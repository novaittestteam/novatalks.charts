INSERT INTO public.pg_party_config
(schema_name, master_table, part_col, part_type, date_plan, future_part_count)
VALUES('public', 'messages', 'created_at', 'd', 'month', 6);
INSERT INTO public.pg_party_config
(schema_name, master_table, part_col, part_type, date_plan, future_part_count)
VALUES('public', 'conversations', 'created_at', 'd', 'month', 6);
INSERT INTO public.pg_party_config
(schema_name, master_table, part_col, part_type, date_plan, future_part_count)
VALUES('public', 'dialogs', 'created_at', 'd', 'month', 6);
INSERT INTO public.pg_party_config
(schema_name, master_table, part_col, part_type, date_plan, future_part_count)
VALUES('public', 'reporting_events', 'created_at', 'd', 'month', 6);
INSERT INTO public.pg_party_config
(schema_name, master_table, part_col, part_type, date_plan, future_part_count)
VALUES('public', 'team_dialogs', 'created_at', 'd', 'month', 6);
INSERT INTO public.pg_party_config
(schema_name, master_table, part_col, part_type, date_plan, future_part_count)
VALUES('public', 'user_dialogs', 'created_at', 'd', 'month', 6);
INSERT INTO public.pg_party_config
(schema_name, master_table, part_col, part_type, date_plan, future_part_count)
VALUES('public', 'inbox_interval', 'created_at', 'd', 'month', 6);
INSERT INTO public.pg_party_config
(schema_name, master_table, part_col, part_type, date_plan, future_part_count)
VALUES('public', 'team_interval', 'created_at', 'd', 'month', 6);
INSERT INTO public.pg_party_config
(schema_name, master_table, part_col, part_type, date_plan, future_part_count)
VALUES('public', 'user_csat_interval', 'created_at', 'd', 'month', 6);
INSERT INTO public.pg_party_config
(schema_name, master_table, part_col, part_type, date_plan, future_part_count)
VALUES('public', 'user_interval', 'created_at', 'd', 'month', 6);
INSERT INTO public.pg_party_config
(schema_name, master_table, part_col, part_type, date_plan, future_part_count)
VALUES('public', 'user_team_interval', 'created_at', 'd', 'month', 6);