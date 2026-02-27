package com.example.todo;

import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

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
        List<Task> tasks = dao.findAll();
        String json = gson.toJson(tasks);
        resp.getWriter().write(json);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        Task received = gson.fromJson(new InputStreamReader(req.getInputStream()), Task.class);
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
            if (ok) resp.setStatus(HttpServletResponse.SC_NO_CONTENT);
            else resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
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

        Task received = gson.fromJson(new InputStreamReader(req.getInputStream()), Task.class);
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
