-- Find and delete inconsistent data
-- Conversations
delete from conversations_old where id in (
select co.id 
from 
  conversations_old co 
  left join
  contacts c on co.contact_id = c.id
  left join
  accounts a on co.account_id = a.id
  left join
  users u on co.assignee_id  = u.id
  left join
  campaigns c2 on co.campaign_id = c2.id
  left join
  contact_inboxes ci  on co.contact_inbox_id = ci.id
  left join
  inboxes i on co.inbox_id  = i.id
  left join
  teams t on co.team_id  = t.id 
where c.id is null or a.id is null or u.id is null or c2.id is null or ci.id is null or i.id is null or t.id is null);

-- Delete month by month (example)
WITH selection AS (
  DELETE FROM conversations_old
  WHERE created_at  < '2022-08-01'
  RETURNING *
)
INSERT INTO conversations 
  SELECT * FROM selection;


-- Messages
delete from messages_old where id in (
select mo.id
from
  messages_old mo 
  left join
  accounts a on mo.account_id = a.id
  left join
  inboxes i on mo.inbox_id  = i.id
where a.id is null or i.id is null);

-- Delete month by month (example)
WITH selection AS (
  DELETE FROM messages_old
  WHERE created_at  < '2022-08-01'
  RETURNING *
)
INSERT INTO messages 
  SELECT * FROM selection;

-- Dialogs

delete from dialogs_old where id in (
select d.id 
from 
  dialogs_old d
  left join
  contacts c on d.contact_id = c.id
  left join
  accounts a on d.account_id = a.id
  left join
  users u on d.assignee_id  = u.id
  left join
  inboxes i on d.inbox_id  = i.id
  left join
  teams t on d.team_id  = t.id 
where c.id is null or a.id is null or u.id is null or i.id is null or t.id is null);

-- Delete month by month (example)

 WITH selection AS (
  DELETE FROM dialogs_old
  WHERE created_at  < '2022-08-01' 
  RETURNING *
)
INSERT INTO dialogs 
  SELECT * FROM selection;
