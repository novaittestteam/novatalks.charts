-- inbox_interval Recreate

-- Creating new partioned Table
CREATE TABLE inbox_interval_partioned (LIKE inbox_interval INCLUDING IDENTITY) PARTITION BY RANGE (created_at);
--ALTER SEQUENCE public.inbox_interval_id_seq OWNED BY public.inbox_interval_partioned.id;

-- Add Permissions

ALTER TABLE inbox_interval_partioned OWNER TO "ntk-dev-novait-novatalks-svc";
GRANT ALL ON TABLE inbox_interval_partioned TO "ntk-dev-novait-novatalks-svc";

-- Drop all contraints and indexes on root table

ALTER TABLE ONLY public.inbox_interval DROP CONSTRAINT inbox_interval_inbox_id_fkey;
ALTER TABLE ONLY public.inbox_interval DROP CONSTRAINT inbox_interval_account_id_fkey;
DROP INDEX IF EXISTS public.index_inbox_interval_on_inbox_id;
DROP INDEX IF EXISTS public.index_inbox_interval_on_date_time;
ALTER TABLE ONLY public.inbox_interval DROP CONSTRAINT inbox_interval_pkey;
ALTER TABLE public.inbox_interval ALTER COLUMN id DROP DEFAULT;

-- Rename tables

ALTER TABLE public.inbox_interval RENAME TO inbox_interval_old;
ALTER TABLE public.inbox_interval_partioned RENAME TO inbox_interval;
CREATE TABLE public.inbox_interval_default PARTITION OF inbox_interval DEFAULT; -- < Creating a DEFAULT partition
ALTER SEQUENCE public.inbox_interval_id_seq OWNED BY public.inbox_interval.id;
GRANT ALL ON TABLE public.inbox_interval_default TO "ntk-dev-novait-novatalks-svc";


-- Add same contraints(remove ONLY statement) and indexes like in root table


ALTER TABLE ONLY public.inbox_interval ALTER COLUMN id SET DEFAULT nextval('public.inbox_interval_id_seq'::regclass);
ALTER TABLE ONLY public.inbox_interval ADD CONSTRAINT inbox_interval_pkey PRIMARY KEY (id, created_at);
ALTER TABLE public.inbox_interval ADD CONSTRAINT inbox_interval_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id);
ALTER TABLE public.inbox_interval ADD CONSTRAINT inbox_interval_inbox_id_fkey FOREIGN KEY (inbox_id) REFERENCES public.inboxes(id);
CREATE INDEX index_inbox_interval_on_date_time ON public.inbox_interval USING btree (date_time);
CREATE INDEX index_inbox_interval_on_inbox_id ON public.inbox_interval USING btree (inbox_id);