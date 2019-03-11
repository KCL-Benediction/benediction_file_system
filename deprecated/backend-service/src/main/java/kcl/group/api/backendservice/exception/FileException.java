package kcl.group.api.backendservice.exception;

/**
 * <p>
 * This class handles Exceptions thrown by the File API.
 * <p>
 *
 * @author : KCL Benediction Group
 **/

public class FileException extends Exception {

    public FileException(String exception){
        super(exception);
    }

    public FileException(String exception, Throwable throwable) {
        super(exception, throwable);
    }
}
