--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.5 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP EVENT TRIGGER IF EXISTS pgrst_drop_watch;
DROP EVENT TRIGGER IF EXISTS pgrst_ddl_watch;
DROP EVENT TRIGGER IF EXISTS issue_pg_net_access;
DROP EVENT TRIGGER IF EXISTS issue_pg_graphql_access;
DROP EVENT TRIGGER IF EXISTS issue_pg_cron_access;
DROP EVENT TRIGGER IF EXISTS issue_graphql_placeholder;
DROP PUBLICATION IF EXISTS supabase_realtime;
DROP POLICY IF EXISTS "Allow service accounts to read tickets" ON public.support_tickets;
DROP POLICY IF EXISTS "Allow reading security logs" ON public.security_log;
DROP POLICY IF EXISTS "Allow reading notification logs" ON public.notification_log;
DROP POLICY IF EXISTS "Allow bot to update tickets" ON public.support_tickets;
DROP POLICY IF EXISTS "Allow bot to read owners" ON public.owners;
DROP POLICY IF EXISTS "Allow bot to read machines" ON public.machines;
DROP POLICY IF EXISTS "Allow bot to manage user blocks" ON public.user_blocks;
DROP POLICY IF EXISTS "Allow bot to manage suspicious activity" ON public.suspicious_activity;
DROP POLICY IF EXISTS "Allow bot to manage notification settings" ON public.owner_notification_settings;
DROP POLICY IF EXISTS "Allow bot to insert tickets" ON public.support_tickets;
DROP POLICY IF EXISTS "Allow bot to insert security logs" ON public.security_log;
DROP POLICY IF EXISTS "Allow bot to insert notification logs" ON public.notification_log;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads_parts DROP CONSTRAINT IF EXISTS s3_multipart_uploads_parts_upload_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads_parts DROP CONSTRAINT IF EXISTS s3_multipart_uploads_parts_bucket_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads DROP CONSTRAINT IF EXISTS s3_multipart_uploads_bucket_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.objects DROP CONSTRAINT IF EXISTS "objects_bucketId_fkey";
ALTER TABLE IF EXISTS ONLY public.water_analyses DROP CONSTRAINT IF EXISTS water_analyses_machine_id_fkey;
ALTER TABLE IF EXISTS ONLY public.support_tickets DROP CONSTRAINT IF EXISTS support_tickets_machine_id_fkey;
ALTER TABLE IF EXISTS ONLY public.support_tickets DROP CONSTRAINT IF EXISTS support_tickets_assigned_to_fkey;
ALTER TABLE IF EXISTS ONLY public.owner_notification_settings DROP CONSTRAINT IF EXISTS owner_notification_settings_owner_id_fkey;
ALTER TABLE IF EXISTS ONLY public.notification_log DROP CONSTRAINT IF EXISTS notification_log_ticket_id_fkey;
ALTER TABLE IF EXISTS ONLY public.notification_log DROP CONSTRAINT IF EXISTS notification_log_owner_id_fkey;
ALTER TABLE IF EXISTS ONLY public.machines DROP CONSTRAINT IF EXISTS machines_owner_id_fkey;
ALTER TABLE IF EXISTS ONLY public.filter_replacements DROP CONSTRAINT IF EXISTS filter_replacements_machine_id_fkey;
ALTER TABLE IF EXISTS ONLY public.collections DROP CONSTRAINT IF EXISTS collections_machine_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.sso_domains DROP CONSTRAINT IF EXISTS sso_domains_sso_provider_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.sessions DROP CONSTRAINT IF EXISTS sessions_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.saml_relay_states DROP CONSTRAINT IF EXISTS saml_relay_states_sso_provider_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.saml_relay_states DROP CONSTRAINT IF EXISTS saml_relay_states_flow_state_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.saml_providers DROP CONSTRAINT IF EXISTS saml_providers_sso_provider_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.refresh_tokens DROP CONSTRAINT IF EXISTS refresh_tokens_session_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.one_time_tokens DROP CONSTRAINT IF EXISTS one_time_tokens_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_factors DROP CONSTRAINT IF EXISTS mfa_factors_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_challenges DROP CONSTRAINT IF EXISTS mfa_challenges_auth_factor_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_amr_claims DROP CONSTRAINT IF EXISTS mfa_amr_claims_session_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.identities DROP CONSTRAINT IF EXISTS identities_user_id_fkey;
DROP TRIGGER IF EXISTS update_objects_updated_at ON storage.objects;
DROP TRIGGER IF EXISTS tr_check_filters ON realtime.subscription;
DROP TRIGGER IF EXISTS update_support_tickets_updated_at ON public.support_tickets;
DROP TRIGGER IF EXISTS update_owner_notification_settings_updated_at ON public.owner_notification_settings;
DROP TRIGGER IF EXISTS set_machine_id ON public.machines;
DROP INDEX IF EXISTS storage.name_prefix_search;
DROP INDEX IF EXISTS storage.idx_objects_bucket_id_name;
DROP INDEX IF EXISTS storage.idx_multipart_uploads_list;
DROP INDEX IF EXISTS storage.bucketid_objname;
DROP INDEX IF EXISTS storage.bname;
DROP INDEX IF EXISTS realtime.subscription_subscription_id_entity_filters_key;
DROP INDEX IF EXISTS realtime.ix_realtime_subscription_entity;
DROP INDEX IF EXISTS public.idx_water_analyses_machine_id;
DROP INDEX IF EXISTS public.idx_water_analyses_date;
DROP INDEX IF EXISTS public.idx_user_blocks_until;
DROP INDEX IF EXISTS public.idx_user_blocks_active;
DROP INDEX IF EXISTS public.idx_suspicious_user_type;
DROP INDEX IF EXISTS public.idx_suspicious_severity;
DROP INDEX IF EXISTS public.idx_support_tickets_user_id;
DROP INDEX IF EXISTS public.idx_support_tickets_ticket_number;
DROP INDEX IF EXISTS public.idx_support_tickets_subcategory;
DROP INDEX IF EXISTS public.idx_support_tickets_status_created;
DROP INDEX IF EXISTS public.idx_support_tickets_status;
DROP INDEX IF EXISTS public.idx_support_tickets_owner;
DROP INDEX IF EXISTS public.idx_support_tickets_machine_status;
DROP INDEX IF EXISTS public.idx_support_tickets_machine_id;
DROP INDEX IF EXISTS public.idx_support_tickets_created_at;
DROP INDEX IF EXISTS public.idx_support_tickets_assigned_status;
DROP INDEX IF EXISTS public.idx_security_log_user_time;
DROP INDEX IF EXISTS public.idx_security_log_success;
DROP INDEX IF EXISTS public.idx_security_log_machine_time;
DROP INDEX IF EXISTS public.idx_security_log_action_time;
DROP INDEX IF EXISTS public.idx_notification_log_ticket_id;
DROP INDEX IF EXISTS public.idx_notification_log_status;
DROP INDEX IF EXISTS public.idx_notification_log_created_at;
DROP INDEX IF EXISTS public.idx_machines_status;
DROP INDEX IF EXISTS public.idx_filter_replacements_machine_id;
DROP INDEX IF EXISTS public.idx_filter_replacements_date;
DROP INDEX IF EXISTS auth.users_is_anonymous_idx;
DROP INDEX IF EXISTS auth.users_instance_id_idx;
DROP INDEX IF EXISTS auth.users_instance_id_email_idx;
DROP INDEX IF EXISTS auth.users_email_partial_key;
DROP INDEX IF EXISTS auth.user_id_created_at_idx;
DROP INDEX IF EXISTS auth.unique_phone_factor_per_user;
DROP INDEX IF EXISTS auth.sso_providers_resource_id_idx;
DROP INDEX IF EXISTS auth.sso_domains_sso_provider_id_idx;
DROP INDEX IF EXISTS auth.sso_domains_domain_idx;
DROP INDEX IF EXISTS auth.sessions_user_id_idx;
DROP INDEX IF EXISTS auth.sessions_not_after_idx;
DROP INDEX IF EXISTS auth.saml_relay_states_sso_provider_id_idx;
DROP INDEX IF EXISTS auth.saml_relay_states_for_email_idx;
DROP INDEX IF EXISTS auth.saml_relay_states_created_at_idx;
DROP INDEX IF EXISTS auth.saml_providers_sso_provider_id_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_updated_at_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_session_id_revoked_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_parent_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_instance_id_user_id_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_instance_id_idx;
DROP INDEX IF EXISTS auth.recovery_token_idx;
DROP INDEX IF EXISTS auth.reauthentication_token_idx;
DROP INDEX IF EXISTS auth.one_time_tokens_user_id_token_type_key;
DROP INDEX IF EXISTS auth.one_time_tokens_token_hash_hash_idx;
DROP INDEX IF EXISTS auth.one_time_tokens_relates_to_hash_idx;
DROP INDEX IF EXISTS auth.mfa_factors_user_id_idx;
DROP INDEX IF EXISTS auth.mfa_factors_user_friendly_name_unique;
DROP INDEX IF EXISTS auth.mfa_challenge_created_at_idx;
DROP INDEX IF EXISTS auth.idx_user_id_auth_method;
DROP INDEX IF EXISTS auth.idx_auth_code;
DROP INDEX IF EXISTS auth.identities_user_id_idx;
DROP INDEX IF EXISTS auth.identities_email_idx;
DROP INDEX IF EXISTS auth.flow_state_created_at_idx;
DROP INDEX IF EXISTS auth.factor_id_created_at_idx;
DROP INDEX IF EXISTS auth.email_change_token_new_idx;
DROP INDEX IF EXISTS auth.email_change_token_current_idx;
DROP INDEX IF EXISTS auth.confirmation_token_idx;
DROP INDEX IF EXISTS auth.audit_logs_instance_id_idx;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads DROP CONSTRAINT IF EXISTS s3_multipart_uploads_pkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads_parts DROP CONSTRAINT IF EXISTS s3_multipart_uploads_parts_pkey;
ALTER TABLE IF EXISTS ONLY storage.objects DROP CONSTRAINT IF EXISTS objects_pkey;
ALTER TABLE IF EXISTS ONLY storage.migrations DROP CONSTRAINT IF EXISTS migrations_pkey;
ALTER TABLE IF EXISTS ONLY storage.migrations DROP CONSTRAINT IF EXISTS migrations_name_key;
ALTER TABLE IF EXISTS ONLY storage.buckets DROP CONSTRAINT IF EXISTS buckets_pkey;
ALTER TABLE IF EXISTS ONLY realtime.schema_migrations DROP CONSTRAINT IF EXISTS schema_migrations_pkey;
ALTER TABLE IF EXISTS ONLY realtime.subscription DROP CONSTRAINT IF EXISTS pk_subscription;
ALTER TABLE IF EXISTS ONLY realtime.messages DROP CONSTRAINT IF EXISTS messages_pkey;
ALTER TABLE IF EXISTS ONLY public.water_analyses DROP CONSTRAINT IF EXISTS water_analyses_pkey;
ALTER TABLE IF EXISTS ONLY public.user_blocks DROP CONSTRAINT IF EXISTS user_blocks_user_id_key;
ALTER TABLE IF EXISTS ONLY public.user_blocks DROP CONSTRAINT IF EXISTS user_blocks_pkey;
ALTER TABLE IF EXISTS ONLY public.filter_replacements DROP CONSTRAINT IF EXISTS unique_machine_filter_date;
ALTER TABLE IF EXISTS ONLY public.suspicious_activity DROP CONSTRAINT IF EXISTS suspicious_activity_pkey;
ALTER TABLE IF EXISTS ONLY public.support_tickets DROP CONSTRAINT IF EXISTS support_tickets_ticket_number_key;
ALTER TABLE IF EXISTS ONLY public.support_tickets DROP CONSTRAINT IF EXISTS support_tickets_pkey;
ALTER TABLE IF EXISTS ONLY public.security_log DROP CONSTRAINT IF EXISTS security_log_pkey;
ALTER TABLE IF EXISTS ONLY public.owners DROP CONSTRAINT IF EXISTS owners_pkey;
ALTER TABLE IF EXISTS ONLY public.owner_notification_settings DROP CONSTRAINT IF EXISTS owner_notification_settings_pkey;
ALTER TABLE IF EXISTS ONLY public.owner_notification_settings DROP CONSTRAINT IF EXISTS owner_notification_settings_owner_id_key;
ALTER TABLE IF EXISTS ONLY public.notification_log DROP CONSTRAINT IF EXISTS notification_log_pkey;
ALTER TABLE IF EXISTS ONLY public.machines DROP CONSTRAINT IF EXISTS machines_pkey;
ALTER TABLE IF EXISTS ONLY public.machines DROP CONSTRAINT IF EXISTS machines_code_key;
ALTER TABLE IF EXISTS ONLY public.filter_replacements DROP CONSTRAINT IF EXISTS filter_replacements_pkey;
ALTER TABLE IF EXISTS ONLY public.collections DROP CONSTRAINT IF EXISTS collections_pkey;
ALTER TABLE IF EXISTS ONLY auth.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY auth.users DROP CONSTRAINT IF EXISTS users_phone_key;
ALTER TABLE IF EXISTS ONLY auth.sso_providers DROP CONSTRAINT IF EXISTS sso_providers_pkey;
ALTER TABLE IF EXISTS ONLY auth.sso_domains DROP CONSTRAINT IF EXISTS sso_domains_pkey;
ALTER TABLE IF EXISTS ONLY auth.sessions DROP CONSTRAINT IF EXISTS sessions_pkey;
ALTER TABLE IF EXISTS ONLY auth.schema_migrations DROP CONSTRAINT IF EXISTS schema_migrations_pkey;
ALTER TABLE IF EXISTS ONLY auth.saml_relay_states DROP CONSTRAINT IF EXISTS saml_relay_states_pkey;
ALTER TABLE IF EXISTS ONLY auth.saml_providers DROP CONSTRAINT IF EXISTS saml_providers_pkey;
ALTER TABLE IF EXISTS ONLY auth.saml_providers DROP CONSTRAINT IF EXISTS saml_providers_entity_id_key;
ALTER TABLE IF EXISTS ONLY auth.refresh_tokens DROP CONSTRAINT IF EXISTS refresh_tokens_token_unique;
ALTER TABLE IF EXISTS ONLY auth.refresh_tokens DROP CONSTRAINT IF EXISTS refresh_tokens_pkey;
ALTER TABLE IF EXISTS ONLY auth.one_time_tokens DROP CONSTRAINT IF EXISTS one_time_tokens_pkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_factors DROP CONSTRAINT IF EXISTS mfa_factors_pkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_factors DROP CONSTRAINT IF EXISTS mfa_factors_last_challenged_at_key;
ALTER TABLE IF EXISTS ONLY auth.mfa_challenges DROP CONSTRAINT IF EXISTS mfa_challenges_pkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_amr_claims DROP CONSTRAINT IF EXISTS mfa_amr_claims_session_id_authentication_method_pkey;
ALTER TABLE IF EXISTS ONLY auth.instances DROP CONSTRAINT IF EXISTS instances_pkey;
ALTER TABLE IF EXISTS ONLY auth.identities DROP CONSTRAINT IF EXISTS identities_provider_id_provider_unique;
ALTER TABLE IF EXISTS ONLY auth.identities DROP CONSTRAINT IF EXISTS identities_pkey;
ALTER TABLE IF EXISTS ONLY auth.flow_state DROP CONSTRAINT IF EXISTS flow_state_pkey;
ALTER TABLE IF EXISTS ONLY auth.audit_log_entries DROP CONSTRAINT IF EXISTS audit_log_entries_pkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_amr_claims DROP CONSTRAINT IF EXISTS amr_id_pk;
ALTER TABLE IF EXISTS public.water_analyses ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.user_blocks ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.suspicious_activity ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.support_tickets ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.security_log ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.owners ALTER COLUMN owner_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.owner_notification_settings ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.notification_log ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.filter_replacements ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.collections ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS auth.refresh_tokens ALTER COLUMN id DROP DEFAULT;
DROP TABLE IF EXISTS storage.s3_multipart_uploads_parts;
DROP TABLE IF EXISTS storage.s3_multipart_uploads;
DROP TABLE IF EXISTS storage.objects;
DROP TABLE IF EXISTS storage.migrations;
DROP TABLE IF EXISTS storage.buckets;
DROP TABLE IF EXISTS realtime.subscription;
DROP TABLE IF EXISTS realtime.schema_migrations;
DROP TABLE IF EXISTS realtime.messages;
DROP SEQUENCE IF EXISTS public.water_analyses_id_seq;
DROP VIEW IF EXISTS public.view_collections_extended;
DROP SEQUENCE IF EXISTS public.user_blocks_id_seq;
DROP TABLE IF EXISTS public.user_blocks;
DROP SEQUENCE IF EXISTS public.suspicious_activity_id_seq;
DROP TABLE IF EXISTS public.suspicious_activity;
DROP SEQUENCE IF EXISTS public.support_tickets_id_seq;
DROP SEQUENCE IF EXISTS public.security_log_id_seq;
DROP TABLE IF EXISTS public.security_log;
DROP SEQUENCE IF EXISTS public.owners_owner_id_seq;
DROP VIEW IF EXISTS public.owner_ticket_statistics_extended;
DROP VIEW IF EXISTS public.owner_ticket_statistics;
DROP SEQUENCE IF EXISTS public.owner_notification_settings_id_seq;
DROP TABLE IF EXISTS public.owner_notification_settings;
DROP SEQUENCE IF EXISTS public.notification_log_id_seq;
DROP TABLE IF EXISTS public.notification_log;
DROP VIEW IF EXISTS public.machines_with_owners;
DROP VIEW IF EXISTS public.machines_with_owner_name;
DROP TABLE IF EXISTS public.owners;
DROP VIEW IF EXISTS public.machine_water_quality;
DROP VIEW IF EXISTS public.machine_problem_statistics_extended;
DROP TABLE IF EXISTS public.water_analyses;
DROP VIEW IF EXISTS public.machine_problem_statistics;
DROP TABLE IF EXISTS public.support_tickets;
DROP TABLE IF EXISTS public.machines;
DROP SEQUENCE IF EXISTS public.machine_id_seq;
DROP SEQUENCE IF EXISTS public.filter_replacements_id_seq;
DROP TABLE IF EXISTS public.filter_replacements;
DROP SEQUENCE IF EXISTS public.collections_id_seq;
DROP TABLE IF EXISTS public.collections;
DROP TABLE IF EXISTS auth.users;
DROP TABLE IF EXISTS auth.sso_providers;
DROP TABLE IF EXISTS auth.sso_domains;
DROP TABLE IF EXISTS auth.sessions;
DROP TABLE IF EXISTS auth.schema_migrations;
DROP TABLE IF EXISTS auth.saml_relay_states;
DROP TABLE IF EXISTS auth.saml_providers;
DROP SEQUENCE IF EXISTS auth.refresh_tokens_id_seq;
DROP TABLE IF EXISTS auth.refresh_tokens;
DROP TABLE IF EXISTS auth.one_time_tokens;
DROP TABLE IF EXISTS auth.mfa_factors;
DROP TABLE IF EXISTS auth.mfa_challenges;
DROP TABLE IF EXISTS auth.mfa_amr_claims;
DROP TABLE IF EXISTS auth.instances;
DROP TABLE IF EXISTS auth.identities;
DROP TABLE IF EXISTS auth.flow_state;
DROP TABLE IF EXISTS auth.audit_log_entries;
DROP FUNCTION IF EXISTS storage.update_updated_at_column();
DROP FUNCTION IF EXISTS storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text);
DROP FUNCTION IF EXISTS storage.operation();
DROP FUNCTION IF EXISTS storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text);
DROP FUNCTION IF EXISTS storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text);
DROP FUNCTION IF EXISTS storage.get_size_by_bucket();
DROP FUNCTION IF EXISTS storage.foldername(name text);
DROP FUNCTION IF EXISTS storage.filename(name text);
DROP FUNCTION IF EXISTS storage.extension(name text);
DROP FUNCTION IF EXISTS storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb);
DROP FUNCTION IF EXISTS realtime.topic();
DROP FUNCTION IF EXISTS realtime.to_regrole(role_name text);
DROP FUNCTION IF EXISTS realtime.subscription_check_filters();
DROP FUNCTION IF EXISTS realtime.send(payload jsonb, event text, topic text, private boolean);
DROP FUNCTION IF EXISTS realtime.quote_wal2json(entity regclass);
DROP FUNCTION IF EXISTS realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer);
DROP FUNCTION IF EXISTS realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]);
DROP FUNCTION IF EXISTS realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text);
DROP FUNCTION IF EXISTS realtime."cast"(val text, type_ regtype);
DROP FUNCTION IF EXISTS realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]);
DROP FUNCTION IF EXISTS realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text);
DROP FUNCTION IF EXISTS realtime.apply_rls(wal jsonb, max_record_bytes integer);
DROP FUNCTION IF EXISTS public.update_updated_at_column();
DROP FUNCTION IF EXISTS public.unblock_user(p_user_id bigint, p_admin_note text);
DROP FUNCTION IF EXISTS public.get_security_dashboard(days_back integer);
DROP FUNCTION IF EXISTS public.get_problem_statistics(days_back integer);
DROP FUNCTION IF EXISTS public.get_machine_secure(p_machine_code text, p_user_id bigint, p_username text, p_user_agent text, p_session_id text);
DROP FUNCTION IF EXISTS public.get_machine_filter_history(machine_uuid uuid, limit_count integer);
DROP FUNCTION IF EXISTS public.generate_ticket_number();
DROP FUNCTION IF EXISTS public.generate_machine_id();
DROP FUNCTION IF EXISTS public.create_ticket_secure(p_machine_code text, p_user_id bigint, p_user_name text, p_user_phone text, p_problem_type text, p_problem_subcategory text, p_problem_description text, p_user_agent text);
DROP FUNCTION IF EXISTS public.check_user_security_status(p_user_id bigint, p_username text, p_machine_code text, p_user_agent text);
DROP FUNCTION IF EXISTS pgbouncer.get_auth(p_usename text);
DROP FUNCTION IF EXISTS extensions.set_graphql_placeholder();
DROP FUNCTION IF EXISTS extensions.pgrst_drop_watch();
DROP FUNCTION IF EXISTS extensions.pgrst_ddl_watch();
DROP FUNCTION IF EXISTS extensions.grant_pg_net_access();
DROP FUNCTION IF EXISTS extensions.grant_pg_graphql_access();
DROP FUNCTION IF EXISTS extensions.grant_pg_cron_access();
DROP FUNCTION IF EXISTS auth.uid();
DROP FUNCTION IF EXISTS auth.role();
DROP FUNCTION IF EXISTS auth.jwt();
DROP FUNCTION IF EXISTS auth.email();
DROP TYPE IF EXISTS realtime.wal_rls;
DROP TYPE IF EXISTS realtime.wal_column;
DROP TYPE IF EXISTS realtime.user_defined_filter;
DROP TYPE IF EXISTS realtime.equality_op;
DROP TYPE IF EXISTS realtime.action;
DROP TYPE IF EXISTS public.ownership_form;
DROP TYPE IF EXISTS auth.one_time_token_type;
DROP TYPE IF EXISTS auth.factor_type;
DROP TYPE IF EXISTS auth.factor_status;
DROP TYPE IF EXISTS auth.code_challenge_method;
DROP TYPE IF EXISTS auth.aal_level;
DROP EXTENSION IF EXISTS "uuid-ossp";
DROP EXTENSION IF EXISTS supabase_vault;
DROP EXTENSION IF EXISTS pgcrypto;
DROP EXTENSION IF EXISTS pg_stat_statements;
DROP EXTENSION IF EXISTS pg_graphql;
DROP SCHEMA IF EXISTS vault;
DROP SCHEMA IF EXISTS storage;
DROP SCHEMA IF EXISTS realtime;
DROP SCHEMA IF EXISTS pgbouncer;
DROP SCHEMA IF EXISTS graphql_public;
DROP SCHEMA IF EXISTS graphql;
DROP SCHEMA IF EXISTS extensions;
DROP SCHEMA IF EXISTS auth;
--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA auth;


