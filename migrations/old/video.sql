--
-- Migrations
--
-- Migration from public.video_boxes to video.series
INSERT INTO video.series (
        series_id,
        lft,
        rgt,
        in_url,
        url,
        name,
        description,
        thumbnail,
        status
    )
SELECT id,
    left_value,
    right_value,
    use_in_url,
    url_name,
    COALESCE(display_name, name, url_name),
    COALESCE(description, ''),
    COALESCE(image, ''),
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
    COALESCE(display_name, url_name),
    url_name,
    COALESCE(description, ''),
    COALESCE(EXTRACT(EPOCH FROM duration)::int, 0),
    COALESCE(regexp_split_to_array(keywords, ' '), array[]::text[]),
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
        mode,
        width,
        height,
        arguments,
        file_suffix,
        watermarked
    )
SELECT name,
    COALESCE(description, ''),
    media_type,
    mode::text,
    width,
    height,
    'legacy',
    '',
    CASE
        WHEN "mode"::text LIKE '%download%' THEN TRUE
        ELSE FALSE
    END
FROM public.video_file_types;
-- Migration from public.video_files to video.files
INSERT INTO video.files (
        file_id,
        video_id,
        format_id,
        uri,
        status,
        size
    )
SELECT vf.id,
    vf.video_id,
    en.format_id,
    CONCAT('legacy/', vf.filename),
    CASE
        WHEN vf.is_enabled THEN 'public'
        ELSE 'internal'
    END,
    COALESCE(size, 0)
FROM public.video_files vf
    LEFT JOIN video.encode_formats en ON vf.video_file_type_name = en.name;
-- Migration from public.video_hits to video.hits
INSERT INTO video.hits (
    hit_id,
    start_time,
    mode,
    ip_address,
    client_info,
    percent,
    video_id
)
SELECT id,
    start_time,
    mode,
    ip_address,
    client_info,
    percent,
    video_id
FROM public.video_hits;
