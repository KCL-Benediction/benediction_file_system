package kcl.group.api.backendservice.service.impl;

import kcl.group.api.backendservice.config.FileLocationConfig;
import kcl.group.api.backendservice.exception.FileException;
import kcl.group.api.backendservice.exception.ResouceFileNotFoundException;
import kcl.group.api.backendservice.service.FileStoreService;
import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.util.FileSystemUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.nio.file.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static org.slf4j.LoggerFactory.getLogger;

@Service
public class FileStoreServiceImpl implements FileStoreService {

    private static final Logger logger = getLogger(FileStoreServiceImpl.class);
    private final Path rootDirectory;
    @Autowired
    public FileStoreServiceImpl(FileLocationConfig fileLocationConfig) throws FileException {
        this.rootDirectory = Paths.get(fileLocationConfig.getUploadDirectory());

        try {
            Files.createDirectories(rootDirectory);
        } catch (IOException e) {
            throw new FileException("Could not create directory", e);
        }
    }

    @Override
    public String saveFile(MultipartFile multipartFile) throws FileException {
        if(multipartFile.isEmpty()){
            throw new FileException("Cannot save empty File" + multipartFile.getOriginalFilename());
        }
        String filename = StringUtils.cleanPath(multipartFile.getOriginalFilename());

        if(filename.contains("..")){
            throw new FileException("Cannot save file outside directory!" + multipartFile.getOriginalFilename());
        }

        logger.info("File upload service started.....");
        try {
            Path fileDestination = this.rootDirectory.resolve(filename);
            InputStream inputStream = multipartFile.getInputStream();
            /*if(!new File(this.rootDirectory+"/"+multipartFile.getOriginalFilename()).exists()) {
                logger.info("File already exists: " + multipartFile.getOriginalFilename());
                throw new FileAlreadyExistsException("File already exists: ");
            }*/
                Files.copy(inputStream, fileDestination, StandardCopyOption.REPLACE_EXISTING);
        } catch (IOException e) {
            throw new FileException("Cannot Read File contents", e);
        }
        return filename;

    }

    @Override
    public Resource downloadFileAsResource(String filename) throws ResouceFileNotFoundException {

        try {
            Path path = rootDirectory.resolve(filename);
            Resource resource = new UrlResource(path.toUri());

            if(!resource.exists() || !resource.isReadable()){
                throw new ResouceFileNotFoundException("Cannot access File"+filename);
            }

            return resource;
        } catch (MalformedURLException e) {
            throw new ResouceFileNotFoundException("Cannot find specified File", e);
        }
    }

    @Override
    public Stream<Path> listAllFiles() throws FileException {

        try {
            return Files.walk(this.rootDirectory, 1)
                    .filter(directory -> !directory.equals(this.rootDirectory))
                    .map(this.rootDirectory::relativize);
        } catch (IOException e) {
            throw new FileException("Cannot read uploaded files", e);
        }
    }

    @Override
    public void deleteAllFiles() {
        FileSystemUtils.deleteRecursively(this.rootDirectory.toFile());
    }

    @Override
    public void deleteFile(String filename) throws FileException {

        try {
            Path path = Paths.get(filename);
            Files.delete(path);
        } catch (IOException e) {
            throw new FileException("Unable to delete file", e);
        }
    }
}
