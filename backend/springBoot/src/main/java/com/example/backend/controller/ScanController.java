package com.example.backend.controller;

import com.example.backend.domain.Image;
import com.example.backend.domain.Scan;
import com.example.backend.payload.request.ScanRequest;
import com.example.backend.persistence.ScanRepository;
import com.example.backend.service.FileLocationService;
import lombok.SneakyThrows;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.RequestBuilder;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.json.JSONObject;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.io.File;
import java.io.IOException;

@RestController
@RequestMapping("/scan")
public class ScanController {

    private final ScanRepository scanRepository;

    private final FileLocationService<Image> fileLocationService;


    public ScanController(ScanRepository scanRepository, FileLocationService<Image> fileLocationService) {
        this.scanRepository = scanRepository;
        this.fileLocationService = fileLocationService;
    }

    @SneakyThrows
    @PostMapping(consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    public ResponseEntity<String> uploadImage(@RequestParam double longitude, @RequestParam double latitude, @RequestParam String email, @RequestPart("image") MultipartFile image) {
        var domainImage = new Image(null, null, longitude, latitude, email);
        var scan = new Scan(null, null, false, domainImage);

        Image image1 = fileLocationService.save(domainImage, image);
        scanRepository.save(scan);

        new Thread(() -> {

            var client = HttpClients.createDefault();
            var file = new File(image1.getPath());
            var data = MultipartEntityBuilder.create().setMode(HttpMultipartMode.BROWSER_COMPATIBLE)
                    .addBinaryBody("image", file, ContentType.DEFAULT_BINARY, file.getName())
                    .build();
            var request = RequestBuilder.post("http://pythonapi:14344/requestvaluation").setEntity(data).build();
            ResponseHandler<String> responseHandler = response -> {
                int status = response.getStatusLine().getStatusCode();
                if (status >= 200 && status < 300) {
                    var entity = response.getEntity();
                    return entity != null ? EntityUtils.toString(entity) : null;
                }
                return null;
            };
            try {
                String body = client.execute(request, responseHandler);
                var json = new JSONObject(body);
                var message = json.getString("message");
                if(message.matches("(?<=C=)[.\\d]+")) {
                    scan.setProbability(Double.parseDouble(message));
                    scanRepository.save(scan);
                }

            } catch (IOException e) {
                // ignore
            }

        }).start();

        return ResponseEntity.ok("{\"path\": \"" + image1.getPath() + "\"}");
    }

}
