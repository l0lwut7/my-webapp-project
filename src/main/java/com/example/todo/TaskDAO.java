package com.example.todo;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/** Data Access Object for managing {@link Task} persistence in an SQLite database. */
public class TaskDAO {
  private static final String DB_URL = "jdbc:sqlite:todo.db";

  static {
    try {
      Class.forName("org.sqlite.JDBC");
    } catch (ClassNotFoundException e) {
      throw new DataAccessException("SQLite JDBC driver not found", e);
    }
  }

  /** Constructs a new TaskDAO and initialises the database schema. */
  public TaskDAO() {
    init();
  }

  private void init() {
    String sql =
        "CREATE TABLE IF NOT EXISTS tasks ("
            + "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            + "title TEXT NOT NULL, "
            + "completed INTEGER NOT NULL"
            + ")";
    try (Connection conn = getConnection();
        Statement stmt = conn.createStatement()) {
      stmt.execute(sql);
    } catch (SQLException e) {
      throw new DataAccessException("Failed to initialize database", e);
    }
  }

  private Connection getConnection() throws SQLException {
    return DriverManager.getConnection(DB_URL);
  }

  /**
   * Returns all tasks ordered by id descending.
   *
   * @return list of all tasks
   */
  public List<Task> findAll() {
    String sql = "SELECT id, title, completed FROM tasks ORDER BY id DESC";
    List<Task> list = new ArrayList<>();
    try (Connection conn = getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery()) {
      while (rs.next()) {
        Task t = new Task(rs.getInt("id"), rs.getString("title"), rs.getInt("completed") != 0);
        list.add(t);
      }
    } catch (SQLException e) {
      throw new DataAccessException("Failed to retrieve tasks", e);
    }
    return list;
  }

  /**
   * Creates a new task and sets its generated id.
   *
   * @param task the task to create
   * @return the created task with its generated id
   */
  public Task create(Task task) {
    String sql = "INSERT INTO tasks(title, completed) VALUES(?, ?)";
    try (Connection conn = getConnection();
        PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
      ps.setString(1, task.getTitle());
      ps.setInt(2, task.isCompleted() ? 1 : 0);
      int affected = ps.executeUpdate();
      if (affected == 0) {
        throw new SQLException("Creating task failed, no rows affected.");
      }
      try (ResultSet keys = ps.getGeneratedKeys()) {
        if (keys.next()) {
          task.setId(keys.getInt(1));
        }
      }
      return task;
    } catch (SQLException e) {
      throw new DataAccessException("Failed to create task", e);
    }
  }

  /**
   * Deletes a task by its id.
   *
   * @param id the task id to delete
   * @return true if a row was deleted, false otherwise
   */
  public boolean delete(int id) {
    String sql = "DELETE FROM tasks WHERE id = ?";
    try (Connection conn = getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setInt(1, id);
      int affected = ps.executeUpdate();
      return affected > 0;
    } catch (SQLException e) {
      throw new DataAccessException("Failed to delete task with id " + id, e);
    }
  }

  /**
   * Finds a task by its id.
   *
   * @param id the task id to find
   * @return the task if found, or null
   */
  public Task findById(int id) {
    String sql = "SELECT id, title, completed FROM tasks WHERE id = ?";
    try (Connection conn = getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setInt(1, id);
      try (ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
          return new Task(rs.getInt("id"), rs.getString("title"), rs.getInt("completed") != 0);
        }
      }
    } catch (SQLException e) {
      throw new DataAccessException("Failed to find task with id " + id, e);
    }
    return null;
  }

  /**
   * Updates an existing task.
   *
   * @param task the task with updated values
   * @return true if a row was updated, false otherwise
   */
  public boolean update(Task task) {
    String sql = "UPDATE tasks SET title = ?, completed = ? WHERE id = ?";
    try (Connection conn = getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setString(1, task.getTitle());
      ps.setInt(2, task.isCompleted() ? 1 : 0);
      ps.setInt(3, task.getId());
      int affected = ps.executeUpdate();
      return affected > 0;
    } catch (SQLException e) {
      throw new DataAccessException("Failed to update task with id " + task.getId(), e);
    }
  }
}
