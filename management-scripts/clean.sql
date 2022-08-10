\echo 'ystv_website2020 management-scripts clean'

\echo 'Truncating people schema'
TRUNCATE TABLE people.users, people.roles, people.role_members,
people.permissions, people.role_permissions, people.officerships,
people.officership_members, people.officership_teams,
people.officership_team_members CASCADE;

\echo 'Truncating video schema'
TRUNCATE TABLE video.series, video.encode_presets, video.encode_formats,
video.encode_preset_formats, video.items, video.playlists,
video.playlist_items, video.files, video.hits CASCADE;

\echo 'Truncating event schema'
TRUNCATE TABLE event.events, event.signup_sheets, event.position_groups,
event.positions, event.crews, event.attendees, event.projects CASCADE;

\echo 'Truncating misc schema'
TRUNCATE TABLE misc.quotes, misc.webcams, misc.teaching_periods, misc.redirects
CASCADE;

\echo 'Truncating mail schema'
TRUNCATE TABLE mail.lists, mail.subscribers CASCADE;
