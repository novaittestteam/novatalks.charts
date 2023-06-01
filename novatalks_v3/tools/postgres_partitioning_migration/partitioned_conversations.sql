-- Conversations Recreate

-- Creating new partioned Table
CREATE TABLE conversations_partioned (LIKE conversations INCLUDING IDENTITY) PARTITION BY RANGE (created_at);
-- ALTER SEQUENCE public.conversations_id_seq OWNED BY public.conversations_partioned.id;

-- Add Permissions

ALTER TABLE conversations_partioned OWNER TO "ntk-dev-novait-novatalks-svc";
GRANT ALL ON TABLE conversations_partioned TO "ntk-dev-novait-novatalks-svc";

-- Drop all contraints and indexes on root table

ALTER TABLE ONLY public.conversations DROP CONSTRAINT conversations_team_id_fkey;
ALTER TABLE ONLY public.conversations DROP CONSTRAINT conversations_inbox_id_fkey;
ALTER TABLE ONLY public.conversations DROP CONSTRAINT conversations_contact_inbox_id_fkey;
ALTER TABLE ONLY public.conversations DROP CONSTRAINT conversations_contact_id_fkey;
ALTER TABLE ONLY public.conversations DROP CONSTRAINT conversations_campaign_id_fkey;
ALTER TABLE ONLY public.conversations DROP CONSTRAINT conversations_assignee_id_fkey;
ALTER TABLE ONLY public.conversations DROP CONSTRAINT conversations_account_id_fkey;
DROP INDEX IF EXISTS public.index_conversations_on_team_id;
DROP INDEX IF EXISTS public.index_conversations_on_status_and_account_id_inbox_id;
DROP INDEX IF EXISTS public.index_conversations_on_status;
DROP INDEX IF EXISTS public.index_conversations_on_last_activity_at;
DROP INDEX IF EXISTS public.index_conversations_on_inbox_id;
DROP INDEX IF EXISTS public.index_conversations_on_contact_inbox_id;
DROP INDEX IF EXISTS public.index_conversations_on_campaign_id;
DROP INDEX IF EXISTS public.index_conversations_on_assignee_id_and_account_id_inbox_id;
DROP INDEX IF EXISTS public.index_conversations_on_assignee_id;
DROP INDEX IF EXISTS public.index_conversations_on_additional_attributes_chat_id;
DROP INDEX IF EXISTS public.index_conversations_on_account_id;
ALTER TABLE ONLY public.conversations DROP CONSTRAINT conversations_pkey;
ALTER TABLE public.conversations ALTER COLUMN id DROP DEFAULT;

-- Rename tables

ALTER TABLE public.conversations RENAME TO conversations_old;
ALTER TABLE public.conversations_partioned RENAME TO conversations;
CREATE TABLE public.conversations_default PARTITION OF conversations DEFAULT; -- < Creating a DEFAULT partition
ALTER SEQUENCE public.conversations_id_seq OWNED BY public.conversations.id;
GRANT ALL ON TABLE public.conversations_default TO "ntk-dev-novait-novatalks-svc";

-- Add same contraints(remove ONLY statement) and indexes like in root table


ALTER TABLE public.conversations ALTER COLUMN id SET DEFAULT nextval('public.conversations_id_seq'::regclass);
ALTER TABLE public.conversations ADD CONSTRAINT conversations_pkey PRIMARY KEY (id, created_at);
ALTER TABLE public.conversations ADD CONSTRAINT conversations_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;
ALTER TABLE public.conversations ADD CONSTRAINT conversations_assignee_id_fkey FOREIGN KEY (assignee_id) REFERENCES public.users(id) ON DELETE SET NULL;
ALTER TABLE public.conversations ADD CONSTRAINT conversations_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES public.campaigns(id) ON DELETE SET NULL;
ALTER TABLE public.conversations ADD CONSTRAINT conversations_contact_id_fkey FOREIGN KEY (contact_id) REFERENCES public.contacts(id) ON DELETE CASCADE;
ALTER TABLE public.conversations ADD CONSTRAINT conversations_contact_inbox_id_fkey FOREIGN KEY (contact_inbox_id) REFERENCES public.contact_inboxes(id) ON DELETE SET NULL;
ALTER TABLE public.conversations ADD CONSTRAINT conversations_inbox_id_fkey FOREIGN KEY (inbox_id) REFERENCES public.inboxes(id) ON DELETE CASCADE;
ALTER TABLE public.conversations ADD CONSTRAINT conversations_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE SET NULL;
CREATE INDEX index_conversations_on_account_id ON public.conversations USING btree (account_id);
CREATE INDEX index_conversations_on_additional_attributes_chat_id ON public.conversations USING gin (((additional_attributes -> 'chatId'::text)));
CREATE INDEX index_conversations_on_assignee_id ON public.conversations USING btree (assignee_id);
CREATE INDEX index_conversations_on_assignee_id_and_account_id_inbox_id ON public.conversations USING btree (assignee_id, account_id, inbox_id);
CREATE INDEX index_conversations_on_campaign_id ON public.conversations USING btree (campaign_id);
CREATE INDEX index_conversations_on_contact_inbox_id ON public.conversations USING btree (contact_inbox_id);
CREATE INDEX index_conversations_on_inbox_id ON public.conversations USING btree (inbox_id);
CREATE INDEX index_conversations_on_last_activity_at ON public.conversations USING btree (last_activity_at);
CREATE INDEX index_conversations_on_status ON public.conversations USING btree (status);
CREATE INDEX index_conversations_on_status_and_account_id_inbox_id ON public.conversations USING btree (status, account_id, inbox_id);
CREATE INDEX index_conversations_on_team_id ON public.conversations USING btree (team_id);