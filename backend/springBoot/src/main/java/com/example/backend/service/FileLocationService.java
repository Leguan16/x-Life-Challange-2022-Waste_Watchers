package com.example.backend.service;

import org.springframework.core.io.ByteArrayResource;
import org.springframework.web.multipart.MultipartFile;

import java.util.Optional;

public interface FileLocationService<T> {

    T save(T entity, MultipartFile file);

    Optional<ByteArrayResource> get(T entity);

}
