CREATE SCHEMA creator;
CREATE TABLE creator.preferences(
    user_id int NOT NULL REFERENCES people.users(user_id),
    preferences jsonb
);