package com.example.backend.domain;

import lombok.*;

import javax.persistence.*;
import java.util.Objects;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter

@Entity
@Table(name = "scan")
public class Scan {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "scan_generator")
    private Long id;

    private Double probability;

    @Column(nullable = false)
    private boolean reported;

    @OneToOne(cascade = CascadeType.PERSIST)
    private Image image;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Scan scan = (Scan) o;
        return Objects.equals(id, scan.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}
