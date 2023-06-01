-- reporting_events Recreate

-- Creating new partioned Table
CREATE TABLE reporting_events_partioned (LIKE reporting_events INCLUDING IDENTITY) PARTITION BY RANGE (created_at);
-- ALTER SEQUENCE public.reporting_events_id_seq OWNED BY public.reporting_events_partioned.id;

-- Add Permissions

ALTER TABLE reporting_events_partioned OWNER TO "ntk-dev-novait-novatalks-svc";
GRANT ALL ON TABLE reporting_events_partioned TO "ntk-dev-novait-novatalks-svc";

-- Drop all contraints and indexes on root table

ALTER TABLE ONLY public.reporting_events DROP CONSTRAINT reporting_events_user_id_fkey;
ALTER TABLE ONLY public.reporting_events DROP CONSTRAINT reporting_events_team_id_fkey;
DROP INDEX IF EXISTS public.index_reporting_events_on_user_id;
DROP INDEX IF EXISTS public.index_reporting_events_on_name;
DROP INDEX IF EXISTS public.index_reporting_events_on_inbox_id;
DROP INDEX IF EXISTS public.index_reporting_events_on_dialog_id;
DROP INDEX IF EXISTS public.index_reporting_events_on_created_at;
DROP INDEX IF EXISTS public.index_reporting_events_on_account_id;
ALTER TABLE ONLY public.reporting_events DROP CONSTRAINT reporting_events_pkey;
ALTER TABLE public.reporting_events ALTER COLUMN id DROP DEFAULT;

-- Rename tables 

ALTER TABLE public.reporting_events RENAME TO reporting_events_old;
ALTER TABLE public.reporting_events_partioned RENAME TO reporting_events;
CREATE TABLE public.reporting_events_default PARTITION OF reporting_events DEFAULT; -- < Creating a DEFAULT partition
ALTER SEQUENCE public.reporting_events_id_seq OWNED BY public.reporting_events.id;
GRANT ALL ON TABLE public.reporting_events_default TO "ntk-dev-novait-novatalks-svc";

-- Add same contraints(remove ONLY statement) and indexes like in root table


ALTER TABLE ONLY public.reporting_events ALTER COLUMN id SET DEFAULT nextval('public.reporting_events_id_seq'::regclass);
ALTER TABLE ONLY public.reporting_events ADD CONSTRAINT reporting_events_pkey PRIMARY KEY (id, created_at);
ALTER TABLE public.reporting_events ADD CONSTRAINT reporting_events_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE;
ALTER TABLE public.reporting_events ADD CONSTRAINT reporting_events_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;
CREATE INDEX index_reporting_events_on_account_id ON public.reporting_events USING btree (account_id);
CREATE INDEX index_reporting_events_on_created_at ON public.reporting_events USING btree (created_at);
CREATE INDEX index_reporting_events_on_dialog_id ON public.reporting_events USING btree (dialog_id);
CREATE INDEX index_reporting_events_on_inbox_id ON public.reporting_events USING btree (inbox_id);
CREATE INDEX index_reporting_events_on_name ON public.reporting_events USING btree (name);
CREATE INDEX index_reporting_events_on_user_id ON public.reporting_events USING btree (user_id);