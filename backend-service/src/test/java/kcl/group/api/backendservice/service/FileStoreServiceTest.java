package kcl.group.api.backendservice.service;

import kcl.group.api.backendservice.config.FileLocationConfig;
import kcl.group.api.backendservice.exception.FileException;
import kcl.group.api.backendservice.exception.ResouceFileNotFoundException;
import kcl.group.api.backendservice.service.impl.FileStoreServiceImpl;
import org.assertj.core.api.Assertions;
import org.junit.*;
import org.junit.rules.TemporaryFolder;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.junit4.SpringRunner;

import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Random;

import static org.assertj.core.api.Assertions.*;
import static org.junit.Assert.*;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.when;

@RunWith(SpringRunner.class)
@SpringBootTest
public class FileStoreServiceTest {

    @Rule
    public TemporaryFolder temporaryFolder = new TemporaryFolder();
    private FileStoreService fileStoreService;
    private FileLocationConfig fileLocationConfig = new FileLocationConfig();
    private String filename;

    @Before
    public void setUp() throws FileException {
        fileLocationConfig.setUploadDirectory(temporaryFolder.toString()+"/test-files/");
        try {
            fileStoreService = new FileStoreServiceImpl(fileLocationConfig);
        } catch (FileException e) {
            e.printStackTrace();
        }
        filename = fileStoreService.saveFile(new MockMultipartFile("test", "test.txt", MediaType.TEXT_PLAIN_VALUE,
                "This is testing the service save method!".getBytes()));
    }

    @Test
    public void saveFile() throws FileException {

        assertThat(filename).isEqualToIgnoringCase("test.txt");
    }

    @Test(expected = FileException.class)
    public void shouldReturnFileExceptionCanNotSaveFile() throws Exception {
        when(this.fileStoreService.saveFile(new MockMultipartFile("EmptyFile","testFile.txt"
                ,MediaType.TEXT_PLAIN_VALUE, "".getBytes())))
                .thenReturn(null);
        fileStoreService.saveFile(new MockMultipartFile("EmptyFile","testFile.txt"
                ,MediaType.TEXT_PLAIN_VALUE, "".getBytes()));
    }

    @Test
    public void downloadFile() throws ResouceFileNotFoundException {
        Resource testReturnFile = fileStoreService.downloadFileAsResource("test.txt");
        assertThat(testReturnFile.getFilename()).isEqualToIgnoringCase("test.txt");
    }

    @Test(expected = ResouceFileNotFoundException.class)
    public void shouldReturnExceptionWhenNoFile() throws Exception {
        when(this.fileStoreService.downloadFileAsResource("NoTest.txt"))
                .thenReturn(null);
        fileStoreService.downloadFileAsResource("NoTest.txt");
     }

}