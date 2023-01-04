-- Migration public.members to people.users
INSERT INTO people.users (
        user_id,
        username,
        university_username,
        email,
        first_name,
        last_name,
        nickname,
        login_type,
        password,
        salt,
        avatar,
        last_login,
        reset_pw,
        created_at,
        created_by,
        updated_at,
        updated_by
    )
SELECT id,
    COALESCE(
        username,
        server_name,
        email_address,
        LOWER(
            CONCAT(first_name, '.', last_name, '.', id::text)
        )
    ),
    COALESCE(username, ''),
    CASE
        WHEN (COALESCE(email_address, '') = '') THEN CONCAT('noreply+', id::text, '@ystv.co.uk')
        ELSE email_address
    END AS email_address,
    first_name,
    last_name,
    first_name,
    'internal',
    COALESCE(newpw, ''),
    salt,
    COALESCE(photo_file, ''),
    last_logged_in,
    force_pw_reset,
    created_date,
    created_by,
    last_edited_date,
    last_edited_by
FROM public.members;
--
-- Migration public.member_groups to people.roles
INSERT INTO people.roles (name, description)
SELECT name,
    description
FROM public.member_groups;
--
-- Migration public.member_group_members to people.role_members
INSERT INTO people.role_members (user_id, role_id)
SELECT gm.member_id,
    roles.role_id
FROM public.member_group_members gm
    LEFT JOIN people.roles roles ON member_group_name = roles.name;
--
-- Migration public.permissions to people.permissions
INSERT INTO people.permissions (name, description)
SELECT name,
    description
FROM public.permissions;
--
-- Migration public.member_group_permissions to people.role_permissions
INSERT INTO people.role_permissions (role_id, permission_id)
SELECT roles.role_id,
    perm.permission_id
FROM public.member_group_permissions oldgrp
    LEFT JOIN people.roles roles ON oldgrp.member_group_name = roles.name
    LEFT JOIN people.permissions perm ON oldgrp.permission_name = perm.name;
--
-- Migration from public.officerships to people.officerships
INSERT INTO people.officerships(name, description, email_alias, is_current)
SELECT name,
    COALESCE(description, ''),
    email_alias,
    is_current
FROM public.officerships;
-- we don't do if_unfilled since we need the data source to exist first
-- so not gonna faff with it.
-- Also not faffing with migrating the officership permissions, can be made manually.
--
-- Migration from public.member_officerships to people.officership_members
INSERT INTO people.officership_members(officership_member_id, user_id, officer_id, start_date, end_date)
SELECT id,
    member_id,
    officer_id,
    start_date,
    end_date
FROM public.member_officerships
INNER JOIN people.officerships ON officership_name = name;
--
-- Migration from public.officerships to people.officership_teams
INSERT INTO people.officership_teams(name)
-- TODO(https://ystv.atlassian.net/browse/WEB-122): the 2020 schema doesn't have an is_current flag for teams, so we exclude historic teams for now
SELECT DISTINCT team FROM public.officerships WHERE team IS NOT NULL AND is_current;
--
-- Migration from public.officerships to people.officership_team_members
INSERT INTO people.officership_team_members(team_id, officer_id, is_leader, is_deputy)
SELECT team_id, officer_id, is_team_leader, is_team_deputy
FROM public.officerships old_off
INNER JOIN people.officerships new_off ON old_off.name = new_off.name
INNER JOIN people.officership_teams team ON old_off.team = team.name; 
