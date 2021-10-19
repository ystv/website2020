-- Migrate public.events to event.events
INSERT INTO event.events (
        event_id,
        event_type,
        name,
        start_date,
        end_date,
        description,
        location,
        is_private,
        is_cancelled,
        is_tentative,
        created_at,
        created_by
    )
SELECT id,
    event_type,
    name,
    start_date,
    (start_date::date + end_time::interval),
    COALESCE(description, ''),
    COALESCE(location, ''),
    is_private,
    is_cancelled,
    is_tentative,
    start_date,
    host_member_id
FROM public.events;
--
-- Migrate public.crew_positions to event.positions
-- We don't copy member_group_name since we are trying to move away
-- from permissions by the role/group and by an individual permission.
INSERT INTO event.positions (
        name,
        description,
        admin
    )
SELECT name,
    COALESCE(description, ''),
    has_admin_rights
FROM public.crew_positions;
--
-- Migration public.event_signups to event.signups
INSERT INTO event.signups (
        signup_id,
        event_id,
        title,
        description,
        unlock_date,
        arrival_time,
        start_time,
        end_time
    )
SELECT signup.id,
    event_id,
    signup.name,
    COALESCE(notes, ''),
    unlock_date,
    (start_date::date + arrival_time::interval),
    (start_date::date + start_time::interval),
    (start_date::date + signup.end_time::interval)
FROM public.event_signups signup
    LEFT OUTER JOIN public.events event ON event.id = signup.event_id;
--
-- Migration public.event_attendees to event.attendees
INSERT INTO event.attendees (event_id, user_id, attend_status)
SELECT event_id,
    member_id,
    attend_status::text
FROM public.event_attendees;
--
-- Migration public.event_signup_crew to event.crews
INSERT INTO event.crews (
        crew_id,
        signup_id,
        position_id,
        user_id,
        locked,
        ordering
    )
SELECT sc.id,
    sc.event_signup_id,
    pos.position_id,
    sc.member_id,
    sc.is_locked,
    sc.ordering
FROM public.event_signup_crew sc
    LEFT JOIN event.positions pos ON sc.crew_position_name = pos.name;
