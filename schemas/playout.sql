-- Creating playout schema, all live tables are stored here
--
--                          NOTE
--
-- The longevity of this schema is dubious since it is liked to
-- be merged into the ystv/playout DB.
--
CREATE SCHEMA playout;
--
-- We will initate the tables in the following order,
-- in order to ensure that the foreign keys get setup:
--
-- 1. playout.channel
--
-- playout.channel represents an Channel that is event-only (not linear)
CREATE TABLE playout.channel (
    channel_id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    url_name text NOT NULL UNIQUE,
    name text NOT NULL,
    description text NOT NULL,
    thumbnail text NOT NULL,
    output_type text NOT NULL,
    output_url text NOT NULL,
    visibility text NOT NULL,
    status text NOT NULL,
    location text NOT NULL,
    scheduled_start timestamptz NOT NULL,
    scheduled_end timestamptz NOT NULL,
    CONSTRAINT name_chk CHECK (char_length(name) <= 30),
    CONSTRAINT output_type_chk CHECK (output_type IN ('hls', 'iframe')),
    CONSTRAINT visibility_chk CHECK (visibility IN ('public', 'internal')),
    CONSTRAINT status_chk CHECK (status IN ('live', 'scheduled', 'cancelled', 'finished')),
    CONSTRAINT time_chk CHECK (scheduled_end > scheduled_start)
);