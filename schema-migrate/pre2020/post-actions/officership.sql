UPDATE people.officership_teams SET
    name = 'Computing Team',
    email_alias = 'computing',
    short_description = 'System administration, software development, streaming, and more!',
    full_description = 'The Computing Team look after the computers, network and their operation. Get in touch with this team if you are interested in getting involved with anything related to computers, whether it’s development and programming, system administration, networking or anything else related to computers! No past experience is necessary.'
WHERE name = 'computing';

UPDATE people.officership_teams SET
    name = 'Admin Team',
    email_alias = 'admin',
    short_description = 'Looks after YSTV''s records, finances, marketing and more!',
    full_description = 'This team handles the beind the scenes aspect of YSTV. Often a lot of communication involved whether liasing with YUSU, the University, societes, etc or leading the weekly meetings. There is always something on the go so please get involved!'
WHERE name = 'admin';

UPDATE people.officership_teams SET
    name = 'Technical Team',
    email_alias = 'technical',
    short_description = 'Technical operations and maintainence of YSTV equipment',
    full_description = 'To run a TV station it requires a technical team. Working behind the scenes of every production. Such as setting up gear for events both live and pre-recorded.'
WHERE name = 'technical';

UPDATE people.officership_teams SET
    name = 'Production Team',
    email_alias = 'production',
    short_description = 'Making live and pre-recorded content',
    full_description = 'Responsible for "creating and organsing shows". Involving a load of things to do and skills to learn. '
WHERE name = 'production';

UPDATE people.officership_teams SET
    name = 'Marketing Team',
    email_alias = 'marketing',
    short_description = 'Promoting YSTV to campus and the outside world',
    full_description = 'The Marketing Team controls the ''face of YSTV''. We''re an open, friendly team and are always looking for new faces and talents. If you''re interested in marketing, branding, graphic design, photography, organising sponsorship or masterminding an advertising campaign, then don''t hesitate to get in touch!'
WHERE name = 'marketing';
