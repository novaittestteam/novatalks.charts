-- team_interval Recreate

-- Creating new partioned Table
CREATE TABLE team_interval_partioned (LIKE team_interval INCLUDING IDENTITY) PARTITION BY RANGE (created_at);
-- ALTER SEQUENCE public.team_interval_id_seq OWNED BY public.team_interval_partioned.id;

-- Add Permissions

ALTER TABLE team_interval_partioned OWNER TO "ntk-dev-novait-novatalks-svc";
GRANT ALL ON TABLE team_interval_partioned TO "ntk-dev-novait-novatalks-svc";

-- Drop all contraints and indexes on root table

ALTER TABLE ONLY public.team_interval DROP CONSTRAINT team_interval_team_id_fkey;
ALTER TABLE ONLY public.team_interval DROP CONSTRAINT team_interval_inbox_id_fkey;
ALTER TABLE ONLY public.team_interval DROP CONSTRAINT team_interval_account_id_fkey;
DROP INDEX IF EXISTS public.index_team_interval_on_team_id;
DROP INDEX IF EXISTS public.index_team_interval_on_date_time;
ALTER TABLE ONLY public.team_interval DROP CONSTRAINT team_interval_pkey;
ALTER TABLE public.team_interval ALTER COLUMN id DROP DEFAULT;

-- Rename tables

ALTER TABLE public.team_interval RENAME TO team_interval_old;
ALTER TABLE public.team_interval_partioned RENAME TO team_interval;
CREATE TABLE public.team_interval_default PARTITION OF team_interval DEFAULT; -- < Creating a DEFAULT partition
ALTER SEQUENCE public.team_interval_id_seq OWNED BY public.team_interval.id;
GRANT ALL ON TABLE public.team_interval_default TO "ntk-dev-novait-novatalks-svc";


-- Add same contraints(remove ONLY statement) and indexes like in root table


ALTER TABLE ONLY public.team_interval ALTER COLUMN id SET DEFAULT nextval('public.team_interval_id_seq'::regclass);
ALTER TABLE ONLY public.team_interval ADD CONSTRAINT team_interval_pkey PRIMARY KEY (id, created_at);
ALTER TABLE public.team_interval ADD CONSTRAINT team_interval_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id);
ALTER TABLE public.team_interval ADD CONSTRAINT team_interval_inbox_id_fkey FOREIGN KEY (inbox_id) REFERENCES public.inboxes(id);
ALTER TABLE public.team_interval ADD CONSTRAINT team_interval_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id);
CREATE INDEX index_team_interval_on_date_time ON public.team_interval USING btree (date_time);
CREATE INDEX index_team_interval_on_team_id ON public.team_interval USING btree (team_id);