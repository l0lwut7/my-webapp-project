package com.example.todo;

import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Simple test driver for {@link TaskDAO} operations.
 */
public class TestDao {
    private static final Logger LOGGER = Logger.getLogger(TestDao.class.getName());

    /**
     * Runs basic DAO operations and logs the results.
     *
     * @param args command-line arguments (unused)
     */
    public static void main(String[] args) {
        TaskDAO dao = new TaskDAO();
        LOGGER.log(Level.INFO, "Initial list:");
        for (Task t : dao.findAll()) {
            LOGGER.log(Level.INFO, "{0}", t);
        }
        Task t1 = dao.create(new Task("Test insert 1", false));
        LOGGER.log(Level.INFO, "Created ID: {0}", t1.getId());

        LOGGER.log(Level.INFO, "List after insert:");
        for (Task t : dao.findAll()) {
            LOGGER.log(Level.INFO, "{0}", t);
        }
    }
}
