
-- https://stackoverflow.com/questions/62444225/custom-result-handling-by-calling-store-procedure-in-spring-data-jpa
create or replace function find_within_area(
    in inputLat float8,
    in inputLon float8,
    in inputRadius float8
)
returns setof trashcan
as
$$
begin

    -- http://edwilliams.org/avform147.htm
    -- https://stackoverflow.com/questions/45611141/how-to-add-an-offset-value-to-a-geographical-coordinate
    return query select trashcan.id, confirmed, image_id
    from trashcan
    inner join image i on trashcan.image_id = i.id
    where distance(inputLat, inputLon, i.latitude, i.longitude) < inputRadius;
end;
$$
    language plpgsql;

-- https://www.movable-type.co.uk/scripts/latlong.html
-- https://stackoverflow.com/questions/389211/geospatial-coordinates-and-distance-in-kilometers
create or replace function distance(
    in lat1 float8,
    in lon1 float8,
    in lat2 float8,
    in lon2 float8
) returns float8
as
$$
declare
    theta        float8 := lon1 - lon2;
    declare dist float8 := sin(radians(lat1)) * sin(radians(lat2)) +
                           cos(radians(lat1)) * cos(radians(lat2)) * cos(radians(theta));
begin
    dist := acos(dist);
    dist := degrees(dist);
    return dist * 60 * 1.1515 * 1.609344;
end;
$$
    language plpgsql;




SELECT *
FROM trashcan
         inner join image on trashcan.image_id = image.id
where distance(48, 15, image.latitude, image.longitude) < (22222000 / 1000)
