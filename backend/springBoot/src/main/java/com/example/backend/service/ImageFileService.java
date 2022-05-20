package com.example.backend.service;


import lombok.SneakyThrows;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.nio.file.*;
import java.util.Optional;

@Service
public class ImageFileService implements FileService {

    public static final String IMAGE_PATH = "";

    @SneakyThrows
    @Override
    public String saveFile(MultipartFile file, String fileName) {
        Path uploadPath = Paths.get(FILE_PATH + IMAGE_PATH);

        if (Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);

            try (InputStream inputStream = file.getInputStream()) {
                Path filePath = uploadPath.resolve(fileName + ".png");

                Files.copy(inputStream, filePath);

                return filePath.toString();
            } catch (IOException ioe) {
                throw new IOException("Could not save image file: " + fileName, ioe);
            }
        }

        return fileName;
    }

    @SneakyThrows
    @Override
    public Optional<ByteArrayResource> getFile(String fileName) {
        var file = new File(fileName).getAbsoluteFile();
        if (Files.exists(file.toPath())) {
            return Optional.of(new ByteArrayResource(Files.readAllBytes(file.toPath())));
        }
        return Optional.empty();
    }
}
