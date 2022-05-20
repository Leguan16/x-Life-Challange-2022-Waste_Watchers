package com.example.backend.service;

import com.example.backend.domain.Image;
import com.example.backend.persistence.ImageRepository;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.Optional;

@Service
public class ImageFileLocationService implements FileLocationService<Image> {

    private final ImageRepository imageRepository;

    private final FileService fileService;

    public ImageFileLocationService(ImageRepository imageRepository, FileService fileService) {
        this.imageRepository = imageRepository;
        this.fileService = fileService;
    }


    @Override
    public Image save(Image entity, MultipartFile file) {
        var saved = imageRepository.save(entity);
        var path = fileService.saveFile(file, String.valueOf(saved.getId()));
        saved.setPath(path);
        return imageRepository.save(saved);
    }

    @Override
    public Optional<ByteArrayResource> get(Image entity) {
        var inDatabase = imageRepository.findById(entity.getId());
        if (inDatabase.isEmpty()) {
            return Optional.empty();
        }
        return fileService.getFile(inDatabase.get().getPath());
    }
}
