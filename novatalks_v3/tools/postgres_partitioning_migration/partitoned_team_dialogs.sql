-- team_dialogs Recreate

-- Creating new partioned Table
CREATE TABLE team_dialogs_partioned (LIKE team_dialogs INCLUDING IDENTITY) PARTITION BY RANGE (created_at);
-- ALTER SEQUENCE public.team_dialogs_id_seq OWNED BY public.team_dialogs_partioned.id;

-- Add Permissions

ALTER TABLE team_dialogs_partioned OWNER TO "ntk-dev-novait-novatalks-svc";
GRANT ALL ON TABLE team_dialogs_partioned TO "ntk-dev-novait-novatalks-svc";

-- Drop all contraints and indexes on root table

ALTER TABLE ONLY public.team_dialogs DROP CONSTRAINT team_dialogs_team_id_fkey;
ALTER TABLE ONLY public.team_dialogs DROP CONSTRAINT team_dialogs_inbox_id_fkey;
ALTER TABLE ONLY public.team_dialogs DROP CONSTRAINT team_dialogs_contact_id_fkey;
ALTER TABLE ONLY public.team_dialogs DROP CONSTRAINT team_dialogs_account_id_fkey;
DROP INDEX IF EXISTS public.index_team_dialogs_on_team_id;
DROP INDEX IF EXISTS public.index_team_dialogs_on_dialog_id;
DROP INDEX IF EXISTS public.index_team_dialogs_on_created_at;
DROP INDEX IF EXISTS public.index_team_dialogs_on_account_id;
ALTER TABLE ONLY public.team_dialogs DROP CONSTRAINT team_dialogs_pkey;
ALTER TABLE public.team_dialogs ALTER COLUMN id DROP DEFAULT;

-- Rename tables

ALTER TABLE public.team_dialogs RENAME TO team_dialogs_old;
ALTER TABLE public.team_dialogs_partioned RENAME TO team_dialogs;
CREATE TABLE public.team_dialogs_default PARTITION OF team_dialogs DEFAULT; -- < Creating a DEFAULT partition
ALTER SEQUENCE public.team_dialogs_id_seq OWNED BY public.team_dialogs.id;
GRANT ALL ON TABLE public.team_dialogs_default TO "ntk-dev-novait-novatalks-svc";


-- Add same contraints(remove ONLY statement) and indexes like in root table


ALTER TABLE ONLY public.team_dialogs ALTER COLUMN id SET DEFAULT nextval('public.team_dialogs_id_seq'::regclass);
ALTER TABLE ONLY public.team_dialogs ADD CONSTRAINT team_dialogs_pkey PRIMARY KEY (id, created_at);
ALTER TABLE public.team_dialogs ADD CONSTRAINT team_dialogs_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id);
ALTER TABLE public.team_dialogs ADD CONSTRAINT team_dialogs_contact_id_fkey FOREIGN KEY (contact_id) REFERENCES public.contacts(id);
ALTER TABLE public.team_dialogs ADD CONSTRAINT team_dialogs_inbox_id_fkey FOREIGN KEY (inbox_id) REFERENCES public.inboxes(id);
ALTER TABLE public.team_dialogs ADD CONSTRAINT team_dialogs_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE;
CREATE INDEX index_team_dialogs_on_account_id ON public.team_dialogs USING btree (account_id);
CREATE INDEX index_team_dialogs_on_created_at ON public.team_dialogs USING btree (created_at);
CREATE INDEX index_team_dialogs_on_dialog_id ON public.team_dialogs USING btree (dialog_id);
CREATE INDEX index_team_dialogs_on_team_id ON public.team_dialogs USING btree (team_id);