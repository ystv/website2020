# Searching

I plan on handling searching by outsourcing it to Elasticsearch due to better performance and usability.

In order to create this connection we'll need this nifty tool called `zombodb` which allows Postgres and Elasticsearch to connect to each other.

To setup this functionality we'll use this schema:

```
ALTER TABLE video.items
ALTER COLUMN description TYPE zdb.fulltext;
CREATE INDEX idxitems ON video.items USING zombodb ((video.items.*)) WITH (url = 'URL');

```

With the URL being the Elasticsearch instance

Then to search we would use:

```
SELECT *
FROM video.items
WHERE items == > 'search_variable';
```

with search variable being whatever the person throws at it.

## Todo

We'll need to do more researching into zombodb to ensure that we are feeding it enough search data to improve it's performance.  
Also, we'll need to see if it is smart enough to find the data using foreign keys since the series table does have some extra data for it to chew on.
