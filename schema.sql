-- +goose Up
-- +goose StatementBegin
CREATE SCHEMA internal;
CREATE TABLE internal.calendar ();
-- Creating video schema, all video related tables stored here
CREATE SCHEMA video;
-- We will initate the tables in the following order,
-- in order to ensure that the foreign keys get setup:
-- 1. video.series
-- 2. video.presets
-- 3. video.encode_formats
-- 4. video.presets_encode_formats
-- 5. video.items
-- 6. video.playlists
-- 7. video.playlist_items
-- 8. video.files
-- Then migrate the data in the same order.
-- (We won't need to migrate playlists due to it being new)
--
-- video.series table represents a group of videos, recursive and a video belongs to one series only
--
CREATE TABLE video.series (
    series_id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    series_left int NOT NULL,
    series_right int NOT NULL,
    name text,
    url text NOT NULL,
    description text,
    thumbnail text,
    tags text [],
    status text,
    series_position smallint,
    created_at timestamptz NOT NULL DEFAULT NOW(),
    created_by int,
    updated_at timestamptz,
    updated_by int,
    deleted_at timestamptz,
    deleted_by int
);
-- The files each have an encode_format that is used to convert the
-- source file using the encode_format params to create the file.
-- A video item can have a preset selected which will generate
-- A group of encode_formats for a video, this saves time since
-- we can specify once that we need these specific qualities and
-- all videos will follow that rule.
CREATE TABLE video.presets (
    id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name text NOT NULL,
    description text
);
CREATE TABLE video.encode_formats (
    id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name text NOT NULL,
    description text,
    mime_type text NOT NULL,
    width int NOT NULL,
    height int NOT NULL,
    arguments text NOT NULL,
    watermarked bool NOT NULL
);
CREATE TABLE video.presets_encode_formats (
    preset_id int REFERENCES video.presets(id) ON UPDATE CASCADE ON DELETE CASCADE,
    encode_format_id int REFERENCES video.encode_formats(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT presets_encode_formats_pkey PRIMARY KEY (preset_id, encode_format_id)
);
--
-- video.items table stores every video
--
-- Name if null should fallback to use the URL.
-- Series position indicates its position in relation to
-- it's siblings.
CREATE TABLE video.items (
    video_id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    series_id int NOT NULL REFERENCES video.series(series_id),
    name text NOT NULL,
    url text,
    description text,
    thumbnail text,
    duration interval,
    views int NOT NULL DEFAULT 0,
    genre int NOT NULL DEFAULT 0,
    tags text [],
    series_position smallint,
    status text NOT NULL DEFAULT 'internal',
    preset int REFERENCES video.presets(id),
    broadcast_date timestamptz NOT NULL,
    created_at timestamptz NOT NULL DEFAULT NOW(),
    created_by int DEFAULT 0,
    updated_at timestamptz,
    updated_by int,
    deleted_at timestamptz,
    deleted_by int
);
--
-- video.playlists essentially youtube playlists
--
CREATE TABLE video.playlists (
    id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name text NOT NULL,
    description text,
    thumbnail text,
    status text NOT NULL DEFAULT 'internal',
    created_at timestamptz NOT NULL,
    created_by int NOT NULL,
    updated_at timestamptz,
    updated_by int,
    deleted_at timestamptz,
    deleted_by int
);
-- We need to map that many to many relationship
CREATE TABLE video.playlist_items (
    playlist_id int REFERENCES video.playlists(id) ON UPDATE CASCADE ON DELETE CASCADE,
    video_item_id int REFERENCES video.items(video_id) ON UPDATE CASCADE ON DELETE CASCADE,
    position smallint,
    CONSTRAINT playlists_items_pkey PRIMARY KEY (playlist_id, video_item_id)
);
CREATE TABLE video.files (
    file_id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    video_id int NOT NULL REFERENCES video.items(video_id),
    uri text NOT NULL,
    status text,
    encode_format int NOT NULL REFERENCES video.encode_formats(id),
    size bigint
);
COMMENT ON TABLE video.files IS 'Supporting video files for a video item';
COMMENT ON COLUMN video.files.status IS 'Indicates status of the file i.e. public, internal, error';
COMMENT ON COLUMN video.files.size IS 'Measured in kilobytes (KB)';
-- Migrations
-- Migration from public.video_boxes to video.series
INSERT INTO video.series (
        series_id,
        series_left,
        series_right,
        url,
        name,
        description,
        thumbnail,
        status
    )
SELECT id,
    left_value,
    right_value,
    url_name,
    display_name,
    description,
    image,
    CASE
        WHEN is_public THEN 'public'
        ELSE 'internal'
    END
FROM public.video_boxes;
-- Migration from public.videos to video.items
INSERT INTO video.items (
        video_id,
        series_id,
        name,
        url,
        description,
        duration,
        tags,
        series_position,
        status,
        broadcast_date,
        created_at,
        created_by
    )
SELECT id,
    video_box_id,
    display_name,
    url_name,
    description,
    duration,
    regexp_split_to_array(keywords, ' '),
    ordering,
    CASE
        WHEN is_enabled THEN 'public'
        ELSE 'internal'
    END,
    created_date,
    created_date,
    created_by
FROM public.videos;
-- Migration from public.video_file_types to video.encode_formats
INSERT INTO video.encode_formats (
        name,
        description,
        mime_type,
        width,
        height,
        arguments,
        watermarked
    )
SELECT name,
    description,
    media_type,
    width,
    height,
    'legacy',
    CASE
        WHEN "mode"::text LIKE '%download%' THEN TRUE
        ELSE FALSE
    END
FROM public.video_file_types;
-- Migration from public.video_files to video.files
INSERT INTO video.files (
        file_id,
        video_id,
        uri,
        status,
        encode_format,
        size
    )
SELECT vf.id,
    vf.video_id,
    CONCAT('legacy/', vf.filename),
    CASE
        WHEN vf.is_enabled THEN 'public'
        ELSE 'internal'
    END,
    en.id,
    size
FROM public.video_files vf
    LEFT JOIN video.encode_formats en ON vf.video_file_type_name = en.name;
-- Migration public.video_boxes to video.series for nested set to adjacency list
-- UPDATE video.series
-- SET parent_series_id = ;
-- Creating our people schema which will store personal data and whatnot
-- so we'll be trying to keep things in there and clamp down on access.
CREATE SCHEMA people;
CREATE TABLE people.users (
    user_id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    username text NOT NULL,
    name text NOT NULL,
    nickname text NOT NULL,
    password text NOT NULL
);
CREATE TABLE people.groups (
    group_id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name text NOT NULL
) -- +goose StatementEnd
-- +goose Down
-- +goose StatementBegin
DROP SCHEMA video CASCADE;
DROP SCHEMA people CASCADE;
-- +goose StatementEnd