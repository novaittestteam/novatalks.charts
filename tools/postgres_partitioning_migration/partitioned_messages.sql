-- Messages Recreate

-- Creating new partioned Table
CREATE TABLE messages_partioned (LIKE messages INCLUDING IDENTITY) PARTITION BY RANGE (created_at);
-- ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages_partioned.id;

-- Add Permissions

ALTER TABLE messages_partioned OWNER TO "ntk-dev-novait-novatalks-svc";
GRANT ALL ON TABLE messages_partioned TO "ntk-dev-novait-novatalks-svc";

-- Drop all contraints and indexes on root table

ALTER TABLE ONLY public.messages DROP CONSTRAINT messages_inbox_id_fkey;
ALTER TABLE ONLY public.messages DROP CONSTRAINT messages_account_id_fkey;
DROP INDEX IF EXISTS public.index_messages_on_source_id;
DROP INDEX IF EXISTS public.index_messages_on_sender_type_and_sender_id;
DROP INDEX IF EXISTS public.index_messages_on_sender_type;
DROP INDEX IF EXISTS public.index_messages_on_message_type_at;
DROP INDEX IF EXISTS public.index_messages_on_inbox_id;
DROP INDEX IF EXISTS public.index_messages_on_dialog_id;
DROP INDEX IF EXISTS public.index_messages_on_created_at;
DROP INDEX IF EXISTS public.index_messages_on_conversation_id;
DROP INDEX IF EXISTS public.index_messages_on_account_id;
ALTER TABLE ONLY public.messages DROP CONSTRAINT messages_pkey;
ALTER TABLE public.messages ALTER COLUMN id DROP DEFAULT;

-- Rename tables 

ALTER TABLE public.messages RENAME TO messages_old;
ALTER TABLE public.messages_partioned RENAME TO messages;
CREATE TABLE public.messages_default PARTITION OF messages DEFAULT; -- < Creating a DEFAULT partition
ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;
GRANT ALL ON TABLE public.messages_default TO "ntk-dev-novait-novatalks-svc";

-- Add same ontraints and indexes like in root table


ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);
ALTER TABLE ONLY public.messages ADD CONSTRAINT messages_pkey PRIMARY KEY (id, created_at);

ALTER TABLE public.messages ADD CONSTRAINT messages_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;
ALTER TABLE public.messages ADD CONSTRAINT messages_inbox_id_fkey FOREIGN KEY (inbox_id) REFERENCES public.inboxes(id) ON DELETE CASCADE;
CREATE INDEX index_messages_on_account_id ON public.messages USING btree (account_id);
CREATE INDEX index_messages_on_conversation_id ON public.messages USING btree (conversation_id);
CREATE INDEX index_messages_on_created_at ON public.messages USING btree (created_at);
CREATE INDEX index_messages_on_dialog_id ON public.messages USING btree (dialog_id);
CREATE INDEX index_messages_on_inbox_id ON public.messages USING btree (inbox_id);
CREATE INDEX index_messages_on_message_type_at ON public.messages USING btree (message_type);
CREATE INDEX index_messages_on_sender_type ON public.messages USING btree (sender_type);
CREATE INDEX index_messages_on_sender_type_and_sender_id ON public.messages USING btree (sender_type, sender_id);
CREATE INDEX index_messages_on_source_id ON public.messages USING btree (source_id);