# Webcams

We use Shinobi as our security camera server, but it can likely be used by anything which produces an accessible file endpoint (usually an m/jpeg stream or hls manifest). my-tv currently only accepts a jpeg input.

## Adding to database

You will want to make a query similar to the one below to match your structure. The URL is the base URL and file is where it is located in that directory. Reason it is seperate is since it reverse proxies the URL not only the file, so when you are using HLS which has other files stored in the directory you can still acess them through the proxy.

```
INSERT INTO misc.webcams(name, url, file, mime_type)
VALUES
    ('Camera 1', 'https://cool-webcams.com/cameras/cam1/', 's.jpeg', 'image/jpeg'),
    ('Camera 2', 'https://cool-webcams.com/cameras/cam2/', 's.jpeg', 'image/jpeg'),
    ('Camera 3', https://cool-webcams.com/cameras/camhd/', 'main.m3u8', 'application/x-mpegURL');
```
