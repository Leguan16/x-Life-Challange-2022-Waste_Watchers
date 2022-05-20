package com.example.backend.controller;

import com.example.backend.domain.Image;
import com.example.backend.domain.TrashCan;
import com.example.backend.persistence.TrashCanRepository;
import com.example.backend.service.FileLocationService;
import lombok.SneakyThrows;
import org.apache.http.client.methods.RequestBuilder;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.impl.client.HttpClients;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.Collections;
import java.util.List;

@RestController
@RequestMapping("/trashcans")
public class TrashCanController {

    private final TrashCanRepository trashCanRepository;

    private final FileLocationService<Image> fileLocationService;



    public TrashCanController(TrashCanRepository trashCanRepository, FileLocationService<Image> fileLocationService) {
        this.trashCanRepository = trashCanRepository;
        this.fileLocationService = fileLocationService;
    }

    @GetMapping()
    public List<TrashCan> all() {
        return trashCanRepository.findAll();
    }

    @GetMapping("/{id}")
    public TrashCan one(@PathVariable long id) {
        return trashCanRepository.findById(id).orElseThrow();
    }

    @GetMapping("/trashcansByLocation")
    public List<TrashCan> allByLocation(@RequestParam double longitude, @RequestParam double latitude, @RequestParam int radius) {
        System.out.println(longitude + " " + latitude + " " + radius);
        return trashCanRepository.findAllTrashcansWithinRadius(latitude, longitude, radius);
    }

    @SneakyThrows
    @PostMapping(consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    public ResponseEntity<String> uploadImage(@RequestParam double longitude, @RequestParam double latitude, @RequestParam String email, @RequestPart("image") MultipartFile image) {
        var domainImage = new Image(null, null, longitude, latitude, email);
        var scan = new TrashCan(null, false, domainImage, Collections.emptyList());

        Image image1 = fileLocationService.save(domainImage, image);

        trashCanRepository.save(scan);

        return ResponseEntity.ok("{\"path\": \"" + image1.getPath() + "\"}");
    }
}
