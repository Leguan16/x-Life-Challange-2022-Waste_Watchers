package com.example.backend.persistence;

import com.example.backend.domain.TrashCan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.jdbc.datasource.DataSourceUtils;
import org.springframework.stereotype.Repository;

import javax.persistence.NamedNativeQuery;
import java.util.List;

@Repository
public interface TrashCanRepository extends JpaRepository<TrashCan, Long> {

    /**
     * Finds all trash cans that are in the given area.
     *
     * @param latitude  The latitude of the area.
     * @param longitude The longitude of the area.
     * @param radius    The radius of the area in meters.
     * @return
     */
    @Query(value = "select * from find_within_area(?1, ?2, ?3)", nativeQuery = true)
    List<TrashCan> findAllTrashcansWithinRadius(Double latitude, Double longitude, Integer radius);

}
