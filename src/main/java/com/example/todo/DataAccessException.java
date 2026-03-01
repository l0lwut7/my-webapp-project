package com.example.todo;

/** Custom unchecked exception for data access failures in the DAO layer. */
public class DataAccessException extends RuntimeException {
  private static final long serialVersionUID = 1L;

  /**
   * Constructs a new DataAccessException with the specified detail message and cause.
   *
   * @param message the detail message
   * @param cause the underlying cause
   */
  public DataAccessException(String message, Throwable cause) {
    super(message, cause);
  }
}
