package com.example.todo;

import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/api/tasks/*")
public class TasksServlet extends HttpServlet {
    private TaskDAO dao;
    private Gson gson = new Gson();

    @Override
    public void init() throws ServletException {
        super.init();
        dao = new TaskDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
        resp.setHeader("Pragma", "no-cache"); // HTTP 1.0
        resp.setDateHeader("Expires", 0); // Proxies
        List<Task> tasks = dao.findAll();
        String json = gson.toJson(tasks);
        resp.getWriter().write(json);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        Task received = null;
        String contentType = req.getContentType();
        if (contentType != null && contentType.contains("application/json")) {
            // parse JSON body
            received = gson.fromJson(new InputStreamReader(req.getInputStream()), Task.class);
        } else if (contentType != null && contentType.contains("application/x-www-form-urlencoded")) {
            // fallback to form parameters
            String title = req.getParameter("title");
            String completed = req.getParameter("completed");
            boolean isCompleted = "true".equalsIgnoreCase(completed);
            received = new Task();
            received.setTitle(title);
            received.setCompleted(isCompleted);
        }
        if (received == null || received.getTitle() == null || received.getTitle().trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            JsonObject obj = new JsonObject();
            obj.addProperty("error", "title is required");
            resp.getWriter().write(gson.toJson(obj));
            return;
        }
        Task created = dao.create(new Task(received.getTitle().trim(), received.isCompleted()));
        resp.setStatus(HttpServletResponse.SC_CREATED);
        resp.getWriter().write(gson.toJson(created));
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo(); // e.g. /{id}
        if (path == null || path.length() <= 1) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        String idStr = path.substring(1);
        try {
            int id = Integer.parseInt(idStr);
            boolean ok = dao.delete(id);
            if (ok)
                resp.setStatus(HttpServletResponse.SC_NO_CONTENT);
            else
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo(); // e.g. /{id}
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

        Task received = null;
        String contentType = req.getContentType();
        if (contentType != null && contentType.contains("application/json")) {
            received = gson.fromJson(new InputStreamReader(req.getInputStream()), Task.class);
        } else {
            // try parameters (either form/ body or query string)
            String title = req.getParameter("title");
            String completedParam = req.getParameter("completed");
            // Tomcat does not populate query parameters for PUT, so fallback manually
            if ((title == null || title.isEmpty()) && (completedParam == null || completedParam.isEmpty())) {
                String qs = req.getQueryString();
                if (qs != null) {
                    for (String pair : qs.split("&")) {
                        String[] kv = pair.split("=", 2);
                        if (kv.length == 2) {
                            String k = java.net.URLDecoder.decode(kv[0], "UTF-8");
                            String v = java.net.URLDecoder.decode(kv[1], "UTF-8");
                            if ("title".equals(k) && (title == null || title.isEmpty())) {
                                title = v;
                            }
                            if ("completed".equals(k) && (completedParam == null || completedParam.isEmpty())) {
                                completedParam = v;
                            }
                        }
                    }
                }
            }
            Boolean isCompleted = null;
            if (completedParam != null && !completedParam.isEmpty()) {
                isCompleted = "true".equalsIgnoreCase(completedParam);
            }
            if (title != null || isCompleted != null) {
                // if any field provided, start with existing record if present
                Task existing = dao.findById(id);
                if (existing != null) {
                    received = new Task(existing.getId(), existing.getTitle(), existing.isCompleted());
                } else {
                    // no record; cannot update
                    resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
                if (title != null) {
                    received.setTitle(title);
                }
                if (isCompleted != null) {
                    received.setCompleted(isCompleted);
                }
            }
        }
        if (received == null || received.getTitle() == null || received.getTitle().trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            JsonObject obj = new JsonObject();
            obj.addProperty("error", "title is required");
            resp.getWriter().write(gson.toJson(obj));
            return;
        }

        received.setId(id);
        boolean ok = dao.update(received);
        if (ok) {
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write(gson.toJson(received));
            resp.setStatus(HttpServletResponse.SC_OK);
        } else {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
