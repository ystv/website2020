DO $$

DECLARE keycard_role_id int;
DECLARE keycard_permission_id int;

BEGIN
--
-- Add keycard access permission
INSERT INTO people.permissions (
    name,
    description
)
VALUES (
    'Access.Keycard.Station',
    'People who have keycard access to the station'
)
RETURNING permission_id INTO keycard_permission_id;
--
-- Add keycard access role
INSERT INTO people.roles (
    name,
    description
)
VALUES (
    'Station access',
    'People who have explicit keycard access to the station'
)
RETURNING role_id INTO keycard_role_id;
--
-- Adding the keycard permission to the keycard role
INSERT INTO people.role_permissions (
    role_id,
    permission_id
)
VALUES (
    keycard_role_id,
    keycard_permission_id
);
--
-- Migration from public.members to people.role_members
INSERT INTO people.role_members (
    user_id,
    role_id
)
SELECT (
    id,
    keycard_role_id
)
FROM public.members
WHERE on_key_list;

END $$;