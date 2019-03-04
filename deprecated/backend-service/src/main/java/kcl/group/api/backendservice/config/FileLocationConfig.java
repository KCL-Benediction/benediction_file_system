package kcl.group.api.backendservice.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

/**
 * <p>
 * This class configures file location directory.
 * <p>
 *
 * @author : KCL Benediction Group
 **/

@Configuration
public class FileLocationConfig {

    @Value(value = "${file.upload.directory}")
    private String uploadDirectory;

    public String getUploadDirectory() {
        return uploadDirectory;
    }

    public void setUploadDirectory(String uploadDirectory) {
        this.uploadDirectory = uploadDirectory;
    }
}
