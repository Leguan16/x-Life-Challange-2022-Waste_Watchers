BEGIN;
create table image
(
    id        bigint not null
        primary key,
    email     varchar(255),
    latitude  double precision,
    longitude double precision,
    path      varchar(255)
);
create table trashcan
(
    id        bigint  not null
        primary key,
    confirmed boolean not null,
    image_id  bigint
        constraint fkqyee504mg221p17vjgrqpc48c
            references image
);
create or replace function find_within_area(
        in inputLat float8,
        in inputLon float8,
        in inputRadius float8
    )
    returns setof trashcan
    as
$$
begin
return query select trashcan.id, confirmed, image_id
        from trashcan
        inner join image i on trashcan.image_id = i.id
        where distance(inputLat, inputLon, i.latitude, i.longitude) < inputRadius;
end;
$$
        language plpgsql;
    create or replace function distance(
        in lat1 float8,
        in lon1 float8,
        in lat2 float8,
        in lon2 float8
    ) returns float8
    as
$$
    declare theta float8 := lon1 - lon2;
        declare dist float8 := sin(radians(lat1)) * sin(radians(lat2)) +
                               cos(radians(lat1)) * cos(radians(lat2)) * cos(radians(theta));
begin
        dist := acos(dist);
        dist := degrees(dist);
return dist * 60 * 1.1515 * 1.609344;
end;
$$
        language plpgsql;
COMMIT;