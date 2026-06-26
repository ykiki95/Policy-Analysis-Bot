--
-- PostgreSQL database dump
--

\restrict UsdXvuaJmd1ACnTGUcPOM4ck4zH3CTe5FqBk4M4d0cF0ZorzrchFwd9MZgnd4yi

-- Dumped from database version 16.10
-- Dumped by pg_dump version 16.10

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.surveys DROP CONSTRAINT IF EXISTS surveys_user_id_fk;
ALTER TABLE IF EXISTS ONLY public.survey_uploads DROP CONSTRAINT IF EXISTS survey_uploads_user_id_fk;
ALTER TABLE IF EXISTS ONLY public.simulations DROP CONSTRAINT IF EXISTS simulations_user_id_fk;
ALTER TABLE IF EXISTS ONLY public.calibrations DROP CONSTRAINT IF EXISTS calibrations_user_id_fk;
ALTER TABLE IF EXISTS ONLY public.calibration_settings DROP CONSTRAINT IF EXISTS calibration_settings_user_id_fk;
ALTER TABLE IF EXISTS ONLY public.agents DROP CONSTRAINT IF EXISTS agents_user_id_fk;
DROP INDEX IF EXISTS public.surveys_user_id_idx;
DROP INDEX IF EXISTS public.survey_uploads_user_id_idx;
DROP INDEX IF EXISTS public.simulations_user_id_idx;
DROP INDEX IF EXISTS public.sim_responses_sim_agent_uq;
DROP INDEX IF EXISTS public.calibrations_user_id_idx;
DROP INDEX IF EXISTS public.agents_user_id_idx;
DROP INDEX IF EXISTS public.access_events_user_idx;
DROP INDEX IF EXISTS public.access_events_session_idx;
DROP INDEX IF EXISTS public.access_events_ip_idx;
DROP INDEX IF EXISTS public.access_events_created_at_idx;
DROP INDEX IF EXISTS public."IDX_session_expire";
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_username_unique;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.surveys DROP CONSTRAINT IF EXISTS surveys_pkey;
ALTER TABLE IF EXISTS ONLY public.survey_uploads DROP CONSTRAINT IF EXISTS survey_uploads_pkey;
ALTER TABLE IF EXISTS ONLY public.simulations DROP CONSTRAINT IF EXISTS simulations_pkey;
ALTER TABLE IF EXISTS ONLY public.simulation_responses DROP CONSTRAINT IF EXISTS simulation_responses_pkey;
ALTER TABLE IF EXISTS ONLY public.signal_settings DROP CONSTRAINT IF EXISTS signal_settings_user_id_key;
ALTER TABLE IF EXISTS ONLY public.signal_settings DROP CONSTRAINT IF EXISTS signal_settings_pkey;
ALTER TABLE IF EXISTS ONLY public.signal_batches DROP CONSTRAINT IF EXISTS signal_batches_pkey;
ALTER TABLE IF EXISTS ONLY public.session DROP CONSTRAINT IF EXISTS session_pkey;
ALTER TABLE IF EXISTS ONLY public.regions DROP CONSTRAINT IF EXISTS regions_pkey;
ALTER TABLE IF EXISTS ONLY public.learning_contributions DROP CONSTRAINT IF EXISTS learning_contributions_pkey;
ALTER TABLE IF EXISTS ONLY public.ip_geo DROP CONSTRAINT IF EXISTS ip_geo_pkey;
ALTER TABLE IF EXISTS ONLY public.elections DROP CONSTRAINT IF EXISTS elections_pkey;
ALTER TABLE IF EXISTS ONLY public.demographic_margins DROP CONSTRAINT IF EXISTS demographic_margins_pkey;
ALTER TABLE IF EXISTS ONLY public.data_sources DROP CONSTRAINT IF EXISTS data_sources_pkey;
ALTER TABLE IF EXISTS ONLY public.contributor_reputation DROP CONSTRAINT IF EXISTS contributor_reputation_pkey;
ALTER TABLE IF EXISTS ONLY public.calibrations DROP CONSTRAINT IF EXISTS calibrations_pkey;
ALTER TABLE IF EXISTS ONLY public.calibration_settings DROP CONSTRAINT IF EXISTS calibration_settings_pkey;
ALTER TABLE IF EXISTS ONLY public.agents DROP CONSTRAINT IF EXISTS agents_pkey;
ALTER TABLE IF EXISTS ONLY public.accuracy_snapshots DROP CONSTRAINT IF EXISTS accuracy_snapshots_pkey;
ALTER TABLE IF EXISTS ONLY public.access_events DROP CONSTRAINT IF EXISTS access_events_pkey;
ALTER TABLE IF EXISTS public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.surveys ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.survey_uploads ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.simulations ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.simulation_responses ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.signal_settings ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.signal_batches ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.learning_contributions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.elections ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.demographic_margins ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.data_sources ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.calibrations ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.calibration_settings ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.agents ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.accuracy_snapshots ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.access_events ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.users_id_seq;
DROP TABLE IF EXISTS public.users;
DROP SEQUENCE IF EXISTS public.surveys_id_seq;
DROP TABLE IF EXISTS public.surveys;
DROP SEQUENCE IF EXISTS public.survey_uploads_id_seq;
DROP TABLE IF EXISTS public.survey_uploads;
DROP SEQUENCE IF EXISTS public.simulations_id_seq;
DROP TABLE IF EXISTS public.simulations;
DROP SEQUENCE IF EXISTS public.simulation_responses_id_seq;
DROP TABLE IF EXISTS public.simulation_responses;
DROP SEQUENCE IF EXISTS public.signal_settings_id_seq;
DROP TABLE IF EXISTS public.signal_settings;
DROP SEQUENCE IF EXISTS public.signal_batches_id_seq;
DROP TABLE IF EXISTS public.signal_batches;
DROP TABLE IF EXISTS public.session;
DROP TABLE IF EXISTS public.regions;
DROP SEQUENCE IF EXISTS public.learning_contributions_id_seq;
DROP TABLE IF EXISTS public.learning_contributions;
DROP TABLE IF EXISTS public.ip_geo;
DROP SEQUENCE IF EXISTS public.elections_id_seq;
DROP TABLE IF EXISTS public.elections;
DROP SEQUENCE IF EXISTS public.demographic_margins_id_seq;
DROP TABLE IF EXISTS public.demographic_margins;
DROP SEQUENCE IF EXISTS public.data_sources_id_seq;
DROP TABLE IF EXISTS public.data_sources;
DROP TABLE IF EXISTS public.contributor_reputation;
DROP SEQUENCE IF EXISTS public.calibrations_id_seq;
DROP TABLE IF EXISTS public.calibrations;
DROP SEQUENCE IF EXISTS public.calibration_settings_id_seq;
DROP TABLE IF EXISTS public.calibration_settings;
DROP SEQUENCE IF EXISTS public.agents_id_seq;
DROP TABLE IF EXISTS public.agents;
DROP SEQUENCE IF EXISTS public.accuracy_snapshots_id_seq;
DROP TABLE IF EXISTS public.accuracy_snapshots;
DROP SEQUENCE IF EXISTS public.access_events_id_seq;
DROP TABLE IF EXISTS public.access_events;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: access_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.access_events (
    id integer NOT NULL,
    client_id text NOT NULL,
    session_id text NOT NULL,
    user_id integer,
    ip text,
    user_agent text,
    device_type text,
    browser text,
    os text,
    path text NOT NULL,
    type text NOT NULL,
    success boolean,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: access_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.access_events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.access_events_id_seq OWNED BY public.access_events.id;


--
-- Name: accuracy_snapshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accuracy_snapshots (
    id integer NOT NULL,
    cycle integer NOT NULL,
    raw_error double precision NOT NULL,
    calibrated_error double precision NOT NULL,
    accuracy double precision NOT NULL,
    political_error double precision NOT NULL,
    consumer_error double precision NOT NULL,
    policy_error double precision NOT NULL,
    contributions_applied integer DEFAULT 0 NOT NULL,
    contributions_flagged integer DEFAULT 0 NOT NULL,
    population_size integer DEFAULT 0 NOT NULL,
    offset_political double precision DEFAULT 0 NOT NULL,
    offset_consumer double precision DEFAULT 0 NOT NULL,
    offset_policy double precision DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: accuracy_snapshots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.accuracy_snapshots_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accuracy_snapshots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.accuracy_snapshots_id_seq OWNED BY public.accuracy_snapshots.id;


--
-- Name: agents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.agents (
    id integer NOT NULL,
    name text NOT NULL,
    age integer NOT NULL,
    age_bracket text NOT NULL,
    gender text NOT NULL,
    district text NOT NULL,
    lat double precision NOT NULL,
    lng double precision NOT NULL,
    education text NOT NULL,
    income_bracket text NOT NULL,
    occupation text NOT NULL,
    household_type text NOT NULL,
    political_leaning integer NOT NULL,
    party_affinity text NOT NULL,
    turnout_propensity integer NOT NULL,
    issue_stances jsonb NOT NULL,
    media_diet text NOT NULL,
    "values" text[] NOT NULL,
    persona_summary text NOT NULL,
    consumer_stances jsonb DEFAULT '{"brandLoyalty": 50, "noveltySeeking": 50, "ecoConsciousness": 50, "priceSensitivity": 50, "digitalConsumption": 50}'::jsonb NOT NULL,
    policy_stances jsonb DEFAULT '{"taxTolerance": 50, "governmentTrust": 50, "policyAcceptance": 50, "regulationPreference": 50, "publicServiceSatisfaction": 50}'::jsonb NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: agents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.agents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: agents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.agents_id_seq OWNED BY public.agents.id;


--
-- Name: calibration_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.calibration_settings (
    id integer NOT NULL,
    method text NOT NULL,
    benchmark_weight double precision NOT NULL,
    recency_weight double precision NOT NULL,
    shrinkage_factor double precision NOT NULL,
    outlier_trim_pct double precision NOT NULL,
    description text NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    apply_to_population boolean DEFAULT false NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: calibration_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.calibration_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: calibration_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.calibration_settings_id_seq OWNED BY public.calibration_settings.id;


--
-- Name: calibrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.calibrations (
    id integer NOT NULL,
    title text NOT NULL,
    event_type text NOT NULL,
    target_date text NOT NULL,
    metric text NOT NULL,
    actual_value double precision NOT NULL,
    raw_prediction double precision NOT NULL,
    calibrated_prediction double precision NOT NULL,
    raw_error double precision NOT NULL,
    calibrated_error double precision NOT NULL,
    method text NOT NULL,
    product text DEFAULT 'Dynamo'::text NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: calibrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.calibrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: calibrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.calibrations_id_seq OWNED BY public.calibrations.id;


--
-- Name: contributor_reputation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contributor_reputation (
    user_id integer NOT NULL,
    contributions integer DEFAULT 0 NOT NULL,
    helpful integer DEFAULT 0 NOT NULL,
    harmful integer DEFAULT 0 NOT NULL,
    reputation double precision DEFAULT 1 NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: data_sources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.data_sources (
    id integer NOT NULL,
    name text NOT NULL,
    agency text NOT NULL,
    category text NOT NULL,
    contributes_to text NOT NULL,
    record_count integer NOT NULL,
    coverage text NOT NULL,
    reference_year text NOT NULL,
    source_url text NOT NULL
);


--
-- Name: data_sources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.data_sources_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: data_sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.data_sources_id_seq OWNED BY public.data_sources.id;


--
-- Name: demographic_margins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.demographic_margins (
    id integer NOT NULL,
    dimension text NOT NULL,
    key text NOT NULL,
    label text NOT NULL,
    population integer NOT NULL
);


--
-- Name: demographic_margins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.demographic_margins_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: demographic_margins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.demographic_margins_id_seq OWNED BY public.demographic_margins.id;


--
-- Name: elections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.elections (
    id integer NOT NULL,
    name text NOT NULL,
    election_type text NOT NULL,
    election_date text NOT NULL,
    region_code text NOT NULL,
    metric text NOT NULL,
    leaning text NOT NULL,
    actual_value double precision NOT NULL,
    actual_winner text NOT NULL
);


--
-- Name: elections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.elections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: elections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.elections_id_seq OWNED BY public.elections.id;


--
-- Name: ip_geo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ip_geo (
    ip text NOT NULL,
    status text NOT NULL,
    country text,
    country_code text,
    region text,
    city text,
    lat double precision,
    lon double precision,
    isp text,
    fetched_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: learning_contributions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.learning_contributions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    domain text NOT NULL,
    product text NOT NULL,
    title text NOT NULL,
    observed_value double precision NOT NULL,
    predicted_value double precision NOT NULL,
    bias double precision NOT NULL,
    proposed_offset double precision NOT NULL,
    sample_size integer DEFAULT 0 NOT NULL,
    status text DEFAULT 'candidate'::text NOT NULL,
    quality_score double precision DEFAULT 0 NOT NULL,
    accuracy_delta double precision,
    decided_by text,
    flag_reason text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    evaluated_at timestamp with time zone
);


--
-- Name: learning_contributions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.learning_contributions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: learning_contributions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.learning_contributions_id_seq OWNED BY public.learning_contributions.id;


--
-- Name: regions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regions (
    code text NOT NULL,
    name text NOT NULL,
    lat double precision NOT NULL,
    lng double precision NOT NULL,
    leaning_bias integer NOT NULL,
    macro_region text NOT NULL,
    display_order integer NOT NULL
);


--
-- Name: session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.session (
    sid character varying NOT NULL,
    sess json NOT NULL,
    expire timestamp(6) without time zone NOT NULL
);


--
-- Name: signal_batches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.signal_batches (
    id integer NOT NULL,
    user_id integer NOT NULL,
    source text NOT NULL,
    title text NOT NULL,
    collected_at timestamp with time zone DEFAULT now() NOT NULL,
    item_count integer NOT NULL,
    sentiment_pos integer NOT NULL,
    sentiment_neu integer NOT NULL,
    sentiment_neg integer NOT NULL,
    summary text NOT NULL,
    linked_product text NOT NULL,
    linked_simulation_id integer,
    metric text NOT NULL,
    value_before double precision NOT NULL,
    value_after double precision NOT NULL,
    status text DEFAULT '완료'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: signal_batches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.signal_batches_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: signal_batches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.signal_batches_id_seq OWNED BY public.signal_batches.id;


--
-- Name: signal_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.signal_settings (
    id integer NOT NULL,
    user_id integer NOT NULL,
    source_news_enabled boolean DEFAULT true NOT NULL,
    source_trend_enabled boolean DEFAULT true NOT NULL,
    source_sns_enabled boolean DEFAULT true NOT NULL,
    source_news_weight double precision DEFAULT 1 NOT NULL,
    source_trend_weight double precision DEFAULT 1 NOT NULL,
    source_sns_weight double precision DEFAULT 1 NOT NULL,
    apply_to_prediction boolean DEFAULT true NOT NULL,
    schedule_enabled boolean DEFAULT false NOT NULL,
    schedule_interval text DEFAULT '수동'::text NOT NULL,
    filter_bot_removal boolean DEFAULT true NOT NULL,
    filter_dedup boolean DEFAULT true NOT NULL,
    filter_min_items integer DEFAULT 50 NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: signal_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.signal_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: signal_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.signal_settings_id_seq OWNED BY public.signal_settings.id;


--
-- Name: simulation_responses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.simulation_responses (
    id integer NOT NULL,
    simulation_id integer NOT NULL,
    agent_id integer NOT NULL,
    agent_name text NOT NULL,
    district text NOT NULL,
    age_bracket text NOT NULL,
    gender text NOT NULL,
    stance text NOT NULL,
    score integer NOT NULL,
    confidence integer NOT NULL,
    reasoning text NOT NULL,
    political_leaning integer DEFAULT 0 NOT NULL,
    policy_stances jsonb
);


--
-- Name: simulation_responses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.simulation_responses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: simulation_responses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.simulation_responses_id_seq OWNED BY public.simulation_responses.id;


--
-- Name: simulations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.simulations (
    id integer NOT NULL,
    title text NOT NULL,
    audience text NOT NULL,
    product text NOT NULL,
    policy_text text NOT NULL,
    model text NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    progress integer DEFAULT 0 NOT NULL,
    total_agents integer NOT NULL,
    cost_estimate_usd double precision NOT NULL,
    cost_actual_usd double precision,
    overall_support double precision,
    support_pct double precision,
    oppose_pct double precision,
    neutral_pct double precision,
    summary text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    completed_at timestamp with time zone,
    user_id integer NOT NULL,
    locked_by text,
    locked_at timestamp with time zone,
    heartbeat_at timestamp with time zone,
    last_error text,
    prediction_locked_at timestamp with time zone,
    prediction_value double precision,
    actual_value double precision,
    actual_metric text,
    actual_entered_at timestamp with time zone,
    prediction_error double precision,
    learned_at timestamp with time zone
);


--
-- Name: simulations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.simulations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: simulations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.simulations_id_seq OWNED BY public.simulations.id;


--
-- Name: survey_uploads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.survey_uploads (
    id integer NOT NULL,
    file_name text NOT NULL,
    description text NOT NULL,
    format text NOT NULL,
    row_count integer NOT NULL,
    status text NOT NULL,
    applied_to_population boolean DEFAULT false NOT NULL,
    columns jsonb NOT NULL,
    sample_rows jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: survey_uploads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.survey_uploads_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: survey_uploads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.survey_uploads_id_seq OWNED BY public.survey_uploads.id;


--
-- Name: surveys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.surveys (
    id integer NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    methodology text NOT NULL,
    sample_size integer NOT NULL,
    fielded_date text NOT NULL,
    status text NOT NULL,
    reliability double precision NOT NULL,
    drivers jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_to_population boolean DEFAULT false NOT NULL,
    is_real boolean DEFAULT false NOT NULL,
    source_agency text,
    source_title text,
    field_period text,
    source_url text,
    domain text DEFAULT 'political'::text NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: surveys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.surveys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: surveys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.surveys_id_seq OWNED BY public.surveys.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username text NOT NULL,
    name text NOT NULL,
    birth_date text,
    password_hash text NOT NULL,
    role text DEFAULT 'user'::text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    budget_limit_usd double precision DEFAULT 1 NOT NULL,
    avatar text,
    password_plain text
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: access_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_events ALTER COLUMN id SET DEFAULT nextval('public.access_events_id_seq'::regclass);


--
-- Name: accuracy_snapshots id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accuracy_snapshots ALTER COLUMN id SET DEFAULT nextval('public.accuracy_snapshots_id_seq'::regclass);


--
-- Name: agents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents ALTER COLUMN id SET DEFAULT nextval('public.agents_id_seq'::regclass);


--
-- Name: calibration_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calibration_settings ALTER COLUMN id SET DEFAULT nextval('public.calibration_settings_id_seq'::regclass);


--
-- Name: calibrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calibrations ALTER COLUMN id SET DEFAULT nextval('public.calibrations_id_seq'::regclass);


--
-- Name: data_sources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_sources ALTER COLUMN id SET DEFAULT nextval('public.data_sources_id_seq'::regclass);


--
-- Name: demographic_margins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.demographic_margins ALTER COLUMN id SET DEFAULT nextval('public.demographic_margins_id_seq'::regclass);


--
-- Name: elections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.elections ALTER COLUMN id SET DEFAULT nextval('public.elections_id_seq'::regclass);


--
-- Name: learning_contributions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.learning_contributions ALTER COLUMN id SET DEFAULT nextval('public.learning_contributions_id_seq'::regclass);


--
-- Name: signal_batches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.signal_batches ALTER COLUMN id SET DEFAULT nextval('public.signal_batches_id_seq'::regclass);


--
-- Name: signal_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.signal_settings ALTER COLUMN id SET DEFAULT nextval('public.signal_settings_id_seq'::regclass);


--
-- Name: simulation_responses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.simulation_responses ALTER COLUMN id SET DEFAULT nextval('public.simulation_responses_id_seq'::regclass);


--
-- Name: simulations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.simulations ALTER COLUMN id SET DEFAULT nextval('public.simulations_id_seq'::regclass);


--
-- Name: survey_uploads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_uploads ALTER COLUMN id SET DEFAULT nextval('public.survey_uploads_id_seq'::regclass);


--
-- Name: surveys id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.surveys ALTER COLUMN id SET DEFAULT nextval('public.surveys_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: access_events; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.access_events (id, client_id, session_id, user_id, ip, user_agent, device_type, browser, os, path, type, success, created_at) FROM stdin;
1	smoke-c1	smoke-s1	\N	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 Mobile Safari/604.1	mobile	Mobile Safari	iOS	/dashboard	pageview	\N	2026-06-25 23:17:58.372113+00
2	smoke-c1	smoke-s1	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/dashboard	heartbeat	\N	2026-06-25 23:17:58.433615+00
3	login-form	login-form	2	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/login	login	t	2026-06-25 23:18:08.142676+00
4	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	pageview	\N	2026-06-25 23:19:31.892031+00
5	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:19:51.903262+00
6	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:20:11.894403+00
7	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:20:31.896513+00
8	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:20:51.896625+00
9	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:21:11.909766+00
10	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:21:31.912923+00
11	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:21:51.904385+00
12	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	pageview	\N	2026-06-25 23:21:52.016967+00
13	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:22:11.898399+00
14	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:22:31.907361+00
15	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:22:51.897159+00
16	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:23:11.911949+00
17	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:23:31.61936+00
18	4aa0d4a4-48d0-486e-a831-83f300f6f579	615956c5-5e9d-4f84-ab97-7d4eaadb305a	\N	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0	desktop	Chrome	Windows	/	pageview	\N	2026-06-25 23:23:39.849969+00
19	4aa0d4a4-48d0-486e-a831-83f300f6f579	615956c5-5e9d-4f84-ab97-7d4eaadb305a	\N	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0	desktop	Chrome	Windows	/login	pageview	\N	2026-06-25 23:23:39.908991+00
20	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	pageview	\N	2026-06-25 23:23:42.520495+00
21	4aa0d4a4-48d0-486e-a831-83f300f6f579	615956c5-5e9d-4f84-ab97-7d4eaadb305a	\N	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0	desktop	Chrome	Windows	/login	heartbeat	\N	2026-06-25 23:23:43.343818+00
22	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:24:02.526195+00
23	login-form	login-form	2	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/login	login	t	2026-06-25 23:24:15.176236+00
24	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:24:22.543025+00
25	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:24:42.528051+00
26	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:25:02.526008+00
27	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:25:22.526786+00
28	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:25:42.523811+00
29	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:26:02.534466+00
91	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:07.528521+00
30	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:26:22.521595+00
31	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:26:42.529774+00
32	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:27:02.546058+00
33	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:04.497174+00
34	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:04.551651+00
35	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:04.606666+00
36	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:04.654339+00
37	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:04.71258+00
38	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:04.764597+00
39	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:04.795187+00
40	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:04.838493+00
41	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:04.88715+00
42	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:04.936891+00
43	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:04.986451+00
44	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:05.041581+00
45	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:05.100523+00
46	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:05.149822+00
47	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:05.20024+00
48	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:05.258799+00
49	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:05.309248+00
50	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:05.360493+00
51	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:05.41538+00
52	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:05.464376+00
53	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:05.516467+00
54	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:05.566236+00
55	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:05.627521+00
56	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:05.678553+00
57	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:05.730274+00
58	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:05.780405+00
59	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:05.83099+00
60	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:05.882889+00
61	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:05.932886+00
62	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:05.984558+00
63	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:06.034878+00
64	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:06.089158+00
65	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:06.140087+00
66	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:06.194006+00
67	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:06.246092+00
68	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:06.29965+00
69	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:06.353329+00
70	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:06.406725+00
71	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:06.466741+00
72	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:06.521976+00
73	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:06.571039+00
74	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:06.643231+00
75	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:06.695952+00
76	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:06.753135+00
77	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:06.805664+00
78	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:06.860368+00
79	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:06.911585+00
80	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:06.96645+00
81	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:07.018699+00
82	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:07.067043+00
83	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:07.125664+00
84	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:07.181658+00
85	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:07.231141+00
86	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:07.282143+00
87	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:07.331717+00
88	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:07.380573+00
89	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:07.428376+00
90	smoke	smoke	\N	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/	pageview	\N	2026-06-25 23:27:07.477951+00
92	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:34:50.381627+00
93	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:34:50.383125+00
94	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:35:02.52588+00
95	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:35:22.523009+00
96	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:35:42.531172+00
97	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:36:02.528476+00
98	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:36:22.525167+00
99	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:36:42.522522+00
100	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:37:02.523083+00
101	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:37:22.53202+00
102	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:37:42.538243+00
103	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:38:02.553272+00
104	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:38:22.527217+00
105	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:38:42.529013+00
106	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:39:02.547031+00
107	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:39:22.535338+00
108	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:39:42.535398+00
109	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:40:02.535949+00
110	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:40:22.529552+00
111	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:40:42.52867+00
112	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:41:02.526287+00
113	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:41:22.523499+00
114	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:41:42.535628+00
115	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:42:02.524143+00
116	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:42:22.53321+00
117	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:42:42.538698+00
118	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:43:02.537296+00
119	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:43:22.525072+00
120	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	pageview	\N	2026-06-25 23:43:29.261323+00
121	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:43:42.528007+00
122	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:44:02.529503+00
123	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:44:23.26133+00
124	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:44:42.536496+00
125	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:45:02.527229+00
126	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:45:22.536383+00
127	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/population	pageview	\N	2026-06-25 23:45:22.98017+00
128	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/surveys	pageview	\N	2026-06-25 23:45:31.011539+00
129	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/simulations	pageview	\N	2026-06-25 23:45:32.617022+00
130	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/simulations/17	pageview	\N	2026-06-25 23:45:40.434782+00
131	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/simulations/17	heartbeat	\N	2026-06-25 23:45:42.530997+00
132	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/simulations	pageview	\N	2026-06-25 23:45:47.375023+00
133	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/population	pageview	\N	2026-06-25 23:45:51.870089+00
134	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	pageview	\N	2026-06-25 23:45:53.233593+00
135	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:46:02.536663+00
136	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:46:07.065645+00
137	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:46:22.539983+00
138	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:46:42.540465+00
139	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:47:02.948791+00
140	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:47:22.529867+00
141	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:47:42.538582+00
142	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:48:02.529316+00
143	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:48:22.530705+00
144	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:48:42.537037+00
145	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:50:29.749396+00
146	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:50:29.911075+00
147	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:50:42.542322+00
148	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:51:02.534115+00
149	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:51:22.543486+00
150	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:51:42.545856+00
151	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:52:02.534143+00
152	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:52:22.537794+00
153	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:52:42.544648+00
154	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:53:02.534932+00
155	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:53:22.540673+00
156	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-25 23:53:42.530542+00
157	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/calibration	pageview	\N	2026-06-25 23:53:51.431916+00
158	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/calibration	heartbeat	\N	2026-06-25 23:54:02.527886+00
159	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	pageview	\N	2026-06-25 23:54:19.525109+00
160	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:54:22.539417+00
161	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:54:42.535106+00
162	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:55:02.540795+00
163	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:55:22.534563+00
164	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:55:42.536808+00
165	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:56:02.530508+00
166	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:56:22.530652+00
167	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:56:42.530022+00
168	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:57:02.534171+00
169	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:57:22.54207+00
170	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:57:42.546803+00
171	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:58:36.946162+00
172	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-25 23:58:42.537541+00
173	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:00:47.29204+00
174	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:00:47.682726+00
175	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:01:02.53475+00
176	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:01:22.538493+00
177	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:01:42.531592+00
178	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:02:02.541857+00
179	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:02:22.536593+00
180	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:02:42.556469+00
181	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:03:02.537081+00
182	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:03:22.53484+00
183	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:03:42.537363+00
184	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:04:02.544392+00
185	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:04:22.546326+00
186	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:04:42.535032+00
187	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:05:02.569484+00
188	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:05:23.459426+00
189	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	pageview	\N	2026-06-26 00:05:24.137843+00
190	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	pageview	\N	2026-06-26 00:05:24.538559+00
191	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:05:42.549004+00
192	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:06:02.536738+00
193	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:06:22.542489+00
194	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:06:42.546837+00
195	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:07:02.546528+00
196	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:07:22.54028+00
197	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:07:42.55631+00
198	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:08:02.534284+00
199	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:08:22.536745+00
200	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:08:42.540348+00
201	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:09:02.539061+00
202	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:09:22.523214+00
203	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:09:42.545275+00
204	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:09:43.703901+00
205	login-form	login-form	2	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/login	login	t	2026-06-26 00:11:48.028099+00
206	login-form	login-form	2	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/login	login	t	2026-06-26 00:12:10.317764+00
207	login-form	login-form	2	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/login	login	t	2026-06-26 00:16:12.985415+00
208	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:22:24.407255+00
209	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 00:22:24.771311+00
210	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	pageview	\N	2026-06-26 01:48:40.597609+00
211	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 01:49:00.572695+00
212	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 01:49:20.578679+00
213	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	pageview	\N	2026-06-26 01:49:33.161336+00
214	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:49:40.574445+00
215	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:50:00.582795+00
216	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:50:20.574079+00
217	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:50:40.592849+00
218	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:51:00.578808+00
219	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:51:20.580206+00
220	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:51:40.580261+00
221	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:52:00.581769+00
222	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:52:20.574099+00
223	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:52:40.585729+00
224	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:53:00.578574+00
225	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:53:20.587798+00
226	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:53:40.578849+00
227	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:54:00.574658+00
228	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:54:20.576136+00
229	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:54:40.572332+00
230	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:55:00.590521+00
231	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:55:20.576464+00
232	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:55:40.5825+00
233	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:56:00.585703+00
234	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:56:20.591524+00
235	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:56:40.582605+00
236	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:57:00.588511+00
237	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:57:20.575932+00
238	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:57:40.594782+00
239	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:58:00.584713+00
240	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:58:20.579103+00
241	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:58:40.581457+00
242	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:59:00.583218+00
243	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:59:20.590731+00
244	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 01:59:40.581894+00
245	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:00:00.577073+00
246	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:00:21.015565+00
247	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:00:40.582977+00
248	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:01:00.588864+00
249	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:01:20.581393+00
250	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:01:40.584217+00
251	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:02:00.590713+00
252	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:02:20.58121+00
253	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:02:40.588256+00
254	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:03:00.587265+00
255	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:03:20.590617+00
256	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:03:40.578392+00
257	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:04:00.582984+00
258	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:04:20.578869+00
259	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:04:40.587691+00
260	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:05:00.587252+00
261	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:05:20.672013+00
262	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:05:40.581769+00
263	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:09:11.356883+00
264	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:09:11.700513+00
265	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:09:20.606609+00
266	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:09:40.589865+00
267	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:10:00.593027+00
268	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:10:20.594392+00
269	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:10:40.592239+00
270	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:11:00.587425+00
271	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:11:20.587101+00
272	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:11:40.591395+00
273	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:12:00.595077+00
274	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:12:20.596624+00
275	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:12:40.591161+00
276	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:13:00.5987+00
277	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:13:20.594665+00
278	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:13:40.594196+00
279	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:14:00.589601+00
280	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:14:20.597652+00
281	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:14:40.582397+00
282	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:15:00.589063+00
283	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:15:20.591247+00
284	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:15:40.592252+00
285	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:16:00.595627+00
286	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:16:20.58534+00
287	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:16:40.585496+00
288	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:17:00.598345+00
289	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:17:20.593407+00
290	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:17:40.584416+00
291	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:18:00.599625+00
292	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:18:20.594314+00
293	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:18:40.599117+00
294	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:19:00.593575+00
295	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:19:20.597118+00
296	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:19:40.586783+00
297	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:20:00.58482+00
298	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:20:20.588434+00
299	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:20:40.59364+00
300	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:21:00.589166+00
301	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:21:20.594317+00
302	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:21:40.624841+00
303	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:22:00.590058+00
304	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:22:20.600029+00
305	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:22:40.59112+00
306	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:23:00.600383+00
307	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:23:20.59683+00
308	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:23:40.589421+00
309	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:24:00.590672+00
310	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:24:20.598639+00
311	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:24:40.597247+00
312	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:25:00.593213+00
313	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:25:20.594485+00
314	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	pageview	\N	2026-06-26 02:31:22.478002+00
315	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:31:33.333078+00
316	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:31:33.341172+00
317	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:31:40.590388+00
318	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:32:00.599753+00
319	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:32:23.171022+00
320	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	pageview	\N	2026-06-26 02:32:24.970216+00
321	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	pageview	\N	2026-06-26 02:32:25.968098+00
322	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:32:40.596453+00
323	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:33:00.592239+00
324	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:33:20.593556+00
325	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:33:40.597124+00
326	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:34:00.586085+00
327	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:34:20.592014+00
328	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:34:40.591668+00
329	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	pageview	\N	2026-06-26 02:34:48.293898+00
330	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	pageview	\N	2026-06-26 02:34:48.896847+00
331	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:35:00.587084+00
332	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	pageview	\N	2026-06-26 02:35:03.913334+00
333	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:35:20.59744+00
334	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:35:40.615888+00
335	login-form	login-form	2	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/login	login	t	2026-06-26 02:36:25.50356+00
336	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:36:26.695241+00
337	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:36:40.596496+00
338	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:37:00.602201+00
339	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:37:20.588035+00
340	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:37:40.600676+00
341	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:38:00.601653+00
342	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:38:20.598049+00
343	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:38:40.598208+00
344	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:39:00.585478+00
345	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:39:20.595343+00
346	52ed9183-6a02-4bb2-9a4b-beaabbb03e3d	190c3a5b-1411-4214-92c6-31f34325d7c1	\N	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0	desktop	Chrome	Windows	/learning	pageview	\N	2026-06-26 02:39:25.423403+00
347	52ed9183-6a02-4bb2-9a4b-beaabbb03e3d	190c3a5b-1411-4214-92c6-31f34325d7c1	\N	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0	desktop	Chrome	Windows	/login	pageview	\N	2026-06-26 02:39:25.502485+00
348	52ed9183-6a02-4bb2-9a4b-beaabbb03e3d	190c3a5b-1411-4214-92c6-31f34325d7c1	\N	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0	desktop	Chrome	Windows	/login	heartbeat	\N	2026-06-26 02:39:27.765623+00
349	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:39:40.587898+00
350	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:42:22.529646+00
351	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:42:22.999111+00
352	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:42:40.593095+00
353	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:43:00.595562+00
354	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:43:20.590368+00
355	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:43:40.603431+00
356	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:44:00.638842+00
357	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:44:20.594179+00
358	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:44:40.595754+00
359	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:45:00.596032+00
360	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:45:20.600566+00
361	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:45:40.597885+00
362	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:46:00.585613+00
363	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:47:45.769022+00
364	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:47:46.242198+00
365	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:48:00.604576+00
366	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:48:20.598929+00
367	login-form	login-form	2	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/login	login	t	2026-06-26 02:48:34.98301+00
368	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:48:40.597386+00
369	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:49:00.596607+00
370	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:49:20.591822+00
371	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:49:40.601129+00
372	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:50:00.592431+00
373	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:50:20.596442+00
374	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:50:40.607086+00
375	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:51:00.600576+00
376	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:51:20.585445+00
377	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:51:40.596929+00
378	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/	heartbeat	\N	2026-06-26 02:52:00.592429+00
379	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	pageview	\N	2026-06-26 02:52:18.321339+00
380	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 02:52:20.58993+00
381	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 02:52:40.588673+00
382	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 02:53:00.588996+00
383	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/calibration	pageview	\N	2026-06-26 02:53:03.306871+00
384	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	pageview	\N	2026-06-26 02:53:06.061336+00
385	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	pageview	\N	2026-06-26 02:53:11.247972+00
386	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/signals	pageview	\N	2026-06-26 02:53:12.352516+00
387	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/surveys	pageview	\N	2026-06-26 02:53:16.932915+00
388	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/simulations	pageview	\N	2026-06-26 02:53:18.547726+00
389	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/simulations	heartbeat	\N	2026-06-26 02:53:20.591299+00
390	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/calibration	pageview	\N	2026-06-26 02:53:21.713306+00
391	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	pageview	\N	2026-06-26 02:53:22.566141+00
392	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	pageview	\N	2026-06-26 02:53:27.548306+00
393	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 02:53:40.60161+00
394	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 02:54:00.596754+00
395	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 02:54:20.594216+00
396	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 02:54:40.600564+00
397	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	pageview	\N	2026-06-26 02:54:49.806405+00
398	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 02:55:00.600489+00
399	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 02:55:20.594824+00
400	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 02:55:40.598061+00
401	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 02:58:22.031399+00
402	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 02:58:22.040739+00
403	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 02:58:40.602664+00
404	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 02:59:00.587331+00
405	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 02:59:20.600438+00
406	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 02:59:40.611714+00
407	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:00:00.643141+00
408	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:00:21.000197+00
409	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:00:40.599497+00
410	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:01:00.597488+00
411	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:01:20.600072+00
412	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:01:40.615558+00
413	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:02:00.596452+00
414	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:02:20.594333+00
415	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:02:40.603602+00
416	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:03:00.596659+00
417	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:03:20.604513+00
418	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:03:40.60446+00
419	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:04:00.597565+00
420	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/calibration	pageview	\N	2026-06-26 03:04:16.805337+00
421	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/calibration	heartbeat	\N	2026-06-26 03:04:20.598338+00
422	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/calibration	heartbeat	\N	2026-06-26 03:04:40.600286+00
423	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/calibration	heartbeat	\N	2026-06-26 03:05:00.608543+00
424	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/calibration	heartbeat	\N	2026-06-26 03:05:20.676229+00
425	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/calibration	heartbeat	\N	2026-06-26 03:05:40.61077+00
426	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/calibration	heartbeat	\N	2026-06-26 03:06:00.605217+00
427	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/calibration	heartbeat	\N	2026-06-26 03:06:20.599709+00
428	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/calibration	heartbeat	\N	2026-06-26 03:06:40.601678+00
429	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/calibration	heartbeat	\N	2026-06-26 03:07:00.604498+00
430	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	pageview	\N	2026-06-26 03:07:15.339083+00
431	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:07:20.594374+00
432	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:07:40.59521+00
433	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:08:00.602887+00
434	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:08:20.606435+00
435	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:08:40.592802+00
436	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:09:00.599603+00
437	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:09:20.598454+00
438	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:09:40.603465+00
439	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:10:00.599084+00
440	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:10:20.605879+00
441	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:10:40.604291+00
442	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:11:00.600485+00
443	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:11:20.598689+00
444	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:11:40.595897+00
445	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:12:00.605687+00
446	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:12:20.601082+00
447	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:12:40.597485+00
448	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:13:00.606064+00
449	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:13:20.595693+00
450	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:13:40.595967+00
451	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:14:00.607903+00
452	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:14:20.602475+00
453	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:14:40.592159+00
454	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	pageview	\N	2026-06-26 03:15:25.471617+00
455	login-form	login-form	2	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/login	login	t	2026-06-26 03:16:49.6085+00
456	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:17:39.866864+00
457	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:17:39.89023+00
458	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:18:00.622465+00
459	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:18:20.608332+00
460	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:18:40.604032+00
461	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:19:00.598299+00
462	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:19:20.610111+00
463	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:19:40.6076+00
464	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:20:00.604593+00
465	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:20:20.610188+00
466	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:20:40.596647+00
467	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:21:00.600003+00
468	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:21:20.619486+00
469	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:21:20.770449+00
470	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	pageview	\N	2026-06-26 03:21:23.280607+00
471	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:21:43.301687+00
472	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:22:03.298988+00
473	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:22:23.30054+00
474	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:22:43.301461+00
475	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:23:03.310372+00
476	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:23:23.30508+00
477	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:23:43.300486+00
478	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:24:03.295932+00
479	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:24:23.291925+00
480	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:24:43.298842+00
481	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:25:03.299064+00
482	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:25:23.29162+00
483	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:25:43.30849+00
484	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:26:03.303404+00
485	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:26:23.312721+00
486	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:26:43.303025+00
487	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:27:03.293845+00
488	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:27:23.29454+00
489	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:27:43.296714+00
490	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:28:03.303791+00
491	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:28:23.30258+00
492	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:30:11.507733+00
493	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:30:11.534566+00
494	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:30:23.293624+00
495	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:30:43.305051+00
496	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:31:03.307878+00
497	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:31:23.302463+00
498	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:31:43.302407+00
499	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:32:03.307989+00
500	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:32:23.30146+00
501	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:32:43.306158+00
502	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:33:03.302692+00
503	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:33:23.304252+00
504	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:33:43.297419+00
505	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:34:03.29482+00
506	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:34:23.306925+00
507	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:34:43.295584+00
508	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:35:03.301477+00
509	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:35:23.297059+00
510	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:35:43.32343+00
511	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:36:03.299388+00
512	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:36:23.299631+00
513	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:36:43.308808+00
514	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:37:03.296488+00
515	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:37:23.2969+00
516	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:37:43.313366+00
517	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:38:03.30245+00
518	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:38:23.316314+00
519	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:38:43.313356+00
520	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:39:03.306618+00
521	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:39:23.303516+00
522	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:39:43.301581+00
523	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:40:03.307341+00
524	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:40:23.297574+00
525	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:40:43.299599+00
526	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:41:03.29916+00
527	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:41:23.30448+00
528	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:41:43.305583+00
529	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:42:03.295222+00
530	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:42:23.311264+00
531	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:42:43.299353+00
532	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:43:03.309826+00
533	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:43:23.301723+00
534	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:43:43.303872+00
535	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:44:03.302706+00
536	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:44:23.312773+00
537	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:44:43.305244+00
538	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:45:03.301916+00
539	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:45:23.30499+00
540	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:45:43.301723+00
541	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:46:03.30925+00
542	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:46:23.309792+00
543	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:46:43.309451+00
544	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:47:03.301754+00
545	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:47:23.301705+00
546	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:47:43.308019+00
547	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:48:03.306429+00
548	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:48:23.302342+00
549	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:48:43.309569+00
550	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:49:03.305407+00
551	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:49:23.308717+00
552	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:49:43.315743+00
553	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:50:03.305299+00
554	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:50:23.312896+00
555	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:50:43.312977+00
556	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:51:03.314894+00
557	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:51:23.308718+00
558	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:51:43.31661+00
559	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:52:03.312634+00
560	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:52:23.319413+00
561	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:52:43.315406+00
562	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:53:03.314498+00
563	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:53:23.310341+00
564	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:53:43.310048+00
565	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:54:03.306081+00
566	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:54:23.315742+00
567	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:54:43.315571+00
568	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:55:03.322463+00
569	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:55:23.312922+00
570	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:55:43.348107+00
571	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:56:03.3115+00
572	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:56:23.31565+00
573	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:56:43.309991+00
574	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:57:03.304905+00
575	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:57:23.303558+00
576	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:57:43.301744+00
577	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:58:03.304726+00
578	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:58:23.299743+00
579	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:58:43.312778+00
580	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:59:03.312699+00
581	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:59:23.304824+00
582	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 03:59:43.303658+00
583	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:00:03.309985+00
584	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:00:23.731652+00
585	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:00:43.312049+00
586	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:01:03.317964+00
587	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:01:23.319728+00
588	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:01:43.317866+00
589	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:02:03.311275+00
590	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:02:23.315676+00
591	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	pageview	\N	2026-06-26 04:02:33.502466+00
592	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	pageview	\N	2026-06-26 04:02:34.807618+00
593	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:02:43.30524+00
594	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:03:03.313407+00
595	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:03:23.303986+00
596	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:03:43.322355+00
597	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:04:03.309013+00
598	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:04:23.314211+00
599	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:04:43.301252+00
600	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:05:03.35539+00
601	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:05:23.313812+00
602	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:05:43.328092+00
603	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:06:03.30786+00
604	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:06:23.318937+00
605	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:06:43.312218+00
606	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:07:03.312981+00
607	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:07:23.304383+00
608	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:07:43.311395+00
609	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:08:03.309039+00
610	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:08:23.305787+00
611	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:08:43.310044+00
612	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:09:03.307048+00
613	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:09:23.320068+00
614	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:09:43.306282+00
615	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:10:05.974937+00
616	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	pageview	\N	2026-06-26 04:10:09.474494+00
617	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	pageview	\N	2026-06-26 04:10:11.033885+00
618	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:10:23.32462+00
619	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:10:43.315301+00
620	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:11:03.315637+00
621	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:11:23.317812+00
622	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:11:43.303761+00
623	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:12:03.323727+00
624	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:12:23.32005+00
625	login-form	login-form	2	127.0.0.1	curl/8.14.1	desktop	unknown	unknown	/login	login	t	2026-06-26 04:12:43.065426+00
626	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:12:43.306947+00
627	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:13:03.311106+00
628	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:13:23.344967+00
629	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:13:44.575471+00
630	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:14:03.310946+00
631	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:14:23.304514+00
632	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:14:43.315077+00
633	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:15:03.311639+00
634	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:15:23.331697+00
635	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:15:43.31112+00
636	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:16:03.307419+00
637	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:16:23.317656+00
638	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:16:43.308048+00
639	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:17:03.315702+00
640	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:17:23.319177+00
641	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:17:43.305557+00
642	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:18:03.311686+00
643	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:18:23.312733+00
644	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:18:43.323075+00
645	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:19:03.323841+00
646	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:19:23.320904+00
647	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:19:43.317803+00
648	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:20:03.316282+00
649	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:20:23.327276+00
650	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:20:43.317909+00
651	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:21:03.32297+00
652	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:21:23.323577+00
653	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:21:43.31333+00
654	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:22:03.309219+00
655	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:22:23.314858+00
656	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:22:43.309845+00
657	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:23:03.311849+00
658	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:23:23.320581+00
659	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:23:43.314523+00
660	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:24:03.3051+00
661	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	pageview	\N	2026-06-26 04:24:14.416055+00
662	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 04:24:23.315908+00
663	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/admin	heartbeat	\N	2026-06-26 04:24:43.315542+00
664	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	pageview	\N	2026-06-26 04:25:01.719283+00
665	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:25:03.325338+00
666	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:25:23.320255+00
667	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:25:43.310295+00
668	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:26:03.306833+00
669	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:26:23.31963+00
670	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:26:43.317808+00
671	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:27:03.324859+00
672	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:27:23.311827+00
673	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:27:43.317566+00
674	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:28:03.31274+00
675	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:28:23.318472+00
676	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:28:43.307175+00
677	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:29:03.308949+00
678	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:29:23.319164+00
679	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:29:43.309198+00
680	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:33:14.58308+00
681	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:33:14.606453+00
682	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:33:23.31867+00
683	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:33:43.318502+00
684	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:34:03.307751+00
685	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:34:23.322377+00
686	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:34:43.313161+00
687	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:35:03.320905+00
688	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:35:23.312103+00
689	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:35:43.312115+00
690	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:36:03.312876+00
691	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:36:23.322055+00
692	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:36:43.315766+00
693	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:37:03.310259+00
694	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:37:23.341611+00
695	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:37:43.31773+00
696	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:38:03.318167+00
697	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:38:23.314349+00
698	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:38:43.335014+00
699	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:39:03.316201+00
700	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:39:23.313613+00
701	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/learning	heartbeat	\N	2026-06-26 04:39:43.312246+00
702	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/population	pageview	\N	2026-06-26 04:39:53.708031+00
703	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/surveys	pageview	\N	2026-06-26 04:39:56.902218+00
704	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/simulations	pageview	\N	2026-06-26 04:39:59.094868+00
705	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/simulations/new	pageview	\N	2026-06-26 04:40:00.318215+00
706	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/simulations/new	heartbeat	\N	2026-06-26 04:40:03.307406+00
707	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/signals	pageview	\N	2026-06-26 04:40:15.404297+00
708	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/signals	heartbeat	\N	2026-06-26 04:40:23.32358+00
709	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/signals	heartbeat	\N	2026-06-26 04:40:43.322075+00
710	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/signals	heartbeat	\N	2026-06-26 04:41:03.312588+00
711	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/signals	heartbeat	\N	2026-06-26 04:41:23.315954+00
712	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/signals	heartbeat	\N	2026-06-26 04:41:43.307875+00
713	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/signals	heartbeat	\N	2026-06-26 04:42:03.309062+00
714	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/signals	heartbeat	\N	2026-06-26 04:42:23.320883+00
715	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/signals	heartbeat	\N	2026-06-26 04:42:43.319356+00
716	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/signals	heartbeat	\N	2026-06-26 04:43:03.31958+00
717	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/signals	heartbeat	\N	2026-06-26 04:43:23.308828+00
718	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/signals	heartbeat	\N	2026-06-26 04:43:43.314346+00
719	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/signals	heartbeat	\N	2026-06-26 04:44:50.52166+00
720	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/signals	heartbeat	\N	2026-06-26 04:45:03.31299+00
721	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/signals	heartbeat	\N	2026-06-26 04:45:23.326952+00
722	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/signals	heartbeat	\N	2026-06-26 04:45:43.32155+00
723	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/signals	heartbeat	\N	2026-06-26 04:46:03.317864+00
724	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/signals	heartbeat	\N	2026-06-26 04:46:23.320715+00
725	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/signals	heartbeat	\N	2026-06-26 04:46:43.311751+00
726	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/signals	heartbeat	\N	2026-06-26 04:47:03.313311+00
727	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/signals	heartbeat	\N	2026-06-26 04:47:23.319941+00
728	6633bafb-c891-42b7-b96a-54591e689f9e	2c4b3c10-2da0-4697-8848-650d8b4179bc	2	1.220.56.227	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	desktop	Chrome	Windows	/signals	heartbeat	\N	2026-06-26 04:47:43.310995+00
\.


--
-- Data for Name: accuracy_snapshots; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.accuracy_snapshots (id, cycle, raw_error, calibrated_error, accuracy, political_error, consumer_error, policy_error, contributions_applied, contributions_flagged, population_size, offset_political, offset_consumer, offset_policy, created_at) FROM stdin;
2	1	22	13.2	78	22	14	13.5	0	1	800	0	0	0	2026-05-27 02:37:27.400163+00
3	2	19.4	11.6	80.6	19.4	12.6	12	2	1	800	2.5	1.5	1	2026-06-01 02:37:32.127443+00
4	3	17.1	10.3	82.9	17.1	10.8	10.4	3	0	800	4	3	2.5	2026-06-08 02:37:36.932588+00
5	4	15.6	9.4	84.4	15.6	9.2	8.9	2	1	800	5	4.5	3.5	2026-06-15 02:37:41.592188+00
6	5	14.4	8.6	85.6	14.4	7.8	7.4	4	0	800	4	5.5	4.5	2026-06-21 02:37:46.655704+00
7	6	13.7	8.2	86.3	13.7	6.9	6.5	3	1	800	0	0	0	2026-06-25 02:37:52.107939+00
8	7	9	5.4	91	9	15	13.5	2	0	800	-13.4	0	2.5	2026-06-26 02:48:35.389876+00
\.


--
-- Data for Name: agents; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.agents (id, name, age, age_bracket, gender, district, lat, lng, education, income_bracket, occupation, household_type, political_leaning, party_affinity, turnout_propensity, issue_stances, media_diet, "values", persona_summary, consumer_stances, policy_stances, user_id) FROM stdin;
3501	오은우	18	18-29	Female	서울특별시	37.599046	127.058571	전문대 졸	200-350만원	학생	다세대 가구	19	보수 성향 무당층	48	{"economy": 21, "housing": -20, "welfare": 2, "security": -1, "environment": 19}	신문/팟캐스트	{다양성,공정,혁신}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 다양성, 공정, 혁신 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 86, "ecoConsciousness": 49, "priceSensitivity": 45, "digitalConsumption": 78}	{"taxTolerance": 41, "governmentTrust": 49, "policyAcceptance": 41, "regulationPreference": 68, "publicServiceSatisfaction": 74}	0
3502	임성호	21	18-29	Female	서울특별시	37.514726	126.984236	대학원 졸	500-700만원	학생	부부 가구	-43	진보 성향 무당층	16	{"economy": -44, "housing": 21, "welfare": 39, "security": -15, "environment": 35}	지상파/종편 뉴스	{전통,공정,환경}	서울특별시에 거주하는 18-29 학생. 정치 성향은 진보이며 전통, 공정, 환경 가치를 중시한다.	{"brandLoyalty": 18, "noveltySeeking": 88, "ecoConsciousness": 62, "priceSensitivity": 48, "digitalConsumption": 72}	{"taxTolerance": 33, "governmentTrust": 35, "policyAcceptance": 49, "regulationPreference": 71, "publicServiceSatisfaction": 67}	0
3503	정지호	21	18-29	Female	서울특별시	37.595256	126.908857	고졸 이하	350-500만원	자영업	자녀 양육 가구	-46	진보 정당 지지	30	{"economy": -55, "housing": 40, "welfare": 71, "security": -1, "environment": 40}	신문/팟캐스트	{혁신,다양성,자유}	서울특별시에 거주하는 18-29 자영업. 정치 성향은 진보이며 혁신, 다양성, 자유 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 69, "ecoConsciousness": 32, "priceSensitivity": 57, "digitalConsumption": 79}	{"taxTolerance": 28, "governmentTrust": 43, "policyAcceptance": 47, "regulationPreference": 65, "publicServiceSatisfaction": 67}	0
3504	황건우	24	18-29	Female	서울특별시	37.552618	127.024872	고졸 이하	200만원 미만	학생	1인 가구	-28	진보 성향 무당층	27	{"economy": 8, "housing": 23, "welfare": 10, "security": 6, "environment": 36}	포털 뉴스	{안정,자유,환경}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 안정, 자유, 환경 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 73, "ecoConsciousness": 34, "priceSensitivity": 78, "digitalConsumption": 82}	{"taxTolerance": 38, "governmentTrust": 59, "policyAcceptance": 73, "regulationPreference": 50, "publicServiceSatisfaction": 66}	0
3505	홍수아	29	18-29	Female	서울특별시	37.565116	126.954603	전문대 졸	200만원 미만	주부	1인 가구	-58	진보 정당 지지	63	{"economy": -67, "housing": 46, "welfare": 26, "security": -28, "environment": 60}	포털 뉴스	{공정,자유,환경}	서울특별시에 거주하는 18-29 주부. 정치 성향은 진보이며 공정, 자유, 환경 가치를 중시한다.	{"brandLoyalty": 16, "noveltySeeking": 72, "ecoConsciousness": 46, "priceSensitivity": 79, "digitalConsumption": 72}	{"taxTolerance": 48, "governmentTrust": 55, "policyAcceptance": 52, "regulationPreference": 54, "publicServiceSatisfaction": 78}	0
3506	권정희	26	18-29	Female	서울특별시	37.552459	126.878901	전문대 졸	200-350만원	전문직	다세대 가구	-29	진보 성향 무당층	42	{"economy": -15, "housing": -4, "welfare": 41, "security": -16, "environment": 39}	유튜브	{혁신,환경,공정}	서울특별시에 거주하는 18-29 전문직. 정치 성향은 중도이며 혁신, 환경, 공정 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 69, "ecoConsciousness": 57, "priceSensitivity": 85, "digitalConsumption": 82}	{"taxTolerance": 75, "governmentTrust": 40, "policyAcceptance": 51, "regulationPreference": 65, "publicServiceSatisfaction": 60}	0
3507	김건우	27	18-29	Female	서울특별시	37.530024	126.935793	전문대 졸	500-700만원	서비스직	다세대 가구	-28	진보 성향 무당층	63	{"economy": -29, "housing": 22, "welfare": 28, "security": -30, "environment": 18}	지상파/종편 뉴스	{혁신,다양성,안정}	서울특별시에 거주하는 18-29 서비스직. 정치 성향은 중도이며 혁신, 다양성, 안정 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 63, "ecoConsciousness": 75, "priceSensitivity": 59, "digitalConsumption": 88}	{"taxTolerance": 55, "governmentTrust": 33, "policyAcceptance": 46, "regulationPreference": 59, "publicServiceSatisfaction": 58}	0
3508	이광수	22	18-29	Female	서울특별시	37.569833	126.884919	대학교 졸	200만원 미만	공무원	부부 가구	5	중도 무당층	52	{"economy": -3, "housing": -5, "welfare": 21, "security": 9, "environment": 5}	SNS	{성장,안전,전통}	서울특별시에 거주하는 18-29 공무원. 정치 성향은 중도이며 성장, 안전, 전통 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 75, "ecoConsciousness": 31, "priceSensitivity": 62, "digitalConsumption": 96}	{"taxTolerance": 33, "governmentTrust": 32, "policyAcceptance": 53, "regulationPreference": 58, "publicServiceSatisfaction": 69}	0
3509	류지호	29	18-29	Female	서울특별시	37.646423	127.045563	대학원 졸	500-700만원	은퇴	1인 가구	-34	진보 성향 무당층	49	{"economy": -36, "housing": 4, "welfare": 18, "security": -11, "environment": 16}	신문/팟캐스트	{공정,자유,전통}	서울특별시에 거주하는 18-29 은퇴. 정치 성향은 진보이며 공정, 자유, 전통 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 76, "ecoConsciousness": 70, "priceSensitivity": 58, "digitalConsumption": 85}	{"taxTolerance": 60, "governmentTrust": 52, "policyAcceptance": 29, "regulationPreference": 55, "publicServiceSatisfaction": 60}	0
3510	서지아	26	18-29	Female	서울특별시	37.608911	126.941361	전문대 졸	350-500만원	사무직	다세대 가구	-40	진보 성향 무당층	43	{"economy": -27, "housing": 28, "welfare": 7, "security": -16, "environment": 50}	지상파/종편 뉴스	{공동체,환경,다양성}	서울특별시에 거주하는 18-29 사무직. 정치 성향은 진보이며 공동체, 환경, 다양성 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 80, "ecoConsciousness": 60, "priceSensitivity": 59, "digitalConsumption": 98}	{"taxTolerance": 52, "governmentTrust": 41, "policyAcceptance": 71, "regulationPreference": 64, "publicServiceSatisfaction": 87}	0
3511	신경숙	25	18-29	Female	서울특별시	37.58022	127.068806	대학원 졸	200-350만원	자영업	다세대 가구	-37	진보 성향 무당층	47	{"economy": -3, "housing": 10, "welfare": 36, "security": -8, "environment": 46}	지상파/종편 뉴스	{전통,공동체,혁신}	서울특별시에 거주하는 18-29 자영업. 정치 성향은 진보이며 전통, 공동체, 혁신 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 69, "ecoConsciousness": 52, "priceSensitivity": 70, "digitalConsumption": 100}	{"taxTolerance": 61, "governmentTrust": 39, "policyAcceptance": 24, "regulationPreference": 65, "publicServiceSatisfaction": 75}	0
3512	장성호	19	18-29	Female	서울특별시	37.548791	126.97777	대학원 졸	700만원 이상	프리랜서	1인 가구	-67	진보 정당 지지	40	{"economy": -30, "housing": 44, "welfare": 43, "security": -44, "environment": 45}	지상파/종편 뉴스	{성장,공정,다양성}	서울특별시에 거주하는 18-29 프리랜서. 정치 성향은 진보이며 성장, 공정, 다양성 가치를 중시한다.	{"brandLoyalty": 20, "noveltySeeking": 80, "ecoConsciousness": 63, "priceSensitivity": 37, "digitalConsumption": 83}	{"taxTolerance": 63, "governmentTrust": 33, "policyAcceptance": 53, "regulationPreference": 66, "publicServiceSatisfaction": 52}	0
3513	신지우	24	18-29	Male	서울특별시	37.634949	126.902355	대학교 졸	200-350만원	서비스직	부부 가구	-44	진보 성향 무당층	63	{"economy": -33, "housing": 42, "welfare": 3, "security": -15, "environment": 6}	SNS	{공동체,공정,혁신}	서울특별시에 거주하는 18-29 서비스직. 정치 성향은 진보이며 공동체, 공정, 혁신 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 84, "ecoConsciousness": 70, "priceSensitivity": 73, "digitalConsumption": 83}	{"taxTolerance": 58, "governmentTrust": 51, "policyAcceptance": 64, "regulationPreference": 77, "publicServiceSatisfaction": 48}	0
3514	홍민준	26	18-29	Male	서울특별시	37.57857	126.927441	전문대 졸	700만원 이상	서비스직	다세대 가구	-28	진보 성향 무당층	67	{"economy": -31, "housing": 34, "welfare": 25, "security": -15, "environment": 38}	유튜브	{성장,다양성,공동체}	서울특별시에 거주하는 18-29 서비스직. 정치 성향은 중도이며 성장, 다양성, 공동체 가치를 중시한다.	{"brandLoyalty": 22, "noveltySeeking": 72, "ecoConsciousness": 50, "priceSensitivity": 65, "digitalConsumption": 78}	{"taxTolerance": 38, "governmentTrust": 38, "policyAcceptance": 61, "regulationPreference": 55, "publicServiceSatisfaction": 76}	0
3515	김수아	27	18-29	Male	서울특별시	37.617721	126.9008	대학원 졸	200-350만원	자영업	다세대 가구	-39	진보 성향 무당층	24	{"economy": -39, "housing": 27, "welfare": 10, "security": -20, "environment": 14}	지상파/종편 뉴스	{공동체,성장,안전}	서울특별시에 거주하는 18-29 자영업. 정치 성향은 진보이며 공동체, 성장, 안전 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 57, "ecoConsciousness": 48, "priceSensitivity": 70, "digitalConsumption": 85}	{"taxTolerance": 62, "governmentTrust": 45, "policyAcceptance": 65, "regulationPreference": 85, "publicServiceSatisfaction": 62}	0
3516	장은우	19	18-29	Male	서울특별시	37.521288	126.936239	대학원 졸	350-500만원	학생	다세대 가구	-10	중도 무당층	50	{"economy": -15, "housing": 1, "welfare": 51, "security": -6, "environment": 29}	유튜브	{혁신,안전,자유}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 혁신, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 86, "ecoConsciousness": 53, "priceSensitivity": 62, "digitalConsumption": 80}	{"taxTolerance": 69, "governmentTrust": 29, "policyAcceptance": 18, "regulationPreference": 87, "publicServiceSatisfaction": 60}	0
3517	송도윤	18	18-29	Male	서울특별시	37.638895	127.003454	대학교 졸	500-700만원	학생	다세대 가구	-43	진보 성향 무당층	39	{"economy": -7, "housing": 49, "welfare": 19, "security": -21, "environment": 31}	지상파/종편 뉴스	{전통,공정,안전}	서울특별시에 거주하는 18-29 학생. 정치 성향은 진보이며 전통, 공정, 안전 가치를 중시한다.	{"brandLoyalty": 16, "noveltySeeking": 82, "ecoConsciousness": 51, "priceSensitivity": 61, "digitalConsumption": 73}	{"taxTolerance": 86, "governmentTrust": 28, "policyAcceptance": 38, "regulationPreference": 58, "publicServiceSatisfaction": 58}	0
3518	임동현	26	18-29	Male	서울특별시	37.635488	126.880268	대학원 졸	200-350만원	전문직	부부 가구	-39	진보 성향 무당층	47	{"economy": -13, "housing": 42, "welfare": 25, "security": -2, "environment": 26}	신문/팟캐스트	{공정,혁신,다양성}	서울특별시에 거주하는 18-29 전문직. 정치 성향은 진보이며 공정, 혁신, 다양성 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 65, "ecoConsciousness": 69, "priceSensitivity": 59, "digitalConsumption": 95}	{"taxTolerance": 72, "governmentTrust": 52, "policyAcceptance": 59, "regulationPreference": 72, "publicServiceSatisfaction": 80}	0
3519	이수아	23	18-29	Male	서울특별시	37.552704	126.893666	대학교 졸	200-350만원	학생	부부 가구	-32	진보 성향 무당층	29	{"economy": -18, "housing": 27, "welfare": -1, "security": -9, "environment": 21}	유튜브	{성장,안정,공정}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 성장, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 63, "ecoConsciousness": 48, "priceSensitivity": 51, "digitalConsumption": 69}	{"taxTolerance": 53, "governmentTrust": 66, "policyAcceptance": 50, "regulationPreference": 68, "publicServiceSatisfaction": 82}	0
3520	이성호	27	18-29	Male	서울특별시	37.504126	126.879631	대학교 졸	350-500만원	공무원	다세대 가구	-14	중도 무당층	58	{"economy": -20, "housing": 7, "welfare": 14, "security": 7, "environment": 51}	포털 뉴스	{환경,공정,안정}	서울특별시에 거주하는 18-29 공무원. 정치 성향은 중도이며 환경, 공정, 안정 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 73, "ecoConsciousness": 64, "priceSensitivity": 66, "digitalConsumption": 85}	{"taxTolerance": 54, "governmentTrust": 44, "policyAcceptance": 46, "regulationPreference": 50, "publicServiceSatisfaction": 62}	0
3521	신도윤	23	18-29	Male	서울특별시	37.526941	126.919748	대학원 졸	350-500만원	은퇴	자녀 양육 가구	-55	진보 정당 지지	62	{"economy": -44, "housing": 43, "welfare": 35, "security": -10, "environment": 37}	유튜브	{성장,공동체,환경}	서울특별시에 거주하는 18-29 은퇴. 정치 성향은 진보이며 성장, 공동체, 환경 가치를 중시한다.	{"brandLoyalty": 13, "noveltySeeking": 62, "ecoConsciousness": 57, "priceSensitivity": 61, "digitalConsumption": 76}	{"taxTolerance": 64, "governmentTrust": 45, "policyAcceptance": 33, "regulationPreference": 83, "publicServiceSatisfaction": 67}	0
3522	안유준	21	18-29	Male	서울특별시	37.588103	126.89088	전문대 졸	500-700만원	자영업	부부 가구	-38	진보 성향 무당층	52	{"economy": -37, "housing": 20, "welfare": 43, "security": 2, "environment": 35}	포털 뉴스	{안정,공정,공동체}	서울특별시에 거주하는 18-29 자영업. 정치 성향은 진보이며 안정, 공정, 공동체 가치를 중시한다.	{"brandLoyalty": 23, "noveltySeeking": 61, "ecoConsciousness": 67, "priceSensitivity": 70, "digitalConsumption": 77}	{"taxTolerance": 38, "governmentTrust": 46, "policyAcceptance": 49, "regulationPreference": 65, "publicServiceSatisfaction": 72}	0
3523	김지민	18	18-29	Male	서울특별시	37.514981	126.977714	고졸 이하	500-700만원	생산직	1인 가구	-20	진보 성향 무당층	44	{"economy": -21, "housing": 36, "welfare": 29, "security": -4, "environment": 43}	지상파/종편 뉴스	{안전,공동체,환경}	서울특별시에 거주하는 18-29 생산직. 정치 성향은 중도이며 안전, 공동체, 환경 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 71, "ecoConsciousness": 13, "priceSensitivity": 53, "digitalConsumption": 100}	{"taxTolerance": 45, "governmentTrust": 54, "policyAcceptance": 58, "regulationPreference": 55, "publicServiceSatisfaction": 75}	0
3524	서수아	28	18-29	Male	서울특별시	37.607417	126.961051	대학원 졸	200-350만원	전문직	1인 가구	-59	진보 정당 지지	42	{"economy": -51, "housing": 35, "welfare": 33, "security": -28, "environment": 48}	지상파/종편 뉴스	{전통,안정,공정}	서울특별시에 거주하는 18-29 전문직. 정치 성향은 진보이며 전통, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 59, "ecoConsciousness": 64, "priceSensitivity": 65, "digitalConsumption": 75}	{"taxTolerance": 55, "governmentTrust": 50, "policyAcceptance": 46, "regulationPreference": 58, "publicServiceSatisfaction": 93}	0
3525	한순자	31	30-39	Female	서울특별시	37.586627	127.006129	대학원 졸	200-350만원	사무직	자녀 양육 가구	-82	진보 정당 지지	53	{"economy": -55, "housing": 43, "welfare": 53, "security": -60, "environment": 91}	지상파/종편 뉴스	{전통,안정,혁신}	서울특별시에 거주하는 30-39 사무직. 정치 성향은 진보이며 전통, 안정, 혁신 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 73, "ecoConsciousness": 58, "priceSensitivity": 68, "digitalConsumption": 71}	{"taxTolerance": 56, "governmentTrust": 50, "policyAcceptance": 37, "regulationPreference": 61, "publicServiceSatisfaction": 64}	0
3526	장영수	30	30-39	Female	서울특별시	37.53154	126.935248	대학교 졸	200만원 미만	은퇴	다세대 가구	2	중도 무당층	56	{"economy": 6, "housing": 25, "welfare": 16, "security": -14, "environment": 35}	지상파/종편 뉴스	{안정,성장,공정}	서울특별시에 거주하는 30-39 은퇴. 정치 성향은 중도이며 안정, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 81, "ecoConsciousness": 67, "priceSensitivity": 80, "digitalConsumption": 90}	{"taxTolerance": 45, "governmentTrust": 45, "policyAcceptance": 48, "regulationPreference": 74, "publicServiceSatisfaction": 87}	0
3527	신경숙	39	30-39	Female	서울특별시	37.533126	126.908133	대학교 졸	200만원 미만	학생	자녀 양육 가구	-26	진보 성향 무당층	65	{"economy": -9, "housing": 11, "welfare": 32, "security": 1, "environment": 8}	포털 뉴스	{혁신,환경,안전}	서울특별시에 거주하는 30-39 학생. 정치 성향은 중도이며 혁신, 환경, 안전 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 69, "ecoConsciousness": 49, "priceSensitivity": 59, "digitalConsumption": 78}	{"taxTolerance": 58, "governmentTrust": 53, "policyAcceptance": 47, "regulationPreference": 64, "publicServiceSatisfaction": 77}	0
3528	송정희	34	30-39	Female	서울특별시	37.561892	126.914282	전문대 졸	200-350만원	프리랜서	1인 가구	3	중도 무당층	65	{"economy": -5, "housing": 25, "welfare": 32, "security": 17, "environment": 35}	SNS	{혁신,안전,다양성}	서울특별시에 거주하는 30-39 프리랜서. 정치 성향은 중도이며 혁신, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 67, "ecoConsciousness": 59, "priceSensitivity": 80, "digitalConsumption": 86}	{"taxTolerance": 26, "governmentTrust": 39, "policyAcceptance": 58, "regulationPreference": 56, "publicServiceSatisfaction": 52}	0
3529	조지우	36	30-39	Female	서울특별시	37.566994	127.014303	대학원 졸	700만원 이상	서비스직	다세대 가구	-44	진보 성향 무당층	69	{"economy": -1, "housing": 8, "welfare": 22, "security": -18, "environment": 28}	포털 뉴스	{안정,자유,혁신}	서울특별시에 거주하는 30-39 서비스직. 정치 성향은 진보이며 안정, 자유, 혁신 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 60, "ecoConsciousness": 63, "priceSensitivity": 41, "digitalConsumption": 62}	{"taxTolerance": 68, "governmentTrust": 26, "policyAcceptance": 68, "regulationPreference": 50, "publicServiceSatisfaction": 94}	0
3530	권혜진	31	30-39	Female	서울특별시	37.587662	126.887947	대학원 졸	500-700만원	은퇴	다세대 가구	-53	진보 정당 지지	65	{"economy": -8, "housing": 28, "welfare": 44, "security": -15, "environment": 64}	SNS	{전통,공정,안전}	서울특별시에 거주하는 30-39 은퇴. 정치 성향은 진보이며 전통, 공정, 안전 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 86, "ecoConsciousness": 60, "priceSensitivity": 45, "digitalConsumption": 88}	{"taxTolerance": 70, "governmentTrust": 18, "policyAcceptance": 33, "regulationPreference": 62, "publicServiceSatisfaction": 70}	0
3531	홍지민	39	30-39	Female	서울특별시	37.627216	126.936645	고졸 이하	500-700만원	자영업	다세대 가구	-12	중도 무당층	56	{"economy": -4, "housing": 3, "welfare": -5, "security": 4, "environment": 55}	유튜브	{혁신,전통,안전}	서울특별시에 거주하는 30-39 자영업. 정치 성향은 중도이며 혁신, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 60, "ecoConsciousness": 48, "priceSensitivity": 45, "digitalConsumption": 68}	{"taxTolerance": 41, "governmentTrust": 60, "policyAcceptance": 47, "regulationPreference": 61, "publicServiceSatisfaction": 69}	0
3532	신성호	31	30-39	Female	서울특별시	37.6229	127.022853	대학교 졸	350-500만원	은퇴	자녀 양육 가구	-40	진보 성향 무당층	39	{"economy": -41, "housing": 62, "welfare": 24, "security": -4, "environment": 37}	포털 뉴스	{환경,성장,혁신}	서울특별시에 거주하는 30-39 은퇴. 정치 성향은 진보이며 환경, 성장, 혁신 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 73, "ecoConsciousness": 61, "priceSensitivity": 56, "digitalConsumption": 80}	{"taxTolerance": 74, "governmentTrust": 39, "policyAcceptance": 53, "regulationPreference": 73, "publicServiceSatisfaction": 70}	0
3533	홍지우	35	30-39	Female	서울특별시	37.574089	126.959642	전문대 졸	500-700만원	자영업	1인 가구	9	중도 무당층	58	{"economy": -11, "housing": 27, "welfare": 26, "security": -13, "environment": 46}	포털 뉴스	{환경,안정,다양성}	서울특별시에 거주하는 30-39 자영업. 정치 성향은 중도이며 환경, 안정, 다양성 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 72, "ecoConsciousness": 35, "priceSensitivity": 67, "digitalConsumption": 73}	{"taxTolerance": 53, "governmentTrust": 55, "policyAcceptance": 35, "regulationPreference": 56, "publicServiceSatisfaction": 60}	0
3534	이서윤	34	30-39	Female	서울특별시	37.622475	127.045275	대학교 졸	500-700만원	학생	1인 가구	-20	진보 성향 무당층	22	{"economy": -32, "housing": 11, "welfare": 26, "security": -39, "environment": 28}	포털 뉴스	{다양성,안정,성장}	서울특별시에 거주하는 30-39 학생. 정치 성향은 중도이며 다양성, 안정, 성장 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 70, "ecoConsciousness": 60, "priceSensitivity": 44, "digitalConsumption": 74}	{"taxTolerance": 49, "governmentTrust": 56, "policyAcceptance": 49, "regulationPreference": 61, "publicServiceSatisfaction": 72}	0
3535	임순자	35	30-39	Female	서울특별시	37.502618	127.076485	고졸 이하	500-700만원	사무직	부부 가구	-30	진보 성향 무당층	41	{"economy": -41, "housing": 34, "welfare": 35, "security": -41, "environment": 33}	SNS	{다양성,성장,공동체}	서울특별시에 거주하는 30-39 사무직. 정치 성향은 중도이며 다양성, 성장, 공동체 가치를 중시한다.	{"brandLoyalty": 66, "noveltySeeking": 59, "ecoConsciousness": 30, "priceSensitivity": 61, "digitalConsumption": 68}	{"taxTolerance": 46, "governmentTrust": 55, "policyAcceptance": 52, "regulationPreference": 56, "publicServiceSatisfaction": 54}	0
3536	서채원	37	30-39	Male	서울특별시	37.493128	127.015173	대학교 졸	350-500만원	서비스직	1인 가구	-22	진보 성향 무당층	69	{"economy": -9, "housing": 41, "welfare": 7, "security": -5, "environment": 31}	유튜브	{다양성,환경,안정}	서울특별시에 거주하는 30-39 서비스직. 정치 성향은 중도이며 다양성, 환경, 안정 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 62, "ecoConsciousness": 59, "priceSensitivity": 46, "digitalConsumption": 84}	{"taxTolerance": 58, "governmentTrust": 40, "policyAcceptance": 50, "regulationPreference": 62, "publicServiceSatisfaction": 55}	0
3537	박은우	30	30-39	Male	서울특별시	37.50758	126.959892	대학원 졸	200-350만원	사무직	부부 가구	-45	진보 정당 지지	40	{"economy": -18, "housing": 22, "welfare": 46, "security": -15, "environment": 24}	지상파/종편 뉴스	{자유,안전,성장}	서울특별시에 거주하는 30-39 사무직. 정치 성향은 진보이며 자유, 안전, 성장 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 59, "ecoConsciousness": 49, "priceSensitivity": 66, "digitalConsumption": 75}	{"taxTolerance": 78, "governmentTrust": 40, "policyAcceptance": 41, "regulationPreference": 65, "publicServiceSatisfaction": 55}	0
3538	권유준	36	30-39	Male	서울특별시	37.494713	126.950057	대학원 졸	700만원 이상	학생	다세대 가구	4	중도 무당층	46	{"economy": 6, "housing": -1, "welfare": 26, "security": 21, "environment": 55}	유튜브	{환경,자유,안정}	서울특별시에 거주하는 30-39 학생. 정치 성향은 중도이며 환경, 자유, 안정 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 63, "ecoConsciousness": 47, "priceSensitivity": 61, "digitalConsumption": 93}	{"taxTolerance": 69, "governmentTrust": 47, "policyAcceptance": 49, "regulationPreference": 58, "publicServiceSatisfaction": 57}	0
3539	오순자	30	30-39	Male	서울특별시	37.582657	127.007214	대학원 졸	200만원 미만	사무직	1인 가구	-58	진보 정당 지지	61	{"economy": -49, "housing": 72, "welfare": 45, "security": -32, "environment": 54}	지상파/종편 뉴스	{자유,성장,다양성}	서울특별시에 거주하는 30-39 사무직. 정치 성향은 진보이며 자유, 성장, 다양성 가치를 중시한다.	{"brandLoyalty": 67, "noveltySeeking": 76, "ecoConsciousness": 67, "priceSensitivity": 73, "digitalConsumption": 73}	{"taxTolerance": 76, "governmentTrust": 47, "policyAcceptance": 36, "regulationPreference": 59, "publicServiceSatisfaction": 66}	0
3540	홍예준	37	30-39	Male	서울특별시	37.61735	126.912613	대학교 졸	350-500만원	자영업	다세대 가구	-21	진보 성향 무당층	69	{"economy": -28, "housing": 17, "welfare": 17, "security": -12, "environment": 33}	SNS	{다양성,환경,공정}	서울특별시에 거주하는 30-39 자영업. 정치 성향은 중도이며 다양성, 환경, 공정 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 68, "ecoConsciousness": 60, "priceSensitivity": 72, "digitalConsumption": 58}	{"taxTolerance": 64, "governmentTrust": 62, "policyAcceptance": 58, "regulationPreference": 59, "publicServiceSatisfaction": 46}	0
3541	권채원	35	30-39	Male	서울특별시	37.586705	126.940688	고졸 이하	350-500만원	공무원	부부 가구	-63	진보 정당 지지	47	{"economy": -55, "housing": 42, "welfare": 8, "security": -22, "environment": 45}	포털 뉴스	{환경,성장,안정}	서울특별시에 거주하는 30-39 공무원. 정치 성향은 진보이며 환경, 성장, 안정 가치를 중시한다.	{"brandLoyalty": 24, "noveltySeeking": 38, "ecoConsciousness": 35, "priceSensitivity": 64, "digitalConsumption": 47}	{"taxTolerance": 40, "governmentTrust": 50, "policyAcceptance": 49, "regulationPreference": 65, "publicServiceSatisfaction": 64}	0
3542	송동현	33	30-39	Male	서울특별시	37.623547	127.045467	대학교 졸	700만원 이상	학생	자녀 양육 가구	-64	진보 정당 지지	41	{"economy": -43, "housing": 39, "welfare": 40, "security": -48, "environment": 41}	SNS	{안정,공정,공동체}	서울특별시에 거주하는 30-39 학생. 정치 성향은 진보이며 안정, 공정, 공동체 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 71, "ecoConsciousness": 53, "priceSensitivity": 58, "digitalConsumption": 65}	{"taxTolerance": 68, "governmentTrust": 44, "policyAcceptance": 47, "regulationPreference": 64, "publicServiceSatisfaction": 85}	0
3543	신주원	30	30-39	Male	서울특별시	37.623017	126.985814	대학원 졸	700만원 이상	프리랜서	자녀 양육 가구	-28	진보 성향 무당층	61	{"economy": -31, "housing": 7, "welfare": 16, "security": -26, "environment": 12}	신문/팟캐스트	{혁신,다양성,안정}	서울특별시에 거주하는 30-39 프리랜서. 정치 성향은 중도이며 혁신, 다양성, 안정 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 69, "ecoConsciousness": 43, "priceSensitivity": 27, "digitalConsumption": 76}	{"taxTolerance": 30, "governmentTrust": 38, "policyAcceptance": 43, "regulationPreference": 71, "publicServiceSatisfaction": 72}	0
3544	송채원	35	30-39	Male	서울특별시	37.567882	126.956365	대학교 졸	200만원 미만	생산직	자녀 양육 가구	21	보수 성향 무당층	42	{"economy": -4, "housing": 10, "welfare": -21, "security": -8, "environment": 21}	포털 뉴스	{공정,전통,다양성}	서울특별시에 거주하는 30-39 생산직. 정치 성향은 중도이며 공정, 전통, 다양성 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 59, "ecoConsciousness": 55, "priceSensitivity": 91, "digitalConsumption": 56}	{"taxTolerance": 56, "governmentTrust": 39, "policyAcceptance": 56, "regulationPreference": 52, "publicServiceSatisfaction": 82}	0
3545	조민서	34	30-39	Male	서울특별시	37.633986	126.905455	대학원 졸	500-700만원	서비스직	부부 가구	-23	진보 성향 무당층	62	{"economy": -46, "housing": 37, "welfare": 33, "security": -12, "environment": 22}	SNS	{다양성,안전,혁신}	서울특별시에 거주하는 30-39 서비스직. 정치 성향은 중도이며 다양성, 안전, 혁신 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 64, "ecoConsciousness": 66, "priceSensitivity": 55, "digitalConsumption": 70}	{"taxTolerance": 55, "governmentTrust": 24, "policyAcceptance": 35, "regulationPreference": 74, "publicServiceSatisfaction": 64}	0
3546	전민서	36	30-39	Male	서울특별시	37.507873	126.941987	전문대 졸	500-700만원	공무원	자녀 양육 가구	-11	중도 무당층	57	{"economy": -27, "housing": 16, "welfare": -14, "security": -18, "environment": 49}	SNS	{성장,안정,자유}	서울특별시에 거주하는 30-39 공무원. 정치 성향은 중도이며 성장, 안정, 자유 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 64, "ecoConsciousness": 61, "priceSensitivity": 60, "digitalConsumption": 84}	{"taxTolerance": 58, "governmentTrust": 51, "policyAcceptance": 42, "regulationPreference": 75, "publicServiceSatisfaction": 80}	0
3547	이미경	43	40-49	Female	서울특별시	37.526189	126.979684	대학교 졸	200-350만원	전문직	자녀 양육 가구	9	중도 무당층	75	{"economy": -4, "housing": 32, "welfare": 15, "security": 17, "environment": 36}	신문/팟캐스트	{환경,공동체,공정}	서울특별시에 거주하는 40-49 전문직. 정치 성향은 중도이며 환경, 공동체, 공정 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 54, "ecoConsciousness": 59, "priceSensitivity": 46, "digitalConsumption": 73}	{"taxTolerance": 46, "governmentTrust": 48, "policyAcceptance": 66, "regulationPreference": 64, "publicServiceSatisfaction": 73}	0
3548	최건우	47	40-49	Female	서울특별시	37.629119	126.961296	전문대 졸	700만원 이상	사무직	자녀 양육 가구	-10	중도 무당층	58	{"economy": 10, "housing": 11, "welfare": 14, "security": -4, "environment": 27}	포털 뉴스	{공정,안전,안정}	서울특별시에 거주하는 40-49 사무직. 정치 성향은 중도이며 공정, 안전, 안정 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 56, "ecoConsciousness": 56, "priceSensitivity": 47, "digitalConsumption": 65}	{"taxTolerance": 44, "governmentTrust": 35, "policyAcceptance": 42, "regulationPreference": 58, "publicServiceSatisfaction": 80}	0
3549	이정희	43	40-49	Female	서울특별시	37.628605	126.923327	전문대 졸	200-350만원	서비스직	다세대 가구	-10	중도 무당층	54	{"economy": 33, "housing": 37, "welfare": 21, "security": -14, "environment": 1}	포털 뉴스	{환경,다양성,안정}	서울특별시에 거주하는 40-49 서비스직. 정치 성향은 중도이며 환경, 다양성, 안정 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 65, "ecoConsciousness": 52, "priceSensitivity": 69, "digitalConsumption": 80}	{"taxTolerance": 40, "governmentTrust": 46, "policyAcceptance": 71, "regulationPreference": 51, "publicServiceSatisfaction": 62}	0
3550	강정희	48	40-49	Female	서울특별시	37.574283	126.906785	고졸 이하	500-700만원	사무직	다세대 가구	-19	진보 성향 무당층	71	{"economy": -2, "housing": 20, "welfare": 29, "security": 4, "environment": 23}	SNS	{안전,환경,성장}	서울특별시에 거주하는 40-49 사무직. 정치 성향은 중도이며 안전, 환경, 성장 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 70, "ecoConsciousness": 68, "priceSensitivity": 56, "digitalConsumption": 61}	{"taxTolerance": 52, "governmentTrust": 59, "policyAcceptance": 58, "regulationPreference": 51, "publicServiceSatisfaction": 59}	0
3551	임지호	42	40-49	Female	서울특별시	37.636308	127.025657	전문대 졸	350-500만원	학생	부부 가구	-32	진보 성향 무당층	72	{"economy": -7, "housing": 39, "welfare": 29, "security": 3, "environment": 14}	신문/팟캐스트	{환경,성장,다양성}	서울특별시에 거주하는 40-49 학생. 정치 성향은 중도이며 환경, 성장, 다양성 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 45, "ecoConsciousness": 40, "priceSensitivity": 57, "digitalConsumption": 76}	{"taxTolerance": 45, "governmentTrust": 42, "policyAcceptance": 54, "regulationPreference": 55, "publicServiceSatisfaction": 70}	0
3552	최동현	47	40-49	Female	서울특별시	37.599354	126.992887	전문대 졸	350-500만원	자영업	부부 가구	-15	진보 성향 무당층	79	{"economy": -26, "housing": 15, "welfare": 25, "security": -8, "environment": 28}	지상파/종편 뉴스	{안전,안정,다양성}	서울특별시에 거주하는 40-49 자영업. 정치 성향은 중도이며 안전, 안정, 다양성 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 56, "ecoConsciousness": 39, "priceSensitivity": 47, "digitalConsumption": 77}	{"taxTolerance": 36, "governmentTrust": 42, "policyAcceptance": 41, "regulationPreference": 51, "publicServiceSatisfaction": 61}	0
3553	서은우	48	40-49	Female	서울특별시	37.534341	127.053132	대학교 졸	200만원 미만	서비스직	자녀 양육 가구	-36	진보 성향 무당층	54	{"economy": -40, "housing": -10, "welfare": 39, "security": -29, "environment": 64}	SNS	{안전,다양성,공동체}	서울특별시에 거주하는 40-49 서비스직. 정치 성향은 진보이며 안전, 다양성, 공동체 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 53, "ecoConsciousness": 46, "priceSensitivity": 78, "digitalConsumption": 87}	{"taxTolerance": 58, "governmentTrust": 67, "policyAcceptance": 72, "regulationPreference": 74, "publicServiceSatisfaction": 56}	0
3554	강순자	41	40-49	Female	서울특별시	37.586961	126.964545	대학원 졸	700만원 이상	공무원	1인 가구	-27	진보 성향 무당층	46	{"economy": -38, "housing": 41, "welfare": -8, "security": 15, "environment": 23}	유튜브	{안전,환경,혁신}	서울특별시에 거주하는 40-49 공무원. 정치 성향은 중도이며 안전, 환경, 혁신 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 72, "ecoConsciousness": 67, "priceSensitivity": 62, "digitalConsumption": 65}	{"taxTolerance": 62, "governmentTrust": 51, "policyAcceptance": 45, "regulationPreference": 86, "publicServiceSatisfaction": 78}	0
3555	정지민	42	40-49	Female	서울특별시	37.594108	126.903373	전문대 졸	700만원 이상	전문직	부부 가구	17	보수 성향 무당층	44	{"economy": -2, "housing": 8, "welfare": 4, "security": 6, "environment": 6}	포털 뉴스	{환경,안전,성장}	서울특별시에 거주하는 40-49 전문직. 정치 성향은 중도이며 환경, 안전, 성장 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 62, "ecoConsciousness": 62, "priceSensitivity": 57, "digitalConsumption": 86}	{"taxTolerance": 59, "governmentTrust": 46, "policyAcceptance": 44, "regulationPreference": 72, "publicServiceSatisfaction": 62}	0
3556	홍도윤	46	40-49	Female	서울특별시	37.547062	126.894311	대학원 졸	200-350만원	은퇴	부부 가구	14	중도 무당층	67	{"economy": 24, "housing": 20, "welfare": -3, "security": -2, "environment": 18}	포털 뉴스	{공동체,전통,공정}	서울특별시에 거주하는 40-49 은퇴. 정치 성향은 중도이며 공동체, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 54, "ecoConsciousness": 64, "priceSensitivity": 52, "digitalConsumption": 75}	{"taxTolerance": 48, "governmentTrust": 44, "policyAcceptance": 47, "regulationPreference": 78, "publicServiceSatisfaction": 66}	0
3557	박철수	43	40-49	Female	서울특별시	37.608488	126.913878	전문대 졸	200만원 미만	사무직	자녀 양육 가구	-34	진보 성향 무당층	79	{"economy": -3, "housing": 37, "welfare": 18, "security": -36, "environment": 41}	신문/팟캐스트	{전통,안전,자유}	서울특별시에 거주하는 40-49 사무직. 정치 성향은 진보이며 전통, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 62, "ecoConsciousness": 38, "priceSensitivity": 58, "digitalConsumption": 75}	{"taxTolerance": 37, "governmentTrust": 28, "policyAcceptance": 59, "regulationPreference": 75, "publicServiceSatisfaction": 64}	0
3558	서은우	48	40-49	Female	서울특별시	37.540411	127.064511	대학교 졸	700만원 이상	프리랜서	자녀 양육 가구	-1	중도 무당층	68	{"economy": 6, "housing": 9, "welfare": 39, "security": 31, "environment": 19}	SNS	{전통,안정,공정}	서울특별시에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 전통, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 25, "noveltySeeking": 62, "ecoConsciousness": 67, "priceSensitivity": 31, "digitalConsumption": 61}	{"taxTolerance": 69, "governmentTrust": 68, "policyAcceptance": 48, "regulationPreference": 59, "publicServiceSatisfaction": 61}	0
3559	임혜진	42	40-49	Female	서울특별시	37.564358	127.030349	전문대 졸	700만원 이상	자영업	부부 가구	-50	진보 정당 지지	65	{"economy": -40, "housing": 29, "welfare": 31, "security": -13, "environment": 37}	포털 뉴스	{안정,다양성,환경}	서울특별시에 거주하는 40-49 자영업. 정치 성향은 진보이며 안정, 다양성, 환경 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 62, "ecoConsciousness": 57, "priceSensitivity": 64, "digitalConsumption": 88}	{"taxTolerance": 39, "governmentTrust": 30, "policyAcceptance": 42, "regulationPreference": 61, "publicServiceSatisfaction": 71}	0
3560	이유준	49	40-49	Male	서울특별시	37.558095	127.025982	전문대 졸	500-700만원	공무원	다세대 가구	-25	진보 성향 무당층	75	{"economy": -17, "housing": 23, "welfare": 26, "security": -3, "environment": 20}	SNS	{성장,자유,안전}	서울특별시에 거주하는 40-49 공무원. 정치 성향은 중도이며 성장, 자유, 안전 가치를 중시한다.	{"brandLoyalty": 23, "noveltySeeking": 61, "ecoConsciousness": 70, "priceSensitivity": 37, "digitalConsumption": 65}	{"taxTolerance": 32, "governmentTrust": 47, "policyAcceptance": 43, "regulationPreference": 76, "publicServiceSatisfaction": 66}	0
3561	홍건우	44	40-49	Male	서울특별시	37.502994	126.949765	대학원 졸	200-350만원	서비스직	1인 가구	-25	진보 성향 무당층	64	{"economy": -29, "housing": 34, "welfare": 5, "security": -28, "environment": 43}	신문/팟캐스트	{성장,다양성,공동체}	서울특별시에 거주하는 40-49 서비스직. 정치 성향은 중도이며 성장, 다양성, 공동체 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 67, "ecoConsciousness": 57, "priceSensitivity": 60, "digitalConsumption": 100}	{"taxTolerance": 49, "governmentTrust": 47, "policyAcceptance": 42, "regulationPreference": 62, "publicServiceSatisfaction": 74}	0
3562	서광수	44	40-49	Male	서울특별시	37.49855	126.941071	전문대 졸	350-500만원	사무직	자녀 양육 가구	0	중도 무당층	77	{"economy": -4, "housing": 7, "welfare": 25, "security": 5, "environment": -7}	유튜브	{자유,성장,다양성}	서울특별시에 거주하는 40-49 사무직. 정치 성향은 중도이며 자유, 성장, 다양성 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 72, "ecoConsciousness": 58, "priceSensitivity": 53, "digitalConsumption": 78}	{"taxTolerance": 67, "governmentTrust": 52, "policyAcceptance": 47, "regulationPreference": 70, "publicServiceSatisfaction": 74}	0
3563	한건우	42	40-49	Male	서울특별시	37.642272	126.912392	전문대 졸	700만원 이상	은퇴	부부 가구	5	중도 무당층	79	{"economy": 4, "housing": 20, "welfare": 32, "security": 23, "environment": -5}	신문/팟캐스트	{환경,공동체,다양성}	서울특별시에 거주하는 40-49 은퇴. 정치 성향은 중도이며 환경, 공동체, 다양성 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 54, "ecoConsciousness": 37, "priceSensitivity": 52, "digitalConsumption": 68}	{"taxTolerance": 43, "governmentTrust": 78, "policyAcceptance": 57, "regulationPreference": 79, "publicServiceSatisfaction": 70}	0
3564	임하은	47	40-49	Male	서울특별시	37.558807	126.882127	전문대 졸	350-500만원	전문직	다세대 가구	-7	중도 무당층	77	{"economy": -26, "housing": 23, "welfare": 24, "security": -10, "environment": 25}	포털 뉴스	{혁신,공동체,성장}	서울특별시에 거주하는 40-49 전문직. 정치 성향은 중도이며 혁신, 공동체, 성장 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 59, "ecoConsciousness": 37, "priceSensitivity": 47, "digitalConsumption": 82}	{"taxTolerance": 52, "governmentTrust": 50, "policyAcceptance": 56, "regulationPreference": 56, "publicServiceSatisfaction": 64}	0
3565	최서연	45	40-49	Male	서울특별시	37.514283	126.964785	대학교 졸	350-500만원	주부	부부 가구	-37	진보 성향 무당층	78	{"economy": -36, "housing": 0, "welfare": 6, "security": -13, "environment": 18}	지상파/종편 뉴스	{전통,성장,자유}	서울특별시에 거주하는 40-49 주부. 정치 성향은 진보이며 전통, 성장, 자유 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 62, "ecoConsciousness": 71, "priceSensitivity": 53, "digitalConsumption": 80}	{"taxTolerance": 49, "governmentTrust": 45, "policyAcceptance": 48, "regulationPreference": 75, "publicServiceSatisfaction": 76}	0
3566	권지우	43	40-49	Male	서울특별시	37.500014	127.071676	전문대 졸	200만원 미만	생산직	다세대 가구	-7	중도 무당층	67	{"economy": -19, "housing": 20, "welfare": 42, "security": 24, "environment": 40}	지상파/종편 뉴스	{공정,다양성,안정}	서울특별시에 거주하는 40-49 생산직. 정치 성향은 중도이며 공정, 다양성, 안정 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 64, "ecoConsciousness": 57, "priceSensitivity": 87, "digitalConsumption": 78}	{"taxTolerance": 45, "governmentTrust": 40, "policyAcceptance": 59, "regulationPreference": 69, "publicServiceSatisfaction": 87}	0
3567	이유준	42	40-49	Male	서울특별시	37.566575	126.932622	고졸 이하	200-350만원	전문직	1인 가구	-50	진보 정당 지지	38	{"economy": -54, "housing": 40, "welfare": 21, "security": -50, "environment": 34}	지상파/종편 뉴스	{안전,성장,혁신}	서울특별시에 거주하는 40-49 전문직. 정치 성향은 진보이며 안전, 성장, 혁신 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 70, "ecoConsciousness": 39, "priceSensitivity": 69, "digitalConsumption": 58}	{"taxTolerance": 39, "governmentTrust": 50, "policyAcceptance": 50, "regulationPreference": 70, "publicServiceSatisfaction": 64}	0
3568	신다은	49	40-49	Male	서울특별시	37.526188	126.910101	고졸 이하	200만원 미만	프리랜서	부부 가구	-9	중도 무당층	32	{"economy": -10, "housing": 34, "welfare": 31, "security": 11, "environment": 49}	유튜브	{환경,전통,공동체}	서울특별시에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 환경, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 41, "ecoConsciousness": 53, "priceSensitivity": 73, "digitalConsumption": 74}	{"taxTolerance": 30, "governmentTrust": 55, "policyAcceptance": 68, "regulationPreference": 49, "publicServiceSatisfaction": 63}	0
3569	이민서	40	40-49	Male	서울특별시	37.625349	126.898588	전문대 졸	200-350만원	은퇴	다세대 가구	-30	진보 성향 무당층	51	{"economy": -8, "housing": 42, "welfare": 27, "security": 5, "environment": 26}	지상파/종편 뉴스	{전통,공정,다양성}	서울특별시에 거주하는 40-49 은퇴. 정치 성향은 중도이며 전통, 공정, 다양성 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 75, "ecoConsciousness": 68, "priceSensitivity": 50, "digitalConsumption": 74}	{"taxTolerance": 49, "governmentTrust": 53, "policyAcceptance": 37, "regulationPreference": 80, "publicServiceSatisfaction": 50}	0
3570	박수아	48	40-49	Male	서울특별시	37.577284	127.024521	전문대 졸	200만원 미만	공무원	부부 가구	-35	진보 성향 무당층	77	{"economy": -58, "housing": 34, "welfare": 21, "security": -47, "environment": -4}	포털 뉴스	{전통,안전,혁신}	서울특별시에 거주하는 40-49 공무원. 정치 성향은 진보이며 전통, 안전, 혁신 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 56, "ecoConsciousness": 57, "priceSensitivity": 90, "digitalConsumption": 63}	{"taxTolerance": 44, "governmentTrust": 38, "policyAcceptance": 42, "regulationPreference": 73, "publicServiceSatisfaction": 76}	0
3571	이미경	48	40-49	Male	서울특별시	37.528575	126.932138	전문대 졸	700만원 이상	공무원	자녀 양육 가구	2	중도 무당층	58	{"economy": -10, "housing": 24, "welfare": 13, "security": 16, "environment": 17}	SNS	{공동체,자유,안정}	서울특별시에 거주하는 40-49 공무원. 정치 성향은 중도이며 공동체, 자유, 안정 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 75, "ecoConsciousness": 39, "priceSensitivity": 55, "digitalConsumption": 70}	{"taxTolerance": 32, "governmentTrust": 52, "policyAcceptance": 44, "regulationPreference": 60, "publicServiceSatisfaction": 61}	0
3572	홍준서	43	40-49	Male	서울특별시	37.594363	127.014057	전문대 졸	700만원 이상	자영업	자녀 양육 가구	-17	진보 성향 무당층	53	{"economy": -13, "housing": 41, "welfare": 2, "security": -2, "environment": 33}	유튜브	{공동체,혁신,공정}	서울특별시에 거주하는 40-49 자영업. 정치 성향은 중도이며 공동체, 혁신, 공정 가치를 중시한다.	{"brandLoyalty": 75, "noveltySeeking": 63, "ecoConsciousness": 44, "priceSensitivity": 53, "digitalConsumption": 78}	{"taxTolerance": 44, "governmentTrust": 41, "policyAcceptance": 54, "regulationPreference": 58, "publicServiceSatisfaction": 83}	0
3573	안광수	52	50-59	Female	서울특별시	37.640313	127.053536	고졸 이하	500-700만원	프리랜서	자녀 양육 가구	-1	중도 무당층	49	{"economy": 9, "housing": 17, "welfare": 27, "security": 8, "environment": 39}	신문/팟캐스트	{혁신,전통,성장}	서울특별시에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 혁신, 전통, 성장 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 63, "ecoConsciousness": 47, "priceSensitivity": 58, "digitalConsumption": 69}	{"taxTolerance": 35, "governmentTrust": 56, "policyAcceptance": 70, "regulationPreference": 53, "publicServiceSatisfaction": 64}	0
3574	안혜진	56	50-59	Female	서울특별시	37.531956	126.946367	전문대 졸	350-500만원	프리랜서	1인 가구	23	보수 성향 무당층	67	{"economy": 39, "housing": 11, "welfare": -1, "security": 8, "environment": 21}	유튜브	{안전,안정,자유}	서울특별시에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 안전, 안정, 자유 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 56, "ecoConsciousness": 43, "priceSensitivity": 53, "digitalConsumption": 58}	{"taxTolerance": 38, "governmentTrust": 59, "policyAcceptance": 53, "regulationPreference": 81, "publicServiceSatisfaction": 68}	0
3575	류지아	50	50-59	Female	서울특별시	37.610732	126.95303	대학교 졸	700만원 이상	공무원	1인 가구	39	보수 성향 무당층	68	{"economy": 50, "housing": -35, "welfare": -10, "security": 33, "environment": 11}	SNS	{다양성,안전,환경}	서울특별시에 거주하는 50-59 공무원. 정치 성향은 보수이며 다양성, 안전, 환경 가치를 중시한다.	{"brandLoyalty": 23, "noveltySeeking": 70, "ecoConsciousness": 32, "priceSensitivity": 50, "digitalConsumption": 77}	{"taxTolerance": 41, "governmentTrust": 59, "policyAcceptance": 57, "regulationPreference": 63, "publicServiceSatisfaction": 75}	0
3576	최미경	56	50-59	Female	서울특별시	37.49515	126.973851	대학교 졸	700만원 이상	자영업	부부 가구	14	중도 무당층	77	{"economy": 3, "housing": 32, "welfare": 4, "security": -18, "environment": 12}	신문/팟캐스트	{안정,자유,혁신}	서울특별시에 거주하는 50-59 자영업. 정치 성향은 중도이며 안정, 자유, 혁신 가치를 중시한다.	{"brandLoyalty": 60, "noveltySeeking": 67, "ecoConsciousness": 53, "priceSensitivity": 46, "digitalConsumption": 69}	{"taxTolerance": 45, "governmentTrust": 58, "policyAcceptance": 66, "regulationPreference": 76, "publicServiceSatisfaction": 83}	0
3577	정서연	52	50-59	Female	서울특별시	37.638973	126.992726	고졸 이하	700만원 이상	생산직	자녀 양육 가구	-43	진보 성향 무당층	69	{"economy": -24, "housing": -2, "welfare": 28, "security": -18, "environment": 57}	신문/팟캐스트	{혁신,전통,자유}	서울특별시에 거주하는 50-59 생산직. 정치 성향은 진보이며 혁신, 전통, 자유 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 46, "ecoConsciousness": 55, "priceSensitivity": 43, "digitalConsumption": 74}	{"taxTolerance": 46, "governmentTrust": 67, "policyAcceptance": 60, "regulationPreference": 59, "publicServiceSatisfaction": 70}	0
3578	윤도윤	51	50-59	Female	서울특별시	37.487489	126.962757	대학교 졸	500-700만원	학생	1인 가구	-20	진보 성향 무당층	62	{"economy": -12, "housing": 35, "welfare": 20, "security": 11, "environment": 17}	SNS	{공동체,전통,안전}	서울특별시에 거주하는 50-59 학생. 정치 성향은 중도이며 공동체, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 56, "ecoConsciousness": 40, "priceSensitivity": 60, "digitalConsumption": 53}	{"taxTolerance": 50, "governmentTrust": 67, "policyAcceptance": 36, "regulationPreference": 73, "publicServiceSatisfaction": 74}	0
3579	황미경	55	50-59	Female	서울특별시	37.629379	126.890929	대학교 졸	500-700만원	전문직	다세대 가구	-31	진보 성향 무당층	61	{"economy": -56, "housing": 10, "welfare": 21, "security": -4, "environment": 41}	지상파/종편 뉴스	{공정,자유,안정}	서울특별시에 거주하는 50-59 전문직. 정치 성향은 중도이며 공정, 자유, 안정 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 48, "ecoConsciousness": 42, "priceSensitivity": 52, "digitalConsumption": 67}	{"taxTolerance": 46, "governmentTrust": 54, "policyAcceptance": 55, "regulationPreference": 56, "publicServiceSatisfaction": 76}	0
3580	임성호	58	50-59	Female	서울특별시	37.54488	126.956484	고졸 이하	500-700만원	서비스직	다세대 가구	-18	진보 성향 무당층	75	{"economy": -34, "housing": 66, "welfare": 27, "security": -2, "environment": 34}	지상파/종편 뉴스	{안정,환경,자유}	서울특별시에 거주하는 50-59 서비스직. 정치 성향은 중도이며 안정, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 45, "ecoConsciousness": 45, "priceSensitivity": 49, "digitalConsumption": 55}	{"taxTolerance": 61, "governmentTrust": 60, "policyAcceptance": 54, "regulationPreference": 53, "publicServiceSatisfaction": 66}	0
3581	장유준	52	50-59	Female	서울특별시	37.508838	126.993317	전문대 졸	500-700만원	은퇴	부부 가구	-32	진보 성향 무당층	53	{"economy": -52, "housing": 12, "welfare": 50, "security": -8, "environment": 6}	유튜브	{혁신,안정,공동체}	서울특별시에 거주하는 50-59 은퇴. 정치 성향은 중도이며 혁신, 안정, 공동체 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 76, "ecoConsciousness": 64, "priceSensitivity": 66, "digitalConsumption": 75}	{"taxTolerance": 36, "governmentTrust": 65, "policyAcceptance": 69, "regulationPreference": 62, "publicServiceSatisfaction": 77}	0
3582	임준서	55	50-59	Female	서울특별시	37.52761	127.03911	대학교 졸	200-350만원	학생	부부 가구	-36	진보 성향 무당층	66	{"economy": -34, "housing": 35, "welfare": 23, "security": -29, "environment": 39}	SNS	{환경,안전,혁신}	서울특별시에 거주하는 50-59 학생. 정치 성향은 진보이며 환경, 안전, 혁신 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 51, "ecoConsciousness": 50, "priceSensitivity": 67, "digitalConsumption": 65}	{"taxTolerance": 52, "governmentTrust": 53, "policyAcceptance": 48, "regulationPreference": 71, "publicServiceSatisfaction": 41}	0
3583	장성호	50	50-59	Female	서울특별시	37.592796	127.069319	대학교 졸	350-500만원	학생	부부 가구	-44	진보 성향 무당층	71	{"economy": -4, "housing": 42, "welfare": 31, "security": -2, "environment": 45}	유튜브	{다양성,성장,전통}	서울특별시에 거주하는 50-59 학생. 정치 성향은 진보이며 다양성, 성장, 전통 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 49, "ecoConsciousness": 39, "priceSensitivity": 40, "digitalConsumption": 62}	{"taxTolerance": 39, "governmentTrust": 33, "policyAcceptance": 74, "regulationPreference": 62, "publicServiceSatisfaction": 78}	0
3584	이경숙	50	50-59	Female	서울특별시	37.633512	126.925209	대학교 졸	350-500만원	생산직	부부 가구	17	보수 성향 무당층	54	{"economy": 10, "housing": 28, "welfare": -18, "security": 36, "environment": 31}	SNS	{안정,성장,공정}	서울특별시에 거주하는 50-59 생산직. 정치 성향은 중도이며 안정, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 75, "ecoConsciousness": 67, "priceSensitivity": 84, "digitalConsumption": 75}	{"taxTolerance": 35, "governmentTrust": 48, "policyAcceptance": 45, "regulationPreference": 64, "publicServiceSatisfaction": 90}	0
3585	조영수	50	50-59	Female	서울특별시	37.629532	126.935385	대학원 졸	500-700만원	서비스직	다세대 가구	-45	진보 정당 지지	92	{"economy": -35, "housing": 44, "welfare": 13, "security": -13, "environment": 22}	신문/팟캐스트	{안전,공동체,안정}	서울특별시에 거주하는 50-59 서비스직. 정치 성향은 진보이며 안전, 공동체, 안정 가치를 중시한다.	{"brandLoyalty": 60, "noveltySeeking": 67, "ecoConsciousness": 50, "priceSensitivity": 53, "digitalConsumption": 66}	{"taxTolerance": 43, "governmentTrust": 64, "policyAcceptance": 67, "regulationPreference": 67, "publicServiceSatisfaction": 88}	0
3586	홍현우	56	50-59	Female	서울특별시	37.506968	126.981065	대학원 졸	500-700만원	자영업	1인 가구	-23	진보 성향 무당층	68	{"economy": -30, "housing": 28, "welfare": 17, "security": 21, "environment": 25}	포털 뉴스	{안전,자유,성장}	서울특별시에 거주하는 50-59 자영업. 정치 성향은 중도이며 안전, 자유, 성장 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 67, "ecoConsciousness": 69, "priceSensitivity": 32, "digitalConsumption": 72}	{"taxTolerance": 50, "governmentTrust": 28, "policyAcceptance": 44, "regulationPreference": 68, "publicServiceSatisfaction": 73}	0
3587	조수아	58	50-59	Female	서울특별시	37.505805	126.980526	대학교 졸	350-500만원	프리랜서	부부 가구	4	중도 무당층	83	{"economy": -5, "housing": 20, "welfare": 38, "security": 22, "environment": 21}	지상파/종편 뉴스	{자유,혁신,안전}	서울특별시에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 자유, 혁신, 안전 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 71, "ecoConsciousness": 45, "priceSensitivity": 72, "digitalConsumption": 53}	{"taxTolerance": 47, "governmentTrust": 62, "policyAcceptance": 50, "regulationPreference": 72, "publicServiceSatisfaction": 77}	0
3588	이철수	55	50-59	Male	서울특별시	37.59961	126.951075	대학원 졸	500-700만원	생산직	자녀 양육 가구	3	중도 무당층	75	{"economy": -14, "housing": 39, "welfare": 35, "security": 7, "environment": 11}	유튜브	{공정,안전,자유}	서울특별시에 거주하는 50-59 생산직. 정치 성향은 중도이며 공정, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 64, "ecoConsciousness": 66, "priceSensitivity": 70, "digitalConsumption": 56}	{"taxTolerance": 60, "governmentTrust": 34, "policyAcceptance": 39, "regulationPreference": 79, "publicServiceSatisfaction": 75}	0
3589	조경숙	58	50-59	Male	서울특별시	37.527673	126.885118	전문대 졸	200-350만원	전문직	부부 가구	11	중도 무당층	86	{"economy": -14, "housing": 10, "welfare": 25, "security": 15, "environment": 41}	SNS	{자유,다양성,전통}	서울특별시에 거주하는 50-59 전문직. 정치 성향은 중도이며 자유, 다양성, 전통 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 68, "ecoConsciousness": 46, "priceSensitivity": 57, "digitalConsumption": 43}	{"taxTolerance": 59, "governmentTrust": 66, "policyAcceptance": 36, "regulationPreference": 61, "publicServiceSatisfaction": 60}	0
3590	안다은	57	50-59	Male	서울특별시	37.583682	126.967852	대학교 졸	350-500만원	학생	자녀 양육 가구	54	보수 정당 지지	76	{"economy": 22, "housing": -12, "welfare": -18, "security": 11, "environment": 23}	신문/팟캐스트	{자유,환경,전통}	서울특별시에 거주하는 50-59 학생. 정치 성향은 보수이며 자유, 환경, 전통 가치를 중시한다.	{"brandLoyalty": 63, "noveltySeeking": 40, "ecoConsciousness": 56, "priceSensitivity": 56, "digitalConsumption": 66}	{"taxTolerance": 47, "governmentTrust": 43, "policyAcceptance": 46, "regulationPreference": 66, "publicServiceSatisfaction": 72}	0
3591	서서연	55	50-59	Male	서울특별시	37.516501	126.977252	전문대 졸	500-700만원	자영업	자녀 양육 가구	-19	진보 성향 무당층	82	{"economy": -21, "housing": 21, "welfare": 33, "security": -7, "environment": 52}	신문/팟캐스트	{자유,다양성,혁신}	서울특별시에 거주하는 50-59 자영업. 정치 성향은 중도이며 자유, 다양성, 혁신 가치를 중시한다.	{"brandLoyalty": 61, "noveltySeeking": 51, "ecoConsciousness": 56, "priceSensitivity": 61, "digitalConsumption": 60}	{"taxTolerance": 55, "governmentTrust": 62, "policyAcceptance": 59, "regulationPreference": 53, "publicServiceSatisfaction": 51}	0
3592	전현우	51	50-59	Male	서울특별시	37.550667	126.88567	대학교 졸	350-500만원	자영업	자녀 양육 가구	15	보수 성향 무당층	74	{"economy": 13, "housing": -4, "welfare": 2, "security": 1, "environment": 9}	지상파/종편 뉴스	{공정,자유,환경}	서울특별시에 거주하는 50-59 자영업. 정치 성향은 중도이며 공정, 자유, 환경 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 52, "ecoConsciousness": 58, "priceSensitivity": 49, "digitalConsumption": 81}	{"taxTolerance": 54, "governmentTrust": 44, "policyAcceptance": 48, "regulationPreference": 74, "publicServiceSatisfaction": 53}	0
3593	오민준	51	50-59	Male	서울특별시	37.549706	126.925788	전문대 졸	700만원 이상	학생	자녀 양육 가구	-12	중도 무당층	67	{"economy": -29, "housing": 44, "welfare": 13, "security": -10, "environment": 22}	SNS	{안정,자유,환경}	서울특별시에 거주하는 50-59 학생. 정치 성향은 중도이며 안정, 자유, 환경 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 43, "ecoConsciousness": 36, "priceSensitivity": 29, "digitalConsumption": 66}	{"taxTolerance": 33, "governmentTrust": 54, "policyAcceptance": 49, "regulationPreference": 68, "publicServiceSatisfaction": 80}	0
3594	홍도윤	50	50-59	Male	서울특별시	37.621692	127.039663	전문대 졸	350-500만원	은퇴	1인 가구	11	중도 무당층	58	{"economy": -11, "housing": 12, "welfare": 13, "security": 11, "environment": 33}	신문/팟캐스트	{안전,자유,전통}	서울특별시에 거주하는 50-59 은퇴. 정치 성향은 중도이며 안전, 자유, 전통 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 58, "ecoConsciousness": 67, "priceSensitivity": 66, "digitalConsumption": 61}	{"taxTolerance": 52, "governmentTrust": 43, "policyAcceptance": 43, "regulationPreference": 57, "publicServiceSatisfaction": 66}	0
3595	장서연	54	50-59	Male	서울특별시	37.565527	126.986427	대학교 졸	200만원 미만	은퇴	자녀 양육 가구	21	보수 성향 무당층	67	{"economy": -5, "housing": 30, "welfare": -16, "security": 22, "environment": 15}	유튜브	{전통,혁신,안정}	서울특별시에 거주하는 50-59 은퇴. 정치 성향은 중도이며 전통, 혁신, 안정 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 55, "ecoConsciousness": 53, "priceSensitivity": 71, "digitalConsumption": 62}	{"taxTolerance": 48, "governmentTrust": 45, "policyAcceptance": 38, "regulationPreference": 82, "publicServiceSatisfaction": 72}	0
3596	김준서	56	50-59	Male	서울특별시	37.610189	127.007602	고졸 이하	200만원 미만	주부	부부 가구	-10	중도 무당층	51	{"economy": -18, "housing": 16, "welfare": 12, "security": -8, "environment": 34}	신문/팟캐스트	{공정,안정,혁신}	서울특별시에 거주하는 50-59 주부. 정치 성향은 중도이며 공정, 안정, 혁신 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 47, "ecoConsciousness": 43, "priceSensitivity": 72, "digitalConsumption": 69}	{"taxTolerance": 50, "governmentTrust": 68, "policyAcceptance": 71, "regulationPreference": 76, "publicServiceSatisfaction": 51}	0
3597	조정희	52	50-59	Male	서울특별시	37.56745	127.058345	고졸 이하	350-500만원	주부	다세대 가구	-46	진보 정당 지지	68	{"economy": -29, "housing": 41, "welfare": 27, "security": -24, "environment": 49}	신문/팟캐스트	{환경,다양성,성장}	서울특별시에 거주하는 50-59 주부. 정치 성향은 진보이며 환경, 다양성, 성장 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 65, "ecoConsciousness": 36, "priceSensitivity": 49, "digitalConsumption": 60}	{"taxTolerance": 40, "governmentTrust": 41, "policyAcceptance": 45, "regulationPreference": 63, "publicServiceSatisfaction": 58}	0
3598	황영수	55	50-59	Male	서울특별시	37.633201	127.05438	전문대 졸	350-500만원	서비스직	다세대 가구	-32	진보 성향 무당층	67	{"economy": -38, "housing": 35, "welfare": 45, "security": -6, "environment": 44}	포털 뉴스	{혁신,안전,환경}	서울특별시에 거주하는 50-59 서비스직. 정치 성향은 중도이며 혁신, 안전, 환경 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 50, "ecoConsciousness": 50, "priceSensitivity": 57, "digitalConsumption": 72}	{"taxTolerance": 42, "governmentTrust": 72, "policyAcceptance": 50, "regulationPreference": 51, "publicServiceSatisfaction": 58}	0
3599	신광수	55	50-59	Male	서울특별시	37.531967	127.068375	고졸 이하	500-700만원	학생	다세대 가구	23	보수 성향 무당층	92	{"economy": -8, "housing": 5, "welfare": 24, "security": 16, "environment": 24}	지상파/종편 뉴스	{환경,안전,공동체}	서울특별시에 거주하는 50-59 학생. 정치 성향은 중도이며 환경, 안전, 공동체 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 28, "ecoConsciousness": 47, "priceSensitivity": 59, "digitalConsumption": 66}	{"taxTolerance": 64, "governmentTrust": 52, "policyAcceptance": 47, "regulationPreference": 58, "publicServiceSatisfaction": 53}	0
3600	류철수	53	50-59	Male	서울특별시	37.539522	126.963548	대학교 졸	500-700만원	사무직	1인 가구	-27	진보 성향 무당층	77	{"economy": -41, "housing": -1, "welfare": 12, "security": -1, "environment": 21}	SNS	{환경,안정,다양성}	서울특별시에 거주하는 50-59 사무직. 정치 성향은 중도이며 환경, 안정, 다양성 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 39, "ecoConsciousness": 50, "priceSensitivity": 39, "digitalConsumption": 66}	{"taxTolerance": 43, "governmentTrust": 55, "policyAcceptance": 62, "regulationPreference": 74, "publicServiceSatisfaction": 66}	0
3601	황예준	55	50-59	Male	서울특별시	37.569989	127.039748	고졸 이하	500-700만원	프리랜서	1인 가구	-29	진보 성향 무당층	57	{"economy": -9, "housing": 2, "welfare": 18, "security": -25, "environment": 24}	SNS	{공동체,안정,다양성}	서울특별시에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 공동체, 안정, 다양성 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 62, "ecoConsciousness": 37, "priceSensitivity": 39, "digitalConsumption": 68}	{"taxTolerance": 54, "governmentTrust": 61, "policyAcceptance": 52, "regulationPreference": 69, "publicServiceSatisfaction": 79}	0
3602	권유준	60	60-69	Female	서울특별시	37.592179	126.950802	전문대 졸	700만원 이상	은퇴	1인 가구	-4	중도 무당층	76	{"economy": -20, "housing": 9, "welfare": -4, "security": 33, "environment": 17}	신문/팟캐스트	{다양성,안정,환경}	서울특별시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 다양성, 안정, 환경 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 74, "ecoConsciousness": 34, "priceSensitivity": 59, "digitalConsumption": 71}	{"taxTolerance": 47, "governmentTrust": 59, "policyAcceptance": 47, "regulationPreference": 58, "publicServiceSatisfaction": 66}	0
3603	안미경	64	60-69	Female	서울특별시	37.513215	127.000452	대학교 졸	500-700만원	학생	부부 가구	-18	진보 성향 무당층	68	{"economy": -16, "housing": 36, "welfare": 41, "security": 1, "environment": 69}	SNS	{환경,안전,혁신}	서울특별시에 거주하는 60-69 학생. 정치 성향은 중도이며 환경, 안전, 혁신 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 57, "ecoConsciousness": 51, "priceSensitivity": 64, "digitalConsumption": 80}	{"taxTolerance": 39, "governmentTrust": 67, "policyAcceptance": 30, "regulationPreference": 77, "publicServiceSatisfaction": 61}	0
3604	권주원	64	60-69	Female	서울특별시	37.502719	126.963346	고졸 이하	350-500만원	서비스직	자녀 양육 가구	-1	중도 무당층	68	{"economy": 18, "housing": 19, "welfare": 17, "security": -25, "environment": 2}	신문/팟캐스트	{공동체,안정,성장}	서울특별시에 거주하는 60-69 서비스직. 정치 성향은 중도이며 공동체, 안정, 성장 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 54, "ecoConsciousness": 54, "priceSensitivity": 65, "digitalConsumption": 68}	{"taxTolerance": 31, "governmentTrust": 57, "policyAcceptance": 38, "regulationPreference": 58, "publicServiceSatisfaction": 75}	0
3605	류혜진	60	60-69	Female	서울특별시	37.541396	127.008521	고졸 이하	500-700만원	학생	자녀 양육 가구	-37	진보 성향 무당층	59	{"economy": -42, "housing": 49, "welfare": 37, "security": -28, "environment": 16}	SNS	{자유,안정,환경}	서울특별시에 거주하는 60-69 학생. 정치 성향은 진보이며 자유, 안정, 환경 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 40, "ecoConsciousness": 45, "priceSensitivity": 38, "digitalConsumption": 74}	{"taxTolerance": 24, "governmentTrust": 44, "policyAcceptance": 51, "regulationPreference": 46, "publicServiceSatisfaction": 66}	0
3606	오정희	68	60-69	Female	서울특별시	37.566221	126.962419	대학교 졸	200-350만원	은퇴	자녀 양육 가구	10	중도 무당층	86	{"economy": -7, "housing": -15, "welfare": 6, "security": 22, "environment": 11}	신문/팟캐스트	{전통,환경,공동체}	서울특별시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 전통, 환경, 공동체 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 58, "ecoConsciousness": 49, "priceSensitivity": 66, "digitalConsumption": 66}	{"taxTolerance": 64, "governmentTrust": 56, "policyAcceptance": 79, "regulationPreference": 69, "publicServiceSatisfaction": 84}	0
3607	전준서	67	60-69	Female	서울특별시	37.609839	126.885142	전문대 졸	350-500만원	은퇴	자녀 양육 가구	-7	중도 무당층	84	{"economy": -1, "housing": 7, "welfare": 10, "security": 28, "environment": 15}	포털 뉴스	{자유,전통,안전}	서울특별시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 자유, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 64, "ecoConsciousness": 39, "priceSensitivity": 72, "digitalConsumption": 51}	{"taxTolerance": 43, "governmentTrust": 50, "policyAcceptance": 52, "regulationPreference": 65, "publicServiceSatisfaction": 62}	0
3608	윤서연	64	60-69	Female	서울특별시	37.577304	126.896286	전문대 졸	200-350만원	서비스직	1인 가구	22	보수 성향 무당층	71	{"economy": 19, "housing": -3, "welfare": -12, "security": -22, "environment": 8}	신문/팟캐스트	{공정,다양성,혁신}	서울특별시에 거주하는 60-69 서비스직. 정치 성향은 중도이며 공정, 다양성, 혁신 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 65, "ecoConsciousness": 46, "priceSensitivity": 75, "digitalConsumption": 53}	{"taxTolerance": 36, "governmentTrust": 58, "policyAcceptance": 68, "regulationPreference": 60, "publicServiceSatisfaction": 59}	0
3609	이수아	63	60-69	Female	서울특별시	37.512331	127.076538	대학교 졸	200만원 미만	자영업	자녀 양육 가구	3	중도 무당층	86	{"economy": 2, "housing": 14, "welfare": 40, "security": 26, "environment": 35}	신문/팟캐스트	{자유,공정,혁신}	서울특별시에 거주하는 60-69 자영업. 정치 성향은 중도이며 자유, 공정, 혁신 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 32, "ecoConsciousness": 52, "priceSensitivity": 83, "digitalConsumption": 76}	{"taxTolerance": 39, "governmentTrust": 58, "policyAcceptance": 50, "regulationPreference": 74, "publicServiceSatisfaction": 72}	0
3610	윤미경	62	60-69	Female	서울특별시	37.637233	126.999693	대학교 졸	500-700만원	전문직	1인 가구	-50	진보 정당 지지	72	{"economy": -29, "housing": 66, "welfare": 58, "security": -11, "environment": 22}	지상파/종편 뉴스	{공동체,안정,공정}	서울특별시에 거주하는 60-69 전문직. 정치 성향은 진보이며 공동체, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 61, "ecoConsciousness": 43, "priceSensitivity": 58, "digitalConsumption": 72}	{"taxTolerance": 46, "governmentTrust": 58, "policyAcceptance": 44, "regulationPreference": 62, "publicServiceSatisfaction": 69}	0
3611	장영수	67	60-69	Female	서울특별시	37.603972	127.021589	전문대 졸	350-500만원	은퇴	1인 가구	-11	중도 무당층	73	{"economy": -12, "housing": 23, "welfare": 10, "security": 32, "environment": 18}	지상파/종편 뉴스	{안전,공정,다양성}	서울특별시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 안전, 공정, 다양성 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 49, "ecoConsciousness": 35, "priceSensitivity": 61, "digitalConsumption": 60}	{"taxTolerance": 50, "governmentTrust": 63, "policyAcceptance": 26, "regulationPreference": 56, "publicServiceSatisfaction": 62}	0
3612	최성호	67	60-69	Female	서울특별시	37.487298	126.879083	대학교 졸	200-350만원	은퇴	1인 가구	27	보수 성향 무당층	59	{"economy": -3, "housing": -1, "welfare": 4, "security": 27, "environment": -18}	신문/팟캐스트	{환경,혁신,다양성}	서울특별시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 환경, 혁신, 다양성 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 47, "ecoConsciousness": 38, "priceSensitivity": 68, "digitalConsumption": 52}	{"taxTolerance": 61, "governmentTrust": 28, "policyAcceptance": 61, "regulationPreference": 75, "publicServiceSatisfaction": 72}	0
3613	강수아	69	60-69	Female	서울특별시	37.493956	127.01553	대학원 졸	200만원 미만	은퇴	1인 가구	-25	진보 성향 무당층	67	{"economy": -22, "housing": 40, "welfare": 20, "security": 5, "environment": 30}	유튜브	{공정,안정,환경}	서울특별시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 공정, 안정, 환경 가치를 중시한다.	{"brandLoyalty": 68, "noveltySeeking": 49, "ecoConsciousness": 49, "priceSensitivity": 72, "digitalConsumption": 62}	{"taxTolerance": 66, "governmentTrust": 51, "policyAcceptance": 62, "regulationPreference": 76, "publicServiceSatisfaction": 66}	0
3614	한하은	61	60-69	Male	서울특별시	37.631434	127.0042	고졸 이하	200만원 미만	자영업	자녀 양육 가구	11	중도 무당층	68	{"economy": -32, "housing": -9, "welfare": -9, "security": 9, "environment": 11}	SNS	{안전,공정,공동체}	서울특별시에 거주하는 60-69 자영업. 정치 성향은 중도이며 안전, 공정, 공동체 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 58, "ecoConsciousness": 44, "priceSensitivity": 79, "digitalConsumption": 53}	{"taxTolerance": 45, "governmentTrust": 45, "policyAcceptance": 50, "regulationPreference": 60, "publicServiceSatisfaction": 80}	0
3615	최채원	62	60-69	Male	서울특별시	37.609271	126.914802	전문대 졸	350-500만원	사무직	자녀 양육 가구	-10	중도 무당층	80	{"economy": -28, "housing": 22, "welfare": -12, "security": -4, "environment": 17}	지상파/종편 뉴스	{다양성,성장,혁신}	서울특별시에 거주하는 60-69 사무직. 정치 성향은 중도이며 다양성, 성장, 혁신 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 45, "ecoConsciousness": 27, "priceSensitivity": 53, "digitalConsumption": 69}	{"taxTolerance": 61, "governmentTrust": 43, "policyAcceptance": 55, "regulationPreference": 57, "publicServiceSatisfaction": 77}	0
3616	류현우	64	60-69	Male	서울특별시	37.517768	126.963703	대학원 졸	350-500만원	학생	다세대 가구	11	중도 무당층	83	{"economy": -11, "housing": 13, "welfare": -25, "security": 11, "environment": 1}	포털 뉴스	{전통,공동체,환경}	서울특별시에 거주하는 60-69 학생. 정치 성향은 중도이며 전통, 공동체, 환경 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 56, "ecoConsciousness": 63, "priceSensitivity": 90, "digitalConsumption": 56}	{"taxTolerance": 54, "governmentTrust": 45, "policyAcceptance": 60, "regulationPreference": 59, "publicServiceSatisfaction": 49}	0
3617	정미경	63	60-69	Male	서울특별시	37.547739	127.039619	대학교 졸	500-700만원	공무원	자녀 양육 가구	41	보수 성향 무당층	64	{"economy": 33, "housing": 0, "welfare": 1, "security": 11, "environment": 27}	SNS	{혁신,전통,공동체}	서울특별시에 거주하는 60-69 공무원. 정치 성향은 보수이며 혁신, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 64, "noveltySeeking": 42, "ecoConsciousness": 53, "priceSensitivity": 64, "digitalConsumption": 61}	{"taxTolerance": 43, "governmentTrust": 60, "policyAcceptance": 49, "regulationPreference": 75, "publicServiceSatisfaction": 76}	0
3618	신철수	61	60-69	Male	서울특별시	37.590047	127.077859	전문대 졸	200만원 미만	전문직	자녀 양육 가구	-1	중도 무당층	64	{"economy": -3, "housing": 17, "welfare": 12, "security": 12, "environment": 12}	SNS	{환경,공동체,안정}	서울특별시에 거주하는 60-69 전문직. 정치 성향은 중도이며 환경, 공동체, 안정 가치를 중시한다.	{"brandLoyalty": 60, "noveltySeeking": 55, "ecoConsciousness": 43, "priceSensitivity": 83, "digitalConsumption": 67}	{"taxTolerance": 34, "governmentTrust": 37, "policyAcceptance": 59, "regulationPreference": 67, "publicServiceSatisfaction": 85}	0
3619	김예준	63	60-69	Male	서울특별시	37.603701	126.957522	전문대 졸	350-500만원	은퇴	부부 가구	-17	진보 성향 무당층	81	{"economy": 3, "housing": 10, "welfare": 41, "security": 6, "environment": 33}	SNS	{환경,공동체,전통}	서울특별시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 환경, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 66, "noveltySeeking": 57, "ecoConsciousness": 46, "priceSensitivity": 71, "digitalConsumption": 74}	{"taxTolerance": 46, "governmentTrust": 45, "policyAcceptance": 42, "regulationPreference": 73, "publicServiceSatisfaction": 59}	0
3620	오서윤	65	60-69	Male	서울특별시	37.537824	127.04187	대학교 졸	200-350만원	공무원	자녀 양육 가구	-20	진보 성향 무당층	56	{"economy": -19, "housing": 16, "welfare": 19, "security": 9, "environment": 48}	유튜브	{성장,안정,안전}	서울특별시에 거주하는 60-69 공무원. 정치 성향은 중도이며 성장, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 72, "ecoConsciousness": 63, "priceSensitivity": 73, "digitalConsumption": 53}	{"taxTolerance": 52, "governmentTrust": 63, "policyAcceptance": 49, "regulationPreference": 67, "publicServiceSatisfaction": 79}	0
3621	강철수	69	60-69	Male	서울특별시	37.578518	127.017134	대학교 졸	500-700만원	은퇴	1인 가구	2	중도 무당층	84	{"economy": 9, "housing": 16, "welfare": 26, "security": -4, "environment": 1}	유튜브	{전통,공동체,환경}	서울특별시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 전통, 공동체, 환경 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 51, "ecoConsciousness": 68, "priceSensitivity": 66, "digitalConsumption": 62}	{"taxTolerance": 42, "governmentTrust": 72, "policyAcceptance": 46, "regulationPreference": 73, "publicServiceSatisfaction": 77}	0
3622	류채원	65	60-69	Male	서울특별시	37.575647	126.954883	대학교 졸	350-500만원	공무원	부부 가구	0	중도 무당층	56	{"economy": 4, "housing": -5, "welfare": 3, "security": 7, "environment": 55}	지상파/종편 뉴스	{자유,성장,공정}	서울특별시에 거주하는 60-69 공무원. 정치 성향은 중도이며 자유, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 50, "ecoConsciousness": 37, "priceSensitivity": 60, "digitalConsumption": 61}	{"taxTolerance": 38, "governmentTrust": 44, "policyAcceptance": 25, "regulationPreference": 70, "publicServiceSatisfaction": 63}	0
3623	신영수	62	60-69	Male	서울특별시	37.506137	127.03729	고졸 이하	200만원 미만	은퇴	다세대 가구	37	보수 성향 무당층	78	{"economy": 14, "housing": -2, "welfare": 20, "security": 18, "environment": -3}	유튜브	{성장,자유,환경}	서울특별시에 거주하는 60-69 은퇴. 정치 성향은 보수이며 성장, 자유, 환경 가치를 중시한다.	{"brandLoyalty": 71, "noveltySeeking": 47, "ecoConsciousness": 40, "priceSensitivity": 79, "digitalConsumption": 60}	{"taxTolerance": 39, "governmentTrust": 54, "policyAcceptance": 46, "regulationPreference": 63, "publicServiceSatisfaction": 72}	0
3624	윤도윤	67	60-69	Male	서울특별시	37.575997	126.967415	고졸 이하	500-700만원	은퇴	부부 가구	27	보수 성향 무당층	78	{"economy": 8, "housing": 3, "welfare": -1, "security": 36, "environment": -8}	지상파/종편 뉴스	{다양성,전통,공동체}	서울특별시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 다양성, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 42, "ecoConsciousness": 34, "priceSensitivity": 70, "digitalConsumption": 61}	{"taxTolerance": 41, "governmentTrust": 51, "policyAcceptance": 49, "regulationPreference": 64, "publicServiceSatisfaction": 71}	0
3625	이주원	66	60-69	Male	서울특별시	37.505723	126.954382	전문대 졸	350-500만원	학생	다세대 가구	-17	진보 성향 무당층	99	{"economy": 3, "housing": 31, "welfare": 7, "security": -18, "environment": 45}	유튜브	{안전,다양성,공정}	서울특별시에 거주하는 60-69 학생. 정치 성향은 중도이며 안전, 다양성, 공정 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 53, "ecoConsciousness": 39, "priceSensitivity": 62, "digitalConsumption": 50}	{"taxTolerance": 47, "governmentTrust": 60, "policyAcceptance": 68, "regulationPreference": 65, "publicServiceSatisfaction": 67}	0
3626	박지우	80	70+	Female	서울특별시	37.562982	127.020482	대학교 졸	500-700만원	은퇴	다세대 가구	7	중도 무당층	81	{"economy": -12, "housing": 1, "welfare": 17, "security": -19, "environment": 33}	지상파/종편 뉴스	{환경,안정,안전}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 환경, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 58, "ecoConsciousness": 47, "priceSensitivity": 48, "digitalConsumption": 62}	{"taxTolerance": 37, "governmentTrust": 52, "policyAcceptance": 56, "regulationPreference": 84, "publicServiceSatisfaction": 73}	0
3627	장혜진	79	70+	Female	서울특별시	37.63943	126.881205	대학원 졸	350-500만원	은퇴	다세대 가구	2	중도 무당층	81	{"economy": 7, "housing": 34, "welfare": -6, "security": 14, "environment": 4}	SNS	{전통,안정,자유}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 전통, 안정, 자유 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 42, "ecoConsciousness": 58, "priceSensitivity": 55, "digitalConsumption": 65}	{"taxTolerance": 51, "governmentTrust": 45, "policyAcceptance": 60, "regulationPreference": 61, "publicServiceSatisfaction": 52}	0
3628	윤지호	76	70+	Female	서울특별시	37.599589	126.92193	대학교 졸	200만원 미만	은퇴	1인 가구	46	보수 정당 지지	86	{"economy": 12, "housing": 33, "welfare": -23, "security": 64, "environment": 5}	지상파/종편 뉴스	{공동체,성장,다양성}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 공동체, 성장, 다양성 가치를 중시한다.	{"brandLoyalty": 60, "noveltySeeking": 44, "ecoConsciousness": 44, "priceSensitivity": 75, "digitalConsumption": 50}	{"taxTolerance": 35, "governmentTrust": 52, "policyAcceptance": 39, "regulationPreference": 66, "publicServiceSatisfaction": 72}	0
3629	박민서	75	70+	Female	서울특별시	37.513375	126.91064	대학교 졸	200만원 미만	은퇴	다세대 가구	21	보수 성향 무당층	99	{"economy": 6, "housing": 10, "welfare": 6, "security": 5, "environment": 4}	SNS	{공정,안전,성장}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공정, 안전, 성장 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 31, "ecoConsciousness": 61, "priceSensitivity": 78, "digitalConsumption": 64}	{"taxTolerance": 60, "governmentTrust": 39, "policyAcceptance": 60, "regulationPreference": 76, "publicServiceSatisfaction": 74}	0
3630	오민서	74	70+	Female	서울특별시	37.603323	127.036093	대학교 졸	200-350만원	은퇴	1인 가구	57	보수 정당 지지	94	{"economy": 19, "housing": -7, "welfare": -29, "security": 36, "environment": 13}	SNS	{안전,공정,성장}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안전, 공정, 성장 가치를 중시한다.	{"brandLoyalty": 64, "noveltySeeking": 52, "ecoConsciousness": 21, "priceSensitivity": 74, "digitalConsumption": 48}	{"taxTolerance": 59, "governmentTrust": 56, "policyAcceptance": 55, "regulationPreference": 81, "publicServiceSatisfaction": 55}	0
3631	장주원	75	70+	Female	서울특별시	37.587298	126.939941	전문대 졸	350-500만원	은퇴	다세대 가구	-8	중도 무당층	71	{"economy": -4, "housing": -16, "welfare": -2, "security": 2, "environment": 9}	지상파/종편 뉴스	{안전,혁신,성장}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안전, 혁신, 성장 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 34, "ecoConsciousness": 28, "priceSensitivity": 63, "digitalConsumption": 55}	{"taxTolerance": 46, "governmentTrust": 56, "policyAcceptance": 66, "regulationPreference": 48, "publicServiceSatisfaction": 65}	0
3632	송서연	75	70+	Female	서울특별시	37.620145	126.895882	대학원 졸	200-350만원	은퇴	다세대 가구	-8	중도 무당층	99	{"economy": -3, "housing": 34, "welfare": 46, "security": 5, "environment": 13}	유튜브	{환경,혁신,다양성}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 환경, 혁신, 다양성 가치를 중시한다.	{"brandLoyalty": 73, "noveltySeeking": 33, "ecoConsciousness": 56, "priceSensitivity": 59, "digitalConsumption": 55}	{"taxTolerance": 31, "governmentTrust": 51, "policyAcceptance": 54, "regulationPreference": 65, "publicServiceSatisfaction": 53}	0
3633	신광수	80	70+	Female	서울특별시	37.63998	126.900593	전문대 졸	200-350만원	은퇴	자녀 양육 가구	38	보수 성향 무당층	81	{"economy": 31, "housing": 0, "welfare": -28, "security": 5, "environment": 1}	포털 뉴스	{안전,혁신,공동체}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안전, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 61, "noveltySeeking": 28, "ecoConsciousness": 36, "priceSensitivity": 73, "digitalConsumption": 48}	{"taxTolerance": 54, "governmentTrust": 43, "policyAcceptance": 49, "regulationPreference": 58, "publicServiceSatisfaction": 69}	0
3634	신민서	74	70+	Female	서울특별시	37.50232	127.023596	대학원 졸	200-350만원	은퇴	부부 가구	8	중도 무당층	82	{"economy": 24, "housing": 10, "welfare": 16, "security": 17, "environment": 28}	신문/팟캐스트	{전통,공정,안정}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 전통, 공정, 안정 가치를 중시한다.	{"brandLoyalty": 70, "noveltySeeking": 65, "ecoConsciousness": 54, "priceSensitivity": 63, "digitalConsumption": 60}	{"taxTolerance": 69, "governmentTrust": 56, "policyAcceptance": 72, "regulationPreference": 88, "publicServiceSatisfaction": 62}	0
3635	황은우	71	70+	Female	서울특별시	37.635563	126.999188	대학교 졸	200만원 미만	은퇴	부부 가구	7	중도 무당층	98	{"economy": -25, "housing": 5, "welfare": -17, "security": 8, "environment": 13}	신문/팟캐스트	{다양성,공정,성장}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 다양성, 공정, 성장 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 60, "ecoConsciousness": 36, "priceSensitivity": 59, "digitalConsumption": 69}	{"taxTolerance": 32, "governmentTrust": 51, "policyAcceptance": 72, "regulationPreference": 71, "publicServiceSatisfaction": 58}	0
3636	정하은	81	70+	Male	서울특별시	37.507661	126.892978	고졸 이하	200만원 미만	은퇴	자녀 양육 가구	25	보수 성향 무당층	99	{"economy": 28, "housing": 17, "welfare": 22, "security": 27, "environment": 10}	유튜브	{안전,성장,전통}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안전, 성장, 전통 가치를 중시한다.	{"brandLoyalty": 70, "noveltySeeking": 32, "ecoConsciousness": 53, "priceSensitivity": 69, "digitalConsumption": 63}	{"taxTolerance": 44, "governmentTrust": 67, "policyAcceptance": 66, "regulationPreference": 81, "publicServiceSatisfaction": 82}	0
3637	오성호	71	70+	Male	서울특별시	37.510302	127.036238	전문대 졸	500-700만원	은퇴	1인 가구	-29	진보 성향 무당층	87	{"economy": -28, "housing": 44, "welfare": 59, "security": -1, "environment": 12}	지상파/종편 뉴스	{공정,안전,다양성}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공정, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 51, "ecoConsciousness": 21, "priceSensitivity": 50, "digitalConsumption": 51}	{"taxTolerance": 64, "governmentTrust": 51, "policyAcceptance": 62, "regulationPreference": 76, "publicServiceSatisfaction": 87}	0
3638	강혜진	76	70+	Male	서울특별시	37.540983	126.993774	전문대 졸	350-500만원	은퇴	1인 가구	-23	진보 성향 무당층	99	{"economy": -5, "housing": 12, "welfare": 59, "security": -29, "environment": 26}	포털 뉴스	{공동체,안정,전통}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공동체, 안정, 전통 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 35, "ecoConsciousness": 44, "priceSensitivity": 67, "digitalConsumption": 33}	{"taxTolerance": 39, "governmentTrust": 50, "policyAcceptance": 76, "regulationPreference": 67, "publicServiceSatisfaction": 68}	0
3639	장현우	78	70+	Male	서울특별시	37.524725	127.026438	대학교 졸	350-500만원	은퇴	다세대 가구	47	보수 정당 지지	86	{"economy": 2, "housing": -9, "welfare": 1, "security": 25, "environment": -24}	SNS	{자유,성장,안전}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 자유, 성장, 안전 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 40, "ecoConsciousness": 46, "priceSensitivity": 61, "digitalConsumption": 20}	{"taxTolerance": 67, "governmentTrust": 51, "policyAcceptance": 67, "regulationPreference": 73, "publicServiceSatisfaction": 71}	0
3640	전철수	80	70+	Male	서울특별시	37.509678	126.954932	대학교 졸	350-500만원	은퇴	자녀 양육 가구	28	보수 성향 무당층	99	{"economy": 9, "housing": 24, "welfare": 8, "security": 32, "environment": 4}	SNS	{안정,다양성,공정}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안정, 다양성, 공정 가치를 중시한다.	{"brandLoyalty": 84, "noveltySeeking": 42, "ecoConsciousness": 54, "priceSensitivity": 54, "digitalConsumption": 43}	{"taxTolerance": 51, "governmentTrust": 59, "policyAcceptance": 42, "regulationPreference": 92, "publicServiceSatisfaction": 66}	0
3641	임채원	76	70+	Male	서울특별시	37.535085	126.926797	대학원 졸	700만원 이상	은퇴	다세대 가구	-16	진보 성향 무당층	97	{"economy": -44, "housing": 12, "welfare": 4, "security": 4, "environment": 22}	포털 뉴스	{다양성,공정,혁신}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 다양성, 공정, 혁신 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 46, "ecoConsciousness": 49, "priceSensitivity": 55, "digitalConsumption": 45}	{"taxTolerance": 42, "governmentTrust": 53, "policyAcceptance": 40, "regulationPreference": 86, "publicServiceSatisfaction": 63}	0
3642	조순자	81	70+	Male	서울특별시	37.55112	127.029659	전문대 졸	350-500만원	은퇴	자녀 양육 가구	42	보수 성향 무당층	98	{"economy": 28, "housing": 24, "welfare": 13, "security": 36, "environment": 10}	신문/팟캐스트	{공정,공동체,전통}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 공정, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 55, "ecoConsciousness": 27, "priceSensitivity": 56, "digitalConsumption": 67}	{"taxTolerance": 30, "governmentTrust": 57, "policyAcceptance": 72, "regulationPreference": 84, "publicServiceSatisfaction": 59}	0
3643	권예준	78	70+	Male	서울특별시	37.563934	127.030823	고졸 이하	200만원 미만	은퇴	다세대 가구	23	보수 성향 무당층	65	{"economy": 43, "housing": 20, "welfare": 0, "security": 36, "environment": -3}	지상파/종편 뉴스	{공정,다양성,전통}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공정, 다양성, 전통 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 36, "ecoConsciousness": 59, "priceSensitivity": 70, "digitalConsumption": 57}	{"taxTolerance": 36, "governmentTrust": 50, "policyAcceptance": 41, "regulationPreference": 54, "publicServiceSatisfaction": 79}	0
3644	서광수	75	70+	Male	서울특별시	37.567739	127.007381	전문대 졸	500-700만원	은퇴	1인 가구	-11	중도 무당층	99	{"economy": -39, "housing": 32, "welfare": 37, "security": 1, "environment": 35}	SNS	{다양성,환경,혁신}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 다양성, 환경, 혁신 가치를 중시한다.	{"brandLoyalty": 61, "noveltySeeking": 46, "ecoConsciousness": 47, "priceSensitivity": 46, "digitalConsumption": 35}	{"taxTolerance": 40, "governmentTrust": 59, "policyAcceptance": 51, "regulationPreference": 54, "publicServiceSatisfaction": 69}	0
3645	이준서	70	70+	Male	서울특별시	37.583296	126.974149	전문대 졸	200만원 미만	은퇴	다세대 가구	14	중도 무당층	51	{"economy": -26, "housing": 2, "welfare": -5, "security": 38, "environment": 47}	포털 뉴스	{혁신,다양성,성장}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 혁신, 다양성, 성장 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 44, "ecoConsciousness": 36, "priceSensitivity": 90, "digitalConsumption": 67}	{"taxTolerance": 43, "governmentTrust": 55, "policyAcceptance": 67, "regulationPreference": 55, "publicServiceSatisfaction": 74}	0
3646	이민서	29	18-29	Female	부산광역시	35.134564	129.065923	전문대 졸	500-700만원	사무직	부부 가구	-63	진보 정당 지지	34	{"economy": -39, "housing": 25, "welfare": 45, "security": -15, "environment": 67}	지상파/종편 뉴스	{전통,성장,환경}	부산광역시에 거주하는 18-29 사무직. 정치 성향은 진보이며 전통, 성장, 환경 가치를 중시한다.	{"brandLoyalty": 21, "noveltySeeking": 69, "ecoConsciousness": 39, "priceSensitivity": 39, "digitalConsumption": 94}	{"taxTolerance": 35, "governmentTrust": 34, "policyAcceptance": 53, "regulationPreference": 58, "publicServiceSatisfaction": 77}	0
3647	전지호	27	18-29	Female	부산광역시	35.114573	129.058764	대학원 졸	200-350만원	주부	1인 가구	-38	진보 성향 무당층	58	{"economy": -78, "housing": 28, "welfare": 42, "security": 2, "environment": 6}	유튜브	{성장,안전,자유}	부산광역시에 거주하는 18-29 주부. 정치 성향은 진보이며 성장, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 65, "ecoConsciousness": 79, "priceSensitivity": 62, "digitalConsumption": 83}	{"taxTolerance": 48, "governmentTrust": 53, "policyAcceptance": 47, "regulationPreference": 52, "publicServiceSatisfaction": 54}	0
3648	오채원	19	18-29	Female	부산광역시	35.117657	129.072171	대학교 졸	350-500만원	학생	다세대 가구	-31	진보 성향 무당층	32	{"economy": -27, "housing": 41, "welfare": 25, "security": -7, "environment": 39}	지상파/종편 뉴스	{공동체,혁신,환경}	부산광역시에 거주하는 18-29 학생. 정치 성향은 중도이며 공동체, 혁신, 환경 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 96, "ecoConsciousness": 53, "priceSensitivity": 51, "digitalConsumption": 92}	{"taxTolerance": 47, "governmentTrust": 47, "policyAcceptance": 50, "regulationPreference": 46, "publicServiceSatisfaction": 79}	0
3649	오성호	28	18-29	Female	부산광역시	35.109751	129.036629	전문대 졸	500-700만원	생산직	부부 가구	-5	중도 무당층	30	{"economy": 9, "housing": 17, "welfare": -36, "security": 14, "environment": 33}	지상파/종편 뉴스	{자유,안정,안전}	부산광역시에 거주하는 18-29 생산직. 정치 성향은 중도이며 자유, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 52, "ecoConsciousness": 61, "priceSensitivity": 64, "digitalConsumption": 70}	{"taxTolerance": 41, "governmentTrust": 36, "policyAcceptance": 39, "regulationPreference": 57, "publicServiceSatisfaction": 64}	0
3650	신정희	18	18-29	Male	부산광역시	35.111054	129.11001	대학원 졸	350-500만원	공무원	1인 가구	4	중도 무당층	32	{"economy": 6, "housing": 26, "welfare": 18, "security": 15, "environment": 20}	포털 뉴스	{환경,공동체,공정}	부산광역시에 거주하는 18-29 공무원. 정치 성향은 중도이며 환경, 공동체, 공정 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 80, "ecoConsciousness": 59, "priceSensitivity": 64, "digitalConsumption": 80}	{"taxTolerance": 68, "governmentTrust": 27, "policyAcceptance": 56, "regulationPreference": 67, "publicServiceSatisfaction": 67}	0
3651	홍정희	28	18-29	Male	부산광역시	35.245508	129.161002	대학원 졸	200-350만원	학생	다세대 가구	8	중도 무당층	42	{"economy": 1, "housing": 25, "welfare": -10, "security": -6, "environment": 35}	지상파/종편 뉴스	{공동체,혁신,안전}	부산광역시에 거주하는 18-29 학생. 정치 성향은 중도이며 공동체, 혁신, 안전 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 74, "ecoConsciousness": 49, "priceSensitivity": 62, "digitalConsumption": 81}	{"taxTolerance": 54, "governmentTrust": 41, "policyAcceptance": 55, "regulationPreference": 57, "publicServiceSatisfaction": 68}	0
3652	황지우	21	18-29	Male	부산광역시	35.229147	129.114616	대학원 졸	200-350만원	학생	다세대 가구	-52	진보 정당 지지	51	{"economy": -38, "housing": 65, "welfare": 36, "security": -41, "environment": 23}	SNS	{안전,환경,공동체}	부산광역시에 거주하는 18-29 학생. 정치 성향은 진보이며 안전, 환경, 공동체 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 84, "ecoConsciousness": 49, "priceSensitivity": 54, "digitalConsumption": 75}	{"taxTolerance": 83, "governmentTrust": 42, "policyAcceptance": 62, "regulationPreference": 51, "publicServiceSatisfaction": 53}	0
3653	송광수	20	18-29	Male	부산광역시	35.24798	129.035681	대학원 졸	350-500만원	학생	다세대 가구	-62	진보 정당 지지	34	{"economy": -36, "housing": 58, "welfare": 54, "security": -47, "environment": 34}	포털 뉴스	{공동체,자유,환경}	부산광역시에 거주하는 18-29 학생. 정치 성향은 진보이며 공동체, 자유, 환경 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 62, "ecoConsciousness": 58, "priceSensitivity": 37, "digitalConsumption": 100}	{"taxTolerance": 60, "governmentTrust": 32, "policyAcceptance": 53, "regulationPreference": 58, "publicServiceSatisfaction": 90}	0
3654	강도윤	38	30-39	Female	부산광역시	35.188306	129.0261	대학원 졸	500-700만원	생산직	자녀 양육 가구	17	보수 성향 무당층	46	{"economy": 9, "housing": 12, "welfare": 32, "security": 10, "environment": -20}	포털 뉴스	{자유,혁신,안전}	부산광역시에 거주하는 30-39 생산직. 정치 성향은 중도이며 자유, 혁신, 안전 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 64, "ecoConsciousness": 47, "priceSensitivity": 48, "digitalConsumption": 74}	{"taxTolerance": 66, "governmentTrust": 36, "policyAcceptance": 43, "regulationPreference": 55, "publicServiceSatisfaction": 83}	0
3655	임지호	38	30-39	Female	부산광역시	35.227545	128.994229	대학교 졸	700만원 이상	프리랜서	다세대 가구	-55	진보 정당 지지	59	{"economy": -44, "housing": 32, "welfare": 61, "security": -22, "environment": 39}	신문/팟캐스트	{공동체,환경,다양성}	부산광역시에 거주하는 30-39 프리랜서. 정치 성향은 진보이며 공동체, 환경, 다양성 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 64, "ecoConsciousness": 43, "priceSensitivity": 45, "digitalConsumption": 99}	{"taxTolerance": 49, "governmentTrust": 50, "policyAcceptance": 50, "regulationPreference": 74, "publicServiceSatisfaction": 50}	0
3656	강철수	30	30-39	Female	부산광역시	35.233632	128.986476	대학원 졸	200-350만원	은퇴	다세대 가구	-31	진보 성향 무당층	53	{"economy": -37, "housing": 33, "welfare": 32, "security": -3, "environment": 55}	SNS	{안정,혁신,성장}	부산광역시에 거주하는 30-39 은퇴. 정치 성향은 중도이며 안정, 혁신, 성장 가치를 중시한다.	{"brandLoyalty": 25, "noveltySeeking": 65, "ecoConsciousness": 42, "priceSensitivity": 65, "digitalConsumption": 80}	{"taxTolerance": 59, "governmentTrust": 40, "policyAcceptance": 61, "regulationPreference": 49, "publicServiceSatisfaction": 79}	0
3657	황다은	30	30-39	Female	부산광역시	35.176361	129.076406	대학원 졸	700만원 이상	프리랜서	자녀 양육 가구	-3	중도 무당층	36	{"economy": -1, "housing": 36, "welfare": -9, "security": 20, "environment": 19}	유튜브	{자유,전통,안전}	부산광역시에 거주하는 30-39 프리랜서. 정치 성향은 중도이며 자유, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 79, "ecoConsciousness": 46, "priceSensitivity": 47, "digitalConsumption": 74}	{"taxTolerance": 52, "governmentTrust": 58, "policyAcceptance": 59, "regulationPreference": 66, "publicServiceSatisfaction": 59}	0
3658	박혜진	34	30-39	Male	부산광역시	35.142079	128.994268	대학원 졸	350-500만원	생산직	다세대 가구	15	보수 성향 무당층	67	{"economy": 13, "housing": 22, "welfare": 14, "security": 27, "environment": 10}	유튜브	{전통,공동체,안정}	부산광역시에 거주하는 30-39 생산직. 정치 성향은 중도이며 전통, 공동체, 안정 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 69, "ecoConsciousness": 57, "priceSensitivity": 44, "digitalConsumption": 83}	{"taxTolerance": 70, "governmentTrust": 54, "policyAcceptance": 55, "regulationPreference": 83, "publicServiceSatisfaction": 72}	0
3659	서채원	36	30-39	Male	부산광역시	35.197223	129.051067	대학원 졸	500-700만원	서비스직	다세대 가구	25	보수 성향 무당층	60	{"economy": 4, "housing": 2, "welfare": 2, "security": 1, "environment": -20}	신문/팟캐스트	{환경,성장,공정}	부산광역시에 거주하는 30-39 서비스직. 정치 성향은 중도이며 환경, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 69, "ecoConsciousness": 62, "priceSensitivity": 49, "digitalConsumption": 78}	{"taxTolerance": 74, "governmentTrust": 38, "policyAcceptance": 52, "regulationPreference": 79, "publicServiceSatisfaction": 77}	0
3660	강채원	31	30-39	Male	부산광역시	35.238833	129.12692	전문대 졸	500-700만원	학생	다세대 가구	36	보수 성향 무당층	56	{"economy": 20, "housing": 5, "welfare": -5, "security": 39, "environment": 5}	SNS	{공동체,전통,다양성}	부산광역시에 거주하는 30-39 학생. 정치 성향은 보수이며 공동체, 전통, 다양성 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 61, "ecoConsciousness": 57, "priceSensitivity": 63, "digitalConsumption": 67}	{"taxTolerance": 47, "governmentTrust": 48, "policyAcceptance": 35, "regulationPreference": 66, "publicServiceSatisfaction": 91}	0
3661	권서연	33	30-39	Male	부산광역시	35.239906	129.078894	대학교 졸	200-350만원	자영업	1인 가구	-9	중도 무당층	57	{"economy": 7, "housing": 28, "welfare": 19, "security": -13, "environment": 27}	포털 뉴스	{공정,성장,혁신}	부산광역시에 거주하는 30-39 자영업. 정치 성향은 중도이며 공정, 성장, 혁신 가치를 중시한다.	{"brandLoyalty": 25, "noveltySeeking": 57, "ecoConsciousness": 35, "priceSensitivity": 64, "digitalConsumption": 77}	{"taxTolerance": 54, "governmentTrust": 53, "policyAcceptance": 28, "regulationPreference": 80, "publicServiceSatisfaction": 73}	0
3662	홍동현	45	40-49	Female	부산광역시	35.150558	129.006696	대학원 졸	200-350만원	자영업	다세대 가구	7	중도 무당층	70	{"economy": 0, "housing": 18, "welfare": 26, "security": -1, "environment": 14}	포털 뉴스	{공정,다양성,안정}	부산광역시에 거주하는 40-49 자영업. 정치 성향은 중도이며 공정, 다양성, 안정 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 79, "ecoConsciousness": 61, "priceSensitivity": 67, "digitalConsumption": 69}	{"taxTolerance": 46, "governmentTrust": 36, "policyAcceptance": 56, "regulationPreference": 56, "publicServiceSatisfaction": 67}	0
3663	정혜진	45	40-49	Female	부산광역시	35.148842	129.023939	대학교 졸	500-700만원	서비스직	부부 가구	-42	진보 성향 무당층	90	{"economy": -32, "housing": -5, "welfare": 43, "security": -39, "environment": 32}	신문/팟캐스트	{공동체,혁신,전통}	부산광역시에 거주하는 40-49 서비스직. 정치 성향은 진보이며 공동체, 혁신, 전통 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 61, "ecoConsciousness": 43, "priceSensitivity": 59, "digitalConsumption": 73}	{"taxTolerance": 37, "governmentTrust": 51, "policyAcceptance": 64, "regulationPreference": 67, "publicServiceSatisfaction": 69}	0
3664	정혜진	41	40-49	Female	부산광역시	35.164966	129.012033	대학원 졸	200-350만원	사무직	자녀 양육 가구	-17	진보 성향 무당층	78	{"economy": 26, "housing": 42, "welfare": 45, "security": 25, "environment": -2}	포털 뉴스	{다양성,공정,공동체}	부산광역시에 거주하는 40-49 사무직. 정치 성향은 중도이며 다양성, 공정, 공동체 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 70, "ecoConsciousness": 70, "priceSensitivity": 74, "digitalConsumption": 85}	{"taxTolerance": 63, "governmentTrust": 48, "policyAcceptance": 57, "regulationPreference": 78, "publicServiceSatisfaction": 64}	0
3665	안미경	42	40-49	Female	부산광역시	35.100622	129.109058	대학원 졸	350-500만원	주부	1인 가구	10	중도 무당층	68	{"economy": -10, "housing": -11, "welfare": 14, "security": 26, "environment": -10}	지상파/종편 뉴스	{자유,성장,공동체}	부산광역시에 거주하는 40-49 주부. 정치 성향은 중도이며 자유, 성장, 공동체 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 56, "ecoConsciousness": 57, "priceSensitivity": 81, "digitalConsumption": 62}	{"taxTolerance": 48, "governmentTrust": 28, "policyAcceptance": 40, "regulationPreference": 48, "publicServiceSatisfaction": 76}	0
3666	송혜진	41	40-49	Female	부산광역시	35.233561	129.039184	대학교 졸	700만원 이상	은퇴	다세대 가구	-40	진보 성향 무당층	72	{"economy": -7, "housing": 8, "welfare": -3, "security": -26, "environment": 34}	신문/팟캐스트	{혁신,다양성,성장}	부산광역시에 거주하는 40-49 은퇴. 정치 성향은 진보이며 혁신, 다양성, 성장 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 53, "ecoConsciousness": 61, "priceSensitivity": 49, "digitalConsumption": 72}	{"taxTolerance": 61, "governmentTrust": 34, "policyAcceptance": 36, "regulationPreference": 71, "publicServiceSatisfaction": 62}	0
3667	한미경	41	40-49	Male	부산광역시	35.22728	129.118374	전문대 졸	500-700만원	서비스직	부부 가구	-15	진보 성향 무당층	53	{"economy": -6, "housing": 34, "welfare": 26, "security": 2, "environment": 50}	SNS	{전통,자유,공정}	부산광역시에 거주하는 40-49 서비스직. 정치 성향은 중도이며 전통, 자유, 공정 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 67, "ecoConsciousness": 60, "priceSensitivity": 59, "digitalConsumption": 65}	{"taxTolerance": 48, "governmentTrust": 50, "policyAcceptance": 71, "regulationPreference": 74, "publicServiceSatisfaction": 63}	0
3668	윤지호	43	40-49	Male	부산광역시	35.252333	129.120196	대학원 졸	350-500만원	자영업	부부 가구	-22	진보 성향 무당층	68	{"economy": -2, "housing": 28, "welfare": 24, "security": -3, "environment": 37}	포털 뉴스	{환경,안전,자유}	부산광역시에 거주하는 40-49 자영업. 정치 성향은 중도이며 환경, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 57, "ecoConsciousness": 66, "priceSensitivity": 63, "digitalConsumption": 79}	{"taxTolerance": 60, "governmentTrust": 52, "policyAcceptance": 48, "regulationPreference": 74, "publicServiceSatisfaction": 86}	0
3669	강채원	49	40-49	Male	부산광역시	35.204938	129.110076	대학원 졸	500-700만원	자영업	부부 가구	3	중도 무당층	66	{"economy": -6, "housing": 10, "welfare": 26, "security": 8, "environment": 7}	유튜브	{혁신,환경,다양성}	부산광역시에 거주하는 40-49 자영업. 정치 성향은 중도이며 혁신, 환경, 다양성 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 53, "ecoConsciousness": 25, "priceSensitivity": 50, "digitalConsumption": 60}	{"taxTolerance": 62, "governmentTrust": 54, "policyAcceptance": 46, "regulationPreference": 72, "publicServiceSatisfaction": 75}	0
3670	박준서	45	40-49	Male	부산광역시	35.201234	129.043836	대학원 졸	700만원 이상	서비스직	1인 가구	18	보수 성향 무당층	60	{"economy": -8, "housing": 9, "welfare": 40, "security": -6, "environment": 20}	SNS	{공정,성장,다양성}	부산광역시에 거주하는 40-49 서비스직. 정치 성향은 중도이며 공정, 성장, 다양성 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 65, "ecoConsciousness": 44, "priceSensitivity": 51, "digitalConsumption": 67}	{"taxTolerance": 66, "governmentTrust": 44, "policyAcceptance": 56, "regulationPreference": 66, "publicServiceSatisfaction": 74}	0
3671	임경숙	41	40-49	Male	부산광역시	35.158047	129.051499	대학교 졸	200만원 미만	주부	자녀 양육 가구	-19	진보 성향 무당층	56	{"economy": -23, "housing": 8, "welfare": 28, "security": -24, "environment": 26}	신문/팟캐스트	{안전,환경,자유}	부산광역시에 거주하는 40-49 주부. 정치 성향은 중도이며 안전, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 64, "ecoConsciousness": 42, "priceSensitivity": 75, "digitalConsumption": 71}	{"taxTolerance": 51, "governmentTrust": 22, "policyAcceptance": 46, "regulationPreference": 67, "publicServiceSatisfaction": 56}	0
3672	안지아	54	50-59	Female	부산광역시	35.238877	129.146797	전문대 졸	500-700만원	전문직	부부 가구	-12	중도 무당층	59	{"economy": -13, "housing": 14, "welfare": 24, "security": 15, "environment": 12}	신문/팟캐스트	{공정,안정,환경}	부산광역시에 거주하는 50-59 전문직. 정치 성향은 중도이며 공정, 안정, 환경 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 68, "ecoConsciousness": 52, "priceSensitivity": 64, "digitalConsumption": 65}	{"taxTolerance": 41, "governmentTrust": 54, "policyAcceptance": 70, "regulationPreference": 64, "publicServiceSatisfaction": 67}	0
3673	임동현	55	50-59	Female	부산광역시	35.110703	129.043966	대학교 졸	350-500만원	공무원	부부 가구	-8	중도 무당층	61	{"economy": -30, "housing": 12, "welfare": -4, "security": -1, "environment": 9}	유튜브	{공정,성장,공동체}	부산광역시에 거주하는 50-59 공무원. 정치 성향은 중도이며 공정, 성장, 공동체 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 51, "ecoConsciousness": 30, "priceSensitivity": 55, "digitalConsumption": 62}	{"taxTolerance": 53, "governmentTrust": 42, "policyAcceptance": 57, "regulationPreference": 61, "publicServiceSatisfaction": 75}	0
3674	홍건우	59	50-59	Female	부산광역시	35.259095	128.981911	대학원 졸	350-500만원	은퇴	부부 가구	48	보수 정당 지지	65	{"economy": -17, "housing": 28, "welfare": 1, "security": 55, "environment": -16}	SNS	{성장,안전,혁신}	부산광역시에 거주하는 50-59 은퇴. 정치 성향은 보수이며 성장, 안전, 혁신 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 66, "ecoConsciousness": 71, "priceSensitivity": 73, "digitalConsumption": 54}	{"taxTolerance": 55, "governmentTrust": 31, "policyAcceptance": 55, "regulationPreference": 65, "publicServiceSatisfaction": 66}	0
3675	송은우	51	50-59	Female	부산광역시	35.145653	129.055745	대학교 졸	350-500만원	은퇴	부부 가구	0	중도 무당층	61	{"economy": -4, "housing": 8, "welfare": 41, "security": 4, "environment": 23}	신문/팟캐스트	{전통,혁신,다양성}	부산광역시에 거주하는 50-59 은퇴. 정치 성향은 중도이며 전통, 혁신, 다양성 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 46, "ecoConsciousness": 69, "priceSensitivity": 43, "digitalConsumption": 81}	{"taxTolerance": 50, "governmentTrust": 43, "policyAcceptance": 60, "regulationPreference": 74, "publicServiceSatisfaction": 71}	0
3676	권서윤	51	50-59	Female	부산광역시	35.142521	129.007491	전문대 졸	350-500만원	학생	부부 가구	4	중도 무당층	66	{"economy": -12, "housing": 21, "welfare": -9, "security": -23, "environment": 37}	SNS	{자유,성장,공동체}	부산광역시에 거주하는 50-59 학생. 정치 성향은 중도이며 자유, 성장, 공동체 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 62, "ecoConsciousness": 47, "priceSensitivity": 57, "digitalConsumption": 53}	{"taxTolerance": 45, "governmentTrust": 55, "policyAcceptance": 50, "regulationPreference": 47, "publicServiceSatisfaction": 58}	0
3677	홍예준	57	50-59	Male	부산광역시	35.123096	129.083108	고졸 이하	500-700만원	서비스직	1인 가구	-11	중도 무당층	68	{"economy": -2, "housing": 20, "welfare": 10, "security": -8, "environment": 22}	유튜브	{공동체,자유,혁신}	부산광역시에 거주하는 50-59 서비스직. 정치 성향은 중도이며 공동체, 자유, 혁신 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 45, "ecoConsciousness": 34, "priceSensitivity": 37, "digitalConsumption": 55}	{"taxTolerance": 30, "governmentTrust": 55, "policyAcceptance": 62, "regulationPreference": 69, "publicServiceSatisfaction": 66}	0
3678	정유준	58	50-59	Male	부산광역시	35.22492	128.994657	대학원 졸	500-700만원	서비스직	부부 가구	11	중도 무당층	77	{"economy": 38, "housing": 10, "welfare": 2, "security": 34, "environment": 1}	유튜브	{성장,전통,공동체}	부산광역시에 거주하는 50-59 서비스직. 정치 성향은 중도이며 성장, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 68, "ecoConsciousness": 41, "priceSensitivity": 49, "digitalConsumption": 76}	{"taxTolerance": 54, "governmentTrust": 68, "policyAcceptance": 61, "regulationPreference": 77, "publicServiceSatisfaction": 76}	0
3679	장하은	51	50-59	Male	부산광역시	35.240936	129.136854	전문대 졸	700만원 이상	서비스직	부부 가구	-3	중도 무당층	54	{"economy": -32, "housing": 13, "welfare": 23, "security": 17, "environment": 26}	포털 뉴스	{혁신,안전,공동체}	부산광역시에 거주하는 50-59 서비스직. 정치 성향은 중도이며 혁신, 안전, 공동체 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 67, "ecoConsciousness": 57, "priceSensitivity": 49, "digitalConsumption": 77}	{"taxTolerance": 32, "governmentTrust": 44, "policyAcceptance": 41, "regulationPreference": 54, "publicServiceSatisfaction": 68}	0
3680	강주원	54	50-59	Male	부산광역시	35.25614	129.030629	전문대 졸	350-500만원	자영업	1인 가구	24	보수 성향 무당층	73	{"economy": 16, "housing": -2, "welfare": -17, "security": 20, "environment": 25}	포털 뉴스	{다양성,안전,공정}	부산광역시에 거주하는 50-59 자영업. 정치 성향은 중도이며 다양성, 안전, 공정 가치를 중시한다.	{"brandLoyalty": 81, "noveltySeeking": 47, "ecoConsciousness": 38, "priceSensitivity": 64, "digitalConsumption": 58}	{"taxTolerance": 50, "governmentTrust": 55, "policyAcceptance": 56, "regulationPreference": 78, "publicServiceSatisfaction": 73}	0
3681	윤주원	54	50-59	Male	부산광역시	35.229686	129.012167	전문대 졸	500-700만원	사무직	자녀 양육 가구	29	보수 성향 무당층	68	{"economy": 28, "housing": -15, "welfare": 26, "security": 8, "environment": 30}	포털 뉴스	{다양성,공정,자유}	부산광역시에 거주하는 50-59 사무직. 정치 성향은 중도이며 다양성, 공정, 자유 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 63, "ecoConsciousness": 41, "priceSensitivity": 54, "digitalConsumption": 46}	{"taxTolerance": 59, "governmentTrust": 59, "policyAcceptance": 41, "regulationPreference": 70, "publicServiceSatisfaction": 81}	0
3682	서성호	64	60-69	Female	부산광역시	35.251055	129.047732	대학교 졸	200-350만원	전문직	다세대 가구	7	중도 무당층	74	{"economy": -3, "housing": 26, "welfare": -12, "security": 0, "environment": 20}	포털 뉴스	{공정,혁신,환경}	부산광역시에 거주하는 60-69 전문직. 정치 성향은 중도이며 공정, 혁신, 환경 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 45, "ecoConsciousness": 44, "priceSensitivity": 60, "digitalConsumption": 58}	{"taxTolerance": 40, "governmentTrust": 56, "policyAcceptance": 53, "regulationPreference": 65, "publicServiceSatisfaction": 63}	0
3683	조준서	67	60-69	Female	부산광역시	35.119007	129.072975	대학교 졸	350-500만원	은퇴	다세대 가구	-6	중도 무당층	82	{"economy": -15, "housing": 26, "welfare": -5, "security": 7, "environment": 31}	유튜브	{전통,혁신,성장}	부산광역시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 전통, 혁신, 성장 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 66, "ecoConsciousness": 49, "priceSensitivity": 65, "digitalConsumption": 64}	{"taxTolerance": 35, "governmentTrust": 55, "policyAcceptance": 52, "regulationPreference": 64, "publicServiceSatisfaction": 73}	0
3684	류은우	63	60-69	Female	부산광역시	35.125053	129.054066	전문대 졸	350-500만원	서비스직	부부 가구	27	보수 성향 무당층	72	{"economy": 14, "housing": 0, "welfare": 16, "security": 10, "environment": 30}	SNS	{안전,공동체,혁신}	부산광역시에 거주하는 60-69 서비스직. 정치 성향은 중도이며 안전, 공동체, 혁신 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 46, "ecoConsciousness": 42, "priceSensitivity": 60, "digitalConsumption": 65}	{"taxTolerance": 46, "governmentTrust": 51, "policyAcceptance": 58, "regulationPreference": 70, "publicServiceSatisfaction": 62}	0
3685	전철수	69	60-69	Female	부산광역시	35.226929	128.977896	대학교 졸	200만원 미만	은퇴	1인 가구	30	보수 성향 무당층	77	{"economy": 5, "housing": -27, "welfare": 6, "security": 19, "environment": 21}	포털 뉴스	{안전,성장,안정}	부산광역시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 안전, 성장, 안정 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 44, "ecoConsciousness": 55, "priceSensitivity": 65, "digitalConsumption": 64}	{"taxTolerance": 37, "governmentTrust": 35, "policyAcceptance": 51, "regulationPreference": 63, "publicServiceSatisfaction": 76}	0
3686	홍서윤	69	60-69	Male	부산광역시	35.175843	129.123089	전문대 졸	350-500만원	은퇴	자녀 양육 가구	-21	진보 성향 무당층	82	{"economy": -10, "housing": 24, "welfare": 29, "security": 5, "environment": 31}	SNS	{성장,자유,안전}	부산광역시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 성장, 자유, 안전 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 64, "ecoConsciousness": 49, "priceSensitivity": 70, "digitalConsumption": 45}	{"taxTolerance": 41, "governmentTrust": 50, "policyAcceptance": 53, "regulationPreference": 48, "publicServiceSatisfaction": 76}	0
3687	홍은우	63	60-69	Male	부산광역시	35.127168	129.053098	대학교 졸	500-700만원	생산직	다세대 가구	2	중도 무당층	66	{"economy": -7, "housing": 20, "welfare": 19, "security": -14, "environment": 23}	지상파/종편 뉴스	{공정,자유,성장}	부산광역시에 거주하는 60-69 생산직. 정치 성향은 중도이며 공정, 자유, 성장 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 57, "ecoConsciousness": 56, "priceSensitivity": 66, "digitalConsumption": 48}	{"taxTolerance": 34, "governmentTrust": 55, "policyAcceptance": 47, "regulationPreference": 62, "publicServiceSatisfaction": 59}	0
3688	윤철수	60	60-69	Male	부산광역시	35.152432	129.119829	전문대 졸	500-700만원	전문직	부부 가구	1	중도 무당층	92	{"economy": 23, "housing": 13, "welfare": 25, "security": 27, "environment": 2}	포털 뉴스	{다양성,성장,안전}	부산광역시에 거주하는 60-69 전문직. 정치 성향은 중도이며 다양성, 성장, 안전 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 45, "ecoConsciousness": 60, "priceSensitivity": 52, "digitalConsumption": 61}	{"taxTolerance": 40, "governmentTrust": 60, "policyAcceptance": 78, "regulationPreference": 68, "publicServiceSatisfaction": 83}	0
3689	송채원	63	60-69	Male	부산광역시	35.148659	129.042726	대학원 졸	700만원 이상	서비스직	다세대 가구	27	보수 성향 무당층	75	{"economy": 22, "housing": 3, "welfare": -7, "security": 3, "environment": 5}	유튜브	{자유,혁신,환경}	부산광역시에 거주하는 60-69 서비스직. 정치 성향은 중도이며 자유, 혁신, 환경 가치를 중시한다.	{"brandLoyalty": 61, "noveltySeeking": 51, "ecoConsciousness": 52, "priceSensitivity": 42, "digitalConsumption": 40}	{"taxTolerance": 42, "governmentTrust": 54, "policyAcceptance": 57, "regulationPreference": 53, "publicServiceSatisfaction": 65}	0
3690	윤정희	81	70+	Female	부산광역시	35.189621	129.044802	전문대 졸	200만원 미만	은퇴	1인 가구	19	보수 성향 무당층	99	{"economy": -11, "housing": 23, "welfare": 8, "security": 45, "environment": 3}	지상파/종편 뉴스	{자유,안전,다양성}	부산광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 자유, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 41, "ecoConsciousness": 22, "priceSensitivity": 82, "digitalConsumption": 43}	{"taxTolerance": 53, "governmentTrust": 50, "policyAcceptance": 59, "regulationPreference": 69, "publicServiceSatisfaction": 54}	0
3691	신민준	81	70+	Female	부산광역시	35.247874	129.12239	대학교 졸	200만원 미만	은퇴	자녀 양육 가구	1	중도 무당층	86	{"economy": 6, "housing": -4, "welfare": 5, "security": 50, "environment": -8}	SNS	{공정,다양성,안정}	부산광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공정, 다양성, 안정 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 76, "ecoConsciousness": 32, "priceSensitivity": 66, "digitalConsumption": 36}	{"taxTolerance": 49, "governmentTrust": 51, "policyAcceptance": 75, "regulationPreference": 68, "publicServiceSatisfaction": 50}	0
3692	임주원	76	70+	Female	부산광역시	35.122603	129.017511	전문대 졸	200-350만원	은퇴	부부 가구	53	보수 정당 지지	99	{"economy": 1, "housing": -5, "welfare": -15, "security": 57, "environment": 18}	유튜브	{자유,다양성,안전}	부산광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 자유, 다양성, 안전 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 53, "ecoConsciousness": 45, "priceSensitivity": 55, "digitalConsumption": 35}	{"taxTolerance": 46, "governmentTrust": 54, "policyAcceptance": 70, "regulationPreference": 81, "publicServiceSatisfaction": 48}	0
3693	조지호	75	70+	Female	부산광역시	35.245532	129.156298	대학교 졸	500-700만원	은퇴	자녀 양육 가구	7	중도 무당층	74	{"economy": -6, "housing": 16, "welfare": 11, "security": 11, "environment": 18}	유튜브	{환경,공정,안정}	부산광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 환경, 공정, 안정 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 63, "ecoConsciousness": 33, "priceSensitivity": 72, "digitalConsumption": 58}	{"taxTolerance": 46, "governmentTrust": 57, "policyAcceptance": 55, "regulationPreference": 88, "publicServiceSatisfaction": 68}	0
3694	최예준	81	70+	Male	부산광역시	35.111847	129.030196	고졸 이하	200-350만원	은퇴	부부 가구	44	보수 성향 무당층	90	{"economy": 24, "housing": -8, "welfare": -6, "security": 36, "environment": -5}	신문/팟캐스트	{혁신,공동체,전통}	부산광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 혁신, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 73, "noveltySeeking": 39, "ecoConsciousness": 37, "priceSensitivity": 73, "digitalConsumption": 47}	{"taxTolerance": 31, "governmentTrust": 55, "policyAcceptance": 72, "regulationPreference": 94, "publicServiceSatisfaction": 69}	0
3695	황하은	75	70+	Male	부산광역시	35.151099	129.124544	대학교 졸	200-350만원	은퇴	부부 가구	31	보수 성향 무당층	90	{"economy": 23, "housing": 15, "welfare": -9, "security": 7, "environment": -4}	지상파/종편 뉴스	{혁신,전통,성장}	부산광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 혁신, 전통, 성장 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 37, "ecoConsciousness": 23, "priceSensitivity": 73, "digitalConsumption": 46}	{"taxTolerance": 46, "governmentTrust": 54, "policyAcceptance": 58, "regulationPreference": 60, "publicServiceSatisfaction": 66}	0
3696	임수아	71	70+	Male	부산광역시	35.258058	129.153095	전문대 졸	200-350만원	은퇴	다세대 가구	13	중도 무당층	73	{"economy": 9, "housing": 12, "welfare": 8, "security": 0, "environment": 19}	신문/팟캐스트	{안전,혁신,전통}	부산광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안전, 혁신, 전통 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 40, "ecoConsciousness": 34, "priceSensitivity": 53, "digitalConsumption": 49}	{"taxTolerance": 37, "governmentTrust": 53, "policyAcceptance": 67, "regulationPreference": 78, "publicServiceSatisfaction": 68}	0
3697	신성호	72	70+	Male	부산광역시	35.10495	129.152527	고졸 이하	200만원 미만	은퇴	부부 가구	10	중도 무당층	90	{"economy": 2, "housing": -19, "welfare": 31, "security": -9, "environment": 10}	포털 뉴스	{안정,공정,전통}	부산광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안정, 공정, 전통 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 40, "ecoConsciousness": 41, "priceSensitivity": 96, "digitalConsumption": 50}	{"taxTolerance": 43, "governmentTrust": 55, "policyAcceptance": 49, "regulationPreference": 76, "publicServiceSatisfaction": 67}	0
3698	임서윤	25	18-29	Female	대구광역시	35.929874	128.629517	대학교 졸	500-700만원	생산직	부부 가구	-32	진보 성향 무당층	63	{"economy": -22, "housing": 17, "welfare": 44, "security": -3, "environment": 30}	포털 뉴스	{혁신,안정,공동체}	대구광역시에 거주하는 18-29 생산직. 정치 성향은 중도이며 혁신, 안정, 공동체 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 67, "ecoConsciousness": 54, "priceSensitivity": 47, "digitalConsumption": 94}	{"taxTolerance": 56, "governmentTrust": 47, "policyAcceptance": 42, "regulationPreference": 60, "publicServiceSatisfaction": 74}	0
3699	황하은	27	18-29	Female	대구광역시	35.901967	128.527899	대학원 졸	200-350만원	학생	1인 가구	2	중도 무당층	67	{"economy": 20, "housing": 15, "welfare": 25, "security": 42, "environment": 16}	지상파/종편 뉴스	{자유,전통,안정}	대구광역시에 거주하는 18-29 학생. 정치 성향은 중도이며 자유, 전통, 안정 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 79, "ecoConsciousness": 59, "priceSensitivity": 70, "digitalConsumption": 93}	{"taxTolerance": 51, "governmentTrust": 27, "policyAcceptance": 43, "regulationPreference": 62, "publicServiceSatisfaction": 78}	0
3700	황다은	25	18-29	Female	대구광역시	35.929722	128.578779	대학교 졸	500-700만원	공무원	1인 가구	12	중도 무당층	51	{"economy": 10, "housing": -12, "welfare": 22, "security": -5, "environment": 21}	신문/팟캐스트	{전통,다양성,혁신}	대구광역시에 거주하는 18-29 공무원. 정치 성향은 중도이며 전통, 다양성, 혁신 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 75, "ecoConsciousness": 67, "priceSensitivity": 58, "digitalConsumption": 70}	{"taxTolerance": 50, "governmentTrust": 41, "policyAcceptance": 47, "regulationPreference": 54, "publicServiceSatisfaction": 63}	0
3701	정건우	27	18-29	Male	대구광역시	35.860129	128.516512	대학원 졸	350-500만원	사무직	1인 가구	20	보수 성향 무당층	28	{"economy": 3, "housing": 8, "welfare": -16, "security": 7, "environment": -1}	신문/팟캐스트	{성장,안정,혁신}	대구광역시에 거주하는 18-29 사무직. 정치 성향은 중도이며 성장, 안정, 혁신 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 64, "ecoConsciousness": 66, "priceSensitivity": 76, "digitalConsumption": 75}	{"taxTolerance": 35, "governmentTrust": 48, "policyAcceptance": 56, "regulationPreference": 58, "publicServiceSatisfaction": 79}	0
3702	강준서	26	18-29	Male	대구광역시	35.946391	128.513005	대학교 졸	200-350만원	공무원	다세대 가구	5	중도 무당층	46	{"economy": -8, "housing": 33, "welfare": 37, "security": 3, "environment": 19}	SNS	{자유,환경,공정}	대구광역시에 거주하는 18-29 공무원. 정치 성향은 중도이며 자유, 환경, 공정 가치를 중시한다.	{"brandLoyalty": 19, "noveltySeeking": 76, "ecoConsciousness": 65, "priceSensitivity": 72, "digitalConsumption": 97}	{"taxTolerance": 57, "governmentTrust": 51, "policyAcceptance": 33, "regulationPreference": 47, "publicServiceSatisfaction": 65}	0
3703	전하은	20	18-29	Male	대구광역시	35.918135	128.53067	대학교 졸	350-500만원	학생	다세대 가구	-9	중도 무당층	28	{"economy": -34, "housing": 7, "welfare": 29, "security": -4, "environment": 16}	포털 뉴스	{환경,공동체,안전}	대구광역시에 거주하는 18-29 학생. 정치 성향은 중도이며 환경, 공동체, 안전 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 71, "ecoConsciousness": 65, "priceSensitivity": 60, "digitalConsumption": 81}	{"taxTolerance": 39, "governmentTrust": 35, "policyAcceptance": 38, "regulationPreference": 75, "publicServiceSatisfaction": 99}	0
3704	전미경	39	30-39	Female	대구광역시	35.81997	128.571475	대학원 졸	200-350만원	서비스직	자녀 양육 가구	41	보수 성향 무당층	77	{"economy": 8, "housing": 31, "welfare": 5, "security": 1, "environment": 19}	신문/팟캐스트	{공정,자유,안전}	대구광역시에 거주하는 30-39 서비스직. 정치 성향은 보수이며 공정, 자유, 안전 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 94, "ecoConsciousness": 52, "priceSensitivity": 61, "digitalConsumption": 68}	{"taxTolerance": 53, "governmentTrust": 39, "policyAcceptance": 44, "regulationPreference": 54, "publicServiceSatisfaction": 69}	0
3705	류혜진	34	30-39	Female	대구광역시	35.878007	128.687819	대학원 졸	200만원 미만	서비스직	자녀 양육 가구	0	중도 무당층	49	{"economy": -26, "housing": 32, "welfare": 17, "security": 16, "environment": 27}	포털 뉴스	{공동체,환경,전통}	대구광역시에 거주하는 30-39 서비스직. 정치 성향은 중도이며 공동체, 환경, 전통 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 73, "ecoConsciousness": 62, "priceSensitivity": 57, "digitalConsumption": 65}	{"taxTolerance": 51, "governmentTrust": 37, "policyAcceptance": 56, "regulationPreference": 59, "publicServiceSatisfaction": 58}	0
3706	신정희	32	30-39	Female	대구광역시	35.914515	128.651507	대학교 졸	700만원 이상	생산직	부부 가구	4	중도 무당층	44	{"economy": -11, "housing": 22, "welfare": 25, "security": 1, "environment": 0}	신문/팟캐스트	{혁신,공정,성장}	대구광역시에 거주하는 30-39 생산직. 정치 성향은 중도이며 혁신, 공정, 성장 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 76, "ecoConsciousness": 55, "priceSensitivity": 52, "digitalConsumption": 85}	{"taxTolerance": 70, "governmentTrust": 44, "policyAcceptance": 47, "regulationPreference": 65, "publicServiceSatisfaction": 70}	0
3707	송도윤	35	30-39	Male	대구광역시	35.864427	128.65617	전문대 졸	500-700만원	자영업	자녀 양육 가구	-25	진보 성향 무당층	55	{"economy": -12, "housing": 16, "welfare": 13, "security": 27, "environment": 37}	신문/팟캐스트	{공정,성장,환경}	대구광역시에 거주하는 30-39 자영업. 정치 성향은 중도이며 공정, 성장, 환경 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 61, "ecoConsciousness": 67, "priceSensitivity": 56, "digitalConsumption": 68}	{"taxTolerance": 60, "governmentTrust": 50, "policyAcceptance": 56, "regulationPreference": 51, "publicServiceSatisfaction": 70}	0
3708	조준서	34	30-39	Male	대구광역시	35.894145	128.568236	대학교 졸	200-350만원	프리랜서	다세대 가구	-7	중도 무당층	42	{"economy": -1, "housing": 10, "welfare": 25, "security": 33, "environment": 11}	지상파/종편 뉴스	{자유,공동체,혁신}	대구광역시에 거주하는 30-39 프리랜서. 정치 성향은 중도이며 자유, 공동체, 혁신 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 61, "ecoConsciousness": 36, "priceSensitivity": 67, "digitalConsumption": 84}	{"taxTolerance": 59, "governmentTrust": 42, "policyAcceptance": 47, "regulationPreference": 78, "publicServiceSatisfaction": 69}	0
3709	장경숙	36	30-39	Male	대구광역시	35.801864	128.630336	대학교 졸	700만원 이상	전문직	다세대 가구	38	보수 성향 무당층	69	{"economy": 25, "housing": 12, "welfare": -13, "security": 46, "environment": -38}	유튜브	{안전,혁신,전통}	대구광역시에 거주하는 30-39 전문직. 정치 성향은 보수이며 안전, 혁신, 전통 가치를 중시한다.	{"brandLoyalty": 26, "noveltySeeking": 60, "ecoConsciousness": 43, "priceSensitivity": 50, "digitalConsumption": 89}	{"taxTolerance": 53, "governmentTrust": 45, "policyAcceptance": 58, "regulationPreference": 67, "publicServiceSatisfaction": 57}	0
3710	박지민	44	40-49	Female	대구광역시	35.862813	128.648185	대학교 졸	700만원 이상	사무직	부부 가구	38	보수 성향 무당층	49	{"economy": 38, "housing": 9, "welfare": -16, "security": 23, "environment": -12}	유튜브	{성장,안전,안정}	대구광역시에 거주하는 40-49 사무직. 정치 성향은 보수이며 성장, 안전, 안정 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 65, "ecoConsciousness": 57, "priceSensitivity": 49, "digitalConsumption": 62}	{"taxTolerance": 68, "governmentTrust": 36, "policyAcceptance": 46, "regulationPreference": 79, "publicServiceSatisfaction": 52}	0
3711	안채원	47	40-49	Female	대구광역시	35.824106	128.550716	대학원 졸	500-700만원	주부	부부 가구	6	중도 무당층	35	{"economy": -29, "housing": 38, "welfare": 14, "security": 2, "environment": 16}	유튜브	{공동체,안전,공정}	대구광역시에 거주하는 40-49 주부. 정치 성향은 중도이며 공동체, 안전, 공정 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 68, "ecoConsciousness": 62, "priceSensitivity": 60, "digitalConsumption": 64}	{"taxTolerance": 37, "governmentTrust": 63, "policyAcceptance": 60, "regulationPreference": 75, "publicServiceSatisfaction": 87}	0
3712	황성호	46	40-49	Female	대구광역시	35.894096	128.68798	고졸 이하	700만원 이상	자영업	1인 가구	17	보수 성향 무당층	49	{"economy": 4, "housing": 24, "welfare": -11, "security": 32, "environment": 27}	유튜브	{안정,다양성,성장}	대구광역시에 거주하는 40-49 자영업. 정치 성향은 중도이며 안정, 다양성, 성장 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 43, "ecoConsciousness": 55, "priceSensitivity": 39, "digitalConsumption": 62}	{"taxTolerance": 46, "governmentTrust": 64, "policyAcceptance": 38, "regulationPreference": 57, "publicServiceSatisfaction": 73}	0
3713	신성호	43	40-49	Male	대구광역시	35.887408	128.637681	전문대 졸	500-700만원	자영업	자녀 양육 가구	-9	중도 무당층	59	{"economy": -29, "housing": 2, "welfare": 16, "security": 20, "environment": 28}	지상파/종편 뉴스	{다양성,환경,자유}	대구광역시에 거주하는 40-49 자영업. 정치 성향은 중도이며 다양성, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 55, "ecoConsciousness": 63, "priceSensitivity": 54, "digitalConsumption": 81}	{"taxTolerance": 65, "governmentTrust": 56, "policyAcceptance": 37, "regulationPreference": 73, "publicServiceSatisfaction": 72}	0
3714	임하은	43	40-49	Male	대구광역시	35.813023	128.532003	대학교 졸	500-700만원	자영업	1인 가구	31	보수 성향 무당층	59	{"economy": 10, "housing": 29, "welfare": 16, "security": 33, "environment": 9}	SNS	{환경,공동체,안전}	대구광역시에 거주하는 40-49 자영업. 정치 성향은 중도이며 환경, 공동체, 안전 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 73, "ecoConsciousness": 49, "priceSensitivity": 41, "digitalConsumption": 96}	{"taxTolerance": 48, "governmentTrust": 50, "policyAcceptance": 48, "regulationPreference": 62, "publicServiceSatisfaction": 87}	0
3715	장지아	40	40-49	Male	대구광역시	35.841788	128.575647	고졸 이하	500-700만원	주부	부부 가구	-14	중도 무당층	63	{"economy": 9, "housing": 4, "welfare": 38, "security": -25, "environment": 16}	유튜브	{성장,환경,다양성}	대구광역시에 거주하는 40-49 주부. 정치 성향은 중도이며 성장, 환경, 다양성 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 52, "ecoConsciousness": 33, "priceSensitivity": 58, "digitalConsumption": 77}	{"taxTolerance": 46, "governmentTrust": 51, "policyAcceptance": 45, "regulationPreference": 66, "publicServiceSatisfaction": 91}	0
3716	전경숙	52	50-59	Female	대구광역시	35.888199	128.565559	대학교 졸	500-700만원	학생	부부 가구	30	보수 성향 무당층	60	{"economy": 20, "housing": -18, "welfare": -22, "security": 51, "environment": 30}	포털 뉴스	{공동체,자유,안정}	대구광역시에 거주하는 50-59 학생. 정치 성향은 중도이며 공동체, 자유, 안정 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 55, "ecoConsciousness": 39, "priceSensitivity": 32, "digitalConsumption": 91}	{"taxTolerance": 70, "governmentTrust": 48, "policyAcceptance": 65, "regulationPreference": 76, "publicServiceSatisfaction": 72}	0
3717	이민준	56	50-59	Female	대구광역시	35.851184	128.686583	전문대 졸	200-350만원	주부	1인 가구	23	보수 성향 무당층	52	{"economy": 5, "housing": -6, "welfare": 13, "security": -3, "environment": 13}	신문/팟캐스트	{공정,다양성,자유}	대구광역시에 거주하는 50-59 주부. 정치 성향은 중도이며 공정, 다양성, 자유 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 69, "ecoConsciousness": 46, "priceSensitivity": 65, "digitalConsumption": 83}	{"taxTolerance": 58, "governmentTrust": 60, "policyAcceptance": 56, "regulationPreference": 78, "publicServiceSatisfaction": 84}	0
3718	한건우	52	50-59	Female	대구광역시	35.910545	128.670128	대학원 졸	500-700만원	생산직	부부 가구	48	보수 정당 지지	84	{"economy": 5, "housing": 13, "welfare": -17, "security": 61, "environment": 8}	유튜브	{혁신,공동체,환경}	대구광역시에 거주하는 50-59 생산직. 정치 성향은 보수이며 혁신, 공동체, 환경 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 71, "ecoConsciousness": 48, "priceSensitivity": 49, "digitalConsumption": 55}	{"taxTolerance": 54, "governmentTrust": 49, "policyAcceptance": 49, "regulationPreference": 63, "publicServiceSatisfaction": 64}	0
3719	송지우	57	50-59	Female	대구광역시	35.839672	128.667931	전문대 졸	500-700만원	은퇴	자녀 양육 가구	16	보수 성향 무당층	43	{"economy": -11, "housing": -2, "welfare": 15, "security": -5, "environment": 18}	유튜브	{안정,안전,공정}	대구광역시에 거주하는 50-59 은퇴. 정치 성향은 중도이며 안정, 안전, 공정 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 65, "ecoConsciousness": 55, "priceSensitivity": 55, "digitalConsumption": 65}	{"taxTolerance": 45, "governmentTrust": 53, "policyAcceptance": 43, "regulationPreference": 78, "publicServiceSatisfaction": 57}	0
3720	황지민	52	50-59	Male	대구광역시	35.857707	128.692061	고졸 이하	350-500만원	서비스직	다세대 가구	10	중도 무당층	58	{"economy": 3, "housing": 9, "welfare": -24, "security": 9, "environment": 14}	포털 뉴스	{혁신,안정,공동체}	대구광역시에 거주하는 50-59 서비스직. 정치 성향은 중도이며 혁신, 안정, 공동체 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 68, "ecoConsciousness": 25, "priceSensitivity": 52, "digitalConsumption": 58}	{"taxTolerance": 39, "governmentTrust": 44, "policyAcceptance": 54, "regulationPreference": 67, "publicServiceSatisfaction": 59}	0
3721	류민준	55	50-59	Male	대구광역시	35.864554	128.61029	대학교 졸	500-700만원	프리랜서	자녀 양육 가구	12	중도 무당층	62	{"economy": -1, "housing": 18, "welfare": 48, "security": 13, "environment": 2}	SNS	{자유,안전,환경}	대구광역시에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 자유, 안전, 환경 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 49, "ecoConsciousness": 50, "priceSensitivity": 59, "digitalConsumption": 76}	{"taxTolerance": 50, "governmentTrust": 63, "policyAcceptance": 42, "regulationPreference": 68, "publicServiceSatisfaction": 79}	0
3722	임동현	58	50-59	Male	대구광역시	35.949346	128.654283	고졸 이하	500-700만원	프리랜서	부부 가구	44	보수 성향 무당층	76	{"economy": -11, "housing": -13, "welfare": -36, "security": 36, "environment": -6}	유튜브	{자유,환경,안전}	대구광역시에 거주하는 50-59 프리랜서. 정치 성향은 보수이며 자유, 환경, 안전 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 47, "ecoConsciousness": 31, "priceSensitivity": 35, "digitalConsumption": 56}	{"taxTolerance": 43, "governmentTrust": 37, "policyAcceptance": 49, "regulationPreference": 56, "publicServiceSatisfaction": 56}	0
3723	임하은	51	50-59	Male	대구광역시	35.857381	128.654813	대학원 졸	200만원 미만	주부	부부 가구	16	보수 성향 무당층	75	{"economy": 5, "housing": 2, "welfare": -1, "security": -14, "environment": 12}	포털 뉴스	{안정,안전,공동체}	대구광역시에 거주하는 50-59 주부. 정치 성향은 중도이며 안정, 안전, 공동체 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 62, "ecoConsciousness": 64, "priceSensitivity": 84, "digitalConsumption": 69}	{"taxTolerance": 54, "governmentTrust": 49, "policyAcceptance": 69, "regulationPreference": 69, "publicServiceSatisfaction": 75}	0
3724	윤준서	63	60-69	Female	대구광역시	35.887581	128.54992	전문대 졸	500-700만원	생산직	자녀 양육 가구	32	보수 성향 무당층	80	{"economy": 11, "housing": -30, "welfare": 9, "security": 70, "environment": 27}	포털 뉴스	{공동체,안정,자유}	대구광역시에 거주하는 60-69 생산직. 정치 성향은 중도이며 공동체, 안정, 자유 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 64, "ecoConsciousness": 58, "priceSensitivity": 40, "digitalConsumption": 53}	{"taxTolerance": 42, "governmentTrust": 69, "policyAcceptance": 54, "regulationPreference": 56, "publicServiceSatisfaction": 64}	0
3725	이주원	65	60-69	Female	대구광역시	35.881429	128.516858	전문대 졸	500-700만원	주부	부부 가구	38	보수 성향 무당층	73	{"economy": 31, "housing": 6, "welfare": 15, "security": 25, "environment": 18}	포털 뉴스	{안정,공정,다양성}	대구광역시에 거주하는 60-69 주부. 정치 성향은 보수이며 안정, 공정, 다양성 가치를 중시한다.	{"brandLoyalty": 61, "noveltySeeking": 45, "ecoConsciousness": 39, "priceSensitivity": 46, "digitalConsumption": 52}	{"taxTolerance": 55, "governmentTrust": 56, "policyAcceptance": 51, "regulationPreference": 53, "publicServiceSatisfaction": 88}	0
3726	안은우	63	60-69	Female	대구광역시	35.80401	128.510046	대학원 졸	200만원 미만	자영업	1인 가구	42	보수 성향 무당층	86	{"economy": 29, "housing": 25, "welfare": -11, "security": 33, "environment": 1}	지상파/종편 뉴스	{공동체,공정,다양성}	대구광역시에 거주하는 60-69 자영업. 정치 성향은 보수이며 공동체, 공정, 다양성 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 53, "ecoConsciousness": 27, "priceSensitivity": 84, "digitalConsumption": 47}	{"taxTolerance": 42, "governmentTrust": 65, "policyAcceptance": 29, "regulationPreference": 78, "publicServiceSatisfaction": 72}	0
3727	신혜진	61	60-69	Male	대구광역시	35.884792	128.516177	대학원 졸	200-350만원	학생	자녀 양육 가구	34	보수 성향 무당층	66	{"economy": 12, "housing": 9, "welfare": 2, "security": 3, "environment": -19}	SNS	{안전,자유,성장}	대구광역시에 거주하는 60-69 학생. 정치 성향은 보수이며 안전, 자유, 성장 가치를 중시한다.	{"brandLoyalty": 67, "noveltySeeking": 55, "ecoConsciousness": 57, "priceSensitivity": 65, "digitalConsumption": 56}	{"taxTolerance": 44, "governmentTrust": 53, "policyAcceptance": 66, "regulationPreference": 75, "publicServiceSatisfaction": 57}	0
3728	홍미경	69	60-69	Male	대구광역시	35.796851	128.586249	대학원 졸	200만원 미만	은퇴	다세대 가구	19	보수 성향 무당층	68	{"economy": 21, "housing": 14, "welfare": 7, "security": 12, "environment": 11}	SNS	{성장,다양성,혁신}	대구광역시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 성장, 다양성, 혁신 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 50, "ecoConsciousness": 42, "priceSensitivity": 79, "digitalConsumption": 55}	{"taxTolerance": 61, "governmentTrust": 54, "policyAcceptance": 55, "regulationPreference": 79, "publicServiceSatisfaction": 65}	0
3729	이지우	63	60-69	Male	대구광역시	35.937825	128.559399	전문대 졸	500-700만원	공무원	자녀 양육 가구	1	중도 무당층	88	{"economy": 7, "housing": 13, "welfare": 5, "security": 31, "environment": 11}	지상파/종편 뉴스	{다양성,안전,전통}	대구광역시에 거주하는 60-69 공무원. 정치 성향은 중도이며 다양성, 안전, 전통 가치를 중시한다.	{"brandLoyalty": 75, "noveltySeeking": 49, "ecoConsciousness": 27, "priceSensitivity": 71, "digitalConsumption": 38}	{"taxTolerance": 60, "governmentTrust": 54, "policyAcceptance": 47, "regulationPreference": 71, "publicServiceSatisfaction": 56}	0
3730	윤철수	80	70+	Female	대구광역시	35.879357	128.677467	대학원 졸	200-350만원	은퇴	자녀 양육 가구	48	보수 정당 지지	84	{"economy": 27, "housing": 7, "welfare": 4, "security": 57, "environment": -5}	유튜브	{환경,안정,다양성}	대구광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 환경, 안정, 다양성 가치를 중시한다.	{"brandLoyalty": 75, "noveltySeeking": 49, "ecoConsciousness": 37, "priceSensitivity": 77, "digitalConsumption": 63}	{"taxTolerance": 49, "governmentTrust": 75, "policyAcceptance": 63, "regulationPreference": 76, "publicServiceSatisfaction": 65}	0
3731	신준서	79	70+	Female	대구광역시	35.830003	128.654919	전문대 졸	500-700만원	은퇴	다세대 가구	21	보수 성향 무당층	80	{"economy": 1, "housing": 36, "welfare": -22, "security": 18, "environment": -9}	신문/팟캐스트	{공동체,자유,공정}	대구광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공동체, 자유, 공정 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 52, "ecoConsciousness": 42, "priceSensitivity": 46, "digitalConsumption": 60}	{"taxTolerance": 55, "governmentTrust": 38, "policyAcceptance": 62, "regulationPreference": 57, "publicServiceSatisfaction": 47}	0
3732	강정희	76	70+	Female	대구광역시	35.887217	128.56339	전문대 졸	350-500만원	은퇴	1인 가구	81	보수 정당 지지	75	{"economy": 0, "housing": -12, "welfare": -26, "security": 69, "environment": -5}	신문/팟캐스트	{자유,성장,공동체}	대구광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 자유, 성장, 공동체 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 34, "ecoConsciousness": 47, "priceSensitivity": 65, "digitalConsumption": 47}	{"taxTolerance": 47, "governmentTrust": 63, "policyAcceptance": 54, "regulationPreference": 63, "publicServiceSatisfaction": 61}	0
3733	이은우	77	70+	Male	대구광역시	35.858451	128.601686	고졸 이하	350-500만원	은퇴	자녀 양육 가구	18	보수 성향 무당층	99	{"economy": 8, "housing": 7, "welfare": -2, "security": 7, "environment": 23}	포털 뉴스	{안전,공동체,전통}	대구광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안전, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 45, "ecoConsciousness": 32, "priceSensitivity": 69, "digitalConsumption": 69}	{"taxTolerance": 29, "governmentTrust": 46, "policyAcceptance": 55, "regulationPreference": 61, "publicServiceSatisfaction": 68}	0
3734	조지아	72	70+	Male	대구광역시	35.833301	128.64428	대학원 졸	500-700만원	은퇴	부부 가구	34	보수 성향 무당층	90	{"economy": 28, "housing": 6, "welfare": -2, "security": 44, "environment": 25}	신문/팟캐스트	{다양성,공정,안정}	대구광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 다양성, 공정, 안정 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 55, "ecoConsciousness": 40, "priceSensitivity": 55, "digitalConsumption": 64}	{"taxTolerance": 55, "governmentTrust": 38, "policyAcceptance": 58, "regulationPreference": 57, "publicServiceSatisfaction": 86}	0
3735	강주원	72	70+	Male	대구광역시	35.865253	128.638913	대학교 졸	200-350만원	은퇴	1인 가구	51	보수 정당 지지	78	{"economy": 35, "housing": -7, "welfare": -13, "security": 28, "environment": 7}	SNS	{다양성,안정,공동체}	대구광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 다양성, 안정, 공동체 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 45, "ecoConsciousness": 44, "priceSensitivity": 75, "digitalConsumption": 61}	{"taxTolerance": 40, "governmentTrust": 46, "policyAcceptance": 69, "regulationPreference": 80, "publicServiceSatisfaction": 73}	0
3736	강지우	26	18-29	Female	인천광역시	37.512384	126.804959	전문대 졸	200-350만원	은퇴	자녀 양육 가구	-14	중도 무당층	32	{"economy": 5, "housing": 17, "welfare": 12, "security": 10, "environment": 2}	신문/팟캐스트	{전통,자유,환경}	인천광역시에 거주하는 18-29 은퇴. 정치 성향은 중도이며 전통, 자유, 환경 가치를 중시한다.	{"brandLoyalty": 19, "noveltySeeking": 90, "ecoConsciousness": 54, "priceSensitivity": 59, "digitalConsumption": 72}	{"taxTolerance": 21, "governmentTrust": 50, "policyAcceptance": 55, "regulationPreference": 55, "publicServiceSatisfaction": 87}	0
3737	장채원	26	18-29	Female	인천광역시	37.471436	126.692096	대학원 졸	200-350만원	주부	부부 가구	-46	진보 정당 지지	58	{"economy": -64, "housing": 56, "welfare": 13, "security": -15, "environment": 23}	신문/팟캐스트	{공동체,전통,공정}	인천광역시에 거주하는 18-29 주부. 정치 성향은 진보이며 공동체, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 75, "ecoConsciousness": 52, "priceSensitivity": 77, "digitalConsumption": 84}	{"taxTolerance": 46, "governmentTrust": 44, "policyAcceptance": 52, "regulationPreference": 47, "publicServiceSatisfaction": 81}	0
3738	임영수	25	18-29	Female	인천광역시	37.422566	126.779034	전문대 졸	500-700만원	공무원	다세대 가구	-4	중도 무당층	60	{"economy": -9, "housing": -2, "welfare": 4, "security": -5, "environment": 54}	SNS	{공정,안정,성장}	인천광역시에 거주하는 18-29 공무원. 정치 성향은 중도이며 공정, 안정, 성장 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 70, "ecoConsciousness": 52, "priceSensitivity": 42, "digitalConsumption": 83}	{"taxTolerance": 48, "governmentTrust": 45, "policyAcceptance": 43, "regulationPreference": 76, "publicServiceSatisfaction": 57}	0
3739	정지민	18	18-29	Female	인천광역시	37.435051	126.647737	대학교 졸	500-700만원	학생	다세대 가구	-37	진보 성향 무당층	39	{"economy": -29, "housing": 69, "welfare": 36, "security": 7, "environment": 33}	유튜브	{성장,다양성,공정}	인천광역시에 거주하는 18-29 학생. 정치 성향은 진보이며 성장, 다양성, 공정 가치를 중시한다.	{"brandLoyalty": 13, "noveltySeeking": 76, "ecoConsciousness": 62, "priceSensitivity": 59, "digitalConsumption": 77}	{"taxTolerance": 59, "governmentTrust": 55, "policyAcceptance": 54, "regulationPreference": 45, "publicServiceSatisfaction": 79}	0
3740	안지우	23	18-29	Male	인천광역시	37.473059	126.780573	대학교 졸	200-350만원	학생	1인 가구	-54	진보 정당 지지	56	{"economy": -43, "housing": 44, "welfare": 47, "security": -9, "environment": 46}	포털 뉴스	{안전,전통,환경}	인천광역시에 거주하는 18-29 학생. 정치 성향은 진보이며 안전, 전통, 환경 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 52, "ecoConsciousness": 45, "priceSensitivity": 56, "digitalConsumption": 71}	{"taxTolerance": 33, "governmentTrust": 40, "policyAcceptance": 50, "regulationPreference": 55, "publicServiceSatisfaction": 58}	0
3741	류민서	22	18-29	Male	인천광역시	37.448818	126.647753	대학교 졸	500-700만원	학생	다세대 가구	-31	진보 성향 무당층	59	{"economy": -55, "housing": 3, "welfare": 26, "security": -4, "environment": 57}	포털 뉴스	{전통,다양성,환경}	인천광역시에 거주하는 18-29 학생. 정치 성향은 중도이며 전통, 다양성, 환경 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 72, "ecoConsciousness": 42, "priceSensitivity": 47, "digitalConsumption": 87}	{"taxTolerance": 65, "governmentTrust": 36, "policyAcceptance": 42, "regulationPreference": 59, "publicServiceSatisfaction": 72}	0
3742	조서윤	19	18-29	Male	인천광역시	37.423609	126.781994	대학원 졸	200만원 미만	생산직	자녀 양육 가구	-58	진보 정당 지지	46	{"economy": -40, "housing": 61, "welfare": 48, "security": -8, "environment": 37}	유튜브	{환경,안전,성장}	인천광역시에 거주하는 18-29 생산직. 정치 성향은 진보이며 환경, 안전, 성장 가치를 중시한다.	{"brandLoyalty": 20, "noveltySeeking": 81, "ecoConsciousness": 57, "priceSensitivity": 95, "digitalConsumption": 97}	{"taxTolerance": 59, "governmentTrust": 23, "policyAcceptance": 41, "regulationPreference": 59, "publicServiceSatisfaction": 64}	0
3743	송도윤	19	18-29	Male	인천광역시	37.534684	126.741895	대학원 졸	350-500만원	학생	다세대 가구	-48	진보 정당 지지	39	{"economy": -33, "housing": 45, "welfare": 31, "security": -29, "environment": 47}	신문/팟캐스트	{다양성,전통,안전}	인천광역시에 거주하는 18-29 학생. 정치 성향은 진보이며 다양성, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 18, "noveltySeeking": 67, "ecoConsciousness": 81, "priceSensitivity": 63, "digitalConsumption": 95}	{"taxTolerance": 61, "governmentTrust": 22, "policyAcceptance": 46, "regulationPreference": 63, "publicServiceSatisfaction": 70}	0
3744	강서연	30	30-39	Female	인천광역시	37.461225	126.761538	대학원 졸	350-500만원	서비스직	1인 가구	-36	진보 성향 무당층	64	{"economy": -23, "housing": 1, "welfare": 11, "security": -28, "environment": 42}	포털 뉴스	{전통,공정,공동체}	인천광역시에 거주하는 30-39 서비스직. 정치 성향은 진보이며 전통, 공정, 공동체 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 98, "ecoConsciousness": 51, "priceSensitivity": 55, "digitalConsumption": 84}	{"taxTolerance": 54, "governmentTrust": 40, "policyAcceptance": 46, "regulationPreference": 65, "publicServiceSatisfaction": 68}	0
3745	신미경	37	30-39	Female	인천광역시	37.535612	126.77713	대학교 졸	500-700만원	학생	부부 가구	-11	중도 무당층	59	{"economy": 1, "housing": 8, "welfare": 19, "security": 0, "environment": 33}	신문/팟캐스트	{성장,전통,다양성}	인천광역시에 거주하는 30-39 학생. 정치 성향은 중도이며 성장, 전통, 다양성 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 67, "ecoConsciousness": 53, "priceSensitivity": 41, "digitalConsumption": 81}	{"taxTolerance": 47, "governmentTrust": 41, "policyAcceptance": 41, "regulationPreference": 58, "publicServiceSatisfaction": 78}	0
3746	권지민	31	30-39	Female	인천광역시	37.415087	126.767231	대학원 졸	700만원 이상	주부	부부 가구	-22	진보 성향 무당층	47	{"economy": -5, "housing": 58, "welfare": 24, "security": 27, "environment": 36}	SNS	{다양성,공정,안정}	인천광역시에 거주하는 30-39 주부. 정치 성향은 중도이며 다양성, 공정, 안정 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 76, "ecoConsciousness": 67, "priceSensitivity": 29, "digitalConsumption": 67}	{"taxTolerance": 71, "governmentTrust": 22, "policyAcceptance": 43, "regulationPreference": 54, "publicServiceSatisfaction": 65}	0
3747	김수아	33	30-39	Female	인천광역시	37.399556	126.769726	전문대 졸	500-700만원	학생	1인 가구	-27	진보 성향 무당층	40	{"economy": 6, "housing": 14, "welfare": 22, "security": -25, "environment": 17}	지상파/종편 뉴스	{혁신,안전,자유}	인천광역시에 거주하는 30-39 학생. 정치 성향은 중도이며 혁신, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 26, "noveltySeeking": 65, "ecoConsciousness": 65, "priceSensitivity": 34, "digitalConsumption": 78}	{"taxTolerance": 55, "governmentTrust": 47, "policyAcceptance": 45, "regulationPreference": 61, "publicServiceSatisfaction": 78}	0
3748	조채원	34	30-39	Male	인천광역시	37.486467	126.733746	전문대 졸	350-500만원	자영업	1인 가구	-7	중도 무당층	72	{"economy": -24, "housing": 26, "welfare": 28, "security": -22, "environment": 52}	지상파/종편 뉴스	{공동체,공정,자유}	인천광역시에 거주하는 30-39 자영업. 정치 성향은 중도이며 공동체, 공정, 자유 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 66, "ecoConsciousness": 44, "priceSensitivity": 63, "digitalConsumption": 82}	{"taxTolerance": 58, "governmentTrust": 20, "policyAcceptance": 40, "regulationPreference": 75, "publicServiceSatisfaction": 60}	0
3749	최주원	30	30-39	Male	인천광역시	37.515684	126.774007	대학원 졸	350-500만원	사무직	자녀 양육 가구	-25	진보 성향 무당층	56	{"economy": -37, "housing": 11, "welfare": 25, "security": -12, "environment": 38}	포털 뉴스	{자유,안정,공동체}	인천광역시에 거주하는 30-39 사무직. 정치 성향은 중도이며 자유, 안정, 공동체 가치를 중시한다.	{"brandLoyalty": 16, "noveltySeeking": 78, "ecoConsciousness": 43, "priceSensitivity": 46, "digitalConsumption": 65}	{"taxTolerance": 78, "governmentTrust": 62, "policyAcceptance": 45, "regulationPreference": 61, "publicServiceSatisfaction": 51}	0
3750	장지민	39	30-39	Male	인천광역시	37.474102	126.638663	대학교 졸	200-350만원	서비스직	자녀 양육 가구	-18	진보 성향 무당층	52	{"economy": -3, "housing": 3, "welfare": 7, "security": 13, "environment": 19}	신문/팟캐스트	{전통,혁신,안정}	인천광역시에 거주하는 30-39 서비스직. 정치 성향은 중도이며 전통, 혁신, 안정 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 67, "ecoConsciousness": 59, "priceSensitivity": 64, "digitalConsumption": 86}	{"taxTolerance": 60, "governmentTrust": 37, "policyAcceptance": 46, "regulationPreference": 59, "publicServiceSatisfaction": 68}	0
3751	이현우	32	30-39	Male	인천광역시	37.409492	126.704953	대학원 졸	700만원 이상	프리랜서	자녀 양육 가구	-57	진보 정당 지지	37	{"economy": -68, "housing": 33, "welfare": 53, "security": 3, "environment": 42}	포털 뉴스	{안전,전통,안정}	인천광역시에 거주하는 30-39 프리랜서. 정치 성향은 진보이며 안전, 전통, 안정 가치를 중시한다.	{"brandLoyalty": 7, "noveltySeeking": 60, "ecoConsciousness": 52, "priceSensitivity": 49, "digitalConsumption": 68}	{"taxTolerance": 59, "governmentTrust": 41, "policyAcceptance": 40, "regulationPreference": 70, "publicServiceSatisfaction": 73}	0
3752	조채원	44	40-49	Female	인천광역시	37.441787	126.7476	대학원 졸	500-700만원	학생	자녀 양육 가구	-75	진보 정당 지지	80	{"economy": -49, "housing": 51, "welfare": 51, "security": -34, "environment": 46}	신문/팟캐스트	{성장,안정,공동체}	인천광역시에 거주하는 40-49 학생. 정치 성향은 진보이며 성장, 안정, 공동체 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 57, "ecoConsciousness": 62, "priceSensitivity": 35, "digitalConsumption": 87}	{"taxTolerance": 49, "governmentTrust": 44, "policyAcceptance": 53, "regulationPreference": 47, "publicServiceSatisfaction": 61}	0
3753	장준서	43	40-49	Female	인천광역시	37.415467	126.7721	대학교 졸	200-350만원	은퇴	다세대 가구	1	중도 무당층	62	{"economy": 5, "housing": 3, "welfare": 10, "security": -9, "environment": 9}	지상파/종편 뉴스	{혁신,성장,다양성}	인천광역시에 거주하는 40-49 은퇴. 정치 성향은 중도이며 혁신, 성장, 다양성 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 72, "ecoConsciousness": 44, "priceSensitivity": 65, "digitalConsumption": 76}	{"taxTolerance": 50, "governmentTrust": 30, "policyAcceptance": 40, "regulationPreference": 62, "publicServiceSatisfaction": 57}	0
3754	박서연	45	40-49	Female	인천광역시	37.471	126.679076	대학교 졸	350-500만원	사무직	자녀 양육 가구	-2	중도 무당층	64	{"economy": 9, "housing": 11, "welfare": 18, "security": -29, "environment": 25}	포털 뉴스	{성장,공정,안정}	인천광역시에 거주하는 40-49 사무직. 정치 성향은 중도이며 성장, 공정, 안정 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 60, "ecoConsciousness": 64, "priceSensitivity": 48, "digitalConsumption": 70}	{"taxTolerance": 46, "governmentTrust": 23, "policyAcceptance": 64, "regulationPreference": 58, "publicServiceSatisfaction": 66}	0
3755	오예준	44	40-49	Female	인천광역시	37.470649	126.762202	대학원 졸	700만원 이상	전문직	부부 가구	-3	중도 무당층	51	{"economy": 5, "housing": 34, "welfare": 9, "security": 7, "environment": 1}	포털 뉴스	{공정,전통,공동체}	인천광역시에 거주하는 40-49 전문직. 정치 성향은 중도이며 공정, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 77, "ecoConsciousness": 41, "priceSensitivity": 42, "digitalConsumption": 74}	{"taxTolerance": 65, "governmentTrust": 49, "policyAcceptance": 32, "regulationPreference": 63, "publicServiceSatisfaction": 73}	0
3756	류채원	44	40-49	Male	인천광역시	37.40022	126.752412	고졸 이하	200만원 미만	주부	자녀 양육 가구	-49	진보 정당 지지	57	{"economy": -46, "housing": 31, "welfare": 35, "security": -19, "environment": 36}	지상파/종편 뉴스	{환경,공동체,전통}	인천광역시에 거주하는 40-49 주부. 정치 성향은 진보이며 환경, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 57, "ecoConsciousness": 52, "priceSensitivity": 72, "digitalConsumption": 75}	{"taxTolerance": 39, "governmentTrust": 51, "policyAcceptance": 69, "regulationPreference": 53, "publicServiceSatisfaction": 75}	0
3757	신하은	42	40-49	Male	인천광역시	37.493076	126.658502	대학교 졸	700만원 이상	서비스직	1인 가구	-33	진보 성향 무당층	61	{"economy": -28, "housing": 23, "welfare": 36, "security": -21, "environment": 25}	유튜브	{자유,성장,전통}	인천광역시에 거주하는 40-49 서비스직. 정치 성향은 중도이며 자유, 성장, 전통 가치를 중시한다.	{"brandLoyalty": 24, "noveltySeeking": 60, "ecoConsciousness": 47, "priceSensitivity": 45, "digitalConsumption": 84}	{"taxTolerance": 47, "governmentTrust": 61, "policyAcceptance": 40, "regulationPreference": 62, "publicServiceSatisfaction": 69}	0
3758	이다은	40	40-49	Male	인천광역시	37.473137	126.730263	전문대 졸	200-350만원	서비스직	부부 가구	-44	진보 성향 무당층	77	{"economy": -49, "housing": 28, "welfare": 12, "security": -18, "environment": 34}	포털 뉴스	{혁신,다양성,성장}	인천광역시에 거주하는 40-49 서비스직. 정치 성향은 진보이며 혁신, 다양성, 성장 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 60, "ecoConsciousness": 68, "priceSensitivity": 59, "digitalConsumption": 84}	{"taxTolerance": 30, "governmentTrust": 39, "policyAcceptance": 53, "regulationPreference": 57, "publicServiceSatisfaction": 69}	0
3759	강지우	42	40-49	Male	인천광역시	37.530657	126.749171	전문대 졸	700만원 이상	사무직	다세대 가구	29	보수 성향 무당층	41	{"economy": 9, "housing": 18, "welfare": 0, "security": 28, "environment": 31}	포털 뉴스	{공동체,성장,공정}	인천광역시에 거주하는 40-49 사무직. 정치 성향은 중도이며 공동체, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 62, "ecoConsciousness": 51, "priceSensitivity": 47, "digitalConsumption": 77}	{"taxTolerance": 43, "governmentTrust": 44, "policyAcceptance": 64, "regulationPreference": 58, "publicServiceSatisfaction": 66}	0
3760	강지민	53	50-59	Female	인천광역시	37.452936	126.643362	대학원 졸	500-700만원	서비스직	1인 가구	-23	진보 성향 무당층	74	{"economy": -26, "housing": 58, "welfare": 21, "security": 5, "environment": 43}	포털 뉴스	{안정,전통,다양성}	인천광역시에 거주하는 50-59 서비스직. 정치 성향은 중도이며 안정, 전통, 다양성 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 71, "ecoConsciousness": 49, "priceSensitivity": 54, "digitalConsumption": 66}	{"taxTolerance": 34, "governmentTrust": 61, "policyAcceptance": 67, "regulationPreference": 64, "publicServiceSatisfaction": 71}	0
3761	한지호	58	50-59	Female	인천광역시	37.517148	126.763931	대학교 졸	500-700만원	학생	다세대 가구	-24	진보 성향 무당층	90	{"economy": -28, "housing": 66, "welfare": -7, "security": -2, "environment": 28}	유튜브	{공정,전통,혁신}	인천광역시에 거주하는 50-59 학생. 정치 성향은 중도이며 공정, 전통, 혁신 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 35, "ecoConsciousness": 55, "priceSensitivity": 51, "digitalConsumption": 59}	{"taxTolerance": 54, "governmentTrust": 45, "policyAcceptance": 67, "regulationPreference": 60, "publicServiceSatisfaction": 77}	0
3762	권지민	58	50-59	Female	인천광역시	37.433232	126.780111	대학교 졸	700만원 이상	은퇴	부부 가구	0	중도 무당층	87	{"economy": -30, "housing": 12, "welfare": 0, "security": 32, "environment": 36}	포털 뉴스	{다양성,안전,환경}	인천광역시에 거주하는 50-59 은퇴. 정치 성향은 중도이며 다양성, 안전, 환경 가치를 중시한다.	{"brandLoyalty": 60, "noveltySeeking": 66, "ecoConsciousness": 36, "priceSensitivity": 38, "digitalConsumption": 65}	{"taxTolerance": 39, "governmentTrust": 41, "policyAcceptance": 58, "regulationPreference": 71, "publicServiceSatisfaction": 61}	0
3763	서다은	53	50-59	Female	인천광역시	37.380106	126.717802	고졸 이하	350-500만원	프리랜서	1인 가구	-5	중도 무당층	70	{"economy": -6, "housing": 7, "welfare": 17, "security": 35, "environment": 4}	신문/팟캐스트	{전통,안정,환경}	인천광역시에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 전통, 안정, 환경 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 50, "ecoConsciousness": 59, "priceSensitivity": 77, "digitalConsumption": 76}	{"taxTolerance": 61, "governmentTrust": 51, "policyAcceptance": 54, "regulationPreference": 70, "publicServiceSatisfaction": 60}	0
3764	안민준	59	50-59	Female	인천광역시	37.428779	126.778138	전문대 졸	700만원 이상	사무직	다세대 가구	16	보수 성향 무당층	74	{"economy": -11, "housing": -13, "welfare": -30, "security": 35, "environment": 14}	SNS	{자유,환경,안정}	인천광역시에 거주하는 50-59 사무직. 정치 성향은 중도이며 자유, 환경, 안정 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 70, "ecoConsciousness": 52, "priceSensitivity": 44, "digitalConsumption": 70}	{"taxTolerance": 52, "governmentTrust": 60, "policyAcceptance": 64, "regulationPreference": 61, "publicServiceSatisfaction": 57}	0
3765	신순자	58	50-59	Male	인천광역시	37.41823	126.786556	전문대 졸	700만원 이상	주부	자녀 양육 가구	-36	진보 성향 무당층	90	{"economy": -27, "housing": 17, "welfare": 22, "security": -4, "environment": 34}	신문/팟캐스트	{안정,전통,환경}	인천광역시에 거주하는 50-59 주부. 정치 성향은 진보이며 안정, 전통, 환경 가치를 중시한다.	{"brandLoyalty": 64, "noveltySeeking": 31, "ecoConsciousness": 47, "priceSensitivity": 38, "digitalConsumption": 81}	{"taxTolerance": 58, "governmentTrust": 46, "policyAcceptance": 59, "regulationPreference": 72, "publicServiceSatisfaction": 86}	0
3766	권혜진	55	50-59	Male	인천광역시	37.461034	126.776433	대학교 졸	500-700만원	학생	부부 가구	-21	진보 성향 무당층	63	{"economy": 4, "housing": 42, "welfare": 34, "security": 3, "environment": 29}	SNS	{전통,안정,혁신}	인천광역시에 거주하는 50-59 학생. 정치 성향은 중도이며 전통, 안정, 혁신 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 41, "ecoConsciousness": 35, "priceSensitivity": 48, "digitalConsumption": 81}	{"taxTolerance": 48, "governmentTrust": 51, "policyAcceptance": 52, "regulationPreference": 71, "publicServiceSatisfaction": 59}	0
3767	홍영수	55	50-59	Male	인천광역시	37.436567	126.805146	대학교 졸	700만원 이상	공무원	1인 가구	18	보수 성향 무당층	63	{"economy": 9, "housing": 8, "welfare": -33, "security": -18, "environment": 13}	신문/팟캐스트	{안정,다양성,전통}	인천광역시에 거주하는 50-59 공무원. 정치 성향은 중도이며 안정, 다양성, 전통 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 69, "ecoConsciousness": 38, "priceSensitivity": 27, "digitalConsumption": 59}	{"taxTolerance": 52, "governmentTrust": 36, "policyAcceptance": 68, "regulationPreference": 53, "publicServiceSatisfaction": 76}	0
3768	이은우	55	50-59	Male	인천광역시	37.394734	126.613175	고졸 이하	200-350만원	은퇴	1인 가구	-24	진보 성향 무당층	72	{"economy": -23, "housing": 14, "welfare": 12, "security": 5, "environment": 60}	유튜브	{자유,다양성,전통}	인천광역시에 거주하는 50-59 은퇴. 정치 성향은 중도이며 자유, 다양성, 전통 가치를 중시한다.	{"brandLoyalty": 68, "noveltySeeking": 54, "ecoConsciousness": 41, "priceSensitivity": 72, "digitalConsumption": 53}	{"taxTolerance": 42, "governmentTrust": 62, "policyAcceptance": 72, "regulationPreference": 66, "publicServiceSatisfaction": 70}	0
3769	최하은	56	50-59	Male	인천광역시	37.428503	126.788686	대학원 졸	350-500만원	서비스직	자녀 양육 가구	18	보수 성향 무당층	63	{"economy": 13, "housing": 22, "welfare": -3, "security": -32, "environment": 12}	포털 뉴스	{공동체,혁신,자유}	인천광역시에 거주하는 50-59 서비스직. 정치 성향은 중도이며 공동체, 혁신, 자유 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 45, "ecoConsciousness": 62, "priceSensitivity": 66, "digitalConsumption": 68}	{"taxTolerance": 70, "governmentTrust": 41, "policyAcceptance": 45, "regulationPreference": 75, "publicServiceSatisfaction": 57}	0
3770	류서연	67	60-69	Female	인천광역시	37.422284	126.676872	고졸 이하	350-500만원	은퇴	자녀 양육 가구	13	중도 무당층	51	{"economy": 12, "housing": 10, "welfare": 7, "security": -12, "environment": -20}	유튜브	{안전,환경,자유}	인천광역시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 안전, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 50, "ecoConsciousness": 44, "priceSensitivity": 49, "digitalConsumption": 66}	{"taxTolerance": 39, "governmentTrust": 57, "policyAcceptance": 73, "regulationPreference": 72, "publicServiceSatisfaction": 65}	0
3771	박혜진	66	60-69	Female	인천광역시	37.38417	126.615724	고졸 이하	200-350만원	공무원	1인 가구	-12	중도 무당층	84	{"economy": -20, "housing": 33, "welfare": 24, "security": 15, "environment": 26}	신문/팟캐스트	{안전,자유,혁신}	인천광역시에 거주하는 60-69 공무원. 정치 성향은 중도이며 안전, 자유, 혁신 가치를 중시한다.	{"brandLoyalty": 65, "noveltySeeking": 62, "ecoConsciousness": 48, "priceSensitivity": 72, "digitalConsumption": 54}	{"taxTolerance": 62, "governmentTrust": 47, "policyAcceptance": 51, "regulationPreference": 64, "publicServiceSatisfaction": 76}	0
3772	한다은	63	60-69	Female	인천광역시	37.524522	126.709872	대학교 졸	200만원 미만	은퇴	자녀 양육 가구	-41	진보 성향 무당층	66	{"economy": -15, "housing": 49, "welfare": 9, "security": -24, "environment": 49}	SNS	{환경,공동체,다양성}	인천광역시에 거주하는 60-69 은퇴. 정치 성향은 진보이며 환경, 공동체, 다양성 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 37, "ecoConsciousness": 65, "priceSensitivity": 81, "digitalConsumption": 61}	{"taxTolerance": 56, "governmentTrust": 45, "policyAcceptance": 56, "regulationPreference": 61, "publicServiceSatisfaction": 61}	0
3773	송민준	60	60-69	Female	인천광역시	37.502939	126.637087	전문대 졸	350-500만원	자영업	1인 가구	-11	중도 무당층	62	{"economy": -8, "housing": 29, "welfare": 18, "security": -2, "environment": 13}	지상파/종편 뉴스	{다양성,공정,안정}	인천광역시에 거주하는 60-69 자영업. 정치 성향은 중도이며 다양성, 공정, 안정 가치를 중시한다.	{"brandLoyalty": 61, "noveltySeeking": 39, "ecoConsciousness": 36, "priceSensitivity": 52, "digitalConsumption": 66}	{"taxTolerance": 48, "governmentTrust": 49, "policyAcceptance": 33, "regulationPreference": 59, "publicServiceSatisfaction": 73}	0
3774	박유준	60	60-69	Male	인천광역시	37.484019	126.640946	대학원 졸	500-700만원	전문직	자녀 양육 가구	0	중도 무당층	77	{"economy": -15, "housing": 1, "welfare": 4, "security": 23, "environment": 25}	SNS	{다양성,환경,공동체}	인천광역시에 거주하는 60-69 전문직. 정치 성향은 중도이며 다양성, 환경, 공동체 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 57, "ecoConsciousness": 60, "priceSensitivity": 57, "digitalConsumption": 64}	{"taxTolerance": 43, "governmentTrust": 47, "policyAcceptance": 63, "regulationPreference": 71, "publicServiceSatisfaction": 63}	0
3775	서미경	68	60-69	Male	인천광역시	37.459379	126.630006	대학원 졸	350-500만원	은퇴	자녀 양육 가구	-4	중도 무당층	82	{"economy": -25, "housing": 26, "welfare": 22, "security": -4, "environment": 13}	지상파/종편 뉴스	{성장,환경,안정}	인천광역시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 성장, 환경, 안정 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 46, "ecoConsciousness": 57, "priceSensitivity": 70, "digitalConsumption": 57}	{"taxTolerance": 48, "governmentTrust": 36, "policyAcceptance": 49, "regulationPreference": 52, "publicServiceSatisfaction": 50}	0
3776	권지민	67	60-69	Male	인천광역시	37.394328	126.631693	전문대 졸	200-350만원	은퇴	부부 가구	-14	중도 무당층	72	{"economy": 4, "housing": 43, "welfare": 15, "security": 8, "environment": 25}	신문/팟캐스트	{다양성,성장,안전}	인천광역시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 다양성, 성장, 안전 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 49, "ecoConsciousness": 29, "priceSensitivity": 63, "digitalConsumption": 56}	{"taxTolerance": 43, "governmentTrust": 48, "policyAcceptance": 60, "regulationPreference": 62, "publicServiceSatisfaction": 84}	0
3777	최현우	64	60-69	Male	인천광역시	37.530927	126.69492	전문대 졸	200만원 미만	주부	자녀 양육 가구	3	중도 무당층	63	{"economy": 2, "housing": 6, "welfare": 23, "security": -19, "environment": 32}	SNS	{자유,안전,혁신}	인천광역시에 거주하는 60-69 주부. 정치 성향은 중도이며 자유, 안전, 혁신 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 70, "ecoConsciousness": 42, "priceSensitivity": 66, "digitalConsumption": 39}	{"taxTolerance": 38, "governmentTrust": 72, "policyAcceptance": 53, "regulationPreference": 58, "publicServiceSatisfaction": 71}	0
3778	류도윤	84	70+	Female	인천광역시	37.390101	126.633024	대학원 졸	200만원 미만	은퇴	다세대 가구	60	보수 정당 지지	82	{"economy": 17, "housing": 15, "welfare": -4, "security": 75, "environment": -1}	포털 뉴스	{안전,전통,안정}	인천광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안전, 전통, 안정 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 63, "ecoConsciousness": 68, "priceSensitivity": 59, "digitalConsumption": 72}	{"taxTolerance": 55, "governmentTrust": 66, "policyAcceptance": 45, "regulationPreference": 55, "publicServiceSatisfaction": 59}	0
3779	오민준	70	70+	Female	인천광역시	37.492366	126.788163	대학교 졸	200만원 미만	은퇴	다세대 가구	15	보수 성향 무당층	74	{"economy": 17, "housing": 7, "welfare": 17, "security": 26, "environment": 17}	SNS	{자유,전통,환경}	인천광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 자유, 전통, 환경 가치를 중시한다.	{"brandLoyalty": 69, "noveltySeeking": 51, "ecoConsciousness": 37, "priceSensitivity": 76, "digitalConsumption": 55}	{"taxTolerance": 44, "governmentTrust": 54, "policyAcceptance": 51, "regulationPreference": 61, "publicServiceSatisfaction": 73}	0
3780	전현우	71	70+	Female	인천광역시	37.470416	126.671513	대학교 졸	200만원 미만	은퇴	부부 가구	-12	중도 무당층	83	{"economy": 7, "housing": 38, "welfare": 9, "security": 13, "environment": 29}	지상파/종편 뉴스	{성장,안전,공정}	인천광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 성장, 안전, 공정 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 48, "ecoConsciousness": 49, "priceSensitivity": 59, "digitalConsumption": 58}	{"taxTolerance": 47, "governmentTrust": 72, "policyAcceptance": 59, "regulationPreference": 63, "publicServiceSatisfaction": 84}	0
3781	조지민	81	70+	Male	인천광역시	37.460308	126.802476	대학교 졸	200만원 미만	은퇴	다세대 가구	8	중도 무당층	82	{"economy": -9, "housing": 28, "welfare": -8, "security": 14, "environment": -10}	SNS	{다양성,혁신,안전}	인천광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 다양성, 혁신, 안전 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 41, "ecoConsciousness": 51, "priceSensitivity": 69, "digitalConsumption": 54}	{"taxTolerance": 52, "governmentTrust": 50, "policyAcceptance": 43, "regulationPreference": 56, "publicServiceSatisfaction": 84}	0
3782	한지민	80	70+	Male	인천광역시	37.397578	126.680314	대학원 졸	500-700만원	은퇴	부부 가구	16	보수 성향 무당층	86	{"economy": 12, "housing": 4, "welfare": 2, "security": 23, "environment": -1}	신문/팟캐스트	{환경,자유,성장}	인천광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 환경, 자유, 성장 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 24, "ecoConsciousness": 54, "priceSensitivity": 76, "digitalConsumption": 50}	{"taxTolerance": 55, "governmentTrust": 72, "policyAcceptance": 61, "regulationPreference": 77, "publicServiceSatisfaction": 61}	0
3783	서하은	82	70+	Male	인천광역시	37.482022	126.799513	대학교 졸	500-700만원	은퇴	부부 가구	50	보수 정당 지지	99	{"economy": 25, "housing": -5, "welfare": -20, "security": -14, "environment": 3}	유튜브	{다양성,혁신,자유}	인천광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 다양성, 혁신, 자유 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 42, "ecoConsciousness": 42, "priceSensitivity": 55, "digitalConsumption": 51}	{"taxTolerance": 45, "governmentTrust": 66, "policyAcceptance": 58, "regulationPreference": 66, "publicServiceSatisfaction": 51}	0
3784	황건우	19	18-29	Female	광주광역시	35.16501	126.855115	대학교 졸	500-700만원	사무직	1인 가구	-66	진보 정당 지지	42	{"economy": -66, "housing": 22, "welfare": 24, "security": -16, "environment": 83}	유튜브	{환경,자유,성장}	광주광역시에 거주하는 18-29 사무직. 정치 성향은 진보이며 환경, 자유, 성장 가치를 중시한다.	{"brandLoyalty": 26, "noveltySeeking": 69, "ecoConsciousness": 37, "priceSensitivity": 57, "digitalConsumption": 94}	{"taxTolerance": 48, "governmentTrust": 38, "policyAcceptance": 47, "regulationPreference": 42, "publicServiceSatisfaction": 73}	0
3785	권동현	26	18-29	Female	광주광역시	35.183628	126.858167	대학원 졸	200만원 미만	프리랜서	1인 가구	-38	진보 성향 무당층	50	{"economy": -56, "housing": 65, "welfare": 32, "security": -3, "environment": 20}	SNS	{공정,환경,성장}	광주광역시에 거주하는 18-29 프리랜서. 정치 성향은 진보이며 공정, 환경, 성장 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 79, "ecoConsciousness": 56, "priceSensitivity": 88, "digitalConsumption": 68}	{"taxTolerance": 83, "governmentTrust": 37, "policyAcceptance": 44, "regulationPreference": 70, "publicServiceSatisfaction": 82}	0
3786	임지민	25	18-29	Male	광주광역시	35.19292	126.946661	대학원 졸	350-500만원	프리랜서	자녀 양육 가구	-84	진보 정당 지지	58	{"economy": -66, "housing": 37, "welfare": 82, "security": -66, "environment": 72}	포털 뉴스	{성장,공정,자유}	광주광역시에 거주하는 18-29 프리랜서. 정치 성향은 진보이며 성장, 공정, 자유 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 78, "ecoConsciousness": 66, "priceSensitivity": 40, "digitalConsumption": 91}	{"taxTolerance": 65, "governmentTrust": 66, "policyAcceptance": 40, "regulationPreference": 72, "publicServiceSatisfaction": 49}	0
3787	서서연	26	18-29	Male	광주광역시	35.114938	126.825183	대학원 졸	350-500만원	자영업	자녀 양육 가구	-88	진보 정당 지지	55	{"economy": -35, "housing": 50, "welfare": 48, "security": -72, "environment": 40}	SNS	{공정,다양성,혁신}	광주광역시에 거주하는 18-29 자영업. 정치 성향은 진보이며 공정, 다양성, 혁신 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 66, "ecoConsciousness": 60, "priceSensitivity": 73, "digitalConsumption": 84}	{"taxTolerance": 57, "governmentTrust": 44, "policyAcceptance": 63, "regulationPreference": 72, "publicServiceSatisfaction": 67}	0
3788	신민준	30	30-39	Female	광주광역시	35.177859	126.78452	고졸 이하	350-500만원	주부	다세대 가구	-61	진보 정당 지지	46	{"economy": -36, "housing": 15, "welfare": 33, "security": -35, "environment": 58}	지상파/종편 뉴스	{다양성,공동체,공정}	광주광역시에 거주하는 30-39 주부. 정치 성향은 진보이며 다양성, 공동체, 공정 가치를 중시한다.	{"brandLoyalty": 24, "noveltySeeking": 65, "ecoConsciousness": 41, "priceSensitivity": 58, "digitalConsumption": 82}	{"taxTolerance": 41, "governmentTrust": 36, "policyAcceptance": 67, "regulationPreference": 68, "publicServiceSatisfaction": 84}	0
3789	이경숙	30	30-39	Female	광주광역시	35.181107	126.802199	대학원 졸	200-350만원	전문직	부부 가구	-73	진보 정당 지지	48	{"economy": -41, "housing": 32, "welfare": 37, "security": -30, "environment": 34}	지상파/종편 뉴스	{안전,성장,공정}	광주광역시에 거주하는 30-39 전문직. 정치 성향은 진보이며 안전, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 73, "ecoConsciousness": 49, "priceSensitivity": 77, "digitalConsumption": 65}	{"taxTolerance": 64, "governmentTrust": 49, "policyAcceptance": 60, "regulationPreference": 51, "publicServiceSatisfaction": 79}	0
3790	신예준	30	30-39	Male	광주광역시	35.153715	126.947112	대학원 졸	200-350만원	공무원	자녀 양육 가구	-67	진보 정당 지지	60	{"economy": -54, "housing": 56, "welfare": 49, "security": -16, "environment": 49}	지상파/종편 뉴스	{다양성,성장,안전}	광주광역시에 거주하는 30-39 공무원. 정치 성향은 진보이며 다양성, 성장, 안전 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 88, "ecoConsciousness": 53, "priceSensitivity": 66, "digitalConsumption": 82}	{"taxTolerance": 72, "governmentTrust": 36, "policyAcceptance": 75, "regulationPreference": 53, "publicServiceSatisfaction": 56}	0
3791	조미경	33	30-39	Male	광주광역시	35.169818	126.921255	대학원 졸	350-500만원	전문직	다세대 가구	-76	진보 정당 지지	57	{"economy": -41, "housing": 34, "welfare": 35, "security": -35, "environment": 36}	신문/팟캐스트	{안정,환경,안전}	광주광역시에 거주하는 30-39 전문직. 정치 성향은 진보이며 안정, 환경, 안전 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 57, "ecoConsciousness": 51, "priceSensitivity": 78, "digitalConsumption": 83}	{"taxTolerance": 52, "governmentTrust": 65, "policyAcceptance": 45, "regulationPreference": 55, "publicServiceSatisfaction": 60}	0
3792	전영수	48	40-49	Female	광주광역시	35.091476	126.928461	대학교 졸	500-700만원	은퇴	부부 가구	-22	진보 성향 무당층	67	{"economy": -15, "housing": 18, "welfare": 21, "security": -15, "environment": -5}	유튜브	{공동체,자유,성장}	광주광역시에 거주하는 40-49 은퇴. 정치 성향은 중도이며 공동체, 자유, 성장 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 58, "ecoConsciousness": 47, "priceSensitivity": 45, "digitalConsumption": 53}	{"taxTolerance": 56, "governmentTrust": 49, "policyAcceptance": 79, "regulationPreference": 73, "publicServiceSatisfaction": 74}	0
3793	안서윤	48	40-49	Female	광주광역시	35.089917	126.839348	고졸 이하	200-350만원	전문직	다세대 가구	-45	진보 정당 지지	50	{"economy": -52, "housing": 82, "welfare": 40, "security": -40, "environment": 28}	SNS	{공동체,성장,전통}	광주광역시에 거주하는 40-49 전문직. 정치 성향은 진보이며 공동체, 성장, 전통 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 65, "ecoConsciousness": 43, "priceSensitivity": 59, "digitalConsumption": 58}	{"taxTolerance": 64, "governmentTrust": 58, "policyAcceptance": 76, "regulationPreference": 57, "publicServiceSatisfaction": 65}	0
3794	임서윤	42	40-49	Male	광주광역시	35.199205	126.840511	대학원 졸	500-700만원	공무원	자녀 양육 가구	-24	진보 성향 무당층	44	{"economy": -33, "housing": 43, "welfare": 10, "security": 7, "environment": 9}	지상파/종편 뉴스	{자유,다양성,안전}	광주광역시에 거주하는 40-49 공무원. 정치 성향은 중도이며 자유, 다양성, 안전 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 57, "ecoConsciousness": 74, "priceSensitivity": 59, "digitalConsumption": 59}	{"taxTolerance": 40, "governmentTrust": 40, "policyAcceptance": 57, "regulationPreference": 59, "publicServiceSatisfaction": 81}	0
3795	황혜진	43	40-49	Male	광주광역시	35.134768	126.820637	대학원 졸	350-500만원	생산직	다세대 가구	-39	진보 성향 무당층	62	{"economy": -2, "housing": 24, "welfare": 38, "security": -9, "environment": 41}	포털 뉴스	{환경,공정,안전}	광주광역시에 거주하는 40-49 생산직. 정치 성향은 진보이며 환경, 공정, 안전 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 78, "ecoConsciousness": 44, "priceSensitivity": 70, "digitalConsumption": 59}	{"taxTolerance": 45, "governmentTrust": 23, "policyAcceptance": 38, "regulationPreference": 56, "publicServiceSatisfaction": 54}	0
3796	최다은	54	50-59	Female	광주광역시	35.198561	126.840385	대학원 졸	500-700만원	학생	자녀 양육 가구	-32	진보 성향 무당층	76	{"economy": -43, "housing": 4, "welfare": 24, "security": -31, "environment": 42}	SNS	{혁신,안전,공동체}	광주광역시에 거주하는 50-59 학생. 정치 성향은 중도이며 혁신, 안전, 공동체 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 39, "ecoConsciousness": 58, "priceSensitivity": 61, "digitalConsumption": 46}	{"taxTolerance": 52, "governmentTrust": 47, "policyAcceptance": 54, "regulationPreference": 83, "publicServiceSatisfaction": 76}	0
3797	강다은	52	50-59	Female	광주광역시	35.171751	126.806977	고졸 이하	350-500만원	전문직	1인 가구	-61	진보 정당 지지	63	{"economy": -52, "housing": 8, "welfare": 46, "security": -17, "environment": 17}	포털 뉴스	{안정,자유,공정}	광주광역시에 거주하는 50-59 전문직. 정치 성향은 진보이며 안정, 자유, 공정 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 53, "ecoConsciousness": 46, "priceSensitivity": 64, "digitalConsumption": 71}	{"taxTolerance": 37, "governmentTrust": 71, "policyAcceptance": 59, "regulationPreference": 73, "publicServiceSatisfaction": 74}	0
3798	안도윤	56	50-59	Male	광주광역시	35.201225	126.926645	대학원 졸	500-700만원	서비스직	1인 가구	7	중도 무당층	90	{"economy": -15, "housing": 6, "welfare": -9, "security": -8, "environment": 55}	포털 뉴스	{다양성,안전,환경}	광주광역시에 거주하는 50-59 서비스직. 정치 성향은 중도이며 다양성, 안전, 환경 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 48, "ecoConsciousness": 55, "priceSensitivity": 34, "digitalConsumption": 70}	{"taxTolerance": 66, "governmentTrust": 64, "policyAcceptance": 44, "regulationPreference": 76, "publicServiceSatisfaction": 72}	0
3799	박은우	56	50-59	Male	광주광역시	35.136556	126.918697	전문대 졸	350-500만원	사무직	1인 가구	-48	진보 정당 지지	77	{"economy": -38, "housing": 9, "welfare": 23, "security": -46, "environment": 37}	SNS	{자유,안정,안전}	광주광역시에 거주하는 50-59 사무직. 정치 성향은 진보이며 자유, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 61, "noveltySeeking": 48, "ecoConsciousness": 53, "priceSensitivity": 57, "digitalConsumption": 65}	{"taxTolerance": 28, "governmentTrust": 79, "policyAcceptance": 72, "regulationPreference": 59, "publicServiceSatisfaction": 66}	0
3800	류미경	62	60-69	Female	광주광역시	35.168762	126.88108	대학원 졸	350-500만원	전문직	부부 가구	-39	진보 성향 무당층	75	{"economy": -46, "housing": 33, "welfare": 38, "security": -40, "environment": 74}	신문/팟캐스트	{자유,안정,환경}	광주광역시에 거주하는 60-69 전문직. 정치 성향은 진보이며 자유, 안정, 환경 가치를 중시한다.	{"brandLoyalty": 85, "noveltySeeking": 64, "ecoConsciousness": 66, "priceSensitivity": 57, "digitalConsumption": 44}	{"taxTolerance": 63, "governmentTrust": 50, "policyAcceptance": 64, "regulationPreference": 68, "publicServiceSatisfaction": 55}	0
3801	윤정희	66	60-69	Female	광주광역시	35.162428	126.895553	대학원 졸	350-500만원	자영업	다세대 가구	-34	진보 성향 무당층	54	{"economy": -33, "housing": 62, "welfare": 19, "security": -3, "environment": 35}	지상파/종편 뉴스	{공동체,자유,혁신}	광주광역시에 거주하는 60-69 자영업. 정치 성향은 진보이며 공동체, 자유, 혁신 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 57, "ecoConsciousness": 38, "priceSensitivity": 56, "digitalConsumption": 45}	{"taxTolerance": 46, "governmentTrust": 60, "policyAcceptance": 63, "regulationPreference": 68, "publicServiceSatisfaction": 71}	0
3802	장지아	61	60-69	Male	광주광역시	35.087947	126.947486	대학교 졸	500-700만원	공무원	다세대 가구	-56	진보 정당 지지	66	{"economy": -56, "housing": 39, "welfare": 41, "security": -39, "environment": 40}	SNS	{전통,혁신,안전}	광주광역시에 거주하는 60-69 공무원. 정치 성향은 진보이며 전통, 혁신, 안전 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 52, "ecoConsciousness": 39, "priceSensitivity": 73, "digitalConsumption": 70}	{"taxTolerance": 67, "governmentTrust": 60, "policyAcceptance": 46, "regulationPreference": 53, "publicServiceSatisfaction": 72}	0
3803	최서윤	66	60-69	Male	광주광역시	35.191315	126.826085	전문대 졸	200-350만원	사무직	다세대 가구	-30	진보 성향 무당층	62	{"economy": -73, "housing": 36, "welfare": 20, "security": -3, "environment": 42}	포털 뉴스	{혁신,전통,성장}	광주광역시에 거주하는 60-69 사무직. 정치 성향은 중도이며 혁신, 전통, 성장 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 56, "ecoConsciousness": 45, "priceSensitivity": 52, "digitalConsumption": 54}	{"taxTolerance": 56, "governmentTrust": 34, "policyAcceptance": 55, "regulationPreference": 60, "publicServiceSatisfaction": 72}	0
3804	황지호	84	70+	Female	광주광역시	35.233542	126.868796	대학원 졸	200-350만원	은퇴	자녀 양육 가구	-20	진보 성향 무당층	87	{"economy": 9, "housing": 25, "welfare": 34, "security": 6, "environment": 25}	지상파/종편 뉴스	{자유,다양성,안정}	광주광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 자유, 다양성, 안정 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 50, "ecoConsciousness": 49, "priceSensitivity": 65, "digitalConsumption": 49}	{"taxTolerance": 62, "governmentTrust": 68, "policyAcceptance": 47, "regulationPreference": 73, "publicServiceSatisfaction": 90}	0
3805	장다은	81	70+	Female	광주광역시	35.168709	126.764062	대학교 졸	350-500만원	은퇴	1인 가구	-50	진보 정당 지지	94	{"economy": -19, "housing": 23, "welfare": 45, "security": -23, "environment": 48}	SNS	{다양성,성장,전통}	광주광역시에 거주하는 70+ 은퇴. 정치 성향은 진보이며 다양성, 성장, 전통 가치를 중시한다.	{"brandLoyalty": 75, "noveltySeeking": 49, "ecoConsciousness": 48, "priceSensitivity": 69, "digitalConsumption": 59}	{"taxTolerance": 67, "governmentTrust": 57, "policyAcceptance": 48, "regulationPreference": 85, "publicServiceSatisfaction": 77}	0
3806	김주원	75	70+	Male	광주광역시	35.158465	126.766764	대학교 졸	500-700만원	은퇴	1인 가구	3	중도 무당층	80	{"economy": -39, "housing": -4, "welfare": -2, "security": 30, "environment": 35}	포털 뉴스	{공정,공동체,다양성}	광주광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공정, 공동체, 다양성 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 40, "ecoConsciousness": 42, "priceSensitivity": 63, "digitalConsumption": 48}	{"taxTolerance": 51, "governmentTrust": 48, "policyAcceptance": 61, "regulationPreference": 70, "publicServiceSatisfaction": 71}	0
3807	홍다은	22	18-29	Female	대전광역시	36.393679	127.380665	대학교 졸	200-350만원	생산직	다세대 가구	-16	진보 성향 무당층	32	{"economy": -4, "housing": 23, "welfare": 48, "security": -24, "environment": 26}	포털 뉴스	{성장,환경,혁신}	대전광역시에 거주하는 18-29 생산직. 정치 성향은 중도이며 성장, 환경, 혁신 가치를 중시한다.	{"brandLoyalty": 22, "noveltySeeking": 60, "ecoConsciousness": 39, "priceSensitivity": 68, "digitalConsumption": 85}	{"taxTolerance": 68, "governmentTrust": 56, "policyAcceptance": 51, "regulationPreference": 71, "publicServiceSatisfaction": 77}	0
3808	홍하은	19	18-29	Female	대전광역시	36.346522	127.292776	대학원 졸	200-350만원	학생	자녀 양육 가구	-51	진보 정당 지지	48	{"economy": -25, "housing": 22, "welfare": 40, "security": -43, "environment": 49}	지상파/종편 뉴스	{전통,환경,다양성}	대전광역시에 거주하는 18-29 학생. 정치 성향은 진보이며 전통, 환경, 다양성 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 63, "ecoConsciousness": 43, "priceSensitivity": 54, "digitalConsumption": 72}	{"taxTolerance": 58, "governmentTrust": 42, "policyAcceptance": 34, "regulationPreference": 66, "publicServiceSatisfaction": 81}	0
3809	오수아	25	18-29	Male	대전광역시	36.407811	127.448007	대학교 졸	500-700만원	전문직	1인 가구	-29	진보 성향 무당층	37	{"economy": -44, "housing": 1, "welfare": 13, "security": 12, "environment": 16}	유튜브	{공동체,공정,혁신}	대전광역시에 거주하는 18-29 전문직. 정치 성향은 중도이며 공동체, 공정, 혁신 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 76, "ecoConsciousness": 48, "priceSensitivity": 55, "digitalConsumption": 78}	{"taxTolerance": 79, "governmentTrust": 49, "policyAcceptance": 39, "regulationPreference": 68, "publicServiceSatisfaction": 77}	0
3810	김영수	18	18-29	Male	대전광역시	36.271404	127.472877	대학원 졸	350-500만원	학생	다세대 가구	-42	진보 성향 무당층	50	{"economy": -45, "housing": 41, "welfare": 30, "security": -9, "environment": 60}	지상파/종편 뉴스	{성장,혁신,다양성}	대전광역시에 거주하는 18-29 학생. 정치 성향은 진보이며 성장, 혁신, 다양성 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 63, "ecoConsciousness": 59, "priceSensitivity": 65, "digitalConsumption": 83}	{"taxTolerance": 71, "governmentTrust": 43, "policyAcceptance": 49, "regulationPreference": 57, "publicServiceSatisfaction": 83}	0
3811	장채원	30	30-39	Female	대전광역시	36.299305	127.298066	대학교 졸	200-350만원	자영업	자녀 양육 가구	-66	진보 정당 지지	44	{"economy": -38, "housing": 61, "welfare": 51, "security": -33, "environment": 38}	유튜브	{혁신,공동체,전통}	대전광역시에 거주하는 30-39 자영업. 정치 성향은 진보이며 혁신, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 68, "ecoConsciousness": 54, "priceSensitivity": 81, "digitalConsumption": 85}	{"taxTolerance": 43, "governmentTrust": 43, "policyAcceptance": 44, "regulationPreference": 57, "publicServiceSatisfaction": 73}	0
3812	홍준서	36	30-39	Female	대전광역시	36.353777	127.292156	대학원 졸	200-350만원	공무원	부부 가구	-40	진보 성향 무당층	53	{"economy": -17, "housing": 36, "welfare": 45, "security": -18, "environment": 35}	지상파/종편 뉴스	{자유,공동체,성장}	대전광역시에 거주하는 30-39 공무원. 정치 성향은 진보이며 자유, 공동체, 성장 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 82, "ecoConsciousness": 50, "priceSensitivity": 60, "digitalConsumption": 72}	{"taxTolerance": 34, "governmentTrust": 47, "policyAcceptance": 53, "regulationPreference": 83, "publicServiceSatisfaction": 61}	0
3813	강경숙	38	30-39	Male	대전광역시	36.311085	127.453879	전문대 졸	700만원 이상	자영업	다세대 가구	-60	진보 정당 지지	62	{"economy": -38, "housing": 57, "welfare": 76, "security": -27, "environment": 42}	포털 뉴스	{공정,다양성,공동체}	대전광역시에 거주하는 30-39 자영업. 정치 성향은 진보이며 공정, 다양성, 공동체 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 62, "ecoConsciousness": 49, "priceSensitivity": 46, "digitalConsumption": 86}	{"taxTolerance": 49, "governmentTrust": 32, "policyAcceptance": 53, "regulationPreference": 74, "publicServiceSatisfaction": 69}	0
3814	윤다은	32	30-39	Male	대전광역시	36.312839	127.447158	전문대 졸	200만원 미만	주부	다세대 가구	-54	진보 정당 지지	61	{"economy": -42, "housing": 58, "welfare": 59, "security": -46, "environment": 57}	유튜브	{공동체,안전,전통}	대전광역시에 거주하는 30-39 주부. 정치 성향은 진보이며 공동체, 안전, 전통 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 67, "ecoConsciousness": 43, "priceSensitivity": 80, "digitalConsumption": 83}	{"taxTolerance": 34, "governmentTrust": 33, "policyAcceptance": 39, "regulationPreference": 71, "publicServiceSatisfaction": 63}	0
3815	이서연	48	40-49	Female	대전광역시	36.308786	127.353109	전문대 졸	350-500만원	프리랜서	자녀 양육 가구	9	중도 무당층	77	{"economy": 20, "housing": -17, "welfare": 54, "security": 27, "environment": 2}	신문/팟캐스트	{환경,공동체,전통}	대전광역시에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 환경, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 25, "noveltySeeking": 50, "ecoConsciousness": 50, "priceSensitivity": 58, "digitalConsumption": 48}	{"taxTolerance": 52, "governmentTrust": 53, "policyAcceptance": 68, "regulationPreference": 59, "publicServiceSatisfaction": 73}	0
3816	홍영수	48	40-49	Female	대전광역시	36.368436	127.366601	전문대 졸	200만원 미만	사무직	다세대 가구	-9	중도 무당층	55	{"economy": -33, "housing": 4, "welfare": 28, "security": -2, "environment": 17}	포털 뉴스	{공정,자유,혁신}	대전광역시에 거주하는 40-49 사무직. 정치 성향은 중도이며 공정, 자유, 혁신 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 59, "ecoConsciousness": 41, "priceSensitivity": 60, "digitalConsumption": 41}	{"taxTolerance": 53, "governmentTrust": 54, "policyAcceptance": 58, "regulationPreference": 77, "publicServiceSatisfaction": 75}	0
3817	이서연	41	40-49	Male	대전광역시	36.309412	127.321298	고졸 이하	200-350만원	사무직	1인 가구	-14	중도 무당층	58	{"economy": -18, "housing": 31, "welfare": 7, "security": -22, "environment": 36}	신문/팟캐스트	{안전,공정,혁신}	대전광역시에 거주하는 40-49 사무직. 정치 성향은 중도이며 안전, 공정, 혁신 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 78, "ecoConsciousness": 45, "priceSensitivity": 64, "digitalConsumption": 79}	{"taxTolerance": 43, "governmentTrust": 43, "policyAcceptance": 38, "regulationPreference": 81, "publicServiceSatisfaction": 74}	0
3818	정혜진	43	40-49	Male	대전광역시	36.424638	127.467479	전문대 졸	500-700만원	서비스직	다세대 가구	-44	진보 성향 무당층	65	{"economy": -18, "housing": 45, "welfare": 48, "security": -6, "environment": 39}	SNS	{성장,환경,공동체}	대전광역시에 거주하는 40-49 서비스직. 정치 성향은 진보이며 성장, 환경, 공동체 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 65, "ecoConsciousness": 48, "priceSensitivity": 58, "digitalConsumption": 56}	{"taxTolerance": 44, "governmentTrust": 37, "policyAcceptance": 38, "regulationPreference": 58, "publicServiceSatisfaction": 75}	0
3819	서지우	58	50-59	Female	대전광역시	36.275349	127.309868	전문대 졸	350-500만원	주부	1인 가구	5	중도 무당층	83	{"economy": 6, "housing": 24, "welfare": -7, "security": 30, "environment": 31}	지상파/종편 뉴스	{자유,안전,공동체}	대전광역시에 거주하는 50-59 주부. 정치 성향은 중도이며 자유, 안전, 공동체 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 60, "ecoConsciousness": 31, "priceSensitivity": 59, "digitalConsumption": 69}	{"taxTolerance": 37, "governmentTrust": 68, "policyAcceptance": 48, "regulationPreference": 35, "publicServiceSatisfaction": 69}	0
3820	류도윤	56	50-59	Female	대전광역시	36.400583	127.302075	대학교 졸	350-500만원	전문직	부부 가구	-5	중도 무당층	64	{"economy": -2, "housing": 24, "welfare": 15, "security": -5, "environment": 32}	포털 뉴스	{안정,공정,다양성}	대전광역시에 거주하는 50-59 전문직. 정치 성향은 중도이며 안정, 공정, 다양성 가치를 중시한다.	{"brandLoyalty": 60, "noveltySeeking": 52, "ecoConsciousness": 48, "priceSensitivity": 64, "digitalConsumption": 69}	{"taxTolerance": 56, "governmentTrust": 54, "policyAcceptance": 67, "regulationPreference": 75, "publicServiceSatisfaction": 73}	0
3821	박지호	50	50-59	Male	대전광역시	36.307504	127.291668	전문대 졸	200-350만원	전문직	다세대 가구	-69	진보 정당 지지	87	{"economy": 1, "housing": 32, "welfare": 39, "security": -56, "environment": 3}	유튜브	{공동체,다양성,안정}	대전광역시에 거주하는 50-59 전문직. 정치 성향은 진보이며 공동체, 다양성, 안정 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 58, "ecoConsciousness": 41, "priceSensitivity": 56, "digitalConsumption": 67}	{"taxTolerance": 15, "governmentTrust": 67, "policyAcceptance": 56, "regulationPreference": 44, "publicServiceSatisfaction": 60}	0
3822	홍지아	54	50-59	Male	대전광역시	36.319881	127.418368	대학원 졸	500-700만원	은퇴	1인 가구	2	중도 무당층	59	{"economy": -19, "housing": -3, "welfare": 30, "security": 50, "environment": 22}	유튜브	{혁신,자유,공정}	대전광역시에 거주하는 50-59 은퇴. 정치 성향은 중도이며 혁신, 자유, 공정 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 54, "ecoConsciousness": 62, "priceSensitivity": 61, "digitalConsumption": 74}	{"taxTolerance": 50, "governmentTrust": 56, "policyAcceptance": 64, "regulationPreference": 87, "publicServiceSatisfaction": 75}	0
3823	강서연	62	60-69	Female	대전광역시	36.330587	127.343332	전문대 졸	200-350만원	프리랜서	자녀 양육 가구	-6	중도 무당층	94	{"economy": -2, "housing": 23, "welfare": 12, "security": 3, "environment": 37}	신문/팟캐스트	{공정,성장,안정}	대전광역시에 거주하는 60-69 프리랜서. 정치 성향은 중도이며 공정, 성장, 안정 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 57, "ecoConsciousness": 53, "priceSensitivity": 71, "digitalConsumption": 59}	{"taxTolerance": 55, "governmentTrust": 62, "policyAcceptance": 69, "regulationPreference": 80, "publicServiceSatisfaction": 73}	0
3824	황성호	68	60-69	Female	대전광역시	36.293267	127.422839	전문대 졸	200-350만원	은퇴	자녀 양육 가구	28	보수 성향 무당층	64	{"economy": 6, "housing": 7, "welfare": 14, "security": 4, "environment": 12}	유튜브	{전통,공정,안전}	대전광역시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 전통, 공정, 안전 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 59, "ecoConsciousness": 35, "priceSensitivity": 67, "digitalConsumption": 67}	{"taxTolerance": 58, "governmentTrust": 44, "policyAcceptance": 51, "regulationPreference": 59, "publicServiceSatisfaction": 71}	0
3825	조은우	63	60-69	Male	대전광역시	36.307342	127.304013	대학교 졸	350-500만원	서비스직	1인 가구	36	보수 성향 무당층	96	{"economy": 32, "housing": 4, "welfare": 3, "security": 17, "environment": 13}	유튜브	{공동체,공정,혁신}	대전광역시에 거주하는 60-69 서비스직. 정치 성향은 보수이며 공동체, 공정, 혁신 가치를 중시한다.	{"brandLoyalty": 64, "noveltySeeking": 71, "ecoConsciousness": 44, "priceSensitivity": 63, "digitalConsumption": 61}	{"taxTolerance": 44, "governmentTrust": 49, "policyAcceptance": 55, "regulationPreference": 73, "publicServiceSatisfaction": 75}	0
3826	조미경	69	60-69	Male	대전광역시	36.302348	127.327063	전문대 졸	500-700만원	은퇴	다세대 가구	71	보수 정당 지지	75	{"economy": 18, "housing": -6, "welfare": -3, "security": 54, "environment": -52}	지상파/종편 뉴스	{공동체,환경,자유}	대전광역시에 거주하는 60-69 은퇴. 정치 성향은 보수이며 공동체, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 44, "ecoConsciousness": 47, "priceSensitivity": 79, "digitalConsumption": 49}	{"taxTolerance": 52, "governmentTrust": 61, "policyAcceptance": 48, "regulationPreference": 63, "publicServiceSatisfaction": 62}	0
3827	신영수	81	70+	Female	대전광역시	36.367051	127.427321	전문대 졸	350-500만원	은퇴	자녀 양육 가구	9	중도 무당층	95	{"economy": 10, "housing": 14, "welfare": 13, "security": 1, "environment": 28}	유튜브	{공동체,성장,안정}	대전광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공동체, 성장, 안정 가치를 중시한다.	{"brandLoyalty": 72, "noveltySeeking": 42, "ecoConsciousness": 36, "priceSensitivity": 56, "digitalConsumption": 47}	{"taxTolerance": 37, "governmentTrust": 51, "policyAcceptance": 78, "regulationPreference": 72, "publicServiceSatisfaction": 78}	0
3828	이지아	71	70+	Female	대전광역시	36.354993	127.400871	전문대 졸	200-350만원	은퇴	부부 가구	3	중도 무당층	88	{"economy": -12, "housing": 44, "welfare": -19, "security": -7, "environment": 11}	포털 뉴스	{환경,공동체,안정}	대전광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 환경, 공동체, 안정 가치를 중시한다.	{"brandLoyalty": 73, "noveltySeeking": 55, "ecoConsciousness": 46, "priceSensitivity": 64, "digitalConsumption": 50}	{"taxTolerance": 48, "governmentTrust": 31, "policyAcceptance": 58, "regulationPreference": 67, "publicServiceSatisfaction": 71}	0
3829	서예준	72	70+	Male	대전광역시	36.284202	127.306135	대학원 졸	200만원 미만	은퇴	1인 가구	37	보수 성향 무당층	94	{"economy": 35, "housing": 28, "welfare": -1, "security": 16, "environment": -2}	포털 뉴스	{안정,공정,다양성}	대전광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안정, 공정, 다양성 가치를 중시한다.	{"brandLoyalty": 61, "noveltySeeking": 48, "ecoConsciousness": 66, "priceSensitivity": 83, "digitalConsumption": 53}	{"taxTolerance": 35, "governmentTrust": 49, "policyAcceptance": 37, "regulationPreference": 58, "publicServiceSatisfaction": 56}	0
3830	이성호	83	70+	Male	대전광역시	36.412567	127.355351	대학교 졸	200만원 미만	은퇴	자녀 양육 가구	-16	진보 성향 무당층	93	{"economy": -9, "housing": 33, "welfare": 23, "security": -10, "environment": 3}	포털 뉴스	{안정,안전,환경}	대전광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안정, 안전, 환경 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 33, "ecoConsciousness": 59, "priceSensitivity": 76, "digitalConsumption": 38}	{"taxTolerance": 62, "governmentTrust": 45, "policyAcceptance": 47, "regulationPreference": 69, "publicServiceSatisfaction": 72}	0
3831	송하은	19	18-29	Female	울산광역시	35.541812	129.362729	대학원 졸	350-500만원	학생	다세대 가구	-25	진보 성향 무당층	69	{"economy": -23, "housing": 13, "welfare": 32, "security": -29, "environment": -4}	SNS	{혁신,안정,자유}	울산광역시에 거주하는 18-29 학생. 정치 성향은 중도이며 혁신, 안정, 자유 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 88, "ecoConsciousness": 69, "priceSensitivity": 57, "digitalConsumption": 77}	{"taxTolerance": 75, "governmentTrust": 41, "policyAcceptance": 38, "regulationPreference": 67, "publicServiceSatisfaction": 72}	0
3832	강지우	23	18-29	Male	울산광역시	35.59201	129.40255	대학교 졸	500-700만원	자영업	부부 가구	-26	진보 성향 무당층	61	{"economy": -23, "housing": 46, "welfare": 18, "security": -1, "environment": 38}	포털 뉴스	{자유,환경,혁신}	울산광역시에 거주하는 18-29 자영업. 정치 성향은 중도이며 자유, 환경, 혁신 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 88, "ecoConsciousness": 59, "priceSensitivity": 48, "digitalConsumption": 78}	{"taxTolerance": 43, "governmentTrust": 41, "policyAcceptance": 18, "regulationPreference": 61, "publicServiceSatisfaction": 72}	0
3833	이지호	30	30-39	Female	울산광역시	35.591659	129.279452	대학원 졸	500-700만원	은퇴	다세대 가구	2	중도 무당층	47	{"economy": 0, "housing": 0, "welfare": 20, "security": 0, "environment": 35}	포털 뉴스	{안전,전통,안정}	울산광역시에 거주하는 30-39 은퇴. 정치 성향은 중도이며 안전, 전통, 안정 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 59, "ecoConsciousness": 58, "priceSensitivity": 57, "digitalConsumption": 68}	{"taxTolerance": 37, "governmentTrust": 46, "policyAcceptance": 55, "regulationPreference": 63, "publicServiceSatisfaction": 77}	0
3834	홍광수	34	30-39	Male	울산광역시	35.605396	129.305699	전문대 졸	350-500만원	생산직	1인 가구	10	중도 무당층	52	{"economy": -3, "housing": -4, "welfare": 32, "security": -9, "environment": -5}	포털 뉴스	{안전,공정,다양성}	울산광역시에 거주하는 30-39 생산직. 정치 성향은 중도이며 안전, 공정, 다양성 가치를 중시한다.	{"brandLoyalty": 26, "noveltySeeking": 77, "ecoConsciousness": 49, "priceSensitivity": 53, "digitalConsumption": 73}	{"taxTolerance": 49, "governmentTrust": 57, "policyAcceptance": 42, "regulationPreference": 62, "publicServiceSatisfaction": 82}	0
3835	조서윤	47	40-49	Female	울산광역시	35.480167	129.357596	전문대 졸	350-500만원	서비스직	다세대 가구	-19	진보 성향 무당층	84	{"economy": -22, "housing": 31, "welfare": 44, "security": 2, "environment": 29}	포털 뉴스	{혁신,공동체,성장}	울산광역시에 거주하는 40-49 서비스직. 정치 성향은 중도이며 혁신, 공동체, 성장 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 62, "ecoConsciousness": 31, "priceSensitivity": 53, "digitalConsumption": 68}	{"taxTolerance": 53, "governmentTrust": 52, "policyAcceptance": 60, "regulationPreference": 59, "publicServiceSatisfaction": 74}	0
3836	한민준	43	40-49	Female	울산광역시	35.559713	129.366082	고졸 이하	350-500만원	전문직	1인 가구	-6	중도 무당층	94	{"economy": -13, "housing": -19, "welfare": 19, "security": 14, "environment": 11}	유튜브	{전통,혁신,안정}	울산광역시에 거주하는 40-49 전문직. 정치 성향은 중도이며 전통, 혁신, 안정 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 46, "ecoConsciousness": 35, "priceSensitivity": 71, "digitalConsumption": 73}	{"taxTolerance": 35, "governmentTrust": 49, "policyAcceptance": 62, "regulationPreference": 64, "publicServiceSatisfaction": 95}	0
3837	오준서	44	40-49	Male	울산광역시	35.536886	129.273587	대학원 졸	200-350만원	서비스직	다세대 가구	-33	진보 성향 무당층	71	{"economy": -40, "housing": 33, "welfare": 22, "security": -33, "environment": 45}	유튜브	{다양성,공동체,공정}	울산광역시에 거주하는 40-49 서비스직. 정치 성향은 중도이며 다양성, 공동체, 공정 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 56, "ecoConsciousness": 62, "priceSensitivity": 66, "digitalConsumption": 69}	{"taxTolerance": 55, "governmentTrust": 44, "policyAcceptance": 43, "regulationPreference": 70, "publicServiceSatisfaction": 56}	0
3838	황준서	42	40-49	Male	울산광역시	35.594899	129.339205	대학원 졸	500-700만원	은퇴	자녀 양육 가구	22	보수 성향 무당층	48	{"economy": 13, "housing": 1, "welfare": 8, "security": 18, "environment": 35}	유튜브	{다양성,공동체,환경}	울산광역시에 거주하는 40-49 은퇴. 정치 성향은 중도이며 다양성, 공동체, 환경 가치를 중시한다.	{"brandLoyalty": 17, "noveltySeeking": 63, "ecoConsciousness": 69, "priceSensitivity": 40, "digitalConsumption": 74}	{"taxTolerance": 48, "governmentTrust": 53, "policyAcceptance": 36, "regulationPreference": 68, "publicServiceSatisfaction": 69}	0
3839	안서윤	53	50-59	Female	울산광역시	35.5151	129.222709	대학원 졸	700만원 이상	주부	1인 가구	28	보수 성향 무당층	80	{"economy": -7, "housing": 13, "welfare": -13, "security": 10, "environment": 21}	포털 뉴스	{자유,안정,성장}	울산광역시에 거주하는 50-59 주부. 정치 성향은 중도이며 자유, 안정, 성장 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 50, "ecoConsciousness": 63, "priceSensitivity": 53, "digitalConsumption": 94}	{"taxTolerance": 55, "governmentTrust": 41, "policyAcceptance": 58, "regulationPreference": 85, "publicServiceSatisfaction": 61}	0
3840	임경숙	53	50-59	Female	울산광역시	35.614188	129.295549	대학원 졸	350-500만원	공무원	다세대 가구	26	보수 성향 무당층	77	{"economy": 39, "housing": 3, "welfare": 17, "security": 35, "environment": 31}	신문/팟캐스트	{안정,혁신,자유}	울산광역시에 거주하는 50-59 공무원. 정치 성향은 중도이며 안정, 혁신, 자유 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 66, "ecoConsciousness": 51, "priceSensitivity": 69, "digitalConsumption": 69}	{"taxTolerance": 60, "governmentTrust": 60, "policyAcceptance": 53, "regulationPreference": 77, "publicServiceSatisfaction": 60}	0
3841	윤철수	58	50-59	Male	울산광역시	35.520754	129.38066	전문대 졸	700만원 이상	생산직	다세대 가구	25	보수 성향 무당층	99	{"economy": 4, "housing": 5, "welfare": -14, "security": 37, "environment": 8}	신문/팟캐스트	{환경,안정,성장}	울산광역시에 거주하는 50-59 생산직. 정치 성향은 중도이며 환경, 안정, 성장 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 51, "ecoConsciousness": 42, "priceSensitivity": 44, "digitalConsumption": 68}	{"taxTolerance": 43, "governmentTrust": 40, "policyAcceptance": 54, "regulationPreference": 87, "publicServiceSatisfaction": 55}	0
3842	장민준	56	50-59	Male	울산광역시	35.612884	129.213275	전문대 졸	500-700만원	프리랜서	다세대 가구	3	중도 무당층	71	{"economy": 27, "housing": -14, "welfare": 24, "security": 14, "environment": 30}	유튜브	{혁신,환경,공정}	울산광역시에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 혁신, 환경, 공정 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 45, "ecoConsciousness": 66, "priceSensitivity": 46, "digitalConsumption": 70}	{"taxTolerance": 38, "governmentTrust": 32, "policyAcceptance": 50, "regulationPreference": 74, "publicServiceSatisfaction": 62}	0
3843	박영수	68	60-69	Female	울산광역시	35.584901	129.392211	대학교 졸	350-500만원	은퇴	1인 가구	-6	중도 무당층	68	{"economy": 30, "housing": 32, "welfare": 18, "security": 8, "environment": 13}	포털 뉴스	{공정,자유,환경}	울산광역시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 공정, 자유, 환경 가치를 중시한다.	{"brandLoyalty": 65, "noveltySeeking": 69, "ecoConsciousness": 62, "priceSensitivity": 64, "digitalConsumption": 54}	{"taxTolerance": 61, "governmentTrust": 41, "policyAcceptance": 57, "regulationPreference": 86, "publicServiceSatisfaction": 61}	0
3844	임하은	62	60-69	Male	울산광역시	35.571955	129.21175	고졸 이하	200-350만원	프리랜서	다세대 가구	40	보수 성향 무당층	64	{"economy": 12, "housing": 17, "welfare": -8, "security": 32, "environment": -22}	포털 뉴스	{공동체,전통,혁신}	울산광역시에 거주하는 60-69 프리랜서. 정치 성향은 보수이며 공동체, 전통, 혁신 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 40, "ecoConsciousness": 65, "priceSensitivity": 86, "digitalConsumption": 77}	{"taxTolerance": 42, "governmentTrust": 55, "policyAcceptance": 44, "regulationPreference": 69, "publicServiceSatisfaction": 60}	0
3845	윤건우	71	70+	Female	울산광역시	35.563646	129.290883	대학교 졸	500-700만원	은퇴	1인 가구	47	보수 정당 지지	68	{"economy": 32, "housing": 7, "welfare": -25, "security": 58, "environment": 21}	유튜브	{전통,공정,성장}	울산광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 전통, 공정, 성장 가치를 중시한다.	{"brandLoyalty": 71, "noveltySeeking": 52, "ecoConsciousness": 54, "priceSensitivity": 48, "digitalConsumption": 63}	{"taxTolerance": 65, "governmentTrust": 50, "policyAcceptance": 71, "regulationPreference": 59, "publicServiceSatisfaction": 50}	0
3846	황민준	76	70+	Male	울산광역시	35.556067	129.24647	대학교 졸	350-500만원	은퇴	부부 가구	37	보수 성향 무당층	91	{"economy": 24, "housing": 7, "welfare": -3, "security": 14, "environment": 8}	유튜브	{성장,공정,다양성}	울산광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 성장, 공정, 다양성 가치를 중시한다.	{"brandLoyalty": 87, "noveltySeeking": 56, "ecoConsciousness": 48, "priceSensitivity": 58, "digitalConsumption": 51}	{"taxTolerance": 52, "governmentTrust": 68, "policyAcceptance": 64, "regulationPreference": 72, "publicServiceSatisfaction": 59}	0
3847	송다은	49	40-49	Female	세종특별자치시	36.541672	127.226384	대학원 졸	200만원 미만	프리랜서	부부 가구	-16	진보 성향 무당층	31	{"economy": -30, "housing": 0, "welfare": 38, "security": -31, "environment": 57}	포털 뉴스	{혁신,전통,안전}	세종특별자치시에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 혁신, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 43, "ecoConsciousness": 51, "priceSensitivity": 75, "digitalConsumption": 65}	{"taxTolerance": 48, "governmentTrust": 58, "policyAcceptance": 69, "regulationPreference": 69, "publicServiceSatisfaction": 76}	0
3848	강준서	49	40-49	Male	세종특별자치시	36.493128	127.257037	전문대 졸	350-500만원	공무원	부부 가구	1	중도 무당층	65	{"economy": 14, "housing": -4, "welfare": 7, "security": 9, "environment": 1}	유튜브	{혁신,자유,다양성}	세종특별자치시에 거주하는 40-49 공무원. 정치 성향은 중도이며 혁신, 자유, 다양성 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 66, "ecoConsciousness": 43, "priceSensitivity": 64, "digitalConsumption": 70}	{"taxTolerance": 51, "governmentTrust": 39, "policyAcceptance": 51, "regulationPreference": 70, "publicServiceSatisfaction": 56}	0
3849	오예준	57	50-59	Female	세종특별자치시	36.487117	127.3018	전문대 졸	700만원 이상	학생	다세대 가구	-50	진보 정당 지지	73	{"economy": -42, "housing": 28, "welfare": 33, "security": -31, "environment": 76}	포털 뉴스	{공정,전통,환경}	세종특별자치시에 거주하는 50-59 학생. 정치 성향은 진보이며 공정, 전통, 환경 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 55, "ecoConsciousness": 40, "priceSensitivity": 56, "digitalConsumption": 59}	{"taxTolerance": 49, "governmentTrust": 51, "policyAcceptance": 42, "regulationPreference": 73, "publicServiceSatisfaction": 69}	0
3850	이건우	58	50-59	Male	세종특별자치시	36.453126	127.329895	대학교 졸	350-500만원	주부	1인 가구	8	중도 무당층	76	{"economy": -20, "housing": 27, "welfare": -16, "security": 6, "environment": 40}	신문/팟캐스트	{자유,혁신,안정}	세종특별자치시에 거주하는 50-59 주부. 정치 성향은 중도이며 자유, 혁신, 안정 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 56, "ecoConsciousness": 55, "priceSensitivity": 49, "digitalConsumption": 56}	{"taxTolerance": 44, "governmentTrust": 54, "policyAcceptance": 64, "regulationPreference": 51, "publicServiceSatisfaction": 65}	0
3851	강철수	27	18-29	Female	경기도	37.427802	127.58846	전문대 졸	200-350만원	프리랜서	자녀 양육 가구	-44	진보 성향 무당층	51	{"economy": -25, "housing": 8, "welfare": 37, "security": -29, "environment": 27}	유튜브	{안전,공정,공동체}	경기도에 거주하는 18-29 프리랜서. 정치 성향은 진보이며 안전, 공정, 공동체 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 73, "ecoConsciousness": 64, "priceSensitivity": 71, "digitalConsumption": 83}	{"taxTolerance": 43, "governmentTrust": 23, "policyAcceptance": 42, "regulationPreference": 82, "publicServiceSatisfaction": 70}	0
3852	홍영수	21	18-29	Female	경기도	37.42925	127.472588	대학교 졸	350-500만원	학생	다세대 가구	-22	진보 성향 무당층	39	{"economy": -28, "housing": 18, "welfare": 26, "security": 4, "environment": 50}	지상파/종편 뉴스	{성장,안전,다양성}	경기도에 거주하는 18-29 학생. 정치 성향은 중도이며 성장, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 82, "ecoConsciousness": 42, "priceSensitivity": 54, "digitalConsumption": 94}	{"taxTolerance": 33, "governmentTrust": 60, "policyAcceptance": 42, "regulationPreference": 71, "publicServiceSatisfaction": 74}	0
3853	황민서	27	18-29	Female	경기도	37.492912	127.585074	대학원 졸	200만원 미만	사무직	자녀 양육 가구	-49	진보 정당 지지	44	{"economy": -16, "housing": 25, "welfare": 46, "security": -26, "environment": 33}	SNS	{자유,환경,혁신}	경기도에 거주하는 18-29 사무직. 정치 성향은 진보이며 자유, 환경, 혁신 가치를 중시한다.	{"brandLoyalty": 19, "noveltySeeking": 63, "ecoConsciousness": 64, "priceSensitivity": 70, "digitalConsumption": 91}	{"taxTolerance": 62, "governmentTrust": 29, "policyAcceptance": 37, "regulationPreference": 95, "publicServiceSatisfaction": 51}	0
3854	정서연	21	18-29	Female	경기도	37.45193	127.548034	대학원 졸	200-350만원	학생	자녀 양육 가구	-60	진보 정당 지지	46	{"economy": -52, "housing": 35, "welfare": 52, "security": -38, "environment": 20}	신문/팟캐스트	{공동체,자유,안전}	경기도에 거주하는 18-29 학생. 정치 성향은 진보이며 공동체, 자유, 안전 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 90, "ecoConsciousness": 70, "priceSensitivity": 66, "digitalConsumption": 76}	{"taxTolerance": 54, "governmentTrust": 30, "policyAcceptance": 46, "regulationPreference": 67, "publicServiceSatisfaction": 64}	0
3855	권지민	27	18-29	Female	경기도	37.483321	127.502393	대학교 졸	350-500만원	자영업	자녀 양육 가구	-66	진보 정당 지지	83	{"economy": -94, "housing": 69, "welfare": 44, "security": -46, "environment": 25}	유튜브	{자유,다양성,혁신}	경기도에 거주하는 18-29 자영업. 정치 성향은 진보이며 자유, 다양성, 혁신 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 68, "ecoConsciousness": 57, "priceSensitivity": 51, "digitalConsumption": 77}	{"taxTolerance": 52, "governmentTrust": 42, "policyAcceptance": 57, "regulationPreference": 67, "publicServiceSatisfaction": 82}	0
3856	전지우	23	18-29	Female	경기도	37.424792	127.501754	대학교 졸	500-700만원	주부	다세대 가구	-18	진보 성향 무당층	63	{"economy": -30, "housing": 15, "welfare": 14, "security": -17, "environment": 20}	포털 뉴스	{안정,전통,자유}	경기도에 거주하는 18-29 주부. 정치 성향은 중도이며 안정, 전통, 자유 가치를 중시한다.	{"brandLoyalty": 15, "noveltySeeking": 66, "ecoConsciousness": 54, "priceSensitivity": 48, "digitalConsumption": 82}	{"taxTolerance": 39, "governmentTrust": 57, "policyAcceptance": 57, "regulationPreference": 48, "publicServiceSatisfaction": 45}	0
3857	이광수	22	18-29	Female	경기도	37.432044	127.599581	전문대 졸	200-350만원	학생	부부 가구	-71	진보 정당 지지	48	{"economy": -30, "housing": 40, "welfare": 60, "security": 7, "environment": 62}	신문/팟캐스트	{공동체,전통,혁신}	경기도에 거주하는 18-29 학생. 정치 성향은 진보이며 공동체, 전통, 혁신 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 95, "ecoConsciousness": 78, "priceSensitivity": 80, "digitalConsumption": 73}	{"taxTolerance": 73, "governmentTrust": 36, "policyAcceptance": 38, "regulationPreference": 61, "publicServiceSatisfaction": 67}	0
3858	윤채원	29	18-29	Female	경기도	37.466349	127.48208	전문대 졸	200-350만원	주부	부부 가구	-16	진보 성향 무당층	74	{"economy": -14, "housing": -16, "welfare": 34, "security": 2, "environment": 40}	지상파/종편 뉴스	{성장,전통,자유}	경기도에 거주하는 18-29 주부. 정치 성향은 중도이며 성장, 전통, 자유 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 66, "ecoConsciousness": 51, "priceSensitivity": 80, "digitalConsumption": 81}	{"taxTolerance": 49, "governmentTrust": 38, "policyAcceptance": 40, "regulationPreference": 53, "publicServiceSatisfaction": 64}	0
3859	전주원	27	18-29	Female	경기도	37.470066	127.450966	대학원 졸	200만원 미만	서비스직	1인 가구	-60	진보 정당 지지	41	{"economy": -19, "housing": 46, "welfare": 50, "security": -18, "environment": 42}	SNS	{자유,공정,안정}	경기도에 거주하는 18-29 서비스직. 정치 성향은 진보이며 자유, 공정, 안정 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 64, "ecoConsciousness": 55, "priceSensitivity": 75, "digitalConsumption": 99}	{"taxTolerance": 42, "governmentTrust": 41, "policyAcceptance": 58, "regulationPreference": 59, "publicServiceSatisfaction": 69}	0
3860	박민서	21	18-29	Female	경기도	37.417494	127.597439	전문대 졸	500-700만원	학생	부부 가구	-79	진보 정당 지지	41	{"economy": -41, "housing": 61, "welfare": 40, "security": -21, "environment": 63}	지상파/종편 뉴스	{다양성,안전,자유}	경기도에 거주하는 18-29 학생. 정치 성향은 진보이며 다양성, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 70, "ecoConsciousness": 63, "priceSensitivity": 42, "digitalConsumption": 100}	{"taxTolerance": 38, "governmentTrust": 35, "policyAcceptance": 53, "regulationPreference": 68, "publicServiceSatisfaction": 70}	0
3861	박주원	24	18-29	Female	경기도	37.336094	127.559105	대학원 졸	350-500만원	학생	자녀 양육 가구	-68	진보 정당 지지	24	{"economy": -57, "housing": 53, "welfare": 40, "security": -29, "environment": 68}	SNS	{안전,공정,전통}	경기도에 거주하는 18-29 학생. 정치 성향은 진보이며 안전, 공정, 전통 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 87, "ecoConsciousness": 62, "priceSensitivity": 65, "digitalConsumption": 76}	{"taxTolerance": 36, "governmentTrust": 35, "policyAcceptance": 43, "regulationPreference": 68, "publicServiceSatisfaction": 73}	0
3862	안서연	24	18-29	Female	경기도	37.379952	127.560759	대학원 졸	350-500만원	학생	부부 가구	-3	중도 무당층	40	{"economy": -29, "housing": 30, "welfare": 26, "security": -14, "environment": 1}	SNS	{성장,공동체,혁신}	경기도에 거주하는 18-29 학생. 정치 성향은 중도이며 성장, 공동체, 혁신 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 74, "ecoConsciousness": 50, "priceSensitivity": 63, "digitalConsumption": 78}	{"taxTolerance": 57, "governmentTrust": 52, "policyAcceptance": 51, "regulationPreference": 62, "publicServiceSatisfaction": 77}	0
3863	임예준	27	18-29	Female	경기도	37.4609	127.54203	대학원 졸	500-700만원	사무직	부부 가구	21	보수 성향 무당층	44	{"economy": -4, "housing": 12, "welfare": 14, "security": 25, "environment": 20}	포털 뉴스	{공동체,전통,혁신}	경기도에 거주하는 18-29 사무직. 정치 성향은 중도이며 공동체, 전통, 혁신 가치를 중시한다.	{"brandLoyalty": 25, "noveltySeeking": 71, "ecoConsciousness": 30, "priceSensitivity": 61, "digitalConsumption": 65}	{"taxTolerance": 69, "governmentTrust": 66, "policyAcceptance": 47, "regulationPreference": 61, "publicServiceSatisfaction": 69}	0
3864	한지호	29	18-29	Female	경기도	37.355723	127.544354	대학교 졸	200-350만원	프리랜서	부부 가구	-58	진보 정당 지지	66	{"economy": -54, "housing": 11, "welfare": 53, "security": -33, "environment": 28}	신문/팟캐스트	{환경,성장,자유}	경기도에 거주하는 18-29 프리랜서. 정치 성향은 진보이며 환경, 성장, 자유 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 72, "ecoConsciousness": 41, "priceSensitivity": 79, "digitalConsumption": 94}	{"taxTolerance": 56, "governmentTrust": 46, "policyAcceptance": 33, "regulationPreference": 35, "publicServiceSatisfaction": 77}	0
3865	전채원	29	18-29	Female	경기도	37.459196	127.537079	대학교 졸	200만원 미만	전문직	다세대 가구	-3	중도 무당층	53	{"economy": 1, "housing": 22, "welfare": 9, "security": 33, "environment": 26}	유튜브	{전통,다양성,공정}	경기도에 거주하는 18-29 전문직. 정치 성향은 중도이며 전통, 다양성, 공정 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 72, "ecoConsciousness": 73, "priceSensitivity": 84, "digitalConsumption": 91}	{"taxTolerance": 34, "governmentTrust": 36, "policyAcceptance": 51, "regulationPreference": 57, "publicServiceSatisfaction": 70}	0
3866	신수아	25	18-29	Female	경기도	37.438509	127.614768	고졸 이하	200-350만원	프리랜서	자녀 양육 가구	-43	진보 성향 무당층	65	{"economy": -26, "housing": 26, "welfare": 47, "security": -9, "environment": 55}	지상파/종편 뉴스	{안정,다양성,공정}	경기도에 거주하는 18-29 프리랜서. 정치 성향은 진보이며 안정, 다양성, 공정 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 79, "ecoConsciousness": 37, "priceSensitivity": 71, "digitalConsumption": 74}	{"taxTolerance": 44, "governmentTrust": 55, "policyAcceptance": 33, "regulationPreference": 62, "publicServiceSatisfaction": 75}	0
3867	송유준	19	18-29	Female	경기도	37.385772	127.435695	대학교 졸	350-500만원	전문직	자녀 양육 가구	-50	진보 정당 지지	37	{"economy": -56, "housing": 32, "welfare": 36, "security": -23, "environment": 26}	지상파/종편 뉴스	{환경,혁신,공동체}	경기도에 거주하는 18-29 전문직. 정치 성향은 진보이며 환경, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 71, "ecoConsciousness": 75, "priceSensitivity": 62, "digitalConsumption": 88}	{"taxTolerance": 56, "governmentTrust": 35, "policyAcceptance": 31, "regulationPreference": 75, "publicServiceSatisfaction": 66}	0
3868	윤순자	28	18-29	Male	경기도	37.386659	127.428154	대학원 졸	200만원 미만	학생	다세대 가구	-36	진보 성향 무당층	43	{"economy": -25, "housing": 9, "welfare": 38, "security": -1, "environment": 47}	유튜브	{자유,성장,공정}	경기도에 거주하는 18-29 학생. 정치 성향은 진보이며 자유, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 18, "noveltySeeking": 62, "ecoConsciousness": 61, "priceSensitivity": 90, "digitalConsumption": 78}	{"taxTolerance": 45, "governmentTrust": 37, "policyAcceptance": 47, "regulationPreference": 51, "publicServiceSatisfaction": 75}	0
3869	송광수	20	18-29	Male	경기도	37.469329	127.580253	대학교 졸	350-500만원	생산직	다세대 가구	-19	진보 성향 무당층	43	{"economy": -16, "housing": 35, "welfare": 32, "security": -16, "environment": 33}	신문/팟캐스트	{성장,다양성,공정}	경기도에 거주하는 18-29 생산직. 정치 성향은 중도이며 성장, 다양성, 공정 가치를 중시한다.	{"brandLoyalty": 25, "noveltySeeking": 79, "ecoConsciousness": 59, "priceSensitivity": 47, "digitalConsumption": 84}	{"taxTolerance": 64, "governmentTrust": 72, "policyAcceptance": 44, "regulationPreference": 69, "publicServiceSatisfaction": 94}	0
3870	이은우	22	18-29	Male	경기도	37.355839	127.429452	대학원 졸	700만원 이상	전문직	다세대 가구	-100	진보 정당 지지	36	{"economy": -71, "housing": 46, "welfare": 60, "security": -64, "environment": 58}	신문/팟캐스트	{공동체,공정,환경}	경기도에 거주하는 18-29 전문직. 정치 성향은 진보이며 공동체, 공정, 환경 가치를 중시한다.	{"brandLoyalty": 20, "noveltySeeking": 66, "ecoConsciousness": 59, "priceSensitivity": 48, "digitalConsumption": 76}	{"taxTolerance": 53, "governmentTrust": 44, "policyAcceptance": 41, "regulationPreference": 63, "publicServiceSatisfaction": 65}	0
3871	안준서	19	18-29	Male	경기도	37.392104	127.42797	대학원 졸	700만원 이상	학생	다세대 가구	-31	진보 성향 무당층	34	{"economy": -34, "housing": 44, "welfare": 52, "security": -13, "environment": 28}	SNS	{전통,성장,다양성}	경기도에 거주하는 18-29 학생. 정치 성향은 중도이며 전통, 성장, 다양성 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 68, "ecoConsciousness": 40, "priceSensitivity": 50, "digitalConsumption": 83}	{"taxTolerance": 50, "governmentTrust": 37, "policyAcceptance": 46, "regulationPreference": 66, "publicServiceSatisfaction": 72}	0
3872	조동현	22	18-29	Male	경기도	37.401333	127.584123	대학교 졸	500-700만원	주부	다세대 가구	12	중도 무당층	44	{"economy": -20, "housing": 1, "welfare": 15, "security": 42, "environment": 5}	포털 뉴스	{혁신,안전,환경}	경기도에 거주하는 18-29 주부. 정치 성향은 중도이며 혁신, 안전, 환경 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 77, "ecoConsciousness": 57, "priceSensitivity": 47, "digitalConsumption": 95}	{"taxTolerance": 81, "governmentTrust": 52, "policyAcceptance": 86, "regulationPreference": 68, "publicServiceSatisfaction": 78}	0
3873	전하은	28	18-29	Male	경기도	37.430759	127.420815	대학교 졸	200만원 미만	전문직	1인 가구	-52	진보 정당 지지	50	{"economy": -50, "housing": 25, "welfare": 38, "security": -32, "environment": 50}	지상파/종편 뉴스	{공정,환경,안정}	경기도에 거주하는 18-29 전문직. 정치 성향은 진보이며 공정, 환경, 안정 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 70, "ecoConsciousness": 44, "priceSensitivity": 80, "digitalConsumption": 89}	{"taxTolerance": 50, "governmentTrust": 66, "policyAcceptance": 47, "regulationPreference": 72, "publicServiceSatisfaction": 76}	0
3874	윤영수	18	18-29	Male	경기도	37.418146	127.483562	전문대 졸	200만원 미만	학생	다세대 가구	-12	중도 무당층	61	{"economy": -35, "housing": 30, "welfare": 46, "security": -5, "environment": 31}	SNS	{안정,혁신,자유}	경기도에 거주하는 18-29 학생. 정치 성향은 중도이며 안정, 혁신, 자유 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 77, "ecoConsciousness": 64, "priceSensitivity": 74, "digitalConsumption": 96}	{"taxTolerance": 54, "governmentTrust": 45, "policyAcceptance": 33, "regulationPreference": 84, "publicServiceSatisfaction": 71}	0
3875	윤지호	28	18-29	Male	경기도	37.481004	127.522444	대학원 졸	200-350만원	사무직	1인 가구	-48	진보 정당 지지	50	{"economy": -33, "housing": 31, "welfare": 39, "security": -17, "environment": 43}	유튜브	{다양성,공동체,혁신}	경기도에 거주하는 18-29 사무직. 정치 성향은 진보이며 다양성, 공동체, 혁신 가치를 중시한다.	{"brandLoyalty": 13, "noveltySeeking": 83, "ecoConsciousness": 70, "priceSensitivity": 76, "digitalConsumption": 90}	{"taxTolerance": 52, "governmentTrust": 65, "policyAcceptance": 46, "regulationPreference": 70, "publicServiceSatisfaction": 68}	0
3876	강은우	26	18-29	Male	경기도	37.466951	127.586296	대학원 졸	200만원 미만	주부	부부 가구	-25	진보 성향 무당층	60	{"economy": -19, "housing": 39, "welfare": 10, "security": -3, "environment": 41}	신문/팟캐스트	{환경,공동체,안전}	경기도에 거주하는 18-29 주부. 정치 성향은 중도이며 환경, 공동체, 안전 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 69, "ecoConsciousness": 67, "priceSensitivity": 55, "digitalConsumption": 70}	{"taxTolerance": 59, "governmentTrust": 56, "policyAcceptance": 57, "regulationPreference": 53, "publicServiceSatisfaction": 52}	0
3877	강준서	22	18-29	Male	경기도	37.452323	127.605075	대학교 졸	200만원 미만	서비스직	다세대 가구	-53	진보 정당 지지	29	{"economy": -65, "housing": 31, "welfare": 45, "security": -20, "environment": 33}	포털 뉴스	{전통,환경,혁신}	경기도에 거주하는 18-29 서비스직. 정치 성향은 진보이며 전통, 환경, 혁신 가치를 중시한다.	{"brandLoyalty": 24, "noveltySeeking": 89, "ecoConsciousness": 47, "priceSensitivity": 85, "digitalConsumption": 98}	{"taxTolerance": 53, "governmentTrust": 29, "policyAcceptance": 54, "regulationPreference": 74, "publicServiceSatisfaction": 70}	0
3878	이지우	25	18-29	Male	경기도	37.399878	127.580553	대학원 졸	500-700만원	공무원	자녀 양육 가구	-46	진보 정당 지지	22	{"economy": -67, "housing": 26, "welfare": 10, "security": -23, "environment": 49}	SNS	{환경,공정,자유}	경기도에 거주하는 18-29 공무원. 정치 성향은 진보이며 환경, 공정, 자유 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 61, "ecoConsciousness": 63, "priceSensitivity": 55, "digitalConsumption": 71}	{"taxTolerance": 57, "governmentTrust": 53, "policyAcceptance": 50, "regulationPreference": 70, "publicServiceSatisfaction": 69}	0
3879	안하은	25	18-29	Male	경기도	37.40668	127.579171	대학원 졸	500-700만원	자영업	부부 가구	-24	진보 성향 무당층	48	{"economy": -5, "housing": 40, "welfare": 48, "security": -24, "environment": 39}	포털 뉴스	{다양성,안전,안정}	경기도에 거주하는 18-29 자영업. 정치 성향은 중도이며 다양성, 안전, 안정 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 72, "ecoConsciousness": 56, "priceSensitivity": 61, "digitalConsumption": 92}	{"taxTolerance": 65, "governmentTrust": 32, "policyAcceptance": 40, "regulationPreference": 64, "publicServiceSatisfaction": 72}	0
3880	신하은	29	18-29	Male	경기도	37.431684	127.418349	대학원 졸	200-350만원	학생	부부 가구	-45	진보 정당 지지	51	{"economy": -41, "housing": 39, "welfare": 42, "security": 0, "environment": 59}	포털 뉴스	{전통,성장,공정}	경기도에 거주하는 18-29 학생. 정치 성향은 진보이며 전통, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 65, "ecoConsciousness": 46, "priceSensitivity": 69, "digitalConsumption": 87}	{"taxTolerance": 42, "governmentTrust": 57, "policyAcceptance": 35, "regulationPreference": 77, "publicServiceSatisfaction": 49}	0
3881	임미경	29	18-29	Male	경기도	37.458199	127.440972	대학원 졸	700만원 이상	은퇴	다세대 가구	-42	진보 성향 무당층	49	{"economy": -37, "housing": 35, "welfare": 20, "security": -28, "environment": 45}	신문/팟캐스트	{전통,안정,자유}	경기도에 거주하는 18-29 은퇴. 정치 성향은 진보이며 전통, 안정, 자유 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 78, "ecoConsciousness": 55, "priceSensitivity": 39, "digitalConsumption": 83}	{"taxTolerance": 59, "governmentTrust": 39, "policyAcceptance": 31, "regulationPreference": 52, "publicServiceSatisfaction": 80}	0
3882	조지민	19	18-29	Male	경기도	37.335796	127.44788	전문대 졸	200-350만원	학생	자녀 양육 가구	-38	진보 성향 무당층	67	{"economy": -54, "housing": 11, "welfare": 41, "security": -48, "environment": 30}	유튜브	{환경,혁신,안정}	경기도에 거주하는 18-29 학생. 정치 성향은 진보이며 환경, 혁신, 안정 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 75, "ecoConsciousness": 38, "priceSensitivity": 73, "digitalConsumption": 91}	{"taxTolerance": 29, "governmentTrust": 59, "policyAcceptance": 44, "regulationPreference": 56, "publicServiceSatisfaction": 67}	0
3883	임다은	24	18-29	Male	경기도	37.358745	127.55641	대학교 졸	200-350만원	학생	1인 가구	-21	진보 성향 무당층	43	{"economy": -43, "housing": 9, "welfare": 27, "security": -41, "environment": 18}	SNS	{다양성,전통,공동체}	경기도에 거주하는 18-29 학생. 정치 성향은 중도이며 다양성, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 81, "ecoConsciousness": 65, "priceSensitivity": 67, "digitalConsumption": 85}	{"taxTolerance": 60, "governmentTrust": 58, "policyAcceptance": 53, "regulationPreference": 61, "publicServiceSatisfaction": 70}	0
3884	한채원	24	18-29	Male	경기도	37.391953	127.532413	대학교 졸	350-500만원	사무직	다세대 가구	-13	중도 무당층	44	{"economy": -10, "housing": 19, "welfare": 27, "security": -13, "environment": 37}	지상파/종편 뉴스	{안전,공정,환경}	경기도에 거주하는 18-29 사무직. 정치 성향은 중도이며 안전, 공정, 환경 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 78, "ecoConsciousness": 66, "priceSensitivity": 65, "digitalConsumption": 82}	{"taxTolerance": 46, "governmentTrust": 46, "policyAcceptance": 37, "regulationPreference": 88, "publicServiceSatisfaction": 54}	0
3885	정다은	33	30-39	Female	경기도	37.334535	127.597781	대학교 졸	200만원 미만	은퇴	다세대 가구	-25	진보 성향 무당층	31	{"economy": -45, "housing": 23, "welfare": 14, "security": -13, "environment": 26}	지상파/종편 뉴스	{자유,공동체,환경}	경기도에 거주하는 30-39 은퇴. 정치 성향은 중도이며 자유, 공동체, 환경 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 58, "ecoConsciousness": 53, "priceSensitivity": 69, "digitalConsumption": 77}	{"taxTolerance": 43, "governmentTrust": 53, "policyAcceptance": 44, "regulationPreference": 55, "publicServiceSatisfaction": 81}	0
3886	전하은	33	30-39	Female	경기도	37.403196	127.607431	전문대 졸	700만원 이상	학생	다세대 가구	-4	중도 무당층	44	{"economy": 3, "housing": 14, "welfare": 6, "security": 22, "environment": 1}	포털 뉴스	{안전,안정,환경}	경기도에 거주하는 30-39 학생. 정치 성향은 중도이며 안전, 안정, 환경 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 78, "ecoConsciousness": 45, "priceSensitivity": 34, "digitalConsumption": 61}	{"taxTolerance": 71, "governmentTrust": 44, "policyAcceptance": 54, "regulationPreference": 58, "publicServiceSatisfaction": 66}	0
3887	김성호	39	30-39	Female	경기도	37.463815	127.429122	대학교 졸	200만원 미만	주부	1인 가구	-15	진보 성향 무당층	67	{"economy": -38, "housing": 38, "welfare": 15, "security": -27, "environment": 21}	SNS	{혁신,공동체,공정}	경기도에 거주하는 30-39 주부. 정치 성향은 중도이며 혁신, 공동체, 공정 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 73, "ecoConsciousness": 44, "priceSensitivity": 69, "digitalConsumption": 59}	{"taxTolerance": 37, "governmentTrust": 44, "policyAcceptance": 62, "regulationPreference": 55, "publicServiceSatisfaction": 68}	0
3888	권주원	36	30-39	Female	경기도	37.481014	127.422936	대학원 졸	350-500만원	서비스직	부부 가구	-50	진보 정당 지지	63	{"economy": -15, "housing": 55, "welfare": 49, "security": -15, "environment": 50}	지상파/종편 뉴스	{안정,안전,다양성}	경기도에 거주하는 30-39 서비스직. 정치 성향은 진보이며 안정, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 68, "ecoConsciousness": 50, "priceSensitivity": 70, "digitalConsumption": 81}	{"taxTolerance": 42, "governmentTrust": 47, "policyAcceptance": 41, "regulationPreference": 69, "publicServiceSatisfaction": 57}	0
3889	정수아	38	30-39	Female	경기도	37.349063	127.491	고졸 이하	350-500만원	은퇴	1인 가구	-41	진보 성향 무당층	46	{"economy": -35, "housing": 43, "welfare": 8, "security": -27, "environment": 48}	신문/팟캐스트	{공정,공동체,환경}	경기도에 거주하는 30-39 은퇴. 정치 성향은 진보이며 공정, 공동체, 환경 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 56, "ecoConsciousness": 54, "priceSensitivity": 40, "digitalConsumption": 84}	{"taxTolerance": 47, "governmentTrust": 50, "policyAcceptance": 50, "regulationPreference": 69, "publicServiceSatisfaction": 60}	0
3890	오지아	31	30-39	Female	경기도	37.391048	127.594139	전문대 졸	500-700만원	전문직	다세대 가구	-52	진보 정당 지지	59	{"economy": -52, "housing": 36, "welfare": 44, "security": -31, "environment": 45}	포털 뉴스	{다양성,공동체,혁신}	경기도에 거주하는 30-39 전문직. 정치 성향은 진보이며 다양성, 공동체, 혁신 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 73, "ecoConsciousness": 53, "priceSensitivity": 56, "digitalConsumption": 78}	{"taxTolerance": 67, "governmentTrust": 18, "policyAcceptance": 45, "regulationPreference": 62, "publicServiceSatisfaction": 47}	0
3891	류주원	33	30-39	Female	경기도	37.369885	127.465346	대학원 졸	350-500만원	생산직	부부 가구	10	중도 무당층	50	{"economy": 5, "housing": 5, "welfare": 29, "security": 25, "environment": -10}	유튜브	{환경,혁신,공정}	경기도에 거주하는 30-39 생산직. 정치 성향은 중도이며 환경, 혁신, 공정 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 52, "ecoConsciousness": 58, "priceSensitivity": 69, "digitalConsumption": 81}	{"taxTolerance": 37, "governmentTrust": 51, "policyAcceptance": 34, "regulationPreference": 56, "publicServiceSatisfaction": 64}	0
3892	김광수	37	30-39	Female	경기도	37.466216	127.580751	대학원 졸	700만원 이상	사무직	1인 가구	-25	진보 성향 무당층	45	{"economy": -21, "housing": 40, "welfare": 34, "security": 21, "environment": 25}	신문/팟캐스트	{자유,환경,혁신}	경기도에 거주하는 30-39 사무직. 정치 성향은 중도이며 자유, 환경, 혁신 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 72, "ecoConsciousness": 59, "priceSensitivity": 57, "digitalConsumption": 67}	{"taxTolerance": 35, "governmentTrust": 57, "policyAcceptance": 60, "regulationPreference": 70, "publicServiceSatisfaction": 78}	0
3893	최예준	39	30-39	Female	경기도	37.460581	127.614817	대학원 졸	200-350만원	사무직	자녀 양육 가구	-13	중도 무당층	71	{"economy": -22, "housing": 12, "welfare": 0, "security": 18, "environment": 7}	유튜브	{공동체,성장,전통}	경기도에 거주하는 30-39 사무직. 정치 성향은 중도이며 공동체, 성장, 전통 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 66, "ecoConsciousness": 81, "priceSensitivity": 71, "digitalConsumption": 61}	{"taxTolerance": 62, "governmentTrust": 34, "policyAcceptance": 50, "regulationPreference": 50, "publicServiceSatisfaction": 64}	0
3894	권철수	31	30-39	Female	경기도	37.446507	127.419319	전문대 졸	200-350만원	생산직	자녀 양육 가구	-44	진보 성향 무당층	37	{"economy": -41, "housing": 26, "welfare": 44, "security": -41, "environment": 57}	SNS	{혁신,환경,자유}	경기도에 거주하는 30-39 생산직. 정치 성향은 진보이며 혁신, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 53, "ecoConsciousness": 57, "priceSensitivity": 72, "digitalConsumption": 84}	{"taxTolerance": 64, "governmentTrust": 57, "policyAcceptance": 45, "regulationPreference": 58, "publicServiceSatisfaction": 73}	0
3895	장예준	38	30-39	Female	경기도	37.416627	127.616045	전문대 졸	350-500만원	프리랜서	1인 가구	-20	진보 성향 무당층	68	{"economy": -37, "housing": -11, "welfare": 23, "security": -6, "environment": 41}	지상파/종편 뉴스	{전통,안전,성장}	경기도에 거주하는 30-39 프리랜서. 정치 성향은 중도이며 전통, 안전, 성장 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 64, "ecoConsciousness": 45, "priceSensitivity": 36, "digitalConsumption": 88}	{"taxTolerance": 56, "governmentTrust": 61, "policyAcceptance": 61, "regulationPreference": 69, "publicServiceSatisfaction": 76}	0
3896	한민서	37	30-39	Female	경기도	37.440575	127.447028	대학교 졸	500-700만원	자영업	1인 가구	-33	진보 성향 무당층	70	{"economy": -37, "housing": 18, "welfare": 27, "security": -45, "environment": 33}	신문/팟캐스트	{성장,안전,다양성}	경기도에 거주하는 30-39 자영업. 정치 성향은 중도이며 성장, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 74, "ecoConsciousness": 46, "priceSensitivity": 46, "digitalConsumption": 81}	{"taxTolerance": 51, "governmentTrust": 59, "policyAcceptance": 48, "regulationPreference": 64, "publicServiceSatisfaction": 68}	0
3897	류성호	32	30-39	Female	경기도	37.383228	127.607521	전문대 졸	200-350만원	프리랜서	자녀 양육 가구	-9	중도 무당층	66	{"economy": 20, "housing": 46, "welfare": 26, "security": 7, "environment": 37}	지상파/종편 뉴스	{전통,다양성,성장}	경기도에 거주하는 30-39 프리랜서. 정치 성향은 중도이며 전통, 다양성, 성장 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 66, "ecoConsciousness": 45, "priceSensitivity": 70, "digitalConsumption": 68}	{"taxTolerance": 49, "governmentTrust": 32, "policyAcceptance": 49, "regulationPreference": 71, "publicServiceSatisfaction": 71}	0
3898	신준서	34	30-39	Female	경기도	37.383292	127.566425	대학원 졸	200-350만원	사무직	부부 가구	-21	진보 성향 무당층	56	{"economy": -35, "housing": 32, "welfare": 29, "security": 12, "environment": 27}	포털 뉴스	{안전,공동체,전통}	경기도에 거주하는 30-39 사무직. 정치 성향은 중도이며 안전, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 14, "noveltySeeking": 74, "ecoConsciousness": 61, "priceSensitivity": 48, "digitalConsumption": 80}	{"taxTolerance": 44, "governmentTrust": 30, "policyAcceptance": 47, "regulationPreference": 72, "publicServiceSatisfaction": 69}	0
3899	한지호	38	30-39	Female	경기도	37.389515	127.602276	대학교 졸	350-500만원	서비스직	부부 가구	-51	진보 정당 지지	77	{"economy": -27, "housing": 29, "welfare": 61, "security": -29, "environment": 30}	지상파/종편 뉴스	{안전,공동체,다양성}	경기도에 거주하는 30-39 서비스직. 정치 성향은 진보이며 안전, 공동체, 다양성 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 86, "ecoConsciousness": 49, "priceSensitivity": 62, "digitalConsumption": 80}	{"taxTolerance": 49, "governmentTrust": 27, "policyAcceptance": 54, "regulationPreference": 44, "publicServiceSatisfaction": 45}	0
3900	이현우	38	30-39	Female	경기도	37.379788	127.454601	대학교 졸	700만원 이상	학생	부부 가구	-5	중도 무당층	47	{"economy": -7, "housing": 9, "welfare": 50, "security": 5, "environment": 16}	유튜브	{공정,성장,다양성}	경기도에 거주하는 30-39 학생. 정치 성향은 중도이며 공정, 성장, 다양성 가치를 중시한다.	{"brandLoyalty": 15, "noveltySeeking": 64, "ecoConsciousness": 41, "priceSensitivity": 50, "digitalConsumption": 66}	{"taxTolerance": 74, "governmentTrust": 52, "policyAcceptance": 30, "regulationPreference": 79, "publicServiceSatisfaction": 45}	0
3901	전은우	37	30-39	Male	경기도	37.395697	127.487766	전문대 졸	350-500만원	전문직	다세대 가구	16	보수 성향 무당층	47	{"economy": -8, "housing": 45, "welfare": -16, "security": -1, "environment": 31}	유튜브	{안정,환경,혁신}	경기도에 거주하는 30-39 전문직. 정치 성향은 중도이며 안정, 환경, 혁신 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 70, "ecoConsciousness": 61, "priceSensitivity": 69, "digitalConsumption": 59}	{"taxTolerance": 50, "governmentTrust": 38, "policyAcceptance": 57, "regulationPreference": 92, "publicServiceSatisfaction": 66}	0
3902	이수아	30	30-39	Male	경기도	37.402921	127.451809	대학원 졸	200-350만원	은퇴	부부 가구	-10	중도 무당층	60	{"economy": -18, "housing": 20, "welfare": 26, "security": 16, "environment": -5}	신문/팟캐스트	{안정,다양성,공정}	경기도에 거주하는 30-39 은퇴. 정치 성향은 중도이며 안정, 다양성, 공정 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 91, "ecoConsciousness": 70, "priceSensitivity": 64, "digitalConsumption": 80}	{"taxTolerance": 36, "governmentTrust": 49, "policyAcceptance": 53, "regulationPreference": 51, "publicServiceSatisfaction": 59}	0
3903	오영수	37	30-39	Male	경기도	37.390861	127.502222	대학교 졸	200-350만원	주부	1인 가구	-34	진보 성향 무당층	60	{"economy": -38, "housing": 43, "welfare": 5, "security": 15, "environment": 50}	포털 뉴스	{혁신,안정,자유}	경기도에 거주하는 30-39 주부. 정치 성향은 진보이며 혁신, 안정, 자유 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 58, "ecoConsciousness": 54, "priceSensitivity": 73, "digitalConsumption": 83}	{"taxTolerance": 20, "governmentTrust": 34, "policyAcceptance": 46, "regulationPreference": 72, "publicServiceSatisfaction": 79}	0
3904	권혜진	31	30-39	Male	경기도	37.429655	127.578179	대학원 졸	350-500만원	자영업	다세대 가구	-15	진보 성향 무당층	68	{"economy": -33, "housing": 26, "welfare": 1, "security": 6, "environment": 46}	유튜브	{혁신,공정,안정}	경기도에 거주하는 30-39 자영업. 정치 성향은 중도이며 혁신, 공정, 안정 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 81, "ecoConsciousness": 72, "priceSensitivity": 76, "digitalConsumption": 77}	{"taxTolerance": 48, "governmentTrust": 43, "policyAcceptance": 39, "regulationPreference": 68, "publicServiceSatisfaction": 75}	0
3905	장지민	31	30-39	Male	경기도	37.400473	127.529237	대학원 졸	200-350만원	은퇴	다세대 가구	-55	진보 정당 지지	53	{"economy": -43, "housing": 42, "welfare": 24, "security": 8, "environment": 41}	지상파/종편 뉴스	{안정,공정,환경}	경기도에 거주하는 30-39 은퇴. 정치 성향은 진보이며 안정, 공정, 환경 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 64, "ecoConsciousness": 60, "priceSensitivity": 67, "digitalConsumption": 91}	{"taxTolerance": 44, "governmentTrust": 46, "policyAcceptance": 44, "regulationPreference": 70, "publicServiceSatisfaction": 62}	0
3906	최철수	38	30-39	Male	경기도	37.401975	127.578094	대학원 졸	500-700만원	전문직	1인 가구	-41	진보 성향 무당층	53	{"economy": -40, "housing": 63, "welfare": 9, "security": -33, "environment": 48}	SNS	{다양성,공정,환경}	경기도에 거주하는 30-39 전문직. 정치 성향은 진보이며 다양성, 공정, 환경 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 74, "ecoConsciousness": 72, "priceSensitivity": 36, "digitalConsumption": 74}	{"taxTolerance": 53, "governmentTrust": 37, "policyAcceptance": 59, "regulationPreference": 71, "publicServiceSatisfaction": 56}	0
3907	조철수	34	30-39	Male	경기도	37.479471	127.580407	대학교 졸	200만원 미만	사무직	1인 가구	-34	진보 성향 무당층	73	{"economy": -26, "housing": -17, "welfare": 18, "security": -9, "environment": 36}	유튜브	{환경,전통,안전}	경기도에 거주하는 30-39 사무직. 정치 성향은 진보이며 환경, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 22, "noveltySeeking": 83, "ecoConsciousness": 31, "priceSensitivity": 84, "digitalConsumption": 80}	{"taxTolerance": 55, "governmentTrust": 44, "policyAcceptance": 50, "regulationPreference": 70, "publicServiceSatisfaction": 68}	0
3908	김지우	39	30-39	Male	경기도	37.343795	127.601771	대학교 졸	350-500만원	생산직	부부 가구	-59	진보 정당 지지	40	{"economy": -14, "housing": 11, "welfare": 49, "security": -24, "environment": 34}	포털 뉴스	{자유,환경,안정}	경기도에 거주하는 30-39 생산직. 정치 성향은 진보이며 자유, 환경, 안정 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 72, "ecoConsciousness": 54, "priceSensitivity": 54, "digitalConsumption": 70}	{"taxTolerance": 28, "governmentTrust": 54, "policyAcceptance": 44, "regulationPreference": 67, "publicServiceSatisfaction": 73}	0
3909	신하은	31	30-39	Male	경기도	37.334671	127.525572	대학교 졸	700만원 이상	전문직	부부 가구	-43	진보 성향 무당층	41	{"economy": -56, "housing": 20, "welfare": 55, "security": -30, "environment": 35}	SNS	{성장,환경,자유}	경기도에 거주하는 30-39 전문직. 정치 성향은 진보이며 성장, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 74, "ecoConsciousness": 53, "priceSensitivity": 55, "digitalConsumption": 55}	{"taxTolerance": 44, "governmentTrust": 48, "policyAcceptance": 50, "regulationPreference": 64, "publicServiceSatisfaction": 82}	0
3910	홍성호	33	30-39	Male	경기도	37.48945	127.561044	대학원 졸	200-350만원	자영업	다세대 가구	-27	진보 성향 무당층	48	{"economy": -1, "housing": -10, "welfare": 20, "security": 10, "environment": 50}	신문/팟캐스트	{안전,혁신,다양성}	경기도에 거주하는 30-39 자영업. 정치 성향은 중도이며 안전, 혁신, 다양성 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 77, "ecoConsciousness": 49, "priceSensitivity": 65, "digitalConsumption": 100}	{"taxTolerance": 68, "governmentTrust": 38, "policyAcceptance": 45, "regulationPreference": 62, "publicServiceSatisfaction": 74}	0
3911	오은우	35	30-39	Male	경기도	37.363578	127.441123	전문대 졸	700만원 이상	서비스직	부부 가구	-6	중도 무당층	53	{"economy": -25, "housing": 41, "welfare": 15, "security": -7, "environment": -11}	유튜브	{안전,환경,공정}	경기도에 거주하는 30-39 서비스직. 정치 성향은 중도이며 안전, 환경, 공정 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 63, "ecoConsciousness": 47, "priceSensitivity": 53, "digitalConsumption": 80}	{"taxTolerance": 46, "governmentTrust": 50, "policyAcceptance": 53, "regulationPreference": 63, "publicServiceSatisfaction": 70}	0
3912	전지우	36	30-39	Male	경기도	37.386276	127.527509	전문대 졸	500-700만원	학생	다세대 가구	-42	진보 성향 무당층	79	{"economy": -30, "housing": 30, "welfare": 52, "security": -10, "environment": 38}	신문/팟캐스트	{안정,환경,안전}	경기도에 거주하는 30-39 학생. 정치 성향은 진보이며 안정, 환경, 안전 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 75, "ecoConsciousness": 63, "priceSensitivity": 54, "digitalConsumption": 83}	{"taxTolerance": 54, "governmentTrust": 35, "policyAcceptance": 50, "regulationPreference": 63, "publicServiceSatisfaction": 51}	0
3913	안철수	39	30-39	Male	경기도	37.339448	127.465586	대학교 졸	350-500만원	전문직	자녀 양육 가구	-43	진보 성향 무당층	49	{"economy": -11, "housing": 32, "welfare": 40, "security": -17, "environment": 36}	SNS	{공동체,환경,공정}	경기도에 거주하는 30-39 전문직. 정치 성향은 진보이며 공동체, 환경, 공정 가치를 중시한다.	{"brandLoyalty": 26, "noveltySeeking": 71, "ecoConsciousness": 51, "priceSensitivity": 63, "digitalConsumption": 85}	{"taxTolerance": 51, "governmentTrust": 38, "policyAcceptance": 48, "regulationPreference": 59, "publicServiceSatisfaction": 72}	0
3914	황건우	39	30-39	Male	경기도	37.447439	127.581138	전문대 졸	350-500만원	생산직	부부 가구	-8	중도 무당층	51	{"economy": -14, "housing": -1, "welfare": 23, "security": -26, "environment": 21}	유튜브	{공동체,다양성,환경}	경기도에 거주하는 30-39 생산직. 정치 성향은 중도이며 공동체, 다양성, 환경 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 66, "ecoConsciousness": 49, "priceSensitivity": 72, "digitalConsumption": 81}	{"taxTolerance": 47, "governmentTrust": 54, "policyAcceptance": 37, "regulationPreference": 63, "publicServiceSatisfaction": 65}	0
3915	윤채원	38	30-39	Male	경기도	37.39998	127.559441	대학교 졸	500-700만원	자영업	부부 가구	1	중도 무당층	64	{"economy": -3, "housing": 43, "welfare": -7, "security": 15, "environment": 23}	신문/팟캐스트	{안정,안전,다양성}	경기도에 거주하는 30-39 자영업. 정치 성향은 중도이며 안정, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 62, "ecoConsciousness": 62, "priceSensitivity": 60, "digitalConsumption": 79}	{"taxTolerance": 58, "governmentTrust": 28, "policyAcceptance": 52, "regulationPreference": 77, "publicServiceSatisfaction": 100}	0
3916	이영수	35	30-39	Male	경기도	37.369756	127.459657	전문대 졸	350-500만원	자영업	부부 가구	-25	진보 성향 무당층	63	{"economy": 21, "housing": 34, "welfare": 15, "security": -17, "environment": 28}	포털 뉴스	{자유,안전,전통}	경기도에 거주하는 30-39 자영업. 정치 성향은 중도이며 자유, 안전, 전통 가치를 중시한다.	{"brandLoyalty": 21, "noveltySeeking": 61, "ecoConsciousness": 51, "priceSensitivity": 51, "digitalConsumption": 81}	{"taxTolerance": 43, "governmentTrust": 54, "policyAcceptance": 61, "regulationPreference": 59, "publicServiceSatisfaction": 63}	0
3917	황정희	47	40-49	Female	경기도	37.451918	127.487972	고졸 이하	500-700만원	공무원	1인 가구	-1	중도 무당층	75	{"economy": -16, "housing": 27, "welfare": -9, "security": -7, "environment": 23}	지상파/종편 뉴스	{혁신,자유,안전}	경기도에 거주하는 40-49 공무원. 정치 성향은 중도이며 혁신, 자유, 안전 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 53, "ecoConsciousness": 34, "priceSensitivity": 48, "digitalConsumption": 62}	{"taxTolerance": 56, "governmentTrust": 40, "policyAcceptance": 43, "regulationPreference": 65, "publicServiceSatisfaction": 59}	0
3918	임서윤	42	40-49	Female	경기도	37.349126	127.429104	대학원 졸	500-700만원	주부	자녀 양육 가구	-24	진보 성향 무당층	60	{"economy": -48, "housing": 25, "welfare": 15, "security": 6, "environment": 34}	포털 뉴스	{자유,전통,공동체}	경기도에 거주하는 40-49 주부. 정치 성향은 중도이며 자유, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 72, "ecoConsciousness": 62, "priceSensitivity": 70, "digitalConsumption": 84}	{"taxTolerance": 59, "governmentTrust": 40, "policyAcceptance": 60, "regulationPreference": 74, "publicServiceSatisfaction": 75}	0
3919	최지아	46	40-49	Female	경기도	37.452296	127.543296	대학교 졸	350-500만원	서비스직	다세대 가구	-6	중도 무당층	65	{"economy": -7, "housing": 8, "welfare": 23, "security": 30, "environment": 46}	신문/팟캐스트	{안정,다양성,전통}	경기도에 거주하는 40-49 서비스직. 정치 성향은 중도이며 안정, 다양성, 전통 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 66, "ecoConsciousness": 68, "priceSensitivity": 57, "digitalConsumption": 74}	{"taxTolerance": 47, "governmentTrust": 40, "policyAcceptance": 43, "regulationPreference": 58, "publicServiceSatisfaction": 62}	0
3920	임건우	46	40-49	Female	경기도	37.426876	127.521088	고졸 이하	350-500만원	학생	다세대 가구	11	중도 무당층	49	{"economy": -15, "housing": 28, "welfare": 11, "security": 2, "environment": 16}	SNS	{안전,자유,공정}	경기도에 거주하는 40-49 학생. 정치 성향은 중도이며 안전, 자유, 공정 가치를 중시한다.	{"brandLoyalty": 7, "noveltySeeking": 63, "ecoConsciousness": 42, "priceSensitivity": 62, "digitalConsumption": 74}	{"taxTolerance": 38, "governmentTrust": 58, "policyAcceptance": 46, "regulationPreference": 65, "publicServiceSatisfaction": 64}	0
3921	강서연	45	40-49	Female	경기도	37.339871	127.536168	대학교 졸	700만원 이상	사무직	다세대 가구	-33	진보 성향 무당층	69	{"economy": -13, "housing": 32, "welfare": 49, "security": -7, "environment": 34}	유튜브	{성장,안정,다양성}	경기도에 거주하는 40-49 사무직. 정치 성향은 중도이며 성장, 안정, 다양성 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 46, "ecoConsciousness": 65, "priceSensitivity": 59, "digitalConsumption": 72}	{"taxTolerance": 51, "governmentTrust": 45, "policyAcceptance": 68, "regulationPreference": 75, "publicServiceSatisfaction": 73}	0
3922	류주원	48	40-49	Female	경기도	37.492938	127.526316	전문대 졸	500-700만원	자영업	부부 가구	-22	진보 성향 무당층	66	{"economy": -11, "housing": 15, "welfare": -2, "security": 9, "environment": 32}	신문/팟캐스트	{다양성,공동체,자유}	경기도에 거주하는 40-49 자영업. 정치 성향은 중도이며 다양성, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 49, "ecoConsciousness": 30, "priceSensitivity": 48, "digitalConsumption": 77}	{"taxTolerance": 44, "governmentTrust": 43, "policyAcceptance": 47, "regulationPreference": 57, "publicServiceSatisfaction": 72}	0
3923	김도윤	45	40-49	Female	경기도	37.382341	127.588102	전문대 졸	500-700만원	서비스직	1인 가구	-17	진보 성향 무당층	69	{"economy": -28, "housing": 35, "welfare": 39, "security": -18, "environment": 17}	신문/팟캐스트	{전통,안정,환경}	경기도에 거주하는 40-49 서비스직. 정치 성향은 중도이며 전통, 안정, 환경 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 62, "ecoConsciousness": 56, "priceSensitivity": 56, "digitalConsumption": 66}	{"taxTolerance": 48, "governmentTrust": 56, "policyAcceptance": 37, "regulationPreference": 64, "publicServiceSatisfaction": 65}	0
3924	임준서	49	40-49	Female	경기도	37.351233	127.577083	대학교 졸	500-700만원	사무직	다세대 가구	-20	진보 성향 무당층	78	{"economy": 1, "housing": 35, "welfare": 11, "security": -13, "environment": 18}	포털 뉴스	{안정,안전,성장}	경기도에 거주하는 40-49 사무직. 정치 성향은 중도이며 안정, 안전, 성장 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 58, "ecoConsciousness": 61, "priceSensitivity": 28, "digitalConsumption": 77}	{"taxTolerance": 43, "governmentTrust": 45, "policyAcceptance": 45, "regulationPreference": 62, "publicServiceSatisfaction": 62}	0
3925	황미경	44	40-49	Female	경기도	37.474283	127.505851	전문대 졸	350-500만원	서비스직	부부 가구	-8	중도 무당층	58	{"economy": -12, "housing": 39, "welfare": 30, "security": -2, "environment": 34}	신문/팟캐스트	{자유,다양성,안정}	경기도에 거주하는 40-49 서비스직. 정치 성향은 중도이며 자유, 다양성, 안정 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 64, "ecoConsciousness": 37, "priceSensitivity": 44, "digitalConsumption": 68}	{"taxTolerance": 45, "governmentTrust": 61, "policyAcceptance": 68, "regulationPreference": 70, "publicServiceSatisfaction": 74}	0
3926	황지호	42	40-49	Female	경기도	37.37112	127.518259	대학교 졸	350-500만원	자영업	1인 가구	-15	진보 성향 무당층	78	{"economy": -5, "housing": 41, "welfare": 11, "security": -6, "environment": -6}	유튜브	{성장,전통,안전}	경기도에 거주하는 40-49 자영업. 정치 성향은 중도이며 성장, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 64, "noveltySeeking": 61, "ecoConsciousness": 54, "priceSensitivity": 70, "digitalConsumption": 82}	{"taxTolerance": 51, "governmentTrust": 52, "policyAcceptance": 59, "regulationPreference": 51, "publicServiceSatisfaction": 59}	0
3927	권경숙	44	40-49	Female	경기도	37.38738	127.577416	대학교 졸	500-700만원	자영업	다세대 가구	-31	진보 성향 무당층	63	{"economy": -23, "housing": 31, "welfare": 29, "security": -25, "environment": 8}	유튜브	{전통,성장,다양성}	경기도에 거주하는 40-49 자영업. 정치 성향은 중도이며 전통, 성장, 다양성 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 61, "ecoConsciousness": 73, "priceSensitivity": 48, "digitalConsumption": 56}	{"taxTolerance": 38, "governmentTrust": 60, "policyAcceptance": 52, "regulationPreference": 87, "publicServiceSatisfaction": 59}	0
3928	한예준	42	40-49	Female	경기도	37.43854	127.530964	전문대 졸	200-350만원	공무원	자녀 양육 가구	-47	진보 정당 지지	68	{"economy": -44, "housing": 24, "welfare": 64, "security": 16, "environment": 38}	SNS	{성장,공동체,환경}	경기도에 거주하는 40-49 공무원. 정치 성향은 진보이며 성장, 공동체, 환경 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 83, "ecoConsciousness": 41, "priceSensitivity": 79, "digitalConsumption": 52}	{"taxTolerance": 45, "governmentTrust": 42, "policyAcceptance": 71, "regulationPreference": 71, "publicServiceSatisfaction": 55}	0
3929	권현우	47	40-49	Female	경기도	37.407036	127.443449	전문대 졸	200-350만원	은퇴	다세대 가구	1	중도 무당층	56	{"economy": 4, "housing": 13, "welfare": 1, "security": -7, "environment": 6}	SNS	{안전,혁신,환경}	경기도에 거주하는 40-49 은퇴. 정치 성향은 중도이며 안전, 혁신, 환경 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 66, "ecoConsciousness": 51, "priceSensitivity": 69, "digitalConsumption": 76}	{"taxTolerance": 60, "governmentTrust": 51, "policyAcceptance": 43, "regulationPreference": 73, "publicServiceSatisfaction": 63}	0
3930	강지민	47	40-49	Female	경기도	37.461308	127.557246	대학교 졸	700만원 이상	서비스직	다세대 가구	-25	진보 성향 무당층	71	{"economy": -44, "housing": -4, "welfare": 39, "security": 40, "environment": 23}	SNS	{안정,다양성,자유}	경기도에 거주하는 40-49 서비스직. 정치 성향은 중도이며 안정, 다양성, 자유 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 84, "ecoConsciousness": 58, "priceSensitivity": 60, "digitalConsumption": 65}	{"taxTolerance": 58, "governmentTrust": 67, "policyAcceptance": 69, "regulationPreference": 89, "publicServiceSatisfaction": 56}	0
3931	최경숙	48	40-49	Female	경기도	37.428796	127.599782	전문대 졸	350-500만원	주부	부부 가구	-42	진보 성향 무당층	56	{"economy": -32, "housing": 25, "welfare": 53, "security": -13, "environment": 35}	신문/팟캐스트	{공동체,성장,안정}	경기도에 거주하는 40-49 주부. 정치 성향은 진보이며 공동체, 성장, 안정 가치를 중시한다.	{"brandLoyalty": 20, "noveltySeeking": 60, "ecoConsciousness": 30, "priceSensitivity": 50, "digitalConsumption": 67}	{"taxTolerance": 59, "governmentTrust": 41, "policyAcceptance": 59, "regulationPreference": 59, "publicServiceSatisfaction": 64}	0
3932	류영수	40	40-49	Female	경기도	37.399475	127.42777	대학교 졸	500-700만원	전문직	부부 가구	-51	진보 정당 지지	56	{"economy": -39, "housing": 30, "welfare": 57, "security": 2, "environment": 52}	포털 뉴스	{전통,공정,환경}	경기도에 거주하는 40-49 전문직. 정치 성향은 진보이며 전통, 공정, 환경 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 73, "ecoConsciousness": 52, "priceSensitivity": 50, "digitalConsumption": 88}	{"taxTolerance": 48, "governmentTrust": 37, "policyAcceptance": 56, "regulationPreference": 59, "publicServiceSatisfaction": 65}	0
3933	임지호	42	40-49	Female	경기도	37.443174	127.456004	고졸 이하	500-700만원	생산직	다세대 가구	-70	진보 정당 지지	46	{"economy": -40, "housing": 59, "welfare": 51, "security": -27, "environment": 47}	지상파/종편 뉴스	{전통,환경,공정}	경기도에 거주하는 40-49 생산직. 정치 성향은 진보이며 전통, 환경, 공정 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 69, "ecoConsciousness": 33, "priceSensitivity": 62, "digitalConsumption": 67}	{"taxTolerance": 55, "governmentTrust": 47, "policyAcceptance": 45, "regulationPreference": 62, "publicServiceSatisfaction": 76}	0
3934	권혜진	49	40-49	Female	경기도	37.35249	127.580604	대학교 졸	500-700만원	사무직	다세대 가구	-12	중도 무당층	74	{"economy": -12, "housing": 24, "welfare": -17, "security": -26, "environment": -7}	SNS	{공동체,자유,다양성}	경기도에 거주하는 40-49 사무직. 정치 성향은 중도이며 공동체, 자유, 다양성 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 47, "ecoConsciousness": 55, "priceSensitivity": 34, "digitalConsumption": 80}	{"taxTolerance": 61, "governmentTrust": 30, "policyAcceptance": 51, "regulationPreference": 48, "publicServiceSatisfaction": 79}	0
3935	윤하은	45	40-49	Female	경기도	37.38853	127.490347	대학원 졸	200-350만원	자영업	다세대 가구	-24	진보 성향 무당층	74	{"economy": -2, "housing": 29, "welfare": 43, "security": 10, "environment": 10}	지상파/종편 뉴스	{다양성,공정,혁신}	경기도에 거주하는 40-49 자영업. 정치 성향은 중도이며 다양성, 공정, 혁신 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 81, "ecoConsciousness": 68, "priceSensitivity": 76, "digitalConsumption": 85}	{"taxTolerance": 60, "governmentTrust": 54, "policyAcceptance": 54, "regulationPreference": 63, "publicServiceSatisfaction": 72}	0
3936	김혜진	47	40-49	Male	경기도	37.393268	127.558163	대학교 졸	500-700만원	자영업	자녀 양육 가구	5	중도 무당층	52	{"economy": 8, "housing": 10, "welfare": 13, "security": -23, "environment": 35}	유튜브	{공동체,공정,안정}	경기도에 거주하는 40-49 자영업. 정치 성향은 중도이며 공동체, 공정, 안정 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 69, "ecoConsciousness": 39, "priceSensitivity": 40, "digitalConsumption": 63}	{"taxTolerance": 36, "governmentTrust": 41, "policyAcceptance": 68, "regulationPreference": 68, "publicServiceSatisfaction": 57}	0
3937	윤건우	40	40-49	Male	경기도	37.356608	127.466478	고졸 이하	500-700만원	은퇴	다세대 가구	-23	진보 성향 무당층	82	{"economy": 15, "housing": 2, "welfare": 7, "security": -15, "environment": 31}	유튜브	{전통,다양성,자유}	경기도에 거주하는 40-49 은퇴. 정치 성향은 중도이며 전통, 다양성, 자유 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 61, "ecoConsciousness": 52, "priceSensitivity": 42, "digitalConsumption": 89}	{"taxTolerance": 52, "governmentTrust": 50, "policyAcceptance": 51, "regulationPreference": 71, "publicServiceSatisfaction": 68}	0
3938	전지민	48	40-49	Male	경기도	37.354009	127.456336	대학원 졸	350-500만원	주부	다세대 가구	-20	진보 성향 무당층	66	{"economy": -20, "housing": 18, "welfare": 18, "security": -6, "environment": 32}	신문/팟캐스트	{공동체,안전,안정}	경기도에 거주하는 40-49 주부. 정치 성향은 중도이며 공동체, 안전, 안정 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 63, "ecoConsciousness": 38, "priceSensitivity": 76, "digitalConsumption": 61}	{"taxTolerance": 73, "governmentTrust": 55, "policyAcceptance": 55, "regulationPreference": 79, "publicServiceSatisfaction": 72}	0
3939	안혜진	43	40-49	Male	경기도	37.335364	127.53548	전문대 졸	500-700만원	자영업	자녀 양육 가구	-30	진보 성향 무당층	54	{"economy": -17, "housing": 35, "welfare": 42, "security": 9, "environment": 10}	신문/팟캐스트	{공정,다양성,전통}	경기도에 거주하는 40-49 자영업. 정치 성향은 중도이며 공정, 다양성, 전통 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 74, "ecoConsciousness": 38, "priceSensitivity": 33, "digitalConsumption": 58}	{"taxTolerance": 34, "governmentTrust": 34, "policyAcceptance": 60, "regulationPreference": 63, "publicServiceSatisfaction": 70}	0
3940	강민준	40	40-49	Male	경기도	37.3398	127.521727	고졸 이하	700만원 이상	은퇴	1인 가구	-73	진보 정당 지지	54	{"economy": -44, "housing": 56, "welfare": 34, "security": -40, "environment": 46}	SNS	{다양성,전통,안정}	경기도에 거주하는 40-49 은퇴. 정치 성향은 진보이며 다양성, 전통, 안정 가치를 중시한다.	{"brandLoyalty": 61, "noveltySeeking": 73, "ecoConsciousness": 51, "priceSensitivity": 32, "digitalConsumption": 89}	{"taxTolerance": 52, "governmentTrust": 55, "policyAcceptance": 56, "regulationPreference": 74, "publicServiceSatisfaction": 73}	0
3941	최동현	41	40-49	Male	경기도	37.385586	127.439755	대학교 졸	500-700만원	프리랜서	다세대 가구	18	보수 성향 무당층	56	{"economy": 20, "housing": -8, "welfare": -1, "security": 25, "environment": 27}	포털 뉴스	{자유,혁신,환경}	경기도에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 자유, 혁신, 환경 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 62, "ecoConsciousness": 66, "priceSensitivity": 22, "digitalConsumption": 76}	{"taxTolerance": 51, "governmentTrust": 42, "policyAcceptance": 52, "regulationPreference": 76, "publicServiceSatisfaction": 80}	0
3942	류성호	48	40-49	Male	경기도	37.392817	127.467362	대학원 졸	700만원 이상	생산직	자녀 양육 가구	-31	진보 성향 무당층	92	{"economy": -19, "housing": 50, "welfare": 38, "security": -15, "environment": 23}	SNS	{공정,다양성,성장}	경기도에 거주하는 40-49 생산직. 정치 성향은 중도이며 공정, 다양성, 성장 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 70, "ecoConsciousness": 64, "priceSensitivity": 42, "digitalConsumption": 78}	{"taxTolerance": 53, "governmentTrust": 48, "policyAcceptance": 42, "regulationPreference": 61, "publicServiceSatisfaction": 60}	0
3943	전주원	44	40-49	Male	경기도	37.450845	127.481367	대학교 졸	350-500만원	주부	부부 가구	-23	진보 성향 무당층	77	{"economy": -15, "housing": 1, "welfare": 48, "security": -4, "environment": 16}	포털 뉴스	{안전,다양성,환경}	경기도에 거주하는 40-49 주부. 정치 성향은 중도이며 안전, 다양성, 환경 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 72, "ecoConsciousness": 63, "priceSensitivity": 50, "digitalConsumption": 69}	{"taxTolerance": 61, "governmentTrust": 68, "policyAcceptance": 55, "regulationPreference": 84, "publicServiceSatisfaction": 75}	0
3944	류민준	45	40-49	Male	경기도	37.439532	127.566687	전문대 졸	350-500만원	학생	다세대 가구	-26	진보 성향 무당층	64	{"economy": -38, "housing": 32, "welfare": 28, "security": -21, "environment": 34}	유튜브	{공동체,성장,전통}	경기도에 거주하는 40-49 학생. 정치 성향은 중도이며 공동체, 성장, 전통 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 53, "ecoConsciousness": 39, "priceSensitivity": 58, "digitalConsumption": 70}	{"taxTolerance": 52, "governmentTrust": 46, "policyAcceptance": 56, "regulationPreference": 62, "publicServiceSatisfaction": 52}	0
3945	신도윤	41	40-49	Male	경기도	37.43242	127.515389	대학교 졸	350-500만원	사무직	다세대 가구	-17	진보 성향 무당층	64	{"economy": -9, "housing": 33, "welfare": 38, "security": 1, "environment": 47}	지상파/종편 뉴스	{안정,전통,공동체}	경기도에 거주하는 40-49 사무직. 정치 성향은 중도이며 안정, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 56, "ecoConsciousness": 30, "priceSensitivity": 72, "digitalConsumption": 81}	{"taxTolerance": 55, "governmentTrust": 54, "policyAcceptance": 61, "regulationPreference": 66, "publicServiceSatisfaction": 89}	0
3946	송서윤	42	40-49	Male	경기도	37.41751	127.487398	대학원 졸	500-700만원	주부	1인 가구	-10	중도 무당층	59	{"economy": -33, "housing": 23, "welfare": 2, "security": 11, "environment": 49}	포털 뉴스	{공동체,환경,안전}	경기도에 거주하는 40-49 주부. 정치 성향은 중도이며 공동체, 환경, 안전 가치를 중시한다.	{"brandLoyalty": 61, "noveltySeeking": 55, "ecoConsciousness": 40, "priceSensitivity": 51, "digitalConsumption": 68}	{"taxTolerance": 55, "governmentTrust": 66, "policyAcceptance": 35, "regulationPreference": 93, "publicServiceSatisfaction": 63}	0
3947	조유준	49	40-49	Male	경기도	37.358997	127.450468	대학원 졸	350-500만원	공무원	다세대 가구	-9	중도 무당층	48	{"economy": -6, "housing": 32, "welfare": 27, "security": 2, "environment": 37}	신문/팟캐스트	{환경,다양성,안전}	경기도에 거주하는 40-49 공무원. 정치 성향은 중도이며 환경, 다양성, 안전 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 50, "ecoConsciousness": 62, "priceSensitivity": 59, "digitalConsumption": 52}	{"taxTolerance": 47, "governmentTrust": 31, "policyAcceptance": 36, "regulationPreference": 59, "publicServiceSatisfaction": 49}	0
3948	전동현	43	40-49	Male	경기도	37.456376	127.424094	대학교 졸	200만원 미만	서비스직	1인 가구	-14	중도 무당층	78	{"economy": 0, "housing": 42, "welfare": 3, "security": -8, "environment": 33}	지상파/종편 뉴스	{환경,전통,성장}	경기도에 거주하는 40-49 서비스직. 정치 성향은 중도이며 환경, 전통, 성장 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 73, "ecoConsciousness": 46, "priceSensitivity": 81, "digitalConsumption": 65}	{"taxTolerance": 34, "governmentTrust": 38, "policyAcceptance": 65, "regulationPreference": 74, "publicServiceSatisfaction": 55}	0
3949	최준서	42	40-49	Male	경기도	37.445009	127.448345	전문대 졸	500-700만원	학생	부부 가구	-29	진보 성향 무당층	68	{"economy": -40, "housing": 18, "welfare": 41, "security": 8, "environment": 30}	신문/팟캐스트	{공동체,안정,자유}	경기도에 거주하는 40-49 학생. 정치 성향은 중도이며 공동체, 안정, 자유 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 65, "ecoConsciousness": 56, "priceSensitivity": 46, "digitalConsumption": 62}	{"taxTolerance": 72, "governmentTrust": 35, "policyAcceptance": 71, "regulationPreference": 50, "publicServiceSatisfaction": 62}	0
3950	서민준	48	40-49	Male	경기도	37.457257	127.455105	고졸 이하	500-700만원	사무직	다세대 가구	-9	중도 무당층	56	{"economy": -13, "housing": 15, "welfare": 55, "security": -9, "environment": 32}	SNS	{안전,자유,안정}	경기도에 거주하는 40-49 사무직. 정치 성향은 중도이며 안전, 자유, 안정 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 63, "ecoConsciousness": 54, "priceSensitivity": 55, "digitalConsumption": 80}	{"taxTolerance": 54, "governmentTrust": 60, "policyAcceptance": 56, "regulationPreference": 72, "publicServiceSatisfaction": 62}	0
3951	권민서	49	40-49	Male	경기도	37.428926	127.452175	대학원 졸	200-350만원	주부	다세대 가구	-22	진보 성향 무당층	58	{"economy": 0, "housing": 33, "welfare": 30, "security": 11, "environment": 19}	SNS	{다양성,안전,자유}	경기도에 거주하는 40-49 주부. 정치 성향은 중도이며 다양성, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 72, "ecoConsciousness": 56, "priceSensitivity": 57, "digitalConsumption": 51}	{"taxTolerance": 60, "governmentTrust": 33, "policyAcceptance": 44, "regulationPreference": 64, "publicServiceSatisfaction": 61}	0
3952	황정희	49	40-49	Male	경기도	37.460767	127.443306	대학교 졸	350-500만원	공무원	1인 가구	-22	진보 성향 무당층	62	{"economy": 6, "housing": 6, "welfare": 30, "security": 12, "environment": 46}	포털 뉴스	{성장,안정,자유}	경기도에 거주하는 40-49 공무원. 정치 성향은 중도이며 성장, 안정, 자유 가치를 중시한다.	{"brandLoyalty": 76, "noveltySeeking": 63, "ecoConsciousness": 45, "priceSensitivity": 67, "digitalConsumption": 62}	{"taxTolerance": 56, "governmentTrust": 51, "policyAcceptance": 48, "regulationPreference": 76, "publicServiceSatisfaction": 71}	0
3953	류지우	42	40-49	Male	경기도	37.398876	127.429501	대학교 졸	200-350만원	은퇴	1인 가구	-1	중도 무당층	71	{"economy": -17, "housing": 39, "welfare": 39, "security": -6, "environment": 19}	지상파/종편 뉴스	{안정,환경,공동체}	경기도에 거주하는 40-49 은퇴. 정치 성향은 중도이며 안정, 환경, 공동체 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 70, "ecoConsciousness": 54, "priceSensitivity": 51, "digitalConsumption": 82}	{"taxTolerance": 52, "governmentTrust": 44, "policyAcceptance": 41, "regulationPreference": 67, "publicServiceSatisfaction": 76}	0
3954	정미경	47	40-49	Male	경기도	37.44162	127.526533	대학교 졸	500-700만원	프리랜서	다세대 가구	24	보수 성향 무당층	52	{"economy": 27, "housing": -3, "welfare": -7, "security": 26, "environment": 29}	SNS	{공동체,안정,안전}	경기도에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 공동체, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 84, "ecoConsciousness": 52, "priceSensitivity": 50, "digitalConsumption": 74}	{"taxTolerance": 37, "governmentTrust": 52, "policyAcceptance": 52, "regulationPreference": 79, "publicServiceSatisfaction": 72}	0
3955	류은우	53	50-59	Female	경기도	37.407933	127.564936	대학교 졸	700만원 이상	학생	다세대 가구	-27	진보 성향 무당층	74	{"economy": -12, "housing": 39, "welfare": -10, "security": 8, "environment": 53}	유튜브	{전통,공동체,자유}	경기도에 거주하는 50-59 학생. 정치 성향은 중도이며 전통, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 71, "ecoConsciousness": 46, "priceSensitivity": 36, "digitalConsumption": 71}	{"taxTolerance": 28, "governmentTrust": 46, "policyAcceptance": 53, "regulationPreference": 79, "publicServiceSatisfaction": 66}	0
3956	정예준	53	50-59	Female	경기도	37.448306	127.485498	전문대 졸	350-500만원	은퇴	자녀 양육 가구	-9	중도 무당층	73	{"economy": -14, "housing": 10, "welfare": 30, "security": -34, "environment": 42}	유튜브	{안정,자유,성장}	경기도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 안정, 자유, 성장 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 58, "ecoConsciousness": 63, "priceSensitivity": 59, "digitalConsumption": 67}	{"taxTolerance": 48, "governmentTrust": 29, "policyAcceptance": 53, "regulationPreference": 70, "publicServiceSatisfaction": 73}	0
3957	황민서	54	50-59	Female	경기도	37.396328	127.459747	전문대 졸	350-500만원	공무원	자녀 양육 가구	-22	진보 성향 무당층	57	{"economy": -20, "housing": 2, "welfare": 41, "security": -9, "environment": 49}	유튜브	{공정,자유,성장}	경기도에 거주하는 50-59 공무원. 정치 성향은 중도이며 공정, 자유, 성장 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 56, "ecoConsciousness": 29, "priceSensitivity": 69, "digitalConsumption": 63}	{"taxTolerance": 67, "governmentTrust": 61, "policyAcceptance": 48, "regulationPreference": 74, "publicServiceSatisfaction": 67}	0
3958	조혜진	53	50-59	Female	경기도	37.3577	127.526173	대학원 졸	350-500만원	사무직	자녀 양육 가구	-14	중도 무당층	79	{"economy": -12, "housing": 21, "welfare": 31, "security": -14, "environment": 30}	지상파/종편 뉴스	{자유,전통,공정}	경기도에 거주하는 50-59 사무직. 정치 성향은 중도이며 자유, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 50, "ecoConsciousness": 57, "priceSensitivity": 66, "digitalConsumption": 55}	{"taxTolerance": 66, "governmentTrust": 38, "policyAcceptance": 36, "regulationPreference": 37, "publicServiceSatisfaction": 70}	0
3959	신지민	51	50-59	Female	경기도	37.486299	127.514811	대학원 졸	350-500만원	은퇴	1인 가구	-77	진보 정당 지지	64	{"economy": -76, "housing": 32, "welfare": 39, "security": -54, "environment": 39}	신문/팟캐스트	{다양성,공동체,전통}	경기도에 거주하는 50-59 은퇴. 정치 성향은 진보이며 다양성, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 74, "ecoConsciousness": 48, "priceSensitivity": 81, "digitalConsumption": 74}	{"taxTolerance": 45, "governmentTrust": 40, "policyAcceptance": 53, "regulationPreference": 81, "publicServiceSatisfaction": 78}	0
3960	홍경숙	52	50-59	Female	경기도	37.454277	127.453946	전문대 졸	350-500만원	학생	자녀 양육 가구	0	중도 무당층	57	{"economy": -6, "housing": 21, "welfare": 43, "security": 12, "environment": 37}	신문/팟캐스트	{성장,공동체,다양성}	경기도에 거주하는 50-59 학생. 정치 성향은 중도이며 성장, 공동체, 다양성 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 72, "ecoConsciousness": 47, "priceSensitivity": 64, "digitalConsumption": 79}	{"taxTolerance": 36, "governmentTrust": 41, "policyAcceptance": 31, "regulationPreference": 75, "publicServiceSatisfaction": 81}	0
3961	임영수	54	50-59	Female	경기도	37.398465	127.532435	대학교 졸	700만원 이상	자영업	1인 가구	-30	진보 성향 무당층	58	{"economy": -37, "housing": 22, "welfare": 25, "security": -30, "environment": 17}	포털 뉴스	{안전,전통,공동체}	경기도에 거주하는 50-59 자영업. 정치 성향은 중도이며 안전, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 54, "ecoConsciousness": 50, "priceSensitivity": 36, "digitalConsumption": 68}	{"taxTolerance": 43, "governmentTrust": 45, "policyAcceptance": 38, "regulationPreference": 78, "publicServiceSatisfaction": 80}	0
3962	임동현	59	50-59	Female	경기도	37.421089	127.490133	대학원 졸	700만원 이상	학생	1인 가구	12	중도 무당층	72	{"economy": -4, "housing": 23, "welfare": -30, "security": -6, "environment": 9}	지상파/종편 뉴스	{성장,다양성,전통}	경기도에 거주하는 50-59 학생. 정치 성향은 중도이며 성장, 다양성, 전통 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 65, "ecoConsciousness": 32, "priceSensitivity": 53, "digitalConsumption": 64}	{"taxTolerance": 59, "governmentTrust": 52, "policyAcceptance": 58, "regulationPreference": 86, "publicServiceSatisfaction": 76}	0
3963	김현우	52	50-59	Female	경기도	37.344959	127.436889	대학원 졸	200-350만원	학생	1인 가구	-66	진보 정당 지지	76	{"economy": -56, "housing": 44, "welfare": 54, "security": -19, "environment": 48}	유튜브	{전통,환경,공동체}	경기도에 거주하는 50-59 학생. 정치 성향은 진보이며 전통, 환경, 공동체 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 62, "ecoConsciousness": 51, "priceSensitivity": 79, "digitalConsumption": 78}	{"taxTolerance": 43, "governmentTrust": 40, "policyAcceptance": 50, "regulationPreference": 78, "publicServiceSatisfaction": 77}	0
3964	한동현	58	50-59	Female	경기도	37.454538	127.493583	대학교 졸	500-700만원	사무직	다세대 가구	39	보수 성향 무당층	71	{"economy": -5, "housing": 9, "welfare": -23, "security": 19, "environment": 9}	유튜브	{자유,환경,안정}	경기도에 거주하는 50-59 사무직. 정치 성향은 보수이며 자유, 환경, 안정 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 48, "ecoConsciousness": 39, "priceSensitivity": 59, "digitalConsumption": 65}	{"taxTolerance": 30, "governmentTrust": 53, "policyAcceptance": 32, "regulationPreference": 98, "publicServiceSatisfaction": 63}	0
3965	홍현우	51	50-59	Female	경기도	37.475452	127.50019	전문대 졸	350-500만원	주부	자녀 양육 가구	-1	중도 무당층	62	{"economy": -5, "housing": -2, "welfare": 20, "security": 15, "environment": -2}	SNS	{공정,공동체,자유}	경기도에 거주하는 50-59 주부. 정치 성향은 중도이며 공정, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 62, "ecoConsciousness": 58, "priceSensitivity": 61, "digitalConsumption": 83}	{"taxTolerance": 34, "governmentTrust": 63, "policyAcceptance": 51, "regulationPreference": 55, "publicServiceSatisfaction": 51}	0
3966	김준서	50	50-59	Female	경기도	37.339285	127.446509	전문대 졸	500-700만원	은퇴	부부 가구	-20	진보 성향 무당층	66	{"economy": -5, "housing": 6, "welfare": 14, "security": -9, "environment": 32}	유튜브	{공동체,혁신,안정}	경기도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 공동체, 혁신, 안정 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 59, "ecoConsciousness": 65, "priceSensitivity": 50, "digitalConsumption": 62}	{"taxTolerance": 44, "governmentTrust": 42, "policyAcceptance": 84, "regulationPreference": 79, "publicServiceSatisfaction": 75}	0
3967	전하은	55	50-59	Female	경기도	37.344165	127.461431	전문대 졸	350-500만원	은퇴	자녀 양육 가구	-2	중도 무당층	89	{"economy": 11, "housing": 25, "welfare": 29, "security": -31, "environment": 14}	SNS	{공정,안정,환경}	경기도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 공정, 안정, 환경 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 43, "ecoConsciousness": 45, "priceSensitivity": 58, "digitalConsumption": 68}	{"taxTolerance": 37, "governmentTrust": 48, "policyAcceptance": 70, "regulationPreference": 52, "publicServiceSatisfaction": 59}	0
3968	오광수	52	50-59	Female	경기도	37.384904	127.597896	전문대 졸	500-700만원	생산직	다세대 가구	-42	진보 성향 무당층	86	{"economy": -43, "housing": 24, "welfare": 2, "security": -31, "environment": 19}	SNS	{전통,공정,자유}	경기도에 거주하는 50-59 생산직. 정치 성향은 진보이며 전통, 공정, 자유 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 51, "ecoConsciousness": 33, "priceSensitivity": 52, "digitalConsumption": 59}	{"taxTolerance": 42, "governmentTrust": 47, "policyAcceptance": 28, "regulationPreference": 59, "publicServiceSatisfaction": 64}	0
3969	임지민	58	50-59	Female	경기도	37.38739	127.571588	대학원 졸	200-350만원	주부	부부 가구	-5	중도 무당층	86	{"economy": -4, "housing": 18, "welfare": 7, "security": 26, "environment": 5}	SNS	{자유,공동체,전통}	경기도에 거주하는 50-59 주부. 정치 성향은 중도이며 자유, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 16, "noveltySeeking": 63, "ecoConsciousness": 66, "priceSensitivity": 59, "digitalConsumption": 71}	{"taxTolerance": 57, "governmentTrust": 62, "policyAcceptance": 44, "regulationPreference": 64, "publicServiceSatisfaction": 74}	0
3970	권서연	53	50-59	Female	경기도	37.486403	127.591464	전문대 졸	700만원 이상	프리랜서	부부 가구	-34	진보 성향 무당층	88	{"economy": -41, "housing": 42, "welfare": 56, "security": -10, "environment": 35}	SNS	{공정,자유,안전}	경기도에 거주하는 50-59 프리랜서. 정치 성향은 진보이며 공정, 자유, 안전 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 50, "ecoConsciousness": 49, "priceSensitivity": 50, "digitalConsumption": 58}	{"taxTolerance": 60, "governmentTrust": 47, "policyAcceptance": 58, "regulationPreference": 58, "publicServiceSatisfaction": 86}	0
3971	안현우	54	50-59	Female	경기도	37.492617	127.492079	전문대 졸	700만원 이상	서비스직	1인 가구	-11	중도 무당층	81	{"economy": 25, "housing": 9, "welfare": 36, "security": -24, "environment": 3}	지상파/종편 뉴스	{자유,공동체,안전}	경기도에 거주하는 50-59 서비스직. 정치 성향은 중도이며 자유, 공동체, 안전 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 79, "ecoConsciousness": 51, "priceSensitivity": 55, "digitalConsumption": 62}	{"taxTolerance": 64, "governmentTrust": 44, "policyAcceptance": 63, "regulationPreference": 70, "publicServiceSatisfaction": 60}	0
3972	박건우	54	50-59	Female	경기도	37.431828	127.557186	대학교 졸	500-700만원	은퇴	자녀 양육 가구	-10	중도 무당층	62	{"economy": -16, "housing": 16, "welfare": 38, "security": 30, "environment": 18}	신문/팟캐스트	{공정,성장,공동체}	경기도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 공정, 성장, 공동체 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 62, "ecoConsciousness": 58, "priceSensitivity": 53, "digitalConsumption": 79}	{"taxTolerance": 56, "governmentTrust": 31, "policyAcceptance": 47, "regulationPreference": 68, "publicServiceSatisfaction": 60}	0
3973	서은우	51	50-59	Female	경기도	37.485003	127.46341	대학원 졸	350-500만원	주부	1인 가구	-47	진보 정당 지지	66	{"economy": -30, "housing": 26, "welfare": 20, "security": -24, "environment": 71}	신문/팟캐스트	{전통,성장,혁신}	경기도에 거주하는 50-59 주부. 정치 성향은 진보이며 전통, 성장, 혁신 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 70, "ecoConsciousness": 41, "priceSensitivity": 58, "digitalConsumption": 68}	{"taxTolerance": 50, "governmentTrust": 67, "policyAcceptance": 36, "regulationPreference": 50, "publicServiceSatisfaction": 50}	0
3974	류서연	50	50-59	Female	경기도	37.48506	127.590122	전문대 졸	200-350만원	생산직	부부 가구	33	보수 성향 무당층	67	{"economy": 25, "housing": 0, "welfare": 8, "security": 37, "environment": 10}	SNS	{안정,공동체,자유}	경기도에 거주하는 50-59 생산직. 정치 성향은 중도이며 안정, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 40, "ecoConsciousness": 46, "priceSensitivity": 62, "digitalConsumption": 56}	{"taxTolerance": 63, "governmentTrust": 63, "policyAcceptance": 52, "regulationPreference": 67, "publicServiceSatisfaction": 89}	0
3975	한은우	56	50-59	Female	경기도	37.44025	127.571069	대학교 졸	350-500만원	학생	다세대 가구	-57	진보 정당 지지	63	{"economy": -22, "housing": 21, "welfare": 16, "security": -24, "environment": 35}	SNS	{다양성,환경,전통}	경기도에 거주하는 50-59 학생. 정치 성향은 진보이며 다양성, 환경, 전통 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 69, "ecoConsciousness": 63, "priceSensitivity": 67, "digitalConsumption": 71}	{"taxTolerance": 46, "governmentTrust": 49, "policyAcceptance": 58, "regulationPreference": 76, "publicServiceSatisfaction": 89}	0
3976	오지우	58	50-59	Male	경기도	37.349036	127.422623	대학교 졸	200만원 미만	사무직	부부 가구	13	중도 무당층	86	{"economy": 20, "housing": -18, "welfare": -12, "security": -10, "environment": 21}	유튜브	{성장,안전,다양성}	경기도에 거주하는 50-59 사무직. 정치 성향은 중도이며 성장, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 52, "ecoConsciousness": 43, "priceSensitivity": 75, "digitalConsumption": 54}	{"taxTolerance": 59, "governmentTrust": 71, "policyAcceptance": 67, "regulationPreference": 63, "publicServiceSatisfaction": 78}	0
3977	전지우	58	50-59	Male	경기도	37.444105	127.554085	전문대 졸	350-500만원	생산직	자녀 양육 가구	-12	중도 무당층	93	{"economy": -10, "housing": 28, "welfare": 12, "security": -9, "environment": -5}	신문/팟캐스트	{안정,전통,안전}	경기도에 거주하는 50-59 생산직. 정치 성향은 중도이며 안정, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 67, "ecoConsciousness": 24, "priceSensitivity": 56, "digitalConsumption": 54}	{"taxTolerance": 32, "governmentTrust": 41, "policyAcceptance": 48, "regulationPreference": 65, "publicServiceSatisfaction": 51}	0
3978	박철수	50	50-59	Male	경기도	37.396668	127.550894	고졸 이하	500-700만원	은퇴	자녀 양육 가구	-2	중도 무당층	69	{"economy": 2, "housing": 2, "welfare": 31, "security": -9, "environment": 9}	포털 뉴스	{혁신,자유,공정}	경기도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 혁신, 자유, 공정 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 59, "ecoConsciousness": 41, "priceSensitivity": 64, "digitalConsumption": 66}	{"taxTolerance": 42, "governmentTrust": 58, "policyAcceptance": 56, "regulationPreference": 58, "publicServiceSatisfaction": 51}	0
3979	조준서	59	50-59	Male	경기도	37.435063	127.577862	대학원 졸	500-700만원	프리랜서	부부 가구	41	보수 성향 무당층	78	{"economy": 6, "housing": -2, "welfare": 10, "security": 26, "environment": 6}	유튜브	{자유,성장,공정}	경기도에 거주하는 50-59 프리랜서. 정치 성향은 보수이며 자유, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 65, "noveltySeeking": 61, "ecoConsciousness": 54, "priceSensitivity": 52, "digitalConsumption": 73}	{"taxTolerance": 50, "governmentTrust": 43, "policyAcceptance": 73, "regulationPreference": 65, "publicServiceSatisfaction": 67}	0
3980	송지호	59	50-59	Male	경기도	37.343862	127.423782	전문대 졸	350-500만원	은퇴	자녀 양육 가구	-4	중도 무당층	73	{"economy": -21, "housing": 25, "welfare": 5, "security": -7, "environment": 24}	신문/팟캐스트	{혁신,안정,안전}	경기도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 혁신, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 72, "ecoConsciousness": 50, "priceSensitivity": 62, "digitalConsumption": 49}	{"taxTolerance": 52, "governmentTrust": 55, "policyAcceptance": 57, "regulationPreference": 55, "publicServiceSatisfaction": 83}	0
3981	오예준	54	50-59	Male	경기도	37.390228	127.438143	고졸 이하	350-500만원	은퇴	1인 가구	-29	진보 성향 무당층	77	{"economy": -18, "housing": -1, "welfare": 39, "security": -9, "environment": 43}	유튜브	{환경,다양성,전통}	경기도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 환경, 다양성, 전통 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 49, "ecoConsciousness": 46, "priceSensitivity": 58, "digitalConsumption": 62}	{"taxTolerance": 39, "governmentTrust": 52, "policyAcceptance": 42, "regulationPreference": 49, "publicServiceSatisfaction": 69}	0
3982	최서연	58	50-59	Male	경기도	37.383322	127.477799	대학교 졸	200만원 미만	프리랜서	1인 가구	-14	중도 무당층	69	{"economy": 1, "housing": -5, "welfare": 31, "security": 24, "environment": 35}	유튜브	{공정,안전,전통}	경기도에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 공정, 안전, 전통 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 69, "ecoConsciousness": 42, "priceSensitivity": 86, "digitalConsumption": 68}	{"taxTolerance": 57, "governmentTrust": 65, "policyAcceptance": 59, "regulationPreference": 61, "publicServiceSatisfaction": 54}	0
3983	최현우	55	50-59	Male	경기도	37.488373	127.463479	대학교 졸	700만원 이상	전문직	1인 가구	-15	진보 성향 무당층	96	{"economy": -28, "housing": 33, "welfare": 30, "security": 6, "environment": 33}	포털 뉴스	{안전,안정,혁신}	경기도에 거주하는 50-59 전문직. 정치 성향은 중도이며 안전, 안정, 혁신 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 77, "ecoConsciousness": 47, "priceSensitivity": 38, "digitalConsumption": 49}	{"taxTolerance": 47, "governmentTrust": 59, "policyAcceptance": 36, "regulationPreference": 76, "publicServiceSatisfaction": 73}	0
3984	한도윤	51	50-59	Male	경기도	37.375079	127.611278	대학교 졸	500-700만원	자영업	부부 가구	-18	진보 성향 무당층	82	{"economy": 14, "housing": 11, "welfare": 40, "security": -6, "environment": 41}	유튜브	{안전,공정,안정}	경기도에 거주하는 50-59 자영업. 정치 성향은 중도이며 안전, 공정, 안정 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 55, "ecoConsciousness": 41, "priceSensitivity": 47, "digitalConsumption": 77}	{"taxTolerance": 39, "governmentTrust": 38, "policyAcceptance": 42, "regulationPreference": 62, "publicServiceSatisfaction": 62}	0
3985	안현우	59	50-59	Male	경기도	37.40657	127.494791	고졸 이하	700만원 이상	프리랜서	1인 가구	3	중도 무당층	78	{"economy": -9, "housing": 9, "welfare": -8, "security": -5, "environment": 31}	포털 뉴스	{혁신,공동체,전통}	경기도에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 혁신, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 49, "ecoConsciousness": 51, "priceSensitivity": 39, "digitalConsumption": 57}	{"taxTolerance": 43, "governmentTrust": 47, "policyAcceptance": 58, "regulationPreference": 70, "publicServiceSatisfaction": 83}	0
3986	홍채원	55	50-59	Male	경기도	37.452123	127.540724	고졸 이하	200만원 미만	주부	자녀 양육 가구	-51	진보 정당 지지	69	{"economy": -45, "housing": 18, "welfare": 63, "security": -29, "environment": 55}	SNS	{환경,전통,안정}	경기도에 거주하는 50-59 주부. 정치 성향은 진보이며 환경, 전통, 안정 가치를 중시한다.	{"brandLoyalty": 66, "noveltySeeking": 62, "ecoConsciousness": 48, "priceSensitivity": 67, "digitalConsumption": 64}	{"taxTolerance": 41, "governmentTrust": 57, "policyAcceptance": 66, "regulationPreference": 63, "publicServiceSatisfaction": 59}	0
3987	윤순자	54	50-59	Male	경기도	37.391525	127.481084	대학교 졸	500-700만원	서비스직	다세대 가구	-23	진보 성향 무당층	88	{"economy": -5, "housing": 36, "welfare": 23, "security": -33, "environment": 57}	SNS	{공정,환경,자유}	경기도에 거주하는 50-59 서비스직. 정치 성향은 중도이며 공정, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 65, "ecoConsciousness": 60, "priceSensitivity": 57, "digitalConsumption": 67}	{"taxTolerance": 58, "governmentTrust": 37, "policyAcceptance": 68, "regulationPreference": 80, "publicServiceSatisfaction": 81}	0
3988	류다은	58	50-59	Male	경기도	37.434752	127.456158	대학교 졸	700만원 이상	은퇴	다세대 가구	-24	진보 성향 무당층	74	{"economy": -20, "housing": 30, "welfare": 29, "security": 49, "environment": 35}	포털 뉴스	{다양성,환경,공동체}	경기도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 다양성, 환경, 공동체 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 57, "ecoConsciousness": 64, "priceSensitivity": 49, "digitalConsumption": 63}	{"taxTolerance": 47, "governmentTrust": 50, "policyAcceptance": 44, "regulationPreference": 69, "publicServiceSatisfaction": 64}	0
3989	서동현	59	50-59	Male	경기도	37.342306	127.424059	전문대 졸	500-700만원	은퇴	자녀 양육 가구	-26	진보 성향 무당층	96	{"economy": -41, "housing": 34, "welfare": 22, "security": -2, "environment": 17}	지상파/종편 뉴스	{전통,다양성,성장}	경기도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 전통, 다양성, 성장 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 52, "ecoConsciousness": 54, "priceSensitivity": 47, "digitalConsumption": 50}	{"taxTolerance": 55, "governmentTrust": 82, "policyAcceptance": 71, "regulationPreference": 53, "publicServiceSatisfaction": 67}	0
3990	윤채원	57	50-59	Male	경기도	37.400758	127.428068	전문대 졸	700만원 이상	생산직	다세대 가구	28	보수 성향 무당층	67	{"economy": 18, "housing": 16, "welfare": -7, "security": 24, "environment": -22}	포털 뉴스	{성장,혁신,안전}	경기도에 거주하는 50-59 생산직. 정치 성향은 중도이며 성장, 혁신, 안전 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 47, "ecoConsciousness": 53, "priceSensitivity": 40, "digitalConsumption": 54}	{"taxTolerance": 53, "governmentTrust": 28, "policyAcceptance": 62, "regulationPreference": 73, "publicServiceSatisfaction": 71}	0
3991	박순자	59	50-59	Male	경기도	37.45792	127.603698	전문대 졸	200-350만원	사무직	다세대 가구	-6	중도 무당층	62	{"economy": -11, "housing": 12, "welfare": 29, "security": -8, "environment": 7}	SNS	{전통,성장,공동체}	경기도에 거주하는 50-59 사무직. 정치 성향은 중도이며 전통, 성장, 공동체 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 44, "ecoConsciousness": 67, "priceSensitivity": 38, "digitalConsumption": 71}	{"taxTolerance": 40, "governmentTrust": 53, "policyAcceptance": 50, "regulationPreference": 75, "publicServiceSatisfaction": 53}	0
3992	홍건우	54	50-59	Male	경기도	37.461554	127.584182	대학원 졸	200만원 미만	자영업	1인 가구	-37	진보 성향 무당층	68	{"economy": -27, "housing": 24, "welfare": 45, "security": -34, "environment": 38}	신문/팟캐스트	{공정,안전,성장}	경기도에 거주하는 50-59 자영업. 정치 성향은 진보이며 공정, 안전, 성장 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 54, "ecoConsciousness": 39, "priceSensitivity": 72, "digitalConsumption": 74}	{"taxTolerance": 61, "governmentTrust": 50, "policyAcceptance": 49, "regulationPreference": 67, "publicServiceSatisfaction": 70}	0
3993	임순자	54	50-59	Male	경기도	37.490426	127.550816	전문대 졸	350-500만원	주부	다세대 가구	16	보수 성향 무당층	68	{"economy": -17, "housing": 16, "welfare": 25, "security": 27, "environment": 16}	유튜브	{다양성,혁신,안전}	경기도에 거주하는 50-59 주부. 정치 성향은 중도이며 다양성, 혁신, 안전 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 59, "ecoConsciousness": 56, "priceSensitivity": 52, "digitalConsumption": 71}	{"taxTolerance": 41, "governmentTrust": 47, "policyAcceptance": 44, "regulationPreference": 78, "publicServiceSatisfaction": 73}	0
3994	홍주원	51	50-59	Male	경기도	37.340616	127.436844	전문대 졸	350-500만원	은퇴	부부 가구	-18	진보 성향 무당층	49	{"economy": -35, "housing": 41, "welfare": 22, "security": 14, "environment": 12}	유튜브	{다양성,공동체,성장}	경기도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 다양성, 공동체, 성장 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 72, "ecoConsciousness": 30, "priceSensitivity": 67, "digitalConsumption": 65}	{"taxTolerance": 50, "governmentTrust": 46, "policyAcceptance": 51, "regulationPreference": 39, "publicServiceSatisfaction": 69}	0
3995	박경숙	56	50-59	Male	경기도	37.456783	127.479366	전문대 졸	350-500만원	공무원	다세대 가구	22	보수 성향 무당층	66	{"economy": -9, "housing": 4, "welfare": -26, "security": 5, "environment": 26}	지상파/종편 뉴스	{자유,공정,환경}	경기도에 거주하는 50-59 공무원. 정치 성향은 중도이며 자유, 공정, 환경 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 65, "ecoConsciousness": 57, "priceSensitivity": 49, "digitalConsumption": 61}	{"taxTolerance": 56, "governmentTrust": 52, "policyAcceptance": 62, "regulationPreference": 59, "publicServiceSatisfaction": 67}	0
3996	최지아	56	50-59	Male	경기도	37.470847	127.469914	대학원 졸	350-500만원	서비스직	1인 가구	37	보수 성향 무당층	78	{"economy": 8, "housing": -29, "welfare": -6, "security": 31, "environment": 15}	지상파/종편 뉴스	{공동체,안정,자유}	경기도에 거주하는 50-59 서비스직. 정치 성향은 보수이며 공동체, 안정, 자유 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 51, "ecoConsciousness": 59, "priceSensitivity": 51, "digitalConsumption": 59}	{"taxTolerance": 40, "governmentTrust": 46, "policyAcceptance": 44, "regulationPreference": 56, "publicServiceSatisfaction": 70}	0
3997	안하은	62	60-69	Female	경기도	37.476904	127.527969	대학교 졸	500-700만원	자영업	자녀 양육 가구	-27	진보 성향 무당층	96	{"economy": -55, "housing": 3, "welfare": 19, "security": -12, "environment": 37}	포털 뉴스	{자유,다양성,혁신}	경기도에 거주하는 60-69 자영업. 정치 성향은 중도이며 자유, 다양성, 혁신 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 73, "ecoConsciousness": 53, "priceSensitivity": 55, "digitalConsumption": 63}	{"taxTolerance": 67, "governmentTrust": 50, "policyAcceptance": 40, "regulationPreference": 81, "publicServiceSatisfaction": 39}	0
3998	강은우	60	60-69	Female	경기도	37.427852	127.500524	고졸 이하	700만원 이상	공무원	1인 가구	-3	중도 무당층	74	{"economy": 10, "housing": 6, "welfare": 16, "security": -17, "environment": 20}	포털 뉴스	{안정,다양성,혁신}	경기도에 거주하는 60-69 공무원. 정치 성향은 중도이며 안정, 다양성, 혁신 가치를 중시한다.	{"brandLoyalty": 65, "noveltySeeking": 46, "ecoConsciousness": 36, "priceSensitivity": 52, "digitalConsumption": 65}	{"taxTolerance": 43, "governmentTrust": 59, "policyAcceptance": 67, "regulationPreference": 47, "publicServiceSatisfaction": 64}	0
3999	강지아	68	60-69	Female	경기도	37.38117	127.475214	전문대 졸	350-500만원	은퇴	부부 가구	-10	중도 무당층	58	{"economy": -16, "housing": 39, "welfare": 10, "security": -12, "environment": 39}	SNS	{안정,자유,안전}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 안정, 자유, 안전 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 56, "ecoConsciousness": 48, "priceSensitivity": 59, "digitalConsumption": 49}	{"taxTolerance": 46, "governmentTrust": 51, "policyAcceptance": 77, "regulationPreference": 65, "publicServiceSatisfaction": 63}	0
4000	안서윤	69	60-69	Female	경기도	37.379947	127.457623	전문대 졸	200-350만원	은퇴	부부 가구	-4	중도 무당층	75	{"economy": 9, "housing": 40, "welfare": 23, "security": 37, "environment": -4}	포털 뉴스	{다양성,안전,공동체}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 다양성, 안전, 공동체 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 52, "ecoConsciousness": 37, "priceSensitivity": 81, "digitalConsumption": 69}	{"taxTolerance": 37, "governmentTrust": 49, "policyAcceptance": 50, "regulationPreference": 84, "publicServiceSatisfaction": 66}	0
4001	한민준	65	60-69	Female	경기도	37.487513	127.46956	대학교 졸	500-700만원	학생	자녀 양육 가구	41	보수 성향 무당층	82	{"economy": 23, "housing": 21, "welfare": 11, "security": 22, "environment": -5}	유튜브	{성장,안정,공정}	경기도에 거주하는 60-69 학생. 정치 성향은 보수이며 성장, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 62, "ecoConsciousness": 62, "priceSensitivity": 64, "digitalConsumption": 44}	{"taxTolerance": 61, "governmentTrust": 53, "policyAcceptance": 31, "regulationPreference": 61, "publicServiceSatisfaction": 55}	0
4002	안지호	63	60-69	Female	경기도	37.355211	127.589281	전문대 졸	200-350만원	전문직	자녀 양육 가구	25	보수 성향 무당층	65	{"economy": 2, "housing": -4, "welfare": 18, "security": 1, "environment": 4}	포털 뉴스	{공동체,자유,다양성}	경기도에 거주하는 60-69 전문직. 정치 성향은 중도이며 공동체, 자유, 다양성 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 53, "ecoConsciousness": 61, "priceSensitivity": 53, "digitalConsumption": 56}	{"taxTolerance": 56, "governmentTrust": 53, "policyAcceptance": 41, "regulationPreference": 71, "publicServiceSatisfaction": 68}	0
4003	신지호	67	60-69	Female	경기도	37.464147	127.591595	대학교 졸	500-700만원	은퇴	자녀 양육 가구	40	보수 성향 무당층	88	{"economy": 34, "housing": 16, "welfare": -14, "security": 19, "environment": 30}	신문/팟캐스트	{혁신,전통,공동체}	경기도에 거주하는 60-69 은퇴. 정치 성향은 보수이며 혁신, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 58, "ecoConsciousness": 56, "priceSensitivity": 51, "digitalConsumption": 52}	{"taxTolerance": 53, "governmentTrust": 66, "policyAcceptance": 50, "regulationPreference": 66, "publicServiceSatisfaction": 51}	0
4004	정준서	67	60-69	Female	경기도	37.4374	127.613513	대학원 졸	350-500만원	은퇴	자녀 양육 가구	12	중도 무당층	72	{"economy": 7, "housing": 6, "welfare": -7, "security": -9, "environment": 2}	지상파/종편 뉴스	{공동체,전통,환경}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 공동체, 전통, 환경 가치를 중시한다.	{"brandLoyalty": 68, "noveltySeeking": 40, "ecoConsciousness": 57, "priceSensitivity": 70, "digitalConsumption": 68}	{"taxTolerance": 48, "governmentTrust": 53, "policyAcceptance": 37, "regulationPreference": 77, "publicServiceSatisfaction": 54}	0
4005	최도윤	69	60-69	Female	경기도	37.477326	127.517369	대학교 졸	500-700만원	은퇴	다세대 가구	18	보수 성향 무당층	83	{"economy": 19, "housing": 24, "welfare": 13, "security": -14, "environment": 14}	유튜브	{성장,혁신,다양성}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 성장, 혁신, 다양성 가치를 중시한다.	{"brandLoyalty": 72, "noveltySeeking": 44, "ecoConsciousness": 55, "priceSensitivity": 65, "digitalConsumption": 38}	{"taxTolerance": 58, "governmentTrust": 41, "policyAcceptance": 54, "regulationPreference": 52, "publicServiceSatisfaction": 62}	0
4006	박지호	64	60-69	Female	경기도	37.354058	127.474876	고졸 이하	350-500만원	사무직	1인 가구	-4	중도 무당층	74	{"economy": -20, "housing": 14, "welfare": 33, "security": -6, "environment": 41}	신문/팟캐스트	{안전,전통,안정}	경기도에 거주하는 60-69 사무직. 정치 성향은 중도이며 안전, 전통, 안정 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 51, "ecoConsciousness": 46, "priceSensitivity": 73, "digitalConsumption": 53}	{"taxTolerance": 44, "governmentTrust": 47, "policyAcceptance": 52, "regulationPreference": 78, "publicServiceSatisfaction": 60}	0
4007	전건우	63	60-69	Female	경기도	37.388934	127.47991	전문대 졸	200-350만원	전문직	부부 가구	8	중도 무당층	66	{"economy": -7, "housing": 45, "welfare": 14, "security": 20, "environment": 42}	포털 뉴스	{전통,안정,혁신}	경기도에 거주하는 60-69 전문직. 정치 성향은 중도이며 전통, 안정, 혁신 가치를 중시한다.	{"brandLoyalty": 71, "noveltySeeking": 54, "ecoConsciousness": 39, "priceSensitivity": 69, "digitalConsumption": 61}	{"taxTolerance": 52, "governmentTrust": 54, "policyAcceptance": 60, "regulationPreference": 78, "publicServiceSatisfaction": 71}	0
4008	권준서	68	60-69	Female	경기도	37.421536	127.510193	전문대 졸	200-350만원	은퇴	자녀 양육 가구	35	보수 성향 무당층	66	{"economy": 35, "housing": -13, "welfare": 27, "security": 29, "environment": 19}	유튜브	{자유,전통,혁신}	경기도에 거주하는 60-69 은퇴. 정치 성향은 보수이며 자유, 전통, 혁신 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 41, "ecoConsciousness": 41, "priceSensitivity": 71, "digitalConsumption": 53}	{"taxTolerance": 34, "governmentTrust": 79, "policyAcceptance": 65, "regulationPreference": 73, "publicServiceSatisfaction": 72}	0
4009	한미경	69	60-69	Female	경기도	37.484773	127.573373	대학교 졸	200만원 미만	은퇴	다세대 가구	0	중도 무당층	87	{"economy": 4, "housing": 19, "welfare": 12, "security": -7, "environment": 37}	포털 뉴스	{환경,자유,안전}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 환경, 자유, 안전 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 69, "ecoConsciousness": 45, "priceSensitivity": 83, "digitalConsumption": 60}	{"taxTolerance": 46, "governmentTrust": 41, "policyAcceptance": 51, "regulationPreference": 84, "publicServiceSatisfaction": 59}	0
4010	정서연	61	60-69	Female	경기도	37.464882	127.476791	대학원 졸	200만원 미만	주부	다세대 가구	30	보수 성향 무당층	80	{"economy": 4, "housing": 15, "welfare": 12, "security": 35, "environment": -13}	SNS	{다양성,전통,환경}	경기도에 거주하는 60-69 주부. 정치 성향은 중도이며 다양성, 전통, 환경 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 53, "ecoConsciousness": 45, "priceSensitivity": 65, "digitalConsumption": 60}	{"taxTolerance": 43, "governmentTrust": 55, "policyAcceptance": 59, "regulationPreference": 78, "publicServiceSatisfaction": 61}	0
4011	강서연	61	60-69	Female	경기도	37.380267	127.502259	대학원 졸	200-350만원	서비스직	자녀 양육 가구	-9	중도 무당층	89	{"economy": -7, "housing": 34, "welfare": 7, "security": 8, "environment": 56}	포털 뉴스	{공동체,자유,성장}	경기도에 거주하는 60-69 서비스직. 정치 성향은 중도이며 공동체, 자유, 성장 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 54, "ecoConsciousness": 59, "priceSensitivity": 96, "digitalConsumption": 74}	{"taxTolerance": 64, "governmentTrust": 51, "policyAcceptance": 42, "regulationPreference": 77, "publicServiceSatisfaction": 69}	0
4012	임미경	67	60-69	Female	경기도	37.445786	127.481379	대학교 졸	350-500만원	은퇴	다세대 가구	-27	진보 성향 무당층	72	{"economy": -28, "housing": 4, "welfare": 43, "security": 27, "environment": 60}	SNS	{환경,공정,다양성}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 환경, 공정, 다양성 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 44, "ecoConsciousness": 34, "priceSensitivity": 53, "digitalConsumption": 50}	{"taxTolerance": 54, "governmentTrust": 53, "policyAcceptance": 59, "regulationPreference": 61, "publicServiceSatisfaction": 63}	0
4013	정예준	67	60-69	Female	경기도	37.433839	127.456566	대학원 졸	350-500만원	은퇴	1인 가구	20	보수 성향 무당층	96	{"economy": 18, "housing": 21, "welfare": -5, "security": 50, "environment": 39}	유튜브	{안정,공동체,전통}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 안정, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 53, "ecoConsciousness": 59, "priceSensitivity": 73, "digitalConsumption": 62}	{"taxTolerance": 47, "governmentTrust": 50, "policyAcceptance": 55, "regulationPreference": 65, "publicServiceSatisfaction": 64}	0
4014	윤영수	69	60-69	Female	경기도	37.445729	127.532206	전문대 졸	200만원 미만	은퇴	부부 가구	-8	중도 무당층	74	{"economy": -11, "housing": 17, "welfare": 44, "security": 13, "environment": 22}	SNS	{공정,성장,공동체}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 공정, 성장, 공동체 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 49, "ecoConsciousness": 36, "priceSensitivity": 90, "digitalConsumption": 49}	{"taxTolerance": 30, "governmentTrust": 24, "policyAcceptance": 56, "regulationPreference": 46, "publicServiceSatisfaction": 52}	0
4015	정서윤	66	60-69	Male	경기도	37.355658	127.442758	전문대 졸	350-500만원	공무원	자녀 양육 가구	-25	진보 성향 무당층	55	{"economy": -37, "housing": 5, "welfare": 43, "security": -18, "environment": 36}	신문/팟캐스트	{공정,전통,다양성}	경기도에 거주하는 60-69 공무원. 정치 성향은 중도이며 공정, 전통, 다양성 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 41, "ecoConsciousness": 39, "priceSensitivity": 72, "digitalConsumption": 64}	{"taxTolerance": 43, "governmentTrust": 41, "policyAcceptance": 48, "regulationPreference": 70, "publicServiceSatisfaction": 82}	0
4016	정현우	66	60-69	Male	경기도	37.389138	127.44432	고졸 이하	700만원 이상	학생	자녀 양육 가구	1	중도 무당층	81	{"economy": -48, "housing": 9, "welfare": -7, "security": 3, "environment": 15}	신문/팟캐스트	{성장,공정,환경}	경기도에 거주하는 60-69 학생. 정치 성향은 중도이며 성장, 공정, 환경 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 47, "ecoConsciousness": 11, "priceSensitivity": 38, "digitalConsumption": 65}	{"taxTolerance": 46, "governmentTrust": 48, "policyAcceptance": 67, "regulationPreference": 59, "publicServiceSatisfaction": 72}	0
4017	최광수	61	60-69	Male	경기도	37.400021	127.503031	대학교 졸	700만원 이상	주부	1인 가구	-18	진보 성향 무당층	86	{"economy": -20, "housing": 31, "welfare": 24, "security": -12, "environment": 26}	SNS	{안정,전통,다양성}	경기도에 거주하는 60-69 주부. 정치 성향은 중도이며 안정, 전통, 다양성 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 70, "ecoConsciousness": 53, "priceSensitivity": 50, "digitalConsumption": 56}	{"taxTolerance": 47, "governmentTrust": 71, "policyAcceptance": 49, "regulationPreference": 54, "publicServiceSatisfaction": 72}	0
4018	정민서	64	60-69	Male	경기도	37.422208	127.476957	전문대 졸	700만원 이상	사무직	다세대 가구	-10	중도 무당층	97	{"economy": -11, "housing": 11, "welfare": 18, "security": -21, "environment": 42}	지상파/종편 뉴스	{혁신,환경,공정}	경기도에 거주하는 60-69 사무직. 정치 성향은 중도이며 혁신, 환경, 공정 가치를 중시한다.	{"brandLoyalty": 61, "noveltySeeking": 50, "ecoConsciousness": 48, "priceSensitivity": 57, "digitalConsumption": 66}	{"taxTolerance": 43, "governmentTrust": 41, "policyAcceptance": 61, "regulationPreference": 79, "publicServiceSatisfaction": 56}	0
4019	안미경	60	60-69	Male	경기도	37.394315	127.481741	고졸 이하	200-350만원	자영업	자녀 양육 가구	-2	중도 무당층	97	{"economy": -2, "housing": 16, "welfare": 21, "security": 6, "environment": 15}	유튜브	{자유,환경,공정}	경기도에 거주하는 60-69 자영업. 정치 성향은 중도이며 자유, 환경, 공정 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 36, "ecoConsciousness": 34, "priceSensitivity": 55, "digitalConsumption": 56}	{"taxTolerance": 35, "governmentTrust": 50, "policyAcceptance": 57, "regulationPreference": 83, "publicServiceSatisfaction": 73}	0
4020	류정희	62	60-69	Male	경기도	37.33962	127.43122	전문대 졸	200만원 미만	생산직	부부 가구	33	보수 성향 무당층	74	{"economy": 7, "housing": 10, "welfare": -6, "security": 28, "environment": 10}	포털 뉴스	{안전,성장,안정}	경기도에 거주하는 60-69 생산직. 정치 성향은 중도이며 안전, 성장, 안정 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 57, "ecoConsciousness": 43, "priceSensitivity": 71, "digitalConsumption": 74}	{"taxTolerance": 49, "governmentTrust": 26, "policyAcceptance": 38, "regulationPreference": 69, "publicServiceSatisfaction": 63}	0
4021	조지민	63	60-69	Male	경기도	37.393162	127.503454	대학교 졸	700만원 이상	자영업	부부 가구	-21	진보 성향 무당층	77	{"economy": -13, "housing": 16, "welfare": 27, "security": 4, "environment": -2}	SNS	{다양성,안정,공정}	경기도에 거주하는 60-69 자영업. 정치 성향은 중도이며 다양성, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 61, "ecoConsciousness": 52, "priceSensitivity": 72, "digitalConsumption": 66}	{"taxTolerance": 57, "governmentTrust": 49, "policyAcceptance": 33, "regulationPreference": 77, "publicServiceSatisfaction": 59}	0
4022	한서윤	68	60-69	Male	경기도	37.437665	127.453889	대학교 졸	500-700만원	은퇴	자녀 양육 가구	26	보수 성향 무당층	87	{"economy": 24, "housing": 16, "welfare": -10, "security": 13, "environment": 27}	포털 뉴스	{안전,안정,혁신}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 안전, 안정, 혁신 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 38, "ecoConsciousness": 43, "priceSensitivity": 69, "digitalConsumption": 38}	{"taxTolerance": 54, "governmentTrust": 44, "policyAcceptance": 44, "regulationPreference": 73, "publicServiceSatisfaction": 78}	0
4023	류광수	69	60-69	Male	경기도	37.442564	127.428532	대학원 졸	350-500만원	은퇴	1인 가구	43	보수 성향 무당층	71	{"economy": 32, "housing": -20, "welfare": -9, "security": 34, "environment": 22}	신문/팟캐스트	{성장,환경,전통}	경기도에 거주하는 60-69 은퇴. 정치 성향은 보수이며 성장, 환경, 전통 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 67, "ecoConsciousness": 33, "priceSensitivity": 74, "digitalConsumption": 51}	{"taxTolerance": 41, "governmentTrust": 59, "policyAcceptance": 78, "regulationPreference": 80, "publicServiceSatisfaction": 71}	0
4024	안서연	60	60-69	Male	경기도	37.337766	127.542352	대학원 졸	350-500만원	서비스직	자녀 양육 가구	27	보수 성향 무당층	70	{"economy": 20, "housing": 13, "welfare": 8, "security": 8, "environment": 35}	신문/팟캐스트	{공동체,혁신,환경}	경기도에 거주하는 60-69 서비스직. 정치 성향은 중도이며 공동체, 혁신, 환경 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 48, "ecoConsciousness": 47, "priceSensitivity": 71, "digitalConsumption": 75}	{"taxTolerance": 46, "governmentTrust": 28, "policyAcceptance": 62, "regulationPreference": 59, "publicServiceSatisfaction": 68}	0
4025	권민서	69	60-69	Male	경기도	37.491748	127.537758	대학원 졸	350-500만원	은퇴	1인 가구	21	보수 성향 무당층	79	{"economy": 32, "housing": 19, "welfare": 33, "security": 10, "environment": 26}	신문/팟캐스트	{안정,안전,다양성}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 안정, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 57, "ecoConsciousness": 50, "priceSensitivity": 59, "digitalConsumption": 52}	{"taxTolerance": 49, "governmentTrust": 53, "policyAcceptance": 62, "regulationPreference": 65, "publicServiceSatisfaction": 63}	0
4026	최경숙	63	60-69	Male	경기도	37.396474	127.571105	대학원 졸	350-500만원	주부	자녀 양육 가구	7	중도 무당층	91	{"economy": 15, "housing": -10, "welfare": -6, "security": 11, "environment": 15}	유튜브	{성장,안전,공정}	경기도에 거주하는 60-69 주부. 정치 성향은 중도이며 성장, 안전, 공정 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 48, "ecoConsciousness": 67, "priceSensitivity": 76, "digitalConsumption": 61}	{"taxTolerance": 76, "governmentTrust": 56, "policyAcceptance": 61, "regulationPreference": 73, "publicServiceSatisfaction": 72}	0
4027	박철수	64	60-69	Male	경기도	37.462407	127.47404	전문대 졸	200만원 미만	사무직	자녀 양육 가구	26	보수 성향 무당층	64	{"economy": 8, "housing": 12, "welfare": 35, "security": 48, "environment": -27}	SNS	{공정,공동체,안정}	경기도에 거주하는 60-69 사무직. 정치 성향은 중도이며 공정, 공동체, 안정 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 58, "ecoConsciousness": 52, "priceSensitivity": 73, "digitalConsumption": 54}	{"taxTolerance": 42, "governmentTrust": 72, "policyAcceptance": 64, "regulationPreference": 50, "publicServiceSatisfaction": 63}	0
4028	이서연	67	60-69	Male	경기도	37.418405	127.550635	대학원 졸	200-350만원	은퇴	자녀 양육 가구	0	중도 무당층	79	{"economy": -24, "housing": 19, "welfare": 40, "security": -1, "environment": 35}	포털 뉴스	{안전,자유,공정}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 안전, 자유, 공정 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 43, "ecoConsciousness": 29, "priceSensitivity": 60, "digitalConsumption": 71}	{"taxTolerance": 66, "governmentTrust": 44, "policyAcceptance": 60, "regulationPreference": 69, "publicServiceSatisfaction": 84}	0
4029	최민서	68	60-69	Male	경기도	37.428276	127.480655	대학교 졸	200만원 미만	은퇴	1인 가구	-8	중도 무당층	72	{"economy": 1, "housing": 29, "welfare": 44, "security": -12, "environment": 58}	포털 뉴스	{전통,환경,혁신}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 전통, 환경, 혁신 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 42, "ecoConsciousness": 41, "priceSensitivity": 88, "digitalConsumption": 60}	{"taxTolerance": 50, "governmentTrust": 50, "policyAcceptance": 37, "regulationPreference": 68, "publicServiceSatisfaction": 50}	0
4030	서경숙	66	60-69	Male	경기도	37.427847	127.523072	대학교 졸	350-500만원	은퇴	1인 가구	62	보수 정당 지지	63	{"economy": 45, "housing": 1, "welfare": 1, "security": 19, "environment": 19}	포털 뉴스	{성장,자유,공정}	경기도에 거주하는 60-69 은퇴. 정치 성향은 보수이며 성장, 자유, 공정 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 63, "ecoConsciousness": 44, "priceSensitivity": 61, "digitalConsumption": 57}	{"taxTolerance": 77, "governmentTrust": 63, "policyAcceptance": 44, "regulationPreference": 73, "publicServiceSatisfaction": 72}	0
4031	조하은	61	60-69	Male	경기도	37.348251	127.432824	대학교 졸	200만원 미만	자영업	1인 가구	55	보수 정당 지지	81	{"economy": 25, "housing": -10, "welfare": -23, "security": 62, "environment": -16}	지상파/종편 뉴스	{혁신,자유,전통}	경기도에 거주하는 60-69 자영업. 정치 성향은 보수이며 혁신, 자유, 전통 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 57, "ecoConsciousness": 58, "priceSensitivity": 94, "digitalConsumption": 62}	{"taxTolerance": 22, "governmentTrust": 73, "policyAcceptance": 64, "regulationPreference": 68, "publicServiceSatisfaction": 72}	0
4032	윤도윤	68	60-69	Male	경기도	37.370783	127.568155	전문대 졸	200-350만원	은퇴	1인 가구	-5	중도 무당층	89	{"economy": -11, "housing": -3, "welfare": 27, "security": 8, "environment": 35}	지상파/종편 뉴스	{자유,환경,전통}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 자유, 환경, 전통 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 42, "ecoConsciousness": 40, "priceSensitivity": 91, "digitalConsumption": 68}	{"taxTolerance": 44, "governmentTrust": 27, "policyAcceptance": 61, "regulationPreference": 69, "publicServiceSatisfaction": 51}	0
4033	황영수	73	70+	Female	경기도	37.443901	127.515162	대학원 졸	350-500만원	은퇴	1인 가구	17	보수 성향 무당층	95	{"economy": 17, "housing": 13, "welfare": 15, "security": 28, "environment": 35}	신문/팟캐스트	{자유,성장,안전}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 자유, 성장, 안전 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 57, "ecoConsciousness": 36, "priceSensitivity": 58, "digitalConsumption": 71}	{"taxTolerance": 35, "governmentTrust": 67, "policyAcceptance": 55, "regulationPreference": 71, "publicServiceSatisfaction": 57}	0
4034	서지민	80	70+	Female	경기도	37.45923	127.567654	전문대 졸	350-500만원	은퇴	다세대 가구	19	보수 성향 무당층	88	{"economy": -14, "housing": 13, "welfare": -17, "security": 20, "environment": 17}	지상파/종편 뉴스	{안정,공동체,다양성}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안정, 공동체, 다양성 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 35, "ecoConsciousness": 47, "priceSensitivity": 55, "digitalConsumption": 52}	{"taxTolerance": 38, "governmentTrust": 83, "policyAcceptance": 54, "regulationPreference": 68, "publicServiceSatisfaction": 57}	0
4035	장지호	84	70+	Female	경기도	37.406522	127.482916	대학원 졸	200만원 미만	은퇴	1인 가구	11	중도 무당층	98	{"economy": -36, "housing": -32, "welfare": 11, "security": -18, "environment": 30}	유튜브	{안전,공정,환경}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안전, 공정, 환경 가치를 중시한다.	{"brandLoyalty": 71, "noveltySeeking": 40, "ecoConsciousness": 67, "priceSensitivity": 83, "digitalConsumption": 54}	{"taxTolerance": 43, "governmentTrust": 52, "policyAcceptance": 51, "regulationPreference": 75, "publicServiceSatisfaction": 54}	0
4036	신서연	82	70+	Female	경기도	37.475807	127.591204	고졸 이하	200-350만원	은퇴	다세대 가구	15	보수 성향 무당층	73	{"economy": -14, "housing": 13, "welfare": 15, "security": 19, "environment": 10}	유튜브	{전통,성장,자유}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 전통, 성장, 자유 가치를 중시한다.	{"brandLoyalty": 65, "noveltySeeking": 52, "ecoConsciousness": 26, "priceSensitivity": 69, "digitalConsumption": 60}	{"taxTolerance": 63, "governmentTrust": 35, "policyAcceptance": 55, "regulationPreference": 70, "publicServiceSatisfaction": 67}	0
4037	전지호	80	70+	Female	경기도	37.486221	127.47627	대학교 졸	350-500만원	은퇴	다세대 가구	10	중도 무당층	95	{"economy": 7, "housing": 24, "welfare": 14, "security": 12, "environment": 18}	SNS	{안정,공정,환경}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안정, 공정, 환경 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 25, "ecoConsciousness": 45, "priceSensitivity": 54, "digitalConsumption": 60}	{"taxTolerance": 53, "governmentTrust": 66, "policyAcceptance": 54, "regulationPreference": 69, "publicServiceSatisfaction": 71}	0
4038	서경숙	83	70+	Female	경기도	37.491905	127.56913	전문대 졸	200-350만원	은퇴	1인 가구	36	보수 성향 무당층	80	{"economy": 26, "housing": 9, "welfare": -27, "security": 38, "environment": -5}	신문/팟캐스트	{공동체,환경,성장}	경기도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 공동체, 환경, 성장 가치를 중시한다.	{"brandLoyalty": 72, "noveltySeeking": 34, "ecoConsciousness": 46, "priceSensitivity": 73, "digitalConsumption": 50}	{"taxTolerance": 45, "governmentTrust": 55, "policyAcceptance": 56, "regulationPreference": 58, "publicServiceSatisfaction": 71}	0
4039	조경숙	81	70+	Female	경기도	37.383244	127.57845	전문대 졸	200-350만원	은퇴	1인 가구	35	보수 성향 무당층	89	{"economy": -18, "housing": -9, "welfare": -33, "security": 20, "environment": 14}	지상파/종편 뉴스	{안정,공동체,공정}	경기도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안정, 공동체, 공정 가치를 중시한다.	{"brandLoyalty": 68, "noveltySeeking": 35, "ecoConsciousness": 28, "priceSensitivity": 78, "digitalConsumption": 46}	{"taxTolerance": 56, "governmentTrust": 49, "policyAcceptance": 66, "regulationPreference": 64, "publicServiceSatisfaction": 76}	0
4040	윤준서	71	70+	Female	경기도	37.47551	127.448209	전문대 졸	200만원 미만	은퇴	1인 가구	42	보수 성향 무당층	88	{"economy": 10, "housing": 12, "welfare": 11, "security": 24, "environment": 5}	SNS	{안정,다양성,자유}	경기도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안정, 다양성, 자유 가치를 중시한다.	{"brandLoyalty": 66, "noveltySeeking": 40, "ecoConsciousness": 48, "priceSensitivity": 100, "digitalConsumption": 61}	{"taxTolerance": 31, "governmentTrust": 60, "policyAcceptance": 62, "regulationPreference": 72, "publicServiceSatisfaction": 68}	0
4041	장영수	82	70+	Female	경기도	37.378435	127.609086	전문대 졸	350-500만원	은퇴	다세대 가구	28	보수 성향 무당층	72	{"economy": 19, "housing": 7, "welfare": 15, "security": 31, "environment": 11}	포털 뉴스	{안전,환경,자유}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안전, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 39, "ecoConsciousness": 35, "priceSensitivity": 77, "digitalConsumption": 64}	{"taxTolerance": 43, "governmentTrust": 55, "policyAcceptance": 52, "regulationPreference": 67, "publicServiceSatisfaction": 80}	0
4042	박준서	70	70+	Female	경기도	37.399978	127.47423	대학교 졸	200-350만원	은퇴	부부 가구	-11	중도 무당층	99	{"economy": -3, "housing": 42, "welfare": 25, "security": 8, "environment": 12}	포털 뉴스	{다양성,안전,자유}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 다양성, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 55, "ecoConsciousness": 72, "priceSensitivity": 56, "digitalConsumption": 46}	{"taxTolerance": 62, "governmentTrust": 64, "policyAcceptance": 53, "regulationPreference": 64, "publicServiceSatisfaction": 61}	0
4043	황주원	79	70+	Female	경기도	37.375694	127.481998	전문대 졸	350-500만원	은퇴	다세대 가구	-6	중도 무당층	98	{"economy": -2, "housing": 12, "welfare": 25, "security": -14, "environment": 44}	유튜브	{자유,공동체,전통}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 자유, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 56, "ecoConsciousness": 44, "priceSensitivity": 73, "digitalConsumption": 39}	{"taxTolerance": 43, "governmentTrust": 42, "policyAcceptance": 54, "regulationPreference": 56, "publicServiceSatisfaction": 84}	0
4044	황정희	81	70+	Female	경기도	37.438466	127.559382	전문대 졸	200-350만원	은퇴	자녀 양육 가구	39	보수 성향 무당층	73	{"economy": 21, "housing": -5, "welfare": -12, "security": 16, "environment": 4}	포털 뉴스	{환경,공정,자유}	경기도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 환경, 공정, 자유 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 50, "ecoConsciousness": 56, "priceSensitivity": 75, "digitalConsumption": 39}	{"taxTolerance": 49, "governmentTrust": 57, "policyAcceptance": 66, "regulationPreference": 65, "publicServiceSatisfaction": 64}	0
4045	임영수	78	70+	Female	경기도	37.489771	127.472585	대학원 졸	500-700만원	은퇴	부부 가구	33	보수 성향 무당층	86	{"economy": 6, "housing": 13, "welfare": -29, "security": 29, "environment": -5}	신문/팟캐스트	{혁신,다양성,자유}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 혁신, 다양성, 자유 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 44, "ecoConsciousness": 65, "priceSensitivity": 64, "digitalConsumption": 68}	{"taxTolerance": 45, "governmentTrust": 40, "policyAcceptance": 59, "regulationPreference": 56, "publicServiceSatisfaction": 87}	0
4046	한민준	79	70+	Female	경기도	37.44823	127.479549	고졸 이하	500-700만원	은퇴	자녀 양육 가구	-29	진보 성향 무당층	73	{"economy": -37, "housing": 28, "welfare": 17, "security": 14, "environment": 27}	SNS	{환경,성장,혁신}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 환경, 성장, 혁신 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 40, "ecoConsciousness": 32, "priceSensitivity": 58, "digitalConsumption": 63}	{"taxTolerance": 39, "governmentTrust": 52, "policyAcceptance": 52, "regulationPreference": 56, "publicServiceSatisfaction": 54}	0
4047	최다은	79	70+	Female	경기도	37.441801	127.481496	전문대 졸	200만원 미만	은퇴	부부 가구	40	보수 성향 무당층	89	{"economy": 7, "housing": -29, "welfare": 0, "security": 39, "environment": -14}	포털 뉴스	{환경,안정,자유}	경기도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 환경, 안정, 자유 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 44, "ecoConsciousness": 27, "priceSensitivity": 85, "digitalConsumption": 48}	{"taxTolerance": 54, "governmentTrust": 51, "policyAcceptance": 45, "regulationPreference": 82, "publicServiceSatisfaction": 51}	0
4048	전유준	73	70+	Male	경기도	37.441658	127.560591	전문대 졸	500-700만원	은퇴	자녀 양육 가구	12	중도 무당층	90	{"economy": -17, "housing": 21, "welfare": 2, "security": 19, "environment": 35}	SNS	{안전,환경,전통}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안전, 환경, 전통 가치를 중시한다.	{"brandLoyalty": 60, "noveltySeeking": 37, "ecoConsciousness": 25, "priceSensitivity": 46, "digitalConsumption": 49}	{"taxTolerance": 41, "governmentTrust": 56, "policyAcceptance": 55, "regulationPreference": 68, "publicServiceSatisfaction": 53}	0
4049	안서연	72	70+	Male	경기도	37.385041	127.603604	대학원 졸	200-350만원	은퇴	1인 가구	24	보수 성향 무당층	91	{"economy": 0, "housing": 27, "welfare": 14, "security": 22, "environment": 6}	신문/팟캐스트	{자유,다양성,공정}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 자유, 다양성, 공정 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 56, "ecoConsciousness": 54, "priceSensitivity": 73, "digitalConsumption": 50}	{"taxTolerance": 54, "governmentTrust": 56, "policyAcceptance": 64, "regulationPreference": 68, "publicServiceSatisfaction": 71}	0
4050	류순자	82	70+	Male	경기도	37.371135	127.571756	대학원 졸	350-500만원	은퇴	다세대 가구	22	보수 성향 무당층	89	{"economy": 11, "housing": -11, "welfare": 1, "security": 22, "environment": 29}	포털 뉴스	{혁신,자유,환경}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 혁신, 자유, 환경 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 47, "ecoConsciousness": 48, "priceSensitivity": 50, "digitalConsumption": 45}	{"taxTolerance": 51, "governmentTrust": 59, "policyAcceptance": 55, "regulationPreference": 56, "publicServiceSatisfaction": 67}	0
4051	정민준	80	70+	Male	경기도	37.348198	127.54152	전문대 졸	200-350만원	은퇴	다세대 가구	22	보수 성향 무당층	82	{"economy": 13, "housing": -9, "welfare": 11, "security": 6, "environment": 27}	지상파/종편 뉴스	{전통,성장,다양성}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 전통, 성장, 다양성 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 65, "ecoConsciousness": 42, "priceSensitivity": 63, "digitalConsumption": 52}	{"taxTolerance": 48, "governmentTrust": 53, "policyAcceptance": 41, "regulationPreference": 44, "publicServiceSatisfaction": 76}	0
4052	한현우	79	70+	Male	경기도	37.489056	127.562464	대학교 졸	500-700만원	은퇴	자녀 양육 가구	40	보수 성향 무당층	99	{"economy": 16, "housing": 27, "welfare": -25, "security": 36, "environment": 1}	지상파/종편 뉴스	{혁신,자유,안정}	경기도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 혁신, 자유, 안정 가치를 중시한다.	{"brandLoyalty": 60, "noveltySeeking": 60, "ecoConsciousness": 34, "priceSensitivity": 69, "digitalConsumption": 48}	{"taxTolerance": 48, "governmentTrust": 67, "policyAcceptance": 72, "regulationPreference": 77, "publicServiceSatisfaction": 65}	0
4053	안순자	75	70+	Male	경기도	37.425342	127.566193	대학교 졸	350-500만원	은퇴	다세대 가구	50	보수 정당 지지	99	{"economy": -5, "housing": -9, "welfare": -22, "security": 33, "environment": 16}	신문/팟캐스트	{자유,다양성,안정}	경기도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 자유, 다양성, 안정 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 43, "ecoConsciousness": 57, "priceSensitivity": 45, "digitalConsumption": 51}	{"taxTolerance": 52, "governmentTrust": 51, "policyAcceptance": 42, "regulationPreference": 70, "publicServiceSatisfaction": 65}	0
4054	송지아	80	70+	Male	경기도	37.420172	127.575048	고졸 이하	350-500만원	은퇴	다세대 가구	28	보수 성향 무당층	96	{"economy": -1, "housing": 18, "welfare": 0, "security": 34, "environment": 26}	유튜브	{자유,안전,전통}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 자유, 안전, 전통 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 27, "ecoConsciousness": 47, "priceSensitivity": 58, "digitalConsumption": 51}	{"taxTolerance": 37, "governmentTrust": 73, "policyAcceptance": 57, "regulationPreference": 75, "publicServiceSatisfaction": 69}	0
4055	황지호	75	70+	Male	경기도	37.389971	127.556431	전문대 졸	350-500만원	은퇴	자녀 양육 가구	13	중도 무당층	70	{"economy": 4, "housing": 17, "welfare": 11, "security": 31, "environment": -7}	신문/팟캐스트	{환경,전통,공정}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 환경, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 69, "noveltySeeking": 53, "ecoConsciousness": 50, "priceSensitivity": 56, "digitalConsumption": 59}	{"taxTolerance": 54, "governmentTrust": 64, "policyAcceptance": 71, "regulationPreference": 62, "publicServiceSatisfaction": 65}	0
4056	권지호	83	70+	Male	경기도	37.481364	127.566187	대학교 졸	200-350만원	은퇴	다세대 가구	-3	중도 무당층	82	{"economy": 9, "housing": -5, "welfare": 9, "security": 10, "environment": 14}	포털 뉴스	{혁신,다양성,안전}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 혁신, 다양성, 안전 가치를 중시한다.	{"brandLoyalty": 68, "noveltySeeking": 36, "ecoConsciousness": 48, "priceSensitivity": 66, "digitalConsumption": 39}	{"taxTolerance": 54, "governmentTrust": 47, "policyAcceptance": 39, "regulationPreference": 85, "publicServiceSatisfaction": 77}	0
4057	권주원	83	70+	Male	경기도	37.402104	127.611571	대학원 졸	200만원 미만	은퇴	1인 가구	30	보수 성향 무당층	99	{"economy": -11, "housing": -8, "welfare": 2, "security": 60, "environment": 11}	지상파/종편 뉴스	{혁신,자유,안정}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 혁신, 자유, 안정 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 46, "ecoConsciousness": 38, "priceSensitivity": 68, "digitalConsumption": 53}	{"taxTolerance": 42, "governmentTrust": 62, "policyAcceptance": 75, "regulationPreference": 61, "publicServiceSatisfaction": 68}	0
4058	전동현	82	70+	Male	경기도	37.37133	127.577642	대학원 졸	350-500만원	은퇴	1인 가구	7	중도 무당층	68	{"economy": 37, "housing": 13, "welfare": 18, "security": -5, "environment": -13}	포털 뉴스	{환경,공동체,안정}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 환경, 공동체, 안정 가치를 중시한다.	{"brandLoyalty": 68, "noveltySeeking": 54, "ecoConsciousness": 41, "priceSensitivity": 54, "digitalConsumption": 61}	{"taxTolerance": 60, "governmentTrust": 31, "policyAcceptance": 37, "regulationPreference": 77, "publicServiceSatisfaction": 65}	0
4059	최수아	84	70+	Male	경기도	37.336681	127.489255	대학원 졸	200만원 미만	은퇴	자녀 양육 가구	39	보수 성향 무당층	85	{"economy": 22, "housing": -14, "welfare": -34, "security": 30, "environment": -14}	포털 뉴스	{환경,안전,공동체}	경기도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 환경, 안전, 공동체 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 43, "ecoConsciousness": 52, "priceSensitivity": 80, "digitalConsumption": 57}	{"taxTolerance": 65, "governmentTrust": 48, "policyAcceptance": 69, "regulationPreference": 54, "publicServiceSatisfaction": 68}	0
4060	김은우	83	70+	Male	경기도	37.435243	127.608082	대학원 졸	200만원 미만	은퇴	다세대 가구	5	중도 무당층	99	{"economy": -21, "housing": 13, "welfare": 2, "security": 19, "environment": 22}	신문/팟캐스트	{혁신,성장,공동체}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 혁신, 성장, 공동체 가치를 중시한다.	{"brandLoyalty": 65, "noveltySeeking": 33, "ecoConsciousness": 38, "priceSensitivity": 86, "digitalConsumption": 48}	{"taxTolerance": 58, "governmentTrust": 42, "policyAcceptance": 54, "regulationPreference": 77, "publicServiceSatisfaction": 52}	0
4061	박채원	73	70+	Male	경기도	37.476719	127.602182	대학교 졸	700만원 이상	은퇴	1인 가구	-22	진보 성향 무당층	54	{"economy": -10, "housing": 27, "welfare": 44, "security": -31, "environment": 36}	지상파/종편 뉴스	{전통,성장,환경}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 전통, 성장, 환경 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 31, "ecoConsciousness": 29, "priceSensitivity": 57, "digitalConsumption": 53}	{"taxTolerance": 56, "governmentTrust": 57, "policyAcceptance": 57, "regulationPreference": 67, "publicServiceSatisfaction": 62}	0
4062	안도윤	72	70+	Male	경기도	37.411961	127.554282	대학원 졸	500-700만원	은퇴	부부 가구	1	중도 무당층	84	{"economy": 6, "housing": 7, "welfare": 33, "security": 7, "environment": 12}	포털 뉴스	{혁신,안정,공정}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 혁신, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 51, "ecoConsciousness": 48, "priceSensitivity": 59, "digitalConsumption": 48}	{"taxTolerance": 48, "governmentTrust": 76, "policyAcceptance": 60, "regulationPreference": 62, "publicServiceSatisfaction": 60}	0
4063	조동현	19	18-29	Female	충청북도	36.649768	127.461533	전문대 졸	350-500만원	사무직	자녀 양육 가구	-36	진보 성향 무당층	53	{"economy": -35, "housing": 31, "welfare": 47, "security": -21, "environment": 19}	신문/팟캐스트	{혁신,환경,안전}	충청북도에 거주하는 18-29 사무직. 정치 성향은 진보이며 혁신, 환경, 안전 가치를 중시한다.	{"brandLoyalty": 25, "noveltySeeking": 72, "ecoConsciousness": 28, "priceSensitivity": 56, "digitalConsumption": 76}	{"taxTolerance": 39, "governmentTrust": 46, "policyAcceptance": 45, "regulationPreference": 65, "publicServiceSatisfaction": 85}	0
4064	류건우	29	18-29	Female	충청북도	36.626591	127.482071	대학교 졸	350-500만원	공무원	부부 가구	-43	진보 성향 무당층	36	{"economy": -45, "housing": 47, "welfare": 34, "security": -23, "environment": 34}	유튜브	{공동체,안전,자유}	충청북도에 거주하는 18-29 공무원. 정치 성향은 진보이며 공동체, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 69, "ecoConsciousness": 59, "priceSensitivity": 60, "digitalConsumption": 71}	{"taxTolerance": 58, "governmentTrust": 49, "policyAcceptance": 22, "regulationPreference": 76, "publicServiceSatisfaction": 74}	0
4065	신지아	18	18-29	Male	충청북도	36.616523	127.505448	대학원 졸	350-500만원	학생	1인 가구	-17	진보 성향 무당층	26	{"economy": 10, "housing": 52, "welfare": 22, "security": 13, "environment": 34}	지상파/종편 뉴스	{공동체,안정,안전}	충청북도에 거주하는 18-29 학생. 정치 성향은 중도이며 공동체, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 72, "ecoConsciousness": 56, "priceSensitivity": 40, "digitalConsumption": 81}	{"taxTolerance": 59, "governmentTrust": 48, "policyAcceptance": 35, "regulationPreference": 58, "publicServiceSatisfaction": 52}	0
4066	송민준	25	18-29	Male	충청북도	36.653068	127.55467	대학원 졸	350-500만원	전문직	부부 가구	-24	진보 성향 무당층	46	{"economy": -8, "housing": 7, "welfare": 35, "security": -19, "environment": 41}	신문/팟캐스트	{혁신,안정,공동체}	충청북도에 거주하는 18-29 전문직. 정치 성향은 중도이며 혁신, 안정, 공동체 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 92, "ecoConsciousness": 63, "priceSensitivity": 65, "digitalConsumption": 96}	{"taxTolerance": 58, "governmentTrust": 42, "policyAcceptance": 41, "regulationPreference": 72, "publicServiceSatisfaction": 61}	0
4067	박혜진	32	30-39	Female	충청북도	36.564449	127.591216	대학교 졸	350-500만원	서비스직	1인 가구	-44	진보 성향 무당층	57	{"economy": -33, "housing": 25, "welfare": 63, "security": 6, "environment": 20}	지상파/종편 뉴스	{공정,자유,공동체}	충청북도에 거주하는 30-39 서비스직. 정치 성향은 진보이며 공정, 자유, 공동체 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 60, "ecoConsciousness": 37, "priceSensitivity": 75, "digitalConsumption": 80}	{"taxTolerance": 63, "governmentTrust": 44, "policyAcceptance": 59, "regulationPreference": 70, "publicServiceSatisfaction": 77}	0
4068	안지호	39	30-39	Female	충청북도	36.626727	127.430597	고졸 이하	500-700만원	주부	다세대 가구	-13	중도 무당층	36	{"economy": -13, "housing": 10, "welfare": 22, "security": -6, "environment": 25}	지상파/종편 뉴스	{환경,안전,다양성}	충청북도에 거주하는 30-39 주부. 정치 성향은 중도이며 환경, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 75, "ecoConsciousness": 51, "priceSensitivity": 45, "digitalConsumption": 86}	{"taxTolerance": 49, "governmentTrust": 52, "policyAcceptance": 55, "regulationPreference": 58, "publicServiceSatisfaction": 73}	0
4069	박서연	37	30-39	Male	충청북도	36.632895	127.534421	대학원 졸	200-350만원	사무직	다세대 가구	-24	진보 성향 무당층	66	{"economy": -29, "housing": 41, "welfare": 33, "security": 17, "environment": 14}	지상파/종편 뉴스	{자유,환경,공정}	충청북도에 거주하는 30-39 사무직. 정치 성향은 중도이며 자유, 환경, 공정 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 80, "ecoConsciousness": 47, "priceSensitivity": 69, "digitalConsumption": 69}	{"taxTolerance": 50, "governmentTrust": 35, "policyAcceptance": 44, "regulationPreference": 75, "publicServiceSatisfaction": 71}	0
4070	류하은	32	30-39	Male	충청북도	36.628801	127.536049	대학원 졸	200-350만원	전문직	다세대 가구	19	보수 성향 무당층	58	{"economy": -4, "housing": -8, "welfare": 21, "security": -5, "environment": -1}	신문/팟캐스트	{환경,공동체,전통}	충청북도에 거주하는 30-39 전문직. 정치 성향은 중도이며 환경, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 17, "noveltySeeking": 69, "ecoConsciousness": 28, "priceSensitivity": 49, "digitalConsumption": 64}	{"taxTolerance": 66, "governmentTrust": 38, "policyAcceptance": 31, "regulationPreference": 49, "publicServiceSatisfaction": 55}	0
4071	임채원	40	40-49	Female	충청북도	36.690017	127.557763	대학교 졸	200-350만원	학생	자녀 양육 가구	-21	진보 성향 무당층	53	{"economy": -25, "housing": 15, "welfare": -6, "security": -14, "environment": 36}	유튜브	{안전,안정,자유}	충청북도에 거주하는 40-49 학생. 정치 성향은 중도이며 안전, 안정, 자유 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 74, "ecoConsciousness": 44, "priceSensitivity": 68, "digitalConsumption": 75}	{"taxTolerance": 44, "governmentTrust": 46, "policyAcceptance": 40, "regulationPreference": 78, "publicServiceSatisfaction": 90}	0
4072	전서윤	46	40-49	Female	충청북도	36.575391	127.511766	전문대 졸	350-500만원	주부	1인 가구	-36	진보 성향 무당층	65	{"economy": -15, "housing": 42, "welfare": 16, "security": -16, "environment": 36}	신문/팟캐스트	{안정,전통,혁신}	충청북도에 거주하는 40-49 주부. 정치 성향은 진보이며 안정, 전통, 혁신 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 47, "ecoConsciousness": 66, "priceSensitivity": 53, "digitalConsumption": 70}	{"taxTolerance": 38, "governmentTrust": 35, "policyAcceptance": 26, "regulationPreference": 73, "publicServiceSatisfaction": 59}	0
4073	임지호	45	40-49	Male	충청북도	36.566125	127.588326	전문대 졸	700만원 이상	은퇴	1인 가구	4	중도 무당층	83	{"economy": 6, "housing": 11, "welfare": 25, "security": -2, "environment": -17}	신문/팟캐스트	{환경,성장,공동체}	충청북도에 거주하는 40-49 은퇴. 정치 성향은 중도이며 환경, 성장, 공동체 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 55, "ecoConsciousness": 50, "priceSensitivity": 60, "digitalConsumption": 89}	{"taxTolerance": 44, "governmentTrust": 64, "policyAcceptance": 69, "regulationPreference": 60, "publicServiceSatisfaction": 68}	0
4074	강은우	41	40-49	Male	충청북도	36.655602	127.550562	대학원 졸	700만원 이상	서비스직	다세대 가구	-15	진보 성향 무당층	43	{"economy": -1, "housing": 42, "welfare": 32, "security": 9, "environment": 24}	유튜브	{혁신,공동체,안정}	충청북도에 거주하는 40-49 서비스직. 정치 성향은 중도이며 혁신, 공동체, 안정 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 77, "ecoConsciousness": 62, "priceSensitivity": 51, "digitalConsumption": 67}	{"taxTolerance": 23, "governmentTrust": 38, "policyAcceptance": 37, "regulationPreference": 42, "publicServiceSatisfaction": 63}	0
4075	전수아	54	50-59	Female	충청북도	36.631729	127.446278	대학원 졸	200-350만원	프리랜서	부부 가구	19	보수 성향 무당층	65	{"economy": 7, "housing": 11, "welfare": -1, "security": 46, "environment": 17}	유튜브	{안전,환경,공정}	충청북도에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 안전, 환경, 공정 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 59, "ecoConsciousness": 53, "priceSensitivity": 58, "digitalConsumption": 67}	{"taxTolerance": 46, "governmentTrust": 39, "policyAcceptance": 61, "regulationPreference": 78, "publicServiceSatisfaction": 68}	0
4076	서현우	54	50-59	Female	충청북도	36.573409	127.45743	대학원 졸	350-500만원	학생	다세대 가구	-3	중도 무당층	64	{"economy": 6, "housing": 8, "welfare": 7, "security": 1, "environment": 3}	지상파/종편 뉴스	{전통,환경,혁신}	충청북도에 거주하는 50-59 학생. 정치 성향은 중도이며 전통, 환경, 혁신 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 71, "ecoConsciousness": 23, "priceSensitivity": 70, "digitalConsumption": 71}	{"taxTolerance": 44, "governmentTrust": 41, "policyAcceptance": 43, "regulationPreference": 73, "publicServiceSatisfaction": 89}	0
4077	이다은	52	50-59	Male	충청북도	36.653047	127.444602	전문대 졸	500-700만원	사무직	다세대 가구	-31	진보 성향 무당층	55	{"economy": -40, "housing": 54, "welfare": 1, "security": 3, "environment": 32}	포털 뉴스	{혁신,다양성,안정}	충청북도에 거주하는 50-59 사무직. 정치 성향은 중도이며 혁신, 다양성, 안정 가치를 중시한다.	{"brandLoyalty": 71, "noveltySeeking": 52, "ecoConsciousness": 47, "priceSensitivity": 56, "digitalConsumption": 77}	{"taxTolerance": 43, "governmentTrust": 53, "policyAcceptance": 60, "regulationPreference": 77, "publicServiceSatisfaction": 78}	0
4078	임민준	59	50-59	Male	충청북도	36.625633	127.550834	대학교 졸	200-350만원	서비스직	1인 가구	4	중도 무당층	89	{"economy": -5, "housing": 6, "welfare": 10, "security": 26, "environment": 22}	지상파/종편 뉴스	{자유,전통,안전}	충청북도에 거주하는 50-59 서비스직. 정치 성향은 중도이며 자유, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 63, "ecoConsciousness": 63, "priceSensitivity": 62, "digitalConsumption": 47}	{"taxTolerance": 45, "governmentTrust": 55, "policyAcceptance": 49, "regulationPreference": 73, "publicServiceSatisfaction": 79}	0
4079	윤동현	60	60-69	Female	충청북도	36.627413	127.458673	전문대 졸	200-350만원	생산직	다세대 가구	15	보수 성향 무당층	64	{"economy": -28, "housing": 21, "welfare": 8, "security": 21, "environment": 26}	포털 뉴스	{전통,혁신,다양성}	충청북도에 거주하는 60-69 생산직. 정치 성향은 중도이며 전통, 혁신, 다양성 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 49, "ecoConsciousness": 45, "priceSensitivity": 68, "digitalConsumption": 70}	{"taxTolerance": 49, "governmentTrust": 40, "policyAcceptance": 45, "regulationPreference": 63, "publicServiceSatisfaction": 69}	0
4080	서순자	61	60-69	Female	충청북도	36.697274	127.43144	고졸 이하	200-350만원	은퇴	부부 가구	-13	중도 무당층	73	{"economy": -39, "housing": 25, "welfare": 28, "security": 14, "environment": 32}	유튜브	{자유,공동체,안전}	충청북도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 자유, 공동체, 안전 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 47, "ecoConsciousness": 22, "priceSensitivity": 65, "digitalConsumption": 75}	{"taxTolerance": 35, "governmentTrust": 37, "policyAcceptance": 53, "regulationPreference": 63, "publicServiceSatisfaction": 72}	0
4081	최성호	65	60-69	Male	충청북도	36.569432	127.554623	대학원 졸	350-500만원	서비스직	1인 가구	-5	중도 무당층	64	{"economy": -9, "housing": -7, "welfare": 13, "security": 5, "environment": 17}	포털 뉴스	{전통,공정,다양성}	충청북도에 거주하는 60-69 서비스직. 정치 성향은 중도이며 전통, 공정, 다양성 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 61, "ecoConsciousness": 41, "priceSensitivity": 79, "digitalConsumption": 75}	{"taxTolerance": 50, "governmentTrust": 46, "policyAcceptance": 63, "regulationPreference": 58, "publicServiceSatisfaction": 69}	0
4082	임혜진	65	60-69	Male	충청북도	36.593956	127.424733	고졸 이하	200만원 미만	자영업	1인 가구	20	보수 성향 무당층	88	{"economy": -20, "housing": 26, "welfare": -14, "security": 21, "environment": 16}	유튜브	{공동체,공정,안전}	충청북도에 거주하는 60-69 자영업. 정치 성향은 중도이며 공동체, 공정, 안전 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 49, "ecoConsciousness": 53, "priceSensitivity": 60, "digitalConsumption": 41}	{"taxTolerance": 46, "governmentTrust": 58, "policyAcceptance": 45, "regulationPreference": 48, "publicServiceSatisfaction": 76}	0
4083	류영수	84	70+	Female	충청북도	36.684066	127.5343	전문대 졸	200만원 미만	은퇴	부부 가구	39	보수 성향 무당층	90	{"economy": 21, "housing": 21, "welfare": -14, "security": 8, "environment": -1}	유튜브	{안전,성장,환경}	충청북도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안전, 성장, 환경 가치를 중시한다.	{"brandLoyalty": 66, "noveltySeeking": 34, "ecoConsciousness": 38, "priceSensitivity": 70, "digitalConsumption": 79}	{"taxTolerance": 66, "governmentTrust": 62, "policyAcceptance": 65, "regulationPreference": 56, "publicServiceSatisfaction": 60}	0
4084	조광수	72	70+	Female	충청북도	36.710049	127.528189	고졸 이하	500-700만원	은퇴	부부 가구	1	중도 무당층	68	{"economy": 18, "housing": 11, "welfare": 8, "security": -9, "environment": 32}	SNS	{혁신,공정,공동체}	충청북도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 혁신, 공정, 공동체 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 32, "ecoConsciousness": 42, "priceSensitivity": 71, "digitalConsumption": 60}	{"taxTolerance": 46, "governmentTrust": 47, "policyAcceptance": 53, "regulationPreference": 54, "publicServiceSatisfaction": 71}	0
4085	윤채원	72	70+	Male	충청북도	36.598008	127.542111	대학교 졸	200만원 미만	은퇴	다세대 가구	12	중도 무당층	77	{"economy": 10, "housing": 22, "welfare": 7, "security": 35, "environment": 8}	포털 뉴스	{자유,공동체,환경}	충청북도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 자유, 공동체, 환경 가치를 중시한다.	{"brandLoyalty": 72, "noveltySeeking": 60, "ecoConsciousness": 50, "priceSensitivity": 65, "digitalConsumption": 69}	{"taxTolerance": 70, "governmentTrust": 69, "policyAcceptance": 48, "regulationPreference": 61, "publicServiceSatisfaction": 55}	0
4086	서서연	80	70+	Male	충청북도	36.606432	127.44283	고졸 이하	500-700만원	은퇴	자녀 양육 가구	32	보수 성향 무당층	99	{"economy": -13, "housing": -2, "welfare": -8, "security": 35, "environment": 14}	신문/팟캐스트	{환경,안정,공동체}	충청북도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 환경, 안정, 공동체 가치를 중시한다.	{"brandLoyalty": 71, "noveltySeeking": 25, "ecoConsciousness": 35, "priceSensitivity": 55, "digitalConsumption": 48}	{"taxTolerance": 47, "governmentTrust": 60, "policyAcceptance": 66, "regulationPreference": 68, "publicServiceSatisfaction": 81}	0
4087	이혜진	23	18-29	Female	충청남도	36.715237	126.714205	대학교 졸	200-350만원	생산직	자녀 양육 가구	-36	진보 성향 무당층	33	{"economy": 0, "housing": 11, "welfare": 47, "security": 3, "environment": 8}	신문/팟캐스트	{성장,전통,안정}	충청남도에 거주하는 18-29 생산직. 정치 성향은 진보이며 성장, 전통, 안정 가치를 중시한다.	{"brandLoyalty": 18, "noveltySeeking": 68, "ecoConsciousness": 49, "priceSensitivity": 67, "digitalConsumption": 75}	{"taxTolerance": 43, "governmentTrust": 42, "policyAcceptance": 53, "regulationPreference": 62, "publicServiceSatisfaction": 59}	0
4088	장영수	22	18-29	Female	충청남도	36.675335	126.75039	대학교 졸	200-350만원	학생	1인 가구	-39	진보 성향 무당층	59	{"economy": -19, "housing": 24, "welfare": 24, "security": -8, "environment": 52}	신문/팟캐스트	{혁신,공정,성장}	충청남도에 거주하는 18-29 학생. 정치 성향은 진보이며 혁신, 공정, 성장 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 73, "ecoConsciousness": 57, "priceSensitivity": 80, "digitalConsumption": 81}	{"taxTolerance": 46, "governmentTrust": 49, "policyAcceptance": 43, "regulationPreference": 62, "publicServiceSatisfaction": 76}	0
4089	이수아	29	18-29	Female	충청남도	36.586866	126.7178	대학원 졸	200-350만원	은퇴	1인 가구	2	중도 무당층	66	{"economy": -27, "housing": 6, "welfare": 16, "security": 4, "environment": 43}	신문/팟캐스트	{안전,공동체,다양성}	충청남도에 거주하는 18-29 은퇴. 정치 성향은 중도이며 안전, 공동체, 다양성 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 63, "ecoConsciousness": 66, "priceSensitivity": 63, "digitalConsumption": 83}	{"taxTolerance": 33, "governmentTrust": 50, "policyAcceptance": 40, "regulationPreference": 73, "publicServiceSatisfaction": 74}	0
4090	김미경	18	18-29	Male	충청남도	36.628638	126.763231	전문대 졸	350-500만원	프리랜서	다세대 가구	-48	진보 정당 지지	53	{"economy": -43, "housing": 7, "welfare": 35, "security": 16, "environment": 19}	신문/팟캐스트	{성장,안정,안전}	충청남도에 거주하는 18-29 프리랜서. 정치 성향은 진보이며 성장, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 24, "noveltySeeking": 76, "ecoConsciousness": 45, "priceSensitivity": 55, "digitalConsumption": 84}	{"taxTolerance": 26, "governmentTrust": 41, "policyAcceptance": 45, "regulationPreference": 60, "publicServiceSatisfaction": 63}	0
4091	전서연	28	18-29	Male	충청남도	36.719514	126.699217	대학원 졸	700만원 이상	은퇴	부부 가구	-24	진보 성향 무당층	60	{"economy": -42, "housing": 30, "welfare": 32, "security": -11, "environment": 18}	지상파/종편 뉴스	{다양성,공정,안전}	충청남도에 거주하는 18-29 은퇴. 정치 성향은 중도이며 다양성, 공정, 안전 가치를 중시한다.	{"brandLoyalty": 22, "noveltySeeking": 73, "ecoConsciousness": 52, "priceSensitivity": 65, "digitalConsumption": 82}	{"taxTolerance": 46, "governmentTrust": 35, "policyAcceptance": 54, "regulationPreference": 52, "publicServiceSatisfaction": 97}	0
4092	류건우	24	18-29	Male	충청남도	36.639688	126.651797	대학원 졸	200-350만원	학생	부부 가구	-39	진보 성향 무당층	55	{"economy": -46, "housing": 44, "welfare": 31, "security": -7, "environment": 42}	포털 뉴스	{자유,환경,안전}	충청남도에 거주하는 18-29 학생. 정치 성향은 진보이며 자유, 환경, 안전 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 66, "ecoConsciousness": 34, "priceSensitivity": 73, "digitalConsumption": 99}	{"taxTolerance": 47, "governmentTrust": 42, "policyAcceptance": 34, "regulationPreference": 55, "publicServiceSatisfaction": 72}	0
4093	강지아	37	30-39	Female	충청남도	36.615318	126.634645	전문대 졸	500-700만원	사무직	자녀 양육 가구	-11	중도 무당층	34	{"economy": -8, "housing": 22, "welfare": 35, "security": -17, "environment": 32}	포털 뉴스	{다양성,혁신,환경}	충청남도에 거주하는 30-39 사무직. 정치 성향은 중도이며 다양성, 혁신, 환경 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 68, "ecoConsciousness": 38, "priceSensitivity": 56, "digitalConsumption": 90}	{"taxTolerance": 52, "governmentTrust": 51, "policyAcceptance": 52, "regulationPreference": 62, "publicServiceSatisfaction": 60}	0
4094	최동현	39	30-39	Female	충청남도	36.69266	126.618196	대학원 졸	350-500만원	서비스직	1인 가구	-44	진보 성향 무당층	65	{"economy": -18, "housing": 30, "welfare": 11, "security": -17, "environment": 33}	SNS	{다양성,안정,공정}	충청남도에 거주하는 30-39 서비스직. 정치 성향은 진보이며 다양성, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 52, "ecoConsciousness": 69, "priceSensitivity": 74, "digitalConsumption": 76}	{"taxTolerance": 55, "governmentTrust": 45, "policyAcceptance": 53, "regulationPreference": 57, "publicServiceSatisfaction": 66}	0
4095	조민서	33	30-39	Female	충청남도	36.732507	126.691224	대학원 졸	200-350만원	은퇴	자녀 양육 가구	-29	진보 성향 무당층	36	{"economy": -44, "housing": 24, "welfare": 24, "security": -24, "environment": 14}	지상파/종편 뉴스	{안정,전통,안전}	충청남도에 거주하는 30-39 은퇴. 정치 성향은 중도이며 안정, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 71, "ecoConsciousness": 59, "priceSensitivity": 43, "digitalConsumption": 89}	{"taxTolerance": 61, "governmentTrust": 52, "policyAcceptance": 79, "regulationPreference": 60, "publicServiceSatisfaction": 67}	0
4096	조채원	38	30-39	Male	충청남도	36.631086	126.707704	대학원 졸	350-500만원	은퇴	부부 가구	1	중도 무당층	68	{"economy": 6, "housing": -18, "welfare": -22, "security": 14, "environment": 0}	지상파/종편 뉴스	{전통,다양성,환경}	충청남도에 거주하는 30-39 은퇴. 정치 성향은 중도이며 전통, 다양성, 환경 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 74, "ecoConsciousness": 65, "priceSensitivity": 60, "digitalConsumption": 72}	{"taxTolerance": 70, "governmentTrust": 34, "policyAcceptance": 56, "regulationPreference": 85, "publicServiceSatisfaction": 58}	0
4097	서성호	33	30-39	Male	충청남도	36.702965	126.579505	대학교 졸	200-350만원	프리랜서	다세대 가구	-33	진보 성향 무당층	56	{"economy": -20, "housing": 28, "welfare": 34, "security": -6, "environment": 3}	신문/팟캐스트	{공동체,안정,성장}	충청남도에 거주하는 30-39 프리랜서. 정치 성향은 중도이며 공동체, 안정, 성장 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 70, "ecoConsciousness": 62, "priceSensitivity": 53, "digitalConsumption": 73}	{"taxTolerance": 42, "governmentTrust": 68, "policyAcceptance": 43, "regulationPreference": 59, "publicServiceSatisfaction": 74}	0
4098	최서연	44	40-49	Female	충청남도	36.655008	126.651861	대학교 졸	500-700만원	은퇴	1인 가구	-6	중도 무당층	66	{"economy": -10, "housing": 34, "welfare": 22, "security": -37, "environment": 35}	SNS	{혁신,안정,공동체}	충청남도에 거주하는 40-49 은퇴. 정치 성향은 중도이며 혁신, 안정, 공동체 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 52, "ecoConsciousness": 71, "priceSensitivity": 65, "digitalConsumption": 72}	{"taxTolerance": 37, "governmentTrust": 44, "policyAcceptance": 53, "regulationPreference": 66, "publicServiceSatisfaction": 57}	0
4099	류광수	43	40-49	Female	충청남도	36.590643	126.677325	전문대 졸	500-700만원	은퇴	1인 가구	-63	진보 정당 지지	67	{"economy": -50, "housing": 48, "welfare": 29, "security": -11, "environment": 57}	SNS	{다양성,공정,자유}	충청남도에 거주하는 40-49 은퇴. 정치 성향은 진보이며 다양성, 공정, 자유 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 63, "ecoConsciousness": 47, "priceSensitivity": 48, "digitalConsumption": 90}	{"taxTolerance": 57, "governmentTrust": 58, "policyAcceptance": 48, "regulationPreference": 57, "publicServiceSatisfaction": 41}	0
4100	윤민서	47	40-49	Female	충청남도	36.710567	126.618125	고졸 이하	200-350만원	주부	1인 가구	-6	중도 무당층	45	{"economy": -12, "housing": 16, "welfare": 27, "security": -2, "environment": -16}	SNS	{자유,다양성,안정}	충청남도에 거주하는 40-49 주부. 정치 성향은 중도이며 자유, 다양성, 안정 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 47, "ecoConsciousness": 40, "priceSensitivity": 63, "digitalConsumption": 57}	{"taxTolerance": 56, "governmentTrust": 42, "policyAcceptance": 44, "regulationPreference": 75, "publicServiceSatisfaction": 77}	0
4101	전영수	44	40-49	Male	충청남도	36.643218	126.700096	대학원 졸	700만원 이상	공무원	자녀 양육 가구	11	중도 무당층	46	{"economy": 1, "housing": 7, "welfare": -3, "security": 4, "environment": 36}	포털 뉴스	{혁신,공동체,다양성}	충청남도에 거주하는 40-49 공무원. 정치 성향은 중도이며 혁신, 공동체, 다양성 가치를 중시한다.	{"brandLoyalty": 24, "noveltySeeking": 44, "ecoConsciousness": 66, "priceSensitivity": 51, "digitalConsumption": 69}	{"taxTolerance": 53, "governmentTrust": 46, "policyAcceptance": 43, "regulationPreference": 79, "publicServiceSatisfaction": 62}	0
4102	이성호	45	40-49	Male	충청남도	36.612811	126.650149	고졸 이하	350-500만원	전문직	다세대 가구	-23	진보 성향 무당층	72	{"economy": -18, "housing": 15, "welfare": 46, "security": -16, "environment": 34}	지상파/종편 뉴스	{혁신,공정,안전}	충청남도에 거주하는 40-49 전문직. 정치 성향은 중도이며 혁신, 공정, 안전 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 79, "ecoConsciousness": 33, "priceSensitivity": 59, "digitalConsumption": 75}	{"taxTolerance": 49, "governmentTrust": 53, "policyAcceptance": 51, "regulationPreference": 50, "publicServiceSatisfaction": 61}	0
4103	황주원	42	40-49	Male	충청남도	36.726464	126.648768	대학원 졸	350-500만원	학생	1인 가구	-25	진보 성향 무당층	79	{"economy": -26, "housing": 34, "welfare": 12, "security": -25, "environment": -1}	유튜브	{다양성,자유,전통}	충청남도에 거주하는 40-49 학생. 정치 성향은 중도이며 다양성, 자유, 전통 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 91, "ecoConsciousness": 59, "priceSensitivity": 74, "digitalConsumption": 76}	{"taxTolerance": 53, "governmentTrust": 44, "policyAcceptance": 42, "regulationPreference": 78, "publicServiceSatisfaction": 77}	0
4104	안지민	54	50-59	Female	충청남도	36.649529	126.665448	전문대 졸	700만원 이상	프리랜서	자녀 양육 가구	15	보수 성향 무당층	69	{"economy": 27, "housing": 18, "welfare": 20, "security": 14, "environment": 26}	포털 뉴스	{성장,전통,다양성}	충청남도에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 성장, 전통, 다양성 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 51, "ecoConsciousness": 57, "priceSensitivity": 37, "digitalConsumption": 76}	{"taxTolerance": 33, "governmentTrust": 46, "policyAcceptance": 54, "regulationPreference": 63, "publicServiceSatisfaction": 58}	0
4105	권주원	51	50-59	Female	충청남도	36.616235	126.739347	대학교 졸	700만원 이상	학생	자녀 양육 가구	15	보수 성향 무당층	86	{"economy": 12, "housing": 1, "welfare": 8, "security": -4, "environment": -9}	유튜브	{전통,환경,성장}	충청남도에 거주하는 50-59 학생. 정치 성향은 중도이며 전통, 환경, 성장 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 52, "ecoConsciousness": 42, "priceSensitivity": 19, "digitalConsumption": 63}	{"taxTolerance": 55, "governmentTrust": 47, "policyAcceptance": 54, "regulationPreference": 70, "publicServiceSatisfaction": 89}	0
4106	이하은	55	50-59	Female	충청남도	36.599644	126.761449	전문대 졸	700만원 이상	생산직	부부 가구	47	보수 정당 지지	83	{"economy": 19, "housing": 5, "welfare": -26, "security": 32, "environment": 9}	지상파/종편 뉴스	{혁신,성장,전통}	충청남도에 거주하는 50-59 생산직. 정치 성향은 보수이며 혁신, 성장, 전통 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 34, "ecoConsciousness": 49, "priceSensitivity": 62, "digitalConsumption": 73}	{"taxTolerance": 69, "governmentTrust": 54, "policyAcceptance": 58, "regulationPreference": 71, "publicServiceSatisfaction": 64}	0
4107	윤광수	57	50-59	Male	충청남도	36.625205	126.617587	대학원 졸	500-700만원	프리랜서	1인 가구	7	중도 무당층	69	{"economy": 0, "housing": 38, "welfare": 9, "security": 18, "environment": -7}	지상파/종편 뉴스	{전통,혁신,공정}	충청남도에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 전통, 혁신, 공정 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 63, "ecoConsciousness": 48, "priceSensitivity": 56, "digitalConsumption": 57}	{"taxTolerance": 51, "governmentTrust": 52, "policyAcceptance": 40, "regulationPreference": 66, "publicServiceSatisfaction": 66}	0
4108	신성호	52	50-59	Male	충청남도	36.602279	126.758096	고졸 이하	350-500만원	전문직	부부 가구	-26	진보 성향 무당층	64	{"economy": -24, "housing": 51, "welfare": 34, "security": -9, "environment": 14}	포털 뉴스	{공동체,성장,전통}	충청남도에 거주하는 50-59 전문직. 정치 성향은 중도이며 공동체, 성장, 전통 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 65, "ecoConsciousness": 41, "priceSensitivity": 65, "digitalConsumption": 67}	{"taxTolerance": 55, "governmentTrust": 59, "policyAcceptance": 41, "regulationPreference": 66, "publicServiceSatisfaction": 59}	0
4109	임미경	50	50-59	Male	충청남도	36.666897	126.60068	대학원 졸	500-700만원	공무원	자녀 양육 가구	-13	중도 무당층	58	{"economy": -27, "housing": 29, "welfare": 13, "security": -8, "environment": 24}	유튜브	{안정,환경,안전}	충청남도에 거주하는 50-59 공무원. 정치 성향은 중도이며 안정, 환경, 안전 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 62, "ecoConsciousness": 65, "priceSensitivity": 59, "digitalConsumption": 75}	{"taxTolerance": 58, "governmentTrust": 53, "policyAcceptance": 65, "regulationPreference": 72, "publicServiceSatisfaction": 64}	0
4110	홍순자	60	60-69	Female	충청남도	36.664189	126.731543	전문대 졸	200-350만원	학생	자녀 양육 가구	15	보수 성향 무당층	82	{"economy": 15, "housing": -7, "welfare": 17, "security": 22, "environment": 2}	포털 뉴스	{다양성,전통,환경}	충청남도에 거주하는 60-69 학생. 정치 성향은 중도이며 다양성, 전통, 환경 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 57, "ecoConsciousness": 53, "priceSensitivity": 64, "digitalConsumption": 59}	{"taxTolerance": 51, "governmentTrust": 47, "policyAcceptance": 48, "regulationPreference": 81, "publicServiceSatisfaction": 63}	0
4111	이지아	62	60-69	Female	충청남도	36.610124	126.608612	전문대 졸	200-350만원	주부	다세대 가구	40	보수 성향 무당층	59	{"economy": 36, "housing": -17, "welfare": -4, "security": 31, "environment": -22}	SNS	{성장,다양성,자유}	충청남도에 거주하는 60-69 주부. 정치 성향은 보수이며 성장, 다양성, 자유 가치를 중시한다.	{"brandLoyalty": 70, "noveltySeeking": 47, "ecoConsciousness": 41, "priceSensitivity": 61, "digitalConsumption": 66}	{"taxTolerance": 43, "governmentTrust": 61, "policyAcceptance": 58, "regulationPreference": 61, "publicServiceSatisfaction": 50}	0
4112	서주원	69	60-69	Female	충청남도	36.588569	126.716341	전문대 졸	350-500만원	은퇴	1인 가구	-10	중도 무당층	83	{"economy": -32, "housing": 54, "welfare": 15, "security": -4, "environment": 37}	유튜브	{전통,안전,성장}	충청남도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 전통, 안전, 성장 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 62, "ecoConsciousness": 39, "priceSensitivity": 89, "digitalConsumption": 50}	{"taxTolerance": 50, "governmentTrust": 50, "policyAcceptance": 62, "regulationPreference": 59, "publicServiceSatisfaction": 69}	0
4113	박서연	63	60-69	Male	충청남도	36.711206	126.652145	전문대 졸	350-500만원	서비스직	다세대 가구	2	중도 무당층	75	{"economy": 22, "housing": 29, "welfare": 37, "security": 3, "environment": 18}	포털 뉴스	{다양성,공정,환경}	충청남도에 거주하는 60-69 서비스직. 정치 성향은 중도이며 다양성, 공정, 환경 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 62, "ecoConsciousness": 45, "priceSensitivity": 68, "digitalConsumption": 50}	{"taxTolerance": 48, "governmentTrust": 49, "policyAcceptance": 60, "regulationPreference": 73, "publicServiceSatisfaction": 71}	0
4114	장동현	69	60-69	Male	충청남도	36.722286	126.633109	대학원 졸	350-500만원	은퇴	다세대 가구	27	보수 성향 무당층	85	{"economy": 18, "housing": -13, "welfare": -13, "security": 51, "environment": -7}	신문/팟캐스트	{다양성,혁신,전통}	충청남도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 다양성, 혁신, 전통 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 54, "ecoConsciousness": 63, "priceSensitivity": 67, "digitalConsumption": 63}	{"taxTolerance": 63, "governmentTrust": 56, "policyAcceptance": 62, "regulationPreference": 64, "publicServiceSatisfaction": 49}	0
4115	오준서	64	60-69	Male	충청남도	36.652817	126.638391	전문대 졸	350-500만원	프리랜서	자녀 양육 가구	5	중도 무당층	85	{"economy": 36, "housing": 8, "welfare": 27, "security": 12, "environment": 19}	지상파/종편 뉴스	{공동체,안전,공정}	충청남도에 거주하는 60-69 프리랜서. 정치 성향은 중도이며 공동체, 안전, 공정 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 57, "ecoConsciousness": 46, "priceSensitivity": 70, "digitalConsumption": 55}	{"taxTolerance": 51, "governmentTrust": 48, "policyAcceptance": 32, "regulationPreference": 53, "publicServiceSatisfaction": 56}	0
4116	안혜진	71	70+	Female	충청남도	36.671821	126.621473	고졸 이하	200-350만원	은퇴	부부 가구	39	보수 성향 무당층	76	{"economy": 6, "housing": -6, "welfare": 4, "security": 27, "environment": 10}	유튜브	{안정,성장,전통}	충청남도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안정, 성장, 전통 가치를 중시한다.	{"brandLoyalty": 61, "noveltySeeking": 47, "ecoConsciousness": 53, "priceSensitivity": 77, "digitalConsumption": 46}	{"taxTolerance": 27, "governmentTrust": 55, "policyAcceptance": 75, "regulationPreference": 69, "publicServiceSatisfaction": 58}	0
4117	전순자	76	70+	Female	충청남도	36.59588	126.659018	대학교 졸	350-500만원	은퇴	다세대 가구	16	보수 성향 무당층	67	{"economy": 6, "housing": 23, "welfare": -9, "security": 20, "environment": 15}	유튜브	{안전,안정,공동체}	충청남도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안전, 안정, 공동체 가치를 중시한다.	{"brandLoyalty": 78, "noveltySeeking": 46, "ecoConsciousness": 48, "priceSensitivity": 45, "digitalConsumption": 39}	{"taxTolerance": 59, "governmentTrust": 53, "policyAcceptance": 72, "regulationPreference": 71, "publicServiceSatisfaction": 69}	0
4118	권은우	80	70+	Male	충청남도	36.673595	126.63041	대학원 졸	350-500만원	은퇴	자녀 양육 가구	15	보수 성향 무당층	99	{"economy": 19, "housing": 31, "welfare": -35, "security": 7, "environment": -6}	포털 뉴스	{다양성,공정,안전}	충청남도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 다양성, 공정, 안전 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 36, "ecoConsciousness": 38, "priceSensitivity": 68, "digitalConsumption": 49}	{"taxTolerance": 55, "governmentTrust": 60, "policyAcceptance": 63, "regulationPreference": 54, "publicServiceSatisfaction": 77}	0
4119	장지민	71	70+	Male	충청남도	36.666077	126.71136	전문대 졸	200만원 미만	은퇴	자녀 양육 가구	-16	진보 성향 무당층	83	{"economy": -13, "housing": 16, "welfare": 28, "security": 7, "environment": 19}	포털 뉴스	{전통,안정,공정}	충청남도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 전통, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 50, "ecoConsciousness": 49, "priceSensitivity": 100, "digitalConsumption": 55}	{"taxTolerance": 52, "governmentTrust": 72, "policyAcceptance": 58, "regulationPreference": 71, "publicServiceSatisfaction": 74}	0
4120	류영수	26	18-29	Female	전라남도	34.8639	126.534019	대학원 졸	350-500만원	전문직	1인 가구	-74	진보 정당 지지	31	{"economy": -43, "housing": 38, "welfare": 34, "security": -50, "environment": 97}	신문/팟캐스트	{혁신,안정,자유}	전라남도에 거주하는 18-29 전문직. 정치 성향은 진보이며 혁신, 안정, 자유 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 57, "ecoConsciousness": 79, "priceSensitivity": 57, "digitalConsumption": 67}	{"taxTolerance": 35, "governmentTrust": 48, "policyAcceptance": 22, "regulationPreference": 69, "publicServiceSatisfaction": 69}	0
4121	송민준	23	18-29	Female	전라남도	34.883823	126.429416	대학원 졸	200-350만원	프리랜서	부부 가구	-48	진보 정당 지지	39	{"economy": -49, "housing": 38, "welfare": 48, "security": -16, "environment": 54}	SNS	{안전,공정,전통}	전라남도에 거주하는 18-29 프리랜서. 정치 성향은 진보이며 안전, 공정, 전통 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 72, "ecoConsciousness": 73, "priceSensitivity": 52, "digitalConsumption": 79}	{"taxTolerance": 58, "governmentTrust": 51, "policyAcceptance": 52, "regulationPreference": 63, "publicServiceSatisfaction": 41}	0
4122	이지아	26	18-29	Male	전라남도	34.799379	126.555582	대학교 졸	200-350만원	사무직	자녀 양육 가구	-44	진보 성향 무당층	65	{"economy": -13, "housing": 26, "welfare": 26, "security": -25, "environment": 47}	포털 뉴스	{안전,안정,전통}	전라남도에 거주하는 18-29 사무직. 정치 성향은 진보이며 안전, 안정, 전통 가치를 중시한다.	{"brandLoyalty": 22, "noveltySeeking": 79, "ecoConsciousness": 45, "priceSensitivity": 81, "digitalConsumption": 83}	{"taxTolerance": 66, "governmentTrust": 39, "policyAcceptance": 52, "regulationPreference": 69, "publicServiceSatisfaction": 68}	0
4123	전철수	28	18-29	Male	전라남도	34.82598	126.504067	대학교 졸	200만원 미만	은퇴	부부 가구	-73	진보 정당 지지	50	{"economy": -76, "housing": 12, "welfare": 43, "security": -6, "environment": 29}	포털 뉴스	{안정,환경,다양성}	전라남도에 거주하는 18-29 은퇴. 정치 성향은 진보이며 안정, 환경, 다양성 가치를 중시한다.	{"brandLoyalty": 60, "noveltySeeking": 75, "ecoConsciousness": 38, "priceSensitivity": 65, "digitalConsumption": 74}	{"taxTolerance": 40, "governmentTrust": 46, "policyAcceptance": 34, "regulationPreference": 65, "publicServiceSatisfaction": 70}	0
4124	이하은	30	30-39	Female	전라남도	34.891684	126.56208	대학교 졸	350-500만원	생산직	부부 가구	-62	진보 정당 지지	70	{"economy": -38, "housing": 33, "welfare": 58, "security": -29, "environment": 31}	지상파/종편 뉴스	{안전,다양성,전통}	전라남도에 거주하는 30-39 생산직. 정치 성향은 진보이며 안전, 다양성, 전통 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 56, "ecoConsciousness": 52, "priceSensitivity": 67, "digitalConsumption": 77}	{"taxTolerance": 71, "governmentTrust": 34, "policyAcceptance": 61, "regulationPreference": 33, "publicServiceSatisfaction": 58}	0
4125	김주원	37	30-39	Female	전라남도	34.748092	126.422198	대학교 졸	700만원 이상	서비스직	1인 가구	-56	진보 정당 지지	38	{"economy": -42, "housing": 50, "welfare": 71, "security": -36, "environment": 29}	유튜브	{혁신,공동체,전통}	전라남도에 거주하는 30-39 서비스직. 정치 성향은 진보이며 혁신, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 23, "noveltySeeking": 57, "ecoConsciousness": 46, "priceSensitivity": 48, "digitalConsumption": 72}	{"taxTolerance": 61, "governmentTrust": 53, "policyAcceptance": 58, "regulationPreference": 79, "publicServiceSatisfaction": 54}	0
4126	류민서	34	30-39	Male	전라남도	34.874909	126.544521	대학교 졸	700만원 이상	은퇴	자녀 양육 가구	-52	진보 정당 지지	40	{"economy": -48, "housing": 26, "welfare": 16, "security": -35, "environment": 43}	포털 뉴스	{안정,공동체,안전}	전라남도에 거주하는 30-39 은퇴. 정치 성향은 진보이며 안정, 공동체, 안전 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 70, "ecoConsciousness": 47, "priceSensitivity": 45, "digitalConsumption": 83}	{"taxTolerance": 73, "governmentTrust": 47, "policyAcceptance": 34, "regulationPreference": 75, "publicServiceSatisfaction": 87}	0
4127	강지아	38	30-39	Male	전라남도	34.791166	126.541722	대학교 졸	700만원 이상	전문직	1인 가구	-72	진보 정당 지지	70	{"economy": -65, "housing": 14, "welfare": 42, "security": -50, "environment": 13}	포털 뉴스	{성장,안정,공정}	전라남도에 거주하는 30-39 전문직. 정치 성향은 진보이며 성장, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 25, "noveltySeeking": 69, "ecoConsciousness": 35, "priceSensitivity": 36, "digitalConsumption": 79}	{"taxTolerance": 44, "governmentTrust": 36, "policyAcceptance": 30, "regulationPreference": 49, "publicServiceSatisfaction": 68}	0
4128	강경숙	48	40-49	Female	전라남도	34.821032	126.539466	전문대 졸	500-700만원	공무원	다세대 가구	-22	진보 성향 무당층	50	{"economy": -19, "housing": 55, "welfare": 42, "security": -4, "environment": 43}	신문/팟캐스트	{혁신,성장,전통}	전라남도에 거주하는 40-49 공무원. 정치 성향은 중도이며 혁신, 성장, 전통 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 62, "ecoConsciousness": 68, "priceSensitivity": 46, "digitalConsumption": 95}	{"taxTolerance": 37, "governmentTrust": 58, "policyAcceptance": 47, "regulationPreference": 57, "publicServiceSatisfaction": 60}	0
4129	이민서	48	40-49	Female	전라남도	34.83654	126.40567	고졸 이하	500-700만원	프리랜서	부부 가구	-35	진보 성향 무당층	55	{"economy": -5, "housing": 35, "welfare": 44, "security": -34, "environment": 57}	포털 뉴스	{성장,환경,공동체}	전라남도에 거주하는 40-49 프리랜서. 정치 성향은 진보이며 성장, 환경, 공동체 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 68, "ecoConsciousness": 47, "priceSensitivity": 58, "digitalConsumption": 66}	{"taxTolerance": 41, "governmentTrust": 58, "policyAcceptance": 53, "regulationPreference": 65, "publicServiceSatisfaction": 62}	0
4130	김도윤	44	40-49	Female	전라남도	34.806638	126.372902	전문대 졸	350-500만원	서비스직	자녀 양육 가구	-57	진보 정당 지지	53	{"economy": -36, "housing": 22, "welfare": 24, "security": -27, "environment": 66}	유튜브	{다양성,환경,혁신}	전라남도에 거주하는 40-49 서비스직. 정치 성향은 진보이며 다양성, 환경, 혁신 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 66, "ecoConsciousness": 37, "priceSensitivity": 71, "digitalConsumption": 60}	{"taxTolerance": 47, "governmentTrust": 51, "policyAcceptance": 25, "regulationPreference": 69, "publicServiceSatisfaction": 64}	0
4131	한정희	41	40-49	Male	전라남도	34.803784	126.497235	고졸 이하	350-500만원	사무직	1인 가구	-59	진보 정당 지지	80	{"economy": -10, "housing": 27, "welfare": 35, "security": -6, "environment": 58}	SNS	{자유,공동체,성장}	전라남도에 거주하는 40-49 사무직. 정치 성향은 진보이며 자유, 공동체, 성장 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 49, "ecoConsciousness": 41, "priceSensitivity": 50, "digitalConsumption": 87}	{"taxTolerance": 70, "governmentTrust": 66, "policyAcceptance": 67, "regulationPreference": 75, "publicServiceSatisfaction": 81}	0
4132	권건우	45	40-49	Male	전라남도	34.821628	126.49383	고졸 이하	700만원 이상	전문직	자녀 양육 가구	-52	진보 정당 지지	58	{"economy": -47, "housing": 23, "welfare": 44, "security": -23, "environment": 1}	SNS	{환경,공정,혁신}	전라남도에 거주하는 40-49 전문직. 정치 성향은 진보이며 환경, 공정, 혁신 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 61, "ecoConsciousness": 45, "priceSensitivity": 38, "digitalConsumption": 66}	{"taxTolerance": 62, "governmentTrust": 69, "policyAcceptance": 46, "regulationPreference": 65, "publicServiceSatisfaction": 68}	0
4133	이예준	49	40-49	Male	전라남도	34.768625	126.43178	대학교 졸	500-700만원	서비스직	자녀 양육 가구	-27	진보 성향 무당층	52	{"economy": -20, "housing": 48, "welfare": 34, "security": -31, "environment": 38}	포털 뉴스	{다양성,혁신,안전}	전라남도에 거주하는 40-49 서비스직. 정치 성향은 중도이며 다양성, 혁신, 안전 가치를 중시한다.	{"brandLoyalty": 17, "noveltySeeking": 52, "ecoConsciousness": 38, "priceSensitivity": 42, "digitalConsumption": 80}	{"taxTolerance": 56, "governmentTrust": 52, "policyAcceptance": 47, "regulationPreference": 66, "publicServiceSatisfaction": 75}	0
4134	전서연	55	50-59	Female	전라남도	34.862159	126.492092	대학원 졸	700만원 이상	학생	부부 가구	-61	진보 정당 지지	63	{"economy": -33, "housing": 26, "welfare": 27, "security": -36, "environment": 53}	포털 뉴스	{성장,공동체,다양성}	전라남도에 거주하는 50-59 학생. 정치 성향은 진보이며 성장, 공동체, 다양성 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 77, "ecoConsciousness": 51, "priceSensitivity": 33, "digitalConsumption": 64}	{"taxTolerance": 33, "governmentTrust": 42, "policyAcceptance": 53, "regulationPreference": 71, "publicServiceSatisfaction": 68}	0
4135	최은우	52	50-59	Female	전라남도	34.810331	126.390981	대학교 졸	500-700만원	서비스직	자녀 양육 가구	-29	진보 성향 무당층	59	{"economy": -14, "housing": 30, "welfare": -3, "security": -28, "environment": 37}	SNS	{안정,다양성,안전}	전라남도에 거주하는 50-59 서비스직. 정치 성향은 중도이며 안정, 다양성, 안전 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 58, "ecoConsciousness": 44, "priceSensitivity": 51, "digitalConsumption": 79}	{"taxTolerance": 66, "governmentTrust": 44, "policyAcceptance": 38, "regulationPreference": 59, "publicServiceSatisfaction": 77}	0
4136	서동현	57	50-59	Female	전라남도	34.848119	126.430157	전문대 졸	500-700만원	전문직	부부 가구	-8	중도 무당층	79	{"economy": -4, "housing": 25, "welfare": 23, "security": -1, "environment": -1}	포털 뉴스	{다양성,공동체,자유}	전라남도에 거주하는 50-59 전문직. 정치 성향은 중도이며 다양성, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 48, "ecoConsciousness": 37, "priceSensitivity": 50, "digitalConsumption": 60}	{"taxTolerance": 47, "governmentTrust": 54, "policyAcceptance": 75, "regulationPreference": 70, "publicServiceSatisfaction": 69}	0
4137	박광수	55	50-59	Male	전라남도	34.86834	126.474487	전문대 졸	350-500만원	프리랜서	자녀 양육 가구	-54	진보 정당 지지	67	{"economy": -65, "housing": -6, "welfare": 27, "security": -26, "environment": 40}	지상파/종편 뉴스	{자유,안전,혁신}	전라남도에 거주하는 50-59 프리랜서. 정치 성향은 진보이며 자유, 안전, 혁신 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 47, "ecoConsciousness": 62, "priceSensitivity": 49, "digitalConsumption": 76}	{"taxTolerance": 33, "governmentTrust": 34, "policyAcceptance": 41, "regulationPreference": 53, "publicServiceSatisfaction": 64}	0
4138	황정희	54	50-59	Male	전라남도	34.738197	126.395865	고졸 이하	200만원 미만	공무원	자녀 양육 가구	-45	진보 정당 지지	69	{"economy": -25, "housing": 43, "welfare": 39, "security": -31, "environment": 50}	유튜브	{혁신,안전,공정}	전라남도에 거주하는 50-59 공무원. 정치 성향은 진보이며 혁신, 안전, 공정 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 53, "ecoConsciousness": 64, "priceSensitivity": 83, "digitalConsumption": 64}	{"taxTolerance": 46, "governmentTrust": 34, "policyAcceptance": 53, "regulationPreference": 59, "publicServiceSatisfaction": 61}	0
4139	오성호	59	50-59	Male	전라남도	34.861211	126.390036	전문대 졸	350-500만원	프리랜서	자녀 양육 가구	-20	진보 성향 무당층	93	{"economy": -47, "housing": 20, "welfare": 55, "security": 10, "environment": 47}	포털 뉴스	{혁신,안전,성장}	전라남도에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 혁신, 안전, 성장 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 81, "ecoConsciousness": 45, "priceSensitivity": 63, "digitalConsumption": 34}	{"taxTolerance": 40, "governmentTrust": 69, "policyAcceptance": 68, "regulationPreference": 71, "publicServiceSatisfaction": 80}	0
4140	서유준	68	60-69	Female	전라남도	34.793515	126.41372	대학원 졸	350-500만원	은퇴	부부 가구	3	중도 무당층	67	{"economy": 14, "housing": 19, "welfare": 4, "security": -1, "environment": 26}	유튜브	{환경,공동체,성장}	전라남도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 환경, 공동체, 성장 가치를 중시한다.	{"brandLoyalty": 64, "noveltySeeking": 53, "ecoConsciousness": 48, "priceSensitivity": 71, "digitalConsumption": 46}	{"taxTolerance": 62, "governmentTrust": 23, "policyAcceptance": 47, "regulationPreference": 54, "publicServiceSatisfaction": 64}	0
4141	오준서	61	60-69	Female	전라남도	34.785677	126.426707	대학교 졸	500-700만원	은퇴	다세대 가구	-49	진보 정당 지지	92	{"economy": -7, "housing": 30, "welfare": 18, "security": -45, "environment": 27}	유튜브	{공동체,공정,다양성}	전라남도에 거주하는 60-69 은퇴. 정치 성향은 진보이며 공동체, 공정, 다양성 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 49, "ecoConsciousness": 39, "priceSensitivity": 43, "digitalConsumption": 60}	{"taxTolerance": 48, "governmentTrust": 58, "policyAcceptance": 54, "regulationPreference": 86, "publicServiceSatisfaction": 49}	0
4142	최성호	68	60-69	Male	전라남도	34.830401	126.475296	대학교 졸	200-350만원	은퇴	부부 가구	-16	진보 성향 무당층	61	{"economy": -60, "housing": 34, "welfare": 8, "security": 18, "environment": 21}	포털 뉴스	{혁신,공정,성장}	전라남도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 혁신, 공정, 성장 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 52, "ecoConsciousness": 27, "priceSensitivity": 71, "digitalConsumption": 38}	{"taxTolerance": 57, "governmentTrust": 62, "policyAcceptance": 61, "regulationPreference": 70, "publicServiceSatisfaction": 61}	0
4143	박지호	69	60-69	Male	전라남도	34.771171	126.450364	대학원 졸	500-700만원	은퇴	다세대 가구	-25	진보 성향 무당층	86	{"economy": -19, "housing": 13, "welfare": 12, "security": -15, "environment": 18}	신문/팟캐스트	{자유,공정,혁신}	전라남도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 자유, 공정, 혁신 가치를 중시한다.	{"brandLoyalty": 64, "noveltySeeking": 66, "ecoConsciousness": 59, "priceSensitivity": 44, "digitalConsumption": 55}	{"taxTolerance": 40, "governmentTrust": 29, "policyAcceptance": 42, "regulationPreference": 85, "publicServiceSatisfaction": 74}	0
4144	장지아	82	70+	Female	전라남도	34.877298	126.463956	대학원 졸	700만원 이상	은퇴	1인 가구	-20	진보 성향 무당층	70	{"economy": -22, "housing": 22, "welfare": 23, "security": 5, "environment": 14}	지상파/종편 뉴스	{전통,안정,공동체}	전라남도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 전통, 안정, 공동체 가치를 중시한다.	{"brandLoyalty": 74, "noveltySeeking": 39, "ecoConsciousness": 41, "priceSensitivity": 58, "digitalConsumption": 65}	{"taxTolerance": 53, "governmentTrust": 66, "policyAcceptance": 52, "regulationPreference": 74, "publicServiceSatisfaction": 61}	0
4145	권지우	74	70+	Female	전라남도	34.891195	126.38788	고졸 이하	200-350만원	은퇴	자녀 양육 가구	-24	진보 성향 무당층	92	{"economy": -4, "housing": 19, "welfare": 32, "security": -6, "environment": 58}	신문/팟캐스트	{안전,자유,다양성}	전라남도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안전, 자유, 다양성 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 38, "ecoConsciousness": 59, "priceSensitivity": 74, "digitalConsumption": 44}	{"taxTolerance": 61, "governmentTrust": 56, "policyAcceptance": 43, "regulationPreference": 73, "publicServiceSatisfaction": 63}	0
4146	임은우	80	70+	Male	전라남도	34.792888	126.374345	대학교 졸	350-500만원	은퇴	1인 가구	-33	진보 성향 무당층	99	{"economy": -24, "housing": 68, "welfare": 40, "security": 1, "environment": 28}	신문/팟캐스트	{자유,전통,혁신}	전라남도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 자유, 전통, 혁신 가치를 중시한다.	{"brandLoyalty": 78, "noveltySeeking": 48, "ecoConsciousness": 39, "priceSensitivity": 62, "digitalConsumption": 45}	{"taxTolerance": 34, "governmentTrust": 55, "policyAcceptance": 42, "regulationPreference": 70, "publicServiceSatisfaction": 80}	0
4147	안미경	77	70+	Male	전라남도	34.777687	126.466369	대학교 졸	350-500만원	은퇴	부부 가구	-14	중도 무당층	89	{"economy": -18, "housing": 26, "welfare": 3, "security": -27, "environment": -11}	포털 뉴스	{안전,안정,전통}	전라남도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안전, 안정, 전통 가치를 중시한다.	{"brandLoyalty": 69, "noveltySeeking": 38, "ecoConsciousness": 44, "priceSensitivity": 51, "digitalConsumption": 49}	{"taxTolerance": 35, "governmentTrust": 48, "policyAcceptance": 57, "regulationPreference": 83, "publicServiceSatisfaction": 80}	0
4148	조광수	26	18-29	Female	경상북도	36.556985	128.501002	전문대 졸	350-500만원	서비스직	부부 가구	23	보수 성향 무당층	50	{"economy": 23, "housing": -29, "welfare": 10, "security": 8, "environment": 26}	신문/팟캐스트	{공정,자유,공동체}	경상북도에 거주하는 18-29 서비스직. 정치 성향은 중도이며 공정, 자유, 공동체 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 73, "ecoConsciousness": 49, "priceSensitivity": 43, "digitalConsumption": 88}	{"taxTolerance": 58, "governmentTrust": 47, "policyAcceptance": 43, "regulationPreference": 66, "publicServiceSatisfaction": 95}	0
4149	최미경	20	18-29	Female	경상북도	36.635696	128.532297	대학교 졸	350-500만원	학생	1인 가구	14	중도 무당층	47	{"economy": -5, "housing": 12, "welfare": 9, "security": 12, "environment": 27}	SNS	{자유,안정,안전}	경상북도에 거주하는 18-29 학생. 정치 성향은 중도이며 자유, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 21, "noveltySeeking": 64, "ecoConsciousness": 51, "priceSensitivity": 80, "digitalConsumption": 70}	{"taxTolerance": 36, "governmentTrust": 46, "policyAcceptance": 56, "regulationPreference": 74, "publicServiceSatisfaction": 44}	0
4150	김서윤	25	18-29	Female	경상북도	36.520623	128.518351	대학교 졸	200-350만원	자영업	1인 가구	-40	진보 성향 무당층	55	{"economy": -60, "housing": 33, "welfare": 21, "security": -6, "environment": 33}	지상파/종편 뉴스	{안정,전통,자유}	경상북도에 거주하는 18-29 자영업. 정치 성향은 진보이며 안정, 전통, 자유 가치를 중시한다.	{"brandLoyalty": 17, "noveltySeeking": 62, "ecoConsciousness": 40, "priceSensitivity": 77, "digitalConsumption": 82}	{"taxTolerance": 43, "governmentTrust": 37, "policyAcceptance": 50, "regulationPreference": 61, "publicServiceSatisfaction": 73}	0
4151	정유준	26	18-29	Male	경상북도	36.546769	128.463086	대학교 졸	700만원 이상	공무원	1인 가구	43	보수 성향 무당층	34	{"economy": 15, "housing": -17, "welfare": 17, "security": 34, "environment": 14}	유튜브	{공동체,환경,안정}	경상북도에 거주하는 18-29 공무원. 정치 성향은 보수이며 공동체, 환경, 안정 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 66, "ecoConsciousness": 47, "priceSensitivity": 41, "digitalConsumption": 82}	{"taxTolerance": 57, "governmentTrust": 41, "policyAcceptance": 43, "regulationPreference": 75, "publicServiceSatisfaction": 65}	0
4152	류준서	25	18-29	Male	경상북도	36.624077	128.508416	대학원 졸	200-350만원	주부	부부 가구	-5	중도 무당층	55	{"economy": -20, "housing": 21, "welfare": 28, "security": -5, "environment": 44}	포털 뉴스	{자유,다양성,전통}	경상북도에 거주하는 18-29 주부. 정치 성향은 중도이며 자유, 다양성, 전통 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 76, "ecoConsciousness": 65, "priceSensitivity": 78, "digitalConsumption": 66}	{"taxTolerance": 36, "governmentTrust": 25, "policyAcceptance": 63, "regulationPreference": 61, "publicServiceSatisfaction": 47}	0
4153	이서연	20	18-29	Male	경상북도	36.585431	128.589235	고졸 이하	350-500만원	학생	자녀 양육 가구	-6	중도 무당층	51	{"economy": -1, "housing": 14, "welfare": -7, "security": 5, "environment": 23}	유튜브	{안전,안정,혁신}	경상북도에 거주하는 18-29 학생. 정치 성향은 중도이며 안전, 안정, 혁신 가치를 중시한다.	{"brandLoyalty": 25, "noveltySeeking": 57, "ecoConsciousness": 52, "priceSensitivity": 78, "digitalConsumption": 88}	{"taxTolerance": 34, "governmentTrust": 54, "policyAcceptance": 47, "regulationPreference": 57, "publicServiceSatisfaction": 60}	0
4154	최지아	39	30-39	Female	경상북도	36.583954	128.590796	대학교 졸	500-700만원	주부	다세대 가구	1	중도 무당층	58	{"economy": 20, "housing": 14, "welfare": 22, "security": 20, "environment": 11}	포털 뉴스	{안전,다양성,성장}	경상북도에 거주하는 30-39 주부. 정치 성향은 중도이며 안전, 다양성, 성장 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 49, "ecoConsciousness": 48, "priceSensitivity": 69, "digitalConsumption": 83}	{"taxTolerance": 49, "governmentTrust": 33, "policyAcceptance": 33, "regulationPreference": 59, "publicServiceSatisfaction": 65}	0
4155	장현우	34	30-39	Female	경상북도	36.581898	128.599597	전문대 졸	350-500만원	프리랜서	부부 가구	15	보수 성향 무당층	57	{"economy": -4, "housing": 11, "welfare": 7, "security": 54, "environment": 1}	포털 뉴스	{성장,공동체,자유}	경상북도에 거주하는 30-39 프리랜서. 정치 성향은 중도이며 성장, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 70, "ecoConsciousness": 34, "priceSensitivity": 47, "digitalConsumption": 71}	{"taxTolerance": 41, "governmentTrust": 52, "policyAcceptance": 41, "regulationPreference": 54, "publicServiceSatisfaction": 63}	0
4156	서미경	36	30-39	Female	경상북도	36.593134	128.473058	전문대 졸	500-700만원	학생	자녀 양육 가구	3	중도 무당층	58	{"economy": 7, "housing": 31, "welfare": 34, "security": 12, "environment": 6}	SNS	{공동체,다양성,전통}	경상북도에 거주하는 30-39 학생. 정치 성향은 중도이며 공동체, 다양성, 전통 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 69, "ecoConsciousness": 36, "priceSensitivity": 56, "digitalConsumption": 95}	{"taxTolerance": 45, "governmentTrust": 49, "policyAcceptance": 54, "regulationPreference": 70, "publicServiceSatisfaction": 64}	0
4157	전민준	36	30-39	Male	경상북도	36.527084	128.491212	대학원 졸	350-500만원	프리랜서	자녀 양육 가구	13	중도 무당층	71	{"economy": 6, "housing": 2, "welfare": 15, "security": 14, "environment": 36}	유튜브	{공동체,자유,환경}	경상북도에 거주하는 30-39 프리랜서. 정치 성향은 중도이며 공동체, 자유, 환경 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 83, "ecoConsciousness": 63, "priceSensitivity": 56, "digitalConsumption": 65}	{"taxTolerance": 74, "governmentTrust": 37, "policyAcceptance": 27, "regulationPreference": 64, "publicServiceSatisfaction": 65}	0
4158	서동현	32	30-39	Male	경상북도	36.503001	128.555906	대학원 졸	500-700만원	공무원	자녀 양육 가구	-10	중도 무당층	56	{"economy": -31, "housing": 15, "welfare": 11, "security": 2, "environment": 29}	포털 뉴스	{다양성,자유,공동체}	경상북도에 거주하는 30-39 공무원. 정치 성향은 중도이며 다양성, 자유, 공동체 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 59, "ecoConsciousness": 48, "priceSensitivity": 86, "digitalConsumption": 80}	{"taxTolerance": 67, "governmentTrust": 47, "policyAcceptance": 37, "regulationPreference": 50, "publicServiceSatisfaction": 69}	0
4159	정하은	38	30-39	Male	경상북도	36.520796	128.499985	대학교 졸	500-700만원	전문직	부부 가구	6	중도 무당층	71	{"economy": 0, "housing": 8, "welfare": 38, "security": -3, "environment": 20}	지상파/종편 뉴스	{공정,혁신,성장}	경상북도에 거주하는 30-39 전문직. 정치 성향은 중도이며 공정, 혁신, 성장 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 69, "ecoConsciousness": 43, "priceSensitivity": 43, "digitalConsumption": 86}	{"taxTolerance": 61, "governmentTrust": 49, "policyAcceptance": 40, "regulationPreference": 51, "publicServiceSatisfaction": 68}	0
4160	조다은	42	40-49	Female	경상북도	36.501136	128.547979	대학교 졸	700만원 이상	생산직	1인 가구	40	보수 성향 무당층	67	{"economy": 12, "housing": -11, "welfare": -8, "security": 26, "environment": 26}	지상파/종편 뉴스	{환경,다양성,전통}	경상북도에 거주하는 40-49 생산직. 정치 성향은 보수이며 환경, 다양성, 전통 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 64, "ecoConsciousness": 56, "priceSensitivity": 45, "digitalConsumption": 65}	{"taxTolerance": 39, "governmentTrust": 39, "policyAcceptance": 47, "regulationPreference": 72, "publicServiceSatisfaction": 67}	0
4161	박서연	44	40-49	Female	경상북도	36.542556	128.42863	대학원 졸	500-700만원	은퇴	자녀 양육 가구	20	보수 성향 무당층	71	{"economy": 31, "housing": 23, "welfare": -2, "security": 13, "environment": 23}	유튜브	{자유,다양성,공동체}	경상북도에 거주하는 40-49 은퇴. 정치 성향은 중도이며 자유, 다양성, 공동체 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 67, "ecoConsciousness": 52, "priceSensitivity": 51, "digitalConsumption": 74}	{"taxTolerance": 73, "governmentTrust": 47, "policyAcceptance": 51, "regulationPreference": 66, "publicServiceSatisfaction": 78}	0
4162	장지우	48	40-49	Female	경상북도	36.51969	128.535257	대학교 졸	500-700만원	생산직	자녀 양육 가구	25	보수 성향 무당층	51	{"economy": -2, "housing": 20, "welfare": -2, "security": 19, "environment": -8}	포털 뉴스	{환경,자유,성장}	경상북도에 거주하는 40-49 생산직. 정치 성향은 중도이며 환경, 자유, 성장 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 49, "ecoConsciousness": 55, "priceSensitivity": 62, "digitalConsumption": 76}	{"taxTolerance": 56, "governmentTrust": 55, "policyAcceptance": 54, "regulationPreference": 61, "publicServiceSatisfaction": 59}	0
4163	최주원	42	40-49	Female	경상북도	36.591926	128.528069	고졸 이하	200만원 미만	사무직	부부 가구	0	중도 무당층	69	{"economy": -40, "housing": 23, "welfare": 31, "security": 2, "environment": 25}	포털 뉴스	{전통,공정,혁신}	경상북도에 거주하는 40-49 사무직. 정치 성향은 중도이며 전통, 공정, 혁신 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 63, "ecoConsciousness": 51, "priceSensitivity": 58, "digitalConsumption": 81}	{"taxTolerance": 41, "governmentTrust": 37, "policyAcceptance": 65, "regulationPreference": 58, "publicServiceSatisfaction": 81}	0
4164	최미경	48	40-49	Male	경상북도	36.655991	128.525964	대학교 졸	500-700만원	은퇴	다세대 가구	-2	중도 무당층	83	{"economy": -19, "housing": -2, "welfare": 9, "security": -22, "environment": 19}	지상파/종편 뉴스	{자유,공동체,다양성}	경상북도에 거주하는 40-49 은퇴. 정치 성향은 중도이며 자유, 공동체, 다양성 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 45, "ecoConsciousness": 38, "priceSensitivity": 65, "digitalConsumption": 70}	{"taxTolerance": 26, "governmentTrust": 57, "policyAcceptance": 58, "regulationPreference": 49, "publicServiceSatisfaction": 76}	0
4165	장동현	44	40-49	Male	경상북도	36.505361	128.492227	대학교 졸	500-700만원	생산직	1인 가구	32	보수 성향 무당층	68	{"economy": 20, "housing": 0, "welfare": -19, "security": 37, "environment": 2}	지상파/종편 뉴스	{다양성,자유,공동체}	경상북도에 거주하는 40-49 생산직. 정치 성향은 중도이며 다양성, 자유, 공동체 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 58, "ecoConsciousness": 40, "priceSensitivity": 65, "digitalConsumption": 70}	{"taxTolerance": 57, "governmentTrust": 40, "policyAcceptance": 49, "regulationPreference": 72, "publicServiceSatisfaction": 63}	0
4166	송순자	47	40-49	Male	경상북도	36.545494	128.462864	대학원 졸	350-500만원	공무원	다세대 가구	53	보수 정당 지지	94	{"economy": 42, "housing": -2, "welfare": -18, "security": 35, "environment": 15}	포털 뉴스	{자유,공정,공동체}	경상북도에 거주하는 40-49 공무원. 정치 성향은 보수이며 자유, 공정, 공동체 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 75, "ecoConsciousness": 35, "priceSensitivity": 73, "digitalConsumption": 79}	{"taxTolerance": 72, "governmentTrust": 44, "policyAcceptance": 37, "regulationPreference": 59, "publicServiceSatisfaction": 57}	0
4167	임하은	40	40-49	Male	경상북도	36.651706	128.415914	대학원 졸	500-700만원	사무직	다세대 가구	11	중도 무당층	59	{"economy": -5, "housing": 27, "welfare": 27, "security": 31, "environment": 32}	신문/팟캐스트	{안전,성장,환경}	경상북도에 거주하는 40-49 사무직. 정치 성향은 중도이며 안전, 성장, 환경 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 62, "ecoConsciousness": 44, "priceSensitivity": 51, "digitalConsumption": 90}	{"taxTolerance": 48, "governmentTrust": 57, "policyAcceptance": 56, "regulationPreference": 82, "publicServiceSatisfaction": 71}	0
4168	서경숙	53	50-59	Female	경상북도	36.582531	128.490282	대학교 졸	500-700만원	서비스직	부부 가구	5	중도 무당층	61	{"economy": -9, "housing": 0, "welfare": 32, "security": 13, "environment": 27}	유튜브	{안전,공정,환경}	경상북도에 거주하는 50-59 서비스직. 정치 성향은 중도이며 안전, 공정, 환경 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 54, "ecoConsciousness": 49, "priceSensitivity": 64, "digitalConsumption": 80}	{"taxTolerance": 55, "governmentTrust": 37, "policyAcceptance": 63, "regulationPreference": 77, "publicServiceSatisfaction": 80}	0
4169	오유준	54	50-59	Female	경상북도	36.543401	128.455473	대학교 졸	350-500만원	프리랜서	자녀 양육 가구	42	보수 성향 무당층	80	{"economy": 0, "housing": -4, "welfare": 23, "security": 39, "environment": -22}	SNS	{다양성,안정,공동체}	경상북도에 거주하는 50-59 프리랜서. 정치 성향은 보수이며 다양성, 안정, 공동체 가치를 중시한다.	{"brandLoyalty": 64, "noveltySeeking": 47, "ecoConsciousness": 45, "priceSensitivity": 72, "digitalConsumption": 58}	{"taxTolerance": 19, "governmentTrust": 41, "policyAcceptance": 43, "regulationPreference": 71, "publicServiceSatisfaction": 70}	0
4170	장다은	58	50-59	Female	경상북도	36.552626	128.443595	대학교 졸	200-350만원	공무원	다세대 가구	22	보수 성향 무당층	79	{"economy": 33, "housing": -8, "welfare": -10, "security": 43, "environment": 10}	지상파/종편 뉴스	{환경,안전,자유}	경상북도에 거주하는 50-59 공무원. 정치 성향은 중도이며 환경, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 55, "ecoConsciousness": 52, "priceSensitivity": 65, "digitalConsumption": 61}	{"taxTolerance": 56, "governmentTrust": 47, "policyAcceptance": 50, "regulationPreference": 49, "publicServiceSatisfaction": 62}	0
4171	황서윤	50	50-59	Female	경상북도	36.610556	128.585592	대학교 졸	700만원 이상	공무원	다세대 가구	25	보수 성향 무당층	69	{"economy": 19, "housing": 14, "welfare": 4, "security": 33, "environment": 11}	포털 뉴스	{안정,환경,공동체}	경상북도에 거주하는 50-59 공무원. 정치 성향은 중도이며 안정, 환경, 공동체 가치를 중시한다.	{"brandLoyalty": 19, "noveltySeeking": 51, "ecoConsciousness": 40, "priceSensitivity": 62, "digitalConsumption": 63}	{"taxTolerance": 61, "governmentTrust": 52, "policyAcceptance": 74, "regulationPreference": 70, "publicServiceSatisfaction": 64}	0
4172	황하은	59	50-59	Male	경상북도	36.625074	128.568924	고졸 이하	350-500만원	서비스직	부부 가구	27	보수 성향 무당층	75	{"economy": 32, "housing": 8, "welfare": -29, "security": 26, "environment": -10}	신문/팟캐스트	{성장,공정,자유}	경상북도에 거주하는 50-59 서비스직. 정치 성향은 중도이며 성장, 공정, 자유 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 35, "ecoConsciousness": 60, "priceSensitivity": 68, "digitalConsumption": 59}	{"taxTolerance": 56, "governmentTrust": 37, "policyAcceptance": 65, "regulationPreference": 55, "publicServiceSatisfaction": 56}	0
4173	조미경	53	50-59	Male	경상북도	36.497931	128.575481	대학교 졸	500-700만원	서비스직	자녀 양육 가구	28	보수 성향 무당층	83	{"economy": -2, "housing": 39, "welfare": 21, "security": 31, "environment": 42}	유튜브	{혁신,환경,성장}	경상북도에 거주하는 50-59 서비스직. 정치 성향은 중도이며 혁신, 환경, 성장 가치를 중시한다.	{"brandLoyalty": 65, "noveltySeeking": 82, "ecoConsciousness": 44, "priceSensitivity": 41, "digitalConsumption": 81}	{"taxTolerance": 41, "governmentTrust": 57, "policyAcceptance": 27, "regulationPreference": 59, "publicServiceSatisfaction": 64}	0
4174	황유준	55	50-59	Male	경상북도	36.632339	128.507565	전문대 졸	200-350만원	사무직	1인 가구	-23	진보 성향 무당층	75	{"economy": 2, "housing": 21, "welfare": 40, "security": -31, "environment": -10}	포털 뉴스	{성장,안정,공정}	경상북도에 거주하는 50-59 사무직. 정치 성향은 중도이며 성장, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 63, "ecoConsciousness": 42, "priceSensitivity": 56, "digitalConsumption": 53}	{"taxTolerance": 30, "governmentTrust": 32, "policyAcceptance": 72, "regulationPreference": 73, "publicServiceSatisfaction": 42}	0
4175	전유준	51	50-59	Male	경상북도	36.611082	128.604402	전문대 졸	700만원 이상	자영업	부부 가구	-9	중도 무당층	64	{"economy": -1, "housing": 20, "welfare": 17, "security": -5, "environment": 45}	신문/팟캐스트	{전통,자유,환경}	경상북도에 거주하는 50-59 자영업. 정치 성향은 중도이며 전통, 자유, 환경 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 65, "ecoConsciousness": 33, "priceSensitivity": 50, "digitalConsumption": 62}	{"taxTolerance": 38, "governmentTrust": 49, "policyAcceptance": 61, "regulationPreference": 60, "publicServiceSatisfaction": 91}	0
4176	최지아	68	60-69	Female	경상북도	36.575331	128.576565	대학교 졸	200만원 미만	은퇴	다세대 가구	31	보수 성향 무당층	77	{"economy": 8, "housing": -9, "welfare": 3, "security": 21, "environment": 1}	신문/팟캐스트	{공정,안정,공동체}	경상북도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 공정, 안정, 공동체 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 58, "ecoConsciousness": 50, "priceSensitivity": 83, "digitalConsumption": 50}	{"taxTolerance": 27, "governmentTrust": 60, "policyAcceptance": 55, "regulationPreference": 62, "publicServiceSatisfaction": 64}	0
4177	윤수아	66	60-69	Female	경상북도	36.507359	128.508393	대학원 졸	700만원 이상	전문직	자녀 양육 가구	45	보수 정당 지지	75	{"economy": 30, "housing": 19, "welfare": -5, "security": 14, "environment": -5}	신문/팟캐스트	{공동체,다양성,성장}	경상북도에 거주하는 60-69 전문직. 정치 성향은 보수이며 공동체, 다양성, 성장 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 71, "ecoConsciousness": 44, "priceSensitivity": 25, "digitalConsumption": 63}	{"taxTolerance": 59, "governmentTrust": 60, "policyAcceptance": 43, "regulationPreference": 76, "publicServiceSatisfaction": 48}	0
4178	최동현	64	60-69	Female	경상북도	36.509901	128.591603	대학교 졸	350-500만원	서비스직	다세대 가구	37	보수 성향 무당층	60	{"economy": 42, "housing": 28, "welfare": -22, "security": 6, "environment": 48}	SNS	{자유,환경,공정}	경상북도에 거주하는 60-69 서비스직. 정치 성향은 보수이며 자유, 환경, 공정 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 63, "ecoConsciousness": 39, "priceSensitivity": 63, "digitalConsumption": 44}	{"taxTolerance": 59, "governmentTrust": 46, "policyAcceptance": 42, "regulationPreference": 77, "publicServiceSatisfaction": 59}	0
4179	전현우	64	60-69	Male	경상북도	36.555732	128.532739	고졸 이하	350-500만원	공무원	1인 가구	51	보수 정당 지지	88	{"economy": 23, "housing": 8, "welfare": -5, "security": 54, "environment": -12}	지상파/종편 뉴스	{혁신,안전,공정}	경상북도에 거주하는 60-69 공무원. 정치 성향은 보수이며 혁신, 안전, 공정 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 36, "ecoConsciousness": 36, "priceSensitivity": 62, "digitalConsumption": 60}	{"taxTolerance": 34, "governmentTrust": 46, "policyAcceptance": 52, "regulationPreference": 73, "publicServiceSatisfaction": 64}	0
4180	황철수	67	60-69	Male	경상북도	36.654156	128.447425	대학교 졸	200-350만원	은퇴	1인 가구	92	보수 정당 지지	91	{"economy": 53, "housing": -23, "welfare": -41, "security": 57, "environment": -31}	SNS	{공정,공동체,안전}	경상북도에 거주하는 60-69 은퇴. 정치 성향은 보수이며 공정, 공동체, 안전 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 49, "ecoConsciousness": 29, "priceSensitivity": 70, "digitalConsumption": 35}	{"taxTolerance": 57, "governmentTrust": 39, "policyAcceptance": 56, "regulationPreference": 70, "publicServiceSatisfaction": 52}	0
4181	서건우	67	60-69	Male	경상북도	36.533783	128.562527	대학원 졸	200-350만원	은퇴	자녀 양육 가구	42	보수 성향 무당층	79	{"economy": 9, "housing": 9, "welfare": -49, "security": 24, "environment": -18}	지상파/종편 뉴스	{공동체,혁신,전통}	경상북도에 거주하는 60-69 은퇴. 정치 성향은 보수이며 공동체, 혁신, 전통 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 52, "ecoConsciousness": 74, "priceSensitivity": 75, "digitalConsumption": 61}	{"taxTolerance": 40, "governmentTrust": 67, "policyAcceptance": 48, "regulationPreference": 70, "publicServiceSatisfaction": 69}	0
4182	권서윤	74	70+	Female	경상북도	36.605265	128.521769	고졸 이하	700만원 이상	은퇴	부부 가구	46	보수 정당 지지	79	{"economy": 0, "housing": 16, "welfare": 7, "security": 31, "environment": 1}	유튜브	{공동체,환경,안정}	경상북도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 공동체, 환경, 안정 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 43, "ecoConsciousness": 39, "priceSensitivity": 49, "digitalConsumption": 55}	{"taxTolerance": 43, "governmentTrust": 57, "policyAcceptance": 49, "regulationPreference": 82, "publicServiceSatisfaction": 64}	0
4183	임순자	73	70+	Female	경상북도	36.560522	128.432766	대학교 졸	350-500만원	은퇴	부부 가구	46	보수 정당 지지	69	{"economy": -1, "housing": -13, "welfare": 0, "security": 41, "environment": 19}	포털 뉴스	{성장,안전,환경}	경상북도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 성장, 안전, 환경 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 50, "ecoConsciousness": 56, "priceSensitivity": 53, "digitalConsumption": 53}	{"taxTolerance": 42, "governmentTrust": 48, "policyAcceptance": 59, "regulationPreference": 42, "publicServiceSatisfaction": 51}	0
4184	전유준	82	70+	Female	경상북도	36.597986	128.545498	전문대 졸	700만원 이상	은퇴	자녀 양육 가구	69	보수 정당 지지	97	{"economy": 10, "housing": 8, "welfare": -44, "security": 22, "environment": 6}	포털 뉴스	{공정,안정,성장}	경상북도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 공정, 안정, 성장 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 27, "ecoConsciousness": 23, "priceSensitivity": 65, "digitalConsumption": 52}	{"taxTolerance": 47, "governmentTrust": 50, "policyAcceptance": 71, "regulationPreference": 65, "publicServiceSatisfaction": 62}	0
4185	임지우	83	70+	Male	경상북도	36.617252	128.54451	전문대 졸	350-500만원	은퇴	1인 가구	52	보수 정당 지지	89	{"economy": 20, "housing": 20, "welfare": -14, "security": 27, "environment": -22}	신문/팟캐스트	{공동체,전통,공정}	경상북도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 공동체, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 50, "ecoConsciousness": 35, "priceSensitivity": 70, "digitalConsumption": 69}	{"taxTolerance": 47, "governmentTrust": 47, "policyAcceptance": 66, "regulationPreference": 79, "publicServiceSatisfaction": 46}	0
4186	오유준	75	70+	Male	경상북도	36.51517	128.563023	전문대 졸	350-500만원	은퇴	1인 가구	43	보수 성향 무당층	99	{"economy": 32, "housing": 10, "welfare": -25, "security": 25, "environment": 3}	지상파/종편 뉴스	{공동체,안정,안전}	경상북도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 공동체, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 55, "ecoConsciousness": 27, "priceSensitivity": 74, "digitalConsumption": 46}	{"taxTolerance": 47, "governmentTrust": 43, "policyAcceptance": 41, "regulationPreference": 62, "publicServiceSatisfaction": 77}	0
4187	한도윤	70	70+	Male	경상북도	36.555617	128.45777	대학원 졸	200-350만원	은퇴	자녀 양육 가구	27	보수 성향 무당층	99	{"economy": -24, "housing": 16, "welfare": -34, "security": 11, "environment": 16}	포털 뉴스	{전통,환경,혁신}	경상북도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 전통, 환경, 혁신 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 48, "ecoConsciousness": 42, "priceSensitivity": 54, "digitalConsumption": 53}	{"taxTolerance": 64, "governmentTrust": 43, "policyAcceptance": 59, "regulationPreference": 52, "publicServiceSatisfaction": 73}	0
4188	박현우	28	18-29	Female	경상남도	35.449382	128.200109	대학교 졸	200만원 미만	자영업	자녀 양육 가구	2	중도 무당층	41	{"economy": -29, "housing": 24, "welfare": 6, "security": 9, "environment": 20}	지상파/종편 뉴스	{환경,혁신,전통}	경상남도에 거주하는 18-29 자영업. 정치 성향은 중도이며 환경, 혁신, 전통 가치를 중시한다.	{"brandLoyalty": 22, "noveltySeeking": 80, "ecoConsciousness": 49, "priceSensitivity": 73, "digitalConsumption": 83}	{"taxTolerance": 47, "governmentTrust": 42, "policyAcceptance": 41, "regulationPreference": 80, "publicServiceSatisfaction": 75}	0
4189	신지호	26	18-29	Female	경상남도	35.426287	128.258384	전문대 졸	200만원 미만	사무직	1인 가구	-7	중도 무당층	33	{"economy": 3, "housing": 26, "welfare": -2, "security": 13, "environment": 40}	신문/팟캐스트	{공정,성장,혁신}	경상남도에 거주하는 18-29 사무직. 정치 성향은 중도이며 공정, 성장, 혁신 가치를 중시한다.	{"brandLoyalty": 16, "noveltySeeking": 82, "ecoConsciousness": 79, "priceSensitivity": 92, "digitalConsumption": 91}	{"taxTolerance": 42, "governmentTrust": 48, "policyAcceptance": 52, "regulationPreference": 88, "publicServiceSatisfaction": 81}	0
4190	오광수	21	18-29	Female	경상남도	35.435567	128.24046	고졸 이하	200만원 미만	은퇴	1인 가구	1	중도 무당층	31	{"economy": 29, "housing": 5, "welfare": -7, "security": 21, "environment": 27}	SNS	{다양성,안전,혁신}	경상남도에 거주하는 18-29 은퇴. 정치 성향은 중도이며 다양성, 안전, 혁신 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 81, "ecoConsciousness": 40, "priceSensitivity": 61, "digitalConsumption": 76}	{"taxTolerance": 37, "governmentTrust": 51, "policyAcceptance": 55, "regulationPreference": 48, "publicServiceSatisfaction": 74}	0
4191	정준서	27	18-29	Female	경상남도	35.522009	128.221093	대학교 졸	200만원 미만	전문직	1인 가구	-6	중도 무당층	59	{"economy": -43, "housing": 13, "welfare": 14, "security": -16, "environment": 22}	포털 뉴스	{공동체,전통,자유}	경상남도에 거주하는 18-29 전문직. 정치 성향은 중도이며 공동체, 전통, 자유 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 87, "ecoConsciousness": 61, "priceSensitivity": 71, "digitalConsumption": 66}	{"taxTolerance": 50, "governmentTrust": 49, "policyAcceptance": 42, "regulationPreference": 60, "publicServiceSatisfaction": 67}	0
4192	송현우	21	18-29	Male	경상남도	35.470692	128.284437	전문대 졸	500-700만원	학생	부부 가구	-31	진보 성향 무당층	49	{"economy": -26, "housing": 34, "welfare": 42, "security": 13, "environment": 21}	지상파/종편 뉴스	{안전,공동체,공정}	경상남도에 거주하는 18-29 학생. 정치 성향은 중도이며 안전, 공동체, 공정 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 77, "ecoConsciousness": 39, "priceSensitivity": 60, "digitalConsumption": 91}	{"taxTolerance": 56, "governmentTrust": 43, "policyAcceptance": 41, "regulationPreference": 64, "publicServiceSatisfaction": 71}	0
4193	황영수	27	18-29	Male	경상남도	35.433197	128.219569	대학원 졸	200만원 미만	생산직	부부 가구	20	보수 성향 무당층	45	{"economy": 19, "housing": -11, "welfare": -5, "security": 14, "environment": 24}	신문/팟캐스트	{전통,혁신,공동체}	경상남도에 거주하는 18-29 생산직. 정치 성향은 중도이며 전통, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 20, "noveltySeeking": 74, "ecoConsciousness": 61, "priceSensitivity": 50, "digitalConsumption": 92}	{"taxTolerance": 65, "governmentTrust": 42, "policyAcceptance": 35, "regulationPreference": 59, "publicServiceSatisfaction": 67}	0
4194	권지아	18	18-29	Male	경상남도	35.5398	128.128632	대학원 졸	500-700만원	전문직	부부 가구	-53	진보 정당 지지	40	{"economy": -43, "housing": 29, "welfare": 8, "security": -33, "environment": 41}	지상파/종편 뉴스	{성장,혁신,환경}	경상남도에 거주하는 18-29 전문직. 정치 성향은 진보이며 성장, 혁신, 환경 가치를 중시한다.	{"brandLoyalty": 23, "noveltySeeking": 79, "ecoConsciousness": 54, "priceSensitivity": 55, "digitalConsumption": 88}	{"taxTolerance": 46, "governmentTrust": 26, "policyAcceptance": 36, "regulationPreference": 75, "publicServiceSatisfaction": 68}	0
4195	김예준	22	18-29	Male	경상남도	35.525823	128.177124	대학교 졸	350-500만원	학생	다세대 가구	-37	진보 성향 무당층	37	{"economy": -59, "housing": 7, "welfare": 46, "security": -25, "environment": 40}	포털 뉴스	{혁신,환경,전통}	경상남도에 거주하는 18-29 학생. 정치 성향은 진보이며 혁신, 환경, 전통 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 66, "ecoConsciousness": 45, "priceSensitivity": 51, "digitalConsumption": 75}	{"taxTolerance": 55, "governmentTrust": 44, "policyAcceptance": 43, "regulationPreference": 66, "publicServiceSatisfaction": 70}	0
4196	권지민	39	30-39	Female	경상남도	35.431872	128.173712	대학교 졸	350-500만원	학생	자녀 양육 가구	12	중도 무당층	57	{"economy": 20, "housing": 30, "welfare": 15, "security": 47, "environment": 3}	지상파/종편 뉴스	{다양성,혁신,공동체}	경상남도에 거주하는 30-39 학생. 정치 성향은 중도이며 다양성, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 79, "ecoConsciousness": 44, "priceSensitivity": 61, "digitalConsumption": 77}	{"taxTolerance": 56, "governmentTrust": 38, "policyAcceptance": 54, "regulationPreference": 58, "publicServiceSatisfaction": 53}	0
4197	류성호	33	30-39	Female	경상남도	35.44245	128.127394	대학교 졸	350-500만원	서비스직	부부 가구	-24	진보 성향 무당층	61	{"economy": 5, "housing": 29, "welfare": 42, "security": -9, "environment": 68}	유튜브	{공동체,다양성,성장}	경상남도에 거주하는 30-39 서비스직. 정치 성향은 중도이며 공동체, 다양성, 성장 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 73, "ecoConsciousness": 62, "priceSensitivity": 41, "digitalConsumption": 87}	{"taxTolerance": 54, "governmentTrust": 54, "policyAcceptance": 55, "regulationPreference": 57, "publicServiceSatisfaction": 52}	0
4198	류서연	32	30-39	Female	경상남도	35.535562	128.306772	대학교 졸	200-350만원	서비스직	다세대 가구	-33	진보 성향 무당층	69	{"economy": -26, "housing": 13, "welfare": 50, "security": -28, "environment": 27}	포털 뉴스	{안정,환경,공정}	경상남도에 거주하는 30-39 서비스직. 정치 성향은 중도이며 안정, 환경, 공정 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 85, "ecoConsciousness": 51, "priceSensitivity": 69, "digitalConsumption": 72}	{"taxTolerance": 67, "governmentTrust": 54, "policyAcceptance": 52, "regulationPreference": 58, "publicServiceSatisfaction": 68}	0
4199	정철수	33	30-39	Female	경상남도	35.46012	128.149017	대학원 졸	500-700만원	생산직	자녀 양육 가구	-7	중도 무당층	55	{"economy": -13, "housing": 17, "welfare": 10, "security": -19, "environment": 24}	SNS	{다양성,공정,전통}	경상남도에 거주하는 30-39 생산직. 정치 성향은 중도이며 다양성, 공정, 전통 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 68, "ecoConsciousness": 56, "priceSensitivity": 52, "digitalConsumption": 71}	{"taxTolerance": 39, "governmentTrust": 36, "policyAcceptance": 48, "regulationPreference": 49, "publicServiceSatisfaction": 72}	0
4200	황동현	31	30-39	Male	경상남도	35.529507	128.154252	대학교 졸	500-700만원	자영업	부부 가구	-59	진보 정당 지지	37	{"economy": -61, "housing": 21, "welfare": 32, "security": -46, "environment": 35}	유튜브	{혁신,전통,자유}	경상남도에 거주하는 30-39 자영업. 정치 성향은 진보이며 혁신, 전통, 자유 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 81, "ecoConsciousness": 35, "priceSensitivity": 39, "digitalConsumption": 89}	{"taxTolerance": 68, "governmentTrust": 44, "policyAcceptance": 47, "regulationPreference": 69, "publicServiceSatisfaction": 67}	0
4201	안순자	34	30-39	Male	경상남도	35.395992	128.194172	대학원 졸	200-350만원	프리랜서	부부 가구	-16	진보 성향 무당층	69	{"economy": -34, "housing": 19, "welfare": 33, "security": 10, "environment": 31}	유튜브	{환경,공정,안정}	경상남도에 거주하는 30-39 프리랜서. 정치 성향은 중도이며 환경, 공정, 안정 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 87, "ecoConsciousness": 45, "priceSensitivity": 67, "digitalConsumption": 80}	{"taxTolerance": 50, "governmentTrust": 35, "policyAcceptance": 47, "regulationPreference": 61, "publicServiceSatisfaction": 66}	0
4202	최지호	31	30-39	Male	경상남도	35.509833	128.205891	전문대 졸	350-500만원	학생	다세대 가구	25	보수 성향 무당층	50	{"economy": 13, "housing": 1, "welfare": 8, "security": 5, "environment": 33}	유튜브	{공동체,안정,공정}	경상남도에 거주하는 30-39 학생. 정치 성향은 중도이며 공동체, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 59, "ecoConsciousness": 33, "priceSensitivity": 54, "digitalConsumption": 77}	{"taxTolerance": 54, "governmentTrust": 63, "policyAcceptance": 46, "regulationPreference": 57, "publicServiceSatisfaction": 68}	0
4203	한철수	39	30-39	Male	경상남도	35.487251	128.168426	전문대 졸	700만원 이상	서비스직	자녀 양육 가구	-40	진보 성향 무당층	51	{"economy": -23, "housing": 22, "welfare": 65, "security": 4, "environment": 32}	지상파/종편 뉴스	{환경,공동체,혁신}	경상남도에 거주하는 30-39 서비스직. 정치 성향은 진보이며 환경, 공동체, 혁신 가치를 중시한다.	{"brandLoyalty": 26, "noveltySeeking": 63, "ecoConsciousness": 59, "priceSensitivity": 46, "digitalConsumption": 62}	{"taxTolerance": 40, "governmentTrust": 48, "policyAcceptance": 58, "regulationPreference": 52, "publicServiceSatisfaction": 81}	0
4204	조도윤	42	40-49	Female	경상남도	35.446359	128.223306	대학원 졸	700만원 이상	생산직	다세대 가구	-1	중도 무당층	60	{"economy": 10, "housing": 11, "welfare": 12, "security": 13, "environment": 20}	신문/팟캐스트	{안정,환경,성장}	경상남도에 거주하는 40-49 생산직. 정치 성향은 중도이며 안정, 환경, 성장 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 60, "ecoConsciousness": 58, "priceSensitivity": 29, "digitalConsumption": 63}	{"taxTolerance": 48, "governmentTrust": 44, "policyAcceptance": 27, "regulationPreference": 52, "publicServiceSatisfaction": 63}	0
4205	홍서윤	42	40-49	Female	경상남도	35.490508	128.196085	대학교 졸	200-350만원	공무원	자녀 양육 가구	18	보수 성향 무당층	56	{"economy": 16, "housing": -12, "welfare": -9, "security": 4, "environment": 52}	포털 뉴스	{다양성,공동체,전통}	경상남도에 거주하는 40-49 공무원. 정치 성향은 중도이며 다양성, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 58, "ecoConsciousness": 62, "priceSensitivity": 61, "digitalConsumption": 78}	{"taxTolerance": 50, "governmentTrust": 51, "policyAcceptance": 50, "regulationPreference": 47, "publicServiceSatisfaction": 67}	0
4206	조광수	43	40-49	Female	경상남도	35.531441	128.308851	대학교 졸	500-700만원	사무직	다세대 가구	26	보수 성향 무당층	60	{"economy": 14, "housing": 3, "welfare": 6, "security": 15, "environment": 28}	지상파/종편 뉴스	{공정,안정,다양성}	경상남도에 거주하는 40-49 사무직. 정치 성향은 중도이며 공정, 안정, 다양성 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 55, "ecoConsciousness": 51, "priceSensitivity": 45, "digitalConsumption": 50}	{"taxTolerance": 64, "governmentTrust": 30, "policyAcceptance": 60, "regulationPreference": 77, "publicServiceSatisfaction": 73}	0
4207	김지호	47	40-49	Female	경상남도	35.499378	128.129282	전문대 졸	200-350만원	주부	자녀 양육 가구	-15	진보 성향 무당층	64	{"economy": 16, "housing": 20, "welfare": 16, "security": 9, "environment": 11}	SNS	{자유,전통,공정}	경상남도에 거주하는 40-49 주부. 정치 성향은 중도이며 자유, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 61, "ecoConsciousness": 55, "priceSensitivity": 72, "digitalConsumption": 95}	{"taxTolerance": 46, "governmentTrust": 44, "policyAcceptance": 45, "regulationPreference": 61, "publicServiceSatisfaction": 62}	0
4208	송영수	42	40-49	Female	경상남도	35.498696	128.160434	대학교 졸	350-500만원	서비스직	자녀 양육 가구	28	보수 성향 무당층	67	{"economy": 41, "housing": 20, "welfare": -4, "security": 52, "environment": -4}	지상파/종편 뉴스	{안전,환경,자유}	경상남도에 거주하는 40-49 서비스직. 정치 성향은 중도이며 안전, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 66, "ecoConsciousness": 47, "priceSensitivity": 70, "digitalConsumption": 62}	{"taxTolerance": 65, "governmentTrust": 52, "policyAcceptance": 47, "regulationPreference": 74, "publicServiceSatisfaction": 67}	0
4209	송민서	44	40-49	Male	경상남도	35.535762	128.269575	전문대 졸	200-350만원	프리랜서	다세대 가구	-21	진보 성향 무당층	62	{"economy": -11, "housing": 3, "welfare": 19, "security": -37, "environment": 12}	SNS	{공동체,공정,전통}	경상남도에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 공동체, 공정, 전통 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 60, "ecoConsciousness": 46, "priceSensitivity": 72, "digitalConsumption": 51}	{"taxTolerance": 58, "governmentTrust": 47, "policyAcceptance": 67, "regulationPreference": 61, "publicServiceSatisfaction": 61}	0
4210	홍서윤	43	40-49	Male	경상남도	35.514175	128.237166	대학교 졸	500-700만원	주부	자녀 양육 가구	-16	진보 성향 무당층	63	{"economy": -46, "housing": 1, "welfare": 44, "security": -12, "environment": 31}	SNS	{환경,다양성,전통}	경상남도에 거주하는 40-49 주부. 정치 성향은 중도이며 환경, 다양성, 전통 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 63, "ecoConsciousness": 62, "priceSensitivity": 51, "digitalConsumption": 74}	{"taxTolerance": 44, "governmentTrust": 34, "policyAcceptance": 39, "regulationPreference": 54, "publicServiceSatisfaction": 57}	0
4211	장도윤	46	40-49	Male	경상남도	35.440124	128.302917	전문대 졸	700만원 이상	프리랜서	부부 가구	28	보수 성향 무당층	62	{"economy": -10, "housing": 30, "welfare": -19, "security": 9, "environment": 19}	유튜브	{전통,자유,혁신}	경상남도에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 전통, 자유, 혁신 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 51, "ecoConsciousness": 53, "priceSensitivity": 46, "digitalConsumption": 64}	{"taxTolerance": 55, "governmentTrust": 30, "policyAcceptance": 88, "regulationPreference": 64, "publicServiceSatisfaction": 63}	0
4212	홍경숙	43	40-49	Male	경상남도	35.470436	128.16697	대학교 졸	350-500만원	사무직	다세대 가구	-10	중도 무당층	73	{"economy": -30, "housing": 11, "welfare": 5, "security": -18, "environment": 20}	신문/팟캐스트	{공동체,성장,공정}	경상남도에 거주하는 40-49 사무직. 정치 성향은 중도이며 공동체, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 58, "ecoConsciousness": 46, "priceSensitivity": 65, "digitalConsumption": 84}	{"taxTolerance": 49, "governmentTrust": 49, "policyAcceptance": 35, "regulationPreference": 56, "publicServiceSatisfaction": 72}	0
4213	박민준	41	40-49	Male	경상남도	35.426134	128.116954	고졸 이하	350-500만원	사무직	부부 가구	-10	중도 무당층	55	{"economy": -8, "housing": 26, "welfare": -18, "security": -9, "environment": 11}	유튜브	{공동체,안정,혁신}	경상남도에 거주하는 40-49 사무직. 정치 성향은 중도이며 공동체, 안정, 혁신 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 78, "ecoConsciousness": 22, "priceSensitivity": 69, "digitalConsumption": 74}	{"taxTolerance": 54, "governmentTrust": 35, "policyAcceptance": 55, "regulationPreference": 63, "publicServiceSatisfaction": 76}	0
4214	서민서	59	50-59	Female	경상남도	35.502124	128.145964	대학교 졸	500-700만원	은퇴	부부 가구	0	중도 무당층	72	{"economy": 5, "housing": 19, "welfare": 17, "security": 13, "environment": 18}	유튜브	{다양성,전통,자유}	경상남도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 다양성, 전통, 자유 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 56, "ecoConsciousness": 54, "priceSensitivity": 57, "digitalConsumption": 51}	{"taxTolerance": 53, "governmentTrust": 48, "policyAcceptance": 42, "regulationPreference": 63, "publicServiceSatisfaction": 60}	0
4215	임혜진	51	50-59	Female	경상남도	35.441622	128.132384	고졸 이하	200만원 미만	학생	자녀 양육 가구	-13	중도 무당층	60	{"economy": -8, "housing": 16, "welfare": 21, "security": -13, "environment": 21}	유튜브	{다양성,안정,자유}	경상남도에 거주하는 50-59 학생. 정치 성향은 중도이며 다양성, 안정, 자유 가치를 중시한다.	{"brandLoyalty": 74, "noveltySeeking": 63, "ecoConsciousness": 51, "priceSensitivity": 83, "digitalConsumption": 68}	{"taxTolerance": 42, "governmentTrust": 51, "policyAcceptance": 54, "regulationPreference": 71, "publicServiceSatisfaction": 69}	0
4216	안지호	52	50-59	Female	경상남도	35.475582	128.193496	대학교 졸	700만원 이상	생산직	1인 가구	6	중도 무당층	69	{"economy": -12, "housing": 3, "welfare": 15, "security": -3, "environment": 21}	신문/팟캐스트	{전통,안정,공동체}	경상남도에 거주하는 50-59 생산직. 정치 성향은 중도이며 전통, 안정, 공동체 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 71, "ecoConsciousness": 58, "priceSensitivity": 53, "digitalConsumption": 79}	{"taxTolerance": 49, "governmentTrust": 47, "policyAcceptance": 48, "regulationPreference": 65, "publicServiceSatisfaction": 65}	0
4217	권현우	52	50-59	Female	경상남도	35.521903	128.220628	전문대 졸	350-500만원	프리랜서	다세대 가구	-14	중도 무당층	93	{"economy": -28, "housing": 24, "welfare": 26, "security": -21, "environment": 32}	신문/팟캐스트	{다양성,안전,안정}	경상남도에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 다양성, 안전, 안정 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 55, "ecoConsciousness": 25, "priceSensitivity": 72, "digitalConsumption": 67}	{"taxTolerance": 36, "governmentTrust": 57, "policyAcceptance": 43, "regulationPreference": 66, "publicServiceSatisfaction": 74}	0
4218	신민준	57	50-59	Female	경상남도	35.413859	128.226848	고졸 이하	500-700만원	자영업	부부 가구	28	보수 성향 무당층	65	{"economy": 10, "housing": -1, "welfare": -4, "security": 15, "environment": -7}	SNS	{공동체,공정,안정}	경상남도에 거주하는 50-59 자영업. 정치 성향은 중도이며 공동체, 공정, 안정 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 52, "ecoConsciousness": 47, "priceSensitivity": 30, "digitalConsumption": 54}	{"taxTolerance": 36, "governmentTrust": 54, "policyAcceptance": 55, "regulationPreference": 75, "publicServiceSatisfaction": 76}	0
4219	정하은	56	50-59	Male	경상남도	35.384603	128.133737	전문대 졸	350-500만원	학생	자녀 양육 가구	-18	진보 성향 무당층	57	{"economy": -21, "housing": 24, "welfare": 5, "security": -5, "environment": 30}	유튜브	{환경,다양성,안정}	경상남도에 거주하는 50-59 학생. 정치 성향은 중도이며 환경, 다양성, 안정 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 56, "ecoConsciousness": 27, "priceSensitivity": 65, "digitalConsumption": 59}	{"taxTolerance": 35, "governmentTrust": 48, "policyAcceptance": 50, "regulationPreference": 39, "publicServiceSatisfaction": 60}	0
4220	류서윤	52	50-59	Male	경상남도	35.404871	128.142798	대학원 졸	700만원 이상	은퇴	부부 가구	-19	진보 성향 무당층	88	{"economy": -12, "housing": 9, "welfare": 7, "security": -4, "environment": 38}	신문/팟캐스트	{전통,다양성,안전}	경상남도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 전통, 다양성, 안전 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 66, "ecoConsciousness": 76, "priceSensitivity": 48, "digitalConsumption": 62}	{"taxTolerance": 44, "governmentTrust": 55, "policyAcceptance": 58, "regulationPreference": 54, "publicServiceSatisfaction": 67}	0
4221	최순자	57	50-59	Male	경상남도	35.406785	128.135744	대학교 졸	350-500만원	사무직	자녀 양육 가구	-24	진보 성향 무당층	70	{"economy": -29, "housing": 35, "welfare": 15, "security": -17, "environment": 18}	SNS	{다양성,성장,안정}	경상남도에 거주하는 50-59 사무직. 정치 성향은 중도이며 다양성, 성장, 안정 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 61, "ecoConsciousness": 51, "priceSensitivity": 61, "digitalConsumption": 75}	{"taxTolerance": 42, "governmentTrust": 40, "policyAcceptance": 66, "regulationPreference": 59, "publicServiceSatisfaction": 70}	0
4222	서유준	51	50-59	Male	경상남도	35.506571	128.279409	대학원 졸	500-700만원	자영업	부부 가구	-2	중도 무당층	65	{"economy": 0, "housing": 9, "welfare": 20, "security": -23, "environment": 21}	지상파/종편 뉴스	{혁신,공정,성장}	경상남도에 거주하는 50-59 자영업. 정치 성향은 중도이며 혁신, 공정, 성장 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 61, "ecoConsciousness": 51, "priceSensitivity": 41, "digitalConsumption": 62}	{"taxTolerance": 49, "governmentTrust": 42, "policyAcceptance": 52, "regulationPreference": 78, "publicServiceSatisfaction": 68}	0
4223	윤영수	50	50-59	Male	경상남도	35.535178	128.118651	전문대 졸	700만원 이상	공무원	자녀 양육 가구	7	중도 무당층	68	{"economy": 7, "housing": 5, "welfare": -5, "security": -2, "environment": 27}	SNS	{전통,안전,안정}	경상남도에 거주하는 50-59 공무원. 정치 성향은 중도이며 전통, 안전, 안정 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 59, "ecoConsciousness": 60, "priceSensitivity": 49, "digitalConsumption": 74}	{"taxTolerance": 46, "governmentTrust": 60, "policyAcceptance": 41, "regulationPreference": 56, "publicServiceSatisfaction": 56}	0
4224	임도윤	64	60-69	Female	경상남도	35.510295	128.245693	대학교 졸	700만원 이상	프리랜서	다세대 가구	24	보수 성향 무당층	77	{"economy": -17, "housing": 21, "welfare": -12, "security": 31, "environment": 11}	포털 뉴스	{공정,다양성,안전}	경상남도에 거주하는 60-69 프리랜서. 정치 성향은 중도이며 공정, 다양성, 안전 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 56, "ecoConsciousness": 36, "priceSensitivity": 51, "digitalConsumption": 76}	{"taxTolerance": 40, "governmentTrust": 44, "policyAcceptance": 60, "regulationPreference": 76, "publicServiceSatisfaction": 70}	0
4225	최서윤	68	60-69	Female	경상남도	35.384635	128.120983	대학원 졸	350-500만원	은퇴	자녀 양육 가구	5	중도 무당층	92	{"economy": 1, "housing": -12, "welfare": 1, "security": 28, "environment": 17}	신문/팟캐스트	{안정,전통,혁신}	경상남도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 안정, 전통, 혁신 가치를 중시한다.	{"brandLoyalty": 63, "noveltySeeking": 47, "ecoConsciousness": 66, "priceSensitivity": 56, "digitalConsumption": 42}	{"taxTolerance": 43, "governmentTrust": 52, "policyAcceptance": 42, "regulationPreference": 64, "publicServiceSatisfaction": 55}	0
4226	신동현	61	60-69	Female	경상남도	35.403081	128.19236	고졸 이하	500-700만원	은퇴	부부 가구	34	보수 성향 무당층	82	{"economy": 24, "housing": 7, "welfare": -17, "security": 26, "environment": -2}	지상파/종편 뉴스	{공동체,성장,안전}	경상남도에 거주하는 60-69 은퇴. 정치 성향은 보수이며 공동체, 성장, 안전 가치를 중시한다.	{"brandLoyalty": 65, "noveltySeeking": 52, "ecoConsciousness": 62, "priceSensitivity": 53, "digitalConsumption": 70}	{"taxTolerance": 34, "governmentTrust": 63, "policyAcceptance": 57, "regulationPreference": 67, "publicServiceSatisfaction": 71}	0
4227	장예준	64	60-69	Female	경상남도	35.486928	128.147342	대학교 졸	350-500만원	주부	다세대 가구	-11	중도 무당층	99	{"economy": -3, "housing": 35, "welfare": 56, "security": -8, "environment": 26}	신문/팟캐스트	{다양성,안전,자유}	경상남도에 거주하는 60-69 주부. 정치 성향은 중도이며 다양성, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 48, "ecoConsciousness": 57, "priceSensitivity": 84, "digitalConsumption": 60}	{"taxTolerance": 53, "governmentTrust": 69, "policyAcceptance": 46, "regulationPreference": 65, "publicServiceSatisfaction": 69}	0
4228	김수아	62	60-69	Male	경상남도	35.507373	128.209193	대학교 졸	500-700만원	사무직	자녀 양육 가구	39	보수 성향 무당층	73	{"economy": 20, "housing": 25, "welfare": -9, "security": 6, "environment": 6}	포털 뉴스	{환경,공동체,안전}	경상남도에 거주하는 60-69 사무직. 정치 성향은 보수이며 환경, 공동체, 안전 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 53, "ecoConsciousness": 50, "priceSensitivity": 67, "digitalConsumption": 62}	{"taxTolerance": 52, "governmentTrust": 27, "policyAcceptance": 52, "regulationPreference": 63, "publicServiceSatisfaction": 73}	0
4229	김건우	66	60-69	Male	경상남도	35.519787	128.214195	전문대 졸	200만원 미만	사무직	다세대 가구	32	보수 성향 무당층	74	{"economy": 51, "housing": 35, "welfare": 6, "security": 35, "environment": 20}	신문/팟캐스트	{환경,자유,성장}	경상남도에 거주하는 60-69 사무직. 정치 성향은 중도이며 환경, 자유, 성장 가치를 중시한다.	{"brandLoyalty": 68, "noveltySeeking": 58, "ecoConsciousness": 45, "priceSensitivity": 76, "digitalConsumption": 47}	{"taxTolerance": 35, "governmentTrust": 50, "policyAcceptance": 57, "regulationPreference": 67, "publicServiceSatisfaction": 56}	0
4230	장유준	62	60-69	Male	경상남도	35.422753	128.253044	대학교 졸	500-700만원	사무직	부부 가구	8	중도 무당층	62	{"economy": 0, "housing": -16, "welfare": 1, "security": 7, "environment": 20}	포털 뉴스	{혁신,성장,공정}	경상남도에 거주하는 60-69 사무직. 정치 성향은 중도이며 혁신, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 61, "ecoConsciousness": 53, "priceSensitivity": 51, "digitalConsumption": 50}	{"taxTolerance": 65, "governmentTrust": 43, "policyAcceptance": 35, "regulationPreference": 59, "publicServiceSatisfaction": 61}	0
4231	조서윤	65	60-69	Male	경상남도	35.45755	128.160747	전문대 졸	350-500만원	은퇴	다세대 가구	50	보수 정당 지지	99	{"economy": 40, "housing": -20, "welfare": -9, "security": 29, "environment": -21}	포털 뉴스	{성장,공동체,자유}	경상남도에 거주하는 60-69 은퇴. 정치 성향은 보수이며 성장, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 53, "ecoConsciousness": 43, "priceSensitivity": 63, "digitalConsumption": 64}	{"taxTolerance": 65, "governmentTrust": 49, "policyAcceptance": 50, "regulationPreference": 66, "publicServiceSatisfaction": 70}	0
4232	오혜진	70	70+	Female	경상남도	35.438616	128.132806	고졸 이하	500-700만원	은퇴	부부 가구	4	중도 무당층	83	{"economy": 35, "housing": 9, "welfare": -7, "security": 22, "environment": 17}	포털 뉴스	{안정,자유,성장}	경상남도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안정, 자유, 성장 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 40, "ecoConsciousness": 66, "priceSensitivity": 64, "digitalConsumption": 60}	{"taxTolerance": 44, "governmentTrust": 43, "policyAcceptance": 52, "regulationPreference": 54, "publicServiceSatisfaction": 73}	0
4233	신서연	78	70+	Female	경상남도	35.524411	128.215503	대학교 졸	500-700만원	은퇴	1인 가구	27	보수 성향 무당층	50	{"economy": 19, "housing": 29, "welfare": 4, "security": 5, "environment": 23}	유튜브	{자유,안전,다양성}	경상남도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 자유, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 52, "ecoConsciousness": 33, "priceSensitivity": 70, "digitalConsumption": 54}	{"taxTolerance": 65, "governmentTrust": 58, "policyAcceptance": 40, "regulationPreference": 54, "publicServiceSatisfaction": 67}	0
4234	권동현	80	70+	Female	경상남도	35.447861	128.176005	고졸 이하	200만원 미만	은퇴	자녀 양육 가구	38	보수 성향 무당층	90	{"economy": 15, "housing": 43, "welfare": -27, "security": 44, "environment": 31}	유튜브	{자유,혁신,안정}	경상남도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 자유, 혁신, 안정 가치를 중시한다.	{"brandLoyalty": 61, "noveltySeeking": 34, "ecoConsciousness": 45, "priceSensitivity": 62, "digitalConsumption": 50}	{"taxTolerance": 35, "governmentTrust": 66, "policyAcceptance": 59, "regulationPreference": 67, "publicServiceSatisfaction": 54}	0
4235	박도윤	73	70+	Female	경상남도	35.433965	128.202203	고졸 이하	200만원 미만	은퇴	자녀 양육 가구	49	보수 정당 지지	84	{"economy": -3, "housing": -30, "welfare": -20, "security": 23, "environment": 14}	포털 뉴스	{안정,자유,전통}	경상남도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안정, 자유, 전통 가치를 중시한다.	{"brandLoyalty": 76, "noveltySeeking": 61, "ecoConsciousness": 40, "priceSensitivity": 60, "digitalConsumption": 47}	{"taxTolerance": 38, "governmentTrust": 52, "policyAcceptance": 66, "regulationPreference": 65, "publicServiceSatisfaction": 80}	0
4236	김정희	82	70+	Male	경상남도	35.409698	128.188872	대학교 졸	200-350만원	은퇴	자녀 양육 가구	21	보수 성향 무당층	69	{"economy": -5, "housing": 27, "welfare": -3, "security": 5, "environment": 22}	신문/팟캐스트	{다양성,안정,공정}	경상남도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 다양성, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 68, "noveltySeeking": 53, "ecoConsciousness": 44, "priceSensitivity": 72, "digitalConsumption": 33}	{"taxTolerance": 63, "governmentTrust": 55, "policyAcceptance": 69, "regulationPreference": 83, "publicServiceSatisfaction": 51}	0
4237	조채원	74	70+	Male	경상남도	35.445656	128.204846	대학원 졸	200만원 미만	은퇴	1인 가구	33	보수 성향 무당층	90	{"economy": 41, "housing": 2, "welfare": -16, "security": 42, "environment": -6}	신문/팟캐스트	{환경,다양성,전통}	경상남도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 환경, 다양성, 전통 가치를 중시한다.	{"brandLoyalty": 61, "noveltySeeking": 51, "ecoConsciousness": 61, "priceSensitivity": 77, "digitalConsumption": 46}	{"taxTolerance": 51, "governmentTrust": 55, "policyAcceptance": 55, "regulationPreference": 55, "publicServiceSatisfaction": 62}	0
4238	장하은	71	70+	Male	경상남도	35.399951	128.282869	전문대 졸	350-500만원	은퇴	부부 가구	50	보수 정당 지지	85	{"economy": 13, "housing": 19, "welfare": -10, "security": 26, "environment": -2}	지상파/종편 뉴스	{다양성,공동체,안정}	경상남도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 다양성, 공동체, 안정 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 39, "ecoConsciousness": 53, "priceSensitivity": 46, "digitalConsumption": 63}	{"taxTolerance": 43, "governmentTrust": 57, "policyAcceptance": 72, "regulationPreference": 59, "publicServiceSatisfaction": 57}	0
4239	박도윤	18	18-29	Female	제주특별자치도	33.44835	126.464711	대학교 졸	500-700만원	자영업	부부 가구	-70	진보 정당 지지	56	{"economy": -39, "housing": 31, "welfare": 45, "security": -31, "environment": 63}	포털 뉴스	{공정,안전,자유}	제주특별자치도에 거주하는 18-29 자영업. 정치 성향은 진보이며 공정, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 75, "ecoConsciousness": 70, "priceSensitivity": 55, "digitalConsumption": 93}	{"taxTolerance": 55, "governmentTrust": 44, "policyAcceptance": 49, "regulationPreference": 53, "publicServiceSatisfaction": 82}	0
4240	최건우	27	18-29	Male	제주특별자치도	33.511324	126.600704	대학원 졸	500-700만원	주부	다세대 가구	-42	진보 성향 무당층	48	{"economy": -23, "housing": 29, "welfare": 44, "security": -8, "environment": 50}	신문/팟캐스트	{공동체,전통,혁신}	제주특별자치도에 거주하는 18-29 주부. 정치 성향은 진보이며 공동체, 전통, 혁신 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 77, "ecoConsciousness": 54, "priceSensitivity": 42, "digitalConsumption": 79}	{"taxTolerance": 47, "governmentTrust": 55, "policyAcceptance": 35, "regulationPreference": 79, "publicServiceSatisfaction": 49}	0
4241	오지호	36	30-39	Female	제주특별자치도	33.462274	126.433684	전문대 졸	700만원 이상	공무원	부부 가구	-6	중도 무당층	72	{"economy": -12, "housing": 34, "welfare": 27, "security": -26, "environment": 50}	신문/팟캐스트	{전통,자유,혁신}	제주특별자치도에 거주하는 30-39 공무원. 정치 성향은 중도이며 전통, 자유, 혁신 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 51, "ecoConsciousness": 34, "priceSensitivity": 59, "digitalConsumption": 71}	{"taxTolerance": 43, "governmentTrust": 36, "policyAcceptance": 38, "regulationPreference": 63, "publicServiceSatisfaction": 90}	0
4242	조서연	31	30-39	Male	제주특별자치도	33.502318	126.592422	전문대 졸	200-350만원	학생	자녀 양육 가구	1	중도 무당층	53	{"economy": -3, "housing": 36, "welfare": 35, "security": 33, "environment": 7}	유튜브	{공정,안전,안정}	제주특별자치도에 거주하는 30-39 학생. 정치 성향은 중도이며 공정, 안전, 안정 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 67, "ecoConsciousness": 62, "priceSensitivity": 60, "digitalConsumption": 92}	{"taxTolerance": 59, "governmentTrust": 52, "policyAcceptance": 25, "regulationPreference": 58, "publicServiceSatisfaction": 81}	0
4243	최수아	41	40-49	Female	제주특별자치도	33.461244	126.506494	대학원 졸	350-500만원	전문직	다세대 가구	-29	진보 성향 무당층	64	{"economy": -22, "housing": 1, "welfare": -3, "security": -23, "environment": 28}	신문/팟캐스트	{환경,안정,다양성}	제주특별자치도에 거주하는 40-49 전문직. 정치 성향은 중도이며 환경, 안정, 다양성 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 88, "ecoConsciousness": 39, "priceSensitivity": 69, "digitalConsumption": 80}	{"taxTolerance": 61, "governmentTrust": 46, "policyAcceptance": 57, "regulationPreference": 59, "publicServiceSatisfaction": 88}	0
4244	조채원	41	40-49	Male	제주특별자치도	33.564327	126.45938	대학원 졸	350-500만원	서비스직	다세대 가구	-41	진보 성향 무당층	83	{"economy": -6, "housing": 29, "welfare": 21, "security": 14, "environment": 37}	유튜브	{공동체,환경,안정}	제주특별자치도에 거주하는 40-49 서비스직. 정치 성향은 진보이며 공동체, 환경, 안정 가치를 중시한다.	{"brandLoyalty": 17, "noveltySeeking": 76, "ecoConsciousness": 62, "priceSensitivity": 69, "digitalConsumption": 76}	{"taxTolerance": 62, "governmentTrust": 51, "policyAcceptance": 61, "regulationPreference": 69, "publicServiceSatisfaction": 71}	0
4245	황민서	57	50-59	Female	제주특별자치도	33.544109	126.538166	고졸 이하	350-500만원	생산직	다세대 가구	-6	중도 무당층	87	{"economy": 0, "housing": 24, "welfare": 23, "security": -24, "environment": 15}	지상파/종편 뉴스	{공동체,안전,혁신}	제주특별자치도에 거주하는 50-59 생산직. 정치 성향은 중도이며 공동체, 안전, 혁신 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 64, "ecoConsciousness": 33, "priceSensitivity": 48, "digitalConsumption": 72}	{"taxTolerance": 52, "governmentTrust": 49, "policyAcceptance": 74, "regulationPreference": 77, "publicServiceSatisfaction": 74}	0
4246	황채원	58	50-59	Male	제주특별자치도	33.535624	126.548165	전문대 졸	700만원 이상	주부	자녀 양육 가구	-9	중도 무당층	46	{"economy": 8, "housing": 28, "welfare": 37, "security": 11, "environment": 26}	포털 뉴스	{안정,공정,안전}	제주특별자치도에 거주하는 50-59 주부. 정치 성향은 중도이며 안정, 공정, 안전 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 55, "ecoConsciousness": 73, "priceSensitivity": 70, "digitalConsumption": 61}	{"taxTolerance": 42, "governmentTrust": 63, "policyAcceptance": 61, "regulationPreference": 83, "publicServiceSatisfaction": 66}	0
4247	이동현	63	60-69	Female	제주특별자치도	33.420004	126.61572	대학원 졸	200만원 미만	전문직	1인 가구	28	보수 성향 무당층	86	{"economy": 5, "housing": 9, "welfare": -7, "security": 32, "environment": 29}	유튜브	{공정,성장,자유}	제주특별자치도에 거주하는 60-69 전문직. 정치 성향은 중도이며 공정, 성장, 자유 가치를 중시한다.	{"brandLoyalty": 67, "noveltySeeking": 59, "ecoConsciousness": 52, "priceSensitivity": 69, "digitalConsumption": 70}	{"taxTolerance": 71, "governmentTrust": 52, "policyAcceptance": 50, "regulationPreference": 67, "publicServiceSatisfaction": 65}	0
4248	전지민	66	60-69	Male	제주특별자치도	33.541395	126.609152	전문대 졸	200-350만원	공무원	부부 가구	-32	진보 성향 무당층	79	{"economy": -42, "housing": 31, "welfare": 9, "security": -21, "environment": 28}	유튜브	{자유,안전,공동체}	제주특별자치도에 거주하는 60-69 공무원. 정치 성향은 중도이며 자유, 안전, 공동체 가치를 중시한다.	{"brandLoyalty": 64, "noveltySeeking": 42, "ecoConsciousness": 79, "priceSensitivity": 68, "digitalConsumption": 56}	{"taxTolerance": 53, "governmentTrust": 54, "policyAcceptance": 52, "regulationPreference": 53, "publicServiceSatisfaction": 76}	0
4249	권서윤	81	70+	Female	제주특별자치도	33.423112	126.513291	대학교 졸	350-500만원	은퇴	1인 가구	5	중도 무당층	94	{"economy": 12, "housing": 19, "welfare": 33, "security": 21, "environment": 11}	지상파/종편 뉴스	{환경,혁신,안전}	제주특별자치도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 환경, 혁신, 안전 가치를 중시한다.	{"brandLoyalty": 71, "noveltySeeking": 28, "ecoConsciousness": 59, "priceSensitivity": 71, "digitalConsumption": 52}	{"taxTolerance": 43, "governmentTrust": 48, "policyAcceptance": 65, "regulationPreference": 63, "publicServiceSatisfaction": 62}	0
4250	오준서	84	70+	Male	제주특별자치도	33.421837	126.56982	대학교 졸	200-350만원	은퇴	자녀 양육 가구	31	보수 성향 무당층	75	{"economy": -20, "housing": -2, "welfare": -20, "security": 9, "environment": -24}	유튜브	{환경,성장,혁신}	제주특별자치도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 환경, 성장, 혁신 가치를 중시한다.	{"brandLoyalty": 71, "noveltySeeking": 41, "ecoConsciousness": 50, "priceSensitivity": 81, "digitalConsumption": 43}	{"taxTolerance": 46, "governmentTrust": 56, "policyAcceptance": 59, "regulationPreference": 70, "publicServiceSatisfaction": 60}	0
4251	신지호	25	18-29	Female	강원특별자치도	37.800463	128.19362	대학원 졸	350-500만원	은퇴	자녀 양육 가구	13	중도 무당층	67	{"economy": 5, "housing": 12, "welfare": 19, "security": 22, "environment": 28}	유튜브	{안정,전통,공정}	강원특별자치도에 거주하는 18-29 은퇴. 정치 성향은 중도이며 안정, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 58, "ecoConsciousness": 59, "priceSensitivity": 82, "digitalConsumption": 83}	{"taxTolerance": 51, "governmentTrust": 43, "policyAcceptance": 33, "regulationPreference": 44, "publicServiceSatisfaction": 80}	0
4252	김혜진	22	18-29	Female	강원특별자치도	37.88361	128.168181	대학교 졸	500-700만원	학생	다세대 가구	-28	진보 성향 무당층	45	{"economy": -29, "housing": 33, "welfare": 49, "security": -5, "environment": 30}	유튜브	{공동체,공정,안전}	강원특별자치도에 거주하는 18-29 학생. 정치 성향은 중도이며 공동체, 공정, 안전 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 68, "ecoConsciousness": 61, "priceSensitivity": 56, "digitalConsumption": 91}	{"taxTolerance": 65, "governmentTrust": 44, "policyAcceptance": 44, "regulationPreference": 74, "publicServiceSatisfaction": 63}	0
4253	한민준	21	18-29	Male	강원특별자치도	37.756008	128.225083	대학교 졸	200만원 미만	주부	다세대 가구	25	보수 성향 무당층	51	{"economy": 26, "housing": -4, "welfare": -25, "security": 20, "environment": -7}	포털 뉴스	{다양성,안전,공정}	강원특별자치도에 거주하는 18-29 주부. 정치 성향은 중도이며 다양성, 안전, 공정 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 85, "ecoConsciousness": 48, "priceSensitivity": 58, "digitalConsumption": 97}	{"taxTolerance": 50, "governmentTrust": 46, "policyAcceptance": 52, "regulationPreference": 67, "publicServiceSatisfaction": 71}	0
4254	오영수	18	18-29	Male	강원특별자치도	37.782332	128.24158	대학원 졸	350-500만원	사무직	부부 가구	-30	진보 성향 무당층	43	{"economy": -24, "housing": 14, "welfare": 56, "security": -5, "environment": 27}	지상파/종편 뉴스	{안정,공동체,환경}	강원특별자치도에 거주하는 18-29 사무직. 정치 성향은 중도이며 안정, 공동체, 환경 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 82, "ecoConsciousness": 54, "priceSensitivity": 70, "digitalConsumption": 80}	{"taxTolerance": 45, "governmentTrust": 30, "policyAcceptance": 64, "regulationPreference": 56, "publicServiceSatisfaction": 72}	0
4255	김현우	33	30-39	Female	강원특별자치도	37.866204	128.218053	대학원 졸	200만원 미만	서비스직	1인 가구	21	보수 성향 무당층	47	{"economy": 19, "housing": 2, "welfare": 6, "security": 8, "environment": 9}	SNS	{공정,혁신,자유}	강원특별자치도에 거주하는 30-39 서비스직. 정치 성향은 중도이며 공정, 혁신, 자유 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 82, "ecoConsciousness": 63, "priceSensitivity": 67, "digitalConsumption": 78}	{"taxTolerance": 54, "governmentTrust": 46, "policyAcceptance": 71, "regulationPreference": 60, "publicServiceSatisfaction": 58}	0
4256	정미경	38	30-39	Female	강원특별자치도	37.895353	128.165306	고졸 이하	200-350만원	공무원	1인 가구	3	중도 무당층	58	{"economy": 28, "housing": -14, "welfare": 21, "security": -18, "environment": -13}	지상파/종편 뉴스	{공동체,혁신,안전}	강원특별자치도에 거주하는 30-39 공무원. 정치 성향은 중도이며 공동체, 혁신, 안전 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 44, "ecoConsciousness": 50, "priceSensitivity": 63, "digitalConsumption": 71}	{"taxTolerance": 51, "governmentTrust": 59, "policyAcceptance": 49, "regulationPreference": 52, "publicServiceSatisfaction": 70}	0
4257	정동현	33	30-39	Male	강원특별자치도	37.802974	128.125665	대학교 졸	200-350만원	서비스직	다세대 가구	-24	진보 성향 무당층	58	{"economy": -45, "housing": 25, "welfare": 24, "security": 28, "environment": 15}	유튜브	{전통,자유,다양성}	강원특별자치도에 거주하는 30-39 서비스직. 정치 성향은 중도이며 전통, 자유, 다양성 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 61, "ecoConsciousness": 54, "priceSensitivity": 77, "digitalConsumption": 83}	{"taxTolerance": 59, "governmentTrust": 60, "policyAcceptance": 41, "regulationPreference": 62, "publicServiceSatisfaction": 72}	0
4258	이현우	37	30-39	Male	강원특별자치도	37.787775	128.189577	대학교 졸	200-350만원	공무원	다세대 가구	-1	중도 무당층	40	{"economy": -9, "housing": 8, "welfare": 13, "security": 38, "environment": 10}	신문/팟캐스트	{다양성,전통,자유}	강원특별자치도에 거주하는 30-39 공무원. 정치 성향은 중도이며 다양성, 전통, 자유 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 76, "ecoConsciousness": 43, "priceSensitivity": 52, "digitalConsumption": 76}	{"taxTolerance": 65, "governmentTrust": 47, "policyAcceptance": 49, "regulationPreference": 60, "publicServiceSatisfaction": 63}	0
4259	최주원	47	40-49	Female	강원특별자치도	37.805498	128.207826	대학교 졸	500-700만원	전문직	다세대 가구	2	중도 무당층	71	{"economy": 3, "housing": -6, "welfare": 25, "security": 11, "environment": 35}	포털 뉴스	{자유,공정,안전}	강원특별자치도에 거주하는 40-49 전문직. 정치 성향은 중도이며 자유, 공정, 안전 가치를 중시한다.	{"brandLoyalty": 25, "noveltySeeking": 64, "ecoConsciousness": 63, "priceSensitivity": 54, "digitalConsumption": 54}	{"taxTolerance": 67, "governmentTrust": 35, "policyAcceptance": 34, "regulationPreference": 46, "publicServiceSatisfaction": 75}	0
4260	장지호	45	40-49	Female	강원특별자치도	37.868744	128.23676	대학원 졸	200-350만원	학생	부부 가구	-25	진보 성향 무당층	59	{"economy": -22, "housing": 19, "welfare": 19, "security": -17, "environment": 45}	포털 뉴스	{환경,전통,혁신}	강원특별자치도에 거주하는 40-49 학생. 정치 성향은 중도이며 환경, 전통, 혁신 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 61, "ecoConsciousness": 59, "priceSensitivity": 76, "digitalConsumption": 79}	{"taxTolerance": 60, "governmentTrust": 31, "policyAcceptance": 44, "regulationPreference": 53, "publicServiceSatisfaction": 82}	0
4261	황광수	48	40-49	Male	강원특별자치도	37.874933	128.072059	대학교 졸	350-500만원	은퇴	1인 가구	-12	중도 무당층	75	{"economy": -26, "housing": 41, "welfare": 23, "security": 29, "environment": 17}	신문/팟캐스트	{혁신,공정,공동체}	강원특별자치도에 거주하는 40-49 은퇴. 정치 성향은 중도이며 혁신, 공정, 공동체 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 59, "ecoConsciousness": 63, "priceSensitivity": 57, "digitalConsumption": 73}	{"taxTolerance": 61, "governmentTrust": 66, "policyAcceptance": 37, "regulationPreference": 80, "publicServiceSatisfaction": 62}	0
4262	안민서	42	40-49	Male	강원특별자치도	37.754751	128.160063	대학교 졸	350-500만원	생산직	자녀 양육 가구	-67	진보 정당 지지	51	{"economy": -60, "housing": 43, "welfare": 52, "security": -35, "environment": 61}	유튜브	{환경,전통,공정}	강원특별자치도에 거주하는 40-49 생산직. 정치 성향은 진보이며 환경, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 78, "ecoConsciousness": 50, "priceSensitivity": 67, "digitalConsumption": 87}	{"taxTolerance": 67, "governmentTrust": 32, "policyAcceptance": 29, "regulationPreference": 69, "publicServiceSatisfaction": 75}	0
4263	김지우	50	50-59	Female	강원특별자치도	37.884023	128.213522	전문대 졸	500-700만원	주부	다세대 가구	44	보수 성향 무당층	77	{"economy": 32, "housing": 8, "welfare": -28, "security": 34, "environment": 19}	유튜브	{안전,전통,공동체}	강원특별자치도에 거주하는 50-59 주부. 정치 성향은 보수이며 안전, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 56, "ecoConsciousness": 52, "priceSensitivity": 59, "digitalConsumption": 63}	{"taxTolerance": 65, "governmentTrust": 56, "policyAcceptance": 21, "regulationPreference": 53, "publicServiceSatisfaction": 74}	0
4264	김동현	58	50-59	Female	강원특별자치도	37.872359	128.226531	고졸 이하	500-700만원	학생	다세대 가구	34	보수 성향 무당층	54	{"economy": 23, "housing": 7, "welfare": -17, "security": 26, "environment": 37}	유튜브	{공정,혁신,환경}	강원특별자치도에 거주하는 50-59 학생. 정치 성향은 보수이며 공정, 혁신, 환경 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 28, "ecoConsciousness": 40, "priceSensitivity": 51, "digitalConsumption": 62}	{"taxTolerance": 32, "governmentTrust": 60, "policyAcceptance": 51, "regulationPreference": 67, "publicServiceSatisfaction": 63}	0
4265	조혜진	57	50-59	Male	강원특별자치도	37.764032	128.239258	대학원 졸	500-700만원	프리랜서	다세대 가구	-12	중도 무당층	75	{"economy": -15, "housing": 7, "welfare": 30, "security": 7, "environment": 6}	유튜브	{혁신,환경,다양성}	강원특별자치도에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 혁신, 환경, 다양성 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 62, "ecoConsciousness": 63, "priceSensitivity": 71, "digitalConsumption": 52}	{"taxTolerance": 50, "governmentTrust": 43, "policyAcceptance": 48, "regulationPreference": 64, "publicServiceSatisfaction": 77}	0
4266	한영수	54	50-59	Male	강원특별자치도	37.77344	128.135384	전문대 졸	700만원 이상	프리랜서	자녀 양육 가구	-1	중도 무당층	80	{"economy": -17, "housing": 30, "welfare": 27, "security": 55, "environment": 15}	포털 뉴스	{혁신,안전,공동체}	강원특별자치도에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 혁신, 안전, 공동체 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 54, "ecoConsciousness": 43, "priceSensitivity": 55, "digitalConsumption": 76}	{"taxTolerance": 29, "governmentTrust": 36, "policyAcceptance": 56, "regulationPreference": 59, "publicServiceSatisfaction": 55}	0
4267	홍예준	66	60-69	Female	강원특별자치도	37.797379	128.249888	대학교 졸	200-350만원	은퇴	다세대 가구	7	중도 무당층	68	{"economy": -10, "housing": 26, "welfare": 11, "security": 14, "environment": 15}	유튜브	{공동체,안전,성장}	강원특별자치도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 공동체, 안전, 성장 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 63, "ecoConsciousness": 51, "priceSensitivity": 70, "digitalConsumption": 40}	{"taxTolerance": 55, "governmentTrust": 56, "policyAcceptance": 43, "regulationPreference": 67, "publicServiceSatisfaction": 58}	0
4268	류민준	66	60-69	Female	강원특별자치도	37.898647	128.122417	전문대 졸	350-500만원	학생	다세대 가구	37	보수 성향 무당층	99	{"economy": 3, "housing": 19, "welfare": -29, "security": 54, "environment": 28}	지상파/종편 뉴스	{자유,혁신,다양성}	강원특별자치도에 거주하는 60-69 학생. 정치 성향은 보수이며 자유, 혁신, 다양성 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 57, "ecoConsciousness": 38, "priceSensitivity": 46, "digitalConsumption": 60}	{"taxTolerance": 43, "governmentTrust": 67, "policyAcceptance": 43, "regulationPreference": 70, "publicServiceSatisfaction": 67}	0
4269	전지아	60	60-69	Male	강원특별자치도	37.833338	128.084489	전문대 졸	700만원 이상	학생	부부 가구	11	중도 무당층	66	{"economy": 0, "housing": 15, "welfare": 11, "security": 19, "environment": 29}	포털 뉴스	{전통,다양성,안전}	강원특별자치도에 거주하는 60-69 학생. 정치 성향은 중도이며 전통, 다양성, 안전 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 44, "ecoConsciousness": 46, "priceSensitivity": 58, "digitalConsumption": 63}	{"taxTolerance": 71, "governmentTrust": 57, "policyAcceptance": 53, "regulationPreference": 58, "publicServiceSatisfaction": 47}	0
4270	황순자	69	60-69	Male	강원특별자치도	37.797128	128.075925	전문대 졸	200-350만원	은퇴	다세대 가구	69	보수 정당 지지	87	{"economy": 45, "housing": -25, "welfare": -17, "security": 54, "environment": -10}	SNS	{혁신,안정,성장}	강원특별자치도에 거주하는 60-69 은퇴. 정치 성향은 보수이며 혁신, 안정, 성장 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 39, "ecoConsciousness": 21, "priceSensitivity": 80, "digitalConsumption": 57}	{"taxTolerance": 54, "governmentTrust": 46, "policyAcceptance": 72, "regulationPreference": 59, "publicServiceSatisfaction": 75}	0
4271	류미경	83	70+	Female	강원특별자치도	37.835369	128.227861	대학교 졸	700만원 이상	은퇴	자녀 양육 가구	41	보수 성향 무당층	93	{"economy": 28, "housing": 14, "welfare": -26, "security": 10, "environment": 32}	SNS	{다양성,혁신,자유}	강원특별자치도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 다양성, 혁신, 자유 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 43, "ecoConsciousness": 19, "priceSensitivity": 60, "digitalConsumption": 64}	{"taxTolerance": 55, "governmentTrust": 60, "policyAcceptance": 50, "regulationPreference": 47, "publicServiceSatisfaction": 49}	0
4272	권지호	80	70+	Female	강원특별자치도	37.849465	128.105358	대학원 졸	200만원 미만	은퇴	다세대 가구	-25	진보 성향 무당층	95	{"economy": -8, "housing": 40, "welfare": 23, "security": 20, "environment": 14}	신문/팟캐스트	{안전,공정,환경}	강원특별자치도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안전, 공정, 환경 가치를 중시한다.	{"brandLoyalty": 61, "noveltySeeking": 50, "ecoConsciousness": 33, "priceSensitivity": 81, "digitalConsumption": 43}	{"taxTolerance": 49, "governmentTrust": 71, "policyAcceptance": 53, "regulationPreference": 69, "publicServiceSatisfaction": 52}	0
4273	조영수	77	70+	Male	강원특별자치도	37.801414	128.098799	대학교 졸	350-500만원	은퇴	부부 가구	-24	진보 성향 무당층	63	{"economy": -22, "housing": 26, "welfare": 37, "security": -1, "environment": 18}	포털 뉴스	{다양성,혁신,공정}	강원특별자치도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 다양성, 혁신, 공정 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 41, "ecoConsciousness": 36, "priceSensitivity": 44, "digitalConsumption": 49}	{"taxTolerance": 43, "governmentTrust": 43, "policyAcceptance": 66, "regulationPreference": 62, "publicServiceSatisfaction": 89}	0
4274	김준서	80	70+	Male	강원특별자치도	37.816817	128.155693	고졸 이하	200만원 미만	은퇴	부부 가구	9	중도 무당층	99	{"economy": 2, "housing": -1, "welfare": -12, "security": 19, "environment": 15}	유튜브	{자유,안전,공정}	강원특별자치도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 자유, 안전, 공정 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 39, "ecoConsciousness": 48, "priceSensitivity": 66, "digitalConsumption": 76}	{"taxTolerance": 42, "governmentTrust": 51, "policyAcceptance": 49, "regulationPreference": 65, "publicServiceSatisfaction": 59}	0
4275	임민준	25	18-29	Female	전북특별자치도	35.870848	127.140778	대학원 졸	200-350만원	서비스직	다세대 가구	-66	진보 정당 지지	40	{"economy": -43, "housing": 11, "welfare": 14, "security": -39, "environment": 50}	포털 뉴스	{안전,자유,공정}	전북특별자치도에 거주하는 18-29 서비스직. 정치 성향은 진보이며 안전, 자유, 공정 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 81, "ecoConsciousness": 53, "priceSensitivity": 79, "digitalConsumption": 82}	{"taxTolerance": 60, "governmentTrust": 48, "policyAcceptance": 33, "regulationPreference": 68, "publicServiceSatisfaction": 66}	0
4276	김경숙	28	18-29	Female	전북특별자치도	35.791989	127.107235	전문대 졸	500-700만원	학생	자녀 양육 가구	-64	진보 정당 지지	36	{"economy": -60, "housing": 30, "welfare": 63, "security": -35, "environment": 29}	지상파/종편 뉴스	{공동체,혁신,안정}	전북특별자치도에 거주하는 18-29 학생. 정치 성향은 진보이며 공동체, 혁신, 안정 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 78, "ecoConsciousness": 43, "priceSensitivity": 46, "digitalConsumption": 79}	{"taxTolerance": 56, "governmentTrust": 38, "policyAcceptance": 36, "regulationPreference": 56, "publicServiceSatisfaction": 58}	0
4277	전정희	28	18-29	Male	전북특별자치도	35.880702	127.10487	대학원 졸	200-350만원	전문직	자녀 양육 가구	-61	진보 정당 지지	32	{"economy": -40, "housing": 17, "welfare": 28, "security": -12, "environment": 60}	신문/팟캐스트	{안정,환경,전통}	전북특별자치도에 거주하는 18-29 전문직. 정치 성향은 진보이며 안정, 환경, 전통 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 54, "ecoConsciousness": 66, "priceSensitivity": 59, "digitalConsumption": 80}	{"taxTolerance": 58, "governmentTrust": 24, "policyAcceptance": 38, "regulationPreference": 58, "publicServiceSatisfaction": 63}	0
4278	장동현	19	18-29	Male	전북특별자치도	35.764113	127.017631	대학교 졸	700만원 이상	사무직	1인 가구	-39	진보 성향 무당층	29	{"economy": -12, "housing": 16, "welfare": 30, "security": -3, "environment": 30}	신문/팟캐스트	{혁신,다양성,환경}	전북특별자치도에 거주하는 18-29 사무직. 정치 성향은 진보이며 혁신, 다양성, 환경 가치를 중시한다.	{"brandLoyalty": 25, "noveltySeeking": 57, "ecoConsciousness": 30, "priceSensitivity": 54, "digitalConsumption": 81}	{"taxTolerance": 40, "governmentTrust": 37, "policyAcceptance": 38, "regulationPreference": 49, "publicServiceSatisfaction": 69}	0
4279	김미경	30	30-39	Female	전북특별자치도	35.827185	127.020272	고졸 이하	500-700만원	자영업	자녀 양육 가구	-100	진보 정당 지지	30	{"economy": -60, "housing": 40, "welfare": 68, "security": -62, "environment": 75}	SNS	{안정,공동체,혁신}	전북특별자치도에 거주하는 30-39 자영업. 정치 성향은 진보이며 안정, 공동체, 혁신 가치를 중시한다.	{"brandLoyalty": 24, "noveltySeeking": 71, "ecoConsciousness": 53, "priceSensitivity": 49, "digitalConsumption": 79}	{"taxTolerance": 71, "governmentTrust": 57, "policyAcceptance": 25, "regulationPreference": 69, "publicServiceSatisfaction": 66}	0
4280	윤채원	34	30-39	Female	전북특별자치도	35.753628	127.199987	전문대 졸	350-500만원	학생	부부 가구	-67	진보 정당 지지	47	{"economy": -60, "housing": 36, "welfare": 43, "security": -42, "environment": 28}	SNS	{공정,공동체,안정}	전북특별자치도에 거주하는 30-39 학생. 정치 성향은 진보이며 공정, 공동체, 안정 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 89, "ecoConsciousness": 44, "priceSensitivity": 54, "digitalConsumption": 78}	{"taxTolerance": 36, "governmentTrust": 29, "policyAcceptance": 28, "regulationPreference": 47, "publicServiceSatisfaction": 54}	0
4281	오순자	37	30-39	Male	전북특별자치도	35.74192	127.057914	대학원 졸	350-500만원	자영업	다세대 가구	-47	진보 정당 지지	54	{"economy": -19, "housing": 28, "welfare": 39, "security": -19, "environment": 37}	포털 뉴스	{공동체,안정,공정}	전북특별자치도에 거주하는 30-39 자영업. 정치 성향은 진보이며 공동체, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 73, "ecoConsciousness": 57, "priceSensitivity": 56, "digitalConsumption": 73}	{"taxTolerance": 67, "governmentTrust": 47, "policyAcceptance": 40, "regulationPreference": 64, "publicServiceSatisfaction": 75}	0
4282	전예준	37	30-39	Male	전북특별자치도	35.891912	127.091453	전문대 졸	350-500만원	은퇴	자녀 양육 가구	-44	진보 성향 무당층	52	{"economy": -55, "housing": 25, "welfare": 44, "security": -37, "environment": 36}	유튜브	{공동체,공정,환경}	전북특별자치도에 거주하는 30-39 은퇴. 정치 성향은 진보이며 공동체, 공정, 환경 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 54, "ecoConsciousness": 51, "priceSensitivity": 60, "digitalConsumption": 54}	{"taxTolerance": 41, "governmentTrust": 50, "policyAcceptance": 40, "regulationPreference": 57, "publicServiceSatisfaction": 85}	0
4283	조건우	43	40-49	Female	전북특별자치도	35.829355	127.190892	대학교 졸	700만원 이상	은퇴	부부 가구	-58	진보 정당 지지	60	{"economy": -31, "housing": 34, "welfare": 41, "security": -28, "environment": 42}	포털 뉴스	{자유,안전,혁신}	전북특별자치도에 거주하는 40-49 은퇴. 정치 성향은 진보이며 자유, 안전, 혁신 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 52, "ecoConsciousness": 45, "priceSensitivity": 52, "digitalConsumption": 71}	{"taxTolerance": 58, "governmentTrust": 51, "policyAcceptance": 41, "regulationPreference": 72, "publicServiceSatisfaction": 65}	0
4284	권서연	47	40-49	Female	전북특별자치도	35.786506	127.059965	대학원 졸	200-350만원	전문직	자녀 양육 가구	-5	중도 무당층	72	{"economy": -9, "housing": 43, "welfare": 37, "security": 10, "environment": 23}	지상파/종편 뉴스	{공정,성장,혁신}	전북특별자치도에 거주하는 40-49 전문직. 정치 성향은 중도이며 공정, 성장, 혁신 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 51, "ecoConsciousness": 67, "priceSensitivity": 79, "digitalConsumption": 70}	{"taxTolerance": 43, "governmentTrust": 54, "policyAcceptance": 47, "regulationPreference": 73, "publicServiceSatisfaction": 65}	0
4285	서경숙	46	40-49	Male	전북특별자치도	35.825859	127.132307	전문대 졸	500-700만원	생산직	부부 가구	-66	진보 정당 지지	47	{"economy": -24, "housing": 43, "welfare": 48, "security": -37, "environment": 46}	유튜브	{안정,환경,안전}	전북특별자치도에 거주하는 40-49 생산직. 정치 성향은 진보이며 안정, 환경, 안전 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 54, "ecoConsciousness": 45, "priceSensitivity": 58, "digitalConsumption": 62}	{"taxTolerance": 58, "governmentTrust": 32, "policyAcceptance": 66, "regulationPreference": 66, "publicServiceSatisfaction": 59}	0
4286	윤미경	45	40-49	Male	전북특별자치도	35.812563	127.134652	전문대 졸	350-500만원	주부	자녀 양육 가구	-34	진보 성향 무당층	92	{"economy": -25, "housing": 48, "welfare": 47, "security": -8, "environment": 30}	지상파/종편 뉴스	{안전,전통,자유}	전북특별자치도에 거주하는 40-49 주부. 정치 성향은 진보이며 안전, 전통, 자유 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 68, "ecoConsciousness": 55, "priceSensitivity": 74, "digitalConsumption": 49}	{"taxTolerance": 42, "governmentTrust": 43, "policyAcceptance": 42, "regulationPreference": 56, "publicServiceSatisfaction": 46}	0
4287	장하은	52	50-59	Female	전북특별자치도	35.878554	127.11532	대학원 졸	350-500만원	사무직	자녀 양육 가구	-15	진보 성향 무당층	68	{"economy": 5, "housing": 25, "welfare": 15, "security": 3, "environment": 17}	SNS	{혁신,성장,공정}	전북특별자치도에 거주하는 50-59 사무직. 정치 성향은 중도이며 혁신, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 42, "ecoConsciousness": 48, "priceSensitivity": 53, "digitalConsumption": 76}	{"taxTolerance": 68, "governmentTrust": 25, "policyAcceptance": 60, "regulationPreference": 78, "publicServiceSatisfaction": 79}	0
4288	한지민	55	50-59	Female	전북특별자치도	35.745146	127.011005	대학원 졸	700만원 이상	서비스직	1인 가구	-44	진보 성향 무당층	53	{"economy": -37, "housing": 18, "welfare": 19, "security": -47, "environment": 52}	포털 뉴스	{안전,공동체,환경}	전북특별자치도에 거주하는 50-59 서비스직. 정치 성향은 진보이며 안전, 공동체, 환경 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 78, "ecoConsciousness": 34, "priceSensitivity": 47, "digitalConsumption": 62}	{"taxTolerance": 42, "governmentTrust": 64, "policyAcceptance": 49, "regulationPreference": 78, "publicServiceSatisfaction": 63}	0
4289	류다은	54	50-59	Female	전북특별자치도	35.847356	127.129113	전문대 졸	200-350만원	은퇴	부부 가구	-47	진보 정당 지지	65	{"economy": -45, "housing": 25, "welfare": 31, "security": -14, "environment": 47}	포털 뉴스	{환경,전통,공정}	전북특별자치도에 거주하는 50-59 은퇴. 정치 성향은 진보이며 환경, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 49, "ecoConsciousness": 56, "priceSensitivity": 81, "digitalConsumption": 68}	{"taxTolerance": 59, "governmentTrust": 55, "policyAcceptance": 35, "regulationPreference": 65, "publicServiceSatisfaction": 61}	0
4290	신민준	58	50-59	Male	전북특별자치도	35.835404	127.119529	대학교 졸	350-500만원	전문직	부부 가구	-63	진보 정당 지지	64	{"economy": -39, "housing": 28, "welfare": 27, "security": 3, "environment": 34}	신문/팟캐스트	{안정,성장,공정}	전북특별자치도에 거주하는 50-59 전문직. 정치 성향은 진보이며 안정, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 57, "ecoConsciousness": 50, "priceSensitivity": 66, "digitalConsumption": 65}	{"taxTolerance": 44, "governmentTrust": 63, "policyAcceptance": 51, "regulationPreference": 62, "publicServiceSatisfaction": 66}	0
4291	서지민	50	50-59	Male	전북특별자치도	35.873247	127.111558	전문대 졸	700만원 이상	서비스직	부부 가구	-76	진보 정당 지지	81	{"economy": -82, "housing": 46, "welfare": 48, "security": -30, "environment": 44}	유튜브	{공정,혁신,공동체}	전북특별자치도에 거주하는 50-59 서비스직. 정치 성향은 진보이며 공정, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 62, "ecoConsciousness": 44, "priceSensitivity": 39, "digitalConsumption": 80}	{"taxTolerance": 34, "governmentTrust": 44, "policyAcceptance": 45, "regulationPreference": 50, "publicServiceSatisfaction": 67}	0
4292	권순자	50	50-59	Male	전북특별자치도	35.854187	127.177074	대학원 졸	700만원 이상	자영업	다세대 가구	-32	진보 성향 무당층	69	{"economy": -23, "housing": 37, "welfare": 31, "security": 3, "environment": 33}	지상파/종편 뉴스	{다양성,공정,자유}	전북특별자치도에 거주하는 50-59 자영업. 정치 성향은 중도이며 다양성, 공정, 자유 가치를 중시한다.	{"brandLoyalty": 21, "noveltySeeking": 52, "ecoConsciousness": 47, "priceSensitivity": 39, "digitalConsumption": 78}	{"taxTolerance": 43, "governmentTrust": 52, "policyAcceptance": 52, "regulationPreference": 63, "publicServiceSatisfaction": 61}	0
4293	강순자	64	60-69	Female	전북특별자치도	35.760777	127.082413	대학교 졸	350-500만원	전문직	부부 가구	-10	중도 무당층	87	{"economy": 9, "housing": 6, "welfare": 27, "security": 5, "environment": 31}	SNS	{공정,환경,전통}	전북특별자치도에 거주하는 60-69 전문직. 정치 성향은 중도이며 공정, 환경, 전통 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 28, "ecoConsciousness": 59, "priceSensitivity": 58, "digitalConsumption": 69}	{"taxTolerance": 44, "governmentTrust": 53, "policyAcceptance": 78, "regulationPreference": 62, "publicServiceSatisfaction": 64}	0
4294	정다은	64	60-69	Female	전북특별자치도	35.809783	127.13551	대학교 졸	500-700만원	사무직	부부 가구	-62	진보 정당 지지	78	{"economy": -48, "housing": 41, "welfare": 42, "security": -20, "environment": 29}	포털 뉴스	{다양성,공정,안정}	전북특별자치도에 거주하는 60-69 사무직. 정치 성향은 진보이며 다양성, 공정, 안정 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 52, "ecoConsciousness": 35, "priceSensitivity": 54, "digitalConsumption": 68}	{"taxTolerance": 59, "governmentTrust": 48, "policyAcceptance": 47, "regulationPreference": 84, "publicServiceSatisfaction": 62}	0
4295	정동현	61	60-69	Male	전북특별자치도	35.884144	127.198585	대학원 졸	350-500만원	전문직	다세대 가구	-77	진보 정당 지지	72	{"economy": -90, "housing": 24, "welfare": 41, "security": -31, "environment": 52}	SNS	{공정,자유,공동체}	전북특별자치도에 거주하는 60-69 전문직. 정치 성향은 진보이며 공정, 자유, 공동체 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 42, "ecoConsciousness": 48, "priceSensitivity": 65, "digitalConsumption": 72}	{"taxTolerance": 74, "governmentTrust": 46, "policyAcceptance": 47, "regulationPreference": 57, "publicServiceSatisfaction": 58}	0
4296	장순자	63	60-69	Male	전북특별자치도	35.850406	127.180981	대학원 졸	350-500만원	생산직	다세대 가구	-55	진보 정당 지지	65	{"economy": -49, "housing": 0, "welfare": 25, "security": 4, "environment": 39}	지상파/종편 뉴스	{공동체,안정,환경}	전북특별자치도에 거주하는 60-69 생산직. 정치 성향은 진보이며 공동체, 안정, 환경 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 59, "ecoConsciousness": 66, "priceSensitivity": 69, "digitalConsumption": 71}	{"taxTolerance": 40, "governmentTrust": 31, "policyAcceptance": 37, "regulationPreference": 67, "publicServiceSatisfaction": 66}	0
4297	황성호	71	70+	Female	전북특별자치도	35.859157	127.045015	대학교 졸	500-700만원	은퇴	부부 가구	-65	진보 정당 지지	78	{"economy": -44, "housing": 54, "welfare": 26, "security": -41, "environment": 44}	SNS	{환경,공동체,혁신}	전북특별자치도에 거주하는 70+ 은퇴. 정치 성향은 진보이며 환경, 공동체, 혁신 가치를 중시한다.	{"brandLoyalty": 63, "noveltySeeking": 69, "ecoConsciousness": 57, "priceSensitivity": 48, "digitalConsumption": 52}	{"taxTolerance": 53, "governmentTrust": 45, "policyAcceptance": 49, "regulationPreference": 71, "publicServiceSatisfaction": 82}	0
4298	황민준	84	70+	Female	전북특별자치도	35.777118	127.200093	고졸 이하	350-500만원	은퇴	1인 가구	6	중도 무당층	80	{"economy": -3, "housing": 23, "welfare": 2, "security": 26, "environment": 20}	유튜브	{자유,다양성,안전}	전북특별자치도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 자유, 다양성, 안전 가치를 중시한다.	{"brandLoyalty": 60, "noveltySeeking": 29, "ecoConsciousness": 38, "priceSensitivity": 67, "digitalConsumption": 53}	{"taxTolerance": 34, "governmentTrust": 63, "policyAcceptance": 57, "regulationPreference": 69, "publicServiceSatisfaction": 66}	0
4299	이채원	75	70+	Male	전북특별자치도	35.796934	127.041353	대학교 졸	200-350만원	은퇴	1인 가구	14	중도 무당층	86	{"economy": 21, "housing": -5, "welfare": 6, "security": 33, "environment": 6}	신문/팟캐스트	{자유,성장,공정}	전북특별자치도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 자유, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 23, "ecoConsciousness": 44, "priceSensitivity": 91, "digitalConsumption": 38}	{"taxTolerance": 37, "governmentTrust": 43, "policyAcceptance": 64, "regulationPreference": 65, "publicServiceSatisfaction": 68}	0
4300	장영수	79	70+	Male	전북특별자치도	35.880319	127.047964	대학교 졸	500-700만원	은퇴	자녀 양육 가구	-31	진보 성향 무당층	99	{"economy": -49, "housing": 33, "welfare": -6, "security": -30, "environment": 16}	신문/팟캐스트	{성장,공동체,안정}	전북특별자치도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 성장, 공동체, 안정 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 43, "ecoConsciousness": 41, "priceSensitivity": 46, "digitalConsumption": 76}	{"taxTolerance": 61, "governmentTrust": 57, "policyAcceptance": 53, "regulationPreference": 74, "publicServiceSatisfaction": 58}	0
\.


--
-- Data for Name: calibration_settings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.calibration_settings (id, method, benchmark_weight, recency_weight, shrinkage_factor, outlier_trim_pct, description, updated_at, apply_to_population, user_id) FROM stdin;
1	베이지안 축소 (Bayesian Shrinkage)	0.6	0.3	0.4	5	과거 가상 이벤트 벤치마크에 가중치를 두고, 최근 데이터에 더 큰 비중을 부여하여 원시 예측을 보정합니다.	2026-06-17 09:25:00.093+00	t	0
\.


--
-- Data for Name: calibrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.calibrations (id, title, event_type, target_date, metric, actual_value, raw_prediction, calibrated_prediction, raw_error, calibrated_error, method, product, user_id) FROM stdin;
9	신제품 A 출시 반응	제품 반응	2025-03-15	구매의향률	42	51	47.4	9	5.4	베이지안 축소 (Bayesian Shrinkage)	Lumen	0
10	봄 캠페인 전환율	제품 반응	2025-05-20	전환율	18	24	21.6	6	3.6	베이지안 축소 (Bayesian Shrinkage)	Lumen	0
11	프리미엄 요금제 수용	여론조사	2025-06-01	가입의향률	29	35	32.6	6	3.6	베이지안 축소 (Bayesian Shrinkage)	Lumen	0
12	주 4일제 시범 수용	정책 반응	2025-02-10	찬성률	58	66	62.8	8	4.8	베이지안 축소 (Bayesian Shrinkage)	Seraph	0
13	청년 주거지원 정책	정책 반응	2025-04-05	수용률	71	64	66.8	7	4.2	베이지안 축소 (Bayesian Shrinkage)	Seraph	0
14	대중교통 요금 인상안	여론조사	2025-05-30	찬성률	33	41	37.8	8	4.8	베이지안 축소 (Bayesian Shrinkage)	Seraph	0
15	시뮬레이션 학습 — 청년 월세 지원 확대 정책 반응 테스트	시뮬레이션	2026-06-22	실제 지지율(여론조사)	43.5	40.6	41.8	2.9	1.7	베이지안 축소 (Bayesian Shrinkage)	Seraph	0
4	심야 대중교통 확대 정책 지지율	정책 반응	2025-11-02	지지율(%)	67.4	73.1	68.8	5.7	1.4	사후 인구가중 + 성향 보정	Seraph	0
3	생활폐기물 종량제 인상 수용도	정책	2025-09-15	찬성 비율(%)	38.7	31.2	37	-7.5	-1.7	이슈 민감도 재가중	Seraph	0
6	청년 주거 지원 정책 인지·지지	정책	2026-01-20	지지 비율(%)	58.9	64.2	60.1	5.3	1.2	베이지안 수축 보정	Seraph	0
7	탄소중립 교통 분담금 도입 찬반	정책	2026-02-14	찬성 비율(%)	33.5	27	32.2	-6.5	-1.3	이슈 민감도 재가중	Seraph	0
5	신제품 구독 서비스 출시 반응	제품 반응	2025-12-10	구매 의향(%)	24.6	30.4	25.9	5.8	1.3	세그먼트 캘리브레이션	Lumen	0
\.


--
-- Data for Name: contributor_reputation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.contributor_reputation (user_id, contributions, helpful, harmful, reputation, updated_at) FROM stdin;
0	3	2	1	1.2	2026-06-26 02:39:02.084867+00
2	1	1	0	2	2026-06-26 02:48:35.37693+00
1	6	4	1	2	2026-06-26 02:48:35.38+00
\.


--
-- Data for Name: data_sources; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.data_sources (id, name, agency, category, contributes_to, record_count, coverage, reference_year, source_url) FROM stdin;
1	통계청 인구주택총조사	통계청	인구통계	연령·성별·가구 구성 분포	51829023	전국 (서울 추출)	2020	https://kostat.go.kr
2	주민등록 인구통계	행정안전부	인구통계	자치구별 인구 규모·가중치	9386034	서울특별시 25개 자치구	2024	https://jumin.mois.go.kr
3	KOSIS 가계금융복지조사	통계청	소득·자산	소득 분위·가구 자산 분포	20000	전국 표본	2023	https://kosis.kr
4	서울 열린데이터광장 행정구역	서울특별시	지리정보	자치구 중심좌표·경계(lat/lng)	25	서울특별시	2024	https://data.seoul.go.kr
5	중앙선거관리위원회 선거통계시스템	중앙선거관리위원회	정치성향	투표율·정당 득표 성향 보정	4400000	서울 유권자	2024	https://info.nec.go.kr
6	한국언론진흥재단 언론수용자조사	한국언론진흥재단	미디어이용	미디어 이용 행태(미디어 다이어트)	58000	전국 표본	2023	https://www.kpf.or.kr
7	경제활동인구조사	통계청	직업·고용	직업·종사상 지위 분포	35000	전국 표본	2024	https://kostat.go.kr
133	한국갤럽 데일리 오피니언 (경기 전망)	한국갤럽	여론조사	경제 태도(시장·정부 역할)	1000	전국 만 18세 이상	2025	https://www.gallup.co.kr/gallupdb/report.asp
134	통계청 2023년 사회조사 (복지)	통계청	여론조사	복지 태도(복지 확대)	36000	전국 만 13세 이상	2023	https://kostat.go.kr/board.es?mid=a10301010000&bid=219&act=view&list_no=427913
135	서울대 통일평화연구원 통일의식조사	서울대학교 통일평화연구원	여론조사	안보 태도(대북 인식)	1200	전국 17개 시·도 만 19세 이상	2024	https://ipus.snu.ac.kr/blog/archives/news/9627
136	KEI 2024 국민환경의식조사	한국환경연구원(KEI)	여론조사	환경 태도(기후변화 인식)	3040	전국 성인 (웹조사)	2024	https://www.kei.re.kr/elibList.es?mid=a10101010000&elibName=researchreport&act=view&c_id=766481
137	국토교통부 2023년 주거실태조사	국토교통부	여론조사	주거 태도(보유의사·지원)	61000	전국 약 6.1만 가구	2023	https://www.molit.go.kr/USR/NEWS/m_71/dtl.jsp?lcmspage=1&id=95090538
138	방송통신위원회 2024 방송매체 이용행태조사	방송통신위원회	소비자조사	디지털소비(OTT·스마트폰 이용)	8316	전국 17개 시·도 13세 이상	2024	https://www.kcc.go.kr/user.do?mode=view&page=A05030000&dc=K05030000&boardId=1113&boardSeq=64951
139	과학기술정보통신부 2024 인터넷이용실태조사	과학기술정보통신부	소비자조사	신제품수용(AI·신기술 수용)	60229	전국 25,509가구 만 3세 이상	2024	https://www.korea.kr/briefing/pressReleaseView.do?newsId=156681493
140	한국소비자원 친환경 소비 제도 이용 실태조사	한국소비자원	소비자조사	친환경소비(인식·실천)	3200	전국 성인 소비자	2025	https://www.kca.go.kr/home/board/download.do?menukey=4002&fno=10046976&bid=00000013&did=1003867815
141	한국은행 소비자동향조사	한국은행	소비자조사	가격민감도(물가 전망)	2500	전국 약 2,500가구 (월간)	2025	https://www.bok.or.kr/portal/bbs/B0000501/view.do?nttId=10095310&menuNo=201264
142	대한상공회의소 소비 트렌드 조사	대한상공회의소	소비자조사	브랜드충성도(가성비·PB 전환)	1000	소비자 대상 설문	2024	http://www.korcham.net/nCham/Service/Economy/appl/KcciReportDetail.asp?SEQ_NO_C010=20120938356&CHAM_CD=B001
143	한국행정연구원 사회통합실태조사 (정부신뢰)	한국행정연구원(KIPA)	정책조사	정부신뢰(중앙정부 신뢰)	8000	전국 만 19세 이상	2023	https://www.kipa.re.kr/site/kipa/research/selectBaseList.do
144	한국행정연구원 사회통합실태조사 (정책수용성)	한국행정연구원(KIPA)	정책조사	정책수용성(정책 결정 과정 신뢰)	8000	전국 만 19세 이상	2023	https://www.kipa.re.kr/site/kipa/research/selectBaseList.do
145	한국조세재정연구원 재정패널조사	한국조세재정연구원(KIPF)	정책조사	증세수용(조세·재정 인식)	5000	전국 가구·개인 패널	2023	https://www.kipf.re.kr/panel/
146	통계청 2024 사회조사 (사회안전·규제)	통계청	정책조사	규제선호(사회안전·규제 인식)	36000	전국 만 13세 이상	2024	https://kostat.go.kr/board.es?mid=a10301010000&bid=219
147	행정안전부 전자정부서비스 이용실태조사	행정안전부	정책조사	공공서비스만족(전자정부 만족도)	4000	전국 만 16~74세	2022	https://www.mois.go.kr/frt/bbs/type010/commonSelectBoardList.do?bbsId=BBSMSTR_000000000008
\.


--
-- Data for Name: demographic_margins; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.demographic_margins (id, dimension, key, label, population) FROM stdin;
1	region	11	서울특별시	9386000
2	region	26	부산광역시	3293000
3	region	27	대구광역시	2374000
4	region	28	인천광역시	2997000
5	region	29	광주광역시	1419000
6	region	30	대전광역시	1442000
7	region	31	울산광역시	1103000
8	region	36	세종특별자치시	387000
9	region	41	경기도	13630000
10	region	51	강원특별자치도	1527000
11	region	43	충청북도	1593000
12	region	44	충청남도	2130000
13	region	52	전북특별자치도	1754000
14	region	46	전라남도	1804000
15	region	47	경상북도	2554000
16	region	48	경상남도	3251000
17	region	50	제주특별자치도	675000
18	age	18-29	18~29세	7000000
19	age	30-39	30대	6600000
20	age	40-49	40대	7900000
21	age	50-59	50대	8600000
22	age	60-69	60대	7200000
23	age	70+	70세 이상	6000000
24	gender	Male	남성	21900000
25	gender	Female	여성	22100000
\.


--
-- Data for Name: elections; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.elections (id, name, election_type, election_date, region_code, metric, leaning, actual_value, actual_winner) FROM stdin;
191	제8회 전국동시지방선거 (광역단체장)	지방선거	2022-06-01	11	보수 후보(국민의힘) 득표율	conservative	59.05	conservative
192	제8회 전국동시지방선거 (광역단체장)	지방선거	2022-06-01	26	보수 후보(국민의힘) 득표율	conservative	66.37	conservative
193	제8회 전국동시지방선거 (광역단체장)	지방선거	2022-06-01	27	보수 후보(국민의힘) 득표율	conservative	78.75	conservative
194	제8회 전국동시지방선거 (광역단체장)	지방선거	2022-06-01	28	보수 후보(국민의힘) 득표율	conservative	51.77	conservative
195	제8회 전국동시지방선거 (광역단체장)	지방선거	2022-06-01	29	보수 후보(국민의힘) 득표율	conservative	15.91	progressive
196	제8회 전국동시지방선거 (광역단체장)	지방선거	2022-06-01	30	보수 후보(국민의힘) 득표율	conservative	51.2	conservative
197	제8회 전국동시지방선거 (광역단체장)	지방선거	2022-06-01	31	보수 후보(국민의힘) 득표율	conservative	59.79	conservative
198	제8회 전국동시지방선거 (광역단체장)	지방선거	2022-06-01	36	보수 후보(국민의힘) 득표율	conservative	52.84	conservative
199	제8회 전국동시지방선거 (광역단체장)	지방선거	2022-06-01	41	보수 후보(국민의힘) 득표율	conservative	48.91	progressive
200	제8회 전국동시지방선거 (광역단체장)	지방선거	2022-06-01	51	보수 후보(국민의힘) 득표율	conservative	54.07	conservative
201	제8회 전국동시지방선거 (광역단체장)	지방선거	2022-06-01	43	보수 후보(국민의힘) 득표율	conservative	58.19	conservative
202	제8회 전국동시지방선거 (광역단체장)	지방선거	2022-06-01	44	보수 후보(국민의힘) 득표율	conservative	53.87	conservative
203	제8회 전국동시지방선거 (광역단체장)	지방선거	2022-06-01	52	보수 후보(국민의힘) 득표율	conservative	17.88	progressive
204	제8회 전국동시지방선거 (광역단체장)	지방선거	2022-06-01	46	보수 후보(국민의힘) 득표율	conservative	18.81	progressive
205	제8회 전국동시지방선거 (광역단체장)	지방선거	2022-06-01	47	보수 후보(국민의힘) 득표율	conservative	77.96	conservative
206	제8회 전국동시지방선거 (광역단체장)	지방선거	2022-06-01	48	보수 후보(국민의힘) 득표율	conservative	65.71	conservative
207	제8회 전국동시지방선거 (광역단체장)	지방선거	2022-06-01	50	보수 후보(국민의힘) 득표율	conservative	39.48	progressive
208	제22대 국회의원선거 (비례대표)	국회의원선거	2024-04-10	11	보수 정당(국민의미래) 득표율	conservative	36.93	conservative
209	제22대 국회의원선거 (비례대표)	국회의원선거	2024-04-10	26	보수 정당(국민의미래) 득표율	conservative	45.94	conservative
210	제22대 국회의원선거 (비례대표)	국회의원선거	2024-04-10	27	보수 정당(국민의미래) 득표율	conservative	60.16	conservative
211	제22대 국회의원선거 (비례대표)	국회의원선거	2024-04-10	28	보수 정당(국민의미래) 득표율	conservative	34.87	conservative
212	제22대 국회의원선거 (비례대표)	국회의원선거	2024-04-10	29	보수 정당(국민의미래) 득표율	conservative	5.77	progressive
213	제22대 국회의원선거 (비례대표)	국회의원선거	2024-04-10	30	보수 정당(국민의미래) 득표율	conservative	35.49	conservative
214	제22대 국회의원선거 (비례대표)	국회의원선거	2024-04-10	31	보수 정당(국민의미래) 득표율	conservative	41.84	conservative
215	제22대 국회의원선거 (비례대표)	국회의원선거	2024-04-10	36	보수 정당(국민의미래) 득표율	conservative	29.88	progressive
216	제22대 국회의원선거 (비례대표)	국회의원선거	2024-04-10	41	보수 정당(국민의미래) 득표율	conservative	33.94	conservative
217	제22대 국회의원선거 (비례대표)	국회의원선거	2024-04-10	51	보수 정당(국민의미래) 득표율	conservative	43.56	conservative
218	제22대 국회의원선거 (비례대표)	국회의원선거	2024-04-10	43	보수 정당(국민의미래) 득표율	conservative	39.05	conservative
219	제22대 국회의원선거 (비례대표)	국회의원선거	2024-04-10	44	보수 정당(국민의미래) 득표율	conservative	38.98	conservative
220	제22대 국회의원선거 (비례대표)	국회의원선거	2024-04-10	52	보수 정당(국민의미래) 득표율	conservative	8.45	progressive
221	제22대 국회의원선거 (비례대표)	국회의원선거	2024-04-10	46	보수 정당(국민의미래) 득표율	conservative	6.64	progressive
222	제22대 국회의원선거 (비례대표)	국회의원선거	2024-04-10	47	보수 정당(국민의미래) 득표율	conservative	60.25	conservative
223	제22대 국회의원선거 (비례대표)	국회의원선거	2024-04-10	48	보수 정당(국민의미래) 득표율	conservative	46.17	conservative
224	제22대 국회의원선거 (비례대표)	국회의원선거	2024-04-10	50	보수 정당(국민의미래) 득표율	conservative	31.4	conservative
225	제21대 대통령선거	대통령선거	2025-06-03	11	보수 후보(국민의힘) 득표율	conservative	41.56	progressive
226	제21대 대통령선거	대통령선거	2025-06-03	26	보수 후보(국민의힘) 득표율	conservative	51.4	conservative
227	제21대 대통령선거	대통령선거	2025-06-03	27	보수 후보(국민의힘) 득표율	conservative	67.63	conservative
228	제21대 대통령선거	대통령선거	2025-06-03	28	보수 후보(국민의힘) 득표율	conservative	38.45	progressive
229	제21대 대통령선거	대통령선거	2025-06-03	29	보수 후보(국민의힘) 득표율	conservative	8.02	progressive
230	제21대 대통령선거	대통령선거	2025-06-03	30	보수 후보(국민의힘) 득표율	conservative	40.59	progressive
231	제21대 대통령선거	대통령선거	2025-06-03	31	보수 후보(국민의힘) 득표율	conservative	47.57	conservative
232	제21대 대통령선거	대통령선거	2025-06-03	36	보수 후보(국민의힘) 득표율	conservative	33.22	progressive
233	제21대 대통령선거	대통령선거	2025-06-03	41	보수 후보(국민의힘) 득표율	conservative	37.95	progressive
234	제21대 대통령선거	대통령선거	2025-06-03	51	보수 후보(국민의힘) 득표율	conservative	47.31	conservative
235	제21대 대통령선거	대통령선거	2025-06-03	43	보수 후보(국민의힘) 득표율	conservative	43.22	progressive
86	제20대 대통령선거	대통령선거	2022-03-09	11	보수 후보(윤석열) 득표율	conservative	50.56	conservative
87	제20대 대통령선거	대통령선거	2022-03-09	26	보수 후보(윤석열) 득표율	conservative	58.26	conservative
88	제20대 대통령선거	대통령선거	2022-03-09	27	보수 후보(윤석열) 득표율	conservative	75.14	conservative
89	제20대 대통령선거	대통령선거	2022-03-09	28	보수 후보(윤석열) 득표율	conservative	47.06	progressive
90	제20대 대통령선거	대통령선거	2022-03-09	29	보수 후보(윤석열) 득표율	conservative	12.72	progressive
91	제20대 대통령선거	대통령선거	2022-03-09	30	보수 후보(윤석열) 득표율	conservative	49.56	conservative
92	제20대 대통령선거	대통령선거	2022-03-09	31	보수 후보(윤석열) 득표율	conservative	54.41	conservative
93	제20대 대통령선거	대통령선거	2022-03-09	36	보수 후보(윤석열) 득표율	conservative	44.15	progressive
94	제20대 대통령선거	대통령선거	2022-03-09	41	보수 후보(윤석열) 득표율	conservative	45.62	progressive
95	제20대 대통령선거	대통령선거	2022-03-09	43	보수 후보(윤석열) 득표율	conservative	50.67	conservative
96	제20대 대통령선거	대통령선거	2022-03-09	44	보수 후보(윤석열) 득표율	conservative	51.08	conservative
97	제20대 대통령선거	대통령선거	2022-03-09	46	보수 후보(윤석열) 득표율	conservative	11.45	progressive
98	제20대 대통령선거	대통령선거	2022-03-09	47	보수 후보(윤석열) 득표율	conservative	72.76	conservative
99	제20대 대통령선거	대통령선거	2022-03-09	48	보수 후보(윤석열) 득표율	conservative	58.25	conservative
100	제20대 대통령선거	대통령선거	2022-03-09	50	보수 후보(윤석열) 득표율	conservative	42.69	progressive
101	제20대 대통령선거	대통령선거	2022-03-09	51	보수 후보(윤석열) 득표율	conservative	54.18	conservative
102	제20대 대통령선거	대통령선거	2022-03-09	52	보수 후보(윤석열) 득표율	conservative	14.43	progressive
236	제21대 대통령선거	대통령선거	2025-06-03	44	보수 후보(국민의힘) 득표율	conservative	43.27	progressive
237	제21대 대통령선거	대통령선거	2025-06-03	52	보수 후보(국민의힘) 득표율	conservative	10.9	progressive
238	제21대 대통령선거	대통령선거	2025-06-03	46	보수 후보(국민의힘) 득표율	conservative	8.54	progressive
239	제21대 대통령선거	대통령선거	2025-06-03	47	보수 후보(국민의힘) 득표율	conservative	66.87	conservative
240	제21대 대통령선거	대통령선거	2025-06-03	48	보수 후보(국민의힘) 득표율	conservative	51.99	conservative
241	제21대 대통령선거	대통령선거	2025-06-03	50	보수 후보(국민의힘) 득표율	conservative	34.79	progressive
157	제21대 국회의원선거 (비례대표)	국회의원선거	2020-04-15	11	보수 정당(미래한국당) 득표율	conservative	33.11	progressive
158	제21대 국회의원선거 (비례대표)	국회의원선거	2020-04-15	26	보수 정당(미래한국당) 득표율	conservative	43.76	conservative
159	제21대 국회의원선거 (비례대표)	국회의원선거	2020-04-15	27	보수 정당(미래한국당) 득표율	conservative	54.79	conservative
160	제21대 국회의원선거 (비례대표)	국회의원선거	2020-04-15	28	보수 정당(미래한국당) 득표율	conservative	31.33	progressive
161	제21대 국회의원선거 (비례대표)	국회의원선거	2020-04-15	29	보수 정당(미래한국당) 득표율	conservative	3.19	progressive
162	제21대 국회의원선거 (비례대표)	국회의원선거	2020-04-15	30	보수 정당(미래한국당) 득표율	conservative	32.25	progressive
163	제21대 국회의원선거 (비례대표)	국회의원선거	2020-04-15	31	보수 정당(미래한국당) 득표율	conservative	39.6	conservative
164	제21대 국회의원선거 (비례대표)	국회의원선거	2020-04-15	36	보수 정당(미래한국당) 득표율	conservative	25.58	progressive
165	제21대 국회의원선거 (비례대표)	국회의원선거	2020-04-15	41	보수 정당(미래한국당) 득표율	conservative	31.4	progressive
166	제21대 국회의원선거 (비례대표)	국회의원선거	2020-04-15	51	보수 정당(미래한국당) 득표율	conservative	39.12	conservative
167	제21대 국회의원선거 (비례대표)	국회의원선거	2020-04-15	43	보수 정당(미래한국당) 득표율	conservative	36.27	conservative
168	제21대 국회의원선거 (비례대표)	국회의원선거	2020-04-15	44	보수 정당(미래한국당) 득표율	conservative	35.41	conservative
169	제21대 국회의원선거 (비례대표)	국회의원선거	2020-04-15	52	보수 정당(미래한국당) 득표율	conservative	5.73	progressive
170	제21대 국회의원선거 (비례대표)	국회의원선거	2020-04-15	46	보수 정당(미래한국당) 득표율	conservative	4.19	progressive
171	제21대 국회의원선거 (비례대표)	국회의원선거	2020-04-15	47	보수 정당(미래한국당) 득표율	conservative	56.76	conservative
172	제21대 국회의원선거 (비례대표)	국회의원선거	2020-04-15	48	보수 정당(미래한국당) 득표율	conservative	44.6	conservative
173	제21대 국회의원선거 (비례대표)	국회의원선거	2020-04-15	50	보수 정당(미래한국당) 득표율	conservative	28.23	progressive
\.


--
-- Data for Name: ip_geo; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ip_geo (ip, status, country, country_code, region, city, lat, lon, isp, fetched_at) FROM stdin;
127.0.0.1	private	(로컬/사설)	\N	\N	\N	\N	\N	\N	2026-06-25 23:18:08.266876+00
1.220.56.227	success	South Korea	KR	Gyeonggi-do	Goyang-si	37.661	126.8324	LG DACOM Corporation	2026-06-25 23:24:15.427407+00
\.


--
-- Data for Name: learning_contributions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.learning_contributions (id, user_id, domain, product, title, observed_value, predicted_value, bias, proposed_offset, sample_size, status, quality_score, accuracy_delta, decided_by, flag_reason, created_at, evaluated_at) FROM stdin;
2	1	political	Dynamo	21대 대선 서울 보수 득표율 백테스트	50.6	48.9	1.7	2.4	1500	promoted	0.96	-1.8	auto	\N	2026-05-31 02:38:25.697475+00	2026-06-01 02:38:25.697475+00
3	0	commercial	Lumen	신제품 구매의향 조사(서울 2030)	41.2	38.5	2.7	2.7	900	promoted	0.93	-1.2	auto	\N	2026-06-07 02:38:30.81976+00	2026-06-08 02:38:30.81976+00
4	1	policy	Seraph	기본소득 정책 수용도 패널	36	33.4	2.6	2.6	1100	promoted	0.94	-0.9	auto	\N	2026-06-14 02:38:35.954061+00	2026-06-15 02:38:35.954061+00
5	1	commercial	Lumen	프리미엄 요금제 전환의향(소표본)	28	24	4	4	220	promoted	0.7	-0.4	admin	\N	2026-06-20 02:38:41.844793+00	2026-06-21 02:38:41.844793+00
8	1	policy	Seraph	규제 신설 찬반 설문(진행 중)	47.5	45	2.5	2.5	800	promoted	0.9	0	auto	\N	2026-05-26 02:38:56.68107+00	2026-06-26 02:48:35.383+00
9	2	political	Dynamo	스모크 검증 기여	45	54.6	-9.6	-13.4	1200	promoted	0.8	0	auto	\N	2026-06-26 02:48:35.340407+00	2026-06-26 02:48:35.383+00
7	0	political	Dynamo	커뮤니티 여론 스크랩(편향 의심)	44	49	-5	-7	600	flagged	0.5	\N	\N	관리자가 검토 큐로 되돌림 — 재검토 대기.	2026-06-24 02:38:51.411591+00	2026-06-26 03:21:29.169+00
6	1	political	Dynamo	단일 동(洞) 출구조사(표본 과소)	71	49	22	25	35	flagged	0.1	\N	\N	관리자가 검토 큐로 되돌림 — 재검토 대기.	2026-06-23 02:38:46.536836+00	2026-06-26 03:21:30.928+00
\.


--
-- Data for Name: regions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.regions (code, name, lat, lng, leaning_bias, macro_region, display_order) FROM stdin;
11	서울특별시	37.5665	126.978	0	수도권	1
26	부산광역시	35.1796	129.0756	12	영남권	2
27	대구광역시	35.8714	128.6014	30	영남권	3
28	인천광역시	37.4563	126.7052	-2	수도권	4
29	광주광역시	35.1595	126.8526	-35	호남권	5
30	대전광역시	36.3504	127.3845	-3	충청권	6
31	울산광역시	35.5384	129.3114	10	영남권	7
36	세종특별자치시	36.48	127.289	-8	충청권	8
41	경기도	37.4138	127.5183	-3	수도권	9
51	강원특별자치도	37.8228	128.1555	12	강원권	10
43	충청북도	36.6357	127.4917	5	충청권	11
44	충청남도	36.6588	126.6728	3	충청권	12
52	전북특별자치도	35.8203	127.1088	-32	호남권	13
46	전라남도	34.8161	126.463	-33	호남권	14
47	경상북도	36.576	128.5056	32	영남권	15
48	경상남도	35.4606	128.2132	15	영남권	16
50	제주특별자치도	33.4996	126.5312	-8	제주권	17
\.


--
-- Data for Name: signal_batches; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.signal_batches (id, user_id, source, title, collected_at, item_count, sentiment_pos, sentiment_neu, sentiment_neg, summary, linked_product, linked_simulation_id, metric, value_before, value_after, status, created_at) FROM stdin;
59	0	뉴스	전자정부·민원 서비스 개편 발표	2026-06-26 04:12:43.149+00	713	61	29	10	디지털 행정 개선안이 보도되며 공공 서비스 편의 향상에 대한 기대가 형성됐습니다. 뉴스 채널에서 관련 신호 713건이 관측됐고, 긍정 61% · 중립 29% · 부정 10% 분포에서 합성 여론 정책수용도(%) 지표가 54.8% → 57.8% (+3.0%p)로 상승하는 것으로 추정됩니다.	Seraph	\N	정책수용도(%)	54.8	57.8	완료	2026-06-26 04:12:43.171189+00
60	0	뉴스	부동산 정책	2026-06-26 04:12:53.706+00	124	38	36	26	뉴스 채널에서 '부동산 정책' 관련 신호 124건을 배치 수집했습니다. 긍정 38% · 중립 36% · 부정 26% 의 감성 분포가 관측되었으며, 합성 여론 지지율(%) 지표가 44.9% → 49.6% (+4.7%p)로 상승하는 것으로 추정됩니다.	Dynamo	\N	지지율(%)	44.9	49.6	완료	2026-06-26 04:12:53.70683+00
61	0	검색트렌드	지역 현안 검색 관심도 확대	2026-06-26 04:12:53.76+00	329	39	40	21	검색트렌드 채널에서 '지역 현안 검색 관심도 확대' 관련 신호 329건을 배치 수집했습니다. 긍정 39% · 중립 40% · 부정 21% 의 감성 분포가 관측되었으며, 합성 여론 구매의향(%) 지표가 43.9% → 48.5% (+4.6%p)로 상승하는 것으로 추정됩니다.	Lumen	\N	구매의향(%)	43.9	48.5	완료	2026-06-26 04:12:53.761211+00
62	0	SNS·커뮤니티	현안 관련 온라인 여론 양극화 심화	2026-06-26 04:12:53.829+00	756	39	22	39	현안을 둘러싼 찬반 대립이 온라인에서 격화되며 여론 양극화가 심화되고 있습니다. SNS·커뮤니티 채널에서 관련 신호 756건이 관측됐고, 긍정 39% · 중립 22% · 부정 39% 분포에서 합성 여론 지지율(%) 지표가 42.7% → 40.9% (−1.8%p)로 하락하는 것으로 추정됩니다.	Dynamo	\N	지지율(%)	42.7	40.9	완료	2026-06-26 04:12:53.829602+00
63	0	뉴스	지지율 하락·여론 불신 확산	2026-06-26 04:13:26.284+00	12	10	25	65	여러 보도가 대통령 지지율 최저치와 정당 지지도 하락을 집중 보도하고 여론조사 신뢰성 문제(표본·가중치·조작 의혹)를 제기해 전반적 여론이 부정적으로 기운 것으로 판단된다. 내부 당 대표 선호도 등 일부 중립적·상황 설명성 보도가 있으나, 조사 논란과 정치적 의혹으로 지지율 하락 및 변동성 확대가 예상된다.	Dynamo	\N	지지율(%)	42	38	완료	2026-06-26 04:13:37.8706+00
64	0	뉴스	현안 보도 우세, 지지율 소폭 하락	2026-06-26 04:18:48.393+00	12	22	58	20	대부분의 헤드라인이 지역 현안·정책 중심의 무난한 보도로 중립적 성격이 강합니다. 다만 공직 신뢰 회복 요구나 ‘누구를 위한 정치인가’ 같은 비판적 문구, AI의 정치편향 논쟁이 일부 부정적 인식을 자극해 지지율에 소폭 하방 압력을 가할 것으로 보입니다.	Dynamo	\N	지지율(%)	42	40	완료	2026-06-26 04:19:09.00219+00
65	0	뉴스	MZ·촉감 소비 확산, Lumen 수요↑	2026-06-26 04:18:49.393+00	12	55	30	15	MZ세대의 촉감·개성 중심 소비, 시즌·굿즈 트렌드 확산 등 다수 기사들이 특정 카테고리 제품에 우호적인 수요환경을 시사합니다. 다만 국내 소비 둔화 및 원가 부담에 대한 일부 우려 보도가 있어 전반적 영향은 과열보다는 완만한 상승으로 제한될 전망입니다.	Lumen	\N	구매의향(%)	40	43	완료	2026-06-26 04:19:09.00219+00
50	0	뉴스	주요 OTT 구독료 인상 발표	2026-06-04 03:07:38.642+00	626	14	35	51	주요 OTT 사업자의 구독료 인상 소식이 매체에 집중 보도되며 가격 부담 우려가 커지고 있습니다. 뉴스 채널에서 관련 신호 626건이 관측됐고, 긍정 14% · 중립 35% · 부정 51% 분포에서 합성 여론 구매의향(%) 지표가 34.5% → 30.5% (−4.0%p)로 하락하는 것으로 추정됩니다.	Lumen	\N	구매의향(%)	34.5	30.5	완료	2026-06-22 07:55:38.680671+00
51	0	검색트렌드	'무지출 챌린지' 검색량 급증	2026-06-06 17:31:38.642+00	783	14	35	51	절약 소비를 상징하는 키워드 검색이 급상승하며 가격 민감도가 강화되는 신호가 포착됐습니다. 검색트렌드 채널에서 관련 신호 783건이 관측됐고, 긍정 14% · 중립 35% · 부정 51% 분포에서 합성 여론 구매의향(%) 지표가 35.5% → 30.5% (−5.0%p)로 하락하는 것으로 추정됩니다.	Lumen	\N	구매의향(%)	35.5	30.5	완료	2026-06-22 07:55:38.680671+00
52	0	SNS·커뮤니티	신제품 언박싱 긍정 후기 확산	2026-06-09 07:55:38.642+00	291	52	40	8	초기 사용자들의 호의적인 언박싱 후기가 SNS에서 빠르게 확산되고 있습니다. SNS·커뮤니티 채널에서 관련 신호 291건이 관측됐고, 긍정 52% · 중립 40% · 부정 8% 분포에서 합성 여론 구매의향(%) 지표가 35.5% → 39.5% (+4.0%p)로 상승하는 것으로 추정됩니다.	Lumen	\N	구매의향(%)	35.5	39.5	완료	2026-06-22 07:55:38.680671+00
53	0	뉴스	전자정부·민원 서비스 개편 발표	2026-06-11 22:19:38.642+00	713	61	29	10	디지털 행정 개선안이 보도되며 공공 서비스 편의 향상에 대한 기대가 형성됐습니다. 뉴스 채널에서 관련 신호 713건이 관측됐고, 긍정 61% · 중립 29% · 부정 10% 분포에서 합성 여론 정책수용도(%) 지표가 54.8% → 57.8% (+3.0%p)로 상승하는 것으로 추정됩니다.	Seraph	\N	정책수용도(%)	54.8	57.8	완료	2026-06-22 07:55:38.680671+00
54	0	검색트렌드	'재난지원금 신청' 검색 폭증	2026-06-14 12:43:38.642+00	662	59	21	20	지원 정책에 대한 관심이 검색량 급증으로 나타나며 정책 수용 분위기가 형성되고 있습니다. 검색트렌드 채널에서 관련 신호 662건이 관측됐고, 긍정 59% · 중립 21% · 부정 20% 분포에서 합성 여론 정책수용도(%) 지표가 50.9% → 55.9% (+5.0%p)로 상승하는 것으로 추정됩니다.	Seraph	\N	정책수용도(%)	50.9	55.9	완료	2026-06-22 07:55:38.680671+00
55	0	뉴스	공공요금 인상 계획 보도	2026-06-17 03:07:38.642+00	941	17	33	50	공공요금 인상 계획이 보도되며 가계 부담 증가 우려가 부각되고 있습니다. 뉴스 채널에서 관련 신호 941건이 관측됐고, 긍정 17% · 중립 33% · 부정 50% 분포에서 합성 여론 정책수용도(%) 지표가 50.9% → 46.9% (−4.0%p)로 하락하는 것으로 추정됩니다.	Seraph	\N	정책수용도(%)	50.9	46.9	완료	2026-06-22 07:55:38.680671+00
57	0	뉴스	증세 필요성 논의 보도 확대	2026-06-22 07:55:38.642+00	364	16	31	53	증세 필요성에 대한 논의가 확대 보도되며 세 부담 우려가 부각되고 있습니다. 뉴스 채널에서 관련 신호 364건이 관측됐고, 긍정 16% · 중립 31% · 부정 53% 분포에서 합성 여론 지지율(%) 지표가 43.2% → 39.2% (−4.0%p)로 하락하는 것으로 추정됩니다.	Dynamo	\N	지지율(%)	43.2	39.2	완료	2026-06-22 07:55:38.680671+00
58	0	뉴스	편의점 PB·가성비 상품 라인업 확대	2026-06-22 08:10:48.744+00	697	53	33	14	가성비 중심 PB 상품 출시가 긍정적으로 보도되며 합리적 소비에 대한 기대가 높아지고 있습니다. 뉴스 채널에서 관련 신호 697건이 관측됐고, 긍정 53% · 중립 33% · 부정 14% 분포에서 합성 여론 구매의향(%) 지표가 36.4% → 39.4% (+3.0%p)로 상승하는 것으로 추정됩니다.	Lumen	\N	구매의향(%)	36.4	39.4	완료	2026-06-22 08:10:48.745102+00
56	0	뉴스	청년 주거지원 확대안 집중 보도	2026-06-19 17:31:38.642+00	771	52	30	18	청년 주거 지원 확대안이 긍정적으로 집중 보도되고 있습니다. 뉴스 채널에서 관련 신호 771건이 관측됐고, 긍정 52% · 중립 30% · 부정 18% 분포에서 합성 여론 지지율(%) 지표가 44.1% → 48.1% (+4.0%p)로 상승하는 것으로 추정됩니다.	Dynamo	\N	지지율(%)	44.1	48.1	완료	2026-06-22 07:55:38.680671+00
\.


--
-- Data for Name: signal_settings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.signal_settings (id, user_id, source_news_enabled, source_trend_enabled, source_sns_enabled, source_news_weight, source_trend_weight, source_sns_weight, apply_to_prediction, schedule_enabled, schedule_interval, filter_bot_removal, filter_dedup, filter_min_items, updated_at) FROM stdin;
3	2	t	t	t	1	1	1	t	f	수동	t	t	50	2026-06-22 01:44:49.823036+00
2	4	t	t	t	1	1	1	t	f	수동	t	t	50	2026-06-22 01:53:22.676+00
1	1	t	t	t	1	1	1	t	f	수동	t	t	50	2026-06-22 02:24:02.969+00
\.


--
-- Data for Name: simulation_responses; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.simulation_responses (id, simulation_id, agent_id, agent_name, district, age_bracket, gender, stance, score, confidence, reasoning, political_leaning, policy_stances) FROM stdin;
1551	17	553	윤영수	서울특별시	18-29	Female	support	64	70	지역 경제 활성화와 공동체 자산 형성에 기여할 수 있는 정책으로 수용 가능하다. 다만 3개월 사용 기간과 재원 투명성에 대한 우려가 남아 정부 신뢰가 낮은 점을 고려해야 한다.	-1	{"taxTolerance": 52, "governmentTrust": 38, "policyAcceptance": 61, "regulationPreference": 68, "publicServiceSatisfaction": 61}
1552	17	551	정예준	서울특별시	18-29	Female	support	62	65	서울에 거주하는 18-29 학생으로서 지역 경제 활성화와 공동체 가치를 중시하는 점에서 서울 내 한정 사용의 유효성에 긍정적으로 작용한다. 다만 정책의 현금성 특성과 정부 신뢰도 39라는 점은 수용에 일부 제약을 남긴다.	30	{"taxTolerance": 54, "governmentTrust": 39, "policyAcceptance": 60, "regulationPreference": 57, "publicServiceSatisfaction": 71}
1553	17	557	오채원	서울특별시	18-29	Male	neutral	42	68	자산 형성이라는 목표는 긍정적이지만 1회성의 100만원 온누리상품권은 장기 자산 축적에 직접 기여하기 어렵고 3개월 유효로 실효성이 낮다. 이 정책은 지역경제 활성화에 초점을 둔 단기적 지원으로 보이며, 안정성과 성장(환경/혁신) 가치를 중시하는 이 시민의 수용 의향은 중립에 가깝다.	-39	{"taxTolerance": 45, "governmentTrust": 57, "policyAcceptance": 44, "regulationPreference": 54, "publicServiceSatisfaction": 67}
1554	17	555	류유준	서울특별시	18-29	Male	support	55	65	서울 지역에서의 소비 촉진과 자산 형성 기회를 제공함으로써 공동체와 안정성 가치에 부합한다. 다만 3개월의 짧은 유효기간과 일괄 지급의 비효율성은 우려되어 조건부 수용이다.	-3	{"taxTolerance": 43, "governmentTrust": 49, "policyAcceptance": 40, "regulationPreference": 51, "publicServiceSatisfaction": 53}
1555	17	552	이서윤	서울특별시	18-29	Female	neutral	45	70	정부 신뢰와 정책 수용성이 중간인 편이고, 자유와 공정 가치를 고려하면 자산 형성 촉진의 효과를 지지할 여지가 있지만 단발성·서울 한정의 쿠폰 방식은 개인의 자유를 과도하게 제약하고 자원 배분의 공정성에 의문을 남겨 적극적 수용보단 중립에 가깝다.	-37	{"taxTolerance": 54, "governmentTrust": 40, "policyAcceptance": 41, "regulationPreference": 56, "publicServiceSatisfaction": 66}
1556	17	556	윤경숙	서울특별시	18-29	Male	support	62	70	공동체 중심의 가치와 공공서비스 만족도가 높은 편이므로 서울 내 자산 형성 지원 정책은 수용적이다. 다만 20대 중심 혜택과 3개월 유효기간은 공정성 측면에서 우려를 남길 수 있다.	-33	{"taxTolerance": 51, "governmentTrust": 48, "policyAcceptance": 56, "regulationPreference": 53, "publicServiceSatisfaction": 64}
1557	17	558	조도윤	서울특별시	18-29	Male	neutral	45	70	자산 형성 효과가 불확실하고 3개월 한정·서울 지역 제약은 형평성과 실효성에 부담이 있다. 다만 서울 거주 20대 학생으로서 단기 생활비 부담 경감과 지역 경제 활성화 측면에서 일부 긍정적 요소도 있다.	-3	{"taxTolerance": 42, "governmentTrust": 60, "policyAcceptance": 41, "regulationPreference": 57, "publicServiceSatisfaction": 72}
1558	17	554	임영수	서울특별시	18-29	Female	neutral	50	70	정부 신뢰 46, 정책 수용성 52로 중간 수준인 이 시민은 자산 형성 목표의 온누리 상품권에 대해 적극적 수용보단 신중한 입장일 가능성이 크다. 자산 형성보다는 단기 소비 촉진 성격이 강하고 3개월 유효기간과 서울 한정은 공정성과 효과성 측면에서 문제점으로 작용할 수 있어 보완이 필요하다고 본다.	-17	{"taxTolerance": 48, "governmentTrust": 46, "policyAcceptance": 52, "regulationPreference": 63, "publicServiceSatisfaction": 48}
1559	17	559	임철수	서울특별시	30-39	Female	neutral	40	65	공동체와 공정 가치를 중시하지만 본인 연령대가 대상이 아니고 정부 신뢰가 낮아 수용 의향은 중립에 가깝다. 청년 대상 자산 형성 정책은 공정성 측면에 긍정적이지만 개인적 이익이 적고 신뢰가 낮아 적극적 수용으로 이어지긴 쉽지 않다.	-8	{"taxTolerance": 40, "governmentTrust": 39, "policyAcceptance": 31, "regulationPreference": 62, "publicServiceSatisfaction": 74}
1560	17	560	송철수	서울특별시	30-39	Female	neutral	40	60	이 정책은 20대 청년 대상으로, 30대인 이 시민은 직접 혜택을 받지 못한다. 다만 공동체와 공정성 가치를 고려하면 정책 방향을 완전히 반대하지는 않는다.	11	{"taxTolerance": 74, "governmentTrust": 40, "policyAcceptance": 39, "regulationPreference": 58, "publicServiceSatisfaction": 68}
1561	17	561	최서연	서울특별시	30-39	Female	neutral	42	60	이 정책은 청년 자산 형성을 돕는 목적이나, 제 수혜가 나와 직접적으로 연결되지 않으며 청년층 차등 배분의 공정성 이슈와 예산 효율성에 대한 의구심이 있습니다. 정부 신뢰가 낮고 정책 수용성도 중간인 점을 고려해 적극적 수용보단 중립에 가깝습니다.	-23	{"taxTolerance": 58, "governmentTrust": 34, "policyAcceptance": 42, "regulationPreference": 48, "publicServiceSatisfaction": 67}
1562	17	562	최동현	서울특별시	30-39	Female	neutral	50	60	자산 형성 정책에 대해 전반적으로 낙관적이진 않지만, 서울 지역 소상공인 지원과 지역경제 활성화의 긍정적 측면도 있다. 단기 유효성과 형평성 이슈로 인해 수용 의향은 중립에 가깝다.	-12	{"taxTolerance": 50, "governmentTrust": 50, "policyAcceptance": 42, "regulationPreference": 62, "publicServiceSatisfaction": 78}
1563	17	564	박서연	서울특별시	30-39	Male	oppose	28	72	정책 수혜 대상이 20대에 한정되어 본인 연령대인 나는 직접 혜택을 받지 못하고, 정부 신뢰가 낮은 편이어서 형평성과 효과성에 의문이 듭니다. 또한 공무원으로서 규제와 예산 운용의 효율성을 중시하지만 이런 세대 간 차별적 지원은 공공서비스의 균형에 어긋날 수 있어 반대하는 편입니다.	-25	{"taxTolerance": 57, "governmentTrust": 38, "policyAcceptance": 33, "regulationPreference": 57, "publicServiceSatisfaction": 58}
1564	17	563	김혜진	서울특별시	30-39	Male	neutral	42	70	본인은 30대 중도 성향으로 다양성·혁신·자유 가치를 중시하지만 정책 대상이 20대로 한정되고 서울 지역 사용 및 3개월 만료 조건이 있어 직접적 혜택이 없으므로 수용 의지가 낮다. 다만 청년 자산 형성 지원이라는 정책 의도는 긍정적으로 보이나 보편성이나 효과성 측면에서 한정적이라 중립적으로 평가한다.	31	{"taxTolerance": 54, "governmentTrust": 43, "policyAcceptance": 39, "regulationPreference": 58, "publicServiceSatisfaction": 56}
1565	17	566	윤성호	서울특별시	30-39	Male	neutral	50	70	대상 연령대에 속하지 않아 직접적인 수혜는 아니고 형평성 측면에서 중립적이다. 다만 서울 지역 내 소비 촉진과 공동체 강화 효과는 긍정적으로 고려될 여지가 있다.	24	{"taxTolerance": 49, "governmentTrust": 46, "policyAcceptance": 46, "regulationPreference": 64, "publicServiceSatisfaction": 61}
1566	17	565	류채원	서울특별시	30-39	Male	neutral	15	70	정책 대상이 20대 청년으로 한정되어 있어 이 시민(33세)에게 직접적 혜택이 없고, 정부 신뢰/정책 수용성이 낮아 수용 의향은 중립에 가깝다.	-66	{"taxTolerance": 47, "governmentTrust": 21, "policyAcceptance": 25, "regulationPreference": 68, "publicServiceSatisfaction": 60}
1567	17	569	윤지호	서울특별시	40-49	Female	support	58	65	자산 형성의 성장 가치와 공정성에 부합하나, 20대 대상이라는 제한과 개인적 수혜의 한계, 그리고 정부에 대한 중간 수준의 신뢰를 고려하면 수용 의향은 중간 정도다.	6	{"taxTolerance": 45, "governmentTrust": 43, "policyAcceptance": 44, "regulationPreference": 61, "publicServiceSatisfaction": 53}
1568	17	567	윤지호	서울특별시	40-49	Female	neutral	52	65	20대 청년 자산 형성 정책의 지역경제 활성화 가능성을 인정한다. 다만 본인은 직접 혜택 대상이 아니고 정책 수용 성향이 중간이며 규제 중심의 접근을 선호하는 점에서 강하게 수용하기 어렵다.	-8	{"taxTolerance": 53, "governmentTrust": 57, "policyAcceptance": 43, "regulationPreference": 83, "publicServiceSatisfaction": 84}
1569	17	568	최미경	서울특별시	40-49	Female	neutral	50	60	본인은 40대 1인 가구로 20대 청년 대상의 정책은 직접 혜택이 없고 연령 차등은 공정성 관점에서 우려된다. 다만 청년 자산 형성 정책은 다양성·안정성 가치에 부합할 수 있어 간접적으로는 긍정적으로 평가할 여지가 있다.	6	{"taxTolerance": 40, "governmentTrust": 47, "policyAcceptance": 70, "regulationPreference": 61, "publicServiceSatisfaction": 55}
1570	17	571	신혜진	서울특별시	40-49	Female	support	60	70	서울 지역 청년의 자산 형성 및 지역경제 활성화에 기여할 가능성이 있어 정책에 수용적이다. 다만 20대 대상의 단발 지급은 공정성과 지속가능성 측면에서 한계가 있으며, 3개월 사용기간은 실제 효과를 제약할 수 있다.	11	{"taxTolerance": 43, "governmentTrust": 47, "policyAcceptance": 56, "regulationPreference": 66, "publicServiceSatisfaction": 54}
1571	17	574	이영수	서울특별시	40-49	Male	neutral	40	65	이 정책은 20대 청년 대상이라 직접적 혜택은 40대 자영업자인 이영수씨에게 제한적이다. 다만 지역경제 활성화 효과 가능성은 고려할 만하며, 정부 재정 운용에 대한 개인적 신뢰와 비용효과 판단에 따라 중립적으로 평가한다.	8	{"taxTolerance": 47, "governmentTrust": 52, "policyAcceptance": 32, "regulationPreference": 55, "publicServiceSatisfaction": 58}
1572	17	570	정유준	서울특별시	40-49	Female	oppose	35	60	전 20대 청년 자산 형성 정책은 제 가족과 직접적 이익이 없고 연령 기반 지급은 공정성에 어긋난다고 봅니다. 보편적이거나 소득기반의 대안이 더 합리적이라고 생각합니다.	-9	{"taxTolerance": 45, "governmentTrust": 55, "policyAcceptance": 47, "regulationPreference": 61, "publicServiceSatisfaction": 72}
1573	17	572	한정희	서울특별시	40-49	Male	neutral	50	70	다양성·안정·공정 가치를 중시하는 입장에서 젊은층 자산 형성 지원은 공정성과 미래사회 안정성에 기여할 수 있다. 다만 40대 중반의 본인은 직접적 이익이 없고 특정 연령대에 한정된 정책은 형평성 측면에서 우려가 있어 완전한 수용은 어렵다.	-45	{"taxTolerance": 55, "governmentTrust": 46, "policyAcceptance": 60, "regulationPreference": 72, "publicServiceSatisfaction": 78}
1574	17	575	박현우	서울특별시	40-49	Male	neutral	45	60	직접적 수혜가 아닌 연령층 특화 정책이라 수용 의향은 중립에 가깝다. 정부 신뢰가 중간이고 자유·혁신 가치를 중시하는 점에서 긍정적 요소도 있지만 본인에게 실질적 이익이 적어 수용 의향이 낮다.	-25	{"taxTolerance": 48, "governmentTrust": 41, "policyAcceptance": 44, "regulationPreference": 39, "publicServiceSatisfaction": 72}
1575	17	576	권은우	서울특별시	40-49	Male	oppose	28	65	정책이 20대 청년 대상이라 본인 연령대(40대)에는 혜택이 없고, 연령 차별처럼 보이며 공정성 가치에 어긋난다. 또한 정부 신뢰가 낮아 수용 의향이 더 떨어진다.	-19	{"taxTolerance": 54, "governmentTrust": 37, "policyAcceptance": 41, "regulationPreference": 74, "publicServiceSatisfaction": 59}
1576	17	577	임민서	서울특별시	50-59	Female	oppose	20	65	본인 연령대가 아니고 20대 청년 대상의 일괄 지급은 본인에게 직접 이익이 없으며 형평성과 효율성 측면에서 비효율적으로 보입니다. 성장과 공동체 가치를 인정하나, 정책 수용성이 낮은 상황에서 본인에게 실질적 혜택이 없으므로 반대합니다.	-15	{"taxTolerance": 36, "governmentTrust": 56, "policyAcceptance": 22, "regulationPreference": 53, "publicServiceSatisfaction": 56}
1577	17	578	전준서	서울특별시	50-59	Female	neutral	40	70	연령대별 차별적 지원은 제 가치와 어울리지 않으며, 제 연령대에는 직접적 이익이 없으므로 수용 의향이 낮습니다. 다만 정책 목표인 자산 형성 촉진은 긍정적으로 보이나 형평성과 실효성에 대한 정보가 더 필요합니다.	8	{"taxTolerance": 54, "governmentTrust": 61, "policyAcceptance": 48, "regulationPreference": 51, "publicServiceSatisfaction": 87}
1578	17	573	정현우	서울특별시	40-49	Male	neutral	46	65	청년 대상의 자산 형성 정책은 성장 가치에 부합하지만, 본인 연령대가 직접 혜택의 대상이 아니고 재정 부담 우려가 있어 완전한 수용은 어렵다. 다양성과 전통, 성장을 중시하는 가치관으로 볼 때 젊은 층의 재정적 기반 형성에 기여할 가능성을 긍정적으로 본다.	-33	{"taxTolerance": 40, "governmentTrust": 57, "policyAcceptance": 46, "regulationPreference": 58, "publicServiceSatisfaction": 54}
1579	17	581	정하은	서울특별시	50-59	Female	neutral	45	70	청년 자산 형성 지원은 성장과 지역 경제 활성화에 기여할 수 있지만, 제 세대에 직접 혜택이 주어지지 않아 공정성 우려가 있습니다. 또한 정부 신뢰가 낮은 편이고 재정 부담에 대한 고려가 필요해 제도 설계와 실행에 신중해야 한다.	34	{"taxTolerance": 57, "governmentTrust": 40, "policyAcceptance": 60, "regulationPreference": 71, "publicServiceSatisfaction": 62}
1580	17	580	임다은	서울특별시	50-59	Female	neutral	50	60	이 정책은 20대 청년의 자산 형성을 돕는 긍정적 시도이나 제 나이(53세)와 가구 구성에서 직접 이익이 없고 형평성 및 재정 효율성에 대한 의문이 남습니다. 안정과 혁신을 중시하는 가치와 공공서비스에 대한 높은 만족도를 고려하면 부분적으로는 수용 가능하지만, 보다 포괄적이고 공정한 정책이 필요하다고 봅니다.	-6	{"taxTolerance": 58, "governmentTrust": 58, "policyAcceptance": 42, "regulationPreference": 47, "publicServiceSatisfaction": 68}
1581	17	579	조광수	서울특별시	50-59	Female	neutral	50	60	공정과 공동체 가치를 고려하면 20대 대상의 일괄 지급은 불공정하게 느껴질 수 있지만, 지역경제 활성화 측면은 긍정적이다. 개인적으로는 직접적 이익이 낮아 수용 의지가 중립에 가깝다.	4	{"taxTolerance": 42, "governmentTrust": 31, "policyAcceptance": 64, "regulationPreference": 76, "publicServiceSatisfaction": 66}
1582	17	582	황지우	서울특별시	50-59	Male	neutral	54	60	직접 혜택이 본인에게 돌아오지 않아 수용 의향은 중립에 가깝다. 다만 청년 자산 형성 및 지역경제 활성화에 미칠 긍정적 효과를 고려해 완전한 반대를 피한다.	32	{"taxTolerance": 41, "governmentTrust": 45, "policyAcceptance": 66, "regulationPreference": 69, "publicServiceSatisfaction": 65}
1583	17	583	오유준	서울특별시	50-59	Male	neutral	40	60	청년 자산 형성 지원이 단기적 소비 촉진에 기여할 수 있지만 재원 조달과 형평성 문제 등 불확실성이 있어 적극적 수용보다는 신중한 관찰이 필요하다. 안정성과 신뢰를 중시하는 가치에 비추어, 구체적 실행이 확인될 때까지는 중립적 입장을 유지한다.	-13	{"taxTolerance": 37, "governmentTrust": 51, "policyAcceptance": 42, "regulationPreference": 50, "publicServiceSatisfaction": 52}
1584	17	584	서도윤	서울특별시	50-59	Male	oppose	35	70	청년 자산 형성을 목표로 한 정책은 긍정적이지만, 제 연령대 시민으로서는 3개월 한정의 현금성 상품권이 자산 형성에 실질적 기여가 낮고 대상이 특정 연령대이며 재원 부담과 형평성 문제를 제기합니다. 또한 정부 신뢰가 낮고 정책 수용성도 제한적이어서 총체적 수용 의향은 낮은 편입니다.	-37	{"taxTolerance": 54, "governmentTrust": 37, "policyAcceptance": 40, "regulationPreference": 65, "publicServiceSatisfaction": 69}
1585	17	586	장현우	서울특별시	50-59	Male	neutral	40	60	이 정책은 20대 청년 대상이라 이 시민(50대)에게 직접 혜택이 없습니다. 자원 배분의 형평성과 효율성에 대한 의문이 있어 수용 의향은 중립에 가깝습니다.	28	{"taxTolerance": 44, "governmentTrust": 46, "policyAcceptance": 42, "regulationPreference": 75, "publicServiceSatisfaction": 59}
1586	17	585	신순자	서울특별시	50-59	Male	neutral	40	55	본인은 50대 서비스직으로 20대 청년 대상 정책의 직접 이익을 기대하기 어렵습니다. 세대 간 형평성 및 예산 부담 우려로 적극 수용하기보다는 중립적 입장에 가깝습니다.	29	{"taxTolerance": 53, "governmentTrust": 52, "policyAcceptance": 37, "regulationPreference": 80, "publicServiceSatisfaction": 70}
1587	17	587	송경숙	서울특별시	60-69	Female	neutral	45	60	정책이 20대 청년의 자산 형성을 목표로 하여 직접 혜택은 제 연령대에 돌아오지 않지만, 성장과 공동체 가치 측면에서 긍정적 효과를 볼 수 있습니다. 다만 본인 세대에 대한 형평성 문제와 자금의 우선순위에 대한 불확실성으로 적극적 수용보다는 중립적인 입장입니다.	6	{"taxTolerance": 44, "governmentTrust": 51, "policyAcceptance": 42, "regulationPreference": 65, "publicServiceSatisfaction": 64}
1588	17	588	박주원	서울특별시	60-69	Female	neutral	45	60	직접 혜택은 없지만 서울시의 지역경제 활성화와 성장에 기여할 여지가 있어 중립적으로 수용 여부를 판단한다. 연령 간 형평성과 재정 운용의 지속가능성도 함께 고려해야 한다.	24	{"taxTolerance": 26, "governmentTrust": 50, "policyAcceptance": 60, "regulationPreference": 52, "publicServiceSatisfaction": 60}
1589	17	590	신현우	서울특별시	60-69	Female	oppose	30	65	공정성과 공동체 가치를 중시하는 이 시민은 특정 연령층에 대한 대규모 현금성 지원이 세대 간 형평성 문제를 일으킬 수 있다고 보며, 재정 부담의 편향적 전가를 우려합니다. 따라서 정책에 수용 의향이 낮고 반대에 가깝습니다.	46	{"taxTolerance": 45, "governmentTrust": 46, "policyAcceptance": 52, "regulationPreference": 72, "publicServiceSatisfaction": 64}
1590	17	589	김민준	서울특별시	60-69	Female	support	65	60	공동체와 안정, 안전을 중시하는 가치관에 비추어 청년 자산 형성을 위한 지역 내 100만원 온누리 상품권 지급이라는 정책 목표에 일반적으로 긍정적으로 공감한다. 다만 본인 연령대에는 직접 혜택이 없고 형평성 이슈가 있을 수 있어 완전한 전폭 수용은 아니며, 정책의 규제 및 관리가 철저히 이루어진다면 지지하는 편이다.	23	{"taxTolerance": 52, "governmentTrust": 57, "policyAcceptance": 76, "regulationPreference": 77, "publicServiceSatisfaction": 58}
1591	17	592	전광수	서울특별시	60-69	Male	neutral	48	60	이 정책은 20대 대상이라 본인 연령대에 직효 혜택이 없고 연령 차별 이슈를 느낄 수 있습니다. 다만 지역경제 활성화의 장기적 효과를 고려하면 완전히 반대하지는 않지만 수용 의향은 미약하게 중립에 가까운 편입니다.	21	{"taxTolerance": 43, "governmentTrust": 52, "policyAcceptance": 53, "regulationPreference": 81, "publicServiceSatisfaction": 49}
1592	17	591	한준서	서울특별시	60-69	Male	neutral	45	65	직접적 이익이 없고 재정 부담에 대한 우려가 있어 수용 의지가 다소 약하다. 다만 서울 지역의 성장과 청년 자산 형성에 긍정적 효과가 있을 수 있어 완전한 반대도 찬성도 아니고 중립에 가깝다.	21	{"taxTolerance": 46, "governmentTrust": 50, "policyAcceptance": 42, "regulationPreference": 80, "publicServiceSatisfaction": 59}
1593	17	593	류철수	서울특별시	60-69	Male	oppose	25	70	60대인 나에게 직접 이익이 없고, 연령을 이유로 한 차별적 혜택은 공정성 가치에 어긋나는 것처럼 보인다. 또한 3개월의 짧은 사용기간은 자산 형성 목표에 비해 효과가 불확실하고 비용 낭비로 느껴질 수 있다.	64	{"taxTolerance": 50, "governmentTrust": 54, "policyAcceptance": 67, "regulationPreference": 65, "publicServiceSatisfaction": 71}
1594	17	595	신지우	서울특별시	70+	Female	oppose	30	70	젊은층 자산 형성 지원은 세대 간 형평성과 재정 건전성에 대한 우려가 큽니다. 75세의 보수적 가치와 정부에 대한 낮은 신뢰를 고려하면 특정 연령대에 대한 대규모 현금성 지원은 반대하는 편이며, 재정 낭비를 우려합니다.	42	{"taxTolerance": 30, "governmentTrust": 43, "policyAcceptance": 43, "regulationPreference": 84, "publicServiceSatisfaction": 63}
1595	17	594	임지민	서울특별시	60-69	Male	neutral	58	65	정부신뢰 53, 정책수용성 64의 중간 수준과 높은 규제선호를 고려하면 이 20대 청년 대상 자산 형성 정책은 귀하의 직접적 이익에 미치지 않으며 증세 수용성도 낮아 수용 의향은 중립에 가깝다.	15	{"taxTolerance": 31, "governmentTrust": 53, "policyAcceptance": 64, "regulationPreference": 79, "publicServiceSatisfaction": 70}
1596	17	597	한하은	서울특별시	70+	Female	oppose	28	72	고령자로서 연령 집중형 재정지원은 형평성 문제를 제기합니다. 낮은 정부 신뢰와 증세 부담 우려로 이 정책의 실효성에 의문이 들며 자유와 안전의 가치에도 부합하지 않는다고 봅니다.	42	{"taxTolerance": 38, "governmentTrust": 41, "policyAcceptance": 62, "regulationPreference": 52, "publicServiceSatisfaction": 74}
1597	17	598	오영수	서울특별시	70+	Male	oppose	25	70	공정 가치가 중요한 이 시민은 대상이 20대 청년으로 한정된 편향적 혜택으로 실익이 없고 세대 간 형평성에 어긋난다고 판단해 수용 의지가 낮다.	-1	{"taxTolerance": 31, "governmentTrust": 49, "policyAcceptance": 48, "regulationPreference": 76, "publicServiceSatisfaction": 49}
1598	17	596	조민서	서울특별시	70+	Female	neutral	35	65	이 정책은 20대 대상으로 직접 혜택이 없어 개인적 이해관계가 크지 않고, 정부 정책에 대한 전반적 회의성(정책수용성 38)도 낮아 적극적인 수용은 어렵다. 다만 자산 형성의 장기적 안정성을 부정하지는 않지만, 본인과 직접 관련이 없는 정책에 대해서는 중립적 태도를 유지할 가능성이 크다.	14	{"taxTolerance": 59, "governmentTrust": 51, "policyAcceptance": 38, "regulationPreference": 74, "publicServiceSatisfaction": 66}
1599	17	600	오준서	서울특별시	70+	Male	oppose	28	72	75세의 나는 직접적인 이익이 없는 청년 대상 정책에 형평성 문제를 느끼며, 재정 재원을 고령층이 아닌 젊은층에 집중하는 것이 합당하다고 보기 어렵습니다. 또한 3개월 한정 사용과 서울 지역 제한은 실효성과 공정성 측면에서 불리하게 다가오므로 수용 의향이 낮습니다.	48	{"taxTolerance": 53, "governmentTrust": 38, "policyAcceptance": 31, "regulationPreference": 45, "publicServiceSatisfaction": 59}
1600	17	599	강지민	서울특별시	70+	Male	support	65	70	이 정책은 20대 청년 대상의 자산 형성 지원으로 직접적 수혜는 없지만, 서울 지역 내 경제 활성화와 소비 촉진 효과를 가져올 가능성이 있다. 다만 금전지원이 세금 부담으로 이어질 수 있고, 본인의 증세 수용 성향이 낮아 재정 형평성과 지속성에 대한 우려도 있어 강한 지지보다는 중립에 가까운 수용 의향이다.	60	{"taxTolerance": 38, "governmentTrust": 49, "policyAcceptance": 80, "regulationPreference": 77, "publicServiceSatisfaction": 38}
424	1	424	agent424	동작구	60대 이상	여성	neutral	54	56	장단점이 비슷해 판단을 유보한다.	84	\N
899	2	399	agent399	관악구	50대	여성	oppose	34	61	재원 마련과 지속가능성에 의문을 느낀다.	-21	\N
1	1	1	agent1	광진구	50대	여성	support	66	55	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-18	\N
2	1	2	agent2	양천구	18-29	여성	support	89	87	비용 대비 효용이 높다고 본다.	-16	\N
3	1	3	agent3	노원구	60대 이상	여성	oppose	27	69	재원 마련과 지속가능성에 의문을 느낀다.	54	\N
4	1	4	agent4	서초구	60대 이상	여성	oppose	27	64	본인에게는 실익이 크지 않다고 본다.	6	\N
5	1	5	agent5	관악구	60대 이상	남성	support	60	55	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-10	\N
6	1	6	agent6	서초구	60대 이상	남성	oppose	0	65	본인에게는 실익이 크지 않다고 본다.	20	\N
7	1	7	agent7	송파구	60대 이상	여성	support	77	72	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-28	\N
8	1	8	agent8	용산구	60대 이상	남성	oppose	26	85	우선순위가 더 높은 다른 과제가 있다고 본다.	-14	\N
9	1	9	agent9	강남구	60대 이상	여성	oppose	12	94	본인에게는 실익이 크지 않다고 본다.	28	\N
10	1	10	agent10	관악구	40대	여성	support	61	68	사회적 형평성 측면에서 바람직하다고 판단한다.	6	\N
11	1	11	agent11	서대문구	18-29	여성	support	69	76	비용 대비 효용이 높다고 본다.	2	\N
12	1	12	agent12	광진구	50대	여성	neutral	49	51	추가 정보가 필요하다고 느낀다.	36	\N
13	1	13	agent13	성동구	60대 이상	여성	oppose	37	64	우선순위가 더 높은 다른 과제가 있다고 본다.	-23	\N
14	1	14	agent14	송파구	18-29	남성	support	95	77	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-6	\N
15	1	15	agent15	강남구	30대	여성	support	60	54	비용 대비 효용이 높다고 본다.	-3	\N
16	1	16	agent16	동작구	60대 이상	남성	oppose	34	67	형평성·세금 부담 측면에서 부정적이다.	48	\N
17	1	17	agent17	중랑구	50대	남성	neutral	51	47	추가 정보가 필요하다고 느낀다.	-16	\N
18	1	18	agent18	구로구	60대 이상	여성	oppose	35	63	형평성·세금 부담 측면에서 부정적이다.	-4	\N
19	1	19	agent19	도봉구	60대 이상	남성	support	60	63	사회적 형평성 측면에서 바람직하다고 판단한다.	9	\N
20	1	20	agent20	금천구	50대	여성	oppose	21	77	재원 마련과 지속가능성에 의문을 느낀다.	32	\N
21	1	21	agent21	강동구	50대	남성	neutral	43	61	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-36	\N
22	1	22	agent22	영등포구	18-29	남성	support	70	79	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-3	\N
23	1	23	agent23	성동구	60대 이상	여성	oppose	11	78	형평성·세금 부담 측면에서 부정적이다.	-32	\N
24	1	24	agent24	은평구	60대 이상	여성	support	61	48	비용 대비 효용이 높다고 본다.	0	\N
25	1	25	agent25	성북구	60대 이상	여성	oppose	21	76	형평성·세금 부담 측면에서 부정적이다.	-28	\N
26	1	26	agent26	은평구	30대	남성	neutral	53	64	장단점이 비슷해 판단을 유보한다.	-31	\N
27	1	27	agent27	양천구	50대	여성	support	96	95	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	27	\N
28	1	28	agent28	양천구	50대	남성	support	62	66	사회적 형평성 측면에서 바람직하다고 판단한다.	26	\N
29	1	29	agent29	중랑구	30대	남성	support	67	67	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	28	\N
30	1	30	agent30	마포구	40대	남성	oppose	37	48	형평성·세금 부담 측면에서 부정적이다.	0	\N
31	1	31	agent31	강남구	60대 이상	여성	oppose	0	97	재원 마련과 지속가능성에 의문을 느낀다.	8	\N
32	1	32	agent32	노원구	50대	남성	neutral	49	50	추가 정보가 필요하다고 느낀다.	21	\N
33	1	33	agent33	중구	40대	여성	oppose	31	49	형평성·세금 부담 측면에서 부정적이다.	-22	\N
34	1	34	agent34	동작구	50대	남성	oppose	39	60	본인에게는 실익이 크지 않다고 본다.	-12	\N
35	1	35	agent35	광진구	18-29	남성	support	100	79	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	26	\N
36	1	36	agent36	강남구	60대 이상	남성	oppose	26	83	본인에게는 실익이 크지 않다고 본다.	13	\N
37	1	37	agent37	마포구	50대	남성	oppose	20	59	재원 마련과 지속가능성에 의문을 느낀다.	-38	\N
38	1	38	agent38	구로구	40대	여성	neutral	44	52	추가 정보가 필요하다고 느낀다.	-2	\N
39	1	39	agent39	관악구	30대	여성	neutral	56	64	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-28	\N
40	1	40	agent40	서대문구	18-29	여성	support	66	75	비용 대비 효용이 높다고 본다.	-8	\N
41	1	41	agent41	은평구	60대 이상	여성	neutral	51	71	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-8	\N
42	1	42	agent42	노원구	50대	남성	neutral	54	50	장단점이 비슷해 판단을 유보한다.	-12	\N
43	1	43	agent43	서초구	60대 이상	여성	support	65	69	비용 대비 효용이 높다고 본다.	30	\N
44	1	44	agent44	노원구	60대 이상	여성	neutral	52	55	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-12	\N
45	1	45	agent45	노원구	60대 이상	여성	neutral	56	55	장단점이 비슷해 판단을 유보한다.	8	\N
46	1	46	agent46	용산구	18-29	여성	support	63	72	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	33	\N
47	1	47	agent47	광진구	50대	여성	oppose	34	53	본인에게는 실익이 크지 않다고 본다.	-47	\N
48	1	48	agent48	성북구	30대	여성	support	83	84	사회적 형평성 측면에서 바람직하다고 판단한다.	3	\N
49	1	49	agent49	노원구	40대	남성	oppose	28	75	재원 마련과 지속가능성에 의문을 느낀다.	40	\N
50	1	50	agent50	강남구	50대	남성	neutral	46	56	장단점이 비슷해 판단을 유보한다.	14	\N
51	1	51	agent51	중구	40대	여성	oppose	30	64	본인에게는 실익이 크지 않다고 본다.	-39	\N
52	1	52	agent52	은평구	50대	남성	support	94	81	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	38	\N
53	1	53	agent53	양천구	18-29	여성	support	78	82	비용 대비 효용이 높다고 본다.	23	\N
54	1	54	agent54	서대문구	60대 이상	남성	neutral	45	51	추가 정보가 필요하다고 느낀다.	75	\N
55	1	55	agent55	금천구	60대 이상	여성	oppose	16	73	본인에게는 실익이 크지 않다고 본다.	-22	\N
56	1	56	agent56	송파구	18-29	남성	support	88	61	비용 대비 효용이 높다고 본다.	-9	\N
57	1	57	agent57	동대문구	60대 이상	남성	support	64	54	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	11	\N
58	1	58	agent58	동작구	60대 이상	여성	oppose	18	68	형평성·세금 부담 측면에서 부정적이다.	6	\N
59	1	59	agent59	송파구	40대	여성	neutral	48	64	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-23	\N
60	1	60	agent60	송파구	60대 이상	남성	oppose	24	64	형평성·세금 부담 측면에서 부정적이다.	36	\N
61	1	61	agent61	송파구	60대 이상	남성	oppose	37	56	형평성·세금 부담 측면에서 부정적이다.	51	\N
62	1	62	agent62	강남구	50대	남성	oppose	14	85	우선순위가 더 높은 다른 과제가 있다고 본다.	36	\N
63	1	63	agent63	광진구	60대 이상	여성	support	62	62	사회적 형평성 측면에서 바람직하다고 판단한다.	-33	\N
64	1	64	agent64	도봉구	60대 이상	남성	oppose	24	63	우선순위가 더 높은 다른 과제가 있다고 본다.	29	\N
65	1	65	agent65	관악구	30대	여성	support	88	86	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-44	\N
66	1	66	agent66	강북구	50대	남성	neutral	57	77	장단점이 비슷해 판단을 유보한다.	28	\N
67	1	67	agent67	성북구	60대 이상	여성	support	60	52	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-17	\N
68	1	68	agent68	강서구	40대	남성	oppose	8	78	본인에게는 실익이 크지 않다고 본다.	-24	\N
69	1	69	agent69	광진구	18-29	남성	support	94	75	사회적 형평성 측면에서 바람직하다고 판단한다.	43	\N
70	1	70	agent70	양천구	18-29	남성	support	66	48	사회적 형평성 측면에서 바람직하다고 판단한다.	-22	\N
71	1	71	agent71	강서구	50대	여성	oppose	20	62	본인에게는 실익이 크지 않다고 본다.	-28	\N
72	1	72	agent72	강남구	18-29	여성	neutral	51	66	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	5	\N
73	1	73	agent73	관악구	50대	여성	support	91	70	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	62	\N
74	1	74	agent74	송파구	60대 이상	여성	oppose	27	64	본인에게는 실익이 크지 않다고 본다.	-16	\N
75	1	75	agent75	도봉구	40대	여성	support	73	69	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-56	\N
76	1	76	agent76	은평구	40대	남성	neutral	44	60	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	45	\N
77	1	77	agent77	구로구	40대	남성	support	74	73	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	30	\N
78	1	78	agent78	중랑구	18-29	남성	support	63	67	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	35	\N
79	1	79	agent79	중랑구	60대 이상	여성	support	69	51	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-5	\N
80	1	80	agent80	영등포구	18-29	여성	support	100	97	비용 대비 효용이 높다고 본다.	12	\N
81	1	81	agent81	강동구	60대 이상	남성	oppose	42	56	재원 마련과 지속가능성에 의문을 느낀다.	-41	\N
82	1	82	agent82	강서구	18-29	남성	support	95	85	비용 대비 효용이 높다고 본다.	-3	\N
83	1	83	agent83	강서구	50대	여성	neutral	51	45	추가 정보가 필요하다고 느낀다.	10	\N
84	1	84	agent84	도봉구	60대 이상	남성	neutral	43	64	추가 정보가 필요하다고 느낀다.	70	\N
85	1	85	agent85	서초구	18-29	남성	support	77	71	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-46	\N
86	1	86	agent86	광진구	60대 이상	여성	neutral	54	62	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-5	\N
87	1	87	agent87	강동구	60대 이상	여성	oppose	27	69	본인에게는 실익이 크지 않다고 본다.	28	\N
88	1	88	agent88	금천구	18-29	여성	support	100	80	사회적 형평성 측면에서 바람직하다고 판단한다.	-19	\N
89	1	89	agent89	마포구	50대	남성	support	70	79	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	32	\N
90	1	90	agent90	마포구	50대	여성	oppose	36	72	형평성·세금 부담 측면에서 부정적이다.	-61	\N
91	1	91	agent91	양천구	60대 이상	남성	support	66	58	비용 대비 효용이 높다고 본다.	-26	\N
92	1	92	agent92	노원구	40대	여성	support	63	65	사회적 형평성 측면에서 바람직하다고 판단한다.	17	\N
93	1	93	agent93	중랑구	60대 이상	남성	neutral	43	62	추가 정보가 필요하다고 느낀다.	2	\N
94	1	94	agent94	구로구	60대 이상	여성	oppose	36	69	재원 마련과 지속가능성에 의문을 느낀다.	20	\N
95	1	95	agent95	강서구	18-29	남성	support	92	79	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	3	\N
96	1	96	agent96	성동구	30대	남성	support	62	60	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-53	\N
97	1	97	agent97	종로구	18-29	남성	support	79	84	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-7	\N
98	1	98	agent98	강북구	18-29	여성	support	100	77	사회적 형평성 측면에서 바람직하다고 판단한다.	-6	\N
99	1	99	agent99	양천구	60대 이상	남성	neutral	55	52	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-25	\N
100	1	100	agent100	도봉구	40대	남성	support	61	76	비용 대비 효용이 높다고 본다.	-29	\N
101	1	101	agent101	강동구	30대	남성	support	75	75	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-51	\N
102	1	102	agent102	은평구	60대 이상	남성	neutral	52	53	장단점이 비슷해 판단을 유보한다.	-19	\N
103	1	103	agent103	강남구	60대 이상	남성	oppose	30	66	재원 마련과 지속가능성에 의문을 느낀다.	-37	\N
104	1	104	agent104	송파구	18-29	남성	support	67	71	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-19	\N
105	1	105	agent105	강남구	30대	여성	oppose	32	62	형평성·세금 부담 측면에서 부정적이다.	-6	\N
106	1	106	agent106	송파구	60대 이상	남성	oppose	37	50	우선순위가 더 높은 다른 과제가 있다고 본다.	35	\N
107	1	107	agent107	송파구	30대	남성	support	73	74	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-10	\N
108	1	108	agent108	도봉구	30대	남성	neutral	52	64	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	1	\N
109	1	109	agent109	노원구	50대	남성	neutral	48	59	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	52	\N
110	1	110	agent110	성북구	18-29	남성	support	85	89	사회적 형평성 측면에서 바람직하다고 판단한다.	-5	\N
111	1	111	agent111	양천구	18-29	여성	support	81	67	비용 대비 효용이 높다고 본다.	44	\N
112	1	112	agent112	서대문구	30대	남성	support	75	76	사회적 형평성 측면에서 바람직하다고 판단한다.	46	\N
113	1	113	agent113	동대문구	60대 이상	여성	oppose	17	78	본인에게는 실익이 크지 않다고 본다.	-13	\N
114	1	114	agent114	관악구	40대	남성	neutral	52	47	추가 정보가 필요하다고 느낀다.	7	\N
115	1	115	agent115	강서구	50대	남성	oppose	32	61	본인에게는 실익이 크지 않다고 본다.	-23	\N
116	1	116	agent116	강남구	40대	남성	neutral	47	61	추가 정보가 필요하다고 느낀다.	-20	\N
117	1	117	agent117	동대문구	50대	남성	support	66	65	비용 대비 효용이 높다고 본다.	-1	\N
118	1	118	agent118	관악구	18-29	여성	support	100	78	비용 대비 효용이 높다고 본다.	-50	\N
119	1	119	agent119	관악구	50대	여성	support	79	76	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	38	\N
120	1	120	agent120	동대문구	18-29	여성	support	80	73	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-38	\N
121	1	121	agent121	중랑구	40대	여성	neutral	48	69	장단점이 비슷해 판단을 유보한다.	-17	\N
122	1	122	agent122	관악구	30대	남성	support	63	56	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	40	\N
123	1	123	agent123	송파구	60대 이상	남성	oppose	1	75	형평성·세금 부담 측면에서 부정적이다.	3	\N
124	1	124	agent124	중랑구	50대	여성	support	80	75	사회적 형평성 측면에서 바람직하다고 판단한다.	39	\N
125	1	125	agent125	성동구	18-29	남성	support	87	73	사회적 형평성 측면에서 바람직하다고 판단한다.	38	\N
126	1	126	agent126	구로구	30대	남성	neutral	53	57	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	52	\N
127	1	127	agent127	금천구	60대 이상	남성	oppose	10	76	본인에게는 실익이 크지 않다고 본다.	-30	\N
128	1	128	agent128	양천구	60대 이상	남성	oppose	12	86	재원 마련과 지속가능성에 의문을 느낀다.	17	\N
129	1	129	agent129	노원구	50대	남성	support	65	57	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	36	\N
130	1	130	agent130	서초구	50대	여성	oppose	32	62	재원 마련과 지속가능성에 의문을 느낀다.	19	\N
131	1	131	agent131	강서구	30대	여성	support	68	75	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-19	\N
132	1	132	agent132	동작구	50대	여성	oppose	26	91	우선순위가 더 높은 다른 과제가 있다고 본다.	-13	\N
133	1	133	agent133	금천구	60대 이상	여성	oppose	22	75	형평성·세금 부담 측면에서 부정적이다.	-9	\N
134	1	134	agent134	강남구	60대 이상	남성	neutral	44	56	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	10	\N
135	1	135	agent135	양천구	18-29	남성	support	68	60	비용 대비 효용이 높다고 본다.	-16	\N
136	1	136	agent136	구로구	40대	남성	support	75	57	비용 대비 효용이 높다고 본다.	-19	\N
137	1	137	agent137	구로구	18-29	여성	support	92	68	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-35	\N
138	1	138	agent138	도봉구	30대	여성	support	80	71	사회적 형평성 측면에서 바람직하다고 판단한다.	5	\N
139	1	139	agent139	도봉구	60대 이상	여성	oppose	39	57	본인에게는 실익이 크지 않다고 본다.	65	\N
140	1	140	agent140	서대문구	50대	여성	oppose	41	53	본인에게는 실익이 크지 않다고 본다.	0	\N
141	1	141	agent141	중랑구	60대 이상	남성	oppose	22	77	우선순위가 더 높은 다른 과제가 있다고 본다.	46	\N
142	1	142	agent142	성동구	60대 이상	여성	neutral	54	61	추가 정보가 필요하다고 느낀다.	-12	\N
143	1	143	agent143	송파구	30대	남성	support	83	74	비용 대비 효용이 높다고 본다.	-26	\N
144	1	144	agent144	강서구	40대	남성	support	72	80	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	34	\N
145	1	145	agent145	강서구	40대	여성	support	60	63	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	19	\N
146	1	146	agent146	영등포구	60대 이상	남성	oppose	26	76	형평성·세금 부담 측면에서 부정적이다.	41	\N
147	1	147	agent147	강북구	40대	여성	support	77	75	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	41	\N
148	1	148	agent148	동대문구	18-29	여성	support	85	72	사회적 형평성 측면에서 바람직하다고 판단한다.	-16	\N
149	1	149	agent149	영등포구	60대 이상	남성	oppose	28	80	형평성·세금 부담 측면에서 부정적이다.	-43	\N
150	1	150	agent150	서초구	60대 이상	남성	neutral	51	54	추가 정보가 필요하다고 느낀다.	7	\N
151	1	151	agent151	동작구	60대 이상	남성	oppose	36	59	본인에게는 실익이 크지 않다고 본다.	-13	\N
152	1	152	agent152	구로구	60대 이상	남성	oppose	26	90	본인에게는 실익이 크지 않다고 본다.	-12	\N
153	1	153	agent153	노원구	40대	남성	oppose	37	56	형평성·세금 부담 측면에서 부정적이다.	10	\N
154	1	154	agent154	양천구	60대 이상	여성	neutral	46	48	추가 정보가 필요하다고 느낀다.	-29	\N
155	1	155	agent155	동대문구	60대 이상	여성	oppose	20	60	형평성·세금 부담 측면에서 부정적이다.	-2	\N
156	1	156	agent156	노원구	30대	여성	support	78	73	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-52	\N
157	1	157	agent157	노원구	60대 이상	남성	oppose	24	67	본인에게는 실익이 크지 않다고 본다.	-13	\N
158	1	158	agent158	동대문구	60대 이상	여성	neutral	43	57	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-4	\N
159	1	159	agent159	영등포구	18-29	남성	support	97	82	비용 대비 효용이 높다고 본다.	25	\N
160	1	160	agent160	관악구	60대 이상	여성	oppose	29	76	형평성·세금 부담 측면에서 부정적이다.	-5	\N
161	1	161	agent161	영등포구	18-29	남성	support	100	83	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	4	\N
162	1	162	agent162	동작구	50대	남성	support	73	77	비용 대비 효용이 높다고 본다.	-27	\N
163	1	163	agent163	관악구	30대	여성	support	78	87	사회적 형평성 측면에서 바람직하다고 판단한다.	70	\N
164	1	164	agent164	영등포구	40대	남성	support	69	65	사회적 형평성 측면에서 바람직하다고 판단한다.	28	\N
165	1	165	agent165	양천구	60대 이상	여성	oppose	22	59	본인에게는 실익이 크지 않다고 본다.	-25	\N
166	1	166	agent166	성동구	60대 이상	여성	oppose	27	80	형평성·세금 부담 측면에서 부정적이다.	-35	\N
167	1	167	agent167	용산구	18-29	남성	support	100	93	사회적 형평성 측면에서 바람직하다고 판단한다.	-31	\N
168	1	168	agent168	종로구	60대 이상	남성	neutral	49	58	추가 정보가 필요하다고 느낀다.	9	\N
169	1	169	agent169	강서구	50대	남성	neutral	48	65	추가 정보가 필요하다고 느낀다.	-22	\N
170	1	170	agent170	송파구	60대 이상	여성	oppose	18	79	형평성·세금 부담 측면에서 부정적이다.	8	\N
171	1	171	agent171	동대문구	60대 이상	여성	oppose	38	55	본인에게는 실익이 크지 않다고 본다.	26	\N
172	1	172	agent172	종로구	30대	여성	neutral	50	53	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-59	\N
173	1	173	agent173	구로구	60대 이상	여성	support	67	72	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-21	\N
174	1	174	agent174	노원구	60대 이상	남성	oppose	38	51	형평성·세금 부담 측면에서 부정적이다.	76	\N
175	1	175	agent175	은평구	30대	여성	support	74	65	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	7	\N
176	1	176	agent176	강남구	18-29	남성	support	79	72	비용 대비 효용이 높다고 본다.	45	\N
177	1	177	agent177	관악구	50대	남성	support	72	68	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-2	\N
178	1	178	agent178	도봉구	40대	남성	oppose	33	63	본인에게는 실익이 크지 않다고 본다.	-8	\N
179	1	179	agent179	은평구	60대 이상	여성	oppose	18	79	본인에게는 실익이 크지 않다고 본다.	32	\N
180	1	180	agent180	강북구	18-29	남성	support	77	66	사회적 형평성 측면에서 바람직하다고 판단한다.	1	\N
181	1	181	agent181	강동구	18-29	여성	support	87	88	사회적 형평성 측면에서 바람직하다고 판단한다.	3	\N
182	1	182	agent182	은평구	40대	남성	support	89	73	비용 대비 효용이 높다고 본다.	25	\N
183	1	183	agent183	동작구	40대	남성	support	65	63	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-22	\N
184	1	184	agent184	중구	18-29	남성	support	69	56	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-4	\N
185	1	185	agent185	마포구	60대 이상	여성	support	66	66	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-24	\N
186	1	186	agent186	서초구	60대 이상	여성	oppose	0	75	우선순위가 더 높은 다른 과제가 있다고 본다.	32	\N
187	1	187	agent187	마포구	18-29	남성	support	84	66	비용 대비 효용이 높다고 본다.	12	\N
188	1	188	agent188	강서구	18-29	남성	support	90	81	비용 대비 효용이 높다고 본다.	-18	\N
189	1	189	agent189	동작구	50대	여성	neutral	52	49	장단점이 비슷해 판단을 유보한다.	-24	\N
190	1	190	agent190	강서구	50대	남성	neutral	56	59	추가 정보가 필요하다고 느낀다.	38	\N
191	1	191	agent191	송파구	30대	여성	neutral	51	53	장단점이 비슷해 판단을 유보한다.	-7	\N
192	1	192	agent192	강동구	60대 이상	남성	oppose	0	91	형평성·세금 부담 측면에서 부정적이다.	-22	\N
193	1	193	agent193	관악구	50대	여성	oppose	39	55	형평성·세금 부담 측면에서 부정적이다.	-29	\N
194	1	194	agent194	양천구	30대	남성	neutral	47	66	장단점이 비슷해 판단을 유보한다.	18	\N
195	1	195	agent195	강서구	30대	남성	support	100	97	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	1	\N
196	1	196	agent196	종로구	50대	남성	neutral	51	55	장단점이 비슷해 판단을 유보한다.	9	\N
197	1	197	agent197	종로구	18-29	여성	support	75	68	비용 대비 효용이 높다고 본다.	-59	\N
198	1	198	agent198	구로구	30대	여성	neutral	49	62	장단점이 비슷해 판단을 유보한다.	8	\N
199	1	199	agent199	영등포구	30대	여성	neutral	51	64	장단점이 비슷해 판단을 유보한다.	-9	\N
200	1	200	agent200	마포구	60대 이상	여성	oppose	28	74	우선순위가 더 높은 다른 과제가 있다고 본다.	-16	\N
201	1	201	agent201	성동구	60대 이상	여성	oppose	5	83	우선순위가 더 높은 다른 과제가 있다고 본다.	17	\N
202	1	202	agent202	강서구	60대 이상	남성	oppose	20	76	재원 마련과 지속가능성에 의문을 느낀다.	-35	\N
203	1	203	agent203	서대문구	30대	여성	support	83	83	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-11	\N
204	1	204	agent204	성동구	30대	여성	support	100	89	비용 대비 효용이 높다고 본다.	-1	\N
205	1	205	agent205	양천구	40대	여성	support	68	71	사회적 형평성 측면에서 바람직하다고 판단한다.	37	\N
206	1	206	agent206	관악구	50대	여성	support	89	83	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	6	\N
207	1	207	agent207	관악구	60대 이상	남성	oppose	40	66	본인에게는 실익이 크지 않다고 본다.	38	\N
208	1	208	agent208	관악구	40대	여성	neutral	54	44	추가 정보가 필요하다고 느낀다.	49	\N
209	1	209	agent209	광진구	30대	여성	support	69	55	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-25	\N
210	1	210	agent210	도봉구	18-29	남성	support	80	71	비용 대비 효용이 높다고 본다.	-4	\N
211	1	211	agent211	강서구	60대 이상	남성	oppose	24	73	본인에게는 실익이 크지 않다고 본다.	48	\N
212	1	212	agent212	강남구	60대 이상	여성	oppose	20	78	형평성·세금 부담 측면에서 부정적이다.	-40	\N
213	1	213	agent213	강동구	60대 이상	남성	support	58	58	비용 대비 효용이 높다고 본다.	13	\N
214	1	214	agent214	광진구	60대 이상	여성	neutral	54	56	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-35	\N
215	1	215	agent215	강남구	50대	여성	neutral	46	59	추가 정보가 필요하다고 느낀다.	26	\N
216	1	216	agent216	강남구	40대	남성	support	69	66	사회적 형평성 측면에서 바람직하다고 판단한다.	33	\N
217	1	217	agent217	강동구	30대	여성	support	58	63	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	4	\N
218	1	218	agent218	중구	30대	여성	support	93	77	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	30	\N
219	1	219	agent219	동작구	18-29	남성	support	77	73	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	27	\N
220	1	220	agent220	양천구	30대	여성	support	66	49	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	30	\N
221	1	221	agent221	금천구	30대	남성	support	66	66	비용 대비 효용이 높다고 본다.	21	\N
222	1	222	agent222	강남구	50대	여성	support	66	68	사회적 형평성 측면에서 바람직하다고 판단한다.	17	\N
223	1	223	agent223	송파구	40대	여성	neutral	43	71	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-2	\N
224	1	224	agent224	은평구	60대 이상	남성	oppose	22	80	형평성·세금 부담 측면에서 부정적이다.	60	\N
225	1	225	agent225	노원구	60대 이상	여성	oppose	41	57	형평성·세금 부담 측면에서 부정적이다.	7	\N
226	1	226	agent226	양천구	60대 이상	여성	oppose	24	83	재원 마련과 지속가능성에 의문을 느낀다.	25	\N
227	1	227	agent227	강서구	60대 이상	남성	support	61	59	사회적 형평성 측면에서 바람직하다고 판단한다.	-27	\N
228	1	228	agent228	구로구	60대 이상	여성	oppose	21	74	형평성·세금 부담 측면에서 부정적이다.	-5	\N
229	1	229	agent229	강북구	60대 이상	남성	oppose	31	64	우선순위가 더 높은 다른 과제가 있다고 본다.	2	\N
230	1	230	agent230	동작구	60대 이상	남성	oppose	32	64	형평성·세금 부담 측면에서 부정적이다.	45	\N
231	1	231	agent231	강남구	18-29	남성	neutral	57	70	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-5	\N
232	1	232	agent232	관악구	30대	여성	support	80	70	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-8	\N
233	1	233	agent233	성북구	30대	여성	support	70	79	비용 대비 효용이 높다고 본다.	-3	\N
234	1	234	agent234	강북구	60대 이상	여성	oppose	37	64	본인에게는 실익이 크지 않다고 본다.	5	\N
235	1	235	agent235	은평구	60대 이상	여성	oppose	37	40	형평성·세금 부담 측면에서 부정적이다.	-28	\N
236	1	236	agent236	마포구	18-29	여성	support	99	95	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	25	\N
237	1	237	agent237	강북구	60대 이상	여성	neutral	47	56	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-27	\N
238	1	238	agent238	종로구	50대	여성	oppose	37	68	본인에게는 실익이 크지 않다고 본다.	-35	\N
239	1	239	agent239	강남구	50대	여성	oppose	18	74	본인에게는 실익이 크지 않다고 본다.	-6	\N
240	1	240	agent240	송파구	18-29	남성	support	71	70	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-65	\N
241	1	241	agent241	노원구	50대	여성	oppose	37	61	우선순위가 더 높은 다른 과제가 있다고 본다.	88	\N
242	1	242	agent242	금천구	30대	여성	support	63	53	사회적 형평성 측면에서 바람직하다고 판단한다.	33	\N
243	1	243	agent243	동대문구	60대 이상	남성	oppose	27	69	우선순위가 더 높은 다른 과제가 있다고 본다.	-15	\N
244	1	244	agent244	양천구	60대 이상	여성	oppose	39	60	본인에게는 실익이 크지 않다고 본다.	-45	\N
245	1	245	agent245	관악구	30대	남성	support	74	59	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	30	\N
246	1	246	agent246	서대문구	60대 이상	남성	oppose	37	73	재원 마련과 지속가능성에 의문을 느낀다.	23	\N
247	1	247	agent247	영등포구	40대	남성	support	59	63	비용 대비 효용이 높다고 본다.	42	\N
248	1	248	agent248	도봉구	60대 이상	여성	oppose	31	68	재원 마련과 지속가능성에 의문을 느낀다.	0	\N
249	1	249	agent249	양천구	30대	여성	support	62	65	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	54	\N
250	1	250	agent250	송파구	30대	여성	support	64	65	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	24	\N
251	1	251	agent251	송파구	30대	여성	oppose	41	56	우선순위가 더 높은 다른 과제가 있다고 본다.	-25	\N
252	1	252	agent252	마포구	18-29	남성	neutral	56	49	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-27	\N
253	1	253	agent253	도봉구	30대	여성	support	59	54	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	3	\N
254	1	254	agent254	광진구	30대	여성	support	71	51	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	25	\N
255	1	255	agent255	광진구	30대	여성	support	93	74	사회적 형평성 측면에서 바람직하다고 판단한다.	14	\N
256	1	256	agent256	용산구	50대	남성	oppose	39	58	본인에게는 실익이 크지 않다고 본다.	71	\N
257	1	257	agent257	마포구	18-29	남성	support	100	99	사회적 형평성 측면에서 바람직하다고 판단한다.	59	\N
258	1	258	agent258	강남구	60대 이상	여성	neutral	43	68	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	29	\N
259	1	259	agent259	양천구	30대	남성	neutral	55	60	장단점이 비슷해 판단을 유보한다.	16	\N
260	1	260	agent260	강남구	30대	여성	neutral	53	66	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	67	\N
261	1	261	agent261	용산구	50대	남성	neutral	43	56	장단점이 비슷해 판단을 유보한다.	-48	\N
262	1	262	agent262	동대문구	40대	여성	support	58	48	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-3	\N
263	1	263	agent263	도봉구	18-29	남성	neutral	52	59	추가 정보가 필요하다고 느낀다.	-2	\N
264	1	264	agent264	동작구	40대	남성	support	63	77	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-23	\N
265	1	265	agent265	도봉구	60대 이상	여성	oppose	10	75	형평성·세금 부담 측면에서 부정적이다.	10	\N
266	1	266	agent266	성북구	50대	여성	oppose	36	57	재원 마련과 지속가능성에 의문을 느낀다.	17	\N
267	1	267	agent267	송파구	50대	남성	oppose	36	69	우선순위가 더 높은 다른 과제가 있다고 본다.	-11	\N
268	1	268	agent268	구로구	40대	여성	neutral	44	48	추가 정보가 필요하다고 느낀다.	3	\N
269	1	269	agent269	동작구	60대 이상	여성	neutral	53	67	장단점이 비슷해 판단을 유보한다.	8	\N
270	1	270	agent270	노원구	30대	남성	support	85	85	비용 대비 효용이 높다고 본다.	40	\N
271	1	271	agent271	광진구	60대 이상	여성	oppose	36	68	재원 마련과 지속가능성에 의문을 느낀다.	-2	\N
272	1	272	agent272	동작구	40대	남성	neutral	44	53	장단점이 비슷해 판단을 유보한다.	-29	\N
273	1	273	agent273	양천구	40대	남성	neutral	51	52	장단점이 비슷해 판단을 유보한다.	-12	\N
274	1	274	agent274	서초구	18-29	남성	support	78	86	비용 대비 효용이 높다고 본다.	16	\N
275	1	275	agent275	양천구	60대 이상	남성	neutral	43	60	추가 정보가 필요하다고 느낀다.	4	\N
276	1	276	agent276	관악구	18-29	여성	support	87	77	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-36	\N
277	1	277	agent277	강동구	60대 이상	여성	support	62	59	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-47	\N
278	1	278	agent278	관악구	60대 이상	여성	neutral	43	64	추가 정보가 필요하다고 느낀다.	-15	\N
279	1	279	agent279	강남구	50대	여성	neutral	57	44	장단점이 비슷해 판단을 유보한다.	-35	\N
280	1	280	agent280	노원구	40대	여성	support	71	65	비용 대비 효용이 높다고 본다.	-42	\N
281	1	281	agent281	용산구	18-29	여성	support	100	93	비용 대비 효용이 높다고 본다.	-5	\N
282	1	282	agent282	동작구	18-29	여성	support	86	85	비용 대비 효용이 높다고 본다.	0	\N
283	1	283	agent283	성동구	30대	여성	support	77	67	사회적 형평성 측면에서 바람직하다고 판단한다.	-14	\N
284	1	284	agent284	강남구	60대 이상	남성	oppose	42	55	본인에게는 실익이 크지 않다고 본다.	-5	\N
285	1	285	agent285	서초구	50대	여성	oppose	36	58	재원 마련과 지속가능성에 의문을 느낀다.	-45	\N
286	1	286	agent286	용산구	18-29	남성	support	74	71	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-57	\N
287	1	287	agent287	동대문구	40대	남성	support	78	81	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	5	\N
288	1	288	agent288	동대문구	40대	여성	support	58	55	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-37	\N
289	1	289	agent289	서초구	18-29	남성	support	78	69	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-30	\N
290	1	290	agent290	강북구	60대 이상	여성	oppose	33	69	재원 마련과 지속가능성에 의문을 느낀다.	-50	\N
291	1	291	agent291	중랑구	60대 이상	남성	oppose	5	72	우선순위가 더 높은 다른 과제가 있다고 본다.	-64	\N
292	1	292	agent292	종로구	40대	여성	neutral	46	54	장단점이 비슷해 판단을 유보한다.	-10	\N
293	1	293	agent293	동작구	60대 이상	남성	support	61	63	사회적 형평성 측면에서 바람직하다고 판단한다.	11	\N
294	1	294	agent294	양천구	60대 이상	남성	neutral	56	68	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	33	\N
295	1	295	agent295	서대문구	18-29	여성	support	72	71	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-3	\N
296	1	296	agent296	용산구	18-29	여성	support	73	83	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-28	\N
297	1	297	agent297	강남구	60대 이상	여성	oppose	7	93	형평성·세금 부담 측면에서 부정적이다.	-46	\N
298	1	298	agent298	구로구	30대	남성	neutral	57	51	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	41	\N
299	1	299	agent299	관악구	30대	남성	neutral	46	54	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	6	\N
300	1	300	agent300	서초구	60대 이상	남성	oppose	16	83	우선순위가 더 높은 다른 과제가 있다고 본다.	-8	\N
301	1	301	agent301	서초구	40대	여성	oppose	39	68	형평성·세금 부담 측면에서 부정적이다.	-2	\N
302	1	302	agent302	양천구	60대 이상	여성	support	61	60	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-50	\N
303	1	303	agent303	서대문구	60대 이상	남성	oppose	42	54	재원 마련과 지속가능성에 의문을 느낀다.	8	\N
304	1	304	agent304	성동구	18-29	남성	support	94	76	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	36	\N
305	1	305	agent305	관악구	30대	여성	support	79	86	비용 대비 효용이 높다고 본다.	5	\N
306	1	306	agent306	동작구	60대 이상	남성	oppose	18	84	형평성·세금 부담 측면에서 부정적이다.	9	\N
307	1	307	agent307	관악구	60대 이상	남성	oppose	23	83	우선순위가 더 높은 다른 과제가 있다고 본다.	12	\N
308	1	308	agent308	마포구	60대 이상	남성	support	72	68	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-19	\N
309	1	309	agent309	송파구	18-29	여성	support	65	39	비용 대비 효용이 높다고 본다.	25	\N
310	1	310	agent310	마포구	50대	남성	oppose	27	65	우선순위가 더 높은 다른 과제가 있다고 본다.	-22	\N
311	1	311	agent311	은평구	60대 이상	남성	oppose	40	61	본인에게는 실익이 크지 않다고 본다.	11	\N
312	1	312	agent312	강동구	60대 이상	남성	oppose	0	82	우선순위가 더 높은 다른 과제가 있다고 본다.	27	\N
313	1	313	agent313	성북구	60대 이상	여성	oppose	35	61	형평성·세금 부담 측면에서 부정적이다.	-33	\N
314	1	314	agent314	강동구	50대	남성	oppose	21	75	형평성·세금 부담 측면에서 부정적이다.	-25	\N
315	1	315	agent315	광진구	60대 이상	여성	oppose	0	86	우선순위가 더 높은 다른 과제가 있다고 본다.	40	\N
316	1	316	agent316	서초구	60대 이상	남성	oppose	4	67	본인에게는 실익이 크지 않다고 본다.	0	\N
317	1	317	agent317	서초구	40대	여성	neutral	45	47	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	3	\N
318	1	318	agent318	강서구	40대	남성	neutral	52	58	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	43	\N
319	1	319	agent319	강서구	50대	여성	support	64	56	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-15	\N
320	1	320	agent320	관악구	60대 이상	남성	oppose	30	62	본인에게는 실익이 크지 않다고 본다.	32	\N
321	1	321	agent321	중랑구	60대 이상	여성	oppose	29	68	형평성·세금 부담 측면에서 부정적이다.	6	\N
322	1	322	agent322	관악구	50대	남성	support	61	73	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-7	\N
323	1	323	agent323	양천구	60대 이상	여성	oppose	11	84	본인에게는 실익이 크지 않다고 본다.	10	\N
324	1	324	agent324	송파구	40대	남성	neutral	53	61	장단점이 비슷해 판단을 유보한다.	1	\N
325	1	325	agent325	강동구	18-29	여성	support	68	66	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-11	\N
326	1	326	agent326	광진구	50대	여성	support	80	70	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-24	\N
327	1	327	agent327	중랑구	60대 이상	여성	neutral	46	65	장단점이 비슷해 판단을 유보한다.	19	\N
328	1	328	agent328	관악구	18-29	남성	support	87	79	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	30	\N
329	1	329	agent329	송파구	60대 이상	남성	neutral	56	69	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	41	\N
330	1	330	agent330	마포구	30대	여성	support	95	90	사회적 형평성 측면에서 바람직하다고 판단한다.	-1	\N
331	1	331	agent331	성북구	18-29	남성	support	80	59	사회적 형평성 측면에서 바람직하다고 판단한다.	18	\N
332	1	332	agent332	마포구	40대	여성	neutral	51	47	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-21	\N
333	1	333	agent333	양천구	60대 이상	여성	oppose	42	57	우선순위가 더 높은 다른 과제가 있다고 본다.	-12	\N
334	1	334	agent334	동작구	30대	여성	oppose	41	62	본인에게는 실익이 크지 않다고 본다.	-2	\N
335	1	335	agent335	도봉구	18-29	여성	support	100	74	사회적 형평성 측면에서 바람직하다고 판단한다.	-29	\N
336	1	336	agent336	양천구	60대 이상	여성	oppose	20	58	본인에게는 실익이 크지 않다고 본다.	30	\N
337	1	337	agent337	강북구	60대 이상	여성	oppose	18	75	본인에게는 실익이 크지 않다고 본다.	-26	\N
338	1	338	agent338	노원구	60대 이상	남성	neutral	50	72	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	0	\N
339	1	339	agent339	은평구	60대 이상	여성	support	62	70	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-45	\N
340	1	340	agent340	동작구	18-29	남성	support	100	90	사회적 형평성 측면에서 바람직하다고 판단한다.	49	\N
341	1	341	agent341	영등포구	18-29	여성	support	100	80	비용 대비 효용이 높다고 본다.	32	\N
342	1	342	agent342	노원구	50대	남성	support	64	69	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	5	\N
343	1	343	agent343	중구	60대 이상	남성	oppose	25	73	본인에게는 실익이 크지 않다고 본다.	4	\N
344	1	344	agent344	양천구	18-29	남성	support	58	54	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	5	\N
345	1	345	agent345	은평구	30대	남성	oppose	30	74	형평성·세금 부담 측면에서 부정적이다.	-8	\N
346	1	346	agent346	성북구	60대 이상	남성	neutral	49	57	추가 정보가 필요하다고 느낀다.	-5	\N
347	1	347	agent347	송파구	50대	여성	oppose	4	74	본인에게는 실익이 크지 않다고 본다.	-60	\N
348	1	348	agent348	강남구	30대	여성	support	70	82	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-22	\N
349	1	349	agent349	종로구	18-29	여성	support	75	61	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	49	\N
350	1	350	agent350	마포구	30대	남성	support	58	57	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-15	\N
351	1	351	agent351	강남구	30대	여성	oppose	41	59	본인에게는 실익이 크지 않다고 본다.	31	\N
352	1	352	agent352	도봉구	18-29	남성	support	100	82	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-7	\N
353	1	353	agent353	강남구	18-29	남성	neutral	57	70	추가 정보가 필요하다고 느낀다.	6	\N
354	1	354	agent354	광진구	60대 이상	남성	support	60	65	사회적 형평성 측면에서 바람직하다고 판단한다.	11	\N
355	1	355	agent355	성동구	60대 이상	남성	oppose	39	63	형평성·세금 부담 측면에서 부정적이다.	37	\N
356	1	356	agent356	관악구	60대 이상	남성	support	76	62	비용 대비 효용이 높다고 본다.	-12	\N
357	1	357	agent357	송파구	40대	남성	oppose	38	63	형평성·세금 부담 측면에서 부정적이다.	4	\N
358	1	358	agent358	노원구	60대 이상	남성	neutral	50	73	장단점이 비슷해 판단을 유보한다.	-20	\N
359	1	359	agent359	용산구	50대	남성	oppose	41	60	우선순위가 더 높은 다른 과제가 있다고 본다.	1	\N
360	1	360	agent360	용산구	60대 이상	남성	oppose	28	56	형평성·세금 부담 측면에서 부정적이다.	-7	\N
361	1	361	agent361	동대문구	50대	여성	support	81	81	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-48	\N
362	1	362	agent362	송파구	50대	여성	support	64	60	비용 대비 효용이 높다고 본다.	41	\N
363	1	363	agent363	양천구	50대	남성	support	74	68	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	27	\N
364	1	364	agent364	강서구	18-29	여성	support	87	73	사회적 형평성 측면에서 바람직하다고 판단한다.	-20	\N
365	1	365	agent365	강북구	18-29	여성	support	100	82	비용 대비 효용이 높다고 본다.	-28	\N
366	1	366	agent366	동작구	18-29	남성	support	84	73	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-11	\N
367	1	367	agent367	중랑구	60대 이상	남성	oppose	42	62	본인에게는 실익이 크지 않다고 본다.	42	\N
368	1	368	agent368	강남구	18-29	여성	oppose	40	49	형평성·세금 부담 측면에서 부정적이다.	17	\N
369	1	369	agent369	서대문구	18-29	여성	support	94	85	비용 대비 효용이 높다고 본다.	6	\N
370	1	370	agent370	서초구	18-29	여성	support	86	84	사회적 형평성 측면에서 바람직하다고 판단한다.	12	\N
371	1	371	agent371	은평구	60대 이상	남성	neutral	44	65	추가 정보가 필요하다고 느낀다.	23	\N
372	1	372	agent372	송파구	60대 이상	남성	neutral	44	75	추가 정보가 필요하다고 느낀다.	2	\N
373	1	373	agent373	구로구	18-29	여성	support	68	79	비용 대비 효용이 높다고 본다.	39	\N
374	1	374	agent374	은평구	30대	여성	support	62	63	비용 대비 효용이 높다고 본다.	38	\N
375	1	375	agent375	종로구	60대 이상	여성	oppose	30	65	본인에게는 실익이 크지 않다고 본다.	-23	\N
376	1	376	agent376	강남구	60대 이상	남성	neutral	51	67	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	56	\N
377	1	377	agent377	강동구	50대	남성	oppose	38	52	본인에게는 실익이 크지 않다고 본다.	22	\N
378	1	378	agent378	도봉구	60대 이상	여성	oppose	35	79	형평성·세금 부담 측면에서 부정적이다.	30	\N
379	1	379	agent379	강남구	60대 이상	남성	oppose	10	79	형평성·세금 부담 측면에서 부정적이다.	24	\N
380	1	380	agent380	서초구	40대	여성	oppose	18	86	본인에게는 실익이 크지 않다고 본다.	12	\N
381	1	381	agent381	중랑구	60대 이상	남성	oppose	27	72	재원 마련과 지속가능성에 의문을 느낀다.	-33	\N
382	1	382	agent382	송파구	50대	여성	support	61	66	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	44	\N
383	1	383	agent383	송파구	30대	남성	support	64	60	사회적 형평성 측면에서 바람직하다고 판단한다.	-28	\N
384	1	384	agent384	강남구	60대 이상	여성	oppose	40	70	재원 마련과 지속가능성에 의문을 느낀다.	-62	\N
385	1	385	agent385	강남구	50대	여성	oppose	36	57	재원 마련과 지속가능성에 의문을 느낀다.	-18	\N
386	1	386	agent386	도봉구	18-29	남성	support	64	60	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-43	\N
387	1	387	agent387	강북구	60대 이상	여성	support	67	67	사회적 형평성 측면에서 바람직하다고 판단한다.	-38	\N
388	1	388	agent388	노원구	60대 이상	여성	support	65	62	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-44	\N
389	1	389	agent389	구로구	60대 이상	여성	oppose	4	85	재원 마련과 지속가능성에 의문을 느낀다.	-8	\N
390	1	390	agent390	관악구	60대 이상	여성	oppose	41	73	형평성·세금 부담 측면에서 부정적이다.	-45	\N
391	1	391	agent391	동대문구	60대 이상	남성	oppose	16	79	재원 마련과 지속가능성에 의문을 느낀다.	55	\N
392	1	392	agent392	강남구	60대 이상	여성	oppose	10	77	형평성·세금 부담 측면에서 부정적이다.	-19	\N
393	1	393	agent393	용산구	60대 이상	여성	neutral	46	56	장단점이 비슷해 판단을 유보한다.	-3	\N
394	1	394	agent394	성동구	40대	여성	neutral	56	56	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	38	\N
395	1	395	agent395	강남구	60대 이상	남성	oppose	19	79	본인에게는 실익이 크지 않다고 본다.	-10	\N
396	1	396	agent396	동작구	50대	남성	support	78	61	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-13	\N
397	1	397	agent397	중랑구	60대 이상	여성	neutral	52	65	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	27	\N
398	1	398	agent398	양천구	60대 이상	남성	oppose	0	89	본인에게는 실익이 크지 않다고 본다.	8	\N
399	1	399	agent399	관악구	50대	여성	neutral	53	69	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-21	\N
400	1	400	agent400	광진구	60대 이상	남성	oppose	35	65	우선순위가 더 높은 다른 과제가 있다고 본다.	47	\N
401	1	401	agent401	서초구	30대	남성	support	63	69	사회적 형평성 측면에서 바람직하다고 판단한다.	6	\N
402	1	402	agent402	노원구	40대	남성	support	62	56	사회적 형평성 측면에서 바람직하다고 판단한다.	-15	\N
403	1	403	agent403	구로구	60대 이상	여성	oppose	5	75	형평성·세금 부담 측면에서 부정적이다.	-18	\N
404	1	404	agent404	강남구	60대 이상	남성	oppose	19	63	우선순위가 더 높은 다른 과제가 있다고 본다.	22	\N
405	1	405	agent405	금천구	60대 이상	남성	oppose	31	77	본인에게는 실익이 크지 않다고 본다.	-22	\N
406	1	406	agent406	중랑구	60대 이상	여성	oppose	13	75	형평성·세금 부담 측면에서 부정적이다.	7	\N
407	1	407	agent407	서초구	40대	여성	oppose	0	76	형평성·세금 부담 측면에서 부정적이다.	-1	\N
408	1	408	agent408	양천구	50대	여성	support	71	64	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-23	\N
409	1	409	agent409	중랑구	60대 이상	남성	oppose	24	73	재원 마련과 지속가능성에 의문을 느낀다.	-18	\N
410	1	410	agent410	성동구	18-29	남성	support	69	62	사회적 형평성 측면에서 바람직하다고 판단한다.	-50	\N
411	1	411	agent411	구로구	40대	여성	oppose	31	60	형평성·세금 부담 측면에서 부정적이다.	-21	\N
412	1	412	agent412	강서구	18-29	남성	support	59	55	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	11	\N
413	1	413	agent413	서대문구	60대 이상	여성	oppose	38	50	재원 마련과 지속가능성에 의문을 느낀다.	3	\N
414	1	414	agent414	송파구	50대	여성	oppose	20	83	재원 마련과 지속가능성에 의문을 느낀다.	25	\N
415	1	415	agent415	노원구	50대	여성	oppose	34	58	우선순위가 더 높은 다른 과제가 있다고 본다.	5	\N
416	1	416	agent416	노원구	60대 이상	여성	oppose	21	69	우선순위가 더 높은 다른 과제가 있다고 본다.	-15	\N
417	1	417	agent417	중랑구	30대	남성	support	88	81	비용 대비 효용이 높다고 본다.	19	\N
418	1	418	agent418	서초구	50대	여성	oppose	6	90	형평성·세금 부담 측면에서 부정적이다.	-31	\N
419	1	419	agent419	구로구	60대 이상	남성	oppose	35	76	본인에게는 실익이 크지 않다고 본다.	11	\N
420	1	420	agent420	송파구	30대	여성	neutral	44	63	장단점이 비슷해 판단을 유보한다.	4	\N
421	1	421	agent421	송파구	50대	여성	oppose	2	83	재원 마련과 지속가능성에 의문을 느낀다.	-32	\N
422	1	422	agent422	서초구	60대 이상	여성	oppose	0	90	형평성·세금 부담 측면에서 부정적이다.	10	\N
423	1	423	agent423	관악구	30대	남성	support	64	79	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-26	\N
530	2	30	agent30	마포구	40대	남성	neutral	44	51	추가 정보가 필요하다고 느낀다.	0	\N
425	1	425	agent425	강서구	50대	여성	neutral	43	57	장단점이 비슷해 판단을 유보한다.	-12	\N
426	1	426	agent426	은평구	18-29	남성	support	91	99	사회적 형평성 측면에서 바람직하다고 판단한다.	27	\N
427	1	427	agent427	송파구	30대	남성	neutral	50	61	추가 정보가 필요하다고 느낀다.	11	\N
428	1	428	agent428	강서구	18-29	남성	support	68	68	비용 대비 효용이 높다고 본다.	-33	\N
429	1	429	agent429	강남구	50대	남성	oppose	35	63	형평성·세금 부담 측면에서 부정적이다.	31	\N
430	1	430	agent430	금천구	18-29	여성	support	65	67	비용 대비 효용이 높다고 본다.	-1	\N
431	1	431	agent431	중랑구	50대	남성	oppose	22	66	본인에게는 실익이 크지 않다고 본다.	-49	\N
432	1	432	agent432	서초구	30대	남성	neutral	52	62	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-37	\N
433	1	433	agent433	구로구	60대 이상	여성	neutral	43	71	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	7	\N
434	1	434	agent434	도봉구	40대	남성	oppose	16	79	우선순위가 더 높은 다른 과제가 있다고 본다.	-20	\N
435	1	435	agent435	중랑구	60대 이상	남성	oppose	13	69	우선순위가 더 높은 다른 과제가 있다고 본다.	-32	\N
436	1	436	agent436	종로구	60대 이상	남성	neutral	45	63	추가 정보가 필요하다고 느낀다.	-34	\N
437	1	437	agent437	강남구	50대	남성	oppose	19	80	재원 마련과 지속가능성에 의문을 느낀다.	13	\N
438	1	438	agent438	송파구	60대 이상	여성	oppose	30	72	형평성·세금 부담 측면에서 부정적이다.	-50	\N
439	1	439	agent439	영등포구	50대	여성	oppose	32	68	우선순위가 더 높은 다른 과제가 있다고 본다.	17	\N
440	1	440	agent440	송파구	50대	남성	support	60	52	비용 대비 효용이 높다고 본다.	19	\N
441	1	441	agent441	광진구	40대	남성	oppose	18	71	형평성·세금 부담 측면에서 부정적이다.	3	\N
442	1	442	agent442	동작구	60대 이상	여성	oppose	34	57	형평성·세금 부담 측면에서 부정적이다.	9	\N
443	1	443	agent443	강동구	18-29	여성	support	62	73	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-48	\N
444	1	444	agent444	강북구	30대	여성	support	97	97	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	63	\N
445	1	445	agent445	관악구	40대	여성	neutral	50	52	장단점이 비슷해 판단을 유보한다.	2	\N
446	1	446	agent446	은평구	50대	여성	support	61	70	비용 대비 효용이 높다고 본다.	26	\N
447	1	447	agent447	송파구	60대 이상	남성	oppose	29	62	재원 마련과 지속가능성에 의문을 느낀다.	-9	\N
448	1	448	agent448	강서구	60대 이상	여성	oppose	41	59	본인에게는 실익이 크지 않다고 본다.	-22	\N
449	1	449	agent449	동작구	60대 이상	남성	neutral	43	60	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-9	\N
450	1	450	agent450	강남구	18-29	여성	support	59	55	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	7	\N
451	1	451	agent451	송파구	60대 이상	남성	neutral	43	65	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-12	\N
452	1	452	agent452	강남구	40대	남성	oppose	13	66	형평성·세금 부담 측면에서 부정적이다.	-24	\N
453	1	453	agent453	동작구	40대	남성	neutral	53	61	장단점이 비슷해 판단을 유보한다.	47	\N
454	1	454	agent454	노원구	18-29	여성	support	100	85	비용 대비 효용이 높다고 본다.	14	\N
455	1	455	agent455	강동구	30대	여성	support	66	46	비용 대비 효용이 높다고 본다.	37	\N
456	1	456	agent456	강남구	18-29	여성	support	66	60	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	13	\N
457	1	457	agent457	강남구	40대	남성	oppose	27	73	우선순위가 더 높은 다른 과제가 있다고 본다.	4	\N
458	1	458	agent458	서대문구	40대	여성	neutral	55	58	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	38	\N
459	1	459	agent459	강북구	18-29	남성	support	64	70	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-43	\N
460	1	460	agent460	영등포구	60대 이상	남성	oppose	18	76	형평성·세금 부담 측면에서 부정적이다.	-15	\N
461	1	461	agent461	구로구	50대	남성	neutral	51	63	장단점이 비슷해 판단을 유보한다.	-6	\N
462	1	462	agent462	관악구	30대	여성	support	59	57	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	25	\N
463	1	463	agent463	광진구	40대	여성	oppose	38	63	형평성·세금 부담 측면에서 부정적이다.	2	\N
464	1	464	agent464	강동구	40대	남성	support	63	61	비용 대비 효용이 높다고 본다.	58	\N
465	1	465	agent465	은평구	30대	여성	support	100	89	비용 대비 효용이 높다고 본다.	-4	\N
466	1	466	agent466	광진구	18-29	여성	support	100	76	사회적 형평성 측면에서 바람직하다고 판단한다.	-7	\N
467	1	467	agent467	노원구	40대	여성	support	92	85	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-12	\N
468	1	468	agent468	광진구	30대	남성	neutral	50	51	장단점이 비슷해 판단을 유보한다.	-22	\N
469	1	469	agent469	성동구	50대	남성	support	78	77	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	9	\N
470	1	470	agent470	중랑구	60대 이상	남성	oppose	35	64	우선순위가 더 높은 다른 과제가 있다고 본다.	11	\N
471	1	471	agent471	영등포구	60대 이상	남성	oppose	0	91	본인에게는 실익이 크지 않다고 본다.	-13	\N
472	1	472	agent472	강남구	60대 이상	남성	oppose	0	90	형평성·세금 부담 측면에서 부정적이다.	-49	\N
473	1	473	agent473	동대문구	18-29	여성	support	76	82	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	16	\N
474	1	474	agent474	마포구	30대	여성	oppose	15	84	재원 마련과 지속가능성에 의문을 느낀다.	39	\N
475	1	475	agent475	용산구	40대	남성	oppose	42	54	본인에게는 실익이 크지 않다고 본다.	15	\N
476	1	476	agent476	마포구	50대	남성	neutral	53	56	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-9	\N
477	1	477	agent477	강남구	60대 이상	여성	oppose	25	60	형평성·세금 부담 측면에서 부정적이다.	22	\N
478	1	478	agent478	송파구	60대 이상	여성	oppose	41	66	형평성·세금 부담 측면에서 부정적이다.	-33	\N
479	1	479	agent479	양천구	50대	여성	neutral	55	53	추가 정보가 필요하다고 느낀다.	4	\N
480	1	480	agent480	강남구	40대	남성	oppose	30	63	재원 마련과 지속가능성에 의문을 느낀다.	11	\N
481	1	481	agent481	동작구	50대	여성	oppose	39	60	형평성·세금 부담 측면에서 부정적이다.	3	\N
482	1	482	agent482	양천구	60대 이상	여성	oppose	23	71	재원 마련과 지속가능성에 의문을 느낀다.	-25	\N
483	1	483	agent483	서초구	18-29	여성	support	65	77	비용 대비 효용이 높다고 본다.	-8	\N
484	1	484	agent484	강남구	40대	여성	neutral	44	55	장단점이 비슷해 판단을 유보한다.	-34	\N
485	1	485	agent485	강남구	60대 이상	여성	oppose	0	81	형평성·세금 부담 측면에서 부정적이다.	-4	\N
486	1	486	agent486	서초구	50대	여성	oppose	36	58	우선순위가 더 높은 다른 과제가 있다고 본다.	11	\N
487	1	487	agent487	도봉구	60대 이상	남성	oppose	2	89	우선순위가 더 높은 다른 과제가 있다고 본다.	26	\N
488	1	488	agent488	영등포구	50대	여성	oppose	33	70	재원 마련과 지속가능성에 의문을 느낀다.	0	\N
489	1	489	agent489	서초구	50대	여성	neutral	48	56	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-16	\N
490	1	490	agent490	송파구	50대	남성	oppose	10	80	우선순위가 더 높은 다른 과제가 있다고 본다.	4	\N
491	1	491	agent491	강남구	60대 이상	여성	oppose	1	74	형평성·세금 부담 측면에서 부정적이다.	-21	\N
492	1	492	agent492	강남구	18-29	여성	oppose	42	61	재원 마련과 지속가능성에 의문을 느낀다.	21	\N
493	1	493	agent493	강남구	30대	남성	neutral	54	49	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	8	\N
494	1	494	agent494	서초구	40대	남성	support	68	80	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-14	\N
495	1	495	agent495	양천구	50대	여성	neutral	47	60	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	30	\N
496	1	496	agent496	마포구	60대 이상	남성	oppose	31	71	재원 마련과 지속가능성에 의문을 느낀다.	-5	\N
497	1	497	agent497	용산구	60대 이상	남성	neutral	50	59	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	25	\N
498	1	498	agent498	광진구	60대 이상	남성	neutral	44	55	추가 정보가 필요하다고 느낀다.	36	\N
499	1	499	agent499	성동구	60대 이상	여성	oppose	2	91	재원 마련과 지속가능성에 의문을 느낀다.	-1	\N
500	1	500	agent500	강북구	60대 이상	남성	oppose	32	72	본인에게는 실익이 크지 않다고 본다.	-2	\N
501	2	1	agent1	광진구	50대	여성	oppose	40	39	본인에게는 실익이 크지 않다고 본다.	-18	\N
502	2	2	agent2	양천구	18-29	여성	support	68	61	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-16	\N
503	2	3	agent3	노원구	60대 이상	여성	oppose	14	59	형평성·세금 부담 측면에서 부정적이다.	54	\N
504	2	4	agent4	서초구	60대 이상	여성	oppose	39	67	본인에게는 실익이 크지 않다고 본다.	6	\N
505	2	5	agent5	관악구	60대 이상	남성	oppose	33	58	본인에게는 실익이 크지 않다고 본다.	-10	\N
506	2	6	agent6	서초구	60대 이상	남성	neutral	47	68	장단점이 비슷해 판단을 유보한다.	20	\N
507	2	7	agent7	송파구	60대 이상	여성	oppose	30	70	형평성·세금 부담 측면에서 부정적이다.	-28	\N
508	2	8	agent8	용산구	60대 이상	남성	oppose	35	57	형평성·세금 부담 측면에서 부정적이다.	-14	\N
509	2	9	agent9	강남구	60대 이상	여성	oppose	28	58	우선순위가 더 높은 다른 과제가 있다고 본다.	28	\N
510	2	10	agent10	관악구	40대	여성	neutral	44	62	장단점이 비슷해 판단을 유보한다.	6	\N
511	2	11	agent11	서대문구	18-29	여성	support	70	39	비용 대비 효용이 높다고 본다.	2	\N
512	2	12	agent12	광진구	50대	여성	neutral	47	67	추가 정보가 필요하다고 느낀다.	36	\N
513	2	13	agent13	성동구	60대 이상	여성	oppose	33	58	형평성·세금 부담 측면에서 부정적이다.	-23	\N
514	2	14	agent14	송파구	18-29	남성	support	76	64	사회적 형평성 측면에서 바람직하다고 판단한다.	-6	\N
515	2	15	agent15	강남구	30대	여성	neutral	50	44	장단점이 비슷해 판단을 유보한다.	-3	\N
516	2	16	agent16	동작구	60대 이상	남성	oppose	32	65	본인에게는 실익이 크지 않다고 본다.	48	\N
517	2	17	agent17	중랑구	50대	남성	oppose	24	63	형평성·세금 부담 측면에서 부정적이다.	-16	\N
518	2	18	agent18	구로구	60대 이상	여성	oppose	30	61	형평성·세금 부담 측면에서 부정적이다.	-4	\N
519	2	19	agent19	도봉구	60대 이상	남성	oppose	13	86	형평성·세금 부담 측면에서 부정적이다.	9	\N
520	2	20	agent20	금천구	50대	여성	oppose	28	58	본인에게는 실익이 크지 않다고 본다.	32	\N
521	2	21	agent21	강동구	50대	남성	oppose	41	68	재원 마련과 지속가능성에 의문을 느낀다.	-36	\N
522	2	22	agent22	영등포구	18-29	남성	support	82	68	사회적 형평성 측면에서 바람직하다고 판단한다.	-3	\N
523	2	23	agent23	성동구	60대 이상	여성	oppose	34	54	본인에게는 실익이 크지 않다고 본다.	-32	\N
524	2	24	agent24	은평구	60대 이상	여성	oppose	32	64	우선순위가 더 높은 다른 과제가 있다고 본다.	0	\N
525	2	25	agent25	성북구	60대 이상	여성	neutral	44	49	장단점이 비슷해 판단을 유보한다.	-28	\N
526	2	26	agent26	은평구	30대	남성	neutral	49	51	추가 정보가 필요하다고 느낀다.	-31	\N
527	2	27	agent27	양천구	50대	여성	oppose	40	59	본인에게는 실익이 크지 않다고 본다.	27	\N
528	2	28	agent28	양천구	50대	남성	neutral	44	56	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	26	\N
529	2	29	agent29	중랑구	30대	남성	support	71	72	사회적 형평성 측면에서 바람직하다고 판단한다.	28	\N
531	2	31	agent31	강남구	60대 이상	여성	neutral	49	60	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	8	\N
532	2	32	agent32	노원구	50대	남성	oppose	30	66	형평성·세금 부담 측면에서 부정적이다.	21	\N
533	2	33	agent33	중구	40대	여성	oppose	40	61	본인에게는 실익이 크지 않다고 본다.	-22	\N
534	2	34	agent34	동작구	50대	남성	oppose	9	74	본인에게는 실익이 크지 않다고 본다.	-12	\N
535	2	35	agent35	광진구	18-29	남성	support	59	64	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	26	\N
536	2	36	agent36	강남구	60대 이상	남성	neutral	45	66	장단점이 비슷해 판단을 유보한다.	13	\N
537	2	37	agent37	마포구	50대	남성	neutral	57	46	추가 정보가 필요하다고 느낀다.	-38	\N
538	2	38	agent38	구로구	40대	여성	support	69	58	사회적 형평성 측면에서 바람직하다고 판단한다.	-2	\N
539	2	39	agent39	관악구	30대	여성	neutral	45	55	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-28	\N
540	2	40	agent40	서대문구	18-29	여성	support	92	78	사회적 형평성 측면에서 바람직하다고 판단한다.	-8	\N
541	2	41	agent41	은평구	60대 이상	여성	oppose	39	51	본인에게는 실익이 크지 않다고 본다.	-8	\N
542	2	42	agent42	노원구	50대	남성	support	60	57	사회적 형평성 측면에서 바람직하다고 판단한다.	-12	\N
543	2	43	agent43	서초구	60대 이상	여성	oppose	31	61	형평성·세금 부담 측면에서 부정적이다.	30	\N
544	2	44	agent44	노원구	60대 이상	여성	oppose	40	63	재원 마련과 지속가능성에 의문을 느낀다.	-12	\N
545	2	45	agent45	노원구	60대 이상	여성	oppose	3	83	우선순위가 더 높은 다른 과제가 있다고 본다.	8	\N
546	2	46	agent46	용산구	18-29	여성	support	69	71	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	33	\N
547	2	47	agent47	광진구	50대	여성	neutral	44	45	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-47	\N
548	2	48	agent48	성북구	30대	여성	support	86	77	사회적 형평성 측면에서 바람직하다고 판단한다.	3	\N
549	2	49	agent49	노원구	40대	남성	oppose	40	67	재원 마련과 지속가능성에 의문을 느낀다.	40	\N
550	2	50	agent50	강남구	50대	남성	neutral	51	58	장단점이 비슷해 판단을 유보한다.	14	\N
551	2	51	agent51	중구	40대	여성	support	63	61	비용 대비 효용이 높다고 본다.	-39	\N
552	2	52	agent52	은평구	50대	남성	neutral	56	63	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	38	\N
553	2	53	agent53	양천구	18-29	여성	neutral	51	52	장단점이 비슷해 판단을 유보한다.	23	\N
554	2	54	agent54	서대문구	60대 이상	남성	neutral	46	54	장단점이 비슷해 판단을 유보한다.	75	\N
555	2	55	agent55	금천구	60대 이상	여성	oppose	24	72	우선순위가 더 높은 다른 과제가 있다고 본다.	-22	\N
556	2	56	agent56	송파구	18-29	남성	support	74	79	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-9	\N
557	2	57	agent57	동대문구	60대 이상	남성	oppose	24	68	형평성·세금 부담 측면에서 부정적이다.	11	\N
558	2	58	agent58	동작구	60대 이상	여성	oppose	17	77	본인에게는 실익이 크지 않다고 본다.	6	\N
559	2	59	agent59	송파구	40대	여성	support	58	60	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-23	\N
560	2	60	agent60	송파구	60대 이상	남성	oppose	41	61	형평성·세금 부담 측면에서 부정적이다.	36	\N
561	2	61	agent61	송파구	60대 이상	남성	oppose	29	66	우선순위가 더 높은 다른 과제가 있다고 본다.	51	\N
562	2	62	agent62	강남구	50대	남성	neutral	45	57	추가 정보가 필요하다고 느낀다.	36	\N
563	2	63	agent63	광진구	60대 이상	여성	oppose	37	70	본인에게는 실익이 크지 않다고 본다.	-33	\N
564	2	64	agent64	도봉구	60대 이상	남성	oppose	21	79	우선순위가 더 높은 다른 과제가 있다고 본다.	29	\N
565	2	65	agent65	관악구	30대	여성	neutral	56	60	장단점이 비슷해 판단을 유보한다.	-44	\N
566	2	66	agent66	강북구	50대	남성	oppose	35	65	재원 마련과 지속가능성에 의문을 느낀다.	28	\N
618	2	118	agent118	관악구	18-29	여성	support	80	78	비용 대비 효용이 높다고 본다.	-50	\N
567	2	67	agent67	성북구	60대 이상	여성	neutral	54	54	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-17	\N
568	2	68	agent68	강서구	40대	남성	oppose	37	62	우선순위가 더 높은 다른 과제가 있다고 본다.	-24	\N
569	2	69	agent69	광진구	18-29	남성	support	70	60	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	43	\N
570	2	70	agent70	양천구	18-29	남성	neutral	57	55	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-22	\N
571	2	71	agent71	강서구	50대	여성	oppose	40	72	재원 마련과 지속가능성에 의문을 느낀다.	-28	\N
572	2	72	agent72	강남구	18-29	여성	support	62	62	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	5	\N
573	2	73	agent73	관악구	50대	여성	neutral	52	50	장단점이 비슷해 판단을 유보한다.	62	\N
574	2	74	agent74	송파구	60대 이상	여성	neutral	43	50	추가 정보가 필요하다고 느낀다.	-16	\N
575	2	75	agent75	도봉구	40대	여성	oppose	35	59	본인에게는 실익이 크지 않다고 본다.	-56	\N
576	2	76	agent76	은평구	40대	남성	neutral	51	54	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	45	\N
577	2	77	agent77	구로구	40대	남성	oppose	37	71	본인에게는 실익이 크지 않다고 본다.	30	\N
578	2	78	agent78	중랑구	18-29	남성	neutral	57	68	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	35	\N
579	2	79	agent79	중랑구	60대 이상	여성	oppose	27	74	본인에게는 실익이 크지 않다고 본다.	-5	\N
580	2	80	agent80	영등포구	18-29	여성	neutral	57	59	장단점이 비슷해 판단을 유보한다.	12	\N
581	2	81	agent81	강동구	60대 이상	남성	oppose	9	71	본인에게는 실익이 크지 않다고 본다.	-41	\N
582	2	82	agent82	강서구	18-29	남성	support	73	75	사회적 형평성 측면에서 바람직하다고 판단한다.	-3	\N
583	2	83	agent83	강서구	50대	여성	oppose	38	43	형평성·세금 부담 측면에서 부정적이다.	10	\N
584	2	84	agent84	도봉구	60대 이상	남성	oppose	19	81	우선순위가 더 높은 다른 과제가 있다고 본다.	70	\N
585	2	85	agent85	서초구	18-29	남성	oppose	38	58	재원 마련과 지속가능성에 의문을 느낀다.	-46	\N
586	2	86	agent86	광진구	60대 이상	여성	support	71	78	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-5	\N
587	2	87	agent87	강동구	60대 이상	여성	oppose	13	71	재원 마련과 지속가능성에 의문을 느낀다.	28	\N
588	2	88	agent88	금천구	18-29	여성	oppose	41	49	형평성·세금 부담 측면에서 부정적이다.	-19	\N
589	2	89	agent89	마포구	50대	남성	neutral	53	50	추가 정보가 필요하다고 느낀다.	32	\N
590	2	90	agent90	마포구	50대	여성	neutral	50	69	장단점이 비슷해 판단을 유보한다.	-61	\N
591	2	91	agent91	양천구	60대 이상	남성	oppose	29	63	재원 마련과 지속가능성에 의문을 느낀다.	-26	\N
592	2	92	agent92	노원구	40대	여성	neutral	53	69	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	17	\N
593	2	93	agent93	중랑구	60대 이상	남성	oppose	33	69	우선순위가 더 높은 다른 과제가 있다고 본다.	2	\N
594	2	94	agent94	구로구	60대 이상	여성	oppose	18	69	형평성·세금 부담 측면에서 부정적이다.	20	\N
595	2	95	agent95	강서구	18-29	남성	support	66	60	사회적 형평성 측면에서 바람직하다고 판단한다.	3	\N
596	2	96	agent96	성동구	30대	남성	neutral	51	60	장단점이 비슷해 판단을 유보한다.	-53	\N
597	2	97	agent97	종로구	18-29	남성	support	77	69	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-7	\N
598	2	98	agent98	강북구	18-29	여성	support	61	62	비용 대비 효용이 높다고 본다.	-6	\N
599	2	99	agent99	양천구	60대 이상	남성	oppose	7	79	우선순위가 더 높은 다른 과제가 있다고 본다.	-25	\N
600	2	100	agent100	도봉구	40대	남성	neutral	46	72	추가 정보가 필요하다고 느낀다.	-29	\N
601	2	101	agent101	강동구	30대	남성	neutral	47	48	장단점이 비슷해 판단을 유보한다.	-51	\N
602	2	102	agent102	은평구	60대 이상	남성	neutral	46	68	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-19	\N
603	2	103	agent103	강남구	60대 이상	남성	oppose	42	61	본인에게는 실익이 크지 않다고 본다.	-37	\N
604	2	104	agent104	송파구	18-29	남성	support	63	49	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-19	\N
605	2	105	agent105	강남구	30대	여성	neutral	49	49	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-6	\N
606	2	106	agent106	송파구	60대 이상	남성	neutral	51	49	장단점이 비슷해 판단을 유보한다.	35	\N
607	2	107	agent107	송파구	30대	남성	support	67	62	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-10	\N
608	2	108	agent108	도봉구	30대	남성	support	66	71	비용 대비 효용이 높다고 본다.	1	\N
609	2	109	agent109	노원구	50대	남성	neutral	49	49	장단점이 비슷해 판단을 유보한다.	52	\N
610	2	110	agent110	성북구	18-29	남성	support	74	74	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-5	\N
611	2	111	agent111	양천구	18-29	여성	support	62	64	사회적 형평성 측면에서 바람직하다고 판단한다.	44	\N
612	2	112	agent112	서대문구	30대	남성	neutral	55	57	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	46	\N
613	2	113	agent113	동대문구	60대 이상	여성	oppose	23	58	형평성·세금 부담 측면에서 부정적이다.	-13	\N
614	2	114	agent114	관악구	40대	남성	support	80	64	비용 대비 효용이 높다고 본다.	7	\N
615	2	115	agent115	강서구	50대	남성	neutral	43	54	장단점이 비슷해 판단을 유보한다.	-23	\N
616	2	116	agent116	강남구	40대	남성	oppose	37	69	우선순위가 더 높은 다른 과제가 있다고 본다.	-20	\N
617	2	117	agent117	동대문구	50대	남성	oppose	34	48	우선순위가 더 높은 다른 과제가 있다고 본다.	-1	\N
619	2	119	agent119	관악구	50대	여성	neutral	46	58	추가 정보가 필요하다고 느낀다.	38	\N
620	2	120	agent120	동대문구	18-29	여성	support	72	75	사회적 형평성 측면에서 바람직하다고 판단한다.	-38	\N
621	2	121	agent121	중랑구	40대	여성	neutral	55	57	추가 정보가 필요하다고 느낀다.	-17	\N
622	2	122	agent122	관악구	30대	남성	support	66	65	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	40	\N
623	2	123	agent123	송파구	60대 이상	남성	oppose	38	59	우선순위가 더 높은 다른 과제가 있다고 본다.	3	\N
624	2	124	agent124	중랑구	50대	여성	neutral	48	53	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	39	\N
625	2	125	agent125	성동구	18-29	남성	support	71	59	사회적 형평성 측면에서 바람직하다고 판단한다.	38	\N
626	2	126	agent126	구로구	30대	남성	neutral	52	57	장단점이 비슷해 판단을 유보한다.	52	\N
627	2	127	agent127	금천구	60대 이상	남성	oppose	21	74	재원 마련과 지속가능성에 의문을 느낀다.	-30	\N
628	2	128	agent128	양천구	60대 이상	남성	oppose	33	66	본인에게는 실익이 크지 않다고 본다.	17	\N
629	2	129	agent129	노원구	50대	남성	neutral	50	44	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	36	\N
630	2	130	agent130	서초구	50대	여성	neutral	57	53	추가 정보가 필요하다고 느낀다.	19	\N
631	2	131	agent131	강서구	30대	여성	support	60	55	사회적 형평성 측면에서 바람직하다고 판단한다.	-19	\N
632	2	132	agent132	동작구	50대	여성	oppose	17	77	재원 마련과 지속가능성에 의문을 느낀다.	-13	\N
633	2	133	agent133	금천구	60대 이상	여성	oppose	29	63	우선순위가 더 높은 다른 과제가 있다고 본다.	-9	\N
634	2	134	agent134	강남구	60대 이상	남성	oppose	19	70	형평성·세금 부담 측면에서 부정적이다.	10	\N
635	2	135	agent135	양천구	18-29	남성	neutral	43	70	추가 정보가 필요하다고 느낀다.	-16	\N
636	2	136	agent136	구로구	40대	남성	support	67	60	사회적 형평성 측면에서 바람직하다고 판단한다.	-19	\N
637	2	137	agent137	구로구	18-29	여성	oppose	42	62	본인에게는 실익이 크지 않다고 본다.	-35	\N
638	2	138	agent138	도봉구	30대	여성	support	66	66	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	5	\N
639	2	139	agent139	도봉구	60대 이상	여성	oppose	26	81	본인에게는 실익이 크지 않다고 본다.	65	\N
640	2	140	agent140	서대문구	50대	여성	neutral	45	58	장단점이 비슷해 판단을 유보한다.	0	\N
641	2	141	agent141	중랑구	60대 이상	남성	oppose	36	61	재원 마련과 지속가능성에 의문을 느낀다.	46	\N
642	2	142	agent142	성동구	60대 이상	여성	oppose	39	71	재원 마련과 지속가능성에 의문을 느낀다.	-12	\N
643	2	143	agent143	송파구	30대	남성	support	74	59	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-26	\N
644	2	144	agent144	강서구	40대	남성	neutral	51	67	추가 정보가 필요하다고 느낀다.	34	\N
645	2	145	agent145	강서구	40대	여성	oppose	34	67	본인에게는 실익이 크지 않다고 본다.	19	\N
646	2	146	agent146	영등포구	60대 이상	남성	oppose	10	73	본인에게는 실익이 크지 않다고 본다.	41	\N
647	2	147	agent147	강북구	40대	여성	support	78	64	사회적 형평성 측면에서 바람직하다고 판단한다.	41	\N
648	2	148	agent148	동대문구	18-29	여성	support	68	62	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-16	\N
649	2	149	agent149	영등포구	60대 이상	남성	neutral	43	55	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-43	\N
650	2	150	agent150	서초구	60대 이상	남성	oppose	36	58	우선순위가 더 높은 다른 과제가 있다고 본다.	7	\N
651	2	151	agent151	동작구	60대 이상	남성	oppose	16	69	우선순위가 더 높은 다른 과제가 있다고 본다.	-13	\N
652	2	152	agent152	구로구	60대 이상	남성	oppose	34	76	우선순위가 더 높은 다른 과제가 있다고 본다.	-12	\N
653	2	153	agent153	노원구	40대	남성	neutral	47	64	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	10	\N
654	2	154	agent154	양천구	60대 이상	여성	oppose	33	68	재원 마련과 지속가능성에 의문을 느낀다.	-29	\N
655	2	155	agent155	동대문구	60대 이상	여성	oppose	10	70	우선순위가 더 높은 다른 과제가 있다고 본다.	-2	\N
656	2	156	agent156	노원구	30대	여성	support	59	58	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-52	\N
657	2	157	agent157	노원구	60대 이상	남성	oppose	36	76	형평성·세금 부담 측면에서 부정적이다.	-13	\N
658	2	158	agent158	동대문구	60대 이상	여성	oppose	42	59	형평성·세금 부담 측면에서 부정적이다.	-4	\N
659	2	159	agent159	영등포구	18-29	남성	support	68	56	비용 대비 효용이 높다고 본다.	25	\N
660	2	160	agent160	관악구	60대 이상	여성	oppose	30	61	본인에게는 실익이 크지 않다고 본다.	-5	\N
661	2	161	agent161	영등포구	18-29	남성	support	58	56	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	4	\N
662	2	162	agent162	동작구	50대	남성	neutral	48	58	추가 정보가 필요하다고 느낀다.	-27	\N
663	2	163	agent163	관악구	30대	여성	neutral	56	60	장단점이 비슷해 판단을 유보한다.	70	\N
664	2	164	agent164	영등포구	40대	남성	neutral	53	61	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	28	\N
665	2	165	agent165	양천구	60대 이상	여성	oppose	26	85	재원 마련과 지속가능성에 의문을 느낀다.	-25	\N
666	2	166	agent166	성동구	60대 이상	여성	oppose	9	74	본인에게는 실익이 크지 않다고 본다.	-35	\N
667	2	167	agent167	용산구	18-29	남성	support	68	83	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-31	\N
668	2	168	agent168	종로구	60대 이상	남성	oppose	17	84	재원 마련과 지속가능성에 의문을 느낀다.	9	\N
669	2	169	agent169	강서구	50대	남성	neutral	54	68	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-22	\N
670	2	170	agent170	송파구	60대 이상	여성	neutral	45	44	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	8	\N
671	2	171	agent171	동대문구	60대 이상	여성	neutral	50	46	장단점이 비슷해 판단을 유보한다.	26	\N
672	2	172	agent172	종로구	30대	여성	oppose	27	61	재원 마련과 지속가능성에 의문을 느낀다.	-59	\N
673	2	173	agent173	구로구	60대 이상	여성	oppose	22	76	재원 마련과 지속가능성에 의문을 느낀다.	-21	\N
674	2	174	agent174	노원구	60대 이상	남성	oppose	36	63	본인에게는 실익이 크지 않다고 본다.	76	\N
675	2	175	agent175	은평구	30대	여성	support	65	69	비용 대비 효용이 높다고 본다.	7	\N
676	2	176	agent176	강남구	18-29	남성	neutral	53	58	장단점이 비슷해 판단을 유보한다.	45	\N
677	2	177	agent177	관악구	50대	남성	neutral	54	69	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-2	\N
678	2	178	agent178	도봉구	40대	남성	neutral	46	68	장단점이 비슷해 판단을 유보한다.	-8	\N
679	2	179	agent179	은평구	60대 이상	여성	oppose	35	59	우선순위가 더 높은 다른 과제가 있다고 본다.	32	\N
680	2	180	agent180	강북구	18-29	남성	support	79	67	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	1	\N
681	2	181	agent181	강동구	18-29	여성	support	62	69	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	3	\N
682	2	182	agent182	은평구	40대	남성	neutral	57	57	추가 정보가 필요하다고 느낀다.	25	\N
683	2	183	agent183	동작구	40대	남성	neutral	53	54	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-22	\N
684	2	184	agent184	중구	18-29	남성	neutral	49	56	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-4	\N
685	2	185	agent185	마포구	60대 이상	여성	oppose	36	75	재원 마련과 지속가능성에 의문을 느낀다.	-24	\N
686	2	186	agent186	서초구	60대 이상	여성	oppose	0	99	우선순위가 더 높은 다른 과제가 있다고 본다.	32	\N
687	2	187	agent187	마포구	18-29	남성	support	73	62	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	12	\N
688	2	188	agent188	강서구	18-29	남성	support	62	71	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-18	\N
689	2	189	agent189	동작구	50대	여성	oppose	39	69	본인에게는 실익이 크지 않다고 본다.	-24	\N
690	2	190	agent190	강서구	50대	남성	support	70	49	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	38	\N
691	2	191	agent191	송파구	30대	여성	neutral	52	59	추가 정보가 필요하다고 느낀다.	-7	\N
692	2	192	agent192	강동구	60대 이상	남성	oppose	16	86	형평성·세금 부담 측면에서 부정적이다.	-22	\N
693	2	193	agent193	관악구	50대	여성	support	60	67	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-29	\N
694	2	194	agent194	양천구	30대	남성	support	83	68	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	18	\N
695	2	195	agent195	강서구	30대	남성	support	74	62	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	1	\N
696	2	196	agent196	종로구	50대	남성	oppose	42	45	우선순위가 더 높은 다른 과제가 있다고 본다.	9	\N
697	2	197	agent197	종로구	18-29	여성	neutral	53	59	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-59	\N
698	2	198	agent198	구로구	30대	여성	support	79	79	비용 대비 효용이 높다고 본다.	8	\N
699	2	199	agent199	영등포구	30대	여성	support	63	50	사회적 형평성 측면에서 바람직하다고 판단한다.	-9	\N
700	2	200	agent200	마포구	60대 이상	여성	oppose	19	64	형평성·세금 부담 측면에서 부정적이다.	-16	\N
701	2	201	agent201	성동구	60대 이상	여성	oppose	24	77	우선순위가 더 높은 다른 과제가 있다고 본다.	17	\N
702	2	202	agent202	강서구	60대 이상	남성	oppose	10	79	우선순위가 더 높은 다른 과제가 있다고 본다.	-35	\N
703	2	203	agent203	서대문구	30대	여성	support	73	57	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-11	\N
704	2	204	agent204	성동구	30대	여성	support	65	76	비용 대비 효용이 높다고 본다.	-1	\N
705	2	205	agent205	양천구	40대	여성	support	69	62	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	37	\N
706	2	206	agent206	관악구	50대	여성	neutral	44	64	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	6	\N
707	2	207	agent207	관악구	60대 이상	남성	oppose	29	71	재원 마련과 지속가능성에 의문을 느낀다.	38	\N
708	2	208	agent208	관악구	40대	여성	neutral	49	55	장단점이 비슷해 판단을 유보한다.	49	\N
709	2	209	agent209	광진구	30대	여성	oppose	41	58	본인에게는 실익이 크지 않다고 본다.	-25	\N
710	2	210	agent210	도봉구	18-29	남성	support	58	69	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-4	\N
711	2	211	agent211	강서구	60대 이상	남성	oppose	26	68	형평성·세금 부담 측면에서 부정적이다.	48	\N
712	2	212	agent212	강남구	60대 이상	여성	oppose	29	60	재원 마련과 지속가능성에 의문을 느낀다.	-40	\N
713	2	213	agent213	강동구	60대 이상	남성	oppose	38	62	재원 마련과 지속가능성에 의문을 느낀다.	13	\N
714	2	214	agent214	광진구	60대 이상	여성	oppose	39	59	형평성·세금 부담 측면에서 부정적이다.	-35	\N
715	2	215	agent215	강남구	50대	여성	neutral	54	63	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	26	\N
716	2	216	agent216	강남구	40대	남성	neutral	55	61	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	33	\N
717	2	217	agent217	강동구	30대	여성	support	67	51	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	4	\N
718	2	218	agent218	중구	30대	여성	support	67	73	비용 대비 효용이 높다고 본다.	30	\N
719	2	219	agent219	동작구	18-29	남성	support	72	59	비용 대비 효용이 높다고 본다.	27	\N
720	2	220	agent220	양천구	30대	여성	neutral	53	64	추가 정보가 필요하다고 느낀다.	30	\N
721	2	221	agent221	금천구	30대	남성	neutral	51	51	장단점이 비슷해 판단을 유보한다.	21	\N
722	2	222	agent222	강남구	50대	여성	neutral	56	44	장단점이 비슷해 판단을 유보한다.	17	\N
723	2	223	agent223	송파구	40대	여성	neutral	54	49	장단점이 비슷해 판단을 유보한다.	-2	\N
724	2	224	agent224	은평구	60대 이상	남성	oppose	34	81	재원 마련과 지속가능성에 의문을 느낀다.	60	\N
725	2	225	agent225	노원구	60대 이상	여성	oppose	24	64	본인에게는 실익이 크지 않다고 본다.	7	\N
726	2	226	agent226	양천구	60대 이상	여성	oppose	16	82	우선순위가 더 높은 다른 과제가 있다고 본다.	25	\N
727	2	227	agent227	강서구	60대 이상	남성	oppose	21	71	본인에게는 실익이 크지 않다고 본다.	-27	\N
728	2	228	agent228	구로구	60대 이상	여성	oppose	24	68	본인에게는 실익이 크지 않다고 본다.	-5	\N
729	2	229	agent229	강북구	60대 이상	남성	oppose	38	45	우선순위가 더 높은 다른 과제가 있다고 본다.	2	\N
730	2	230	agent230	동작구	60대 이상	남성	oppose	37	67	재원 마련과 지속가능성에 의문을 느낀다.	45	\N
731	2	231	agent231	강남구	18-29	남성	support	63	60	비용 대비 효용이 높다고 본다.	-5	\N
732	2	232	agent232	관악구	30대	여성	support	70	75	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-8	\N
733	2	233	agent233	성북구	30대	여성	support	67	71	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-3	\N
734	2	234	agent234	강북구	60대 이상	여성	oppose	29	72	우선순위가 더 높은 다른 과제가 있다고 본다.	5	\N
735	2	235	agent235	은평구	60대 이상	여성	oppose	27	68	재원 마련과 지속가능성에 의문을 느낀다.	-28	\N
736	2	236	agent236	마포구	18-29	여성	support	75	83	비용 대비 효용이 높다고 본다.	25	\N
737	2	237	agent237	강북구	60대 이상	여성	oppose	39	65	형평성·세금 부담 측면에서 부정적이다.	-27	\N
738	2	238	agent238	종로구	50대	여성	support	62	64	비용 대비 효용이 높다고 본다.	-35	\N
739	2	239	agent239	강남구	50대	여성	neutral	49	51	장단점이 비슷해 판단을 유보한다.	-6	\N
740	2	240	agent240	송파구	18-29	남성	support	80	66	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-65	\N
741	2	241	agent241	노원구	50대	여성	neutral	46	57	추가 정보가 필요하다고 느낀다.	88	\N
742	2	242	agent242	금천구	30대	여성	support	69	58	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	33	\N
743	2	243	agent243	동대문구	60대 이상	남성	oppose	35	56	형평성·세금 부담 측면에서 부정적이다.	-15	\N
744	2	244	agent244	양천구	60대 이상	여성	oppose	19	63	우선순위가 더 높은 다른 과제가 있다고 본다.	-45	\N
745	2	245	agent245	관악구	30대	남성	support	67	55	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	30	\N
746	2	246	agent246	서대문구	60대 이상	남성	oppose	33	76	재원 마련과 지속가능성에 의문을 느낀다.	23	\N
747	2	247	agent247	영등포구	40대	남성	support	64	64	비용 대비 효용이 높다고 본다.	42	\N
748	2	248	agent248	도봉구	60대 이상	여성	support	60	55	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	0	\N
749	2	249	agent249	양천구	30대	여성	neutral	50	47	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	54	\N
750	2	250	agent250	송파구	30대	여성	support	74	72	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	24	\N
751	2	251	agent251	송파구	30대	여성	neutral	50	57	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-25	\N
752	2	252	agent252	마포구	18-29	남성	support	64	73	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-27	\N
753	2	253	agent253	도봉구	30대	여성	support	64	66	사회적 형평성 측면에서 바람직하다고 판단한다.	3	\N
754	2	254	agent254	광진구	30대	여성	neutral	54	48	장단점이 비슷해 판단을 유보한다.	25	\N
755	2	255	agent255	광진구	30대	여성	neutral	51	62	장단점이 비슷해 판단을 유보한다.	14	\N
756	2	256	agent256	용산구	50대	남성	oppose	41	82	형평성·세금 부담 측면에서 부정적이다.	71	\N
757	2	257	agent257	마포구	18-29	남성	neutral	56	49	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	59	\N
758	2	258	agent258	강남구	60대 이상	여성	oppose	38	66	형평성·세금 부담 측면에서 부정적이다.	29	\N
759	2	259	agent259	양천구	30대	남성	support	62	53	비용 대비 효용이 높다고 본다.	16	\N
760	2	260	agent260	강남구	30대	여성	support	67	65	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	67	\N
761	2	261	agent261	용산구	50대	남성	neutral	51	55	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-48	\N
762	2	262	agent262	동대문구	40대	여성	support	64	68	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-3	\N
763	2	263	agent263	도봉구	18-29	남성	neutral	50	57	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-2	\N
764	2	264	agent264	동작구	40대	남성	oppose	39	69	재원 마련과 지속가능성에 의문을 느낀다.	-23	\N
765	2	265	agent265	도봉구	60대 이상	여성	oppose	28	76	우선순위가 더 높은 다른 과제가 있다고 본다.	10	\N
766	2	266	agent266	성북구	50대	여성	neutral	49	60	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	17	\N
767	2	267	agent267	송파구	50대	남성	oppose	36	64	우선순위가 더 높은 다른 과제가 있다고 본다.	-11	\N
768	2	268	agent268	구로구	40대	여성	neutral	54	52	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	3	\N
769	2	269	agent269	동작구	60대 이상	여성	oppose	30	73	재원 마련과 지속가능성에 의문을 느낀다.	8	\N
770	2	270	agent270	노원구	30대	남성	neutral	49	52	추가 정보가 필요하다고 느낀다.	40	\N
771	2	271	agent271	광진구	60대 이상	여성	oppose	24	77	형평성·세금 부담 측면에서 부정적이다.	-2	\N
772	2	272	agent272	동작구	40대	남성	oppose	40	57	본인에게는 실익이 크지 않다고 본다.	-29	\N
773	2	273	agent273	양천구	40대	남성	oppose	34	75	본인에게는 실익이 크지 않다고 본다.	-12	\N
774	2	274	agent274	서초구	18-29	남성	oppose	36	69	형평성·세금 부담 측면에서 부정적이다.	16	\N
775	2	275	agent275	양천구	60대 이상	남성	oppose	11	85	형평성·세금 부담 측면에서 부정적이다.	4	\N
776	2	276	agent276	관악구	18-29	여성	support	64	69	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-36	\N
777	2	277	agent277	강동구	60대 이상	여성	oppose	26	71	본인에게는 실익이 크지 않다고 본다.	-47	\N
778	2	278	agent278	관악구	60대 이상	여성	oppose	19	69	본인에게는 실익이 크지 않다고 본다.	-15	\N
779	2	279	agent279	강남구	50대	여성	neutral	51	47	장단점이 비슷해 판단을 유보한다.	-35	\N
780	2	280	agent280	노원구	40대	여성	oppose	32	74	재원 마련과 지속가능성에 의문을 느낀다.	-42	\N
781	2	281	agent281	용산구	18-29	여성	neutral	54	59	추가 정보가 필요하다고 느낀다.	-5	\N
782	2	282	agent282	동작구	18-29	여성	support	64	45	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	0	\N
783	2	283	agent283	성동구	30대	여성	neutral	52	57	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-14	\N
784	2	284	agent284	강남구	60대 이상	남성	neutral	46	48	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-5	\N
785	2	285	agent285	서초구	50대	여성	neutral	55	57	장단점이 비슷해 판단을 유보한다.	-45	\N
786	2	286	agent286	용산구	18-29	남성	neutral	51	52	장단점이 비슷해 판단을 유보한다.	-57	\N
787	2	287	agent287	동대문구	40대	남성	neutral	52	63	추가 정보가 필요하다고 느낀다.	5	\N
788	2	288	agent288	동대문구	40대	여성	neutral	48	57	장단점이 비슷해 판단을 유보한다.	-37	\N
789	2	289	agent289	서초구	18-29	남성	support	75	81	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-30	\N
790	2	290	agent290	강북구	60대 이상	여성	oppose	15	75	재원 마련과 지속가능성에 의문을 느낀다.	-50	\N
791	2	291	agent291	중랑구	60대 이상	남성	oppose	5	99	우선순위가 더 높은 다른 과제가 있다고 본다.	-64	\N
792	2	292	agent292	종로구	40대	여성	oppose	35	76	형평성·세금 부담 측면에서 부정적이다.	-10	\N
793	2	293	agent293	동작구	60대 이상	남성	oppose	29	62	재원 마련과 지속가능성에 의문을 느낀다.	11	\N
794	2	294	agent294	양천구	60대 이상	남성	neutral	43	51	장단점이 비슷해 판단을 유보한다.	33	\N
795	2	295	agent295	서대문구	18-29	여성	support	73	69	비용 대비 효용이 높다고 본다.	-3	\N
796	2	296	agent296	용산구	18-29	여성	support	82	78	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-28	\N
797	2	297	agent297	강남구	60대 이상	여성	oppose	21	68	형평성·세금 부담 측면에서 부정적이다.	-46	\N
798	2	298	agent298	구로구	30대	남성	oppose	34	75	재원 마련과 지속가능성에 의문을 느낀다.	41	\N
799	2	299	agent299	관악구	30대	남성	neutral	51	44	장단점이 비슷해 판단을 유보한다.	6	\N
800	2	300	agent300	서초구	60대 이상	남성	oppose	22	84	재원 마련과 지속가능성에 의문을 느낀다.	-8	\N
801	2	301	agent301	서초구	40대	여성	neutral	46	70	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-2	\N
802	2	302	agent302	양천구	60대 이상	여성	oppose	26	72	재원 마련과 지속가능성에 의문을 느낀다.	-50	\N
803	2	303	agent303	서대문구	60대 이상	남성	neutral	47	56	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	8	\N
804	2	304	agent304	성동구	18-29	남성	support	79	81	비용 대비 효용이 높다고 본다.	36	\N
805	2	305	agent305	관악구	30대	여성	support	64	51	비용 대비 효용이 높다고 본다.	5	\N
806	2	306	agent306	동작구	60대 이상	남성	oppose	10	73	우선순위가 더 높은 다른 과제가 있다고 본다.	9	\N
807	2	307	agent307	관악구	60대 이상	남성	oppose	38	53	형평성·세금 부담 측면에서 부정적이다.	12	\N
808	2	308	agent308	마포구	60대 이상	남성	oppose	41	45	본인에게는 실익이 크지 않다고 본다.	-19	\N
809	2	309	agent309	송파구	18-29	여성	support	64	45	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	25	\N
810	2	310	agent310	마포구	50대	남성	oppose	41	48	우선순위가 더 높은 다른 과제가 있다고 본다.	-22	\N
811	2	311	agent311	은평구	60대 이상	남성	oppose	25	66	형평성·세금 부담 측면에서 부정적이다.	11	\N
812	2	312	agent312	강동구	60대 이상	남성	oppose	11	83	우선순위가 더 높은 다른 과제가 있다고 본다.	27	\N
813	2	313	agent313	성북구	60대 이상	여성	oppose	24	65	형평성·세금 부담 측면에서 부정적이다.	-33	\N
814	2	314	agent314	강동구	50대	남성	oppose	29	58	재원 마련과 지속가능성에 의문을 느낀다.	-25	\N
815	2	315	agent315	광진구	60대 이상	여성	support	60	61	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	40	\N
816	2	316	agent316	서초구	60대 이상	남성	oppose	39	68	재원 마련과 지속가능성에 의문을 느낀다.	0	\N
817	2	317	agent317	서초구	40대	여성	neutral	43	68	추가 정보가 필요하다고 느낀다.	3	\N
818	2	318	agent318	강서구	40대	남성	oppose	30	64	본인에게는 실익이 크지 않다고 본다.	43	\N
819	2	319	agent319	강서구	50대	여성	neutral	44	53	장단점이 비슷해 판단을 유보한다.	-15	\N
820	2	320	agent320	관악구	60대 이상	남성	oppose	42	55	형평성·세금 부담 측면에서 부정적이다.	32	\N
821	2	321	agent321	중랑구	60대 이상	여성	neutral	44	71	추가 정보가 필요하다고 느낀다.	6	\N
822	2	322	agent322	관악구	50대	남성	oppose	33	82	본인에게는 실익이 크지 않다고 본다.	-7	\N
823	2	323	agent323	양천구	60대 이상	여성	oppose	31	57	재원 마련과 지속가능성에 의문을 느낀다.	10	\N
824	2	324	agent324	송파구	40대	남성	neutral	52	52	추가 정보가 필요하다고 느낀다.	1	\N
825	2	325	agent325	강동구	18-29	여성	support	67	64	비용 대비 효용이 높다고 본다.	-11	\N
826	2	326	agent326	광진구	50대	여성	neutral	43	67	추가 정보가 필요하다고 느낀다.	-24	\N
827	2	327	agent327	중랑구	60대 이상	여성	oppose	28	70	본인에게는 실익이 크지 않다고 본다.	19	\N
828	2	328	agent328	관악구	18-29	남성	neutral	51	61	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	30	\N
829	2	329	agent329	송파구	60대 이상	남성	oppose	33	70	우선순위가 더 높은 다른 과제가 있다고 본다.	41	\N
830	2	330	agent330	마포구	30대	여성	support	69	69	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-1	\N
831	2	331	agent331	성북구	18-29	남성	neutral	53	66	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	18	\N
832	2	332	agent332	마포구	40대	여성	support	63	66	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-21	\N
833	2	333	agent333	양천구	60대 이상	여성	oppose	22	73	형평성·세금 부담 측면에서 부정적이다.	-12	\N
834	2	334	agent334	동작구	30대	여성	neutral	56	69	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-2	\N
835	2	335	agent335	도봉구	18-29	여성	support	84	80	사회적 형평성 측면에서 바람직하다고 판단한다.	-29	\N
836	2	336	agent336	양천구	60대 이상	여성	oppose	25	58	재원 마련과 지속가능성에 의문을 느낀다.	30	\N
837	2	337	agent337	강북구	60대 이상	여성	oppose	27	72	형평성·세금 부담 측면에서 부정적이다.	-26	\N
838	2	338	agent338	노원구	60대 이상	남성	oppose	27	76	본인에게는 실익이 크지 않다고 본다.	0	\N
839	2	339	agent339	은평구	60대 이상	여성	oppose	39	68	우선순위가 더 높은 다른 과제가 있다고 본다.	-45	\N
840	2	340	agent340	동작구	18-29	남성	support	75	58	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	49	\N
841	2	341	agent341	영등포구	18-29	여성	support	90	82	사회적 형평성 측면에서 바람직하다고 판단한다.	32	\N
842	2	342	agent342	노원구	50대	남성	oppose	14	78	본인에게는 실익이 크지 않다고 본다.	5	\N
843	2	343	agent343	중구	60대 이상	남성	oppose	17	68	재원 마련과 지속가능성에 의문을 느낀다.	4	\N
844	2	344	agent344	양천구	18-29	남성	neutral	51	60	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	5	\N
845	2	345	agent345	은평구	30대	남성	neutral	54	58	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-8	\N
846	2	346	agent346	성북구	60대 이상	남성	oppose	34	72	본인에게는 실익이 크지 않다고 본다.	-5	\N
847	2	347	agent347	송파구	50대	여성	oppose	33	60	형평성·세금 부담 측면에서 부정적이다.	-60	\N
848	2	348	agent348	강남구	30대	여성	support	59	60	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-22	\N
849	2	349	agent349	종로구	18-29	여성	neutral	54	59	장단점이 비슷해 판단을 유보한다.	49	\N
850	2	350	agent350	마포구	30대	남성	support	78	75	사회적 형평성 측면에서 바람직하다고 판단한다.	-15	\N
851	2	351	agent351	강남구	30대	여성	support	62	56	사회적 형평성 측면에서 바람직하다고 판단한다.	31	\N
852	2	352	agent352	도봉구	18-29	남성	support	69	62	사회적 형평성 측면에서 바람직하다고 판단한다.	-7	\N
853	2	353	agent353	강남구	18-29	남성	support	67	71	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	6	\N
854	2	354	agent354	광진구	60대 이상	남성	oppose	39	56	형평성·세금 부담 측면에서 부정적이다.	11	\N
855	2	355	agent355	성동구	60대 이상	남성	neutral	47	52	추가 정보가 필요하다고 느낀다.	37	\N
856	2	356	agent356	관악구	60대 이상	남성	support	61	52	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-12	\N
857	2	357	agent357	송파구	40대	남성	neutral	43	56	장단점이 비슷해 판단을 유보한다.	4	\N
858	2	358	agent358	노원구	60대 이상	남성	oppose	16	64	본인에게는 실익이 크지 않다고 본다.	-20	\N
859	2	359	agent359	용산구	50대	남성	support	59	62	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	1	\N
860	2	360	agent360	용산구	60대 이상	남성	oppose	14	83	형평성·세금 부담 측면에서 부정적이다.	-7	\N
861	2	361	agent361	동대문구	50대	여성	oppose	38	60	우선순위가 더 높은 다른 과제가 있다고 본다.	-48	\N
862	2	362	agent362	송파구	50대	여성	neutral	53	62	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	41	\N
863	2	363	agent363	양천구	50대	남성	neutral	47	56	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	27	\N
864	2	364	agent364	강서구	18-29	여성	support	69	69	비용 대비 효용이 높다고 본다.	-20	\N
865	2	365	agent365	강북구	18-29	여성	support	65	66	사회적 형평성 측면에서 바람직하다고 판단한다.	-28	\N
866	2	366	agent366	동작구	18-29	남성	neutral	51	54	추가 정보가 필요하다고 느낀다.	-11	\N
867	2	367	agent367	중랑구	60대 이상	남성	oppose	26	73	형평성·세금 부담 측면에서 부정적이다.	42	\N
868	2	368	agent368	강남구	18-29	여성	support	58	68	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	17	\N
869	2	369	agent369	서대문구	18-29	여성	neutral	53	68	추가 정보가 필요하다고 느낀다.	6	\N
870	2	370	agent370	서초구	18-29	여성	neutral	50	42	장단점이 비슷해 판단을 유보한다.	12	\N
871	2	371	agent371	은평구	60대 이상	남성	oppose	33	53	형평성·세금 부담 측면에서 부정적이다.	23	\N
872	2	372	agent372	송파구	60대 이상	남성	oppose	31	79	재원 마련과 지속가능성에 의문을 느낀다.	2	\N
873	2	373	agent373	구로구	18-29	여성	support	62	58	사회적 형평성 측면에서 바람직하다고 판단한다.	39	\N
874	2	374	agent374	은평구	30대	여성	support	60	63	사회적 형평성 측면에서 바람직하다고 판단한다.	38	\N
875	2	375	agent375	종로구	60대 이상	여성	neutral	48	55	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-23	\N
876	2	376	agent376	강남구	60대 이상	남성	oppose	21	77	본인에게는 실익이 크지 않다고 본다.	56	\N
877	2	377	agent377	강동구	50대	남성	oppose	19	72	우선순위가 더 높은 다른 과제가 있다고 본다.	22	\N
878	2	378	agent378	도봉구	60대 이상	여성	oppose	36	67	형평성·세금 부담 측면에서 부정적이다.	30	\N
879	2	379	agent379	강남구	60대 이상	남성	oppose	13	84	본인에게는 실익이 크지 않다고 본다.	24	\N
880	2	380	agent380	서초구	40대	여성	neutral	46	56	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	12	\N
881	2	381	agent381	중랑구	60대 이상	남성	oppose	32	79	형평성·세금 부담 측면에서 부정적이다.	-33	\N
882	2	382	agent382	송파구	50대	여성	neutral	50	58	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	44	\N
883	2	383	agent383	송파구	30대	남성	neutral	56	64	장단점이 비슷해 판단을 유보한다.	-28	\N
884	2	384	agent384	강남구	60대 이상	여성	oppose	17	65	본인에게는 실익이 크지 않다고 본다.	-62	\N
885	2	385	agent385	강남구	50대	여성	support	60	66	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-18	\N
886	2	386	agent386	도봉구	18-29	남성	oppose	42	49	본인에게는 실익이 크지 않다고 본다.	-43	\N
887	2	387	agent387	강북구	60대 이상	여성	oppose	42	58	우선순위가 더 높은 다른 과제가 있다고 본다.	-38	\N
888	2	388	agent388	노원구	60대 이상	여성	oppose	26	67	우선순위가 더 높은 다른 과제가 있다고 본다.	-44	\N
889	2	389	agent389	구로구	60대 이상	여성	oppose	22	80	우선순위가 더 높은 다른 과제가 있다고 본다.	-8	\N
890	2	390	agent390	관악구	60대 이상	여성	neutral	54	52	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-45	\N
891	2	391	agent391	동대문구	60대 이상	남성	oppose	26	71	형평성·세금 부담 측면에서 부정적이다.	55	\N
892	2	392	agent392	강남구	60대 이상	여성	oppose	28	73	우선순위가 더 높은 다른 과제가 있다고 본다.	-19	\N
893	2	393	agent393	용산구	60대 이상	여성	oppose	36	71	형평성·세금 부담 측면에서 부정적이다.	-3	\N
894	2	394	agent394	성동구	40대	여성	neutral	54	62	추가 정보가 필요하다고 느낀다.	38	\N
895	2	395	agent395	강남구	60대 이상	남성	oppose	31	54	우선순위가 더 높은 다른 과제가 있다고 본다.	-10	\N
896	2	396	agent396	동작구	50대	남성	neutral	57	62	장단점이 비슷해 판단을 유보한다.	-13	\N
897	2	397	agent397	중랑구	60대 이상	여성	oppose	22	78	형평성·세금 부담 측면에서 부정적이다.	27	\N
898	2	398	agent398	양천구	60대 이상	남성	oppose	21	95	우선순위가 더 높은 다른 과제가 있다고 본다.	8	\N
900	2	400	agent400	광진구	60대 이상	남성	oppose	12	70	본인에게는 실익이 크지 않다고 본다.	47	\N
901	2	401	agent401	서초구	30대	남성	neutral	49	41	장단점이 비슷해 판단을 유보한다.	6	\N
902	2	402	agent402	노원구	40대	남성	neutral	48	58	추가 정보가 필요하다고 느낀다.	-15	\N
903	2	403	agent403	구로구	60대 이상	여성	oppose	9	93	형평성·세금 부담 측면에서 부정적이다.	-18	\N
904	2	404	agent404	강남구	60대 이상	남성	oppose	42	71	형평성·세금 부담 측면에서 부정적이다.	22	\N
905	2	405	agent405	금천구	60대 이상	남성	oppose	0	78	우선순위가 더 높은 다른 과제가 있다고 본다.	-22	\N
906	2	406	agent406	중랑구	60대 이상	여성	oppose	21	69	형평성·세금 부담 측면에서 부정적이다.	7	\N
907	2	407	agent407	서초구	40대	여성	oppose	41	67	우선순위가 더 높은 다른 과제가 있다고 본다.	-1	\N
908	2	408	agent408	양천구	50대	여성	neutral	56	62	추가 정보가 필요하다고 느낀다.	-23	\N
909	2	409	agent409	중랑구	60대 이상	남성	oppose	39	51	형평성·세금 부담 측면에서 부정적이다.	-18	\N
910	2	410	agent410	성동구	18-29	남성	support	73	83	비용 대비 효용이 높다고 본다.	-50	\N
911	2	411	agent411	구로구	40대	여성	support	60	60	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-21	\N
912	2	412	agent412	강서구	18-29	남성	support	65	70	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	11	\N
913	2	413	agent413	서대문구	60대 이상	여성	oppose	17	68	형평성·세금 부담 측면에서 부정적이다.	3	\N
914	2	414	agent414	송파구	50대	여성	neutral	56	55	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	25	\N
915	2	415	agent415	노원구	50대	여성	oppose	20	74	우선순위가 더 높은 다른 과제가 있다고 본다.	5	\N
916	2	416	agent416	노원구	60대 이상	여성	oppose	7	92	형평성·세금 부담 측면에서 부정적이다.	-15	\N
917	2	417	agent417	중랑구	30대	남성	support	69	68	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	19	\N
918	2	418	agent418	서초구	50대	여성	oppose	33	62	우선순위가 더 높은 다른 과제가 있다고 본다.	-31	\N
919	2	419	agent419	구로구	60대 이상	남성	oppose	26	80	형평성·세금 부담 측면에서 부정적이다.	11	\N
920	2	420	agent420	송파구	30대	여성	support	64	60	비용 대비 효용이 높다고 본다.	4	\N
921	2	421	agent421	송파구	50대	여성	neutral	45	74	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-32	\N
922	2	422	agent422	서초구	60대 이상	여성	oppose	28	80	형평성·세금 부담 측면에서 부정적이다.	10	\N
923	2	423	agent423	관악구	30대	남성	support	69	71	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-26	\N
924	2	424	agent424	동작구	60대 이상	여성	oppose	18	69	형평성·세금 부담 측면에서 부정적이다.	84	\N
925	2	425	agent425	강서구	50대	여성	oppose	41	71	형평성·세금 부담 측면에서 부정적이다.	-12	\N
926	2	426	agent426	은평구	18-29	남성	support	61	54	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	27	\N
927	2	427	agent427	송파구	30대	남성	neutral	46	59	장단점이 비슷해 판단을 유보한다.	11	\N
928	2	428	agent428	강서구	18-29	남성	support	67	54	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-33	\N
929	2	429	agent429	강남구	50대	남성	oppose	40	61	형평성·세금 부담 측면에서 부정적이다.	31	\N
930	2	430	agent430	금천구	18-29	여성	support	68	69	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-1	\N
931	2	431	agent431	중랑구	50대	남성	oppose	31	87	형평성·세금 부담 측면에서 부정적이다.	-49	\N
932	2	432	agent432	서초구	30대	남성	support	58	58	사회적 형평성 측면에서 바람직하다고 판단한다.	-37	\N
933	2	433	agent433	구로구	60대 이상	여성	oppose	7	76	우선순위가 더 높은 다른 과제가 있다고 본다.	7	\N
934	2	434	agent434	도봉구	40대	남성	oppose	38	57	본인에게는 실익이 크지 않다고 본다.	-20	\N
935	2	435	agent435	중랑구	60대 이상	남성	oppose	26	68	재원 마련과 지속가능성에 의문을 느낀다.	-32	\N
936	2	436	agent436	종로구	60대 이상	남성	oppose	16	70	우선순위가 더 높은 다른 과제가 있다고 본다.	-34	\N
937	2	437	agent437	강남구	50대	남성	neutral	52	51	추가 정보가 필요하다고 느낀다.	13	\N
938	2	438	agent438	송파구	60대 이상	여성	neutral	44	85	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-50	\N
939	2	439	agent439	영등포구	50대	여성	support	68	64	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	17	\N
940	2	440	agent440	송파구	50대	남성	support	66	51	사회적 형평성 측면에서 바람직하다고 판단한다.	19	\N
941	2	441	agent441	광진구	40대	남성	neutral	51	48	장단점이 비슷해 판단을 유보한다.	3	\N
942	2	442	agent442	동작구	60대 이상	여성	neutral	50	41	장단점이 비슷해 판단을 유보한다.	9	\N
943	2	443	agent443	강동구	18-29	여성	support	74	59	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-48	\N
944	2	444	agent444	강북구	30대	여성	support	78	62	사회적 형평성 측면에서 바람직하다고 판단한다.	63	\N
945	2	445	agent445	관악구	40대	여성	neutral	56	66	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	2	\N
946	2	446	agent446	은평구	50대	여성	support	62	74	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	26	\N
947	2	447	agent447	송파구	60대 이상	남성	neutral	44	57	추가 정보가 필요하다고 느낀다.	-9	\N
948	2	448	agent448	강서구	60대 이상	여성	oppose	16	58	형평성·세금 부담 측면에서 부정적이다.	-22	\N
949	2	449	agent449	동작구	60대 이상	남성	oppose	41	59	재원 마련과 지속가능성에 의문을 느낀다.	-9	\N
950	2	450	agent450	강남구	18-29	여성	support	67	75	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	7	\N
951	2	451	agent451	송파구	60대 이상	남성	neutral	45	55	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-12	\N
952	2	452	agent452	강남구	40대	남성	support	69	71	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-24	\N
953	2	453	agent453	동작구	40대	남성	support	59	58	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	47	\N
954	2	454	agent454	노원구	18-29	여성	support	69	76	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	14	\N
955	2	455	agent455	강동구	30대	여성	support	79	90	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	37	\N
956	2	456	agent456	강남구	18-29	여성	neutral	46	61	추가 정보가 필요하다고 느낀다.	13	\N
957	2	457	agent457	강남구	40대	남성	neutral	55	55	장단점이 비슷해 판단을 유보한다.	4	\N
958	2	458	agent458	서대문구	40대	여성	support	65	72	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	38	\N
959	2	459	agent459	강북구	18-29	남성	support	68	69	비용 대비 효용이 높다고 본다.	-43	\N
960	2	460	agent460	영등포구	60대 이상	남성	oppose	22	76	재원 마련과 지속가능성에 의문을 느낀다.	-15	\N
961	2	461	agent461	구로구	50대	남성	neutral	52	50	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-6	\N
962	2	462	agent462	관악구	30대	여성	support	62	73	비용 대비 효용이 높다고 본다.	25	\N
963	2	463	agent463	광진구	40대	여성	neutral	49	61	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	2	\N
964	2	464	agent464	강동구	40대	남성	neutral	46	66	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	58	\N
965	2	465	agent465	은평구	30대	여성	oppose	37	76	형평성·세금 부담 측면에서 부정적이다.	-4	\N
966	2	466	agent466	광진구	18-29	여성	oppose	36	71	재원 마련과 지속가능성에 의문을 느낀다.	-7	\N
967	2	467	agent467	노원구	40대	여성	support	60	59	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-12	\N
968	2	468	agent468	광진구	30대	남성	support	74	74	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	-22	\N
969	2	469	agent469	성동구	50대	남성	support	67	66	사회적 형평성 측면에서 바람직하다고 판단한다.	9	\N
970	2	470	agent470	중랑구	60대 이상	남성	oppose	13	81	우선순위가 더 높은 다른 과제가 있다고 본다.	11	\N
971	2	471	agent471	영등포구	60대 이상	남성	oppose	37	58	본인에게는 실익이 크지 않다고 본다.	-13	\N
972	2	472	agent472	강남구	60대 이상	남성	oppose	0	95	재원 마련과 지속가능성에 의문을 느낀다.	-49	\N
973	2	473	agent473	동대문구	18-29	여성	support	62	65	사회적 형평성 측면에서 바람직하다고 판단한다.	16	\N
974	2	474	agent474	마포구	30대	여성	neutral	57	54	추가 정보가 필요하다고 느낀다.	39	\N
975	2	475	agent475	용산구	40대	남성	support	61	65	사회적 형평성 측면에서 바람직하다고 판단한다.	15	\N
976	2	476	agent476	마포구	50대	남성	support	61	67	사회적 형평성 측면에서 바람직하다고 판단한다.	-9	\N
977	2	477	agent477	강남구	60대 이상	여성	oppose	38	76	재원 마련과 지속가능성에 의문을 느낀다.	22	\N
978	2	478	agent478	송파구	60대 이상	여성	oppose	31	59	본인에게는 실익이 크지 않다고 본다.	-33	\N
979	2	479	agent479	양천구	50대	여성	neutral	52	67	장단점이 비슷해 판단을 유보한다.	4	\N
980	2	480	agent480	강남구	40대	남성	neutral	43	60	추가 정보가 필요하다고 느낀다.	11	\N
981	2	481	agent481	동작구	50대	여성	oppose	38	65	재원 마련과 지속가능성에 의문을 느낀다.	3	\N
982	2	482	agent482	양천구	60대 이상	여성	oppose	42	56	형평성·세금 부담 측면에서 부정적이다.	-25	\N
983	2	483	agent483	서초구	18-29	여성	support	83	73	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-8	\N
984	2	484	agent484	강남구	40대	여성	oppose	31	55	우선순위가 더 높은 다른 과제가 있다고 본다.	-34	\N
985	2	485	agent485	강남구	60대 이상	여성	oppose	6	64	형평성·세금 부담 측면에서 부정적이다.	-4	\N
986	2	486	agent486	서초구	50대	여성	oppose	36	72	형평성·세금 부담 측면에서 부정적이다.	11	\N
987	2	487	agent487	도봉구	60대 이상	남성	oppose	29	55	본인에게는 실익이 크지 않다고 본다.	26	\N
988	2	488	agent488	영등포구	50대	여성	support	60	63	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	0	\N
989	2	489	agent489	서초구	50대	여성	neutral	50	63	추가 정보가 필요하다고 느낀다.	-16	\N
990	2	490	agent490	송파구	50대	남성	neutral	55	49	장단점이 비슷해 판단을 유보한다.	4	\N
991	2	491	agent491	강남구	60대 이상	여성	oppose	28	67	형평성·세금 부담 측면에서 부정적이다.	-21	\N
992	2	492	agent492	강남구	18-29	여성	support	69	59	정책 취지에 공감하며 실질적 도움이 될 것으로 본다.	21	\N
993	2	493	agent493	강남구	30대	남성	neutral	48	48	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	8	\N
994	2	494	agent494	서초구	40대	남성	support	63	61	본인 또는 주변에 혜택이 돌아갈 것으로 기대한다.	-14	\N
995	2	495	agent495	양천구	50대	여성	oppose	33	60	본인에게는 실익이 크지 않다고 본다.	30	\N
996	2	496	agent496	마포구	60대 이상	남성	oppose	41	74	재원 마련과 지속가능성에 의문을 느낀다.	-5	\N
997	2	497	agent497	용산구	60대 이상	남성	oppose	22	69	본인에게는 실익이 크지 않다고 본다.	25	\N
998	2	498	agent498	광진구	60대 이상	남성	oppose	26	62	형평성·세금 부담 측면에서 부정적이다.	36	\N
999	2	499	agent499	성동구	60대 이상	여성	oppose	37	66	재원 마련과 지속가능성에 의문을 느낀다.	-1	\N
1000	2	500	agent500	강북구	60대 이상	남성	neutral	44	60	취지에는 공감하나 구체적 실행 방안을 더 보고 판단하겠다.	-2	\N
\.


--
-- Data for Name: simulations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.simulations (id, title, audience, product, policy_text, model, status, progress, total_agents, cost_estimate_usd, cost_actual_usd, overall_support, support_pct, oppose_pct, neutral_pct, summary, created_at, completed_at, user_id, locked_by, locked_at, heartbeat_at, last_error, prediction_locked_at, prediction_value, actual_value, actual_metric, actual_entered_at, prediction_error, learned_at) FROM stdin;
1	청년 월세 지원 확대 정책 반응 테스트	정부	Seraph	서울시는 만 19~34세 무주택 청년을 대상으로 월 최대 30만원의 월세를 24개월간 지원하는 정책을 검토 중입니다. 재원은 지방채 발행과 기존 주거복지 예산 재편으로 충당합니다. 이 정책에 대한 시민 반응을 평가하세요.	gpt-5-mini	completed	100	500	0.2875	0.3071	50.8	40.6	38.2	21.2	서울 합성 인구 500명 시뮬레이션 결과 찬반이 팽팽하게 갈리는 반응이 나타났습니다. 찬성 40.6%, 반대 38.2%, 중립 21.2%로, 관악구 지역에서 지지가 가장 높았습니다.	2026-06-15 06:49:34.164375+00	2026-06-13 06:49:34.164375+00	1	\N	\N	\N	\N	2026-06-13 06:49:34.164375+00	40.6	43.5	실제 지지율(여론조사)	2026-06-22 03:44:27.801+00	2.9	2026-06-22 03:45:26.654+00
18	심야 대중교통 확대 정책 지지율 예측	정부	Seraph	서울시 심야 대중교통(버스·지하철) 운행 시간을 새벽 2시까지 확대하는 정책에 대한 시민 지지율을 예측한다.	gpt-5-mini	completed	100	500	0.29	0.29	73.1	73.1	18.5	8.4	합성 시민 500명 중 73.1%가 심야 대중교통 확대 정책을 지지(반대 18.5%, 중립 8.4%). 청년·직장인 밀집 자치구에서 지지가 두드러졌다. 이후 실제 여론조사 지지율 67.4%가 입력되어 예측 오차 5.7%p가 측정되었고, 보정 루프에 학습 반영되었다.	2025-10-30 09:00:00+00	2025-11-01 12:00:00+00	1	\N	\N	\N	\N	2025-11-01 12:00:00+00	73.1	67.4	지지율(%)	2025-11-02 09:00:00+00	5.7	2025-11-03 10:00:00+00
2	프리미엄 구독형 모빌리티 서비스 출시 컨셉 테스트	비즈니스	Lumen	월 9만 9천원에 따릉이·심야버스·전기 킥보드·카셰어링을 무제한 이용할 수 있는 통합 구독형 모빌리티 멤버십 'SeoulPass+'를 출시하려 합니다. 직장인과 청년을 핵심 타깃으로 합니다. 이 신서비스에 대한 구매 의향과 반응을 평가하세요.	gpt-5-mini	completed	100	500	0.2875	0.2772	45.4	27.2	43.8	29	서울 합성 인구 500명 시뮬레이션 결과 찬반이 팽팽하게 갈리는 반응이 나타났습니다. 찬성 27.2%, 반대 43.8%, 중립 29%로, 서대문구 지역에서 지지가 가장 높았습니다.	2026-06-15 06:49:48.082029+00	2026-06-10 06:49:48.082029+00	1	\N	\N	\N	\N	2026-06-10 06:49:48.082029+00	27.2	\N	\N	\N	\N	\N
17	서울지역 20대 청년 온누리 상품권 100만원권 일괄 지급	정부	Seraph	서울시 20대 청년의 자산 형성을 위해서 일괄적으로 100만원 온누리 상품권을 지급합니다.\n이 상품권은 서울 지역에서만 사용가능하면 사용기간은 3개월 이내이고, 3개월 후 소멸됩니다.	gpt-5-nano	completed	100	50	0.0058	0.0417	43.6	16	22	62	전국 합성 인구 50명 시뮬레이션 결과 수용과 거부가 팽팽하게 갈리는 반응이 나타났습니다. 수용 16%, 거부 22%, 중립 62%로, 서울특별시 지역에서 수용도가 가장 높았습니다.	2026-06-19 03:26:22.824226+00	2026-06-19 03:34:57.19+00	1	\N	\N	\N	\N	2026-06-19 03:34:57.19+00	16	\N	\N	\N	\N	\N
\.


--
-- Data for Name: survey_uploads; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.survey_uploads (id, file_name, description, format, row_count, status, applied_to_population, columns, sample_rows, created_at, user_id) FROM stdin;
\.


--
-- Data for Name: surveys; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.surveys (id, title, description, methodology, sample_size, fielded_date, status, reliability, drivers, created_at, applied_to_population, is_real, source_agency, source_title, field_period, source_url, domain, user_id) FROM stdin;
135	대한상공회의소 2024 소비 트렌드 조사 — 브랜드 충성도	소비자 대상 소비 트렌드 조사. 고가 제품 구매 축소 49%, 저렴한 브랜드 의도적 탐색 43.8%, PB(자체 브랜드) 구매 증가 33%로 가성비 중심 전환이 뚜렷해 브랜드 충성도가 약화 → 브랜드충성도 성향을 낮게 보정.	소비자 대상 설문조사	1000	2024-08-31	active	90	[{"issue": "브랜드충성도", "factor": "가성비 전환·브랜드 이탈", "weight": 0.5, "direction": "저렴 브랜드 탐색 43.8%·PB 구매 33% → 브랜드 충성도 약화", "targetStance": 38}]	2026-06-19 05:13:52.922662+00	t	t	대한상공회의소	2024 하반기 소비트렌드 변화와 대응방안	2024 하반기	http://www.korcham.net/nCham/Service/Economy/appl/KcciReportDetail.asp?SEQ_NO_C010=20120938356&CHAM_CD=B001	commercial	0
136	한국행정연구원 2023 사회통합실태조사 — 정부 신뢰	전국 만 19세 이상 약 8,000명 대상 1:1 면접조사(국가승인통계). 중앙정부 신뢰 응답이 절반에 못 미치는 수준(약 48%)에 머물러 정부 기관에 대한 신뢰가 중간 이하로 나타남 → 정부신뢰 성향을 중간 이하로 보정.	1:1 가구방문 면접조사 (국가승인통계 제417001호)	8000	2023-12-31	active	95	[{"issue": "정부신뢰", "factor": "중앙정부 신뢰", "weight": 0.6, "direction": "중앙정부 신뢰 약 48%로 절반 미만 → 정부신뢰 중간 이하", "targetStance": 48}]	2026-06-19 05:13:52.922662+00	t	t	한국행정연구원(KIPA)	2023 사회통합실태조사	2023 (연간 조사)	https://www.kipa.re.kr/site/kipa/research/selectBaseList.do	policy	0
137	한국행정연구원 2023 사회통합실태조사 — 정책 수용성	전국 만 19세 이상 약 8,000명 대상 면접조사(국가승인통계). 정부 정책 결정 과정의 공정성·반응성에 대한 긍정 평가가 절반에 못 미쳐(약 46%) 새 정책에 대한 자발적 수용·순응 의향이 중간 수준에 그침 → 정책수용성을 중간 수준으로 보정.	1:1 가구방문 면접조사 (국가승인통계 제417001호)	8000	2023-12-31	active	95	[{"issue": "정책수용성", "factor": "정책 결정 과정 신뢰", "weight": 0.5, "direction": "정책 결정 과정 공정성 긍정 약 46% → 정책수용성 중간 수준", "targetStance": 46}]	2026-06-19 05:13:52.922662+00	t	t	한국행정연구원(KIPA)	2023 사회통합실태조사 (정부 정책 인식)	2023 (연간 조사)	https://www.kipa.re.kr/site/kipa/research/selectBaseList.do	policy	0
126	한국갤럽 데일리 오피니언 — 향후 1년 경기 전망	전국 만 18세 이상 1,000명 대상 전화면접(CATI) 조사. 향후 1년 경기 전망에서 '나빠질 것' 47% vs '좋아질 것' 24%로 비관론 우세 → 정부의 경제 역할 확대 선호로 해석.	전화면접조사(CATI), 무선 가상번호 무작위 추출	1000	2025-04-17	active	95	[{"issue": "경제", "factor": "경기 전망", "weight": 0.4, "direction": "경기 비관론 우세(나빠질 47% vs 좋아질 24%) → 정부 경제 역할 확대 선호", "targetStance": -20}]	2026-06-19 05:13:52.922662+00	t	t	한국갤럽	데일리 오피니언 제634호 — 향후 1년 경기 전망	2025-04-15 ~ 2025-04-17	https://www.gallup.co.kr/gallupdb/report.asp	political	0
127	통계청 2023년 사회조사 — 복지 부문	전국 만 13세 이상 약 36,000명(약 19,000가구) 대상 면접조사. 늘려야 할 복지서비스로 고용(취업)지원 1위·보건의료 2위, 노후 준비 필요 인식이 높게 나타남 → 복지 확대 지지.	가구방문 면접조사 (국가지정통계)	36000	2023-05-31	active	95	[{"issue": "복지", "factor": "복지 수요", "weight": 0.55, "direction": "늘려야 할 복지 1위 고용지원·2위 보건의료 → 복지 확대 지지", "targetStance": 35}]	2026-06-19 05:13:52.922662+00	t	t	통계청	2023년 사회조사 결과 (복지·사회참여·여가·소득과 소비·노동)	2023-05 (16일간)	https://kostat.go.kr/board.es?mid=a10301010000&bid=219&act=view&list_no=427913	political	0
128	서울대 통일평화연구원 2024 통일의식조사 — 대북·안보 인식	전국 17개 시·도 만 19세 이상 1,200명 대상 1:1 면접조사(표본오차 ±2.8%, 95% 신뢰수준). 대북 적대의식이 22.3%로 역대 최고(3년 연속 상승), 통일 불필요 여론도 역대 최고 → 안보 강화 기조 강화.	1:1 대면 면접조사 (한국갤럽 수행)	1200	2024-07-23	active	95	[{"issue": "안보", "factor": "대북 인식", "weight": 0.45, "direction": "대북 적대의식 22.3% 역대 최고 → 안보 강화 기조 강화", "targetStance": 18}]	2026-06-19 05:13:52.922662+00	t	t	서울대학교 통일평화연구원	2024 통일의식조사	2024-07-01 ~ 2024-07-23	https://ipus.snu.ac.kr/blog/archives/news/9627	political	0
129	한국환경연구원(KEI) 2024 국민환경의식조사 — 기후변화 인식	전국 성인 3,040명 대상 웹조사(지역·성·연령 비례 할당). 기후변화를 가장 중요한 환경문제로 꼽은 응답이 68.2%로 2021년 39.8%에서 급증, 불안감 75.7% → 환경 보호 우선 강하게 지지.	웹조사 (온라인 패널, 비례 할당 추출)	3040	2024-12-31	active	95	[{"issue": "환경", "factor": "기후변화 심각성", "weight": 0.68, "direction": "기후변화를 최우선 환경문제로 꼽은 응답 68.2% → 환경 보호 우선", "targetStance": 45}]	2026-06-19 05:13:52.922662+00	t	t	한국환경연구원(KEI)	2024 국민환경의식조사	2024 (연간 조사)	https://www.kei.re.kr/elibList.es?mid=a10101010000&elibName=researchreport&act=view&c_id=766481	political	0
130	국토교통부 2023년 주거실태조사 — 주거 인식	전국 약 6.1만 가구 대상 1:1 개별 면접조사(국토연구원·한국리서치 수행). 내 집 보유 의사 87.3%인 반면 자가점유율은 57.4%에 그쳐 미충족 주거 수요가 큼 → 주거 지원·공급 확대 지지.	1:1 개별 면접조사 (국토연구원·한국리서치)	61000	2023-12-31	active	95	[{"issue": "주거", "factor": "주거 보유의사", "weight": 0.6, "direction": "내 집 보유의사 87.3% vs 자가점유율 57.4% → 주거 지원·공급 확대 지지", "targetStance": 42}]	2026-06-19 05:13:52.922662+00	t	t	국토교통부	2023년도 주거실태조사	2023 (연간 조사)	https://www.molit.go.kr/USR/NEWS/m_71/dtl.jsp?lcmspage=1&id=95090538	political	0
131	방송통신위원회 2024 방송매체 이용행태조사 — 디지털·OTT 소비	전국 17개 시·도 13세 이상 8,316명 대상 방문면접(국가승인통계). 전체 OTT 이용률 79.2%, 주5일 이상 스마트폰 이용 92.2%로 디지털 매체 소비가 일상화 → 합성 인구의 디지털소비 성향을 높게 보정.	가구방문 면접조사 (국가승인통계 제164002호)	8316	2024-12-30	active	95	[{"issue": "디지털소비", "factor": "OTT·디지털 매체 이용", "weight": 0.7, "direction": "OTT 79.2%·스마트폰 92.2% → 디지털 채널 소비 성향 높음", "targetStance": 72}]	2026-06-19 05:13:52.922662+00	t	t	방송통신위원회	2024 방송매체 이용행태조사	2024 (연간 조사)	https://www.kcc.go.kr/user.do?mode=view&page=A05030000&dc=K05030000&boardId=1113&boardSeq=64951	commercial	0
132	과학기술정보통신부 2024 인터넷이용실태조사 — 신기술 수용	전국 25,509가구·만 3세 이상 60,229명 대상 면접조사. AI 서비스 경험률 60.3%, 생성형 AI 경험률 33.3%(전년 17.6% 대비 약 2배)로 신기술 수용이 빠르게 확산 → 신제품수용 성향을 중상위로 보정.	가구방문 면접조사 (국가승인통계)	60229	2025-03-31	active	95	[{"issue": "신제품수용", "factor": "AI·신기술 수용", "weight": 0.6, "direction": "AI 경험 60.3%·생성형 AI 33.3%(2배↑) → 신제품 수용 성향 중상위", "targetStance": 58}]	2026-06-19 05:13:52.922662+00	t	t	과학기술정보통신부	2024 인터넷이용실태조사	2024 (연간 조사)	https://www.korea.kr/briefing/pressReleaseView.do?newsId=156681493	commercial	0
133	한국소비자원 2025 친환경 소비 제도 이용 실태조사 — 친환경 소비	전국 성인 소비자 3,200명 대상 조사. 친환경 제도 이용 66.4%, 구매 의향 82.2%로 인식은 높으나 실제 친환경 제품 구매 노력은 25.5%에 그쳐 인식–실천 괴리가 큼 → 친환경소비 성향을 중간 수준으로 보정.	소비자 대상 설문조사	3200	2025-05-13	active	95	[{"issue": "친환경소비", "factor": "친환경 인식–실천 괴리", "weight": 0.55, "direction": "제도 이용 66.4%·의향 82.2% vs 실천 25.5% → 친환경소비 중간 수준", "targetStance": 50}]	2026-06-19 05:13:52.922662+00	t	t	한국소비자원	친환경 제도 소비자 이용 실태조사	2025	https://www.kca.go.kr/home/board/download.do?menukey=4002&fno=10046976&bid=00000013&did=1003867815	commercial	0
134	한국은행 2025 소비자동향조사 — 물가·가격 민감도	전국 약 2,500가구 대상 월간 소비자동향조사. 물가수준전망 CSI 148, 기대인플레이션율 2.6%로 향후 물가 상승 부담 인식이 높아 가격에 민감한 소비 태도가 우세 → 가격민감도 성향을 높게 보정.	가구 대상 월간 설문조사 (한국은행 통계)	2500	2025-12-23	active	95	[{"issue": "가격민감도", "factor": "물가 상승 부담", "weight": 0.6, "direction": "물가수준전망 CSI 148·기대인플레 2.6% → 가격민감 소비 우세", "targetStance": 68}]	2026-06-19 05:13:52.922662+00	t	t	한국은행	소비자동향조사(소비자심리지수)	2025-12	https://www.bok.or.kr/portal/bbs/B0000501/view.do?nttId=10095310&menuNo=201264	commercial	0
138	한국조세재정연구원 2023 재정패널 — 증세·조세 인식	전국 가구·개인 패널 대상 재정패널조사. 복지 확대를 위한 증세에 대한 찬성이 약 45% 수준으로, 복지 수요는 높으나 본인 세 부담 증가에는 신중한 태도가 우세 → 증세수용 성향을 중간 이하로 보정.	가구·개인 패널 설문조사 (재정패널)	5000	2023-12-31	active	90	[{"issue": "증세수용", "factor": "증세 수용성", "weight": 0.5, "direction": "복지 위한 증세 찬성 약 45% → 본인 세부담엔 신중, 증세수용 중간 이하", "targetStance": 45}]	2026-06-19 05:13:52.922662+00	t	t	한국조세재정연구원(KIPF)	재정패널조사 (조세·재정 인식)	2023 (연간 조사)	https://www.kipf.re.kr/panel/	policy	0
139	통계청 2024 사회조사 — 사회안전·규제 인식	전국 만 13세 이상 약 36,000명 대상 면접조사(국가지정통계). 식품·범죄·환경 등 위험으로부터의 사회안전 체감이 높지 않아 정부의 안전·환경 규제 강화 요구가 우세 → 규제선호 성향을 중상위로 보정.	가구방문 면접조사 (국가지정통계)	36000	2024-05-31	active	95	[{"issue": "규제선호", "factor": "사회안전·규제 요구", "weight": 0.55, "direction": "사회안전 체감 낮음 → 안전·환경 규제 강화 요구 우세, 규제선호 중상위", "targetStance": 64}]	2026-06-19 05:13:52.922662+00	t	t	통계청	2024년 사회조사 결과 (안전·환경·사회)	2024-05 (16일간)	https://kostat.go.kr/board.es?mid=a10301010000&bid=219	policy	0
140	행정안전부 2022 전자정부서비스 이용실태조사 — 공공서비스 만족	전국 만 16~74세 대상 전자정부서비스 이용실태조사. 전자정부서비스 이용자 만족도가 97.7%로 매우 높게 나타나 공공·행정 서비스 이용 경험에 대한 만족이 높은 수준 → 공공서비스만족 성향을 높게 보정.	이용자 대상 설문조사 (전자정부서비스 이용실태조사)	4000	2022-12-31	active	95	[{"issue": "공공서비스만족", "factor": "공공서비스 만족", "weight": 0.6, "direction": "전자정부서비스 만족도 97.7% → 공공서비스 만족 높음", "targetStance": 80}]	2026-06-19 05:13:52.922662+00	t	t	행정안전부	2022 전자정부서비스 이용실태조사	2022 (연간 조사)	https://www.mois.go.kr/frt/bbs/type010/commonSelectBoardList.do?bbsId=BBSMSTR_000000000008	policy	0
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, username, name, birth_date, password_hash, role, created_at, budget_limit_usd, avatar, password_plain) FROM stdin;
0	__global__	공유 학습 인구	\N	x	system	2026-06-22 08:45:12.458123	1	\N	\N
2	admin	관리자	\N	$2b$10$UVNNgxRjc.JTwmKgn/4uk.LOh1kY1lL197O0KkN8vTC0zmVHbI.mq	admin	2026-06-18 00:33:26.079448	1	\N	1111
1	test	테스트 사용자	1990-05-15	$2b$10$bnFaJbHCAWUTWzSo0AAGkulUFzH/pC4yNNm1X1z2IqH0QOB3yCZ5O	user	2026-06-18 00:33:26.079448	3	av4	1111
\.


--
-- Name: access_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.access_events_id_seq', 728, true);


--
-- Name: accuracy_snapshots_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.accuracy_snapshots_id_seq', 8, true);


--
-- Name: agents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.agents_id_seq', 4300, true);


--
-- Name: calibration_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.calibration_settings_id_seq', 2, true);


--
-- Name: calibrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.calibrations_id_seq', 15, true);


--
-- Name: data_sources_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.data_sources_id_seq', 147, true);


--
-- Name: demographic_margins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.demographic_margins_id_seq', 25, true);


--
-- Name: elections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.elections_id_seq', 241, true);


--
-- Name: learning_contributions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.learning_contributions_id_seq', 9, true);


--
-- Name: signal_batches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.signal_batches_id_seq', 65, true);


--
-- Name: signal_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.signal_settings_id_seq', 3, true);


--
-- Name: simulation_responses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.simulation_responses_id_seq', 1600, true);


--
-- Name: simulations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.simulations_id_seq', 19, true);


--
-- Name: survey_uploads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.survey_uploads_id_seq', 1, false);


--
-- Name: surveys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.surveys_id_seq', 140, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 4, true);


--
-- Name: access_events access_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_events
    ADD CONSTRAINT access_events_pkey PRIMARY KEY (id);


--
-- Name: accuracy_snapshots accuracy_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accuracy_snapshots
    ADD CONSTRAINT accuracy_snapshots_pkey PRIMARY KEY (id);


--
-- Name: agents agents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents
    ADD CONSTRAINT agents_pkey PRIMARY KEY (id);


--
-- Name: calibration_settings calibration_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calibration_settings
    ADD CONSTRAINT calibration_settings_pkey PRIMARY KEY (id);


--
-- Name: calibrations calibrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calibrations
    ADD CONSTRAINT calibrations_pkey PRIMARY KEY (id);


--
-- Name: contributor_reputation contributor_reputation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contributor_reputation
    ADD CONSTRAINT contributor_reputation_pkey PRIMARY KEY (user_id);


--
-- Name: data_sources data_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_sources
    ADD CONSTRAINT data_sources_pkey PRIMARY KEY (id);


--
-- Name: demographic_margins demographic_margins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.demographic_margins
    ADD CONSTRAINT demographic_margins_pkey PRIMARY KEY (id);


--
-- Name: elections elections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.elections
    ADD CONSTRAINT elections_pkey PRIMARY KEY (id);


--
-- Name: ip_geo ip_geo_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ip_geo
    ADD CONSTRAINT ip_geo_pkey PRIMARY KEY (ip);


--
-- Name: learning_contributions learning_contributions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.learning_contributions
    ADD CONSTRAINT learning_contributions_pkey PRIMARY KEY (id);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (code);


--
-- Name: session session_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_pkey PRIMARY KEY (sid);


--
-- Name: signal_batches signal_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.signal_batches
    ADD CONSTRAINT signal_batches_pkey PRIMARY KEY (id);


--
-- Name: signal_settings signal_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.signal_settings
    ADD CONSTRAINT signal_settings_pkey PRIMARY KEY (id);


--
-- Name: signal_settings signal_settings_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.signal_settings
    ADD CONSTRAINT signal_settings_user_id_key UNIQUE (user_id);


--
-- Name: simulation_responses simulation_responses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.simulation_responses
    ADD CONSTRAINT simulation_responses_pkey PRIMARY KEY (id);


--
-- Name: simulations simulations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.simulations
    ADD CONSTRAINT simulations_pkey PRIMARY KEY (id);


--
-- Name: survey_uploads survey_uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_uploads
    ADD CONSTRAINT survey_uploads_pkey PRIMARY KEY (id);


--
-- Name: surveys surveys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.surveys
    ADD CONSTRAINT surveys_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);


--
-- Name: IDX_session_expire; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_session_expire" ON public.session USING btree (expire);


--
-- Name: access_events_created_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX access_events_created_at_idx ON public.access_events USING btree (created_at);


--
-- Name: access_events_ip_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX access_events_ip_idx ON public.access_events USING btree (ip);


--
-- Name: access_events_session_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX access_events_session_idx ON public.access_events USING btree (session_id);


--
-- Name: access_events_user_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX access_events_user_idx ON public.access_events USING btree (user_id);


--
-- Name: agents_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX agents_user_id_idx ON public.agents USING btree (user_id);


--
-- Name: calibrations_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX calibrations_user_id_idx ON public.calibrations USING btree (user_id);


--
-- Name: sim_responses_sim_agent_uq; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX sim_responses_sim_agent_uq ON public.simulation_responses USING btree (simulation_id, agent_id);


--
-- Name: simulations_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX simulations_user_id_idx ON public.simulations USING btree (user_id);


--
-- Name: survey_uploads_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX survey_uploads_user_id_idx ON public.survey_uploads USING btree (user_id);


--
-- Name: surveys_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX surveys_user_id_idx ON public.surveys USING btree (user_id);


--
-- Name: agents agents_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents
    ADD CONSTRAINT agents_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: calibration_settings calibration_settings_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calibration_settings
    ADD CONSTRAINT calibration_settings_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: calibrations calibrations_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calibrations
    ADD CONSTRAINT calibrations_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: simulations simulations_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.simulations
    ADD CONSTRAINT simulations_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: survey_uploads survey_uploads_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_uploads
    ADD CONSTRAINT survey_uploads_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: surveys surveys_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.surveys
    ADD CONSTRAINT surveys_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

\unrestrict UsdXvuaJmd1ACnTGUcPOM4ck4zH3CTe5FqBk4M4d0cF0ZorzrchFwd9MZgnd4yi

