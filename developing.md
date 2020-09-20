# Developing

If your application is running locally and your wanting to access the web-api you'll need the permission cookie which is only available on the ystv.co.uk domain, so I'd recommend modify your `/etc/hosts` and just make `local.ystv.co.uk` go back to localhost, your browser will still think your on the ystv.co.uk domain but you'll be able to use the auth provided by web-auth to authenticate with web-api and be able to utilise it in your application.
