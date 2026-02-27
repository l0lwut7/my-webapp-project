package com.example.todo;

import java.util.Objects;

/**
 * Represents a task in the task management application.
 */
public class Task {
    private int id;
    private String title;
    private boolean completed;

    /**
     * Default no-argument constructor.
     */
    public Task() {
    }

    /**
     * Constructs a Task with the given id, title, and completion status.
     *
     * @param id        the task identifier
     * @param title     the task title
     * @param completed whether the task is completed
     */
    public Task(int id, String title, boolean completed) {
        this.id = id;
        this.title = title;
        this.completed = completed;
    }

    /**
     * Constructs a Task with the given title and completion status.
     *
     * @param title     the task title
     * @param completed whether the task is completed
     */
    public Task(String title, boolean completed) {
        this.title = title;
        this.completed = completed;
    }

    /**
     * Returns the task identifier.
     *
     * @return the task id
     */
    public int getId() {
        return id;
    }

    /**
     * Sets the task identifier.
     *
     * @param id the task id
     */
    public void setId(int id) {
        this.id = id;
    }

    /**
     * Returns the task title.
     *
     * @return the task title
     */
    public String getTitle() {
        return title;
    }

    /**
     * Sets the task title.
     *
     * @param title the task title
     */
    public void setTitle(String title) {
        this.title = title;
    }

    /**
     * Returns whether the task is completed.
     *
     * @return true if the task is completed
     */
    public boolean isCompleted() {
        return completed;
    }

    /**
     * Sets the completion status of the task.
     *
     * @param completed the completion status
     */
    public void setCompleted(boolean completed) {
        this.completed = completed;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || getClass() != obj.getClass()) {
            return false;
        }
        Task task = (Task) obj;
        return id == task.id
                && completed == task.completed
                && Objects.equals(title, task.title);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, title, completed);
    }

    @Override
    public String toString() {
        return "Task{"
                + "id=" + id
                + ", title='" + title + '\''
                + ", completed=" + completed
                + '}';
    }
}
