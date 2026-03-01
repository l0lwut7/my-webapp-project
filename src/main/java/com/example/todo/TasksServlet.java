package com.example.todo;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/** Servlet that exposes a REST-style API for managing {@link Task} resources. */
@WebServlet("/api/tasks/*")
public class TasksServlet extends HttpServlet {
  private static final long serialVersionUID = 1L;
  private static final String PARAM_TITLE = "title";
  private static final String PARAM_COMPLETED = "completed";
  private static final String JSON_CONTENT_TYPE = "application/json;charset=UTF-8";
  private static final String WRITE_ERROR_MSG = "Failed to write response";
  private static final Logger LOGGER = Logger.getLogger(TasksServlet.class.getName());

  private transient TaskDAO dao;
  private final transient Gson gson = new Gson();

  @Override
  public void init() throws ServletException {
    super.init();
    dao = new TaskDAO();
  }

  /**
   * Handles GET requests — returns all tasks as JSON.
   *
   * @param req the HTTP request
   * @param resp the HTTP response
   * @throws ServletException if a servlet error occurs
   */
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException {
    resp.setContentType(JSON_CONTENT_TYPE);
    resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    resp.setHeader("Pragma", "no-cache");
    resp.setDateHeader("Expires", 0);
    List<Task> tasks = dao.findAll();
    String json = gson.toJson(tasks);
    writeJsonSafe(resp, json);
  }

  /**
   * Handles POST requests — creates a new task.
   *
   * @param req the HTTP request
   * @param resp the HTTP response
   * @throws ServletException if a servlet error occurs
   */
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException {
    resp.setContentType(JSON_CONTENT_TYPE);
    Task received;
    try {
      received = parseTaskFromRequest(req);
    } catch (IOException e) {
      LOGGER.log(Level.WARNING, "Failed to parse request body", e);
      resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
      return;
    }

    if (isMissingTitle(received)) {
      sendBadRequestSafe(resp, "title is required");
      return;
    }

    Task created = dao.create(new Task(received.getTitle().trim(), received.isCompleted()));
    resp.setStatus(HttpServletResponse.SC_CREATED);
    writeJsonSafe(resp, gson.toJson(created));
  }

