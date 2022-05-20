package com.example.backend.service;

import org.springframework.core.io.ByteArrayResource;
import org.springframework.web.multipart.MultipartFile;

import java.util.Optional;

public interface FileService {

    String FILE_PATH = "";

    String saveFile(MultipartFile file, String fileName);

    Optional<ByteArrayResource> getFile(String fileName);
}
