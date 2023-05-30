-- You can't modify DEFAULT constraints in DEFAULT partion, so we insert after all doings https://github.com/pgpartman/pg_partman/issues/247
-- 1. converastions
INSERT INTO conversations SELECT * FROM conversations_old;
-- All is done and we can drop old table
DROP TABLE conversations_old;

-- 2. messages
INSERT INTO messages SELECT * FROM messages_old;
-- All is done and we can drop old table
DROP TABLE messages_old;

-- 3. dialogs
INSERT INTO dialogs SELECT * FROM dialogs_old;
-- All is done and we can drop old table
DROP TABLE dialogs_old;

-- 4. reporting_events
INSERT INTO reporting_events SELECT * FROM reporting_events_old;
-- All is done and we can drop old table
DROP TABLE reporting_events_old;

-- 5. team_dialogs
INSERT INTO team_dialogs SELECT * FROM team_dialogs_old;
-- All is done and we can drop old table
DROP TABLE team_dialogs_old;

-- 6. user_dialogs
INSERT INTO user_dialogs SELECT * FROM user_dialogs_old;
-- All is done and we can drop old table
DROP TABLE user_dialogs_old;

-- 7. inbox_interval
INSERT INTO inbox_interval SELECT * FROM inbox_interval_old;
-- All is done and we can drop old table
DROP TABLE inbox_interval_old;

-- 8. team_interval
INSERT INTO team_interval SELECT * FROM team_interval_old;
-- All is done and we can drop old table
DROP TABLE team_interval_old;

-- 9. user_csat_interval
INSERT INTO user_csat_interval SELECT * FROM user_csat_interval_old;
-- All is done and we can drop old table
DROP TABLE user_csat_interval_old;

-- 10. user_interval
INSERT INTO user_interval SELECT * FROM user_interval_old;
-- All is done and we can drop old table
DROP TABLE user_interval_old;

-- 11. user_team_interval
INSERT INTO user_team_interval SELECT * FROM user_team_interval_old;
-- All is done and we can drop old table
DROP TABLE user_team_interval_old;