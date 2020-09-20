# View count

Currently we are not recording view hits and are just relying on the old data right now which isn't ideal, but hopefully it will be resolved soon™

Anyways, run this command to generate the viewcount data, this will take its time to run (5 - 10 minutes).

```
update video.items
set views = (select count(*) from public.video_hits
where video.items.video_id = public.video_hits.video_id);
```

Also, this is currently using the old view count table, will update this so it uses the new table as well.
