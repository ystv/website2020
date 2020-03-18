## Domains
### Public facing
* ystv.co.uk
* sso.ystv.co.uk
#### fun ones
* cal.ystv.co.uk
* evil.ystv.co.uk
### YSTV Member facing
* graphics.ystv.co.uk
* files.ystv.co.uk
* upload.ystv.co.uk
* internal.ystv.co.uk
### Computing Team facing
* dev.ystv.co.uk
* admin.ystv.co.uk
### General API point
api.ystv.co.uk
### Streaming
stream.ystv.co.uk
* Outputs:
	* /live - Records 1080p, watermark added from here
	* /web - Website post transcoders, will transcode `20Mb`, `7Mb`, and `3.5Mb` outputs

* Inputs:
	* /srt
	* /rtc
	* /rtmp

## Deployment
Will use jenkins to live deploy from github to web, master going to `ystv.co.uk` whilst dev branch to `dev.ystv.co.uk`

## Misc
OB unit site just use the OB's own IP
