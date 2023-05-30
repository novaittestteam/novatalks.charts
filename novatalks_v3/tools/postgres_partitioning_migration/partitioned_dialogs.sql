-- dialogs Recreate

-- Creating new partioned Table
CREATE TABLE dialogs_partioned (LIKE dialogs INCLUDING IDENTITY) PARTITION BY RANGE (created_at);
-- Don't have a sequence

-- Add Permissions

ALTER TABLE dialogs_partioned OWNER TO "ntk-dev-novait-novatalks-svc";
GRANT ALL ON TABLE dialogs_partioned TO "ntk-dev-novait-novatalks-svc";

-- Drop all contraints and indexes on root table

ALTER TABLE ONLY public.dialogs DROP CONSTRAINT dialogs_team_id_fkey;
ALTER TABLE ONLY public.dialogs DROP CONSTRAINT dialogs_inbox_id_fkey;
ALTER TABLE ONLY public.dialogs DROP CONSTRAINT dialogs_contact_id_fkey;
ALTER TABLE ONLY public.dialogs DROP CONSTRAINT dialogs_assignee_id_fkey;
ALTER TABLE ONLY public.dialogs DROP CONSTRAINT dialogs_account_id_fkey;;
DROP INDEX IF EXISTS public.index_dialogs_on_updated_at;
DROP INDEX IF EXISTS public.index_dialogs_on_team_id;
DROP INDEX IF EXISTS public.index_dialogs_on_status;
DROP INDEX IF EXISTS public.index_dialogs_on_inbox_id;
DROP INDEX IF EXISTS public.index_dialogs_on_conversation_id;
DROP INDEX IF EXISTS public.index_dialogs_on_assignee_id;
DROP INDEX IF EXISTS public.index_dialogs_on_account_id;
ALTER TABLE ONLY public.dialogs DROP CONSTRAINT dialogs_pkey;
ALTER TABLE public.dialogs ALTER COLUMN id DROP DEFAULT;

-- Rename tables
ALTER TABLE public.dialogs RENAME TO dialogs_old;
ALTER TABLE public.dialogs_partioned RENAME TO dialogs;
CREATE TABLE public.dialogs_default PARTITION OF dialogs DEFAULT; -- < Creating a DEFAULT partition
GRANT ALL ON TABLE public.dialogs_default TO "ntk-dev-novait-novatalks-svc";

-- Add same contraints(remove ONLY statement) and indexes like in root table

ALTER TABLE ONLY public.dialogs ADD CONSTRAINT dialogs_pkey PRIMARY KEY (id, created_at);
ALTER TABLE public.dialogs ADD CONSTRAINT dialogs_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;
ALTER TABLE public.dialogs ADD CONSTRAINT dialogs_assignee_id_fkey FOREIGN KEY (assignee_id) REFERENCES public.users(id) ON DELETE SET NULL;
ALTER TABLE public.dialogs ADD CONSTRAINT dialogs_contact_id_fkey FOREIGN KEY (contact_id) REFERENCES public.contacts(id) ON DELETE CASCADE;
ALTER TABLE public.dialogs ADD CONSTRAINT dialogs_inbox_id_fkey FOREIGN KEY (inbox_id) REFERENCES public.inboxes(id) ON DELETE CASCADE;
ALTER TABLE public.dialogs ADD CONSTRAINT dialogs_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE SET NULL;
CREATE INDEX index_dialogs_on_account_id ON public.dialogs USING btree (account_id);
CREATE INDEX index_dialogs_on_assignee_id ON public.dialogs USING btree (assignee_id);
CREATE INDEX index_dialogs_on_conversation_id ON public.dialogs USING btree (conversation_id);
CREATE INDEX index_dialogs_on_inbox_id ON public.dialogs USING btree (inbox_id);
CREATE INDEX index_dialogs_on_status ON public.dialogs USING btree (status);
CREATE INDEX index_dialogs_on_team_id ON public.dialogs USING btree (team_id);
CREATE INDEX index_dialogs_on_updated_at ON public.dialogs USING btree (updated_at);