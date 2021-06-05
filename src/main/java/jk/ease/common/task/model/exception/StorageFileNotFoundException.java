package jk.ease.common.task.model.exception;

public class StorageFileNotFoundException extends StorageException {

	private static final long serialVersionUID = -187045062637737316L;

	public StorageFileNotFoundException(String message) {
		super(message);
	}

	public StorageFileNotFoundException(String message, Throwable cause) {
		super(message, cause);
	}
}