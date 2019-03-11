package kcl.group.api.backendservice.controller;

import kcl.group.api.backendservice.service.FileStoreService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.stream.Collector;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.BDDMockito.given;
import static org.mockito.BDDMockito.then;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.multipart;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@RunWith(SpringRunner.class)
@AutoConfigureMockMvc
@SpringBootTest
public class FileControllerTest {

    @MockBean
    private FileStoreService fileStoreService;
    @Autowired
    private MockMvc mockMvc;

    @Test
    public void shouldSaveUploadedFile() throws Exception {
        MockMultipartFile multipartFile = new MockMultipartFile("file", "testFile.txt",
                "text/plain", "This is a test for the upload function!".getBytes());
        MvcResult result = this.mockMvc.perform(multipart("/upload").file(multipartFile))
                .andExpect(status().isOk())
                .andReturn();
        then(this.fileStoreService).should().saveFile(multipartFile);

        assertThat(result.getResponse().getContentAsString()).containsIgnoringCase("\"fileSize\":"+multipartFile.getSize());
    }
    @Test
    public void shouldDownloadFile() throws Exception {
        Resource resource = new ClassPathResource("downloadTestFile.txt");
        given(this.fileStoreService.downloadFileAsResource(resource.getFilename())).willReturn(resource);
        MvcResult result = this.mockMvc.perform(get("/download/downloadTestFile.txt"))
                .andExpect(status().isOk())
                .andReturn();

        assertThat(result.getResponse().getHeader(HttpHeaders.CONTENT_DISPOSITION)).containsIgnoringCase(resource.getFilename());

    }

    @Test
    public void shouldListAllFiles() throws Exception {
        Resource resource = new ClassPathResource("downloadTestFile.txt");
        Stream<Path> stream = Stream.of(Paths.get("downloadTestFile.txt"));

        given(this.fileStoreService.listAllFiles()).willReturn(stream);
        MvcResult result = this.mockMvc.perform(get("/listAllFiles"))
                .andExpect(status().isOk())
                .andReturn();

        assertThat(result.getResponse().getContentAsString()).containsIgnoringCase("http://localhost/download/downloadTestFile.txt");
    }
}