-- +goose Up
-- +goose StatementBegin
CREATE SCHEMA video;
CREATE TYPE video.other_sites AS (
    platform text NOT NULL,
    ID text NOT NULL,
    status text NOT NULL
);
CREATE TABLE video.items (
    ID serial PRIMARY KEY,
    name varchar(50) NOT NULL,
    description text,
    thumbnail text,
    duration interval,
    views int NOT NULL DEFAULT 0,
    genre int NOT NULL DEFAULT 0,
    tags text [],
    series int,
    series_position int,
    edit_permission int [] NOT NULL DEFAULT 0,
    read_permission int [] NOT NULL DEFAULT 0,
    platforms video.other_sites [],
    broadcast_date timestamptz NOT NULL,
    created_at timestamptz NOT NULL,
    created_by int NOT NULL,
    updated_at [] timestamptz,
    updated_by [] int,
    deleted_at timestamptz,
    deleted_by int
);
CREATE TABLE video.files (
    ID serial PRIMARY KEY,
    video_id int NOT NULL REFERENCES video.items(ID) uri text NOT NULL,
    status text NOT NUL DEFAULT "Null",
    preset int NOT NULL REFERENCES video.presets(ID)
);
CREATE TABLE video.playlists (
    ID serial PRIMARY KEY,
    name varchar(50) NOT NULL,
    description text,
    thumbnail text,
    videos int [],
    edit_permission int [] NOT NULL DEFAULT 0,
    read_permission int [] NOT NULL DEFAULT 0,
    created_at timestamptz NOT NULL,
    created_by int NOT NULL,
    updated_at timestamptz [],
    updated_by int [],
    deleted_at timestamptz,
    deleted_by int
);
CREATE TABLE video.series (
    ID serial PRIMARY KEY,
    name varchar(50) NOT NULL,
    description text,
    thumbnail text,
    edit_permission int [] NOT NULL DEFAULT 0,
    read_permission int [] NOT NULL DEFAULT 0,
    sorted bool NOT NULL DEFAULT false
);
CREATE TABLE video.presets (
    ID serial PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description text,
);
CREATE TABLE video.encode_formats (
    ID serial PRIMARY KEY,
    description text,
    arguements text NOT NULL,
    watermarked bool NOT NULL
);
CREATE TABLE video.presets_encode_formats (
    preset_id int REFERENCES video.preset(ID) ON UPDATE CASCADE ON DELETE CASCADE,
    encode_format_id REFERENCES video.encode_formats(ID) ON UPDATE CASCADE,
    CONSTRAINT video.presets_encode_formats_pkey PRIMARY KEY (preset_id encode_format_id)
);
-- +goose StatementEnd
-- +goose Down
-- +goose StatementBegin
CREATE TYPE public.video_mode AS ENUM (
    'watch',
    'watch-webM',
    'download',
    'HQdownload',
    'HDdownload',
    'schedule',
    'none',
    'thumbs'
);
ALTER TYPE public.video_mode OWNER TO ystvweb;
CREATE TABLE public.video_boxes (
    id integer NOT NULL,
    left_value smallint NOT NULL,
    right_value smallint NOT NULL,
    url_name character varying(50) NOT NULL,
    display_name character varying(100),
    use_in_url boolean DEFAULT true NOT NULL,
    description text,
    image character varying(50),
    is_enabled boolean DEFAULT true NOT NULL,
    is_public boolean DEFAULT true NOT NULL,
    ordering_type public.box_ordering NOT NULL,
    is_production boolean DEFAULT false NOT NULL,
    name character varying(50),
    ordering_type_boxes public.box_ordering NOT NULL,
    is_visible_in_latest_videos boolean DEFAULT true NOT NULL
);
ALTER TABLE public.video_boxes OWNER TO ystvweb;
CREATE TABLE public.video_file_types (
    name character varying(30) NOT NULL,
    extension character varying(5) NOT NULL,
    width smallint NOT NULL,
    height smallint NOT NULL,
    icon_image character varying(50),
    media_type character varying(30) NOT NULL,
    mode public.video_mode NOT NULL,
    description text,
    ordering smallint NOT NULL,
    vft_dest_type character varying(255),
    CONSTRAINT video_file_types_mode_key UNIQUE (mode, ordering),
    CONSTRAINT video_file_types_pkey PRIMARY KEY (name),
    CONSTRAINT video_file_types_ordering_check CHECK ((ordering > 0))
);
ALTER TABLE public.video_file_types OWNER TO ystvweb;
CREATE TABLE public.video_files (
    video_id integer NOT NULL,
    video_file_type_name character varying(30) NOT NULL,
    filename character varying(100) NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    comments text,
    id integer NOT NULL,
    size bigint
);
ALTER TABLE public.video_files OWNER TO ystvweb;
CREATE TABLE public.videos (
    id integer NOT NULL,
    video_box_id integer NOT NULL,
    display_name character varying(50),
    url_name character varying(50) NOT NULL,
    description text,
    ordering smallint,
    duration interval,
    created_date timestamp with time zone NOT NULL,
    created_by integer,
    is_enabled boolean DEFAULT false NOT NULL,
    search_index_data tsvector,
    keywords text,
    redirect_id integer,
    CONSTRAINT videos_ordering_check CHECK ((ordering > 0))
);
ALTER TABLE public.videos OWNER TO ystvweb;
ALTER TABLE ONLY public.video_boxes
ADD CONSTRAINT video_boxes_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.video_files
ADD CONSTRAINT video_files_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.videos
ADD CONSTRAINT videos_pkey PRIMARY KEY (id);
-- +goose StatementEnd