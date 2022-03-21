-- Preparing event.position_groups
-- 
-- In the new version of the schema, position groups are new
-- and every event.position is required to be in-one. So we're
-- creating a catch-all group for the initial migration
INSERT INTO event.position_groups(
    name,
    description,
    primary_colour
) VALUES (
    'Misc',
    'Positions that have don''t fit in anywhere particular or have yet to be sorted.',
    '#fbfbfb'
);