  /**
   * Handles DELETE requests — deletes a task by id.
   *
   * @param req the HTTP request
   * @param resp the HTTP response
   * @throws ServletException if a servlet error occurs
   */
  @Override
  protected void doDelete(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException {
    String path = req.getPathInfo();
    if (path == null || path.length() <= 1) {
      resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
      return;
    }
    String idStr = path.substring(1);
    try {
      int id = Integer.parseInt(idStr);
      boolean ok = dao.delete(id);
      if (ok) {
        resp.setStatus(HttpServletResponse.SC_NO_CONTENT);
      } else {
        resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
      }
    } catch (NumberFormatException e) {
      resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
    }
  }

  /**
   * Handles PUT requests — updates an existing task.
   *
   * @param req the HTTP request
   * @param resp the HTTP response
   * @throws ServletException if a servlet error occurs
   */
  @Override
  protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws ServletException {
    String path = req.getPathInfo();
    if (path == null || path.length() <= 1) {
      resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
      return;
    }
    String idStr = path.substring(1);
    int id;
    try {
      id = Integer.parseInt(idStr);
    } catch (NumberFormatException e) {
      resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
      return;
    }

    Task received;
    try {
      received = parseTaskForUpdate(req, id);
    } catch (IOException e) {
      LOGGER.log(Level.WARNING, "Failed to parse request body", e);
      resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
      return;
    }

    if (isMissingTitle(received)) {
      sendBadRequestSafe(resp, "title is required");
      return;
    }

    received.setId(id);
    boolean ok = dao.update(received);
    if (ok) {
      resp.setContentType(JSON_CONTENT_TYPE);
      writeJsonSafe(resp, gson.toJson(received));
      resp.setStatus(HttpServletResponse.SC_OK);
    } else {
      resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
    }
  }

  /**
   * Writes a JSON string to the response. Logs and sets a 500 status on failure.
   *
   * @param resp the HTTP response
   * @param json the JSON string to write
   */
  private void writeJsonSafe(HttpServletResponse resp, String json) {
    try {
      resp.getWriter().write(json);
    } catch (IOException e) {
      LOGGER.log(Level.SEVERE, WRITE_ERROR_MSG, e);
      resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
  }

  /**
   * Sends a 400 Bad Request response with a JSON error body. Logs and sets a 500 status if the
   * write itself fails.
   *
   * @param resp the HTTP response
   * @param message the error message
   */
  private void sendBadRequestSafe(HttpServletResponse resp, String message) {
    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
    JsonObject obj = new JsonObject();
    obj.addProperty("error", message);
    try {
      resp.getWriter().write(gson.toJson(obj));
    } catch (IOException e) {
      LOGGER.log(Level.SEVERE, WRITE_ERROR_MSG, e);
      resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
  }

  /**
   * Parses a {@link Task} from the request body (JSON or form-encoded).
   *
   * @param req the HTTP request
   * @return the parsed task, or null if no data found
   * @throws IOException if an I/O error occurs
   */
  private Task parseTaskFromRequest(HttpServletRequest req) throws IOException {
    String contentType = req.getContentType();
    if (contentType != null && contentType.contains("application/json")) {
      try (InputStreamReader reader = new InputStreamReader(req.getInputStream())) {
        return gson.fromJson(reader, Task.class);
      }
    } else if (contentType != null && contentType.contains("application/x-www-form-urlencoded")) {
      String title = req.getParameter(PARAM_TITLE);
      String completed = req.getParameter(PARAM_COMPLETED);
      boolean isCompleted = "true".equalsIgnoreCase(completed);
      Task task = new Task();
      task.setTitle(title);
      task.setCompleted(isCompleted);
      return task;
    }
    return null;
  }

  /**
   * Parses a {@link Task} for an update operation. Reads from JSON body, form parameters, or
   * query-string fallback.
   *
   * @param req the HTTP request
   * @param id the task id being updated
   * @return the parsed task, or null if not found
   * @throws IOException if an I/O error occurs
   */
  private Task parseTaskForUpdate(HttpServletRequest req, int id) throws IOException {
    String contentType = req.getContentType();
    if (contentType != null && contentType.contains("application/json")) {
      try (InputStreamReader reader = new InputStreamReader(req.getInputStream())) {
        return gson.fromJson(reader, Task.class);
      }
    }

    String[] params = resolveParams(req);
    String title = params[0];
    String completedParam = params[1];

    return buildTaskFromParams(title, completedParam, id);
  }

  /**
   * Resolves title and completed parameters from the request, falling back to manual query-string
   * parsing when standard parameters are empty.
   *
   * @param req the HTTP request
   * @return a two-element array: [title, completed]
   */
  private String[] resolveParams(HttpServletRequest req) {
    String title = req.getParameter(PARAM_TITLE);
    String completedParam = req.getParameter(PARAM_COMPLETED);

    if (isNullOrEmpty(title) && isNullOrEmpty(completedParam)) {
      String qs = req.getQueryString();
      if (qs != null) {
        String[] parsed = parseQueryString(qs);
        if (isNullOrEmpty(title)) {
          title = parsed[0];
        }
        if (isNullOrEmpty(completedParam)) {
          completedParam = parsed[1];
        }
      }
    }
    return new String[] {title, completedParam};
  }

  /**
   * Builds a {@link Task} by merging the provided parameter values with the existing record from
   * the database.
   *
   * @param title the new title (may be null)
   * @param completedParam the new completed value (may be null)
   * @param id the task id
   * @return the merged task, or null if no parameters or no existing record
   */
  private Task buildTaskFromParams(String title, String completedParam, int id) {
    Boolean isCompleted = null;
    if (!isNullOrEmpty(completedParam)) {
      isCompleted = "true".equalsIgnoreCase(completedParam);
    }

    if (title == null && isCompleted == null) {
      return null;
    }

    Task existing = dao.findById(id);
    if (existing == null) {
      return null;
    }

    Task received = new Task(existing.getId(), existing.getTitle(), existing.isCompleted());
    if (title != null) {
      received.setTitle(title);
    }
    if (isCompleted != null) {
      received.setCompleted(isCompleted);
    }
    return received;
  }

  /**
   * Parses the query string to extract title and completed values.
   *
   * @param queryString the raw query string
   * @return a two-element array: [title, completed] (either may be null)
   */
  private String[] parseQueryString(String queryString) {
    String title = null;
    String completedParam = null;
    for (String pair : queryString.split("&")) {
      String[] kv = pair.split("=", 2);
      if (kv.length == 2) {
        String key = URLDecoder.decode(kv[0], StandardCharsets.UTF_8);
        String value = URLDecoder.decode(kv[1], StandardCharsets.UTF_8);
        if (PARAM_TITLE.equals(key) && title == null) {
          title = value;
        }
        if (PARAM_COMPLETED.equals(key) && completedParam == null) {
          completedParam = value;
        }
      }
    }
    return new String[] {title, completedParam};
  }

  /**
   * Checks whether the task is null or has no title.
   *
   * @param task the task to check
   * @return true if the task is null or has a blank title
   */
  private boolean isMissingTitle(Task task) {
    return task == null || task.getTitle() == null || task.getTitle().trim().isEmpty();
  }

  private boolean isNullOrEmpty(String value) {
    return value == null || value.isEmpty();
  }
}
