-- user_dialogs Recreate

-- Creating new partioned Table
CREATE TABLE user_dialogs_partioned (LIKE user_dialogs INCLUDING IDENTITY) PARTITION BY RANGE (created_at);
-- ALTER SEQUENCE public.user_dialogs_id_seq OWNED BY public.user_dialogs_partioned.id;

-- Add Permissions

ALTER TABLE user_dialogs_partioned OWNER TO "ntk-dev-novait-novatalks-svc";
GRANT ALL ON TABLE user_dialogs_partioned TO "ntk-dev-novait-novatalks-svc";

-- Drop all contraints and indexes on root table

ALTER TABLE ONLY public.user_dialogs DROP CONSTRAINT user_dialogs_user_id_fkey;
ALTER TABLE ONLY public.user_dialogs DROP CONSTRAINT user_dialogs_inbox_id_fkey;
ALTER TABLE ONLY public.user_dialogs DROP CONSTRAINT user_dialogs_contact_id_fkey;
ALTER TABLE ONLY public.user_dialogs DROP CONSTRAINT user_dialogs_account_id_fkey;
DROP INDEX IF EXISTS public.index_user_dialogs_on_user_id;
DROP INDEX IF EXISTS public.index_user_dialogs_on_dialog_id;
DROP INDEX IF EXISTS public.index_user_dialogs_on_created_at;
DROP INDEX IF EXISTS public.index_user_dialogs_on_account_id;
ALTER TABLE ONLY public.user_dialogs DROP CONSTRAINT user_dialogs_pkey;
ALTER TABLE public.user_dialogs ALTER COLUMN id DROP DEFAULT;


-- Rename tables

ALTER TABLE public.user_dialogs RENAME TO user_dialogs_old;
ALTER TABLE public.user_dialogs_partioned RENAME TO user_dialogs;
CREATE TABLE public.user_dialogs_default PARTITION OF user_dialogs DEFAULT; -- < Creating a DEFAULT partition
ALTER SEQUENCE public.user_dialogs_id_seq OWNED BY public.user_dialogs.id;
GRANT ALL ON TABLE public.user_dialogs_default TO "ntk-dev-novait-novatalks-svc";


-- Add same contraints(remove ONLY statement) and indexes like in root table


ALTER TABLE ONLY public.user_dialogs ALTER COLUMN id SET DEFAULT nextval('public.user_dialogs_id_seq'::regclass);
ALTER TABLE ONLY public.user_dialogs ADD CONSTRAINT user_dialogs_pkey PRIMARY KEY (id, created_at);
ALTER TABLE public.user_dialogs ADD CONSTRAINT user_dialogs_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id);
ALTER TABLE public.user_dialogs ADD CONSTRAINT user_dialogs_contact_id_fkey FOREIGN KEY (contact_id) REFERENCES public.contacts(id);
ALTER TABLE public.user_dialogs ADD CONSTRAINT user_dialogs_inbox_id_fkey FOREIGN KEY (inbox_id) REFERENCES public.inboxes(id);
ALTER TABLE public.user_dialogs ADD CONSTRAINT user_dialogs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
CREATE INDEX index_user_dialogs_on_account_id ON public.user_dialogs USING btree (account_id);
CREATE INDEX index_user_dialogs_on_created_at ON public.user_dialogs USING btree (created_at);
CREATE INDEX index_user_dialogs_on_dialog_id ON public.user_dialogs USING btree (dialog_id);
CREATE INDEX index_user_dialogs_on_user_id ON public.user_dialogs USING btree (user_id);