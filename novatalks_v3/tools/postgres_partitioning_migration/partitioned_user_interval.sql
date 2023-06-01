-- user_interval Recreate

-- Creating new partioned Table
CREATE TABLE user_interval_partioned (LIKE user_interval INCLUDING IDENTITY) PARTITION BY RANGE (created_at);
-- ALTER SEQUENCE public.user_interval_id_seq OWNED BY public.user_interval_partioned.id;

-- Add Permissions

ALTER TABLE user_interval_partioned OWNER TO "ntk-dev-novait-novatalks-svc";
GRANT ALL ON TABLE user_interval_partioned TO "ntk-dev-novait-novatalks-svc";

-- Drop all contraints and indexes on root table

ALTER TABLE ONLY public.user_interval DROP CONSTRAINT user_interval_user_id_fkey;
ALTER TABLE ONLY public.user_interval DROP CONSTRAINT user_interval_account_id_fkey;
DROP INDEX IF EXISTS public.index_user_interval_on_user_id;
DROP INDEX IF EXISTS public.index_user_interval_on_date_time;
ALTER TABLE ONLY public.user_interval DROP CONSTRAINT user_interval_pkey;
ALTER TABLE public.user_interval ALTER COLUMN id DROP DEFAULT;
-- Rename tables

ALTER TABLE public.user_interval RENAME TO user_interval_old;
ALTER TABLE public.user_interval_partioned RENAME TO user_interval;
CREATE TABLE public.user_interval_default PARTITION OF user_interval DEFAULT; -- < Creating a DEFAULT partition
ALTER SEQUENCE public.user_interval_id_seq OWNED BY public.user_interval.id;
GRANT ALL ON TABLE public.user_interval_default TO "ntk-dev-novait-novatalks-svc";


-- Add same contraints(remove ONLY statement) and indexes like in root table


ALTER TABLE ONLY public.user_interval ALTER COLUMN id SET DEFAULT nextval('public.user_interval_id_seq'::regclass);
ALTER TABLE ONLY public.user_interval ADD CONSTRAINT user_interval_pkey PRIMARY KEY (id, created_at);
ALTER TABLE public.user_interval ADD CONSTRAINT user_interval_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id);
ALTER TABLE public.user_interval ADD CONSTRAINT user_interval_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);
CREATE INDEX index_user_interval_on_date_time ON public.user_interval USING btree (date_time);
CREATE INDEX index_user_interval_on_user_id ON public.user_interval USING btree (user_id);