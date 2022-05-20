package com.example.backend.payload.request;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class ScanRequest {

    @NonNull
    private Double longitude;

    @NonNull
    private Double latitude;

    @NonNull
    private String email;

}
