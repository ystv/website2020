CREATE SCHEMA IF NOT EXISTS mail;
--
-- Table creations
--
-- mail.lists stores list information
CREATE TABLE mail.lists(
    list_id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name text NOT NULL,
    description text NOT NULL DEFAULT '',
    alias text NOT NULL,
    permission_id int REFERENCES people.permissions(permission_id),
    CONSTRAINT namechk CHECK (char_length(name) <= 20)
);
COMMENT ON TABLE mail.lists IS
'Mailing lists where you send to the alias and each subscriber receiver a copy';
--
-- mail.subscribers stores users who have subscribed to a mailing list
CREATE TABLE mail.subscribers(
    list_id int NOT NULL REFERENCES mail.lists(list_id),
    user_id int NOT NULL REFERENCES people.users(user_id),
    subscribe_id uuid DEFAULT uuid_generate_v4(),
    CONSTRAINT subscribers_pkey PRIMARY KEY (user_id, subscribe_id)
);
COMMENT ON COLUMN mail.subscribers.subscribe_id IS
'Using extra unique key since it will be used to unsubscribe from mailing lists
where the user doesn''t need to be signed-in';
COMMENT ON TABLE mail.subscribers IS
'Relationship of users subscribing to mailing lists';
