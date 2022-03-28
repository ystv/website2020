-- Migrate from public.mllists to mail.lists
INSERT INTO mail.lists(
        list_id,
        name,
        description,
        alias
    )
SELECT id,
    mailinglistname,
    "Description",
    left(address, strpos(address, '@') - 1)
FROM public.mllists;
--
-- Migrate from public.mlusersinlists to mail.subscribers
INSERT INTO mail.subscribers(list_id, user_id)
SELECT mailinglistid, userid FROM public.mlusersinlists;
