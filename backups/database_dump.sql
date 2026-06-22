--
-- PostgreSQL database dump
--

\restrict oTvSz39Z76NIpP53ZxJxyG7INg262Sxsysn4eZ2KXcdn0KgzHmzseFbXqgEHaWa

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
ALTER TABLE IF EXISTS ONLY public.elections DROP CONSTRAINT IF EXISTS elections_pkey;
ALTER TABLE IF EXISTS ONLY public.demographic_margins DROP CONSTRAINT IF EXISTS demographic_margins_pkey;
ALTER TABLE IF EXISTS ONLY public.data_sources DROP CONSTRAINT IF EXISTS data_sources_pkey;
ALTER TABLE IF EXISTS ONLY public.calibrations DROP CONSTRAINT IF EXISTS calibrations_pkey;
ALTER TABLE IF EXISTS ONLY public.calibration_settings DROP CONSTRAINT IF EXISTS calibration_settings_pkey;
ALTER TABLE IF EXISTS ONLY public.agents DROP CONSTRAINT IF EXISTS agents_pkey;
ALTER TABLE IF EXISTS public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.surveys ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.survey_uploads ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.simulations ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.simulation_responses ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.signal_settings ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.signal_batches ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.elections ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.demographic_margins ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.data_sources ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.calibrations ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.calibration_settings ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.agents ALTER COLUMN id DROP DEFAULT;
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
DROP SEQUENCE IF EXISTS public.elections_id_seq;
DROP TABLE IF EXISTS public.elections;
DROP SEQUENCE IF EXISTS public.demographic_margins_id_seq;
DROP TABLE IF EXISTS public.demographic_margins;
DROP SEQUENCE IF EXISTS public.data_sources_id_seq;
DROP TABLE IF EXISTS public.data_sources;
DROP SEQUENCE IF EXISTS public.calibrations_id_seq;
DROP TABLE IF EXISTS public.calibrations;
DROP SEQUENCE IF EXISTS public.calibration_settings_id_seq;
DROP TABLE IF EXISTS public.calibration_settings;
DROP SEQUENCE IF EXISTS public.agents_id_seq;
DROP TABLE IF EXISTS public.agents;
SET default_tablespace = '';

SET default_table_access_method = heap;

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
    avatar text
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
-- Data for Name: agents; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.agents (id, name, age, age_bracket, gender, district, lat, lng, education, income_bracket, occupation, household_type, political_leaning, party_affinity, turnout_propensity, issue_stances, media_diet, "values", persona_summary, consumer_stances, policy_stances, user_id) FROM stdin;
1101	정예준	18	18-29	Female	서울특별시	37.566599	127.054194	대학원 졸	200-350만원	학생	부부 가구	30	보수 성향 무당층	36	{"economy": 13, "housing": -14, "welfare": -3, "security": 29, "environment": -6}	지상파/종편 뉴스	{혁신,공동체,다양성}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 혁신, 공동체, 다양성 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 96, "ecoConsciousness": 63, "priceSensitivity": 60, "digitalConsumption": 93}	{"taxTolerance": 54, "governmentTrust": 39, "policyAcceptance": 60, "regulationPreference": 57, "publicServiceSatisfaction": 71}	0
1102	이서윤	22	18-29	Female	서울특별시	37.639776	126.972986	대학원 졸	200-350만원	학생	다세대 가구	-37	진보 성향 무당층	60	{"economy": -9, "housing": 36, "welfare": 30, "security": -20, "environment": 65}	신문/팟캐스트	{자유,공정,다양성}	서울특별시에 거주하는 18-29 학생. 정치 성향은 진보이며 자유, 공정, 다양성 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 87, "ecoConsciousness": 78, "priceSensitivity": 62, "digitalConsumption": 86}	{"taxTolerance": 54, "governmentTrust": 40, "policyAcceptance": 41, "regulationPreference": 56, "publicServiceSatisfaction": 66}	0
1103	윤영수	22	18-29	Female	서울특별시	37.62274	126.95526	대학교 졸	200-350만원	학생	부부 가구	-1	중도 무당층	60	{"economy": 10, "housing": 17, "welfare": 55, "security": 13, "environment": 16}	포털 뉴스	{공동체,성장,혁신}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 공동체, 성장, 혁신 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 75, "ecoConsciousness": 53, "priceSensitivity": 48, "digitalConsumption": 67}	{"taxTolerance": 52, "governmentTrust": 38, "policyAcceptance": 61, "regulationPreference": 68, "publicServiceSatisfaction": 61}	0
1104	임영수	23	18-29	Female	서울특별시	37.505012	126.939674	대학원 졸	350-500만원	학생	다세대 가구	-17	진보 성향 무당층	49	{"economy": -25, "housing": 45, "welfare": 47, "security": -32, "environment": 6}	지상파/종편 뉴스	{혁신,공동체,공정}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 혁신, 공동체, 공정 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 83, "ecoConsciousness": 58, "priceSensitivity": 73, "digitalConsumption": 65}	{"taxTolerance": 48, "governmentTrust": 46, "policyAcceptance": 52, "regulationPreference": 63, "publicServiceSatisfaction": 48}	0
1105	류유준	21	18-29	Female	서울특별시	37.510722	126.998855	고졸 이하	200-350만원	학생	다세대 가구	-3	중도 무당층	42	{"economy": -13, "housing": 17, "welfare": 2, "security": -15, "environment": 38}	SNS	{공동체,혁신,안정}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 공동체, 혁신, 안정 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 73, "ecoConsciousness": 39, "priceSensitivity": 65, "digitalConsumption": 78}	{"taxTolerance": 43, "governmentTrust": 49, "policyAcceptance": 40, "regulationPreference": 51, "publicServiceSatisfaction": 53}	0
1106	윤경숙	26	18-29	Female	서울특별시	37.595766	127.031785	대학교 졸	500-700만원	은퇴	다세대 가구	-33	진보 성향 무당층	51	{"economy": -47, "housing": 15, "welfare": 15, "security": -16, "environment": 35}	포털 뉴스	{공동체,자유,환경}	서울특별시에 거주하는 18-29 은퇴. 정치 성향은 중도이며 공동체, 자유, 환경 가치를 중시한다.	{"brandLoyalty": 20, "noveltySeeking": 80, "ecoConsciousness": 54, "priceSensitivity": 70, "digitalConsumption": 82}	{"taxTolerance": 51, "governmentTrust": 48, "policyAcceptance": 56, "regulationPreference": 53, "publicServiceSatisfaction": 64}	0
1107	오채원	29	18-29	Female	서울특별시	37.493959	127.053976	대학원 졸	200-350만원	생산직	1인 가구	-39	진보 성향 무당층	50	{"economy": -26, "housing": 22, "welfare": 33, "security": 7, "environment": 14}	지상파/종편 뉴스	{안정,환경,혁신}	서울특별시에 거주하는 18-29 생산직. 정치 성향은 진보이며 안정, 환경, 혁신 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 79, "ecoConsciousness": 44, "priceSensitivity": 62, "digitalConsumption": 63}	{"taxTolerance": 45, "governmentTrust": 57, "policyAcceptance": 44, "regulationPreference": 54, "publicServiceSatisfaction": 67}	0
1108	조도윤	29	18-29	Female	서울특별시	37.645737	126.989025	전문대 졸	350-500만원	학생	1인 가구	-3	중도 무당층	52	{"economy": -19, "housing": 54, "welfare": 40, "security": 22, "environment": 8}	지상파/종편 뉴스	{안정,전통,공정}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 안정, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 68, "ecoConsciousness": 42, "priceSensitivity": 58, "digitalConsumption": 74}	{"taxTolerance": 42, "governmentTrust": 60, "policyAcceptance": 41, "regulationPreference": 57, "publicServiceSatisfaction": 72}	0
1109	임철수	28	18-29	Female	서울특별시	37.519491	126.932737	대학원 졸	200만원 미만	생산직	다세대 가구	-17	진보 성향 무당층	58	{"economy": 3, "housing": 35, "welfare": 28, "security": -6, "environment": 30}	유튜브	{공동체,공정,자유}	서울특별시에 거주하는 18-29 생산직. 정치 성향은 중도이며 공동체, 공정, 자유 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 58, "ecoConsciousness": 64, "priceSensitivity": 49, "digitalConsumption": 81}	{"taxTolerance": 41, "governmentTrust": 37, "policyAcceptance": 29, "regulationPreference": 61, "publicServiceSatisfaction": 74}	0
1110	송철수	18	18-29	Female	서울특별시	37.588713	127.077939	전문대 졸	200만원 미만	학생	자녀 양육 가구	0	중도 무당층	54	{"economy": -25, "housing": -11, "welfare": -13, "security": -10, "environment": -3}	유튜브	{공동체,공정,혁신}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 공동체, 공정, 혁신 가치를 중시한다.	{"brandLoyalty": 10, "noveltySeeking": 97, "ecoConsciousness": 48, "priceSensitivity": 71, "digitalConsumption": 86}	{"taxTolerance": 75, "governmentTrust": 38, "policyAcceptance": 37, "regulationPreference": 57, "publicServiceSatisfaction": 69}	0
1111	최서연	27	18-29	Female	서울특별시	37.502924	126.997723	대학원 졸	200만원 미만	은퇴	자녀 양육 가구	-33	진보 성향 무당층	65	{"economy": -12, "housing": 40, "welfare": 0, "security": 5, "environment": 17}	SNS	{안정,자유,공정}	서울특별시에 거주하는 18-29 은퇴. 정치 성향은 중도이며 안정, 자유, 공정 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 67, "ecoConsciousness": 35, "priceSensitivity": 84, "digitalConsumption": 73}	{"taxTolerance": 62, "governmentTrust": 30, "policyAcceptance": 39, "regulationPreference": 48, "publicServiceSatisfaction": 68}	0
1112	최동현	24	18-29	Female	서울특별시	37.617533	126.973049	대학원 졸	500-700만원	학생	1인 가구	-22	진보 성향 무당층	53	{"economy": -40, "housing": 25, "welfare": 27, "security": -24, "environment": 43}	SNS	{혁신,공동체,안정}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 혁신, 공동체, 안정 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 73, "ecoConsciousness": 43, "priceSensitivity": 52, "digitalConsumption": 86}	{"taxTolerance": 54, "governmentTrust": 46, "policyAcceptance": 39, "regulationPreference": 62, "publicServiceSatisfaction": 78}	0
1113	김혜진	22	18-29	Male	서울특별시	37.568338	126.9064	대학원 졸	500-700만원	학생	부부 가구	21	보수 성향 무당층	36	{"economy": 18, "housing": 5, "welfare": 8, "security": 10, "environment": -10}	포털 뉴스	{다양성,혁신,자유}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 다양성, 혁신, 자유 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 73, "ecoConsciousness": 62, "priceSensitivity": 68, "digitalConsumption": 87}	{"taxTolerance": 56, "governmentTrust": 41, "policyAcceptance": 37, "regulationPreference": 57, "publicServiceSatisfaction": 57}	0
1114	박서연	29	18-29	Male	서울특별시	37.635754	126.894247	대학원 졸	200-350만원	공무원	1인 가구	-34	진보 성향 무당층	48	{"economy": -24, "housing": 29, "welfare": 24, "security": 2, "environment": 50}	SNS	{다양성,혁신,전통}	서울특별시에 거주하는 18-29 공무원. 정치 성향은 진보이며 다양성, 혁신, 전통 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 83, "ecoConsciousness": 73, "priceSensitivity": 71, "digitalConsumption": 75}	{"taxTolerance": 58, "governmentTrust": 36, "policyAcceptance": 31, "regulationPreference": 56, "publicServiceSatisfaction": 58}	0
1115	류채원	22	18-29	Male	서울특별시	37.604653	127.017057	대학원 졸	700만원 이상	학생	다세대 가구	-76	진보 정당 지지	53	{"economy": -46, "housing": 34, "welfare": 49, "security": -11, "environment": 47}	SNS	{혁신,다양성,성장}	서울특별시에 거주하는 18-29 학생. 정치 성향은 진보이며 혁신, 다양성, 성장 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 65, "ecoConsciousness": 50, "priceSensitivity": 34, "digitalConsumption": 78}	{"taxTolerance": 48, "governmentTrust": 19, "policyAcceptance": 23, "regulationPreference": 67, "publicServiceSatisfaction": 61}	0
1116	윤성호	20	18-29	Male	서울특별시	37.538339	126.879483	대학원 졸	200만원 미만	학생	1인 가구	14	중도 무당층	47	{"economy": 4, "housing": 40, "welfare": -3, "security": 2, "environment": 16}	신문/팟캐스트	{공동체,환경,자유}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 공동체, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 25, "noveltySeeking": 100, "ecoConsciousness": 50, "priceSensitivity": 69, "digitalConsumption": 82}	{"taxTolerance": 50, "governmentTrust": 44, "policyAcceptance": 44, "regulationPreference": 62, "publicServiceSatisfaction": 62}	0
1117	윤지호	20	18-29	Male	서울특별시	37.496085	126.939161	대학원 졸	200만원 미만	학생	다세대 가구	-27	진보 성향 무당층	53	{"economy": -10, "housing": 64, "welfare": 25, "security": -3, "environment": 45}	포털 뉴스	{혁신,다양성,안정}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 혁신, 다양성, 안정 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 65, "ecoConsciousness": 79, "priceSensitivity": 72, "digitalConsumption": 70}	{"taxTolerance": 58, "governmentTrust": 52, "policyAcceptance": 38, "regulationPreference": 81, "publicServiceSatisfaction": 85}	0
1118	최미경	19	18-29	Male	서울특별시	37.597389	127.015369	대학교 졸	500-700만원	학생	1인 가구	-13	중도 무당층	59	{"economy": 5, "housing": 23, "welfare": 25, "security": 6, "environment": 34}	유튜브	{다양성,안정,공정}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 다양성, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 65, "ecoConsciousness": 55, "priceSensitivity": 56, "digitalConsumption": 88}	{"taxTolerance": 45, "governmentTrust": 41, "policyAcceptance": 65, "regulationPreference": 60, "publicServiceSatisfaction": 57}	0
1119	윤지호	29	18-29	Male	서울특별시	37.501335	127.002758	대학원 졸	500-700만원	전문직	자녀 양육 가구	-12	중도 무당층	61	{"economy": -41, "housing": 17, "welfare": 28, "security": 14, "environment": 12}	유튜브	{안전,성장,공정}	서울특별시에 거주하는 18-29 전문직. 정치 성향은 중도이며 안전, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 67, "ecoConsciousness": 76, "priceSensitivity": 57, "digitalConsumption": 84}	{"taxTolerance": 49, "governmentTrust": 38, "policyAcceptance": 39, "regulationPreference": 60, "publicServiceSatisfaction": 54}	0
1120	한정희	22	18-29	Male	서울특별시	37.617942	126.890677	고졸 이하	200-350만원	자영업	자녀 양육 가구	-28	진보 성향 무당층	44	{"economy": -60, "housing": 14, "welfare": 27, "security": -25, "environment": 44}	지상파/종편 뉴스	{전통,성장,공정}	서울특별시에 거주하는 18-29 자영업. 정치 성향은 중도이며 전통, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 26, "noveltySeeking": 90, "ecoConsciousness": 61, "priceSensitivity": 71, "digitalConsumption": 91}	{"taxTolerance": 47, "governmentTrust": 51, "policyAcceptance": 44, "regulationPreference": 58, "publicServiceSatisfaction": 73}	0
1121	신혜진	25	18-29	Male	서울특별시	37.617839	126.923625	대학교 졸	200-350만원	학생	자녀 양육 가구	36	보수 성향 무당층	52	{"economy": 14, "housing": 29, "welfare": -19, "security": 37, "environment": -8}	지상파/종편 뉴스	{안정,환경,공동체}	서울특별시에 거주하는 18-29 학생. 정치 성향은 보수이며 안정, 환경, 공동체 가치를 중시한다.	{"brandLoyalty": 23, "noveltySeeking": 66, "ecoConsciousness": 64, "priceSensitivity": 66, "digitalConsumption": 83}	{"taxTolerance": 50, "governmentTrust": 41, "policyAcceptance": 51, "regulationPreference": 66, "publicServiceSatisfaction": 55}	0
1122	한정희	25	18-29	Male	서울특별시	37.573741	127.074231	전문대 졸	200만원 미만	공무원	부부 가구	-64	진보 정당 지지	79	{"economy": -61, "housing": 28, "welfare": 35, "security": -19, "environment": 26}	유튜브	{다양성,안정,공정}	서울특별시에 거주하는 18-29 공무원. 정치 성향은 진보이며 다양성, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 63, "ecoConsciousness": 61, "priceSensitivity": 69, "digitalConsumption": 62}	{"taxTolerance": 60, "governmentTrust": 41, "policyAcceptance": 55, "regulationPreference": 70, "publicServiceSatisfaction": 79}	0
1123	정현우	25	18-29	Male	서울특별시	37.562885	126.947878	대학원 졸	350-500만원	프리랜서	자녀 양육 가구	-51	진보 정당 지지	48	{"economy": -22, "housing": 35, "welfare": 38, "security": -19, "environment": 29}	포털 뉴스	{다양성,전통,성장}	서울특별시에 거주하는 18-29 프리랜서. 정치 성향은 진보이며 다양성, 전통, 성장 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 77, "ecoConsciousness": 51, "priceSensitivity": 78, "digitalConsumption": 70}	{"taxTolerance": 42, "governmentTrust": 54, "policyAcceptance": 43, "regulationPreference": 56, "publicServiceSatisfaction": 55}	0
1124	이영수	19	18-29	Male	서울특별시	37.613727	126.997955	대학교 졸	200-350만원	학생	1인 가구	-11	중도 무당층	47	{"economy": -7, "housing": 16, "welfare": 34, "security": -2, "environment": 32}	지상파/종편 뉴스	{안전,전통,다양성}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 안전, 전통, 다양성 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 76, "ecoConsciousness": 63, "priceSensitivity": 69, "digitalConsumption": 78}	{"taxTolerance": 52, "governmentTrust": 46, "policyAcceptance": 27, "regulationPreference": 53, "publicServiceSatisfaction": 60}	0
1125	박현우	38	30-39	Female	서울특별시	37.50839	127.02072	대학교 졸	500-700만원	자영업	1인 가구	-34	진보 성향 무당층	58	{"economy": -31, "housing": 17, "welfare": 15, "security": 0, "environment": 30}	SNS	{자유,안전,혁신}	서울특별시에 거주하는 30-39 자영업. 정치 성향은 진보이며 자유, 안전, 혁신 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 62, "ecoConsciousness": 53, "priceSensitivity": 64, "digitalConsumption": 80}	{"taxTolerance": 49, "governmentTrust": 39, "policyAcceptance": 42, "regulationPreference": 38, "publicServiceSatisfaction": 73}	0
1126	권은우	37	30-39	Female	서울특별시	37.497135	127.034272	대학원 졸	500-700만원	학생	다세대 가구	-28	진보 성향 무당층	40	{"economy": -35, "housing": 5, "welfare": 39, "security": -16, "environment": 11}	유튜브	{안정,공정,성장}	서울특별시에 거주하는 30-39 학생. 정치 성향은 중도이며 안정, 공정, 성장 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 56, "ecoConsciousness": 61, "priceSensitivity": 39, "digitalConsumption": 85}	{"taxTolerance": 55, "governmentTrust": 36, "policyAcceptance": 39, "regulationPreference": 72, "publicServiceSatisfaction": 60}	0
1127	임민서	34	30-39	Female	서울특별시	37.490129	126.952694	대학교 졸	200-350만원	생산직	자녀 양육 가구	-33	진보 성향 무당층	56	{"economy": -20, "housing": 29, "welfare": 44, "security": -19, "environment": 42}	SNS	{성장,전통,공동체}	서울특별시에 거주하는 30-39 생산직. 정치 성향은 중도이며 성장, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 78, "ecoConsciousness": 49, "priceSensitivity": 49, "digitalConsumption": 80}	{"taxTolerance": 38, "governmentTrust": 52, "policyAcceptance": 19, "regulationPreference": 50, "publicServiceSatisfaction": 57}	0
1128	전준서	32	30-39	Female	서울특별시	37.575648	127.043751	대학원 졸	350-500만원	사무직	부부 가구	-10	중도 무당층	56	{"economy": -28, "housing": 27, "welfare": 23, "security": -7, "environment": 24}	지상파/종편 뉴스	{다양성,자유,전통}	서울특별시에 거주하는 30-39 사무직. 정치 성향은 중도이며 다양성, 자유, 전통 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 59, "ecoConsciousness": 64, "priceSensitivity": 61, "digitalConsumption": 91}	{"taxTolerance": 58, "governmentTrust": 55, "policyAcceptance": 43, "regulationPreference": 50, "publicServiceSatisfaction": 88}	0
1129	조광수	31	30-39	Female	서울특별시	37.615906	127.036771	대학교 졸	350-500만원	생산직	부부 가구	-14	중도 무당층	56	{"economy": -28, "housing": 16, "welfare": 23, "security": -2, "environment": 34}	신문/팟캐스트	{공정,자유,공동체}	서울특별시에 거주하는 30-39 생산직. 정치 성향은 중도이며 공정, 자유, 공동체 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 87, "ecoConsciousness": 49, "priceSensitivity": 75, "digitalConsumption": 69}	{"taxTolerance": 46, "governmentTrust": 25, "policyAcceptance": 60, "regulationPreference": 75, "publicServiceSatisfaction": 68}	0
1130	임다은	33	30-39	Female	서울특별시	37.572175	126.925025	대학원 졸	200만원 미만	사무직	부부 가구	-24	진보 성향 무당층	57	{"economy": -28, "housing": -3, "welfare": 17, "security": 17, "environment": 25}	포털 뉴스	{안정,다양성,혁신}	서울특별시에 거주하는 30-39 사무직. 정치 성향은 중도이며 안정, 다양성, 혁신 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 87, "ecoConsciousness": 45, "priceSensitivity": 76, "digitalConsumption": 61}	{"taxTolerance": 60, "governmentTrust": 54, "policyAcceptance": 38, "regulationPreference": 44, "publicServiceSatisfaction": 69}	0
1131	정하은	39	30-39	Female	서울특별시	37.611457	126.987005	전문대 졸	350-500만원	전문직	자녀 양육 가구	16	보수 성향 무당층	79	{"economy": -9, "housing": 4, "welfare": 3, "security": 39, "environment": -4}	SNS	{성장,안전,전통}	서울특별시에 거주하는 30-39 전문직. 정치 성향은 중도이며 성장, 안전, 전통 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 64, "ecoConsciousness": 57, "priceSensitivity": 69, "digitalConsumption": 89}	{"taxTolerance": 59, "governmentTrust": 37, "policyAcceptance": 57, "regulationPreference": 68, "publicServiceSatisfaction": 64}	0
1132	황지우	37	30-39	Female	서울특별시	37.51547	126.932971	고졸 이하	200-350만원	자영업	자녀 양육 가구	14	중도 무당층	59	{"economy": -10, "housing": -18, "welfare": 50, "security": 9, "environment": 2}	SNS	{안정,성장,자유}	서울특별시에 거주하는 30-39 자영업. 정치 성향은 중도이며 안정, 성장, 자유 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 55, "ecoConsciousness": 52, "priceSensitivity": 78, "digitalConsumption": 96}	{"taxTolerance": 43, "governmentTrust": 41, "policyAcceptance": 62, "regulationPreference": 67, "publicServiceSatisfaction": 66}	0
1133	오유준	32	30-39	Female	서울특별시	37.545103	126.976054	대학원 졸	200-350만원	공무원	부부 가구	-31	진보 성향 무당층	52	{"economy": -49, "housing": 68, "welfare": 33, "security": -2, "environment": 34}	지상파/종편 뉴스	{다양성,안전,안정}	서울특별시에 거주하는 30-39 공무원. 정치 성향은 중도이며 다양성, 안전, 안정 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 66, "ecoConsciousness": 48, "priceSensitivity": 43, "digitalConsumption": 66}	{"taxTolerance": 39, "governmentTrust": 47, "policyAcceptance": 39, "regulationPreference": 48, "publicServiceSatisfaction": 54}	0
1134	서도윤	30	30-39	Female	서울특별시	37.551462	126.932572	대학원 졸	350-500만원	사무직	1인 가구	-55	진보 정당 지지	80	{"economy": -30, "housing": 36, "welfare": 42, "security": -42, "environment": 3}	지상파/종편 뉴스	{혁신,안전,환경}	서울특별시에 거주하는 30-39 사무직. 정치 성향은 진보이며 혁신, 안전, 환경 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 74, "ecoConsciousness": 60, "priceSensitivity": 64, "digitalConsumption": 76}	{"taxTolerance": 59, "governmentTrust": 31, "policyAcceptance": 35, "regulationPreference": 63, "publicServiceSatisfaction": 70}	0
1135	신순자	38	30-39	Female	서울특별시	37.597483	127.028803	대학원 졸	350-500만원	서비스직	부부 가구	11	중도 무당층	64	{"economy": 9, "housing": 15, "welfare": 17, "security": 9, "environment": 26}	유튜브	{성장,자유,안전}	서울특별시에 거주하는 30-39 서비스직. 정치 성향은 중도이며 성장, 자유, 안전 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 75, "ecoConsciousness": 55, "priceSensitivity": 74, "digitalConsumption": 63}	{"taxTolerance": 55, "governmentTrust": 48, "policyAcceptance": 34, "regulationPreference": 77, "publicServiceSatisfaction": 71}	0
1136	장현우	35	30-39	Male	서울특별시	37.642491	127.049135	전문대 졸	500-700만원	사무직	부부 가구	10	중도 무당층	56	{"economy": 6, "housing": 11, "welfare": 13, "security": 22, "environment": -2}	SNS	{안정,다양성,환경}	서울특별시에 거주하는 30-39 사무직. 정치 성향은 중도이며 안정, 다양성, 환경 가치를 중시한다.	{"brandLoyalty": 23, "noveltySeeking": 55, "ecoConsciousness": 34, "priceSensitivity": 51, "digitalConsumption": 85}	{"taxTolerance": 46, "governmentTrust": 42, "policyAcceptance": 38, "regulationPreference": 72, "publicServiceSatisfaction": 60}	0
1137	송경숙	30	30-39	Male	서울특별시	37.57989	126.919567	대학원 졸	200-350만원	서비스직	1인 가구	-21	진보 성향 무당층	30	{"economy": 0, "housing": 27, "welfare": 24, "security": -14, "environment": 23}	지상파/종편 뉴스	{성장,혁신,공동체}	서울특별시에 거주하는 30-39 서비스직. 정치 성향은 중도이며 성장, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 67, "ecoConsciousness": 49, "priceSensitivity": 77, "digitalConsumption": 84}	{"taxTolerance": 50, "governmentTrust": 44, "policyAcceptance": 35, "regulationPreference": 63, "publicServiceSatisfaction": 66}	0
1138	정성호	37	30-39	Male	서울특별시	37.527259	126.922792	전문대 졸	350-500만원	전문직	자녀 양육 가구	-3	중도 무당층	70	{"economy": -30, "housing": 48, "welfare": 13, "security": 2, "environment": 30}	지상파/종편 뉴스	{안전,안정,성장}	서울특별시에 거주하는 30-39 전문직. 정치 성향은 중도이며 안전, 안정, 성장 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 71, "ecoConsciousness": 27, "priceSensitivity": 65, "digitalConsumption": 57}	{"taxTolerance": 29, "governmentTrust": 44, "policyAcceptance": 55, "regulationPreference": 48, "publicServiceSatisfaction": 62}	0
1139	김민준	39	30-39	Male	서울특별시	37.620472	126.948052	대학교 졸	500-700만원	프리랜서	자녀 양육 가구	10	중도 무당층	54	{"economy": -13, "housing": 8, "welfare": 22, "security": 4, "environment": 12}	SNS	{안정,공동체,안전}	서울특별시에 거주하는 30-39 프리랜서. 정치 성향은 중도이며 안정, 공동체, 안전 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 61, "ecoConsciousness": 66, "priceSensitivity": 52, "digitalConsumption": 80}	{"taxTolerance": 56, "governmentTrust": 52, "policyAcceptance": 71, "regulationPreference": 75, "publicServiceSatisfaction": 59}	0
1140	윤성호	38	30-39	Male	서울특별시	37.599308	127.002853	전문대 졸	500-700만원	학생	부부 가구	19	보수 성향 무당층	71	{"economy": 7, "housing": 25, "welfare": 6, "security": 18, "environment": 18}	신문/팟캐스트	{공정,혁신,공동체}	서울특별시에 거주하는 30-39 학생. 정치 성향은 중도이며 공정, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 76, "ecoConsciousness": 57, "priceSensitivity": 61, "digitalConsumption": 66}	{"taxTolerance": 48, "governmentTrust": 40, "policyAcceptance": 47, "regulationPreference": 68, "publicServiceSatisfaction": 66}	0
1141	임은우	31	30-39	Male	서울특별시	37.513758	126.89102	대학교 졸	200만원 미만	공무원	1인 가구	-7	중도 무당층	52	{"economy": -13, "housing": 11, "welfare": 42, "security": -3, "environment": 10}	포털 뉴스	{성장,환경,전통}	서울특별시에 거주하는 30-39 공무원. 정치 성향은 중도이며 성장, 환경, 전통 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 79, "ecoConsciousness": 53, "priceSensitivity": 71, "digitalConsumption": 71}	{"taxTolerance": 50, "governmentTrust": 43, "policyAcceptance": 36, "regulationPreference": 76, "publicServiceSatisfaction": 61}	0
1142	홍경숙	31	30-39	Male	서울특별시	37.495826	127.061937	대학원 졸	350-500만원	프리랜서	1인 가구	-10	중도 무당층	50	{"economy": 6, "housing": 18, "welfare": -1, "security": -1, "environment": -4}	SNS	{안정,성장,자유}	서울특별시에 거주하는 30-39 프리랜서. 정치 성향은 중도이며 안정, 성장, 자유 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 87, "ecoConsciousness": 74, "priceSensitivity": 76, "digitalConsumption": 79}	{"taxTolerance": 51, "governmentTrust": 43, "policyAcceptance": 45, "regulationPreference": 79, "publicServiceSatisfaction": 51}	0
1143	류철수	34	30-39	Male	서울특별시	37.581525	127.077183	대학원 졸	200만원 미만	서비스직	부부 가구	-29	진보 성향 무당층	39	{"economy": -39, "housing": 37, "welfare": 36, "security": 9, "environment": 41}	SNS	{공정,안전,안정}	서울특별시에 거주하는 30-39 서비스직. 정치 성향은 중도이며 공정, 안전, 안정 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 79, "ecoConsciousness": 57, "priceSensitivity": 74, "digitalConsumption": 76}	{"taxTolerance": 56, "governmentTrust": 47, "policyAcceptance": 60, "regulationPreference": 62, "publicServiceSatisfaction": 73}	0
1144	임지민	32	30-39	Male	서울특별시	37.635001	126.883251	전문대 졸	700만원 이상	주부	1인 가구	-12	중도 무당층	54	{"economy": -6, "housing": 10, "welfare": 26, "security": 14, "environment": 7}	지상파/종편 뉴스	{전통,혁신,안전}	서울특별시에 거주하는 30-39 주부. 정치 성향은 중도이며 전통, 혁신, 안전 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 59, "ecoConsciousness": 57, "priceSensitivity": 42, "digitalConsumption": 68}	{"taxTolerance": 34, "governmentTrust": 48, "policyAcceptance": 59, "regulationPreference": 75, "publicServiceSatisfaction": 72}	0
1145	박영수	33	30-39	Male	서울특별시	37.52757	126.955044	대학교 졸	200-350만원	학생	부부 가구	4	중도 무당층	33	{"economy": -2, "housing": 20, "welfare": 10, "security": 3, "environment": 37}	유튜브	{안전,전통,자유}	서울특별시에 거주하는 30-39 학생. 정치 성향은 중도이며 안전, 전통, 자유 가치를 중시한다.	{"brandLoyalty": 21, "noveltySeeking": 66, "ecoConsciousness": 43, "priceSensitivity": 59, "digitalConsumption": 71}	{"taxTolerance": 34, "governmentTrust": 35, "policyAcceptance": 36, "regulationPreference": 78, "publicServiceSatisfaction": 66}	0
1146	강하은	35	30-39	Male	서울특별시	37.500832	127.060946	대학원 졸	350-500만원	생산직	다세대 가구	-23	진보 성향 무당층	52	{"economy": -15, "housing": 14, "welfare": 5, "security": 17, "environment": 51}	지상파/종편 뉴스	{안정,혁신,자유}	서울특별시에 거주하는 30-39 생산직. 정치 성향은 중도이며 안정, 혁신, 자유 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 66, "ecoConsciousness": 49, "priceSensitivity": 66, "digitalConsumption": 79}	{"taxTolerance": 66, "governmentTrust": 42, "policyAcceptance": 29, "regulationPreference": 69, "publicServiceSatisfaction": 69}	0
1147	권유준	41	40-49	Female	서울특별시	37.50594	127.062301	대학교 졸	200-350만원	전문직	자녀 양육 가구	17	보수 성향 무당층	54	{"economy": -14, "housing": 6, "welfare": -26, "security": 9, "environment": 0}	지상파/종편 뉴스	{안전,전통,성장}	서울특별시에 거주하는 40-49 전문직. 정치 성향은 중도이며 안전, 전통, 성장 가치를 중시한다.	{"brandLoyalty": 15, "noveltySeeking": 75, "ecoConsciousness": 46, "priceSensitivity": 53, "digitalConsumption": 67}	{"taxTolerance": 45, "governmentTrust": 32, "policyAcceptance": 54, "regulationPreference": 48, "publicServiceSatisfaction": 76}	0
1148	윤지호	49	40-49	Female	서울특별시	37.593587	127.008759	전문대 졸	500-700만원	은퇴	다세대 가구	-23	진보 성향 무당층	74	{"economy": -26, "housing": 6, "welfare": 31, "security": -3, "environment": 24}	SNS	{전통,혁신,공동체}	서울특별시에 거주하는 40-49 은퇴. 정치 성향은 중도이며 전통, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 69, "ecoConsciousness": 48, "priceSensitivity": 65, "digitalConsumption": 66}	{"taxTolerance": 31, "governmentTrust": 46, "policyAcceptance": 45, "regulationPreference": 72, "publicServiceSatisfaction": 51}	0
1149	윤준서	40	40-49	Female	서울특별시	37.578286	126.993593	대학교 졸	700만원 이상	생산직	자녀 양육 가구	3	중도 무당층	71	{"economy": 14, "housing": 30, "welfare": 25, "security": -3, "environment": 19}	유튜브	{공정,자유,혁신}	서울특별시에 거주하는 40-49 생산직. 정치 성향은 중도이며 공정, 자유, 혁신 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 67, "ecoConsciousness": 56, "priceSensitivity": 50, "digitalConsumption": 64}	{"taxTolerance": 42, "governmentTrust": 42, "policyAcceptance": 74, "regulationPreference": 73, "publicServiceSatisfaction": 41}	0
1150	황현우	49	40-49	Female	서울특별시	37.501711	127.005075	전문대 졸	700만원 이상	사무직	다세대 가구	-15	진보 성향 무당층	51	{"economy": -4, "housing": 12, "welfare": 36, "security": -9, "environment": 4}	SNS	{전통,안전,다양성}	서울특별시에 거주하는 40-49 사무직. 정치 성향은 중도이며 전통, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 62, "ecoConsciousness": 64, "priceSensitivity": 45, "digitalConsumption": 68}	{"taxTolerance": 56, "governmentTrust": 33, "policyAcceptance": 26, "regulationPreference": 42, "publicServiceSatisfaction": 61}	0
1151	장미경	49	40-49	Female	서울특별시	37.541804	127.052043	고졸 이하	500-700만원	공무원	자녀 양육 가구	-22	진보 성향 무당층	43	{"economy": -39, "housing": 19, "welfare": 17, "security": 7, "environment": 42}	신문/팟캐스트	{공동체,혁신,안전}	서울특별시에 거주하는 40-49 공무원. 정치 성향은 중도이며 공동체, 혁신, 안전 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 40, "ecoConsciousness": 49, "priceSensitivity": 52, "digitalConsumption": 67}	{"taxTolerance": 34, "governmentTrust": 45, "policyAcceptance": 38, "regulationPreference": 53, "publicServiceSatisfaction": 62}	0
1152	전영수	42	40-49	Female	서울특별시	37.493994	126.908758	대학원 졸	700만원 이상	사무직	1인 가구	26	보수 성향 무당층	59	{"economy": -16, "housing": 0, "welfare": -19, "security": 11, "environment": 4}	SNS	{안전,혁신,공동체}	서울특별시에 거주하는 40-49 사무직. 정치 성향은 중도이며 안전, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 74, "ecoConsciousness": 55, "priceSensitivity": 46, "digitalConsumption": 69}	{"taxTolerance": 58, "governmentTrust": 45, "policyAcceptance": 54, "regulationPreference": 75, "publicServiceSatisfaction": 61}	0
1153	권다은	46	40-49	Female	서울특별시	37.583371	126.942978	전문대 졸	500-700만원	사무직	다세대 가구	-10	중도 무당층	77	{"economy": -23, "housing": 17, "welfare": 22, "security": 7, "environment": 3}	신문/팟캐스트	{안정,성장,다양성}	서울특별시에 거주하는 40-49 사무직. 정치 성향은 중도이며 안정, 성장, 다양성 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 69, "ecoConsciousness": 23, "priceSensitivity": 73, "digitalConsumption": 74}	{"taxTolerance": 48, "governmentTrust": 29, "policyAcceptance": 60, "regulationPreference": 59, "publicServiceSatisfaction": 76}	0
1154	이예준	46	40-49	Female	서울특별시	37.615417	127.042961	대학교 졸	500-700만원	주부	1인 가구	-47	진보 정당 지지	53	{"economy": -30, "housing": 42, "welfare": 82, "security": -22, "environment": 38}	SNS	{안전,다양성,성장}	서울특별시에 거주하는 40-49 주부. 정치 성향은 진보이며 안전, 다양성, 성장 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 51, "ecoConsciousness": 54, "priceSensitivity": 64, "digitalConsumption": 59}	{"taxTolerance": 48, "governmentTrust": 56, "policyAcceptance": 46, "regulationPreference": 58, "publicServiceSatisfaction": 60}	0
1155	오동현	41	40-49	Female	서울특별시	37.562738	126.911424	대학교 졸	200-350만원	주부	부부 가구	-16	진보 성향 무당층	75	{"economy": -30, "housing": 16, "welfare": 27, "security": 10, "environment": -8}	유튜브	{전통,공정,안정}	서울특별시에 거주하는 40-49 주부. 정치 성향은 중도이며 전통, 공정, 안정 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 75, "ecoConsciousness": 35, "priceSensitivity": 61, "digitalConsumption": 83}	{"taxTolerance": 53, "governmentTrust": 51, "policyAcceptance": 52, "regulationPreference": 64, "publicServiceSatisfaction": 89}	0
1156	정지아	47	40-49	Female	서울특별시	37.518218	127.017834	대학원 졸	500-700만원	학생	부부 가구	24	보수 성향 무당층	80	{"economy": 3, "housing": 32, "welfare": 21, "security": 28, "environment": 12}	지상파/종편 뉴스	{혁신,전통,성장}	서울특별시에 거주하는 40-49 학생. 정치 성향은 중도이며 혁신, 전통, 성장 가치를 중시한다.	{"brandLoyalty": 67, "noveltySeeking": 83, "ecoConsciousness": 47, "priceSensitivity": 58, "digitalConsumption": 73}	{"taxTolerance": 41, "governmentTrust": 6, "policyAcceptance": 47, "regulationPreference": 54, "publicServiceSatisfaction": 74}	0
1157	임예준	48	40-49	Female	서울특별시	37.583237	126.99232	대학교 졸	500-700만원	주부	부부 가구	-12	중도 무당층	60	{"economy": 12, "housing": 11, "welfare": 11, "security": 1, "environment": 38}	유튜브	{안정,공정,환경}	서울특별시에 거주하는 40-49 주부. 정치 성향은 중도이며 안정, 공정, 환경 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 66, "ecoConsciousness": 49, "priceSensitivity": 64, "digitalConsumption": 60}	{"taxTolerance": 52, "governmentTrust": 47, "policyAcceptance": 33, "regulationPreference": 69, "publicServiceSatisfaction": 83}	0
1158	황성호	41	40-49	Female	서울특별시	37.561746	127.016396	대학교 졸	350-500만원	서비스직	1인 가구	-16	진보 성향 무당층	62	{"economy": -13, "housing": 10, "welfare": 15, "security": -14, "environment": 39}	유튜브	{자유,안전,전통}	서울특별시에 거주하는 40-49 서비스직. 정치 성향은 중도이며 자유, 안전, 전통 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 65, "ecoConsciousness": 48, "priceSensitivity": 61, "digitalConsumption": 72}	{"taxTolerance": 42, "governmentTrust": 50, "policyAcceptance": 45, "regulationPreference": 79, "publicServiceSatisfaction": 54}	0
1159	한민준	49	40-49	Female	서울특별시	37.582606	126.892667	전문대 졸	700만원 이상	전문직	자녀 양육 가구	-10	중도 무당층	59	{"economy": -33, "housing": 24, "welfare": 10, "security": 30, "environment": 38}	지상파/종편 뉴스	{전통,안정,성장}	서울특별시에 거주하는 40-49 전문직. 정치 성향은 중도이며 전통, 안정, 성장 가치를 중시한다.	{"brandLoyalty": 24, "noveltySeeking": 44, "ecoConsciousness": 54, "priceSensitivity": 44, "digitalConsumption": 61}	{"taxTolerance": 59, "governmentTrust": 46, "policyAcceptance": 53, "regulationPreference": 77, "publicServiceSatisfaction": 60}	0
1160	이서윤	42	40-49	Male	서울특별시	37.628244	126.914611	전문대 졸	350-500만원	사무직	부부 가구	-4	중도 무당층	54	{"economy": -7, "housing": 26, "welfare": 42, "security": 7, "environment": 31}	신문/팟캐스트	{자유,공정,안정}	서울특별시에 거주하는 40-49 사무직. 정치 성향은 중도이며 자유, 공정, 안정 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 62, "ecoConsciousness": 65, "priceSensitivity": 67, "digitalConsumption": 71}	{"taxTolerance": 28, "governmentTrust": 18, "policyAcceptance": 42, "regulationPreference": 64, "publicServiceSatisfaction": 66}	0
1161	권하은	44	40-49	Male	서울특별시	37.553643	127.07542	대학교 졸	700만원 이상	자영업	자녀 양육 가구	-23	진보 성향 무당층	62	{"economy": 1, "housing": 31, "welfare": 18, "security": -38, "environment": 20}	유튜브	{환경,자유,안정}	서울특별시에 거주하는 40-49 자영업. 정치 성향은 중도이며 환경, 자유, 안정 가치를 중시한다.	{"brandLoyalty": 25, "noveltySeeking": 73, "ecoConsciousness": 79, "priceSensitivity": 31, "digitalConsumption": 59}	{"taxTolerance": 53, "governmentTrust": 39, "policyAcceptance": 38, "regulationPreference": 53, "publicServiceSatisfaction": 60}	0
1162	류민서	46	40-49	Male	서울특별시	37.502128	127.008525	전문대 졸	500-700만원	공무원	다세대 가구	10	중도 무당층	65	{"economy": -2, "housing": 10, "welfare": -19, "security": -17, "environment": 17}	신문/팟캐스트	{다양성,공동체,자유}	서울특별시에 거주하는 40-49 공무원. 정치 성향은 중도이며 다양성, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 49, "ecoConsciousness": 55, "priceSensitivity": 45, "digitalConsumption": 78}	{"taxTolerance": 37, "governmentTrust": 30, "policyAcceptance": 44, "regulationPreference": 53, "publicServiceSatisfaction": 68}	0
1163	장준서	47	40-49	Male	서울특별시	37.58907	126.914737	대학교 졸	350-500만원	학생	1인 가구	27	보수 성향 무당층	77	{"economy": 41, "housing": 13, "welfare": 16, "security": 6, "environment": 21}	포털 뉴스	{공정,전통,자유}	서울특별시에 거주하는 40-49 학생. 정치 성향은 중도이며 공정, 전통, 자유 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 41, "ecoConsciousness": 42, "priceSensitivity": 35, "digitalConsumption": 76}	{"taxTolerance": 58, "governmentTrust": 46, "policyAcceptance": 43, "regulationPreference": 65, "publicServiceSatisfaction": 47}	0
1164	강순자	41	40-49	Male	서울특별시	37.586454	127.043359	대학교 졸	700만원 이상	자영업	부부 가구	29	보수 성향 무당층	54	{"economy": 6, "housing": 24, "welfare": 20, "security": 17, "environment": 11}	포털 뉴스	{혁신,공동체,자유}	서울특별시에 거주하는 40-49 자영업. 정치 성향은 중도이며 혁신, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 70, "ecoConsciousness": 51, "priceSensitivity": 48, "digitalConsumption": 74}	{"taxTolerance": 76, "governmentTrust": 42, "policyAcceptance": 42, "regulationPreference": 36, "publicServiceSatisfaction": 53}	0
1165	황경숙	42	40-49	Male	서울특별시	37.570015	127.076642	전문대 졸	200-350만원	사무직	부부 가구	-9	중도 무당층	52	{"economy": -15, "housing": 15, "welfare": 3, "security": -5, "environment": 29}	SNS	{환경,혁신,공정}	서울특별시에 거주하는 40-49 사무직. 정치 성향은 중도이며 환경, 혁신, 공정 가치를 중시한다.	{"brandLoyalty": 60, "noveltySeeking": 77, "ecoConsciousness": 59, "priceSensitivity": 66, "digitalConsumption": 78}	{"taxTolerance": 54, "governmentTrust": 34, "policyAcceptance": 46, "regulationPreference": 64, "publicServiceSatisfaction": 67}	0
1166	권경숙	46	40-49	Male	서울특별시	37.62772	126.882643	전문대 졸	500-700만원	공무원	부부 가구	-24	진보 성향 무당층	84	{"economy": -16, "housing": 26, "welfare": 15, "security": -18, "environment": 48}	지상파/종편 뉴스	{다양성,자유,전통}	서울특별시에 거주하는 40-49 공무원. 정치 성향은 중도이며 다양성, 자유, 전통 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 63, "ecoConsciousness": 23, "priceSensitivity": 59, "digitalConsumption": 61}	{"taxTolerance": 52, "governmentTrust": 41, "policyAcceptance": 54, "regulationPreference": 67, "publicServiceSatisfaction": 81}	0
1167	권지민	48	40-49	Male	서울특별시	37.640908	126.988995	전문대 졸	700만원 이상	프리랜서	부부 가구	9	중도 무당층	87	{"economy": -19, "housing": 17, "welfare": 7, "security": -8, "environment": 44}	신문/팟캐스트	{전통,안전,환경}	서울특별시에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 전통, 안전, 환경 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 55, "ecoConsciousness": 51, "priceSensitivity": 41, "digitalConsumption": 65}	{"taxTolerance": 55, "governmentTrust": 51, "policyAcceptance": 56, "regulationPreference": 49, "publicServiceSatisfaction": 69}	0
1168	이유준	45	40-49	Male	서울특별시	37.559589	127.05443	전문대 졸	350-500만원	서비스직	부부 가구	-1	중도 무당층	76	{"economy": 3, "housing": 28, "welfare": 22, "security": 29, "environment": 18}	포털 뉴스	{혁신,다양성,자유}	서울특별시에 거주하는 40-49 서비스직. 정치 성향은 중도이며 혁신, 다양성, 자유 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 46, "ecoConsciousness": 34, "priceSensitivity": 56, "digitalConsumption": 56}	{"taxTolerance": 30, "governmentTrust": 38, "policyAcceptance": 57, "regulationPreference": 43, "publicServiceSatisfaction": 75}	0
1169	류지우	49	40-49	Male	서울특별시	37.619254	126.896664	고졸 이하	500-700만원	사무직	부부 가구	-24	진보 성향 무당층	90	{"economy": -5, "housing": 16, "welfare": 0, "security": 7, "environment": 30}	신문/팟캐스트	{전통,공정,혁신}	서울특별시에 거주하는 40-49 사무직. 정치 성향은 중도이며 전통, 공정, 혁신 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 63, "ecoConsciousness": 38, "priceSensitivity": 50, "digitalConsumption": 60}	{"taxTolerance": 40, "governmentTrust": 62, "policyAcceptance": 47, "regulationPreference": 61, "publicServiceSatisfaction": 53}	0
1170	권수아	42	40-49	Male	서울특별시	37.643452	126.956807	전문대 졸	700만원 이상	자영업	자녀 양육 가구	10	중도 무당층	71	{"economy": 11, "housing": 0, "welfare": 35, "security": -14, "environment": 0}	SNS	{다양성,전통,공동체}	서울특별시에 거주하는 40-49 자영업. 정치 성향은 중도이며 다양성, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 67, "ecoConsciousness": 46, "priceSensitivity": 45, "digitalConsumption": 75}	{"taxTolerance": 45, "governmentTrust": 43, "policyAcceptance": 57, "regulationPreference": 61, "publicServiceSatisfaction": 78}	0
1171	안정희	43	40-49	Male	서울특별시	37.543412	127.020664	대학교 졸	500-700만원	자영업	다세대 가구	-47	진보 정당 지지	59	{"economy": -19, "housing": 16, "welfare": 55, "security": -6, "environment": 36}	유튜브	{다양성,전통,성장}	서울특별시에 거주하는 40-49 자영업. 정치 성향은 진보이며 다양성, 전통, 성장 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 60, "ecoConsciousness": 40, "priceSensitivity": 59, "digitalConsumption": 83}	{"taxTolerance": 70, "governmentTrust": 36, "policyAcceptance": 41, "regulationPreference": 59, "publicServiceSatisfaction": 99}	0
1172	장현우	43	40-49	Male	서울특별시	37.615958	126.905537	전문대 졸	700만원 이상	사무직	부부 가구	29	보수 성향 무당층	44	{"economy": 54, "housing": 15, "welfare": -5, "security": 16, "environment": 24}	유튜브	{성장,전통,공정}	서울특별시에 거주하는 40-49 사무직. 정치 성향은 중도이며 성장, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 26, "noveltySeeking": 32, "ecoConsciousness": 67, "priceSensitivity": 36, "digitalConsumption": 75}	{"taxTolerance": 44, "governmentTrust": 47, "policyAcceptance": 35, "regulationPreference": 41, "publicServiceSatisfaction": 67}	0
1173	서영수	52	50-59	Female	서울특별시	37.637596	126.913371	전문대 졸	350-500만원	전문직	1인 가구	7	중도 무당층	81	{"economy": -13, "housing": 17, "welfare": -16, "security": -25, "environment": 13}	포털 뉴스	{전통,공동체,성장}	서울특별시에 거주하는 50-59 전문직. 정치 성향은 중도이며 전통, 공동체, 성장 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 56, "ecoConsciousness": 57, "priceSensitivity": 58, "digitalConsumption": 73}	{"taxTolerance": 45, "governmentTrust": 29, "policyAcceptance": 50, "regulationPreference": 59, "publicServiceSatisfaction": 76}	0
1174	정은우	54	50-59	Female	서울특별시	37.637663	126.882897	고졸 이하	700만원 이상	전문직	1인 가구	8	중도 무당층	69	{"economy": 9, "housing": 22, "welfare": 4, "security": -10, "environment": 9}	지상파/종편 뉴스	{성장,공정,전통}	서울특별시에 거주하는 50-59 전문직. 정치 성향은 중도이며 성장, 공정, 전통 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 53, "ecoConsciousness": 25, "priceSensitivity": 47, "digitalConsumption": 76}	{"taxTolerance": 55, "governmentTrust": 41, "policyAcceptance": 49, "regulationPreference": 63, "publicServiceSatisfaction": 60}	0
1175	장성호	54	50-59	Female	서울특별시	37.612612	127.057058	전문대 졸	200-350만원	프리랜서	1인 가구	-1	중도 무당층	51	{"economy": -35, "housing": -4, "welfare": 3, "security": 14, "environment": 7}	신문/팟캐스트	{혁신,전통,안정}	서울특별시에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 혁신, 전통, 안정 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 51, "ecoConsciousness": 43, "priceSensitivity": 73, "digitalConsumption": 89}	{"taxTolerance": 59, "governmentTrust": 44, "policyAcceptance": 55, "regulationPreference": 55, "publicServiceSatisfaction": 59}	0
1176	홍정희	59	50-59	Female	서울특별시	37.538577	126.901506	대학교 졸	200-350만원	공무원	자녀 양육 가구	5	중도 무당층	88	{"economy": 4, "housing": 20, "welfare": 16, "security": 21, "environment": 12}	신문/팟캐스트	{공동체,안전,전통}	서울특별시에 거주하는 50-59 공무원. 정치 성향은 중도이며 공동체, 안전, 전통 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 69, "ecoConsciousness": 15, "priceSensitivity": 75, "digitalConsumption": 48}	{"taxTolerance": 58, "governmentTrust": 51, "policyAcceptance": 69, "regulationPreference": 74, "publicServiceSatisfaction": 70}	0
1177	윤하은	50	50-59	Female	서울특별시	37.63486	126.983839	대학교 졸	350-500만원	생산직	다세대 가구	19	보수 성향 무당층	59	{"economy": -8, "housing": 13, "welfare": -32, "security": 9, "environment": 10}	포털 뉴스	{공정,공동체,안정}	서울특별시에 거주하는 50-59 생산직. 정치 성향은 중도이며 공정, 공동체, 안정 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 60, "ecoConsciousness": 62, "priceSensitivity": 67, "digitalConsumption": 79}	{"taxTolerance": 58, "governmentTrust": 55, "policyAcceptance": 50, "regulationPreference": 78, "publicServiceSatisfaction": 51}	0
1178	최경숙	51	50-59	Female	서울특별시	37.525366	127.048106	대학원 졸	350-500만원	주부	자녀 양육 가구	9	중도 무당층	65	{"economy": 7, "housing": 11, "welfare": -1, "security": 2, "environment": 4}	포털 뉴스	{안전,자유,안정}	서울특별시에 거주하는 50-59 주부. 정치 성향은 중도이며 안전, 자유, 안정 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 74, "ecoConsciousness": 49, "priceSensitivity": 52, "digitalConsumption": 65}	{"taxTolerance": 52, "governmentTrust": 44, "policyAcceptance": 43, "regulationPreference": 74, "publicServiceSatisfaction": 70}	0
1179	윤경숙	56	50-59	Female	서울특별시	37.6121	126.880478	전문대 졸	500-700만원	전문직	다세대 가구	-12	중도 무당층	65	{"economy": -20, "housing": 30, "welfare": 34, "security": -7, "environment": 24}	유튜브	{환경,안전,공동체}	서울특별시에 거주하는 50-59 전문직. 정치 성향은 중도이며 환경, 안전, 공동체 가치를 중시한다.	{"brandLoyalty": 66, "noveltySeeking": 40, "ecoConsciousness": 42, "priceSensitivity": 60, "digitalConsumption": 81}	{"taxTolerance": 50, "governmentTrust": 54, "policyAcceptance": 60, "regulationPreference": 67, "publicServiceSatisfaction": 66}	0
1180	전유준	57	50-59	Female	서울특별시	37.495842	127.050433	대학원 졸	200-350만원	서비스직	다세대 가구	-4	중도 무당층	65	{"economy": -4, "housing": 18, "welfare": 39, "security": 9, "environment": 56}	유튜브	{자유,공정,전통}	서울특별시에 거주하는 50-59 서비스직. 정치 성향은 중도이며 자유, 공정, 전통 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 78, "ecoConsciousness": 45, "priceSensitivity": 70, "digitalConsumption": 57}	{"taxTolerance": 55, "governmentTrust": 44, "policyAcceptance": 38, "regulationPreference": 58, "publicServiceSatisfaction": 86}	0
1181	홍혜진	58	50-59	Female	서울특별시	37.555295	127.008872	대학원 졸	200-350만원	생산직	자녀 양육 가구	37	보수 성향 무당층	84	{"economy": 19, "housing": 21, "welfare": 5, "security": 24, "environment": 27}	지상파/종편 뉴스	{혁신,공정,전통}	서울특별시에 거주하는 50-59 생산직. 정치 성향은 보수이며 혁신, 공정, 전통 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 68, "ecoConsciousness": 46, "priceSensitivity": 56, "digitalConsumption": 59}	{"taxTolerance": 61, "governmentTrust": 38, "policyAcceptance": 49, "regulationPreference": 64, "publicServiceSatisfaction": 67}	0
1182	이민준	53	50-59	Female	서울특별시	37.583101	127.000648	고졸 이하	350-500만원	전문직	다세대 가구	11	중도 무당층	79	{"economy": 3, "housing": -2, "welfare": 13, "security": 17, "environment": -9}	신문/팟캐스트	{자유,환경,안정}	서울특별시에 거주하는 50-59 전문직. 정치 성향은 중도이며 자유, 환경, 안정 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 49, "ecoConsciousness": 51, "priceSensitivity": 61, "digitalConsumption": 69}	{"taxTolerance": 35, "governmentTrust": 37, "policyAcceptance": 44, "regulationPreference": 55, "publicServiceSatisfaction": 77}	0
1183	안유준	55	50-59	Female	서울특별시	37.594493	126.896972	전문대 졸	200-350만원	은퇴	부부 가구	40	보수 성향 무당층	52	{"economy": 13, "housing": 1, "welfare": -15, "security": 7, "environment": 19}	신문/팟캐스트	{다양성,혁신,성장}	서울특별시에 거주하는 50-59 은퇴. 정치 성향은 보수이며 다양성, 혁신, 성장 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 75, "ecoConsciousness": 63, "priceSensitivity": 63, "digitalConsumption": 71}	{"taxTolerance": 58, "governmentTrust": 54, "policyAcceptance": 52, "regulationPreference": 68, "publicServiceSatisfaction": 61}	0
1184	장영수	51	50-59	Female	서울특별시	37.578203	127.021663	전문대 졸	700만원 이상	자영업	다세대 가구	14	중도 무당층	85	{"economy": 4, "housing": 28, "welfare": -3, "security": 39, "environment": 26}	유튜브	{안전,안정,다양성}	서울특별시에 거주하는 50-59 자영업. 정치 성향은 중도이며 안전, 안정, 다양성 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 34, "ecoConsciousness": 59, "priceSensitivity": 57, "digitalConsumption": 60}	{"taxTolerance": 18, "governmentTrust": 56, "policyAcceptance": 46, "regulationPreference": 62, "publicServiceSatisfaction": 67}	0
1185	홍성호	52	50-59	Female	서울특별시	37.515767	127.001701	고졸 이하	500-700만원	공무원	부부 가구	18	보수 성향 무당층	66	{"economy": -2, "housing": -12, "welfare": -3, "security": -3, "environment": 7}	포털 뉴스	{성장,안전,전통}	서울특별시에 거주하는 50-59 공무원. 정치 성향은 중도이며 성장, 안전, 전통 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 52, "ecoConsciousness": 47, "priceSensitivity": 52, "digitalConsumption": 53}	{"taxTolerance": 43, "governmentTrust": 62, "policyAcceptance": 39, "regulationPreference": 63, "publicServiceSatisfaction": 66}	0
1186	송철수	50	50-59	Female	서울특별시	37.606015	126.913524	전문대 졸	500-700만원	전문직	자녀 양육 가구	13	중도 무당층	56	{"economy": 37, "housing": -17, "welfare": 43, "security": 7, "environment": -3}	포털 뉴스	{성장,안정,다양성}	서울특별시에 거주하는 50-59 전문직. 정치 성향은 중도이며 성장, 안정, 다양성 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 49, "ecoConsciousness": 76, "priceSensitivity": 48, "digitalConsumption": 75}	{"taxTolerance": 55, "governmentTrust": 49, "policyAcceptance": 40, "regulationPreference": 54, "publicServiceSatisfaction": 58}	0
1187	황순자	55	50-59	Female	서울특별시	37.546234	126.900966	전문대 졸	200-350만원	주부	부부 가구	13	중도 무당층	67	{"economy": 17, "housing": -7, "welfare": 1, "security": 18, "environment": -12}	신문/팟캐스트	{자유,안정,공동체}	서울특별시에 거주하는 50-59 주부. 정치 성향은 중도이며 자유, 안정, 공동체 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 57, "ecoConsciousness": 44, "priceSensitivity": 45, "digitalConsumption": 74}	{"taxTolerance": 53, "governmentTrust": 33, "policyAcceptance": 62, "regulationPreference": 79, "publicServiceSatisfaction": 58}	0
1188	한서연	51	50-59	Male	서울특별시	37.615178	126.910284	대학교 졸	350-500만원	주부	다세대 가구	11	중도 무당층	62	{"economy": -15, "housing": -14, "welfare": 0, "security": 19, "environment": 14}	유튜브	{공정,전통,안전}	서울특별시에 거주하는 50-59 주부. 정치 성향은 중도이며 공정, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 59, "ecoConsciousness": 51, "priceSensitivity": 44, "digitalConsumption": 67}	{"taxTolerance": 65, "governmentTrust": 42, "policyAcceptance": 31, "regulationPreference": 69, "publicServiceSatisfaction": 55}	0
1189	송민준	59	50-59	Male	서울특별시	37.563958	126.963559	고졸 이하	350-500만원	자영업	부부 가구	19	보수 성향 무당층	69	{"economy": 27, "housing": -5, "welfare": 33, "security": 7, "environment": 21}	신문/팟캐스트	{안정,성장,다양성}	서울특별시에 거주하는 50-59 자영업. 정치 성향은 중도이며 안정, 성장, 다양성 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 63, "ecoConsciousness": 39, "priceSensitivity": 56, "digitalConsumption": 60}	{"taxTolerance": 48, "governmentTrust": 55, "policyAcceptance": 52, "regulationPreference": 60, "publicServiceSatisfaction": 64}	0
1190	송지아	54	50-59	Male	서울특별시	37.496574	126.963943	전문대 졸	350-500만원	은퇴	자녀 양육 가구	20	보수 성향 무당층	71	{"economy": 7, "housing": 23, "welfare": 13, "security": 7, "environment": 12}	유튜브	{공동체,공정,다양성}	서울특별시에 거주하는 50-59 은퇴. 정치 성향은 중도이며 공동체, 공정, 다양성 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 64, "ecoConsciousness": 45, "priceSensitivity": 67, "digitalConsumption": 76}	{"taxTolerance": 42, "governmentTrust": 49, "policyAcceptance": 49, "regulationPreference": 66, "publicServiceSatisfaction": 78}	0
1191	전다은	50	50-59	Male	서울특별시	37.603746	127.052218	대학교 졸	500-700만원	사무직	부부 가구	-1	중도 무당층	85	{"economy": 0, "housing": -3, "welfare": 16, "security": 45, "environment": 12}	지상파/종편 뉴스	{안전,혁신,자유}	서울특별시에 거주하는 50-59 사무직. 정치 성향은 중도이며 안전, 혁신, 자유 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 58, "ecoConsciousness": 66, "priceSensitivity": 61, "digitalConsumption": 52}	{"taxTolerance": 48, "governmentTrust": 50, "policyAcceptance": 51, "regulationPreference": 35, "publicServiceSatisfaction": 51}	0
1192	권채원	55	50-59	Male	서울특별시	37.621517	126.892465	고졸 이하	500-700만원	은퇴	자녀 양육 가구	-8	중도 무당층	72	{"economy": 7, "housing": 37, "welfare": -21, "security": 4, "environment": 4}	SNS	{안정,다양성,안전}	서울특별시에 거주하는 50-59 은퇴. 정치 성향은 중도이며 안정, 다양성, 안전 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 34, "ecoConsciousness": 43, "priceSensitivity": 56, "digitalConsumption": 68}	{"taxTolerance": 25, "governmentTrust": 60, "policyAcceptance": 56, "regulationPreference": 64, "publicServiceSatisfaction": 55}	0
1193	오은우	50	50-59	Male	서울특별시	37.610518	126.927971	대학교 졸	700만원 이상	공무원	부부 가구	14	중도 무당층	79	{"economy": 36, "housing": 17, "welfare": 15, "security": -15, "environment": 14}	포털 뉴스	{안정,자유,다양성}	서울특별시에 거주하는 50-59 공무원. 정치 성향은 중도이며 안정, 자유, 다양성 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 69, "ecoConsciousness": 57, "priceSensitivity": 47, "digitalConsumption": 69}	{"taxTolerance": 60, "governmentTrust": 60, "policyAcceptance": 42, "regulationPreference": 62, "publicServiceSatisfaction": 72}	0
1194	강성호	54	50-59	Male	서울특별시	37.525852	127.024224	대학원 졸	350-500만원	서비스직	부부 가구	28	보수 성향 무당층	88	{"economy": 6, "housing": 2, "welfare": 15, "security": 20, "environment": 0}	SNS	{환경,성장,전통}	서울특별시에 거주하는 50-59 서비스직. 정치 성향은 중도이며 환경, 성장, 전통 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 42, "ecoConsciousness": 58, "priceSensitivity": 55, "digitalConsumption": 65}	{"taxTolerance": 45, "governmentTrust": 23, "policyAcceptance": 55, "regulationPreference": 80, "publicServiceSatisfaction": 88}	0
1195	한도윤	54	50-59	Male	서울특별시	37.621343	126.898049	대학원 졸	350-500만원	생산직	1인 가구	-5	중도 무당층	73	{"economy": 0, "housing": 17, "welfare": 27, "security": 22, "environment": 28}	신문/팟캐스트	{혁신,공정,전통}	서울특별시에 거주하는 50-59 생산직. 정치 성향은 중도이며 혁신, 공정, 전통 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 59, "ecoConsciousness": 49, "priceSensitivity": 70, "digitalConsumption": 60}	{"taxTolerance": 36, "governmentTrust": 42, "policyAcceptance": 42, "regulationPreference": 70, "publicServiceSatisfaction": 44}	0
1196	서하은	50	50-59	Male	서울특별시	37.531647	126.891746	대학교 졸	200만원 미만	학생	1인 가구	-12	중도 무당층	57	{"economy": -7, "housing": 19, "welfare": 30, "security": 24, "environment": 31}	신문/팟캐스트	{성장,자유,환경}	서울특별시에 거주하는 50-59 학생. 정치 성향은 중도이며 성장, 자유, 환경 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 49, "ecoConsciousness": 61, "priceSensitivity": 85, "digitalConsumption": 60}	{"taxTolerance": 53, "governmentTrust": 49, "policyAcceptance": 42, "regulationPreference": 62, "publicServiceSatisfaction": 56}	0
1197	정경숙	59	50-59	Male	서울특별시	37.510247	127.057927	전문대 졸	350-500만원	전문직	부부 가구	20	보수 성향 무당층	73	{"economy": 10, "housing": 4, "welfare": -3, "security": 24, "environment": 56}	포털 뉴스	{혁신,안정,공동체}	서울특별시에 거주하는 50-59 전문직. 정치 성향은 중도이며 혁신, 안정, 공동체 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 54, "ecoConsciousness": 39, "priceSensitivity": 70, "digitalConsumption": 55}	{"taxTolerance": 40, "governmentTrust": 26, "policyAcceptance": 59, "regulationPreference": 61, "publicServiceSatisfaction": 77}	0
1198	정혜진	52	50-59	Male	서울특별시	37.499314	127.010836	대학교 졸	700만원 이상	프리랜서	부부 가구	8	중도 무당층	76	{"economy": 22, "housing": 13, "welfare": -15, "security": 16, "environment": 19}	유튜브	{안정,전통,안전}	서울특별시에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 안정, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 66, "ecoConsciousness": 48, "priceSensitivity": 51, "digitalConsumption": 50}	{"taxTolerance": 51, "governmentTrust": 43, "policyAcceptance": 48, "regulationPreference": 47, "publicServiceSatisfaction": 56}	0
1199	권미경	57	50-59	Male	서울특별시	37.532109	126.957624	전문대 졸	500-700만원	자영업	다세대 가구	36	보수 성향 무당층	67	{"economy": 31, "housing": -6, "welfare": -20, "security": 14, "environment": 13}	지상파/종편 뉴스	{환경,자유,안정}	서울특별시에 거주하는 50-59 자영업. 정치 성향은 보수이며 환경, 자유, 안정 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 62, "ecoConsciousness": 28, "priceSensitivity": 48, "digitalConsumption": 62}	{"taxTolerance": 38, "governmentTrust": 45, "policyAcceptance": 62, "regulationPreference": 74, "publicServiceSatisfaction": 62}	0
1200	안지우	56	50-59	Male	서울특별시	37.545428	126.952754	대학원 졸	350-500만원	서비스직	다세대 가구	5	중도 무당층	76	{"economy": -10, "housing": 16, "welfare": -4, "security": 5, "environment": 38}	유튜브	{환경,자유,공정}	서울특별시에 거주하는 50-59 서비스직. 정치 성향은 중도이며 환경, 자유, 공정 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 67, "ecoConsciousness": 49, "priceSensitivity": 66, "digitalConsumption": 67}	{"taxTolerance": 50, "governmentTrust": 46, "policyAcceptance": 52, "regulationPreference": 73, "publicServiceSatisfaction": 43}	0
1201	한현우	51	50-59	Male	서울특별시	37.522642	127.065959	대학교 졸	350-500만원	학생	자녀 양육 가구	36	보수 성향 무당층	56	{"economy": 37, "housing": -8, "welfare": 7, "security": 21, "environment": -5}	신문/팟캐스트	{안전,공정,전통}	서울특별시에 거주하는 50-59 학생. 정치 성향은 보수이며 안전, 공정, 전통 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 65, "ecoConsciousness": 54, "priceSensitivity": 65, "digitalConsumption": 64}	{"taxTolerance": 43, "governmentTrust": 36, "policyAcceptance": 39, "regulationPreference": 66, "publicServiceSatisfaction": 47}	0
1202	임현우	66	60-69	Female	서울특별시	37.586161	127.023964	고졸 이하	200-350만원	주부	자녀 양육 가구	17	보수 성향 무당층	61	{"economy": 9, "housing": -1, "welfare": 3, "security": 12, "environment": 11}	SNS	{전통,환경,안정}	서울특별시에 거주하는 60-69 주부. 정치 성향은 중도이며 전통, 환경, 안정 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 33, "ecoConsciousness": 49, "priceSensitivity": 82, "digitalConsumption": 51}	{"taxTolerance": 46, "governmentTrust": 31, "policyAcceptance": 40, "regulationPreference": 56, "publicServiceSatisfaction": 74}	0
1203	류지민	68	60-69	Female	서울특별시	37.593887	126.878211	고졸 이하	200만원 미만	은퇴	부부 가구	72	보수 정당 지지	82	{"economy": 38, "housing": -6, "welfare": -9, "security": 64, "environment": -5}	유튜브	{안정,공동체,공정}	서울특별시에 거주하는 60-69 은퇴. 정치 성향은 보수이며 안정, 공동체, 공정 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 37, "ecoConsciousness": 62, "priceSensitivity": 78, "digitalConsumption": 58}	{"taxTolerance": 13, "governmentTrust": 45, "policyAcceptance": 56, "regulationPreference": 49, "publicServiceSatisfaction": 68}	0
1204	최지민	67	60-69	Female	서울특별시	37.617828	127.027556	대학교 졸	500-700만원	은퇴	1인 가구	24	보수 성향 무당층	83	{"economy": 16, "housing": 39, "welfare": -44, "security": 53, "environment": 5}	유튜브	{안전,전통,자유}	서울특별시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 안전, 전통, 자유 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 55, "ecoConsciousness": 54, "priceSensitivity": 66, "digitalConsumption": 48}	{"taxTolerance": 47, "governmentTrust": 34, "policyAcceptance": 45, "regulationPreference": 50, "publicServiceSatisfaction": 63}	0
1205	송하은	61	60-69	Female	서울특별시	37.636075	126.92664	전문대 졸	500-700만원	프리랜서	1인 가구	26	보수 성향 무당층	67	{"economy": -9, "housing": -3, "welfare": -24, "security": 33, "environment": 4}	지상파/종편 뉴스	{안정,안전,전통}	서울특별시에 거주하는 60-69 프리랜서. 정치 성향은 중도이며 안정, 안전, 전통 가치를 중시한다.	{"brandLoyalty": 66, "noveltySeeking": 53, "ecoConsciousness": 68, "priceSensitivity": 47, "digitalConsumption": 57}	{"taxTolerance": 44, "governmentTrust": 48, "policyAcceptance": 56, "regulationPreference": 57, "publicServiceSatisfaction": 71}	0
1206	강건우	66	60-69	Female	서울특별시	37.502644	127.015368	대학교 졸	350-500만원	사무직	1인 가구	40	보수 성향 무당층	86	{"economy": 6, "housing": 0, "welfare": -8, "security": 18, "environment": 42}	신문/팟캐스트	{공동체,혁신,환경}	서울특별시에 거주하는 60-69 사무직. 정치 성향은 보수이며 공동체, 혁신, 환경 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 57, "ecoConsciousness": 43, "priceSensitivity": 67, "digitalConsumption": 77}	{"taxTolerance": 44, "governmentTrust": 54, "policyAcceptance": 53, "regulationPreference": 60, "publicServiceSatisfaction": 73}	0
1207	안민준	63	60-69	Female	서울특별시	37.567367	127.005572	대학원 졸	200만원 미만	서비스직	자녀 양육 가구	54	보수 정당 지지	90	{"economy": 35, "housing": -11, "welfare": 4, "security": 11, "environment": 12}	포털 뉴스	{안전,자유,혁신}	서울특별시에 거주하는 60-69 서비스직. 정치 성향은 보수이며 안전, 자유, 혁신 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 50, "ecoConsciousness": 33, "priceSensitivity": 83, "digitalConsumption": 69}	{"taxTolerance": 61, "governmentTrust": 41, "policyAcceptance": 40, "regulationPreference": 69, "publicServiceSatisfaction": 75}	0
1208	최혜진	63	60-69	Female	서울특별시	37.60954	126.947066	대학원 졸	500-700만원	전문직	부부 가구	23	보수 성향 무당층	85	{"economy": 24, "housing": -13, "welfare": 1, "security": 29, "environment": 44}	유튜브	{안정,혁신,전통}	서울특별시에 거주하는 60-69 전문직. 정치 성향은 중도이며 안정, 혁신, 전통 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 46, "ecoConsciousness": 62, "priceSensitivity": 52, "digitalConsumption": 52}	{"taxTolerance": 56, "governmentTrust": 50, "policyAcceptance": 48, "regulationPreference": 59, "publicServiceSatisfaction": 51}	0
1209	조도윤	66	60-69	Female	서울특별시	37.599636	127.048027	전문대 졸	350-500만원	공무원	부부 가구	2	중도 무당층	81	{"economy": -36, "housing": 23, "welfare": 27, "security": 30, "environment": 19}	유튜브	{환경,공정,안정}	서울특별시에 거주하는 60-69 공무원. 정치 성향은 중도이며 환경, 공정, 안정 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 56, "ecoConsciousness": 57, "priceSensitivity": 64, "digitalConsumption": 44}	{"taxTolerance": 33, "governmentTrust": 41, "policyAcceptance": 37, "regulationPreference": 58, "publicServiceSatisfaction": 59}	0
1210	김준서	63	60-69	Female	서울특별시	37.641713	127.028236	전문대 졸	500-700만원	주부	부부 가구	16	보수 성향 무당층	85	{"economy": 10, "housing": 9, "welfare": -5, "security": 12, "environment": 38}	SNS	{공정,안정,환경}	서울특별시에 거주하는 60-69 주부. 정치 성향은 중도이며 공정, 안정, 환경 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 54, "ecoConsciousness": 53, "priceSensitivity": 49, "digitalConsumption": 48}	{"taxTolerance": 43, "governmentTrust": 73, "policyAcceptance": 51, "regulationPreference": 66, "publicServiceSatisfaction": 54}	0
1211	오유준	68	60-69	Female	서울특별시	37.550229	126.894645	대학원 졸	200만원 미만	은퇴	자녀 양육 가구	24	보수 성향 무당층	67	{"economy": 13, "housing": 11, "welfare": 23, "security": 8, "environment": 25}	지상파/종편 뉴스	{성장,공정,다양성}	서울특별시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 성장, 공정, 다양성 가치를 중시한다.	{"brandLoyalty": 74, "noveltySeeking": 43, "ecoConsciousness": 56, "priceSensitivity": 83, "digitalConsumption": 76}	{"taxTolerance": 45, "governmentTrust": 41, "policyAcceptance": 34, "regulationPreference": 58, "publicServiceSatisfaction": 50}	0
1212	최영수	66	60-69	Female	서울특별시	37.496721	127.014676	대학교 졸	350-500만원	전문직	1인 가구	28	보수 성향 무당층	79	{"economy": -4, "housing": -28, "welfare": -22, "security": 14, "environment": 3}	유튜브	{자유,환경,공동체}	서울특별시에 거주하는 60-69 전문직. 정치 성향은 중도이며 자유, 환경, 공동체 가치를 중시한다.	{"brandLoyalty": 64, "noveltySeeking": 58, "ecoConsciousness": 29, "priceSensitivity": 62, "digitalConsumption": 54}	{"taxTolerance": 57, "governmentTrust": 52, "policyAcceptance": 32, "regulationPreference": 62, "publicServiceSatisfaction": 54}	0
1213	전준서	63	60-69	Female	서울특별시	37.548683	126.929757	대학교 졸	200만원 미만	생산직	부부 가구	-21	진보 성향 무당층	68	{"economy": -28, "housing": 7, "welfare": 39, "security": -13, "environment": 40}	지상파/종편 뉴스	{공동체,환경,공정}	서울특별시에 거주하는 60-69 생산직. 정치 성향은 중도이며 공동체, 환경, 공정 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 55, "ecoConsciousness": 34, "priceSensitivity": 77, "digitalConsumption": 71}	{"taxTolerance": 55, "governmentTrust": 51, "policyAcceptance": 31, "regulationPreference": 65, "publicServiceSatisfaction": 63}	0
1214	안채원	61	60-69	Male	서울특별시	37.590671	127.044049	고졸 이하	350-500만원	공무원	다세대 가구	74	보수 정당 지지	81	{"economy": 17, "housing": 7, "welfare": -10, "security": 32, "environment": -10}	포털 뉴스	{다양성,성장,자유}	서울특별시에 거주하는 60-69 공무원. 정치 성향은 보수이며 다양성, 성장, 자유 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 45, "ecoConsciousness": 41, "priceSensitivity": 55, "digitalConsumption": 70}	{"taxTolerance": 47, "governmentTrust": 66, "policyAcceptance": 64, "regulationPreference": 47, "publicServiceSatisfaction": 68}	0
1215	강지민	68	60-69	Male	서울특별시	37.5375	126.95115	전문대 졸	200-350만원	은퇴	1인 가구	5	중도 무당층	92	{"economy": -4, "housing": 18, "welfare": 22, "security": 25, "environment": 14}	신문/팟캐스트	{공동체,성장,안정}	서울특별시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 공동체, 성장, 안정 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 28, "ecoConsciousness": 30, "priceSensitivity": 53, "digitalConsumption": 49}	{"taxTolerance": 43, "governmentTrust": 59, "policyAcceptance": 53, "regulationPreference": 74, "publicServiceSatisfaction": 62}	0
1216	황건우	66	60-69	Male	서울특별시	37.624888	126.970535	고졸 이하	200만원 미만	주부	다세대 가구	8	중도 무당층	61	{"economy": -18, "housing": -20, "welfare": 18, "security": 32, "environment": 1}	신문/팟캐스트	{안전,혁신,공동체}	서울특별시에 거주하는 60-69 주부. 정치 성향은 중도이며 안전, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 60, "ecoConsciousness": 55, "priceSensitivity": 75, "digitalConsumption": 48}	{"taxTolerance": 23, "governmentTrust": 41, "policyAcceptance": 44, "regulationPreference": 55, "publicServiceSatisfaction": 59}	0
1217	권예준	63	60-69	Male	서울특별시	37.629387	126.899764	전문대 졸	700만원 이상	생산직	다세대 가구	46	보수 정당 지지	85	{"economy": 29, "housing": 20, "welfare": -46, "security": 25, "environment": 15}	포털 뉴스	{안정,자유,공정}	서울특별시에 거주하는 60-69 생산직. 정치 성향은 보수이며 안정, 자유, 공정 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 48, "ecoConsciousness": 48, "priceSensitivity": 57, "digitalConsumption": 60}	{"taxTolerance": 50, "governmentTrust": 44, "policyAcceptance": 54, "regulationPreference": 58, "publicServiceSatisfaction": 74}	0
1218	조채원	67	60-69	Male	서울특별시	37.583363	126.985411	고졸 이하	350-500만원	은퇴	부부 가구	15	보수 성향 무당층	76	{"economy": -5, "housing": 28, "welfare": 0, "security": -19, "environment": 26}	포털 뉴스	{안정,공정,안전}	서울특별시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 안정, 공정, 안전 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 33, "ecoConsciousness": 48, "priceSensitivity": 44, "digitalConsumption": 73}	{"taxTolerance": 59, "governmentTrust": 50, "policyAcceptance": 60, "regulationPreference": 47, "publicServiceSatisfaction": 72}	0
1219	임유준	64	60-69	Male	서울특별시	37.596521	126.956968	전문대 졸	350-500만원	프리랜서	부부 가구	-7	중도 무당층	67	{"economy": -4, "housing": 34, "welfare": 32, "security": 16, "environment": 18}	포털 뉴스	{공정,자유,안전}	서울특별시에 거주하는 60-69 프리랜서. 정치 성향은 중도이며 공정, 자유, 안전 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 48, "ecoConsciousness": 53, "priceSensitivity": 72, "digitalConsumption": 66}	{"taxTolerance": 59, "governmentTrust": 57, "policyAcceptance": 46, "regulationPreference": 60, "publicServiceSatisfaction": 64}	0
1220	황민서	69	60-69	Male	서울특별시	37.60491	126.913044	대학교 졸	200만원 미만	은퇴	부부 가구	1	중도 무당층	67	{"economy": 10, "housing": -16, "welfare": -3, "security": -5, "environment": 39}	지상파/종편 뉴스	{공동체,전통,공정}	서울특별시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 공동체, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 64, "noveltySeeking": 40, "ecoConsciousness": 40, "priceSensitivity": 100, "digitalConsumption": 77}	{"taxTolerance": 38, "governmentTrust": 44, "policyAcceptance": 48, "regulationPreference": 66, "publicServiceSatisfaction": 78}	0
1221	전경숙	61	60-69	Male	서울특별시	37.609539	127.05003	전문대 졸	200만원 미만	서비스직	자녀 양육 가구	38	보수 성향 무당층	83	{"economy": 14, "housing": 22, "welfare": -23, "security": 16, "environment": 6}	SNS	{공동체,전통,다양성}	서울특별시에 거주하는 60-69 서비스직. 정치 성향은 보수이며 공동체, 전통, 다양성 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 63, "ecoConsciousness": 55, "priceSensitivity": 89, "digitalConsumption": 59}	{"taxTolerance": 47, "governmentTrust": 49, "policyAcceptance": 42, "regulationPreference": 60, "publicServiceSatisfaction": 60}	0
1222	강도윤	61	60-69	Male	서울특별시	37.553865	126.88601	전문대 졸	200-350만원	주부	다세대 가구	11	중도 무당층	99	{"economy": 12, "housing": 14, "welfare": 2, "security": 14, "environment": 13}	지상파/종편 뉴스	{혁신,공정,다양성}	서울특별시에 거주하는 60-69 주부. 정치 성향은 중도이며 혁신, 공정, 다양성 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 63, "ecoConsciousness": 49, "priceSensitivity": 85, "digitalConsumption": 83}	{"taxTolerance": 47, "governmentTrust": 44, "policyAcceptance": 59, "regulationPreference": 55, "publicServiceSatisfaction": 50}	0
1223	전경숙	65	60-69	Male	서울특별시	37.581417	127.024473	전문대 졸	200-350만원	공무원	1인 가구	27	보수 성향 무당층	93	{"economy": 3, "housing": 19, "welfare": 19, "security": 21, "environment": -15}	SNS	{자유,공동체,안전}	서울특별시에 거주하는 60-69 공무원. 정치 성향은 중도이며 자유, 공동체, 안전 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 44, "ecoConsciousness": 27, "priceSensitivity": 68, "digitalConsumption": 59}	{"taxTolerance": 31, "governmentTrust": 59, "policyAcceptance": 68, "regulationPreference": 76, "publicServiceSatisfaction": 56}	0
1224	송서연	69	60-69	Male	서울특별시	37.554367	127.055224	대학원 졸	200만원 미만	은퇴	1인 가구	16	보수 성향 무당층	77	{"economy": -1, "housing": 24, "welfare": -4, "security": 22, "environment": 5}	신문/팟캐스트	{혁신,공정,자유}	서울특별시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 혁신, 공정, 자유 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 49, "ecoConsciousness": 46, "priceSensitivity": 74, "digitalConsumption": 53}	{"taxTolerance": 43, "governmentTrust": 33, "policyAcceptance": 42, "regulationPreference": 68, "publicServiceSatisfaction": 64}	0
1225	송민서	64	60-69	Male	서울특별시	37.508761	126.938325	대학원 졸	200-350만원	생산직	1인 가구	11	중도 무당층	78	{"economy": 14, "housing": 32, "welfare": 20, "security": 22, "environment": 13}	포털 뉴스	{공동체,안전,혁신}	서울특별시에 거주하는 60-69 생산직. 정치 성향은 중도이며 공동체, 안전, 혁신 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 60, "ecoConsciousness": 50, "priceSensitivity": 67, "digitalConsumption": 59}	{"taxTolerance": 62, "governmentTrust": 54, "policyAcceptance": 36, "regulationPreference": 66, "publicServiceSatisfaction": 71}	0
1226	김수아	71	70+	Female	서울특별시	37.621958	126.913791	전문대 졸	500-700만원	은퇴	1인 가구	21	보수 성향 무당층	71	{"economy": 3, "housing": 19, "welfare": 7, "security": 17, "environment": -5}	유튜브	{전통,공동체,공정}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 전통, 공동체, 공정 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 60, "ecoConsciousness": 40, "priceSensitivity": 49, "digitalConsumption": 68}	{"taxTolerance": 32, "governmentTrust": 61, "policyAcceptance": 47, "regulationPreference": 70, "publicServiceSatisfaction": 66}	0
1227	정하은	76	70+	Female	서울특별시	37.641325	127.045839	전문대 졸	200-350만원	은퇴	1인 가구	49	보수 정당 지지	90	{"economy": 30, "housing": -28, "welfare": 7, "security": 45, "environment": -8}	신문/팟캐스트	{공동체,환경,성장}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 공동체, 환경, 성장 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 28, "ecoConsciousness": 46, "priceSensitivity": 79, "digitalConsumption": 58}	{"taxTolerance": 52, "governmentTrust": 49, "policyAcceptance": 56, "regulationPreference": 56, "publicServiceSatisfaction": 57}	0
1228	안지우	78	70+	Female	서울특별시	37.574448	126.973682	전문대 졸	350-500만원	은퇴	다세대 가구	62	보수 정당 지지	98	{"economy": 28, "housing": 6, "welfare": 2, "security": 57, "environment": 6}	지상파/종편 뉴스	{환경,공동체,성장}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 환경, 공동체, 성장 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 46, "ecoConsciousness": 42, "priceSensitivity": 65, "digitalConsumption": 71}	{"taxTolerance": 39, "governmentTrust": 36, "policyAcceptance": 49, "regulationPreference": 85, "publicServiceSatisfaction": 76}	0
1229	권채원	81	70+	Female	서울특별시	37.568899	126.954396	전문대 졸	700만원 이상	은퇴	다세대 가구	5	중도 무당층	99	{"economy": -23, "housing": 23, "welfare": -1, "security": 8, "environment": 17}	신문/팟캐스트	{다양성,혁신,환경}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 다양성, 혁신, 환경 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 35, "ecoConsciousness": 53, "priceSensitivity": 60, "digitalConsumption": 47}	{"taxTolerance": 54, "governmentTrust": 69, "policyAcceptance": 70, "regulationPreference": 60, "publicServiceSatisfaction": 52}	0
1230	신건우	77	70+	Female	서울특별시	37.622061	127.012317	고졸 이하	350-500만원	은퇴	다세대 가구	9	중도 무당층	90	{"economy": -5, "housing": 12, "welfare": -30, "security": 38, "environment": 9}	SNS	{공동체,자유,안정}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공동체, 자유, 안정 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 35, "ecoConsciousness": 36, "priceSensitivity": 75, "digitalConsumption": 55}	{"taxTolerance": 54, "governmentTrust": 52, "policyAcceptance": 74, "regulationPreference": 78, "publicServiceSatisfaction": 63}	0
1231	신순자	75	70+	Female	서울특별시	37.635319	127.060099	대학원 졸	350-500만원	은퇴	부부 가구	72	보수 정당 지지	86	{"economy": 40, "housing": -6, "welfare": -4, "security": 33, "environment": 19}	신문/팟캐스트	{환경,성장,전통}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 환경, 성장, 전통 가치를 중시한다.	{"brandLoyalty": 66, "noveltySeeking": 55, "ecoConsciousness": 44, "priceSensitivity": 60, "digitalConsumption": 53}	{"taxTolerance": 44, "governmentTrust": 47, "policyAcceptance": 47, "regulationPreference": 67, "publicServiceSatisfaction": 58}	0
1232	서하은	80	70+	Female	서울특별시	37.506257	126.985783	대학교 졸	350-500만원	은퇴	1인 가구	-2	중도 무당층	99	{"economy": 15, "housing": 23, "welfare": -3, "security": 8, "environment": 38}	신문/팟캐스트	{다양성,안전,전통}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 다양성, 안전, 전통 가치를 중시한다.	{"brandLoyalty": 91, "noveltySeeking": 40, "ecoConsciousness": 43, "priceSensitivity": 71, "digitalConsumption": 50}	{"taxTolerance": 59, "governmentTrust": 61, "policyAcceptance": 52, "regulationPreference": 60, "publicServiceSatisfaction": 55}	0
1233	김유준	75	70+	Female	서울특별시	37.615473	126.970608	대학원 졸	200-350만원	은퇴	다세대 가구	27	보수 성향 무당층	73	{"economy": 10, "housing": 8, "welfare": 15, "security": 29, "environment": 1}	유튜브	{성장,전통,안전}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 성장, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 68, "ecoConsciousness": 49, "priceSensitivity": 65, "digitalConsumption": 56}	{"taxTolerance": 54, "governmentTrust": 39, "policyAcceptance": 61, "regulationPreference": 61, "publicServiceSatisfaction": 52}	0
1234	한혜진	76	70+	Female	서울특별시	37.514383	127.002938	대학원 졸	200만원 미만	은퇴	다세대 가구	24	보수 성향 무당층	88	{"economy": -1, "housing": 18, "welfare": -6, "security": 5, "environment": 2}	포털 뉴스	{전통,다양성,환경}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 전통, 다양성, 환경 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 58, "ecoConsciousness": 55, "priceSensitivity": 69, "digitalConsumption": 44}	{"taxTolerance": 42, "governmentTrust": 65, "policyAcceptance": 56, "regulationPreference": 54, "publicServiceSatisfaction": 73}	0
1235	장현우	72	70+	Female	서울특별시	37.581927	126.902143	대학교 졸	200-350만원	은퇴	1인 가구	21	보수 성향 무당층	64	{"economy": 6, "housing": 22, "welfare": 21, "security": 18, "environment": -6}	포털 뉴스	{성장,안정,다양성}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 성장, 안정, 다양성 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 52, "ecoConsciousness": 41, "priceSensitivity": 58, "digitalConsumption": 52}	{"taxTolerance": 47, "governmentTrust": 45, "policyAcceptance": 39, "regulationPreference": 61, "publicServiceSatisfaction": 53}	0
1236	정예준	71	70+	Male	서울특별시	37.4965	127.003498	대학교 졸	500-700만원	은퇴	부부 가구	30	보수 성향 무당층	82	{"economy": 55, "housing": -1, "welfare": -16, "security": 40, "environment": 8}	유튜브	{혁신,공동체,안전}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 혁신, 공동체, 안전 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 59, "ecoConsciousness": 47, "priceSensitivity": 58, "digitalConsumption": 61}	{"taxTolerance": 36, "governmentTrust": 43, "policyAcceptance": 66, "regulationPreference": 61, "publicServiceSatisfaction": 77}	0
1237	한정희	80	70+	Male	서울특별시	37.566441	127.071545	전문대 졸	200-350만원	은퇴	자녀 양육 가구	22	보수 성향 무당층	79	{"economy": -5, "housing": -12, "welfare": -6, "security": 22, "environment": 40}	포털 뉴스	{전통,혁신,공동체}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 전통, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 39, "ecoConsciousness": 43, "priceSensitivity": 84, "digitalConsumption": 54}	{"taxTolerance": 13, "governmentTrust": 49, "policyAcceptance": 62, "regulationPreference": 64, "publicServiceSatisfaction": 51}	0
1238	류수아	80	70+	Male	서울특별시	37.593783	126.941541	대학교 졸	500-700만원	은퇴	1인 가구	-1	중도 무당층	83	{"economy": -5, "housing": 3, "welfare": 21, "security": -12, "environment": 29}	포털 뉴스	{혁신,공동체,자유}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 혁신, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 61, "noveltySeeking": 63, "ecoConsciousness": 40, "priceSensitivity": 47, "digitalConsumption": 44}	{"taxTolerance": 31, "governmentTrust": 60, "policyAcceptance": 57, "regulationPreference": 64, "publicServiceSatisfaction": 71}	0
1239	송지우	73	70+	Male	서울특별시	37.518945	127.064789	고졸 이하	700만원 이상	은퇴	자녀 양육 가구	22	보수 성향 무당층	92	{"economy": -1, "housing": 29, "welfare": -13, "security": 31, "environment": 16}	포털 뉴스	{다양성,공정,환경}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 다양성, 공정, 환경 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 55, "ecoConsciousness": 43, "priceSensitivity": 42, "digitalConsumption": 38}	{"taxTolerance": 49, "governmentTrust": 53, "policyAcceptance": 39, "regulationPreference": 68, "publicServiceSatisfaction": 73}	0
1240	서철수	77	70+	Male	서울특별시	37.590922	127.025382	전문대 졸	500-700만원	은퇴	부부 가구	1	중도 무당층	89	{"economy": 23, "housing": 18, "welfare": 15, "security": -5, "environment": 2}	SNS	{공동체,전통,환경}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공동체, 전통, 환경 가치를 중시한다.	{"brandLoyalty": 67, "noveltySeeking": 38, "ecoConsciousness": 31, "priceSensitivity": 55, "digitalConsumption": 71}	{"taxTolerance": 28, "governmentTrust": 66, "policyAcceptance": 49, "regulationPreference": 77, "publicServiceSatisfaction": 68}	0
1241	이예준	81	70+	Male	서울특별시	37.50915	126.956848	대학교 졸	500-700만원	은퇴	1인 가구	37	보수 성향 무당층	89	{"economy": 31, "housing": -8, "welfare": 17, "security": 26, "environment": 15}	포털 뉴스	{성장,환경,다양성}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 성장, 환경, 다양성 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 39, "ecoConsciousness": 41, "priceSensitivity": 47, "digitalConsumption": 44}	{"taxTolerance": 29, "governmentTrust": 49, "policyAcceptance": 58, "regulationPreference": 85, "publicServiceSatisfaction": 58}	0
1242	전철수	70	70+	Male	서울특별시	37.609815	127.040513	대학교 졸	350-500만원	은퇴	1인 가구	44	보수 성향 무당층	87	{"economy": 13, "housing": -6, "welfare": -13, "security": 13, "environment": 8}	지상파/종편 뉴스	{공동체,혁신,공정}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 공동체, 혁신, 공정 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 45, "ecoConsciousness": 48, "priceSensitivity": 75, "digitalConsumption": 45}	{"taxTolerance": 65, "governmentTrust": 61, "policyAcceptance": 59, "regulationPreference": 70, "publicServiceSatisfaction": 58}	0
1243	홍경숙	78	70+	Male	서울특별시	37.518943	126.88237	전문대 졸	350-500만원	은퇴	다세대 가구	55	보수 정당 지지	99	{"economy": 23, "housing": 2, "welfare": 1, "security": 26, "environment": 7}	지상파/종편 뉴스	{안정,안전,혁신}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안정, 안전, 혁신 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 37, "ecoConsciousness": 44, "priceSensitivity": 57, "digitalConsumption": 62}	{"taxTolerance": 54, "governmentTrust": 37, "policyAcceptance": 46, "regulationPreference": 60, "publicServiceSatisfaction": 55}	0
1244	장은우	83	70+	Male	서울특별시	37.599572	126.991633	대학교 졸	350-500만원	은퇴	1인 가구	34	보수 성향 무당층	83	{"economy": 18, "housing": 18, "welfare": -23, "security": 5, "environment": -7}	지상파/종편 뉴스	{혁신,전통,환경}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 혁신, 전통, 환경 가치를 중시한다.	{"brandLoyalty": 61, "noveltySeeking": 51, "ecoConsciousness": 40, "priceSensitivity": 39, "digitalConsumption": 58}	{"taxTolerance": 49, "governmentTrust": 39, "policyAcceptance": 77, "regulationPreference": 57, "publicServiceSatisfaction": 68}	0
1245	안혜진	70	70+	Male	서울특별시	37.631139	126.918961	고졸 이하	200-350만원	은퇴	부부 가구	9	중도 무당층	83	{"economy": -10, "housing": 16, "welfare": 29, "security": 10, "environment": 23}	지상파/종편 뉴스	{혁신,공동체,안정}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 혁신, 공동체, 안정 가치를 중시한다.	{"brandLoyalty": 73, "noveltySeeking": 59, "ecoConsciousness": 30, "priceSensitivity": 68, "digitalConsumption": 58}	{"taxTolerance": 46, "governmentTrust": 46, "policyAcceptance": 50, "regulationPreference": 48, "publicServiceSatisfaction": 61}	0
1246	황지아	20	18-29	Female	부산광역시	35.179139	129.15847	대학교 졸	350-500만원	학생	부부 가구	-30	진보 성향 무당층	46	{"economy": -18, "housing": 3, "welfare": -3, "security": -16, "environment": 50}	지상파/종편 뉴스	{다양성,성장,공동체}	부산광역시에 거주하는 18-29 학생. 정치 성향은 중도이며 다양성, 성장, 공동체 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 74, "ecoConsciousness": 48, "priceSensitivity": 74, "digitalConsumption": 79}	{"taxTolerance": 31, "governmentTrust": 43, "policyAcceptance": 32, "regulationPreference": 73, "publicServiceSatisfaction": 68}	0
1247	한수아	25	18-29	Female	부산광역시	35.160456	129.146657	대학교 졸	350-500만원	서비스직	1인 가구	-15	진보 성향 무당층	35	{"economy": 5, "housing": 27, "welfare": 26, "security": 1, "environment": 27}	신문/팟캐스트	{성장,공동체,안정}	부산광역시에 거주하는 18-29 서비스직. 정치 성향은 중도이며 성장, 공동체, 안정 가치를 중시한다.	{"brandLoyalty": 18, "noveltySeeking": 84, "ecoConsciousness": 65, "priceSensitivity": 60, "digitalConsumption": 93}	{"taxTolerance": 43, "governmentTrust": 44, "policyAcceptance": 50, "regulationPreference": 61, "publicServiceSatisfaction": 82}	0
1248	권하은	28	18-29	Female	부산광역시	35.206097	129.168064	대학원 졸	700만원 이상	자영업	자녀 양육 가구	5	중도 무당층	64	{"economy": -10, "housing": -10, "welfare": -8, "security": 4, "environment": 34}	지상파/종편 뉴스	{안정,공동체,전통}	부산광역시에 거주하는 18-29 자영업. 정치 성향은 중도이며 안정, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 78, "ecoConsciousness": 45, "priceSensitivity": 48, "digitalConsumption": 83}	{"taxTolerance": 45, "governmentTrust": 32, "policyAcceptance": 37, "regulationPreference": 49, "publicServiceSatisfaction": 74}	0
1249	류영수	21	18-29	Female	부산광역시	35.194417	129.10072	대학원 졸	200-350만원	학생	자녀 양육 가구	-27	진보 성향 무당층	48	{"economy": -18, "housing": 35, "welfare": 12, "security": -7, "environment": 28}	유튜브	{안전,환경,안정}	부산광역시에 거주하는 18-29 학생. 정치 성향은 중도이며 안전, 환경, 안정 가치를 중시한다.	{"brandLoyalty": 8, "noveltySeeking": 78, "ecoConsciousness": 61, "priceSensitivity": 69, "digitalConsumption": 81}	{"taxTolerance": 32, "governmentTrust": 27, "policyAcceptance": 42, "regulationPreference": 44, "publicServiceSatisfaction": 65}	0
1250	박철수	29	18-29	Male	부산광역시	35.198247	129.007769	대학원 졸	350-500만원	공무원	다세대 가구	43	보수 성향 무당층	49	{"economy": 36, "housing": 19, "welfare": -6, "security": 26, "environment": 0}	포털 뉴스	{자유,성장,전통}	부산광역시에 거주하는 18-29 공무원. 정치 성향은 보수이며 자유, 성장, 전통 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 76, "ecoConsciousness": 57, "priceSensitivity": 50, "digitalConsumption": 90}	{"taxTolerance": 52, "governmentTrust": 42, "policyAcceptance": 36, "regulationPreference": 64, "publicServiceSatisfaction": 77}	0
1251	장다은	25	18-29	Male	부산광역시	35.212607	129.139613	대학원 졸	200-350만원	프리랜서	1인 가구	3	중도 무당층	61	{"economy": -3, "housing": 4, "welfare": 10, "security": -13, "environment": 16}	SNS	{전통,혁신,자유}	부산광역시에 거주하는 18-29 프리랜서. 정치 성향은 중도이며 전통, 혁신, 자유 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 72, "ecoConsciousness": 65, "priceSensitivity": 64, "digitalConsumption": 93}	{"taxTolerance": 51, "governmentTrust": 44, "policyAcceptance": 63, "regulationPreference": 55, "publicServiceSatisfaction": 74}	0
1252	임광수	19	18-29	Male	부산광역시	35.121479	129.100072	대학교 졸	200-350만원	학생	자녀 양육 가구	4	중도 무당층	33	{"economy": 4, "housing": -3, "welfare": 24, "security": 25, "environment": 4}	포털 뉴스	{자유,안정,환경}	부산광역시에 거주하는 18-29 학생. 정치 성향은 중도이며 자유, 안정, 환경 가치를 중시한다.	{"brandLoyalty": 7, "noveltySeeking": 97, "ecoConsciousness": 48, "priceSensitivity": 61, "digitalConsumption": 73}	{"taxTolerance": 40, "governmentTrust": 46, "policyAcceptance": 41, "regulationPreference": 62, "publicServiceSatisfaction": 54}	0
1253	서현우	18	18-29	Male	부산광역시	35.243677	129.099101	대학원 졸	500-700만원	학생	1인 가구	32	보수 성향 무당층	41	{"economy": 30, "housing": 18, "welfare": 10, "security": 37, "environment": -4}	포털 뉴스	{공동체,성장,전통}	부산광역시에 거주하는 18-29 학생. 정치 성향은 중도이며 공동체, 성장, 전통 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 82, "ecoConsciousness": 59, "priceSensitivity": 52, "digitalConsumption": 82}	{"taxTolerance": 50, "governmentTrust": 45, "policyAcceptance": 37, "regulationPreference": 62, "publicServiceSatisfaction": 60}	0
1254	조서연	32	30-39	Female	부산광역시	35.186573	129.124915	전문대 졸	200-350만원	사무직	다세대 가구	42	보수 성향 무당층	47	{"economy": 23, "housing": 11, "welfare": -22, "security": 13, "environment": -1}	유튜브	{자유,환경,공정}	부산광역시에 거주하는 30-39 사무직. 정치 성향은 보수이며 자유, 환경, 공정 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 77, "ecoConsciousness": 58, "priceSensitivity": 56, "digitalConsumption": 85}	{"taxTolerance": 42, "governmentTrust": 45, "policyAcceptance": 48, "regulationPreference": 51, "publicServiceSatisfaction": 60}	0
1255	조지아	30	30-39	Female	부산광역시	35.21112	129.155	대학교 졸	200만원 미만	전문직	부부 가구	11	중도 무당층	59	{"economy": -1, "housing": 1, "welfare": -23, "security": -5, "environment": 20}	SNS	{안정,다양성,혁신}	부산광역시에 거주하는 30-39 전문직. 정치 성향은 중도이며 안정, 다양성, 혁신 가치를 중시한다.	{"brandLoyalty": 14, "noveltySeeking": 61, "ecoConsciousness": 45, "priceSensitivity": 83, "digitalConsumption": 89}	{"taxTolerance": 50, "governmentTrust": 38, "policyAcceptance": 50, "regulationPreference": 70, "publicServiceSatisfaction": 50}	0
1256	조다은	31	30-39	Female	부산광역시	35.191133	129.104668	대학교 졸	200만원 미만	자영업	1인 가구	2	중도 무당층	38	{"economy": 9, "housing": 33, "welfare": -4, "security": 12, "environment": 6}	신문/팟캐스트	{다양성,환경,자유}	부산광역시에 거주하는 30-39 자영업. 정치 성향은 중도이며 다양성, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 21, "noveltySeeking": 77, "ecoConsciousness": 59, "priceSensitivity": 73, "digitalConsumption": 86}	{"taxTolerance": 46, "governmentTrust": 62, "policyAcceptance": 45, "regulationPreference": 52, "publicServiceSatisfaction": 50}	0
1257	장광수	32	30-39	Female	부산광역시	35.147893	128.990811	전문대 졸	350-500만원	은퇴	부부 가구	-6	중도 무당층	65	{"economy": 5, "housing": 15, "welfare": 32, "security": 6, "environment": 11}	SNS	{혁신,안전,환경}	부산광역시에 거주하는 30-39 은퇴. 정치 성향은 중도이며 혁신, 안전, 환경 가치를 중시한다.	{"brandLoyalty": 19, "noveltySeeking": 56, "ecoConsciousness": 41, "priceSensitivity": 64, "digitalConsumption": 87}	{"taxTolerance": 34, "governmentTrust": 53, "policyAcceptance": 43, "regulationPreference": 56, "publicServiceSatisfaction": 61}	0
1258	김지호	32	30-39	Male	부산광역시	35.202422	129.117558	대학원 졸	350-500만원	은퇴	자녀 양육 가구	-4	중도 무당층	52	{"economy": -19, "housing": 5, "welfare": -2, "security": 13, "environment": 17}	유튜브	{환경,전통,다양성}	부산광역시에 거주하는 30-39 은퇴. 정치 성향은 중도이며 환경, 전통, 다양성 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 76, "ecoConsciousness": 55, "priceSensitivity": 51, "digitalConsumption": 92}	{"taxTolerance": 54, "governmentTrust": 39, "policyAcceptance": 41, "regulationPreference": 58, "publicServiceSatisfaction": 61}	0
1259	이지호	39	30-39	Male	부산광역시	35.129906	129.089986	대학원 졸	350-500만원	전문직	자녀 양육 가구	7	중도 무당층	48	{"economy": -2, "housing": -21, "welfare": -3, "security": 5, "environment": -6}	신문/팟캐스트	{공동체,환경,안전}	부산광역시에 거주하는 30-39 전문직. 정치 성향은 중도이며 공동체, 환경, 안전 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 44, "ecoConsciousness": 38, "priceSensitivity": 56, "digitalConsumption": 57}	{"taxTolerance": 45, "governmentTrust": 41, "policyAcceptance": 50, "regulationPreference": 58, "publicServiceSatisfaction": 84}	0
1260	김주원	34	30-39	Male	부산광역시	35.159875	129.083854	대학교 졸	350-500만원	주부	1인 가구	13	중도 무당층	69	{"economy": -27, "housing": 27, "welfare": -33, "security": 10, "environment": 23}	유튜브	{자유,혁신,성장}	부산광역시에 거주하는 30-39 주부. 정치 성향은 중도이며 자유, 혁신, 성장 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 61, "ecoConsciousness": 44, "priceSensitivity": 45, "digitalConsumption": 65}	{"taxTolerance": 50, "governmentTrust": 47, "policyAcceptance": 71, "regulationPreference": 53, "publicServiceSatisfaction": 47}	0
1261	안민준	30	30-39	Male	부산광역시	35.230634	129.022528	대학교 졸	500-700만원	은퇴	1인 가구	14	중도 무당층	63	{"economy": 13, "housing": 27, "welfare": -13, "security": 16, "environment": -1}	SNS	{자유,다양성,전통}	부산광역시에 거주하는 30-39 은퇴. 정치 성향은 중도이며 자유, 다양성, 전통 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 61, "ecoConsciousness": 50, "priceSensitivity": 47, "digitalConsumption": 82}	{"taxTolerance": 52, "governmentTrust": 42, "policyAcceptance": 54, "regulationPreference": 73, "publicServiceSatisfaction": 75}	0
1262	황지민	48	40-49	Female	부산광역시	35.113609	129.079864	대학원 졸	700만원 이상	자영업	자녀 양육 가구	6	중도 무당층	60	{"economy": 36, "housing": 5, "welfare": 31, "security": -2, "environment": 40}	포털 뉴스	{자유,혁신,공정}	부산광역시에 거주하는 40-49 자영업. 정치 성향은 중도이며 자유, 혁신, 공정 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 62, "ecoConsciousness": 53, "priceSensitivity": 26, "digitalConsumption": 78}	{"taxTolerance": 51, "governmentTrust": 33, "policyAcceptance": 49, "regulationPreference": 51, "publicServiceSatisfaction": 70}	0
1263	서지민	45	40-49	Female	부산광역시	35.234638	129.117624	전문대 졸	200만원 미만	전문직	부부 가구	16	보수 성향 무당층	71	{"economy": 41, "housing": 38, "welfare": -9, "security": 31, "environment": -16}	포털 뉴스	{공동체,전통,자유}	부산광역시에 거주하는 40-49 전문직. 정치 성향은 중도이며 공동체, 전통, 자유 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 48, "ecoConsciousness": 40, "priceSensitivity": 76, "digitalConsumption": 58}	{"taxTolerance": 40, "governmentTrust": 56, "policyAcceptance": 46, "regulationPreference": 62, "publicServiceSatisfaction": 72}	0
1264	송광수	47	40-49	Female	부산광역시	35.130667	129.155294	전문대 졸	350-500만원	서비스직	자녀 양육 가구	-2	중도 무당층	66	{"economy": -4, "housing": 6, "welfare": 29, "security": 8, "environment": 1}	유튜브	{안전,공동체,안정}	부산광역시에 거주하는 40-49 서비스직. 정치 성향은 중도이며 안전, 공동체, 안정 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 59, "ecoConsciousness": 56, "priceSensitivity": 46, "digitalConsumption": 63}	{"taxTolerance": 54, "governmentTrust": 33, "policyAcceptance": 66, "regulationPreference": 59, "publicServiceSatisfaction": 61}	0
1265	황정희	45	40-49	Female	부산광역시	35.159309	129.022995	대학원 졸	350-500만원	학생	부부 가구	5	중도 무당층	63	{"economy": -21, "housing": 21, "welfare": 4, "security": -11, "environment": 5}	SNS	{혁신,안전,공정}	부산광역시에 거주하는 40-49 학생. 정치 성향은 중도이며 혁신, 안전, 공정 가치를 중시한다.	{"brandLoyalty": 21, "noveltySeeking": 77, "ecoConsciousness": 41, "priceSensitivity": 56, "digitalConsumption": 95}	{"taxTolerance": 44, "governmentTrust": 27, "policyAcceptance": 40, "regulationPreference": 51, "publicServiceSatisfaction": 79}	0
1266	안동현	46	40-49	Female	부산광역시	35.170631	129.110871	대학교 졸	350-500만원	전문직	부부 가구	-7	중도 무당층	63	{"economy": -4, "housing": 6, "welfare": 43, "security": 21, "environment": 4}	지상파/종편 뉴스	{안정,전통,성장}	부산광역시에 거주하는 40-49 전문직. 정치 성향은 중도이며 안정, 전통, 성장 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 61, "ecoConsciousness": 57, "priceSensitivity": 80, "digitalConsumption": 82}	{"taxTolerance": 60, "governmentTrust": 33, "policyAcceptance": 25, "regulationPreference": 65, "publicServiceSatisfaction": 63}	0
1267	신지아	44	40-49	Male	부산광역시	35.118481	129.123951	전문대 졸	500-700만원	자영업	부부 가구	-4	중도 무당층	51	{"economy": 7, "housing": 41, "welfare": 18, "security": -14, "environment": 0}	유튜브	{성장,환경,다양성}	부산광역시에 거주하는 40-49 자영업. 정치 성향은 중도이며 성장, 환경, 다양성 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 65, "ecoConsciousness": 44, "priceSensitivity": 52, "digitalConsumption": 81}	{"taxTolerance": 50, "governmentTrust": 46, "policyAcceptance": 36, "regulationPreference": 58, "publicServiceSatisfaction": 57}	0
1268	이수아	44	40-49	Male	부산광역시	35.259504	129.167802	전문대 졸	500-700만원	서비스직	자녀 양육 가구	-4	중도 무당층	39	{"economy": 1, "housing": 35, "welfare": 15, "security": -26, "environment": 20}	유튜브	{안전,환경,안정}	부산광역시에 거주하는 40-49 서비스직. 정치 성향은 중도이며 안전, 환경, 안정 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 69, "ecoConsciousness": 60, "priceSensitivity": 67, "digitalConsumption": 100}	{"taxTolerance": 56, "governmentTrust": 46, "policyAcceptance": 49, "regulationPreference": 47, "publicServiceSatisfaction": 65}	0
1269	홍광수	49	40-49	Male	부산광역시	35.230256	129.168976	고졸 이하	700만원 이상	학생	자녀 양육 가구	25	보수 성향 무당층	70	{"economy": 5, "housing": -4, "welfare": -8, "security": 13, "environment": 9}	유튜브	{안전,공정,혁신}	부산광역시에 거주하는 40-49 학생. 정치 성향은 중도이며 안전, 공정, 혁신 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 59, "ecoConsciousness": 60, "priceSensitivity": 52, "digitalConsumption": 67}	{"taxTolerance": 35, "governmentTrust": 38, "policyAcceptance": 45, "regulationPreference": 63, "publicServiceSatisfaction": 55}	0
1270	강다은	40	40-49	Male	부산광역시	35.218961	129.051544	대학교 졸	350-500만원	전문직	부부 가구	-13	중도 무당층	73	{"economy": -9, "housing": 21, "welfare": 34, "security": 18, "environment": 54}	SNS	{안전,공정,다양성}	부산광역시에 거주하는 40-49 전문직. 정치 성향은 중도이며 안전, 공정, 다양성 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 51, "ecoConsciousness": 70, "priceSensitivity": 55, "digitalConsumption": 57}	{"taxTolerance": 40, "governmentTrust": 49, "policyAcceptance": 47, "regulationPreference": 67, "publicServiceSatisfaction": 59}	0
1271	윤하은	49	40-49	Male	부산광역시	35.1383	129.06817	대학원 졸	500-700만원	학생	자녀 양육 가구	11	중도 무당층	64	{"economy": -6, "housing": 9, "welfare": 6, "security": -1, "environment": 12}	포털 뉴스	{공정,안정,환경}	부산광역시에 거주하는 40-49 학생. 정치 성향은 중도이며 공정, 안정, 환경 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 59, "ecoConsciousness": 61, "priceSensitivity": 39, "digitalConsumption": 64}	{"taxTolerance": 30, "governmentTrust": 59, "policyAcceptance": 37, "regulationPreference": 65, "publicServiceSatisfaction": 47}	0
1272	윤은우	52	50-59	Female	부산광역시	35.153661	129.092996	전문대 졸	200-350만원	사무직	다세대 가구	29	보수 성향 무당층	79	{"economy": 32, "housing": 4, "welfare": 3, "security": 24, "environment": 12}	포털 뉴스	{다양성,전통,환경}	부산광역시에 거주하는 50-59 사무직. 정치 성향은 중도이며 다양성, 전통, 환경 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 51, "ecoConsciousness": 18, "priceSensitivity": 54, "digitalConsumption": 79}	{"taxTolerance": 53, "governmentTrust": 43, "policyAcceptance": 27, "regulationPreference": 73, "publicServiceSatisfaction": 58}	0
1273	류동현	59	50-59	Female	부산광역시	35.176162	128.981131	전문대 졸	200만원 미만	프리랜서	다세대 가구	-4	중도 무당층	99	{"economy": -27, "housing": 34, "welfare": 2, "security": -5, "environment": 20}	포털 뉴스	{공정,다양성,공동체}	부산광역시에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 공정, 다양성, 공동체 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 43, "ecoConsciousness": 44, "priceSensitivity": 67, "digitalConsumption": 64}	{"taxTolerance": 63, "governmentTrust": 60, "policyAcceptance": 46, "regulationPreference": 75, "publicServiceSatisfaction": 59}	0
1274	임은우	53	50-59	Female	부산광역시	35.143656	129.120546	대학교 졸	200만원 미만	주부	자녀 양육 가구	71	보수 정당 지지	69	{"economy": 68, "housing": 7, "welfare": -29, "security": 33, "environment": 1}	포털 뉴스	{자유,전통,안정}	부산광역시에 거주하는 50-59 주부. 정치 성향은 보수이며 자유, 전통, 안정 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 53, "ecoConsciousness": 42, "priceSensitivity": 46, "digitalConsumption": 61}	{"taxTolerance": 65, "governmentTrust": 55, "policyAcceptance": 53, "regulationPreference": 69, "publicServiceSatisfaction": 41}	0
1275	한은우	52	50-59	Female	부산광역시	35.129353	129.160573	고졸 이하	350-500만원	생산직	1인 가구	-7	중도 무당층	81	{"economy": -52, "housing": 18, "welfare": 32, "security": -8, "environment": 10}	포털 뉴스	{공정,공동체,자유}	부산광역시에 거주하는 50-59 생산직. 정치 성향은 중도이며 공정, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 56, "ecoConsciousness": 54, "priceSensitivity": 71, "digitalConsumption": 77}	{"taxTolerance": 39, "governmentTrust": 45, "policyAcceptance": 65, "regulationPreference": 62, "publicServiceSatisfaction": 50}	0
1276	송민서	55	50-59	Female	부산광역시	35.129158	129.022669	전문대 졸	500-700만원	은퇴	부부 가구	10	중도 무당층	61	{"economy": 9, "housing": 24, "welfare": 35, "security": 5, "environment": 25}	SNS	{공동체,공정,전통}	부산광역시에 거주하는 50-59 은퇴. 정치 성향은 중도이며 공동체, 공정, 전통 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 60, "ecoConsciousness": 44, "priceSensitivity": 58, "digitalConsumption": 96}	{"taxTolerance": 49, "governmentTrust": 27, "policyAcceptance": 48, "regulationPreference": 55, "publicServiceSatisfaction": 72}	0
1277	정민준	50	50-59	Male	부산광역시	35.157785	129.107308	전문대 졸	350-500만원	전문직	1인 가구	6	중도 무당층	64	{"economy": 4, "housing": 14, "welfare": 57, "security": 8, "environment": 24}	신문/팟캐스트	{혁신,안전,자유}	부산광역시에 거주하는 50-59 전문직. 정치 성향은 중도이며 혁신, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 67, "ecoConsciousness": 57, "priceSensitivity": 69, "digitalConsumption": 51}	{"taxTolerance": 36, "governmentTrust": 41, "policyAcceptance": 38, "regulationPreference": 57, "publicServiceSatisfaction": 56}	0
1278	권건우	58	50-59	Male	부산광역시	35.104006	129.071127	대학교 졸	700만원 이상	학생	자녀 양육 가구	54	보수 정당 지지	76	{"economy": 33, "housing": 2, "welfare": -18, "security": 20, "environment": -2}	포털 뉴스	{다양성,자유,공동체}	부산광역시에 거주하는 50-59 학생. 정치 성향은 보수이며 다양성, 자유, 공동체 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 67, "ecoConsciousness": 58, "priceSensitivity": 52, "digitalConsumption": 82}	{"taxTolerance": 44, "governmentTrust": 69, "policyAcceptance": 37, "regulationPreference": 60, "publicServiceSatisfaction": 58}	0
1279	안광수	55	50-59	Male	부산광역시	35.237597	128.995955	대학원 졸	200-350만원	전문직	부부 가구	9	중도 무당층	68	{"economy": 17, "housing": 17, "welfare": 11, "security": 23, "environment": -1}	포털 뉴스	{환경,안전,성장}	부산광역시에 거주하는 50-59 전문직. 정치 성향은 중도이며 환경, 안전, 성장 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 55, "ecoConsciousness": 55, "priceSensitivity": 61, "digitalConsumption": 72}	{"taxTolerance": 57, "governmentTrust": 57, "policyAcceptance": 43, "regulationPreference": 72, "publicServiceSatisfaction": 59}	0
1280	한성호	51	50-59	Male	부산광역시	35.19718	129.172253	대학교 졸	350-500만원	생산직	자녀 양육 가구	-12	중도 무당층	62	{"economy": 20, "housing": 8, "welfare": 29, "security": -2, "environment": 25}	유튜브	{환경,혁신,성장}	부산광역시에 거주하는 50-59 생산직. 정치 성향은 중도이며 환경, 혁신, 성장 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 67, "ecoConsciousness": 48, "priceSensitivity": 32, "digitalConsumption": 50}	{"taxTolerance": 62, "governmentTrust": 59, "policyAcceptance": 38, "regulationPreference": 65, "publicServiceSatisfaction": 76}	0
1281	윤영수	51	50-59	Male	부산광역시	35.18121	129.044008	대학원 졸	700만원 이상	공무원	부부 가구	43	보수 성향 무당층	49	{"economy": 29, "housing": -13, "welfare": 8, "security": 23, "environment": -10}	SNS	{환경,안전,자유}	부산광역시에 거주하는 50-59 공무원. 정치 성향은 보수이며 환경, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 81, "ecoConsciousness": 62, "priceSensitivity": 50, "digitalConsumption": 69}	{"taxTolerance": 54, "governmentTrust": 47, "policyAcceptance": 48, "regulationPreference": 63, "publicServiceSatisfaction": 51}	0
1282	임서연	69	60-69	Female	부산광역시	35.22432	129.051127	고졸 이하	500-700만원	은퇴	다세대 가구	20	보수 성향 무당층	80	{"economy": -14, "housing": 35, "welfare": 12, "security": 3, "environment": 33}	지상파/종편 뉴스	{전통,성장,환경}	부산광역시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 전통, 성장, 환경 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 63, "ecoConsciousness": 32, "priceSensitivity": 52, "digitalConsumption": 63}	{"taxTolerance": 37, "governmentTrust": 42, "policyAcceptance": 52, "regulationPreference": 55, "publicServiceSatisfaction": 39}	0
1283	송준서	66	60-69	Female	부산광역시	35.119763	129.008147	대학원 졸	500-700만원	전문직	1인 가구	60	보수 정당 지지	81	{"economy": 17, "housing": -9, "welfare": -12, "security": 47, "environment": 24}	지상파/종편 뉴스	{자유,다양성,환경}	부산광역시에 거주하는 60-69 전문직. 정치 성향은 보수이며 자유, 다양성, 환경 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 25, "ecoConsciousness": 53, "priceSensitivity": 61, "digitalConsumption": 70}	{"taxTolerance": 36, "governmentTrust": 45, "policyAcceptance": 39, "regulationPreference": 60, "publicServiceSatisfaction": 52}	0
1284	서은우	64	60-69	Female	부산광역시	35.162832	129.073663	전문대 졸	500-700만원	공무원	1인 가구	25	보수 성향 무당층	91	{"economy": 9, "housing": 29, "welfare": -15, "security": 15, "environment": 22}	지상파/종편 뉴스	{혁신,성장,안전}	부산광역시에 거주하는 60-69 공무원. 정치 성향은 중도이며 혁신, 성장, 안전 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 37, "ecoConsciousness": 57, "priceSensitivity": 57, "digitalConsumption": 66}	{"taxTolerance": 40, "governmentTrust": 21, "policyAcceptance": 36, "regulationPreference": 76, "publicServiceSatisfaction": 48}	0
1285	장다은	60	60-69	Female	부산광역시	35.126571	129.028684	대학교 졸	700만원 이상	전문직	1인 가구	7	중도 무당층	79	{"economy": -8, "housing": 2, "welfare": 33, "security": 12, "environment": 23}	유튜브	{안전,전통,성장}	부산광역시에 거주하는 60-69 전문직. 정치 성향은 중도이며 안전, 전통, 성장 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 60, "ecoConsciousness": 58, "priceSensitivity": 41, "digitalConsumption": 75}	{"taxTolerance": 65, "governmentTrust": 50, "policyAcceptance": 33, "regulationPreference": 72, "publicServiceSatisfaction": 82}	0
1286	안서연	68	60-69	Male	부산광역시	35.247738	129.072814	전문대 졸	350-500만원	은퇴	1인 가구	16	보수 성향 무당층	83	{"economy": 1, "housing": -1, "welfare": -7, "security": -2, "environment": 49}	유튜브	{공동체,혁신,안정}	부산광역시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 공동체, 혁신, 안정 가치를 중시한다.	{"brandLoyalty": 67, "noveltySeeking": 71, "ecoConsciousness": 57, "priceSensitivity": 75, "digitalConsumption": 78}	{"taxTolerance": 43, "governmentTrust": 50, "policyAcceptance": 70, "regulationPreference": 58, "publicServiceSatisfaction": 62}	0
1287	황영수	61	60-69	Male	부산광역시	35.111815	129.136979	대학원 졸	200만원 미만	전문직	자녀 양육 가구	58	보수 정당 지지	77	{"economy": 31, "housing": -22, "welfare": 13, "security": 58, "environment": 5}	포털 뉴스	{혁신,환경,전통}	부산광역시에 거주하는 60-69 전문직. 정치 성향은 보수이며 혁신, 환경, 전통 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 56, "ecoConsciousness": 36, "priceSensitivity": 72, "digitalConsumption": 70}	{"taxTolerance": 36, "governmentTrust": 39, "policyAcceptance": 39, "regulationPreference": 60, "publicServiceSatisfaction": 66}	0
1288	홍정희	61	60-69	Male	부산광역시	35.176961	129.101703	전문대 졸	500-700만원	사무직	자녀 양육 가구	18	보수 성향 무당층	68	{"economy": -27, "housing": 7, "welfare": -3, "security": 10, "environment": 36}	유튜브	{성장,공동체,안전}	부산광역시에 거주하는 60-69 사무직. 정치 성향은 중도이며 성장, 공동체, 안전 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 54, "ecoConsciousness": 38, "priceSensitivity": 32, "digitalConsumption": 67}	{"taxTolerance": 37, "governmentTrust": 41, "policyAcceptance": 29, "regulationPreference": 58, "publicServiceSatisfaction": 59}	0
1289	조서연	64	60-69	Male	부산광역시	35.23221	129.044437	전문대 졸	350-500만원	주부	1인 가구	35	보수 성향 무당층	68	{"economy": 43, "housing": 2, "welfare": 14, "security": 10, "environment": 4}	포털 뉴스	{성장,환경,자유}	부산광역시에 거주하는 60-69 주부. 정치 성향은 보수이며 성장, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 74, "noveltySeeking": 59, "ecoConsciousness": 33, "priceSensitivity": 52, "digitalConsumption": 66}	{"taxTolerance": 37, "governmentTrust": 53, "policyAcceptance": 44, "regulationPreference": 72, "publicServiceSatisfaction": 69}	0
1290	장하은	79	70+	Female	부산광역시	35.120269	129.083734	전문대 졸	200만원 미만	은퇴	다세대 가구	60	보수 정당 지지	87	{"economy": -1, "housing": 0, "welfare": -14, "security": 8, "environment": -13}	신문/팟캐스트	{안전,다양성,환경}	부산광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안전, 다양성, 환경 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 31, "ecoConsciousness": 27, "priceSensitivity": 84, "digitalConsumption": 58}	{"taxTolerance": 33, "governmentTrust": 56, "policyAcceptance": 47, "regulationPreference": 76, "publicServiceSatisfaction": 47}	0
1291	권지우	75	70+	Female	부산광역시	35.211233	128.978678	대학교 졸	350-500만원	은퇴	자녀 양육 가구	84	보수 정당 지지	78	{"economy": 59, "housing": -24, "welfare": -23, "security": 53, "environment": 13}	SNS	{안정,전통,성장}	부산광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안정, 전통, 성장 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 49, "ecoConsciousness": 58, "priceSensitivity": 67, "digitalConsumption": 63}	{"taxTolerance": 60, "governmentTrust": 49, "policyAcceptance": 60, "regulationPreference": 50, "publicServiceSatisfaction": 68}	0
1292	권지우	80	70+	Female	부산광역시	35.207794	129.081294	고졸 이하	200-350만원	은퇴	부부 가구	49	보수 정당 지지	97	{"economy": 72, "housing": 22, "welfare": -25, "security": 22, "environment": 4}	유튜브	{안정,혁신,공동체}	부산광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안정, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 47, "ecoConsciousness": 45, "priceSensitivity": 72, "digitalConsumption": 45}	{"taxTolerance": 43, "governmentTrust": 29, "policyAcceptance": 63, "regulationPreference": 67, "publicServiceSatisfaction": 68}	0
1293	류민서	70	70+	Female	부산광역시	35.148265	129.037576	대학원 졸	500-700만원	은퇴	자녀 양육 가구	39	보수 성향 무당층	64	{"economy": 52, "housing": 31, "welfare": -32, "security": 14, "environment": 28}	SNS	{환경,혁신,전통}	부산광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 환경, 혁신, 전통 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 56, "ecoConsciousness": 65, "priceSensitivity": 52, "digitalConsumption": 64}	{"taxTolerance": 60, "governmentTrust": 50, "policyAcceptance": 53, "regulationPreference": 71, "publicServiceSatisfaction": 54}	0
1294	장지호	76	70+	Male	부산광역시	35.233988	129.168016	전문대 졸	200-350만원	은퇴	다세대 가구	43	보수 성향 무당층	85	{"economy": 32, "housing": -3, "welfare": -41, "security": 37, "environment": 16}	SNS	{공동체,안정,안전}	부산광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 공동체, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 35, "ecoConsciousness": 58, "priceSensitivity": 67, "digitalConsumption": 43}	{"taxTolerance": 53, "governmentTrust": 48, "policyAcceptance": 50, "regulationPreference": 67, "publicServiceSatisfaction": 67}	0
1295	전다은	76	70+	Male	부산광역시	35.227502	129.105478	대학원 졸	350-500만원	은퇴	자녀 양육 가구	25	보수 성향 무당층	71	{"economy": 19, "housing": 14, "welfare": 4, "security": 29, "environment": -6}	지상파/종편 뉴스	{공정,안정,성장}	부산광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공정, 안정, 성장 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 30, "ecoConsciousness": 48, "priceSensitivity": 71, "digitalConsumption": 56}	{"taxTolerance": 48, "governmentTrust": 40, "policyAcceptance": 59, "regulationPreference": 69, "publicServiceSatisfaction": 64}	0
1296	오광수	71	70+	Male	부산광역시	35.168651	129.147426	전문대 졸	350-500만원	은퇴	자녀 양육 가구	18	보수 성향 무당층	96	{"economy": -19, "housing": 39, "welfare": 8, "security": 1, "environment": 9}	신문/팟캐스트	{안정,공동체,혁신}	부산광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안정, 공동체, 혁신 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 50, "ecoConsciousness": 47, "priceSensitivity": 55, "digitalConsumption": 75}	{"taxTolerance": 31, "governmentTrust": 53, "policyAcceptance": 43, "regulationPreference": 58, "publicServiceSatisfaction": 58}	0
1297	홍미경	80	70+	Male	부산광역시	35.241882	129.097377	대학교 졸	350-500만원	은퇴	1인 가구	15	보수 성향 무당층	71	{"economy": 6, "housing": 10, "welfare": 43, "security": 24, "environment": 22}	포털 뉴스	{환경,혁신,성장}	부산광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 환경, 혁신, 성장 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 45, "ecoConsciousness": 47, "priceSensitivity": 54, "digitalConsumption": 48}	{"taxTolerance": 38, "governmentTrust": 46, "policyAcceptance": 61, "regulationPreference": 59, "publicServiceSatisfaction": 62}	0
1298	윤도윤	27	18-29	Female	대구광역시	35.945157	128.556632	대학원 졸	350-500만원	생산직	자녀 양육 가구	9	중도 무당층	66	{"economy": 1, "housing": 30, "welfare": 41, "security": -12, "environment": 18}	포털 뉴스	{자유,안정,공정}	대구광역시에 거주하는 18-29 생산직. 정치 성향은 중도이며 자유, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 78, "ecoConsciousness": 61, "priceSensitivity": 49, "digitalConsumption": 80}	{"taxTolerance": 53, "governmentTrust": 31, "policyAcceptance": 43, "regulationPreference": 56, "publicServiceSatisfaction": 60}	0
1299	김영수	18	18-29	Female	대구광역시	35.800017	128.578246	대학교 졸	200-350만원	학생	자녀 양육 가구	-24	진보 성향 무당층	30	{"economy": -27, "housing": 5, "welfare": 22, "security": -38, "environment": 37}	유튜브	{안정,환경,전통}	대구광역시에 거주하는 18-29 학생. 정치 성향은 중도이며 안정, 환경, 전통 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 70, "ecoConsciousness": 42, "priceSensitivity": 91, "digitalConsumption": 65}	{"taxTolerance": 41, "governmentTrust": 45, "policyAcceptance": 39, "regulationPreference": 62, "publicServiceSatisfaction": 63}	0
1300	장경숙	28	18-29	Female	대구광역시	35.850097	128.691766	대학원 졸	200만원 미만	주부	다세대 가구	26	보수 성향 무당층	47	{"economy": 41, "housing": 18, "welfare": 4, "security": 4, "environment": 33}	SNS	{성장,환경,다양성}	대구광역시에 거주하는 18-29 주부. 정치 성향은 중도이며 성장, 환경, 다양성 가치를 중시한다.	{"brandLoyalty": 60, "noveltySeeking": 80, "ecoConsciousness": 62, "priceSensitivity": 68, "digitalConsumption": 91}	{"taxTolerance": 64, "governmentTrust": 33, "policyAcceptance": 50, "regulationPreference": 71, "publicServiceSatisfaction": 93}	0
1301	정도윤	21	18-29	Male	대구광역시	35.845285	128.648996	대학원 졸	200만원 미만	학생	자녀 양육 가구	6	중도 무당층	35	{"economy": 4, "housing": 24, "welfare": 14, "security": -14, "environment": -8}	유튜브	{자유,공동체,안정}	대구광역시에 거주하는 18-29 학생. 정치 성향은 중도이며 자유, 공동체, 안정 가치를 중시한다.	{"brandLoyalty": 16, "noveltySeeking": 93, "ecoConsciousness": 54, "priceSensitivity": 64, "digitalConsumption": 74}	{"taxTolerance": 47, "governmentTrust": 44, "policyAcceptance": 34, "regulationPreference": 62, "publicServiceSatisfaction": 63}	0
1302	류준서	26	18-29	Male	대구광역시	35.918469	128.504767	대학원 졸	200-350만원	서비스직	부부 가구	0	중도 무당층	60	{"economy": -10, "housing": 6, "welfare": 20, "security": 15, "environment": 40}	SNS	{성장,환경,자유}	대구광역시에 거주하는 18-29 서비스직. 정치 성향은 중도이며 성장, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 26, "noveltySeeking": 84, "ecoConsciousness": 73, "priceSensitivity": 67, "digitalConsumption": 92}	{"taxTolerance": 52, "governmentTrust": 55, "policyAcceptance": 50, "regulationPreference": 54, "publicServiceSatisfaction": 61}	0
1303	황경숙	25	18-29	Male	대구광역시	35.801287	128.543601	전문대 졸	200만원 미만	서비스직	부부 가구	31	보수 성향 무당층	43	{"economy": 19, "housing": -6, "welfare": -21, "security": 26, "environment": -7}	유튜브	{전통,안전,자유}	대구광역시에 거주하는 18-29 서비스직. 정치 성향은 중도이며 전통, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 58, "ecoConsciousness": 49, "priceSensitivity": 85, "digitalConsumption": 88}	{"taxTolerance": 49, "governmentTrust": 55, "policyAcceptance": 50, "regulationPreference": 45, "publicServiceSatisfaction": 65}	0
1304	장서연	37	30-39	Female	대구광역시	35.793954	128.568472	대학교 졸	500-700만원	은퇴	부부 가구	29	보수 성향 무당층	67	{"economy": 18, "housing": 28, "welfare": -16, "security": 38, "environment": -10}	포털 뉴스	{자유,다양성,성장}	대구광역시에 거주하는 30-39 은퇴. 정치 성향은 중도이며 자유, 다양성, 성장 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 62, "ecoConsciousness": 68, "priceSensitivity": 62, "digitalConsumption": 82}	{"taxTolerance": 33, "governmentTrust": 52, "policyAcceptance": 58, "regulationPreference": 72, "publicServiceSatisfaction": 67}	0
1305	홍영수	32	30-39	Female	대구광역시	35.816277	128.570671	고졸 이하	500-700만원	프리랜서	다세대 가구	1	중도 무당층	48	{"economy": -23, "housing": 27, "welfare": 43, "security": -17, "environment": 23}	신문/팟캐스트	{환경,자유,혁신}	대구광역시에 거주하는 30-39 프리랜서. 정치 성향은 중도이며 환경, 자유, 혁신 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 59, "ecoConsciousness": 56, "priceSensitivity": 53, "digitalConsumption": 75}	{"taxTolerance": 37, "governmentTrust": 45, "policyAcceptance": 66, "regulationPreference": 46, "publicServiceSatisfaction": 72}	0
1306	안민준	38	30-39	Female	대구광역시	35.935466	128.625737	고졸 이하	500-700만원	공무원	1인 가구	3	중도 무당층	92	{"economy": -33, "housing": 37, "welfare": 5, "security": -11, "environment": 7}	포털 뉴스	{다양성,전통,안정}	대구광역시에 거주하는 30-39 공무원. 정치 성향은 중도이며 다양성, 전통, 안정 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 60, "ecoConsciousness": 34, "priceSensitivity": 39, "digitalConsumption": 75}	{"taxTolerance": 47, "governmentTrust": 40, "policyAcceptance": 30, "regulationPreference": 54, "publicServiceSatisfaction": 56}	0
1307	김동현	30	30-39	Male	대구광역시	35.812001	128.682502	전문대 졸	350-500만원	생산직	자녀 양육 가구	6	중도 무당층	28	{"economy": 13, "housing": 16, "welfare": 3, "security": 5, "environment": 34}	SNS	{환경,공정,안전}	대구광역시에 거주하는 30-39 생산직. 정치 성향은 중도이며 환경, 공정, 안전 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 71, "ecoConsciousness": 53, "priceSensitivity": 64, "digitalConsumption": 70}	{"taxTolerance": 43, "governmentTrust": 43, "policyAcceptance": 57, "regulationPreference": 55, "publicServiceSatisfaction": 72}	0
1308	최하은	34	30-39	Male	대구광역시	35.823469	128.531678	전문대 졸	200-350만원	주부	부부 가구	47	보수 정당 지지	47	{"economy": 10, "housing": 3, "welfare": -1, "security": 35, "environment": 10}	SNS	{다양성,자유,성장}	대구광역시에 거주하는 30-39 주부. 정치 성향은 보수이며 다양성, 자유, 성장 가치를 중시한다.	{"brandLoyalty": 26, "noveltySeeking": 78, "ecoConsciousness": 48, "priceSensitivity": 64, "digitalConsumption": 85}	{"taxTolerance": 36, "governmentTrust": 29, "policyAcceptance": 45, "regulationPreference": 54, "publicServiceSatisfaction": 67}	0
1309	정서연	32	30-39	Male	대구광역시	35.942852	128.532019	전문대 졸	500-700만원	은퇴	부부 가구	22	보수 성향 무당층	50	{"economy": 7, "housing": -2, "welfare": 5, "security": 13, "environment": 3}	SNS	{다양성,공정,혁신}	대구광역시에 거주하는 30-39 은퇴. 정치 성향은 중도이며 다양성, 공정, 혁신 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 53, "ecoConsciousness": 52, "priceSensitivity": 52, "digitalConsumption": 88}	{"taxTolerance": 42, "governmentTrust": 43, "policyAcceptance": 35, "regulationPreference": 47, "publicServiceSatisfaction": 55}	0
1310	안준서	40	40-49	Female	대구광역시	35.869319	128.613986	전문대 졸	700만원 이상	서비스직	다세대 가구	30	보수 성향 무당층	73	{"economy": 61, "housing": 38, "welfare": 9, "security": 26, "environment": -1}	지상파/종편 뉴스	{공정,혁신,안정}	대구광역시에 거주하는 40-49 서비스직. 정치 성향은 중도이며 공정, 혁신, 안정 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 73, "ecoConsciousness": 38, "priceSensitivity": 37, "digitalConsumption": 66}	{"taxTolerance": 49, "governmentTrust": 38, "policyAcceptance": 39, "regulationPreference": 58, "publicServiceSatisfaction": 75}	0
1311	박서연	45	40-49	Female	대구광역시	35.868474	128.685553	전문대 졸	700만원 이상	프리랜서	자녀 양육 가구	21	보수 성향 무당층	65	{"economy": -4, "housing": 16, "welfare": -10, "security": 30, "environment": 24}	신문/팟캐스트	{환경,안전,공동체}	대구광역시에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 환경, 안전, 공동체 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 54, "ecoConsciousness": 30, "priceSensitivity": 50, "digitalConsumption": 78}	{"taxTolerance": 49, "governmentTrust": 56, "policyAcceptance": 47, "regulationPreference": 44, "publicServiceSatisfaction": 70}	0
1312	임민준	48	40-49	Female	대구광역시	35.893463	128.533635	전문대 졸	500-700만원	은퇴	부부 가구	21	보수 성향 무당층	77	{"economy": 3, "housing": 12, "welfare": 9, "security": 16, "environment": 21}	포털 뉴스	{다양성,환경,공동체}	대구광역시에 거주하는 40-49 은퇴. 정치 성향은 중도이며 다양성, 환경, 공동체 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 70, "ecoConsciousness": 45, "priceSensitivity": 36, "digitalConsumption": 71}	{"taxTolerance": 33, "governmentTrust": 50, "policyAcceptance": 49, "regulationPreference": 74, "publicServiceSatisfaction": 60}	0
1313	서동현	41	40-49	Male	대구광역시	35.859096	128.577408	대학교 졸	700만원 이상	공무원	부부 가구	36	보수 성향 무당층	69	{"economy": 16, "housing": -11, "welfare": -13, "security": 56, "environment": -8}	SNS	{자유,혁신,공동체}	대구광역시에 거주하는 40-49 공무원. 정치 성향은 보수이며 자유, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 53, "ecoConsciousness": 72, "priceSensitivity": 53, "digitalConsumption": 80}	{"taxTolerance": 46, "governmentTrust": 12, "policyAcceptance": 56, "regulationPreference": 64, "publicServiceSatisfaction": 67}	0
1314	류미경	40	40-49	Male	대구광역시	35.867558	128.615124	고졸 이하	200-350만원	서비스직	다세대 가구	28	보수 성향 무당층	64	{"economy": 28, "housing": 14, "welfare": 10, "security": 16, "environment": 43}	유튜브	{공정,자유,안정}	대구광역시에 거주하는 40-49 서비스직. 정치 성향은 중도이며 공정, 자유, 안정 가치를 중시한다.	{"brandLoyalty": 18, "noveltySeeking": 75, "ecoConsciousness": 68, "priceSensitivity": 58, "digitalConsumption": 59}	{"taxTolerance": 55, "governmentTrust": 58, "policyAcceptance": 53, "regulationPreference": 60, "publicServiceSatisfaction": 64}	0
1315	송성호	45	40-49	Male	대구광역시	35.940467	128.546525	고졸 이하	350-500만원	서비스직	자녀 양육 가구	14	중도 무당층	71	{"economy": -5, "housing": 9, "welfare": 24, "security": 14, "environment": 23}	SNS	{안정,다양성,전통}	대구광역시에 거주하는 40-49 서비스직. 정치 성향은 중도이며 안정, 다양성, 전통 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 53, "ecoConsciousness": 25, "priceSensitivity": 73, "digitalConsumption": 76}	{"taxTolerance": 63, "governmentTrust": 46, "policyAcceptance": 39, "regulationPreference": 52, "publicServiceSatisfaction": 79}	0
1316	류주원	57	50-59	Female	대구광역시	35.894828	128.670335	대학교 졸	350-500만원	주부	1인 가구	66	보수 정당 지지	77	{"economy": 56, "housing": -10, "welfare": -39, "security": 31, "environment": -8}	지상파/종편 뉴스	{자유,안전,혁신}	대구광역시에 거주하는 50-59 주부. 정치 성향은 보수이며 자유, 안전, 혁신 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 78, "ecoConsciousness": 54, "priceSensitivity": 60, "digitalConsumption": 67}	{"taxTolerance": 58, "governmentTrust": 38, "policyAcceptance": 36, "regulationPreference": 58, "publicServiceSatisfaction": 75}	0
1317	이정희	59	50-59	Female	대구광역시	35.867377	128.680221	전문대 졸	700만원 이상	전문직	다세대 가구	20	보수 성향 무당층	64	{"economy": -35, "housing": 8, "welfare": 12, "security": 41, "environment": 30}	포털 뉴스	{다양성,자유,공정}	대구광역시에 거주하는 50-59 전문직. 정치 성향은 중도이며 다양성, 자유, 공정 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 63, "ecoConsciousness": 49, "priceSensitivity": 42, "digitalConsumption": 62}	{"taxTolerance": 19, "governmentTrust": 22, "policyAcceptance": 44, "regulationPreference": 60, "publicServiceSatisfaction": 57}	0
1318	김경숙	55	50-59	Female	대구광역시	35.893752	128.598769	대학교 졸	500-700만원	생산직	다세대 가구	56	보수 정당 지지	96	{"economy": 50, "housing": -4, "welfare": 2, "security": 40, "environment": 4}	유튜브	{다양성,성장,안정}	대구광역시에 거주하는 50-59 생산직. 정치 성향은 보수이며 다양성, 성장, 안정 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 64, "ecoConsciousness": 61, "priceSensitivity": 53, "digitalConsumption": 66}	{"taxTolerance": 29, "governmentTrust": 45, "policyAcceptance": 53, "regulationPreference": 46, "publicServiceSatisfaction": 69}	0
1319	서순자	54	50-59	Female	대구광역시	35.846187	128.688152	대학원 졸	700만원 이상	공무원	부부 가구	10	중도 무당층	78	{"economy": 5, "housing": 1, "welfare": 17, "security": 14, "environment": 17}	포털 뉴스	{혁신,다양성,환경}	대구광역시에 거주하는 50-59 공무원. 정치 성향은 중도이며 혁신, 다양성, 환경 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 65, "ecoConsciousness": 54, "priceSensitivity": 47, "digitalConsumption": 63}	{"taxTolerance": 30, "governmentTrust": 31, "policyAcceptance": 48, "regulationPreference": 77, "publicServiceSatisfaction": 54}	0
1320	서채원	58	50-59	Male	대구광역시	35.913181	128.561265	대학원 졸	700만원 이상	사무직	부부 가구	19	보수 성향 무당층	64	{"economy": 13, "housing": -8, "welfare": 24, "security": -15, "environment": 5}	지상파/종편 뉴스	{안정,전통,공정}	대구광역시에 거주하는 50-59 사무직. 정치 성향은 중도이며 안정, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 45, "ecoConsciousness": 60, "priceSensitivity": 43, "digitalConsumption": 61}	{"taxTolerance": 52, "governmentTrust": 47, "policyAcceptance": 29, "regulationPreference": 64, "publicServiceSatisfaction": 61}	0
1321	송현우	55	50-59	Male	대구광역시	35.870124	128.618892	고졸 이하	500-700만원	생산직	자녀 양육 가구	2	중도 무당층	76	{"economy": -5, "housing": 21, "welfare": 31, "security": 23, "environment": 19}	포털 뉴스	{공동체,성장,혁신}	대구광역시에 거주하는 50-59 생산직. 정치 성향은 중도이며 공동체, 성장, 혁신 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 53, "ecoConsciousness": 26, "priceSensitivity": 45, "digitalConsumption": 73}	{"taxTolerance": 44, "governmentTrust": 43, "policyAcceptance": 40, "regulationPreference": 49, "publicServiceSatisfaction": 78}	0
1322	황광수	52	50-59	Male	대구광역시	35.844188	128.611012	고졸 이하	350-500만원	주부	자녀 양육 가구	17	보수 성향 무당층	76	{"economy": 4, "housing": 26, "welfare": 9, "security": 35, "environment": -23}	SNS	{공정,공동체,자유}	대구광역시에 거주하는 50-59 주부. 정치 성향은 중도이며 공정, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 46, "ecoConsciousness": 24, "priceSensitivity": 55, "digitalConsumption": 73}	{"taxTolerance": 53, "governmentTrust": 46, "policyAcceptance": 44, "regulationPreference": 74, "publicServiceSatisfaction": 72}	0
1323	정유준	56	50-59	Male	대구광역시	35.792388	128.619633	고졸 이하	500-700만원	서비스직	1인 가구	43	보수 성향 무당층	57	{"economy": 49, "housing": 0, "welfare": 0, "security": 20, "environment": 14}	포털 뉴스	{다양성,성장,혁신}	대구광역시에 거주하는 50-59 서비스직. 정치 성향은 보수이며 다양성, 성장, 혁신 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 48, "ecoConsciousness": 54, "priceSensitivity": 52, "digitalConsumption": 70}	{"taxTolerance": 31, "governmentTrust": 59, "policyAcceptance": 59, "regulationPreference": 68, "publicServiceSatisfaction": 82}	0
1324	윤광수	67	60-69	Female	대구광역시	35.899498	128.687968	전문대 졸	200-350만원	은퇴	부부 가구	89	보수 정당 지지	78	{"economy": 67, "housing": -41, "welfare": 6, "security": 42, "environment": -12}	유튜브	{자유,공정,안전}	대구광역시에 거주하는 60-69 은퇴. 정치 성향은 보수이며 자유, 공정, 안전 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 39, "ecoConsciousness": 66, "priceSensitivity": 73, "digitalConsumption": 57}	{"taxTolerance": 39, "governmentTrust": 38, "policyAcceptance": 46, "regulationPreference": 54, "publicServiceSatisfaction": 59}	0
1325	박은우	63	60-69	Female	대구광역시	35.871306	128.512338	전문대 졸	200-350만원	사무직	자녀 양육 가구	29	보수 성향 무당층	80	{"economy": 8, "housing": 19, "welfare": -14, "security": -1, "environment": -2}	포털 뉴스	{환경,공정,전통}	대구광역시에 거주하는 60-69 사무직. 정치 성향은 중도이며 환경, 공정, 전통 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 37, "ecoConsciousness": 51, "priceSensitivity": 83, "digitalConsumption": 67}	{"taxTolerance": 37, "governmentTrust": 58, "policyAcceptance": 53, "regulationPreference": 61, "publicServiceSatisfaction": 73}	0
1326	전민준	69	60-69	Female	대구광역시	35.859722	128.685961	고졸 이하	200-350만원	은퇴	1인 가구	8	중도 무당층	91	{"economy": 11, "housing": -2, "welfare": -17, "security": 38, "environment": 6}	SNS	{전통,환경,성장}	대구광역시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 전통, 환경, 성장 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 48, "ecoConsciousness": 40, "priceSensitivity": 62, "digitalConsumption": 52}	{"taxTolerance": 55, "governmentTrust": 32, "policyAcceptance": 36, "regulationPreference": 61, "publicServiceSatisfaction": 64}	0
1327	조예준	61	60-69	Male	대구광역시	35.927136	128.587396	대학원 졸	200만원 미만	학생	자녀 양육 가구	92	보수 정당 지지	52	{"economy": 56, "housing": 6, "welfare": -44, "security": 9, "environment": -50}	신문/팟캐스트	{안전,전통,공정}	대구광역시에 거주하는 60-69 학생. 정치 성향은 보수이며 안전, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 46, "ecoConsciousness": 55, "priceSensitivity": 78, "digitalConsumption": 61}	{"taxTolerance": 53, "governmentTrust": 39, "policyAcceptance": 55, "regulationPreference": 74, "publicServiceSatisfaction": 66}	0
1328	김유준	66	60-69	Male	대구광역시	35.823202	128.562313	대학교 졸	350-500만원	자영업	부부 가구	48	보수 정당 지지	73	{"economy": 72, "housing": 3, "welfare": 2, "security": 34, "environment": -21}	신문/팟캐스트	{안전,공정,다양성}	대구광역시에 거주하는 60-69 자영업. 정치 성향은 보수이며 안전, 공정, 다양성 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 66, "ecoConsciousness": 38, "priceSensitivity": 64, "digitalConsumption": 46}	{"taxTolerance": 46, "governmentTrust": 58, "policyAcceptance": 42, "regulationPreference": 58, "publicServiceSatisfaction": 50}	0
1329	정예준	61	60-69	Male	대구광역시	35.892594	128.676249	대학원 졸	350-500만원	전문직	다세대 가구	28	보수 성향 무당층	64	{"economy": 13, "housing": 12, "welfare": 3, "security": -4, "environment": 40}	지상파/종편 뉴스	{안전,전통,다양성}	대구광역시에 거주하는 60-69 전문직. 정치 성향은 중도이며 안전, 전통, 다양성 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 66, "ecoConsciousness": 61, "priceSensitivity": 77, "digitalConsumption": 62}	{"taxTolerance": 47, "governmentTrust": 36, "policyAcceptance": 35, "regulationPreference": 74, "publicServiceSatisfaction": 73}	0
1330	박하은	80	70+	Female	대구광역시	35.840971	128.659013	대학원 졸	500-700만원	은퇴	부부 가구	57	보수 정당 지지	83	{"economy": 19, "housing": -18, "welfare": -22, "security": 35, "environment": 19}	포털 뉴스	{환경,혁신,공정}	대구광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 환경, 혁신, 공정 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 37, "ecoConsciousness": 59, "priceSensitivity": 57, "digitalConsumption": 38}	{"taxTolerance": 28, "governmentTrust": 49, "policyAcceptance": 58, "regulationPreference": 72, "publicServiceSatisfaction": 60}	0
1331	윤유준	82	70+	Female	대구광역시	35.839379	128.508591	대학원 졸	350-500만원	은퇴	1인 가구	46	보수 정당 지지	99	{"economy": 16, "housing": 26, "welfare": -14, "security": 51, "environment": -28}	SNS	{안전,다양성,안정}	대구광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안전, 다양성, 안정 가치를 중시한다.	{"brandLoyalty": 69, "noveltySeeking": 57, "ecoConsciousness": 45, "priceSensitivity": 83, "digitalConsumption": 40}	{"taxTolerance": 38, "governmentTrust": 68, "policyAcceptance": 52, "regulationPreference": 79, "publicServiceSatisfaction": 74}	0
1332	최미경	80	70+	Female	대구광역시	35.916921	128.637554	전문대 졸	200만원 미만	은퇴	부부 가구	74	보수 정당 지지	96	{"economy": 52, "housing": -25, "welfare": -19, "security": 52, "environment": -2}	포털 뉴스	{환경,혁신,공동체}	대구광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 환경, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 33, "ecoConsciousness": 53, "priceSensitivity": 79, "digitalConsumption": 50}	{"taxTolerance": 43, "governmentTrust": 51, "policyAcceptance": 49, "regulationPreference": 54, "publicServiceSatisfaction": 73}	0
1333	김영수	80	70+	Male	대구광역시	35.807454	128.541968	전문대 졸	500-700만원	은퇴	다세대 가구	48	보수 정당 지지	99	{"economy": 49, "housing": -1, "welfare": -4, "security": 33, "environment": -22}	지상파/종편 뉴스	{공동체,안정,성장}	대구광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 공동체, 안정, 성장 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 34, "ecoConsciousness": 40, "priceSensitivity": 48, "digitalConsumption": 50}	{"taxTolerance": 57, "governmentTrust": 73, "policyAcceptance": 62, "regulationPreference": 79, "publicServiceSatisfaction": 67}	0
1334	한도윤	80	70+	Male	대구광역시	35.944588	128.658801	대학원 졸	350-500만원	은퇴	자녀 양육 가구	78	보수 정당 지지	92	{"economy": 42, "housing": -25, "welfare": -25, "security": 61, "environment": -15}	SNS	{공동체,공정,환경}	대구광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 공동체, 공정, 환경 가치를 중시한다.	{"brandLoyalty": 64, "noveltySeeking": 49, "ecoConsciousness": 43, "priceSensitivity": 55, "digitalConsumption": 60}	{"taxTolerance": 59, "governmentTrust": 52, "policyAcceptance": 55, "regulationPreference": 60, "publicServiceSatisfaction": 61}	0
1335	정지아	83	70+	Male	대구광역시	35.806944	128.67552	전문대 졸	500-700만원	은퇴	부부 가구	65	보수 정당 지지	76	{"economy": 2, "housing": -1, "welfare": -17, "security": 63, "environment": 19}	지상파/종편 뉴스	{다양성,안정,자유}	대구광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 다양성, 안정, 자유 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 42, "ecoConsciousness": 40, "priceSensitivity": 58, "digitalConsumption": 63}	{"taxTolerance": 44, "governmentTrust": 67, "policyAcceptance": 51, "regulationPreference": 61, "publicServiceSatisfaction": 60}	0
1336	오순자	29	18-29	Female	인천광역시	37.38089	126.658483	대학원 졸	200-350만원	주부	부부 가구	-38	진보 성향 무당층	41	{"economy": -33, "housing": 16, "welfare": 49, "security": -13, "environment": 29}	SNS	{자유,성장,혁신}	인천광역시에 거주하는 18-29 주부. 정치 성향은 진보이며 자유, 성장, 혁신 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 64, "ecoConsciousness": 59, "priceSensitivity": 45, "digitalConsumption": 73}	{"taxTolerance": 69, "governmentTrust": 40, "policyAcceptance": 57, "regulationPreference": 42, "publicServiceSatisfaction": 68}	0
1337	조하은	27	18-29	Female	인천광역시	37.406741	126.789016	대학원 졸	200-350만원	은퇴	부부 가구	-16	진보 성향 무당층	51	{"economy": -16, "housing": 37, "welfare": 12, "security": -8, "environment": 35}	지상파/종편 뉴스	{혁신,성장,환경}	인천광역시에 거주하는 18-29 은퇴. 정치 성향은 중도이며 혁신, 성장, 환경 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 76, "ecoConsciousness": 57, "priceSensitivity": 70, "digitalConsumption": 100}	{"taxTolerance": 51, "governmentTrust": 26, "policyAcceptance": 39, "regulationPreference": 78, "publicServiceSatisfaction": 72}	0
1338	최민서	20	18-29	Female	인천광역시	37.529047	126.770324	대학원 졸	350-500만원	학생	1인 가구	-3	중도 무당층	42	{"economy": -10, "housing": 8, "welfare": 3, "security": 18, "environment": 28}	신문/팟캐스트	{성장,다양성,안정}	인천광역시에 거주하는 18-29 학생. 정치 성향은 중도이며 성장, 다양성, 안정 가치를 중시한다.	{"brandLoyalty": 26, "noveltySeeking": 73, "ecoConsciousness": 53, "priceSensitivity": 32, "digitalConsumption": 59}	{"taxTolerance": 58, "governmentTrust": 8, "policyAcceptance": 39, "regulationPreference": 47, "publicServiceSatisfaction": 62}	0
1339	신수아	26	18-29	Female	인천광역시	37.428026	126.641615	대학원 졸	200만원 미만	서비스직	1인 가구	-33	진보 성향 무당층	52	{"economy": 7, "housing": 13, "welfare": 57, "security": -23, "environment": 35}	SNS	{안정,공정,공동체}	인천광역시에 거주하는 18-29 서비스직. 정치 성향은 중도이며 안정, 공정, 공동체 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 76, "ecoConsciousness": 47, "priceSensitivity": 68, "digitalConsumption": 81}	{"taxTolerance": 55, "governmentTrust": 45, "policyAcceptance": 40, "regulationPreference": 58, "publicServiceSatisfaction": 83}	0
1340	신도윤	23	18-29	Male	인천광역시	37.53185	126.614521	고졸 이하	500-700만원	학생	자녀 양육 가구	-30	진보 성향 무당층	26	{"economy": -32, "housing": 15, "welfare": 54, "security": -18, "environment": 17}	유튜브	{자유,혁신,다양성}	인천광역시에 거주하는 18-29 학생. 정치 성향은 중도이며 자유, 혁신, 다양성 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 82, "ecoConsciousness": 33, "priceSensitivity": 54, "digitalConsumption": 83}	{"taxTolerance": 43, "governmentTrust": 43, "policyAcceptance": 38, "regulationPreference": 49, "publicServiceSatisfaction": 68}	0
1341	서유준	28	18-29	Male	인천광역시	37.522299	126.779375	대학교 졸	200만원 미만	주부	1인 가구	-39	진보 성향 무당층	31	{"economy": -43, "housing": 37, "welfare": 38, "security": -34, "environment": 48}	신문/팟캐스트	{자유,공동체,안전}	인천광역시에 거주하는 18-29 주부. 정치 성향은 진보이며 자유, 공동체, 안전 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 66, "ecoConsciousness": 56, "priceSensitivity": 63, "digitalConsumption": 65}	{"taxTolerance": 50, "governmentTrust": 40, "policyAcceptance": 65, "regulationPreference": 56, "publicServiceSatisfaction": 70}	0
1342	강민서	22	18-29	Male	인천광역시	37.411848	126.767337	대학원 졸	500-700만원	학생	다세대 가구	-37	진보 성향 무당층	63	{"economy": -55, "housing": 53, "welfare": 58, "security": -14, "environment": 18}	지상파/종편 뉴스	{다양성,자유,환경}	인천광역시에 거주하는 18-29 학생. 정치 성향은 진보이며 다양성, 자유, 환경 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 48, "ecoConsciousness": 69, "priceSensitivity": 55, "digitalConsumption": 81}	{"taxTolerance": 66, "governmentTrust": 43, "policyAcceptance": 60, "regulationPreference": 65, "publicServiceSatisfaction": 76}	0
1343	최지우	26	18-29	Male	인천광역시	37.390748	126.737106	대학원 졸	350-500만원	공무원	자녀 양육 가구	-13	중도 무당층	44	{"economy": -4, "housing": -3, "welfare": 38, "security": -14, "environment": 21}	신문/팟캐스트	{공동체,성장,안전}	인천광역시에 거주하는 18-29 공무원. 정치 성향은 중도이며 공동체, 성장, 안전 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 53, "ecoConsciousness": 73, "priceSensitivity": 26, "digitalConsumption": 85}	{"taxTolerance": 46, "governmentTrust": 48, "policyAcceptance": 36, "regulationPreference": 61, "publicServiceSatisfaction": 77}	0
1344	한도윤	35	30-39	Female	인천광역시	37.381945	126.616396	대학교 졸	350-500만원	생산직	다세대 가구	-21	진보 성향 무당층	51	{"economy": -7, "housing": -15, "welfare": 20, "security": 0, "environment": 10}	지상파/종편 뉴스	{성장,공정,다양성}	인천광역시에 거주하는 30-39 생산직. 정치 성향은 중도이며 성장, 공정, 다양성 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 72, "ecoConsciousness": 37, "priceSensitivity": 36, "digitalConsumption": 78}	{"taxTolerance": 38, "governmentTrust": 39, "policyAcceptance": 37, "regulationPreference": 58, "publicServiceSatisfaction": 63}	0
1345	오철수	35	30-39	Female	인천광역시	37.456397	126.780506	대학교 졸	500-700만원	프리랜서	부부 가구	-21	진보 성향 무당층	56	{"economy": -20, "housing": 56, "welfare": -12, "security": 7, "environment": 11}	SNS	{공동체,안전,안정}	인천광역시에 거주하는 30-39 프리랜서. 정치 성향은 중도이며 공동체, 안전, 안정 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 66, "ecoConsciousness": 45, "priceSensitivity": 53, "digitalConsumption": 77}	{"taxTolerance": 72, "governmentTrust": 58, "policyAcceptance": 61, "regulationPreference": 67, "publicServiceSatisfaction": 76}	0
1346	서지우	37	30-39	Female	인천광역시	37.496258	126.756346	고졸 이하	500-700만원	공무원	부부 가구	39	보수 성향 무당층	59	{"economy": 32, "housing": 25, "welfare": 13, "security": -2, "environment": 36}	포털 뉴스	{자유,성장,환경}	인천광역시에 거주하는 30-39 공무원. 정치 성향은 보수이며 자유, 성장, 환경 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 73, "ecoConsciousness": 55, "priceSensitivity": 46, "digitalConsumption": 96}	{"taxTolerance": 19, "governmentTrust": 46, "policyAcceptance": 59, "regulationPreference": 81, "publicServiceSatisfaction": 51}	0
1347	조채원	34	30-39	Female	인천광역시	37.508211	126.640862	대학원 졸	500-700만원	주부	1인 가구	14	중도 무당층	30	{"economy": 43, "housing": 22, "welfare": -4, "security": 47, "environment": 22}	포털 뉴스	{성장,안전,다양성}	인천광역시에 거주하는 30-39 주부. 정치 성향은 중도이며 성장, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 59, "ecoConsciousness": 45, "priceSensitivity": 68, "digitalConsumption": 74}	{"taxTolerance": 48, "governmentTrust": 40, "policyAcceptance": 32, "regulationPreference": 59, "publicServiceSatisfaction": 72}	0
1348	안정희	35	30-39	Male	인천광역시	37.519246	126.71672	대학원 졸	350-500만원	자영업	자녀 양육 가구	-7	중도 무당층	39	{"economy": 7, "housing": 44, "welfare": 6, "security": 1, "environment": 22}	SNS	{안전,자유,안정}	인천광역시에 거주하는 30-39 자영업. 정치 성향은 중도이며 안전, 자유, 안정 가치를 중시한다.	{"brandLoyalty": 21, "noveltySeeking": 50, "ecoConsciousness": 53, "priceSensitivity": 59, "digitalConsumption": 71}	{"taxTolerance": 65, "governmentTrust": 44, "policyAcceptance": 45, "regulationPreference": 65, "publicServiceSatisfaction": 78}	0
1349	이하은	36	30-39	Male	인천광역시	37.434362	126.644919	대학교 졸	700만원 이상	프리랜서	다세대 가구	-8	중도 무당층	74	{"economy": -6, "housing": -7, "welfare": 19, "security": 1, "environment": 5}	신문/팟캐스트	{환경,안정,자유}	인천광역시에 거주하는 30-39 프리랜서. 정치 성향은 중도이며 환경, 안정, 자유 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 73, "ecoConsciousness": 60, "priceSensitivity": 67, "digitalConsumption": 79}	{"taxTolerance": 37, "governmentTrust": 35, "policyAcceptance": 32, "regulationPreference": 79, "publicServiceSatisfaction": 80}	0
1350	윤채원	36	30-39	Male	인천광역시	37.530099	126.713752	대학교 졸	350-500만원	서비스직	부부 가구	-81	진보 정당 지지	72	{"economy": -19, "housing": 32, "welfare": 46, "security": -66, "environment": 80}	신문/팟캐스트	{다양성,자유,혁신}	인천광역시에 거주하는 30-39 서비스직. 정치 성향은 진보이며 다양성, 자유, 혁신 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 68, "ecoConsciousness": 56, "priceSensitivity": 67, "digitalConsumption": 96}	{"taxTolerance": 42, "governmentTrust": 56, "policyAcceptance": 59, "regulationPreference": 62, "publicServiceSatisfaction": 45}	0
1351	이수아	38	30-39	Male	인천광역시	37.521448	126.751094	대학교 졸	350-500만원	생산직	다세대 가구	-37	진보 성향 무당층	51	{"economy": -14, "housing": 23, "welfare": 20, "security": -33, "environment": 32}	유튜브	{혁신,전통,성장}	인천광역시에 거주하는 30-39 생산직. 정치 성향은 진보이며 혁신, 전통, 성장 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 69, "ecoConsciousness": 56, "priceSensitivity": 50, "digitalConsumption": 74}	{"taxTolerance": 45, "governmentTrust": 55, "policyAcceptance": 57, "regulationPreference": 61, "publicServiceSatisfaction": 83}	0
1352	임지호	45	40-49	Female	인천광역시	37.479966	126.642717	대학교 졸	700만원 이상	생산직	자녀 양육 가구	-21	진보 성향 무당층	54	{"economy": -9, "housing": 18, "welfare": 59, "security": -4, "environment": 29}	유튜브	{공동체,다양성,환경}	인천광역시에 거주하는 40-49 생산직. 정치 성향은 중도이며 공동체, 다양성, 환경 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 63, "ecoConsciousness": 34, "priceSensitivity": 52, "digitalConsumption": 74}	{"taxTolerance": 50, "governmentTrust": 64, "policyAcceptance": 57, "regulationPreference": 64, "publicServiceSatisfaction": 42}	0
1353	오서연	42	40-49	Female	인천광역시	37.44795	126.664681	대학교 졸	500-700만원	공무원	다세대 가구	5	중도 무당층	78	{"economy": -14, "housing": 18, "welfare": 22, "security": 17, "environment": 0}	SNS	{전통,자유,안전}	인천광역시에 거주하는 40-49 공무원. 정치 성향은 중도이며 전통, 자유, 안전 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 66, "ecoConsciousness": 63, "priceSensitivity": 58, "digitalConsumption": 68}	{"taxTolerance": 62, "governmentTrust": 50, "policyAcceptance": 41, "regulationPreference": 70, "publicServiceSatisfaction": 66}	0
1354	한수아	47	40-49	Female	인천광역시	37.454938	126.621961	전문대 졸	200-350만원	서비스직	1인 가구	1	중도 무당층	74	{"economy": -29, "housing": -10, "welfare": -13, "security": 23, "environment": 7}	지상파/종편 뉴스	{안전,다양성,환경}	인천광역시에 거주하는 40-49 서비스직. 정치 성향은 중도이며 안전, 다양성, 환경 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 54, "ecoConsciousness": 44, "priceSensitivity": 73, "digitalConsumption": 65}	{"taxTolerance": 52, "governmentTrust": 57, "policyAcceptance": 49, "regulationPreference": 54, "publicServiceSatisfaction": 59}	0
1355	송지호	48	40-49	Female	인천광역시	37.4058	126.691751	대학교 졸	500-700만원	서비스직	다세대 가구	-2	중도 무당층	60	{"economy": -29, "housing": 5, "welfare": 35, "security": -8, "environment": 26}	신문/팟캐스트	{다양성,혁신,공동체}	인천광역시에 거주하는 40-49 서비스직. 정치 성향은 중도이며 다양성, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 52, "ecoConsciousness": 50, "priceSensitivity": 51, "digitalConsumption": 58}	{"taxTolerance": 48, "governmentTrust": 40, "policyAcceptance": 49, "regulationPreference": 70, "publicServiceSatisfaction": 60}	0
1356	김미경	42	40-49	Male	인천광역시	37.390811	126.731156	고졸 이하	200만원 미만	전문직	자녀 양육 가구	-49	진보 정당 지지	67	{"economy": -18, "housing": 42, "welfare": 7, "security": -34, "environment": 43}	SNS	{혁신,전통,안전}	인천광역시에 거주하는 40-49 전문직. 정치 성향은 진보이며 혁신, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 63, "ecoConsciousness": 57, "priceSensitivity": 76, "digitalConsumption": 72}	{"taxTolerance": 40, "governmentTrust": 50, "policyAcceptance": 46, "regulationPreference": 65, "publicServiceSatisfaction": 61}	0
1357	서준서	47	40-49	Male	인천광역시	37.49081	126.655682	대학원 졸	700만원 이상	은퇴	자녀 양육 가구	24	보수 성향 무당층	77	{"economy": 47, "housing": 10, "welfare": -7, "security": 36, "environment": 23}	유튜브	{다양성,공동체,혁신}	인천광역시에 거주하는 40-49 은퇴. 정치 성향은 중도이며 다양성, 공동체, 혁신 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 70, "ecoConsciousness": 58, "priceSensitivity": 58, "digitalConsumption": 92}	{"taxTolerance": 45, "governmentTrust": 48, "policyAcceptance": 58, "regulationPreference": 49, "publicServiceSatisfaction": 72}	0
1358	오영수	41	40-49	Male	인천광역시	37.386739	126.709178	대학교 졸	350-500만원	전문직	부부 가구	-21	진보 성향 무당층	47	{"economy": -35, "housing": 30, "welfare": 73, "security": -18, "environment": 13}	지상파/종편 뉴스	{혁신,공정,환경}	인천광역시에 거주하는 40-49 전문직. 정치 성향은 중도이며 혁신, 공정, 환경 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 68, "ecoConsciousness": 47, "priceSensitivity": 75, "digitalConsumption": 64}	{"taxTolerance": 50, "governmentTrust": 40, "policyAcceptance": 49, "regulationPreference": 74, "publicServiceSatisfaction": 49}	0
1359	윤채원	49	40-49	Male	인천광역시	37.507516	126.684165	고졸 이하	350-500만원	프리랜서	자녀 양육 가구	24	보수 성향 무당층	72	{"economy": -12, "housing": -1, "welfare": 31, "security": 24, "environment": -4}	유튜브	{자유,공정,성장}	인천광역시에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 자유, 공정, 성장 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 45, "ecoConsciousness": 29, "priceSensitivity": 52, "digitalConsumption": 66}	{"taxTolerance": 48, "governmentTrust": 52, "policyAcceptance": 62, "regulationPreference": 46, "publicServiceSatisfaction": 53}	0
1360	한경숙	58	50-59	Female	인천광역시	37.487802	126.761435	대학원 졸	700만원 이상	생산직	다세대 가구	-5	중도 무당층	74	{"economy": -10, "housing": 6, "welfare": 13, "security": -9, "environment": 10}	유튜브	{혁신,안정,공동체}	인천광역시에 거주하는 50-59 생산직. 정치 성향은 중도이며 혁신, 안정, 공동체 가치를 중시한다.	{"brandLoyalty": 61, "noveltySeeking": 55, "ecoConsciousness": 63, "priceSensitivity": 34, "digitalConsumption": 53}	{"taxTolerance": 48, "governmentTrust": 39, "policyAcceptance": 34, "regulationPreference": 64, "publicServiceSatisfaction": 72}	0
1361	박주원	57	50-59	Female	인천광역시	37.533043	126.729038	대학교 졸	500-700만원	서비스직	자녀 양육 가구	18	보수 성향 무당층	71	{"economy": 29, "housing": 20, "welfare": 11, "security": 43, "environment": -1}	신문/팟캐스트	{성장,환경,안전}	인천광역시에 거주하는 50-59 서비스직. 정치 성향은 중도이며 성장, 환경, 안전 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 36, "ecoConsciousness": 54, "priceSensitivity": 60, "digitalConsumption": 52}	{"taxTolerance": 48, "governmentTrust": 45, "policyAcceptance": 47, "regulationPreference": 68, "publicServiceSatisfaction": 74}	0
1362	홍성호	54	50-59	Female	인천광역시	37.423749	126.651998	전문대 졸	350-500만원	사무직	1인 가구	-9	중도 무당층	69	{"economy": -6, "housing": 11, "welfare": 30, "security": 7, "environment": -9}	지상파/종편 뉴스	{성장,공동체,자유}	인천광역시에 거주하는 50-59 사무직. 정치 성향은 중도이며 성장, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 49, "ecoConsciousness": 58, "priceSensitivity": 43, "digitalConsumption": 67}	{"taxTolerance": 53, "governmentTrust": 43, "policyAcceptance": 54, "regulationPreference": 52, "publicServiceSatisfaction": 67}	0
1363	한하은	55	50-59	Female	인천광역시	37.483879	126.716446	대학원 졸	350-500만원	은퇴	1인 가구	22	보수 성향 무당층	86	{"economy": 39, "housing": -3, "welfare": 8, "security": -4, "environment": 33}	지상파/종편 뉴스	{전통,혁신,성장}	인천광역시에 거주하는 50-59 은퇴. 정치 성향은 중도이며 전통, 혁신, 성장 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 53, "ecoConsciousness": 57, "priceSensitivity": 75, "digitalConsumption": 65}	{"taxTolerance": 40, "governmentTrust": 39, "policyAcceptance": 40, "regulationPreference": 63, "publicServiceSatisfaction": 47}	0
1364	최서윤	55	50-59	Female	인천광역시	37.478525	126.731077	전문대 졸	500-700만원	학생	부부 가구	10	중도 무당층	72	{"economy": 7, "housing": 31, "welfare": 10, "security": 11, "environment": 22}	지상파/종편 뉴스	{혁신,다양성,자유}	인천광역시에 거주하는 50-59 학생. 정치 성향은 중도이며 혁신, 다양성, 자유 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 50, "ecoConsciousness": 51, "priceSensitivity": 56, "digitalConsumption": 61}	{"taxTolerance": 37, "governmentTrust": 56, "policyAcceptance": 44, "regulationPreference": 65, "publicServiceSatisfaction": 67}	0
1365	임지민	57	50-59	Male	인천광역시	37.509544	126.728786	대학교 졸	350-500만원	은퇴	1인 가구	-10	중도 무당층	82	{"economy": -2, "housing": 46, "welfare": -9, "security": -12, "environment": 21}	유튜브	{성장,공동체,안전}	인천광역시에 거주하는 50-59 은퇴. 정치 성향은 중도이며 성장, 공동체, 안전 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 46, "ecoConsciousness": 40, "priceSensitivity": 67, "digitalConsumption": 54}	{"taxTolerance": 48, "governmentTrust": 70, "policyAcceptance": 37, "regulationPreference": 57, "publicServiceSatisfaction": 51}	0
1366	홍영수	58	50-59	Male	인천광역시	37.468254	126.655861	대학원 졸	500-700만원	프리랜서	부부 가구	-2	중도 무당층	61	{"economy": 18, "housing": 25, "welfare": 36, "security": 36, "environment": 16}	지상파/종편 뉴스	{공정,혁신,전통}	인천광역시에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 공정, 혁신, 전통 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 58, "ecoConsciousness": 43, "priceSensitivity": 59, "digitalConsumption": 70}	{"taxTolerance": 56, "governmentTrust": 47, "policyAcceptance": 52, "regulationPreference": 57, "publicServiceSatisfaction": 74}	0
1367	홍미경	52	50-59	Male	인천광역시	37.516248	126.797048	대학원 졸	700만원 이상	서비스직	다세대 가구	25	보수 성향 무당층	77	{"economy": 30, "housing": 6, "welfare": -8, "security": 8, "environment": 10}	유튜브	{성장,안전,다양성}	인천광역시에 거주하는 50-59 서비스직. 정치 성향은 중도이며 성장, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 65, "ecoConsciousness": 68, "priceSensitivity": 39, "digitalConsumption": 70}	{"taxTolerance": 67, "governmentTrust": 50, "policyAcceptance": 67, "regulationPreference": 59, "publicServiceSatisfaction": 66}	0
1368	오주원	53	50-59	Male	인천광역시	37.379799	126.697126	대학교 졸	700만원 이상	서비스직	부부 가구	-14	중도 무당층	45	{"economy": -1, "housing": 25, "welfare": 10, "security": 29, "environment": 12}	지상파/종편 뉴스	{자유,공정,전통}	인천광역시에 거주하는 50-59 서비스직. 정치 성향은 중도이며 자유, 공정, 전통 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 61, "ecoConsciousness": 55, "priceSensitivity": 30, "digitalConsumption": 72}	{"taxTolerance": 47, "governmentTrust": 25, "policyAcceptance": 47, "regulationPreference": 75, "publicServiceSatisfaction": 63}	0
1369	강미경	56	50-59	Male	인천광역시	37.501646	126.788086	대학원 졸	500-700만원	주부	다세대 가구	-11	중도 무당층	84	{"economy": 20, "housing": 39, "welfare": -1, "security": -4, "environment": 8}	유튜브	{다양성,공동체,전통}	인천광역시에 거주하는 50-59 주부. 정치 성향은 중도이며 다양성, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 58, "ecoConsciousness": 60, "priceSensitivity": 45, "digitalConsumption": 72}	{"taxTolerance": 52, "governmentTrust": 60, "policyAcceptance": 40, "regulationPreference": 55, "publicServiceSatisfaction": 51}	0
1370	송은우	65	60-69	Female	인천광역시	37.417979	126.784464	대학교 졸	350-500만원	학생	1인 가구	-20	진보 성향 무당층	57	{"economy": -43, "housing": 12, "welfare": 40, "security": -4, "environment": 29}	SNS	{환경,안전,다양성}	인천광역시에 거주하는 60-69 학생. 정치 성향은 중도이며 환경, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 43, "ecoConsciousness": 34, "priceSensitivity": 58, "digitalConsumption": 55}	{"taxTolerance": 41, "governmentTrust": 46, "policyAcceptance": 31, "regulationPreference": 74, "publicServiceSatisfaction": 46}	0
1371	류성호	68	60-69	Female	인천광역시	37.434426	126.690133	전문대 졸	200-350만원	은퇴	1인 가구	12	중도 무당층	69	{"economy": 10, "housing": 5, "welfare": 25, "security": 7, "environment": 3}	지상파/종편 뉴스	{다양성,자유,전통}	인천광역시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 다양성, 자유, 전통 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 47, "ecoConsciousness": 31, "priceSensitivity": 70, "digitalConsumption": 47}	{"taxTolerance": 46, "governmentTrust": 40, "policyAcceptance": 53, "regulationPreference": 65, "publicServiceSatisfaction": 77}	0
1372	안정희	64	60-69	Female	인천광역시	37.38233	126.759478	대학교 졸	700만원 이상	프리랜서	다세대 가구	9	중도 무당층	75	{"economy": 14, "housing": 10, "welfare": -21, "security": -2, "environment": 40}	지상파/종편 뉴스	{안전,환경,다양성}	인천광역시에 거주하는 60-69 프리랜서. 정치 성향은 중도이며 안전, 환경, 다양성 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 49, "ecoConsciousness": 65, "priceSensitivity": 49, "digitalConsumption": 67}	{"taxTolerance": 33, "governmentTrust": 26, "policyAcceptance": 30, "regulationPreference": 82, "publicServiceSatisfaction": 77}	0
1373	조동현	64	60-69	Female	인천광역시	37.468759	126.620663	대학원 졸	200-350만원	학생	다세대 가구	32	보수 성향 무당층	68	{"economy": 10, "housing": 14, "welfare": 12, "security": 10, "environment": 17}	SNS	{전통,공동체,안정}	인천광역시에 거주하는 60-69 학생. 정치 성향은 중도이며 전통, 공동체, 안정 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 55, "ecoConsciousness": 55, "priceSensitivity": 67, "digitalConsumption": 65}	{"taxTolerance": 53, "governmentTrust": 32, "policyAcceptance": 65, "regulationPreference": 68, "publicServiceSatisfaction": 65}	0
1374	황지호	69	60-69	Male	인천광역시	37.397353	126.608263	고졸 이하	200-350만원	은퇴	1인 가구	100	보수 정당 지지	76	{"economy": 65, "housing": -10, "welfare": -54, "security": 39, "environment": -16}	지상파/종편 뉴스	{전통,자유,혁신}	인천광역시에 거주하는 60-69 은퇴. 정치 성향은 보수이며 전통, 자유, 혁신 가치를 중시한다.	{"brandLoyalty": 60, "noveltySeeking": 41, "ecoConsciousness": 37, "priceSensitivity": 64, "digitalConsumption": 64}	{"taxTolerance": 32, "governmentTrust": 46, "policyAcceptance": 49, "regulationPreference": 66, "publicServiceSatisfaction": 55}	0
1375	한채원	67	60-69	Male	인천광역시	37.511919	126.732154	고졸 이하	350-500만원	은퇴	자녀 양육 가구	-11	중도 무당층	61	{"economy": -11, "housing": 31, "welfare": 35, "security": -16, "environment": 8}	포털 뉴스	{성장,공동체,환경}	인천광역시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 성장, 공동체, 환경 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 42, "ecoConsciousness": 35, "priceSensitivity": 53, "digitalConsumption": 67}	{"taxTolerance": 50, "governmentTrust": 66, "policyAcceptance": 36, "regulationPreference": 64, "publicServiceSatisfaction": 78}	0
1376	임유준	68	60-69	Male	인천광역시	37.491242	126.795005	전문대 졸	200만원 미만	은퇴	1인 가구	21	보수 성향 무당층	63	{"economy": 10, "housing": 16, "welfare": 29, "security": 11, "environment": 27}	SNS	{혁신,공동체,환경}	인천광역시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 혁신, 공동체, 환경 가치를 중시한다.	{"brandLoyalty": 60, "noveltySeeking": 44, "ecoConsciousness": 51, "priceSensitivity": 74, "digitalConsumption": 69}	{"taxTolerance": 42, "governmentTrust": 66, "policyAcceptance": 69, "regulationPreference": 59, "publicServiceSatisfaction": 49}	0
1377	류유준	66	60-69	Male	인천광역시	37.47805	126.614586	대학교 졸	200-350만원	자영업	다세대 가구	34	보수 성향 무당층	60	{"economy": 27, "housing": -7, "welfare": -11, "security": -9, "environment": 15}	신문/팟캐스트	{환경,전통,안정}	인천광역시에 거주하는 60-69 자영업. 정치 성향은 보수이며 환경, 전통, 안정 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 50, "ecoConsciousness": 46, "priceSensitivity": 40, "digitalConsumption": 62}	{"taxTolerance": 58, "governmentTrust": 45, "policyAcceptance": 40, "regulationPreference": 56, "publicServiceSatisfaction": 82}	0
1378	신지아	73	70+	Female	인천광역시	37.441576	126.609401	대학교 졸	200-350만원	은퇴	다세대 가구	-8	중도 무당층	75	{"economy": -25, "housing": 11, "welfare": 25, "security": -22, "environment": 7}	유튜브	{공동체,전통,자유}	인천광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공동체, 전통, 자유 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 51, "ecoConsciousness": 48, "priceSensitivity": 78, "digitalConsumption": 59}	{"taxTolerance": 41, "governmentTrust": 39, "policyAcceptance": 50, "regulationPreference": 73, "publicServiceSatisfaction": 62}	0
1379	권도윤	71	70+	Female	인천광역시	37.483205	126.754029	전문대 졸	200만원 미만	은퇴	자녀 양육 가구	0	중도 무당층	77	{"economy": -2, "housing": 19, "welfare": 10, "security": -4, "environment": 30}	포털 뉴스	{안전,성장,전통}	인천광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안전, 성장, 전통 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 63, "ecoConsciousness": 52, "priceSensitivity": 87, "digitalConsumption": 46}	{"taxTolerance": 34, "governmentTrust": 44, "policyAcceptance": 64, "regulationPreference": 40, "publicServiceSatisfaction": 70}	0
1380	장도윤	71	70+	Female	인천광역시	37.409093	126.631115	전문대 졸	350-500만원	은퇴	자녀 양육 가구	48	보수 정당 지지	87	{"economy": 31, "housing": 12, "welfare": -22, "security": 18, "environment": -18}	포털 뉴스	{전통,성장,안전}	인천광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 전통, 성장, 안전 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 54, "ecoConsciousness": 45, "priceSensitivity": 64, "digitalConsumption": 50}	{"taxTolerance": 32, "governmentTrust": 66, "policyAcceptance": 50, "regulationPreference": 68, "publicServiceSatisfaction": 62}	0
1381	최지민	75	70+	Male	인천광역시	37.510583	126.720027	대학교 졸	200-350만원	은퇴	자녀 양육 가구	43	보수 성향 무당층	92	{"economy": 31, "housing": -1, "welfare": -21, "security": 22, "environment": -18}	신문/팟캐스트	{성장,혁신,자유}	인천광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 성장, 혁신, 자유 가치를 중시한다.	{"brandLoyalty": 64, "noveltySeeking": 47, "ecoConsciousness": 66, "priceSensitivity": 73, "digitalConsumption": 57}	{"taxTolerance": 45, "governmentTrust": 37, "policyAcceptance": 51, "regulationPreference": 50, "publicServiceSatisfaction": 64}	0
1382	류수아	81	70+	Male	인천광역시	37.398906	126.648887	대학원 졸	500-700만원	은퇴	다세대 가구	-5	중도 무당층	93	{"economy": -17, "housing": 4, "welfare": 18, "security": -17, "environment": 13}	유튜브	{공정,공동체,환경}	인천광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공정, 공동체, 환경 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 38, "ecoConsciousness": 43, "priceSensitivity": 36, "digitalConsumption": 49}	{"taxTolerance": 41, "governmentTrust": 67, "policyAcceptance": 59, "regulationPreference": 54, "publicServiceSatisfaction": 73}	0
1383	김경숙	83	70+	Male	인천광역시	37.535961	126.748023	대학교 졸	200-350만원	은퇴	자녀 양육 가구	7	중도 무당층	99	{"economy": 8, "housing": 4, "welfare": 24, "security": -4, "environment": 7}	신문/팟캐스트	{공정,안전,다양성}	인천광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공정, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 59, "ecoConsciousness": 51, "priceSensitivity": 75, "digitalConsumption": 39}	{"taxTolerance": 50, "governmentTrust": 36, "policyAcceptance": 51, "regulationPreference": 63, "publicServiceSatisfaction": 66}	0
1384	조도윤	23	18-29	Female	광주광역시	35.215344	126.853327	대학원 졸	700만원 이상	학생	다세대 가구	-59	진보 정당 지지	62	{"economy": -42, "housing": 33, "welfare": 27, "security": -4, "environment": 48}	지상파/종편 뉴스	{혁신,환경,공동체}	광주광역시에 거주하는 18-29 학생. 정치 성향은 진보이며 혁신, 환경, 공동체 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 60, "ecoConsciousness": 68, "priceSensitivity": 44, "digitalConsumption": 80}	{"taxTolerance": 73, "governmentTrust": 54, "policyAcceptance": 13, "regulationPreference": 70, "publicServiceSatisfaction": 59}	0
1385	황정희	21	18-29	Female	광주광역시	35.146105	126.788832	대학원 졸	200-350만원	학생	다세대 가구	-94	진보 정당 지지	64	{"economy": -61, "housing": 56, "welfare": 68, "security": -68, "environment": 25}	포털 뉴스	{안정,다양성,공동체}	광주광역시에 거주하는 18-29 학생. 정치 성향은 진보이며 안정, 다양성, 공동체 가치를 중시한다.	{"brandLoyalty": 19, "noveltySeeking": 79, "ecoConsciousness": 56, "priceSensitivity": 78, "digitalConsumption": 92}	{"taxTolerance": 27, "governmentTrust": 31, "policyAcceptance": 31, "regulationPreference": 56, "publicServiceSatisfaction": 54}	0
1386	한영수	21	18-29	Male	광주광역시	35.16005	126.838189	전문대 졸	200-350만원	자영업	자녀 양육 가구	-94	진보 정당 지지	61	{"economy": -50, "housing": 39, "welfare": 73, "security": -44, "environment": 47}	유튜브	{환경,자유,성장}	광주광역시에 거주하는 18-29 자영업. 정치 성향은 진보이며 환경, 자유, 성장 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 63, "ecoConsciousness": 44, "priceSensitivity": 41, "digitalConsumption": 54}	{"taxTolerance": 43, "governmentTrust": 38, "policyAcceptance": 31, "regulationPreference": 51, "publicServiceSatisfaction": 31}	0
1387	송다은	22	18-29	Male	광주광역시	35.228043	126.824799	대학원 졸	350-500만원	학생	1인 가구	-85	진보 정당 지지	66	{"economy": -53, "housing": 46, "welfare": 77, "security": -69, "environment": 62}	신문/팟캐스트	{자유,다양성,안전}	광주광역시에 거주하는 18-29 학생. 정치 성향은 진보이며 자유, 다양성, 안전 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 96, "ecoConsciousness": 65, "priceSensitivity": 54, "digitalConsumption": 92}	{"taxTolerance": 48, "governmentTrust": 63, "policyAcceptance": 50, "regulationPreference": 69, "publicServiceSatisfaction": 55}	0
1388	이다은	33	30-39	Female	광주광역시	35.139888	126.779954	대학원 졸	200만원 미만	전문직	부부 가구	-41	진보 성향 무당층	47	{"economy": -35, "housing": 31, "welfare": 23, "security": -49, "environment": 46}	유튜브	{환경,자유,안전}	광주광역시에 거주하는 30-39 전문직. 정치 성향은 진보이며 환경, 자유, 안전 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 87, "ecoConsciousness": 36, "priceSensitivity": 60, "digitalConsumption": 79}	{"taxTolerance": 45, "governmentTrust": 26, "policyAcceptance": 45, "regulationPreference": 62, "publicServiceSatisfaction": 67}	0
1389	신건우	34	30-39	Female	광주광역시	35.209645	126.897809	대학원 졸	350-500만원	공무원	자녀 양육 가구	-44	진보 성향 무당층	32	{"economy": -34, "housing": 53, "welfare": 6, "security": 17, "environment": 26}	포털 뉴스	{전통,성장,안정}	광주광역시에 거주하는 30-39 공무원. 정치 성향은 진보이며 전통, 성장, 안정 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 74, "ecoConsciousness": 52, "priceSensitivity": 67, "digitalConsumption": 79}	{"taxTolerance": 66, "governmentTrust": 37, "policyAcceptance": 36, "regulationPreference": 70, "publicServiceSatisfaction": 56}	0
1390	황정희	32	30-39	Male	광주광역시	35.142009	126.781564	고졸 이하	700만원 이상	서비스직	다세대 가구	0	중도 무당층	66	{"economy": 0, "housing": 47, "welfare": 6, "security": 21, "environment": 19}	유튜브	{공정,혁신,안정}	광주광역시에 거주하는 30-39 서비스직. 정치 성향은 중도이며 공정, 혁신, 안정 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 59, "ecoConsciousness": 54, "priceSensitivity": 28, "digitalConsumption": 97}	{"taxTolerance": 42, "governmentTrust": 41, "policyAcceptance": 48, "regulationPreference": 62, "publicServiceSatisfaction": 67}	0
1391	정지민	39	30-39	Male	광주광역시	35.1733	126.918225	전문대 졸	500-700만원	자영업	부부 가구	-33	진보 성향 무당층	56	{"economy": -26, "housing": 32, "welfare": 29, "security": 3, "environment": 20}	SNS	{자유,안정,전통}	광주광역시에 거주하는 30-39 자영업. 정치 성향은 중도이며 자유, 안정, 전통 가치를 중시한다.	{"brandLoyalty": 63, "noveltySeeking": 56, "ecoConsciousness": 59, "priceSensitivity": 58, "digitalConsumption": 66}	{"taxTolerance": 36, "governmentTrust": 46, "policyAcceptance": 48, "regulationPreference": 59, "publicServiceSatisfaction": 50}	0
1392	임지우	42	40-49	Female	광주광역시	35.098112	126.913835	대학원 졸	200-350만원	전문직	부부 가구	-26	진보 성향 무당층	73	{"economy": -26, "housing": 24, "welfare": 43, "security": -6, "environment": 27}	유튜브	{자유,전통,환경}	광주광역시에 거주하는 40-49 전문직. 정치 성향은 중도이며 자유, 전통, 환경 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 72, "ecoConsciousness": 60, "priceSensitivity": 65, "digitalConsumption": 67}	{"taxTolerance": 40, "governmentTrust": 47, "policyAcceptance": 22, "regulationPreference": 59, "publicServiceSatisfaction": 55}	0
1393	장정희	45	40-49	Female	광주광역시	35.083263	126.889674	대학교 졸	350-500만원	서비스직	부부 가구	-27	진보 성향 무당층	76	{"economy": -9, "housing": 31, "welfare": 38, "security": -28, "environment": 10}	지상파/종편 뉴스	{다양성,전통,공동체}	광주광역시에 거주하는 40-49 서비스직. 정치 성향은 중도이며 다양성, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 64, "ecoConsciousness": 28, "priceSensitivity": 67, "digitalConsumption": 62}	{"taxTolerance": 47, "governmentTrust": 51, "policyAcceptance": 36, "regulationPreference": 60, "publicServiceSatisfaction": 60}	0
1394	임지아	48	40-49	Male	광주광역시	35.229598	126.948014	대학교 졸	350-500만원	학생	다세대 가구	-45	진보 정당 지지	65	{"economy": -25, "housing": 60, "welfare": 30, "security": -14, "environment": 36}	포털 뉴스	{자유,환경,공정}	광주광역시에 거주하는 40-49 학생. 정치 성향은 진보이며 자유, 환경, 공정 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 57, "ecoConsciousness": 46, "priceSensitivity": 50, "digitalConsumption": 73}	{"taxTolerance": 35, "governmentTrust": 38, "policyAcceptance": 45, "regulationPreference": 52, "publicServiceSatisfaction": 60}	0
1395	송준서	45	40-49	Male	광주광역시	35.166095	126.943555	전문대 졸	700만원 이상	프리랜서	1인 가구	-57	진보 정당 지지	67	{"economy": -42, "housing": 19, "welfare": 42, "security": -25, "environment": 17}	SNS	{안정,안전,공정}	광주광역시에 거주하는 40-49 프리랜서. 정치 성향은 진보이며 안정, 안전, 공정 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 65, "ecoConsciousness": 66, "priceSensitivity": 50, "digitalConsumption": 72}	{"taxTolerance": 39, "governmentTrust": 56, "policyAcceptance": 41, "regulationPreference": 59, "publicServiceSatisfaction": 57}	0
1396	전주원	53	50-59	Female	광주광역시	35.196729	126.779665	전문대 졸	500-700만원	서비스직	다세대 가구	-28	진보 성향 무당층	78	{"economy": -16, "housing": 54, "welfare": 27, "security": -8, "environment": 36}	신문/팟캐스트	{전통,공동체,혁신}	광주광역시에 거주하는 50-59 서비스직. 정치 성향은 중도이며 전통, 공동체, 혁신 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 49, "ecoConsciousness": 63, "priceSensitivity": 59, "digitalConsumption": 69}	{"taxTolerance": 48, "governmentTrust": 49, "policyAcceptance": 67, "regulationPreference": 53, "publicServiceSatisfaction": 68}	0
1397	최경숙	53	50-59	Female	광주광역시	35.118308	126.919565	고졸 이하	500-700만원	학생	자녀 양육 가구	-45	진보 정당 지지	64	{"economy": -29, "housing": 29, "welfare": 33, "security": -13, "environment": 34}	신문/팟캐스트	{혁신,전통,안전}	광주광역시에 거주하는 50-59 학생. 정치 성향은 진보이며 혁신, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 44, "ecoConsciousness": 61, "priceSensitivity": 52, "digitalConsumption": 52}	{"taxTolerance": 60, "governmentTrust": 38, "policyAcceptance": 59, "regulationPreference": 100, "publicServiceSatisfaction": 71}	0
1398	최주원	50	50-59	Male	광주광역시	35.187115	126.782288	고졸 이하	350-500만원	은퇴	다세대 가구	-74	진보 정당 지지	56	{"economy": -59, "housing": 37, "welfare": 44, "security": -52, "environment": 54}	SNS	{성장,공동체,다양성}	광주광역시에 거주하는 50-59 은퇴. 정치 성향은 진보이며 성장, 공동체, 다양성 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 47, "ecoConsciousness": 42, "priceSensitivity": 56, "digitalConsumption": 74}	{"taxTolerance": 46, "governmentTrust": 48, "policyAcceptance": 42, "regulationPreference": 54, "publicServiceSatisfaction": 64}	0
1399	장서연	58	50-59	Male	광주광역시	35.142433	126.823863	전문대 졸	350-500만원	프리랜서	1인 가구	-37	진보 성향 무당층	65	{"economy": -32, "housing": 27, "welfare": 32, "security": -21, "environment": 36}	포털 뉴스	{혁신,환경,전통}	광주광역시에 거주하는 50-59 프리랜서. 정치 성향은 진보이며 혁신, 환경, 전통 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 48, "ecoConsciousness": 43, "priceSensitivity": 46, "digitalConsumption": 42}	{"taxTolerance": 56, "governmentTrust": 57, "policyAcceptance": 50, "regulationPreference": 68, "publicServiceSatisfaction": 60}	0
1400	이미경	62	60-69	Female	광주광역시	35.158674	126.853266	고졸 이하	500-700만원	주부	자녀 양육 가구	-4	중도 무당층	61	{"economy": 1, "housing": -1, "welfare": 11, "security": 5, "environment": 16}	지상파/종편 뉴스	{안정,공정,안전}	광주광역시에 거주하는 60-69 주부. 정치 성향은 중도이며 안정, 공정, 안전 가치를 중시한다.	{"brandLoyalty": 74, "noveltySeeking": 45, "ecoConsciousness": 38, "priceSensitivity": 32, "digitalConsumption": 58}	{"taxTolerance": 51, "governmentTrust": 54, "policyAcceptance": 52, "regulationPreference": 74, "publicServiceSatisfaction": 69}	0
1401	권지민	65	60-69	Female	광주광역시	35.213865	126.891418	전문대 졸	200만원 미만	자영업	다세대 가구	7	중도 무당층	71	{"economy": -5, "housing": -6, "welfare": 38, "security": 2, "environment": 14}	SNS	{공정,환경,혁신}	광주광역시에 거주하는 60-69 자영업. 정치 성향은 중도이며 공정, 환경, 혁신 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 50, "ecoConsciousness": 49, "priceSensitivity": 70, "digitalConsumption": 58}	{"taxTolerance": 36, "governmentTrust": 54, "policyAcceptance": 55, "regulationPreference": 61, "publicServiceSatisfaction": 48}	0
1402	정준서	62	60-69	Male	광주광역시	35.164205	126.842444	대학원 졸	200만원 미만	생산직	자녀 양육 가구	8	중도 무당층	81	{"economy": 30, "housing": 3, "welfare": 18, "security": -7, "environment": 4}	지상파/종편 뉴스	{환경,혁신,성장}	광주광역시에 거주하는 60-69 생산직. 정치 성향은 중도이며 환경, 혁신, 성장 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 52, "ecoConsciousness": 57, "priceSensitivity": 83, "digitalConsumption": 54}	{"taxTolerance": 45, "governmentTrust": 41, "policyAcceptance": 45, "regulationPreference": 56, "publicServiceSatisfaction": 53}	0
1403	최하은	67	60-69	Male	광주광역시	35.168517	126.774016	대학교 졸	200만원 미만	은퇴	부부 가구	7	중도 무당층	65	{"economy": 8, "housing": 21, "welfare": 13, "security": -4, "environment": 18}	포털 뉴스	{혁신,공정,성장}	광주광역시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 혁신, 공정, 성장 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 51, "ecoConsciousness": 60, "priceSensitivity": 76, "digitalConsumption": 67}	{"taxTolerance": 38, "governmentTrust": 65, "policyAcceptance": 24, "regulationPreference": 60, "publicServiceSatisfaction": 67}	0
1404	송서연	74	70+	Female	광주광역시	35.172724	126.941633	전문대 졸	200만원 미만	은퇴	1인 가구	0	중도 무당층	81	{"economy": 31, "housing": 9, "welfare": 17, "security": 3, "environment": 14}	SNS	{혁신,다양성,공동체}	광주광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 혁신, 다양성, 공동체 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 56, "ecoConsciousness": 67, "priceSensitivity": 82, "digitalConsumption": 71}	{"taxTolerance": 43, "governmentTrust": 46, "policyAcceptance": 58, "regulationPreference": 61, "publicServiceSatisfaction": 48}	0
1405	권하은	82	70+	Female	광주광역시	35.16489	126.781542	전문대 졸	350-500만원	은퇴	부부 가구	27	보수 성향 무당층	85	{"economy": 24, "housing": 0, "welfare": 5, "security": 11, "environment": 32}	지상파/종편 뉴스	{공정,환경,안전}	광주광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공정, 환경, 안전 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 43, "ecoConsciousness": 42, "priceSensitivity": 90, "digitalConsumption": 47}	{"taxTolerance": 46, "governmentTrust": 53, "policyAcceptance": 47, "regulationPreference": 60, "publicServiceSatisfaction": 63}	0
1406	오혜진	74	70+	Male	광주광역시	35.174301	126.807919	전문대 졸	200-350만원	은퇴	1인 가구	-14	중도 무당층	96	{"economy": -18, "housing": 5, "welfare": 42, "security": 27, "environment": 15}	유튜브	{공정,자유,공동체}	광주광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공정, 자유, 공동체 가치를 중시한다.	{"brandLoyalty": 75, "noveltySeeking": 31, "ecoConsciousness": 53, "priceSensitivity": 85, "digitalConsumption": 50}	{"taxTolerance": 65, "governmentTrust": 54, "policyAcceptance": 56, "regulationPreference": 72, "publicServiceSatisfaction": 63}	0
1407	강현우	24	18-29	Female	대전광역시	36.326164	127.448848	전문대 졸	350-500만원	학생	다세대 가구	-12	중도 무당층	56	{"economy": -34, "housing": 17, "welfare": 24, "security": -5, "environment": 24}	SNS	{환경,다양성,혁신}	대전광역시에 거주하는 18-29 학생. 정치 성향은 중도이며 환경, 다양성, 혁신 가치를 중시한다.	{"brandLoyalty": 15, "noveltySeeking": 82, "ecoConsciousness": 64, "priceSensitivity": 61, "digitalConsumption": 100}	{"taxTolerance": 68, "governmentTrust": 63, "policyAcceptance": 61, "regulationPreference": 58, "publicServiceSatisfaction": 76}	0
1408	전혜진	27	18-29	Female	대전광역시	36.328755	127.366083	대학원 졸	200만원 미만	서비스직	자녀 양육 가구	-44	진보 성향 무당층	58	{"economy": -26, "housing": 52, "welfare": 37, "security": -25, "environment": 53}	신문/팟캐스트	{자유,공동체,공정}	대전광역시에 거주하는 18-29 서비스직. 정치 성향은 진보이며 자유, 공동체, 공정 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 59, "ecoConsciousness": 57, "priceSensitivity": 60, "digitalConsumption": 91}	{"taxTolerance": 45, "governmentTrust": 34, "policyAcceptance": 48, "regulationPreference": 64, "publicServiceSatisfaction": 71}	0
1409	홍민서	28	18-29	Male	대전광역시	36.279455	127.339543	대학원 졸	500-700만원	서비스직	부부 가구	-27	진보 성향 무당층	48	{"economy": 0, "housing": 27, "welfare": 10, "security": -11, "environment": 17}	신문/팟캐스트	{안정,자유,안전}	대전광역시에 거주하는 18-29 서비스직. 정치 성향은 중도이며 안정, 자유, 안전 가치를 중시한다.	{"brandLoyalty": 25, "noveltySeeking": 75, "ecoConsciousness": 57, "priceSensitivity": 35, "digitalConsumption": 93}	{"taxTolerance": 32, "governmentTrust": 57, "policyAcceptance": 48, "regulationPreference": 58, "publicServiceSatisfaction": 76}	0
1410	정유준	19	18-29	Male	대전광역시	36.285361	127.318895	대학원 졸	200만원 미만	학생	1인 가구	-19	진보 성향 무당층	37	{"economy": -21, "housing": 11, "welfare": 7, "security": -7, "environment": 51}	유튜브	{공동체,전통,성장}	대전광역시에 거주하는 18-29 학생. 정치 성향은 중도이며 공동체, 전통, 성장 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 57, "ecoConsciousness": 60, "priceSensitivity": 74, "digitalConsumption": 84}	{"taxTolerance": 50, "governmentTrust": 26, "policyAcceptance": 34, "regulationPreference": 27, "publicServiceSatisfaction": 47}	0
1411	윤현우	37	30-39	Female	대전광역시	36.315382	127.355055	전문대 졸	350-500만원	사무직	자녀 양육 가구	-18	진보 성향 무당층	62	{"economy": -19, "housing": 15, "welfare": 22, "security": -22, "environment": 35}	포털 뉴스	{공정,혁신,안전}	대전광역시에 거주하는 30-39 사무직. 정치 성향은 중도이며 공정, 혁신, 안전 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 83, "ecoConsciousness": 52, "priceSensitivity": 40, "digitalConsumption": 76}	{"taxTolerance": 34, "governmentTrust": 48, "policyAcceptance": 40, "regulationPreference": 62, "publicServiceSatisfaction": 67}	0
1412	박순자	31	30-39	Female	대전광역시	36.39234	127.406373	전문대 졸	350-500만원	학생	자녀 양육 가구	-4	중도 무당층	40	{"economy": -2, "housing": 32, "welfare": 44, "security": -1, "environment": 8}	신문/팟캐스트	{다양성,전통,혁신}	대전광역시에 거주하는 30-39 학생. 정치 성향은 중도이며 다양성, 전통, 혁신 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 87, "ecoConsciousness": 66, "priceSensitivity": 68, "digitalConsumption": 93}	{"taxTolerance": 52, "governmentTrust": 42, "policyAcceptance": 62, "regulationPreference": 51, "publicServiceSatisfaction": 66}	0
1413	안다은	34	30-39	Male	대전광역시	36.334939	127.28526	전문대 졸	350-500만원	학생	1인 가구	-38	진보 성향 무당층	58	{"economy": -29, "housing": 43, "welfare": 32, "security": -20, "environment": 29}	지상파/종편 뉴스	{자유,환경,전통}	대전광역시에 거주하는 30-39 학생. 정치 성향은 진보이며 자유, 환경, 전통 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 54, "ecoConsciousness": 59, "priceSensitivity": 48, "digitalConsumption": 83}	{"taxTolerance": 31, "governmentTrust": 52, "policyAcceptance": 30, "regulationPreference": 56, "publicServiceSatisfaction": 70}	0
1414	박준서	36	30-39	Male	대전광역시	36.316245	127.437938	전문대 졸	700만원 이상	은퇴	자녀 양육 가구	-15	진보 성향 무당층	67	{"economy": -42, "housing": -12, "welfare": 26, "security": 19, "environment": 23}	유튜브	{공동체,성장,안정}	대전광역시에 거주하는 30-39 은퇴. 정치 성향은 중도이며 공동체, 성장, 안정 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 66, "ecoConsciousness": 59, "priceSensitivity": 59, "digitalConsumption": 72}	{"taxTolerance": 44, "governmentTrust": 37, "policyAcceptance": 52, "regulationPreference": 60, "publicServiceSatisfaction": 60}	0
1415	한서연	48	40-49	Female	대전광역시	36.385922	127.367219	대학원 졸	200만원 미만	전문직	부부 가구	34	보수 성향 무당층	74	{"economy": 4, "housing": -12, "welfare": -6, "security": 34, "environment": -16}	포털 뉴스	{전통,공정,혁신}	대전광역시에 거주하는 40-49 전문직. 정치 성향은 보수이며 전통, 공정, 혁신 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 73, "ecoConsciousness": 55, "priceSensitivity": 64, "digitalConsumption": 66}	{"taxTolerance": 45, "governmentTrust": 35, "policyAcceptance": 44, "regulationPreference": 65, "publicServiceSatisfaction": 58}	0
1416	권수아	46	40-49	Female	대전광역시	36.356557	127.363889	대학교 졸	700만원 이상	공무원	다세대 가구	-19	진보 성향 무당층	59	{"economy": 14, "housing": 25, "welfare": 41, "security": -10, "environment": 39}	포털 뉴스	{성장,자유,환경}	대전광역시에 거주하는 40-49 공무원. 정치 성향은 중도이며 성장, 자유, 환경 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 60, "ecoConsciousness": 57, "priceSensitivity": 49, "digitalConsumption": 59}	{"taxTolerance": 51, "governmentTrust": 40, "policyAcceptance": 32, "regulationPreference": 73, "publicServiceSatisfaction": 67}	0
1417	한순자	49	40-49	Male	대전광역시	36.408468	127.310765	대학교 졸	200-350만원	공무원	다세대 가구	-8	중도 무당층	74	{"economy": -41, "housing": 17, "welfare": 8, "security": 0, "environment": 17}	유튜브	{안전,안정,공정}	대전광역시에 거주하는 40-49 공무원. 정치 성향은 중도이며 안전, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 57, "ecoConsciousness": 49, "priceSensitivity": 59, "digitalConsumption": 76}	{"taxTolerance": 50, "governmentTrust": 58, "policyAcceptance": 50, "regulationPreference": 51, "publicServiceSatisfaction": 71}	0
1418	송지민	48	40-49	Male	대전광역시	36.330134	127.32869	전문대 졸	350-500만원	자영업	다세대 가구	-14	중도 무당층	61	{"economy": -19, "housing": 1, "welfare": 9, "security": 11, "environment": 22}	지상파/종편 뉴스	{환경,안전,자유}	대전광역시에 거주하는 40-49 자영업. 정치 성향은 중도이며 환경, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 52, "ecoConsciousness": 43, "priceSensitivity": 70, "digitalConsumption": 100}	{"taxTolerance": 53, "governmentTrust": 54, "policyAcceptance": 43, "regulationPreference": 75, "publicServiceSatisfaction": 75}	0
1419	윤혜진	55	50-59	Female	대전광역시	36.408786	127.398344	대학교 졸	350-500만원	자영업	자녀 양육 가구	-10	중도 무당층	80	{"economy": -5, "housing": 24, "welfare": 21, "security": -12, "environment": 42}	지상파/종편 뉴스	{안전,안정,환경}	대전광역시에 거주하는 50-59 자영업. 정치 성향은 중도이며 안전, 안정, 환경 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 67, "ecoConsciousness": 56, "priceSensitivity": 76, "digitalConsumption": 61}	{"taxTolerance": 58, "governmentTrust": 32, "policyAcceptance": 59, "regulationPreference": 66, "publicServiceSatisfaction": 61}	0
1420	송순자	52	50-59	Female	대전광역시	36.317463	127.379078	전문대 졸	350-500만원	사무직	1인 가구	-8	중도 무당층	80	{"economy": 3, "housing": 3, "welfare": -6, "security": 17, "environment": 10}	신문/팟캐스트	{성장,전통,혁신}	대전광역시에 거주하는 50-59 사무직. 정치 성향은 중도이며 성장, 전통, 혁신 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 59, "ecoConsciousness": 64, "priceSensitivity": 66, "digitalConsumption": 63}	{"taxTolerance": 44, "governmentTrust": 40, "policyAcceptance": 43, "regulationPreference": 56, "publicServiceSatisfaction": 64}	0
1421	한정희	56	50-59	Male	대전광역시	36.390913	127.391178	대학교 졸	500-700만원	사무직	1인 가구	14	중도 무당층	64	{"economy": 11, "housing": -14, "welfare": 16, "security": 20, "environment": -5}	포털 뉴스	{공동체,성장,다양성}	대전광역시에 거주하는 50-59 사무직. 정치 성향은 중도이며 공동체, 성장, 다양성 가치를 중시한다.	{"brandLoyalty": 78, "noveltySeeking": 58, "ecoConsciousness": 38, "priceSensitivity": 49, "digitalConsumption": 50}	{"taxTolerance": 74, "governmentTrust": 48, "policyAcceptance": 46, "regulationPreference": 59, "publicServiceSatisfaction": 53}	0
1422	송민서	54	50-59	Male	대전광역시	36.407533	127.469655	대학교 졸	350-500만원	서비스직	자녀 양육 가구	-2	중도 무당층	56	{"economy": -31, "housing": 22, "welfare": 3, "security": 11, "environment": 12}	유튜브	{안전,안정,혁신}	대전광역시에 거주하는 50-59 서비스직. 정치 성향은 중도이며 안전, 안정, 혁신 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 54, "ecoConsciousness": 38, "priceSensitivity": 51, "digitalConsumption": 62}	{"taxTolerance": 54, "governmentTrust": 38, "policyAcceptance": 42, "regulationPreference": 68, "publicServiceSatisfaction": 57}	0
1423	정서윤	63	60-69	Female	대전광역시	36.274452	127.301244	대학원 졸	500-700만원	학생	다세대 가구	-4	중도 무당층	65	{"economy": -27, "housing": 38, "welfare": 2, "security": -29, "environment": 25}	유튜브	{전통,성장,공동체}	대전광역시에 거주하는 60-69 학생. 정치 성향은 중도이며 전통, 성장, 공동체 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 30, "ecoConsciousness": 70, "priceSensitivity": 63, "digitalConsumption": 64}	{"taxTolerance": 51, "governmentTrust": 57, "policyAcceptance": 42, "regulationPreference": 63, "publicServiceSatisfaction": 75}	0
1424	김지민	68	60-69	Female	대전광역시	36.376381	127.352113	고졸 이하	500-700만원	은퇴	1인 가구	25	보수 성향 무당층	95	{"economy": 6, "housing": 22, "welfare": -20, "security": 3, "environment": -14}	신문/팟캐스트	{안전,환경,다양성}	대전광역시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 안전, 환경, 다양성 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 46, "ecoConsciousness": 55, "priceSensitivity": 45, "digitalConsumption": 60}	{"taxTolerance": 44, "governmentTrust": 56, "policyAcceptance": 67, "regulationPreference": 51, "publicServiceSatisfaction": 54}	0
1425	조정희	65	60-69	Male	대전광역시	36.392972	127.354876	대학원 졸	200만원 미만	서비스직	다세대 가구	-13	중도 무당층	94	{"economy": -7, "housing": 33, "welfare": 26, "security": -18, "environment": 28}	지상파/종편 뉴스	{환경,공동체,전통}	대전광역시에 거주하는 60-69 서비스직. 정치 성향은 중도이며 환경, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 60, "ecoConsciousness": 58, "priceSensitivity": 63, "digitalConsumption": 62}	{"taxTolerance": 43, "governmentTrust": 46, "policyAcceptance": 58, "regulationPreference": 84, "publicServiceSatisfaction": 70}	0
1426	류지호	66	60-69	Male	대전광역시	36.3675	127.477746	대학교 졸	700만원 이상	주부	다세대 가구	28	보수 성향 무당층	58	{"economy": 25, "housing": -5, "welfare": 15, "security": 8, "environment": -6}	포털 뉴스	{성장,다양성,환경}	대전광역시에 거주하는 60-69 주부. 정치 성향은 중도이며 성장, 다양성, 환경 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 57, "ecoConsciousness": 42, "priceSensitivity": 60, "digitalConsumption": 53}	{"taxTolerance": 62, "governmentTrust": 62, "policyAcceptance": 59, "regulationPreference": 51, "publicServiceSatisfaction": 59}	0
1427	김미경	71	70+	Female	대전광역시	36.381289	127.359789	대학교 졸	350-500만원	은퇴	부부 가구	-6	중도 무당층	99	{"economy": 18, "housing": 12, "welfare": -1, "security": -7, "environment": 25}	SNS	{안전,혁신,다양성}	대전광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안전, 혁신, 다양성 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 60, "ecoConsciousness": 64, "priceSensitivity": 58, "digitalConsumption": 53}	{"taxTolerance": 51, "governmentTrust": 54, "policyAcceptance": 62, "regulationPreference": 53, "publicServiceSatisfaction": 55}	0
1428	정성호	83	70+	Female	대전광역시	36.392882	127.354556	전문대 졸	700만원 이상	은퇴	다세대 가구	8	중도 무당층	84	{"economy": 7, "housing": -7, "welfare": -11, "security": 0, "environment": 20}	포털 뉴스	{안정,안전,공동체}	대전광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안정, 안전, 공동체 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 52, "ecoConsciousness": 48, "priceSensitivity": 49, "digitalConsumption": 59}	{"taxTolerance": 41, "governmentTrust": 62, "policyAcceptance": 48, "regulationPreference": 70, "publicServiceSatisfaction": 61}	0
1429	오은우	77	70+	Male	대전광역시	36.405837	127.46592	전문대 졸	200-350만원	은퇴	다세대 가구	42	보수 성향 무당층	99	{"economy": 8, "housing": 15, "welfare": -29, "security": 27, "environment": 11}	포털 뉴스	{혁신,자유,다양성}	대전광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 혁신, 자유, 다양성 가치를 중시한다.	{"brandLoyalty": 64, "noveltySeeking": 42, "ecoConsciousness": 42, "priceSensitivity": 93, "digitalConsumption": 51}	{"taxTolerance": 57, "governmentTrust": 42, "policyAcceptance": 58, "regulationPreference": 75, "publicServiceSatisfaction": 89}	0
1430	최서연	79	70+	Male	대전광역시	36.365051	127.354744	대학교 졸	500-700만원	은퇴	1인 가구	29	보수 성향 무당층	84	{"economy": 2, "housing": -25, "welfare": 2, "security": 14, "environment": 28}	신문/팟캐스트	{안전,공동체,자유}	대전광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안전, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 69, "noveltySeeking": 55, "ecoConsciousness": 47, "priceSensitivity": 59, "digitalConsumption": 57}	{"taxTolerance": 42, "governmentTrust": 58, "policyAcceptance": 66, "regulationPreference": 68, "publicServiceSatisfaction": 50}	0
1431	강수아	27	18-29	Female	울산광역시	35.608844	129.388901	대학교 졸	500-700만원	학생	1인 가구	5	중도 무당층	38	{"economy": -2, "housing": 12, "welfare": 26, "security": 6, "environment": 47}	신문/팟캐스트	{안전,공정,공동체}	울산광역시에 거주하는 18-29 학생. 정치 성향은 중도이며 안전, 공정, 공동체 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 82, "ecoConsciousness": 39, "priceSensitivity": 67, "digitalConsumption": 93}	{"taxTolerance": 53, "governmentTrust": 50, "policyAcceptance": 54, "regulationPreference": 49, "publicServiceSatisfaction": 62}	0
1432	정영수	22	18-29	Male	울산광역시	35.572088	129.243112	전문대 졸	350-500만원	학생	부부 가구	-30	진보 성향 무당층	62	{"economy": 1, "housing": 12, "welfare": 12, "security": -12, "environment": 33}	지상파/종편 뉴스	{안전,공동체,공정}	울산광역시에 거주하는 18-29 학생. 정치 성향은 중도이며 안전, 공동체, 공정 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 77, "ecoConsciousness": 46, "priceSensitivity": 61, "digitalConsumption": 87}	{"taxTolerance": 28, "governmentTrust": 30, "policyAcceptance": 47, "regulationPreference": 48, "publicServiceSatisfaction": 47}	0
1433	임도윤	35	30-39	Female	울산광역시	35.549934	129.238974	전문대 졸	200만원 미만	학생	다세대 가구	-2	중도 무당층	71	{"economy": 6, "housing": 17, "welfare": 3, "security": 27, "environment": 38}	신문/팟캐스트	{성장,혁신,환경}	울산광역시에 거주하는 30-39 학생. 정치 성향은 중도이며 성장, 혁신, 환경 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 75, "ecoConsciousness": 41, "priceSensitivity": 68, "digitalConsumption": 55}	{"taxTolerance": 66, "governmentTrust": 42, "policyAcceptance": 39, "regulationPreference": 58, "publicServiceSatisfaction": 70}	0
1434	권도윤	38	30-39	Male	울산광역시	35.500254	129.364045	고졸 이하	200-350만원	서비스직	자녀 양육 가구	17	보수 성향 무당층	55	{"economy": 26, "housing": 9, "welfare": -21, "security": 28, "environment": 28}	SNS	{공정,전통,안전}	울산광역시에 거주하는 30-39 서비스직. 정치 성향은 중도이며 공정, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 41, "ecoConsciousness": 53, "priceSensitivity": 77, "digitalConsumption": 57}	{"taxTolerance": 36, "governmentTrust": 48, "policyAcceptance": 48, "regulationPreference": 43, "publicServiceSatisfaction": 41}	0
1435	최지민	44	40-49	Female	울산광역시	35.581235	129.281807	전문대 졸	350-500만원	사무직	부부 가구	6	중도 무당층	54	{"economy": 7, "housing": 29, "welfare": 10, "security": 23, "environment": 18}	포털 뉴스	{환경,공동체,전통}	울산광역시에 거주하는 40-49 사무직. 정치 성향은 중도이며 환경, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 60, "ecoConsciousness": 55, "priceSensitivity": 43, "digitalConsumption": 83}	{"taxTolerance": 52, "governmentTrust": 50, "policyAcceptance": 42, "regulationPreference": 44, "publicServiceSatisfaction": 74}	0
1436	조수아	43	40-49	Female	울산광역시	35.491918	129.237348	고졸 이하	200-350만원	자영업	부부 가구	42	보수 성향 무당층	70	{"economy": 31, "housing": 17, "welfare": 3, "security": 28, "environment": 16}	지상파/종편 뉴스	{안전,안정,환경}	울산광역시에 거주하는 40-49 자영업. 정치 성향은 보수이며 안전, 안정, 환경 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 81, "ecoConsciousness": 65, "priceSensitivity": 69, "digitalConsumption": 72}	{"taxTolerance": 46, "governmentTrust": 40, "policyAcceptance": 63, "regulationPreference": 47, "publicServiceSatisfaction": 67}	0
1437	류혜진	44	40-49	Male	울산광역시	35.461342	129.220869	고졸 이하	700만원 이상	사무직	다세대 가구	11	중도 무당층	42	{"economy": 2, "housing": 21, "welfare": 3, "security": 10, "environment": 16}	신문/팟캐스트	{공정,혁신,안정}	울산광역시에 거주하는 40-49 사무직. 정치 성향은 중도이며 공정, 혁신, 안정 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 40, "ecoConsciousness": 44, "priceSensitivity": 54, "digitalConsumption": 66}	{"taxTolerance": 24, "governmentTrust": 59, "policyAcceptance": 51, "regulationPreference": 51, "publicServiceSatisfaction": 54}	0
1438	강채원	40	40-49	Male	울산광역시	35.509309	129.2359	대학원 졸	500-700만원	전문직	자녀 양육 가구	10	중도 무당층	45	{"economy": 15, "housing": -14, "welfare": 6, "security": 41, "environment": 18}	신문/팟캐스트	{안정,공동체,공정}	울산광역시에 거주하는 40-49 전문직. 정치 성향은 중도이며 안정, 공동체, 공정 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 77, "ecoConsciousness": 74, "priceSensitivity": 37, "digitalConsumption": 86}	{"taxTolerance": 59, "governmentTrust": 36, "policyAcceptance": 42, "regulationPreference": 71, "publicServiceSatisfaction": 61}	0
1439	신혜진	52	50-59	Female	울산광역시	35.555787	129.275447	대학원 졸	500-700만원	프리랜서	다세대 가구	19	보수 성향 무당층	84	{"economy": 27, "housing": 11, "welfare": 8, "security": 8, "environment": -13}	유튜브	{성장,자유,전통}	울산광역시에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 성장, 자유, 전통 가치를 중시한다.	{"brandLoyalty": 66, "noveltySeeking": 49, "ecoConsciousness": 37, "priceSensitivity": 48, "digitalConsumption": 56}	{"taxTolerance": 68, "governmentTrust": 32, "policyAcceptance": 25, "regulationPreference": 61, "publicServiceSatisfaction": 66}	0
1440	홍지민	51	50-59	Female	울산광역시	35.507199	129.265526	대학교 졸	200-350만원	프리랜서	부부 가구	3	중도 무당층	71	{"economy": -1, "housing": 5, "welfare": -19, "security": 4, "environment": 30}	포털 뉴스	{자유,공동체,공정}	울산광역시에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 자유, 공동체, 공정 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 67, "ecoConsciousness": 55, "priceSensitivity": 87, "digitalConsumption": 66}	{"taxTolerance": 37, "governmentTrust": 47, "policyAcceptance": 31, "regulationPreference": 68, "publicServiceSatisfaction": 65}	0
1441	한서연	52	50-59	Male	울산광역시	35.465765	129.386919	대학교 졸	700만원 이상	서비스직	1인 가구	1	중도 무당층	61	{"economy": -10, "housing": 32, "welfare": 15, "security": 4, "environment": 32}	지상파/종편 뉴스	{자유,환경,공동체}	울산광역시에 거주하는 50-59 서비스직. 정치 성향은 중도이며 자유, 환경, 공동체 가치를 중시한다.	{"brandLoyalty": 21, "noveltySeeking": 53, "ecoConsciousness": 23, "priceSensitivity": 59, "digitalConsumption": 72}	{"taxTolerance": 32, "governmentTrust": 30, "policyAcceptance": 55, "regulationPreference": 63, "publicServiceSatisfaction": 64}	0
1442	임다은	57	50-59	Male	울산광역시	35.538015	129.267199	대학교 졸	200-350만원	생산직	자녀 양육 가구	32	보수 성향 무당층	44	{"economy": 22, "housing": 18, "welfare": -31, "security": -4, "environment": 15}	SNS	{혁신,안정,환경}	울산광역시에 거주하는 50-59 생산직. 정치 성향은 중도이며 혁신, 안정, 환경 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 50, "ecoConsciousness": 57, "priceSensitivity": 69, "digitalConsumption": 59}	{"taxTolerance": 45, "governmentTrust": 43, "policyAcceptance": 58, "regulationPreference": 73, "publicServiceSatisfaction": 67}	0
1443	홍은우	67	60-69	Female	울산광역시	35.547505	129.405394	전문대 졸	200만원 미만	은퇴	1인 가구	13	중도 무당층	70	{"economy": -3, "housing": 8, "welfare": 25, "security": 10, "environment": 35}	포털 뉴스	{혁신,전통,공동체}	울산광역시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 혁신, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 22, "ecoConsciousness": 40, "priceSensitivity": 95, "digitalConsumption": 75}	{"taxTolerance": 30, "governmentTrust": 46, "policyAcceptance": 60, "regulationPreference": 59, "publicServiceSatisfaction": 65}	0
1444	장수아	69	60-69	Male	울산광역시	35.470771	129.216964	대학원 졸	500-700만원	은퇴	자녀 양육 가구	64	보수 정당 지지	85	{"economy": 41, "housing": -27, "welfare": -26, "security": 42, "environment": -20}	유튜브	{공동체,환경,자유}	울산광역시에 거주하는 60-69 은퇴. 정치 성향은 보수이며 공동체, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 60, "noveltySeeking": 58, "ecoConsciousness": 60, "priceSensitivity": 50, "digitalConsumption": 52}	{"taxTolerance": 33, "governmentTrust": 62, "policyAcceptance": 36, "regulationPreference": 60, "publicServiceSatisfaction": 67}	0
1445	조다은	72	70+	Female	울산광역시	35.509545	129.376921	대학교 졸	500-700만원	은퇴	부부 가구	-22	진보 성향 무당층	71	{"economy": -31, "housing": 6, "welfare": 14, "security": -3, "environment": 27}	지상파/종편 뉴스	{성장,전통,다양성}	울산광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 성장, 전통, 다양성 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 38, "ecoConsciousness": 50, "priceSensitivity": 62, "digitalConsumption": 58}	{"taxTolerance": 55, "governmentTrust": 37, "policyAcceptance": 32, "regulationPreference": 65, "publicServiceSatisfaction": 77}	0
1446	송지우	70	70+	Male	울산광역시	35.532913	129.372061	고졸 이하	350-500만원	은퇴	1인 가구	1	중도 무당층	70	{"economy": -25, "housing": 19, "welfare": -7, "security": -2, "environment": 41}	포털 뉴스	{공정,다양성,공동체}	울산광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공정, 다양성, 공동체 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 49, "ecoConsciousness": 29, "priceSensitivity": 77, "digitalConsumption": 65}	{"taxTolerance": 32, "governmentTrust": 71, "policyAcceptance": 50, "regulationPreference": 57, "publicServiceSatisfaction": 50}	0
1447	윤혜진	44	40-49	Female	세종특별자치시	36.506564	127.239432	전문대 졸	350-500만원	전문직	자녀 양육 가구	-6	중도 무당층	57	{"economy": 4, "housing": 19, "welfare": 22, "security": 16, "environment": 28}	신문/팟캐스트	{전통,환경,성장}	세종특별자치시에 거주하는 40-49 전문직. 정치 성향은 중도이며 전통, 환경, 성장 가치를 중시한다.	{"brandLoyalty": 69, "noveltySeeking": 56, "ecoConsciousness": 31, "priceSensitivity": 52, "digitalConsumption": 72}	{"taxTolerance": 53, "governmentTrust": 32, "policyAcceptance": 54, "regulationPreference": 57, "publicServiceSatisfaction": 68}	0
1448	황예준	43	40-49	Male	세종특별자치시	36.529268	127.299343	대학원 졸	700만원 이상	서비스직	부부 가구	16	보수 성향 무당층	75	{"economy": 3, "housing": 7, "welfare": -1, "security": -15, "environment": 10}	신문/팟캐스트	{환경,자유,혁신}	세종특별자치시에 거주하는 40-49 서비스직. 정치 성향은 중도이며 환경, 자유, 혁신 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 61, "ecoConsciousness": 71, "priceSensitivity": 36, "digitalConsumption": 78}	{"taxTolerance": 59, "governmentTrust": 54, "policyAcceptance": 35, "regulationPreference": 44, "publicServiceSatisfaction": 63}	0
1449	송건우	57	50-59	Female	세종특별자치시	36.478353	127.273698	대학교 졸	350-500만원	공무원	1인 가구	-7	중도 무당층	81	{"economy": -25, "housing": 24, "welfare": 17, "security": -25, "environment": 7}	SNS	{환경,자유,전통}	세종특별자치시에 거주하는 50-59 공무원. 정치 성향은 중도이며 환경, 자유, 전통 가치를 중시한다.	{"brandLoyalty": 26, "noveltySeeking": 54, "ecoConsciousness": 49, "priceSensitivity": 68, "digitalConsumption": 65}	{"taxTolerance": 64, "governmentTrust": 48, "policyAcceptance": 45, "regulationPreference": 93, "publicServiceSatisfaction": 63}	0
1450	오지호	51	50-59	Male	세종특별자치시	36.48948	127.214351	대학원 졸	700만원 이상	서비스직	1인 가구	31	보수 성향 무당층	62	{"economy": 0, "housing": -3, "welfare": -7, "security": 27, "environment": 20}	포털 뉴스	{안정,환경,공동체}	세종특별자치시에 거주하는 50-59 서비스직. 정치 성향은 중도이며 안정, 환경, 공동체 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 62, "ecoConsciousness": 78, "priceSensitivity": 64, "digitalConsumption": 84}	{"taxTolerance": 40, "governmentTrust": 41, "policyAcceptance": 41, "regulationPreference": 74, "publicServiceSatisfaction": 87}	0
1451	홍지우	20	18-29	Female	경기도	37.493617	127.615998	대학교 졸	500-700만원	전문직	부부 가구	-66	진보 정당 지지	39	{"economy": -50, "housing": 27, "welfare": 42, "security": -25, "environment": 34}	SNS	{환경,혁신,성장}	경기도에 거주하는 18-29 전문직. 정치 성향은 진보이며 환경, 혁신, 성장 가치를 중시한다.	{"brandLoyalty": 21, "noveltySeeking": 69, "ecoConsciousness": 57, "priceSensitivity": 50, "digitalConsumption": 87}	{"taxTolerance": 62, "governmentTrust": 49, "policyAcceptance": 46, "regulationPreference": 44, "publicServiceSatisfaction": 58}	0
1452	권경숙	29	18-29	Female	경기도	37.418952	127.477783	대학원 졸	350-500만원	서비스직	1인 가구	-2	중도 무당층	59	{"economy": -20, "housing": 22, "welfare": 17, "security": 15, "environment": 42}	유튜브	{안정,전통,공정}	경기도에 거주하는 18-29 서비스직. 정치 성향은 중도이며 안정, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 73, "ecoConsciousness": 69, "priceSensitivity": 73, "digitalConsumption": 78}	{"taxTolerance": 44, "governmentTrust": 24, "policyAcceptance": 38, "regulationPreference": 63, "publicServiceSatisfaction": 51}	0
1453	권광수	24	18-29	Female	경기도	37.362153	127.541039	대학원 졸	200만원 미만	학생	1인 가구	-51	진보 정당 지지	45	{"economy": -44, "housing": 43, "welfare": -1, "security": -15, "environment": 15}	포털 뉴스	{다양성,안전,성장}	경기도에 거주하는 18-29 학생. 정치 성향은 진보이며 다양성, 안전, 성장 가치를 중시한다.	{"brandLoyalty": 22, "noveltySeeking": 78, "ecoConsciousness": 66, "priceSensitivity": 72, "digitalConsumption": 85}	{"taxTolerance": 55, "governmentTrust": 29, "policyAcceptance": 63, "regulationPreference": 71, "publicServiceSatisfaction": 72}	0
1454	이동현	22	18-29	Female	경기도	37.412384	127.611395	대학원 졸	700만원 이상	학생	자녀 양육 가구	-49	진보 정당 지지	28	{"economy": -30, "housing": 37, "welfare": 37, "security": -18, "environment": 29}	지상파/종편 뉴스	{성장,안전,공동체}	경기도에 거주하는 18-29 학생. 정치 성향은 진보이며 성장, 안전, 공동체 가치를 중시한다.	{"brandLoyalty": 19, "noveltySeeking": 89, "ecoConsciousness": 65, "priceSensitivity": 29, "digitalConsumption": 86}	{"taxTolerance": 47, "governmentTrust": 38, "policyAcceptance": 46, "regulationPreference": 66, "publicServiceSatisfaction": 76}	0
1455	윤영수	23	18-29	Female	경기도	37.475096	127.555421	고졸 이하	700만원 이상	학생	다세대 가구	-20	진보 성향 무당층	45	{"economy": -15, "housing": 34, "welfare": 24, "security": -48, "environment": 15}	포털 뉴스	{환경,안전,성장}	경기도에 거주하는 18-29 학생. 정치 성향은 중도이며 환경, 안전, 성장 가치를 중시한다.	{"brandLoyalty": 20, "noveltySeeking": 75, "ecoConsciousness": 64, "priceSensitivity": 30, "digitalConsumption": 73}	{"taxTolerance": 37, "governmentTrust": 32, "policyAcceptance": 42, "regulationPreference": 35, "publicServiceSatisfaction": 49}	0
1456	박지민	29	18-29	Female	경기도	37.430771	127.597653	대학교 졸	200-350만원	사무직	1인 가구	-14	중도 무당층	56	{"economy": -19, "housing": 20, "welfare": 20, "security": 8, "environment": 36}	SNS	{공동체,환경,자유}	경기도에 거주하는 18-29 사무직. 정치 성향은 중도이며 공동체, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 66, "ecoConsciousness": 57, "priceSensitivity": 87, "digitalConsumption": 81}	{"taxTolerance": 63, "governmentTrust": 23, "policyAcceptance": 46, "regulationPreference": 63, "publicServiceSatisfaction": 69}	0
1457	박건우	23	18-29	Female	경기도	37.418316	127.517428	대학원 졸	500-700만원	학생	자녀 양육 가구	23	보수 성향 무당층	49	{"economy": 31, "housing": 32, "welfare": 7, "security": 22, "environment": -7}	지상파/종편 뉴스	{혁신,안정,안전}	경기도에 거주하는 18-29 학생. 정치 성향은 중도이며 혁신, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 76, "ecoConsciousness": 75, "priceSensitivity": 34, "digitalConsumption": 84}	{"taxTolerance": 57, "governmentTrust": 62, "policyAcceptance": 43, "regulationPreference": 61, "publicServiceSatisfaction": 54}	0
1458	박민준	24	18-29	Female	경기도	37.416414	127.54026	대학원 졸	200만원 미만	은퇴	1인 가구	-33	진보 성향 무당층	52	{"economy": -22, "housing": 50, "welfare": 32, "security": -11, "environment": 17}	유튜브	{다양성,안정,혁신}	경기도에 거주하는 18-29 은퇴. 정치 성향은 중도이며 다양성, 안정, 혁신 가치를 중시한다.	{"brandLoyalty": 26, "noveltySeeking": 62, "ecoConsciousness": 71, "priceSensitivity": 71, "digitalConsumption": 92}	{"taxTolerance": 53, "governmentTrust": 51, "policyAcceptance": 48, "regulationPreference": 66, "publicServiceSatisfaction": 78}	0
1459	김민서	26	18-29	Female	경기도	37.408418	127.528719	대학원 졸	200-350만원	은퇴	자녀 양육 가구	8	중도 무당층	52	{"economy": 17, "housing": 27, "welfare": 15, "security": 24, "environment": 30}	포털 뉴스	{공정,공동체,안전}	경기도에 거주하는 18-29 은퇴. 정치 성향은 중도이며 공정, 공동체, 안전 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 58, "ecoConsciousness": 63, "priceSensitivity": 69, "digitalConsumption": 81}	{"taxTolerance": 57, "governmentTrust": 53, "policyAcceptance": 51, "regulationPreference": 42, "publicServiceSatisfaction": 74}	0
1460	윤준서	27	18-29	Female	경기도	37.492263	127.495735	대학원 졸	350-500만원	자영업	다세대 가구	-26	진보 성향 무당층	66	{"economy": 8, "housing": 31, "welfare": 47, "security": -14, "environment": 14}	유튜브	{자유,환경,전통}	경기도에 거주하는 18-29 자영업. 정치 성향은 중도이며 자유, 환경, 전통 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 66, "ecoConsciousness": 62, "priceSensitivity": 76, "digitalConsumption": 80}	{"taxTolerance": 45, "governmentTrust": 55, "policyAcceptance": 45, "regulationPreference": 57, "publicServiceSatisfaction": 71}	0
1461	신유준	26	18-29	Female	경기도	37.469134	127.449151	전문대 졸	200-350만원	주부	부부 가구	-45	진보 정당 지지	47	{"economy": -51, "housing": 23, "welfare": 25, "security": -4, "environment": 42}	유튜브	{환경,안전,안정}	경기도에 거주하는 18-29 주부. 정치 성향은 진보이며 환경, 안전, 안정 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 46, "ecoConsciousness": 48, "priceSensitivity": 67, "digitalConsumption": 93}	{"taxTolerance": 38, "governmentTrust": 55, "policyAcceptance": 44, "regulationPreference": 60, "publicServiceSatisfaction": 79}	0
1462	장순자	27	18-29	Female	경기도	37.356807	127.557903	대학교 졸	700만원 이상	서비스직	1인 가구	-46	진보 정당 지지	47	{"economy": -48, "housing": 7, "welfare": 28, "security": -3, "environment": 67}	지상파/종편 뉴스	{안정,혁신,안전}	경기도에 거주하는 18-29 서비스직. 정치 성향은 진보이며 안정, 혁신, 안전 가치를 중시한다.	{"brandLoyalty": 19, "noveltySeeking": 74, "ecoConsciousness": 51, "priceSensitivity": 47, "digitalConsumption": 83}	{"taxTolerance": 72, "governmentTrust": 27, "policyAcceptance": 35, "regulationPreference": 56, "publicServiceSatisfaction": 81}	0
1463	안지민	20	18-29	Female	경기도	37.459637	127.484938	대학원 졸	350-500만원	학생	1인 가구	-43	진보 성향 무당층	31	{"economy": -35, "housing": 55, "welfare": 43, "security": -24, "environment": 39}	포털 뉴스	{환경,공동체,자유}	경기도에 거주하는 18-29 학생. 정치 성향은 진보이며 환경, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 90, "ecoConsciousness": 72, "priceSensitivity": 56, "digitalConsumption": 76}	{"taxTolerance": 66, "governmentTrust": 29, "policyAcceptance": 47, "regulationPreference": 39, "publicServiceSatisfaction": 43}	0
1464	전정희	27	18-29	Female	경기도	37.362136	127.430466	대학원 졸	200만원 미만	학생	부부 가구	-35	진보 성향 무당층	52	{"economy": -29, "housing": 22, "welfare": 36, "security": -14, "environment": -4}	유튜브	{다양성,안정,안전}	경기도에 거주하는 18-29 학생. 정치 성향은 진보이며 다양성, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 73, "ecoConsciousness": 53, "priceSensitivity": 59, "digitalConsumption": 94}	{"taxTolerance": 61, "governmentTrust": 22, "policyAcceptance": 36, "regulationPreference": 62, "publicServiceSatisfaction": 63}	0
1465	류은우	26	18-29	Female	경기도	37.433738	127.512952	대학원 졸	200-350만원	공무원	다세대 가구	-22	진보 성향 무당층	33	{"economy": -6, "housing": 17, "welfare": 3, "security": -19, "environment": 2}	신문/팟캐스트	{자유,안정,공동체}	경기도에 거주하는 18-29 공무원. 정치 성향은 중도이며 자유, 안정, 공동체 가치를 중시한다.	{"brandLoyalty": 17, "noveltySeeking": 71, "ecoConsciousness": 68, "priceSensitivity": 72, "digitalConsumption": 94}	{"taxTolerance": 52, "governmentTrust": 31, "policyAcceptance": 41, "regulationPreference": 59, "publicServiceSatisfaction": 60}	0
1466	임유준	18	18-29	Female	경기도	37.429959	127.441888	대학원 졸	500-700만원	학생	자녀 양육 가구	-43	진보 성향 무당층	45	{"economy": -25, "housing": 47, "welfare": 36, "security": -19, "environment": 19}	포털 뉴스	{공정,전통,혁신}	경기도에 거주하는 18-29 학생. 정치 성향은 진보이며 공정, 전통, 혁신 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 72, "ecoConsciousness": 66, "priceSensitivity": 51, "digitalConsumption": 76}	{"taxTolerance": 42, "governmentTrust": 47, "policyAcceptance": 53, "regulationPreference": 42, "publicServiceSatisfaction": 44}	0
1467	신도윤	26	18-29	Female	경기도	37.412474	127.451253	대학원 졸	200-350만원	공무원	다세대 가구	-21	진보 성향 무당층	34	{"economy": -33, "housing": 53, "welfare": 33, "security": -16, "environment": 40}	유튜브	{전통,환경,혁신}	경기도에 거주하는 18-29 공무원. 정치 성향은 중도이며 전통, 환경, 혁신 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 84, "ecoConsciousness": 59, "priceSensitivity": 55, "digitalConsumption": 73}	{"taxTolerance": 52, "governmentTrust": 45, "policyAcceptance": 51, "regulationPreference": 58, "publicServiceSatisfaction": 52}	0
1468	박도윤	21	18-29	Male	경기도	37.447637	127.5518	대학교 졸	200-350만원	생산직	자녀 양육 가구	8	중도 무당층	50	{"economy": 1, "housing": 16, "welfare": 28, "security": 14, "environment": 10}	포털 뉴스	{성장,공동체,공정}	경기도에 거주하는 18-29 생산직. 정치 성향은 중도이며 성장, 공동체, 공정 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 56, "ecoConsciousness": 69, "priceSensitivity": 63, "digitalConsumption": 97}	{"taxTolerance": 46, "governmentTrust": 24, "policyAcceptance": 69, "regulationPreference": 47, "publicServiceSatisfaction": 58}	0
1469	송경숙	28	18-29	Male	경기도	37.45935	127.605748	전문대 졸	500-700만원	전문직	1인 가구	-1	중도 무당층	34	{"economy": 13, "housing": 2, "welfare": -6, "security": -5, "environment": -2}	신문/팟캐스트	{안전,다양성,공동체}	경기도에 거주하는 18-29 전문직. 정치 성향은 중도이며 안전, 다양성, 공동체 가치를 중시한다.	{"brandLoyalty": 17, "noveltySeeking": 47, "ecoConsciousness": 63, "priceSensitivity": 45, "digitalConsumption": 92}	{"taxTolerance": 60, "governmentTrust": 48, "policyAcceptance": 37, "regulationPreference": 39, "publicServiceSatisfaction": 86}	0
1470	이철수	19	18-29	Male	경기도	37.42655	127.586103	대학원 졸	200만원 미만	전문직	다세대 가구	-33	진보 성향 무당층	66	{"economy": 6, "housing": 19, "welfare": 18, "security": -6, "environment": 13}	지상파/종편 뉴스	{전통,공정,성장}	경기도에 거주하는 18-29 전문직. 정치 성향은 중도이며 전통, 공정, 성장 가치를 중시한다.	{"brandLoyalty": 15, "noveltySeeking": 78, "ecoConsciousness": 61, "priceSensitivity": 75, "digitalConsumption": 91}	{"taxTolerance": 51, "governmentTrust": 33, "policyAcceptance": 36, "regulationPreference": 81, "publicServiceSatisfaction": 58}	0
1471	홍준서	24	18-29	Male	경기도	37.4277	127.470537	대학교 졸	700만원 이상	학생	다세대 가구	-18	진보 성향 무당층	63	{"economy": -38, "housing": 10, "welfare": 32, "security": 11, "environment": 47}	지상파/종편 뉴스	{공동체,성장,다양성}	경기도에 거주하는 18-29 학생. 정치 성향은 중도이며 공동체, 성장, 다양성 가치를 중시한다.	{"brandLoyalty": 25, "noveltySeeking": 77, "ecoConsciousness": 61, "priceSensitivity": 55, "digitalConsumption": 75}	{"taxTolerance": 52, "governmentTrust": 51, "policyAcceptance": 52, "regulationPreference": 53, "publicServiceSatisfaction": 73}	0
1472	강지아	21	18-29	Male	경기도	37.386792	127.45553	대학교 졸	200만원 미만	전문직	부부 가구	-69	진보 정당 지지	53	{"economy": -51, "housing": 6, "welfare": 57, "security": -13, "environment": 60}	유튜브	{안정,안전,성장}	경기도에 거주하는 18-29 전문직. 정치 성향은 진보이며 안정, 안전, 성장 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 80, "ecoConsciousness": 53, "priceSensitivity": 71, "digitalConsumption": 76}	{"taxTolerance": 37, "governmentTrust": 20, "policyAcceptance": 32, "regulationPreference": 46, "publicServiceSatisfaction": 68}	0
1473	임다은	19	18-29	Male	경기도	37.418578	127.534771	대학교 졸	500-700만원	학생	부부 가구	-26	진보 성향 무당층	48	{"economy": -5, "housing": 18, "welfare": 38, "security": -5, "environment": 23}	SNS	{안정,다양성,성장}	경기도에 거주하는 18-29 학생. 정치 성향은 중도이며 안정, 다양성, 성장 가치를 중시한다.	{"brandLoyalty": 21, "noveltySeeking": 75, "ecoConsciousness": 55, "priceSensitivity": 58, "digitalConsumption": 67}	{"taxTolerance": 55, "governmentTrust": 37, "policyAcceptance": 53, "regulationPreference": 47, "publicServiceSatisfaction": 70}	0
1474	서광수	27	18-29	Male	경기도	37.470321	127.516509	대학원 졸	200만원 미만	은퇴	자녀 양육 가구	11	중도 무당층	42	{"economy": 6, "housing": 8, "welfare": -38, "security": -17, "environment": 35}	유튜브	{다양성,전통,성장}	경기도에 거주하는 18-29 은퇴. 정치 성향은 중도이며 다양성, 전통, 성장 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 73, "ecoConsciousness": 55, "priceSensitivity": 61, "digitalConsumption": 83}	{"taxTolerance": 60, "governmentTrust": 51, "policyAcceptance": 36, "regulationPreference": 70, "publicServiceSatisfaction": 65}	0
1475	박지민	24	18-29	Male	경기도	37.341277	127.454071	대학원 졸	200-350만원	학생	1인 가구	-9	중도 무당층	49	{"economy": -12, "housing": 42, "welfare": 30, "security": 4, "environment": 39}	신문/팟캐스트	{환경,다양성,성장}	경기도에 거주하는 18-29 학생. 정치 성향은 중도이며 환경, 다양성, 성장 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 71, "ecoConsciousness": 44, "priceSensitivity": 59, "digitalConsumption": 75}	{"taxTolerance": 58, "governmentTrust": 26, "policyAcceptance": 36, "regulationPreference": 54, "publicServiceSatisfaction": 56}	0
1476	김유준	26	18-29	Male	경기도	37.359197	127.596113	대학원 졸	200-350만원	전문직	자녀 양육 가구	-25	진보 성향 무당층	39	{"economy": 1, "housing": 36, "welfare": 27, "security": -6, "environment": 12}	지상파/종편 뉴스	{혁신,안정,안전}	경기도에 거주하는 18-29 전문직. 정치 성향은 중도이며 혁신, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 71, "ecoConsciousness": 70, "priceSensitivity": 74, "digitalConsumption": 90}	{"taxTolerance": 59, "governmentTrust": 45, "policyAcceptance": 41, "regulationPreference": 75, "publicServiceSatisfaction": 50}	0
1477	강순자	26	18-29	Male	경기도	37.352965	127.434424	대학원 졸	200-350만원	전문직	부부 가구	-5	중도 무당층	56	{"economy": 3, "housing": 17, "welfare": 38, "security": 7, "environment": 6}	SNS	{혁신,공동체,안정}	경기도에 거주하는 18-29 전문직. 정치 성향은 중도이며 혁신, 공동체, 안정 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 86, "ecoConsciousness": 44, "priceSensitivity": 41, "digitalConsumption": 85}	{"taxTolerance": 48, "governmentTrust": 40, "policyAcceptance": 59, "regulationPreference": 61, "publicServiceSatisfaction": 77}	0
1478	윤민준	20	18-29	Male	경기도	37.337086	127.423409	전문대 졸	200-350만원	학생	부부 가구	-35	진보 성향 무당층	67	{"economy": -25, "housing": 23, "welfare": 35, "security": -19, "environment": 33}	신문/팟캐스트	{공동체,혁신,공정}	경기도에 거주하는 18-29 학생. 정치 성향은 진보이며 공동체, 혁신, 공정 가치를 중시한다.	{"brandLoyalty": 26, "noveltySeeking": 50, "ecoConsciousness": 44, "priceSensitivity": 60, "digitalConsumption": 79}	{"taxTolerance": 68, "governmentTrust": 49, "policyAcceptance": 47, "regulationPreference": 48, "publicServiceSatisfaction": 55}	0
1479	신서연	26	18-29	Male	경기도	37.358179	127.442951	대학원 졸	350-500만원	주부	1인 가구	-43	진보 성향 무당층	48	{"economy": -1, "housing": 14, "welfare": 39, "security": -36, "environment": 28}	신문/팟캐스트	{안정,환경,공정}	경기도에 거주하는 18-29 주부. 정치 성향은 진보이며 안정, 환경, 공정 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 90, "ecoConsciousness": 55, "priceSensitivity": 52, "digitalConsumption": 98}	{"taxTolerance": 55, "governmentTrust": 55, "policyAcceptance": 38, "regulationPreference": 62, "publicServiceSatisfaction": 67}	0
1480	조민준	18	18-29	Male	경기도	37.407398	127.558965	대학원 졸	500-700만원	학생	자녀 양육 가구	-19	진보 성향 무당층	45	{"economy": 4, "housing": 26, "welfare": 19, "security": -9, "environment": 25}	유튜브	{안전,안정,자유}	경기도에 거주하는 18-29 학생. 정치 성향은 중도이며 안전, 안정, 자유 가치를 중시한다.	{"brandLoyalty": 13, "noveltySeeking": 76, "ecoConsciousness": 69, "priceSensitivity": 55, "digitalConsumption": 83}	{"taxTolerance": 57, "governmentTrust": 44, "policyAcceptance": 46, "regulationPreference": 67, "publicServiceSatisfaction": 64}	0
1481	정유준	25	18-29	Male	경기도	37.342887	127.480222	대학교 졸	350-500만원	학생	1인 가구	-79	진보 정당 지지	48	{"economy": -49, "housing": 65, "welfare": 57, "security": -27, "environment": 62}	SNS	{공정,안정,안전}	경기도에 거주하는 18-29 학생. 정치 성향은 진보이며 공정, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 82, "ecoConsciousness": 52, "priceSensitivity": 54, "digitalConsumption": 81}	{"taxTolerance": 55, "governmentTrust": 39, "policyAcceptance": 49, "regulationPreference": 51, "publicServiceSatisfaction": 60}	0
1482	안미경	27	18-29	Male	경기도	37.433872	127.520119	전문대 졸	350-500만원	사무직	1인 가구	-55	진보 정당 지지	46	{"economy": -51, "housing": 3, "welfare": 36, "security": -31, "environment": 32}	지상파/종편 뉴스	{성장,공정,전통}	경기도에 거주하는 18-29 사무직. 정치 성향은 진보이며 성장, 공정, 전통 가치를 중시한다.	{"brandLoyalty": 20, "noveltySeeking": 77, "ecoConsciousness": 43, "priceSensitivity": 44, "digitalConsumption": 99}	{"taxTolerance": 29, "governmentTrust": 58, "policyAcceptance": 31, "regulationPreference": 54, "publicServiceSatisfaction": 44}	0
1483	정민서	28	18-29	Male	경기도	37.40191	127.423551	대학원 졸	200만원 미만	생산직	부부 가구	-34	진보 성향 무당층	75	{"economy": -31, "housing": 23, "welfare": -8, "security": -31, "environment": 24}	SNS	{안전,다양성,혁신}	경기도에 거주하는 18-29 생산직. 정치 성향은 진보이며 안전, 다양성, 혁신 가치를 중시한다.	{"brandLoyalty": 23, "noveltySeeking": 77, "ecoConsciousness": 60, "priceSensitivity": 71, "digitalConsumption": 67}	{"taxTolerance": 54, "governmentTrust": 47, "policyAcceptance": 36, "regulationPreference": 64, "publicServiceSatisfaction": 72}	0
1484	정정희	20	18-29	Male	경기도	37.492849	127.510757	대학원 졸	700만원 이상	공무원	자녀 양육 가구	-39	진보 성향 무당층	36	{"economy": -38, "housing": 52, "welfare": 26, "security": -29, "environment": 8}	SNS	{안정,환경,자유}	경기도에 거주하는 18-29 공무원. 정치 성향은 진보이며 안정, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 15, "noveltySeeking": 81, "ecoConsciousness": 49, "priceSensitivity": 27, "digitalConsumption": 82}	{"taxTolerance": 49, "governmentTrust": 54, "policyAcceptance": 40, "regulationPreference": 47, "publicServiceSatisfaction": 68}	0
1485	장미경	30	30-39	Female	경기도	37.348301	127.485968	대학교 졸	200-350만원	생산직	1인 가구	10	중도 무당층	49	{"economy": -8, "housing": 2, "welfare": -15, "security": 40, "environment": -1}	SNS	{성장,안정,다양성}	경기도에 거주하는 30-39 생산직. 정치 성향은 중도이며 성장, 안정, 다양성 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 83, "ecoConsciousness": 58, "priceSensitivity": 71, "digitalConsumption": 89}	{"taxTolerance": 44, "governmentTrust": 30, "policyAcceptance": 58, "regulationPreference": 40, "publicServiceSatisfaction": 83}	0
1486	강예준	35	30-39	Female	경기도	37.470955	127.518316	대학교 졸	700만원 이상	프리랜서	자녀 양육 가구	-13	중도 무당층	52	{"economy": -15, "housing": -8, "welfare": 13, "security": -12, "environment": 27}	포털 뉴스	{혁신,공동체,환경}	경기도에 거주하는 30-39 프리랜서. 정치 성향은 중도이며 혁신, 공동체, 환경 가치를 중시한다.	{"brandLoyalty": 22, "noveltySeeking": 46, "ecoConsciousness": 56, "priceSensitivity": 46, "digitalConsumption": 84}	{"taxTolerance": 38, "governmentTrust": 63, "policyAcceptance": 42, "regulationPreference": 72, "publicServiceSatisfaction": 55}	0
1487	이은우	39	30-39	Female	경기도	37.373271	127.432569	전문대 졸	350-500만원	주부	부부 가구	-3	중도 무당층	60	{"economy": -5, "housing": 12, "welfare": 25, "security": -1, "environment": 15}	SNS	{성장,혁신,공정}	경기도에 거주하는 30-39 주부. 정치 성향은 중도이며 성장, 혁신, 공정 가치를 중시한다.	{"brandLoyalty": 60, "noveltySeeking": 62, "ecoConsciousness": 52, "priceSensitivity": 66, "digitalConsumption": 53}	{"taxTolerance": 48, "governmentTrust": 33, "policyAcceptance": 59, "regulationPreference": 64, "publicServiceSatisfaction": 69}	0
1488	장주원	30	30-39	Female	경기도	37.358497	127.442878	대학교 졸	500-700만원	공무원	부부 가구	-28	진보 성향 무당층	40	{"economy": -39, "housing": 13, "welfare": 41, "security": -10, "environment": 64}	포털 뉴스	{안정,전통,자유}	경기도에 거주하는 30-39 공무원. 정치 성향은 중도이며 안정, 전통, 자유 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 57, "ecoConsciousness": 39, "priceSensitivity": 43, "digitalConsumption": 75}	{"taxTolerance": 62, "governmentTrust": 37, "policyAcceptance": 42, "regulationPreference": 57, "publicServiceSatisfaction": 59}	0
1489	황민준	35	30-39	Female	경기도	37.459434	127.572971	고졸 이하	200-350만원	전문직	다세대 가구	-36	진보 성향 무당층	57	{"economy": -26, "housing": 28, "welfare": 24, "security": -13, "environment": 33}	유튜브	{자유,환경,전통}	경기도에 거주하는 30-39 전문직. 정치 성향은 진보이며 자유, 환경, 전통 가치를 중시한다.	{"brandLoyalty": 22, "noveltySeeking": 57, "ecoConsciousness": 41, "priceSensitivity": 72, "digitalConsumption": 67}	{"taxTolerance": 47, "governmentTrust": 41, "policyAcceptance": 56, "regulationPreference": 55, "publicServiceSatisfaction": 83}	0
1490	황성호	39	30-39	Female	경기도	37.361992	127.527139	대학교 졸	700만원 이상	주부	다세대 가구	-32	진보 성향 무당층	82	{"economy": -46, "housing": 39, "welfare": 29, "security": -36, "environment": 14}	포털 뉴스	{전통,자유,안정}	경기도에 거주하는 30-39 주부. 정치 성향은 중도이며 전통, 자유, 안정 가치를 중시한다.	{"brandLoyalty": 22, "noveltySeeking": 69, "ecoConsciousness": 54, "priceSensitivity": 46, "digitalConsumption": 74}	{"taxTolerance": 49, "governmentTrust": 58, "policyAcceptance": 39, "regulationPreference": 48, "publicServiceSatisfaction": 49}	0
1491	안서윤	38	30-39	Female	경기도	37.42783	127.514411	대학교 졸	700만원 이상	자영업	자녀 양육 가구	-10	중도 무당층	45	{"economy": 9, "housing": 30, "welfare": 20, "security": 21, "environment": 24}	SNS	{환경,공정,안정}	경기도에 거주하는 30-39 자영업. 정치 성향은 중도이며 환경, 공정, 안정 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 60, "ecoConsciousness": 60, "priceSensitivity": 42, "digitalConsumption": 65}	{"taxTolerance": 58, "governmentTrust": 45, "policyAcceptance": 58, "regulationPreference": 59, "publicServiceSatisfaction": 78}	0
1492	오순자	31	30-39	Female	경기도	37.448547	127.59477	전문대 졸	350-500만원	생산직	부부 가구	29	보수 성향 무당층	32	{"economy": 30, "housing": -14, "welfare": 7, "security": 27, "environment": 31}	SNS	{다양성,환경,안정}	경기도에 거주하는 30-39 생산직. 정치 성향은 중도이며 다양성, 환경, 안정 가치를 중시한다.	{"brandLoyalty": 21, "noveltySeeking": 71, "ecoConsciousness": 48, "priceSensitivity": 60, "digitalConsumption": 69}	{"taxTolerance": 65, "governmentTrust": 33, "policyAcceptance": 40, "regulationPreference": 62, "publicServiceSatisfaction": 65}	0
1493	윤광수	31	30-39	Female	경기도	37.474835	127.598414	전문대 졸	200-350만원	은퇴	자녀 양육 가구	-60	진보 정당 지지	55	{"economy": -37, "housing": 27, "welfare": 52, "security": -24, "environment": 43}	유튜브	{성장,공정,전통}	경기도에 거주하는 30-39 은퇴. 정치 성향은 진보이며 성장, 공정, 전통 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 75, "ecoConsciousness": 29, "priceSensitivity": 66, "digitalConsumption": 73}	{"taxTolerance": 51, "governmentTrust": 58, "policyAcceptance": 52, "regulationPreference": 38, "publicServiceSatisfaction": 55}	0
1494	전지우	30	30-39	Female	경기도	37.368064	127.60998	대학원 졸	350-500만원	은퇴	다세대 가구	-59	진보 정당 지지	62	{"economy": -41, "housing": 49, "welfare": 34, "security": -22, "environment": 44}	포털 뉴스	{환경,공동체,공정}	경기도에 거주하는 30-39 은퇴. 정치 성향은 진보이며 환경, 공동체, 공정 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 88, "ecoConsciousness": 72, "priceSensitivity": 55, "digitalConsumption": 73}	{"taxTolerance": 54, "governmentTrust": 41, "policyAcceptance": 55, "regulationPreference": 41, "publicServiceSatisfaction": 46}	0
1495	황도윤	32	30-39	Female	경기도	37.466637	127.489211	대학교 졸	350-500만원	자영업	다세대 가구	2	중도 무당층	38	{"economy": -15, "housing": 37, "welfare": 35, "security": -23, "environment": 4}	지상파/종편 뉴스	{안정,공동체,안전}	경기도에 거주하는 30-39 자영업. 정치 성향은 중도이며 안정, 공동체, 안전 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 50, "ecoConsciousness": 69, "priceSensitivity": 41, "digitalConsumption": 71}	{"taxTolerance": 52, "governmentTrust": 67, "policyAcceptance": 34, "regulationPreference": 57, "publicServiceSatisfaction": 66}	0
1496	임민준	35	30-39	Female	경기도	37.41578	127.571737	대학교 졸	500-700만원	생산직	1인 가구	-14	중도 무당층	56	{"economy": 0, "housing": 22, "welfare": 55, "security": -5, "environment": 19}	SNS	{안정,혁신,안전}	경기도에 거주하는 30-39 생산직. 정치 성향은 중도이며 안정, 혁신, 안전 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 84, "ecoConsciousness": 46, "priceSensitivity": 33, "digitalConsumption": 79}	{"taxTolerance": 60, "governmentTrust": 40, "policyAcceptance": 31, "regulationPreference": 56, "publicServiceSatisfaction": 71}	0
1497	송서윤	31	30-39	Female	경기도	37.416826	127.544139	대학원 졸	200-350만원	공무원	1인 가구	-36	진보 성향 무당층	63	{"economy": -52, "housing": 31, "welfare": 24, "security": -46, "environment": 20}	지상파/종편 뉴스	{다양성,자유,안전}	경기도에 거주하는 30-39 공무원. 정치 성향은 진보이며 다양성, 자유, 안전 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 72, "ecoConsciousness": 54, "priceSensitivity": 73, "digitalConsumption": 75}	{"taxTolerance": 66, "governmentTrust": 52, "policyAcceptance": 37, "regulationPreference": 82, "publicServiceSatisfaction": 66}	0
1498	신광수	34	30-39	Female	경기도	37.425612	127.499024	대학원 졸	200-350만원	프리랜서	다세대 가구	-24	진보 성향 무당층	62	{"economy": -30, "housing": 44, "welfare": 18, "security": -7, "environment": 30}	SNS	{전통,안전,혁신}	경기도에 거주하는 30-39 프리랜서. 정치 성향은 중도이며 전통, 안전, 혁신 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 63, "ecoConsciousness": 59, "priceSensitivity": 46, "digitalConsumption": 79}	{"taxTolerance": 70, "governmentTrust": 38, "policyAcceptance": 40, "regulationPreference": 51, "publicServiceSatisfaction": 67}	0
1499	전경숙	31	30-39	Female	경기도	37.455036	127.563634	대학원 졸	200-350만원	생산직	1인 가구	-20	진보 성향 무당층	24	{"economy": -35, "housing": 18, "welfare": 34, "security": 2, "environment": 6}	지상파/종편 뉴스	{혁신,공동체,전통}	경기도에 거주하는 30-39 생산직. 정치 성향은 중도이며 혁신, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 23, "noveltySeeking": 95, "ecoConsciousness": 46, "priceSensitivity": 62, "digitalConsumption": 75}	{"taxTolerance": 43, "governmentTrust": 27, "policyAcceptance": 39, "regulationPreference": 47, "publicServiceSatisfaction": 62}	0
1500	송은우	36	30-39	Female	경기도	37.389148	127.433008	전문대 졸	500-700만원	생산직	1인 가구	-8	중도 무당층	71	{"economy": 0, "housing": 22, "welfare": 0, "security": -20, "environment": 34}	SNS	{다양성,공동체,환경}	경기도에 거주하는 30-39 생산직. 정치 성향은 중도이며 다양성, 공동체, 환경 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 69, "ecoConsciousness": 52, "priceSensitivity": 63, "digitalConsumption": 61}	{"taxTolerance": 51, "governmentTrust": 40, "policyAcceptance": 27, "regulationPreference": 56, "publicServiceSatisfaction": 73}	0
1501	장채원	31	30-39	Male	경기도	37.338127	127.600478	전문대 졸	350-500만원	주부	다세대 가구	-43	진보 성향 무당층	60	{"economy": -31, "housing": 30, "welfare": 43, "security": -11, "environment": 26}	유튜브	{공정,공동체,환경}	경기도에 거주하는 30-39 주부. 정치 성향은 진보이며 공정, 공동체, 환경 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 78, "ecoConsciousness": 62, "priceSensitivity": 59, "digitalConsumption": 74}	{"taxTolerance": 51, "governmentTrust": 52, "policyAcceptance": 55, "regulationPreference": 73, "publicServiceSatisfaction": 50}	0
1502	강순자	31	30-39	Male	경기도	37.472131	127.533729	대학교 졸	500-700만원	은퇴	1인 가구	-43	진보 성향 무당층	40	{"economy": -36, "housing": 27, "welfare": 29, "security": 1, "environment": 35}	지상파/종편 뉴스	{안정,공동체,전통}	경기도에 거주하는 30-39 은퇴. 정치 성향은 진보이며 안정, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 65, "ecoConsciousness": 67, "priceSensitivity": 33, "digitalConsumption": 69}	{"taxTolerance": 48, "governmentTrust": 25, "policyAcceptance": 50, "regulationPreference": 55, "publicServiceSatisfaction": 67}	0
1503	이경숙	31	30-39	Male	경기도	37.37993	127.566797	전문대 졸	200-350만원	생산직	1인 가구	-4	중도 무당층	60	{"economy": 13, "housing": 9, "welfare": -11, "security": -30, "environment": 7}	SNS	{전통,안전,환경}	경기도에 거주하는 30-39 생산직. 정치 성향은 중도이며 전통, 안전, 환경 가치를 중시한다.	{"brandLoyalty": 22, "noveltySeeking": 55, "ecoConsciousness": 55, "priceSensitivity": 51, "digitalConsumption": 96}	{"taxTolerance": 44, "governmentTrust": 48, "policyAcceptance": 42, "regulationPreference": 64, "publicServiceSatisfaction": 67}	0
1504	황서윤	32	30-39	Male	경기도	37.489104	127.509946	대학원 졸	200-350만원	서비스직	자녀 양육 가구	-36	진보 성향 무당층	62	{"economy": -1, "housing": 34, "welfare": 17, "security": -26, "environment": 26}	신문/팟캐스트	{혁신,안전,공정}	경기도에 거주하는 30-39 서비스직. 정치 성향은 진보이며 혁신, 안전, 공정 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 68, "ecoConsciousness": 59, "priceSensitivity": 75, "digitalConsumption": 78}	{"taxTolerance": 70, "governmentTrust": 40, "policyAcceptance": 59, "regulationPreference": 77, "publicServiceSatisfaction": 60}	0
1505	정순자	37	30-39	Male	경기도	37.435752	127.483781	대학원 졸	500-700만원	주부	부부 가구	8	중도 무당층	38	{"economy": 6, "housing": 21, "welfare": 27, "security": 22, "environment": -3}	포털 뉴스	{공정,안전,환경}	경기도에 거주하는 30-39 주부. 정치 성향은 중도이며 공정, 안전, 환경 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 60, "ecoConsciousness": 65, "priceSensitivity": 65, "digitalConsumption": 80}	{"taxTolerance": 58, "governmentTrust": 29, "policyAcceptance": 26, "regulationPreference": 69, "publicServiceSatisfaction": 56}	0
1506	윤영수	39	30-39	Male	경기도	37.375683	127.452013	전문대 졸	200-350만원	공무원	자녀 양육 가구	-10	중도 무당층	35	{"economy": -16, "housing": -19, "welfare": 41, "security": -7, "environment": 23}	지상파/종편 뉴스	{환경,성장,안전}	경기도에 거주하는 30-39 공무원. 정치 성향은 중도이며 환경, 성장, 안전 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 55, "ecoConsciousness": 64, "priceSensitivity": 78, "digitalConsumption": 82}	{"taxTolerance": 50, "governmentTrust": 54, "policyAcceptance": 43, "regulationPreference": 59, "publicServiceSatisfaction": 57}	0
1507	강현우	31	30-39	Male	경기도	37.363995	127.601094	전문대 졸	200-350만원	생산직	1인 가구	0	중도 무당층	34	{"economy": -12, "housing": -1, "welfare": 12, "security": 30, "environment": 36}	포털 뉴스	{성장,자유,환경}	경기도에 거주하는 30-39 생산직. 정치 성향은 중도이며 성장, 자유, 환경 가치를 중시한다.	{"brandLoyalty": 16, "noveltySeeking": 65, "ecoConsciousness": 54, "priceSensitivity": 73, "digitalConsumption": 83}	{"taxTolerance": 43, "governmentTrust": 58, "policyAcceptance": 37, "regulationPreference": 56, "publicServiceSatisfaction": 68}	0
1508	박광수	30	30-39	Male	경기도	37.486135	127.602589	대학원 졸	350-500만원	서비스직	부부 가구	-9	중도 무당층	33	{"economy": 0, "housing": 38, "welfare": -1, "security": -1, "environment": 5}	신문/팟캐스트	{환경,공동체,공정}	경기도에 거주하는 30-39 서비스직. 정치 성향은 중도이며 환경, 공동체, 공정 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 76, "ecoConsciousness": 48, "priceSensitivity": 44, "digitalConsumption": 100}	{"taxTolerance": 36, "governmentTrust": 42, "policyAcceptance": 46, "regulationPreference": 66, "publicServiceSatisfaction": 93}	0
1509	서철수	38	30-39	Male	경기도	37.339206	127.545274	대학교 졸	500-700만원	생산직	자녀 양육 가구	-42	진보 성향 무당층	74	{"economy": -9, "housing": 13, "welfare": 51, "security": -9, "environment": 33}	지상파/종편 뉴스	{전통,환경,혁신}	경기도에 거주하는 30-39 생산직. 정치 성향은 진보이며 전통, 환경, 혁신 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 73, "ecoConsciousness": 57, "priceSensitivity": 50, "digitalConsumption": 59}	{"taxTolerance": 41, "governmentTrust": 29, "policyAcceptance": 57, "regulationPreference": 60, "publicServiceSatisfaction": 90}	0
1510	황민준	37	30-39	Male	경기도	37.436435	127.494712	대학교 졸	700만원 이상	학생	1인 가구	-37	진보 성향 무당층	43	{"economy": -21, "housing": 48, "welfare": 10, "security": 7, "environment": 41}	신문/팟캐스트	{다양성,환경,안정}	경기도에 거주하는 30-39 학생. 정치 성향은 진보이며 다양성, 환경, 안정 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 66, "ecoConsciousness": 56, "priceSensitivity": 27, "digitalConsumption": 61}	{"taxTolerance": 48, "governmentTrust": 46, "policyAcceptance": 30, "regulationPreference": 63, "publicServiceSatisfaction": 67}	0
1511	황민서	33	30-39	Male	경기도	37.467029	127.572185	대학교 졸	200만원 미만	생산직	1인 가구	14	중도 무당층	54	{"economy": -3, "housing": 17, "welfare": 10, "security": 15, "environment": 45}	유튜브	{혁신,다양성,안전}	경기도에 거주하는 30-39 생산직. 정치 성향은 중도이며 혁신, 다양성, 안전 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 52, "ecoConsciousness": 53, "priceSensitivity": 52, "digitalConsumption": 77}	{"taxTolerance": 42, "governmentTrust": 63, "policyAcceptance": 42, "regulationPreference": 56, "publicServiceSatisfaction": 54}	0
1512	최민서	38	30-39	Male	경기도	37.366471	127.443212	대학원 졸	700만원 이상	은퇴	자녀 양육 가구	5	중도 무당층	52	{"economy": -20, "housing": 41, "welfare": 6, "security": -5, "environment": -4}	유튜브	{성장,다양성,혁신}	경기도에 거주하는 30-39 은퇴. 정치 성향은 중도이며 성장, 다양성, 혁신 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 72, "ecoConsciousness": 62, "priceSensitivity": 29, "digitalConsumption": 68}	{"taxTolerance": 43, "governmentTrust": 30, "policyAcceptance": 56, "regulationPreference": 65, "publicServiceSatisfaction": 64}	0
1513	박지우	35	30-39	Male	경기도	37.344595	127.599663	대학교 졸	200만원 미만	학생	1인 가구	-26	진보 성향 무당층	66	{"economy": -9, "housing": 37, "welfare": 56, "security": -10, "environment": 26}	포털 뉴스	{다양성,자유,안정}	경기도에 거주하는 30-39 학생. 정치 성향은 중도이며 다양성, 자유, 안정 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 63, "ecoConsciousness": 58, "priceSensitivity": 76, "digitalConsumption": 84}	{"taxTolerance": 43, "governmentTrust": 48, "policyAcceptance": 50, "regulationPreference": 58, "publicServiceSatisfaction": 82}	0
1514	장혜진	38	30-39	Male	경기도	37.418839	127.451328	고졸 이하	700만원 이상	전문직	1인 가구	-3	중도 무당층	46	{"economy": 3, "housing": -6, "welfare": 21, "security": 28, "environment": 14}	SNS	{성장,다양성,환경}	경기도에 거주하는 30-39 전문직. 정치 성향은 중도이며 성장, 다양성, 환경 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 54, "ecoConsciousness": 46, "priceSensitivity": 61, "digitalConsumption": 82}	{"taxTolerance": 43, "governmentTrust": 52, "policyAcceptance": 54, "regulationPreference": 52, "publicServiceSatisfaction": 62}	0
1515	조성호	39	30-39	Male	경기도	37.428797	127.576352	대학교 졸	350-500만원	프리랜서	1인 가구	-13	중도 무당층	62	{"economy": 13, "housing": 12, "welfare": 24, "security": 9, "environment": 35}	포털 뉴스	{다양성,환경,공정}	경기도에 거주하는 30-39 프리랜서. 정치 성향은 중도이며 다양성, 환경, 공정 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 64, "ecoConsciousness": 47, "priceSensitivity": 71, "digitalConsumption": 75}	{"taxTolerance": 37, "governmentTrust": 32, "policyAcceptance": 62, "regulationPreference": 50, "publicServiceSatisfaction": 63}	0
1516	박하은	30	30-39	Male	경기도	37.361273	127.443052	대학원 졸	500-700만원	학생	1인 가구	-54	진보 정당 지지	61	{"economy": -48, "housing": 30, "welfare": 48, "security": -24, "environment": 15}	유튜브	{공동체,자유,혁신}	경기도에 거주하는 30-39 학생. 정치 성향은 진보이며 공동체, 자유, 혁신 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 69, "ecoConsciousness": 50, "priceSensitivity": 51, "digitalConsumption": 88}	{"taxTolerance": 36, "governmentTrust": 55, "policyAcceptance": 46, "regulationPreference": 61, "publicServiceSatisfaction": 71}	0
1517	최지우	45	40-49	Female	경기도	37.445751	127.578258	대학교 졸	350-500만원	프리랜서	1인 가구	-23	진보 성향 무당층	63	{"economy": -13, "housing": 20, "welfare": 54, "security": -16, "environment": 21}	SNS	{성장,안정,공동체}	경기도에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 성장, 안정, 공동체 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 49, "ecoConsciousness": 56, "priceSensitivity": 60, "digitalConsumption": 63}	{"taxTolerance": 46, "governmentTrust": 34, "policyAcceptance": 46, "regulationPreference": 59, "publicServiceSatisfaction": 90}	0
1518	안도윤	48	40-49	Female	경기도	37.456177	127.543368	고졸 이하	500-700만원	은퇴	부부 가구	-18	진보 성향 무당층	82	{"economy": -20, "housing": 25, "welfare": 10, "security": -14, "environment": 35}	포털 뉴스	{다양성,환경,자유}	경기도에 거주하는 40-49 은퇴. 정치 성향은 중도이며 다양성, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 66, "noveltySeeking": 35, "ecoConsciousness": 64, "priceSensitivity": 42, "digitalConsumption": 74}	{"taxTolerance": 24, "governmentTrust": 36, "policyAcceptance": 59, "regulationPreference": 50, "publicServiceSatisfaction": 74}	0
1519	홍광수	44	40-49	Female	경기도	37.42938	127.513267	대학원 졸	500-700만원	공무원	1인 가구	-74	진보 정당 지지	72	{"economy": -70, "housing": 35, "welfare": 39, "security": -30, "environment": 40}	지상파/종편 뉴스	{공동체,성장,환경}	경기도에 거주하는 40-49 공무원. 정치 성향은 진보이며 공동체, 성장, 환경 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 53, "ecoConsciousness": 53, "priceSensitivity": 55, "digitalConsumption": 67}	{"taxTolerance": 37, "governmentTrust": 43, "policyAcceptance": 33, "regulationPreference": 67, "publicServiceSatisfaction": 58}	0
1520	김다은	49	40-49	Female	경기도	37.468938	127.533065	대학원 졸	700만원 이상	주부	다세대 가구	12	중도 무당층	57	{"economy": -19, "housing": 4, "welfare": -13, "security": 19, "environment": 20}	지상파/종편 뉴스	{성장,공정,자유}	경기도에 거주하는 40-49 주부. 정치 성향은 중도이며 성장, 공정, 자유 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 78, "ecoConsciousness": 45, "priceSensitivity": 33, "digitalConsumption": 73}	{"taxTolerance": 46, "governmentTrust": 40, "policyAcceptance": 33, "regulationPreference": 73, "publicServiceSatisfaction": 78}	0
1521	최예준	49	40-49	Female	경기도	37.374127	127.613401	전문대 졸	200-350만원	생산직	1인 가구	3	중도 무당층	78	{"economy": -18, "housing": 16, "welfare": 7, "security": 30, "environment": 41}	포털 뉴스	{전통,안전,자유}	경기도에 거주하는 40-49 생산직. 정치 성향은 중도이며 전통, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 57, "ecoConsciousness": 55, "priceSensitivity": 52, "digitalConsumption": 61}	{"taxTolerance": 27, "governmentTrust": 55, "policyAcceptance": 50, "regulationPreference": 73, "publicServiceSatisfaction": 58}	0
1522	조순자	48	40-49	Female	경기도	37.391167	127.606238	대학교 졸	500-700만원	은퇴	자녀 양육 가구	4	중도 무당층	46	{"economy": -7, "housing": 11, "welfare": 10, "security": 10, "environment": 45}	유튜브	{전통,혁신,환경}	경기도에 거주하는 40-49 은퇴. 정치 성향은 중도이며 전통, 혁신, 환경 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 84, "ecoConsciousness": 46, "priceSensitivity": 55, "digitalConsumption": 92}	{"taxTolerance": 64, "governmentTrust": 39, "policyAcceptance": 73, "regulationPreference": 56, "publicServiceSatisfaction": 65}	0
1523	김영수	45	40-49	Female	경기도	37.45524	127.494289	전문대 졸	200-350만원	자영업	자녀 양육 가구	18	보수 성향 무당층	68	{"economy": 24, "housing": 4, "welfare": 19, "security": 18, "environment": 11}	신문/팟캐스트	{공정,공동체,환경}	경기도에 거주하는 40-49 자영업. 정치 성향은 중도이며 공정, 공동체, 환경 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 78, "ecoConsciousness": 40, "priceSensitivity": 50, "digitalConsumption": 77}	{"taxTolerance": 38, "governmentTrust": 49, "policyAcceptance": 51, "regulationPreference": 51, "publicServiceSatisfaction": 64}	0
1524	김영수	41	40-49	Female	경기도	37.460988	127.541756	대학교 졸	350-500만원	생산직	부부 가구	-27	진보 성향 무당층	63	{"economy": -14, "housing": 24, "welfare": 31, "security": -7, "environment": 27}	유튜브	{다양성,자유,공동체}	경기도에 거주하는 40-49 생산직. 정치 성향은 중도이며 다양성, 자유, 공동체 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 70, "ecoConsciousness": 61, "priceSensitivity": 59, "digitalConsumption": 76}	{"taxTolerance": 56, "governmentTrust": 49, "policyAcceptance": 48, "regulationPreference": 52, "publicServiceSatisfaction": 74}	0
1525	이서윤	44	40-49	Female	경기도	37.432244	127.482879	전문대 졸	200-350만원	사무직	자녀 양육 가구	13	중도 무당층	51	{"economy": 19, "housing": 21, "welfare": 0, "security": 22, "environment": 6}	SNS	{다양성,성장,공동체}	경기도에 거주하는 40-49 사무직. 정치 성향은 중도이며 다양성, 성장, 공동체 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 59, "ecoConsciousness": 68, "priceSensitivity": 77, "digitalConsumption": 66}	{"taxTolerance": 50, "governmentTrust": 59, "policyAcceptance": 48, "regulationPreference": 59, "publicServiceSatisfaction": 57}	0
1526	류하은	46	40-49	Female	경기도	37.354387	127.478897	고졸 이하	350-500만원	프리랜서	다세대 가구	-15	진보 성향 무당층	72	{"economy": -15, "housing": 50, "welfare": 20, "security": -2, "environment": 31}	지상파/종편 뉴스	{공정,다양성,공동체}	경기도에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 공정, 다양성, 공동체 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 62, "ecoConsciousness": 64, "priceSensitivity": 50, "digitalConsumption": 64}	{"taxTolerance": 41, "governmentTrust": 48, "policyAcceptance": 55, "regulationPreference": 50, "publicServiceSatisfaction": 75}	0
1527	이성호	48	40-49	Female	경기도	37.393103	127.606612	대학교 졸	700만원 이상	공무원	다세대 가구	-15	진보 성향 무당층	72	{"economy": 6, "housing": 13, "welfare": 12, "security": 1, "environment": -2}	유튜브	{안전,환경,안정}	경기도에 거주하는 40-49 공무원. 정치 성향은 중도이며 안전, 환경, 안정 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 74, "ecoConsciousness": 50, "priceSensitivity": 47, "digitalConsumption": 58}	{"taxTolerance": 83, "governmentTrust": 39, "policyAcceptance": 57, "regulationPreference": 53, "publicServiceSatisfaction": 59}	0
1528	이수아	48	40-49	Female	경기도	37.427405	127.451726	대학원 졸	200만원 미만	프리랜서	다세대 가구	28	보수 성향 무당층	62	{"economy": 17, "housing": -10, "welfare": 28, "security": -10, "environment": -1}	유튜브	{안전,공동체,안정}	경기도에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 안전, 공동체, 안정 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 61, "ecoConsciousness": 46, "priceSensitivity": 68, "digitalConsumption": 93}	{"taxTolerance": 54, "governmentTrust": 28, "policyAcceptance": 61, "regulationPreference": 69, "publicServiceSatisfaction": 74}	0
1529	조지호	44	40-49	Female	경기도	37.440546	127.471896	전문대 졸	350-500만원	자영업	1인 가구	12	중도 무당층	61	{"economy": -1, "housing": 13, "welfare": 16, "security": 14, "environment": 40}	포털 뉴스	{공동체,성장,공정}	경기도에 거주하는 40-49 자영업. 정치 성향은 중도이며 공동체, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 52, "ecoConsciousness": 48, "priceSensitivity": 50, "digitalConsumption": 70}	{"taxTolerance": 53, "governmentTrust": 54, "policyAcceptance": 55, "regulationPreference": 67, "publicServiceSatisfaction": 54}	0
1530	권순자	47	40-49	Female	경기도	37.380082	127.562238	대학교 졸	200-350만원	전문직	자녀 양육 가구	-12	중도 무당층	50	{"economy": 11, "housing": 2, "welfare": -7, "security": 1, "environment": 14}	SNS	{안전,전통,공동체}	경기도에 거주하는 40-49 전문직. 정치 성향은 중도이며 안전, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 54, "ecoConsciousness": 60, "priceSensitivity": 71, "digitalConsumption": 66}	{"taxTolerance": 56, "governmentTrust": 45, "policyAcceptance": 64, "regulationPreference": 60, "publicServiceSatisfaction": 65}	0
1531	강서윤	46	40-49	Female	경기도	37.376045	127.610479	전문대 졸	700만원 이상	자영업	1인 가구	-1	중도 무당층	84	{"economy": 53, "housing": -5, "welfare": 8, "security": -18, "environment": 24}	포털 뉴스	{안전,안정,성장}	경기도에 거주하는 40-49 자영업. 정치 성향은 중도이며 안전, 안정, 성장 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 54, "ecoConsciousness": 39, "priceSensitivity": 47, "digitalConsumption": 68}	{"taxTolerance": 45, "governmentTrust": 41, "policyAcceptance": 36, "regulationPreference": 55, "publicServiceSatisfaction": 72}	0
1532	한광수	41	40-49	Female	경기도	37.418435	127.522467	전문대 졸	200만원 미만	생산직	자녀 양육 가구	-11	중도 무당층	49	{"economy": 12, "housing": 24, "welfare": 17, "security": -17, "environment": 23}	SNS	{혁신,환경,전통}	경기도에 거주하는 40-49 생산직. 정치 성향은 중도이며 혁신, 환경, 전통 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 72, "ecoConsciousness": 39, "priceSensitivity": 63, "digitalConsumption": 63}	{"taxTolerance": 38, "governmentTrust": 40, "policyAcceptance": 53, "regulationPreference": 54, "publicServiceSatisfaction": 73}	0
1533	서준서	48	40-49	Female	경기도	37.444872	127.570756	전문대 졸	350-500만원	은퇴	다세대 가구	-25	진보 성향 무당층	85	{"economy": -13, "housing": 29, "welfare": 22, "security": 10, "environment": 14}	유튜브	{다양성,혁신,안정}	경기도에 거주하는 40-49 은퇴. 정치 성향은 중도이며 다양성, 혁신, 안정 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 69, "ecoConsciousness": 73, "priceSensitivity": 49, "digitalConsumption": 88}	{"taxTolerance": 37, "governmentTrust": 39, "policyAcceptance": 39, "regulationPreference": 68, "publicServiceSatisfaction": 62}	0
1534	김순자	49	40-49	Female	경기도	37.437905	127.556127	전문대 졸	700만원 이상	프리랜서	부부 가구	-10	중도 무당층	70	{"economy": 3, "housing": 32, "welfare": -17, "security": -36, "environment": 51}	유튜브	{환경,공정,다양성}	경기도에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 환경, 공정, 다양성 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 49, "ecoConsciousness": 54, "priceSensitivity": 43, "digitalConsumption": 67}	{"taxTolerance": 35, "governmentTrust": 40, "policyAcceptance": 61, "regulationPreference": 70, "publicServiceSatisfaction": 45}	0
1535	윤하은	44	40-49	Female	경기도	37.407408	127.501158	전문대 졸	700만원 이상	자영업	다세대 가구	60	보수 정당 지지	79	{"economy": 19, "housing": 6, "welfare": 5, "security": 33, "environment": 39}	신문/팟캐스트	{성장,자유,혁신}	경기도에 거주하는 40-49 자영업. 정치 성향은 보수이며 성장, 자유, 혁신 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 57, "ecoConsciousness": 49, "priceSensitivity": 30, "digitalConsumption": 68}	{"taxTolerance": 14, "governmentTrust": 45, "policyAcceptance": 60, "regulationPreference": 57, "publicServiceSatisfaction": 71}	0
1536	류순자	42	40-49	Male	경기도	37.444187	127.600138	대학교 졸	350-500만원	생산직	자녀 양육 가구	-45	진보 정당 지지	53	{"economy": -28, "housing": 27, "welfare": 41, "security": -5, "environment": 14}	지상파/종편 뉴스	{전통,안정,혁신}	경기도에 거주하는 40-49 생산직. 정치 성향은 진보이며 전통, 안정, 혁신 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 67, "ecoConsciousness": 48, "priceSensitivity": 42, "digitalConsumption": 79}	{"taxTolerance": 29, "governmentTrust": 44, "policyAcceptance": 65, "regulationPreference": 50, "publicServiceSatisfaction": 73}	0
1537	오채원	47	40-49	Male	경기도	37.480382	127.525649	전문대 졸	350-500만원	학생	다세대 가구	32	보수 성향 무당층	65	{"economy": 25, "housing": 23, "welfare": -4, "security": 31, "environment": 6}	지상파/종편 뉴스	{전통,다양성,성장}	경기도에 거주하는 40-49 학생. 정치 성향은 중도이며 전통, 다양성, 성장 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 57, "ecoConsciousness": 29, "priceSensitivity": 73, "digitalConsumption": 85}	{"taxTolerance": 58, "governmentTrust": 52, "policyAcceptance": 54, "regulationPreference": 70, "publicServiceSatisfaction": 53}	0
1538	정지우	43	40-49	Male	경기도	37.350658	127.58877	고졸 이하	350-500만원	학생	자녀 양육 가구	21	보수 성향 무당층	42	{"economy": 9, "housing": -3, "welfare": 0, "security": 26, "environment": 8}	포털 뉴스	{혁신,공정,안전}	경기도에 거주하는 40-49 학생. 정치 성향은 중도이며 혁신, 공정, 안전 가치를 중시한다.	{"brandLoyalty": 23, "noveltySeeking": 82, "ecoConsciousness": 61, "priceSensitivity": 55, "digitalConsumption": 81}	{"taxTolerance": 38, "governmentTrust": 57, "policyAcceptance": 49, "regulationPreference": 59, "publicServiceSatisfaction": 66}	0
1539	정서연	49	40-49	Male	경기도	37.376969	127.552895	전문대 졸	500-700만원	사무직	1인 가구	-19	진보 성향 무당층	75	{"economy": -30, "housing": 28, "welfare": -2, "security": -4, "environment": 24}	지상파/종편 뉴스	{다양성,안정,전통}	경기도에 거주하는 40-49 사무직. 정치 성향은 중도이며 다양성, 안정, 전통 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 55, "ecoConsciousness": 27, "priceSensitivity": 48, "digitalConsumption": 46}	{"taxTolerance": 42, "governmentTrust": 49, "policyAcceptance": 32, "regulationPreference": 65, "publicServiceSatisfaction": 65}	0
1540	황지민	44	40-49	Male	경기도	37.442966	127.52435	전문대 졸	500-700만원	공무원	다세대 가구	10	중도 무당층	56	{"economy": -4, "housing": 11, "welfare": 36, "security": -5, "environment": 16}	SNS	{다양성,성장,안전}	경기도에 거주하는 40-49 공무원. 정치 성향은 중도이며 다양성, 성장, 안전 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 46, "ecoConsciousness": 74, "priceSensitivity": 56, "digitalConsumption": 84}	{"taxTolerance": 48, "governmentTrust": 48, "policyAcceptance": 48, "regulationPreference": 58, "publicServiceSatisfaction": 66}	0
1541	조성호	42	40-49	Male	경기도	37.471474	127.479246	대학교 졸	350-500만원	서비스직	부부 가구	7	중도 무당층	95	{"economy": -6, "housing": 27, "welfare": -22, "security": 3, "environment": -3}	유튜브	{공정,안정,안전}	경기도에 거주하는 40-49 서비스직. 정치 성향은 중도이며 공정, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 85, "ecoConsciousness": 40, "priceSensitivity": 48, "digitalConsumption": 88}	{"taxTolerance": 53, "governmentTrust": 21, "policyAcceptance": 49, "regulationPreference": 56, "publicServiceSatisfaction": 41}	0
1542	이민준	42	40-49	Male	경기도	37.412497	127.564894	고졸 이하	500-700만원	자영업	부부 가구	22	보수 성향 무당층	70	{"economy": -15, "housing": -18, "welfare": 18, "security": 51, "environment": -9}	지상파/종편 뉴스	{다양성,공동체,혁신}	경기도에 거주하는 40-49 자영업. 정치 성향은 중도이며 다양성, 공동체, 혁신 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 43, "ecoConsciousness": 49, "priceSensitivity": 45, "digitalConsumption": 63}	{"taxTolerance": 27, "governmentTrust": 33, "policyAcceptance": 63, "regulationPreference": 63, "publicServiceSatisfaction": 56}	0
1543	김지아	41	40-49	Male	경기도	37.333851	127.514174	대학원 졸	200-350만원	생산직	부부 가구	5	중도 무당층	59	{"economy": -21, "housing": 15, "welfare": 6, "security": -3, "environment": 14}	지상파/종편 뉴스	{환경,전통,공동체}	경기도에 거주하는 40-49 생산직. 정치 성향은 중도이며 환경, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 78, "ecoConsciousness": 36, "priceSensitivity": 73, "digitalConsumption": 64}	{"taxTolerance": 41, "governmentTrust": 51, "policyAcceptance": 44, "regulationPreference": 73, "publicServiceSatisfaction": 61}	0
1544	최미경	44	40-49	Male	경기도	37.415379	127.594422	대학교 졸	700만원 이상	전문직	부부 가구	-29	진보 성향 무당층	88	{"economy": 6, "housing": 25, "welfare": 28, "security": 14, "environment": 48}	유튜브	{성장,안정,전통}	경기도에 거주하는 40-49 전문직. 정치 성향은 중도이며 성장, 안정, 전통 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 53, "ecoConsciousness": 57, "priceSensitivity": 53, "digitalConsumption": 75}	{"taxTolerance": 50, "governmentTrust": 64, "policyAcceptance": 36, "regulationPreference": 63, "publicServiceSatisfaction": 67}	0
1545	박정희	47	40-49	Male	경기도	37.446053	127.544413	전문대 졸	200-350만원	프리랜서	다세대 가구	19	보수 성향 무당층	62	{"economy": 27, "housing": 21, "welfare": 8, "security": 1, "environment": 11}	포털 뉴스	{성장,자유,다양성}	경기도에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 성장, 자유, 다양성 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 64, "ecoConsciousness": 44, "priceSensitivity": 70, "digitalConsumption": 51}	{"taxTolerance": 34, "governmentTrust": 54, "policyAcceptance": 55, "regulationPreference": 55, "publicServiceSatisfaction": 58}	0
1546	김현우	47	40-49	Male	경기도	37.475173	127.591183	전문대 졸	200-350만원	생산직	자녀 양육 가구	34	보수 성향 무당층	79	{"economy": 27, "housing": 17, "welfare": -7, "security": -5, "environment": 3}	신문/팟캐스트	{전통,안전,공동체}	경기도에 거주하는 40-49 생산직. 정치 성향은 보수이며 전통, 안전, 공동체 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 60, "ecoConsciousness": 43, "priceSensitivity": 51, "digitalConsumption": 73}	{"taxTolerance": 48, "governmentTrust": 32, "policyAcceptance": 51, "regulationPreference": 79, "publicServiceSatisfaction": 65}	0
1547	임유준	46	40-49	Male	경기도	37.439056	127.563264	대학원 졸	350-500만원	프리랜서	다세대 가구	-16	진보 성향 무당층	67	{"economy": -5, "housing": 21, "welfare": 33, "security": -6, "environment": -12}	신문/팟캐스트	{안정,혁신,다양성}	경기도에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 안정, 혁신, 다양성 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 74, "ecoConsciousness": 54, "priceSensitivity": 47, "digitalConsumption": 66}	{"taxTolerance": 53, "governmentTrust": 38, "policyAcceptance": 38, "regulationPreference": 46, "publicServiceSatisfaction": 58}	0
1548	권민서	42	40-49	Male	경기도	37.448048	127.508302	고졸 이하	350-500만원	서비스직	1인 가구	-15	진보 성향 무당층	65	{"economy": -19, "housing": 30, "welfare": 39, "security": -1, "environment": 35}	유튜브	{자유,전통,성장}	경기도에 거주하는 40-49 서비스직. 정치 성향은 중도이며 자유, 전통, 성장 가치를 중시한다.	{"brandLoyalty": 17, "noveltySeeking": 52, "ecoConsciousness": 35, "priceSensitivity": 51, "digitalConsumption": 71}	{"taxTolerance": 33, "governmentTrust": 41, "policyAcceptance": 42, "regulationPreference": 60, "publicServiceSatisfaction": 78}	0
1549	박영수	49	40-49	Male	경기도	37.374653	127.585301	대학교 졸	500-700만원	전문직	1인 가구	-11	중도 무당층	70	{"economy": -5, "housing": 28, "welfare": -12, "security": -15, "environment": 28}	신문/팟캐스트	{환경,공정,다양성}	경기도에 거주하는 40-49 전문직. 정치 성향은 중도이며 환경, 공정, 다양성 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 61, "ecoConsciousness": 65, "priceSensitivity": 69, "digitalConsumption": 60}	{"taxTolerance": 57, "governmentTrust": 46, "policyAcceptance": 47, "regulationPreference": 72, "publicServiceSatisfaction": 58}	0
1550	윤혜진	45	40-49	Male	경기도	37.427567	127.476977	전문대 졸	350-500만원	전문직	자녀 양육 가구	-9	중도 무당층	70	{"economy": 16, "housing": 7, "welfare": 2, "security": -22, "environment": 23}	지상파/종편 뉴스	{전통,성장,공정}	경기도에 거주하는 40-49 전문직. 정치 성향은 중도이며 전통, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 44, "ecoConsciousness": 35, "priceSensitivity": 55, "digitalConsumption": 60}	{"taxTolerance": 59, "governmentTrust": 50, "policyAcceptance": 51, "regulationPreference": 55, "publicServiceSatisfaction": 69}	0
1551	송주원	48	40-49	Male	경기도	37.431705	127.474566	전문대 졸	350-500만원	학생	자녀 양육 가구	10	중도 무당층	72	{"economy": -14, "housing": 18, "welfare": 5, "security": 16, "environment": 31}	SNS	{성장,전통,자유}	경기도에 거주하는 40-49 학생. 정치 성향은 중도이며 성장, 전통, 자유 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 48, "ecoConsciousness": 57, "priceSensitivity": 50, "digitalConsumption": 59}	{"taxTolerance": 25, "governmentTrust": 58, "policyAcceptance": 48, "regulationPreference": 70, "publicServiceSatisfaction": 62}	0
1552	서지우	46	40-49	Male	경기도	37.434724	127.502748	전문대 졸	500-700만원	생산직	다세대 가구	5	중도 무당층	69	{"economy": -18, "housing": 23, "welfare": 20, "security": 10, "environment": 28}	지상파/종편 뉴스	{전통,안전,성장}	경기도에 거주하는 40-49 생산직. 정치 성향은 중도이며 전통, 안전, 성장 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 55, "ecoConsciousness": 46, "priceSensitivity": 48, "digitalConsumption": 70}	{"taxTolerance": 31, "governmentTrust": 45, "policyAcceptance": 26, "regulationPreference": 67, "publicServiceSatisfaction": 74}	0
1553	이순자	47	40-49	Male	경기도	37.397902	127.503388	대학원 졸	350-500만원	생산직	자녀 양육 가구	6	중도 무당층	47	{"economy": -10, "housing": 3, "welfare": 2, "security": -6, "environment": 16}	신문/팟캐스트	{안정,안전,다양성}	경기도에 거주하는 40-49 생산직. 정치 성향은 중도이며 안정, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 23, "noveltySeeking": 55, "ecoConsciousness": 66, "priceSensitivity": 72, "digitalConsumption": 69}	{"taxTolerance": 56, "governmentTrust": 39, "policyAcceptance": 47, "regulationPreference": 40, "publicServiceSatisfaction": 52}	0
1554	강서윤	45	40-49	Male	경기도	37.415798	127.464301	전문대 졸	350-500만원	서비스직	다세대 가구	-49	진보 정당 지지	64	{"economy": -37, "housing": 37, "welfare": 40, "security": -16, "environment": 34}	신문/팟캐스트	{공동체,다양성,안전}	경기도에 거주하는 40-49 서비스직. 정치 성향은 진보이며 공동체, 다양성, 안전 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 56, "ecoConsciousness": 44, "priceSensitivity": 51, "digitalConsumption": 70}	{"taxTolerance": 34, "governmentTrust": 49, "policyAcceptance": 32, "regulationPreference": 61, "publicServiceSatisfaction": 71}	0
1555	오유준	50	50-59	Female	경기도	37.470228	127.444872	대학원 졸	500-700만원	자영업	1인 가구	2	중도 무당층	70	{"economy": -5, "housing": 28, "welfare": -8, "security": 6, "environment": 27}	SNS	{성장,안정,공정}	경기도에 거주하는 50-59 자영업. 정치 성향은 중도이며 성장, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 71, "ecoConsciousness": 64, "priceSensitivity": 39, "digitalConsumption": 61}	{"taxTolerance": 45, "governmentTrust": 45, "policyAcceptance": 33, "regulationPreference": 79, "publicServiceSatisfaction": 52}	0
1556	안민준	55	50-59	Female	경기도	37.476474	127.441815	대학교 졸	350-500만원	은퇴	다세대 가구	29	보수 성향 무당층	66	{"economy": -8, "housing": 15, "welfare": -23, "security": 23, "environment": 14}	SNS	{전통,안전,공동체}	경기도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 전통, 안전, 공동체 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 55, "ecoConsciousness": 36, "priceSensitivity": 50, "digitalConsumption": 74}	{"taxTolerance": 44, "governmentTrust": 25, "policyAcceptance": 34, "regulationPreference": 72, "publicServiceSatisfaction": 69}	0
1557	홍미경	56	50-59	Female	경기도	37.478256	127.438732	대학교 졸	350-500만원	주부	부부 가구	1	중도 무당층	83	{"economy": 3, "housing": 0, "welfare": -8, "security": -16, "environment": 27}	지상파/종편 뉴스	{혁신,전통,환경}	경기도에 거주하는 50-59 주부. 정치 성향은 중도이며 혁신, 전통, 환경 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 39, "ecoConsciousness": 64, "priceSensitivity": 68, "digitalConsumption": 58}	{"taxTolerance": 64, "governmentTrust": 50, "policyAcceptance": 47, "regulationPreference": 71, "publicServiceSatisfaction": 82}	0
1558	김정희	58	50-59	Female	경기도	37.424743	127.557315	대학원 졸	500-700만원	주부	다세대 가구	-30	진보 성향 무당층	69	{"economy": -38, "housing": 13, "welfare": 48, "security": -21, "environment": 34}	지상파/종편 뉴스	{자유,다양성,환경}	경기도에 거주하는 50-59 주부. 정치 성향은 중도이며 자유, 다양성, 환경 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 45, "ecoConsciousness": 63, "priceSensitivity": 62, "digitalConsumption": 62}	{"taxTolerance": 53, "governmentTrust": 50, "policyAcceptance": 47, "regulationPreference": 47, "publicServiceSatisfaction": 64}	0
1559	류건우	54	50-59	Female	경기도	37.433004	127.502355	대학교 졸	500-700만원	자영업	다세대 가구	8	중도 무당층	83	{"economy": 9, "housing": 8, "welfare": 20, "security": 21, "environment": 60}	유튜브	{자유,다양성,안전}	경기도에 거주하는 50-59 자영업. 정치 성향은 중도이며 자유, 다양성, 안전 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 61, "ecoConsciousness": 48, "priceSensitivity": 39, "digitalConsumption": 63}	{"taxTolerance": 46, "governmentTrust": 46, "policyAcceptance": 42, "regulationPreference": 73, "publicServiceSatisfaction": 64}	0
1560	서혜진	52	50-59	Female	경기도	37.463133	127.438253	고졸 이하	500-700만원	서비스직	다세대 가구	-45	진보 정당 지지	61	{"economy": -39, "housing": 32, "welfare": 49, "security": -42, "environment": 45}	신문/팟캐스트	{안정,환경,공동체}	경기도에 거주하는 50-59 서비스직. 정치 성향은 진보이며 안정, 환경, 공동체 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 43, "ecoConsciousness": 44, "priceSensitivity": 51, "digitalConsumption": 81}	{"taxTolerance": 51, "governmentTrust": 53, "policyAcceptance": 41, "regulationPreference": 68, "publicServiceSatisfaction": 71}	0
1561	신동현	50	50-59	Female	경기도	37.456798	127.424042	대학교 졸	350-500만원	학생	부부 가구	-5	중도 무당층	60	{"economy": -15, "housing": 13, "welfare": -5, "security": -14, "environment": 41}	유튜브	{안정,공동체,성장}	경기도에 거주하는 50-59 학생. 정치 성향은 중도이며 안정, 공동체, 성장 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 62, "ecoConsciousness": 32, "priceSensitivity": 68, "digitalConsumption": 52}	{"taxTolerance": 49, "governmentTrust": 47, "policyAcceptance": 55, "regulationPreference": 64, "publicServiceSatisfaction": 59}	0
1562	서예준	50	50-59	Female	경기도	37.367708	127.539211	고졸 이하	200-350만원	주부	1인 가구	24	보수 성향 무당층	45	{"economy": 5, "housing": 9, "welfare": 12, "security": 17, "environment": 8}	신문/팟캐스트	{안전,공정,공동체}	경기도에 거주하는 50-59 주부. 정치 성향은 중도이며 안전, 공정, 공동체 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 48, "ecoConsciousness": 52, "priceSensitivity": 63, "digitalConsumption": 64}	{"taxTolerance": 38, "governmentTrust": 39, "policyAcceptance": 64, "regulationPreference": 63, "publicServiceSatisfaction": 68}	0
1563	이정희	54	50-59	Female	경기도	37.447406	127.524308	전문대 졸	500-700만원	공무원	다세대 가구	22	보수 성향 무당층	99	{"economy": -19, "housing": 27, "welfare": -8, "security": 39, "environment": 10}	신문/팟캐스트	{환경,공동체,성장}	경기도에 거주하는 50-59 공무원. 정치 성향은 중도이며 환경, 공동체, 성장 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 62, "ecoConsciousness": 23, "priceSensitivity": 62, "digitalConsumption": 71}	{"taxTolerance": 63, "governmentTrust": 48, "policyAcceptance": 56, "regulationPreference": 59, "publicServiceSatisfaction": 80}	0
1564	최민준	58	50-59	Female	경기도	37.411299	127.530951	대학교 졸	350-500만원	프리랜서	다세대 가구	-14	중도 무당층	65	{"economy": -15, "housing": 33, "welfare": 25, "security": 0, "environment": 19}	신문/팟캐스트	{환경,혁신,자유}	경기도에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 환경, 혁신, 자유 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 42, "ecoConsciousness": 51, "priceSensitivity": 74, "digitalConsumption": 45}	{"taxTolerance": 59, "governmentTrust": 47, "policyAcceptance": 47, "regulationPreference": 60, "publicServiceSatisfaction": 48}	0
1565	서서연	59	50-59	Female	경기도	37.356341	127.509862	대학원 졸	200만원 미만	은퇴	자녀 양육 가구	26	보수 성향 무당층	77	{"economy": 17, "housing": 33, "welfare": 20, "security": 13, "environment": 19}	포털 뉴스	{전통,환경,안정}	경기도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 전통, 환경, 안정 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 58, "ecoConsciousness": 60, "priceSensitivity": 68, "digitalConsumption": 63}	{"taxTolerance": 57, "governmentTrust": 59, "policyAcceptance": 44, "regulationPreference": 69, "publicServiceSatisfaction": 65}	0
1566	서민준	54	50-59	Female	경기도	37.422952	127.598254	전문대 졸	500-700만원	은퇴	1인 가구	21	보수 성향 무당층	64	{"economy": 2, "housing": 31, "welfare": -4, "security": 12, "environment": 13}	SNS	{전통,안정,공동체}	경기도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 전통, 안정, 공동체 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 56, "ecoConsciousness": 47, "priceSensitivity": 55, "digitalConsumption": 50}	{"taxTolerance": 48, "governmentTrust": 50, "policyAcceptance": 49, "regulationPreference": 71, "publicServiceSatisfaction": 62}	0
1567	김혜진	55	50-59	Female	경기도	37.465422	127.614017	전문대 졸	200-350만원	공무원	다세대 가구	4	중도 무당층	57	{"economy": -3, "housing": 4, "welfare": -2, "security": 11, "environment": 21}	SNS	{공동체,자유,혁신}	경기도에 거주하는 50-59 공무원. 정치 성향은 중도이며 공동체, 자유, 혁신 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 45, "ecoConsciousness": 35, "priceSensitivity": 66, "digitalConsumption": 51}	{"taxTolerance": 50, "governmentTrust": 48, "policyAcceptance": 42, "regulationPreference": 77, "publicServiceSatisfaction": 59}	0
1568	홍민준	56	50-59	Female	경기도	37.446331	127.565805	대학교 졸	200-350만원	공무원	1인 가구	-12	중도 무당층	67	{"economy": -27, "housing": 40, "welfare": 26, "security": -23, "environment": 20}	SNS	{안정,안전,다양성}	경기도에 거주하는 50-59 공무원. 정치 성향은 중도이며 안정, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 55, "ecoConsciousness": 43, "priceSensitivity": 62, "digitalConsumption": 52}	{"taxTolerance": 75, "governmentTrust": 36, "policyAcceptance": 43, "regulationPreference": 69, "publicServiceSatisfaction": 76}	0
1569	홍도윤	52	50-59	Female	경기도	37.40847	127.51636	대학교 졸	700만원 이상	학생	부부 가구	2	중도 무당층	57	{"economy": 5, "housing": 14, "welfare": -3, "security": 35, "environment": 18}	포털 뉴스	{혁신,환경,자유}	경기도에 거주하는 50-59 학생. 정치 성향은 중도이며 혁신, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 64, "ecoConsciousness": 54, "priceSensitivity": 47, "digitalConsumption": 68}	{"taxTolerance": 54, "governmentTrust": 38, "policyAcceptance": 44, "regulationPreference": 55, "publicServiceSatisfaction": 68}	0
1570	전준서	52	50-59	Female	경기도	37.34154	127.497765	대학교 졸	350-500만원	생산직	다세대 가구	-5	중도 무당층	70	{"economy": -17, "housing": -3, "welfare": 42, "security": -7, "environment": 9}	신문/팟캐스트	{안전,전통,공동체}	경기도에 거주하는 50-59 생산직. 정치 성향은 중도이며 안전, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 68, "ecoConsciousness": 59, "priceSensitivity": 61, "digitalConsumption": 74}	{"taxTolerance": 40, "governmentTrust": 40, "policyAcceptance": 50, "regulationPreference": 54, "publicServiceSatisfaction": 57}	0
1571	류혜진	52	50-59	Female	경기도	37.38344	127.600255	대학원 졸	350-500만원	서비스직	부부 가구	-10	중도 무당층	67	{"economy": -13, "housing": -5, "welfare": 27, "security": 11, "environment": 23}	유튜브	{다양성,혁신,환경}	경기도에 거주하는 50-59 서비스직. 정치 성향은 중도이며 다양성, 혁신, 환경 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 44, "ecoConsciousness": 60, "priceSensitivity": 72, "digitalConsumption": 58}	{"taxTolerance": 45, "governmentTrust": 39, "policyAcceptance": 59, "regulationPreference": 70, "publicServiceSatisfaction": 88}	0
1572	안경숙	53	50-59	Female	경기도	37.4224	127.517312	전문대 졸	350-500만원	공무원	1인 가구	5	중도 무당층	79	{"economy": 11, "housing": 40, "welfare": 13, "security": 6, "environment": 49}	유튜브	{안전,전통,자유}	경기도에 거주하는 50-59 공무원. 정치 성향은 중도이며 안전, 전통, 자유 가치를 중시한다.	{"brandLoyalty": 22, "noveltySeeking": 61, "ecoConsciousness": 45, "priceSensitivity": 58, "digitalConsumption": 75}	{"taxTolerance": 40, "governmentTrust": 59, "policyAcceptance": 35, "regulationPreference": 52, "publicServiceSatisfaction": 73}	0
1573	송주원	54	50-59	Female	경기도	37.450594	127.578946	대학교 졸	200-350만원	서비스직	다세대 가구	5	중도 무당층	90	{"economy": 13, "housing": 13, "welfare": 26, "security": 29, "environment": 29}	유튜브	{공동체,안전,환경}	경기도에 거주하는 50-59 서비스직. 정치 성향은 중도이며 공동체, 안전, 환경 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 74, "ecoConsciousness": 38, "priceSensitivity": 66, "digitalConsumption": 67}	{"taxTolerance": 22, "governmentTrust": 42, "policyAcceptance": 44, "regulationPreference": 53, "publicServiceSatisfaction": 66}	0
1574	권순자	59	50-59	Female	경기도	37.350594	127.581696	대학교 졸	350-500만원	학생	다세대 가구	2	중도 무당층	91	{"economy": -8, "housing": 28, "welfare": -9, "security": 1, "environment": 34}	SNS	{안전,공동체,다양성}	경기도에 거주하는 50-59 학생. 정치 성향은 중도이며 안전, 공동체, 다양성 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 47, "ecoConsciousness": 30, "priceSensitivity": 47, "digitalConsumption": 46}	{"taxTolerance": 70, "governmentTrust": 45, "policyAcceptance": 62, "regulationPreference": 37, "publicServiceSatisfaction": 81}	0
1575	김채원	59	50-59	Female	경기도	37.335502	127.567049	고졸 이하	200-350만원	은퇴	부부 가구	32	보수 성향 무당층	70	{"economy": -14, "housing": -4, "welfare": -25, "security": 22, "environment": 2}	SNS	{공동체,다양성,혁신}	경기도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 공동체, 다양성, 혁신 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 30, "ecoConsciousness": 41, "priceSensitivity": 66, "digitalConsumption": 78}	{"taxTolerance": 34, "governmentTrust": 48, "policyAcceptance": 50, "regulationPreference": 71, "publicServiceSatisfaction": 66}	0
1576	전지우	55	50-59	Male	경기도	37.360782	127.594159	전문대 졸	200-350만원	주부	자녀 양육 가구	44	보수 성향 무당층	67	{"economy": 13, "housing": -5, "welfare": -25, "security": 60, "environment": 22}	포털 뉴스	{성장,공동체,환경}	경기도에 거주하는 50-59 주부. 정치 성향은 보수이며 성장, 공동체, 환경 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 79, "ecoConsciousness": 30, "priceSensitivity": 58, "digitalConsumption": 68}	{"taxTolerance": 46, "governmentTrust": 53, "policyAcceptance": 77, "regulationPreference": 64, "publicServiceSatisfaction": 72}	0
1577	서철수	59	50-59	Male	경기도	37.373493	127.508375	대학원 졸	350-500만원	프리랜서	자녀 양육 가구	-14	중도 무당층	78	{"economy": -21, "housing": 9, "welfare": 7, "security": 26, "environment": 34}	신문/팟캐스트	{안전,성장,공정}	경기도에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 안전, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 62, "ecoConsciousness": 31, "priceSensitivity": 59, "digitalConsumption": 73}	{"taxTolerance": 59, "governmentTrust": 31, "policyAcceptance": 43, "regulationPreference": 69, "publicServiceSatisfaction": 62}	0
1578	오서윤	56	50-59	Male	경기도	37.41052	127.437908	고졸 이하	500-700만원	공무원	1인 가구	39	보수 성향 무당층	99	{"economy": 11, "housing": -14, "welfare": -1, "security": -19, "environment": 2}	지상파/종편 뉴스	{안정,자유,안전}	경기도에 거주하는 50-59 공무원. 정치 성향은 보수이며 안정, 자유, 안전 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 71, "ecoConsciousness": 46, "priceSensitivity": 49, "digitalConsumption": 55}	{"taxTolerance": 50, "governmentTrust": 31, "policyAcceptance": 47, "regulationPreference": 58, "publicServiceSatisfaction": 71}	0
1579	안성호	58	50-59	Male	경기도	37.363484	127.496787	대학원 졸	350-500만원	전문직	부부 가구	-28	진보 성향 무당층	46	{"economy": -18, "housing": 29, "welfare": 12, "security": -18, "environment": 36}	SNS	{혁신,성장,환경}	경기도에 거주하는 50-59 전문직. 정치 성향은 중도이며 혁신, 성장, 환경 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 48, "ecoConsciousness": 58, "priceSensitivity": 62, "digitalConsumption": 69}	{"taxTolerance": 55, "governmentTrust": 34, "policyAcceptance": 31, "regulationPreference": 65, "publicServiceSatisfaction": 78}	0
1580	홍경숙	53	50-59	Male	경기도	37.413213	127.613802	전문대 졸	500-700만원	은퇴	자녀 양육 가구	-29	진보 성향 무당층	40	{"economy": -21, "housing": 34, "welfare": 16, "security": -34, "environment": 23}	신문/팟캐스트	{자유,공동체,성장}	경기도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 자유, 공동체, 성장 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 46, "ecoConsciousness": 58, "priceSensitivity": 48, "digitalConsumption": 76}	{"taxTolerance": 49, "governmentTrust": 60, "policyAcceptance": 44, "regulationPreference": 64, "publicServiceSatisfaction": 73}	0
1581	윤성호	53	50-59	Male	경기도	37.351887	127.572056	대학원 졸	350-500만원	프리랜서	다세대 가구	-6	중도 무당층	67	{"economy": -7, "housing": -13, "welfare": 6, "security": -10, "environment": 42}	SNS	{환경,안전,안정}	경기도에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 환경, 안전, 안정 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 70, "ecoConsciousness": 54, "priceSensitivity": 72, "digitalConsumption": 63}	{"taxTolerance": 58, "governmentTrust": 43, "policyAcceptance": 71, "regulationPreference": 70, "publicServiceSatisfaction": 74}	0
1582	류지민	55	50-59	Male	경기도	37.471955	127.607354	대학원 졸	200-350만원	학생	다세대 가구	5	중도 무당층	83	{"economy": -36, "housing": 2, "welfare": 37, "security": 8, "environment": 9}	지상파/종편 뉴스	{다양성,안전,혁신}	경기도에 거주하는 50-59 학생. 정치 성향은 중도이며 다양성, 안전, 혁신 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 63, "ecoConsciousness": 48, "priceSensitivity": 51, "digitalConsumption": 41}	{"taxTolerance": 52, "governmentTrust": 41, "policyAcceptance": 45, "regulationPreference": 45, "publicServiceSatisfaction": 62}	0
1583	최현우	59	50-59	Male	경기도	37.347443	127.570274	전문대 졸	200-350만원	서비스직	부부 가구	-58	진보 정당 지지	74	{"economy": -21, "housing": 41, "welfare": 21, "security": -2, "environment": 43}	신문/팟캐스트	{공정,공동체,혁신}	경기도에 거주하는 50-59 서비스직. 정치 성향은 진보이며 공정, 공동체, 혁신 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 59, "ecoConsciousness": 34, "priceSensitivity": 68, "digitalConsumption": 80}	{"taxTolerance": 34, "governmentTrust": 43, "policyAcceptance": 47, "regulationPreference": 53, "publicServiceSatisfaction": 60}	0
1584	이서연	59	50-59	Male	경기도	37.410398	127.534561	전문대 졸	700만원 이상	학생	1인 가구	25	보수 성향 무당층	80	{"economy": -5, "housing": 27, "welfare": -3, "security": 14, "environment": 8}	지상파/종편 뉴스	{전통,안전,공정}	경기도에 거주하는 50-59 학생. 정치 성향은 중도이며 전통, 안전, 공정 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 71, "ecoConsciousness": 35, "priceSensitivity": 26, "digitalConsumption": 65}	{"taxTolerance": 63, "governmentTrust": 52, "policyAcceptance": 48, "regulationPreference": 60, "publicServiceSatisfaction": 56}	0
1585	송은우	51	50-59	Male	경기도	37.415639	127.442724	대학교 졸	350-500만원	생산직	자녀 양육 가구	23	보수 성향 무당층	62	{"economy": 14, "housing": 11, "welfare": -21, "security": 30, "environment": -5}	유튜브	{안전,혁신,안정}	경기도에 거주하는 50-59 생산직. 정치 성향은 중도이며 안전, 혁신, 안정 가치를 중시한다.	{"brandLoyalty": 69, "noveltySeeking": 71, "ecoConsciousness": 58, "priceSensitivity": 58, "digitalConsumption": 63}	{"taxTolerance": 57, "governmentTrust": 36, "policyAcceptance": 73, "regulationPreference": 65, "publicServiceSatisfaction": 62}	0
1586	송도윤	58	50-59	Male	경기도	37.442552	127.461722	전문대 졸	500-700만원	자영업	1인 가구	13	중도 무당층	62	{"economy": -30, "housing": 7, "welfare": 6, "security": 6, "environment": -15}	유튜브	{전통,성장,자유}	경기도에 거주하는 50-59 자영업. 정치 성향은 중도이며 전통, 성장, 자유 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 76, "ecoConsciousness": 42, "priceSensitivity": 59, "digitalConsumption": 43}	{"taxTolerance": 42, "governmentTrust": 32, "policyAcceptance": 52, "regulationPreference": 66, "publicServiceSatisfaction": 35}	0
1587	오지민	52	50-59	Male	경기도	37.384589	127.45024	고졸 이하	500-700만원	은퇴	부부 가구	15	보수 성향 무당층	81	{"economy": 1, "housing": 2, "welfare": -14, "security": 14, "environment": 13}	유튜브	{전통,다양성,공동체}	경기도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 전통, 다양성, 공동체 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 65, "ecoConsciousness": 61, "priceSensitivity": 64, "digitalConsumption": 61}	{"taxTolerance": 20, "governmentTrust": 49, "policyAcceptance": 40, "regulationPreference": 54, "publicServiceSatisfaction": 69}	0
1588	박은우	54	50-59	Male	경기도	37.375947	127.547841	전문대 졸	700만원 이상	공무원	1인 가구	5	중도 무당층	54	{"economy": 15, "housing": 19, "welfare": -8, "security": 4, "environment": 21}	SNS	{혁신,안전,전통}	경기도에 거주하는 50-59 공무원. 정치 성향은 중도이며 혁신, 안전, 전통 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 48, "ecoConsciousness": 39, "priceSensitivity": 46, "digitalConsumption": 85}	{"taxTolerance": 50, "governmentTrust": 40, "policyAcceptance": 33, "regulationPreference": 67, "publicServiceSatisfaction": 64}	0
1589	김혜진	53	50-59	Male	경기도	37.411123	127.606051	전문대 졸	350-500만원	은퇴	다세대 가구	-20	진보 성향 무당층	80	{"economy": 0, "housing": 25, "welfare": 33, "security": -14, "environment": 21}	지상파/종편 뉴스	{성장,전통,공정}	경기도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 성장, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 60, "ecoConsciousness": 33, "priceSensitivity": 46, "digitalConsumption": 44}	{"taxTolerance": 39, "governmentTrust": 37, "policyAcceptance": 34, "regulationPreference": 65, "publicServiceSatisfaction": 83}	0
1590	윤예준	59	50-59	Male	경기도	37.428513	127.454585	대학교 졸	500-700만원	학생	1인 가구	36	보수 성향 무당층	82	{"economy": 9, "housing": -14, "welfare": -13, "security": 29, "environment": 19}	유튜브	{자유,환경,혁신}	경기도에 거주하는 50-59 학생. 정치 성향은 보수이며 자유, 환경, 혁신 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 47, "ecoConsciousness": 46, "priceSensitivity": 63, "digitalConsumption": 66}	{"taxTolerance": 32, "governmentTrust": 43, "policyAcceptance": 65, "regulationPreference": 64, "publicServiceSatisfaction": 66}	0
1591	류현우	59	50-59	Male	경기도	37.431657	127.472551	전문대 졸	500-700만원	생산직	1인 가구	-26	진보 성향 무당층	75	{"economy": -6, "housing": 6, "welfare": 33, "security": -59, "environment": 24}	지상파/종편 뉴스	{공정,혁신,다양성}	경기도에 거주하는 50-59 생산직. 정치 성향은 중도이며 공정, 혁신, 다양성 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 46, "ecoConsciousness": 46, "priceSensitivity": 60, "digitalConsumption": 61}	{"taxTolerance": 48, "governmentTrust": 30, "policyAcceptance": 26, "regulationPreference": 55, "publicServiceSatisfaction": 54}	0
1592	신주원	53	50-59	Male	경기도	37.349457	127.503974	고졸 이하	700만원 이상	학생	자녀 양육 가구	7	중도 무당층	60	{"economy": 2, "housing": 14, "welfare": -5, "security": -16, "environment": 28}	지상파/종편 뉴스	{안정,혁신,공동체}	경기도에 거주하는 50-59 학생. 정치 성향은 중도이며 안정, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 41, "ecoConsciousness": 46, "priceSensitivity": 41, "digitalConsumption": 59}	{"taxTolerance": 32, "governmentTrust": 57, "policyAcceptance": 47, "regulationPreference": 64, "publicServiceSatisfaction": 53}	0
1593	전수아	52	50-59	Male	경기도	37.344605	127.513735	대학원 졸	200만원 미만	학생	부부 가구	6	중도 무당층	39	{"economy": -3, "housing": -10, "welfare": 9, "security": 45, "environment": 25}	포털 뉴스	{혁신,공정,다양성}	경기도에 거주하는 50-59 학생. 정치 성향은 중도이며 혁신, 공정, 다양성 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 64, "ecoConsciousness": 34, "priceSensitivity": 63, "digitalConsumption": 73}	{"taxTolerance": 52, "governmentTrust": 38, "policyAcceptance": 49, "regulationPreference": 49, "publicServiceSatisfaction": 63}	0
1594	류동현	52	50-59	Male	경기도	37.457881	127.592126	전문대 졸	500-700만원	은퇴	1인 가구	-19	진보 성향 무당층	75	{"economy": -20, "housing": 56, "welfare": 38, "security": -7, "environment": 30}	신문/팟캐스트	{공정,안전,공동체}	경기도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 공정, 안전, 공동체 가치를 중시한다.	{"brandLoyalty": 60, "noveltySeeking": 57, "ecoConsciousness": 53, "priceSensitivity": 53, "digitalConsumption": 68}	{"taxTolerance": 48, "governmentTrust": 57, "policyAcceptance": 45, "regulationPreference": 43, "publicServiceSatisfaction": 45}	0
1595	신경숙	58	50-59	Male	경기도	37.485873	127.506777	고졸 이하	200-350만원	공무원	자녀 양육 가구	18	보수 성향 무당층	83	{"economy": -7, "housing": 41, "welfare": -13, "security": 0, "environment": 19}	지상파/종편 뉴스	{혁신,공정,안정}	경기도에 거주하는 50-59 공무원. 정치 성향은 중도이며 혁신, 공정, 안정 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 30, "ecoConsciousness": 48, "priceSensitivity": 72, "digitalConsumption": 55}	{"taxTolerance": 58, "governmentTrust": 46, "policyAcceptance": 70, "regulationPreference": 77, "publicServiceSatisfaction": 68}	0
1596	한예준	57	50-59	Male	경기도	37.334632	127.457329	대학교 졸	700만원 이상	은퇴	다세대 가구	26	보수 성향 무당층	76	{"economy": 9, "housing": 32, "welfare": 1, "security": 21, "environment": 9}	포털 뉴스	{성장,다양성,공정}	경기도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 성장, 다양성, 공정 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 50, "ecoConsciousness": 57, "priceSensitivity": 23, "digitalConsumption": 60}	{"taxTolerance": 68, "governmentTrust": 37, "policyAcceptance": 54, "regulationPreference": 64, "publicServiceSatisfaction": 77}	0
1597	전다은	64	60-69	Female	경기도	37.358281	127.517381	전문대 졸	350-500만원	은퇴	자녀 양육 가구	20	보수 성향 무당층	67	{"economy": 28, "housing": 25, "welfare": 17, "security": 30, "environment": 9}	SNS	{성장,혁신,공동체}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 성장, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 60, "ecoConsciousness": 57, "priceSensitivity": 51, "digitalConsumption": 38}	{"taxTolerance": 35, "governmentTrust": 48, "policyAcceptance": 44, "regulationPreference": 55, "publicServiceSatisfaction": 51}	0
1598	한현우	69	60-69	Female	경기도	37.428987	127.483805	대학원 졸	350-500만원	은퇴	1인 가구	48	보수 정당 지지	76	{"economy": 38, "housing": -11, "welfare": -37, "security": 46, "environment": -11}	신문/팟캐스트	{환경,안전,자유}	경기도에 거주하는 60-69 은퇴. 정치 성향은 보수이며 환경, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 70, "noveltySeeking": 45, "ecoConsciousness": 55, "priceSensitivity": 56, "digitalConsumption": 48}	{"taxTolerance": 55, "governmentTrust": 49, "policyAcceptance": 62, "regulationPreference": 75, "publicServiceSatisfaction": 65}	0
1599	안동현	66	60-69	Female	경기도	37.415679	127.59702	대학교 졸	350-500만원	자영업	부부 가구	-18	진보 성향 무당층	89	{"economy": -4, "housing": 52, "welfare": 52, "security": -24, "environment": 9}	신문/팟캐스트	{전통,성장,환경}	경기도에 거주하는 60-69 자영업. 정치 성향은 중도이며 전통, 성장, 환경 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 58, "ecoConsciousness": 45, "priceSensitivity": 67, "digitalConsumption": 76}	{"taxTolerance": 41, "governmentTrust": 44, "policyAcceptance": 33, "regulationPreference": 64, "publicServiceSatisfaction": 47}	0
1600	홍광수	68	60-69	Female	경기도	37.48967	127.452326	대학교 졸	200-350만원	은퇴	자녀 양육 가구	21	보수 성향 무당층	53	{"economy": -15, "housing": 42, "welfare": -14, "security": 27, "environment": 4}	SNS	{혁신,다양성,안정}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 혁신, 다양성, 안정 가치를 중시한다.	{"brandLoyalty": 65, "noveltySeeking": 66, "ecoConsciousness": 55, "priceSensitivity": 69, "digitalConsumption": 60}	{"taxTolerance": 30, "governmentTrust": 50, "policyAcceptance": 51, "regulationPreference": 83, "publicServiceSatisfaction": 70}	0
1601	서준서	67	60-69	Female	경기도	37.460994	127.430889	대학원 졸	350-500만원	은퇴	자녀 양육 가구	6	중도 무당층	78	{"economy": -8, "housing": 36, "welfare": 3, "security": 24, "environment": 20}	유튜브	{다양성,안전,성장}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 다양성, 안전, 성장 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 63, "ecoConsciousness": 38, "priceSensitivity": 43, "digitalConsumption": 61}	{"taxTolerance": 54, "governmentTrust": 53, "policyAcceptance": 59, "regulationPreference": 70, "publicServiceSatisfaction": 63}	0
1602	서서연	64	60-69	Female	경기도	37.449328	127.597267	대학교 졸	200-350만원	학생	부부 가구	23	보수 성향 무당층	67	{"economy": 10, "housing": 8, "welfare": -29, "security": 23, "environment": -11}	SNS	{안정,전통,공동체}	경기도에 거주하는 60-69 학생. 정치 성향은 중도이며 안정, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 66, "noveltySeeking": 47, "ecoConsciousness": 53, "priceSensitivity": 76, "digitalConsumption": 51}	{"taxTolerance": 52, "governmentTrust": 44, "policyAcceptance": 60, "regulationPreference": 66, "publicServiceSatisfaction": 66}	0
1603	전혜진	64	60-69	Female	경기도	37.397435	127.560172	고졸 이하	700만원 이상	공무원	1인 가구	-26	진보 성향 무당층	53	{"economy": -26, "housing": 57, "welfare": 16, "security": 15, "environment": 25}	신문/팟캐스트	{안정,전통,성장}	경기도에 거주하는 60-69 공무원. 정치 성향은 중도이며 안정, 전통, 성장 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 58, "ecoConsciousness": 56, "priceSensitivity": 46, "digitalConsumption": 52}	{"taxTolerance": 48, "governmentTrust": 48, "policyAcceptance": 56, "regulationPreference": 70, "publicServiceSatisfaction": 45}	0
1604	강채원	65	60-69	Female	경기도	37.451824	127.470074	대학원 졸	350-500만원	자영업	부부 가구	-16	진보 성향 무당층	74	{"economy": -6, "housing": 30, "welfare": 9, "security": 7, "environment": 5}	유튜브	{자유,공정,다양성}	경기도에 거주하는 60-69 자영업. 정치 성향은 중도이며 자유, 공정, 다양성 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 57, "ecoConsciousness": 56, "priceSensitivity": 56, "digitalConsumption": 76}	{"taxTolerance": 46, "governmentTrust": 60, "policyAcceptance": 53, "regulationPreference": 86, "publicServiceSatisfaction": 75}	0
1605	강정희	67	60-69	Female	경기도	37.376068	127.424938	대학교 졸	500-700만원	은퇴	1인 가구	31	보수 성향 무당층	77	{"economy": 58, "housing": 34, "welfare": 28, "security": 46, "environment": -10}	SNS	{전통,안정,자유}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 전통, 안정, 자유 가치를 중시한다.	{"brandLoyalty": 66, "noveltySeeking": 52, "ecoConsciousness": 50, "priceSensitivity": 47, "digitalConsumption": 69}	{"taxTolerance": 39, "governmentTrust": 55, "policyAcceptance": 49, "regulationPreference": 74, "publicServiceSatisfaction": 52}	0
1606	류미경	63	60-69	Female	경기도	37.485877	127.502907	대학원 졸	200-350만원	서비스직	1인 가구	-20	진보 성향 무당층	70	{"economy": -5, "housing": 23, "welfare": 25, "security": 16, "environment": 1}	SNS	{성장,안전,혁신}	경기도에 거주하는 60-69 서비스직. 정치 성향은 중도이며 성장, 안전, 혁신 가치를 중시한다.	{"brandLoyalty": 71, "noveltySeeking": 48, "ecoConsciousness": 66, "priceSensitivity": 71, "digitalConsumption": 72}	{"taxTolerance": 38, "governmentTrust": 65, "policyAcceptance": 52, "regulationPreference": 57, "publicServiceSatisfaction": 60}	0
1607	홍건우	66	60-69	Female	경기도	37.413959	127.528364	전문대 졸	200만원 미만	전문직	부부 가구	-39	진보 성향 무당층	94	{"economy": -20, "housing": 27, "welfare": 41, "security": -19, "environment": 38}	포털 뉴스	{안정,공동체,혁신}	경기도에 거주하는 60-69 전문직. 정치 성향은 진보이며 안정, 공동체, 혁신 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 46, "ecoConsciousness": 49, "priceSensitivity": 74, "digitalConsumption": 59}	{"taxTolerance": 65, "governmentTrust": 38, "policyAcceptance": 61, "regulationPreference": 66, "publicServiceSatisfaction": 48}	0
1608	안성호	61	60-69	Female	경기도	37.460545	127.470176	고졸 이하	200-350만원	사무직	다세대 가구	7	중도 무당층	99	{"economy": -28, "housing": 22, "welfare": -6, "security": 1, "environment": -13}	지상파/종편 뉴스	{전통,공정,안정}	경기도에 거주하는 60-69 사무직. 정치 성향은 중도이며 전통, 공정, 안정 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 50, "ecoConsciousness": 41, "priceSensitivity": 81, "digitalConsumption": 73}	{"taxTolerance": 47, "governmentTrust": 55, "policyAcceptance": 51, "regulationPreference": 73, "publicServiceSatisfaction": 60}	0
1609	박은우	67	60-69	Female	경기도	37.429443	127.503009	전문대 졸	200-350만원	은퇴	다세대 가구	22	보수 성향 무당층	84	{"economy": 27, "housing": 12, "welfare": 17, "security": 21, "environment": -2}	SNS	{안정,공정,자유}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 안정, 공정, 자유 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 67, "ecoConsciousness": 42, "priceSensitivity": 53, "digitalConsumption": 53}	{"taxTolerance": 44, "governmentTrust": 54, "policyAcceptance": 50, "regulationPreference": 70, "publicServiceSatisfaction": 55}	0
1610	송예준	69	60-69	Female	경기도	37.394114	127.476085	고졸 이하	350-500만원	은퇴	다세대 가구	8	중도 무당층	80	{"economy": 11, "housing": 29, "welfare": 22, "security": -1, "environment": 18}	지상파/종편 뉴스	{환경,안정,공정}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 환경, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 74, "noveltySeeking": 41, "ecoConsciousness": 32, "priceSensitivity": 58, "digitalConsumption": 70}	{"taxTolerance": 41, "governmentTrust": 56, "policyAcceptance": 61, "regulationPreference": 77, "publicServiceSatisfaction": 43}	0
1611	최도윤	69	60-69	Female	경기도	37.369153	127.506705	대학교 졸	200만원 미만	은퇴	부부 가구	10	중도 무당층	56	{"economy": -45, "housing": 43, "welfare": 3, "security": 12, "environment": 42}	신문/팟캐스트	{전통,다양성,공정}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 전통, 다양성, 공정 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 63, "ecoConsciousness": 40, "priceSensitivity": 79, "digitalConsumption": 70}	{"taxTolerance": 47, "governmentTrust": 40, "policyAcceptance": 57, "regulationPreference": 69, "publicServiceSatisfaction": 87}	0
1612	서채원	61	60-69	Female	경기도	37.351767	127.597913	대학원 졸	700만원 이상	자영업	자녀 양육 가구	8	중도 무당층	87	{"economy": -12, "housing": 25, "welfare": 25, "security": 11, "environment": 34}	SNS	{성장,다양성,안전}	경기도에 거주하는 60-69 자영업. 정치 성향은 중도이며 성장, 다양성, 안전 가치를 중시한다.	{"brandLoyalty": 64, "noveltySeeking": 55, "ecoConsciousness": 55, "priceSensitivity": 45, "digitalConsumption": 59}	{"taxTolerance": 47, "governmentTrust": 58, "policyAcceptance": 56, "regulationPreference": 65, "publicServiceSatisfaction": 63}	0
1613	장건우	60	60-69	Female	경기도	37.370215	127.462085	대학교 졸	500-700만원	은퇴	자녀 양육 가구	-14	중도 무당층	76	{"economy": -17, "housing": 21, "welfare": 0, "security": -21, "environment": 27}	SNS	{혁신,자유,안전}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 혁신, 자유, 안전 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 29, "ecoConsciousness": 51, "priceSensitivity": 87, "digitalConsumption": 61}	{"taxTolerance": 45, "governmentTrust": 51, "policyAcceptance": 37, "regulationPreference": 64, "publicServiceSatisfaction": 67}	0
1614	신은우	68	60-69	Female	경기도	37.48633	127.500357	전문대 졸	350-500만원	은퇴	자녀 양육 가구	22	보수 성향 무당층	68	{"economy": 10, "housing": 2, "welfare": 6, "security": 25, "environment": 18}	유튜브	{환경,안정,성장}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 환경, 안정, 성장 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 57, "ecoConsciousness": 43, "priceSensitivity": 75, "digitalConsumption": 60}	{"taxTolerance": 44, "governmentTrust": 62, "policyAcceptance": 46, "regulationPreference": 68, "publicServiceSatisfaction": 51}	0
1615	김지호	69	60-69	Male	경기도	37.446523	127.509779	고졸 이하	200-350만원	은퇴	다세대 가구	23	보수 성향 무당층	79	{"economy": 19, "housing": -5, "welfare": -4, "security": -11, "environment": -1}	유튜브	{환경,성장,공정}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 환경, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 64, "noveltySeeking": 62, "ecoConsciousness": 35, "priceSensitivity": 77, "digitalConsumption": 61}	{"taxTolerance": 52, "governmentTrust": 66, "policyAcceptance": 50, "regulationPreference": 67, "publicServiceSatisfaction": 50}	0
1616	류영수	62	60-69	Male	경기도	37.335682	127.609517	고졸 이하	200-350만원	은퇴	1인 가구	-8	중도 무당층	86	{"economy": -30, "housing": 16, "welfare": -2, "security": 5, "environment": 19}	포털 뉴스	{안정,공동체,전통}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 안정, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 40, "ecoConsciousness": 44, "priceSensitivity": 82, "digitalConsumption": 67}	{"taxTolerance": 51, "governmentTrust": 52, "policyAcceptance": 60, "regulationPreference": 60, "publicServiceSatisfaction": 63}	0
1617	황도윤	61	60-69	Male	경기도	37.385428	127.513454	대학원 졸	500-700만원	주부	다세대 가구	7	중도 무당층	47	{"economy": -5, "housing": 45, "welfare": 12, "security": -12, "environment": 22}	유튜브	{공정,자유,안정}	경기도에 거주하는 60-69 주부. 정치 성향은 중도이며 공정, 자유, 안정 가치를 중시한다.	{"brandLoyalty": 69, "noveltySeeking": 45, "ecoConsciousness": 61, "priceSensitivity": 73, "digitalConsumption": 70}	{"taxTolerance": 44, "governmentTrust": 38, "policyAcceptance": 43, "regulationPreference": 54, "publicServiceSatisfaction": 68}	0
1618	오동현	60	60-69	Male	경기도	37.444922	127.450558	대학원 졸	200-350만원	공무원	부부 가구	36	보수 성향 무당층	52	{"economy": 48, "housing": -16, "welfare": 19, "security": 28, "environment": -19}	신문/팟캐스트	{안전,공동체,성장}	경기도에 거주하는 60-69 공무원. 정치 성향은 보수이며 안전, 공동체, 성장 가치를 중시한다.	{"brandLoyalty": 71, "noveltySeeking": 54, "ecoConsciousness": 66, "priceSensitivity": 77, "digitalConsumption": 77}	{"taxTolerance": 59, "governmentTrust": 36, "policyAcceptance": 33, "regulationPreference": 67, "publicServiceSatisfaction": 77}	0
1619	류지우	63	60-69	Male	경기도	37.339602	127.574195	대학교 졸	350-500만원	은퇴	자녀 양육 가구	10	중도 무당층	78	{"economy": 6, "housing": 9, "welfare": 14, "security": 14, "environment": -1}	포털 뉴스	{공동체,공정,혁신}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 공동체, 공정, 혁신 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 56, "ecoConsciousness": 57, "priceSensitivity": 50, "digitalConsumption": 71}	{"taxTolerance": 49, "governmentTrust": 33, "policyAcceptance": 35, "regulationPreference": 61, "publicServiceSatisfaction": 57}	0
1620	송수아	61	60-69	Male	경기도	37.430505	127.544661	대학교 졸	350-500만원	학생	1인 가구	24	보수 성향 무당층	83	{"economy": 21, "housing": -6, "welfare": 11, "security": 46, "environment": -8}	SNS	{혁신,환경,전통}	경기도에 거주하는 60-69 학생. 정치 성향은 중도이며 혁신, 환경, 전통 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 59, "ecoConsciousness": 39, "priceSensitivity": 67, "digitalConsumption": 65}	{"taxTolerance": 38, "governmentTrust": 49, "policyAcceptance": 55, "regulationPreference": 65, "publicServiceSatisfaction": 67}	0
1621	조민서	69	60-69	Male	경기도	37.382165	127.473347	대학원 졸	200-350만원	은퇴	자녀 양육 가구	30	보수 성향 무당층	85	{"economy": 12, "housing": 46, "welfare": -10, "security": 32, "environment": 21}	지상파/종편 뉴스	{안전,공정,성장}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 안전, 공정, 성장 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 35, "ecoConsciousness": 68, "priceSensitivity": 57, "digitalConsumption": 71}	{"taxTolerance": 41, "governmentTrust": 67, "policyAcceptance": 73, "regulationPreference": 52, "publicServiceSatisfaction": 59}	0
1622	윤지민	68	60-69	Male	경기도	37.457399	127.461967	대학교 졸	200만원 미만	은퇴	다세대 가구	22	보수 성향 무당층	88	{"economy": -2, "housing": 8, "welfare": -9, "security": 16, "environment": 12}	SNS	{환경,혁신,성장}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 환경, 혁신, 성장 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 37, "ecoConsciousness": 39, "priceSensitivity": 94, "digitalConsumption": 59}	{"taxTolerance": 12, "governmentTrust": 60, "policyAcceptance": 33, "regulationPreference": 69, "publicServiceSatisfaction": 63}	0
1623	이채원	66	60-69	Male	경기도	37.446079	127.493527	대학원 졸	200만원 미만	서비스직	자녀 양육 가구	27	보수 성향 무당층	92	{"economy": -11, "housing": 11, "welfare": 19, "security": 3, "environment": 34}	지상파/종편 뉴스	{안정,혁신,성장}	경기도에 거주하는 60-69 서비스직. 정치 성향은 중도이며 안정, 혁신, 성장 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 57, "ecoConsciousness": 41, "priceSensitivity": 61, "digitalConsumption": 71}	{"taxTolerance": 26, "governmentTrust": 35, "policyAcceptance": 49, "regulationPreference": 64, "publicServiceSatisfaction": 50}	0
1624	권준서	62	60-69	Male	경기도	37.441823	127.601741	전문대 졸	500-700만원	생산직	자녀 양육 가구	-21	진보 성향 무당층	88	{"economy": -9, "housing": 37, "welfare": 9, "security": -12, "environment": 31}	SNS	{자유,안전,공동체}	경기도에 거주하는 60-69 생산직. 정치 성향은 중도이며 자유, 안전, 공동체 가치를 중시한다.	{"brandLoyalty": 64, "noveltySeeking": 38, "ecoConsciousness": 56, "priceSensitivity": 57, "digitalConsumption": 62}	{"taxTolerance": 59, "governmentTrust": 73, "policyAcceptance": 68, "regulationPreference": 56, "publicServiceSatisfaction": 50}	0
1625	박주원	63	60-69	Male	경기도	37.405557	127.420828	대학교 졸	200-350만원	전문직	부부 가구	2	중도 무당층	77	{"economy": 27, "housing": 19, "welfare": 0, "security": 16, "environment": 13}	SNS	{전통,안전,공정}	경기도에 거주하는 60-69 전문직. 정치 성향은 중도이며 전통, 안전, 공정 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 42, "ecoConsciousness": 48, "priceSensitivity": 68, "digitalConsumption": 64}	{"taxTolerance": 64, "governmentTrust": 37, "policyAcceptance": 55, "regulationPreference": 44, "publicServiceSatisfaction": 64}	0
1626	정순자	66	60-69	Male	경기도	37.4557	127.441364	대학교 졸	350-500만원	학생	자녀 양육 가구	32	보수 성향 무당층	90	{"economy": -14, "housing": 16, "welfare": 4, "security": 37, "environment": 16}	포털 뉴스	{환경,전통,공정}	경기도에 거주하는 60-69 학생. 정치 성향은 중도이며 환경, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 57, "ecoConsciousness": 56, "priceSensitivity": 68, "digitalConsumption": 55}	{"taxTolerance": 43, "governmentTrust": 49, "policyAcceptance": 35, "regulationPreference": 55, "publicServiceSatisfaction": 62}	0
1627	최서윤	66	60-69	Male	경기도	37.39098	127.572413	고졸 이하	200만원 미만	학생	다세대 가구	23	보수 성향 무당층	70	{"economy": 14, "housing": 14, "welfare": -7, "security": 3, "environment": -12}	SNS	{전통,자유,환경}	경기도에 거주하는 60-69 학생. 정치 성향은 중도이며 전통, 자유, 환경 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 51, "ecoConsciousness": 58, "priceSensitivity": 67, "digitalConsumption": 66}	{"taxTolerance": 54, "governmentTrust": 57, "policyAcceptance": 55, "regulationPreference": 56, "publicServiceSatisfaction": 77}	0
1628	김다은	68	60-69	Male	경기도	37.46881	127.441519	대학원 졸	200만원 미만	은퇴	1인 가구	16	보수 성향 무당층	77	{"economy": -6, "housing": -1, "welfare": -2, "security": 24, "environment": 18}	지상파/종편 뉴스	{공정,다양성,공동체}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 공정, 다양성, 공동체 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 56, "ecoConsciousness": 49, "priceSensitivity": 95, "digitalConsumption": 54}	{"taxTolerance": 46, "governmentTrust": 44, "policyAcceptance": 56, "regulationPreference": 64, "publicServiceSatisfaction": 60}	0
1629	박예준	63	60-69	Male	경기도	37.360878	127.524114	대학교 졸	200-350만원	학생	자녀 양육 가구	42	보수 성향 무당층	77	{"economy": 7, "housing": 9, "welfare": -16, "security": 31, "environment": -2}	지상파/종편 뉴스	{전통,자유,혁신}	경기도에 거주하는 60-69 학생. 정치 성향은 보수이며 전통, 자유, 혁신 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 50, "ecoConsciousness": 55, "priceSensitivity": 71, "digitalConsumption": 56}	{"taxTolerance": 37, "governmentTrust": 48, "policyAcceptance": 57, "regulationPreference": 50, "publicServiceSatisfaction": 58}	0
1630	김혜진	68	60-69	Male	경기도	37.442106	127.502261	대학교 졸	200만원 미만	은퇴	부부 가구	43	보수 성향 무당층	78	{"economy": 34, "housing": 19, "welfare": -26, "security": 8, "environment": -12}	지상파/종편 뉴스	{공동체,전통,환경}	경기도에 거주하는 60-69 은퇴. 정치 성향은 보수이며 공동체, 전통, 환경 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 51, "ecoConsciousness": 55, "priceSensitivity": 76, "digitalConsumption": 61}	{"taxTolerance": 45, "governmentTrust": 59, "policyAcceptance": 41, "regulationPreference": 64, "publicServiceSatisfaction": 49}	0
1631	황하은	63	60-69	Male	경기도	37.397175	127.537998	대학원 졸	500-700만원	사무직	다세대 가구	56	보수 정당 지지	73	{"economy": 31, "housing": -17, "welfare": -24, "security": 72, "environment": 10}	유튜브	{공동체,전통,성장}	경기도에 거주하는 60-69 사무직. 정치 성향은 보수이며 공동체, 전통, 성장 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 64, "ecoConsciousness": 58, "priceSensitivity": 46, "digitalConsumption": 71}	{"taxTolerance": 58, "governmentTrust": 65, "policyAcceptance": 60, "regulationPreference": 68, "publicServiceSatisfaction": 58}	0
1632	신현우	64	60-69	Male	경기도	37.414877	127.608382	고졸 이하	350-500만원	생산직	부부 가구	13	중도 무당층	81	{"economy": 5, "housing": -2, "welfare": 23, "security": 8, "environment": 41}	포털 뉴스	{안정,공동체,환경}	경기도에 거주하는 60-69 생산직. 정치 성향은 중도이며 안정, 공동체, 환경 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 47, "ecoConsciousness": 37, "priceSensitivity": 53, "digitalConsumption": 53}	{"taxTolerance": 37, "governmentTrust": 46, "policyAcceptance": 40, "regulationPreference": 49, "publicServiceSatisfaction": 59}	0
1633	신정희	79	70+	Female	경기도	37.389118	127.542331	전문대 졸	350-500만원	은퇴	1인 가구	63	보수 정당 지지	84	{"economy": 39, "housing": -30, "welfare": -14, "security": 48, "environment": -24}	포털 뉴스	{성장,환경,안정}	경기도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 성장, 환경, 안정 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 67, "ecoConsciousness": 45, "priceSensitivity": 84, "digitalConsumption": 54}	{"taxTolerance": 21, "governmentTrust": 72, "policyAcceptance": 35, "regulationPreference": 59, "publicServiceSatisfaction": 63}	0
1634	오동현	71	70+	Female	경기도	37.43068	127.589181	전문대 졸	200-350만원	은퇴	부부 가구	32	보수 성향 무당층	58	{"economy": -5, "housing": 3, "welfare": 4, "security": 21, "environment": 8}	SNS	{자유,성장,안정}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 자유, 성장, 안정 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 43, "ecoConsciousness": 42, "priceSensitivity": 58, "digitalConsumption": 52}	{"taxTolerance": 34, "governmentTrust": 54, "policyAcceptance": 56, "regulationPreference": 51, "publicServiceSatisfaction": 64}	0
1635	김광수	83	70+	Female	경기도	37.478217	127.574654	전문대 졸	350-500만원	은퇴	자녀 양육 가구	26	보수 성향 무당층	99	{"economy": 11, "housing": -1, "welfare": 20, "security": 16, "environment": -3}	지상파/종편 뉴스	{다양성,공정,안정}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 다양성, 공정, 안정 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 43, "ecoConsciousness": 58, "priceSensitivity": 84, "digitalConsumption": 59}	{"taxTolerance": 56, "governmentTrust": 51, "policyAcceptance": 50, "regulationPreference": 62, "publicServiceSatisfaction": 55}	0
1636	류순자	82	70+	Female	경기도	37.362955	127.616628	대학교 졸	200-350만원	은퇴	1인 가구	5	중도 무당층	82	{"economy": 10, "housing": 41, "welfare": -20, "security": 14, "environment": -1}	지상파/종편 뉴스	{공동체,환경,다양성}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공동체, 환경, 다양성 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 39, "ecoConsciousness": 43, "priceSensitivity": 59, "digitalConsumption": 57}	{"taxTolerance": 35, "governmentTrust": 59, "policyAcceptance": 71, "regulationPreference": 46, "publicServiceSatisfaction": 55}	0
1637	홍다은	81	70+	Female	경기도	37.343382	127.435754	대학교 졸	200-350만원	은퇴	다세대 가구	34	보수 성향 무당층	97	{"economy": -19, "housing": 8, "welfare": -5, "security": 24, "environment": 37}	지상파/종편 뉴스	{전통,공동체,안전}	경기도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 전통, 공동체, 안전 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 48, "ecoConsciousness": 35, "priceSensitivity": 64, "digitalConsumption": 70}	{"taxTolerance": 21, "governmentTrust": 55, "policyAcceptance": 61, "regulationPreference": 55, "publicServiceSatisfaction": 76}	0
1638	최서연	71	70+	Female	경기도	37.477186	127.538062	고졸 이하	350-500만원	은퇴	1인 가구	2	중도 무당층	88	{"economy": -2, "housing": 4, "welfare": 8, "security": 18, "environment": 42}	유튜브	{성장,안정,안전}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 성장, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 54, "ecoConsciousness": 50, "priceSensitivity": 57, "digitalConsumption": 57}	{"taxTolerance": 45, "governmentTrust": 58, "policyAcceptance": 47, "regulationPreference": 73, "publicServiceSatisfaction": 78}	0
1639	김광수	75	70+	Female	경기도	37.357191	127.48505	대학교 졸	700만원 이상	은퇴	자녀 양육 가구	14	중도 무당층	71	{"economy": 10, "housing": 27, "welfare": -6, "security": 29, "environment": -18}	신문/팟캐스트	{공정,안전,성장}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공정, 안전, 성장 가치를 중시한다.	{"brandLoyalty": 66, "noveltySeeking": 68, "ecoConsciousness": 33, "priceSensitivity": 43, "digitalConsumption": 44}	{"taxTolerance": 47, "governmentTrust": 51, "policyAcceptance": 57, "regulationPreference": 68, "publicServiceSatisfaction": 64}	0
1640	한민준	77	70+	Female	경기도	37.347596	127.54635	고졸 이하	200-350만원	은퇴	자녀 양육 가구	16	보수 성향 무당층	99	{"economy": 1, "housing": 4, "welfare": -1, "security": 18, "environment": 19}	유튜브	{안정,성장,자유}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안정, 성장, 자유 가치를 중시한다.	{"brandLoyalty": 64, "noveltySeeking": 37, "ecoConsciousness": 45, "priceSensitivity": 83, "digitalConsumption": 63}	{"taxTolerance": 40, "governmentTrust": 56, "policyAcceptance": 66, "regulationPreference": 71, "publicServiceSatisfaction": 74}	0
1641	장미경	78	70+	Female	경기도	37.393796	127.546837	고졸 이하	350-500만원	은퇴	1인 가구	63	보수 정당 지지	98	{"economy": 47, "housing": 19, "welfare": -44, "security": 28, "environment": 2}	지상파/종편 뉴스	{안정,혁신,성장}	경기도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안정, 혁신, 성장 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 27, "ecoConsciousness": 37, "priceSensitivity": 63, "digitalConsumption": 47}	{"taxTolerance": 27, "governmentTrust": 51, "policyAcceptance": 38, "regulationPreference": 75, "publicServiceSatisfaction": 66}	0
1642	김영수	84	70+	Female	경기도	37.463034	127.566215	전문대 졸	500-700만원	은퇴	1인 가구	25	보수 성향 무당층	77	{"economy": -21, "housing": 29, "welfare": -4, "security": 47, "environment": 36}	지상파/종편 뉴스	{공동체,환경,성장}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공동체, 환경, 성장 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 34, "ecoConsciousness": 37, "priceSensitivity": 63, "digitalConsumption": 61}	{"taxTolerance": 45, "governmentTrust": 47, "policyAcceptance": 61, "regulationPreference": 46, "publicServiceSatisfaction": 57}	0
1643	송성호	76	70+	Female	경기도	37.479675	127.478361	전문대 졸	200-350만원	은퇴	다세대 가구	-11	중도 무당층	87	{"economy": -13, "housing": 50, "welfare": 21, "security": -11, "environment": 21}	지상파/종편 뉴스	{성장,안전,다양성}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 성장, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 34, "ecoConsciousness": 44, "priceSensitivity": 72, "digitalConsumption": 52}	{"taxTolerance": 46, "governmentTrust": 37, "policyAcceptance": 45, "regulationPreference": 76, "publicServiceSatisfaction": 58}	0
1644	최철수	76	70+	Female	경기도	37.472975	127.461507	대학교 졸	200만원 미만	은퇴	다세대 가구	12	중도 무당층	86	{"economy": 7, "housing": -2, "welfare": 4, "security": 42, "environment": 6}	유튜브	{공정,공동체,안정}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공정, 공동체, 안정 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 44, "ecoConsciousness": 50, "priceSensitivity": 67, "digitalConsumption": 56}	{"taxTolerance": 64, "governmentTrust": 53, "policyAcceptance": 41, "regulationPreference": 77, "publicServiceSatisfaction": 57}	0
1645	장서윤	79	70+	Female	경기도	37.49321	127.503374	대학교 졸	350-500만원	은퇴	1인 가구	65	보수 정당 지지	92	{"economy": 48, "housing": -7, "welfare": -5, "security": 42, "environment": -11}	포털 뉴스	{환경,안전,공동체}	경기도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 환경, 안전, 공동체 가치를 중시한다.	{"brandLoyalty": 68, "noveltySeeking": 30, "ecoConsciousness": 44, "priceSensitivity": 57, "digitalConsumption": 72}	{"taxTolerance": 43, "governmentTrust": 70, "policyAcceptance": 49, "regulationPreference": 55, "publicServiceSatisfaction": 82}	0
1646	오동현	76	70+	Female	경기도	37.359746	127.548732	대학교 졸	200-350만원	은퇴	자녀 양육 가구	33	보수 성향 무당층	72	{"economy": -7, "housing": -8, "welfare": -31, "security": 11, "environment": 0}	지상파/종편 뉴스	{공동체,안전,다양성}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공동체, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 60, "ecoConsciousness": 34, "priceSensitivity": 88, "digitalConsumption": 48}	{"taxTolerance": 48, "governmentTrust": 53, "policyAcceptance": 46, "regulationPreference": 53, "publicServiceSatisfaction": 79}	0
1647	송지민	71	70+	Female	경기도	37.380321	127.564832	대학교 졸	200만원 미만	은퇴	다세대 가구	37	보수 성향 무당층	86	{"economy": 30, "housing": -3, "welfare": -25, "security": 55, "environment": 15}	지상파/종편 뉴스	{전통,공정,혁신}	경기도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 전통, 공정, 혁신 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 60, "ecoConsciousness": 38, "priceSensitivity": 100, "digitalConsumption": 38}	{"taxTolerance": 44, "governmentTrust": 40, "policyAcceptance": 66, "regulationPreference": 59, "publicServiceSatisfaction": 84}	0
1648	이서윤	83	70+	Male	경기도	37.467481	127.604987	대학원 졸	350-500만원	은퇴	다세대 가구	11	중도 무당층	99	{"economy": -16, "housing": 20, "welfare": -12, "security": 12, "environment": 35}	지상파/종편 뉴스	{환경,공정,안전}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 환경, 공정, 안전 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 44, "ecoConsciousness": 49, "priceSensitivity": 69, "digitalConsumption": 59}	{"taxTolerance": 38, "governmentTrust": 53, "policyAcceptance": 48, "regulationPreference": 59, "publicServiceSatisfaction": 50}	0
1649	윤서연	70	70+	Male	경기도	37.444214	127.510948	대학교 졸	350-500만원	은퇴	다세대 가구	16	보수 성향 무당층	69	{"economy": 18, "housing": 0, "welfare": -19, "security": 19, "environment": -8}	신문/팟캐스트	{안전,안정,혁신}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안전, 안정, 혁신 가치를 중시한다.	{"brandLoyalty": 72, "noveltySeeking": 59, "ecoConsciousness": 49, "priceSensitivity": 58, "digitalConsumption": 48}	{"taxTolerance": 37, "governmentTrust": 29, "policyAcceptance": 52, "regulationPreference": 61, "publicServiceSatisfaction": 82}	0
1650	정경숙	84	70+	Male	경기도	37.484932	127.594828	전문대 졸	350-500만원	은퇴	부부 가구	45	보수 정당 지지	86	{"economy": 1, "housing": -9, "welfare": 12, "security": 11, "environment": -9}	SNS	{성장,혁신,공동체}	경기도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 성장, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 43, "ecoConsciousness": 57, "priceSensitivity": 79, "digitalConsumption": 49}	{"taxTolerance": 42, "governmentTrust": 52, "policyAcceptance": 64, "regulationPreference": 50, "publicServiceSatisfaction": 47}	0
1651	송지호	75	70+	Male	경기도	37.341468	127.45502	대학교 졸	200만원 미만	은퇴	1인 가구	-8	중도 무당층	90	{"economy": -27, "housing": 12, "welfare": -22, "security": 15, "environment": 18}	지상파/종편 뉴스	{공동체,안전,안정}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공동체, 안전, 안정 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 58, "ecoConsciousness": 49, "priceSensitivity": 76, "digitalConsumption": 73}	{"taxTolerance": 44, "governmentTrust": 45, "policyAcceptance": 63, "regulationPreference": 70, "publicServiceSatisfaction": 60}	0
1652	황현우	81	70+	Male	경기도	37.361629	127.480394	고졸 이하	350-500만원	은퇴	자녀 양육 가구	71	보수 정당 지지	75	{"economy": 40, "housing": -17, "welfare": -24, "security": 39, "environment": -23}	SNS	{안전,혁신,공동체}	경기도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안전, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 67, "noveltySeeking": 27, "ecoConsciousness": 49, "priceSensitivity": 50, "digitalConsumption": 62}	{"taxTolerance": 43, "governmentTrust": 60, "policyAcceptance": 46, "regulationPreference": 59, "publicServiceSatisfaction": 60}	0
1653	정광수	74	70+	Male	경기도	37.384687	127.611433	대학교 졸	200만원 미만	은퇴	부부 가구	1	중도 무당층	74	{"economy": 17, "housing": 24, "welfare": 20, "security": 38, "environment": 14}	지상파/종편 뉴스	{공동체,공정,자유}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공동체, 공정, 자유 가치를 중시한다.	{"brandLoyalty": 68, "noveltySeeking": 51, "ecoConsciousness": 43, "priceSensitivity": 70, "digitalConsumption": 57}	{"taxTolerance": 45, "governmentTrust": 47, "policyAcceptance": 58, "regulationPreference": 52, "publicServiceSatisfaction": 51}	0
1654	조건우	76	70+	Male	경기도	37.396838	127.490558	전문대 졸	700만원 이상	은퇴	다세대 가구	15	보수 성향 무당층	72	{"economy": -13, "housing": 30, "welfare": 17, "security": 24, "environment": 25}	유튜브	{다양성,성장,공정}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 다양성, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 30, "ecoConsciousness": 57, "priceSensitivity": 59, "digitalConsumption": 71}	{"taxTolerance": 42, "governmentTrust": 47, "policyAcceptance": 38, "regulationPreference": 60, "publicServiceSatisfaction": 71}	0
1655	한주원	81	70+	Male	경기도	37.406825	127.441445	전문대 졸	200만원 미만	은퇴	부부 가구	75	보수 정당 지지	99	{"economy": 47, "housing": -13, "welfare": -22, "security": 56, "environment": 13}	포털 뉴스	{혁신,안전,환경}	경기도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 혁신, 안전, 환경 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 34, "ecoConsciousness": 44, "priceSensitivity": 65, "digitalConsumption": 50}	{"taxTolerance": 35, "governmentTrust": 54, "policyAcceptance": 64, "regulationPreference": 59, "publicServiceSatisfaction": 41}	0
1656	류은우	79	70+	Male	경기도	37.424003	127.556125	대학원 졸	200-350만원	은퇴	자녀 양육 가구	54	보수 정당 지지	85	{"economy": 28, "housing": -1, "welfare": -21, "security": 53, "environment": -8}	유튜브	{성장,안전,전통}	경기도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 성장, 안전, 전통 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 54, "ecoConsciousness": 38, "priceSensitivity": 63, "digitalConsumption": 71}	{"taxTolerance": 44, "governmentTrust": 55, "policyAcceptance": 44, "regulationPreference": 58, "publicServiceSatisfaction": 71}	0
1657	정철수	74	70+	Male	경기도	37.391651	127.555277	대학교 졸	350-500만원	은퇴	1인 가구	18	보수 성향 무당층	83	{"economy": 11, "housing": 27, "welfare": -10, "security": 30, "environment": 35}	신문/팟캐스트	{공동체,자유,성장}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공동체, 자유, 성장 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 29, "ecoConsciousness": 39, "priceSensitivity": 66, "digitalConsumption": 44}	{"taxTolerance": 37, "governmentTrust": 55, "policyAcceptance": 61, "regulationPreference": 84, "publicServiceSatisfaction": 52}	0
1658	안예준	78	70+	Male	경기도	37.390334	127.615315	대학교 졸	200만원 미만	은퇴	다세대 가구	14	중도 무당층	94	{"economy": 13, "housing": 18, "welfare": -14, "security": -5, "environment": -17}	신문/팟캐스트	{공정,전통,안정}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공정, 전통, 안정 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 60, "ecoConsciousness": 23, "priceSensitivity": 77, "digitalConsumption": 63}	{"taxTolerance": 55, "governmentTrust": 49, "policyAcceptance": 49, "regulationPreference": 55, "publicServiceSatisfaction": 64}	0
1659	임지민	84	70+	Male	경기도	37.42244	127.594016	대학교 졸	700만원 이상	은퇴	다세대 가구	25	보수 성향 무당층	99	{"economy": -8, "housing": 16, "welfare": -5, "security": 37, "environment": 33}	지상파/종편 뉴스	{전통,공정,자유}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 전통, 공정, 자유 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 44, "ecoConsciousness": 38, "priceSensitivity": 47, "digitalConsumption": 50}	{"taxTolerance": 35, "governmentTrust": 56, "policyAcceptance": 50, "regulationPreference": 69, "publicServiceSatisfaction": 49}	0
1660	장민서	81	70+	Male	경기도	37.484373	127.554494	전문대 졸	350-500만원	은퇴	부부 가구	40	보수 성향 무당층	99	{"economy": 18, "housing": 9, "welfare": 6, "security": 39, "environment": 21}	SNS	{공정,전통,환경}	경기도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 공정, 전통, 환경 가치를 중시한다.	{"brandLoyalty": 68, "noveltySeeking": 55, "ecoConsciousness": 41, "priceSensitivity": 46, "digitalConsumption": 52}	{"taxTolerance": 53, "governmentTrust": 49, "policyAcceptance": 59, "regulationPreference": 65, "publicServiceSatisfaction": 63}	0
1661	전예준	71	70+	Male	경기도	37.33717	127.600726	전문대 졸	200-350만원	은퇴	자녀 양육 가구	-1	중도 무당층	60	{"economy": -13, "housing": -7, "welfare": 19, "security": -24, "environment": 7}	포털 뉴스	{다양성,성장,안정}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 다양성, 성장, 안정 가치를 중시한다.	{"brandLoyalty": 61, "noveltySeeking": 57, "ecoConsciousness": 41, "priceSensitivity": 58, "digitalConsumption": 66}	{"taxTolerance": 52, "governmentTrust": 45, "policyAcceptance": 43, "regulationPreference": 64, "publicServiceSatisfaction": 66}	0
1662	조지아	76	70+	Male	경기도	37.350794	127.446818	전문대 졸	350-500만원	은퇴	1인 가구	32	보수 성향 무당층	69	{"economy": 23, "housing": 8, "welfare": -14, "security": -10, "environment": 6}	신문/팟캐스트	{공동체,공정,자유}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공동체, 공정, 자유 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 41, "ecoConsciousness": 36, "priceSensitivity": 79, "digitalConsumption": 51}	{"taxTolerance": 35, "governmentTrust": 59, "policyAcceptance": 40, "regulationPreference": 82, "publicServiceSatisfaction": 46}	0
1663	신수아	26	18-29	Female	충청북도	36.559723	127.396552	전문대 졸	200-350만원	전문직	부부 가구	14	중도 무당층	72	{"economy": -11, "housing": 29, "welfare": -11, "security": 7, "environment": -1}	신문/팟캐스트	{성장,혁신,공정}	충청북도에 거주하는 18-29 전문직. 정치 성향은 중도이며 성장, 혁신, 공정 가치를 중시한다.	{"brandLoyalty": 22, "noveltySeeking": 52, "ecoConsciousness": 52, "priceSensitivity": 43, "digitalConsumption": 99}	{"taxTolerance": 58, "governmentTrust": 39, "policyAcceptance": 33, "regulationPreference": 56, "publicServiceSatisfaction": 79}	0
1664	박서연	22	18-29	Female	충청북도	36.692938	127.578738	전문대 졸	200-350만원	학생	자녀 양육 가구	9	중도 무당층	45	{"economy": 23, "housing": -13, "welfare": 1, "security": 20, "environment": -8}	포털 뉴스	{공동체,혁신,자유}	충청북도에 거주하는 18-29 학생. 정치 성향은 중도이며 공동체, 혁신, 자유 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 69, "ecoConsciousness": 51, "priceSensitivity": 79, "digitalConsumption": 91}	{"taxTolerance": 56, "governmentTrust": 47, "policyAcceptance": 43, "regulationPreference": 65, "publicServiceSatisfaction": 72}	0
1665	권서연	23	18-29	Male	충청북도	36.614953	127.52649	대학교 졸	500-700만원	학생	자녀 양육 가구	7	중도 무당층	58	{"economy": 10, "housing": 18, "welfare": -3, "security": -1, "environment": -1}	신문/팟캐스트	{공동체,혁신,성장}	충청북도에 거주하는 18-29 학생. 정치 성향은 중도이며 공동체, 혁신, 성장 가치를 중시한다.	{"brandLoyalty": 17, "noveltySeeking": 64, "ecoConsciousness": 52, "priceSensitivity": 63, "digitalConsumption": 67}	{"taxTolerance": 58, "governmentTrust": 35, "policyAcceptance": 53, "regulationPreference": 62, "publicServiceSatisfaction": 60}	0
1666	윤은우	29	18-29	Male	충청북도	36.585261	127.436597	고졸 이하	350-500만원	은퇴	부부 가구	-10	중도 무당층	54	{"economy": -18, "housing": 0, "welfare": 16, "security": 7, "environment": 33}	신문/팟캐스트	{전통,안정,자유}	충청북도에 거주하는 18-29 은퇴. 정치 성향은 중도이며 전통, 안정, 자유 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 61, "ecoConsciousness": 34, "priceSensitivity": 75, "digitalConsumption": 80}	{"taxTolerance": 45, "governmentTrust": 53, "policyAcceptance": 29, "regulationPreference": 52, "publicServiceSatisfaction": 65}	0
1667	오서윤	30	30-39	Female	충청북도	36.666534	127.472588	대학원 졸	500-700만원	프리랜서	다세대 가구	-12	중도 무당층	53	{"economy": -25, "housing": 28, "welfare": -1, "security": 14, "environment": 20}	SNS	{환경,성장,안정}	충청북도에 거주하는 30-39 프리랜서. 정치 성향은 중도이며 환경, 성장, 안정 가치를 중시한다.	{"brandLoyalty": 15, "noveltySeeking": 76, "ecoConsciousness": 73, "priceSensitivity": 57, "digitalConsumption": 82}	{"taxTolerance": 54, "governmentTrust": 53, "policyAcceptance": 41, "regulationPreference": 44, "publicServiceSatisfaction": 72}	0
1668	신수아	36	30-39	Female	충청북도	36.69353	127.519313	전문대 졸	350-500만원	생산직	자녀 양육 가구	3	중도 무당층	39	{"economy": -16, "housing": 17, "welfare": 33, "security": 1, "environment": 11}	포털 뉴스	{혁신,공정,자유}	충청북도에 거주하는 30-39 생산직. 정치 성향은 중도이며 혁신, 공정, 자유 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 65, "ecoConsciousness": 49, "priceSensitivity": 56, "digitalConsumption": 85}	{"taxTolerance": 32, "governmentTrust": 58, "policyAcceptance": 54, "regulationPreference": 58, "publicServiceSatisfaction": 70}	0
1669	황다은	35	30-39	Male	충청북도	36.564777	127.560064	대학교 졸	700만원 이상	전문직	부부 가구	-26	진보 성향 무당층	55	{"economy": -26, "housing": 14, "welfare": 47, "security": -27, "environment": 43}	SNS	{안정,전통,자유}	충청북도에 거주하는 30-39 전문직. 정치 성향은 중도이며 안정, 전통, 자유 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 42, "ecoConsciousness": 65, "priceSensitivity": 41, "digitalConsumption": 75}	{"taxTolerance": 53, "governmentTrust": 39, "policyAcceptance": 49, "regulationPreference": 65, "publicServiceSatisfaction": 70}	0
1670	강민준	37	30-39	Male	충청북도	36.63793	127.464772	대학교 졸	350-500만원	학생	1인 가구	-8	중도 무당층	62	{"economy": 5, "housing": 13, "welfare": 34, "security": 2, "environment": 24}	SNS	{자유,성장,환경}	충청북도에 거주하는 30-39 학생. 정치 성향은 중도이며 자유, 성장, 환경 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 60, "ecoConsciousness": 57, "priceSensitivity": 67, "digitalConsumption": 71}	{"taxTolerance": 51, "governmentTrust": 57, "policyAcceptance": 37, "regulationPreference": 70, "publicServiceSatisfaction": 72}	0
1671	한예준	44	40-49	Female	충청북도	36.561018	127.419264	고졸 이하	500-700만원	프리랜서	자녀 양육 가구	-31	진보 성향 무당층	67	{"economy": -41, "housing": 35, "welfare": 8, "security": 25, "environment": 32}	신문/팟캐스트	{공정,전통,혁신}	충청북도에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 공정, 전통, 혁신 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 60, "ecoConsciousness": 45, "priceSensitivity": 58, "digitalConsumption": 77}	{"taxTolerance": 39, "governmentTrust": 48, "policyAcceptance": 58, "regulationPreference": 65, "publicServiceSatisfaction": 79}	0
1672	신경숙	48	40-49	Female	충청북도	36.578387	127.50012	대학원 졸	500-700만원	프리랜서	1인 가구	-14	중도 무당층	82	{"economy": -15, "housing": 32, "welfare": 37, "security": -14, "environment": 48}	유튜브	{혁신,전통,공정}	충청북도에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 혁신, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 61, "noveltySeeking": 69, "ecoConsciousness": 63, "priceSensitivity": 56, "digitalConsumption": 63}	{"taxTolerance": 34, "governmentTrust": 31, "policyAcceptance": 49, "regulationPreference": 70, "publicServiceSatisfaction": 71}	0
1673	안주원	49	40-49	Male	충청북도	36.63073	127.427728	고졸 이하	350-500만원	공무원	부부 가구	25	보수 성향 무당층	60	{"economy": -5, "housing": 12, "welfare": -5, "security": 20, "environment": 8}	지상파/종편 뉴스	{자유,공동체,다양성}	충청북도에 거주하는 40-49 공무원. 정치 성향은 중도이며 자유, 공동체, 다양성 가치를 중시한다.	{"brandLoyalty": 64, "noveltySeeking": 58, "ecoConsciousness": 36, "priceSensitivity": 51, "digitalConsumption": 62}	{"taxTolerance": 46, "governmentTrust": 43, "policyAcceptance": 35, "regulationPreference": 56, "publicServiceSatisfaction": 68}	0
1674	김민서	44	40-49	Male	충청북도	36.560006	127.478321	대학교 졸	500-700만원	프리랜서	부부 가구	16	보수 성향 무당층	48	{"economy": 27, "housing": 15, "welfare": 0, "security": 47, "environment": 7}	신문/팟캐스트	{성장,다양성,공정}	충청북도에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 성장, 다양성, 공정 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 64, "ecoConsciousness": 39, "priceSensitivity": 50, "digitalConsumption": 62}	{"taxTolerance": 42, "governmentTrust": 39, "policyAcceptance": 59, "regulationPreference": 67, "publicServiceSatisfaction": 59}	0
1675	전혜진	52	50-59	Female	충청북도	36.556738	127.50841	전문대 졸	200-350만원	학생	자녀 양육 가구	20	보수 성향 무당층	70	{"economy": 34, "housing": 9, "welfare": -3, "security": 5, "environment": 6}	포털 뉴스	{안전,공동체,혁신}	충청북도에 거주하는 50-59 학생. 정치 성향은 중도이며 안전, 공동체, 혁신 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 69, "ecoConsciousness": 34, "priceSensitivity": 68, "digitalConsumption": 66}	{"taxTolerance": 43, "governmentTrust": 32, "policyAcceptance": 40, "regulationPreference": 61, "publicServiceSatisfaction": 75}	0
1676	임혜진	57	50-59	Female	충청북도	36.555717	127.466041	대학교 졸	700만원 이상	사무직	다세대 가구	34	보수 성향 무당층	72	{"economy": 27, "housing": 30, "welfare": 14, "security": 29, "environment": 21}	유튜브	{안정,자유,환경}	충청북도에 거주하는 50-59 사무직. 정치 성향은 보수이며 안정, 자유, 환경 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 63, "ecoConsciousness": 57, "priceSensitivity": 41, "digitalConsumption": 53}	{"taxTolerance": 46, "governmentTrust": 35, "policyAcceptance": 39, "regulationPreference": 59, "publicServiceSatisfaction": 64}	0
1677	송현우	57	50-59	Male	충청북도	36.689654	127.474007	전문대 졸	200-350만원	사무직	1인 가구	-2	중도 무당층	57	{"economy": 16, "housing": 33, "welfare": 6, "security": 15, "environment": 28}	신문/팟캐스트	{다양성,안전,성장}	충청북도에 거주하는 50-59 사무직. 정치 성향은 중도이며 다양성, 안전, 성장 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 45, "ecoConsciousness": 52, "priceSensitivity": 74, "digitalConsumption": 90}	{"taxTolerance": 13, "governmentTrust": 53, "policyAcceptance": 51, "regulationPreference": 84, "publicServiceSatisfaction": 59}	0
1678	한은우	50	50-59	Male	충청북도	36.567613	127.591462	전문대 졸	350-500만원	전문직	자녀 양육 가구	6	중도 무당층	66	{"economy": -6, "housing": -3, "welfare": 35, "security": 29, "environment": 37}	신문/팟캐스트	{전통,다양성,안정}	충청북도에 거주하는 50-59 전문직. 정치 성향은 중도이며 전통, 다양성, 안정 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 63, "ecoConsciousness": 59, "priceSensitivity": 57, "digitalConsumption": 71}	{"taxTolerance": 56, "governmentTrust": 51, "policyAcceptance": 38, "regulationPreference": 61, "publicServiceSatisfaction": 45}	0
1679	윤미경	61	60-69	Female	충청북도	36.573696	127.573019	전문대 졸	200-350만원	공무원	다세대 가구	29	보수 성향 무당층	88	{"economy": 22, "housing": 11, "welfare": -15, "security": 73, "environment": -2}	포털 뉴스	{안전,혁신,안정}	충청북도에 거주하는 60-69 공무원. 정치 성향은 중도이며 안전, 혁신, 안정 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 67, "ecoConsciousness": 50, "priceSensitivity": 60, "digitalConsumption": 50}	{"taxTolerance": 41, "governmentTrust": 61, "policyAcceptance": 47, "regulationPreference": 62, "publicServiceSatisfaction": 58}	0
1680	최영수	64	60-69	Female	충청북도	36.610594	127.56424	대학원 졸	700만원 이상	자영업	부부 가구	22	보수 성향 무당층	78	{"economy": -18, "housing": 15, "welfare": -11, "security": 5, "environment": 50}	유튜브	{환경,전통,자유}	충청북도에 거주하는 60-69 자영업. 정치 성향은 중도이며 환경, 전통, 자유 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 64, "ecoConsciousness": 45, "priceSensitivity": 41, "digitalConsumption": 58}	{"taxTolerance": 41, "governmentTrust": 54, "policyAcceptance": 57, "regulationPreference": 75, "publicServiceSatisfaction": 62}	0
1681	홍다은	67	60-69	Male	충청북도	36.609991	127.591544	대학원 졸	200만원 미만	은퇴	1인 가구	21	보수 성향 무당층	98	{"economy": 35, "housing": 8, "welfare": -10, "security": 11, "environment": 11}	포털 뉴스	{안정,다양성,공동체}	충청북도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 안정, 다양성, 공동체 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 30, "ecoConsciousness": 54, "priceSensitivity": 88, "digitalConsumption": 60}	{"taxTolerance": 40, "governmentTrust": 60, "policyAcceptance": 53, "regulationPreference": 78, "publicServiceSatisfaction": 56}	0
1682	전은우	66	60-69	Male	충청북도	36.707676	127.459865	대학원 졸	200-350만원	주부	자녀 양육 가구	31	보수 성향 무당층	83	{"economy": 10, "housing": -1, "welfare": -10, "security": 19, "environment": 1}	포털 뉴스	{공정,성장,공동체}	충청북도에 거주하는 60-69 주부. 정치 성향은 중도이며 공정, 성장, 공동체 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 73, "ecoConsciousness": 67, "priceSensitivity": 62, "digitalConsumption": 58}	{"taxTolerance": 45, "governmentTrust": 46, "policyAcceptance": 43, "regulationPreference": 68, "publicServiceSatisfaction": 65}	0
1683	신지호	73	70+	Female	충청북도	36.627001	127.541348	대학교 졸	500-700만원	은퇴	자녀 양육 가구	-7	중도 무당층	63	{"economy": -27, "housing": 23, "welfare": 22, "security": -1, "environment": 7}	신문/팟캐스트	{공정,환경,전통}	충청북도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공정, 환경, 전통 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 80, "ecoConsciousness": 50, "priceSensitivity": 69, "digitalConsumption": 70}	{"taxTolerance": 40, "governmentTrust": 45, "policyAcceptance": 55, "regulationPreference": 51, "publicServiceSatisfaction": 39}	0
1684	정동현	80	70+	Female	충청북도	36.641684	127.470341	대학교 졸	350-500만원	은퇴	자녀 양육 가구	29	보수 성향 무당층	88	{"economy": 24, "housing": 11, "welfare": -5, "security": 25, "environment": 14}	포털 뉴스	{성장,다양성,안정}	충청북도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 성장, 다양성, 안정 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 34, "ecoConsciousness": 43, "priceSensitivity": 67, "digitalConsumption": 51}	{"taxTolerance": 45, "governmentTrust": 40, "policyAcceptance": 47, "regulationPreference": 72, "publicServiceSatisfaction": 62}	0
1685	안지아	79	70+	Male	충청북도	36.602909	127.55372	전문대 졸	350-500만원	은퇴	다세대 가구	15	보수 성향 무당층	75	{"economy": -3, "housing": 25, "welfare": 28, "security": 38, "environment": 13}	신문/팟캐스트	{전통,안정,안전}	충청북도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 전통, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 35, "ecoConsciousness": 24, "priceSensitivity": 66, "digitalConsumption": 56}	{"taxTolerance": 38, "governmentTrust": 49, "policyAcceptance": 43, "regulationPreference": 66, "publicServiceSatisfaction": 58}	0
1686	황현우	74	70+	Male	충청북도	36.562043	127.537576	대학원 졸	200만원 미만	은퇴	다세대 가구	15	보수 성향 무당층	70	{"economy": 1, "housing": 10, "welfare": -4, "security": 0, "environment": 5}	포털 뉴스	{안전,공동체,환경}	충청북도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안전, 공동체, 환경 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 55, "ecoConsciousness": 54, "priceSensitivity": 81, "digitalConsumption": 48}	{"taxTolerance": 35, "governmentTrust": 52, "policyAcceptance": 41, "regulationPreference": 59, "publicServiceSatisfaction": 60}	0
1687	강은우	27	18-29	Female	충청남도	36.650122	126.742047	대학교 졸	350-500만원	공무원	다세대 가구	-13	중도 무당층	62	{"economy": -9, "housing": 26, "welfare": 29, "security": 0, "environment": 38}	지상파/종편 뉴스	{다양성,전통,안전}	충청남도에 거주하는 18-29 공무원. 정치 성향은 중도이며 다양성, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 25, "noveltySeeking": 74, "ecoConsciousness": 53, "priceSensitivity": 88, "digitalConsumption": 82}	{"taxTolerance": 30, "governmentTrust": 36, "policyAcceptance": 47, "regulationPreference": 69, "publicServiceSatisfaction": 61}	0
1688	류은우	25	18-29	Female	충청남도	36.5827	126.583399	대학원 졸	500-700만원	전문직	부부 가구	-1	중도 무당층	25	{"economy": -22, "housing": 28, "welfare": 3, "security": -5, "environment": 20}	지상파/종편 뉴스	{환경,공정,자유}	충청남도에 거주하는 18-29 전문직. 정치 성향은 중도이며 환경, 공정, 자유 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 76, "ecoConsciousness": 62, "priceSensitivity": 64, "digitalConsumption": 99}	{"taxTolerance": 46, "governmentTrust": 43, "policyAcceptance": 53, "regulationPreference": 57, "publicServiceSatisfaction": 51}	0
1689	정도윤	23	18-29	Female	충청남도	36.682473	126.58839	대학원 졸	350-500만원	학생	1인 가구	-24	진보 성향 무당층	72	{"economy": 4, "housing": 48, "welfare": 17, "security": -16, "environment": 29}	신문/팟캐스트	{자유,공동체,안정}	충청남도에 거주하는 18-29 학생. 정치 성향은 중도이며 자유, 공동체, 안정 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 61, "ecoConsciousness": 56, "priceSensitivity": 61, "digitalConsumption": 76}	{"taxTolerance": 43, "governmentTrust": 51, "policyAcceptance": 46, "regulationPreference": 69, "publicServiceSatisfaction": 76}	0
1690	강지민	21	18-29	Male	충청남도	36.718613	126.612424	대학원 졸	700만원 이상	학생	부부 가구	-3	중도 무당층	46	{"economy": 1, "housing": 9, "welfare": 37, "security": -21, "environment": 56}	유튜브	{환경,자유,성장}	충청남도에 거주하는 18-29 학생. 정치 성향은 중도이며 환경, 자유, 성장 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 73, "ecoConsciousness": 56, "priceSensitivity": 43, "digitalConsumption": 95}	{"taxTolerance": 63, "governmentTrust": 51, "policyAcceptance": 51, "regulationPreference": 59, "publicServiceSatisfaction": 64}	0
1691	황현우	22	18-29	Male	충청남도	36.590176	126.644113	대학원 졸	350-500만원	학생	부부 가구	-29	진보 성향 무당층	41	{"economy": -19, "housing": 44, "welfare": 38, "security": 21, "environment": 24}	신문/팟캐스트	{안전,공동체,자유}	충청남도에 거주하는 18-29 학생. 정치 성향은 중도이며 안전, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 0, "noveltySeeking": 74, "ecoConsciousness": 48, "priceSensitivity": 69, "digitalConsumption": 76}	{"taxTolerance": 61, "governmentTrust": 46, "policyAcceptance": 58, "regulationPreference": 65, "publicServiceSatisfaction": 45}	0
1692	오예준	24	18-29	Male	충청남도	36.601333	126.689427	대학원 졸	500-700만원	공무원	부부 가구	-1	중도 무당층	40	{"economy": -7, "housing": 11, "welfare": 7, "security": 10, "environment": 34}	유튜브	{안전,안정,환경}	충청남도에 거주하는 18-29 공무원. 정치 성향은 중도이며 안전, 안정, 환경 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 73, "ecoConsciousness": 56, "priceSensitivity": 37, "digitalConsumption": 87}	{"taxTolerance": 52, "governmentTrust": 31, "policyAcceptance": 43, "regulationPreference": 53, "publicServiceSatisfaction": 82}	0
1693	홍미경	35	30-39	Female	충청남도	36.643519	126.583159	전문대 졸	500-700만원	학생	1인 가구	-45	진보 정당 지지	53	{"economy": -25, "housing": 45, "welfare": 40, "security": 5, "environment": 37}	포털 뉴스	{안정,공동체,자유}	충청남도에 거주하는 30-39 학생. 정치 성향은 진보이며 안정, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 53, "ecoConsciousness": 37, "priceSensitivity": 51, "digitalConsumption": 71}	{"taxTolerance": 39, "governmentTrust": 50, "policyAcceptance": 43, "regulationPreference": 45, "publicServiceSatisfaction": 50}	0
1694	류유준	30	30-39	Female	충청남도	36.607891	126.661008	대학교 졸	200-350만원	자영업	다세대 가구	-4	중도 무당층	60	{"economy": -21, "housing": 2, "welfare": 15, "security": -14, "environment": 47}	지상파/종편 뉴스	{혁신,공정,환경}	충청남도에 거주하는 30-39 자영업. 정치 성향은 중도이며 혁신, 공정, 환경 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 74, "ecoConsciousness": 57, "priceSensitivity": 57, "digitalConsumption": 81}	{"taxTolerance": 62, "governmentTrust": 43, "policyAcceptance": 46, "regulationPreference": 49, "publicServiceSatisfaction": 50}	0
1695	최혜진	38	30-39	Female	충청남도	36.734479	126.628598	고졸 이하	200만원 미만	자영업	다세대 가구	-22	진보 성향 무당층	81	{"economy": 0, "housing": 32, "welfare": 9, "security": -14, "environment": 4}	SNS	{안정,안전,전통}	충청남도에 거주하는 30-39 자영업. 정치 성향은 중도이며 안정, 안전, 전통 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 53, "ecoConsciousness": 39, "priceSensitivity": 70, "digitalConsumption": 77}	{"taxTolerance": 52, "governmentTrust": 36, "policyAcceptance": 53, "regulationPreference": 70, "publicServiceSatisfaction": 46}	0
1696	황순자	33	30-39	Male	충청남도	36.633101	126.653605	고졸 이하	350-500만원	서비스직	다세대 가구	14	중도 무당층	82	{"economy": 6, "housing": 40, "welfare": 39, "security": 25, "environment": 29}	신문/팟캐스트	{환경,안전,자유}	충청남도에 거주하는 30-39 서비스직. 정치 성향은 중도이며 환경, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 76, "ecoConsciousness": 51, "priceSensitivity": 55, "digitalConsumption": 89}	{"taxTolerance": 53, "governmentTrust": 41, "policyAcceptance": 44, "regulationPreference": 63, "publicServiceSatisfaction": 74}	0
1697	황순자	34	30-39	Male	충청남도	36.642903	126.588628	대학원 졸	200-350만원	주부	자녀 양육 가구	-52	진보 정당 지지	69	{"economy": -37, "housing": 30, "welfare": 24, "security": 2, "environment": 27}	지상파/종편 뉴스	{성장,공동체,전통}	충청남도에 거주하는 30-39 주부. 정치 성향은 진보이며 성장, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 65, "ecoConsciousness": 55, "priceSensitivity": 69, "digitalConsumption": 72}	{"taxTolerance": 32, "governmentTrust": 38, "policyAcceptance": 56, "regulationPreference": 57, "publicServiceSatisfaction": 73}	0
1698	정은우	41	40-49	Female	충청남도	36.691022	126.732156	고졸 이하	500-700만원	학생	부부 가구	-11	중도 무당층	69	{"economy": -15, "housing": 1, "welfare": 19, "security": -12, "environment": 30}	SNS	{공동체,성장,전통}	충청남도에 거주하는 40-49 학생. 정치 성향은 중도이며 공동체, 성장, 전통 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 40, "ecoConsciousness": 50, "priceSensitivity": 52, "digitalConsumption": 76}	{"taxTolerance": 45, "governmentTrust": 47, "policyAcceptance": 57, "regulationPreference": 66, "publicServiceSatisfaction": 79}	0
1699	임광수	46	40-49	Female	충청남도	36.686651	126.601392	대학교 졸	350-500만원	사무직	자녀 양육 가구	-6	중도 무당층	49	{"economy": -31, "housing": 30, "welfare": 4, "security": 7, "environment": 14}	포털 뉴스	{다양성,성장,공정}	충청남도에 거주하는 40-49 사무직. 정치 성향은 중도이며 다양성, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 67, "ecoConsciousness": 73, "priceSensitivity": 47, "digitalConsumption": 53}	{"taxTolerance": 34, "governmentTrust": 43, "policyAcceptance": 27, "regulationPreference": 65, "publicServiceSatisfaction": 65}	0
1700	홍채원	42	40-49	Female	충청남도	36.600018	126.645608	대학교 졸	350-500만원	학생	1인 가구	1	중도 무당층	68	{"economy": 17, "housing": 20, "welfare": -12, "security": 12, "environment": 32}	지상파/종편 뉴스	{전통,성장,환경}	충청남도에 거주하는 40-49 학생. 정치 성향은 중도이며 전통, 성장, 환경 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 62, "ecoConsciousness": 58, "priceSensitivity": 83, "digitalConsumption": 73}	{"taxTolerance": 38, "governmentTrust": 17, "policyAcceptance": 51, "regulationPreference": 53, "publicServiceSatisfaction": 72}	0
1701	이유준	43	40-49	Male	충청남도	36.725228	126.741989	대학원 졸	350-500만원	사무직	1인 가구	19	보수 성향 무당층	48	{"economy": 11, "housing": 4, "welfare": 38, "security": -5, "environment": 25}	포털 뉴스	{혁신,자유,다양성}	충청남도에 거주하는 40-49 사무직. 정치 성향은 중도이며 혁신, 자유, 다양성 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 67, "ecoConsciousness": 46, "priceSensitivity": 44, "digitalConsumption": 61}	{"taxTolerance": 50, "governmentTrust": 58, "policyAcceptance": 15, "regulationPreference": 66, "publicServiceSatisfaction": 68}	0
1702	임다은	45	40-49	Male	충청남도	36.711475	126.654453	대학교 졸	350-500만원	주부	자녀 양육 가구	-8	중도 무당층	87	{"economy": 4, "housing": 6, "welfare": 26, "security": 7, "environment": 19}	유튜브	{다양성,안전,성장}	충청남도에 거주하는 40-49 주부. 정치 성향은 중도이며 다양성, 안전, 성장 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 78, "ecoConsciousness": 35, "priceSensitivity": 58, "digitalConsumption": 75}	{"taxTolerance": 37, "governmentTrust": 34, "policyAcceptance": 48, "regulationPreference": 60, "publicServiceSatisfaction": 54}	0
1703	장지호	41	40-49	Male	충청남도	36.640793	126.620612	대학교 졸	700만원 이상	공무원	자녀 양육 가구	8	중도 무당층	69	{"economy": -17, "housing": -20, "welfare": 7, "security": -7, "environment": 48}	유튜브	{안정,안전,공정}	충청남도에 거주하는 40-49 공무원. 정치 성향은 중도이며 안정, 안전, 공정 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 68, "ecoConsciousness": 61, "priceSensitivity": 27, "digitalConsumption": 81}	{"taxTolerance": 52, "governmentTrust": 58, "policyAcceptance": 52, "regulationPreference": 48, "publicServiceSatisfaction": 56}	0
1704	강지호	56	50-59	Female	충청남도	36.592951	126.670068	대학교 졸	350-500만원	생산직	다세대 가구	38	보수 성향 무당층	68	{"economy": 18, "housing": 19, "welfare": -15, "security": 23, "environment": -16}	SNS	{환경,다양성,공정}	충청남도에 거주하는 50-59 생산직. 정치 성향은 보수이며 환경, 다양성, 공정 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 60, "ecoConsciousness": 54, "priceSensitivity": 66, "digitalConsumption": 57}	{"taxTolerance": 63, "governmentTrust": 56, "policyAcceptance": 38, "regulationPreference": 47, "publicServiceSatisfaction": 69}	0
1705	최동현	53	50-59	Female	충청남도	36.659291	126.62996	대학원 졸	350-500만원	자영업	자녀 양육 가구	-39	진보 성향 무당층	62	{"economy": -35, "housing": 15, "welfare": 8, "security": -24, "environment": 34}	포털 뉴스	{성장,공정,자유}	충청남도에 거주하는 50-59 자영업. 정치 성향은 진보이며 성장, 공정, 자유 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 69, "ecoConsciousness": 52, "priceSensitivity": 52, "digitalConsumption": 77}	{"taxTolerance": 56, "governmentTrust": 49, "policyAcceptance": 42, "regulationPreference": 47, "publicServiceSatisfaction": 53}	0
1706	권미경	57	50-59	Female	충청남도	36.686977	126.617004	대학교 졸	700만원 이상	서비스직	다세대 가구	-15	진보 성향 무당층	59	{"economy": -35, "housing": 17, "welfare": 57, "security": -6, "environment": -10}	SNS	{다양성,성장,안정}	충청남도에 거주하는 50-59 서비스직. 정치 성향은 중도이며 다양성, 성장, 안정 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 61, "ecoConsciousness": 55, "priceSensitivity": 48, "digitalConsumption": 61}	{"taxTolerance": 59, "governmentTrust": 37, "policyAcceptance": 49, "regulationPreference": 69, "publicServiceSatisfaction": 46}	0
1707	서지우	52	50-59	Male	충청남도	36.70037	126.692808	대학교 졸	700만원 이상	전문직	부부 가구	15	보수 성향 무당층	68	{"economy": 16, "housing": -1, "welfare": 16, "security": 12, "environment": 4}	신문/팟캐스트	{안정,공정,자유}	충청남도에 거주하는 50-59 전문직. 정치 성향은 중도이며 안정, 공정, 자유 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 63, "ecoConsciousness": 46, "priceSensitivity": 49, "digitalConsumption": 51}	{"taxTolerance": 56, "governmentTrust": 33, "policyAcceptance": 66, "regulationPreference": 72, "publicServiceSatisfaction": 67}	0
1708	정철수	51	50-59	Male	충청남도	36.655192	126.658302	고졸 이하	350-500만원	은퇴	자녀 양육 가구	8	중도 무당층	58	{"economy": -3, "housing": 13, "welfare": -12, "security": 32, "environment": 18}	SNS	{혁신,공동체,공정}	충청남도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 혁신, 공동체, 공정 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 46, "ecoConsciousness": 32, "priceSensitivity": 38, "digitalConsumption": 60}	{"taxTolerance": 50, "governmentTrust": 52, "policyAcceptance": 41, "regulationPreference": 100, "publicServiceSatisfaction": 33}	0
1709	조민서	57	50-59	Male	충청남도	36.683652	126.574953	전문대 졸	500-700만원	생산직	부부 가구	2	중도 무당층	62	{"economy": 37, "housing": -16, "welfare": 17, "security": 16, "environment": 14}	SNS	{공동체,성장,혁신}	충청남도에 거주하는 50-59 생산직. 정치 성향은 중도이며 공동체, 성장, 혁신 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 51, "ecoConsciousness": 50, "priceSensitivity": 54, "digitalConsumption": 61}	{"taxTolerance": 30, "governmentTrust": 62, "policyAcceptance": 65, "regulationPreference": 63, "publicServiceSatisfaction": 52}	0
1710	강미경	67	60-69	Female	충청남도	36.668198	126.628684	고졸 이하	200-350만원	은퇴	1인 가구	62	보수 정당 지지	62	{"economy": 9, "housing": -9, "welfare": 7, "security": 41, "environment": 4}	신문/팟캐스트	{혁신,공정,환경}	충청남도에 거주하는 60-69 은퇴. 정치 성향은 보수이며 혁신, 공정, 환경 가치를 중시한다.	{"brandLoyalty": 64, "noveltySeeking": 46, "ecoConsciousness": 38, "priceSensitivity": 70, "digitalConsumption": 53}	{"taxTolerance": 49, "governmentTrust": 45, "policyAcceptance": 58, "regulationPreference": 65, "publicServiceSatisfaction": 63}	0
1711	송혜진	64	60-69	Female	충청남도	36.611472	126.668731	대학원 졸	200-350만원	프리랜서	다세대 가구	49	보수 정당 지지	81	{"economy": 56, "housing": -2, "welfare": -15, "security": 55, "environment": 11}	포털 뉴스	{안정,다양성,안전}	충청남도에 거주하는 60-69 프리랜서. 정치 성향은 보수이며 안정, 다양성, 안전 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 58, "ecoConsciousness": 50, "priceSensitivity": 72, "digitalConsumption": 47}	{"taxTolerance": 49, "governmentTrust": 48, "policyAcceptance": 48, "regulationPreference": 58, "publicServiceSatisfaction": 53}	0
1712	박준서	60	60-69	Female	충청남도	36.718771	126.587424	전문대 졸	350-500만원	공무원	자녀 양육 가구	-11	중도 무당층	78	{"economy": -9, "housing": 5, "welfare": 25, "security": 12, "environment": 27}	지상파/종편 뉴스	{환경,성장,안전}	충청남도에 거주하는 60-69 공무원. 정치 성향은 중도이며 환경, 성장, 안전 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 48, "ecoConsciousness": 36, "priceSensitivity": 82, "digitalConsumption": 58}	{"taxTolerance": 44, "governmentTrust": 45, "policyAcceptance": 58, "regulationPreference": 58, "publicServiceSatisfaction": 63}	0
1713	조경숙	65	60-69	Male	충청남도	36.712163	126.746339	전문대 졸	500-700만원	은퇴	자녀 양육 가구	-15	진보 성향 무당층	61	{"economy": -2, "housing": 25, "welfare": 16, "security": -8, "environment": 13}	지상파/종편 뉴스	{자유,안정,혁신}	충청남도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 자유, 안정, 혁신 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 48, "ecoConsciousness": 62, "priceSensitivity": 54, "digitalConsumption": 67}	{"taxTolerance": 50, "governmentTrust": 68, "policyAcceptance": 53, "regulationPreference": 38, "publicServiceSatisfaction": 64}	0
1714	송수아	66	60-69	Male	충청남도	36.633163	126.59425	고졸 이하	200만원 미만	학생	다세대 가구	7	중도 무당층	99	{"economy": 27, "housing": 25, "welfare": 22, "security": 16, "environment": -7}	유튜브	{공정,안전,환경}	충청남도에 거주하는 60-69 학생. 정치 성향은 중도이며 공정, 안전, 환경 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 42, "ecoConsciousness": 37, "priceSensitivity": 73, "digitalConsumption": 54}	{"taxTolerance": 49, "governmentTrust": 42, "policyAcceptance": 40, "regulationPreference": 56, "publicServiceSatisfaction": 59}	0
1715	서주원	62	60-69	Male	충청남도	36.643196	126.603257	대학교 졸	350-500만원	전문직	1인 가구	38	보수 성향 무당층	78	{"economy": 13, "housing": 6, "welfare": -21, "security": 21, "environment": 16}	유튜브	{성장,전통,공정}	충청남도에 거주하는 60-69 전문직. 정치 성향은 보수이며 성장, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 46, "ecoConsciousness": 53, "priceSensitivity": 68, "digitalConsumption": 75}	{"taxTolerance": 48, "governmentTrust": 26, "policyAcceptance": 39, "regulationPreference": 93, "publicServiceSatisfaction": 56}	0
1716	류서윤	76	70+	Female	충청남도	36.715085	126.677765	대학교 졸	200만원 미만	은퇴	부부 가구	56	보수 정당 지지	88	{"economy": 14, "housing": 35, "welfare": 2, "security": 54, "environment": -15}	유튜브	{환경,자유,전통}	충청남도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 환경, 자유, 전통 가치를 중시한다.	{"brandLoyalty": 60, "noveltySeeking": 50, "ecoConsciousness": 60, "priceSensitivity": 98, "digitalConsumption": 63}	{"taxTolerance": 36, "governmentTrust": 72, "policyAcceptance": 41, "regulationPreference": 76, "publicServiceSatisfaction": 52}	0
1717	전예준	83	70+	Female	충청남도	36.608859	126.764065	고졸 이하	350-500만원	은퇴	다세대 가구	34	보수 성향 무당층	92	{"economy": -1, "housing": 7, "welfare": 11, "security": 15, "environment": -19}	유튜브	{안정,다양성,공동체}	충청남도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안정, 다양성, 공동체 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 47, "ecoConsciousness": 36, "priceSensitivity": 59, "digitalConsumption": 46}	{"taxTolerance": 33, "governmentTrust": 45, "policyAcceptance": 72, "regulationPreference": 71, "publicServiceSatisfaction": 60}	0
1718	권지우	73	70+	Male	충청남도	36.666593	126.623571	대학교 졸	350-500만원	은퇴	1인 가구	-3	중도 무당층	93	{"economy": -3, "housing": 35, "welfare": 16, "security": 11, "environment": 38}	신문/팟캐스트	{안전,다양성,환경}	충청남도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안전, 다양성, 환경 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 57, "ecoConsciousness": 38, "priceSensitivity": 63, "digitalConsumption": 48}	{"taxTolerance": 35, "governmentTrust": 57, "policyAcceptance": 62, "regulationPreference": 52, "publicServiceSatisfaction": 59}	0
1719	장유준	79	70+	Male	충청남도	36.589035	126.622693	대학교 졸	200만원 미만	은퇴	1인 가구	10	중도 무당층	88	{"economy": 25, "housing": 11, "welfare": 11, "security": -15, "environment": 26}	SNS	{공동체,자유,안전}	충청남도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공동체, 자유, 안전 가치를 중시한다.	{"brandLoyalty": 66, "noveltySeeking": 34, "ecoConsciousness": 52, "priceSensitivity": 75, "digitalConsumption": 55}	{"taxTolerance": 35, "governmentTrust": 57, "policyAcceptance": 51, "regulationPreference": 69, "publicServiceSatisfaction": 61}	0
1720	전채원	24	18-29	Female	전라남도	34.873536	126.500848	전문대 졸	350-500만원	학생	자녀 양육 가구	-89	진보 정당 지지	46	{"economy": -90, "housing": 31, "welfare": 40, "security": -29, "environment": 62}	지상파/종편 뉴스	{다양성,안전,환경}	전라남도에 거주하는 18-29 학생. 정치 성향은 진보이며 다양성, 안전, 환경 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 76, "ecoConsciousness": 52, "priceSensitivity": 60, "digitalConsumption": 78}	{"taxTolerance": 50, "governmentTrust": 51, "policyAcceptance": 40, "regulationPreference": 67, "publicServiceSatisfaction": 64}	0
1721	한지우	23	18-29	Female	전라남도	34.736693	126.534702	대학교 졸	200-350만원	학생	자녀 양육 가구	-55	진보 정당 지지	61	{"economy": -45, "housing": 37, "welfare": 15, "security": -50, "environment": 56}	유튜브	{자유,공동체,전통}	전라남도에 거주하는 18-29 학생. 정치 성향은 진보이며 자유, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 74, "ecoConsciousness": 43, "priceSensitivity": 48, "digitalConsumption": 78}	{"taxTolerance": 50, "governmentTrust": 33, "policyAcceptance": 31, "regulationPreference": 60, "publicServiceSatisfaction": 62}	0
1722	강예준	29	18-29	Male	전라남도	34.794159	126.38983	대학교 졸	350-500만원	자영업	자녀 양육 가구	-69	진보 정당 지지	43	{"economy": -35, "housing": 46, "welfare": 45, "security": -4, "environment": 45}	지상파/종편 뉴스	{안정,안전,공정}	전라남도에 거주하는 18-29 자영업. 정치 성향은 진보이며 안정, 안전, 공정 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 73, "ecoConsciousness": 63, "priceSensitivity": 49, "digitalConsumption": 97}	{"taxTolerance": 43, "governmentTrust": 33, "policyAcceptance": 66, "regulationPreference": 61, "publicServiceSatisfaction": 75}	0
1723	오수아	24	18-29	Male	전라남도	34.812298	126.441446	대학교 졸	700만원 이상	학생	부부 가구	-72	진보 정당 지지	48	{"economy": -68, "housing": 41, "welfare": 58, "security": -38, "environment": 58}	유튜브	{안전,자유,공정}	전라남도에 거주하는 18-29 학생. 정치 성향은 진보이며 안전, 자유, 공정 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 82, "ecoConsciousness": 57, "priceSensitivity": 50, "digitalConsumption": 79}	{"taxTolerance": 52, "governmentTrust": 31, "policyAcceptance": 41, "regulationPreference": 45, "publicServiceSatisfaction": 74}	0
1724	안지우	30	30-39	Female	전라남도	34.740802	126.487357	대학교 졸	350-500만원	사무직	다세대 가구	-42	진보 성향 무당층	60	{"economy": -65, "housing": 47, "welfare": 61, "security": -35, "environment": 17}	SNS	{안정,공정,안전}	전라남도에 거주하는 30-39 사무직. 정치 성향은 진보이며 안정, 공정, 안전 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 74, "ecoConsciousness": 42, "priceSensitivity": 44, "digitalConsumption": 79}	{"taxTolerance": 53, "governmentTrust": 48, "policyAcceptance": 34, "regulationPreference": 54, "publicServiceSatisfaction": 46}	0
1725	서현우	35	30-39	Female	전라남도	34.875607	126.365527	전문대 졸	500-700만원	주부	1인 가구	-39	진보 성향 무당층	62	{"economy": -25, "housing": 31, "welfare": 24, "security": -29, "environment": 17}	신문/팟캐스트	{공정,다양성,공동체}	전라남도에 거주하는 30-39 주부. 정치 성향은 진보이며 공정, 다양성, 공동체 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 74, "ecoConsciousness": 43, "priceSensitivity": 44, "digitalConsumption": 77}	{"taxTolerance": 53, "governmentTrust": 37, "policyAcceptance": 35, "regulationPreference": 43, "publicServiceSatisfaction": 60}	0
1726	임동현	39	30-39	Male	전라남도	34.772948	126.377923	대학교 졸	350-500만원	생산직	1인 가구	-35	진보 성향 무당층	54	{"economy": -8, "housing": 29, "welfare": 8, "security": -2, "environment": 42}	SNS	{안전,환경,자유}	전라남도에 거주하는 30-39 생산직. 정치 성향은 진보이며 안전, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 80, "ecoConsciousness": 42, "priceSensitivity": 64, "digitalConsumption": 84}	{"taxTolerance": 38, "governmentTrust": 43, "policyAcceptance": 56, "regulationPreference": 73, "publicServiceSatisfaction": 66}	0
1727	황정희	39	30-39	Male	전라남도	34.770895	126.551638	고졸 이하	500-700만원	서비스직	1인 가구	-48	진보 정당 지지	59	{"economy": -41, "housing": 17, "welfare": 41, "security": -20, "environment": 46}	포털 뉴스	{성장,전통,다양성}	전라남도에 거주하는 30-39 서비스직. 정치 성향은 진보이며 성장, 전통, 다양성 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 58, "ecoConsciousness": 32, "priceSensitivity": 44, "digitalConsumption": 68}	{"taxTolerance": 39, "governmentTrust": 50, "policyAcceptance": 46, "regulationPreference": 66, "publicServiceSatisfaction": 57}	0
1728	이정희	43	40-49	Female	전라남도	34.804814	126.5533	전문대 졸	500-700만원	프리랜서	1인 가구	-44	진보 성향 무당층	74	{"economy": -54, "housing": 20, "welfare": 38, "security": -34, "environment": 25}	포털 뉴스	{안정,안전,다양성}	전라남도에 거주하는 40-49 프리랜서. 정치 성향은 진보이며 안정, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 65, "ecoConsciousness": 55, "priceSensitivity": 49, "digitalConsumption": 80}	{"taxTolerance": 69, "governmentTrust": 42, "policyAcceptance": 34, "regulationPreference": 75, "publicServiceSatisfaction": 58}	0
1729	홍주원	46	40-49	Female	전라남도	34.875332	126.375665	대학원 졸	700만원 이상	생산직	1인 가구	-39	진보 성향 무당층	74	{"economy": 9, "housing": -3, "welfare": 22, "security": -25, "environment": 39}	신문/팟캐스트	{다양성,전통,안전}	전라남도에 거주하는 40-49 생산직. 정치 성향은 진보이며 다양성, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 77, "ecoConsciousness": 78, "priceSensitivity": 24, "digitalConsumption": 72}	{"taxTolerance": 39, "governmentTrust": 53, "policyAcceptance": 54, "regulationPreference": 48, "publicServiceSatisfaction": 68}	0
1730	윤준서	46	40-49	Female	전라남도	34.76253	126.435704	전문대 졸	500-700만원	자영업	자녀 양육 가구	-9	중도 무당층	40	{"economy": -3, "housing": 32, "welfare": 23, "security": -24, "environment": 12}	유튜브	{혁신,전통,환경}	전라남도에 거주하는 40-49 자영업. 정치 성향은 중도이며 혁신, 전통, 환경 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 67, "ecoConsciousness": 54, "priceSensitivity": 51, "digitalConsumption": 79}	{"taxTolerance": 57, "governmentTrust": 52, "policyAcceptance": 57, "regulationPreference": 67, "publicServiceSatisfaction": 66}	0
1731	안건우	49	40-49	Male	전라남도	34.836077	126.416064	대학교 졸	700만원 이상	사무직	부부 가구	-49	진보 정당 지지	82	{"economy": -23, "housing": 28, "welfare": 68, "security": -5, "environment": 37}	신문/팟캐스트	{성장,전통,다양성}	전라남도에 거주하는 40-49 사무직. 정치 성향은 진보이며 성장, 전통, 다양성 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 47, "ecoConsciousness": 56, "priceSensitivity": 62, "digitalConsumption": 61}	{"taxTolerance": 35, "governmentTrust": 58, "policyAcceptance": 43, "regulationPreference": 60, "publicServiceSatisfaction": 71}	0
1732	전준서	42	40-49	Male	전라남도	34.809347	126.436982	전문대 졸	700만원 이상	프리랜서	1인 가구	-46	진보 정당 지지	53	{"economy": -63, "housing": 40, "welfare": 1, "security": 31, "environment": 22}	신문/팟캐스트	{전통,성장,안정}	전라남도에 거주하는 40-49 프리랜서. 정치 성향은 진보이며 전통, 성장, 안정 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 58, "ecoConsciousness": 30, "priceSensitivity": 66, "digitalConsumption": 66}	{"taxTolerance": 45, "governmentTrust": 79, "policyAcceptance": 57, "regulationPreference": 69, "publicServiceSatisfaction": 53}	0
1733	김건우	40	40-49	Male	전라남도	34.833848	126.368228	전문대 졸	350-500만원	학생	다세대 가구	-36	진보 성향 무당층	55	{"economy": -37, "housing": 39, "welfare": 40, "security": -7, "environment": 42}	유튜브	{안정,안전,환경}	전라남도에 거주하는 40-49 학생. 정치 성향은 진보이며 안정, 안전, 환경 가치를 중시한다.	{"brandLoyalty": 22, "noveltySeeking": 58, "ecoConsciousness": 65, "priceSensitivity": 57, "digitalConsumption": 72}	{"taxTolerance": 41, "governmentTrust": 47, "policyAcceptance": 42, "regulationPreference": 50, "publicServiceSatisfaction": 75}	0
1734	박건우	55	50-59	Female	전라남도	34.784057	126.456064	전문대 졸	700만원 이상	프리랜서	자녀 양육 가구	-23	진보 성향 무당층	72	{"economy": 6, "housing": 45, "welfare": 13, "security": -5, "environment": -3}	신문/팟캐스트	{다양성,자유,혁신}	전라남도에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 다양성, 자유, 혁신 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 41, "ecoConsciousness": 47, "priceSensitivity": 24, "digitalConsumption": 75}	{"taxTolerance": 21, "governmentTrust": 56, "policyAcceptance": 70, "regulationPreference": 57, "publicServiceSatisfaction": 75}	0
1735	안지호	54	50-59	Female	전라남도	34.736151	126.363281	고졸 이하	200만원 미만	서비스직	다세대 가구	-13	중도 무당층	68	{"economy": -18, "housing": 14, "welfare": 14, "security": -16, "environment": 6}	유튜브	{성장,안전,전통}	전라남도에 거주하는 50-59 서비스직. 정치 성향은 중도이며 성장, 안전, 전통 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 56, "ecoConsciousness": 43, "priceSensitivity": 55, "digitalConsumption": 81}	{"taxTolerance": 51, "governmentTrust": 43, "policyAcceptance": 49, "regulationPreference": 63, "publicServiceSatisfaction": 67}	0
1736	전현우	52	50-59	Female	전라남도	34.883337	126.391579	대학원 졸	700만원 이상	자영업	다세대 가구	-34	진보 성향 무당층	94	{"economy": 1, "housing": 20, "welfare": 23, "security": -21, "environment": 23}	신문/팟캐스트	{전통,성장,안전}	전라남도에 거주하는 50-59 자영업. 정치 성향은 진보이며 전통, 성장, 안전 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 58, "ecoConsciousness": 58, "priceSensitivity": 33, "digitalConsumption": 50}	{"taxTolerance": 56, "governmentTrust": 64, "policyAcceptance": 39, "regulationPreference": 76, "publicServiceSatisfaction": 49}	0
1737	황서윤	52	50-59	Male	전라남도	34.892914	126.451348	고졸 이하	350-500만원	주부	다세대 가구	-64	진보 정당 지지	81	{"economy": -70, "housing": 18, "welfare": 54, "security": -33, "environment": 24}	SNS	{안전,공정,다양성}	전라남도에 거주하는 50-59 주부. 정치 성향은 진보이며 안전, 공정, 다양성 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 58, "ecoConsciousness": 62, "priceSensitivity": 61, "digitalConsumption": 72}	{"taxTolerance": 46, "governmentTrust": 47, "policyAcceptance": 45, "regulationPreference": 52, "publicServiceSatisfaction": 72}	0
1738	정채원	56	50-59	Male	전라남도	34.895532	126.524691	전문대 졸	500-700만원	학생	부부 가구	-16	진보 성향 무당층	61	{"economy": -5, "housing": 23, "welfare": 5, "security": -3, "environment": -10}	신문/팟캐스트	{자유,환경,혁신}	전라남도에 거주하는 50-59 학생. 정치 성향은 중도이며 자유, 환경, 혁신 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 59, "ecoConsciousness": 50, "priceSensitivity": 46, "digitalConsumption": 59}	{"taxTolerance": 50, "governmentTrust": 48, "policyAcceptance": 48, "regulationPreference": 64, "publicServiceSatisfaction": 53}	0
1739	정도윤	58	50-59	Male	전라남도	34.780872	126.47065	전문대 졸	200-350만원	서비스직	1인 가구	-44	진보 성향 무당층	77	{"economy": -60, "housing": 28, "welfare": 39, "security": -34, "environment": 51}	유튜브	{자유,혁신,안전}	전라남도에 거주하는 50-59 서비스직. 정치 성향은 진보이며 자유, 혁신, 안전 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 50, "ecoConsciousness": 46, "priceSensitivity": 58, "digitalConsumption": 69}	{"taxTolerance": 48, "governmentTrust": 42, "policyAcceptance": 36, "regulationPreference": 55, "publicServiceSatisfaction": 51}	0
1740	임경숙	61	60-69	Female	전라남도	34.850466	126.459502	전문대 졸	200-350만원	은퇴	부부 가구	-38	진보 성향 무당층	64	{"economy": -19, "housing": 16, "welfare": 14, "security": -19, "environment": 32}	SNS	{안정,전통,다양성}	전라남도에 거주하는 60-69 은퇴. 정치 성향은 진보이며 안정, 전통, 다양성 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 51, "ecoConsciousness": 49, "priceSensitivity": 67, "digitalConsumption": 65}	{"taxTolerance": 48, "governmentTrust": 37, "policyAcceptance": 63, "regulationPreference": 55, "publicServiceSatisfaction": 52}	0
1741	송경숙	69	60-69	Female	전라남도	34.78635	126.456551	대학교 졸	700만원 이상	은퇴	1인 가구	2	중도 무당층	75	{"economy": -9, "housing": 37, "welfare": 26, "security": -10, "environment": 14}	신문/팟캐스트	{공동체,안전,다양성}	전라남도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 공동체, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 62, "ecoConsciousness": 40, "priceSensitivity": 57, "digitalConsumption": 56}	{"taxTolerance": 51, "governmentTrust": 60, "policyAcceptance": 56, "regulationPreference": 67, "publicServiceSatisfaction": 65}	0
1742	정광수	63	60-69	Male	전라남도	34.837941	126.394085	전문대 졸	350-500만원	은퇴	부부 가구	-20	진보 성향 무당층	72	{"economy": 0, "housing": 27, "welfare": 25, "security": -24, "environment": 34}	유튜브	{혁신,전통,환경}	전라남도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 혁신, 전통, 환경 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 50, "ecoConsciousness": 63, "priceSensitivity": 65, "digitalConsumption": 77}	{"taxTolerance": 68, "governmentTrust": 54, "policyAcceptance": 43, "regulationPreference": 54, "publicServiceSatisfaction": 64}	0
1743	정동현	61	60-69	Male	전라남도	34.755268	126.519995	전문대 졸	350-500만원	프리랜서	다세대 가구	-36	진보 성향 무당층	79	{"economy": -9, "housing": 4, "welfare": 56, "security": -45, "environment": 13}	지상파/종편 뉴스	{성장,공정,자유}	전라남도에 거주하는 60-69 프리랜서. 정치 성향은 진보이며 성장, 공정, 자유 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 69, "ecoConsciousness": 50, "priceSensitivity": 62, "digitalConsumption": 56}	{"taxTolerance": 46, "governmentTrust": 68, "policyAcceptance": 67, "regulationPreference": 64, "publicServiceSatisfaction": 55}	0
1744	홍정희	73	70+	Female	전라남도	34.749845	126.488714	대학원 졸	350-500만원	은퇴	다세대 가구	-7	중도 무당층	72	{"economy": 8, "housing": 33, "welfare": 28, "security": 2, "environment": 19}	신문/팟캐스트	{공정,다양성,안전}	전라남도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공정, 다양성, 안전 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 45, "ecoConsciousness": 55, "priceSensitivity": 76, "digitalConsumption": 57}	{"taxTolerance": 59, "governmentTrust": 47, "policyAcceptance": 55, "regulationPreference": 60, "publicServiceSatisfaction": 46}	0
1745	최도윤	73	70+	Female	전라남도	34.774754	126.525813	대학교 졸	200만원 미만	은퇴	부부 가구	-11	중도 무당층	78	{"economy": -5, "housing": 47, "welfare": -3, "security": -8, "environment": 8}	SNS	{안전,환경,혁신}	전라남도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안전, 환경, 혁신 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 35, "ecoConsciousness": 58, "priceSensitivity": 92, "digitalConsumption": 48}	{"taxTolerance": 54, "governmentTrust": 65, "policyAcceptance": 57, "regulationPreference": 75, "publicServiceSatisfaction": 60}	0
1746	한수아	84	70+	Male	전라남도	34.818902	126.418363	대학교 졸	350-500만원	은퇴	자녀 양육 가구	-2	중도 무당층	85	{"economy": -14, "housing": 33, "welfare": -1, "security": -3, "environment": 15}	SNS	{전통,공정,자유}	전라남도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 전통, 공정, 자유 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 52, "ecoConsciousness": 42, "priceSensitivity": 68, "digitalConsumption": 28}	{"taxTolerance": 34, "governmentTrust": 51, "policyAcceptance": 58, "regulationPreference": 70, "publicServiceSatisfaction": 67}	0
1747	오영수	82	70+	Male	전라남도	34.884551	126.364798	고졸 이하	200-350만원	은퇴	자녀 양육 가구	16	보수 성향 무당층	96	{"economy": -25, "housing": 1, "welfare": -18, "security": 2, "environment": -3}	유튜브	{다양성,안전,자유}	전라남도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 다양성, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 76, "noveltySeeking": 42, "ecoConsciousness": 29, "priceSensitivity": 71, "digitalConsumption": 61}	{"taxTolerance": 38, "governmentTrust": 71, "policyAcceptance": 63, "regulationPreference": 75, "publicServiceSatisfaction": 55}	0
1748	전예준	19	18-29	Female	경상북도	36.503413	128.578489	전문대 졸	350-500만원	학생	자녀 양육 가구	16	보수 성향 무당층	37	{"economy": 1, "housing": 20, "welfare": 11, "security": 46, "environment": 16}	신문/팟캐스트	{공동체,다양성,전통}	경상북도에 거주하는 18-29 학생. 정치 성향은 중도이며 공동체, 다양성, 전통 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 67, "ecoConsciousness": 50, "priceSensitivity": 56, "digitalConsumption": 85}	{"taxTolerance": 29, "governmentTrust": 16, "policyAcceptance": 50, "regulationPreference": 66, "publicServiceSatisfaction": 55}	0
1749	서지호	22	18-29	Female	경상북도	36.5298	128.50699	대학교 졸	200-350만원	학생	부부 가구	-2	중도 무당층	38	{"economy": -15, "housing": -2, "welfare": 24, "security": -27, "environment": 23}	지상파/종편 뉴스	{다양성,공동체,전통}	경상북도에 거주하는 18-29 학생. 정치 성향은 중도이며 다양성, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 73, "ecoConsciousness": 61, "priceSensitivity": 52, "digitalConsumption": 78}	{"taxTolerance": 60, "governmentTrust": 25, "policyAcceptance": 36, "regulationPreference": 60, "publicServiceSatisfaction": 73}	0
1750	오은우	28	18-29	Female	경상북도	36.533109	128.559089	전문대 졸	200-350만원	공무원	자녀 양육 가구	32	보수 성향 무당층	61	{"economy": 37, "housing": 14, "welfare": -19, "security": 37, "environment": -4}	SNS	{공정,전통,안정}	경상북도에 거주하는 18-29 공무원. 정치 성향은 중도이며 공정, 전통, 안정 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 61, "ecoConsciousness": 49, "priceSensitivity": 77, "digitalConsumption": 81}	{"taxTolerance": 55, "governmentTrust": 56, "policyAcceptance": 35, "regulationPreference": 65, "publicServiceSatisfaction": 65}	0
1751	장동현	20	18-29	Male	경상북도	36.622679	128.407592	대학원 졸	200-350만원	학생	다세대 가구	21	보수 성향 무당층	29	{"economy": 6, "housing": 5, "welfare": 8, "security": 0, "environment": 9}	신문/팟캐스트	{전통,공동체,공정}	경상북도에 거주하는 18-29 학생. 정치 성향은 중도이며 전통, 공동체, 공정 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 85, "ecoConsciousness": 83, "priceSensitivity": 79, "digitalConsumption": 84}	{"taxTolerance": 43, "governmentTrust": 33, "policyAcceptance": 33, "regulationPreference": 64, "publicServiceSatisfaction": 69}	0
1752	최현우	19	18-29	Male	경상북도	36.542096	128.449991	대학교 졸	350-500만원	학생	부부 가구	32	보수 성향 무당층	52	{"economy": -1, "housing": -15, "welfare": -4, "security": -1, "environment": 1}	포털 뉴스	{자유,혁신,공동체}	경상북도에 거주하는 18-29 학생. 정치 성향은 중도이며 자유, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 61, "ecoConsciousness": 58, "priceSensitivity": 51, "digitalConsumption": 73}	{"taxTolerance": 41, "governmentTrust": 27, "policyAcceptance": 49, "regulationPreference": 51, "publicServiceSatisfaction": 69}	0
1753	최하은	21	18-29	Male	경상북도	36.591924	128.549867	대학원 졸	350-500만원	전문직	1인 가구	16	보수 성향 무당층	42	{"economy": -11, "housing": 10, "welfare": 19, "security": 23, "environment": 14}	신문/팟캐스트	{공정,안전,환경}	경상북도에 거주하는 18-29 전문직. 정치 성향은 중도이며 공정, 안전, 환경 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 68, "ecoConsciousness": 65, "priceSensitivity": 42, "digitalConsumption": 86}	{"taxTolerance": 47, "governmentTrust": 48, "policyAcceptance": 39, "regulationPreference": 53, "publicServiceSatisfaction": 73}	0
1754	이철수	36	30-39	Female	경상북도	36.591118	128.446946	대학원 졸	200-350만원	서비스직	자녀 양육 가구	1	중도 무당층	72	{"economy": -38, "housing": 9, "welfare": -30, "security": 10, "environment": 21}	신문/팟캐스트	{혁신,안전,안정}	경상북도에 거주하는 30-39 서비스직. 정치 성향은 중도이며 혁신, 안전, 안정 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 58, "ecoConsciousness": 54, "priceSensitivity": 79, "digitalConsumption": 73}	{"taxTolerance": 61, "governmentTrust": 31, "policyAcceptance": 47, "regulationPreference": 70, "publicServiceSatisfaction": 79}	0
1755	박민준	34	30-39	Female	경상북도	36.500964	128.552346	대학교 졸	350-500만원	은퇴	부부 가구	-26	진보 성향 무당층	49	{"economy": -31, "housing": 40, "welfare": 10, "security": 9, "environment": 17}	지상파/종편 뉴스	{성장,안정,공정}	경상북도에 거주하는 30-39 은퇴. 정치 성향은 중도이며 성장, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 64, "ecoConsciousness": 61, "priceSensitivity": 77, "digitalConsumption": 90}	{"taxTolerance": 46, "governmentTrust": 38, "policyAcceptance": 38, "regulationPreference": 71, "publicServiceSatisfaction": 67}	0
1756	오정희	32	30-39	Female	경상북도	36.637437	128.421611	전문대 졸	200-350만원	서비스직	자녀 양육 가구	17	보수 성향 무당층	46	{"economy": 19, "housing": 22, "welfare": -17, "security": -2, "environment": 44}	SNS	{다양성,전통,안전}	경상북도에 거주하는 30-39 서비스직. 정치 성향은 중도이며 다양성, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 48, "ecoConsciousness": 31, "priceSensitivity": 59, "digitalConsumption": 67}	{"taxTolerance": 55, "governmentTrust": 70, "policyAcceptance": 34, "regulationPreference": 49, "publicServiceSatisfaction": 65}	0
1757	임민준	39	30-39	Male	경상북도	36.514874	128.461569	전문대 졸	350-500만원	프리랜서	다세대 가구	27	보수 성향 무당층	63	{"economy": 11, "housing": 23, "welfare": 2, "security": 46, "environment": 28}	SNS	{다양성,안전,공동체}	경상북도에 거주하는 30-39 프리랜서. 정치 성향은 중도이며 다양성, 안전, 공동체 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 73, "ecoConsciousness": 45, "priceSensitivity": 64, "digitalConsumption": 89}	{"taxTolerance": 49, "governmentTrust": 44, "policyAcceptance": 38, "regulationPreference": 48, "publicServiceSatisfaction": 57}	0
1758	오철수	30	30-39	Male	경상북도	36.573114	128.484024	대학원 졸	500-700만원	주부	1인 가구	20	보수 성향 무당층	46	{"economy": 7, "housing": 6, "welfare": 13, "security": 34, "environment": 41}	신문/팟캐스트	{환경,전통,안정}	경상북도에 거주하는 30-39 주부. 정치 성향은 중도이며 환경, 전통, 안정 가치를 중시한다.	{"brandLoyalty": 26, "noveltySeeking": 60, "ecoConsciousness": 51, "priceSensitivity": 48, "digitalConsumption": 65}	{"taxTolerance": 45, "governmentTrust": 49, "policyAcceptance": 28, "regulationPreference": 66, "publicServiceSatisfaction": 50}	0
1759	류유준	34	30-39	Male	경상북도	36.636439	128.561478	고졸 이하	200-350만원	서비스직	부부 가구	56	보수 정당 지지	39	{"economy": 43, "housing": 17, "welfare": -34, "security": 29, "environment": 2}	포털 뉴스	{다양성,전통,공동체}	경상북도에 거주하는 30-39 서비스직. 정치 성향은 보수이며 다양성, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 68, "ecoConsciousness": 45, "priceSensitivity": 62, "digitalConsumption": 76}	{"taxTolerance": 61, "governmentTrust": 52, "policyAcceptance": 44, "regulationPreference": 61, "publicServiceSatisfaction": 71}	0
1760	최영수	41	40-49	Female	경상북도	36.597066	128.46052	대학교 졸	500-700만원	생산직	부부 가구	29	보수 성향 무당층	71	{"economy": 20, "housing": -2, "welfare": -3, "security": 21, "environment": 9}	지상파/종편 뉴스	{자유,전통,공정}	경상북도에 거주하는 40-49 생산직. 정치 성향은 중도이며 자유, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 92, "ecoConsciousness": 68, "priceSensitivity": 63, "digitalConsumption": 49}	{"taxTolerance": 35, "governmentTrust": 39, "policyAcceptance": 58, "regulationPreference": 58, "publicServiceSatisfaction": 56}	0
1761	오미경	43	40-49	Female	경상북도	36.550215	128.432587	대학교 졸	200-350만원	생산직	1인 가구	9	중도 무당층	63	{"economy": -6, "housing": 0, "welfare": 16, "security": 26, "environment": 8}	SNS	{다양성,안정,안전}	경상북도에 거주하는 40-49 생산직. 정치 성향은 중도이며 다양성, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 54, "ecoConsciousness": 48, "priceSensitivity": 64, "digitalConsumption": 56}	{"taxTolerance": 51, "governmentTrust": 46, "policyAcceptance": 30, "regulationPreference": 55, "publicServiceSatisfaction": 60}	0
1762	한주원	48	40-49	Female	경상북도	36.546797	128.494932	대학교 졸	700만원 이상	은퇴	다세대 가구	37	보수 성향 무당층	56	{"economy": 24, "housing": 13, "welfare": -12, "security": 16, "environment": 2}	지상파/종편 뉴스	{자유,다양성,성장}	경상북도에 거주하는 40-49 은퇴. 정치 성향은 보수이며 자유, 다양성, 성장 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 54, "ecoConsciousness": 57, "priceSensitivity": 53, "digitalConsumption": 72}	{"taxTolerance": 34, "governmentTrust": 60, "policyAcceptance": 56, "regulationPreference": 77, "publicServiceSatisfaction": 53}	0
1763	송채원	43	40-49	Female	경상북도	36.56339	128.498233	고졸 이하	500-700만원	사무직	자녀 양육 가구	14	중도 무당층	71	{"economy": -15, "housing": 30, "welfare": 8, "security": 6, "environment": 12}	포털 뉴스	{다양성,전통,공정}	경상북도에 거주하는 40-49 사무직. 정치 성향은 중도이며 다양성, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 56, "ecoConsciousness": 60, "priceSensitivity": 43, "digitalConsumption": 49}	{"taxTolerance": 44, "governmentTrust": 29, "policyAcceptance": 60, "regulationPreference": 48, "publicServiceSatisfaction": 75}	0
1764	홍서연	45	40-49	Male	경상북도	36.526833	128.418186	대학원 졸	200-350만원	생산직	1인 가구	54	보수 정당 지지	57	{"economy": 26, "housing": 7, "welfare": -13, "security": 45, "environment": -6}	유튜브	{전통,환경,공동체}	경상북도에 거주하는 40-49 생산직. 정치 성향은 보수이며 전통, 환경, 공동체 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 67, "ecoConsciousness": 57, "priceSensitivity": 80, "digitalConsumption": 82}	{"taxTolerance": 39, "governmentTrust": 59, "policyAcceptance": 68, "regulationPreference": 45, "publicServiceSatisfaction": 65}	0
1765	홍다은	46	40-49	Male	경상북도	36.534439	128.448283	대학교 졸	350-500만원	서비스직	부부 가구	7	중도 무당층	73	{"economy": 0, "housing": 19, "welfare": -10, "security": 31, "environment": 30}	유튜브	{안정,성장,다양성}	경상북도에 거주하는 40-49 서비스직. 정치 성향은 중도이며 안정, 성장, 다양성 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 68, "ecoConsciousness": 46, "priceSensitivity": 64, "digitalConsumption": 65}	{"taxTolerance": 49, "governmentTrust": 27, "policyAcceptance": 43, "regulationPreference": 66, "publicServiceSatisfaction": 76}	0
1766	최순자	40	40-49	Male	경상북도	36.555518	128.481848	고졸 이하	700만원 이상	공무원	다세대 가구	30	보수 성향 무당층	53	{"economy": 26, "housing": -6, "welfare": 30, "security": -5, "environment": -3}	지상파/종편 뉴스	{환경,성장,공동체}	경상북도에 거주하는 40-49 공무원. 정치 성향은 중도이며 환경, 성장, 공동체 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 68, "ecoConsciousness": 52, "priceSensitivity": 48, "digitalConsumption": 77}	{"taxTolerance": 38, "governmentTrust": 38, "policyAcceptance": 59, "regulationPreference": 53, "publicServiceSatisfaction": 51}	0
1767	최현우	48	40-49	Male	경상북도	36.646564	128.604145	전문대 졸	350-500만원	주부	부부 가구	59	보수 정당 지지	67	{"economy": 44, "housing": 10, "welfare": -35, "security": 40, "environment": -17}	유튜브	{전통,자유,성장}	경상북도에 거주하는 40-49 주부. 정치 성향은 보수이며 전통, 자유, 성장 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 46, "ecoConsciousness": 52, "priceSensitivity": 68, "digitalConsumption": 61}	{"taxTolerance": 42, "governmentTrust": 45, "policyAcceptance": 45, "regulationPreference": 56, "publicServiceSatisfaction": 56}	0
1768	정수아	51	50-59	Female	경상북도	36.616897	128.409188	대학교 졸	700만원 이상	전문직	부부 가구	23	보수 성향 무당층	71	{"economy": 3, "housing": 0, "welfare": -37, "security": 3, "environment": 15}	포털 뉴스	{혁신,성장,전통}	경상북도에 거주하는 50-59 전문직. 정치 성향은 중도이며 혁신, 성장, 전통 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 61, "ecoConsciousness": 44, "priceSensitivity": 40, "digitalConsumption": 64}	{"taxTolerance": 61, "governmentTrust": 51, "policyAcceptance": 49, "regulationPreference": 49, "publicServiceSatisfaction": 71}	0
1769	박서연	56	50-59	Female	경상북도	36.600334	128.408551	대학교 졸	700만원 이상	자영업	부부 가구	83	보수 정당 지지	59	{"economy": 54, "housing": -7, "welfare": -40, "security": 54, "environment": -8}	SNS	{공동체,혁신,다양성}	경상북도에 거주하는 50-59 자영업. 정치 성향은 보수이며 공동체, 혁신, 다양성 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 59, "ecoConsciousness": 77, "priceSensitivity": 35, "digitalConsumption": 68}	{"taxTolerance": 62, "governmentTrust": 52, "policyAcceptance": 59, "regulationPreference": 66, "publicServiceSatisfaction": 63}	0
1770	홍성호	57	50-59	Female	경상북도	36.554756	128.544938	대학원 졸	500-700만원	학생	1인 가구	46	보수 정당 지지	77	{"economy": 3, "housing": 26, "welfare": -11, "security": 51, "environment": 24}	SNS	{전통,성장,다양성}	경상북도에 거주하는 50-59 학생. 정치 성향은 보수이며 전통, 성장, 다양성 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 62, "ecoConsciousness": 59, "priceSensitivity": 36, "digitalConsumption": 55}	{"taxTolerance": 64, "governmentTrust": 50, "policyAcceptance": 45, "regulationPreference": 77, "publicServiceSatisfaction": 72}	0
1771	송정희	55	50-59	Female	경상북도	36.573988	128.588961	전문대 졸	700만원 이상	은퇴	자녀 양육 가구	49	보수 정당 지지	59	{"economy": 5, "housing": 18, "welfare": -38, "security": 41, "environment": -16}	지상파/종편 뉴스	{공동체,다양성,안전}	경상북도에 거주하는 50-59 은퇴. 정치 성향은 보수이며 공동체, 다양성, 안전 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 56, "ecoConsciousness": 54, "priceSensitivity": 49, "digitalConsumption": 67}	{"taxTolerance": 34, "governmentTrust": 61, "policyAcceptance": 58, "regulationPreference": 73, "publicServiceSatisfaction": 49}	0
1772	한주원	55	50-59	Male	경상북도	36.505645	128.52293	고졸 이하	350-500만원	서비스직	자녀 양육 가구	66	보수 정당 지지	69	{"economy": 25, "housing": 14, "welfare": -32, "security": 53, "environment": -3}	신문/팟캐스트	{안전,공동체,전통}	경상북도에 거주하는 50-59 서비스직. 정치 성향은 보수이며 안전, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 52, "ecoConsciousness": 21, "priceSensitivity": 65, "digitalConsumption": 67}	{"taxTolerance": 46, "governmentTrust": 50, "policyAcceptance": 53, "regulationPreference": 59, "publicServiceSatisfaction": 61}	0
1773	조지호	53	50-59	Male	경상북도	36.622354	128.435354	대학원 졸	200-350만원	학생	1인 가구	40	보수 성향 무당층	71	{"economy": 31, "housing": 8, "welfare": 25, "security": 45, "environment": 21}	포털 뉴스	{자유,공정,혁신}	경상북도에 거주하는 50-59 학생. 정치 성향은 보수이며 자유, 공정, 혁신 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 79, "ecoConsciousness": 59, "priceSensitivity": 54, "digitalConsumption": 60}	{"taxTolerance": 40, "governmentTrust": 45, "policyAcceptance": 48, "regulationPreference": 60, "publicServiceSatisfaction": 71}	0
1774	류경숙	52	50-59	Male	경상북도	36.533994	128.437158	대학원 졸	700만원 이상	자영업	부부 가구	39	보수 성향 무당층	63	{"economy": -24, "housing": -13, "welfare": -20, "security": 37, "environment": 11}	신문/팟캐스트	{성장,안전,전통}	경상북도에 거주하는 50-59 자영업. 정치 성향은 보수이며 성장, 안전, 전통 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 64, "ecoConsciousness": 67, "priceSensitivity": 63, "digitalConsumption": 79}	{"taxTolerance": 53, "governmentTrust": 21, "policyAcceptance": 50, "regulationPreference": 67, "publicServiceSatisfaction": 65}	0
1775	최도윤	50	50-59	Male	경상북도	36.57732	128.588786	대학교 졸	700만원 이상	서비스직	부부 가구	26	보수 성향 무당층	54	{"economy": 0, "housing": -5, "welfare": 8, "security": 9, "environment": 16}	포털 뉴스	{안전,다양성,공동체}	경상북도에 거주하는 50-59 서비스직. 정치 성향은 중도이며 안전, 다양성, 공동체 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 57, "ecoConsciousness": 53, "priceSensitivity": 45, "digitalConsumption": 73}	{"taxTolerance": 53, "governmentTrust": 53, "policyAcceptance": 52, "regulationPreference": 62, "publicServiceSatisfaction": 61}	0
1776	오주원	61	60-69	Female	경상북도	36.552917	128.493483	전문대 졸	200-350만원	프리랜서	다세대 가구	51	보수 정당 지지	74	{"economy": -12, "housing": 0, "welfare": -24, "security": 18, "environment": -8}	신문/팟캐스트	{전통,안전,공정}	경상북도에 거주하는 60-69 프리랜서. 정치 성향은 보수이며 전통, 안전, 공정 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 46, "ecoConsciousness": 36, "priceSensitivity": 69, "digitalConsumption": 68}	{"taxTolerance": 33, "governmentTrust": 53, "policyAcceptance": 42, "regulationPreference": 63, "publicServiceSatisfaction": 54}	0
1777	안지민	69	60-69	Female	경상북도	36.644281	128.494068	고졸 이하	350-500만원	은퇴	다세대 가구	46	보수 정당 지지	77	{"economy": 6, "housing": -14, "welfare": 1, "security": 22, "environment": -24}	포털 뉴스	{혁신,자유,안정}	경상북도에 거주하는 60-69 은퇴. 정치 성향은 보수이며 혁신, 자유, 안정 가치를 중시한다.	{"brandLoyalty": 90, "noveltySeeking": 54, "ecoConsciousness": 39, "priceSensitivity": 80, "digitalConsumption": 47}	{"taxTolerance": 58, "governmentTrust": 53, "policyAcceptance": 74, "regulationPreference": 55, "publicServiceSatisfaction": 64}	0
1778	신철수	68	60-69	Female	경상북도	36.548014	128.419728	전문대 졸	200-350만원	은퇴	1인 가구	44	보수 성향 무당층	67	{"economy": 28, "housing": -3, "welfare": -10, "security": 48, "environment": 22}	유튜브	{자유,전통,안정}	경상북도에 거주하는 60-69 은퇴. 정치 성향은 보수이며 자유, 전통, 안정 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 69, "ecoConsciousness": 47, "priceSensitivity": 42, "digitalConsumption": 46}	{"taxTolerance": 50, "governmentTrust": 54, "policyAcceptance": 48, "regulationPreference": 46, "publicServiceSatisfaction": 60}	0
1779	서현우	64	60-69	Male	경상북도	36.4991	128.488191	고졸 이하	350-500만원	프리랜서	부부 가구	77	보수 정당 지지	84	{"economy": 67, "housing": 19, "welfare": -31, "security": 68, "environment": 8}	SNS	{공동체,자유,혁신}	경상북도에 거주하는 60-69 프리랜서. 정치 성향은 보수이며 공동체, 자유, 혁신 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 42, "ecoConsciousness": 36, "priceSensitivity": 68, "digitalConsumption": 59}	{"taxTolerance": 46, "governmentTrust": 41, "policyAcceptance": 67, "regulationPreference": 60, "publicServiceSatisfaction": 74}	0
1780	오영수	62	60-69	Male	경상북도	36.522443	128.53583	고졸 이하	350-500만원	사무직	1인 가구	58	보수 정당 지지	78	{"economy": 19, "housing": -10, "welfare": -15, "security": 21, "environment": -3}	유튜브	{안전,환경,다양성}	경상북도에 거주하는 60-69 사무직. 정치 성향은 보수이며 안전, 환경, 다양성 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 71, "ecoConsciousness": 49, "priceSensitivity": 53, "digitalConsumption": 65}	{"taxTolerance": 40, "governmentTrust": 55, "policyAcceptance": 51, "regulationPreference": 59, "publicServiceSatisfaction": 64}	0
1781	임동현	67	60-69	Male	경상북도	36.598881	128.416129	대학교 졸	350-500만원	은퇴	1인 가구	71	보수 정당 지지	97	{"economy": 31, "housing": 11, "welfare": 12, "security": 35, "environment": -9}	포털 뉴스	{자유,공동체,안정}	경상북도에 거주하는 60-69 은퇴. 정치 성향은 보수이며 자유, 공동체, 안정 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 55, "ecoConsciousness": 46, "priceSensitivity": 68, "digitalConsumption": 85}	{"taxTolerance": 60, "governmentTrust": 59, "policyAcceptance": 51, "regulationPreference": 78, "publicServiceSatisfaction": 82}	0
1782	오하은	76	70+	Female	경상북도	36.626228	128.559447	대학교 졸	350-500만원	은퇴	1인 가구	71	보수 정당 지지	73	{"economy": 40, "housing": -15, "welfare": -17, "security": 30, "environment": -23}	SNS	{안전,환경,다양성}	경상북도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안전, 환경, 다양성 가치를 중시한다.	{"brandLoyalty": 60, "noveltySeeking": 44, "ecoConsciousness": 44, "priceSensitivity": 69, "digitalConsumption": 53}	{"taxTolerance": 50, "governmentTrust": 50, "policyAcceptance": 40, "regulationPreference": 65, "publicServiceSatisfaction": 79}	0
1783	권예준	83	70+	Female	경상북도	36.619333	128.411211	대학교 졸	350-500만원	은퇴	부부 가구	77	보수 정당 지지	81	{"economy": 37, "housing": 8, "welfare": -21, "security": 50, "environment": -18}	신문/팟캐스트	{안정,환경,전통}	경상북도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안정, 환경, 전통 가치를 중시한다.	{"brandLoyalty": 63, "noveltySeeking": 37, "ecoConsciousness": 51, "priceSensitivity": 65, "digitalConsumption": 59}	{"taxTolerance": 37, "governmentTrust": 46, "policyAcceptance": 50, "regulationPreference": 68, "publicServiceSatisfaction": 82}	0
1784	한민준	79	70+	Female	경상북도	36.536504	128.575483	고졸 이하	350-500만원	은퇴	부부 가구	19	보수 성향 무당층	99	{"economy": 13, "housing": 18, "welfare": 21, "security": 13, "environment": 19}	유튜브	{다양성,안전,공정}	경상북도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 다양성, 안전, 공정 가치를 중시한다.	{"brandLoyalty": 71, "noveltySeeking": 63, "ecoConsciousness": 34, "priceSensitivity": 73, "digitalConsumption": 53}	{"taxTolerance": 41, "governmentTrust": 45, "policyAcceptance": 58, "regulationPreference": 54, "publicServiceSatisfaction": 80}	0
1785	이동현	72	70+	Male	경상북도	36.605463	128.528212	전문대 졸	200-350만원	은퇴	자녀 양육 가구	39	보수 성향 무당층	72	{"economy": 63, "housing": 5, "welfare": 13, "security": 25, "environment": -1}	포털 뉴스	{환경,자유,안정}	경상북도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 환경, 자유, 안정 가치를 중시한다.	{"brandLoyalty": 66, "noveltySeeking": 50, "ecoConsciousness": 55, "priceSensitivity": 65, "digitalConsumption": 35}	{"taxTolerance": 53, "governmentTrust": 65, "policyAcceptance": 32, "regulationPreference": 78, "publicServiceSatisfaction": 51}	0
1786	황주원	75	70+	Male	경상북도	36.518222	128.563544	대학원 졸	200-350만원	은퇴	1인 가구	50	보수 정당 지지	88	{"economy": 21, "housing": 11, "welfare": 15, "security": 42, "environment": 19}	유튜브	{혁신,성장,자유}	경상북도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 혁신, 성장, 자유 가치를 중시한다.	{"brandLoyalty": 68, "noveltySeeking": 60, "ecoConsciousness": 39, "priceSensitivity": 61, "digitalConsumption": 63}	{"taxTolerance": 40, "governmentTrust": 46, "policyAcceptance": 47, "regulationPreference": 63, "publicServiceSatisfaction": 58}	0
1787	황민서	81	70+	Male	경상북도	36.653759	128.584305	고졸 이하	500-700만원	은퇴	다세대 가구	29	보수 성향 무당층	80	{"economy": 0, "housing": 25, "welfare": 17, "security": 34, "environment": -9}	SNS	{다양성,안정,안전}	경상북도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 다양성, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 29, "ecoConsciousness": 28, "priceSensitivity": 66, "digitalConsumption": 37}	{"taxTolerance": 45, "governmentTrust": 41, "policyAcceptance": 44, "regulationPreference": 35, "publicServiceSatisfaction": 65}	0
1788	안지호	22	18-29	Female	경상남도	35.485947	128.282865	대학교 졸	200만원 미만	학생	다세대 가구	-11	중도 무당층	62	{"economy": -14, "housing": 37, "welfare": 38, "security": 8, "environment": 63}	SNS	{전통,공동체,환경}	경상남도에 거주하는 18-29 학생. 정치 성향은 중도이며 전통, 공동체, 환경 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 86, "ecoConsciousness": 42, "priceSensitivity": 69, "digitalConsumption": 92}	{"taxTolerance": 38, "governmentTrust": 35, "policyAcceptance": 43, "regulationPreference": 67, "publicServiceSatisfaction": 73}	0
1789	송준서	22	18-29	Female	경상남도	35.397443	128.156969	대학원 졸	350-500만원	학생	부부 가구	-37	진보 성향 무당층	49	{"economy": -19, "housing": 41, "welfare": 58, "security": -9, "environment": 6}	유튜브	{혁신,전통,안정}	경상남도에 거주하는 18-29 학생. 정치 성향은 진보이며 혁신, 전통, 안정 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 71, "ecoConsciousness": 46, "priceSensitivity": 62, "digitalConsumption": 77}	{"taxTolerance": 60, "governmentTrust": 48, "policyAcceptance": 41, "regulationPreference": 44, "publicServiceSatisfaction": 69}	0
1790	최서연	23	18-29	Female	경상남도	35.473109	128.213764	대학원 졸	350-500만원	전문직	다세대 가구	17	보수 성향 무당층	55	{"economy": 13, "housing": 6, "welfare": 3, "security": 36, "environment": -23}	SNS	{공정,다양성,안정}	경상남도에 거주하는 18-29 전문직. 정치 성향은 중도이며 공정, 다양성, 안정 가치를 중시한다.	{"brandLoyalty": 24, "noveltySeeking": 92, "ecoConsciousness": 52, "priceSensitivity": 76, "digitalConsumption": 76}	{"taxTolerance": 73, "governmentTrust": 23, "policyAcceptance": 45, "regulationPreference": 65, "publicServiceSatisfaction": 52}	0
1791	박지우	19	18-29	Female	경상남도	35.505474	128.277946	전문대 졸	350-500만원	학생	다세대 가구	15	보수 성향 무당층	24	{"economy": -21, "housing": 15, "welfare": -4, "security": 5, "environment": 5}	SNS	{공정,혁신,환경}	경상남도에 거주하는 18-29 학생. 정치 성향은 중도이며 공정, 혁신, 환경 가치를 중시한다.	{"brandLoyalty": 21, "noveltySeeking": 77, "ecoConsciousness": 44, "priceSensitivity": 32, "digitalConsumption": 72}	{"taxTolerance": 35, "governmentTrust": 59, "policyAcceptance": 51, "regulationPreference": 52, "publicServiceSatisfaction": 73}	0
1792	오철수	21	18-29	Male	경상남도	35.509045	128.115358	대학원 졸	200-350만원	학생	자녀 양육 가구	-22	진보 성향 무당층	45	{"economy": -21, "housing": 16, "welfare": 39, "security": -22, "environment": 17}	신문/팟캐스트	{안전,공동체,성장}	경상남도에 거주하는 18-29 학생. 정치 성향은 중도이며 안전, 공동체, 성장 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 57, "ecoConsciousness": 62, "priceSensitivity": 79, "digitalConsumption": 77}	{"taxTolerance": 27, "governmentTrust": 41, "policyAcceptance": 45, "regulationPreference": 62, "publicServiceSatisfaction": 67}	0
1793	류지민	20	18-29	Male	경상남도	35.464355	128.187216	대학원 졸	200-350만원	학생	자녀 양육 가구	27	보수 성향 무당층	41	{"economy": -15, "housing": 13, "welfare": 27, "security": 26, "environment": 28}	SNS	{성장,안정,전통}	경상남도에 거주하는 18-29 학생. 정치 성향은 중도이며 성장, 안정, 전통 가치를 중시한다.	{"brandLoyalty": 17, "noveltySeeking": 84, "ecoConsciousness": 48, "priceSensitivity": 77, "digitalConsumption": 94}	{"taxTolerance": 49, "governmentTrust": 34, "policyAcceptance": 45, "regulationPreference": 63, "publicServiceSatisfaction": 58}	0
1794	황지민	22	18-29	Male	경상남도	35.413338	128.115436	대학교 졸	500-700만원	학생	1인 가구	-44	진보 성향 무당층	23	{"economy": -41, "housing": 34, "welfare": 41, "security": -23, "environment": 38}	SNS	{안전,성장,전통}	경상남도에 거주하는 18-29 학생. 정치 성향은 진보이며 안전, 성장, 전통 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 73, "ecoConsciousness": 57, "priceSensitivity": 64, "digitalConsumption": 72}	{"taxTolerance": 59, "governmentTrust": 35, "policyAcceptance": 46, "regulationPreference": 62, "publicServiceSatisfaction": 71}	0
1795	권지우	28	18-29	Male	경상남도	35.517932	128.250356	고졸 이하	200만원 미만	공무원	부부 가구	28	보수 성향 무당층	59	{"economy": 6, "housing": -1, "welfare": -13, "security": -3, "environment": 0}	지상파/종편 뉴스	{다양성,자유,전통}	경상남도에 거주하는 18-29 공무원. 정치 성향은 중도이며 다양성, 자유, 전통 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 53, "ecoConsciousness": 47, "priceSensitivity": 69, "digitalConsumption": 83}	{"taxTolerance": 54, "governmentTrust": 45, "policyAcceptance": 45, "regulationPreference": 75, "publicServiceSatisfaction": 72}	0
1796	신건우	38	30-39	Female	경상남도	35.507358	128.258874	대학교 졸	500-700만원	주부	1인 가구	1	중도 무당층	52	{"economy": 29, "housing": 25, "welfare": 12, "security": -9, "environment": 29}	지상파/종편 뉴스	{공정,성장,전통}	경상남도에 거주하는 30-39 주부. 정치 성향은 중도이며 공정, 성장, 전통 가치를 중시한다.	{"brandLoyalty": 18, "noveltySeeking": 65, "ecoConsciousness": 52, "priceSensitivity": 48, "digitalConsumption": 67}	{"taxTolerance": 58, "governmentTrust": 51, "policyAcceptance": 39, "regulationPreference": 75, "publicServiceSatisfaction": 62}	0
1797	안서윤	33	30-39	Female	경상남도	35.464655	128.26235	대학원 졸	350-500만원	사무직	자녀 양육 가구	6	중도 무당층	61	{"economy": -9, "housing": 4, "welfare": 22, "security": 24, "environment": 31}	지상파/종편 뉴스	{환경,다양성,안정}	경상남도에 거주하는 30-39 사무직. 정치 성향은 중도이며 환경, 다양성, 안정 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 82, "ecoConsciousness": 62, "priceSensitivity": 57, "digitalConsumption": 51}	{"taxTolerance": 48, "governmentTrust": 55, "policyAcceptance": 48, "regulationPreference": 64, "publicServiceSatisfaction": 82}	0
1798	신하은	39	30-39	Female	경상남도	35.409645	128.20492	전문대 졸	500-700만원	자영업	자녀 양육 가구	-1	중도 무당층	55	{"economy": 1, "housing": 22, "welfare": -3, "security": 20, "environment": 37}	지상파/종편 뉴스	{안전,다양성,공정}	경상남도에 거주하는 30-39 자영업. 정치 성향은 중도이며 안전, 다양성, 공정 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 52, "ecoConsciousness": 48, "priceSensitivity": 43, "digitalConsumption": 95}	{"taxTolerance": 55, "governmentTrust": 35, "policyAcceptance": 46, "regulationPreference": 67, "publicServiceSatisfaction": 69}	0
1799	오순자	36	30-39	Female	경상남도	35.510493	128.299648	대학교 졸	700만원 이상	공무원	다세대 가구	-21	진보 성향 무당층	51	{"economy": -34, "housing": 23, "welfare": 23, "security": -30, "environment": 50}	신문/팟캐스트	{공정,혁신,자유}	경상남도에 거주하는 30-39 공무원. 정치 성향은 중도이며 공정, 혁신, 자유 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 69, "ecoConsciousness": 39, "priceSensitivity": 35, "digitalConsumption": 97}	{"taxTolerance": 43, "governmentTrust": 37, "policyAcceptance": 48, "regulationPreference": 58, "publicServiceSatisfaction": 75}	0
1800	류수아	35	30-39	Male	경상남도	35.512275	128.222567	대학교 졸	350-500만원	사무직	다세대 가구	-15	진보 성향 무당층	53	{"economy": -3, "housing": 5, "welfare": 39, "security": -19, "environment": 9}	신문/팟캐스트	{자유,안전,전통}	경상남도에 거주하는 30-39 사무직. 정치 성향은 중도이며 자유, 안전, 전통 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 61, "ecoConsciousness": 23, "priceSensitivity": 55, "digitalConsumption": 89}	{"taxTolerance": 41, "governmentTrust": 54, "policyAcceptance": 54, "regulationPreference": 57, "publicServiceSatisfaction": 52}	0
1801	안영수	34	30-39	Male	경상남도	35.536583	128.218673	전문대 졸	350-500만원	공무원	부부 가구	0	중도 무당층	29	{"economy": -9, "housing": 41, "welfare": 4, "security": 13, "environment": 15}	SNS	{공동체,공정,안전}	경상남도에 거주하는 30-39 공무원. 정치 성향은 중도이며 공동체, 공정, 안전 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 56, "ecoConsciousness": 58, "priceSensitivity": 47, "digitalConsumption": 73}	{"taxTolerance": 41, "governmentTrust": 28, "policyAcceptance": 38, "regulationPreference": 58, "publicServiceSatisfaction": 60}	0
1802	전주원	31	30-39	Male	경상남도	35.404248	128.260575	대학원 졸	350-500만원	자영업	1인 가구	40	보수 성향 무당층	63	{"economy": 21, "housing": 10, "welfare": 4, "security": 23, "environment": 4}	유튜브	{다양성,전통,공동체}	경상남도에 거주하는 30-39 자영업. 정치 성향은 보수이며 다양성, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 84, "ecoConsciousness": 71, "priceSensitivity": 61, "digitalConsumption": 72}	{"taxTolerance": 49, "governmentTrust": 35, "policyAcceptance": 42, "regulationPreference": 56, "publicServiceSatisfaction": 52}	0
1803	임순자	39	30-39	Male	경상남도	35.420415	128.140044	대학교 졸	500-700만원	공무원	다세대 가구	22	보수 성향 무당층	63	{"economy": 5, "housing": 16, "welfare": 23, "security": 17, "environment": 10}	신문/팟캐스트	{공정,안정,성장}	경상남도에 거주하는 30-39 공무원. 정치 성향은 중도이며 공정, 안정, 성장 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 59, "ecoConsciousness": 46, "priceSensitivity": 66, "digitalConsumption": 74}	{"taxTolerance": 37, "governmentTrust": 39, "policyAcceptance": 41, "regulationPreference": 69, "publicServiceSatisfaction": 53}	0
1804	전경숙	43	40-49	Female	경상남도	35.452911	128.202472	대학교 졸	700만원 이상	공무원	자녀 양육 가구	-1	중도 무당층	56	{"economy": -18, "housing": 18, "welfare": 3, "security": -16, "environment": 27}	SNS	{성장,안전,전통}	경상남도에 거주하는 40-49 공무원. 정치 성향은 중도이며 성장, 안전, 전통 가치를 중시한다.	{"brandLoyalty": 23, "noveltySeeking": 71, "ecoConsciousness": 34, "priceSensitivity": 48, "digitalConsumption": 74}	{"taxTolerance": 49, "governmentTrust": 45, "policyAcceptance": 29, "regulationPreference": 55, "publicServiceSatisfaction": 75}	0
1805	최성호	46	40-49	Female	경상남도	35.508054	128.174012	전문대 졸	500-700만원	전문직	다세대 가구	19	보수 성향 무당층	55	{"economy": 27, "housing": 11, "welfare": 0, "security": 21, "environment": 16}	지상파/종편 뉴스	{혁신,공동체,성장}	경상남도에 거주하는 40-49 전문직. 정치 성향은 중도이며 혁신, 공동체, 성장 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 53, "ecoConsciousness": 64, "priceSensitivity": 54, "digitalConsumption": 79}	{"taxTolerance": 61, "governmentTrust": 53, "policyAcceptance": 57, "regulationPreference": 68, "publicServiceSatisfaction": 79}	0
1806	전은우	42	40-49	Female	경상남도	35.470693	128.250134	전문대 졸	500-700만원	주부	자녀 양육 가구	4	중도 무당층	83	{"economy": -6, "housing": 3, "welfare": 2, "security": -19, "environment": 37}	지상파/종편 뉴스	{전통,공동체,환경}	경상남도에 거주하는 40-49 주부. 정치 성향은 중도이며 전통, 공동체, 환경 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 79, "ecoConsciousness": 31, "priceSensitivity": 46, "digitalConsumption": 80}	{"taxTolerance": 28, "governmentTrust": 57, "policyAcceptance": 69, "regulationPreference": 61, "publicServiceSatisfaction": 81}	0
1807	오도윤	40	40-49	Female	경상남도	35.517413	128.275234	고졸 이하	350-500만원	프리랜서	자녀 양육 가구	39	보수 성향 무당층	62	{"economy": 24, "housing": 0, "welfare": -2, "security": 34, "environment": 16}	SNS	{혁신,성장,공정}	경상남도에 거주하는 40-49 프리랜서. 정치 성향은 보수이며 혁신, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 52, "ecoConsciousness": 41, "priceSensitivity": 62, "digitalConsumption": 59}	{"taxTolerance": 33, "governmentTrust": 52, "policyAcceptance": 39, "regulationPreference": 79, "publicServiceSatisfaction": 62}	0
1808	전지민	45	40-49	Female	경상남도	35.426986	128.270575	대학교 졸	500-700만원	학생	1인 가구	12	중도 무당층	52	{"economy": 2, "housing": 0, "welfare": 43, "security": -1, "environment": 30}	유튜브	{안전,자유,전통}	경상남도에 거주하는 40-49 학생. 정치 성향은 중도이며 안전, 자유, 전통 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 74, "ecoConsciousness": 56, "priceSensitivity": 46, "digitalConsumption": 90}	{"taxTolerance": 55, "governmentTrust": 55, "policyAcceptance": 56, "regulationPreference": 46, "publicServiceSatisfaction": 76}	0
1809	장유준	47	40-49	Male	경상남도	35.510868	128.218596	전문대 졸	500-700만원	사무직	1인 가구	41	보수 성향 무당층	55	{"economy": 2, "housing": -6, "welfare": -7, "security": 40, "environment": -10}	포털 뉴스	{안정,성장,공동체}	경상남도에 거주하는 40-49 사무직. 정치 성향은 보수이며 안정, 성장, 공동체 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 51, "ecoConsciousness": 35, "priceSensitivity": 77, "digitalConsumption": 67}	{"taxTolerance": 38, "governmentTrust": 24, "policyAcceptance": 56, "regulationPreference": 61, "publicServiceSatisfaction": 72}	0
1810	권지호	46	40-49	Male	경상남도	35.488446	128.212959	대학교 졸	500-700만원	전문직	부부 가구	35	보수 성향 무당층	75	{"economy": 18, "housing": 15, "welfare": 1, "security": 19, "environment": 7}	신문/팟캐스트	{안전,안정,공정}	경상남도에 거주하는 40-49 전문직. 정치 성향은 보수이며 안전, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 69, "ecoConsciousness": 49, "priceSensitivity": 43, "digitalConsumption": 58}	{"taxTolerance": 65, "governmentTrust": 44, "policyAcceptance": 45, "regulationPreference": 56, "publicServiceSatisfaction": 49}	0
1811	류다은	47	40-49	Male	경상남도	35.417564	128.256305	전문대 졸	700만원 이상	생산직	자녀 양육 가구	49	보수 정당 지지	79	{"economy": 5, "housing": -11, "welfare": 17, "security": 28, "environment": -23}	신문/팟캐스트	{성장,혁신,공정}	경상남도에 거주하는 40-49 생산직. 정치 성향은 보수이며 성장, 혁신, 공정 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 53, "ecoConsciousness": 43, "priceSensitivity": 53, "digitalConsumption": 83}	{"taxTolerance": 40, "governmentTrust": 54, "policyAcceptance": 55, "regulationPreference": 52, "publicServiceSatisfaction": 62}	0
1812	홍지아	44	40-49	Male	경상남도	35.440178	128.215601	대학교 졸	200만원 미만	프리랜서	1인 가구	20	보수 성향 무당층	54	{"economy": 13, "housing": -14, "welfare": 8, "security": -20, "environment": -2}	지상파/종편 뉴스	{공동체,안전,다양성}	경상남도에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 공동체, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 65, "ecoConsciousness": 49, "priceSensitivity": 55, "digitalConsumption": 68}	{"taxTolerance": 56, "governmentTrust": 43, "policyAcceptance": 57, "regulationPreference": 60, "publicServiceSatisfaction": 55}	0
1813	오건우	41	40-49	Male	경상남도	35.408656	128.17012	대학원 졸	200-350만원	생산직	1인 가구	14	중도 무당층	75	{"economy": 25, "housing": -21, "welfare": 37, "security": 37, "environment": 16}	지상파/종편 뉴스	{다양성,혁신,안정}	경상남도에 거주하는 40-49 생산직. 정치 성향은 중도이며 다양성, 혁신, 안정 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 46, "ecoConsciousness": 52, "priceSensitivity": 81, "digitalConsumption": 76}	{"taxTolerance": 58, "governmentTrust": 26, "policyAcceptance": 24, "regulationPreference": 56, "publicServiceSatisfaction": 64}	0
1814	홍경숙	53	50-59	Female	경상남도	35.387679	128.212237	전문대 졸	200-350만원	전문직	다세대 가구	19	보수 성향 무당층	67	{"economy": 5, "housing": 16, "welfare": 2, "security": 14, "environment": 29}	지상파/종편 뉴스	{안전,환경,안정}	경상남도에 거주하는 50-59 전문직. 정치 성향은 중도이며 안전, 환경, 안정 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 36, "ecoConsciousness": 29, "priceSensitivity": 76, "digitalConsumption": 58}	{"taxTolerance": 54, "governmentTrust": 48, "policyAcceptance": 54, "regulationPreference": 50, "publicServiceSatisfaction": 60}	0
1815	송혜진	52	50-59	Female	경상남도	35.538508	128.20521	대학교 졸	500-700만원	은퇴	1인 가구	52	보수 정당 지지	66	{"economy": 23, "housing": 29, "welfare": -39, "security": 27, "environment": -13}	SNS	{공정,안전,혁신}	경상남도에 거주하는 50-59 은퇴. 정치 성향은 보수이며 공정, 안전, 혁신 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 39, "ecoConsciousness": 61, "priceSensitivity": 63, "digitalConsumption": 75}	{"taxTolerance": 62, "governmentTrust": 41, "policyAcceptance": 37, "regulationPreference": 66, "publicServiceSatisfaction": 59}	0
1816	장광수	55	50-59	Female	경상남도	35.386993	128.213283	고졸 이하	500-700만원	은퇴	다세대 가구	42	보수 성향 무당층	55	{"economy": 24, "housing": 18, "welfare": -10, "security": 33, "environment": 16}	유튜브	{자유,안정,성장}	경상남도에 거주하는 50-59 은퇴. 정치 성향은 보수이며 자유, 안정, 성장 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 44, "ecoConsciousness": 45, "priceSensitivity": 49, "digitalConsumption": 72}	{"taxTolerance": 41, "governmentTrust": 38, "policyAcceptance": 46, "regulationPreference": 49, "publicServiceSatisfaction": 60}	0
1817	황도윤	52	50-59	Female	경상남도	35.401819	128.207705	대학교 졸	500-700만원	은퇴	자녀 양육 가구	23	보수 성향 무당층	51	{"economy": 14, "housing": 36, "welfare": 9, "security": 16, "environment": 14}	유튜브	{자유,안전,안정}	경상남도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 자유, 안전, 안정 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 62, "ecoConsciousness": 62, "priceSensitivity": 56, "digitalConsumption": 67}	{"taxTolerance": 22, "governmentTrust": 53, "policyAcceptance": 50, "regulationPreference": 71, "publicServiceSatisfaction": 80}	0
1818	권수아	54	50-59	Female	경상남도	35.432456	128.16006	대학원 졸	700만원 이상	공무원	자녀 양육 가구	26	보수 성향 무당층	48	{"economy": -10, "housing": 0, "welfare": 10, "security": -1, "environment": 17}	SNS	{성장,혁신,안전}	경상남도에 거주하는 50-59 공무원. 정치 성향은 중도이며 성장, 혁신, 안전 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 56, "ecoConsciousness": 45, "priceSensitivity": 38, "digitalConsumption": 64}	{"taxTolerance": 68, "governmentTrust": 51, "policyAcceptance": 42, "regulationPreference": 52, "publicServiceSatisfaction": 69}	0
1819	정민준	53	50-59	Male	경상남도	35.420008	128.253534	전문대 졸	500-700만원	사무직	자녀 양육 가구	4	중도 무당층	61	{"economy": 1, "housing": -16, "welfare": -9, "security": 46, "environment": 37}	지상파/종편 뉴스	{공동체,안정,성장}	경상남도에 거주하는 50-59 사무직. 정치 성향은 중도이며 공동체, 안정, 성장 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 53, "ecoConsciousness": 45, "priceSensitivity": 43, "digitalConsumption": 70}	{"taxTolerance": 25, "governmentTrust": 34, "policyAcceptance": 41, "regulationPreference": 73, "publicServiceSatisfaction": 79}	0
1820	최서연	52	50-59	Male	경상남도	35.42633	128.138829	전문대 졸	200-350만원	공무원	1인 가구	33	보수 성향 무당층	81	{"economy": 2, "housing": 7, "welfare": 23, "security": 18, "environment": 16}	신문/팟캐스트	{성장,다양성,안전}	경상남도에 거주하는 50-59 공무원. 정치 성향은 중도이며 성장, 다양성, 안전 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 41, "ecoConsciousness": 38, "priceSensitivity": 66, "digitalConsumption": 63}	{"taxTolerance": 50, "governmentTrust": 31, "policyAcceptance": 40, "regulationPreference": 64, "publicServiceSatisfaction": 77}	0
1821	강민서	59	50-59	Male	경상남도	35.38381	128.26055	고졸 이하	350-500만원	사무직	다세대 가구	27	보수 성향 무당층	70	{"economy": 34, "housing": 15, "welfare": -23, "security": 24, "environment": 29}	신문/팟캐스트	{혁신,환경,안전}	경상남도에 거주하는 50-59 사무직. 정치 성향은 중도이며 혁신, 환경, 안전 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 52, "ecoConsciousness": 44, "priceSensitivity": 68, "digitalConsumption": 60}	{"taxTolerance": 53, "governmentTrust": 82, "policyAcceptance": 35, "regulationPreference": 55, "publicServiceSatisfaction": 63}	0
1822	조정희	59	50-59	Male	경상남도	35.428502	128.282094	대학교 졸	350-500만원	은퇴	1인 가구	48	보수 정당 지지	62	{"economy": 19, "housing": 1, "welfare": -8, "security": -16, "environment": -17}	지상파/종편 뉴스	{안정,혁신,성장}	경상남도에 거주하는 50-59 은퇴. 정치 성향은 보수이며 안정, 혁신, 성장 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 41, "ecoConsciousness": 51, "priceSensitivity": 59, "digitalConsumption": 68}	{"taxTolerance": 57, "governmentTrust": 46, "policyAcceptance": 59, "regulationPreference": 56, "publicServiceSatisfaction": 67}	0
1823	안영수	52	50-59	Male	경상남도	35.477747	128.121971	대학교 졸	350-500만원	학생	1인 가구	25	보수 성향 무당층	84	{"economy": 25, "housing": 7, "welfare": -3, "security": 16, "environment": 18}	SNS	{환경,공정,자유}	경상남도에 거주하는 50-59 학생. 정치 성향은 중도이며 환경, 공정, 자유 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 51, "ecoConsciousness": 56, "priceSensitivity": 58, "digitalConsumption": 74}	{"taxTolerance": 30, "governmentTrust": 60, "policyAcceptance": 48, "regulationPreference": 44, "publicServiceSatisfaction": 65}	0
1824	정지아	62	60-69	Female	경상남도	35.401448	128.141618	대학교 졸	200-350만원	프리랜서	부부 가구	51	보수 정당 지지	76	{"economy": 20, "housing": -17, "welfare": -5, "security": 49, "environment": 20}	유튜브	{다양성,안전,성장}	경상남도에 거주하는 60-69 프리랜서. 정치 성향은 보수이며 다양성, 안전, 성장 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 66, "ecoConsciousness": 53, "priceSensitivity": 79, "digitalConsumption": 75}	{"taxTolerance": 29, "governmentTrust": 48, "policyAcceptance": 27, "regulationPreference": 66, "publicServiceSatisfaction": 57}	0
1825	류광수	61	60-69	Female	경상남도	35.454034	128.184977	대학원 졸	200만원 미만	생산직	다세대 가구	-22	진보 성향 무당층	78	{"economy": -42, "housing": 16, "welfare": 34, "security": -6, "environment": 17}	유튜브	{안전,공동체,성장}	경상남도에 거주하는 60-69 생산직. 정치 성향은 중도이며 안전, 공동체, 성장 가치를 중시한다.	{"brandLoyalty": 63, "noveltySeeking": 55, "ecoConsciousness": 47, "priceSensitivity": 75, "digitalConsumption": 69}	{"taxTolerance": 39, "governmentTrust": 53, "policyAcceptance": 35, "regulationPreference": 49, "publicServiceSatisfaction": 76}	0
1826	전지호	60	60-69	Female	경상남도	35.49639	128.311924	고졸 이하	200-350만원	은퇴	자녀 양육 가구	28	보수 성향 무당층	68	{"economy": 8, "housing": -18, "welfare": -10, "security": 33, "environment": 4}	포털 뉴스	{자유,전통,공정}	경상남도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 자유, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 19, "noveltySeeking": 58, "ecoConsciousness": 32, "priceSensitivity": 61, "digitalConsumption": 80}	{"taxTolerance": 56, "governmentTrust": 59, "policyAcceptance": 55, "regulationPreference": 70, "publicServiceSatisfaction": 57}	0
1827	윤은우	64	60-69	Female	경상남도	35.398149	128.168485	전문대 졸	350-500만원	생산직	1인 가구	29	보수 성향 무당층	96	{"economy": 5, "housing": -19, "welfare": 3, "security": 25, "environment": 11}	SNS	{안전,환경,자유}	경상남도에 거주하는 60-69 생산직. 정치 성향은 중도이며 안전, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 45, "ecoConsciousness": 64, "priceSensitivity": 76, "digitalConsumption": 59}	{"taxTolerance": 60, "governmentTrust": 35, "policyAcceptance": 69, "regulationPreference": 66, "publicServiceSatisfaction": 44}	0
1828	홍지호	60	60-69	Male	경상남도	35.412519	128.122179	전문대 졸	350-500만원	주부	자녀 양육 가구	53	보수 정당 지지	69	{"economy": 31, "housing": -18, "welfare": -4, "security": 38, "environment": 16}	유튜브	{혁신,안정,성장}	경상남도에 거주하는 60-69 주부. 정치 성향은 보수이며 혁신, 안정, 성장 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 56, "ecoConsciousness": 40, "priceSensitivity": 60, "digitalConsumption": 63}	{"taxTolerance": 29, "governmentTrust": 28, "policyAcceptance": 50, "regulationPreference": 64, "publicServiceSatisfaction": 51}	0
1829	김순자	61	60-69	Male	경상남도	35.521674	128.290441	대학교 졸	200-350만원	서비스직	자녀 양육 가구	17	보수 성향 무당층	81	{"economy": 12, "housing": 14, "welfare": -4, "security": 29, "environment": 2}	신문/팟캐스트	{전통,혁신,공동체}	경상남도에 거주하는 60-69 서비스직. 정치 성향은 중도이며 전통, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 46, "ecoConsciousness": 47, "priceSensitivity": 63, "digitalConsumption": 52}	{"taxTolerance": 30, "governmentTrust": 47, "policyAcceptance": 57, "regulationPreference": 74, "publicServiceSatisfaction": 48}	0
1830	이채원	61	60-69	Male	경상남도	35.444676	128.271307	전문대 졸	500-700만원	전문직	부부 가구	30	보수 성향 무당층	79	{"economy": -5, "housing": 1, "welfare": 10, "security": 17, "environment": 11}	유튜브	{성장,혁신,공정}	경상남도에 거주하는 60-69 전문직. 정치 성향은 중도이며 성장, 혁신, 공정 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 43, "ecoConsciousness": 37, "priceSensitivity": 50, "digitalConsumption": 51}	{"taxTolerance": 35, "governmentTrust": 45, "policyAcceptance": 62, "regulationPreference": 64, "publicServiceSatisfaction": 64}	0
1831	이도윤	64	60-69	Male	경상남도	35.538453	128.21266	대학교 졸	500-700만원	학생	자녀 양육 가구	49	보수 정당 지지	66	{"economy": 39, "housing": -5, "welfare": 8, "security": 32, "environment": 10}	신문/팟캐스트	{안전,혁신,성장}	경상남도에 거주하는 60-69 학생. 정치 성향은 보수이며 안전, 혁신, 성장 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 63, "ecoConsciousness": 49, "priceSensitivity": 54, "digitalConsumption": 51}	{"taxTolerance": 37, "governmentTrust": 46, "policyAcceptance": 62, "regulationPreference": 61, "publicServiceSatisfaction": 57}	0
1832	오성호	75	70+	Female	경상남도	35.464836	128.299973	전문대 졸	200-350만원	은퇴	부부 가구	56	보수 정당 지지	89	{"economy": 29, "housing": 12, "welfare": -12, "security": 47, "environment": -7}	지상파/종편 뉴스	{안전,공동체,혁신}	경상남도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안전, 공동체, 혁신 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 50, "ecoConsciousness": 46, "priceSensitivity": 64, "digitalConsumption": 65}	{"taxTolerance": 44, "governmentTrust": 54, "policyAcceptance": 38, "regulationPreference": 74, "publicServiceSatisfaction": 63}	0
1833	장지우	76	70+	Female	경상남도	35.411651	128.273584	전문대 졸	500-700만원	은퇴	부부 가구	9	중도 무당층	80	{"economy": 2, "housing": -2, "welfare": 28, "security": 38, "environment": 2}	유튜브	{환경,공동체,전통}	경상남도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 환경, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 31, "ecoConsciousness": 40, "priceSensitivity": 59, "digitalConsumption": 60}	{"taxTolerance": 73, "governmentTrust": 58, "policyAcceptance": 50, "regulationPreference": 82, "publicServiceSatisfaction": 63}	0
1834	한주원	83	70+	Female	경상남도	35.469972	128.186684	전문대 졸	700만원 이상	은퇴	다세대 가구	52	보수 정당 지지	94	{"economy": 32, "housing": 6, "welfare": -28, "security": 21, "environment": -20}	포털 뉴스	{환경,공동체,성장}	경상남도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 환경, 공동체, 성장 가치를 중시한다.	{"brandLoyalty": 69, "noveltySeeking": 51, "ecoConsciousness": 46, "priceSensitivity": 32, "digitalConsumption": 55}	{"taxTolerance": 45, "governmentTrust": 54, "policyAcceptance": 47, "regulationPreference": 83, "publicServiceSatisfaction": 57}	0
1835	정도윤	84	70+	Female	경상남도	35.43414	128.118353	대학교 졸	200만원 미만	은퇴	1인 가구	52	보수 정당 지지	85	{"economy": 45, "housing": -2, "welfare": -25, "security": 66, "environment": -8}	지상파/종편 뉴스	{다양성,혁신,안전}	경상남도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 다양성, 혁신, 안전 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 42, "ecoConsciousness": 20, "priceSensitivity": 73, "digitalConsumption": 43}	{"taxTolerance": 50, "governmentTrust": 59, "policyAcceptance": 47, "regulationPreference": 75, "publicServiceSatisfaction": 58}	0
1836	장은우	84	70+	Male	경상남도	35.409632	128.164372	대학교 졸	200만원 미만	은퇴	자녀 양육 가구	8	중도 무당층	87	{"economy": 17, "housing": 13, "welfare": 14, "security": 18, "environment": 7}	신문/팟캐스트	{자유,전통,공정}	경상남도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 자유, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 35, "ecoConsciousness": 39, "priceSensitivity": 69, "digitalConsumption": 39}	{"taxTolerance": 69, "governmentTrust": 47, "policyAcceptance": 48, "regulationPreference": 68, "publicServiceSatisfaction": 68}	0
1837	이동현	74	70+	Male	경상남도	35.463087	128.135086	대학원 졸	200-350만원	은퇴	다세대 가구	18	보수 성향 무당층	91	{"economy": 14, "housing": 1, "welfare": -13, "security": 1, "environment": 3}	포털 뉴스	{환경,안전,공동체}	경상남도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 환경, 안전, 공동체 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 56, "ecoConsciousness": 44, "priceSensitivity": 83, "digitalConsumption": 40}	{"taxTolerance": 31, "governmentTrust": 44, "policyAcceptance": 40, "regulationPreference": 73, "publicServiceSatisfaction": 71}	0
1838	홍성호	74	70+	Male	경상남도	35.452587	128.304485	전문대 졸	500-700만원	은퇴	부부 가구	23	보수 성향 무당층	61	{"economy": 7, "housing": 7, "welfare": -22, "security": 12, "environment": 8}	포털 뉴스	{안전,공정,안정}	경상남도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안전, 공정, 안정 가치를 중시한다.	{"brandLoyalty": 67, "noveltySeeking": 32, "ecoConsciousness": 45, "priceSensitivity": 63, "digitalConsumption": 52}	{"taxTolerance": 33, "governmentTrust": 64, "policyAcceptance": 59, "regulationPreference": 67, "publicServiceSatisfaction": 77}	0
1839	황정희	26	18-29	Female	제주특별자치도	33.52905	126.494317	대학교 졸	350-500만원	주부	자녀 양육 가구	-41	진보 성향 무당층	50	{"economy": -57, "housing": 31, "welfare": 44, "security": -7, "environment": 42}	SNS	{성장,자유,공동체}	제주특별자치도에 거주하는 18-29 주부. 정치 성향은 진보이며 성장, 자유, 공동체 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 65, "ecoConsciousness": 76, "priceSensitivity": 46, "digitalConsumption": 70}	{"taxTolerance": 65, "governmentTrust": 43, "policyAcceptance": 15, "regulationPreference": 25, "publicServiceSatisfaction": 51}	0
1840	류경숙	26	18-29	Male	제주특별자치도	33.429584	126.621201	대학원 졸	200만원 미만	전문직	1인 가구	-27	진보 성향 무당층	52	{"economy": -17, "housing": 13, "welfare": 33, "security": -8, "environment": 23}	신문/팟캐스트	{혁신,자유,전통}	제주특별자치도에 거주하는 18-29 전문직. 정치 성향은 중도이며 혁신, 자유, 전통 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 77, "ecoConsciousness": 70, "priceSensitivity": 70, "digitalConsumption": 96}	{"taxTolerance": 72, "governmentTrust": 37, "policyAcceptance": 55, "regulationPreference": 68, "publicServiceSatisfaction": 67}	0
1841	송서연	37	30-39	Female	제주특별자치도	33.508549	126.570172	대학원 졸	500-700만원	주부	다세대 가구	-1	중도 무당층	44	{"economy": 7, "housing": 48, "welfare": -11, "security": 5, "environment": 40}	신문/팟캐스트	{안전,환경,자유}	제주특별자치도에 거주하는 30-39 주부. 정치 성향은 중도이며 안전, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 62, "ecoConsciousness": 70, "priceSensitivity": 60, "digitalConsumption": 92}	{"taxTolerance": 67, "governmentTrust": 51, "policyAcceptance": 49, "regulationPreference": 47, "publicServiceSatisfaction": 86}	0
1842	장수아	30	30-39	Male	제주특별자치도	33.518969	126.453591	대학원 졸	200만원 미만	공무원	1인 가구	-43	진보 성향 무당층	47	{"economy": -26, "housing": 18, "welfare": 38, "security": 0, "environment": 62}	유튜브	{안정,자유,환경}	제주특별자치도에 거주하는 30-39 공무원. 정치 성향은 진보이며 안정, 자유, 환경 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 97, "ecoConsciousness": 39, "priceSensitivity": 55, "digitalConsumption": 65}	{"taxTolerance": 79, "governmentTrust": 37, "policyAcceptance": 33, "regulationPreference": 49, "publicServiceSatisfaction": 48}	0
1843	정건우	48	40-49	Female	제주특별자치도	33.421415	126.548167	대학원 졸	500-700만원	전문직	자녀 양육 가구	-1	중도 무당층	73	{"economy": 1, "housing": 27, "welfare": 36, "security": 9, "environment": 19}	신문/팟캐스트	{다양성,환경,자유}	제주특별자치도에 거주하는 40-49 전문직. 정치 성향은 중도이며 다양성, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 83, "ecoConsciousness": 66, "priceSensitivity": 58, "digitalConsumption": 64}	{"taxTolerance": 41, "governmentTrust": 43, "policyAcceptance": 45, "regulationPreference": 45, "publicServiceSatisfaction": 58}	0
1844	오정희	44	40-49	Male	제주특별자치도	33.524949	126.50444	전문대 졸	200만원 미만	사무직	다세대 가구	-9	중도 무당층	69	{"economy": -25, "housing": 36, "welfare": 1, "security": -4, "environment": 27}	지상파/종편 뉴스	{자유,전통,안전}	제주특별자치도에 거주하는 40-49 사무직. 정치 성향은 중도이며 자유, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 62, "ecoConsciousness": 50, "priceSensitivity": 73, "digitalConsumption": 69}	{"taxTolerance": 69, "governmentTrust": 55, "policyAcceptance": 52, "regulationPreference": 50, "publicServiceSatisfaction": 52}	0
1845	윤채원	51	50-59	Female	제주특별자치도	33.420729	126.591332	전문대 졸	500-700만원	자영업	자녀 양육 가구	3	중도 무당층	73	{"economy": 21, "housing": 33, "welfare": 29, "security": 30, "environment": 8}	유튜브	{공정,성장,자유}	제주특별자치도에 거주하는 50-59 자영업. 정치 성향은 중도이며 공정, 성장, 자유 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 62, "ecoConsciousness": 59, "priceSensitivity": 54, "digitalConsumption": 57}	{"taxTolerance": 46, "governmentTrust": 50, "policyAcceptance": 51, "regulationPreference": 58, "publicServiceSatisfaction": 75}	0
1846	김수아	53	50-59	Male	제주특별자치도	33.477462	126.446648	대학교 졸	700만원 이상	생산직	자녀 양육 가구	28	보수 성향 무당층	79	{"economy": 5, "housing": 6, "welfare": -17, "security": 25, "environment": 14}	유튜브	{안정,다양성,자유}	제주특별자치도에 거주하는 50-59 생산직. 정치 성향은 중도이며 안정, 다양성, 자유 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 75, "ecoConsciousness": 38, "priceSensitivity": 40, "digitalConsumption": 63}	{"taxTolerance": 42, "governmentTrust": 51, "policyAcceptance": 37, "regulationPreference": 75, "publicServiceSatisfaction": 65}	0
1847	강지아	68	60-69	Female	제주특별자치도	33.517751	126.588023	고졸 이하	350-500만원	은퇴	부부 가구	70	보수 정당 지지	75	{"economy": 10, "housing": 24, "welfare": -16, "security": 60, "environment": -7}	지상파/종편 뉴스	{전통,안전,혁신}	제주특별자치도에 거주하는 60-69 은퇴. 정치 성향은 보수이며 전통, 안전, 혁신 가치를 중시한다.	{"brandLoyalty": 63, "noveltySeeking": 38, "ecoConsciousness": 56, "priceSensitivity": 61, "digitalConsumption": 44}	{"taxTolerance": 35, "governmentTrust": 45, "policyAcceptance": 44, "regulationPreference": 77, "publicServiceSatisfaction": 75}	0
1848	신유준	61	60-69	Male	제주특별자치도	33.493166	126.624194	대학교 졸	200-350만원	서비스직	1인 가구	25	보수 성향 무당층	86	{"economy": -15, "housing": 5, "welfare": -13, "security": 22, "environment": 24}	지상파/종편 뉴스	{환경,전통,안정}	제주특별자치도에 거주하는 60-69 서비스직. 정치 성향은 중도이며 환경, 전통, 안정 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 57, "ecoConsciousness": 39, "priceSensitivity": 80, "digitalConsumption": 68}	{"taxTolerance": 29, "governmentTrust": 48, "policyAcceptance": 50, "regulationPreference": 73, "publicServiceSatisfaction": 51}	0
1849	오순자	80	70+	Female	제주특별자치도	33.497707	126.503978	고졸 이하	200만원 미만	은퇴	1인 가구	8	중도 무당층	83	{"economy": -19, "housing": -7, "welfare": -17, "security": 56, "environment": 28}	유튜브	{자유,안전,안정}	제주특별자치도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 자유, 안전, 안정 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 49, "ecoConsciousness": 44, "priceSensitivity": 71, "digitalConsumption": 47}	{"taxTolerance": 44, "governmentTrust": 53, "policyAcceptance": 61, "regulationPreference": 65, "publicServiceSatisfaction": 63}	0
1850	황민서	79	70+	Male	제주특별자치도	33.470248	126.517915	대학원 졸	350-500만원	은퇴	다세대 가구	41	보수 성향 무당층	75	{"economy": 7, "housing": 7, "welfare": 6, "security": 26, "environment": 33}	신문/팟캐스트	{다양성,혁신,환경}	제주특별자치도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 다양성, 혁신, 환경 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 39, "ecoConsciousness": 46, "priceSensitivity": 69, "digitalConsumption": 44}	{"taxTolerance": 54, "governmentTrust": 41, "policyAcceptance": 38, "regulationPreference": 64, "publicServiceSatisfaction": 72}	0
1851	오지우	25	18-29	Female	강원특별자치도	37.798515	128.101897	대학교 졸	200-350만원	자영업	다세대 가구	12	중도 무당층	57	{"economy": 2, "housing": 24, "welfare": 9, "security": -7, "environment": 35}	SNS	{성장,공정,전통}	강원특별자치도에 거주하는 18-29 자영업. 정치 성향은 중도이며 성장, 공정, 전통 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 69, "ecoConsciousness": 48, "priceSensitivity": 77, "digitalConsumption": 100}	{"taxTolerance": 39, "governmentTrust": 55, "policyAcceptance": 33, "regulationPreference": 42, "publicServiceSatisfaction": 74}	0
1852	정광수	26	18-29	Female	강원특별자치도	37.745291	128.124946	대학교 졸	350-500만원	자영업	1인 가구	-13	중도 무당층	28	{"economy": -16, "housing": 22, "welfare": 19, "security": 1, "environment": 36}	유튜브	{전통,안정,성장}	강원특별자치도에 거주하는 18-29 자영업. 정치 성향은 중도이며 전통, 안정, 성장 가치를 중시한다.	{"brandLoyalty": 25, "noveltySeeking": 57, "ecoConsciousness": 52, "priceSensitivity": 57, "digitalConsumption": 69}	{"taxTolerance": 41, "governmentTrust": 29, "policyAcceptance": 59, "regulationPreference": 58, "publicServiceSatisfaction": 67}	0
1853	오하은	21	18-29	Male	강원특별자치도	37.791646	128.23147	대학교 졸	500-700만원	학생	다세대 가구	-6	중도 무당층	43	{"economy": -6, "housing": 24, "welfare": 13, "security": 24, "environment": 37}	포털 뉴스	{성장,안정,환경}	강원특별자치도에 거주하는 18-29 학생. 정치 성향은 중도이며 성장, 안정, 환경 가치를 중시한다.	{"brandLoyalty": 11, "noveltySeeking": 80, "ecoConsciousness": 68, "priceSensitivity": 57, "digitalConsumption": 86}	{"taxTolerance": 55, "governmentTrust": 26, "policyAcceptance": 42, "regulationPreference": 60, "publicServiceSatisfaction": 66}	0
1854	이채원	19	18-29	Male	강원특별자치도	37.875565	128.16314	대학교 졸	200-350만원	학생	자녀 양육 가구	-20	진보 성향 무당층	42	{"economy": -13, "housing": 29, "welfare": 36, "security": -31, "environment": 47}	포털 뉴스	{혁신,공동체,성장}	강원특별자치도에 거주하는 18-29 학생. 정치 성향은 중도이며 혁신, 공동체, 성장 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 77, "ecoConsciousness": 52, "priceSensitivity": 74, "digitalConsumption": 93}	{"taxTolerance": 37, "governmentTrust": 59, "policyAcceptance": 34, "regulationPreference": 61, "publicServiceSatisfaction": 67}	0
1855	최지우	35	30-39	Female	강원특별자치도	37.861439	128.132711	대학원 졸	700만원 이상	은퇴	자녀 양육 가구	-3	중도 무당층	57	{"economy": -7, "housing": 24, "welfare": 4, "security": 23, "environment": 2}	지상파/종편 뉴스	{공정,안정,환경}	강원특별자치도에 거주하는 30-39 은퇴. 정치 성향은 중도이며 공정, 안정, 환경 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 90, "ecoConsciousness": 55, "priceSensitivity": 38, "digitalConsumption": 66}	{"taxTolerance": 47, "governmentTrust": 53, "policyAcceptance": 43, "regulationPreference": 55, "publicServiceSatisfaction": 49}	0
1856	홍지민	32	30-39	Female	강원특별자치도	37.892568	128.139162	대학원 졸	200-350만원	주부	자녀 양육 가구	-22	진보 성향 무당층	54	{"economy": -35, "housing": 41, "welfare": 18, "security": -5, "environment": 37}	포털 뉴스	{안정,성장,전통}	강원특별자치도에 거주하는 30-39 주부. 정치 성향은 중도이며 안정, 성장, 전통 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 55, "ecoConsciousness": 54, "priceSensitivity": 69, "digitalConsumption": 82}	{"taxTolerance": 57, "governmentTrust": 56, "policyAcceptance": 38, "regulationPreference": 69, "publicServiceSatisfaction": 93}	0
1857	홍미경	32	30-39	Male	강원특별자치도	37.8454	128.069261	대학원 졸	350-500만원	생산직	1인 가구	50	보수 정당 지지	54	{"economy": 23, "housing": 22, "welfare": -5, "security": 33, "environment": 7}	지상파/종편 뉴스	{자유,성장,다양성}	강원특별자치도에 거주하는 30-39 생산직. 정치 성향은 보수이며 자유, 성장, 다양성 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 68, "ecoConsciousness": 71, "priceSensitivity": 57, "digitalConsumption": 61}	{"taxTolerance": 64, "governmentTrust": 31, "policyAcceptance": 58, "regulationPreference": 70, "publicServiceSatisfaction": 70}	0
1858	최동현	35	30-39	Male	강원특별자치도	37.898088	128.22469	전문대 졸	200-350만원	학생	부부 가구	-45	진보 정당 지지	71	{"economy": -43, "housing": 30, "welfare": 40, "security": -40, "environment": 45}	SNS	{자유,전통,혁신}	강원특별자치도에 거주하는 30-39 학생. 정치 성향은 진보이며 자유, 전통, 혁신 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 67, "ecoConsciousness": 42, "priceSensitivity": 62, "digitalConsumption": 80}	{"taxTolerance": 44, "governmentTrust": 33, "policyAcceptance": 39, "regulationPreference": 52, "publicServiceSatisfaction": 64}	0
1859	황성호	43	40-49	Female	강원특별자치도	37.890873	128.078331	대학원 졸	700만원 이상	서비스직	부부 가구	-7	중도 무당층	54	{"economy": 5, "housing": 9, "welfare": 21, "security": -5, "environment": 19}	지상파/종편 뉴스	{다양성,환경,자유}	강원특별자치도에 거주하는 40-49 서비스직. 정치 성향은 중도이며 다양성, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 47, "ecoConsciousness": 56, "priceSensitivity": 54, "digitalConsumption": 79}	{"taxTolerance": 35, "governmentTrust": 50, "policyAcceptance": 46, "regulationPreference": 56, "publicServiceSatisfaction": 57}	0
1860	윤광수	45	40-49	Female	강원특별자치도	37.767564	128.125176	대학교 졸	500-700만원	은퇴	다세대 가구	-4	중도 무당층	55	{"economy": 9, "housing": 17, "welfare": -9, "security": -15, "environment": 13}	SNS	{성장,안전,공정}	강원특별자치도에 거주하는 40-49 은퇴. 정치 성향은 중도이며 성장, 안전, 공정 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 62, "ecoConsciousness": 66, "priceSensitivity": 63, "digitalConsumption": 89}	{"taxTolerance": 45, "governmentTrust": 49, "policyAcceptance": 44, "regulationPreference": 51, "publicServiceSatisfaction": 66}	0
1861	신혜진	45	40-49	Male	강원특별자치도	37.866747	128.205216	대학교 졸	350-500만원	학생	다세대 가구	57	보수 정당 지지	69	{"economy": 9, "housing": -12, "welfare": -10, "security": 5, "environment": 18}	유튜브	{혁신,다양성,전통}	강원특별자치도에 거주하는 40-49 학생. 정치 성향은 보수이며 혁신, 다양성, 전통 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 42, "ecoConsciousness": 41, "priceSensitivity": 61, "digitalConsumption": 60}	{"taxTolerance": 43, "governmentTrust": 35, "policyAcceptance": 63, "regulationPreference": 45, "publicServiceSatisfaction": 70}	0
1862	임정희	44	40-49	Male	강원특별자치도	37.787239	128.137326	대학교 졸	350-500만원	전문직	1인 가구	62	보수 정당 지지	83	{"economy": 39, "housing": 4, "welfare": -34, "security": 19, "environment": 4}	지상파/종편 뉴스	{공정,안전,자유}	강원특별자치도에 거주하는 40-49 전문직. 정치 성향은 보수이며 공정, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 45, "ecoConsciousness": 63, "priceSensitivity": 58, "digitalConsumption": 67}	{"taxTolerance": 58, "governmentTrust": 49, "policyAcceptance": 25, "regulationPreference": 62, "publicServiceSatisfaction": 50}	0
1863	장정희	56	50-59	Female	강원특별자치도	37.846157	128.123748	고졸 이하	350-500만원	은퇴	자녀 양육 가구	31	보수 성향 무당층	90	{"economy": 6, "housing": 25, "welfare": -27, "security": 9, "environment": 9}	신문/팟캐스트	{다양성,공동체,성장}	강원특별자치도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 다양성, 공동체, 성장 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 47, "ecoConsciousness": 23, "priceSensitivity": 57, "digitalConsumption": 64}	{"taxTolerance": 33, "governmentTrust": 46, "policyAcceptance": 58, "regulationPreference": 64, "publicServiceSatisfaction": 67}	0
1864	홍성호	52	50-59	Female	강원특별자치도	37.829484	128.146614	고졸 이하	500-700만원	공무원	1인 가구	-26	진보 성향 무당층	60	{"economy": -18, "housing": 29, "welfare": 53, "security": -26, "environment": 25}	신문/팟캐스트	{공동체,안전,환경}	강원특별자치도에 거주하는 50-59 공무원. 정치 성향은 중도이며 공동체, 안전, 환경 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 42, "ecoConsciousness": 43, "priceSensitivity": 74, "digitalConsumption": 54}	{"taxTolerance": 38, "governmentTrust": 47, "policyAcceptance": 50, "regulationPreference": 64, "publicServiceSatisfaction": 73}	0
1865	오경숙	56	50-59	Male	강원특별자치도	37.761358	128.21734	대학교 졸	500-700만원	주부	자녀 양육 가구	6	중도 무당층	99	{"economy": -6, "housing": 44, "welfare": 23, "security": 11, "environment": 27}	지상파/종편 뉴스	{성장,혁신,환경}	강원특별자치도에 거주하는 50-59 주부. 정치 성향은 중도이며 성장, 혁신, 환경 가치를 중시한다.	{"brandLoyalty": 64, "noveltySeeking": 44, "ecoConsciousness": 48, "priceSensitivity": 58, "digitalConsumption": 69}	{"taxTolerance": 57, "governmentTrust": 51, "policyAcceptance": 45, "regulationPreference": 89, "publicServiceSatisfaction": 68}	0
1866	홍현우	50	50-59	Male	강원특별자치도	37.743333	128.231088	전문대 졸	700만원 이상	은퇴	1인 가구	28	보수 성향 무당층	57	{"economy": 26, "housing": -14, "welfare": -3, "security": 24, "environment": 7}	지상파/종편 뉴스	{안전,전통,자유}	강원특별자치도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 안전, 전통, 자유 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 64, "ecoConsciousness": 52, "priceSensitivity": 42, "digitalConsumption": 70}	{"taxTolerance": 54, "governmentTrust": 58, "policyAcceptance": 51, "regulationPreference": 43, "publicServiceSatisfaction": 87}	0
1867	황혜진	60	60-69	Female	강원특별자치도	37.893108	128.126827	전문대 졸	700만원 이상	사무직	자녀 양육 가구	-7	중도 무당층	60	{"economy": -14, "housing": 62, "welfare": 21, "security": 21, "environment": 3}	SNS	{혁신,공동체,전통}	강원특별자치도에 거주하는 60-69 사무직. 정치 성향은 중도이며 혁신, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 42, "ecoConsciousness": 59, "priceSensitivity": 59, "digitalConsumption": 55}	{"taxTolerance": 39, "governmentTrust": 49, "policyAcceptance": 45, "regulationPreference": 83, "publicServiceSatisfaction": 56}	0
1868	임정희	69	60-69	Female	강원특별자치도	37.750203	128.067079	대학교 졸	500-700만원	은퇴	다세대 가구	1	중도 무당층	68	{"economy": 4, "housing": 26, "welfare": 23, "security": -6, "environment": 36}	포털 뉴스	{환경,전통,공정}	강원특별자치도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 환경, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 43, "ecoConsciousness": 46, "priceSensitivity": 56, "digitalConsumption": 63}	{"taxTolerance": 64, "governmentTrust": 49, "policyAcceptance": 62, "regulationPreference": 66, "publicServiceSatisfaction": 71}	0
1869	정지민	61	60-69	Male	강원특별자치도	37.776691	128.169631	전문대 졸	350-500만원	프리랜서	1인 가구	-25	진보 성향 무당층	78	{"economy": -11, "housing": 34, "welfare": 40, "security": -15, "environment": 51}	SNS	{자유,전통,안전}	강원특별자치도에 거주하는 60-69 프리랜서. 정치 성향은 중도이며 자유, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 39, "ecoConsciousness": 44, "priceSensitivity": 73, "digitalConsumption": 53}	{"taxTolerance": 27, "governmentTrust": 40, "policyAcceptance": 44, "regulationPreference": 75, "publicServiceSatisfaction": 59}	0
1870	신수아	61	60-69	Male	강원특별자치도	37.848861	128.157071	전문대 졸	500-700만원	공무원	부부 가구	32	보수 성향 무당층	73	{"economy": -18, "housing": 0, "welfare": 29, "security": 15, "environment": 2}	포털 뉴스	{자유,공정,전통}	강원특별자치도에 거주하는 60-69 공무원. 정치 성향은 중도이며 자유, 공정, 전통 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 42, "ecoConsciousness": 40, "priceSensitivity": 39, "digitalConsumption": 57}	{"taxTolerance": 29, "governmentTrust": 37, "policyAcceptance": 40, "regulationPreference": 56, "publicServiceSatisfaction": 77}	0
1871	정하은	81	70+	Female	강원특별자치도	37.893038	128.084001	대학교 졸	500-700만원	은퇴	다세대 가구	23	보수 성향 무당층	95	{"economy": 16, "housing": 25, "welfare": 27, "security": 37, "environment": 10}	유튜브	{공동체,혁신,환경}	강원특별자치도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공동체, 혁신, 환경 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 38, "ecoConsciousness": 28, "priceSensitivity": 57, "digitalConsumption": 49}	{"taxTolerance": 48, "governmentTrust": 59, "policyAcceptance": 42, "regulationPreference": 74, "publicServiceSatisfaction": 58}	0
1872	안주원	80	70+	Female	강원특별자치도	37.886923	128.205262	대학교 졸	350-500만원	은퇴	다세대 가구	43	보수 성향 무당층	99	{"economy": 16, "housing": -2, "welfare": -17, "security": 23, "environment": 18}	유튜브	{다양성,전통,성장}	강원특별자치도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 다양성, 전통, 성장 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 52, "ecoConsciousness": 54, "priceSensitivity": 64, "digitalConsumption": 52}	{"taxTolerance": 48, "governmentTrust": 52, "policyAcceptance": 67, "regulationPreference": 52, "publicServiceSatisfaction": 50}	0
1873	조철수	73	70+	Male	강원특별자치도	37.797855	128.109115	대학교 졸	350-500만원	은퇴	다세대 가구	22	보수 성향 무당층	99	{"economy": 29, "housing": 0, "welfare": 24, "security": 34, "environment": 23}	포털 뉴스	{안정,자유,혁신}	강원특별자치도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안정, 자유, 혁신 가치를 중시한다.	{"brandLoyalty": 66, "noveltySeeking": 46, "ecoConsciousness": 39, "priceSensitivity": 52, "digitalConsumption": 47}	{"taxTolerance": 61, "governmentTrust": 54, "policyAcceptance": 61, "regulationPreference": 55, "publicServiceSatisfaction": 67}	0
1874	송준서	75	70+	Male	강원특별자치도	37.770038	128.228405	대학교 졸	200-350만원	은퇴	다세대 가구	42	보수 성향 무당층	99	{"economy": 44, "housing": 27, "welfare": 23, "security": 36, "environment": 24}	포털 뉴스	{자유,안정,혁신}	강원특별자치도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 자유, 안정, 혁신 가치를 중시한다.	{"brandLoyalty": 63, "noveltySeeking": 62, "ecoConsciousness": 55, "priceSensitivity": 78, "digitalConsumption": 51}	{"taxTolerance": 37, "governmentTrust": 46, "policyAcceptance": 29, "regulationPreference": 75, "publicServiceSatisfaction": 65}	0
1875	류지민	23	18-29	Female	전북특별자치도	35.856596	127.015161	대학교 졸	200만원 미만	전문직	다세대 가구	-96	진보 정당 지지	61	{"economy": -60, "housing": 48, "welfare": 69, "security": -32, "environment": 45}	지상파/종편 뉴스	{다양성,안전,전통}	전북특별자치도에 거주하는 18-29 전문직. 정치 성향은 진보이며 다양성, 안전, 전통 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 87, "ecoConsciousness": 40, "priceSensitivity": 63, "digitalConsumption": 82}	{"taxTolerance": 41, "governmentTrust": 35, "policyAcceptance": 34, "regulationPreference": 56, "publicServiceSatisfaction": 56}	0
1876	서순자	29	18-29	Female	전북특별자치도	35.75049	127.1847	고졸 이하	350-500만원	생산직	부부 가구	-58	진보 정당 지지	74	{"economy": -54, "housing": 24, "welfare": 15, "security": -19, "environment": 36}	지상파/종편 뉴스	{성장,혁신,전통}	전북특별자치도에 거주하는 18-29 생산직. 정치 성향은 진보이며 성장, 혁신, 전통 가치를 중시한다.	{"brandLoyalty": 24, "noveltySeeking": 69, "ecoConsciousness": 37, "priceSensitivity": 65, "digitalConsumption": 69}	{"taxTolerance": 31, "governmentTrust": 41, "policyAcceptance": 47, "regulationPreference": 70, "publicServiceSatisfaction": 56}	0
1877	한민준	24	18-29	Male	전북특별자치도	35.836295	127.202627	대학교 졸	200-350만원	자영업	다세대 가구	-37	진보 성향 무당층	57	{"economy": -2, "housing": 34, "welfare": 37, "security": -39, "environment": 25}	신문/팟캐스트	{공정,다양성,전통}	전북특별자치도에 거주하는 18-29 자영업. 정치 성향은 진보이며 공정, 다양성, 전통 가치를 중시한다.	{"brandLoyalty": 21, "noveltySeeking": 62, "ecoConsciousness": 55, "priceSensitivity": 66, "digitalConsumption": 79}	{"taxTolerance": 60, "governmentTrust": 46, "policyAcceptance": 56, "regulationPreference": 81, "publicServiceSatisfaction": 72}	0
1878	강경숙	18	18-29	Male	전북특별자치도	35.881646	127.201709	대학원 졸	350-500만원	학생	다세대 가구	-85	진보 정당 지지	55	{"economy": -92, "housing": 46, "welfare": 45, "security": -36, "environment": 74}	포털 뉴스	{혁신,안전,안정}	전북특별자치도에 거주하는 18-29 학생. 정치 성향은 진보이며 혁신, 안전, 안정 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 48, "ecoConsciousness": 55, "priceSensitivity": 56, "digitalConsumption": 100}	{"taxTolerance": 51, "governmentTrust": 49, "policyAcceptance": 38, "regulationPreference": 60, "publicServiceSatisfaction": 70}	0
1879	오미경	37	30-39	Female	전북특별자치도	35.808957	127.090464	대학원 졸	350-500만원	사무직	부부 가구	-20	진보 성향 무당층	50	{"economy": -15, "housing": 15, "welfare": 9, "security": -27, "environment": 39}	포털 뉴스	{공동체,혁신,성장}	전북특별자치도에 거주하는 30-39 사무직. 정치 성향은 중도이며 공동체, 혁신, 성장 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 73, "ecoConsciousness": 46, "priceSensitivity": 88, "digitalConsumption": 64}	{"taxTolerance": 44, "governmentTrust": 26, "policyAcceptance": 52, "regulationPreference": 69, "publicServiceSatisfaction": 55}	0
1880	송지우	31	30-39	Female	전북특별자치도	35.828552	127.173489	전문대 졸	200-350만원	사무직	1인 가구	-39	진보 성향 무당층	56	{"economy": -22, "housing": 37, "welfare": 50, "security": -13, "environment": 24}	포털 뉴스	{공동체,안정,안전}	전북특별자치도에 거주하는 30-39 사무직. 정치 성향은 진보이며 공동체, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 68, "ecoConsciousness": 29, "priceSensitivity": 66, "digitalConsumption": 79}	{"taxTolerance": 48, "governmentTrust": 32, "policyAcceptance": 55, "regulationPreference": 68, "publicServiceSatisfaction": 57}	0
1881	류광수	37	30-39	Male	전북특별자치도	35.861351	127.108075	대학교 졸	350-500만원	사무직	자녀 양육 가구	-51	진보 정당 지지	49	{"economy": -33, "housing": 32, "welfare": 24, "security": -7, "environment": 32}	SNS	{혁신,공정,안정}	전북특별자치도에 거주하는 30-39 사무직. 정치 성향은 진보이며 혁신, 공정, 안정 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 59, "ecoConsciousness": 45, "priceSensitivity": 48, "digitalConsumption": 89}	{"taxTolerance": 47, "governmentTrust": 48, "policyAcceptance": 39, "regulationPreference": 64, "publicServiceSatisfaction": 76}	0
1882	김정희	38	30-39	Male	전북특별자치도	35.860752	127.15677	대학원 졸	500-700만원	학생	자녀 양육 가구	-40	진보 성향 무당층	55	{"economy": -52, "housing": 24, "welfare": 31, "security": -34, "environment": 49}	유튜브	{공동체,성장,공정}	전북특별자치도에 거주하는 30-39 학생. 정치 성향은 진보이며 공동체, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 71, "ecoConsciousness": 40, "priceSensitivity": 65, "digitalConsumption": 77}	{"taxTolerance": 50, "governmentTrust": 55, "policyAcceptance": 42, "regulationPreference": 50, "publicServiceSatisfaction": 64}	0
1883	윤현우	42	40-49	Female	전북특별자치도	35.807444	127.1487	대학교 졸	350-500만원	생산직	자녀 양육 가구	-57	진보 정당 지지	77	{"economy": -17, "housing": 9, "welfare": 29, "security": -21, "environment": 32}	유튜브	{혁신,공동체,자유}	전북특별자치도에 거주하는 40-49 생산직. 정치 성향은 진보이며 혁신, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 71, "ecoConsciousness": 48, "priceSensitivity": 52, "digitalConsumption": 92}	{"taxTolerance": 45, "governmentTrust": 58, "policyAcceptance": 33, "regulationPreference": 56, "publicServiceSatisfaction": 60}	0
1884	박유준	45	40-49	Female	전북특별자치도	35.845404	127.070833	대학교 졸	500-700만원	생산직	1인 가구	-62	진보 정당 지지	84	{"economy": -44, "housing": 38, "welfare": 27, "security": -45, "environment": 50}	신문/팟캐스트	{전통,다양성,공정}	전북특별자치도에 거주하는 40-49 생산직. 정치 성향은 진보이며 전통, 다양성, 공정 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 46, "ecoConsciousness": 41, "priceSensitivity": 43, "digitalConsumption": 75}	{"taxTolerance": 42, "governmentTrust": 60, "policyAcceptance": 42, "regulationPreference": 37, "publicServiceSatisfaction": 62}	0
1885	류경숙	45	40-49	Male	전북특별자치도	35.88953	127.166778	대학교 졸	700만원 이상	생산직	1인 가구	-29	진보 성향 무당층	65	{"economy": -14, "housing": 7, "welfare": 16, "security": -10, "environment": 39}	포털 뉴스	{다양성,공동체,공정}	전북특별자치도에 거주하는 40-49 생산직. 정치 성향은 중도이며 다양성, 공동체, 공정 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 56, "ecoConsciousness": 60, "priceSensitivity": 50, "digitalConsumption": 77}	{"taxTolerance": 51, "governmentTrust": 30, "policyAcceptance": 36, "regulationPreference": 37, "publicServiceSatisfaction": 63}	0
1886	서미경	48	40-49	Male	전북특별자치도	35.796933	127.108935	고졸 이하	200-350만원	학생	1인 가구	-41	진보 성향 무당층	48	{"economy": -36, "housing": 23, "welfare": 48, "security": -29, "environment": 24}	유튜브	{전통,환경,자유}	전북특별자치도에 거주하는 40-49 학생. 정치 성향은 진보이며 전통, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 57, "ecoConsciousness": 23, "priceSensitivity": 58, "digitalConsumption": 77}	{"taxTolerance": 38, "governmentTrust": 52, "policyAcceptance": 44, "regulationPreference": 57, "publicServiceSatisfaction": 74}	0
1887	조철수	56	50-59	Female	전북특별자치도	35.83763	127.139392	전문대 졸	350-500만원	주부	1인 가구	-65	진보 정당 지지	50	{"economy": -46, "housing": 32, "welfare": 36, "security": -50, "environment": 42}	신문/팟캐스트	{성장,자유,안전}	전북특별자치도에 거주하는 50-59 주부. 정치 성향은 진보이며 성장, 자유, 안전 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 47, "ecoConsciousness": 42, "priceSensitivity": 54, "digitalConsumption": 46}	{"taxTolerance": 42, "governmentTrust": 61, "policyAcceptance": 51, "regulationPreference": 57, "publicServiceSatisfaction": 47}	0
1888	오지아	53	50-59	Female	전북특별자치도	35.748835	127.026157	대학교 졸	500-700만원	생산직	다세대 가구	-19	진보 성향 무당층	65	{"economy": -30, "housing": 42, "welfare": 29, "security": 15, "environment": 18}	지상파/종편 뉴스	{성장,안전,공정}	전북특별자치도에 거주하는 50-59 생산직. 정치 성향은 중도이며 성장, 안전, 공정 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 67, "ecoConsciousness": 54, "priceSensitivity": 41, "digitalConsumption": 65}	{"taxTolerance": 43, "governmentTrust": 44, "policyAcceptance": 39, "regulationPreference": 58, "publicServiceSatisfaction": 72}	0
1889	최성호	50	50-59	Female	전북특별자치도	35.766743	127.196092	전문대 졸	700만원 이상	학생	다세대 가구	-66	진보 정당 지지	59	{"economy": -40, "housing": 48, "welfare": 52, "security": -41, "environment": 35}	지상파/종편 뉴스	{성장,안정,다양성}	전북특별자치도에 거주하는 50-59 학생. 정치 성향은 진보이며 성장, 안정, 다양성 가치를 중시한다.	{"brandLoyalty": 23, "noveltySeeking": 47, "ecoConsciousness": 45, "priceSensitivity": 48, "digitalConsumption": 70}	{"taxTolerance": 48, "governmentTrust": 46, "policyAcceptance": 42, "regulationPreference": 77, "publicServiceSatisfaction": 68}	0
1890	오은우	57	50-59	Male	전북특별자치도	35.7818	127.169061	대학교 졸	500-700만원	자영업	자녀 양육 가구	1	중도 무당층	50	{"economy": -29, "housing": 35, "welfare": 8, "security": 16, "environment": 9}	포털 뉴스	{자유,환경,공동체}	전북특별자치도에 거주하는 50-59 자영업. 정치 성향은 중도이며 자유, 환경, 공동체 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 35, "ecoConsciousness": 46, "priceSensitivity": 46, "digitalConsumption": 62}	{"taxTolerance": 47, "governmentTrust": 36, "policyAcceptance": 50, "regulationPreference": 57, "publicServiceSatisfaction": 55}	0
1891	오서연	50	50-59	Male	전북특별자치도	35.821947	127.207632	고졸 이하	500-700만원	은퇴	자녀 양육 가구	15	보수 성향 무당층	61	{"economy": -31, "housing": 29, "welfare": 5, "security": 21, "environment": -2}	포털 뉴스	{전통,다양성,환경}	전북특별자치도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 전통, 다양성, 환경 가치를 중시한다.	{"brandLoyalty": 20, "noveltySeeking": 48, "ecoConsciousness": 61, "priceSensitivity": 54, "digitalConsumption": 62}	{"taxTolerance": 45, "governmentTrust": 34, "policyAcceptance": 52, "regulationPreference": 65, "publicServiceSatisfaction": 72}	0
1892	임서윤	54	50-59	Male	전북특별자치도	35.870044	127.196354	고졸 이하	200-350만원	서비스직	1인 가구	-54	진보 정당 지지	70	{"economy": -41, "housing": 57, "welfare": 23, "security": -10, "environment": 30}	지상파/종편 뉴스	{환경,자유,다양성}	전북특별자치도에 거주하는 50-59 서비스직. 정치 성향은 진보이며 환경, 자유, 다양성 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 66, "ecoConsciousness": 43, "priceSensitivity": 79, "digitalConsumption": 77}	{"taxTolerance": 42, "governmentTrust": 42, "policyAcceptance": 31, "regulationPreference": 58, "publicServiceSatisfaction": 51}	0
1893	황민서	66	60-69	Female	전북특별자치도	35.822263	127.185813	전문대 졸	350-500만원	생산직	자녀 양육 가구	-15	진보 성향 무당층	60	{"economy": -27, "housing": 31, "welfare": 39, "security": 21, "environment": -5}	포털 뉴스	{다양성,안정,성장}	전북특별자치도에 거주하는 60-69 생산직. 정치 성향은 중도이며 다양성, 안정, 성장 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 54, "ecoConsciousness": 51, "priceSensitivity": 56, "digitalConsumption": 51}	{"taxTolerance": 39, "governmentTrust": 41, "policyAcceptance": 60, "regulationPreference": 77, "publicServiceSatisfaction": 50}	0
1894	류현우	61	60-69	Female	전북특별자치도	35.794589	127.091859	전문대 졸	500-700만원	프리랜서	1인 가구	-41	진보 성향 무당층	85	{"economy": -40, "housing": 37, "welfare": 40, "security": -8, "environment": 23}	포털 뉴스	{다양성,성장,환경}	전북특별자치도에 거주하는 60-69 프리랜서. 정치 성향은 진보이며 다양성, 성장, 환경 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 59, "ecoConsciousness": 27, "priceSensitivity": 84, "digitalConsumption": 65}	{"taxTolerance": 60, "governmentTrust": 50, "policyAcceptance": 36, "regulationPreference": 71, "publicServiceSatisfaction": 70}	0
1895	김영수	61	60-69	Male	전북특별자치도	35.888421	127.13655	대학교 졸	350-500만원	학생	부부 가구	-34	진보 성향 무당층	92	{"economy": -8, "housing": 43, "welfare": 20, "security": -7, "environment": 36}	신문/팟캐스트	{성장,자유,안정}	전북특별자치도에 거주하는 60-69 학생. 정치 성향은 진보이며 성장, 자유, 안정 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 33, "ecoConsciousness": 43, "priceSensitivity": 53, "digitalConsumption": 56}	{"taxTolerance": 42, "governmentTrust": 30, "policyAcceptance": 54, "regulationPreference": 65, "publicServiceSatisfaction": 59}	0
1896	홍민서	69	60-69	Male	전북특별자치도	35.856388	127.124005	전문대 졸	200-350만원	은퇴	자녀 양육 가구	1	중도 무당층	68	{"economy": -16, "housing": 32, "welfare": 0, "security": 0, "environment": 23}	신문/팟캐스트	{공동체,다양성,성장}	전북특별자치도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 공동체, 다양성, 성장 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 44, "ecoConsciousness": 40, "priceSensitivity": 88, "digitalConsumption": 57}	{"taxTolerance": 39, "governmentTrust": 51, "policyAcceptance": 35, "regulationPreference": 77, "publicServiceSatisfaction": 62}	0
1897	조순자	72	70+	Female	전북특별자치도	35.779969	127.026473	전문대 졸	350-500만원	은퇴	다세대 가구	-49	진보 정당 지지	98	{"economy": -25, "housing": 54, "welfare": 25, "security": -18, "environment": 2}	유튜브	{성장,혁신,공정}	전북특별자치도에 거주하는 70+ 은퇴. 정치 성향은 진보이며 성장, 혁신, 공정 가치를 중시한다.	{"brandLoyalty": 70, "noveltySeeking": 68, "ecoConsciousness": 43, "priceSensitivity": 50, "digitalConsumption": 59}	{"taxTolerance": 58, "governmentTrust": 55, "policyAcceptance": 74, "regulationPreference": 69, "publicServiceSatisfaction": 71}	0
1898	김민준	77	70+	Female	전북특별자치도	35.775612	127.118946	대학교 졸	500-700만원	은퇴	부부 가구	-18	진보 성향 무당층	70	{"economy": -41, "housing": 17, "welfare": 41, "security": -28, "environment": 1}	신문/팟캐스트	{안정,전통,공정}	전북특별자치도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안정, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 45, "ecoConsciousness": 61, "priceSensitivity": 54, "digitalConsumption": 66}	{"taxTolerance": 45, "governmentTrust": 49, "policyAcceptance": 52, "regulationPreference": 70, "publicServiceSatisfaction": 58}	0
1899	강수아	79	70+	Male	전북특별자치도	35.79776	127.115952	대학교 졸	200-350만원	은퇴	다세대 가구	-10	중도 무당층	93	{"economy": 2, "housing": 21, "welfare": 13, "security": 4, "environment": -4}	지상파/종편 뉴스	{안전,안정,자유}	전북특별자치도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안전, 안정, 자유 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 54, "ecoConsciousness": 46, "priceSensitivity": 77, "digitalConsumption": 60}	{"taxTolerance": 35, "governmentTrust": 45, "policyAcceptance": 72, "regulationPreference": 78, "publicServiceSatisfaction": 76}	0
1900	윤정희	82	70+	Male	전북특별자치도	35.889632	127.173126	전문대 졸	200만원 미만	은퇴	1인 가구	21	보수 성향 무당층	94	{"economy": 21, "housing": 27, "welfare": -17, "security": -15, "environment": 15}	지상파/종편 뉴스	{전통,안정,성장}	전북특별자치도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 전통, 안정, 성장 가치를 중시한다.	{"brandLoyalty": 65, "noveltySeeking": 47, "ecoConsciousness": 44, "priceSensitivity": 81, "digitalConsumption": 47}	{"taxTolerance": 32, "governmentTrust": 67, "policyAcceptance": 42, "regulationPreference": 61, "publicServiceSatisfaction": 58}	0
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

COPY public.users (id, username, name, birth_date, password_hash, role, created_at, budget_limit_usd, avatar) FROM stdin;
2	admin	관리자	\N	$2b$10$UVNNgxRjc.JTwmKgn/4uk.LOh1kY1lL197O0KkN8vTC0zmVHbI.mq	admin	2026-06-18 00:33:26.079448	1	\N
1	test	테스트 사용자	1990-05-15	$2b$10$UVNNgxRjc.JTwmKgn/4uk.LOh1kY1lL197O0KkN8vTC0zmVHbI.mq	user	2026-06-18 00:33:26.079448	3	av4
0	__global__	공유 학습 인구	\N	x	system	2026-06-22 08:45:12.458123	1	\N
\.


--
-- Name: agents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.agents_id_seq', 2700, true);


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
-- Name: signal_batches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.signal_batches_id_seq', 58, true);


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

\unrestrict oTvSz39Z76NIpP53ZxJxyG7INg262Sxsysn4eZ2KXcdn0KgzHmzseFbXqgEHaWa

