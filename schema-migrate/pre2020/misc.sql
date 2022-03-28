-- Migrate public.quotes to misc.quotes
INSERT INTO misc.quotes (
        quote_id,
        quote,
        description,
        created_at,
        created_by
    )
SELECT id,
    quote,
    COALESCE(description, ''),
    posted_date,
    posted_by
FROM public.quotes;
--
-- Migrate public.term_dates to misc.terms
INSERT INTO misc.terms (
    year,
    term,
    start,
    finish
)
SELECT year,
    term,
    start_date,
    start_date + interval '10 week'
FROM public.term_dates;
--
-- Migrate public.permalinks to misc.redirects
INSERT INTO misc.redirects(
    redirect_id, source_url, destination_url
)
SELECT id,
    permalink,
    real_url
FROM public.permalinks;
