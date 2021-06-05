package jk.ease.common.task.model.exception;

public class StorageException extends RuntimeException {

	private static final long serialVersionUID = -1288682616461239068L;

	public StorageException(String message) {
		super(message);
	}

	public StorageException(String message, Throwable cause) {
		super(message, cause);
	}
}