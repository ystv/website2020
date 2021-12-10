-- Creating event schema, all event calendar related tables are stored here
CREATE SCHEMA event;
-- We will initiate the tables in the following order:
-- 1. event.events REFERENCES people.users
-- 2. event.signup_sheets REFERENCES event.events
-- 3. event.position_groups REFERENCES people.users
-- 4. event.positions REFERENCES people.permissions
-- 5. event.crew REFERENCES event.signup_sheets, event.positions, people.users
-- 6. event.attendees REFERENCES event.events, people.users
-- 7. event.projects
--
-- Table creations
--
-- event.events is a single event available on the calendar, contains signup sheets
CREATE TABLE event.events (
    event_id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    event_type text NOT NULL DEFAULT 'other',
    name text NOT NULL,
    start_date timestamptz NOT NULL,
    end_date timestamptz NOT NULL,
    description text NOT NULL DEFAULT '',
    location text NOT NULL DEFAULT '',
    is_private boolean NOT NULL DEFAULT false,
    is_cancelled boolean NOT NULL DEFAULT false,
    is_tentative boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT NOW(),
    created_by int REFERENCES people.users(user_id),
    updated_at timestamptz,
    updated_by int REFERENCES people.users(user_id),
    deleted_at timestamptz,
    deleted_by int REFERENCES people.users(user_id),
    CONSTRAINT namechk CHECK (char_length(name) <= 100),
    CONSTRAINT typechk CHECK (event_type IN ('show', 'meeting', 'social', 'other')),
    CONSTRAINT locationchk CHECK (char_length(location) <= 100)
);
COMMENT ON COLUMN event.events.event_type IS 'Can be show, meeting, social, other';
--
-- event.signup_sheets is a signup sheet for an event, contains the positions and who is signed up
CREATE TABLE event.signup_sheets (
    signup_id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    event_id int REFERENCES event.events(event_id) ON DELETE CASCADE,
    title text NOT NULL,
    description text NOT NULL DEFAULT '',
    unlock_date timestamptz,
    arrival_time timestamptz,
    start_time timestamptz,
    end_time timestamptz,
    CONSTRAINT titlechk CHECK (char_length(title) <= 50)
);
--
-- event.position_groups represents the organisational group a position is part of
CREATE TABLE event.position_groups (
    group_id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name text NOT NULL,
    description text NOT NULL,
    primary_colour text NOT NULL,
    leader int REFERENCES people.users(user_id) ON UPDATE CASCADE ON DELETE SET NULL
);
COMMENT ON TABLE event.position_groups IS
'represents the organisational group a position is part of';
COMMENT ON COLUMN event.position_groups.primary_colour IS
'A hex colour code that is used for styling components';
COMMENT ON COLUMN event.position_groups.leader IS
'The point of contact to go about training and expertise regarding
the positions that are part of the group';
--
-- event.positions is each position that is available for a signup sheet i.e. cam-op
CREATE TABLE event.positions (
    position_id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    group_id int NOT NULL REFERENCES event.position_groups(group_id) ON UPDATE CASCADE,
    permission_id int REFERENCES people.permissions(permission_id),
    name text NOT NULL,
    admin boolean NOT NULL DEFAULT false,
    brief_description text NOT NULL DEFAULT '',
    full_description text NOT NULL,
    image text NOT NULL,
    training_url text NOT NULL,
    CONSTRAINT namechk CHECK (char_length(name) <= 40)
);
COMMENT ON COLUMN event.positions.admin IS
'Whoever has this permission will have admin privileges over the event';
COMMENT ON COLUMN event.positions.page_description IS
'This goes into a lot more detail in comparision to the brief discription
and would be displayed on it''s own dedicated page';
COMMENT ON COLUMN event.positions.training_url IS
'Will be a URL to its wiki page / training video but displayed as a button to the user';
--
-- event.crew is the individual position on the signup sheet with the user.BIGINT
-- Whilst this is many to many we have an ID here since a signup can have multiple
-- of the same position
CREATE TABLE event.crews (
    crew_id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    signup_id int REFERENCES event.signup_sheets(signup_id) ON UPDATE CASCADE ON DELETE CASCADE,
    position_id int REFERENCES event.positions(position_id) ON UPDATE CASCADE ON DELETE CASCADE,
    user_id int REFERENCES people.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE,
    credited boolean NOT NULL DEFAULT TRUE,
    locked bool NOT NULL DEFAULT false,
    ordering int NOT NULL
);
--
-- event.attendees maps the many to many relationship for socials / meetings
CREATE TABLE event.attendees (
    event_id int REFERENCES event.events(event_id) ON UPDATE CASCADE ON DELETE CASCADE,
    user_id int REFERENCES people.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE,
    attend_status text NOT NULL,
    CONSTRAINT attendees_pkey PRIMARY KEY (event_id, user_id)
);
--
-- event.projects allows events to be grouped up under one entity, useful for multi-day events
-- we might be able to just have tags on events instead?
CREATE TABLE event.projects (
    project_id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name text NOT NULL,
    description text NOT NULL,
    status text NOT NULL,
    start_date timestamptz NOT NULL,
    end_date timestamptz NOT NULL
);
