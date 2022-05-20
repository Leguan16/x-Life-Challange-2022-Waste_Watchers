package com.example.backend.payload.request;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Data
@AllArgsConstructor
@NoArgsConstructor
public class TrashCanLocationRequest {

    private double longitude;
    private double latitude;
    private int radius;
}
