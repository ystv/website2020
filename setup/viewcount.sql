UPDATE video.items
SET views = (SELECT count(*) FROM public.video_hits
WHERE video.items.video_id = public.video_hits.video_id);