--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA extensions;


--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql;


--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql_public;


--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA pgbouncer;


--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA realtime;


--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA storage;


--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA vault;


--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


--
-- Name: ownership_form; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.ownership_form AS ENUM (
    'ФОП',
    'ТОВ',
    'Приватне підприємство',
    'Частне підприємство'
);


--
-- Name: action; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: -
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
begin
    raise debug 'PgBouncer auth request: %', p_usename;

    return query
    select 
        rolname::text, 
        case when rolvaliduntil < now() 
            then null 
            else rolpassword::text 
        end 
    from pg_authid 
    where rolname=$1 and rolcanlogin;
end;
$_$;


--
-- Name: check_user_security_status(bigint, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.check_user_security_status(p_user_id bigint, p_username text DEFAULT NULL::text, p_machine_code text DEFAULT NULL::text, p_user_agent text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_block_info record;
    v_recent_requests INTEGER;
    v_unique_machines INTEGER;
    v_invalid_attempts INTEGER;
    v_should_block BOOLEAN := false;
    v_block_reason TEXT;
    v_severity TEXT := 'low';
    v_block_duration INTERVAL := INTERVAL '15 minutes';
BEGIN
    -- Проверяем существующую блокировку
    SELECT * INTO v_block_info
    FROM user_blocks 
    WHERE user_id = p_user_id AND blocked_until > NOW();
    
    IF v_block_info.id IS NOT NULL THEN
        -- Логируем попытку доступа заблокированного пользователя
        INSERT INTO security_log (user_id, username, machine_code, action, success, error_reason, user_agent)
        VALUES (p_user_id, p_username, p_machine_code, 'BLOCKED_USER_ATTEMPT', false, 
                'USER_BLOCKED_UNTIL_' || v_block_info.blocked_until, p_user_agent);
        
        RETURN json_build_object(
            'allowed', false,
            'blocked', true,
            'reason', 'USER_BLOCKED',
            'message', format('Користувач заблокований до %s за %s', 
                            v_block_info.blocked_until::text, v_block_info.block_reason),
            'blocked_until', v_block_info.blocked_until,
            'block_reason', v_block_info.block_reason
        );
    END IF;
    
    -- Анализируем активность за последние 10 минут
    SELECT 
        COUNT(*),
        COUNT(DISTINCT machine_code) FILTER (WHERE machine_code IS NOT NULL),
        COUNT(*) FILTER (WHERE success = false AND error_reason = 'MACHINE_NOT_FOUND')
    INTO v_recent_requests, v_unique_machines, v_invalid_attempts
    FROM security_log 
    WHERE user_id = p_user_id 
    AND created_at > NOW() - INTERVAL '10 minutes';
    
    -- Проверяем различные сценарии блокировки
    IF v_recent_requests >= 10 THEN
        v_should_block := true;
        v_block_reason := 'EXCESSIVE_REQUESTS';
        v_severity := 'high';
        v_block_duration := INTERVAL '30 minutes';
    ELSIF v_unique_machines >= 5 THEN
        v_should_block := true;
        v_block_reason := 'MULTIPLE_MACHINES_SCANNING';
        v_severity := 'critical';
        v_block_duration := INTERVAL '2 hours';
    ELSIF v_invalid_attempts >= 3 THEN
        v_should_block := true;
        v_block_reason := 'INVALID_MACHINE_CODES';
        v_severity := 'medium';
        v_block_duration := INTERVAL '20 minutes';
    END IF;
    
    -- Если нужно заблокировать
    IF v_should_block THEN
        -- Проверяем, не заблокировали ли уже недавно
        IF NOT EXISTS (
            SELECT 1 FROM user_blocks 
            WHERE user_id = p_user_id 
            AND created_at > NOW() - INTERVAL '1 hour'
        ) THEN
            -- Создаем/обновляем блокировку
            INSERT INTO user_blocks (user_id, block_reason, blocked_until, block_count)
            VALUES (p_user_id, v_block_reason, NOW() + v_block_duration, 1)
            ON CONFLICT (user_id) 
            DO UPDATE SET 
                block_reason = EXCLUDED.block_reason,
                blocked_until = NOW() + v_block_duration,
                block_count = user_blocks.block_count + 1,
                updated_at = NOW();
            
            -- Записываем подозрительную активность
            INSERT INTO suspicious_activity (
                user_id, activity_type, description, severity, 
                request_count, machine_codes
            ) VALUES (
                p_user_id, v_block_reason,
                format('Заблокирован за %s: %s запросов к %s автоматам', 
                       v_block_reason, v_recent_requests, v_unique_machines),
                v_severity, v_recent_requests,
                ARRAY(SELECT DISTINCT machine_code FROM security_log 
                      WHERE user_id = p_user_id AND created_at > NOW() - INTERVAL '10 minutes'
                      AND machine_code IS NOT NULL)
            );
            
            -- Логируем блокировку
            INSERT INTO security_log (user_id, username, machine_code, action, success, error_reason, user_agent)
            VALUES (p_user_id, p_username, p_machine_code, 'USER_BLOCKED', true, v_block_reason, p_user_agent);
        END IF; -- ИСПРАВЛЕНО: было END; теперь END IF;
        
        RETURN json_build_object(
            'allowed', false,
            'blocked', true,
            'reason', v_block_reason,
            'message', format('Підозріла активність. Заблоковано на %s', v_block_duration::text),
            'blocked_until', NOW() + v_block_duration,
            'severity', v_severity
        );
    END IF;
    
    -- Пользователь не заблокирован
    RETURN json_build_object(
        'allowed', true,
        'blocked', false,
        'recent_activity', json_build_object(
            'requests_10min', v_recent_requests,
            'unique_machines', v_unique_machines,
            'invalid_attempts', v_invalid_attempts
        )
    );
END;
$$;


--
-- Name: create_ticket_secure(text, bigint, text, text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.create_ticket_secure(p_machine_code text, p_user_id bigint, p_user_name text, p_user_phone text, p_problem_type text, p_problem_subcategory text DEFAULT NULL::text, p_problem_description text DEFAULT NULL::text, p_user_agent text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
DECLARE
    v_machine_info JSON;
    v_ticket_number TEXT;
    v_ticket_id INTEGER;
    v_start_time TIMESTAMP := clock_timestamp();
    v_response_time INTEGER;
BEGIN
    -- 1. Получаем информацию об автомате с проверкой безопасности
    v_machine_info := get_machine_secure(p_machine_code, p_user_id, p_user_name, p_user_agent);
    
    IF NOT (v_machine_info->>'success')::boolean THEN
        RETURN v_machine_info; -- Возвращаем ошибку/блокировку
    END IF;
    
    -- 2. Генерируем номер заявки
    WITH max_ticket AS (
        SELECT COALESCE(MAX(
            CASE 
                WHEN ticket_number ~ '^ST-\d{4}-\d+$' 
                THEN (split_part(ticket_number, '-', 3))::integer
                ELSE 0
            END
        ), 0) as max_num
        FROM support_tickets 
        WHERE ticket_number LIKE 'ST-' || EXTRACT(year FROM NOW()) || '-%'
    )
    SELECT 'ST-' || EXTRACT(year FROM NOW()) || '-' || LPAD((max_num + 1)::text, 4, '0')
    INTO v_ticket_number
    FROM max_ticket;
    
    -- 3. Создаем заявку
    INSERT INTO support_tickets (
        ticket_number, user_id, user_name, user_phone,
        problem_type, problem_subcategory, problem_description,
        machine_id, status, priority
    ) VALUES (
        v_ticket_number, p_user_id, p_user_name, p_user_phone,
        p_problem_type, p_problem_subcategory, p_problem_description,
        (v_machine_info->>'machine_id')::uuid, 'new', 'normal'
    ) RETURNING id INTO v_ticket_id;
    
    -- 4. Вычисляем время ответа
    v_response_time := EXTRACT(epoch FROM (clock_timestamp() - v_start_time)) * 1000;
    
    -- 5. Логируем создание заявки
    INSERT INTO security_log (
        user_id, username, machine_code, action, success, 
        user_agent, response_time_ms
    ) VALUES (
        p_user_id, p_user_name, p_machine_code, 'CREATE_TICKET', true, 
        p_user_agent, v_response_time
    );
    
    -- 6. Возвращаем результат
    RETURN json_build_object(
        'success', true,
        'ticket_number', v_ticket_number,
        'ticket_id', v_ticket_id,
        'response_time_ms', v_response_time
    );
END;
$_$;


--
-- Name: generate_machine_id(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.generate_machine_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.machine_id IS NULL THEN
        NEW.machine_id := 'CV-' || LPAD(nextval('machine_id_seq')::TEXT, 3, '0');
    END IF;
    RETURN NEW;
END;
$$;


--
-- Name: generate_ticket_number(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.generate_ticket_number() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    current_year INTEGER;
    last_number INTEGER;
    new_number INTEGER;
    ticket_number TEXT;
BEGIN
    current_year := EXTRACT(YEAR FROM NOW());
    
    -- Получаем последний номер заявки за текущий год
    SELECT COALESCE(
        MAX(CAST(SPLIT_PART(ticket_number, '-', 3) AS INTEGER)), 
        0
    ) INTO last_number
    FROM support_tickets
    WHERE ticket_number LIKE 'ST-' || current_year || '-%';
    
    new_number := last_number + 1;
    ticket_number := 'ST-' || current_year || '-' || LPAD(new_number::TEXT, 4, '0');
    
    RETURN ticket_number;
END;
$$;


--
-- Name: get_machine_filter_history(uuid, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_machine_filter_history(machine_uuid uuid, limit_count integer DEFAULT 5) RETURNS TABLE(replacement_date date, filter_type character varying, replaced_by character varying, notes text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        fr.replacement_date,
        fr.filter_type,
        fr.replaced_by,
        fr.notes
    FROM filter_replacements fr
    WHERE fr.machine_id = machine_uuid
    ORDER BY fr.replacement_date DESC
    LIMIT limit_count;
END;
$$;


--
-- Name: get_machine_secure(text, bigint, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_machine_secure(p_machine_code text, p_user_id bigint, p_username text DEFAULT NULL::text, p_user_agent text DEFAULT NULL::text, p_session_id text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_machine record;
    v_owner record;
    v_notification_settings record;
    v_start_time TIMESTAMP := clock_timestamp();
    v_response_time INTEGER;
    v_security_check JSON;
BEGIN
    -- 1. Проверка безопасности
    v_security_check := check_user_security_status(p_user_id, p_username, p_machine_code, p_user_agent);
    
    IF NOT (v_security_check->>'allowed')::boolean THEN
        INSERT INTO security_log (
            user_id, username, machine_code, action, success, 
            error_reason, user_agent, session_id
        ) VALUES (
            p_user_id, p_username, p_machine_code, 'GET_MACHINE_BLOCKED', 
            false, v_security_check->>'reason', p_user_agent, p_session_id
        );
        
        RETURN v_security_check;
    END IF;
    
    -- 2. Поиск автомата
    SELECT m.*, 
           CONCAT(m.region, ', вул. ', m.street, ', ', m.building_number) AS machine_address
    INTO v_machine
    FROM machines m 
    WHERE m.code = p_machine_code;
    
    -- Вычисляем время ответа
    v_response_time := EXTRACT(epoch FROM (clock_timestamp() - v_start_time)) * 1000;
    
    IF v_machine.id IS NULL THEN
        INSERT INTO security_log (
            user_id, username, machine_code, action, success, error_reason, 
            user_agent, session_id, response_time_ms
        ) VALUES (
            p_user_id, p_username, p_machine_code, 'GET_MACHINE', false, 
            'MACHINE_NOT_FOUND', p_user_agent, p_session_id, v_response_time
        );
        
        RETURN json_build_object(
            'success', false,
            'error', 'MACHINE_NOT_FOUND',
            'message', 'Автомат з кодом ' || p_machine_code || ' не знайдено',
            'response_time_ms', v_response_time
        );
    END IF;
    
    -- 3. Получаем владельца (ИСПРАВЛЕНО: используем правильные поля)
    SELECT o.owner_id, o.first_name, o.last_name, o.email, o.mobile_phone
    INTO v_owner
    FROM owners o 
    WHERE o.owner_id = v_machine.owner_id;
    
    -- 4. Получаем настройки уведомлений
    SELECT ons.* INTO v_notification_settings
    FROM owner_notification_settings ons 
    WHERE ons.owner_id = v_machine.owner_id;
    
    -- 5. Логируем успешный запрос
    INSERT INTO security_log (
        user_id, username, machine_code, action, success, 
        user_agent, session_id, response_time_ms
    ) VALUES (
        p_user_id, p_username, p_machine_code, 'GET_MACHINE', true, 
        p_user_agent, p_session_id, v_response_time
    );
    
    -- 6. Возвращаем результат (ИСПРАВЛЕНО: формируем owner_name из first_name + last_name)
    RETURN json_build_object(
        'success', true,
        'machine_id', v_machine.id,
        'machine_code', v_machine.code,
        'machine_address', v_machine.machine_address,
        'owner_id', v_owner.owner_id,
        'owner_name', v_owner.first_name || ' ' || v_owner.last_name,  -- ✅ ИСПРАВЛЕНО
        'owner_email', v_owner.email,
        'owner_phone', v_owner.mobile_phone,
        'email_enabled', COALESCE(v_notification_settings.email_enabled, true),
        'telegram_enabled', COALESCE(v_notification_settings.telegram_enabled, true),
        'telegram_chat_id', v_notification_settings.telegram_chat_id,
        'response_time_ms', v_response_time
    );
END;
$$;


--
-- Name: get_problem_statistics(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_problem_statistics(days_back integer DEFAULT 30) RETURNS TABLE(problem_type character varying, problem_subcategory character varying, count_total bigint, count_last_month bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        st.problem_type,
        st.problem_subcategory,
        COUNT(*) as count_total,
        COUNT(CASE WHEN st.created_at >= NOW() - INTERVAL '1 month' * days_back / 30 THEN 1 END) as count_last_month
    FROM support_tickets st
    GROUP BY st.problem_type, st.problem_subcategory
    ORDER BY count_total DESC;
END;
$$;


--
-- Name: get_security_dashboard(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_security_dashboard(days_back integer DEFAULT 7) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN json_build_object(
        'summary', json_build_object(
            'total_requests', (SELECT COUNT(*) FROM security_log WHERE created_at > NOW() - (days_back || ' days')::INTERVAL),
            'successful_requests', (SELECT COUNT(*) FROM security_log WHERE created_at > NOW() - (days_back || ' days')::INTERVAL AND success = true),
            'unique_users', (SELECT COUNT(DISTINCT user_id) FROM security_log WHERE created_at > NOW() - (days_back || ' days')::INTERVAL),
            'blocked_users', (SELECT COUNT(DISTINCT user_id) FROM user_blocks WHERE created_at > NOW() - (days_back || ' days')::INTERVAL),
            'average_response_time', (SELECT ROUND(AVG(response_time_ms)) FROM security_log WHERE created_at > NOW() - (days_back || ' days')::INTERVAL AND response_time_ms IS NOT NULL)
        ),
        'threats', json_build_object(
            'rate_limit_blocks', (SELECT COUNT(*) FROM security_log WHERE created_at > NOW() - (days_back || ' days')::INTERVAL AND error_reason LIKE '%RATE_LIMIT%'),
            'invalid_codes', (SELECT COUNT(*) FROM security_log WHERE created_at > NOW() - (days_back || ' days')::INTERVAL AND error_reason = 'MACHINE_NOT_FOUND'),
            'suspicious_activity', (SELECT COUNT(*) FROM suspicious_activity WHERE last_seen > NOW() - (days_back || ' days')::INTERVAL),
            'critical_threats', (SELECT COUNT(*) FROM suspicious_activity WHERE last_seen > NOW() - (days_back || ' days')::INTERVAL AND severity = 'critical')
        ),
        'top_machines', (
            SELECT json_agg(
                json_build_object(
                    'machine_code', machine_code,
                    'requests', request_count,
                    'success_rate', ROUND((success_count::decimal / request_count * 100), 1)
                )
            )
            FROM (
                SELECT 
                    machine_code, 
                    COUNT(*) as request_count,
                    COUNT(*) FILTER (WHERE success = true) as success_count
                FROM security_log 
                WHERE created_at > NOW() - (days_back || ' days')::INTERVAL
                AND machine_code IS NOT NULL
                GROUP BY machine_code
                ORDER BY request_count DESC
                LIMIT 10
            ) top_machines
        ),
        'recent_blocks', (
            SELECT json_agg(
                json_build_object(
                    'user_id', user_id,
                    'reason', block_reason,
                    'blocked_until', blocked_until,
                    'block_count', block_count
                )
            )
            FROM user_blocks 
            WHERE created_at > NOW() - (days_back || ' days')::INTERVAL
            ORDER BY created_at DESC
            LIMIT 10
        )
    );
END;
$$;


--
-- Name: unblock_user(bigint, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.unblock_user(p_user_id bigint, p_admin_note text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_deleted_count INTEGER;
BEGIN
    DELETE FROM user_blocks WHERE user_id = p_user_id;
    GET DIAGNOSTICS v_deleted_count = ROW_COUNT;
    
    -- Логируем разблокировку
    INSERT INTO security_log (user_id, action, success, error_reason)
    VALUES (p_user_id, 'ADMIN_UNBLOCK', true, p_admin_note);
    
    RETURN json_build_object(
        'success', v_deleted_count > 0,
        'message', CASE 
            WHEN v_deleted_count > 0 THEN 'Користувач розблокований'
            ELSE 'Користувач не був заблокований'
        END
    );
END;
$$;


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_;

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
      return res;
    end
    $$;


--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  BEGIN
    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (payload, event, topic, private, extension)
    VALUES (payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
	select string_to_array(name, '/') into _parts;
	select _parts[array_length(_parts,1)] into _filename;
	-- @todo return the last part instead of 2
	return reverse(split_part(reverse(_filename), '.', 1));
END
$$;


--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[1:array_length(_parts,1)-1];
END
$$;


--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(name COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                        substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1)))
                    ELSE
                        name
                END AS name, id, metadata, updated_at
            FROM
                storage.objects
            WHERE
                bucket_id = $5 AND
                name ILIKE $1 || ''%'' AND
                CASE
                    WHEN $6 != '''' THEN
                    name COLLATE "C" > $6
                ELSE true END
                AND CASE
                    WHEN $4 != '''' THEN
                        CASE
                            WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                                substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                name COLLATE "C" > $4
                            END
                    ELSE
                        true
                END
            ORDER BY
                name COLLATE "C" ASC) as e order by name COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_token, bucket_id, start_after;
END;
$_$;


--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
  v_order_by text;
  v_sort_order text;
begin
  case
    when sortcolumn = 'name' then
      v_order_by = 'name';
    when sortcolumn = 'updated_at' then
      v_order_by = 'updated_at';
    when sortcolumn = 'created_at' then
      v_order_by = 'created_at';
    when sortcolumn = 'last_accessed_at' then
      v_order_by = 'last_accessed_at';
    else
      v_order_by = 'name';
  end case;

  case
    when sortorder = 'asc' then
      v_sort_order = 'asc';
    when sortorder = 'desc' then
      v_sort_order = 'desc';
    else
      v_sort_order = 'asc';
  end case;

  v_order_by = v_order_by || ' ' || v_sort_order;

  return query execute
    'with folders as (
       select path_tokens[$1] as folder
       from storage.objects
         where objects.name ilike $2 || $3 || ''%''
           and bucket_id = $4
           and array_length(objects.path_tokens, 1) <> $1
       group by folder
       order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text NOT NULL,
    code_challenge_method auth.code_challenge_method NOT NULL,
    code_challenge text NOT NULL,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone
);


--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.flow_state IS 'stores metadata for pkce logins';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid
);


--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: -
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: -
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text
);


--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: collections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.collections (
    id integer NOT NULL,
    machine_id uuid,
    collection_date date NOT NULL,
    amount numeric(10,2) NOT NULL,
    CONSTRAINT collections_amount_check CHECK ((amount >= (0)::numeric))
);


--
-- Name: COLUMN collections.machine_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.collections.machine_id IS 'Автомат, з якого здійснено інкасацію';


--
-- Name: COLUMN collections.collection_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.collections.collection_date IS 'Дата проведення інкасації';


--
-- Name: COLUMN collections.amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.collections.amount IS 'Сума інкасації в гривнях';


--
-- Name: collections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.collections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: collections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.collections_id_seq OWNED BY public.collections.id;


--
-- Name: filter_replacements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.filter_replacements (
    id integer NOT NULL,
    machine_id uuid NOT NULL,
    replacement_date date NOT NULL,
    filter_type character varying(50) NOT NULL,
    replaced_by character varying(100),
    notes text,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: filter_replacements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.filter_replacements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: filter_replacements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.filter_replacements_id_seq OWNED BY public.filter_replacements.id;


--
-- Name: machine_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.machine_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: machines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.machines (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    machine_id text,
    sn_ingenico text,
    code text NOT NULL,
    region text NOT NULL,
    street text NOT NULL,
    building_number text NOT NULL,
    details text,
    telegram_link text NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    owner_id integer,
    merchant_id character varying(50),
    impulses integer,
    sn_controller text,
    firmware text,
    status character varying(20) DEFAULT 'active'::character varying,
    last_maintenance timestamp with time zone,
    next_maintenance timestamp with time zone,
    installation_date date,
    qr_code_url text,
    notes text,
    CONSTRAINT machines_impulses_check CHECK ((impulses > 0)),
    CONSTRAINT machines_status_check CHECK (((status)::text = ANY (ARRAY[('active'::character varying)::text, ('maintenance'::character varying)::text, ('offline'::character varying)::text, ('decommissioned'::character varying)::text])))
);


--
-- Name: TABLE machines; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.machines IS 'Список всех автоматов питьевой воды';


--
-- Name: COLUMN machines.machine_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.machines.machine_id IS 'Уникальный ID автомата (например, CV-001)';


--
-- Name: COLUMN machines.sn_ingenico; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.machines.sn_ingenico IS 'Серийный номер устройства';


--
-- Name: COLUMN machines.code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.machines.code IS 'Короткий код, используемый в Telegram (BUCHA_BORYSA_10а и т.п.)';


--
-- Name: COLUMN machines.region; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.machines.region IS 'Населённый пункт или область (м. Київ, м. Буча)';


--
-- Name: COLUMN machines.street; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.machines.street IS 'Название улицы';


--
-- Name: COLUMN machines.building_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.machines.building_number IS 'Номер здания';


--
-- Name: COLUMN machines.details; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.machines.details IS 'Дополнительная информация об объекте (например, "біля Аптеки")';


--
-- Name: COLUMN machines.telegram_link; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.machines.telegram_link IS 'Ссылка на Telegram-бота с параметром start';


--
-- Name: COLUMN machines.merchant_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.machines.merchant_id IS 'Ідентифікатор вендингового автомата в банку (наприклад, в АБанку)';


--
-- Name: COLUMN machines.impulses; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.machines.impulses IS 'Кількість імпульсів на 1 літр';


--
-- Name: COLUMN machines.sn_controller; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.machines.sn_controller IS 'Серійний номер контролера';


--
-- Name: COLUMN machines.firmware; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.machines.firmware IS 'Версія прошивки контролера';


--
-- Name: COLUMN machines.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.machines.status IS 'Статус автомата: active, maintenance, offline, decommissioned';


--
-- Name: COLUMN machines.qr_code_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.machines.qr_code_url IS 'URL QR-кода для автомата';


--
-- Name: COLUMN machines.notes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.machines.notes IS 'Дополнительные заметки об автомате';


--
-- Name: support_tickets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.support_tickets (
    id integer NOT NULL,
    ticket_number character varying(20) NOT NULL,
    user_id bigint NOT NULL,
    user_name character varying(255),
    user_phone character varying(20) NOT NULL,
    problem_type character varying(100) NOT NULL,
    problem_description text,
    machine_id uuid NOT NULL,
    status character varying(20) DEFAULT 'new'::character varying,
    priority character varying(10) DEFAULT 'normal'::character varying,
    assigned_to integer,
    resolution_notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    resolved_at timestamp with time zone,
    photo_urls text[],
    client_rating integer,
    problem_subcategory character varying(100),
    severity_level character varying(20) DEFAULT 'normal'::character varying,
    problem_level3 text,
    comments jsonb DEFAULT '[]'::jsonb,
    CONSTRAINT support_tickets_client_rating_check CHECK (((client_rating >= 1) AND (client_rating <= 5))),
    CONSTRAINT support_tickets_priority_check CHECK (((priority)::text = ANY (ARRAY[('low'::character varying)::text, ('normal'::character varying)::text, ('high'::character varying)::text, ('urgent'::character varying)::text]))),
    CONSTRAINT support_tickets_status_check CHECK (((status)::text = ANY (ARRAY[('new'::character varying)::text, ('in_progress'::character varying)::text, ('resolved'::character varying)::text, ('closed'::character varying)::text])))
);


--
-- Name: TABLE support_tickets; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.support_tickets IS 'Заявки клиентов по проблемам с автоматами';


--
-- Name: COLUMN support_tickets.ticket_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.support_tickets.ticket_number IS 'Уникальный номер заявки в формате ST-YYYY-NNNN';


--
-- Name: COLUMN support_tickets.user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.support_tickets.user_id IS 'Telegram ID пользователя';


--
-- Name: COLUMN support_tickets.problem_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.support_tickets.problem_type IS 'Тип проблемы: machine_offline, payment_issue, water_quality, technical_issue, emergency';


--
-- Name: COLUMN support_tickets.assigned_to; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.support_tickets.assigned_to IS 'ID владельца автомата из таблицы owners';


--
-- Name: COLUMN support_tickets.problem_subcategory; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.support_tickets.problem_subcategory IS 'Подкатегория проблемы (например: no_water_flow, ozonator_failure)';


--
-- Name: COLUMN support_tickets.severity_level; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.support_tickets.severity_level IS 'Уровень критичности: low, normal, high, critical';


--
-- Name: machine_problem_statistics; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.machine_problem_statistics WITH (security_invoker='on') AS
 SELECT m.id AS machine_id,
    m.code,
    m.region,
    m.street,
    m.building_number,
    m.details,
    concat(m.region, ', вул. ', m.street, ', ', m.building_number,
        CASE
            WHEN (m.details IS NOT NULL) THEN concat(' (', m.details, ')')
            ELSE ''::text
        END) AS full_address,
    m.status AS machine_status,
    count(st.id) AS total_tickets,
    count(
        CASE
            WHEN ((st.problem_type)::text = '🚫 Автомат не працює'::text) THEN 1
            ELSE NULL::integer
        END) AS offline_issues,
    count(
        CASE
            WHEN ((st.problem_type)::text = '💳 Проблема з оплатою'::text) THEN 1
            ELSE NULL::integer
        END) AS payment_issues,
    count(
        CASE
            WHEN ((st.problem_type)::text = '💦 Погана якість води'::text) THEN 1
            ELSE NULL::integer
        END) AS water_quality_issues,
    count(
        CASE
            WHEN ((st.problem_type)::text = '🔧 Інша технічна проблема'::text) THEN 1
            ELSE NULL::integer
        END) AS technical_issues,
    count(
        CASE
            WHEN ((st.problem_type)::text = '📞 Екстрена допомога'::text) THEN 1
            ELSE NULL::integer
        END) AS emergency_calls,
    round(avg(st.client_rating), 2) AS avg_rating,
    max(st.created_at) AS last_ticket_date,
    count(
        CASE
            WHEN (st.created_at >= (now() - '30 days'::interval)) THEN 1
            ELSE NULL::integer
        END) AS tickets_last_30_days
   FROM (public.machines m
     LEFT JOIN public.support_tickets st ON ((m.id = st.machine_id)))
  GROUP BY m.id, m.code, m.region, m.street, m.building_number, m.details, m.status;


--
-- Name: water_analyses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.water_analyses (
    id integer NOT NULL,
    machine_id uuid NOT NULL,
    analysis_date date NOT NULL,
    pdf_filename character varying(255) NOT NULL,
    pdf_url text,
    laboratory character varying(100),
    ph_level numeric(3,2),
    tds_ppm integer,
    chlorine_mg_l numeric(4,2),
    bacteria_count integer,
    notes text,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: machine_problem_statistics_extended; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.machine_problem_statistics_extended WITH (security_invoker='on') AS
 SELECT m.id AS machine_id,
    m.code,
    m.region,
    m.street,
    m.building_number,
    m.details,
    concat(m.region, ', вул. ', m.street, ', ', m.building_number,
        CASE
            WHEN (m.details IS NOT NULL) THEN concat(' (', m.details, ')')
            ELSE ''::text
        END) AS full_address,
    m.status AS machine_status,
    count(st.id) AS total_tickets,
    count(
        CASE
            WHEN ((st.problem_type)::text ~~ '%не працює%'::text) THEN 1
            ELSE NULL::integer
        END) AS offline_issues,
    count(
        CASE
            WHEN ((st.problem_type)::text ~~ '%оплатою%'::text) THEN 1
            ELSE NULL::integer
        END) AS payment_issues,
    count(
        CASE
            WHEN ((st.problem_type)::text ~~ '%якість води%'::text) THEN 1
            ELSE NULL::integer
        END) AS water_quality_issues,
    count(
        CASE
            WHEN ((st.problem_type)::text ~~ '%технічна%'::text) THEN 1
            ELSE NULL::integer
        END) AS technical_issues,
    count(
        CASE
            WHEN ((st.problem_type)::text ~~ '%екстрена%'::text) THEN 1
            ELSE NULL::integer
        END) AS emergency_calls,
    count(
        CASE
            WHEN ((st.problem_subcategory)::text = 'no_water_flow'::text) THEN 1
            ELSE NULL::integer
        END) AS no_water_flow_count,
    count(
        CASE
            WHEN ((st.problem_subcategory)::text = 'ozonator_failure'::text) THEN 1
            ELSE NULL::integer
        END) AS ozonator_failure_count,
    count(
        CASE
            WHEN ((st.problem_subcategory)::text = 'no_lights'::text) THEN 1
            ELSE NULL::integer
        END) AS no_lights_count,
    count(
        CASE
            WHEN ((st.problem_subcategory)::text = 'coin_acceptor_failure'::text) THEN 1
            ELSE NULL::integer
        END) AS coin_acceptor_failure_count,
    count(
        CASE
            WHEN ((st.problem_subcategory)::text = 'contactless_failure'::text) THEN 1
            ELSE NULL::integer
        END) AS contactless_failure_count,
    count(
        CASE
            WHEN ((st.problem_subcategory)::text = 'too_much_scale'::text) THEN 1
            ELSE NULL::integer
        END) AS too_much_scale_count,
    count(
        CASE
            WHEN ((st.problem_subcategory)::text = 'strange_taste'::text) THEN 1
            ELSE NULL::integer
        END) AS strange_taste_count,
    count(
        CASE
            WHEN ((st.problem_subcategory)::text = 'chlorine_smell'::text) THEN 1
            ELSE NULL::integer
        END) AS chlorine_smell_count,
    count(
        CASE
            WHEN ((st.problem_subcategory)::text = 'water_turbidity'::text) THEN 1
            ELSE NULL::integer
        END) AS water_turbidity_count,
    round(avg(st.client_rating), 2) AS avg_rating,
    max(st.created_at) AS last_ticket_date,
    count(
        CASE
            WHEN (st.created_at >= (now() - '30 days'::interval)) THEN 1
            ELSE NULL::integer
        END) AS tickets_last_30_days,
    ( SELECT max(wa.analysis_date) AS max
           FROM public.water_analyses wa
          WHERE (wa.machine_id = m.id)) AS last_analysis_date,
    ( SELECT max(fr.replacement_date) AS max
           FROM public.filter_replacements fr
          WHERE (fr.machine_id = m.id)) AS last_filter_replacement
   FROM (public.machines m
     LEFT JOIN public.support_tickets st ON ((m.id = st.machine_id)))
  GROUP BY m.id, m.code, m.region, m.street, m.building_number, m.details, m.status;


--
-- Name: VIEW machine_problem_statistics_extended; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.machine_problem_statistics_extended IS 'Расширенная статистика проблем автоматов с подкатегориями и информацией о качестве воды';


--
-- Name: machine_water_quality; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.machine_water_quality WITH (security_invoker='on') AS
 SELECT m.id AS machine_id,
    m.code AS machine_code,
    m.region,
    m.street,
    m.building_number,
    max(
        CASE
            WHEN ((fr.filter_type)::text = 'pre_filter'::text) THEN fr.replacement_date
            ELSE NULL::date
        END) AS last_pre_filter,
    max(
        CASE
            WHEN ((fr.filter_type)::text = 'carbon_filter'::text) THEN fr.replacement_date
            ELSE NULL::date
        END) AS last_carbon_filter,
    max(
        CASE
            WHEN ((fr.filter_type)::text = 'membrane'::text) THEN fr.replacement_date
            ELSE NULL::date
        END) AS last_membrane,
    max(
        CASE
            WHEN ((fr.filter_type)::text = 'post_carbon'::text) THEN fr.replacement_date
            ELSE NULL::date
        END) AS last_post_carbon,
    max(
        CASE
            WHEN ((fr.filter_type)::text = 'mineralizer'::text) THEN fr.replacement_date
            ELSE NULL::date
        END) AS last_mineralizer,
    max(wa.analysis_date) AS last_analysis_date,
    ( SELECT wa2.pdf_filename
           FROM public.water_analyses wa2
          WHERE (wa2.machine_id = m.id)
          ORDER BY wa2.analysis_date DESC
         LIMIT 1) AS latest_pdf_filename,
    ( SELECT wa2.pdf_url
           FROM public.water_analyses wa2
          WHERE (wa2.machine_id = m.id)
          ORDER BY wa2.analysis_date DESC
         LIMIT 1) AS latest_pdf_url,
    ( SELECT wa2.laboratory
           FROM public.water_analyses wa2
          WHERE (wa2.machine_id = m.id)
          ORDER BY wa2.analysis_date DESC
         LIMIT 1) AS latest_laboratory,
    ( SELECT wa2.ph_level
           FROM public.water_analyses wa2
          WHERE (wa2.machine_id = m.id)
          ORDER BY wa2.analysis_date DESC
         LIMIT 1) AS latest_ph_level,
    ( SELECT wa2.tds_ppm
           FROM public.water_analyses wa2
          WHERE (wa2.machine_id = m.id)
          ORDER BY wa2.analysis_date DESC
         LIMIT 1) AS latest_tds_ppm
   FROM ((public.machines m
     LEFT JOIN public.filter_replacements fr ON ((m.id = fr.machine_id)))
     LEFT JOIN public.water_analyses wa ON ((m.id = wa.machine_id)))
  GROUP BY m.id, m.code, m.region, m.street, m.building_number;


--
-- Name: owners; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.owners (
    owner_id integer NOT NULL,
    last_name character varying(100) NOT NULL,
    first_name character varying(100) NOT NULL,
    patronymic character varying(100),
    ownership_form public.ownership_form NOT NULL,
    mobile_phone character varying(20),
    phone character varying(20),
    email character varying(150),
    residence_address text
);


--
-- Name: machines_with_owner_name; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.machines_with_owner_name WITH (security_invoker='on') AS
 SELECT m.machine_id,
    m.sn_ingenico AS serial_number,
    m.code,
    m.region,
    m.street,
    m.building_number,
    m.details,
    m.telegram_link,
    m.merchant_id,
    o.owner_id AS owner_owner_id,
    concat(o.last_name, ' ', o.first_name) AS owner_name
   FROM (public.machines m
     LEFT JOIN public.owners o ON ((m.owner_id = o.owner_id)));


--
-- Name: machines_with_owners; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.machines_with_owners WITH (security_invoker='on') AS
 SELECT m.machine_id,
    m.sn_ingenico AS serial_number,
    m.code,
    m.region,
    m.street,
    m.building_number,
    m.details,
    m.telegram_link,
    o.owner_id,
    o.last_name,
    o.first_name,
    o.patronymic,
    o.ownership_form,
    o.mobile_phone,
    o.phone,
    o.email,
    o.residence_address
   FROM (public.machines m
     LEFT JOIN public.owners o ON ((m.owner_id = o.owner_id)));


--
-- Name: notification_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notification_log (
    id integer NOT NULL,
    ticket_id integer,
    owner_id integer,
    notification_type character varying(20) NOT NULL,
    status character varying(20) DEFAULT 'pending'::character varying,
    error_message text,
    recipient character varying(255) NOT NULL,
    subject character varying(500),
    message_text text,
    created_at timestamp with time zone DEFAULT now(),
    sent_at timestamp with time zone,
    attempts integer DEFAULT 0,
    external_message_id character varying(100),
    CONSTRAINT notification_log_notification_type_check CHECK (((notification_type)::text = ANY (ARRAY[('email'::character varying)::text, ('telegram'::character varying)::text, ('sms'::character varying)::text]))),
    CONSTRAINT notification_log_status_check CHECK (((status)::text = ANY (ARRAY[('pending'::character varying)::text, ('sent'::character varying)::text, ('failed'::character varying)::text, ('bounced'::character varying)::text])))
);


--
-- Name: TABLE notification_log; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.notification_log IS 'Лог отправленных уведомлений';


--
-- Name: notification_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notification_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notification_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notification_log_id_seq OWNED BY public.notification_log.id;


--
-- Name: owner_notification_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.owner_notification_settings (
    id integer NOT NULL,
    owner_id integer,
    email_enabled boolean DEFAULT true,
    telegram_enabled boolean DEFAULT true,
    sms_enabled boolean DEFAULT false,
    telegram_chat_id bigint,
    notification_hours_start time without time zone DEFAULT '08:00:00'::time without time zone,
    notification_hours_end time without time zone DEFAULT '22:00:00'::time without time zone,
    weekend_notifications boolean DEFAULT true,
    notify_machine_offline boolean DEFAULT true,
    notify_payment_issues boolean DEFAULT true,
    notify_water_quality boolean DEFAULT true,
    notify_other_issues boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: TABLE owner_notification_settings; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.owner_notification_settings IS 'Настройки уведомлений для владельцев автоматов';


--
-- Name: COLUMN owner_notification_settings.telegram_chat_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.owner_notification_settings.telegram_chat_id IS 'Telegram Chat ID владельца для отправки уведомлений';


--
-- Name: owner_notification_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.owner_notification_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: owner_notification_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.owner_notification_settings_id_seq OWNED BY public.owner_notification_settings.id;


--
-- Name: owner_ticket_statistics; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.owner_ticket_statistics WITH (security_invoker='on') AS
 SELECT o.owner_id,
    o.first_name,
    o.last_name,
    o.email,
    count(st.id) AS total_tickets,
    count(
        CASE
            WHEN ((st.status)::text = 'new'::text) THEN 1
            ELSE NULL::integer
        END) AS new_tickets,
    count(
        CASE
            WHEN ((st.status)::text = 'in_progress'::text) THEN 1
            ELSE NULL::integer
        END) AS in_progress_tickets,
    count(
        CASE
            WHEN ((st.status)::text = 'resolved'::text) THEN 1
            ELSE NULL::integer
        END) AS resolved_tickets,
    count(
        CASE
            WHEN ((st.status)::text = 'closed'::text) THEN 1
            ELSE NULL::integer
        END) AS closed_tickets,
    round(avg(st.client_rating), 2) AS avg_rating,
    count(DISTINCT m.id) AS machines_count,
    max(st.created_at) AS last_ticket_date
   FROM ((public.owners o
     LEFT JOIN public.machines m ON ((o.owner_id = m.owner_id)))
     LEFT JOIN public.support_tickets st ON ((m.id = st.machine_id)))
  GROUP BY o.owner_id, o.first_name, o.last_name, o.email;


--
-- Name: owner_ticket_statistics_extended; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.owner_ticket_statistics_extended WITH (security_invoker='on') AS
 SELECT o.owner_id,
    o.first_name,
    o.last_name,
    o.email,
    o.mobile_phone,
    count(st.id) AS total_tickets,
    count(
        CASE
            WHEN ((st.status)::text = 'new'::text) THEN 1
            ELSE NULL::integer
        END) AS new_tickets,
    count(
        CASE
            WHEN ((st.status)::text = 'in_progress'::text) THEN 1
            ELSE NULL::integer
        END) AS in_progress_tickets,
    count(
        CASE
            WHEN ((st.status)::text = 'resolved'::text) THEN 1
            ELSE NULL::integer
        END) AS resolved_tickets,
    count(
        CASE
            WHEN ((st.status)::text = 'closed'::text) THEN 1
            ELSE NULL::integer
        END) AS closed_tickets,
    count(
        CASE
            WHEN ((st.problem_subcategory)::text = 'no_water_flow'::text) THEN 1
            ELSE NULL::integer
        END) AS no_water_flow_tickets,
    count(
        CASE
            WHEN ((st.problem_subcategory)::text = 'ozonator_failure'::text) THEN 1
            ELSE NULL::integer
        END) AS ozonator_failure_tickets,
    count(
        CASE
            WHEN ((st.problem_subcategory)::text = 'coin_acceptor_failure'::text) THEN 1
            ELSE NULL::integer
        END) AS coin_acceptor_tickets,
    count(
        CASE
            WHEN ((st.problem_subcategory)::text = 'contactless_failure'::text) THEN 1
            ELSE NULL::integer
        END) AS contactless_tickets,
    count(
        CASE
            WHEN ((st.problem_subcategory)::text = 'too_much_scale'::text) THEN 1
            ELSE NULL::integer
        END) AS scale_tickets,
    count(
        CASE
            WHEN ((st.problem_subcategory)::text = 'strange_taste'::text) THEN 1
            ELSE NULL::integer
        END) AS taste_tickets,
    round(avg(st.client_rating), 2) AS avg_rating,
    count(DISTINCT m.id) AS machines_count,
    max(st.created_at) AS last_ticket_date,
    ons.email_enabled,
    ons.telegram_enabled,
    ons.telegram_chat_id
   FROM (((public.owners o
     LEFT JOIN public.machines m ON ((o.owner_id = m.owner_id)))
     LEFT JOIN public.support_tickets st ON ((m.id = st.machine_id)))
     LEFT JOIN public.owner_notification_settings ons ON ((o.owner_id = ons.owner_id)))
  GROUP BY o.owner_id, o.first_name, o.last_name, o.email, o.mobile_phone, ons.email_enabled, ons.telegram_enabled, ons.telegram_chat_id;


--
-- Name: VIEW owner_ticket_statistics_extended; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.owner_ticket_statistics_extended IS 'Расширенная статистика заявок владельцев с детализацией по типам проблем';


--
-- Name: owners_owner_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.owners_owner_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: owners_owner_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.owners_owner_id_seq OWNED BY public.owners.owner_id;


--
-- Name: security_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.security_log (
    id integer NOT NULL,
    user_id bigint NOT NULL,
    username text,
    machine_code text,
    action text NOT NULL,
    ip_address text,
    user_agent text,
    success boolean DEFAULT false,
    error_reason text,
    response_time_ms integer,
    session_id text,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: security_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.security_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: security_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.security_log_id_seq OWNED BY public.security_log.id;


--
-- Name: support_tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.support_tickets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: support_tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.support_tickets_id_seq OWNED BY public.support_tickets.id;


--
-- Name: suspicious_activity; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.suspicious_activity (
    id integer NOT NULL,
    user_id bigint,
    activity_type text NOT NULL,
    description text,
    severity text DEFAULT 'medium'::text,
    machine_codes text[],
    request_count integer DEFAULT 1,
    first_seen timestamp with time zone DEFAULT now(),
    last_seen timestamp with time zone DEFAULT now(),
    auto_resolved boolean DEFAULT false
);


--
-- Name: suspicious_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.suspicious_activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: suspicious_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.suspicious_activity_id_seq OWNED BY public.suspicious_activity.id;


--
-- Name: user_blocks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_blocks (
    id integer NOT NULL,
    user_id bigint NOT NULL,
    block_reason text NOT NULL,
    blocked_until timestamp with time zone NOT NULL,
    block_count integer DEFAULT 1,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: user_blocks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_blocks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_blocks_id_seq OWNED BY public.user_blocks.id;


--
-- Name: view_collections_extended; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.view_collections_extended WITH (security_invoker='on') AS
 SELECT c.id,
    c.machine_id,
    m.details,
    m.sn_ingenico AS serial_number,
    m.merchant_id,
    concat_ws(', '::text, m.region, m.street, m.building_number) AS address,
    c.collection_date,
    c.amount
   FROM (public.collections c
     LEFT JOIN public.machines m ON ((m.id = c.machine_id)))
  ORDER BY c.collection_date DESC;


--
-- Name: water_analyses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.water_analyses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: water_analyses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.water_analyses_id_seq OWNED BY public.water_analyses.id;


--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: -
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text
);


--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: objects; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: collections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collections ALTER COLUMN id SET DEFAULT nextval('public.collections_id_seq'::regclass);


--
-- Name: filter_replacements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.filter_replacements ALTER COLUMN id SET DEFAULT nextval('public.filter_replacements_id_seq'::regclass);


--
-- Name: notification_log id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_log ALTER COLUMN id SET DEFAULT nextval('public.notification_log_id_seq'::regclass);


--
-- Name: owner_notification_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.owner_notification_settings ALTER COLUMN id SET DEFAULT nextval('public.owner_notification_settings_id_seq'::regclass);


--
-- Name: owners owner_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.owners ALTER COLUMN owner_id SET DEFAULT nextval('public.owners_owner_id_seq'::regclass);


--
-- Name: security_log id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.security_log ALTER COLUMN id SET DEFAULT nextval('public.security_log_id_seq'::regclass);


--
-- Name: support_tickets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.support_tickets ALTER COLUMN id SET DEFAULT nextval('public.support_tickets_id_seq'::regclass);


--
-- Name: suspicious_activity id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.suspicious_activity ALTER COLUMN id SET DEFAULT nextval('public.suspicious_activity_id_seq'::regclass);


--
-- Name: user_blocks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_blocks ALTER COLUMN id SET DEFAULT nextval('public.user_blocks_id_seq'::regclass);


--
-- Name: water_analyses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.water_analyses ALTER COLUMN id SET DEFAULT nextval('public.water_analyses_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag) FROM stdin;
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
\.


--
-- Data for Name: collections; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.collections (id, machine_id, collection_date, amount) FROM stdin;
\.


--
-- Data for Name: filter_replacements; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.filter_replacements (id, machine_id, replacement_date, filter_type, replaced_by, notes, created_at) FROM stdin;
1	eb2738c9-005b-4275-86b7-6b7fa658a84b	2025-08-01	pre_filter	Сервісний інженер	Планова заміна	2025-08-10 19:58:47.645564+00
2	eb2738c9-005b-4275-86b7-6b7fa658a84b	2025-08-01	carbon_filter	Сервісний інженер	Планова заміна	2025-08-10 19:58:47.645564+00
3	eb2738c9-005b-4275-86b7-6b7fa658a84b	2025-07-15	membrane	Техник	Зниження продуктивності	2025-08-10 19:58:47.645564+00
4	eb2738c9-005b-4275-86b7-6b7fa658a84b	2025-06-20	post_carbon	Сервісний інженер	Планова заміна	2025-08-10 19:58:47.645564+00
5	eb2738c9-005b-4275-86b7-6b7fa658a84b	2025-05-25	mineralizer	Техник	Планова заміна	2025-08-10 19:58:47.645564+00
6	133661da-449b-4efc-ada8-24ca54809f6d	2025-07-25	pre_filter	Сервісний інженер	Планова заміна	2025-08-10 19:58:47.645564+00
7	133661da-449b-4efc-ada8-24ca54809f6d	2025-07-10	carbon_filter	Техник	Помутніння води	2025-08-10 19:58:47.645564+00
8	133661da-449b-4efc-ada8-24ca54809f6d	2025-06-15	membrane	Сервісний інженер	Планова заміна	2025-08-10 19:58:47.645564+00
9	b7257733-86c1-40bd-bca5-eae8c909d768	2025-07-30	pre_filter	Сервісний інженер	Планова заміна	2025-08-10 19:58:47.645564+00
10	b7257733-86c1-40bd-bca5-eae8c909d768	2025-07-05	carbon_filter	Техник	Планова заміна	2025-08-10 19:58:47.645564+00
\.


--
-- Data for Name: machines; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.machines (id, machine_id, sn_ingenico, code, region, street, building_number, details, telegram_link, created_at, owner_id, merchant_id, impulses, sn_controller, firmware, status, last_maintenance, next_maintenance, installation_date, qr_code_url, notes) FROM stdin;
a1b41369-944e-48a7-b014-9584c42dbc10	CV-006		KYYIV_SRIBNOKILSKA_22	Київ	Срібнокільська	22	маг. 'Біле Сухе'	https://t.me/chistavoda_support_bot?start=KYYIV_SRIBNOKILSKA_22	2025-06-27 09:11:45.761273+00	2	\N	\N	\N	\N	active	\N	\N	\N	\N	\N
eb2738c9-005b-4275-86b7-6b7fa658a84b	CV-011	242007333031143756206091\n	IVANO-FRANKIVSK_HALYTSKA_124A	Івано-Франківськ	Галицька	124а	«Джерельце 2»	https://t.me/chistavoda_support_bot?start=IVANO-FRANKIVSK_HALYTSKA_124A	2025-06-27 09:11:45.761273+00	1	ABRET0000030002  	508	02503235	TWO ST VER. 8.1c	active	\N	\N	\N	\N	\N
133661da-449b-4efc-ada8-24ca54809f6d	CV-012	242007333031143756205888\n	IVANO-FRANKIVSK_TROLEYBUSNA_32	Івано-Франківськ	Тролейбусна	32	«Джерельце 1»	https://t.me/chistavoda_support_bot?start=IVANO-FRANKIVSK_TROLEYBUSNA_32	2025-06-27 09:11:45.761273+00	1	ABRET0000031512 	523	02505241	TWO ST VER. 8.1c	active	\N	\N	\N	\N	\N
4cb7b6a0-197b-4c6e-979f-58b60af0ac74	CV-007		KYYIV_SCHUSYEVA_10	Київ	Щусєва	10	поруч з супермаркетом АТБ	https://t.me/chistavoda_support_bot?start=KYYIV_SCHUSYEVA_10	2025-06-27 09:11:45.761273+00	6	\N	\N	\N	\N	active	\N	\N	\N	\N	\N
4c674f0b-02a1-4646-ae76-ce14e0b9d1ec	CV-001		BUCHA_BORYSA_10а	Буча	Бориса Гмирі	10а	ЖК 'Буча Квартал', пекарня 'Дім Буланжері'	https://t.me/chistavoda_support_bot?start=BUCHA_BORYSA_10а	2025-06-27 09:11:45.761273+00	3	\N	\N	\N	\N	active	\N	\N	\N	\N	\N
b7257733-86c1-40bd-bca5-eae8c909d768	CV-010	241847333031195356071651\n	BUCHA_LESI_3	Буча	Лесі Українки	3	ЖК 'Гранд Бурже', маг. 'Біле Сухе'	https://t.me/chistavoda_support_bot?start=BUCHA_LESI_3	2025-06-27 09:11:45.761273+00	2	ABRET0000027858\n	\N	02507242	TWO ST VER. 8.1e	active	\N	\N	\N	\N	\N
65a1afa4-931b-49c8-86ef-56db0e2dbc79	CV-009	223417323031195328341502\n	KYYIV_VIKTORA_10	Київ	Віктора Некрасова	10	ЖК "Діброва Парк"	https://t.me/chistavoda_support_bot?start=KYYIV_VIKTORA_10	2025-06-27 09:11:45.761273+00	4	ABRET0000031230\n	\N	\N	TWO ST VER. 8.1e	active	\N	\N	\N	\N	\N
10e4a8c9-b464-42aa-b2b3-e75d5243ab14	CV-002		BUCHA_BORYSA_18	Буча	Бориса Гмирі	18	ЖК 'Буча Квартал', навпроти магазину 'Лоток'	https://t.me/chistavoda_support_bot?start=BUCHA_BORYSA_18	2025-06-27 09:11:45.761273+00	5	\N	\N	\N	\N	active	\N	\N	\N	\N	\N
3f945d01-a199-450f-87da-51bdf14ab354	CV-021	223417323031195328340965	KYIV_RUSANIVSKYI_BULVAR_2	Київ	Русанівскьий бульвар	2/8	Русанівка	https://t.me/chistavoda_support_bot?start=KYIV_RUSANIVSKYI_BULVAR_2	2025-08-09 13:19:46.129382+00	2	\N	520	02504239	TWO ST VER.8.1.e	active	\N	\N	\N		\N
9605c6d0-b543-4d6c-b46d-e2a9ce8a0282	CV-013	223417323031195328340965	KYIV_ENTUZIASTIV_37	Київ\n	Ентузіастів	37	Руса́нівка, маг. "Біле Сухе"	https://t.me/chistavoda_support_bot?start=KYIV_ENTUZIASTIV_37\n	2025-07-18 10:20:12.384263+00	2	\N	520	02504238	TWO ST VER. 8.1e	active	\N	\N	\N	\N	\N
715aadf0-bc66-4731-852c-ebbbe32274e3	CV-003		IRPIN_ZAKHIDNA_8	Ірпінь	Західна	8	ЖК 'Річ Таун', маг. 'Біле Сухе'	https://t.me/chistavoda_support_bot?start=IRPIN_ZAKHIDNA_8	2025-06-27 09:11:45.761273+00	3	\N	\N	\N	\N	active	\N	\N	\N	\N	\N
78238737-d13f-4c70-b76f-f35008d1e307	CV-004		KYYIV_BAZHANA_16	Київ	Бажана	16	біля супермаркету 'Varus'	https://t.me/chistavoda_support_bot?start=KYYIV_BAZHANA_16	2025-06-27 09:11:45.761273+00	2	\N	\N	\N	\N	active	\N	\N	\N	\N	\N
543c2653-b50c-4df0-a107-012b45bcf3bc	CV-005		KYYIV_BAZHANA_26	Київ	Бажана	26		https://t.me/chistavoda_support_bot?start=KYYIV_BAZHANA_26	2025-06-27 09:11:45.761273+00	2	\N	\N	\N	\N	active	\N	\N	\N	\N	\N
69d5efe7-56d5-45e8-8d05-455f712f4069	CV-008		KYYIV_OLZHYCHA_3	Київ	Ольжича	3	біля Аптеки	https://t.me/chistavoda_support_bot?start=KYYIV_OLZHYCHA_3	2025-06-27 09:11:45.761273+00	6	\N	\N	\N	\N	active	\N	\N	\N	\N	\N
\.


--
-- Data for Name: notification_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.notification_log (id, ticket_id, owner_id, notification_type, status, error_message, recipient, subject, message_text, created_at, sent_at, attempts, external_message_id) FROM stdin;
\.


--
-- Data for Name: owner_notification_settings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.owner_notification_settings (id, owner_id, email_enabled, telegram_enabled, sms_enabled, telegram_chat_id, notification_hours_start, notification_hours_end, weekend_notifications, notify_machine_offline, notify_payment_issues, notify_water_quality, notify_other_issues, created_at, updated_at) FROM stdin;
2	1	t	t	f	\N	08:00:00	22:00:00	t	t	t	t	t	2025-07-19 15:51:40.280483+00	2025-07-19 15:51:40.280483+00
3	4	t	t	f	\N	08:00:00	22:00:00	t	t	t	t	t	2025-07-19 15:51:40.280483+00	2025-07-19 15:51:40.280483+00
4	3	t	t	f	684742993	08:00:00	22:00:00	t	t	t	t	t	2025-08-16 22:41:21.00233+00	2025-08-16 22:41:21.00233+00
1	2	t	t	f	\N	08:00:00	22:00:00	t	t	t	t	t	2025-07-19 15:51:40.280483+00	2025-08-16 22:57:31.558093+00
\.


--
-- Data for Name: owners; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.owners (owner_id, last_name, first_name, patronymic, ownership_form, mobile_phone, phone, email, residence_address) FROM stdin;
2	Дзонь	Олександр	Валентинович	ФОП	+380503285042	\N	dzonalg@gmail.com	Київ
4	Лобадзе	Олександр	\N	ФОП	+380501314999	\N	andruhov.anton@gmail.com	Київ
3	Андрухов	Антон	Валерьевич	ФОП	+380506221811	\N	andruhov.anton@gmail.com	Буча
1	Назарько	Євген	Євгенович	ФОП	+380509845525	\N	eenazar81@gmail.com	Івано-Франківськ
5	Андрухов	Євген	Валерійович	ФОП	+380509080518	\N	andruhov.evgeniy@gmail.com	Буча
6	Жук	Вадим	Анатолійович	ФОП	+38‭0502562607‬	\N	zhuk.vodoley@gmail.com	Київ
\.


--
-- Data for Name: security_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.security_log (id, user_id, username, machine_code, action, ip_address, user_agent, success, error_reason, response_time_ms, session_id, created_at) FROM stdin;
2	684742993	Антон Андрухов	\N	start_command_hybrid	\N	\N	t	\N	780	\N	2025-08-11 11:48:05.242129+00
4	684742993	Антон Андрухов	\N	start_command_hybrid	\N	\N	t	\N	612	\N	2025-08-11 11:56:19.84909+00
5	123456	Test User	BUCHA_LESI_3	GET_MACHINE	\N	\N	t	\N	21	\N	2025-08-11 23:59:56.498514+00
6	684742993	Антон Андрухов	BUCHA_LESI_3	GET_MACHINE	\N	TelegramBot/684742993	t	\N	1	\N	2025-08-12 00:01:13.938904+00
7	684742993	Антон Андрухов	BUCHA_LESI_3	start_command_hybrid	\N	\N	t	\N	831	\N	2025-08-12 00:01:14.806727+00
8	684742993	Антон Андрухов	BUCHA_LESI_3	start_command_hybrid	\N	\N	t	\N	270	\N	2025-08-12 00:02:33.245768+00
9	684742993	Антон Андрухов	BUCHA_LESI_3	GET_MACHINE	\N	TelegramBot/684742993	t	\N	1	\N	2025-08-12 00:02:50.361337+00
10	684742993	Антон Андрухов	BUCHA_LESI_3	start_command_hybrid	\N	\N	t	\N	743	\N	2025-08-12 00:02:50.992127+00
11	684742993	Антон Андрухов	BUCHA_LESI_3	GET_MACHINE	\N	TelegramBot/684742993	t	\N	5	\N	2025-08-12 00:24:48.133204+00
12	684742993	Антон Андрухов	BUCHA_LESI_3	start_command_hybrid	\N	\N	t	\N	641	\N	2025-08-12 00:24:48.796621+00
13	684742993	Антон Андрухов	BUCHA_LESI_3	start_command_hybrid	\N	\N	t	\N	235	\N	2025-08-12 00:25:07.517103+00
14	684742993	Антон Андрухов	BUCHA_LESI_3	start_command_hybrid	\N	\N	f	Can't parse entities: unsupported start tag "user_id" at byte offset 196	226	\N	2025-08-12 00:29:47.896066+00
\.


--
-- Data for Name: support_tickets; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.support_tickets (id, ticket_number, user_id, user_name, user_phone, problem_type, problem_description, machine_id, status, priority, assigned_to, resolution_notes, created_at, updated_at, resolved_at, photo_urls, client_rating, problem_subcategory, severity_level, problem_level3, comments) FROM stdin;
2	ST-2025-TEST01	123456789	Тестовый Пользователь	+380501234567	water_quality	Тестовая проблема - странный привкус воды	10e4a8c9-b464-42aa-b2b3-e75d5243ab14	new	normal	\N	\N	2025-08-09 15:51:02.165387+00	2025-08-09 15:51:02.165387+00	\N	\N	\N	\N	normal	\N	[]
4	ST-2025-TEST02	123456789	Тестовый Пользователь	+380501234567	water_quality	Тестовая проблема - странный привкус воды	10e4a8c9-b464-42aa-b2b3-e75d5243ab14	new	normal	\N	\N	2025-08-09 15:52:24.991622+00	2025-08-09 15:52:24.991622+00	\N	\N	\N	\N	normal	\N	[]
7	ST-2025-0001	684742993	Антон Андрухов	+380506221811	🚫 Автомат не працює	\N	b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-10 17:41:53.490155+00	2025-08-10 17:41:53.490155+00	\N	\N	\N	\N	normal	\N	[]
8	ST-2025-0002	684742993	Антон Андрухов	+380506221811	🚫 Автомат не працює	Не работает налив	b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-10 19:01:28.822747+00	2025-08-10 19:01:28.822747+00	\N	\N	\N	\N	normal	\N	[]
9	ST-2025-0003	684742993	Антон Андрухов	+380506221811	💳 Проблема з оплатою	Забит Монетник	b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-10 19:12:20.958827+00	2025-08-10 19:12:20.958827+00	\N	\N	\N	\N	normal	\N	[]
10	ST-2025-0004	684742993	Антон Андрухов	+380506221811	💦 Погана якість води → Багато накипу	При кипячении много налета	b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-10 20:00:47.700588+00	2025-08-10 20:00:47.700588+00	\N	\N	\N	too_much_scale	normal	\N	[]
11	ST-2025-0005	684742993	Антон Андрухов	+380506221811	💳 Проблема з оплатою → Не працює монетоприймач	Застрягли монети	b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-10 20:05:23.928375+00	2025-08-10 20:05:23.928375+00	\N	\N	\N	coin_acceptor_failure	normal	\N	[]
12	ST-2025-0006	684742993	Антон Андрухов	+380506221811	💦 Погана якість води → Багато накипу	Накипь	b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-10 20:31:05.460233+00	2025-08-10 20:31:05.460233+00	\N	\N	\N	too_much_scale	normal	\N	[]
13	ST-2025-0007	684742993	Антон Андрухов	+380506221811	🚫 Автомат не працює → 🚰 Не працює налив → 💧 Недоливає	100 мл	b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	\N	\N	2025-08-12 04:12:58.45511+00	2025-08-12 04:12:58.455133+00	\N	\N	\N	\N	normal	\N	[]
14	ST-2025-0008	684742993	Антон Андрухов	+380506221811	💳 Проблема з оплатою → 🪙 Не працює монетоприймач → 🧾 Не видав фіскальний чек	Детальний опис не надано	b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	\N	\N	2025-08-12 04:28:34.079638+00	2025-08-12 04:28:34.079659+00	\N	\N	\N	\N	normal	\N	[]
16	ST-2025-0009	684742993	Антон Андрухов	+380504312412	💳 Проблема з оплатою → 💵 Не працює купюроприймач → 🚫 Не приймає купюри	Детальний опис не надано	b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	\N	\N	2025-08-12 04:58:42.592088+00	2025-08-12 04:58:42.592108+00	\N	\N	\N	\N	normal	\N	[]
17	ST-2025-0010	684742993	Антон Андрухов	+380506221811	💳 Проблема з оплатою	Не рахуe монети	b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-12 23:15:06.273021+00	2025-08-12 23:15:06.273021+00	\N	\N	\N	coin_acceptor_failure	normal	\N	[]
18	ST-2025-0011	684742993	Антон Андрухов	+380506221811	Автомат не працює	Нет запаха озона	b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-13 20:46:48.427195+00	2025-08-13 20:46:48.427195+00	\N	\N	\N	ozonator_failure	normal	\N	[]
19	ST-2025-0012	684742993	Антон Андрухов	+380506221811	🚫 Автомат не працює	1	b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-13 21:45:36.443553+00	2025-08-13 21:45:36.443553+00	\N	\N	\N	no_water_flow	normal	\N	[]
20	ST-2025-0013	684742993	Антон Андрухов	+380506221811	🚫 Автомат не працює	12	b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-14 15:23:57.640657+00	2025-08-14 15:23:57.640657+00	\N	\N	\N	no_water_flow	normal	\N	[]
21	ST-2025-0014	684742993	Антон Андрухов	+380506221811	🚫 Автомат не працює → Не працює налив	12	b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-14 16:13:49.287692+00	2025-08-14 16:13:49.287692+00	\N	\N	\N	no_water_flow	normal	\N	[]
22	ST-2025-0015	684742993	Антон Андрухов	+380506221811	💳 Проблема з оплатою → Не працює безконтактна оплата	12	b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-14 16:37:40.610962+00	2025-08-14 16:37:40.610962+00	\N	\N	\N	contactless_failure	normal	\N	[]
23	ST-2025-0016	684742993	Антон Андрухов	+380506221811	🚫 Автомат не працює → Автомат не світиться	123	b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-14 16:48:53.462608+00	2025-08-14 16:48:53.462608+00	\N	\N	\N	no_lights	normal	\N	[]
24	ST-2025-0017	684742993	Антон Андрухов	+380506221811	💳 Проблема з оплатою → Не працює монетоприймач		b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-14 17:42:36.611224+00	2025-08-14 17:42:36.611224+00	\N	\N	\N	coin_acceptor_failure	normal	\N	[]
25	ST-2025-0018	684742993	Антон Андрухов	+380506221811	🚫 Автомат не працює → Автомат не світиться	Не горит подсветка	b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-14 17:50:30.737603+00	2025-08-14 17:50:30.737603+00	\N	\N	\N	no_lights	normal	\N	[]
26	ST-2025-0019	684742993	Антон Андрухов	+380506221811	Невідома проблема		b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-14 17:58:18.849134+00	2025-08-14 17:58:18.849134+00	\N	\N	\N	\N	normal	\N	[]
28	ST-2025-0020	684742993	Антон Андрухов	+380506221811	🚫 Автомат не працює → Не працює налив	Не доливає	b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-14 18:10:48.954497+00	2025-08-14 18:10:48.954497+00	\N	\N	\N	no_water_flow	normal	\N	[]
29	ST-2025-0021	684742993	Антон Андрухов	+380506221811	💦 Погана якість води → Є сторонній присмак		b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-14 19:55:49.092108+00	2025-08-14 19:55:49.092108+00	\N	\N	\N	\N	normal	\N	[]
30	ST-2025-0022	684742993	Антон Андрухов	+380506221811	🚫 Автомат не працює → Не працює налив		b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-14 20:29:45.990775+00	2025-08-14 20:29:45.990775+00	\N	\N	\N	\N	normal	\N	[]
31	ST-2025-0023	684742993	Антон Андрухов	380506221811	water_quality	Много солей	b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-14 21:30:22.915269+00	2025-08-14 21:30:22.915269+00	\N	\N	\N	too_much_scale	normal	\N	[]
32	ST-2025-0024	684742993	Антон Андрухов	380506221811	payment_issue		b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-14 21:32:46.941556+00	2025-08-14 21:32:46.941556+00	\N	\N	\N	coin_acceptor_failure	normal	\N	[]
33	ST-2025-0025	684742993	Антон Андрухов	380506221811	water_quality		b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-14 21:35:15.221757+00	2025-08-14 21:35:15.221757+00	\N	\N	\N	too_much_scale	normal	\N	[]
34	ST-2025-0026	684742993	Антон Андрухов	+380506221811	💦 Погана якість води → Є запах хлору		b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-14 22:34:22.355013+00	2025-08-14 22:34:22.355013+00	\N	\N	\N	\N	normal	\N	[]
35	ST-2025-0027	684742993	Антон Андрухов	380506221811	payment_issue		b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-14 22:50:20.796564+00	2025-08-14 22:50:20.796564+00	\N	\N	\N	coin_acceptor_failure	normal	swallows_coins_no_credit	[]
36	ST-2025-0028	684742993	Антон Андрухов	380506221811	water_quality		b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-14 22:51:26.581951+00	2025-08-14 22:51:26.581951+00	\N	\N	\N	strange_taste	normal	bitter_taste	[]
37	ST-2025-0029	684742993	Антон Андрухов	380506221811	emergency		b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-14 22:53:20.142273+00	2025-08-14 22:53:20.142273+00	\N	\N	\N	critical_situations	normal	machine_danger	[]
38	ST-2025-0030	684742993	Антон Андрухов	380506221811	payment_issue		b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-14 22:56:24.454261+00	2025-08-14 22:56:24.454261+00	\N	\N	\N	contactless_failure	normal	slow_processing	[]
39	ST-2025-0031	684742993	Антон Андрухов	380506221811	machine_offline		b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-14 22:57:36.961024+00	2025-08-14 22:57:36.961024+00	\N	\N	\N	ozonator_failure	normal	no_ozone_smell	[]
40	ST-2025-0032	684742993	Антон Андрухов	380506221811	machine_offline		b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-14 23:14:21.667079+00	2025-08-14 23:14:21.667079+00	\N	\N	\N	no_water_flow	normal	water_flows_slowly	[]
41	ST-2025-0033	684742993	Антон Андрухов	380506221811	water_quality		b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-14 23:15:39.737684+00	2025-08-14 23:15:39.737684+00	\N	\N	\N	too_much_scale	normal	scale_after_boiling	[]
42	ST-2025-0034	684742993	Антон Андрухов	380506221811	water_quality		b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-15 19:21:25.907447+00	2025-08-15 19:21:25.907447+00	\N	\N	\N	strange_taste	normal	metallic_taste	[]
43	ST-2025-0035	684742993	Антон Андрухов	380506221811	payment_issue		10e4a8c9-b464-42aa-b2b3-e75d5243ab14	new	normal	\N	\N	2025-08-15 19:51:18.0379+00	2025-08-15 19:51:18.0379+00	\N	\N	\N	contactless_failure	normal	double_charging	[]
44	ST-2025-0036	684742993	Антон Андрухов	380506221811	emergency		a1b41369-944e-48a7-b014-9584c42dbc10	new	normal	\N	\N	2025-08-15 20:05:01.816998+00	2025-08-15 20:05:01.816998+00	\N	\N	\N	critical_situations	normal	water_flood	[]
45	ST-2025-0037	684742993	Антон Андрухов	380506221811	machine_offline		10e4a8c9-b464-42aa-b2b3-e75d5243ab14	new	normal	\N	\N	2025-08-15 20:06:17.62528+00	2025-08-15 20:06:17.62528+00	\N	\N	\N	no_water_flow	normal	water_not_stopping	[]
46	ST-2025-0038	684742993	Антон Андрухов	380506221811	water_quality		69d5efe7-56d5-45e8-8d05-455f712f4069	new	normal	6	\N	2025-08-15 23:41:08.490098+00	2025-08-15 23:41:08.490098+00	\N	\N	\N	water_turbidity	normal	particles_in_water	[]
47	ST-2025-0039	684742993	Антон Андрухов	380506221811	machine_offline		69d5efe7-56d5-45e8-8d05-455f712f4069	new	normal	6	\N	2025-08-15 23:42:59.643333+00	2025-08-15 23:42:59.643333+00	\N	\N	\N	no_water_flow	normal	no_water_at_all	[]
48	ST-2025-0040	684742993	Антон Андрухов	380506221811	payment_issue		4cb7b6a0-197b-4c6e-979f-58b60af0ac74	new	normal	6	\N	2025-08-15 23:48:27.84293+00	2025-08-15 23:48:27.84293+00	\N	\N	\N	contactless_failure	normal	double_charging	[]
49	ST-2025-0041	85667385	Even A	380509080518	payment_issue		543c2653-b50c-4df0-a107-012b45bcf3bc	new	normal	2	\N	2025-08-16 09:27:00.759026+00	2025-08-16 09:27:00.759026+00	\N	\N	\N	coin_acceptor_failure	normal	coins_stuck	[]
50	ST-2025-0042	85667385	Even A	380509080518	water_quality		10e4a8c9-b464-42aa-b2b3-e75d5243ab14	new	normal	5	\N	2025-08-16 09:28:08.194294+00	2025-08-16 09:28:08.194294+00	\N	\N	\N	too_much_scale	normal	white_residue_container	[]
51	ST-2025-0043	85667385	Even A	380509080518	machine_offline		543c2653-b50c-4df0-a107-012b45bcf3bc	new	normal	2	\N	2025-08-16 09:30:03.769168+00	2025-08-16 09:30:03.769168+00	\N	\N	\N	no_water_flow	normal	no_water_at_all	[]
52	ST-2025-0044	85667385	Even A	380509080518	payment_issue		10e4a8c9-b464-42aa-b2b3-e75d5243ab14	new	normal	5	\N	2025-08-16 09:30:42.174789+00	2025-08-16 09:30:42.174789+00	\N	\N	\N	contactless_failure	normal	cancelled_not_charged	[]
53	ST-2025-0045	85667385	Even A	380509080518	machine_offline		10e4a8c9-b464-42aa-b2b3-e75d5243ab14	new	normal	5	\N	2025-08-16 09:42:37.740049+00	2025-08-16 09:42:37.740049+00	\N	\N	\N	no_water_flow	normal	no_water_at_all	[]
54	ST-2025-0046	684742993	Антон Андрухов	380506221811	machine_offline		b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-16 22:43:34.931721+00	2025-08-16 22:43:34.931721+00	\N	\N	\N	ozonator_failure	normal	no_ozone_smell	[]
56	ST-2025-0047	684742993	Антон Андрухов	380506221811			715aadf0-bc66-4731-852c-ebbbe32274e3	new	normal	3	\N	2025-08-17 03:03:38.443544+00	2025-08-17 00:03:38.582966+00	\N	\N	\N	no_water_flow	normal	no_water_at_all	[]
57	ST-2025-0048	684742993	Антон Андрухов	380506221811			715aadf0-bc66-4731-852c-ebbbe32274e3	new	normal	3	\N	2025-08-17 03:17:01.697124+00	2025-08-17 00:17:01.80144+00	\N	\N	\N	too_much_scale	normal	scale_after_boiling	[]
58	ST-2025-0049	684742993	Антон Андрухов	380506221811			715aadf0-bc66-4731-852c-ebbbe32274e3	new	normal	3	\N	2025-08-17 03:17:11.66234+00	2025-08-17 00:17:11.773813+00	\N	\N	\N	too_much_scale	normal	scale_after_boiling	[]
59	ST-2025-0050	684742993	Антон Андрухов	380506221811			715aadf0-bc66-4731-852c-ebbbe32274e3	new	normal	3	\N	2025-08-17 03:17:34.175583+00	2025-08-17 00:17:34.292085+00	\N	\N	\N	water_turbidity	normal	water_cloudy_immediately	[]
60	ST-2025-0051	684742993	Антон Андрухов	380506221811	water_quality		b7257733-86c1-40bd-bca5-eae8c909d768	new	normal	2	\N	2025-08-17 00:27:46.809998+00	2025-08-17 00:27:46.809998+00	\N	\N	\N	too_much_scale	normal	white_residue_container	[]
\.


--
-- Data for Name: suspicious_activity; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.suspicious_activity (id, user_id, activity_type, description, severity, machine_codes, request_count, first_seen, last_seen, auto_resolved) FROM stdin;
\.


--
-- Data for Name: user_blocks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_blocks (id, user_id, block_reason, blocked_until, block_count, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: water_analyses; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.water_analyses (id, machine_id, analysis_date, pdf_filename, pdf_url, laboratory, ph_level, tds_ppm, chlorine_mg_l, bacteria_count, notes, created_at) FROM stdin;
1	eb2738c9-005b-4275-86b7-6b7fa658a84b	2025-08-05	analysis_CV011_2025-08-05.pdf	https://storage.supabase.co/analyses/analysis_CV011_2025-08-05.pdf	Лабораторія "Чиста Вода"	7.20	45	0.02	\N	Відмінна якість	2025-08-10 19:58:47.645564+00
2	eb2738c9-005b-4275-86b7-6b7fa658a84b	2025-07-01	analysis_CV011_2025-07-01.pdf	https://storage.supabase.co/analyses/analysis_CV011_2025-07-01.pdf	Лабораторія "Чиста Вода"	7.10	50	0.03	\N	Хороша якість	2025-08-10 19:58:47.645564+00
3	133661da-449b-4efc-ada8-24ca54809f6d	2025-07-28	analysis_CV012_2025-07-28.pdf	https://storage.supabase.co/analyses/analysis_CV012_2025-07-28.pdf	Лабораторія "Чиста Вода"	7.30	42	0.01	\N	Відмінна якість	2025-08-10 19:58:47.645564+00
4	b7257733-86c1-40bd-bca5-eae8c909d768	2025-08-02	analysis_CV010_2025-08-02.pdf	https://storage.supabase.co/analyses/analysis_CV010_2025-08-02.pdf	Лабораторія "Еко-Аналіз"	7.00	48	0.02	\N	Хороша якість	2025-08-10 19:58:47.645564+00
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2025-06-26 21:23:02
20211116045059	2025-06-26 21:23:05
20211116050929	2025-06-26 21:23:07
20211116051442	2025-06-26 21:23:09
20211116212300	2025-06-26 21:23:11
20211116213355	2025-06-26 21:23:13
20211116213934	2025-06-26 21:23:15
20211116214523	2025-06-26 21:23:17
20211122062447	2025-06-26 21:23:19
20211124070109	2025-06-26 21:23:21
20211202204204	2025-06-26 21:23:23
20211202204605	2025-06-26 21:23:25
20211210212804	2025-06-26 21:23:31
20211228014915	2025-06-26 21:23:33
20220107221237	2025-06-26 21:23:35
20220228202821	2025-06-26 21:23:37
20220312004840	2025-06-26 21:23:38
20220603231003	2025-06-26 21:23:41
20220603232444	2025-06-26 21:23:43
20220615214548	2025-06-26 21:23:45
20220712093339	2025-06-26 21:23:47
20220908172859	2025-06-26 21:23:49
20220916233421	2025-06-26 21:23:51
20230119133233	2025-06-26 21:23:53
20230128025114	2025-06-26 21:23:56
20230128025212	2025-06-26 21:23:58
20230227211149	2025-06-26 21:23:59
20230228184745	2025-06-26 21:24:01
20230308225145	2025-06-26 21:24:03
20230328144023	2025-06-26 21:24:05
20231018144023	2025-06-26 21:24:07
20231204144023	2025-06-26 21:24:10
20231204144024	2025-06-26 21:24:12
20231204144025	2025-06-26 21:24:14
20240108234812	2025-06-26 21:24:16
20240109165339	2025-06-26 21:24:18
20240227174441	2025-06-26 21:24:21
20240311171622	2025-06-26 21:24:24
20240321100241	2025-06-26 21:24:28
20240401105812	2025-06-26 21:24:33
20240418121054	2025-06-26 21:24:36
20240523004032	2025-06-26 21:24:42
20240618124746	2025-06-26 21:24:44
20240801235015	2025-06-26 21:24:46
20240805133720	2025-06-26 21:24:48
20240827160934	2025-06-26 21:24:50
20240919163303	2025-06-26 21:24:52
20240919163305	2025-06-26 21:24:54
20241019105805	2025-06-26 21:24:56
20241030150047	2025-06-26 21:25:03
20241108114728	2025-06-26 21:25:06
20241121104152	2025-06-26 21:25:08
20241130184212	2025-06-26 21:25:10
20241220035512	2025-06-26 21:25:12
20241220123912	2025-06-26 21:25:14
20241224161212	2025-06-26 21:25:15
20250107150512	2025-06-26 21:25:17
20250110162412	2025-06-26 21:25:19
20250123174212	2025-06-26 21:25:21
20250128220012	2025-06-26 21:25:23
20250506224012	2025-06-26 21:25:24
20250523164012	2025-06-26 21:25:26
20250714121412	2025-07-18 10:15:05
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2025-06-26 21:22:59.581978
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2025-06-26 21:22:59.590693
2	storage-schema	5c7968fd083fcea04050c1b7f6253c9771b99011	2025-06-26 21:22:59.59701
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2025-06-26 21:22:59.620095
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2025-06-26 21:22:59.632693
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2025-06-26 21:22:59.639318
6	change-column-name-in-get-size	f93f62afdf6613ee5e7e815b30d02dc990201044	2025-06-26 21:22:59.646894
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2025-06-26 21:22:59.653854
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2025-06-26 21:22:59.660597
9	fix-search-function	3a0af29f42e35a4d101c259ed955b67e1bee6825	2025-06-26 21:22:59.667513
10	search-files-search-function	68dc14822daad0ffac3746a502234f486182ef6e	2025-06-26 21:22:59.674496
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2025-06-26 21:22:59.681803
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2025-06-26 21:22:59.690746
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2025-06-26 21:22:59.697687
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2025-06-26 21:22:59.705354
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2025-06-26 21:22:59.727409
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2025-06-26 21:22:59.734411
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2025-06-26 21:22:59.741277
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2025-06-26 21:22:59.748541
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2025-06-26 21:22:59.757662
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2025-06-26 21:22:59.764749
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2025-06-26 21:22:59.773614
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2025-06-26 21:22:59.788806
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2025-06-26 21:22:59.802493
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2025-06-26 21:22:59.809378
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2025-06-26 21:22:59.81625
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: -
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: -
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 1, false);


--
-- Name: collections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.collections_id_seq', 1, false);


--
-- Name: filter_replacements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.filter_replacements_id_seq', 10, true);


--
-- Name: machine_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.machine_id_seq', 21, true);


--
-- Name: notification_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.notification_log_id_seq', 1, false);


--
-- Name: owner_notification_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.owner_notification_settings_id_seq', 3, true);


--
-- Name: owners_owner_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.owners_owner_id_seq', 4, true);


--
-- Name: security_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.security_log_id_seq', 14, true);


--
-- Name: support_tickets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.support_tickets_id_seq', 65, true);


--
-- Name: suspicious_activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.suspicious_activity_id_seq', 1, false);


--
-- Name: user_blocks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_blocks_id_seq', 1, false);


--
-- Name: water_analyses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.water_analyses_id_seq', 4, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: -
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: collections collections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (id);


--
-- Name: filter_replacements filter_replacements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.filter_replacements
    ADD CONSTRAINT filter_replacements_pkey PRIMARY KEY (id);


--
-- Name: machines machines_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.machines
    ADD CONSTRAINT machines_code_key UNIQUE (code);


--
-- Name: machines machines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.machines
    ADD CONSTRAINT machines_pkey PRIMARY KEY (id);


--
-- Name: notification_log notification_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_log
    ADD CONSTRAINT notification_log_pkey PRIMARY KEY (id);


--
-- Name: owner_notification_settings owner_notification_settings_owner_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.owner_notification_settings
    ADD CONSTRAINT owner_notification_settings_owner_id_key UNIQUE (owner_id);


--
-- Name: owner_notification_settings owner_notification_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.owner_notification_settings
    ADD CONSTRAINT owner_notification_settings_pkey PRIMARY KEY (id);


--
-- Name: owners owners_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_pkey PRIMARY KEY (owner_id);


--
-- Name: security_log security_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.security_log
    ADD CONSTRAINT security_log_pkey PRIMARY KEY (id);


--
-- Name: support_tickets support_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_pkey PRIMARY KEY (id);


--
-- Name: support_tickets support_tickets_ticket_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_ticket_number_key UNIQUE (ticket_number);


--
-- Name: suspicious_activity suspicious_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.suspicious_activity
    ADD CONSTRAINT suspicious_activity_pkey PRIMARY KEY (id);


--
-- Name: filter_replacements unique_machine_filter_date; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.filter_replacements
    ADD CONSTRAINT unique_machine_filter_date UNIQUE (machine_id, filter_type, replacement_date);


--
-- Name: user_blocks user_blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_blocks
    ADD CONSTRAINT user_blocks_pkey PRIMARY KEY (id);


--
-- Name: user_blocks user_blocks_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_blocks
    ADD CONSTRAINT user_blocks_user_id_key UNIQUE (user_id);


--
-- Name: water_analyses water_analyses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.water_analyses
    ADD CONSTRAINT water_analyses_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: idx_filter_replacements_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_filter_replacements_date ON public.filter_replacements USING btree (replacement_date DESC);


--
-- Name: idx_filter_replacements_machine_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_filter_replacements_machine_id ON public.filter_replacements USING btree (machine_id);


--
-- Name: idx_machines_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_machines_status ON public.machines USING btree (status);


--
-- Name: idx_notification_log_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notification_log_created_at ON public.notification_log USING btree (created_at DESC);


--
-- Name: idx_notification_log_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notification_log_status ON public.notification_log USING btree (status);


--
-- Name: idx_notification_log_ticket_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notification_log_ticket_id ON public.notification_log USING btree (ticket_id);


--
-- Name: idx_security_log_action_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_security_log_action_time ON public.security_log USING btree (action, created_at DESC);


--
-- Name: idx_security_log_machine_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_security_log_machine_time ON public.security_log USING btree (machine_code, created_at DESC);


--
-- Name: idx_security_log_success; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_security_log_success ON public.security_log USING btree (success, created_at DESC);


--
-- Name: idx_security_log_user_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_security_log_user_time ON public.security_log USING btree (user_id, created_at DESC);


--
-- Name: idx_support_tickets_assigned_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_support_tickets_assigned_status ON public.support_tickets USING btree (assigned_to, status) WHERE (assigned_to IS NOT NULL);


--
-- Name: idx_support_tickets_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_support_tickets_created_at ON public.support_tickets USING btree (created_at DESC);


--
-- Name: idx_support_tickets_machine_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_support_tickets_machine_id ON public.support_tickets USING btree (machine_id);


--
-- Name: idx_support_tickets_machine_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_support_tickets_machine_status ON public.support_tickets USING btree (machine_id, status);


--
-- Name: idx_support_tickets_owner; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_support_tickets_owner ON public.support_tickets USING btree (assigned_to);


--
-- Name: idx_support_tickets_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_support_tickets_status ON public.support_tickets USING btree (status);


--
-- Name: idx_support_tickets_status_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_support_tickets_status_created ON public.support_tickets USING btree (status, created_at DESC);


--
-- Name: idx_support_tickets_subcategory; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_support_tickets_subcategory ON public.support_tickets USING btree (problem_subcategory);


--
-- Name: idx_support_tickets_ticket_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_support_tickets_ticket_number ON public.support_tickets USING btree (ticket_number);


--
-- Name: idx_support_tickets_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_support_tickets_user_id ON public.support_tickets USING btree (user_id);


--
-- Name: idx_suspicious_severity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_suspicious_severity ON public.suspicious_activity USING btree (severity, last_seen DESC);


--
-- Name: idx_suspicious_user_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_suspicious_user_type ON public.suspicious_activity USING btree (user_id, activity_type);


--
-- Name: idx_user_blocks_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_blocks_active ON public.user_blocks USING btree (user_id, blocked_until);


--
-- Name: idx_user_blocks_until; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_blocks_until ON public.user_blocks USING btree (blocked_until);


--
-- Name: idx_water_analyses_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_water_analyses_date ON public.water_analyses USING btree (analysis_date DESC);


--
-- Name: idx_water_analyses_machine_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_water_analyses_machine_id ON public.water_analyses USING btree (machine_id);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: subscription_subscription_id_entity_filters_key; Type: INDEX; Schema: realtime; Owner: -
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_key ON realtime.subscription USING btree (subscription_id, entity, filters);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: machines set_machine_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_machine_id BEFORE INSERT ON public.machines FOR EACH ROW EXECUTE FUNCTION public.generate_machine_id();


--
-- Name: owner_notification_settings update_owner_notification_settings_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_owner_notification_settings_updated_at BEFORE UPDATE ON public.owner_notification_settings FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: support_tickets update_support_tickets_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_support_tickets_updated_at BEFORE UPDATE ON public.support_tickets FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: -
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: collections collections_machine_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_machine_id_fkey FOREIGN KEY (machine_id) REFERENCES public.machines(id) ON DELETE CASCADE;


--
-- Name: filter_replacements filter_replacements_machine_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.filter_replacements
    ADD CONSTRAINT filter_replacements_machine_id_fkey FOREIGN KEY (machine_id) REFERENCES public.machines(id) ON DELETE CASCADE;


--
-- Name: machines machines_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.machines
    ADD CONSTRAINT machines_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.owners(owner_id) ON DELETE SET NULL;


--
-- Name: notification_log notification_log_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_log
    ADD CONSTRAINT notification_log_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.owners(owner_id);


--
-- Name: notification_log notification_log_ticket_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_log
    ADD CONSTRAINT notification_log_ticket_id_fkey FOREIGN KEY (ticket_id) REFERENCES public.support_tickets(id);


--
-- Name: owner_notification_settings owner_notification_settings_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.owner_notification_settings
    ADD CONSTRAINT owner_notification_settings_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.owners(owner_id);


--
-- Name: support_tickets support_tickets_assigned_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES public.owners(owner_id);


--
-- Name: support_tickets support_tickets_machine_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_machine_id_fkey FOREIGN KEY (machine_id) REFERENCES public.machines(id);


--
-- Name: water_analyses water_analyses_machine_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.water_analyses
    ADD CONSTRAINT water_analyses_machine_id_fkey FOREIGN KEY (machine_id) REFERENCES public.machines(id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: notification_log Allow bot to insert notification logs; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow bot to insert notification logs" ON public.notification_log FOR INSERT WITH CHECK (true);


--
-- Name: security_log Allow bot to insert security logs; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow bot to insert security logs" ON public.security_log FOR INSERT WITH CHECK (true);


--
-- Name: support_tickets Allow bot to insert tickets; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow bot to insert tickets" ON public.support_tickets FOR INSERT WITH CHECK (true);


--
-- Name: owner_notification_settings Allow bot to manage notification settings; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow bot to manage notification settings" ON public.owner_notification_settings USING (true) WITH CHECK (true);


--
-- Name: suspicious_activity Allow bot to manage suspicious activity; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow bot to manage suspicious activity" ON public.suspicious_activity USING (true);


--
-- Name: user_blocks Allow bot to manage user blocks; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow bot to manage user blocks" ON public.user_blocks USING (true);


--
-- Name: machines Allow bot to read machines; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow bot to read machines" ON public.machines FOR SELECT USING (true);


--
-- Name: owners Allow bot to read owners; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow bot to read owners" ON public.owners FOR SELECT USING (true);


--
-- Name: support_tickets Allow bot to update tickets; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow bot to update tickets" ON public.support_tickets FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: notification_log Allow reading notification logs; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow reading notification logs" ON public.notification_log FOR SELECT USING (true);


--
-- Name: security_log Allow reading security logs; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow reading security logs" ON public.security_log FOR SELECT USING (true);


--
-- Name: support_tickets Allow service accounts to read tickets; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow service accounts to read tickets" ON public.support_tickets FOR SELECT USING (true);


--
-- Name: collections; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.collections ENABLE ROW LEVEL SECURITY;

--
-- Name: filter_replacements; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.filter_replacements ENABLE ROW LEVEL SECURITY;

--
-- Name: machines; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.machines ENABLE ROW LEVEL SECURITY;

--
-- Name: notification_log; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.notification_log ENABLE ROW LEVEL SECURITY;

--
-- Name: owner_notification_settings; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.owner_notification_settings ENABLE ROW LEVEL SECURITY;

--
-- Name: owners; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.owners ENABLE ROW LEVEL SECURITY;

--
-- Name: security_log; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.security_log ENABLE ROW LEVEL SECURITY;

--
-- Name: support_tickets; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.support_tickets ENABLE ROW LEVEL SECURITY;

--
-- Name: suspicious_activity; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.suspicious_activity ENABLE ROW LEVEL SECURITY;

--
-- Name: user_blocks; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.user_blocks ENABLE ROW LEVEL SECURITY;

--
-- Name: water_analyses; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.water_analyses ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: -
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: -
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


--
-- PostgreSQL database dump complete
--

