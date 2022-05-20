package com.example.backend.domain;

import lombok.*;

import javax.persistence.*;
import java.util.List;
import java.util.Objects;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter

@Entity
@Table(name = "trashcan")
public class TrashCan {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "trashcan_generator")
    private Long id;

    @Column(nullable = false)
    private boolean confirmed;

    @NonNull
    @OneToOne(cascade = CascadeType.PERSIST)
    private Image image;

    @ManyToMany(cascade = CascadeType.PERSIST)
    private List<Category> categories;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        TrashCan trashCan = (TrashCan) o;
        return Objects.equals(id, trashCan.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}
