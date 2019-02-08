package kcl.group.api.backendservice.exception;

/**
 * <p>
 * This class handles Exceptions thrown by the File API.
 * <p>
 *
 * @author : KCL Benediction Group
 **/

public class ResouceFileNotFoundException extends Exception {

    public ResouceFileNotFoundException(String exception){
        super(exception);
    }

    public ResouceFileNotFoundException(String exception, Throwable throwable) {
        super(exception, throwable);
    }
}
