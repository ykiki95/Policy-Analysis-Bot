--
-- PostgreSQL database dump
--

\restrict 6V1tAleduhCq9N5p6XqTvLR5mbNIssaHgijIXz4MxtBFIKHRZvkYfbTDIza7vnx

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
    actual_value double precision NOT NULL
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
    last_error text
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
    budget_limit_usd double precision DEFAULT 1 NOT NULL
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
1	정예준	18	18-29	Female	서울특별시	37.566599	127.054194	대학원 졸	200-350만원	학생	부부 가구	30	보수 성향 무당층	36	{"economy": 13, "housing": -14, "welfare": -3, "security": 29, "environment": -6}	지상파/종편 뉴스	{혁신,공동체,다양성}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 혁신, 공동체, 다양성 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 98, "ecoConsciousness": 66, "priceSensitivity": 62, "digitalConsumption": 96}	{"taxTolerance": 56, "governmentTrust": 41, "policyAcceptance": 61, "regulationPreference": 58, "publicServiceSatisfaction": 72}	1
2	이서윤	22	18-29	Female	서울특별시	37.639776	126.972986	대학원 졸	200-350만원	학생	다세대 가구	-37	진보 성향 무당층	60	{"economy": -9, "housing": 36, "welfare": 30, "security": -20, "environment": 65}	신문/팟캐스트	{자유,공정,다양성}	서울특별시에 거주하는 18-29 학생. 정치 성향은 진보이며 자유, 공정, 다양성 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 90, "ecoConsciousness": 80, "priceSensitivity": 65, "digitalConsumption": 89}	{"taxTolerance": 55, "governmentTrust": 42, "policyAcceptance": 42, "regulationPreference": 57, "publicServiceSatisfaction": 67}	1
3	윤영수	22	18-29	Female	서울특별시	37.62274	126.95526	대학교 졸	200-350만원	학생	부부 가구	0	중도 무당층	60	{"economy": 10, "housing": 16, "welfare": 55, "security": 13, "environment": 16}	포털 뉴스	{공동체,성장,혁신}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 공동체, 성장, 혁신 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 78, "ecoConsciousness": 56, "priceSensitivity": 51, "digitalConsumption": 70}	{"taxTolerance": 54, "governmentTrust": 40, "policyAcceptance": 62, "regulationPreference": 69, "publicServiceSatisfaction": 63}	1
4	임영수	23	18-29	Female	서울특별시	37.505012	126.939674	대학원 졸	350-500만원	학생	다세대 가구	-16	진보 성향 무당층	49	{"economy": -25, "housing": 44, "welfare": 47, "security": -31, "environment": 5}	지상파/종편 뉴스	{혁신,공동체,공정}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 혁신, 공동체, 공정 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 86, "ecoConsciousness": 60, "priceSensitivity": 76, "digitalConsumption": 68}	{"taxTolerance": 50, "governmentTrust": 47, "policyAcceptance": 53, "regulationPreference": 64, "publicServiceSatisfaction": 49}	1
5	류유준	21	18-29	Female	서울특별시	37.510722	126.998855	고졸 이하	200-350만원	학생	다세대 가구	-2	중도 무당층	42	{"economy": -13, "housing": 17, "welfare": 1, "security": -14, "environment": 38}	SNS	{공동체,혁신,안정}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 공동체, 혁신, 안정 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 75, "ecoConsciousness": 42, "priceSensitivity": 68, "digitalConsumption": 80}	{"taxTolerance": 44, "governmentTrust": 50, "policyAcceptance": 41, "regulationPreference": 52, "publicServiceSatisfaction": 54}	1
6	윤경숙	26	18-29	Female	서울특별시	37.595766	127.031785	대학교 졸	500-700만원	은퇴	다세대 가구	-32	진보 성향 무당층	51	{"economy": -47, "housing": 15, "welfare": 15, "security": -15, "environment": 35}	포털 뉴스	{공동체,자유,환경}	서울특별시에 거주하는 18-29 은퇴. 정치 성향은 중도이며 공동체, 자유, 환경 가치를 중시한다.	{"brandLoyalty": 23, "noveltySeeking": 83, "ecoConsciousness": 57, "priceSensitivity": 73, "digitalConsumption": 85}	{"taxTolerance": 52, "governmentTrust": 50, "policyAcceptance": 57, "regulationPreference": 54, "publicServiceSatisfaction": 66}	1
7	오채원	29	18-29	Female	서울특별시	37.493959	127.053976	대학원 졸	200-350만원	생산직	1인 가구	-38	진보 성향 무당층	50	{"economy": -26, "housing": 22, "welfare": 33, "security": 7, "environment": 14}	지상파/종편 뉴스	{안정,환경,혁신}	서울특별시에 거주하는 18-29 생산직. 정치 성향은 진보이며 안정, 환경, 혁신 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 82, "ecoConsciousness": 47, "priceSensitivity": 65, "digitalConsumption": 66}	{"taxTolerance": 46, "governmentTrust": 58, "policyAcceptance": 46, "regulationPreference": 55, "publicServiceSatisfaction": 68}	1
8	조도윤	29	18-29	Male	서울특별시	37.645737	126.989025	전문대 졸	350-500만원	학생	1인 가구	-2	중도 무당층	52	{"economy": -19, "housing": 54, "welfare": 40, "security": 23, "environment": 8}	지상파/종편 뉴스	{안정,전통,공정}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 안정, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 71, "ecoConsciousness": 45, "priceSensitivity": 61, "digitalConsumption": 77}	{"taxTolerance": 43, "governmentTrust": 61, "policyAcceptance": 42, "regulationPreference": 59, "publicServiceSatisfaction": 74}	1
9	임철수	28	18-29	Male	서울특별시	37.519491	126.932737	대학원 졸	200만원 미만	생산직	다세대 가구	-16	진보 성향 무당층	58	{"economy": 3, "housing": 35, "welfare": 28, "security": -6, "environment": 30}	유튜브	{공동체,공정,자유}	서울특별시에 거주하는 18-29 생산직. 정치 성향은 중도이며 공동체, 공정, 자유 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 60, "ecoConsciousness": 67, "priceSensitivity": 52, "digitalConsumption": 84}	{"taxTolerance": 42, "governmentTrust": 38, "policyAcceptance": 30, "regulationPreference": 62, "publicServiceSatisfaction": 76}	1
10	송철수	18	18-29	Male	서울특별시	37.588713	127.077939	전문대 졸	200만원 미만	학생	자녀 양육 가구	1	중도 무당층	54	{"economy": -24, "housing": -11, "welfare": -13, "security": -10, "environment": -4}	유튜브	{공동체,공정,혁신}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 공동체, 공정, 혁신 가치를 중시한다.	{"brandLoyalty": 13, "noveltySeeking": 100, "ecoConsciousness": 51, "priceSensitivity": 73, "digitalConsumption": 89}	{"taxTolerance": 76, "governmentTrust": 39, "policyAcceptance": 39, "regulationPreference": 58, "publicServiceSatisfaction": 70}	1
11	최서연	27	18-29	Male	서울특별시	37.502924	126.997723	대학원 졸	200만원 미만	은퇴	자녀 양육 가구	-32	진보 성향 무당층	65	{"economy": -11, "housing": 40, "welfare": -1, "security": 6, "environment": 17}	SNS	{안정,자유,공정}	서울특별시에 거주하는 18-29 은퇴. 정치 성향은 중도이며 안정, 자유, 공정 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 69, "ecoConsciousness": 38, "priceSensitivity": 87, "digitalConsumption": 76}	{"taxTolerance": 63, "governmentTrust": 32, "policyAcceptance": 40, "regulationPreference": 49, "publicServiceSatisfaction": 69}	1
12	최동현	24	18-29	Male	서울특별시	37.617533	126.973049	대학원 졸	500-700만원	학생	1인 가구	-21	진보 성향 무당층	53	{"economy": -39, "housing": 25, "welfare": 26, "security": -24, "environment": 43}	SNS	{혁신,공동체,안정}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 혁신, 공동체, 안정 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 76, "ecoConsciousness": 45, "priceSensitivity": 55, "digitalConsumption": 89}	{"taxTolerance": 55, "governmentTrust": 47, "policyAcceptance": 40, "regulationPreference": 63, "publicServiceSatisfaction": 80}	1
13	김혜진	22	18-29	Male	서울특별시	37.568338	126.9064	대학원 졸	500-700만원	학생	부부 가구	21	보수 성향 무당층	36	{"economy": 18, "housing": 5, "welfare": 8, "security": 10, "environment": -10}	포털 뉴스	{다양성,혁신,자유}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 다양성, 혁신, 자유 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 76, "ecoConsciousness": 65, "priceSensitivity": 71, "digitalConsumption": 90}	{"taxTolerance": 57, "governmentTrust": 42, "policyAcceptance": 38, "regulationPreference": 58, "publicServiceSatisfaction": 58}	1
14	박서연	29	18-29	Male	서울특별시	37.635754	126.894247	대학원 졸	200-350만원	공무원	1인 가구	-34	진보 성향 무당층	48	{"economy": -24, "housing": 29, "welfare": 24, "security": 2, "environment": 50}	SNS	{다양성,혁신,전통}	서울특별시에 거주하는 18-29 공무원. 정치 성향은 진보이며 다양성, 혁신, 전통 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 85, "ecoConsciousness": 76, "priceSensitivity": 74, "digitalConsumption": 78}	{"taxTolerance": 60, "governmentTrust": 37, "policyAcceptance": 33, "regulationPreference": 57, "publicServiceSatisfaction": 59}	1
15	류채원	33	30-39	Female	서울특별시	37.604653	127.017057	대학원 졸	700만원 이상	전문직	다세대 가구	-65	진보 정당 지지	61	{"economy": -39, "housing": 30, "welfare": 43, "security": -5, "environment": 42}	SNS	{혁신,다양성,성장}	서울특별시에 거주하는 30-39 전문직. 정치 성향은 진보이며 혁신, 다양성, 성장 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 62, "ecoConsciousness": 51, "priceSensitivity": 36, "digitalConsumption": 74}	{"taxTolerance": 48, "governmentTrust": 22, "policyAcceptance": 26, "regulationPreference": 69, "publicServiceSatisfaction": 61}	1
16	윤성호	31	30-39	Female	서울특별시	37.538339	126.879483	대학원 졸	200만원 미만	생산직	1인 가구	24	보수 성향 무당층	55	{"economy": 11, "housing": 37, "welfare": -7, "security": 8, "environment": 12}	신문/팟캐스트	{공동체,환경,자유}	서울특별시에 거주하는 30-39 생산직. 정치 성향은 중도이며 공동체, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 98, "ecoConsciousness": 51, "priceSensitivity": 72, "digitalConsumption": 78}	{"taxTolerance": 50, "governmentTrust": 47, "policyAcceptance": 47, "regulationPreference": 65, "publicServiceSatisfaction": 63}	1
17	윤지호	32	30-39	Female	서울특별시	37.496085	126.939161	대학원 졸	200만원 미만	공무원	다세대 가구	-16	진보 성향 무당층	62	{"economy": -3, "housing": 61, "welfare": 20, "security": 3, "environment": 41}	포털 뉴스	{혁신,다양성,안정}	서울특별시에 거주하는 30-39 공무원. 정치 성향은 중도이며 혁신, 다양성, 안정 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 62, "ecoConsciousness": 80, "priceSensitivity": 75, "digitalConsumption": 66}	{"taxTolerance": 58, "governmentTrust": 55, "policyAcceptance": 41, "regulationPreference": 84, "publicServiceSatisfaction": 86}	1
18	최미경	30	30-39	Female	서울특별시	37.597389	127.015369	대학교 졸	500-700만원	생산직	1인 가구	-3	중도 무당층	66	{"economy": 11, "housing": 20, "welfare": 20, "security": 12, "environment": 30}	유튜브	{다양성,안정,공정}	서울특별시에 거주하는 30-39 생산직. 정치 성향은 중도이며 다양성, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 62, "ecoConsciousness": 56, "priceSensitivity": 59, "digitalConsumption": 85}	{"taxTolerance": 45, "governmentTrust": 44, "policyAcceptance": 68, "regulationPreference": 62, "publicServiceSatisfaction": 57}	1
19	윤지호	39	30-39	Female	서울특별시	37.501335	127.002758	대학교 졸	700만원 이상	전문직	자녀 양육 가구	-2	중도 무당층	68	{"economy": -34, "housing": 14, "welfare": 23, "security": 19, "environment": 8}	유튜브	{안전,성장,공정}	서울특별시에 거주하는 30-39 전문직. 정치 성향은 중도이며 안전, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 63, "ecoConsciousness": 74, "priceSensitivity": 53, "digitalConsumption": 81}	{"taxTolerance": 47, "governmentTrust": 43, "policyAcceptance": 44, "regulationPreference": 61, "publicServiceSatisfaction": 55}	1
20	정유준	33	30-39	Female	서울특별시	37.617942	126.890677	고졸 이하	200-350만원	프리랜서	자녀 양육 가구	-17	진보 성향 무당층	52	{"economy": -53, "housing": 11, "welfare": 21, "security": -19, "environment": 40}	SNS	{전통,성장,공정}	서울특별시에 거주하는 30-39 프리랜서. 정치 성향은 중도이며 전통, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 88, "ecoConsciousness": 62, "priceSensitivity": 74, "digitalConsumption": 88}	{"taxTolerance": 48, "governmentTrust": 54, "policyAcceptance": 47, "regulationPreference": 61, "publicServiceSatisfaction": 74}	1
21	신혜진	31	30-39	Female	서울특별시	37.591614	127.042174	전문대 졸	350-500만원	학생	자녀 양육 가구	3	중도 무당층	53	{"economy": 8, "housing": 10, "welfare": 19, "security": -7, "environment": 48}	지상파/종편 뉴스	{안정,환경,공동체}	서울특별시에 거주하는 30-39 학생. 정치 성향은 중도이며 안정, 환경, 공동체 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 63, "ecoConsciousness": 63, "priceSensitivity": 62, "digitalConsumption": 83}	{"taxTolerance": 48, "governmentTrust": 45, "policyAcceptance": 54, "regulationPreference": 67, "publicServiceSatisfaction": 56}	1
22	한정희	36	30-39	Male	서울특별시	37.573741	127.074231	고졸 이하	200-350만원	공무원	부부 가구	-53	진보 정당 지지	87	{"economy": -54, "housing": 24, "welfare": 30, "security": -13, "environment": 22}	유튜브	{다양성,안정,공정}	서울특별시에 거주하는 30-39 공무원. 정치 성향은 진보이며 다양성, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 58, "ecoConsciousness": 58, "priceSensitivity": 65, "digitalConsumption": 59}	{"taxTolerance": 57, "governmentTrust": 46, "policyAcceptance": 59, "regulationPreference": 72, "publicServiceSatisfaction": 80}	1
23	정현우	35	30-39	Male	서울특별시	37.562885	126.947878	대학원 졸	500-700만원	프리랜서	자녀 양육 가구	-41	진보 성향 무당층	55	{"economy": -16, "housing": 32, "welfare": 33, "security": -13, "environment": 25}	포털 뉴스	{다양성,전통,성장}	서울특별시에 거주하는 30-39 프리랜서. 정치 성향은 진보이며 다양성, 전통, 성장 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 75, "ecoConsciousness": 52, "priceSensitivity": 74, "digitalConsumption": 67}	{"taxTolerance": 42, "governmentTrust": 57, "policyAcceptance": 46, "regulationPreference": 58, "publicServiceSatisfaction": 55}	1
24	이영수	31	30-39	Male	서울특별시	37.613727	126.997955	대학교 졸	200-350만원	자영업	1인 가구	0	중도 무당층	55	{"economy": 0, "housing": 13, "welfare": 29, "security": 4, "environment": 28}	지상파/종편 뉴스	{안전,전통,다양성}	서울특별시에 거주하는 30-39 자영업. 정치 성향은 중도이며 안전, 전통, 다양성 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 73, "ecoConsciousness": 64, "priceSensitivity": 72, "digitalConsumption": 75}	{"taxTolerance": 52, "governmentTrust": 50, "policyAcceptance": 30, "regulationPreference": 56, "publicServiceSatisfaction": 60}	1
25	박현우	38	30-39	Male	서울특별시	37.50839	127.02072	대학교 졸	500-700만원	자영업	1인 가구	-33	진보 성향 무당층	58	{"economy": -30, "housing": 17, "welfare": 15, "security": 0, "environment": 30}	SNS	{자유,안전,혁신}	서울특별시에 거주하는 30-39 자영업. 정치 성향은 중도이며 자유, 안전, 혁신 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 64, "ecoConsciousness": 56, "priceSensitivity": 67, "digitalConsumption": 83}	{"taxTolerance": 50, "governmentTrust": 41, "policyAcceptance": 43, "regulationPreference": 39, "publicServiceSatisfaction": 74}	1
26	권은우	37	30-39	Male	서울특별시	37.497135	127.034272	대학원 졸	500-700만원	학생	다세대 가구	-27	진보 성향 무당층	40	{"economy": -34, "housing": 5, "welfare": 38, "security": -15, "environment": 11}	유튜브	{안정,공정,성장}	서울특별시에 거주하는 30-39 학생. 정치 성향은 중도이며 안정, 공정, 성장 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 58, "ecoConsciousness": 64, "priceSensitivity": 42, "digitalConsumption": 88}	{"taxTolerance": 56, "governmentTrust": 37, "policyAcceptance": 41, "regulationPreference": 73, "publicServiceSatisfaction": 61}	1
27	임민서	34	30-39	Male	서울특별시	37.490129	126.952694	대학교 졸	200-350만원	생산직	자녀 양육 가구	-32	진보 성향 무당층	56	{"economy": -19, "housing": 29, "welfare": 44, "security": -19, "environment": 41}	SNS	{성장,전통,공동체}	서울특별시에 거주하는 30-39 생산직. 정치 성향은 중도이며 성장, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 80, "ecoConsciousness": 52, "priceSensitivity": 51, "digitalConsumption": 83}	{"taxTolerance": 39, "governmentTrust": 53, "policyAcceptance": 20, "regulationPreference": 52, "publicServiceSatisfaction": 58}	1
28	전준서	32	30-39	Male	서울특별시	37.575648	127.043751	대학원 졸	350-500만원	사무직	부부 가구	-10	중도 무당층	56	{"economy": -28, "housing": 27, "welfare": 23, "security": -7, "environment": 24}	지상파/종편 뉴스	{다양성,자유,전통}	서울특별시에 거주하는 30-39 사무직. 정치 성향은 중도이며 다양성, 자유, 전통 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 62, "ecoConsciousness": 67, "priceSensitivity": 64, "digitalConsumption": 94}	{"taxTolerance": 60, "governmentTrust": 56, "policyAcceptance": 44, "regulationPreference": 51, "publicServiceSatisfaction": 89}	1
29	조광수	41	40-49	Female	서울특별시	37.615906	127.036771	전문대 졸	500-700만원	생산직	부부 가구	-4	중도 무당층	63	{"economy": -22, "housing": 13, "welfare": 18, "security": 3, "environment": 31}	신문/팟캐스트	{공정,자유,공동체}	서울특별시에 거주하는 40-49 생산직. 정치 성향은 중도이며 공정, 자유, 공동체 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 83, "ecoConsciousness": 47, "priceSensitivity": 71, "digitalConsumption": 67}	{"taxTolerance": 44, "governmentTrust": 30, "policyAcceptance": 64, "regulationPreference": 76, "publicServiceSatisfaction": 68}	1
30	임다은	43	40-49	Female	서울특별시	37.572175	126.925025	대학원 졸	200-350만원	사무직	부부 가구	-14	중도 무당층	64	{"economy": -22, "housing": -6, "welfare": 12, "security": 23, "environment": 22}	포털 뉴스	{안정,다양성,혁신}	서울특별시에 거주하는 40-49 사무직. 정치 성향은 중도이며 안정, 다양성, 혁신 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 85, "ecoConsciousness": 46, "priceSensitivity": 72, "digitalConsumption": 58}	{"taxTolerance": 60, "governmentTrust": 57, "policyAcceptance": 41, "regulationPreference": 47, "publicServiceSatisfaction": 69}	1
31	정하은	49	40-49	Female	서울특별시	37.611457	126.987005	전문대 졸	350-500만원	전문직	자녀 양육 가구	25	보수 성향 무당층	86	{"economy": -3, "housing": 1, "welfare": -1, "security": 44, "environment": -7}	SNS	{성장,안전,전통}	서울특별시에 거주하는 40-49 전문직. 정치 성향은 중도이며 성장, 안전, 전통 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 62, "ecoConsciousness": 58, "priceSensitivity": 72, "digitalConsumption": 86}	{"taxTolerance": 59, "governmentTrust": 40, "policyAcceptance": 60, "regulationPreference": 71, "publicServiceSatisfaction": 64}	1
32	황지우	47	40-49	Female	서울특별시	37.51547	126.932971	고졸 이하	200-350만원	자영업	자녀 양육 가구	23	보수 성향 무당층	66	{"economy": -4, "housing": -21, "welfare": 45, "security": 14, "environment": -1}	SNS	{안정,성장,자유}	서울특별시에 거주하는 40-49 자영업. 정치 성향은 중도이며 안정, 성장, 자유 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 53, "ecoConsciousness": 53, "priceSensitivity": 80, "digitalConsumption": 93}	{"taxTolerance": 43, "governmentTrust": 44, "policyAcceptance": 65, "regulationPreference": 69, "publicServiceSatisfaction": 67}	1
33	오유준	42	40-49	Female	서울특별시	37.545103	126.976054	대학원 졸	350-500만원	공무원	부부 가구	-21	진보 성향 무당층	59	{"economy": -43, "housing": 65, "welfare": 28, "security": 4, "environment": 30}	지상파/종편 뉴스	{다양성,안전,안정}	서울특별시에 거주하는 40-49 공무원. 정치 성향은 중도이며 다양성, 안전, 안정 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 63, "ecoConsciousness": 49, "priceSensitivity": 39, "digitalConsumption": 63}	{"taxTolerance": 39, "governmentTrust": 50, "policyAcceptance": 41, "regulationPreference": 50, "publicServiceSatisfaction": 54}	1
34	서도윤	40	40-49	Female	서울특별시	37.551462	126.932572	대학교 졸	500-700만원	사무직	1인 가구	-45	진보 정당 지지	87	{"economy": -23, "housing": 33, "welfare": 37, "security": -37, "environment": -1}	지상파/종편 뉴스	{혁신,안전,환경}	서울특별시에 거주하는 40-49 사무직. 정치 성향은 진보이며 혁신, 안전, 환경 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 69, "ecoConsciousness": 58, "priceSensitivity": 60, "digitalConsumption": 74}	{"taxTolerance": 57, "governmentTrust": 36, "policyAcceptance": 39, "regulationPreference": 65, "publicServiceSatisfaction": 71}	1
35	신순자	48	40-49	Female	서울특별시	37.597483	127.028803	대학원 졸	350-500만원	서비스직	부부 가구	21	보수 성향 무당층	71	{"economy": 15, "housing": 12, "welfare": 12, "security": 14, "environment": 23}	유튜브	{성장,자유,안전}	서울특별시에 거주하는 40-49 서비스직. 정치 성향은 중도이며 성장, 자유, 안전 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 73, "ecoConsciousness": 56, "priceSensitivity": 77, "digitalConsumption": 60}	{"taxTolerance": 55, "governmentTrust": 51, "policyAcceptance": 37, "regulationPreference": 79, "publicServiceSatisfaction": 71}	1
36	장현우	45	40-49	Female	서울특별시	37.642491	127.049135	전문대 졸	500-700만원	사무직	부부 가구	20	보수 성향 무당층	63	{"economy": 12, "housing": 7, "welfare": 8, "security": 27, "environment": -6}	SNS	{안정,다양성,환경}	서울특별시에 거주하는 40-49 사무직. 정치 성향은 중도이며 안정, 다양성, 환경 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 53, "ecoConsciousness": 35, "priceSensitivity": 53, "digitalConsumption": 82}	{"taxTolerance": 47, "governmentTrust": 45, "policyAcceptance": 41, "regulationPreference": 75, "publicServiceSatisfaction": 61}	1
37	송경숙	40	40-49	Male	서울특별시	37.57989	126.919567	대학교 졸	350-500만원	서비스직	1인 가구	-11	중도 무당층	37	{"economy": 6, "housing": 24, "welfare": 20, "security": -8, "environment": 19}	지상파/종편 뉴스	{성장,혁신,공동체}	서울특별시에 거주하는 40-49 서비스직. 정치 성향은 중도이며 성장, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 63, "ecoConsciousness": 47, "priceSensitivity": 73, "digitalConsumption": 82}	{"taxTolerance": 48, "governmentTrust": 49, "policyAcceptance": 39, "regulationPreference": 64, "publicServiceSatisfaction": 66}	1
38	정성호	47	40-49	Male	서울특별시	37.527259	126.922792	전문대 졸	350-500만원	전문직	자녀 양육 가구	7	중도 무당층	77	{"economy": -24, "housing": 45, "welfare": 9, "security": 7, "environment": 26}	지상파/종편 뉴스	{안전,안정,성장}	서울특별시에 거주하는 40-49 전문직. 정치 성향은 중도이며 안전, 안정, 성장 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 69, "ecoConsciousness": 28, "priceSensitivity": 68, "digitalConsumption": 54}	{"taxTolerance": 29, "governmentTrust": 47, "policyAcceptance": 58, "regulationPreference": 50, "publicServiceSatisfaction": 62}	1
39	김민준	49	40-49	Male	서울특별시	37.620472	126.948052	대학교 졸	500-700만원	프리랜서	자녀 양육 가구	20	보수 성향 무당층	61	{"economy": -7, "housing": 4, "welfare": 17, "security": 9, "environment": 8}	SNS	{안정,공동체,안전}	서울특별시에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 안정, 공동체, 안전 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 59, "ecoConsciousness": 67, "priceSensitivity": 55, "digitalConsumption": 78}	{"taxTolerance": 57, "governmentTrust": 55, "policyAcceptance": 74, "regulationPreference": 78, "publicServiceSatisfaction": 60}	1
40	윤성호	48	40-49	Male	서울특별시	37.599308	127.002853	전문대 졸	500-700만원	학생	부부 가구	29	보수 성향 무당층	78	{"economy": 14, "housing": 22, "welfare": 1, "security": 23, "environment": 14}	신문/팟캐스트	{공정,혁신,공동체}	서울특별시에 거주하는 40-49 학생. 정치 성향은 중도이며 공정, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 74, "ecoConsciousness": 58, "priceSensitivity": 63, "digitalConsumption": 64}	{"taxTolerance": 48, "governmentTrust": 43, "policyAcceptance": 49, "regulationPreference": 71, "publicServiceSatisfaction": 67}	1
41	임은우	41	40-49	Male	서울특별시	37.513758	126.89102	대학교 졸	200-350만원	공무원	1인 가구	2	중도 무당층	59	{"economy": -7, "housing": 9, "welfare": 37, "security": 2, "environment": 7}	포털 뉴스	{성장,환경,전통}	서울특별시에 거주하는 40-49 공무원. 정치 성향은 중도이며 성장, 환경, 전통 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 77, "ecoConsciousness": 54, "priceSensitivity": 67, "digitalConsumption": 69}	{"taxTolerance": 50, "governmentTrust": 46, "policyAcceptance": 39, "regulationPreference": 78, "publicServiceSatisfaction": 61}	1
42	홍경숙	41	40-49	Male	서울특별시	37.495826	127.061937	대학원 졸	500-700만원	프리랜서	1인 가구	-1	중도 무당층	57	{"economy": 12, "housing": 16, "welfare": -6, "security": 4, "environment": -7}	SNS	{안정,성장,자유}	서울특별시에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 안정, 성장, 자유 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 85, "ecoConsciousness": 75, "priceSensitivity": 72, "digitalConsumption": 76}	{"taxTolerance": 52, "governmentTrust": 46, "policyAcceptance": 48, "regulationPreference": 82, "publicServiceSatisfaction": 52}	1
43	류철수	44	40-49	Male	서울특별시	37.581525	127.077183	대학원 졸	200만원 미만	서비스직	부부 가구	-19	진보 성향 무당층	46	{"economy": -32, "housing": 33, "welfare": 31, "security": 14, "environment": 38}	SNS	{공정,안전,안정}	서울특별시에 거주하는 40-49 서비스직. 정치 성향은 중도이며 공정, 안전, 안정 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 77, "ecoConsciousness": 59, "priceSensitivity": 77, "digitalConsumption": 73}	{"taxTolerance": 56, "governmentTrust": 50, "policyAcceptance": 63, "regulationPreference": 64, "publicServiceSatisfaction": 74}	1
44	임지민	42	40-49	Male	서울특별시	37.635001	126.883251	전문대 졸	700만원 이상	주부	1인 가구	-2	중도 무당층	61	{"economy": 0, "housing": 7, "welfare": 22, "security": 19, "environment": 4}	지상파/종편 뉴스	{전통,혁신,안전}	서울특별시에 거주하는 40-49 주부. 정치 성향은 중도이며 전통, 혁신, 안전 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 57, "ecoConsciousness": 58, "priceSensitivity": 45, "digitalConsumption": 65}	{"taxTolerance": 34, "governmentTrust": 51, "policyAcceptance": 62, "regulationPreference": 78, "publicServiceSatisfaction": 72}	1
45	박영수	53	50-59	Female	서울특별시	37.52757	126.955044	대학교 졸	350-500만원	학생	부부 가구	23	보수 성향 무당층	47	{"economy": 10, "housing": 14, "welfare": 1, "security": 14, "environment": 30}	유튜브	{안전,전통,자유}	서울특별시에 거주하는 50-59 학생. 정치 성향은 중도이며 안전, 전통, 자유 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 59, "ecoConsciousness": 42, "priceSensitivity": 55, "digitalConsumption": 63}	{"taxTolerance": 33, "governmentTrust": 40, "policyAcceptance": 40, "regulationPreference": 82, "publicServiceSatisfaction": 66}	1
46	강하은	55	50-59	Female	서울특별시	37.500832	127.060946	대학원 졸	350-500만원	생산직	다세대 가구	-5	중도 무당층	66	{"economy": -4, "housing": 9, "welfare": -4, "security": 27, "environment": 44}	지상파/종편 뉴스	{안정,혁신,자유}	서울특별시에 거주하는 50-59 생산직. 정치 성향은 중도이며 안정, 혁신, 자유 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 59, "ecoConsciousness": 48, "priceSensitivity": 68, "digitalConsumption": 71}	{"taxTolerance": 65, "governmentTrust": 46, "policyAcceptance": 34, "regulationPreference": 73, "publicServiceSatisfaction": 69}	1
47	권유준	51	50-59	Female	서울특별시	37.50594	127.062301	대학교 졸	200-350만원	전문직	자녀 양육 가구	27	보수 성향 무당층	61	{"economy": -8, "housing": 3, "welfare": -31, "security": 14, "environment": -3}	지상파/종편 뉴스	{안전,전통,성장}	서울특별시에 거주하는 50-59 전문직. 정치 성향은 중도이며 안전, 전통, 성장 가치를 중시한다.	{"brandLoyalty": 23, "noveltySeeking": 73, "ecoConsciousness": 48, "priceSensitivity": 56, "digitalConsumption": 64}	{"taxTolerance": 45, "governmentTrust": 35, "policyAcceptance": 57, "regulationPreference": 50, "publicServiceSatisfaction": 77}	1
48	윤지호	59	50-59	Female	서울특별시	37.593587	127.008759	전문대 졸	500-700만원	은퇴	다세대 가구	-13	중도 무당층	81	{"economy": -20, "housing": 3, "welfare": 26, "security": 3, "environment": 21}	SNS	{전통,혁신,공동체}	서울특별시에 거주하는 50-59 은퇴. 정치 성향은 중도이며 전통, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 67, "ecoConsciousness": 49, "priceSensitivity": 68, "digitalConsumption": 64}	{"taxTolerance": 31, "governmentTrust": 49, "policyAcceptance": 47, "regulationPreference": 74, "publicServiceSatisfaction": 51}	1
49	윤준서	50	50-59	Female	서울특별시	37.578286	126.993593	대학교 졸	700만원 이상	생산직	자녀 양육 가구	12	중도 무당층	78	{"economy": 20, "housing": 27, "welfare": 21, "security": 2, "environment": 16}	유튜브	{공정,자유,혁신}	서울특별시에 거주하는 50-59 생산직. 정치 성향은 중도이며 공정, 자유, 혁신 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 65, "ecoConsciousness": 58, "priceSensitivity": 52, "digitalConsumption": 62}	{"taxTolerance": 42, "governmentTrust": 45, "policyAcceptance": 77, "regulationPreference": 75, "publicServiceSatisfaction": 41}	1
50	황현우	59	50-59	Female	서울특별시	37.501711	127.005075	전문대 졸	700만원 이상	사무직	다세대 가구	-6	중도 무당층	58	{"economy": 2, "housing": 9, "welfare": 32, "security": -4, "environment": 1}	SNS	{전통,안전,다양성}	서울특별시에 거주하는 50-59 사무직. 정치 성향은 중도이며 전통, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 64, "noveltySeeking": 60, "ecoConsciousness": 65, "priceSensitivity": 48, "digitalConsumption": 66}	{"taxTolerance": 56, "governmentTrust": 36, "policyAcceptance": 29, "regulationPreference": 44, "publicServiceSatisfaction": 61}	1
51	장미경	59	50-59	Female	서울특별시	37.541804	127.052043	고졸 이하	500-700만원	공무원	자녀 양육 가구	-13	중도 무당층	50	{"economy": -33, "housing": 17, "welfare": 13, "security": 13, "environment": 39}	신문/팟캐스트	{공동체,혁신,안전}	서울특별시에 거주하는 50-59 공무원. 정치 성향은 중도이며 공동체, 혁신, 안전 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 38, "ecoConsciousness": 51, "priceSensitivity": 55, "digitalConsumption": 64}	{"taxTolerance": 34, "governmentTrust": 48, "policyAcceptance": 41, "regulationPreference": 56, "publicServiceSatisfaction": 62}	1
52	전영수	52	50-59	Female	서울특별시	37.493994	126.908758	대학원 졸	700만원 이상	사무직	1인 가구	36	보수 성향 무당층	66	{"economy": -10, "housing": -3, "welfare": -24, "security": 16, "environment": 0}	SNS	{안전,혁신,공동체}	서울특별시에 거주하는 50-59 사무직. 정치 성향은 보수이며 안전, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 72, "ecoConsciousness": 57, "priceSensitivity": 49, "digitalConsumption": 66}	{"taxTolerance": 58, "governmentTrust": 48, "policyAcceptance": 57, "regulationPreference": 78, "publicServiceSatisfaction": 61}	1
53	권다은	56	50-59	Female	서울특별시	37.583371	126.942978	전문대 졸	500-700만원	사무직	다세대 가구	0	중도 무당층	84	{"economy": -17, "housing": 14, "welfare": 18, "security": 13, "environment": -1}	신문/팟캐스트	{안정,성장,다양성}	서울특별시에 거주하는 50-59 사무직. 정치 성향은 중도이며 안정, 성장, 다양성 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 67, "ecoConsciousness": 24, "priceSensitivity": 75, "digitalConsumption": 71}	{"taxTolerance": 48, "governmentTrust": 32, "policyAcceptance": 63, "regulationPreference": 61, "publicServiceSatisfaction": 76}	1
54	이예준	56	50-59	Male	서울특별시	37.615417	127.042961	대학교 졸	500-700만원	주부	1인 가구	-37	진보 성향 무당층	60	{"economy": -23, "housing": 39, "welfare": 77, "security": -16, "environment": 34}	SNS	{안전,다양성,성장}	서울특별시에 거주하는 50-59 주부. 정치 성향은 진보이며 안전, 다양성, 성장 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 49, "ecoConsciousness": 56, "priceSensitivity": 67, "digitalConsumption": 56}	{"taxTolerance": 48, "governmentTrust": 59, "policyAcceptance": 48, "regulationPreference": 61, "publicServiceSatisfaction": 60}	1
55	오동현	51	50-59	Male	서울특별시	37.562738	126.911424	대학교 졸	200-350만원	주부	부부 가구	-6	중도 무당층	82	{"economy": -24, "housing": 13, "welfare": 22, "security": 15, "environment": -12}	유튜브	{전통,공정,안정}	서울특별시에 거주하는 50-59 주부. 정치 성향은 중도이며 전통, 공정, 안정 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 73, "ecoConsciousness": 36, "priceSensitivity": 63, "digitalConsumption": 80}	{"taxTolerance": 53, "governmentTrust": 54, "policyAcceptance": 55, "regulationPreference": 67, "publicServiceSatisfaction": 90}	1
56	정지아	57	50-59	Male	서울특별시	37.518218	127.017834	대학원 졸	500-700만원	학생	부부 가구	33	보수 성향 무당층	87	{"economy": 9, "housing": 29, "welfare": 16, "security": 33, "environment": 9}	지상파/종편 뉴스	{혁신,전통,성장}	서울특별시에 거주하는 50-59 학생. 정치 성향은 중도이며 혁신, 전통, 성장 가치를 중시한다.	{"brandLoyalty": 75, "noveltySeeking": 81, "ecoConsciousness": 48, "priceSensitivity": 60, "digitalConsumption": 71}	{"taxTolerance": 41, "governmentTrust": 9, "policyAcceptance": 50, "regulationPreference": 56, "publicServiceSatisfaction": 75}	1
57	임예준	58	50-59	Male	서울특별시	37.583237	126.99232	대학교 졸	500-700만원	주부	부부 가구	-2	중도 무당층	67	{"economy": 19, "housing": 8, "welfare": 6, "security": 7, "environment": 34}	유튜브	{안정,공정,환경}	서울특별시에 거주하는 50-59 주부. 정치 성향은 중도이며 안정, 공정, 환경 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 64, "ecoConsciousness": 50, "priceSensitivity": 67, "digitalConsumption": 57}	{"taxTolerance": 53, "governmentTrust": 50, "policyAcceptance": 36, "regulationPreference": 72, "publicServiceSatisfaction": 83}	1
58	황성호	51	50-59	Male	서울특별시	37.561746	127.016396	대학교 졸	350-500만원	서비스직	1인 가구	-6	중도 무당층	69	{"economy": -7, "housing": 7, "welfare": 10, "security": -8, "environment": 35}	유튜브	{자유,안전,전통}	서울특별시에 거주하는 50-59 서비스직. 정치 성향은 중도이며 자유, 안전, 전통 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 63, "ecoConsciousness": 49, "priceSensitivity": 64, "digitalConsumption": 70}	{"taxTolerance": 42, "governmentTrust": 53, "policyAcceptance": 48, "regulationPreference": 81, "publicServiceSatisfaction": 55}	1
59	한민준	59	50-59	Male	서울특별시	37.582606	126.892667	전문대 졸	700만원 이상	전문직	자녀 양육 가구	0	중도 무당층	66	{"economy": -27, "housing": 21, "welfare": 5, "security": 35, "environment": 34}	지상파/종편 뉴스	{전통,안정,성장}	서울특별시에 거주하는 50-59 전문직. 정치 성향은 중도이며 전통, 안정, 성장 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 42, "ecoConsciousness": 55, "priceSensitivity": 47, "digitalConsumption": 59}	{"taxTolerance": 59, "governmentTrust": 49, "policyAcceptance": 56, "regulationPreference": 80, "publicServiceSatisfaction": 60}	1
60	이서윤	52	50-59	Male	서울특별시	37.628244	126.914611	전문대 졸	350-500만원	사무직	부부 가구	6	중도 무당층	61	{"economy": 0, "housing": 23, "welfare": 37, "security": 13, "environment": 27}	신문/팟캐스트	{자유,공정,안정}	서울특별시에 거주하는 50-59 사무직. 정치 성향은 중도이며 자유, 공정, 안정 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 60, "ecoConsciousness": 66, "priceSensitivity": 70, "digitalConsumption": 68}	{"taxTolerance": 29, "governmentTrust": 21, "policyAcceptance": 45, "regulationPreference": 67, "publicServiceSatisfaction": 67}	1
61	권하은	54	50-59	Male	서울특별시	37.553643	127.07542	대학교 졸	700만원 이상	자영업	자녀 양육 가구	-13	중도 무당층	69	{"economy": 7, "housing": 28, "welfare": 13, "security": -32, "environment": 16}	유튜브	{환경,자유,안정}	서울특별시에 거주하는 50-59 자영업. 정치 성향은 중도이며 환경, 자유, 안정 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 71, "ecoConsciousness": 80, "priceSensitivity": 34, "digitalConsumption": 56}	{"taxTolerance": 54, "governmentTrust": 42, "policyAcceptance": 41, "regulationPreference": 56, "publicServiceSatisfaction": 61}	1
62	류민서	56	50-59	Male	서울특별시	37.502128	127.008525	전문대 졸	500-700만원	공무원	다세대 가구	20	보수 성향 무당층	72	{"economy": 4, "housing": 7, "welfare": -24, "security": -11, "environment": 13}	신문/팟캐스트	{다양성,공동체,자유}	서울특별시에 거주하는 50-59 공무원. 정치 성향은 중도이며 다양성, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 47, "ecoConsciousness": 57, "priceSensitivity": 48, "digitalConsumption": 76}	{"taxTolerance": 37, "governmentTrust": 33, "policyAcceptance": 47, "regulationPreference": 55, "publicServiceSatisfaction": 69}	1
63	권건우	67	60-69	Female	서울특별시	37.58907	126.914737	대학교 졸	200-350만원	은퇴	자녀 양육 가구	45	보수 정당 지지	91	{"economy": 52, "housing": 8, "welfare": 7, "security": 17, "environment": 14}	지상파/종편 뉴스	{공정,전통,자유}	서울특별시에 거주하는 60-69 은퇴. 정치 성향은 보수이며 공정, 전통, 자유 가치를 중시한다.	{"brandLoyalty": 61, "noveltySeeking": 34, "ecoConsciousness": 42, "priceSensitivity": 48, "digitalConsumption": 68}	{"taxTolerance": 58, "governmentTrust": 51, "policyAcceptance": 47, "regulationPreference": 69, "publicServiceSatisfaction": 47}	1
64	정지호	63	60-69	Female	서울특별시	37.512511	127.002943	전문대 졸	350-500만원	서비스직	자녀 양육 가구	26	보수 성향 무당층	89	{"economy": 11, "housing": 6, "welfare": 6, "security": 25, "environment": 32}	유튜브	{안정,혁신,공동체}	서울특별시에 거주하는 60-69 서비스직. 정치 성향은 중도이며 안정, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 59, "ecoConsciousness": 47, "priceSensitivity": 68, "digitalConsumption": 65}	{"taxTolerance": 72, "governmentTrust": 49, "policyAcceptance": 48, "regulationPreference": 39, "publicServiceSatisfaction": 53}	1
65	황경숙	63	60-69	Female	서울특별시	37.529368	126.982394	대학원 졸	200-350만원	사무직	부부 가구	51	보수 정당 지지	73	{"economy": 20, "housing": -23, "welfare": -24, "security": 48, "environment": 21}	SNS	{환경,혁신,공정}	서울특별시에 거주하는 60-69 사무직. 정치 성향은 보수이며 환경, 혁신, 공정 가치를 중시한다.	{"brandLoyalty": 73, "noveltySeeking": 75, "ecoConsciousness": 65, "priceSensitivity": 72, "digitalConsumption": 69}	{"taxTolerance": 59, "governmentTrust": 36, "policyAcceptance": 48, "regulationPreference": 70, "publicServiceSatisfaction": 66}	1
66	권경숙	66	60-69	Female	서울특별시	37.62772	126.882643	전문대 졸	350-500만원	공무원	부부 가구	-6	중도 무당층	98	{"economy": -5, "housing": 20, "welfare": 7, "security": -8, "environment": 41}	지상파/종편 뉴스	{다양성,자유,전통}	서울특별시에 거주하는 60-69 공무원. 정치 성향은 중도이며 다양성, 자유, 전통 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 56, "ecoConsciousness": 23, "priceSensitivity": 72, "digitalConsumption": 53}	{"taxTolerance": 51, "governmentTrust": 46, "policyAcceptance": 59, "regulationPreference": 71, "publicServiceSatisfaction": 81}	1
67	전영수	68	60-69	Female	서울특별시	37.640908	126.988995	전문대 졸	500-700만원	은퇴	부부 가구	27	보수 성향 무당층	99	{"economy": -8, "housing": 12, "welfare": -2, "security": 2, "environment": 37}	포털 뉴스	{전통,안전,환경}	서울특별시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 전통, 안전, 환경 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 48, "ecoConsciousness": 50, "priceSensitivity": 54, "digitalConsumption": 57}	{"taxTolerance": 54, "governmentTrust": 56, "policyAcceptance": 60, "regulationPreference": 53, "publicServiceSatisfaction": 69}	1
68	조서윤	69	60-69	Female	서울특별시	37.578025	126.969361	대학원 졸	350-500만원	은퇴	1인 가구	46	보수 정당 지지	62	{"economy": 31, "housing": -8, "welfare": -10, "security": 39, "environment": 33}	유튜브	{성장,혁신,다양성}	서울특별시에 거주하는 60-69 은퇴. 정치 성향은 보수이며 성장, 혁신, 다양성 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 42, "ecoConsciousness": 40, "priceSensitivity": 62, "digitalConsumption": 46}	{"taxTolerance": 34, "governmentTrust": 40, "policyAcceptance": 60, "regulationPreference": 50, "publicServiceSatisfaction": 75}	1
69	신서연	63	60-69	Female	서울특별시	37.549277	127.058704	대학원 졸	200만원 미만	공무원	다세대 가구	51	보수 정당 지지	62	{"economy": 34, "housing": 2, "welfare": 2, "security": 9, "environment": 16}	지상파/종편 뉴스	{전통,자유,공정}	서울특별시에 거주하는 60-69 공무원. 정치 성향은 보수이며 전통, 자유, 공정 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 66, "ecoConsciousness": 48, "priceSensitivity": 77, "digitalConsumption": 55}	{"taxTolerance": 48, "governmentTrust": 60, "policyAcceptance": 47, "regulationPreference": 68, "publicServiceSatisfaction": 53}	1
70	임주원	63	60-69	Female	서울특별시	37.635509	126.937246	대학교 졸	200-350만원	공무원	자녀 양육 가구	-32	진보 성향 무당층	84	{"economy": -11, "housing": 10, "welfare": 38, "security": 15, "environment": 8}	포털 뉴스	{자유,공동체,다양성}	서울특별시에 거주하는 60-69 공무원. 정치 성향은 중도이며 자유, 공동체, 다양성 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 62, "ecoConsciousness": 48, "priceSensitivity": 72, "digitalConsumption": 67}	{"taxTolerance": 47, "governmentTrust": 46, "policyAcceptance": 61, "regulationPreference": 66, "publicServiceSatisfaction": 78}	1
71	한지우	67	60-69	Male	서울특별시	37.584067	126.957224	전문대 졸	350-500만원	은퇴	1인 가구	15	보수 성향 무당층	55	{"economy": 3, "housing": 10, "welfare": 20, "security": 34, "environment": 29}	SNS	{환경,혁신,다양성}	서울특별시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 환경, 혁신, 다양성 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 49, "ecoConsciousness": 36, "priceSensitivity": 72, "digitalConsumption": 73}	{"taxTolerance": 66, "governmentTrust": 44, "policyAcceptance": 48, "regulationPreference": 62, "publicServiceSatisfaction": 99}	1
72	박지아	67	60-69	Male	서울특별시	37.625085	126.997746	전문대 졸	200만원 미만	은퇴	부부 가구	27	보수 성향 무당층	76	{"economy": 24, "housing": -11, "welfare": 4, "security": 28, "environment": 7}	지상파/종편 뉴스	{다양성,공정,안전}	서울특별시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 다양성, 공정, 안전 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 23, "ecoConsciousness": 66, "priceSensitivity": 69, "digitalConsumption": 65}	{"taxTolerance": 43, "governmentTrust": 53, "policyAcceptance": 40, "regulationPreference": 46, "publicServiceSatisfaction": 66}	1
73	한유준	64	60-69	Male	서울특별시	37.540218	126.949081	대학교 졸	500-700만원	자영업	1인 가구	23	보수 성향 무당층	90	{"economy": 3, "housing": -23, "welfare": -6, "security": 6, "environment": -13}	지상파/종편 뉴스	{성장,혁신,환경}	서울특별시에 거주하는 60-69 자영업. 정치 성향은 중도이며 성장, 혁신, 환경 가치를 중시한다.	{"brandLoyalty": 63, "noveltySeeking": 56, "ecoConsciousness": 61, "priceSensitivity": 58, "digitalConsumption": 70}	{"taxTolerance": 47, "governmentTrust": 31, "policyAcceptance": 52, "regulationPreference": 63, "publicServiceSatisfaction": 76}	1
74	박수아	66	60-69	Male	서울특별시	37.597587	126.900564	대학교 졸	200-350만원	은퇴	자녀 양육 가구	-1	중도 무당층	99	{"economy": -23, "housing": -2, "welfare": 25, "security": 14, "environment": 16}	지상파/종편 뉴스	{전통,자유,공동체}	서울특별시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 전통, 자유, 공동체 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 55, "ecoConsciousness": 33, "priceSensitivity": 73, "digitalConsumption": 72}	{"taxTolerance": 60, "governmentTrust": 40, "policyAcceptance": 50, "regulationPreference": 68, "publicServiceSatisfaction": 60}	1
75	홍서윤	62	60-69	Male	서울특별시	37.587188	126.910749	전문대 졸	200만원 미만	사무직	다세대 가구	1	중도 무당층	93	{"economy": -13, "housing": 25, "welfare": -15, "security": -23, "environment": 10}	포털 뉴스	{혁신,안전,전통}	서울특별시에 거주하는 60-69 사무직. 정치 성향은 중도이며 혁신, 안전, 전통 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 50, "ecoConsciousness": 45, "priceSensitivity": 86, "digitalConsumption": 87}	{"taxTolerance": 60, "governmentTrust": 47, "policyAcceptance": 57, "regulationPreference": 57, "publicServiceSatisfaction": 60}	1
76	한지아	69	60-69	Male	서울특별시	37.635137	126.943097	대학교 졸	350-500만원	은퇴	다세대 가구	21	보수 성향 무당층	84	{"economy": 15, "housing": 22, "welfare": -5, "security": 7, "environment": 24}	SNS	{성장,공동체,안전}	서울특별시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 성장, 공동체, 안전 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 67, "ecoConsciousness": 16, "priceSensitivity": 75, "digitalConsumption": 46}	{"taxTolerance": 58, "governmentTrust": 54, "policyAcceptance": 71, "regulationPreference": 76, "publicServiceSatisfaction": 71}	1
77	장지호	67	60-69	Male	서울특별시	37.646371	126.880317	전문대 졸	350-500만원	은퇴	부부 가구	-30	진보 성향 무당층	88	{"economy": -39, "housing": 23, "welfare": 14, "security": -49, "environment": 25}	지상파/종편 뉴스	{안정,안전,공정}	서울특별시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 안정, 안전, 공정 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 52, "ecoConsciousness": 59, "priceSensitivity": 74, "digitalConsumption": 73}	{"taxTolerance": 55, "governmentTrust": 61, "policyAcceptance": 56, "regulationPreference": 81, "publicServiceSatisfaction": 52}	1
78	조성호	64	60-69	Male	서울특별시	37.540197	126.912975	대학원 졸	350-500만원	자영업	부부 가구	28	보수 성향 무당층	77	{"economy": -7, "housing": 19, "welfare": -8, "security": 32, "environment": -17}	지상파/종편 뉴스	{공정,자유,공동체}	서울특별시에 거주하는 60-69 자영업. 정치 성향은 중도이며 공정, 자유, 공동체 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 71, "ecoConsciousness": 50, "priceSensitivity": 58, "digitalConsumption": 61}	{"taxTolerance": 52, "governmentTrust": 47, "policyAcceptance": 47, "regulationPreference": 77, "publicServiceSatisfaction": 70}	1
79	윤예준	80	70+	Female	서울특별시	37.509916	127.055905	전문대 졸	200-350만원	은퇴	자녀 양육 가구	18	보수 성향 무당층	92	{"economy": -5, "housing": 36, "welfare": 21, "security": 26, "environment": -4}	신문/팟캐스트	{자유,혁신,환경}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 자유, 혁신, 환경 가치를 중시한다.	{"brandLoyalty": 80, "noveltySeeking": 32, "ecoConsciousness": 41, "priceSensitivity": 80, "digitalConsumption": 71}	{"taxTolerance": 48, "governmentTrust": 60, "policyAcceptance": 66, "regulationPreference": 71, "publicServiceSatisfaction": 65}	1
80	이민준	82	70+	Female	서울특별시	37.618652	127.01994	고졸 이하	500-700만원	은퇴	다세대 가구	44	보수 성향 무당층	98	{"economy": 9, "housing": -15, "welfare": -3, "security": 16, "environment": -28}	신문/팟캐스트	{환경,안전,성장}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 환경, 안전, 성장 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 62, "ecoConsciousness": 34, "priceSensitivity": 63, "digitalConsumption": 46}	{"taxTolerance": 45, "governmentTrust": 55, "policyAcceptance": 48, "regulationPreference": 58, "publicServiceSatisfaction": 85}	1
81	송민준	78	70+	Female	서울특별시	37.606362	126.954968	대학원 졸	350-500만원	은퇴	자녀 양육 가구	16	보수 성향 무당층	96	{"economy": -5, "housing": -5, "welfare": 23, "security": 29, "environment": 38}	SNS	{공동체,공정,전통}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공동체, 공정, 전통 가치를 중시한다.	{"brandLoyalty": 65, "noveltySeeking": 61, "ecoConsciousness": 46, "priceSensitivity": 55, "digitalConsumption": 51}	{"taxTolerance": 61, "governmentTrust": 42, "policyAcceptance": 53, "regulationPreference": 68, "publicServiceSatisfaction": 67}	1
82	정하은	83	70+	Female	서울특별시	37.588059	127.054279	대학원 졸	700만원 이상	은퇴	자녀 양육 가구	33	보수 성향 무당층	75	{"economy": 4, "housing": -1, "welfare": 18, "security": 57, "environment": 9}	포털 뉴스	{자유,성장,공정}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 자유, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 67, "noveltySeeking": 44, "ecoConsciousness": 58, "priceSensitivity": 54, "digitalConsumption": 56}	{"taxTolerance": 41, "governmentTrust": 38, "policyAcceptance": 46, "regulationPreference": 64, "publicServiceSatisfaction": 76}	1
83	조성호	81	70+	Female	서울특별시	37.566145	127.019193	대학교 졸	350-500만원	은퇴	자녀 양육 가구	16	보수 성향 무당층	82	{"economy": 33, "housing": 2, "welfare": -4, "security": 16, "environment": 10}	유튜브	{혁신,환경,공동체}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 혁신, 환경, 공동체 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 67, "ecoConsciousness": 65, "priceSensitivity": 62, "digitalConsumption": 59}	{"taxTolerance": 59, "governmentTrust": 58, "policyAcceptance": 56, "regulationPreference": 74, "publicServiceSatisfaction": 61}	1
84	홍하은	78	70+	Female	서울특별시	37.561763	127.057316	대학원 졸	350-500만원	은퇴	1인 가구	25	보수 성향 무당층	69	{"economy": 9, "housing": 30, "welfare": 25, "security": 15, "environment": 17}	포털 뉴스	{안전,자유,공정}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안전, 자유, 공정 가치를 중시한다.	{"brandLoyalty": 61, "noveltySeeking": 28, "ecoConsciousness": 64, "priceSensitivity": 76, "digitalConsumption": 48}	{"taxTolerance": 22, "governmentTrust": 58, "policyAcceptance": 49, "regulationPreference": 69, "publicServiceSatisfaction": 66}	1
85	윤유준	79	70+	Male	서울특별시	37.603745	127.074964	대학원 졸	350-500만원	은퇴	다세대 가구	47	보수 정당 지지	99	{"economy": 12, "housing": 10, "welfare": 1, "security": 26, "environment": -4}	지상파/종편 뉴스	{안정,전통,혁신}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안정, 전통, 혁신 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 49, "ecoConsciousness": 56, "priceSensitivity": 65, "digitalConsumption": 41}	{"taxTolerance": 49, "governmentTrust": 62, "policyAcceptance": 41, "regulationPreference": 71, "publicServiceSatisfaction": 66}	1
86	오서윤	78	70+	Male	서울특별시	37.558274	127.015279	고졸 이하	350-500만원	은퇴	자녀 양육 가구	4	중도 무당층	82	{"economy": 0, "housing": 15, "welfare": -8, "security": 30, "environment": 7}	포털 뉴스	{성장,공정,안전}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 성장, 공정, 안전 가치를 중시한다.	{"brandLoyalty": 71, "noveltySeeking": 36, "ecoConsciousness": 71, "priceSensitivity": 61, "digitalConsumption": 62}	{"taxTolerance": 51, "governmentTrust": 57, "policyAcceptance": 47, "regulationPreference": 58, "publicServiceSatisfaction": 58}	1
87	조주원	72	70+	Male	서울특별시	37.641656	127.060531	전문대 졸	350-500만원	은퇴	다세대 가구	78	보수 정당 지지	57	{"economy": 56, "housing": -14, "welfare": -24, "security": 65, "environment": -5}	포털 뉴스	{전통,자유,성장}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 전통, 자유, 성장 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 52, "ecoConsciousness": 44, "priceSensitivity": 45, "digitalConsumption": 68}	{"taxTolerance": 53, "governmentTrust": 37, "policyAcceptance": 66, "regulationPreference": 82, "publicServiceSatisfaction": 58}	1
88	안예준	77	70+	Male	서울특별시	37.535935	126.997322	대학교 졸	700만원 이상	은퇴	1인 가구	40	보수 성향 무당층	99	{"economy": 30, "housing": 6, "welfare": -18, "security": 25, "environment": 8}	지상파/종편 뉴스	{공정,안전,성장}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 공정, 안전, 성장 가치를 중시한다.	{"brandLoyalty": 64, "noveltySeeking": 50, "ecoConsciousness": 50, "priceSensitivity": 37, "digitalConsumption": 56}	{"taxTolerance": 63, "governmentTrust": 48, "policyAcceptance": 36, "regulationPreference": 73, "publicServiceSatisfaction": 54}	1
89	류유준	78	70+	Male	서울특별시	37.5964	126.956036	대학교 졸	350-500만원	은퇴	부부 가구	35	보수 성향 무당층	79	{"economy": 13, "housing": -19, "welfare": 13, "security": 30, "environment": 22}	유튜브	{안정,환경,공동체}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안정, 환경, 공동체 가치를 중시한다.	{"brandLoyalty": 65, "noveltySeeking": 62, "ecoConsciousness": 46, "priceSensitivity": 62, "digitalConsumption": 53}	{"taxTolerance": 52, "governmentTrust": 56, "policyAcceptance": 54, "regulationPreference": 66, "publicServiceSatisfaction": 64}	1
90	홍유준	82	70+	Male	서울특별시	37.513707	127.004989	대학원 졸	700만원 이상	은퇴	1인 가구	10	중도 무당층	79	{"economy": -8, "housing": 12, "welfare": 16, "security": -6, "environment": 17}	유튜브	{안전,안정,공동체}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안전, 안정, 공동체 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 58, "ecoConsciousness": 50, "priceSensitivity": 60, "digitalConsumption": 64}	{"taxTolerance": 46, "governmentTrust": 52, "policyAcceptance": 52, "regulationPreference": 74, "publicServiceSatisfaction": 77}	1
91	황경숙	22	18-29	Female	부산광역시	35.236393	128.995537	대학원 졸	200-350만원	학생	1인 가구	-15	진보 성향 무당층	39	{"economy": -10, "housing": 32, "welfare": 39, "security": -22, "environment": 17}	SNS	{안전,전통,공동체}	부산광역시에 거주하는 18-29 학생. 정치 성향은 중도이며 안전, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 76, "ecoConsciousness": 76, "priceSensitivity": 77, "digitalConsumption": 70}	{"taxTolerance": 55, "governmentTrust": 45, "policyAcceptance": 46, "regulationPreference": 34, "publicServiceSatisfaction": 54}	1
92	송도윤	27	18-29	Female	부산광역시	35.24313	129.093656	대학원 졸	700만원 이상	공무원	부부 가구	2	중도 무당층	38	{"economy": 28, "housing": 22, "welfare": 27, "security": 16, "environment": 2}	SNS	{혁신,공정,성장}	부산광역시에 거주하는 18-29 공무원. 정치 성향은 중도이며 혁신, 공정, 성장 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 58, "ecoConsciousness": 60, "priceSensitivity": 52, "digitalConsumption": 86}	{"taxTolerance": 37, "governmentTrust": 50, "policyAcceptance": 48, "regulationPreference": 66, "publicServiceSatisfaction": 58}	1
93	강지우	25	18-29	Female	부산광역시	35.220779	129.141438	대학원 졸	200-350만원	주부	다세대 가구	2	중도 무당층	46	{"economy": -31, "housing": 8, "welfare": -6, "security": 12, "environment": 32}	SNS	{전통,혁신,안정}	부산광역시에 거주하는 18-29 주부. 정치 성향은 중도이며 전통, 혁신, 안정 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 86, "ecoConsciousness": 67, "priceSensitivity": 70, "digitalConsumption": 86}	{"taxTolerance": 66, "governmentTrust": 55, "policyAcceptance": 38, "regulationPreference": 61, "publicServiceSatisfaction": 75}	1
94	박다은	19	18-29	Male	부산광역시	35.170278	129.017587	대학원 졸	200만원 미만	학생	1인 가구	18	보수 성향 무당층	70	{"economy": 5, "housing": -5, "welfare": 9, "security": 14, "environment": -29}	신문/팟캐스트	{공동체,자유,공정}	부산광역시에 거주하는 18-29 학생. 정치 성향은 중도이며 공동체, 자유, 공정 가치를 중시한다.	{"brandLoyalty": 24, "noveltySeeking": 62, "ecoConsciousness": 66, "priceSensitivity": 71, "digitalConsumption": 86}	{"taxTolerance": 50, "governmentTrust": 18, "policyAcceptance": 50, "regulationPreference": 77, "publicServiceSatisfaction": 91}	1
95	오영수	29	18-29	Male	부산광역시	35.105288	129.089024	대학교 졸	200-350만원	전문직	부부 가구	-11	중도 무당층	65	{"economy": -18, "housing": 27, "welfare": 24, "security": 4, "environment": 9}	포털 뉴스	{공동체,혁신,안전}	부산광역시에 거주하는 18-29 전문직. 정치 성향은 중도이며 공동체, 혁신, 안전 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 72, "ecoConsciousness": 53, "priceSensitivity": 80, "digitalConsumption": 76}	{"taxTolerance": 37, "governmentTrust": 41, "policyAcceptance": 41, "regulationPreference": 67, "publicServiceSatisfaction": 47}	1
96	서현우	28	18-29	Male	부산광역시	35.24225	129.119934	대학원 졸	200-350만원	사무직	다세대 가구	12	중도 무당층	52	{"economy": 26, "housing": 17, "welfare": -4, "security": 1, "environment": -1}	포털 뉴스	{안전,안정,공정}	부산광역시에 거주하는 18-29 사무직. 정치 성향은 중도이며 안전, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 24, "noveltySeeking": 64, "ecoConsciousness": 70, "priceSensitivity": 81, "digitalConsumption": 75}	{"taxTolerance": 59, "governmentTrust": 45, "policyAcceptance": 38, "regulationPreference": 62, "publicServiceSatisfaction": 58}	1
97	박경숙	32	30-39	Female	부산광역시	35.122833	129.147966	대학교 졸	350-500만원	은퇴	다세대 가구	21	보수 성향 무당층	49	{"economy": 10, "housing": 20, "welfare": 10, "security": 19, "environment": -7}	SNS	{안전,다양성,성장}	부산광역시에 거주하는 30-39 은퇴. 정치 성향은 중도이며 안전, 다양성, 성장 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 72, "ecoConsciousness": 49, "priceSensitivity": 73, "digitalConsumption": 73}	{"taxTolerance": 47, "governmentTrust": 20, "policyAcceptance": 54, "regulationPreference": 60, "publicServiceSatisfaction": 80}	1
98	김동현	37	30-39	Female	부산광역시	35.142028	129.067365	대학교 졸	500-700만원	학생	1인 가구	-13	중도 무당층	63	{"economy": -16, "housing": 7, "welfare": 6, "security": -8, "environment": 27}	지상파/종편 뉴스	{자유,공정,안정}	부산광역시에 거주하는 30-39 학생. 정치 성향은 중도이며 자유, 공정, 안정 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 76, "ecoConsciousness": 54, "priceSensitivity": 61, "digitalConsumption": 61}	{"taxTolerance": 54, "governmentTrust": 42, "policyAcceptance": 47, "regulationPreference": 46, "publicServiceSatisfaction": 58}	1
99	장지아	33	30-39	Female	부산광역시	35.233107	129.171849	대학원 졸	500-700만원	자영업	다세대 가구	38	보수 성향 무당층	50	{"economy": -8, "housing": 15, "welfare": 5, "security": 23, "environment": 34}	유튜브	{공동체,전통,환경}	부산광역시에 거주하는 30-39 자영업. 정치 성향은 보수이며 공동체, 전통, 환경 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 81, "ecoConsciousness": 41, "priceSensitivity": 51, "digitalConsumption": 78}	{"taxTolerance": 47, "governmentTrust": 38, "policyAcceptance": 57, "regulationPreference": 74, "publicServiceSatisfaction": 65}	1
100	윤민준	33	30-39	Male	부산광역시	35.24632	129.116251	전문대 졸	200-350만원	서비스직	자녀 양육 가구	8	중도 무당층	66	{"economy": 7, "housing": 21, "welfare": -3, "security": -13, "environment": 18}	포털 뉴스	{안전,안정,혁신}	부산광역시에 거주하는 30-39 서비스직. 정치 성향은 중도이며 안전, 안정, 혁신 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 76, "ecoConsciousness": 49, "priceSensitivity": 76, "digitalConsumption": 83}	{"taxTolerance": 49, "governmentTrust": 47, "policyAcceptance": 52, "regulationPreference": 69, "publicServiceSatisfaction": 46}	1
101	박주원	38	30-39	Male	부산광역시	35.234824	129.167333	전문대 졸	350-500만원	생산직	다세대 가구	-2	중도 무당층	53	{"economy": 15, "housing": 10, "welfare": 14, "security": 2, "environment": 20}	SNS	{안전,성장,다양성}	부산광역시에 거주하는 30-39 생산직. 정치 성향은 중도이며 안전, 성장, 다양성 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 72, "ecoConsciousness": 56, "priceSensitivity": 68, "digitalConsumption": 74}	{"taxTolerance": 43, "governmentTrust": 36, "policyAcceptance": 39, "regulationPreference": 65, "publicServiceSatisfaction": 49}	1
102	송다은	30	30-39	Male	부산광역시	35.198734	129.099461	대학원 졸	500-700만원	학생	자녀 양육 가구	12	중도 무당층	49	{"economy": -2, "housing": 2, "welfare": -5, "security": -2, "environment": 12}	SNS	{혁신,공동체,자유}	부산광역시에 거주하는 30-39 학생. 정치 성향은 중도이며 혁신, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 60, "ecoConsciousness": 67, "priceSensitivity": 68, "digitalConsumption": 73}	{"taxTolerance": 59, "governmentTrust": 20, "policyAcceptance": 31, "regulationPreference": 57, "publicServiceSatisfaction": 78}	1
103	신경숙	43	40-49	Female	부산광역시	35.218657	129.120277	대학교 졸	200-350만원	공무원	자녀 양육 가구	32	보수 성향 무당층	70	{"economy": 23, "housing": 31, "welfare": 14, "security": 11, "environment": -7}	지상파/종편 뉴스	{환경,공동체,자유}	부산광역시에 거주하는 40-49 공무원. 정치 성향은 중도이며 환경, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 56, "ecoConsciousness": 75, "priceSensitivity": 71, "digitalConsumption": 74}	{"taxTolerance": 22, "governmentTrust": 38, "policyAcceptance": 50, "regulationPreference": 50, "publicServiceSatisfaction": 71}	1
104	오정희	49	40-49	Female	부산광역시	35.112486	129.024414	대학교 졸	500-700만원	생산직	다세대 가구	23	보수 성향 무당층	53	{"economy": 0, "housing": 6, "welfare": 9, "security": -2, "environment": 21}	SNS	{공정,안전,자유}	부산광역시에 거주하는 40-49 생산직. 정치 성향은 중도이며 공정, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 66, "ecoConsciousness": 59, "priceSensitivity": 65, "digitalConsumption": 61}	{"taxTolerance": 50, "governmentTrust": 32, "policyAcceptance": 43, "regulationPreference": 49, "publicServiceSatisfaction": 66}	1
105	전지호	46	40-49	Female	부산광역시	35.135704	129.015	대학교 졸	700만원 이상	전문직	1인 가구	-23	진보 성향 무당층	57	{"economy": -2, "housing": 10, "welfare": 61, "security": 9, "environment": 48}	신문/팟캐스트	{성장,자유,전통}	부산광역시에 거주하는 40-49 전문직. 정치 성향은 중도이며 성장, 자유, 전통 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 65, "ecoConsciousness": 76, "priceSensitivity": 39, "digitalConsumption": 68}	{"taxTolerance": 49, "governmentTrust": 45, "policyAcceptance": 53, "regulationPreference": 58, "publicServiceSatisfaction": 73}	1
106	서지우	42	40-49	Male	부산광역시	35.169216	129.154118	전문대 졸	350-500만원	전문직	자녀 양육 가구	-6	중도 무당층	63	{"economy": 25, "housing": 34, "welfare": 3, "security": 24, "environment": 41}	SNS	{안전,성장,공정}	부산광역시에 거주하는 40-49 전문직. 정치 성향은 중도이며 안전, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 69, "ecoConsciousness": 47, "priceSensitivity": 66, "digitalConsumption": 93}	{"taxTolerance": 45, "governmentTrust": 53, "policyAcceptance": 52, "regulationPreference": 57, "publicServiceSatisfaction": 76}	1
107	송서윤	48	40-49	Male	부산광역시	35.205513	129.139544	전문대 졸	500-700만원	사무직	자녀 양육 가구	30	보수 성향 무당층	69	{"economy": 3, "housing": 13, "welfare": 36, "security": 18, "environment": -5}	SNS	{안정,공정,공동체}	부산광역시에 거주하는 40-49 사무직. 정치 성향은 중도이며 안정, 공정, 공동체 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 56, "ecoConsciousness": 32, "priceSensitivity": 62, "digitalConsumption": 80}	{"taxTolerance": 58, "governmentTrust": 43, "policyAcceptance": 41, "regulationPreference": 65, "publicServiceSatisfaction": 77}	1
108	강서윤	47	40-49	Male	부산광역시	35.102098	129.070728	대학원 졸	500-700만원	공무원	다세대 가구	42	보수 성향 무당층	54	{"economy": 51, "housing": -6, "welfare": -22, "security": 33, "environment": 17}	포털 뉴스	{자유,환경,안정}	부산광역시에 거주하는 40-49 공무원. 정치 성향은 보수이며 자유, 환경, 안정 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 57, "ecoConsciousness": 67, "priceSensitivity": 51, "digitalConsumption": 64}	{"taxTolerance": 59, "governmentTrust": 48, "policyAcceptance": 47, "regulationPreference": 59, "publicServiceSatisfaction": 53}	1
109	서정희	50	50-59	Female	부산광역시	35.11367	129.033011	고졸 이하	700만원 이상	생산직	다세대 가구	-18	진보 성향 무당층	62	{"economy": -27, "housing": 2, "welfare": 28, "security": -33, "environment": 42}	유튜브	{성장,다양성,공동체}	부산광역시에 거주하는 50-59 생산직. 정치 성향은 중도이며 성장, 다양성, 공동체 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 64, "ecoConsciousness": 59, "priceSensitivity": 49, "digitalConsumption": 56}	{"taxTolerance": 33, "governmentTrust": 42, "policyAcceptance": 37, "regulationPreference": 56, "publicServiceSatisfaction": 61}	1
110	장광수	53	50-59	Female	부산광역시	35.179229	129.020869	고졸 이하	700만원 이상	생산직	다세대 가구	7	중도 무당층	78	{"economy": 23, "housing": 10, "welfare": 9, "security": 16, "environment": 18}	유튜브	{공정,안정,자유}	부산광역시에 거주하는 50-59 생산직. 정치 성향은 중도이며 공정, 안정, 자유 가치를 중시한다.	{"brandLoyalty": 26, "noveltySeeking": 59, "ecoConsciousness": 54, "priceSensitivity": 41, "digitalConsumption": 56}	{"taxTolerance": 43, "governmentTrust": 74, "policyAcceptance": 52, "regulationPreference": 65, "publicServiceSatisfaction": 56}	1
111	류서윤	52	50-59	Female	부산광역시	35.207373	129.010424	대학교 졸	350-500만원	학생	1인 가구	2	중도 무당층	82	{"economy": -6, "housing": 23, "welfare": 36, "security": 3, "environment": 30}	포털 뉴스	{안정,전통,공동체}	부산광역시에 거주하는 50-59 학생. 정치 성향은 중도이며 안정, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 69, "noveltySeeking": 51, "ecoConsciousness": 59, "priceSensitivity": 69, "digitalConsumption": 88}	{"taxTolerance": 45, "governmentTrust": 41, "policyAcceptance": 34, "regulationPreference": 56, "publicServiceSatisfaction": 52}	1
112	이영수	57	50-59	Male	부산광역시	35.214191	129.048394	대학교 졸	700만원 이상	학생	부부 가구	42	보수 성향 무당층	49	{"economy": 10, "housing": -29, "welfare": 7, "security": 31, "environment": 7}	지상파/종편 뉴스	{공동체,혁신,성장}	부산광역시에 거주하는 50-59 학생. 정치 성향은 보수이며 공동체, 혁신, 성장 가치를 중시한다.	{"brandLoyalty": 63, "noveltySeeking": 65, "ecoConsciousness": 33, "priceSensitivity": 48, "digitalConsumption": 61}	{"taxTolerance": 59, "governmentTrust": 52, "policyAcceptance": 32, "regulationPreference": 62, "publicServiceSatisfaction": 56}	1
113	장지호	55	50-59	Male	부산광역시	35.22018	129.013577	대학교 졸	350-500만원	서비스직	다세대 가구	14	중도 무당층	55	{"economy": 12, "housing": 17, "welfare": 20, "security": 3, "environment": -8}	유튜브	{혁신,성장,전통}	부산광역시에 거주하는 50-59 서비스직. 정치 성향은 중도이며 혁신, 성장, 전통 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 61, "ecoConsciousness": 38, "priceSensitivity": 63, "digitalConsumption": 78}	{"taxTolerance": 57, "governmentTrust": 50, "policyAcceptance": 31, "regulationPreference": 66, "publicServiceSatisfaction": 65}	1
114	박다은	52	50-59	Male	부산광역시	35.182997	129.058118	전문대 졸	700만원 이상	사무직	다세대 가구	32	보수 성향 무당층	60	{"economy": -1, "housing": -4, "welfare": -7, "security": 1, "environment": 5}	신문/팟캐스트	{다양성,전통,공동체}	부산광역시에 거주하는 50-59 사무직. 정치 성향은 중도이며 다양성, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 55, "ecoConsciousness": 49, "priceSensitivity": 41, "digitalConsumption": 77}	{"taxTolerance": 51, "governmentTrust": 64, "policyAcceptance": 62, "regulationPreference": 48, "publicServiceSatisfaction": 69}	1
115	윤경숙	69	60-69	Female	부산광역시	35.136548	129.003321	고졸 이하	500-700만원	은퇴	부부 가구	-5	중도 무당층	88	{"economy": -23, "housing": 6, "welfare": 12, "security": 16, "environment": 41}	포털 뉴스	{안전,전통,다양성}	부산광역시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 안전, 전통, 다양성 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 28, "ecoConsciousness": 29, "priceSensitivity": 43, "digitalConsumption": 52}	{"taxTolerance": 41, "governmentTrust": 62, "policyAcceptance": 56, "regulationPreference": 74, "publicServiceSatisfaction": 63}	1
116	신성호	63	60-69	Female	부산광역시	35.195849	129.052669	대학원 졸	200-350만원	은퇴	부부 가구	89	보수 정당 지지	61	{"economy": 13, "housing": -1, "welfare": -34, "security": 41, "environment": -35}	포털 뉴스	{공정,자유,안정}	부산광역시에 거주하는 60-69 은퇴. 정치 성향은 보수이며 공정, 자유, 안정 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 72, "ecoConsciousness": 67, "priceSensitivity": 71, "digitalConsumption": 53}	{"taxTolerance": 33, "governmentTrust": 36, "policyAcceptance": 40, "regulationPreference": 59, "publicServiceSatisfaction": 60}	1
117	류지우	66	60-69	Female	부산광역시	35.203638	129.08017	고졸 이하	350-500만원	서비스직	자녀 양육 가구	-8	중도 무당층	60	{"economy": 13, "housing": -9, "welfare": 0, "security": -35, "environment": 7}	신문/팟캐스트	{환경,공동체,안전}	부산광역시에 거주하는 60-69 서비스직. 정치 성향은 중도이며 환경, 공동체, 안전 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 47, "ecoConsciousness": 48, "priceSensitivity": 73, "digitalConsumption": 61}	{"taxTolerance": 48, "governmentTrust": 47, "policyAcceptance": 57, "regulationPreference": 58, "publicServiceSatisfaction": 75}	1
118	서준서	62	60-69	Male	부산광역시	35.258205	129.002057	대학교 졸	500-700만원	주부	다세대 가구	45	보수 정당 지지	99	{"economy": 10, "housing": -5, "welfare": -37, "security": 64, "environment": 6}	SNS	{성장,안전,자유}	부산광역시에 거주하는 60-69 주부. 정치 성향은 보수이며 성장, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 43, "ecoConsciousness": 58, "priceSensitivity": 40, "digitalConsumption": 79}	{"taxTolerance": 66, "governmentTrust": 47, "policyAcceptance": 58, "regulationPreference": 50, "publicServiceSatisfaction": 74}	1
119	임준서	63	60-69	Male	부산광역시	35.212717	129.137106	대학교 졸	350-500만원	서비스직	자녀 양육 가구	51	보수 정당 지지	85	{"economy": 23, "housing": -13, "welfare": -49, "security": 98, "environment": 8}	포털 뉴스	{공동체,공정,혁신}	부산광역시에 거주하는 60-69 서비스직. 정치 성향은 보수이며 공동체, 공정, 혁신 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 53, "ecoConsciousness": 59, "priceSensitivity": 75, "digitalConsumption": 70}	{"taxTolerance": 63, "governmentTrust": 56, "policyAcceptance": 46, "regulationPreference": 63, "publicServiceSatisfaction": 66}	1
120	장지아	63	60-69	Male	부산광역시	35.178409	129.024189	대학교 졸	500-700만원	전문직	부부 가구	20	보수 성향 무당층	57	{"economy": 30, "housing": -7, "welfare": -5, "security": 22, "environment": -18}	유튜브	{공정,다양성,환경}	부산광역시에 거주하는 60-69 전문직. 정치 성향은 중도이며 공정, 다양성, 환경 가치를 중시한다.	{"brandLoyalty": 64, "noveltySeeking": 46, "ecoConsciousness": 44, "priceSensitivity": 86, "digitalConsumption": 83}	{"taxTolerance": 40, "governmentTrust": 44, "policyAcceptance": 48, "regulationPreference": 67, "publicServiceSatisfaction": 79}	1
121	오동현	71	70+	Female	부산광역시	35.102488	129.133936	전문대 졸	200만원 미만	은퇴	부부 가구	17	보수 성향 무당층	54	{"economy": 11, "housing": 16, "welfare": -11, "security": 14, "environment": -11}	지상파/종편 뉴스	{성장,환경,안전}	부산광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 성장, 환경, 안전 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 61, "ecoConsciousness": 56, "priceSensitivity": 92, "digitalConsumption": 57}	{"taxTolerance": 47, "governmentTrust": 52, "policyAcceptance": 45, "regulationPreference": 63, "publicServiceSatisfaction": 61}	1
122	김은우	81	70+	Female	부산광역시	35.215789	129.162366	전문대 졸	500-700만원	은퇴	자녀 양육 가구	66	보수 정당 지지	72	{"economy": 47, "housing": -27, "welfare": -29, "security": 62, "environment": 8}	신문/팟캐스트	{환경,성장,공동체}	부산광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 환경, 성장, 공동체 가치를 중시한다.	{"brandLoyalty": 63, "noveltySeeking": 56, "ecoConsciousness": 49, "priceSensitivity": 74, "digitalConsumption": 75}	{"taxTolerance": 47, "governmentTrust": 49, "policyAcceptance": 64, "regulationPreference": 59, "publicServiceSatisfaction": 50}	1
123	서정희	83	70+	Male	부산광역시	35.185581	129.117844	전문대 졸	350-500만원	은퇴	부부 가구	40	보수 성향 무당층	98	{"economy": 16, "housing": 15, "welfare": -6, "security": 33, "environment": 3}	지상파/종편 뉴스	{다양성,안정,전통}	부산광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 다양성, 안정, 전통 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 38, "ecoConsciousness": 27, "priceSensitivity": 64, "digitalConsumption": 52}	{"taxTolerance": 30, "governmentTrust": 64, "policyAcceptance": 72, "regulationPreference": 79, "publicServiceSatisfaction": 56}	1
124	전건우	78	70+	Male	부산광역시	35.258887	128.986421	전문대 졸	350-500만원	은퇴	다세대 가구	40	보수 성향 무당층	75	{"economy": 30, "housing": 21, "welfare": -16, "security": 6, "environment": 15}	유튜브	{안전,안정,환경}	부산광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안전, 안정, 환경 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 43, "ecoConsciousness": 41, "priceSensitivity": 64, "digitalConsumption": 51}	{"taxTolerance": 38, "governmentTrust": 39, "policyAcceptance": 48, "regulationPreference": 68, "publicServiceSatisfaction": 65}	1
125	조유준	21	18-29	Female	대구광역시	35.950796	128.554735	대학교 졸	200-350만원	학생	자녀 양육 가구	38	보수 성향 무당층	31	{"economy": 26, "housing": 11, "welfare": -16, "security": 39, "environment": 3}	포털 뉴스	{안정,다양성,공동체}	대구광역시에 거주하는 18-29 학생. 정치 성향은 보수이며 안정, 다양성, 공동체 가치를 중시한다.	{"brandLoyalty": 23, "noveltySeeking": 81, "ecoConsciousness": 56, "priceSensitivity": 67, "digitalConsumption": 85}	{"taxTolerance": 65, "governmentTrust": 49, "policyAcceptance": 32, "regulationPreference": 61, "publicServiceSatisfaction": 74}	1
126	박성호	20	18-29	Female	대구광역시	35.948923	128.666656	대학원 졸	350-500만원	학생	1인 가구	-11	중도 무당층	56	{"economy": -15, "housing": -2, "welfare": 37, "security": 9, "environment": 9}	유튜브	{안전,공동체,성장}	대구광역시에 거주하는 18-29 학생. 정치 성향은 중도이며 안전, 공동체, 성장 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 92, "ecoConsciousness": 57, "priceSensitivity": 55, "digitalConsumption": 98}	{"taxTolerance": 44, "governmentTrust": 49, "policyAcceptance": 37, "regulationPreference": 68, "publicServiceSatisfaction": 70}	1
127	홍성호	21	18-29	Male	대구광역시	35.857023	128.590122	대학교 졸	350-500만원	학생	다세대 가구	5	중도 무당층	57	{"economy": -2, "housing": 10, "welfare": -7, "security": 17, "environment": 1}	지상파/종편 뉴스	{안정,공정,전통}	대구광역시에 거주하는 18-29 학생. 정치 성향은 중도이며 안정, 공정, 전통 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 59, "ecoConsciousness": 60, "priceSensitivity": 72, "digitalConsumption": 90}	{"taxTolerance": 61, "governmentTrust": 38, "policyAcceptance": 46, "regulationPreference": 51, "publicServiceSatisfaction": 61}	1
128	한영수	18	18-29	Male	대구광역시	35.94976	128.519384	고졸 이하	200-350만원	학생	다세대 가구	-1	중도 무당층	57	{"economy": -5, "housing": 21, "welfare": 25, "security": -14, "environment": 37}	포털 뉴스	{성장,안전,전통}	대구광역시에 거주하는 18-29 학생. 정치 성향은 중도이며 성장, 안전, 전통 가치를 중시한다.	{"brandLoyalty": 13, "noveltySeeking": 76, "ecoConsciousness": 51, "priceSensitivity": 71, "digitalConsumption": 100}	{"taxTolerance": 43, "governmentTrust": 28, "policyAcceptance": 41, "regulationPreference": 77, "publicServiceSatisfaction": 80}	1
129	한서윤	39	30-39	Female	대구광역시	35.875623	128.637349	대학원 졸	700만원 이상	주부	다세대 가구	35	보수 성향 무당층	56	{"economy": 26, "housing": 6, "welfare": 5, "security": 21, "environment": 8}	포털 뉴스	{성장,환경,안정}	대구광역시에 거주하는 30-39 주부. 정치 성향은 보수이며 성장, 환경, 안정 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 63, "ecoConsciousness": 69, "priceSensitivity": 60, "digitalConsumption": 72}	{"taxTolerance": 65, "governmentTrust": 59, "policyAcceptance": 61, "regulationPreference": 58, "publicServiceSatisfaction": 55}	1
130	송영수	34	30-39	Female	대구광역시	35.807498	128.521228	대학교 졸	350-500만원	생산직	부부 가구	32	보수 성향 무당층	35	{"economy": 21, "housing": -2, "welfare": -16, "security": 33, "environment": -3}	유튜브	{전통,안전,다양성}	대구광역시에 거주하는 30-39 생산직. 정치 성향은 중도이며 전통, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 64, "ecoConsciousness": 52, "priceSensitivity": 74, "digitalConsumption": 81}	{"taxTolerance": 65, "governmentTrust": 41, "policyAcceptance": 66, "regulationPreference": 76, "publicServiceSatisfaction": 67}	1
131	전경숙	30	30-39	Male	대구광역시	35.932201	128.659814	대학원 졸	350-500만원	프리랜서	1인 가구	-12	중도 무당층	59	{"economy": -12, "housing": 3, "welfare": 32, "security": -22, "environment": 35}	지상파/종편 뉴스	{안전,혁신,자유}	대구광역시에 거주하는 30-39 프리랜서. 정치 성향은 중도이며 안전, 혁신, 자유 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 80, "ecoConsciousness": 54, "priceSensitivity": 59, "digitalConsumption": 80}	{"taxTolerance": 49, "governmentTrust": 40, "policyAcceptance": 41, "regulationPreference": 63, "publicServiceSatisfaction": 62}	1
132	박준서	31	30-39	Male	대구광역시	35.933967	128.502988	대학원 졸	200-350만원	학생	다세대 가구	29	보수 성향 무당층	54	{"economy": 40, "housing": -6, "welfare": -2, "security": 14, "environment": 15}	포털 뉴스	{환경,자유,안전}	대구광역시에 거주하는 30-39 학생. 정치 성향은 중도이며 환경, 자유, 안전 가치를 중시한다.	{"brandLoyalty": 70, "noveltySeeking": 69, "ecoConsciousness": 56, "priceSensitivity": 77, "digitalConsumption": 79}	{"taxTolerance": 68, "governmentTrust": 52, "policyAcceptance": 44, "regulationPreference": 56, "publicServiceSatisfaction": 59}	1
133	임은우	49	40-49	Female	대구광역시	35.950068	128.503057	대학교 졸	700만원 이상	은퇴	다세대 가구	55	보수 정당 지지	59	{"economy": 22, "housing": 6, "welfare": -16, "security": 46, "environment": -32}	유튜브	{성장,다양성,자유}	대구광역시에 거주하는 40-49 은퇴. 정치 성향은 보수이며 성장, 다양성, 자유 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 81, "ecoConsciousness": 53, "priceSensitivity": 44, "digitalConsumption": 73}	{"taxTolerance": 55, "governmentTrust": 37, "policyAcceptance": 59, "regulationPreference": 58, "publicServiceSatisfaction": 54}	1
134	신민준	46	40-49	Female	대구광역시	35.942367	128.679935	대학원 졸	500-700만원	전문직	자녀 양육 가구	18	보수 성향 무당층	63	{"economy": -3, "housing": 9, "welfare": 4, "security": 7, "environment": 18}	지상파/종편 뉴스	{다양성,전통,공동체}	대구광역시에 거주하는 40-49 전문직. 정치 성향은 중도이며 다양성, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 75, "ecoConsciousness": 62, "priceSensitivity": 48, "digitalConsumption": 63}	{"taxTolerance": 46, "governmentTrust": 61, "policyAcceptance": 52, "regulationPreference": 51, "publicServiceSatisfaction": 76}	1
135	강정희	41	40-49	Male	대구광역시	35.946292	128.527737	전문대 졸	350-500만원	전문직	자녀 양육 가구	1	중도 무당층	53	{"economy": -14, "housing": 54, "welfare": 21, "security": 24, "environment": -5}	유튜브	{자유,성장,전통}	대구광역시에 거주하는 40-49 전문직. 정치 성향은 중도이며 자유, 성장, 전통 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 67, "ecoConsciousness": 46, "priceSensitivity": 51, "digitalConsumption": 71}	{"taxTolerance": 49, "governmentTrust": 42, "policyAcceptance": 36, "regulationPreference": 57, "publicServiceSatisfaction": 56}	1
136	임주원	45	40-49	Male	대구광역시	35.914667	128.594283	전문대 졸	200-350만원	학생	부부 가구	31	보수 성향 무당층	66	{"economy": 11, "housing": 21, "welfare": 16, "security": 28, "environment": -24}	SNS	{공정,성장,안정}	대구광역시에 거주하는 40-49 학생. 정치 성향은 중도이며 공정, 성장, 안정 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 72, "ecoConsciousness": 51, "priceSensitivity": 71, "digitalConsumption": 78}	{"taxTolerance": 37, "governmentTrust": 41, "policyAcceptance": 64, "regulationPreference": 58, "publicServiceSatisfaction": 80}	1
137	권수아	53	50-59	Female	대구광역시	35.82304	128.64003	고졸 이하	500-700만원	서비스직	부부 가구	80	보수 정당 지지	66	{"economy": 52, "housing": -25, "welfare": -38, "security": 57, "environment": -4}	지상파/종편 뉴스	{환경,공동체,다양성}	대구광역시에 거주하는 50-59 서비스직. 정치 성향은 보수이며 환경, 공동체, 다양성 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 52, "ecoConsciousness": 47, "priceSensitivity": 70, "digitalConsumption": 71}	{"taxTolerance": 14, "governmentTrust": 47, "policyAcceptance": 60, "regulationPreference": 61, "publicServiceSatisfaction": 54}	1
138	장지민	53	50-59	Female	대구광역시	35.873375	128.562355	대학교 졸	700만원 이상	전문직	다세대 가구	19	보수 성향 무당층	63	{"economy": -17, "housing": 8, "welfare": -3, "security": -3, "environment": -1}	포털 뉴스	{혁신,자유,공동체}	대구광역시에 거주하는 50-59 전문직. 정치 성향은 중도이며 혁신, 자유, 공동체 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 79, "ecoConsciousness": 47, "priceSensitivity": 39, "digitalConsumption": 62}	{"taxTolerance": 35, "governmentTrust": 57, "policyAcceptance": 53, "regulationPreference": 62, "publicServiceSatisfaction": 73}	1
139	류서윤	59	50-59	Male	대구광역시	35.915475	128.550196	대학교 졸	350-500만원	전문직	다세대 가구	54	보수 정당 지지	61	{"economy": 5, "housing": 9, "welfare": -3, "security": 42, "environment": -1}	지상파/종편 뉴스	{공동체,환경,자유}	대구광역시에 거주하는 50-59 전문직. 정치 성향은 보수이며 공동체, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 70, "ecoConsciousness": 54, "priceSensitivity": 55, "digitalConsumption": 48}	{"taxTolerance": 57, "governmentTrust": 49, "policyAcceptance": 35, "regulationPreference": 70, "publicServiceSatisfaction": 75}	1
140	권지우	53	50-59	Male	대구광역시	35.891471	128.587761	고졸 이하	500-700만원	학생	다세대 가구	57	보수 정당 지지	91	{"economy": 33, "housing": -3, "welfare": -4, "security": 37, "environment": -11}	신문/팟캐스트	{전통,성장,공동체}	대구광역시에 거주하는 50-59 학생. 정치 성향은 보수이며 전통, 성장, 공동체 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 50, "ecoConsciousness": 35, "priceSensitivity": 54, "digitalConsumption": 87}	{"taxTolerance": 29, "governmentTrust": 65, "policyAcceptance": 48, "regulationPreference": 74, "publicServiceSatisfaction": 70}	1
141	류준서	60	60-69	Female	대구광역시	35.80426	128.542512	전문대 졸	500-700만원	생산직	1인 가구	32	보수 성향 무당층	86	{"economy": 17, "housing": 43, "welfare": -1, "security": 41, "environment": 23}	신문/팟캐스트	{공정,안정,성장}	대구광역시에 거주하는 60-69 생산직. 정치 성향은 중도이며 공정, 안정, 성장 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 49, "ecoConsciousness": 44, "priceSensitivity": 49, "digitalConsumption": 58}	{"taxTolerance": 29, "governmentTrust": 49, "policyAcceptance": 57, "regulationPreference": 83, "publicServiceSatisfaction": 60}	1
142	최은우	68	60-69	Female	대구광역시	35.826051	128.651084	대학교 졸	700만원 이상	은퇴	자녀 양육 가구	64	보수 정당 지지	69	{"economy": 36, "housing": 4, "welfare": -7, "security": 52, "environment": 12}	지상파/종편 뉴스	{성장,안전,자유}	대구광역시에 거주하는 60-69 은퇴. 정치 성향은 보수이며 성장, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 49, "ecoConsciousness": 51, "priceSensitivity": 65, "digitalConsumption": 49}	{"taxTolerance": 66, "governmentTrust": 62, "policyAcceptance": 60, "regulationPreference": 70, "publicServiceSatisfaction": 59}	1
143	박은우	66	60-69	Male	대구광역시	35.882123	128.620484	전문대 졸	350-500만원	주부	다세대 가구	55	보수 정당 지지	72	{"economy": 56, "housing": 21, "welfare": -22, "security": 47, "environment": 17}	신문/팟캐스트	{전통,혁신,공정}	대구광역시에 거주하는 60-69 주부. 정치 성향은 보수이며 전통, 혁신, 공정 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 46, "ecoConsciousness": 49, "priceSensitivity": 60, "digitalConsumption": 71}	{"taxTolerance": 56, "governmentTrust": 36, "policyAcceptance": 45, "regulationPreference": 59, "publicServiceSatisfaction": 57}	1
144	안성호	61	60-69	Male	대구광역시	35.874008	128.550757	고졸 이하	700만원 이상	전문직	자녀 양육 가구	42	보수 성향 무당층	83	{"economy": 62, "housing": -2, "welfare": -16, "security": 50, "environment": -2}	유튜브	{성장,환경,공정}	대구광역시에 거주하는 60-69 전문직. 정치 성향은 보수이며 성장, 환경, 공정 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 60, "ecoConsciousness": 40, "priceSensitivity": 28, "digitalConsumption": 73}	{"taxTolerance": 47, "governmentTrust": 39, "policyAcceptance": 77, "regulationPreference": 53, "publicServiceSatisfaction": 71}	1
145	한경숙	78	70+	Female	대구광역시	35.887167	128.625375	고졸 이하	350-500만원	은퇴	1인 가구	76	보수 정당 지지	69	{"economy": 48, "housing": -25, "welfare": -15, "security": 39, "environment": -7}	지상파/종편 뉴스	{혁신,자유,성장}	대구광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 혁신, 자유, 성장 가치를 중시한다.	{"brandLoyalty": 79, "noveltySeeking": 57, "ecoConsciousness": 31, "priceSensitivity": 64, "digitalConsumption": 56}	{"taxTolerance": 46, "governmentTrust": 49, "policyAcceptance": 53, "regulationPreference": 50, "publicServiceSatisfaction": 62}	1
146	류민서	80	70+	Female	대구광역시	35.84639	128.66736	대학교 졸	200만원 미만	은퇴	1인 가구	64	보수 정당 지지	72	{"economy": 36, "housing": -11, "welfare": -3, "security": 28, "environment": -4}	포털 뉴스	{안전,공정,성장}	대구광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안전, 공정, 성장 가치를 중시한다.	{"brandLoyalty": 63, "noveltySeeking": 48, "ecoConsciousness": 41, "priceSensitivity": 94, "digitalConsumption": 49}	{"taxTolerance": 26, "governmentTrust": 55, "policyAcceptance": 43, "regulationPreference": 82, "publicServiceSatisfaction": 66}	1
147	류예준	77	70+	Male	대구광역시	35.792553	128.637739	전문대 졸	200만원 미만	은퇴	1인 가구	83	보수 정당 지지	92	{"economy": 54, "housing": -27, "welfare": -43, "security": 83, "environment": -33}	지상파/종편 뉴스	{환경,안정,다양성}	대구광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 환경, 안정, 다양성 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 60, "ecoConsciousness": 56, "priceSensitivity": 80, "digitalConsumption": 68}	{"taxTolerance": 36, "governmentTrust": 56, "policyAcceptance": 61, "regulationPreference": 68, "publicServiceSatisfaction": 80}	1
148	박지민	71	70+	Male	대구광역시	35.926939	128.515834	대학원 졸	200-350만원	은퇴	자녀 양육 가구	19	보수 성향 무당층	92	{"economy": 16, "housing": 26, "welfare": 29, "security": 39, "environment": 19}	SNS	{전통,안정,안전}	대구광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 전통, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 60, "ecoConsciousness": 40, "priceSensitivity": 74, "digitalConsumption": 62}	{"taxTolerance": 42, "governmentTrust": 41, "policyAcceptance": 45, "regulationPreference": 56, "publicServiceSatisfaction": 72}	1
149	오유준	22	18-29	Female	인천광역시	37.383318	126.689196	대학교 졸	350-500만원	학생	다세대 가구	1	중도 무당층	28	{"economy": 7, "housing": -3, "welfare": 37, "security": -6, "environment": 11}	포털 뉴스	{환경,전통,안정}	인천광역시에 거주하는 18-29 학생. 정치 성향은 중도이며 환경, 전통, 안정 가치를 중시한다.	{"brandLoyalty": 11, "noveltySeeking": 78, "ecoConsciousness": 61, "priceSensitivity": 65, "digitalConsumption": 83}	{"taxTolerance": 30, "governmentTrust": 31, "policyAcceptance": 45, "regulationPreference": 44, "publicServiceSatisfaction": 66}	1
150	송지민	23	18-29	Female	인천광역시	37.38336	126.633378	대학원 졸	200-350만원	학생	다세대 가구	-24	진보 성향 무당층	56	{"economy": -32, "housing": 58, "welfare": 8, "security": -42, "environment": 37}	신문/팟캐스트	{공동체,자유,안전}	인천광역시에 거주하는 18-29 학생. 정치 성향은 중도이며 공동체, 자유, 안전 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 82, "ecoConsciousness": 61, "priceSensitivity": 59, "digitalConsumption": 96}	{"taxTolerance": 54, "governmentTrust": 43, "policyAcceptance": 37, "regulationPreference": 64, "publicServiceSatisfaction": 78}	1
151	조은우	20	18-29	Male	인천광역시	37.382595	126.728453	대학원 졸	200만원 미만	학생	1인 가구	-30	진보 성향 무당층	59	{"economy": -22, "housing": 23, "welfare": 27, "security": -18, "environment": 52}	SNS	{안정,전통,성장}	인천광역시에 거주하는 18-29 학생. 정치 성향은 중도이며 안정, 전통, 성장 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 77, "ecoConsciousness": 69, "priceSensitivity": 74, "digitalConsumption": 99}	{"taxTolerance": 52, "governmentTrust": 45, "policyAcceptance": 63, "regulationPreference": 55, "publicServiceSatisfaction": 75}	1
152	권영수	21	18-29	Male	인천광역시	37.493112	126.728095	전문대 졸	200-350만원	학생	1인 가구	-28	진보 성향 무당층	38	{"economy": -49, "housing": 37, "welfare": 36, "security": 4, "environment": 25}	지상파/종편 뉴스	{환경,자유,안정}	인천광역시에 거주하는 18-29 학생. 정치 성향은 중도이며 환경, 자유, 안정 가치를 중시한다.	{"brandLoyalty": 11, "noveltySeeking": 96, "ecoConsciousness": 47, "priceSensitivity": 64, "digitalConsumption": 75}	{"taxTolerance": 38, "governmentTrust": 50, "policyAcceptance": 44, "regulationPreference": 62, "publicServiceSatisfaction": 55}	1
153	전유준	33	30-39	Female	인천광역시	37.380096	126.7042	대학교 졸	350-500만원	사무직	1인 가구	-52	진보 정당 지지	41	{"economy": -61, "housing": 54, "welfare": 55, "security": -27, "environment": 44}	포털 뉴스	{성장,안정,전통}	인천광역시에 거주하는 30-39 사무직. 정치 성향은 진보이며 성장, 안정, 전통 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 75, "ecoConsciousness": 56, "priceSensitivity": 61, "digitalConsumption": 77}	{"taxTolerance": 47, "governmentTrust": 50, "policyAcceptance": 42, "regulationPreference": 64, "publicServiceSatisfaction": 61}	1
154	조지호	39	30-39	Female	인천광역시	37.424125	126.802358	대학교 졸	500-700만원	프리랜서	1인 가구	11	중도 무당층	50	{"economy": -15, "housing": 36, "welfare": -6, "security": 5, "environment": 5}	SNS	{다양성,자유,전통}	인천광역시에 거주하는 30-39 프리랜서. 정치 성향은 중도이며 다양성, 자유, 전통 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 79, "ecoConsciousness": 63, "priceSensitivity": 45, "digitalConsumption": 84}	{"taxTolerance": 45, "governmentTrust": 45, "policyAcceptance": 49, "regulationPreference": 55, "publicServiceSatisfaction": 60}	1
155	황광수	36	30-39	Male	인천광역시	37.474423	126.680291	대학교 졸	700만원 이상	서비스직	자녀 양육 가구	-18	진보 성향 무당층	63	{"economy": -3, "housing": 24, "welfare": -10, "security": -7, "environment": -5}	유튜브	{성장,혁신,전통}	인천광역시에 거주하는 30-39 서비스직. 정치 성향은 중도이며 성장, 혁신, 전통 가치를 중시한다.	{"brandLoyalty": 20, "noveltySeeking": 61, "ecoConsciousness": 47, "priceSensitivity": 59, "digitalConsumption": 89}	{"taxTolerance": 50, "governmentTrust": 40, "policyAcceptance": 52, "regulationPreference": 71, "publicServiceSatisfaction": 50}	1
156	최영수	36	30-39	Male	인천광역시	37.386868	126.632056	대학원 졸	350-500만원	주부	자녀 양육 가구	-28	진보 성향 무당층	63	{"economy": -22, "housing": 37, "welfare": 17, "security": -13, "environment": 23}	지상파/종편 뉴스	{공동체,환경,전통}	인천광역시에 거주하는 30-39 주부. 정치 성향은 중도이며 공동체, 환경, 전통 가치를 중시한다.	{"brandLoyalty": 26, "noveltySeeking": 80, "ecoConsciousness": 64, "priceSensitivity": 63, "digitalConsumption": 86}	{"taxTolerance": 50, "governmentTrust": 62, "policyAcceptance": 46, "regulationPreference": 55, "publicServiceSatisfaction": 51}	1
157	류건우	41	40-49	Female	인천광역시	37.440807	126.690483	대학원 졸	350-500만원	사무직	1인 가구	19	보수 성향 무당층	88	{"economy": -2, "housing": 32, "welfare": 10, "security": 12, "environment": 8}	유튜브	{안전,전통,자유}	인천광역시에 거주하는 40-49 사무직. 정치 성향은 중도이며 안전, 전통, 자유 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 59, "ecoConsciousness": 49, "priceSensitivity": 66, "digitalConsumption": 84}	{"taxTolerance": 39, "governmentTrust": 52, "policyAcceptance": 43, "regulationPreference": 61, "publicServiceSatisfaction": 62}	1
158	정현우	49	40-49	Female	인천광역시	37.38831	126.634746	대학원 졸	700만원 이상	자영업	자녀 양육 가구	-15	진보 성향 무당층	64	{"economy": 2, "housing": 13, "welfare": 22, "security": -12, "environment": 22}	유튜브	{공정,전통,성장}	인천광역시에 거주하는 40-49 자영업. 정치 성향은 중도이며 공정, 전통, 성장 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 71, "ecoConsciousness": 55, "priceSensitivity": 41, "digitalConsumption": 85}	{"taxTolerance": 54, "governmentTrust": 44, "policyAcceptance": 45, "regulationPreference": 61, "publicServiceSatisfaction": 62}	1
159	김수아	45	40-49	Female	인천광역시	37.437154	126.776454	고졸 이하	700만원 이상	생산직	부부 가구	-8	중도 무당층	54	{"economy": -10, "housing": -4, "welfare": -5, "security": 15, "environment": 41}	유튜브	{전통,안전,자유}	인천광역시에 거주하는 40-49 생산직. 정치 성향은 중도이며 전통, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 37, "ecoConsciousness": 30, "priceSensitivity": 45, "digitalConsumption": 56}	{"taxTolerance": 38, "governmentTrust": 48, "policyAcceptance": 56, "regulationPreference": 56, "publicServiceSatisfaction": 85}	1
160	송민서	47	40-49	Male	인천광역시	37.420218	126.747733	대학원 졸	500-700만원	전문직	다세대 가구	25	보수 성향 무당층	51	{"economy": 0, "housing": 25, "welfare": -32, "security": 4, "environment": 19}	유튜브	{성장,공정,전통}	인천광역시에 거주하는 40-49 전문직. 정치 성향은 중도이며 성장, 공정, 전통 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 60, "ecoConsciousness": 48, "priceSensitivity": 41, "digitalConsumption": 61}	{"taxTolerance": 53, "governmentTrust": 49, "policyAcceptance": 73, "regulationPreference": 57, "publicServiceSatisfaction": 47}	1
161	조경숙	42	40-49	Male	인천광역시	37.420676	126.63431	대학원 졸	700만원 이상	프리랜서	자녀 양육 가구	0	중도 무당층	55	{"economy": -1, "housing": 30, "welfare": 27, "security": 8, "environment": 31}	유튜브	{성장,공동체,자유}	인천광역시에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 성장, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 61, "ecoConsciousness": 54, "priceSensitivity": 43, "digitalConsumption": 78}	{"taxTolerance": 55, "governmentTrust": 44, "policyAcceptance": 56, "regulationPreference": 77, "publicServiceSatisfaction": 75}	1
162	김혜진	40	40-49	Male	인천광역시	37.510262	126.787083	대학원 졸	500-700만원	프리랜서	다세대 가구	-25	진보 성향 무당층	57	{"economy": 9, "housing": 19, "welfare": 21, "security": 18, "environment": 12}	SNS	{자유,환경,안정}	인천광역시에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 자유, 환경, 안정 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 68, "ecoConsciousness": 58, "priceSensitivity": 36, "digitalConsumption": 85}	{"taxTolerance": 53, "governmentTrust": 33, "policyAcceptance": 49, "regulationPreference": 51, "publicServiceSatisfaction": 72}	1
163	전지아	50	50-59	Female	인천광역시	37.53478	126.662355	전문대 졸	350-500만원	학생	다세대 가구	35	보수 성향 무당층	60	{"economy": 14, "housing": 9, "welfare": -16, "security": 11, "environment": 0}	신문/팟캐스트	{공동체,안전,자유}	인천광역시에 거주하는 50-59 학생. 정치 성향은 보수이며 공동체, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 49, "ecoConsciousness": 42, "priceSensitivity": 66, "digitalConsumption": 58}	{"taxTolerance": 41, "governmentTrust": 58, "policyAcceptance": 48, "regulationPreference": 64, "publicServiceSatisfaction": 73}	1
164	장다은	53	50-59	Female	인천광역시	37.445925	126.78111	전문대 졸	350-500만원	서비스직	자녀 양육 가구	15	보수 성향 무당층	75	{"economy": -5, "housing": 1, "welfare": -7, "security": 12, "environment": 22}	포털 뉴스	{안정,안전,공동체}	인천광역시에 거주하는 50-59 서비스직. 정치 성향은 중도이며 안정, 안전, 공동체 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 58, "ecoConsciousness": 58, "priceSensitivity": 49, "digitalConsumption": 63}	{"taxTolerance": 54, "governmentTrust": 35, "policyAcceptance": 68, "regulationPreference": 61, "publicServiceSatisfaction": 62}	1
165	임다은	53	50-59	Female	인천광역시	37.533457	126.609775	대학교 졸	700만원 이상	사무직	자녀 양육 가구	43	보수 성향 무당층	64	{"economy": 29, "housing": -1, "welfare": -49, "security": 13, "environment": 5}	유튜브	{안정,환경,안전}	인천광역시에 거주하는 50-59 사무직. 정치 성향은 보수이며 안정, 환경, 안전 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 73, "ecoConsciousness": 39, "priceSensitivity": 45, "digitalConsumption": 94}	{"taxTolerance": 42, "governmentTrust": 32, "policyAcceptance": 44, "regulationPreference": 52, "publicServiceSatisfaction": 80}	1
166	박지우	58	50-59	Male	인천광역시	37.490738	126.764229	전문대 졸	700만원 이상	생산직	부부 가구	-4	중도 무당층	83	{"economy": -16, "housing": 3, "welfare": 11, "security": -1, "environment": 1}	유튜브	{자유,성장,공정}	인천광역시에 거주하는 50-59 생산직. 정치 성향은 중도이며 자유, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 56, "ecoConsciousness": 55, "priceSensitivity": 70, "digitalConsumption": 79}	{"taxTolerance": 57, "governmentTrust": 38, "policyAcceptance": 29, "regulationPreference": 67, "publicServiceSatisfaction": 63}	1
167	안주원	52	50-59	Male	인천광역시	37.520336	126.784883	전문대 졸	500-700만원	생산직	다세대 가구	32	보수 성향 무당층	54	{"economy": 20, "housing": 13, "welfare": 21, "security": 37, "environment": 21}	신문/팟캐스트	{공동체,혁신,공정}	인천광역시에 거주하는 50-59 생산직. 정치 성향은 중도이며 공동체, 혁신, 공정 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 64, "ecoConsciousness": 45, "priceSensitivity": 55, "digitalConsumption": 80}	{"taxTolerance": 51, "governmentTrust": 49, "policyAcceptance": 38, "regulationPreference": 60, "publicServiceSatisfaction": 58}	1
168	송지민	53	50-59	Male	인천광역시	37.411059	126.750771	대학교 졸	700만원 이상	공무원	1인 가구	22	보수 성향 무당층	80	{"economy": 1, "housing": 0, "welfare": -18, "security": -4, "environment": 68}	지상파/종편 뉴스	{안전,공동체,자유}	인천광역시에 거주하는 50-59 공무원. 정치 성향은 중도이며 안전, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 70, "ecoConsciousness": 64, "priceSensitivity": 63, "digitalConsumption": 100}	{"taxTolerance": 59, "governmentTrust": 47, "policyAcceptance": 50, "regulationPreference": 51, "publicServiceSatisfaction": 65}	1
169	황서연	67	60-69	Female	인천광역시	37.508299	126.71383	대학교 졸	200-350만원	은퇴	부부 가구	15	보수 성향 무당층	92	{"economy": 3, "housing": 37, "welfare": -15, "security": 28, "environment": 27}	SNS	{안정,혁신,전통}	인천광역시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 안정, 혁신, 전통 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 58, "ecoConsciousness": 67, "priceSensitivity": 79, "digitalConsumption": 61}	{"taxTolerance": 40, "governmentTrust": 39, "policyAcceptance": 46, "regulationPreference": 69, "publicServiceSatisfaction": 55}	1
170	정광수	64	60-69	Female	인천광역시	37.430532	126.662449	대학원 졸	350-500만원	프리랜서	부부 가구	3	중도 무당층	73	{"economy": -16, "housing": 1, "welfare": 58, "security": -11, "environment": 19}	유튜브	{자유,전통,안전}	인천광역시에 거주하는 60-69 프리랜서. 정치 성향은 중도이며 자유, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 45, "ecoConsciousness": 72, "priceSensitivity": 61, "digitalConsumption": 47}	{"taxTolerance": 41, "governmentTrust": 53, "policyAcceptance": 50, "regulationPreference": 72, "publicServiceSatisfaction": 59}	1
171	홍성호	67	60-69	Female	인천광역시	37.440237	126.794545	대학교 졸	500-700만원	은퇴	다세대 가구	45	보수 정당 지지	99	{"economy": 35, "housing": -8, "welfare": -10, "security": 27, "environment": 20}	SNS	{안정,혁신,공정}	인천광역시에 거주하는 60-69 은퇴. 정치 성향은 보수이며 안정, 혁신, 공정 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 51, "ecoConsciousness": 58, "priceSensitivity": 45, "digitalConsumption": 57}	{"taxTolerance": 27, "governmentTrust": 65, "policyAcceptance": 42, "regulationPreference": 67, "publicServiceSatisfaction": 47}	1
172	윤건우	63	60-69	Male	인천광역시	37.428301	126.627867	대학원 졸	200-350만원	프리랜서	자녀 양육 가구	-1	중도 무당층	85	{"economy": -7, "housing": 5, "welfare": 0, "security": 2, "environment": 20}	유튜브	{성장,안정,자유}	인천광역시에 거주하는 60-69 프리랜서. 정치 성향은 중도이며 성장, 안정, 자유 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 53, "ecoConsciousness": 26, "priceSensitivity": 60, "digitalConsumption": 76}	{"taxTolerance": 58, "governmentTrust": 43, "policyAcceptance": 27, "regulationPreference": 78, "publicServiceSatisfaction": 59}	1
173	박민서	67	60-69	Male	인천광역시	37.396418	126.623544	대학원 졸	500-700만원	은퇴	자녀 양육 가구	12	중도 무당층	59	{"economy": 6, "housing": 30, "welfare": 2, "security": 34, "environment": 25}	신문/팟캐스트	{전통,공동체,다양성}	인천광역시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 전통, 공동체, 다양성 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 46, "ecoConsciousness": 52, "priceSensitivity": 53, "digitalConsumption": 62}	{"taxTolerance": 68, "governmentTrust": 59, "policyAcceptance": 46, "regulationPreference": 80, "publicServiceSatisfaction": 59}	1
174	전광수	77	70+	Female	인천광역시	37.506124	126.732888	전문대 졸	500-700만원	은퇴	1인 가구	8	중도 무당층	81	{"economy": -3, "housing": 34, "welfare": 20, "security": -2, "environment": 51}	SNS	{자유,공정,환경}	인천광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 자유, 공정, 환경 가치를 중시한다.	{"brandLoyalty": 64, "noveltySeeking": 42, "ecoConsciousness": 38, "priceSensitivity": 32, "digitalConsumption": 51}	{"taxTolerance": 61, "governmentTrust": 62, "policyAcceptance": 60, "regulationPreference": 72, "publicServiceSatisfaction": 40}	1
175	전유준	70	70+	Female	인천광역시	37.52893	126.76865	고졸 이하	200-350만원	은퇴	부부 가구	33	보수 성향 무당층	70	{"economy": -1, "housing": -10, "welfare": -6, "security": 41, "environment": -17}	신문/팟캐스트	{자유,공정,성장}	인천광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 자유, 공정, 성장 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 51, "ecoConsciousness": 54, "priceSensitivity": 84, "digitalConsumption": 70}	{"taxTolerance": 38, "governmentTrust": 50, "policyAcceptance": 69, "regulationPreference": 66, "publicServiceSatisfaction": 50}	1
176	최지호	82	70+	Male	인천광역시	37.471406	126.696055	대학원 졸	200-350만원	은퇴	부부 가구	11	중도 무당층	59	{"economy": -12, "housing": -1, "welfare": 6, "security": -2, "environment": 3}	포털 뉴스	{성장,공정,전통}	인천광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 성장, 공정, 전통 가치를 중시한다.	{"brandLoyalty": 74, "noveltySeeking": 55, "ecoConsciousness": 49, "priceSensitivity": 77, "digitalConsumption": 84}	{"taxTolerance": 53, "governmentTrust": 30, "policyAcceptance": 51, "regulationPreference": 62, "publicServiceSatisfaction": 71}	1
177	윤다은	81	70+	Male	인천광역시	37.428944	126.631549	대학원 졸	200-350만원	은퇴	1인 가구	58	보수 정당 지지	91	{"economy": 19, "housing": 11, "welfare": -19, "security": 3, "environment": -11}	유튜브	{공동체,혁신,안정}	인천광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 공동체, 혁신, 안정 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 60, "ecoConsciousness": 62, "priceSensitivity": 82, "digitalConsumption": 37}	{"taxTolerance": 39, "governmentTrust": 44, "policyAcceptance": 42, "regulationPreference": 64, "publicServiceSatisfaction": 55}	1
178	한영수	18	18-29	Female	광주광역시	35.148934	126.835791	대학원 졸	200만원 미만	사무직	1인 가구	-78	진보 정당 지지	38	{"economy": -46, "housing": 51, "welfare": 54, "security": -55, "environment": 28}	지상파/종편 뉴스	{공정,안정,다양성}	광주광역시에 거주하는 18-29 사무직. 정치 성향은 진보이며 공정, 안정, 다양성 가치를 중시한다.	{"brandLoyalty": 19, "noveltySeeking": 91, "ecoConsciousness": 71, "priceSensitivity": 82, "digitalConsumption": 100}	{"taxTolerance": 52, "governmentTrust": 61, "policyAcceptance": 30, "regulationPreference": 57, "publicServiceSatisfaction": 61}	1
179	조다은	20	18-29	Male	광주광역시	35.144089	126.908983	대학교 졸	200만원 미만	학생	1인 가구	-21	진보 성향 무당층	50	{"economy": -21, "housing": 3, "welfare": 25, "security": -38, "environment": 21}	유튜브	{전통,공정,안전}	광주광역시에 거주하는 18-29 학생. 정치 성향은 중도이며 전통, 공정, 안전 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 72, "ecoConsciousness": 61, "priceSensitivity": 70, "digitalConsumption": 93}	{"taxTolerance": 59, "governmentTrust": 53, "policyAcceptance": 40, "regulationPreference": 68, "publicServiceSatisfaction": 62}	1
180	류다은	37	30-39	Female	광주광역시	35.080337	126.923302	대학교 졸	350-500만원	프리랜서	1인 가구	-62	진보 정당 지지	60	{"economy": -33, "housing": -15, "welfare": 44, "security": -20, "environment": 47}	유튜브	{공정,성장,혁신}	광주광역시에 거주하는 30-39 프리랜서. 정치 성향은 진보이며 공정, 성장, 혁신 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 76, "ecoConsciousness": 53, "priceSensitivity": 35, "digitalConsumption": 60}	{"taxTolerance": 65, "governmentTrust": 58, "policyAcceptance": 36, "regulationPreference": 64, "publicServiceSatisfaction": 78}	1
181	류경숙	36	30-39	Male	광주광역시	35.105809	126.93804	대학교 졸	350-500만원	주부	자녀 양육 가구	-12	중도 무당층	55	{"economy": -20, "housing": -9, "welfare": 15, "security": 16, "environment": 8}	신문/팟캐스트	{전통,성장,자유}	광주광역시에 거주하는 30-39 주부. 정치 성향은 중도이며 전통, 성장, 자유 가치를 중시한다.	{"brandLoyalty": 23, "noveltySeeking": 89, "ecoConsciousness": 64, "priceSensitivity": 66, "digitalConsumption": 80}	{"taxTolerance": 54, "governmentTrust": 48, "policyAcceptance": 48, "regulationPreference": 61, "publicServiceSatisfaction": 54}	1
182	서은우	48	40-49	Female	광주광역시	35.130574	126.767232	전문대 졸	200-350만원	전문직	자녀 양육 가구	-23	진보 성향 무당층	78	{"economy": -37, "housing": 27, "welfare": 37, "security": -21, "environment": 22}	SNS	{다양성,환경,자유}	광주광역시에 거주하는 40-49 전문직. 정치 성향은 중도이며 다양성, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 79, "ecoConsciousness": 42, "priceSensitivity": 64, "digitalConsumption": 77}	{"taxTolerance": 43, "governmentTrust": 38, "policyAcceptance": 48, "regulationPreference": 55, "publicServiceSatisfaction": 41}	1
183	정채원	46	40-49	Male	광주광역시	35.171981	126.937944	전문대 졸	700만원 이상	생산직	1인 가구	-63	진보 정당 지지	71	{"economy": -18, "housing": 30, "welfare": 59, "security": -57, "environment": 49}	SNS	{성장,혁신,안정}	광주광역시에 거주하는 40-49 생산직. 정치 성향은 진보이며 성장, 혁신, 안정 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 33, "ecoConsciousness": 53, "priceSensitivity": 54, "digitalConsumption": 84}	{"taxTolerance": 33, "governmentTrust": 47, "policyAcceptance": 40, "regulationPreference": 56, "publicServiceSatisfaction": 55}	1
184	박성호	58	50-59	Female	광주광역시	35.165512	126.875226	대학원 졸	350-500만원	은퇴	자녀 양육 가구	-17	진보 성향 무당층	79	{"economy": -2, "housing": 8, "welfare": 30, "security": -32, "environment": 31}	유튜브	{공동체,성장,공정}	광주광역시에 거주하는 50-59 은퇴. 정치 성향은 중도이며 공동체, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 47, "ecoConsciousness": 67, "priceSensitivity": 63, "digitalConsumption": 72}	{"taxTolerance": 47, "governmentTrust": 18, "policyAcceptance": 34, "regulationPreference": 79, "publicServiceSatisfaction": 49}	1
185	송동현	51	50-59	Male	광주광역시	35.169986	126.900632	대학교 졸	700만원 이상	자영업	다세대 가구	-51	진보 정당 지지	65	{"economy": -22, "housing": 34, "welfare": 11, "security": -41, "environment": 48}	신문/팟캐스트	{공정,공동체,자유}	광주광역시에 거주하는 50-59 자영업. 정치 성향은 진보이며 공정, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 67, "ecoConsciousness": 62, "priceSensitivity": 40, "digitalConsumption": 83}	{"taxTolerance": 67, "governmentTrust": 50, "policyAcceptance": 33, "regulationPreference": 72, "publicServiceSatisfaction": 83}	1
186	류도윤	61	60-69	Female	광주광역시	35.20098	126.810617	대학교 졸	200-350만원	사무직	자녀 양육 가구	13	중도 무당층	77	{"economy": -22, "housing": 41, "welfare": 11, "security": 2, "environment": 7}	유튜브	{공동체,공정,전통}	광주광역시에 거주하는 60-69 사무직. 정치 성향은 중도이며 공동체, 공정, 전통 가치를 중시한다.	{"brandLoyalty": 67, "noveltySeeking": 79, "ecoConsciousness": 64, "priceSensitivity": 84, "digitalConsumption": 84}	{"taxTolerance": 48, "governmentTrust": 49, "policyAcceptance": 68, "regulationPreference": 59, "publicServiceSatisfaction": 63}	1
187	정영수	68	60-69	Male	광주광역시	35.119488	126.893199	대학원 졸	200-350만원	은퇴	다세대 가구	-31	진보 성향 무당층	68	{"economy": -38, "housing": 29, "welfare": 29, "security": -8, "environment": 43}	신문/팟캐스트	{혁신,다양성,자유}	광주광역시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 혁신, 다양성, 자유 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 55, "ecoConsciousness": 38, "priceSensitivity": 68, "digitalConsumption": 69}	{"taxTolerance": 36, "governmentTrust": 42, "policyAcceptance": 41, "regulationPreference": 62, "publicServiceSatisfaction": 67}	1
188	정준서	78	70+	Female	광주광역시	35.206958	126.802145	대학교 졸	200만원 미만	은퇴	다세대 가구	35	보수 성향 무당층	99	{"economy": 17, "housing": -3, "welfare": 12, "security": 15, "environment": -1}	SNS	{혁신,안정,공동체}	광주광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 혁신, 안정, 공동체 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 51, "ecoConsciousness": 41, "priceSensitivity": 55, "digitalConsumption": 61}	{"taxTolerance": 39, "governmentTrust": 43, "policyAcceptance": 32, "regulationPreference": 63, "publicServiceSatisfaction": 60}	1
189	김지민	75	70+	Male	광주광역시	35.087522	126.932324	대학교 졸	700만원 이상	은퇴	부부 가구	-16	진보 성향 무당층	82	{"economy": 1, "housing": 6, "welfare": 27, "security": 2, "environment": 24}	포털 뉴스	{안전,자유,안정}	광주광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안전, 자유, 안정 가치를 중시한다.	{"brandLoyalty": 82, "noveltySeeking": 59, "ecoConsciousness": 37, "priceSensitivity": 41, "digitalConsumption": 63}	{"taxTolerance": 40, "governmentTrust": 55, "policyAcceptance": 46, "regulationPreference": 76, "publicServiceSatisfaction": 70}	1
190	임경숙	26	18-29	Female	대전광역시	36.342508	127.433932	전문대 졸	200-350만원	공무원	자녀 양육 가구	16	보수 성향 무당층	65	{"economy": 1, "housing": 16, "welfare": 4, "security": -4, "environment": 8}	SNS	{자유,혁신,성장}	대전광역시에 거주하는 18-29 공무원. 정치 성향은 중도이며 자유, 혁신, 성장 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 59, "ecoConsciousness": 38, "priceSensitivity": 77, "digitalConsumption": 89}	{"taxTolerance": 40, "governmentTrust": 47, "policyAcceptance": 40, "regulationPreference": 70, "publicServiceSatisfaction": 52}	1
191	김지호	27	18-29	Male	대전광역시	36.314497	127.389409	대학원 졸	200-350만원	은퇴	부부 가구	3	중도 무당층	65	{"economy": 19, "housing": 39, "welfare": 16, "security": 10, "environment": 25}	신문/팟캐스트	{자유,혁신,안정}	대전광역시에 거주하는 18-29 은퇴. 정치 성향은 중도이며 자유, 혁신, 안정 가치를 중시한다.	{"brandLoyalty": 26, "noveltySeeking": 77, "ecoConsciousness": 72, "priceSensitivity": 73, "digitalConsumption": 92}	{"taxTolerance": 69, "governmentTrust": 39, "policyAcceptance": 52, "regulationPreference": 46, "publicServiceSatisfaction": 72}	1
192	임성호	37	30-39	Female	대전광역시	36.315044	127.461529	대학교 졸	700만원 이상	전문직	자녀 양육 가구	6	중도 무당층	62	{"economy": -17, "housing": 7, "welfare": 4, "security": 4, "environment": 11}	유튜브	{혁신,전통,공정}	대전광역시에 거주하는 30-39 전문직. 정치 성향은 중도이며 혁신, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 75, "ecoConsciousness": 61, "priceSensitivity": 52, "digitalConsumption": 71}	{"taxTolerance": 54, "governmentTrust": 19, "policyAcceptance": 55, "regulationPreference": 65, "publicServiceSatisfaction": 72}	1
193	윤준서	31	30-39	Male	대전광역시	36.31553	127.483574	대학원 졸	200만원 미만	은퇴	다세대 가구	-45	진보 정당 지지	39	{"economy": 0, "housing": 30, "welfare": 12, "security": -3, "environment": 22}	포털 뉴스	{자유,환경,공정}	대전광역시에 거주하는 30-39 은퇴. 정치 성향은 진보이며 자유, 환경, 공정 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 78, "ecoConsciousness": 74, "priceSensitivity": 72, "digitalConsumption": 88}	{"taxTolerance": 65, "governmentTrust": 44, "policyAcceptance": 47, "regulationPreference": 67, "publicServiceSatisfaction": 58}	1
194	황정희	49	40-49	Female	대전광역시	36.412685	127.476231	대학원 졸	700만원 이상	주부	자녀 양육 가구	-36	진보 성향 무당층	57	{"economy": -41, "housing": 37, "welfare": 8, "security": -47, "environment": 36}	포털 뉴스	{다양성,성장,공정}	대전광역시에 거주하는 40-49 주부. 정치 성향은 진보이며 다양성, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 56, "ecoConsciousness": 72, "priceSensitivity": 46, "digitalConsumption": 60}	{"taxTolerance": 62, "governmentTrust": 41, "policyAcceptance": 44, "regulationPreference": 67, "publicServiceSatisfaction": 69}	1
195	안민서	42	40-49	Male	대전광역시	36.423847	127.478931	대학교 졸	200-350만원	서비스직	1인 가구	9	중도 무당층	80	{"economy": 4, "housing": 11, "welfare": 10, "security": 16, "environment": 22}	지상파/종편 뉴스	{자유,환경,안전}	대전광역시에 거주하는 40-49 서비스직. 정치 성향은 중도이며 자유, 환경, 안전 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 47, "ecoConsciousness": 53, "priceSensitivity": 76, "digitalConsumption": 77}	{"taxTolerance": 50, "governmentTrust": 37, "policyAcceptance": 56, "regulationPreference": 64, "publicServiceSatisfaction": 68}	1
196	서서연	51	50-59	Female	대전광역시	36.393542	127.445863	대학교 졸	500-700만원	은퇴	1인 가구	-22	진보 성향 무당층	72	{"economy": -35, "housing": 41, "welfare": 32, "security": 4, "environment": 17}	유튜브	{공정,자유,성장}	대전광역시에 거주하는 50-59 은퇴. 정치 성향은 중도이며 공정, 자유, 성장 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 65, "ecoConsciousness": 56, "priceSensitivity": 47, "digitalConsumption": 88}	{"taxTolerance": 37, "governmentTrust": 49, "policyAcceptance": 40, "regulationPreference": 58, "publicServiceSatisfaction": 60}	1
197	홍동현	56	50-59	Male	대전광역시	36.284075	127.355734	고졸 이하	200만원 미만	자영업	다세대 가구	47	보수 정당 지지	67	{"economy": 9, "housing": 14, "welfare": -35, "security": 12, "environment": -19}	신문/팟캐스트	{안정,성장,공동체}	대전광역시에 거주하는 50-59 자영업. 정치 성향은 보수이며 안정, 성장, 공동체 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 55, "ecoConsciousness": 47, "priceSensitivity": 67, "digitalConsumption": 63}	{"taxTolerance": 36, "governmentTrust": 47, "policyAcceptance": 61, "regulationPreference": 55, "publicServiceSatisfaction": 65}	1
198	안건우	61	60-69	Female	대전광역시	36.419534	127.286414	대학교 졸	350-500만원	사무직	자녀 양육 가구	19	보수 성향 무당층	86	{"economy": 35, "housing": 4, "welfare": 14, "security": 12, "environment": 6}	SNS	{공정,안정,다양성}	대전광역시에 거주하는 60-69 사무직. 정치 성향은 중도이며 공정, 안정, 다양성 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 62, "ecoConsciousness": 55, "priceSensitivity": 55, "digitalConsumption": 64}	{"taxTolerance": 48, "governmentTrust": 41, "policyAcceptance": 52, "regulationPreference": 60, "publicServiceSatisfaction": 59}	1
199	강미경	64	60-69	Male	대전광역시	36.281532	127.364264	대학교 졸	200만원 미만	서비스직	부부 가구	23	보수 성향 무당층	69	{"economy": 11, "housing": 11, "welfare": 10, "security": 25, "environment": 14}	지상파/종편 뉴스	{공정,안정,전통}	대전광역시에 거주하는 60-69 서비스직. 정치 성향은 중도이며 공정, 안정, 전통 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 51, "ecoConsciousness": 38, "priceSensitivity": 100, "digitalConsumption": 44}	{"taxTolerance": 38, "governmentTrust": 55, "policyAcceptance": 48, "regulationPreference": 69, "publicServiceSatisfaction": 61}	1
200	최미경	70	70+	Female	대전광역시	36.362604	127.377418	대학교 졸	200만원 미만	은퇴	다세대 가구	19	보수 성향 무당층	66	{"economy": -17, "housing": 34, "welfare": -7, "security": 5, "environment": 2}	SNS	{자유,안전,안정}	대전광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 자유, 안전, 안정 가치를 중시한다.	{"brandLoyalty": 82, "noveltySeeking": 60, "ecoConsciousness": 55, "priceSensitivity": 74, "digitalConsumption": 71}	{"taxTolerance": 58, "governmentTrust": 43, "policyAcceptance": 59, "regulationPreference": 77, "publicServiceSatisfaction": 91}	1
201	정지민	80	70+	Male	대전광역시	36.274564	127.402833	고졸 이하	700만원 이상	은퇴	1인 가구	35	보수 성향 무당층	99	{"economy": 6, "housing": 8, "welfare": -5, "security": 24, "environment": -8}	SNS	{안전,혁신,공동체}	대전광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안전, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 60, "ecoConsciousness": 38, "priceSensitivity": 44, "digitalConsumption": 46}	{"taxTolerance": 34, "governmentTrust": 61, "policyAcceptance": 49, "regulationPreference": 67, "publicServiceSatisfaction": 60}	1
202	강다은	25	18-29	Female	울산광역시	35.583212	129.315077	대학원 졸	350-500만원	은퇴	다세대 가구	5	중도 무당층	42	{"economy": -3, "housing": 27, "welfare": 6, "security": 36, "environment": 10}	포털 뉴스	{공정,안정,공동체}	울산광역시에 거주하는 18-29 은퇴. 정치 성향은 중도이며 공정, 안정, 공동체 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 88, "ecoConsciousness": 76, "priceSensitivity": 63, "digitalConsumption": 95}	{"taxTolerance": 54, "governmentTrust": 56, "policyAcceptance": 51, "regulationPreference": 55, "publicServiceSatisfaction": 62}	1
203	홍은우	28	18-29	Male	울산광역시	35.555466	129.217191	대학교 졸	200만원 미만	사무직	부부 가구	-20	진보 성향 무당층	54	{"economy": -26, "housing": 8, "welfare": 42, "security": -17, "environment": 33}	지상파/종편 뉴스	{전통,혁신,공동체}	울산광역시에 거주하는 18-29 사무직. 정치 성향은 중도이며 전통, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 62, "ecoConsciousness": 55, "priceSensitivity": 88, "digitalConsumption": 89}	{"taxTolerance": 52, "governmentTrust": 55, "policyAcceptance": 50, "regulationPreference": 48, "publicServiceSatisfaction": 66}	1
204	임민서	30	30-39	Female	울산광역시	35.52843	129.308998	대학교 졸	500-700만원	생산직	1인 가구	-23	진보 성향 무당층	65	{"economy": -30, "housing": 14, "welfare": 49, "security": -15, "environment": 21}	유튜브	{공정,환경,성장}	울산광역시에 거주하는 30-39 생산직. 정치 성향은 중도이며 공정, 환경, 성장 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 68, "ecoConsciousness": 72, "priceSensitivity": 65, "digitalConsumption": 89}	{"taxTolerance": 35, "governmentTrust": 52, "policyAcceptance": 58, "regulationPreference": 72, "publicServiceSatisfaction": 68}	1
205	홍성호	35	30-39	Male	울산광역시	35.577937	129.390934	대학원 졸	350-500만원	은퇴	부부 가구	21	보수 성향 무당층	61	{"economy": 15, "housing": 11, "welfare": -3, "security": 32, "environment": 28}	유튜브	{다양성,전통,공동체}	울산광역시에 거주하는 30-39 은퇴. 정치 성향은 중도이며 다양성, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 67, "ecoConsciousness": 68, "priceSensitivity": 63, "digitalConsumption": 76}	{"taxTolerance": 46, "governmentTrust": 41, "policyAcceptance": 64, "regulationPreference": 51, "publicServiceSatisfaction": 73}	1
206	권채원	42	40-49	Female	울산광역시	35.509523	129.230886	고졸 이하	700만원 이상	서비스직	자녀 양육 가구	-15	진보 성향 무당층	77	{"economy": 11, "housing": 39, "welfare": 4, "security": 14, "environment": 31}	포털 뉴스	{다양성,안전,공동체}	울산광역시에 거주하는 40-49 서비스직. 정치 성향은 중도이며 다양성, 안전, 공동체 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 61, "ecoConsciousness": 36, "priceSensitivity": 35, "digitalConsumption": 76}	{"taxTolerance": 48, "governmentTrust": 42, "policyAcceptance": 32, "regulationPreference": 56, "publicServiceSatisfaction": 57}	1
207	서영수	44	40-49	Male	울산광역시	35.560715	129.215858	대학교 졸	500-700만원	사무직	자녀 양육 가구	-39	진보 성향 무당층	95	{"economy": -17, "housing": 14, "welfare": 38, "security": -24, "environment": 3}	포털 뉴스	{안정,환경,자유}	울산광역시에 거주하는 40-49 사무직. 정치 성향은 진보이며 안정, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 69, "ecoConsciousness": 57, "priceSensitivity": 60, "digitalConsumption": 65}	{"taxTolerance": 45, "governmentTrust": 44, "policyAcceptance": 59, "regulationPreference": 60, "publicServiceSatisfaction": 72}	1
208	김지민	55	50-59	Female	울산광역시	35.605477	129.244599	대학원 졸	200만원 미만	전문직	다세대 가구	9	중도 무당층	79	{"economy": -28, "housing": -7, "welfare": 14, "security": 30, "environment": 5}	지상파/종편 뉴스	{자유,환경,공동체}	울산광역시에 거주하는 50-59 전문직. 정치 성향은 중도이며 자유, 환경, 공동체 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 76, "ecoConsciousness": 54, "priceSensitivity": 73, "digitalConsumption": 77}	{"taxTolerance": 41, "governmentTrust": 31, "policyAcceptance": 47, "regulationPreference": 61, "publicServiceSatisfaction": 67}	1
209	김지우	59	50-59	Male	울산광역시	35.538655	129.362966	대학교 졸	350-500만원	사무직	자녀 양육 가구	-21	진보 성향 무당층	72	{"economy": -8, "housing": 23, "welfare": 23, "security": -7, "environment": 27}	포털 뉴스	{안정,성장,환경}	울산광역시에 거주하는 50-59 사무직. 정치 성향은 중도이며 안정, 성장, 환경 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 46, "ecoConsciousness": 54, "priceSensitivity": 62, "digitalConsumption": 76}	{"taxTolerance": 43, "governmentTrust": 47, "policyAcceptance": 39, "regulationPreference": 53, "publicServiceSatisfaction": 55}	1
210	김준서	63	60-69	Female	울산광역시	35.574045	129.277835	대학교 졸	350-500만원	프리랜서	다세대 가구	81	보수 정당 지지	84	{"economy": 44, "housing": -12, "welfare": -33, "security": 70, "environment": -17}	지상파/종편 뉴스	{공동체,다양성,안전}	울산광역시에 거주하는 60-69 프리랜서. 정치 성향은 보수이며 공동체, 다양성, 안전 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 67, "ecoConsciousness": 40, "priceSensitivity": 57, "digitalConsumption": 57}	{"taxTolerance": 51, "governmentTrust": 42, "policyAcceptance": 43, "regulationPreference": 64, "publicServiceSatisfaction": 75}	1
211	송채원	61	60-69	Male	울산광역시	35.530637	129.340484	대학교 졸	200-350만원	은퇴	자녀 양육 가구	68	보수 정당 지지	74	{"economy": 9, "housing": 13, "welfare": 8, "security": 23, "environment": -29}	SNS	{환경,공동체,자유}	울산광역시에 거주하는 60-69 은퇴. 정치 성향은 보수이며 환경, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 51, "ecoConsciousness": 33, "priceSensitivity": 77, "digitalConsumption": 72}	{"taxTolerance": 52, "governmentTrust": 58, "policyAcceptance": 50, "regulationPreference": 49, "publicServiceSatisfaction": 70}	1
212	조지호	79	70+	Female	울산광역시	35.544873	129.382865	대학원 졸	500-700만원	은퇴	1인 가구	58	보수 정당 지지	92	{"economy": 38, "housing": -9, "welfare": 2, "security": 18, "environment": -10}	유튜브	{안전,전통,공정}	울산광역시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안전, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 63, "ecoConsciousness": 49, "priceSensitivity": 42, "digitalConsumption": 57}	{"taxTolerance": 37, "governmentTrust": 53, "policyAcceptance": 53, "regulationPreference": 82, "publicServiceSatisfaction": 59}	1
213	최민준	71	70+	Male	울산광역시	35.608604	129.264636	대학교 졸	350-500만원	은퇴	다세대 가구	5	중도 무당층	91	{"economy": 8, "housing": 27, "welfare": 28, "security": -3, "environment": 10}	지상파/종편 뉴스	{안정,다양성,공정}	울산광역시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안정, 다양성, 공정 가치를 중시한다.	{"brandLoyalty": 69, "noveltySeeking": 41, "ecoConsciousness": 70, "priceSensitivity": 73, "digitalConsumption": 66}	{"taxTolerance": 44, "governmentTrust": 19, "policyAcceptance": 62, "regulationPreference": 69, "publicServiceSatisfaction": 66}	1
214	류민서	23	18-29	Female	경기도	37.375293	127.599104	대학교 졸	200-350만원	학생	다세대 가구	-7	중도 무당층	45	{"economy": -33, "housing": 3, "welfare": 1, "security": -35, "environment": 44}	SNS	{안정,성장,공정}	경기도에 거주하는 18-29 학생. 정치 성향은 중도이며 안정, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 13, "noveltySeeking": 91, "ecoConsciousness": 80, "priceSensitivity": 61, "digitalConsumption": 71}	{"taxTolerance": 63, "governmentTrust": 53, "policyAcceptance": 49, "regulationPreference": 62, "publicServiceSatisfaction": 66}	1
215	권유준	22	18-29	Female	경기도	37.334049	127.459677	대학원 졸	350-500만원	프리랜서	자녀 양육 가구	-27	진보 성향 무당층	66	{"economy": -6, "housing": 31, "welfare": 37, "security": -1, "environment": 11}	SNS	{자유,전통,성장}	경기도에 거주하는 18-29 프리랜서. 정치 성향은 중도이며 자유, 전통, 성장 가치를 중시한다.	{"brandLoyalty": 29, "noveltySeeking": 74, "ecoConsciousness": 41, "priceSensitivity": 75, "digitalConsumption": 91}	{"taxTolerance": 75, "governmentTrust": 37, "policyAcceptance": 33, "regulationPreference": 54, "publicServiceSatisfaction": 81}	1
216	한정희	26	18-29	Female	경기도	37.43209	127.435922	대학교 졸	350-500만원	전문직	1인 가구	-19	진보 성향 무당층	57	{"economy": -26, "housing": -4, "welfare": 38, "security": -3, "environment": 11}	유튜브	{안정,다양성,환경}	경기도에 거주하는 18-29 전문직. 정치 성향은 중도이며 안정, 다양성, 환경 가치를 중시한다.	{"brandLoyalty": 25, "noveltySeeking": 96, "ecoConsciousness": 62, "priceSensitivity": 62, "digitalConsumption": 86}	{"taxTolerance": 62, "governmentTrust": 33, "policyAcceptance": 32, "regulationPreference": 56, "publicServiceSatisfaction": 79}	1
217	홍민서	24	18-29	Female	경기도	37.375308	127.502012	대학원 졸	200-350만원	전문직	자녀 양육 가구	-28	진보 성향 무당층	45	{"economy": -17, "housing": 16, "welfare": 33, "security": -49, "environment": 54}	지상파/종편 뉴스	{자유,전통,혁신}	경기도에 거주하는 18-29 전문직. 정치 성향은 중도이며 자유, 전통, 혁신 가치를 중시한다.	{"brandLoyalty": 22, "noveltySeeking": 88, "ecoConsciousness": 64, "priceSensitivity": 65, "digitalConsumption": 83}	{"taxTolerance": 29, "governmentTrust": 14, "policyAcceptance": 37, "regulationPreference": 60, "publicServiceSatisfaction": 60}	1
218	황지우	26	18-29	Female	경기도	37.489979	127.536753	대학원 졸	350-500만원	전문직	부부 가구	-19	진보 성향 무당층	67	{"economy": 1, "housing": 55, "welfare": 10, "security": -28, "environment": 39}	신문/팟캐스트	{안전,환경,공동체}	경기도에 거주하는 18-29 전문직. 정치 성향은 중도이며 안전, 환경, 공동체 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 83, "ecoConsciousness": 71, "priceSensitivity": 63, "digitalConsumption": 85}	{"taxTolerance": 36, "governmentTrust": 39, "policyAcceptance": 48, "regulationPreference": 45, "publicServiceSatisfaction": 72}	1
219	박지우	26	18-29	Female	경기도	37.370133	127.427944	대학원 졸	350-500만원	공무원	다세대 가구	-14	중도 무당층	70	{"economy": -10, "housing": 32, "welfare": -23, "security": -12, "environment": 0}	포털 뉴스	{성장,전통,안정}	경기도에 거주하는 18-29 공무원. 정치 성향은 중도이며 성장, 전통, 안정 가치를 중시한다.	{"brandLoyalty": 23, "noveltySeeking": 81, "ecoConsciousness": 61, "priceSensitivity": 63, "digitalConsumption": 81}	{"taxTolerance": 34, "governmentTrust": 27, "policyAcceptance": 44, "regulationPreference": 75, "publicServiceSatisfaction": 57}	1
220	류지우	28	18-29	Female	경기도	37.478926	127.571413	전문대 졸	700만원 이상	전문직	1인 가구	-17	진보 성향 무당층	42	{"economy": -43, "housing": 12, "welfare": 22, "security": -12, "environment": 28}	지상파/종편 뉴스	{공동체,공정,환경}	경기도에 거주하는 18-29 전문직. 정치 성향은 중도이며 공동체, 공정, 환경 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 58, "ecoConsciousness": 61, "priceSensitivity": 46, "digitalConsumption": 80}	{"taxTolerance": 51, "governmentTrust": 46, "policyAcceptance": 28, "regulationPreference": 59, "publicServiceSatisfaction": 64}	1
221	정지호	25	18-29	Female	경기도	37.483682	127.588216	대학원 졸	350-500만원	생산직	1인 가구	-14	중도 무당층	53	{"economy": -18, "housing": -4, "welfare": 18, "security": -7, "environment": 10}	포털 뉴스	{성장,다양성,공동체}	경기도에 거주하는 18-29 생산직. 정치 성향은 중도이며 성장, 다양성, 공동체 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 77, "ecoConsciousness": 44, "priceSensitivity": 55, "digitalConsumption": 92}	{"taxTolerance": 56, "governmentTrust": 33, "policyAcceptance": 32, "regulationPreference": 50, "publicServiceSatisfaction": 81}	1
222	서서연	24	18-29	Female	경기도	37.340371	127.501859	대학교 졸	500-700만원	학생	부부 가구	-27	진보 성향 무당층	51	{"economy": -30, "housing": 12, "welfare": 33, "security": -25, "environment": 27}	지상파/종편 뉴스	{공동체,자유,안전}	경기도에 거주하는 18-29 학생. 정치 성향은 중도이며 공동체, 자유, 안전 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 67, "ecoConsciousness": 38, "priceSensitivity": 52, "digitalConsumption": 91}	{"taxTolerance": 62, "governmentTrust": 39, "policyAcceptance": 37, "regulationPreference": 74, "publicServiceSatisfaction": 75}	1
223	홍순자	21	18-29	Female	경기도	37.34622	127.44	대학원 졸	200-350만원	학생	다세대 가구	4	중도 무당층	18	{"economy": 0, "housing": 29, "welfare": 36, "security": 0, "environment": 39}	유튜브	{환경,혁신,전통}	경기도에 거주하는 18-29 학생. 정치 성향은 중도이며 환경, 혁신, 전통 가치를 중시한다.	{"brandLoyalty": 22, "noveltySeeking": 75, "ecoConsciousness": 72, "priceSensitivity": 69, "digitalConsumption": 92}	{"taxTolerance": 44, "governmentTrust": 48, "policyAcceptance": 50, "regulationPreference": 68, "publicServiceSatisfaction": 85}	1
224	신영수	20	18-29	Female	경기도	37.470034	127.558813	대학원 졸	200-350만원	학생	1인 가구	-12	중도 무당층	44	{"economy": -24, "housing": 23, "welfare": 18, "security": -13, "environment": 39}	신문/팟캐스트	{환경,안정,혁신}	경기도에 거주하는 18-29 학생. 정치 성향은 중도이며 환경, 안정, 혁신 가치를 중시한다.	{"brandLoyalty": 25, "noveltySeeking": 69, "ecoConsciousness": 82, "priceSensitivity": 73, "digitalConsumption": 85}	{"taxTolerance": 50, "governmentTrust": 27, "policyAcceptance": 36, "regulationPreference": 52, "publicServiceSatisfaction": 63}	1
225	이서윤	18	18-29	Male	경기도	37.381644	127.51177	대학교 졸	350-500만원	자영업	자녀 양육 가구	-27	진보 성향 무당층	21	{"economy": -6, "housing": 22, "welfare": 16, "security": -25, "environment": 30}	포털 뉴스	{공정,혁신,자유}	경기도에 거주하는 18-29 자영업. 정치 성향은 중도이며 공정, 혁신, 자유 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 64, "ecoConsciousness": 64, "priceSensitivity": 76, "digitalConsumption": 94}	{"taxTolerance": 45, "governmentTrust": 49, "policyAcceptance": 46, "regulationPreference": 58, "publicServiceSatisfaction": 77}	1
226	정광수	25	18-29	Male	경기도	37.406823	127.46995	대학교 졸	350-500만원	학생	다세대 가구	-17	진보 성향 무당층	58	{"economy": -38, "housing": 35, "welfare": 36, "security": 11, "environment": -3}	포털 뉴스	{안전,전통,환경}	경기도에 거주하는 18-29 학생. 정치 성향은 중도이며 안전, 전통, 환경 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 77, "ecoConsciousness": 56, "priceSensitivity": 55, "digitalConsumption": 79}	{"taxTolerance": 66, "governmentTrust": 22, "policyAcceptance": 27, "regulationPreference": 59, "publicServiceSatisfaction": 68}	1
227	안유준	27	18-29	Male	경기도	37.491195	127.579428	대학원 졸	700만원 이상	공무원	부부 가구	-51	진보 정당 지지	38	{"economy": -44, "housing": 15, "welfare": 43, "security": -7, "environment": 42}	신문/팟캐스트	{안정,전통,자유}	경기도에 거주하는 18-29 공무원. 정치 성향은 진보이며 안정, 전통, 자유 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 66, "ecoConsciousness": 63, "priceSensitivity": 51, "digitalConsumption": 82}	{"taxTolerance": 58, "governmentTrust": 34, "policyAcceptance": 50, "regulationPreference": 71, "publicServiceSatisfaction": 69}	1
228	강서연	23	18-29	Male	경기도	37.484645	127.521632	대학교 졸	200-350만원	프리랜서	1인 가구	3	중도 무당층	29	{"economy": -4, "housing": 9, "welfare": -5, "security": 3, "environment": 19}	포털 뉴스	{안전,성장,안정}	경기도에 거주하는 18-29 프리랜서. 정치 성향은 중도이며 안전, 성장, 안정 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 90, "ecoConsciousness": 47, "priceSensitivity": 70, "digitalConsumption": 72}	{"taxTolerance": 52, "governmentTrust": 52, "policyAcceptance": 36, "regulationPreference": 54, "publicServiceSatisfaction": 54}	1
229	안건우	26	18-29	Male	경기도	37.405503	127.429238	대학원 졸	200-350만원	전문직	다세대 가구	-6	중도 무당층	60	{"economy": 6, "housing": 50, "welfare": 31, "security": -9, "environment": 9}	지상파/종편 뉴스	{공정,환경,성장}	경기도에 거주하는 18-29 전문직. 정치 성향은 중도이며 공정, 환경, 성장 가치를 중시한다.	{"brandLoyalty": 20, "noveltySeeking": 86, "ecoConsciousness": 69, "priceSensitivity": 83, "digitalConsumption": 83}	{"taxTolerance": 52, "governmentTrust": 31, "policyAcceptance": 30, "regulationPreference": 71, "publicServiceSatisfaction": 76}	1
230	강다은	21	18-29	Male	경기도	37.462633	127.578435	대학원 졸	200-350만원	자영업	다세대 가구	-1	중도 무당층	48	{"economy": -2, "housing": 30, "welfare": 10, "security": -2, "environment": 36}	유튜브	{전통,혁신,자유}	경기도에 거주하는 18-29 자영업. 정치 성향은 중도이며 전통, 혁신, 자유 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 68, "ecoConsciousness": 72, "priceSensitivity": 70, "digitalConsumption": 72}	{"taxTolerance": 35, "governmentTrust": 40, "policyAcceptance": 49, "regulationPreference": 65, "publicServiceSatisfaction": 65}	1
231	류유준	24	18-29	Male	경기도	37.459061	127.553075	대학원 졸	500-700만원	학생	자녀 양육 가구	-10	중도 무당층	42	{"economy": -23, "housing": 13, "welfare": 36, "security": 20, "environment": 27}	신문/팟캐스트	{안정,자유,환경}	경기도에 거주하는 18-29 학생. 정치 성향은 중도이며 안정, 자유, 환경 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 87, "ecoConsciousness": 57, "priceSensitivity": 76, "digitalConsumption": 74}	{"taxTolerance": 45, "governmentTrust": 59, "policyAcceptance": 43, "regulationPreference": 73, "publicServiceSatisfaction": 79}	1
232	류현우	28	18-29	Male	경기도	37.491419	127.43411	대학원 졸	350-500만원	은퇴	자녀 양육 가구	-39	진보 성향 무당층	53	{"economy": -31, "housing": 39, "welfare": 8, "security": -37, "environment": 49}	SNS	{안정,안전,공동체}	경기도에 거주하는 18-29 은퇴. 정치 성향은 진보이며 안정, 안전, 공동체 가치를 중시한다.	{"brandLoyalty": 6, "noveltySeeking": 66, "ecoConsciousness": 71, "priceSensitivity": 65, "digitalConsumption": 81}	{"taxTolerance": 55, "governmentTrust": 39, "policyAcceptance": 39, "regulationPreference": 52, "publicServiceSatisfaction": 77}	1
233	장건우	23	18-29	Male	경기도	37.359561	127.580288	대학원 졸	200만원 미만	학생	1인 가구	-29	진보 성향 무당층	64	{"economy": -28, "housing": 2, "welfare": 9, "security": -18, "environment": 53}	지상파/종편 뉴스	{공정,안전,공동체}	경기도에 거주하는 18-29 학생. 정치 성향은 중도이며 공정, 안전, 공동체 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 69, "ecoConsciousness": 58, "priceSensitivity": 67, "digitalConsumption": 84}	{"taxTolerance": 70, "governmentTrust": 60, "policyAcceptance": 51, "regulationPreference": 75, "publicServiceSatisfaction": 71}	1
234	임지호	18	18-29	Male	경기도	37.444944	127.61643	대학원 졸	350-500만원	학생	자녀 양육 가구	-30	진보 성향 무당층	52	{"economy": -4, "housing": 38, "welfare": 27, "security": -12, "environment": 32}	유튜브	{성장,혁신,전통}	경기도에 거주하는 18-29 학생. 정치 성향은 중도이며 성장, 혁신, 전통 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 82, "ecoConsciousness": 56, "priceSensitivity": 54, "digitalConsumption": 97}	{"taxTolerance": 67, "governmentTrust": 42, "policyAcceptance": 46, "regulationPreference": 54, "publicServiceSatisfaction": 66}	1
235	홍서윤	18	18-29	Male	경기도	37.441546	127.540691	대학교 졸	200만원 미만	사무직	1인 가구	13	중도 무당층	59	{"economy": -6, "housing": 12, "welfare": 13, "security": 17, "environment": -3}	유튜브	{안정,안전,환경}	경기도에 거주하는 18-29 사무직. 정치 성향은 중도이며 안정, 안전, 환경 가치를 중시한다.	{"brandLoyalty": 22, "noveltySeeking": 79, "ecoConsciousness": 56, "priceSensitivity": 77, "digitalConsumption": 100}	{"taxTolerance": 55, "governmentTrust": 55, "policyAcceptance": 40, "regulationPreference": 55, "publicServiceSatisfaction": 65}	1
236	서순자	33	30-39	Female	경기도	37.338236	127.604638	전문대 졸	500-700만원	전문직	자녀 양육 가구	-14	중도 무당층	44	{"economy": -24, "housing": 16, "welfare": 15, "security": 16, "environment": 28}	SNS	{공동체,혁신,자유}	경기도에 거주하는 30-39 전문직. 정치 성향은 중도이며 공동체, 혁신, 자유 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 60, "ecoConsciousness": 55, "priceSensitivity": 34, "digitalConsumption": 74}	{"taxTolerance": 65, "governmentTrust": 46, "policyAcceptance": 62, "regulationPreference": 42, "publicServiceSatisfaction": 69}	1
237	최철수	33	30-39	Female	경기도	37.457831	127.578272	대학교 졸	350-500만원	학생	다세대 가구	-1	중도 무당층	57	{"economy": -11, "housing": 26, "welfare": 12, "security": -4, "environment": 17}	포털 뉴스	{공동체,안정,혁신}	경기도에 거주하는 30-39 학생. 정치 성향은 중도이며 공동체, 안정, 혁신 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 73, "ecoConsciousness": 56, "priceSensitivity": 66, "digitalConsumption": 100}	{"taxTolerance": 49, "governmentTrust": 30, "policyAcceptance": 43, "regulationPreference": 79, "publicServiceSatisfaction": 73}	1
238	이민서	31	30-39	Female	경기도	37.412829	127.440007	대학원 졸	350-500만원	프리랜서	1인 가구	0	중도 무당층	34	{"economy": 4, "housing": 21, "welfare": 41, "security": 29, "environment": 43}	유튜브	{안전,혁신,성장}	경기도에 거주하는 30-39 프리랜서. 정치 성향은 중도이며 안전, 혁신, 성장 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 70, "ecoConsciousness": 54, "priceSensitivity": 35, "digitalConsumption": 56}	{"taxTolerance": 58, "governmentTrust": 12, "policyAcceptance": 42, "regulationPreference": 50, "publicServiceSatisfaction": 63}	1
239	임현우	31	30-39	Female	경기도	37.492053	127.568166	대학원 졸	350-500만원	자영업	자녀 양육 가구	-8	중도 무당층	47	{"economy": -37, "housing": 22, "welfare": 48, "security": 30, "environment": 14}	포털 뉴스	{전통,자유,안정}	경기도에 거주하는 30-39 자영업. 정치 성향은 중도이며 전통, 자유, 안정 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 76, "ecoConsciousness": 49, "priceSensitivity": 57, "digitalConsumption": 81}	{"taxTolerance": 56, "governmentTrust": 48, "policyAcceptance": 42, "regulationPreference": 60, "publicServiceSatisfaction": 84}	1
240	전지민	31	30-39	Female	경기도	37.446724	127.513765	고졸 이하	200만원 미만	학생	자녀 양육 가구	41	보수 성향 무당층	50	{"economy": 41, "housing": -11, "welfare": -15, "security": 55, "environment": -1}	지상파/종편 뉴스	{공정,공동체,자유}	경기도에 거주하는 30-39 학생. 정치 성향은 보수이며 공정, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 81, "ecoConsciousness": 34, "priceSensitivity": 77, "digitalConsumption": 81}	{"taxTolerance": 43, "governmentTrust": 46, "policyAcceptance": 40, "regulationPreference": 52, "publicServiceSatisfaction": 69}	1
241	송순자	36	30-39	Female	경기도	37.411805	127.599225	고졸 이하	350-500만원	생산직	자녀 양육 가구	22	보수 성향 무당층	46	{"economy": -12, "housing": 23, "welfare": -11, "security": 24, "environment": -4}	유튜브	{전통,안전,자유}	경기도에 거주하는 30-39 생산직. 정치 성향은 중도이며 전통, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 61, "ecoConsciousness": 52, "priceSensitivity": 52, "digitalConsumption": 63}	{"taxTolerance": 45, "governmentTrust": 46, "policyAcceptance": 70, "regulationPreference": 55, "publicServiceSatisfaction": 71}	1
242	최수아	31	30-39	Female	경기도	37.469496	127.497052	대학원 졸	500-700만원	주부	부부 가구	-10	중도 무당층	47	{"economy": 14, "housing": 4, "welfare": -8, "security": 27, "environment": 25}	신문/팟캐스트	{환경,다양성,자유}	경기도에 거주하는 30-39 주부. 정치 성향은 중도이며 환경, 다양성, 자유 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 47, "ecoConsciousness": 70, "priceSensitivity": 58, "digitalConsumption": 79}	{"taxTolerance": 66, "governmentTrust": 46, "policyAcceptance": 62, "regulationPreference": 67, "publicServiceSatisfaction": 76}	1
243	오하은	30	30-39	Female	경기도	37.442193	127.43636	대학교 졸	200-350만원	은퇴	1인 가구	-49	진보 정당 지지	50	{"economy": -33, "housing": 29, "welfare": 29, "security": -66, "environment": 59}	SNS	{전통,공동체,성장}	경기도에 거주하는 30-39 은퇴. 정치 성향은 진보이며 전통, 공동체, 성장 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 51, "ecoConsciousness": 72, "priceSensitivity": 35, "digitalConsumption": 85}	{"taxTolerance": 44, "governmentTrust": 52, "policyAcceptance": 39, "regulationPreference": 62, "publicServiceSatisfaction": 78}	1
244	전민서	39	30-39	Female	경기도	37.421756	127.425356	전문대 졸	700만원 이상	자영업	부부 가구	-12	중도 무당층	70	{"economy": -3, "housing": 40, "welfare": 27, "security": 14, "environment": 19}	지상파/종편 뉴스	{전통,성장,공정}	경기도에 거주하는 30-39 자영업. 정치 성향은 중도이며 전통, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 71, "ecoConsciousness": 36, "priceSensitivity": 25, "digitalConsumption": 79}	{"taxTolerance": 36, "governmentTrust": 43, "policyAcceptance": 41, "regulationPreference": 58, "publicServiceSatisfaction": 64}	1
245	김혜진	37	30-39	Female	경기도	37.353318	127.526237	대학교 졸	500-700만원	은퇴	자녀 양육 가구	8	중도 무당층	53	{"economy": -1, "housing": -3, "welfare": 7, "security": -27, "environment": 30}	SNS	{안전,다양성,공동체}	경기도에 거주하는 30-39 은퇴. 정치 성향은 중도이며 안전, 다양성, 공동체 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 68, "ecoConsciousness": 47, "priceSensitivity": 56, "digitalConsumption": 79}	{"taxTolerance": 73, "governmentTrust": 59, "policyAcceptance": 63, "regulationPreference": 68, "publicServiceSatisfaction": 77}	1
246	황준서	34	30-39	Male	경기도	37.461654	127.57473	대학교 졸	200만원 미만	전문직	자녀 양육 가구	-12	중도 무당층	83	{"economy": -1, "housing": 51, "welfare": 31, "security": 18, "environment": -2}	지상파/종편 뉴스	{혁신,안정,자유}	경기도에 거주하는 30-39 전문직. 정치 성향은 중도이며 혁신, 안정, 자유 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 82, "ecoConsciousness": 65, "priceSensitivity": 69, "digitalConsumption": 100}	{"taxTolerance": 26, "governmentTrust": 43, "policyAcceptance": 57, "regulationPreference": 84, "publicServiceSatisfaction": 52}	1
247	홍철수	34	30-39	Male	경기도	37.385461	127.505563	고졸 이하	500-700만원	은퇴	부부 가구	5	중도 무당층	71	{"economy": 12, "housing": 23, "welfare": 48, "security": -2, "environment": 50}	유튜브	{자유,안전,성장}	경기도에 거주하는 30-39 은퇴. 정치 성향은 중도이며 자유, 안전, 성장 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 54, "ecoConsciousness": 38, "priceSensitivity": 71, "digitalConsumption": 76}	{"taxTolerance": 41, "governmentTrust": 47, "policyAcceptance": 37, "regulationPreference": 56, "publicServiceSatisfaction": 73}	1
248	이주원	31	30-39	Male	경기도	37.38766	127.53213	전문대 졸	700만원 이상	서비스직	다세대 가구	-59	진보 정당 지지	57	{"economy": -47, "housing": 34, "welfare": 57, "security": -39, "environment": 41}	SNS	{안전,안정,자유}	경기도에 거주하는 30-39 서비스직. 정치 성향은 진보이며 안전, 안정, 자유 가치를 중시한다.	{"brandLoyalty": 22, "noveltySeeking": 50, "ecoConsciousness": 50, "priceSensitivity": 49, "digitalConsumption": 76}	{"taxTolerance": 61, "governmentTrust": 48, "policyAcceptance": 48, "regulationPreference": 63, "publicServiceSatisfaction": 80}	1
249	조광수	35	30-39	Male	경기도	37.445424	127.554841	대학원 졸	500-700만원	사무직	1인 가구	-5	중도 무당층	58	{"economy": 7, "housing": 0, "welfare": 19, "security": 5, "environment": 22}	지상파/종편 뉴스	{안전,전통,환경}	경기도에 거주하는 30-39 사무직. 정치 성향은 중도이며 안전, 전통, 환경 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 79, "ecoConsciousness": 66, "priceSensitivity": 77, "digitalConsumption": 82}	{"taxTolerance": 41, "governmentTrust": 34, "policyAcceptance": 32, "regulationPreference": 82, "publicServiceSatisfaction": 81}	1
250	권현우	37	30-39	Male	경기도	37.477005	127.543834	대학원 졸	500-700만원	서비스직	부부 가구	-64	진보 정당 지지	20	{"economy": -48, "housing": 68, "welfare": 79, "security": -37, "environment": 20}	유튜브	{혁신,자유,다양성}	경기도에 거주하는 30-39 서비스직. 정치 성향은 진보이며 혁신, 자유, 다양성 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 73, "ecoConsciousness": 62, "priceSensitivity": 63, "digitalConsumption": 98}	{"taxTolerance": 46, "governmentTrust": 55, "policyAcceptance": 59, "regulationPreference": 64, "publicServiceSatisfaction": 47}	1
251	최민서	32	30-39	Male	경기도	37.482802	127.594346	대학교 졸	350-500만원	학생	1인 가구	-21	진보 성향 무당층	40	{"economy": -23, "housing": 22, "welfare": 36, "security": -18, "environment": 11}	포털 뉴스	{공정,혁신,전통}	경기도에 거주하는 30-39 학생. 정치 성향은 중도이며 공정, 혁신, 전통 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 75, "ecoConsciousness": 60, "priceSensitivity": 52, "digitalConsumption": 80}	{"taxTolerance": 47, "governmentTrust": 55, "policyAcceptance": 57, "regulationPreference": 62, "publicServiceSatisfaction": 84}	1
252	한유준	37	30-39	Male	경기도	37.419184	127.522377	전문대 졸	500-700만원	주부	1인 가구	2	중도 무당층	48	{"economy": 21, "housing": 17, "welfare": 21, "security": 43, "environment": 22}	SNS	{자유,공동체,다양성}	경기도에 거주하는 30-39 주부. 정치 성향은 중도이며 자유, 공동체, 다양성 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 68, "ecoConsciousness": 35, "priceSensitivity": 62, "digitalConsumption": 81}	{"taxTolerance": 50, "governmentTrust": 65, "policyAcceptance": 58, "regulationPreference": 63, "publicServiceSatisfaction": 44}	1
253	오준서	35	30-39	Male	경기도	37.369416	127.507862	고졸 이하	200-350만원	은퇴	1인 가구	-22	진보 성향 무당층	37	{"economy": -19, "housing": 3, "welfare": 4, "security": -2, "environment": 32}	SNS	{공정,전통,자유}	경기도에 거주하는 30-39 은퇴. 정치 성향은 중도이며 공정, 전통, 자유 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 67, "ecoConsciousness": 60, "priceSensitivity": 74, "digitalConsumption": 74}	{"taxTolerance": 58, "governmentTrust": 54, "policyAcceptance": 43, "regulationPreference": 68, "publicServiceSatisfaction": 68}	1
254	조유준	37	30-39	Male	경기도	37.458337	127.516598	대학원 졸	700만원 이상	주부	부부 가구	-1	중도 무당층	65	{"economy": 6, "housing": 31, "welfare": 29, "security": 9, "environment": 9}	지상파/종편 뉴스	{전통,안전,다양성}	경기도에 거주하는 30-39 주부. 정치 성향은 중도이며 전통, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 66, "ecoConsciousness": 55, "priceSensitivity": 56, "digitalConsumption": 73}	{"taxTolerance": 59, "governmentTrust": 53, "policyAcceptance": 46, "regulationPreference": 57, "publicServiceSatisfaction": 61}	1
255	조미경	30	30-39	Male	경기도	37.464257	127.455175	대학교 졸	350-500만원	생산직	1인 가구	5	중도 무당층	60	{"economy": 26, "housing": 11, "welfare": 25, "security": 9, "environment": 33}	SNS	{전통,다양성,혁신}	경기도에 거주하는 30-39 생산직. 정치 성향은 중도이며 전통, 다양성, 혁신 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 63, "ecoConsciousness": 56, "priceSensitivity": 60, "digitalConsumption": 70}	{"taxTolerance": 51, "governmentTrust": 38, "policyAcceptance": 47, "regulationPreference": 69, "publicServiceSatisfaction": 63}	1
256	최서연	49	40-49	Female	경기도	37.380805	127.436438	대학교 졸	700만원 이상	은퇴	다세대 가구	21	보수 성향 무당층	57	{"economy": -9, "housing": -16, "welfare": 7, "security": -3, "environment": 10}	유튜브	{안전,혁신,전통}	경기도에 거주하는 40-49 은퇴. 정치 성향은 중도이며 안전, 혁신, 전통 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 67, "ecoConsciousness": 65, "priceSensitivity": 52, "digitalConsumption": 71}	{"taxTolerance": 46, "governmentTrust": 49, "policyAcceptance": 46, "regulationPreference": 70, "publicServiceSatisfaction": 62}	1
257	안은우	46	40-49	Female	경기도	37.453062	127.561438	대학원 졸	200만원 미만	학생	자녀 양육 가구	-17	진보 성향 무당층	42	{"economy": 14, "housing": 22, "welfare": 50, "security": -21, "environment": 26}	SNS	{환경,다양성,공동체}	경기도에 거주하는 40-49 학생. 정치 성향은 중도이며 환경, 다양성, 공동체 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 73, "ecoConsciousness": 61, "priceSensitivity": 87, "digitalConsumption": 95}	{"taxTolerance": 46, "governmentTrust": 49, "policyAcceptance": 59, "regulationPreference": 50, "publicServiceSatisfaction": 73}	1
258	최준서	45	40-49	Female	경기도	37.349925	127.431348	전문대 졸	500-700만원	주부	자녀 양육 가구	-5	중도 무당층	75	{"economy": -20, "housing": 25, "welfare": 33, "security": -7, "environment": 9}	유튜브	{안전,혁신,공정}	경기도에 거주하는 40-49 주부. 정치 성향은 중도이며 안전, 혁신, 공정 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 66, "ecoConsciousness": 46, "priceSensitivity": 71, "digitalConsumption": 65}	{"taxTolerance": 48, "governmentTrust": 44, "policyAcceptance": 53, "regulationPreference": 75, "publicServiceSatisfaction": 50}	1
259	윤채원	40	40-49	Female	경기도	37.487201	127.58232	대학교 졸	350-500만원	프리랜서	자녀 양육 가구	-27	진보 성향 무당층	84	{"economy": -32, "housing": 14, "welfare": 43, "security": -18, "environment": 20}	유튜브	{자유,공정,성장}	경기도에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 자유, 공정, 성장 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 57, "ecoConsciousness": 40, "priceSensitivity": 55, "digitalConsumption": 73}	{"taxTolerance": 56, "governmentTrust": 48, "policyAcceptance": 59, "regulationPreference": 49, "publicServiceSatisfaction": 55}	1
260	한경숙	48	40-49	Female	경기도	37.445302	127.574535	대학원 졸	700만원 이상	생산직	다세대 가구	-14	중도 무당층	67	{"economy": -15, "housing": 9, "welfare": 18, "security": -14, "environment": 13}	유튜브	{혁신,안정,공동체}	경기도에 거주하는 40-49 생산직. 정치 성향은 중도이며 혁신, 안정, 공동체 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 62, "ecoConsciousness": 67, "priceSensitivity": 36, "digitalConsumption": 62}	{"taxTolerance": 50, "governmentTrust": 39, "policyAcceptance": 33, "regulationPreference": 64, "publicServiceSatisfaction": 74}	1
261	박주원	47	40-49	Female	경기도	37.490543	127.542138	대학교 졸	500-700만원	서비스직	자녀 양육 가구	9	중도 무당층	64	{"economy": 23, "housing": 23, "welfare": 15, "security": 38, "environment": 2}	신문/팟캐스트	{성장,환경,안전}	경기도에 거주하는 40-49 서비스직. 정치 성향은 중도이며 성장, 환경, 안전 가치를 중시한다.	{"brandLoyalty": 60, "noveltySeeking": 43, "ecoConsciousness": 59, "priceSensitivity": 62, "digitalConsumption": 60}	{"taxTolerance": 51, "governmentTrust": 45, "policyAcceptance": 47, "regulationPreference": 68, "publicServiceSatisfaction": 76}	1
262	홍성호	44	40-49	Female	경기도	37.381249	127.465098	전문대 졸	350-500만원	사무직	1인 가구	-18	진보 성향 무당층	62	{"economy": -12, "housing": 14, "welfare": 34, "security": 2, "environment": -5}	지상파/종편 뉴스	{성장,공동체,자유}	경기도에 거주하는 40-49 사무직. 정치 성향은 중도이며 성장, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 56, "ecoConsciousness": 63, "priceSensitivity": 46, "digitalConsumption": 75}	{"taxTolerance": 56, "governmentTrust": 42, "policyAcceptance": 53, "regulationPreference": 52, "publicServiceSatisfaction": 69}	1
263	한하은	45	40-49	Female	경기도	37.441379	127.529546	대학원 졸	350-500만원	은퇴	1인 가구	13	중도 무당층	79	{"economy": 33, "housing": 0, "welfare": 13, "security": -9, "environment": 36}	지상파/종편 뉴스	{전통,혁신,성장}	경기도에 거주하는 40-49 은퇴. 정치 성향은 중도이며 전통, 혁신, 성장 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 61, "ecoConsciousness": 62, "priceSensitivity": 78, "digitalConsumption": 73}	{"taxTolerance": 42, "governmentTrust": 39, "policyAcceptance": 39, "regulationPreference": 63, "publicServiceSatisfaction": 49}	1
264	최서윤	45	40-49	Female	경기도	37.436025	127.544177	전문대 졸	500-700만원	학생	부부 가구	1	중도 무당층	65	{"economy": 2, "housing": 34, "welfare": 14, "security": 6, "environment": 26}	지상파/종편 뉴스	{혁신,다양성,자유}	경기도에 거주하는 40-49 학생. 정치 성향은 중도이며 혁신, 다양성, 자유 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 58, "ecoConsciousness": 56, "priceSensitivity": 59, "digitalConsumption": 69}	{"taxTolerance": 40, "governmentTrust": 56, "policyAcceptance": 44, "regulationPreference": 65, "publicServiceSatisfaction": 69}	1
265	임지민	47	40-49	Female	경기도	37.467044	127.541886	대학교 졸	350-500만원	은퇴	1인 가구	-19	진보 성향 무당층	75	{"economy": -8, "housing": 49, "welfare": -5, "security": -17, "environment": 24}	유튜브	{성장,공동체,안전}	경기도에 거주하는 40-49 은퇴. 정치 성향은 중도이며 성장, 공동체, 안전 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 54, "ecoConsciousness": 44, "priceSensitivity": 70, "digitalConsumption": 62}	{"taxTolerance": 50, "governmentTrust": 70, "policyAcceptance": 36, "regulationPreference": 57, "publicServiceSatisfaction": 52}	1
266	홍영수	48	40-49	Female	경기도	37.425754	127.468961	대학원 졸	500-700만원	프리랜서	부부 가구	-11	중도 무당층	54	{"economy": 12, "housing": 27, "welfare": 41, "security": 31, "environment": 20}	지상파/종편 뉴스	{공정,혁신,전통}	경기도에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 공정, 혁신, 전통 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 66, "ecoConsciousness": 47, "priceSensitivity": 62, "digitalConsumption": 78}	{"taxTolerance": 58, "governmentTrust": 47, "policyAcceptance": 51, "regulationPreference": 57, "publicServiceSatisfaction": 76}	1
267	홍미경	42	40-49	Female	경기도	37.473748	127.610148	대학원 졸	700만원 이상	서비스직	다세대 가구	16	보수 성향 무당층	70	{"economy": 24, "housing": 9, "welfare": -4, "security": 2, "environment": 13}	유튜브	{성장,안전,다양성}	경기도에 거주하는 40-49 서비스직. 정치 성향은 중도이며 성장, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 73, "ecoConsciousness": 72, "priceSensitivity": 42, "digitalConsumption": 79}	{"taxTolerance": 69, "governmentTrust": 49, "policyAcceptance": 67, "regulationPreference": 59, "publicServiceSatisfaction": 68}	1
268	오주원	43	40-49	Male	경기도	37.337299	127.510226	대학교 졸	700만원 이상	서비스직	부부 가구	-23	진보 성향 무당층	38	{"economy": -7, "housing": 28, "welfare": 15, "security": 24, "environment": 15}	지상파/종편 뉴스	{자유,공정,전통}	경기도에 거주하는 40-49 서비스직. 정치 성향은 중도이며 자유, 공정, 전통 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 69, "ecoConsciousness": 60, "priceSensitivity": 33, "digitalConsumption": 80}	{"taxTolerance": 49, "governmentTrust": 24, "policyAcceptance": 47, "regulationPreference": 75, "publicServiceSatisfaction": 65}	1
269	강미경	46	40-49	Male	경기도	37.459146	127.601186	대학원 졸	500-700만원	주부	다세대 가구	-20	진보 성향 무당층	77	{"economy": 15, "housing": 42, "welfare": 3, "security": -9, "environment": 12}	유튜브	{다양성,공동체,전통}	경기도에 거주하는 40-49 주부. 정치 성향은 중도이며 다양성, 공동체, 전통 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 65, "ecoConsciousness": 65, "priceSensitivity": 48, "digitalConsumption": 80}	{"taxTolerance": 54, "governmentTrust": 59, "policyAcceptance": 39, "regulationPreference": 54, "publicServiceSatisfaction": 53}	1
270	송은우	45	40-49	Male	경기도	37.375479	127.597564	대학교 졸	500-700만원	학생	1인 가구	-38	진보 성향 무당층	43	{"economy": -54, "housing": 18, "welfare": 49, "security": -14, "environment": 36}	SNS	{환경,안전,다양성}	경기도에 거주하는 40-49 학생. 정치 성향은 진보이며 환경, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 55, "ecoConsciousness": 40, "priceSensitivity": 51, "digitalConsumption": 69}	{"taxTolerance": 44, "governmentTrust": 43, "policyAcceptance": 29, "regulationPreference": 72, "publicServiceSatisfaction": 48}	1
271	송민준	48	40-49	Male	경기도	37.391926	127.503233	전문대 졸	350-500만원	프리랜서	1인 가구	-7	중도 무당층	55	{"economy": -1, "housing": 11, "welfare": 34, "security": -3, "environment": 10}	유튜브	{다양성,자유,전통}	경기도에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 다양성, 자유, 전통 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 59, "ecoConsciousness": 37, "priceSensitivity": 63, "digitalConsumption": 60}	{"taxTolerance": 49, "governmentTrust": 38, "policyAcceptance": 51, "regulationPreference": 64, "publicServiceSatisfaction": 80}	1
272	임지아	40	40-49	Male	경기도	37.457222	127.512247	대학원 졸	200만원 미만	전문직	1인 가구	9	중도 무당층	78	{"economy": 18, "housing": 22, "welfare": 5, "security": 6, "environment": 17}	신문/팟캐스트	{환경,다양성,안전}	경기도에 거주하는 40-49 전문직. 정치 성향은 중도이며 환경, 다양성, 안전 가치를 중시한다.	{"brandLoyalty": 25, "noveltySeeking": 66, "ecoConsciousness": 75, "priceSensitivity": 75, "digitalConsumption": 83}	{"taxTolerance": 39, "governmentTrust": 21, "policyAcceptance": 26, "regulationPreference": 82, "publicServiceSatisfaction": 79}	1
273	박민준	48	40-49	Male	경기도	37.375498	127.517733	전문대 졸	700만원 이상	프리랜서	다세대 가구	28	보수 성향 무당층	64	{"economy": -1, "housing": 6, "welfare": 9, "security": 29, "environment": -6}	지상파/종편 뉴스	{공정,다양성,혁신}	경기도에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 공정, 다양성, 혁신 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 61, "ecoConsciousness": 54, "priceSensitivity": 46, "digitalConsumption": 76}	{"taxTolerance": 50, "governmentTrust": 34, "policyAcceptance": 66, "regulationPreference": 65, "publicServiceSatisfaction": 68}	1
274	류현우	43	40-49	Male	경기도	37.442367	127.609832	대학교 졸	350-500만원	학생	다세대 가구	-13	중도 무당층	71	{"economy": -11, "housing": 20, "welfare": 28, "security": -33, "environment": 14}	SNS	{성장,환경,안전}	경기도에 거주하는 40-49 학생. 정치 성향은 중도이며 성장, 환경, 안전 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 62, "ecoConsciousness": 51, "priceSensitivity": 57, "digitalConsumption": 81}	{"taxTolerance": 41, "governmentTrust": 39, "policyAcceptance": 43, "regulationPreference": 66, "publicServiceSatisfaction": 58}	1
275	안영수	46	40-49	Male	경기도	37.409332	127.42806	전문대 졸	200-350만원	자영업	부부 가구	33	보수 성향 무당층	63	{"economy": 15, "housing": 12, "welfare": 1, "security": 25, "environment": -10}	SNS	{안전,환경,다양성}	경기도에 거주하는 40-49 자영업. 정치 성향은 중도이며 안전, 환경, 다양성 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 57, "ecoConsciousness": 44, "priceSensitivity": 59, "digitalConsumption": 81}	{"taxTolerance": 56, "governmentTrust": 62, "policyAcceptance": 32, "regulationPreference": 64, "publicServiceSatisfaction": 80}	1
276	안건우	43	40-49	Male	경기도	37.483239	127.510545	전문대 졸	700만원 이상	전문직	다세대 가구	-2	중도 무당층	83	{"economy": 0, "housing": 6, "welfare": -6, "security": -20, "environment": 26}	포털 뉴스	{혁신,안정,전통}	경기도에 거주하는 40-49 전문직. 정치 성향은 중도이며 혁신, 안정, 전통 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 59, "ecoConsciousness": 58, "priceSensitivity": 47, "digitalConsumption": 86}	{"taxTolerance": 46, "governmentTrust": 63, "policyAcceptance": 66, "regulationPreference": 57, "publicServiceSatisfaction": 52}	1
277	장주원	42	40-49	Male	경기도	37.4088	127.492495	고졸 이하	350-500만원	주부	자녀 양육 가구	3	중도 무당층	72	{"economy": 1, "housing": 52, "welfare": -8, "security": 5, "environment": -12}	SNS	{공정,공동체,안정}	경기도에 거주하는 40-49 주부. 정치 성향은 중도이며 공정, 공동체, 안정 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 60, "ecoConsciousness": 46, "priceSensitivity": 32, "digitalConsumption": 78}	{"taxTolerance": 56, "governmentTrust": 46, "policyAcceptance": 40, "regulationPreference": 52, "publicServiceSatisfaction": 85}	1
278	박서윤	47	40-49	Male	경기도	37.390768	127.534381	고졸 이하	200-350만원	생산직	부부 가구	-21	진보 성향 무당층	72	{"economy": -27, "housing": 38, "welfare": 7, "security": -14, "environment": 41}	포털 뉴스	{혁신,환경,자유}	경기도에 거주하는 40-49 생산직. 정치 성향은 중도이며 혁신, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 62, "ecoConsciousness": 48, "priceSensitivity": 77, "digitalConsumption": 76}	{"taxTolerance": 39, "governmentTrust": 39, "policyAcceptance": 50, "regulationPreference": 68, "publicServiceSatisfaction": 65}	1
279	송다은	47	40-49	Male	경기도	37.42449	127.480939	전문대 졸	700만원 이상	자영업	자녀 양육 가구	-17	진보 성향 무당층	56	{"economy": 4, "housing": 24, "welfare": 13, "security": 16, "environment": 13}	지상파/종편 뉴스	{성장,전통,안정}	경기도에 거주하는 40-49 자영업. 정치 성향은 중도이며 성장, 전통, 안정 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 77, "ecoConsciousness": 59, "priceSensitivity": 59, "digitalConsumption": 62}	{"taxTolerance": 38, "governmentTrust": 41, "policyAcceptance": 61, "regulationPreference": 38, "publicServiceSatisfaction": 73}	1
280	황지우	51	50-59	Female	경기도	37.451366	127.460418	고졸 이하	500-700만원	주부	자녀 양육 가구	-14	중도 무당층	58	{"economy": -1, "housing": -5, "welfare": -5, "security": -5, "environment": 16}	유튜브	{자유,다양성,공정}	경기도에 거주하는 50-59 주부. 정치 성향은 중도이며 자유, 다양성, 공정 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 64, "ecoConsciousness": 48, "priceSensitivity": 57, "digitalConsumption": 63}	{"taxTolerance": 32, "governmentTrust": 65, "policyAcceptance": 49, "regulationPreference": 66, "publicServiceSatisfaction": 65}	1
281	전지아	51	50-59	Female	경기도	37.404793	127.49666	전문대 졸	350-500만원	공무원	부부 가구	-7	중도 무당층	50	{"economy": -29, "housing": 28, "welfare": 13, "security": 15, "environment": 39}	신문/팟캐스트	{자유,환경,성장}	경기도에 거주하는 50-59 공무원. 정치 성향은 중도이며 자유, 환경, 성장 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 58, "ecoConsciousness": 70, "priceSensitivity": 65, "digitalConsumption": 73}	{"taxTolerance": 46, "governmentTrust": 36, "policyAcceptance": 50, "regulationPreference": 47, "publicServiceSatisfaction": 66}	1
282	오지호	57	50-59	Female	경기도	37.425498	127.508292	전문대 졸	500-700만원	사무직	다세대 가구	-5	중도 무당층	61	{"economy": -18, "housing": 9, "welfare": -24, "security": 36, "environment": 2}	SNS	{다양성,성장,안전}	경기도에 거주하는 50-59 사무직. 정치 성향은 중도이며 다양성, 성장, 안전 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 47, "ecoConsciousness": 43, "priceSensitivity": 35, "digitalConsumption": 65}	{"taxTolerance": 39, "governmentTrust": 67, "policyAcceptance": 59, "regulationPreference": 50, "publicServiceSatisfaction": 75}	1
283	황서윤	58	50-59	Female	경기도	37.377992	127.520605	대학교 졸	700만원 이상	자영업	부부 가구	-6	중도 무당층	65	{"economy": -43, "housing": 35, "welfare": -13, "security": -29, "environment": 20}	SNS	{공동체,다양성,안정}	경기도에 거주하는 50-59 자영업. 정치 성향은 중도이며 공동체, 다양성, 안정 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 73, "ecoConsciousness": 58, "priceSensitivity": 54, "digitalConsumption": 56}	{"taxTolerance": 54, "governmentTrust": 33, "policyAcceptance": 48, "regulationPreference": 62, "publicServiceSatisfaction": 69}	1
284	최주원	50	50-59	Female	경기도	37.349268	127.434724	대학교 졸	350-500만원	자영업	1인 가구	-2	중도 무당층	62	{"economy": -3, "housing": 39, "welfare": 9, "security": 11, "environment": -5}	신문/팟캐스트	{성장,다양성,혁신}	경기도에 거주하는 50-59 자영업. 정치 성향은 중도이며 성장, 다양성, 혁신 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 48, "ecoConsciousness": 63, "priceSensitivity": 60, "digitalConsumption": 68}	{"taxTolerance": 68, "governmentTrust": 61, "policyAcceptance": 20, "regulationPreference": 74, "publicServiceSatisfaction": 58}	1
285	박성호	56	50-59	Female	경기도	37.424131	127.597104	고졸 이하	350-500만원	공무원	1인 가구	21	보수 성향 무당층	92	{"economy": 34, "housing": 28, "welfare": -3, "security": 0, "environment": -12}	지상파/종편 뉴스	{공동체,안전,자유}	경기도에 거주하는 50-59 공무원. 정치 성향은 중도이며 공동체, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 58, "ecoConsciousness": 44, "priceSensitivity": 74, "digitalConsumption": 76}	{"taxTolerance": 16, "governmentTrust": 44, "policyAcceptance": 42, "regulationPreference": 58, "publicServiceSatisfaction": 53}	1
286	임하은	58	50-59	Female	경기도	37.383106	127.548352	대학교 졸	500-700만원	은퇴	부부 가구	-2	중도 무당층	77	{"economy": -20, "housing": -3, "welfare": 8, "security": -8, "environment": -1}	신문/팟캐스트	{혁신,다양성,안정}	경기도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 혁신, 다양성, 안정 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 50, "ecoConsciousness": 44, "priceSensitivity": 30, "digitalConsumption": 37}	{"taxTolerance": 43, "governmentTrust": 44, "policyAcceptance": 37, "regulationPreference": 58, "publicServiceSatisfaction": 30}	1
287	장수아	58	50-59	Female	경기도	37.477166	127.570671	고졸 이하	200-350만원	공무원	부부 가구	-18	진보 성향 무당층	71	{"economy": -40, "housing": 17, "welfare": 3, "security": -2, "environment": 17}	SNS	{공정,전통,안전}	경기도에 거주하는 50-59 공무원. 정치 성향은 중도이며 공정, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 75, "ecoConsciousness": 52, "priceSensitivity": 64, "digitalConsumption": 76}	{"taxTolerance": 37, "governmentTrust": 76, "policyAcceptance": 62, "regulationPreference": 71, "publicServiceSatisfaction": 54}	1
288	정민준	53	50-59	Female	경기도	37.469704	127.517106	고졸 이하	700만원 이상	생산직	부부 가구	20	보수 성향 무당층	71	{"economy": 4, "housing": 36, "welfare": -10, "security": 23, "environment": 35}	신문/팟캐스트	{공동체,전통,공정}	경기도에 거주하는 50-59 생산직. 정치 성향은 중도이며 공동체, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 73, "ecoConsciousness": 26, "priceSensitivity": 36, "digitalConsumption": 71}	{"taxTolerance": 36, "governmentTrust": 37, "policyAcceptance": 53, "regulationPreference": 62, "publicServiceSatisfaction": 67}	1
289	안서연	55	50-59	Female	경기도	37.488456	127.435035	대학교 졸	500-700만원	생산직	1인 가구	-8	중도 무당층	89	{"economy": -24, "housing": 52, "welfare": 8, "security": 3, "environment": 32}	지상파/종편 뉴스	{환경,안전,다양성}	경기도에 거주하는 50-59 생산직. 정치 성향은 중도이며 환경, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 65, "ecoConsciousness": 49, "priceSensitivity": 63, "digitalConsumption": 70}	{"taxTolerance": 62, "governmentTrust": 44, "policyAcceptance": 42, "regulationPreference": 72, "publicServiceSatisfaction": 56}	1
290	김경숙	51	50-59	Female	경기도	37.399907	127.501372	대학교 졸	700만원 이상	생산직	1인 가구	-28	진보 성향 무당층	87	{"economy": -25, "housing": 31, "welfare": 28, "security": 7, "environment": 40}	SNS	{성장,혁신,안정}	경기도에 거주하는 50-59 생산직. 정치 성향은 중도이며 성장, 혁신, 안정 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 57, "ecoConsciousness": 60, "priceSensitivity": 30, "digitalConsumption": 89}	{"taxTolerance": 47, "governmentTrust": 42, "policyAcceptance": 50, "regulationPreference": 68, "publicServiceSatisfaction": 67}	1
291	오서윤	50	50-59	Female	경기도	37.374694	127.500913	고졸 이하	700만원 이상	프리랜서	부부 가구	56	보수 정당 지지	83	{"economy": 30, "housing": -28, "welfare": -20, "security": 35, "environment": 9}	SNS	{성장,안전,혁신}	경기도에 거주하는 50-59 프리랜서. 정치 성향은 보수이며 성장, 안전, 혁신 가치를 중시한다.	{"brandLoyalty": 71, "noveltySeeking": 51, "ecoConsciousness": 57, "priceSensitivity": 54, "digitalConsumption": 63}	{"taxTolerance": 33, "governmentTrust": 51, "policyAcceptance": 52, "regulationPreference": 60, "publicServiceSatisfaction": 51}	1
292	안수아	57	50-59	Female	경기도	37.354138	127.437389	고졸 이하	350-500만원	주부	다세대 가구	7	중도 무당층	84	{"economy": -10, "housing": 21, "welfare": 9, "security": -8, "environment": 16}	신문/팟캐스트	{공동체,다양성,전통}	경기도에 거주하는 50-59 주부. 정치 성향은 중도이며 공동체, 다양성, 전통 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 61, "ecoConsciousness": 51, "priceSensitivity": 61, "digitalConsumption": 62}	{"taxTolerance": 32, "governmentTrust": 56, "policyAcceptance": 30, "regulationPreference": 58, "publicServiceSatisfaction": 56}	1
293	장수아	53	50-59	Male	경기도	37.4796	127.541351	대학원 졸	200-350만원	주부	1인 가구	25	보수 성향 무당층	74	{"economy": -1, "housing": 1, "welfare": -23, "security": 25, "environment": 46}	신문/팟캐스트	{안정,혁신,자유}	경기도에 거주하는 50-59 주부. 정치 성향은 중도이며 안정, 혁신, 자유 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 65, "ecoConsciousness": 33, "priceSensitivity": 77, "digitalConsumption": 60}	{"taxTolerance": 50, "governmentTrust": 52, "policyAcceptance": 37, "regulationPreference": 64, "publicServiceSatisfaction": 61}	1
294	김영수	50	50-59	Male	경기도	37.403499	127.557049	전문대 졸	500-700만원	전문직	1인 가구	-13	중도 무당층	76	{"economy": -35, "housing": 6, "welfare": 31, "security": -14, "environment": 43}	포털 뉴스	{공정,전통,다양성}	경기도에 거주하는 50-59 전문직. 정치 성향은 중도이며 공정, 전통, 다양성 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 56, "ecoConsciousness": 45, "priceSensitivity": 46, "digitalConsumption": 75}	{"taxTolerance": 34, "governmentTrust": 41, "policyAcceptance": 48, "regulationPreference": 52, "publicServiceSatisfaction": 61}	1
295	홍유준	53	50-59	Male	경기도	37.455968	127.607699	대학교 졸	700만원 이상	사무직	다세대 가구	-11	중도 무당층	83	{"economy": 0, "housing": 31, "welfare": 10, "security": 16, "environment": 24}	지상파/종편 뉴스	{안전,공정,환경}	경기도에 거주하는 50-59 사무직. 정치 성향은 중도이며 안전, 공정, 환경 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 67, "ecoConsciousness": 71, "priceSensitivity": 53, "digitalConsumption": 70}	{"taxTolerance": 42, "governmentTrust": 57, "policyAcceptance": 42, "regulationPreference": 63, "publicServiceSatisfaction": 58}	1
296	황지우	59	50-59	Male	경기도	37.440041	127.575794	전문대 졸	500-700만원	은퇴	1인 가구	51	보수 정당 지지	59	{"economy": 69, "housing": 12, "welfare": -11, "security": 24, "environment": -6}	지상파/종편 뉴스	{전통,안정,공정}	경기도에 거주하는 50-59 은퇴. 정치 성향은 보수이며 전통, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 49, "ecoConsciousness": 65, "priceSensitivity": 61, "digitalConsumption": 68}	{"taxTolerance": 49, "governmentTrust": 52, "policyAcceptance": 70, "regulationPreference": 55, "publicServiceSatisfaction": 69}	1
297	윤정희	56	50-59	Male	경기도	37.388223	127.564985	대학교 졸	700만원 이상	전문직	자녀 양육 가구	-18	진보 성향 무당층	63	{"economy": -20, "housing": 27, "welfare": 27, "security": -12, "environment": 48}	유튜브	{전통,성장,공동체}	경기도에 거주하는 50-59 전문직. 정치 성향은 중도이며 전통, 성장, 공동체 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 51, "ecoConsciousness": 70, "priceSensitivity": 48, "digitalConsumption": 53}	{"taxTolerance": 66, "governmentTrust": 36, "policyAcceptance": 58, "regulationPreference": 100, "publicServiceSatisfaction": 72}	1
298	안유준	58	50-59	Male	경기도	37.352547	127.557133	대학교 졸	500-700만원	자영업	부부 가구	-2	중도 무당층	87	{"economy": -32, "housing": 9, "welfare": 24, "security": -4, "environment": 6}	지상파/종편 뉴스	{혁신,자유,환경}	경기도에 거주하는 50-59 자영업. 정치 성향은 중도이며 혁신, 자유, 환경 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 51, "ecoConsciousness": 49, "priceSensitivity": 52, "digitalConsumption": 73}	{"taxTolerance": 51, "governmentTrust": 47, "policyAcceptance": 41, "regulationPreference": 58, "publicServiceSatisfaction": 64}	1
299	강정희	51	50-59	Male	경기도	37.451412	127.469382	대학원 졸	700만원 이상	프리랜서	1인 가구	12	중도 무당층	70	{"economy": -7, "housing": -6, "welfare": -4, "security": 0, "environment": -7}	SNS	{전통,안전,성장}	경기도에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 전통, 안전, 성장 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 59, "ecoConsciousness": 53, "priceSensitivity": 36, "digitalConsumption": 49}	{"taxTolerance": 63, "governmentTrust": 53, "policyAcceptance": 47, "regulationPreference": 71, "publicServiceSatisfaction": 61}	1
300	류동현	56	50-59	Male	경기도	37.447592	127.563734	전문대 졸	500-700만원	자영업	부부 가구	28	보수 성향 무당층	70	{"economy": 36, "housing": 18, "welfare": 10, "security": -4, "environment": 21}	SNS	{전통,다양성,공동체}	경기도에 거주하는 50-59 자영업. 정치 성향은 중도이며 전통, 다양성, 공동체 가치를 중시한다.	{"brandLoyalty": 74, "noveltySeeking": 53, "ecoConsciousness": 45, "priceSensitivity": 32, "digitalConsumption": 64}	{"taxTolerance": 56, "governmentTrust": 53, "policyAcceptance": 50, "regulationPreference": 76, "publicServiceSatisfaction": 70}	1
301	송철수	57	50-59	Male	경기도	37.450236	127.539523	전문대 졸	700만원 이상	사무직	자녀 양육 가구	1	중도 무당층	60	{"economy": -3, "housing": 40, "welfare": -6, "security": 27, "environment": 26}	SNS	{환경,혁신,안전}	경기도에 거주하는 50-59 사무직. 정치 성향은 중도이며 환경, 혁신, 안전 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 57, "ecoConsciousness": 53, "priceSensitivity": 42, "digitalConsumption": 65}	{"taxTolerance": 38, "governmentTrust": 54, "policyAcceptance": 55, "regulationPreference": 61, "publicServiceSatisfaction": 50}	1
302	윤주원	57	50-59	Male	경기도	37.440132	127.466694	전문대 졸	350-500만원	프리랜서	부부 가구	12	중도 무당층	65	{"economy": 25, "housing": -9, "welfare": -18, "security": 5, "environment": 18}	유튜브	{환경,혁신,성장}	경기도에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 환경, 혁신, 성장 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 52, "ecoConsciousness": 54, "priceSensitivity": 69, "digitalConsumption": 60}	{"taxTolerance": 41, "governmentTrust": 45, "policyAcceptance": 48, "regulationPreference": 54, "publicServiceSatisfaction": 54}	1
303	정지우	53	50-59	Male	경기도	37.454501	127.574831	대학교 졸	500-700만원	서비스직	부부 가구	-17	진보 성향 무당층	74	{"economy": -28, "housing": 44, "welfare": -10, "security": -11, "environment": 6}	SNS	{전통,다양성,안정}	경기도에 거주하는 50-59 서비스직. 정치 성향은 중도이며 전통, 다양성, 안정 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 60, "ecoConsciousness": 65, "priceSensitivity": 55, "digitalConsumption": 77}	{"taxTolerance": 41, "governmentTrust": 63, "policyAcceptance": 23, "regulationPreference": 60, "publicServiceSatisfaction": 69}	1
304	신민준	57	50-59	Male	경기도	37.49066	127.562694	대학교 졸	500-700만원	서비스직	1인 가구	39	보수 성향 무당층	78	{"economy": 31, "housing": 7, "welfare": 15, "security": 21, "environment": -8}	SNS	{환경,성장,자유}	경기도에 거주하는 50-59 서비스직. 정치 성향은 보수이며 환경, 성장, 자유 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 69, "ecoConsciousness": 75, "priceSensitivity": 61, "digitalConsumption": 83}	{"taxTolerance": 48, "governmentTrust": 42, "policyAcceptance": 55, "regulationPreference": 61, "publicServiceSatisfaction": 50}	1
305	황다은	52	50-59	Male	경기도	37.456468	127.579574	전문대 졸	350-500만원	생산직	부부 가구	14	중도 무당층	76	{"economy": -6, "housing": 29, "welfare": -2, "security": -6, "environment": 0}	포털 뉴스	{안전,다양성,공정}	경기도에 거주하는 50-59 생산직. 정치 성향은 중도이며 안전, 다양성, 공정 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 60, "ecoConsciousness": 50, "priceSensitivity": 89, "digitalConsumption": 66}	{"taxTolerance": 50, "governmentTrust": 49, "policyAcceptance": 43, "regulationPreference": 57, "publicServiceSatisfaction": 66}	1
306	강정희	62	60-69	Female	경기도	37.381678	127.497198	대학원 졸	200만원 미만	전문직	1인 가구	5	중도 무당층	63	{"economy": 4, "housing": 19, "welfare": 18, "security": 18, "environment": 4}	포털 뉴스	{전통,공동체,자유}	경기도에 거주하는 60-69 전문직. 정치 성향은 중도이며 전통, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 72, "noveltySeeking": 45, "ecoConsciousness": 64, "priceSensitivity": 94, "digitalConsumption": 59}	{"taxTolerance": 72, "governmentTrust": 50, "policyAcceptance": 53, "regulationPreference": 74, "publicServiceSatisfaction": 65}	1
307	박은우	66	60-69	Female	경기도	37.450264	127.568155	전문대 졸	350-500만원	자영업	다세대 가구	49	보수 정당 지지	87	{"economy": 6, "housing": -1, "welfare": -26, "security": 45, "environment": 2}	지상파/종편 뉴스	{전통,환경,공동체}	경기도에 거주하는 60-69 자영업. 정치 성향은 보수이며 전통, 환경, 공동체 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 65, "ecoConsciousness": 60, "priceSensitivity": 68, "digitalConsumption": 81}	{"taxTolerance": 65, "governmentTrust": 72, "policyAcceptance": 69, "regulationPreference": 64, "publicServiceSatisfaction": 74}	1
308	신경숙	67	60-69	Female	경기도	37.477558	127.492562	대학원 졸	500-700만원	은퇴	자녀 양육 가구	-2	중도 무당층	74	{"economy": 27, "housing": 8, "welfare": 25, "security": 1, "environment": 30}	SNS	{다양성,안전,혁신}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 다양성, 안전, 혁신 가치를 중시한다.	{"brandLoyalty": 70, "noveltySeeking": 42, "ecoConsciousness": 53, "priceSensitivity": 47, "digitalConsumption": 72}	{"taxTolerance": 42, "governmentTrust": 43, "policyAcceptance": 56, "regulationPreference": 70, "publicServiceSatisfaction": 70}	1
309	서지우	63	60-69	Female	경기도	37.393752	127.465248	고졸 이하	500-700만원	공무원	자녀 양육 가구	8	중도 무당층	65	{"economy": 6, "housing": 14, "welfare": 17, "security": 7, "environment": 32}	SNS	{전통,안정,혁신}	경기도에 거주하는 60-69 공무원. 정치 성향은 중도이며 전통, 안정, 혁신 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 54, "ecoConsciousness": 45, "priceSensitivity": 42, "digitalConsumption": 77}	{"taxTolerance": 22, "governmentTrust": 70, "policyAcceptance": 59, "regulationPreference": 60, "publicServiceSatisfaction": 75}	1
310	권서연	60	60-69	Female	경기도	37.371649	127.516712	고졸 이하	350-500만원	자영업	다세대 가구	-12	중도 무당층	80	{"economy": -23, "housing": 23, "welfare": 14, "security": -16, "environment": 8}	유튜브	{공동체,안전,공정}	경기도에 거주하는 60-69 자영업. 정치 성향은 중도이며 공동체, 안전, 공정 가치를 중시한다.	{"brandLoyalty": 63, "noveltySeeking": 33, "ecoConsciousness": 47, "priceSensitivity": 67, "digitalConsumption": 64}	{"taxTolerance": 39, "governmentTrust": 40, "policyAcceptance": 46, "regulationPreference": 29, "publicServiceSatisfaction": 46}	1
311	송성호	66	60-69	Female	경기도	37.416009	127.453621	대학원 졸	200-350만원	자영업	다세대 가구	5	중도 무당층	75	{"economy": -3, "housing": -5, "welfare": 11, "security": 19, "environment": 14}	SNS	{공동체,전통,성장}	경기도에 거주하는 60-69 자영업. 정치 성향은 중도이며 공동체, 전통, 성장 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 77, "ecoConsciousness": 56, "priceSensitivity": 53, "digitalConsumption": 63}	{"taxTolerance": 37, "governmentTrust": 50, "policyAcceptance": 43, "regulationPreference": 69, "publicServiceSatisfaction": 66}	1
312	임지호	67	60-69	Female	경기도	37.387552	127.511996	전문대 졸	350-500만원	은퇴	부부 가구	37	보수 성향 무당층	49	{"economy": 36, "housing": -6, "welfare": -18, "security": 25, "environment": -3}	포털 뉴스	{공동체,안정,공정}	경기도에 거주하는 60-69 은퇴. 정치 성향은 보수이며 공동체, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 73, "ecoConsciousness": 63, "priceSensitivity": 75, "digitalConsumption": 77}	{"taxTolerance": 50, "governmentTrust": 49, "policyAcceptance": 70, "regulationPreference": 57, "publicServiceSatisfaction": 65}	1
313	임미경	62	60-69	Female	경기도	37.385387	127.496382	대학교 졸	350-500만원	생산직	자녀 양육 가구	-9	중도 무당층	56	{"economy": -16, "housing": 18, "welfare": 19, "security": -2, "environment": 35}	신문/팟캐스트	{혁신,성장,환경}	경기도에 거주하는 60-69 생산직. 정치 성향은 중도이며 혁신, 성장, 환경 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 46, "ecoConsciousness": 60, "priceSensitivity": 55, "digitalConsumption": 71}	{"taxTolerance": 32, "governmentTrust": 56, "policyAcceptance": 35, "regulationPreference": 62, "publicServiceSatisfaction": 69}	1
314	황예준	61	60-69	Female	경기도	37.382753	127.607501	대학원 졸	200만원 미만	은퇴	1인 가구	-17	진보 성향 무당층	83	{"economy": -3, "housing": 42, "welfare": 0, "security": 22, "environment": 36}	SNS	{다양성,전통,자유}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 다양성, 전통, 자유 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 61, "ecoConsciousness": 64, "priceSensitivity": 92, "digitalConsumption": 61}	{"taxTolerance": 48, "governmentTrust": 39, "policyAcceptance": 55, "regulationPreference": 67, "publicServiceSatisfaction": 60}	1
315	오민준	65	60-69	Female	경기도	37.42563	127.50421	전문대 졸	200-350만원	프리랜서	1인 가구	-9	중도 무당층	74	{"economy": -19, "housing": 19, "welfare": 2, "security": -12, "environment": 17}	유튜브	{환경,다양성,안전}	경기도에 거주하는 60-69 프리랜서. 정치 성향은 중도이며 환경, 다양성, 안전 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 62, "ecoConsciousness": 48, "priceSensitivity": 63, "digitalConsumption": 60}	{"taxTolerance": 39, "governmentTrust": 43, "policyAcceptance": 51, "regulationPreference": 66, "publicServiceSatisfaction": 59}	1
316	송수아	62	60-69	Female	경기도	37.493573	127.421332	전문대 졸	350-500만원	공무원	자녀 양육 가구	46	보수 정당 지지	72	{"economy": 37, "housing": 12, "welfare": 11, "security": 25, "environment": 12}	SNS	{공동체,전통,안전}	경기도에 거주하는 60-69 공무원. 정치 성향은 보수이며 공동체, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 53, "ecoConsciousness": 54, "priceSensitivity": 69, "digitalConsumption": 53}	{"taxTolerance": 48, "governmentTrust": 46, "policyAcceptance": 37, "regulationPreference": 75, "publicServiceSatisfaction": 68}	1
317	한현우	62	60-69	Male	경기도	37.388444	127.425735	고졸 이하	700만원 이상	학생	부부 가구	38	보수 성향 무당층	76	{"economy": 33, "housing": -4, "welfare": -3, "security": 17, "environment": 0}	신문/팟캐스트	{전통,혁신,공정}	경기도에 거주하는 60-69 학생. 정치 성향은 보수이며 전통, 혁신, 공정 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 49, "ecoConsciousness": 43, "priceSensitivity": 46, "digitalConsumption": 71}	{"taxTolerance": 44, "governmentTrust": 65, "policyAcceptance": 56, "regulationPreference": 51, "publicServiceSatisfaction": 71}	1
318	최지호	60	60-69	Male	경기도	37.403574	127.60865	대학교 졸	700만원 이상	사무직	부부 가구	2	중도 무당층	63	{"economy": -9, "housing": 22, "welfare": -16, "security": -5, "environment": 30}	SNS	{전통,자유,성장}	경기도에 거주하는 60-69 사무직. 정치 성향은 중도이며 전통, 자유, 성장 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 52, "ecoConsciousness": 47, "priceSensitivity": 63, "digitalConsumption": 97}	{"taxTolerance": 55, "governmentTrust": 55, "policyAcceptance": 44, "regulationPreference": 79, "publicServiceSatisfaction": 76}	1
319	신유준	69	60-69	Male	경기도	37.340043	127.419329	대학원 졸	500-700만원	은퇴	부부 가구	57	보수 정당 지지	85	{"economy": 27, "housing": 11, "welfare": -12, "security": 27, "environment": -42}	신문/팟캐스트	{공동체,자유,다양성}	경기도에 거주하는 60-69 은퇴. 정치 성향은 보수이며 공동체, 자유, 다양성 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 66, "ecoConsciousness": 60, "priceSensitivity": 75, "digitalConsumption": 56}	{"taxTolerance": 61, "governmentTrust": 34, "policyAcceptance": 62, "regulationPreference": 70, "publicServiceSatisfaction": 61}	1
320	박광수	67	60-69	Male	경기도	37.387338	127.608194	대학원 졸	350-500만원	은퇴	1인 가구	33	보수 성향 무당층	88	{"economy": 23, "housing": 21, "welfare": -3, "security": 31, "environment": 21}	지상파/종편 뉴스	{성장,공동체,안전}	경기도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 성장, 공동체, 안전 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 59, "ecoConsciousness": 71, "priceSensitivity": 72, "digitalConsumption": 57}	{"taxTolerance": 49, "governmentTrust": 40, "policyAcceptance": 44, "regulationPreference": 62, "publicServiceSatisfaction": 65}	1
321	권동현	60	60-69	Male	경기도	37.486268	127.533694	대학교 졸	700만원 이상	주부	부부 가구	32	보수 성향 무당층	60	{"economy": 13, "housing": 15, "welfare": -2, "security": 35, "environment": 31}	포털 뉴스	{혁신,성장,안정}	경기도에 거주하는 60-69 주부. 정치 성향은 중도이며 혁신, 성장, 안정 가치를 중시한다.	{"brandLoyalty": 83, "noveltySeeking": 59, "ecoConsciousness": 41, "priceSensitivity": 48, "digitalConsumption": 51}	{"taxTolerance": 75, "governmentTrust": 50, "policyAcceptance": 48, "regulationPreference": 61, "publicServiceSatisfaction": 54}	1
322	최유준	64	60-69	Male	경기도	37.37886	127.5853	대학원 졸	200-350만원	학생	부부 가구	2	중도 무당층	81	{"economy": -34, "housing": -2, "welfare": -5, "security": 20, "environment": 23}	포털 뉴스	{전통,환경,안정}	경기도에 거주하는 60-69 학생. 정치 성향은 중도이며 전통, 환경, 안정 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 55, "ecoConsciousness": 43, "priceSensitivity": 64, "digitalConsumption": 59}	{"taxTolerance": 57, "governmentTrust": 39, "policyAcceptance": 44, "regulationPreference": 72, "publicServiceSatisfaction": 58}	1
323	김채원	64	60-69	Male	경기도	37.476854	127.506659	대학원 졸	200-350만원	주부	자녀 양육 가구	19	보수 성향 무당층	93	{"economy": -2, "housing": -24, "welfare": -32, "security": -2, "environment": 25}	SNS	{다양성,안전,전통}	경기도에 거주하는 60-69 주부. 정치 성향은 중도이며 다양성, 안전, 전통 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 32, "ecoConsciousness": 72, "priceSensitivity": 80, "digitalConsumption": 66}	{"taxTolerance": 52, "governmentTrust": 58, "policyAcceptance": 44, "regulationPreference": 64, "publicServiceSatisfaction": 76}	1
324	김도윤	64	60-69	Male	경기도	37.430361	127.541827	대학교 졸	500-700만원	사무직	1인 가구	-22	진보 성향 무당층	87	{"economy": -21, "housing": 6, "welfare": 26, "security": -5, "environment": 30}	유튜브	{다양성,안전,전통}	경기도에 거주하는 60-69 사무직. 정치 성향은 중도이며 다양성, 안전, 전통 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 55, "ecoConsciousness": 65, "priceSensitivity": 48, "digitalConsumption": 65}	{"taxTolerance": 51, "governmentTrust": 53, "policyAcceptance": 65, "regulationPreference": 54, "publicServiceSatisfaction": 55}	1
325	정경숙	65	60-69	Male	경기도	37.427859	127.463111	전문대 졸	350-500만원	학생	다세대 가구	32	보수 성향 무당층	84	{"economy": 7, "housing": 8, "welfare": -6, "security": 39, "environment": -9}	유튜브	{성장,안전,공동체}	경기도에 거주하는 60-69 학생. 정치 성향은 중도이며 성장, 안전, 공동체 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 58, "ecoConsciousness": 54, "priceSensitivity": 52, "digitalConsumption": 65}	{"taxTolerance": 39, "governmentTrust": 51, "policyAcceptance": 62, "regulationPreference": 83, "publicServiceSatisfaction": 71}	1
326	안수아	61	60-69	Male	경기도	37.443527	127.445515	전문대 졸	350-500만원	사무직	1인 가구	-6	중도 무당층	62	{"economy": -1, "housing": 15, "welfare": 16, "security": -39, "environment": 20}	신문/팟캐스트	{혁신,다양성,성장}	경기도에 거주하는 60-69 사무직. 정치 성향은 중도이며 혁신, 다양성, 성장 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 60, "ecoConsciousness": 42, "priceSensitivity": 76, "digitalConsumption": 58}	{"taxTolerance": 61, "governmentTrust": 64, "policyAcceptance": 60, "regulationPreference": 51, "publicServiceSatisfaction": 60}	1
327	홍민준	60	60-69	Male	경기도	37.437713	127.494936	전문대 졸	200-350만원	주부	부부 가구	-2	중도 무당층	77	{"economy": 34, "housing": 2, "welfare": -4, "security": 29, "environment": 6}	지상파/종편 뉴스	{공정,자유,다양성}	경기도에 거주하는 60-69 주부. 정치 성향은 중도이며 공정, 자유, 다양성 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 66, "ecoConsciousness": 65, "priceSensitivity": 68, "digitalConsumption": 62}	{"taxTolerance": 51, "governmentTrust": 55, "policyAcceptance": 63, "regulationPreference": 52, "publicServiceSatisfaction": 57}	1
328	홍수아	79	70+	Female	경기도	37.403894	127.607259	대학원 졸	500-700만원	은퇴	1인 가구	41	보수 성향 무당층	93	{"economy": 18, "housing": -27, "welfare": 0, "security": 14, "environment": 15}	유튜브	{성장,안전,안정}	경기도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 성장, 안전, 안정 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 62, "ecoConsciousness": 58, "priceSensitivity": 59, "digitalConsumption": 64}	{"taxTolerance": 48, "governmentTrust": 59, "policyAcceptance": 45, "regulationPreference": 73, "publicServiceSatisfaction": 62}	1
329	황도윤	78	70+	Female	경기도	37.389959	127.553731	고졸 이하	200-350만원	은퇴	자녀 양육 가구	43	보수 성향 무당층	99	{"economy": 3, "housing": -9, "welfare": -42, "security": 41, "environment": -3}	신문/팟캐스트	{성장,공정,환경}	경기도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 성장, 공정, 환경 가치를 중시한다.	{"brandLoyalty": 67, "noveltySeeking": 42, "ecoConsciousness": 41, "priceSensitivity": 96, "digitalConsumption": 53}	{"taxTolerance": 55, "governmentTrust": 46, "policyAcceptance": 61, "regulationPreference": 75, "publicServiceSatisfaction": 91}	1
330	한지우	72	70+	Female	경기도	37.402748	127.490619	대학원 졸	200만원 미만	은퇴	자녀 양육 가구	26	보수 성향 무당층	77	{"economy": -15, "housing": 36, "welfare": 7, "security": 22, "environment": 17}	신문/팟캐스트	{성장,다양성,공동체}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 성장, 다양성, 공동체 가치를 중시한다.	{"brandLoyalty": 68, "noveltySeeking": 63, "ecoConsciousness": 54, "priceSensitivity": 82, "digitalConsumption": 64}	{"taxTolerance": 46, "governmentTrust": 56, "policyAcceptance": 64, "regulationPreference": 69, "publicServiceSatisfaction": 52}	1
331	한민준	72	70+	Female	경기도	37.343725	127.569076	대학원 졸	200-350만원	은퇴	부부 가구	43	보수 성향 무당층	81	{"economy": 26, "housing": 0, "welfare": -20, "security": 27, "environment": 6}	유튜브	{성장,다양성,자유}	경기도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 성장, 다양성, 자유 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 66, "ecoConsciousness": 38, "priceSensitivity": 87, "digitalConsumption": 71}	{"taxTolerance": 53, "governmentTrust": 58, "policyAcceptance": 62, "regulationPreference": 57, "publicServiceSatisfaction": 60}	1
332	권다은	75	70+	Female	경기도	37.454856	127.555243	대학원 졸	200만원 미만	은퇴	다세대 가구	-36	진보 성향 무당층	94	{"economy": -11, "housing": 38, "welfare": 41, "security": -10, "environment": 30}	유튜브	{전통,성장,안정}	경기도에 거주하는 70+ 은퇴. 정치 성향은 진보이며 전통, 성장, 안정 가치를 중시한다.	{"brandLoyalty": 70, "noveltySeeking": 59, "ecoConsciousness": 47, "priceSensitivity": 80, "digitalConsumption": 61}	{"taxTolerance": 29, "governmentTrust": 37, "policyAcceptance": 55, "regulationPreference": 59, "publicServiceSatisfaction": 45}	1
333	임예준	80	70+	Female	경기도	37.477235	127.512968	대학원 졸	500-700만원	은퇴	1인 가구	45	보수 정당 지지	80	{"economy": 23, "housing": 25, "welfare": -14, "security": 15, "environment": 18}	포털 뉴스	{안전,공정,환경}	경기도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안전, 공정, 환경 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 61, "ecoConsciousness": 43, "priceSensitivity": 54, "digitalConsumption": 33}	{"taxTolerance": 68, "governmentTrust": 48, "policyAcceptance": 45, "regulationPreference": 67, "publicServiceSatisfaction": 68}	1
334	정정희	78	70+	Female	경기도	37.412802	127.567924	전문대 졸	200-350만원	은퇴	1인 가구	3	중도 무당층	87	{"economy": 0, "housing": 15, "welfare": 15, "security": 16, "environment": 15}	유튜브	{환경,공동체,자유}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 환경, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 63, "noveltySeeking": 27, "ecoConsciousness": 52, "priceSensitivity": 83, "digitalConsumption": 38}	{"taxTolerance": 36, "governmentTrust": 55, "policyAcceptance": 55, "regulationPreference": 50, "publicServiceSatisfaction": 40}	1
335	송도윤	74	70+	Female	경기도	37.444982	127.505016	고졸 이하	350-500만원	은퇴	부부 가구	14	중도 무당층	99	{"economy": -21, "housing": 9, "welfare": 6, "security": -2, "environment": 17}	지상파/종편 뉴스	{공정,자유,성장}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공정, 자유, 성장 가치를 중시한다.	{"brandLoyalty": 60, "noveltySeeking": 46, "ecoConsciousness": 50, "priceSensitivity": 50, "digitalConsumption": 70}	{"taxTolerance": 47, "governmentTrust": 59, "policyAcceptance": 49, "regulationPreference": 47, "publicServiceSatisfaction": 73}	1
336	김서연	78	70+	Female	경기도	37.40049	127.517673	대학원 졸	200-350만원	은퇴	1인 가구	32	보수 성향 무당층	87	{"economy": 13, "housing": 4, "welfare": 3, "security": 28, "environment": 13}	신문/팟캐스트	{공정,성장,공동체}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공정, 성장, 공동체 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 74, "ecoConsciousness": 72, "priceSensitivity": 76, "digitalConsumption": 56}	{"taxTolerance": 52, "governmentTrust": 42, "policyAcceptance": 66, "regulationPreference": 56, "publicServiceSatisfaction": 66}	1
337	조지우	82	70+	Male	경기도	37.40709	127.554723	대학교 졸	500-700만원	은퇴	부부 가구	46	보수 정당 지지	86	{"economy": 24, "housing": 5, "welfare": 5, "security": 30, "environment": 25}	SNS	{다양성,안전,안정}	경기도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 다양성, 안전, 안정 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 29, "ecoConsciousness": 47, "priceSensitivity": 67, "digitalConsumption": 48}	{"taxTolerance": 27, "governmentTrust": 63, "policyAcceptance": 56, "regulationPreference": 60, "publicServiceSatisfaction": 53}	1
338	조은우	78	70+	Male	경기도	37.411242	127.614559	대학교 졸	350-500만원	은퇴	부부 가구	67	보수 정당 지지	69	{"economy": 81, "housing": -5, "welfare": -17, "security": 62, "environment": -9}	지상파/종편 뉴스	{전통,환경,다양성}	경기도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 전통, 환경, 다양성 가치를 중시한다.	{"brandLoyalty": 57, "noveltySeeking": 59, "ecoConsciousness": 67, "priceSensitivity": 50, "digitalConsumption": 68}	{"taxTolerance": 54, "governmentTrust": 46, "policyAcceptance": 51, "regulationPreference": 76, "publicServiceSatisfaction": 60}	1
339	한예준	82	70+	Male	경기도	37.475922	127.588839	대학원 졸	350-500만원	은퇴	부부 가구	52	보수 정당 지지	96	{"economy": 19, "housing": 18, "welfare": -39, "security": 35, "environment": -5}	포털 뉴스	{혁신,다양성,환경}	경기도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 혁신, 다양성, 환경 가치를 중시한다.	{"brandLoyalty": 84, "noveltySeeking": 38, "ecoConsciousness": 35, "priceSensitivity": 61, "digitalConsumption": 43}	{"taxTolerance": 66, "governmentTrust": 39, "policyAcceptance": 31, "regulationPreference": 66, "publicServiceSatisfaction": 65}	1
340	윤지호	72	70+	Male	경기도	37.403571	127.608352	전문대 졸	500-700만원	은퇴	1인 가구	29	보수 성향 무당층	78	{"economy": 10, "housing": 12, "welfare": -18, "security": 55, "environment": 0}	신문/팟캐스트	{다양성,자유,공동체}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 다양성, 자유, 공동체 가치를 중시한다.	{"brandLoyalty": 60, "noveltySeeking": 57, "ecoConsciousness": 51, "priceSensitivity": 80, "digitalConsumption": 58}	{"taxTolerance": 33, "governmentTrust": 54, "policyAcceptance": 38, "regulationPreference": 70, "publicServiceSatisfaction": 65}	1
341	최민준	79	70+	Male	경기도	37.386044	127.525003	대학원 졸	500-700만원	은퇴	다세대 가구	55	보수 정당 지지	95	{"economy": 9, "housing": -25, "welfare": -24, "security": 36, "environment": -5}	유튜브	{자유,전통,안정}	경기도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 자유, 전통, 안정 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 45, "ecoConsciousness": 25, "priceSensitivity": 72, "digitalConsumption": 60}	{"taxTolerance": 33, "governmentTrust": 35, "policyAcceptance": 59, "regulationPreference": 69, "publicServiceSatisfaction": 64}	1
342	서정희	74	70+	Male	경기도	37.355948	127.610236	고졸 이하	350-500만원	은퇴	다세대 가구	-28	진보 성향 무당층	88	{"economy": -52, "housing": 46, "welfare": 0, "security": -4, "environment": 42}	유튜브	{환경,공동체,혁신}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 환경, 공동체, 혁신 가치를 중시한다.	{"brandLoyalty": 60, "noveltySeeking": 40, "ecoConsciousness": 50, "priceSensitivity": 69, "digitalConsumption": 53}	{"taxTolerance": 39, "governmentTrust": 51, "policyAcceptance": 65, "regulationPreference": 74, "publicServiceSatisfaction": 67}	1
343	최지민	84	70+	Male	경기도	37.429267	127.486082	고졸 이하	200-350만원	은퇴	다세대 가구	14	중도 무당층	83	{"economy": 23, "housing": -11, "welfare": 3, "security": 34, "environment": 11}	지상파/종편 뉴스	{공동체,다양성,혁신}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공동체, 다양성, 혁신 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 15, "ecoConsciousness": 37, "priceSensitivity": 91, "digitalConsumption": 68}	{"taxTolerance": 26, "governmentTrust": 52, "policyAcceptance": 65, "regulationPreference": 61, "publicServiceSatisfaction": 65}	1
344	황지아	70	70+	Male	경기도	37.482531	127.445635	대학원 졸	350-500만원	은퇴	1인 가구	27	보수 성향 무당층	92	{"economy": 3, "housing": 10, "welfare": 1, "security": 3, "environment": -13}	포털 뉴스	{자유,공동체,공정}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 자유, 공동체, 공정 가치를 중시한다.	{"brandLoyalty": 63, "noveltySeeking": 60, "ecoConsciousness": 63, "priceSensitivity": 59, "digitalConsumption": 54}	{"taxTolerance": 34, "governmentTrust": 63, "policyAcceptance": 37, "regulationPreference": 61, "publicServiceSatisfaction": 68}	1
345	임서연	82	70+	Male	경기도	37.490085	127.505687	대학원 졸	200-350만원	은퇴	1인 가구	8	중도 무당층	96	{"economy": -10, "housing": 5, "welfare": 13, "security": 8, "environment": 0}	유튜브	{다양성,자유,혁신}	경기도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 다양성, 자유, 혁신 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 39, "ecoConsciousness": 55, "priceSensitivity": 78, "digitalConsumption": 55}	{"taxTolerance": 58, "governmentTrust": 39, "policyAcceptance": 34, "regulationPreference": 68, "publicServiceSatisfaction": 77}	1
346	정현우	27	18-29	Female	충청북도	36.679739	127.511732	대학원 졸	200만원 미만	전문직	부부 가구	-32	진보 성향 무당층	36	{"economy": -45, "housing": 37, "welfare": 21, "security": 10, "environment": 35}	SNS	{공정,공동체,안전}	충청북도에 거주하는 18-29 전문직. 정치 성향은 중도이며 공정, 공동체, 안전 가치를 중시한다.	{"brandLoyalty": 26, "noveltySeeking": 80, "ecoConsciousness": 48, "priceSensitivity": 90, "digitalConsumption": 91}	{"taxTolerance": 45, "governmentTrust": 59, "policyAcceptance": 40, "regulationPreference": 57, "publicServiceSatisfaction": 54}	1
347	윤미경	21	18-29	Male	충청북도	36.606262	127.547589	대학교 졸	500-700만원	프리랜서	자녀 양육 가구	-29	진보 성향 무당층	45	{"economy": -17, "housing": 25, "welfare": 40, "security": -5, "environment": 31}	유튜브	{성장,자유,다양성}	충청북도에 거주하는 18-29 프리랜서. 정치 성향은 중도이며 성장, 자유, 다양성 가치를 중시한다.	{"brandLoyalty": 61, "noveltySeeking": 72, "ecoConsciousness": 41, "priceSensitivity": 48, "digitalConsumption": 88}	{"taxTolerance": 59, "governmentTrust": 28, "policyAcceptance": 50, "regulationPreference": 56, "publicServiceSatisfaction": 71}	1
348	안유준	30	30-39	Female	충청북도	36.708745	127.427682	대학교 졸	200-350만원	은퇴	부부 가구	24	보수 성향 무당층	66	{"economy": -20, "housing": -6, "welfare": -4, "security": 14, "environment": -5}	SNS	{환경,성장,자유}	충청북도에 거주하는 30-39 은퇴. 정치 성향은 중도이며 환경, 성장, 자유 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 67, "ecoConsciousness": 72, "priceSensitivity": 58, "digitalConsumption": 88}	{"taxTolerance": 59, "governmentTrust": 55, "policyAcceptance": 35, "regulationPreference": 43, "publicServiceSatisfaction": 65}	1
349	신하은	32	30-39	Male	충청북도	36.591121	127.399519	전문대 졸	350-500만원	전문직	자녀 양육 가구	-6	중도 무당층	48	{"economy": -36, "housing": -6, "welfare": -1, "security": 7, "environment": 8}	지상파/종편 뉴스	{전통,안전,공동체}	충청북도에 거주하는 30-39 전문직. 정치 성향은 중도이며 전통, 안전, 공동체 가치를 중시한다.	{"brandLoyalty": 17, "noveltySeeking": 67, "ecoConsciousness": 53, "priceSensitivity": 70, "digitalConsumption": 81}	{"taxTolerance": 65, "governmentTrust": 46, "policyAcceptance": 44, "regulationPreference": 89, "publicServiceSatisfaction": 66}	1
350	조지호	48	40-49	Female	충청북도	36.570996	127.505022	전문대 졸	700만원 이상	사무직	다세대 가구	-26	진보 성향 무당층	31	{"economy": -11, "housing": 0, "welfare": -3, "security": -18, "environment": 51}	신문/팟캐스트	{자유,전통,공정}	충청북도에 거주하는 40-49 사무직. 정치 성향은 중도이며 자유, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 61, "ecoConsciousness": 75, "priceSensitivity": 67, "digitalConsumption": 88}	{"taxTolerance": 36, "governmentTrust": 45, "policyAcceptance": 45, "regulationPreference": 72, "publicServiceSatisfaction": 88}	1
351	강영수	48	40-49	Male	충청북도	36.622531	127.55863	대학원 졸	500-700만원	전문직	다세대 가구	17	보수 성향 무당층	82	{"economy": 5, "housing": 27, "welfare": 0, "security": 2, "environment": 11}	유튜브	{안전,성장,다양성}	충청북도에 거주하는 40-49 전문직. 정치 성향은 중도이며 안전, 성장, 다양성 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 61, "ecoConsciousness": 58, "priceSensitivity": 53, "digitalConsumption": 74}	{"taxTolerance": 63, "governmentTrust": 53, "policyAcceptance": 50, "regulationPreference": 50, "publicServiceSatisfaction": 58}	1
352	이민서	52	50-59	Female	충청북도	36.669961	127.425936	대학교 졸	350-500만원	은퇴	자녀 양육 가구	24	보수 성향 무당층	75	{"economy": 13, "housing": 6, "welfare": 12, "security": 41, "environment": 16}	지상파/종편 뉴스	{공정,자유,혁신}	충청북도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 공정, 자유, 혁신 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 63, "ecoConsciousness": 65, "priceSensitivity": 76, "digitalConsumption": 69}	{"taxTolerance": 40, "governmentTrust": 31, "policyAcceptance": 44, "regulationPreference": 66, "publicServiceSatisfaction": 50}	1
353	정지민	56	50-59	Female	충청북도	36.682115	127.467837	고졸 이하	350-500만원	프리랜서	부부 가구	8	중도 무당층	81	{"economy": -41, "housing": 40, "welfare": 17, "security": -16, "environment": 27}	유튜브	{성장,안정,혁신}	충청북도에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 성장, 안정, 혁신 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 58, "ecoConsciousness": 55, "priceSensitivity": 61, "digitalConsumption": 71}	{"taxTolerance": 45, "governmentTrust": 41, "policyAcceptance": 74, "regulationPreference": 72, "publicServiceSatisfaction": 72}	1
354	김민서	59	50-59	Male	충청북도	36.649451	127.472847	대학원 졸	500-700만원	학생	다세대 가구	-19	진보 성향 무당층	83	{"economy": -16, "housing": 30, "welfare": 26, "security": -16, "environment": 32}	SNS	{공동체,안정,다양성}	충청북도에 거주하는 50-59 학생. 정치 성향은 중도이며 공동체, 안정, 다양성 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 74, "ecoConsciousness": 61, "priceSensitivity": 38, "digitalConsumption": 69}	{"taxTolerance": 44, "governmentTrust": 46, "policyAcceptance": 53, "regulationPreference": 72, "publicServiceSatisfaction": 75}	1
355	장광수	53	50-59	Male	충청북도	36.68047	127.532706	대학원 졸	350-500만원	주부	자녀 양육 가구	44	보수 성향 무당층	85	{"economy": 34, "housing": 24, "welfare": -25, "security": 11, "environment": 4}	신문/팟캐스트	{전통,자유,혁신}	충청북도에 거주하는 50-59 주부. 정치 성향은 보수이며 전통, 자유, 혁신 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 71, "ecoConsciousness": 71, "priceSensitivity": 46, "digitalConsumption": 60}	{"taxTolerance": 43, "governmentTrust": 33, "policyAcceptance": 44, "regulationPreference": 44, "publicServiceSatisfaction": 49}	1
356	권건우	66	60-69	Female	충청북도	36.592293	127.433787	대학교 졸	350-500만원	전문직	자녀 양육 가구	35	보수 성향 무당층	83	{"economy": 19, "housing": -12, "welfare": 25, "security": 54, "environment": -14}	유튜브	{안정,성장,자유}	충청북도에 거주하는 60-69 전문직. 정치 성향은 보수이며 안정, 성장, 자유 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 51, "ecoConsciousness": 54, "priceSensitivity": 87, "digitalConsumption": 64}	{"taxTolerance": 60, "governmentTrust": 31, "policyAcceptance": 53, "regulationPreference": 69, "publicServiceSatisfaction": 68}	1
357	장지아	69	60-69	Male	충청북도	36.695443	127.416789	대학교 졸	350-500만원	은퇴	1인 가구	8	중도 무당층	72	{"economy": 10, "housing": 14, "welfare": 4, "security": -1, "environment": -17}	유튜브	{안전,공정,성장}	충청북도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 안전, 공정, 성장 가치를 중시한다.	{"brandLoyalty": 71, "noveltySeeking": 54, "ecoConsciousness": 67, "priceSensitivity": 47, "digitalConsumption": 62}	{"taxTolerance": 50, "governmentTrust": 73, "policyAcceptance": 53, "regulationPreference": 67, "publicServiceSatisfaction": 52}	1
358	안경숙	77	70+	Female	충청북도	36.653268	127.447485	고졸 이하	500-700만원	은퇴	1인 가구	2	중도 무당층	99	{"economy": 28, "housing": 21, "welfare": 14, "security": 11, "environment": 16}	지상파/종편 뉴스	{안정,다양성,혁신}	충청북도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안정, 다양성, 혁신 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 32, "ecoConsciousness": 55, "priceSensitivity": 58, "digitalConsumption": 66}	{"taxTolerance": 41, "governmentTrust": 67, "policyAcceptance": 62, "regulationPreference": 70, "publicServiceSatisfaction": 76}	1
359	한미경	70	70+	Male	충청북도	36.621699	127.538621	대학교 졸	350-500만원	은퇴	다세대 가구	4	중도 무당층	97	{"economy": -13, "housing": 28, "welfare": 27, "security": 14, "environment": 32}	지상파/종편 뉴스	{자유,안정,공정}	충청북도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 자유, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 70, "noveltySeeking": 37, "ecoConsciousness": 55, "priceSensitivity": 68, "digitalConsumption": 60}	{"taxTolerance": 51, "governmentTrust": 64, "policyAcceptance": 61, "regulationPreference": 48, "publicServiceSatisfaction": 72}	1
360	안준서	23	18-29	Female	충청남도	36.666051	126.650589	대학교 졸	200-350만원	학생	1인 가구	22	보수 성향 무당층	59	{"economy": 7, "housing": 21, "welfare": 28, "security": 12, "environment": 43}	포털 뉴스	{혁신,환경,자유}	충청남도에 거주하는 18-29 학생. 정치 성향은 중도이며 혁신, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 69, "ecoConsciousness": 62, "priceSensitivity": 86, "digitalConsumption": 85}	{"taxTolerance": 44, "governmentTrust": 58, "policyAcceptance": 47, "regulationPreference": 57, "publicServiceSatisfaction": 72}	1
361	권다은	24	18-29	Female	충청남도	36.710971	126.667904	대학원 졸	200-350만원	사무직	부부 가구	4	중도 무당층	45	{"economy": -4, "housing": -14, "welfare": -3, "security": 17, "environment": 1}	포털 뉴스	{성장,자유,환경}	충청남도에 거주하는 18-29 사무직. 정치 성향은 중도이며 성장, 자유, 환경 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 55, "ecoConsciousness": 58, "priceSensitivity": 70, "digitalConsumption": 97}	{"taxTolerance": 44, "governmentTrust": 52, "policyAcceptance": 43, "regulationPreference": 63, "publicServiceSatisfaction": 81}	1
362	장순자	24	18-29	Male	충청남도	36.702134	126.601558	대학원 졸	500-700만원	학생	1인 가구	-46	진보 정당 지지	58	{"economy": -40, "housing": 54, "welfare": 39, "security": -32, "environment": 64}	지상파/종편 뉴스	{혁신,안정,안전}	충청남도에 거주하는 18-29 학생. 정치 성향은 진보이며 혁신, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 20, "noveltySeeking": 80, "ecoConsciousness": 57, "priceSensitivity": 56, "digitalConsumption": 88}	{"taxTolerance": 76, "governmentTrust": 26, "policyAcceptance": 34, "regulationPreference": 58, "publicServiceSatisfaction": 82}	1
363	안지민	20	18-29	Male	충청남도	36.704637	126.639438	대학원 졸	350-500만원	학생	1인 가구	-37	진보 성향 무당층	31	{"economy": -31, "housing": 53, "welfare": 40, "security": -21, "environment": 37}	포털 뉴스	{환경,공동체,자유}	충청남도에 거주하는 18-29 학생. 정치 성향은 진보이며 환경, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 93, "ecoConsciousness": 74, "priceSensitivity": 58, "digitalConsumption": 78}	{"taxTolerance": 67, "governmentTrust": 30, "policyAcceptance": 48, "regulationPreference": 40, "publicServiceSatisfaction": 44}	1
364	전정희	37	30-39	Female	충청남도	36.607136	126.584966	대학교 졸	200-350만원	학생	부부 가구	-19	진보 성향 무당층	59	{"economy": -19, "housing": 17, "welfare": 28, "security": -5, "environment": -10}	유튜브	{다양성,안정,안전}	충청남도에 거주하는 30-39 학생. 정치 성향은 중도이며 다양성, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 69, "ecoConsciousness": 51, "priceSensitivity": 55, "digitalConsumption": 92}	{"taxTolerance": 58, "governmentTrust": 27, "policyAcceptance": 40, "regulationPreference": 63, "publicServiceSatisfaction": 64}	1
365	류은우	36	30-39	Female	충청남도	36.678738	126.667452	대학교 졸	350-500만원	공무원	다세대 가구	-7	중도 무당층	40	{"economy": 3, "housing": 12, "welfare": -5, "security": -11, "environment": -4}	신문/팟캐스트	{자유,안정,공동체}	충청남도에 거주하는 30-39 공무원. 정치 성향은 중도이며 자유, 안정, 공동체 가치를 중시한다.	{"brandLoyalty": 24, "noveltySeeking": 67, "ecoConsciousness": 66, "priceSensitivity": 68, "digitalConsumption": 92}	{"taxTolerance": 50, "governmentTrust": 36, "policyAcceptance": 45, "regulationPreference": 60, "publicServiceSatisfaction": 60}	1
366	임유준	30	30-39	Male	충청남도	36.674959	126.596388	대학원 졸	500-700만원	공무원	자녀 양육 가구	-25	진보 성향 무당층	53	{"economy": -13, "housing": 41, "welfare": 27, "security": -9, "environment": 12}	포털 뉴스	{공정,전통,혁신}	충청남도에 거주하는 30-39 공무원. 정치 성향은 중도이며 공정, 전통, 혁신 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 69, "ecoConsciousness": 67, "priceSensitivity": 53, "digitalConsumption": 72}	{"taxTolerance": 42, "governmentTrust": 50, "policyAcceptance": 56, "regulationPreference": 45, "publicServiceSatisfaction": 44}	1
367	신도윤	36	30-39	Male	충청남도	36.657474	126.605753	대학원 졸	350-500만원	공무원	다세대 가구	-5	중도 무당층	41	{"economy": -23, "housing": 48, "welfare": 25, "security": -7, "environment": 35}	유튜브	{전통,환경,혁신}	충청남도에 거주하는 30-39 공무원. 정치 성향은 중도이며 전통, 환경, 혁신 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 82, "ecoConsciousness": 60, "priceSensitivity": 52, "digitalConsumption": 70}	{"taxTolerance": 52, "governmentTrust": 48, "policyAcceptance": 54, "regulationPreference": 61, "publicServiceSatisfaction": 52}	1
368	임예준	43	40-49	Female	충청남도	36.692637	126.7063	전문대 졸	350-500만원	프리랜서	1인 가구	34	보수 성향 무당층	65	{"economy": 18, "housing": 8, "welfare": 15, "security": 29, "environment": 0}	SNS	{성장,공동체,공정}	충청남도에 거주하는 40-49 프리랜서. 정치 성향은 보수이며 성장, 공동체, 공정 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 46, "ecoConsciousness": 65, "priceSensitivity": 59, "digitalConsumption": 88}	{"taxTolerance": 43, "governmentTrust": 31, "policyAcceptance": 75, "regulationPreference": 50, "publicServiceSatisfaction": 58}	1
369	박성호	43	40-49	Female	충청남도	36.724777	126.729737	대학교 졸	500-700만원	생산직	다세대 가구	-50	진보 정당 지지	86	{"economy": -45, "housing": 21, "welfare": 66, "security": -29, "environment": 35}	지상파/종편 뉴스	{전통,안전,다양성}	충청남도에 거주하는 40-49 생산직. 정치 성향은 진보이며 전통, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 26, "noveltySeeking": 45, "ecoConsciousness": 66, "priceSensitivity": 48, "digitalConsumption": 87}	{"taxTolerance": 62, "governmentTrust": 51, "policyAcceptance": 39, "regulationPreference": 43, "publicServiceSatisfaction": 86}	1
370	오준서	49	40-49	Male	충청남도	36.592326	126.688738	대학교 졸	350-500만원	공무원	1인 가구	7	중도 무당층	68	{"economy": 11, "housing": 3, "welfare": 9, "security": 15, "environment": 11}	SNS	{자유,전통,공정}	충청남도에 거주하는 40-49 공무원. 정치 성향은 중도이며 자유, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 64, "ecoConsciousness": 56, "priceSensitivity": 65, "digitalConsumption": 78}	{"taxTolerance": 46, "governmentTrust": 41, "policyAcceptance": 44, "regulationPreference": 85, "publicServiceSatisfaction": 57}	1
371	최혜진	41	40-49	Male	충청남도	36.587342	126.726257	대학교 졸	200만원 미만	생산직	1인 가구	51	보수 정당 지지	49	{"economy": 21, "housing": 23, "welfare": 1, "security": 10, "environment": 1}	신문/팟캐스트	{안전,혁신,자유}	충청남도에 거주하는 40-49 생산직. 정치 성향은 보수이며 안전, 혁신, 자유 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 72, "ecoConsciousness": 61, "priceSensitivity": 84, "digitalConsumption": 68}	{"taxTolerance": 52, "governmentTrust": 55, "policyAcceptance": 56, "regulationPreference": 57, "publicServiceSatisfaction": 73}	1
372	최영수	55	50-59	Female	충청남도	36.718687	126.588996	대학교 졸	700만원 이상	은퇴	1인 가구	3	중도 무당층	78	{"economy": -15, "housing": 13, "welfare": 17, "security": -6, "environment": -8}	포털 뉴스	{다양성,공동체,안정}	충청남도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 다양성, 공동체, 안정 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 67, "ecoConsciousness": 50, "priceSensitivity": 47, "digitalConsumption": 61}	{"taxTolerance": 35, "governmentTrust": 27, "policyAcceptance": 39, "regulationPreference": 52, "publicServiceSatisfaction": 67}	1
373	홍지우	55	50-59	Female	충청남도	36.648231	126.666545	대학원 졸	500-700만원	사무직	부부 가구	1	중도 무당층	57	{"economy": 2, "housing": 3, "welfare": -20, "security": 0, "environment": -10}	유튜브	{혁신,공정,자유}	충청남도에 거주하는 50-59 사무직. 정치 성향은 중도이며 혁신, 공정, 자유 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 63, "ecoConsciousness": 55, "priceSensitivity": 61, "digitalConsumption": 51}	{"taxTolerance": 55, "governmentTrust": 43, "policyAcceptance": 59, "regulationPreference": 54, "publicServiceSatisfaction": 69}	1
374	오예준	56	50-59	Male	충청남도	36.646183	126.698617	고졸 이하	700만원 이상	프리랜서	다세대 가구	36	보수 성향 무당층	68	{"economy": 37, "housing": -13, "welfare": 8, "security": 34, "environment": 17}	SNS	{안정,성장,혁신}	충청남도에 거주하는 50-59 프리랜서. 정치 성향은 보수이며 안정, 성장, 혁신 가치를 중시한다.	{"brandLoyalty": 60, "noveltySeeking": 55, "ecoConsciousness": 43, "priceSensitivity": 37, "digitalConsumption": 70}	{"taxTolerance": 51, "governmentTrust": 63, "policyAcceptance": 46, "regulationPreference": 71, "publicServiceSatisfaction": 65}	1
375	박지민	59	50-59	Male	충청남도	36.680205	126.675088	전문대 졸	350-500만원	전문직	1인 가구	42	보수 성향 무당층	73	{"economy": 21, "housing": -25, "welfare": -27, "security": 33, "environment": 23}	신문/팟캐스트	{다양성,환경,성장}	충청남도에 거주하는 50-59 전문직. 정치 성향은 보수이며 다양성, 환경, 성장 가치를 중시한다.	{"brandLoyalty": 76, "noveltySeeking": 52, "ecoConsciousness": 34, "priceSensitivity": 55, "digitalConsumption": 59}	{"taxTolerance": 51, "governmentTrust": 37, "policyAcceptance": 46, "regulationPreference": 57, "publicServiceSatisfaction": 55}	1
376	최민준	67	60-69	Female	충청남도	36.604197	126.750613	대학교 졸	200-350만원	은퇴	부부 가구	18	보수 성향 무당층	68	{"economy": 27, "housing": 23, "welfare": 6, "security": 18, "environment": -4}	SNS	{혁신,안정,안전}	충청남도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 혁신, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 61, "noveltySeeking": 51, "ecoConsciousness": 63, "priceSensitivity": 80, "digitalConsumption": 71}	{"taxTolerance": 53, "governmentTrust": 56, "policyAcceptance": 51, "regulationPreference": 80, "publicServiceSatisfaction": 49}	1
377	박수아	61	60-69	Female	충청남도	36.686336	126.596756	전문대 졸	200-350만원	사무직	다세대 가구	17	보수 성향 무당층	98	{"economy": 28, "housing": -5, "welfare": 11, "security": 13, "environment": -11}	유튜브	{환경,혁신,공동체}	충청남도에 거주하는 60-69 사무직. 정치 성향은 중도이며 환경, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 67, "ecoConsciousness": 35, "priceSensitivity": 48, "digitalConsumption": 69}	{"taxTolerance": 41, "governmentTrust": 51, "policyAcceptance": 69, "regulationPreference": 64, "publicServiceSatisfaction": 76}	1
378	정혜진	66	60-69	Male	충청남도	36.615678	126.576908	고졸 이하	200-350만원	학생	자녀 양육 가구	19	보수 성향 무당층	89	{"economy": 11, "housing": 36, "welfare": 14, "security": 14, "environment": -6}	포털 뉴스	{공정,공동체,혁신}	충청남도에 거주하는 60-69 학생. 정치 성향은 중도이며 공정, 공동체, 혁신 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 28, "ecoConsciousness": 37, "priceSensitivity": 66, "digitalConsumption": 57}	{"taxTolerance": 62, "governmentTrust": 60, "policyAcceptance": 57, "regulationPreference": 53, "publicServiceSatisfaction": 54}	1
379	권지호	60	60-69	Male	충청남도	36.652108	126.747816	대학원 졸	350-500만원	사무직	다세대 가구	36	보수 성향 무당층	69	{"economy": 7, "housing": 18, "welfare": 7, "security": 27, "environment": -23}	SNS	{공정,다양성,자유}	충청남도에 거주하는 60-69 사무직. 정치 성향은 보수이며 공정, 다양성, 자유 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 77, "ecoConsciousness": 52, "priceSensitivity": 59, "digitalConsumption": 83}	{"taxTolerance": 53, "governmentTrust": 62, "policyAcceptance": 45, "regulationPreference": 68, "publicServiceSatisfaction": 67}	1
383	홍은우	20	18-29	Female	전라남도	34.82312	126.381225	고졸 이하	350-500만원	은퇴	부부 가구	-42	진보 성향 무당층	49	{"economy": -20, "housing": 47, "welfare": 33, "security": 10, "environment": 50}	포털 뉴스	{공동체,혁신,성장}	전라남도에 거주하는 18-29 은퇴. 정치 성향은 진보이며 공동체, 혁신, 성장 가치를 중시한다.	{"brandLoyalty": 22, "noveltySeeking": 77, "ecoConsciousness": 54, "priceSensitivity": 60, "digitalConsumption": 74}	{"taxTolerance": 48, "governmentTrust": 52, "policyAcceptance": 40, "regulationPreference": 60, "publicServiceSatisfaction": 74}	1
384	황현우	23	18-29	Male	전라남도	34.797922	126.488129	전문대 졸	200만원 미만	학생	자녀 양육 가구	-38	진보 성향 무당층	56	{"economy": -33, "housing": 34, "welfare": 28, "security": -25, "environment": 22}	유튜브	{전통,혁신,다양성}	전라남도에 거주하는 18-29 학생. 정치 성향은 진보이며 전통, 혁신, 다양성 가치를 중시한다.	{"brandLoyalty": 19, "noveltySeeking": 78, "ecoConsciousness": 45, "priceSensitivity": 56, "digitalConsumption": 84}	{"taxTolerance": 45, "governmentTrust": 59, "policyAcceptance": 44, "regulationPreference": 46, "publicServiceSatisfaction": 69}	1
385	이예준	32	30-39	Female	전라남도	34.850826	126.475883	대학원 졸	200-350만원	전문직	1인 가구	-12	중도 무당층	52	{"economy": -26, "housing": 48, "welfare": 13, "security": -11, "environment": 3}	신문/팟캐스트	{전통,다양성,환경}	전라남도에 거주하는 30-39 전문직. 정치 성향은 중도이며 전통, 다양성, 환경 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 87, "ecoConsciousness": 64, "priceSensitivity": 73, "digitalConsumption": 90}	{"taxTolerance": 48, "governmentTrust": 29, "policyAcceptance": 58, "regulationPreference": 43, "publicServiceSatisfaction": 84}	1
386	한다은	34	30-39	Male	전라남도	34.798522	126.523542	전문대 졸	200-350만원	은퇴	자녀 양육 가구	-52	진보 정당 지지	66	{"economy": -46, "housing": 48, "welfare": 63, "security": -31, "environment": 51}	유튜브	{혁신,안정,성장}	전라남도에 거주하는 30-39 은퇴. 정치 성향은 진보이며 혁신, 안정, 성장 가치를 중시한다.	{"brandLoyalty": 24, "noveltySeeking": 47, "ecoConsciousness": 55, "priceSensitivity": 69, "digitalConsumption": 88}	{"taxTolerance": 36, "governmentTrust": 66, "policyAcceptance": 45, "regulationPreference": 72, "publicServiceSatisfaction": 57}	1
387	조영수	47	40-49	Female	전라남도	34.88099	126.41909	대학교 졸	500-700만원	자영업	1인 가구	-35	진보 성향 무당층	77	{"economy": -26, "housing": 38, "welfare": 22, "security": -18, "environment": 35}	SNS	{공정,자유,혁신}	전라남도에 거주하는 40-49 자영업. 정치 성향은 진보이며 공정, 자유, 혁신 가치를 중시한다.	{"brandLoyalty": 66, "noveltySeeking": 64, "ecoConsciousness": 57, "priceSensitivity": 62, "digitalConsumption": 52}	{"taxTolerance": 51, "governmentTrust": 33, "policyAcceptance": 60, "regulationPreference": 67, "publicServiceSatisfaction": 69}	1
388	서현우	42	40-49	Female	전라남도	34.858344	126.381884	대학교 졸	350-500만원	프리랜서	1인 가구	-52	진보 정당 지지	79	{"economy": -56, "housing": 48, "welfare": 25, "security": -5, "environment": 24}	지상파/종편 뉴스	{안정,환경,다양성}	전라남도에 거주하는 40-49 프리랜서. 정치 성향은 진보이며 안정, 환경, 다양성 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 54, "ecoConsciousness": 39, "priceSensitivity": 52, "digitalConsumption": 71}	{"taxTolerance": 62, "governmentTrust": 40, "policyAcceptance": 45, "regulationPreference": 60, "publicServiceSatisfaction": 60}	1
389	강순자	40	40-49	Male	전라남도	34.74149	126.463187	전문대 졸	500-700만원	주부	1인 가구	-58	진보 정당 지지	62	{"economy": -45, "housing": 30, "welfare": 63, "security": -24, "environment": 34}	SNS	{공정,혁신,공동체}	전라남도에 거주하는 40-49 주부. 정치 성향은 진보이며 공정, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 60, "ecoConsciousness": 46, "priceSensitivity": 61, "digitalConsumption": 68}	{"taxTolerance": 51, "governmentTrust": 41, "policyAcceptance": 57, "regulationPreference": 58, "publicServiceSatisfaction": 84}	1
390	권은우	43	40-49	Male	전라남도	34.850277	126.467943	대학원 졸	350-500만원	서비스직	자녀 양육 가구	-36	진보 성향 무당층	64	{"economy": -44, "housing": 8, "welfare": 59, "security": -3, "environment": 47}	신문/팟캐스트	{안정,안전,다양성}	전라남도에 거주하는 40-49 서비스직. 정치 성향은 진보이며 안정, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 27, "noveltySeeking": 72, "ecoConsciousness": 59, "priceSensitivity": 63, "digitalConsumption": 75}	{"taxTolerance": 52, "governmentTrust": 58, "policyAcceptance": 39, "regulationPreference": 51, "publicServiceSatisfaction": 50}	1
391	박경숙	55	50-59	Female	전라남도	34.787581	126.481935	대학교 졸	200-350만원	은퇴	자녀 양육 가구	-23	진보 성향 무당층	84	{"economy": -1, "housing": -14, "welfare": 13, "security": 10, "environment": 33}	포털 뉴스	{안정,환경,공정}	전라남도에 거주하는 50-59 은퇴. 정치 성향은 중도이며 안정, 환경, 공정 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 55, "ecoConsciousness": 60, "priceSensitivity": 65, "digitalConsumption": 59}	{"taxTolerance": 58, "governmentTrust": 49, "policyAcceptance": 62, "regulationPreference": 63, "publicServiceSatisfaction": 78}	1
392	신민서	51	50-59	Female	전라남도	34.855537	126.407967	고졸 이하	350-500만원	전문직	다세대 가구	-28	진보 성향 무당층	51	{"economy": 3, "housing": 16, "welfare": 67, "security": -10, "environment": 28}	SNS	{안정,성장,다양성}	전라남도에 거주하는 50-59 전문직. 정치 성향은 중도이며 안정, 성장, 다양성 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 62, "ecoConsciousness": 45, "priceSensitivity": 62, "digitalConsumption": 61}	{"taxTolerance": 62, "governmentTrust": 40, "policyAcceptance": 46, "regulationPreference": 64, "publicServiceSatisfaction": 65}	1
393	권하은	50	50-59	Male	전라남도	34.806167	126.47335	대학원 졸	200만원 미만	학생	1인 가구	-63	진보 정당 지지	78	{"economy": -43, "housing": 46, "welfare": 30, "security": -33, "environment": 48}	유튜브	{안정,공동체,공정}	전라남도에 거주하는 50-59 학생. 정치 성향은 진보이며 안정, 공동체, 공정 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 73, "ecoConsciousness": 35, "priceSensitivity": 75, "digitalConsumption": 66}	{"taxTolerance": 56, "governmentTrust": 59, "policyAcceptance": 54, "regulationPreference": 44, "publicServiceSatisfaction": 55}	1
394	안민서	58	50-59	Male	전라남도	34.794377	126.558489	대학원 졸	350-500만원	은퇴	부부 가구	-55	진보 정당 지지	74	{"economy": -40, "housing": 47, "welfare": 29, "security": -32, "environment": 43}	신문/팟캐스트	{안정,다양성,혁신}	전라남도에 거주하는 50-59 은퇴. 정치 성향은 진보이며 안정, 다양성, 혁신 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 77, "ecoConsciousness": 71, "priceSensitivity": 57, "digitalConsumption": 61}	{"taxTolerance": 52, "governmentTrust": 47, "policyAcceptance": 61, "regulationPreference": 45, "publicServiceSatisfaction": 46}	1
395	김건우	69	60-69	Female	전라남도	34.754372	126.533302	대학교 졸	200만원 미만	은퇴	다세대 가구	-16	진보 성향 무당층	67	{"economy": -16, "housing": -7, "welfare": 22, "security": -15, "environment": 48}	포털 뉴스	{공동체,혁신,다양성}	전라남도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 공동체, 혁신, 다양성 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 35, "ecoConsciousness": 65, "priceSensitivity": 60, "digitalConsumption": 54}	{"taxTolerance": 50, "governmentTrust": 75, "policyAcceptance": 42, "regulationPreference": 63, "publicServiceSatisfaction": 65}	1
396	황도윤	67	60-69	Female	전라남도	34.748893	126.516324	대학교 졸	350-500만원	은퇴	자녀 양육 가구	-24	진보 성향 무당층	81	{"economy": -21, "housing": 22, "welfare": 32, "security": 5, "environment": 63}	신문/팟캐스트	{공정,자유,혁신}	전라남도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 공정, 자유, 혁신 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 71, "ecoConsciousness": 44, "priceSensitivity": 47, "digitalConsumption": 64}	{"taxTolerance": 58, "governmentTrust": 47, "policyAcceptance": 38, "regulationPreference": 61, "publicServiceSatisfaction": 70}	1
397	홍혜진	64	60-69	Male	전라남도	34.808102	126.365465	고졸 이하	500-700만원	사무직	부부 가구	-13	중도 무당층	70	{"economy": -15, "housing": 35, "welfare": 17, "security": -7, "environment": 32}	신문/팟캐스트	{전통,공동체,자유}	전라남도에 거주하는 60-69 사무직. 정치 성향은 중도이며 전통, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 75, "noveltySeeking": 51, "ecoConsciousness": 42, "priceSensitivity": 66, "digitalConsumption": 60}	{"taxTolerance": 56, "governmentTrust": 64, "policyAcceptance": 48, "regulationPreference": 84, "publicServiceSatisfaction": 65}	1
398	박지아	65	60-69	Male	전라남도	34.872316	126.438108	전문대 졸	350-500만원	주부	다세대 가구	-4	중도 무당층	66	{"economy": -18, "housing": 28, "welfare": 20, "security": 9, "environment": 35}	SNS	{공정,성장,환경}	전라남도에 거주하는 60-69 주부. 정치 성향은 중도이며 공정, 성장, 환경 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 46, "ecoConsciousness": 50, "priceSensitivity": 45, "digitalConsumption": 65}	{"taxTolerance": 63, "governmentTrust": 49, "policyAcceptance": 49, "regulationPreference": 53, "publicServiceSatisfaction": 66}	1
399	임은우	84	70+	Female	전라남도	34.839546	126.558928	대학원 졸	500-700만원	은퇴	부부 가구	-10	중도 무당층	92	{"economy": -2, "housing": 51, "welfare": 20, "security": -9, "environment": 7}	유튜브	{환경,전통,안정}	전라남도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 환경, 전통, 안정 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 72, "ecoConsciousness": 41, "priceSensitivity": 55, "digitalConsumption": 50}	{"taxTolerance": 38, "governmentTrust": 38, "policyAcceptance": 49, "regulationPreference": 55, "publicServiceSatisfaction": 60}	1
400	한주원	77	70+	Male	전라남도	34.885812	126.539868	전문대 졸	200만원 미만	은퇴	다세대 가구	5	중도 무당층	77	{"economy": -10, "housing": 10, "welfare": 9, "security": 5, "environment": 11}	유튜브	{공동체,공정,다양성}	전라남도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공동체, 공정, 다양성 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 52, "ecoConsciousness": 48, "priceSensitivity": 90, "digitalConsumption": 42}	{"taxTolerance": 48, "governmentTrust": 49, "policyAcceptance": 35, "regulationPreference": 63, "publicServiceSatisfaction": 72}	1
401	송순자	27	18-29	Female	경상북도	36.572851	128.575956	대학원 졸	200만원 미만	학생	부부 가구	36	보수 성향 무당층	58	{"economy": 26, "housing": 15, "welfare": -23, "security": 30, "environment": 8}	유튜브	{성장,안정,혁신}	경상북도에 거주하는 18-29 학생. 정치 성향은 보수이며 성장, 안정, 혁신 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 87, "ecoConsciousness": 72, "priceSensitivity": 75, "digitalConsumption": 79}	{"taxTolerance": 58, "governmentTrust": 49, "policyAcceptance": 53, "regulationPreference": 76, "publicServiceSatisfaction": 52}	1
402	권민준	27	18-29	Female	경상북도	36.608863	128.48716	고졸 이하	200만원 미만	전문직	부부 가구	26	보수 성향 무당층	60	{"economy": -8, "housing": 4, "welfare": -7, "security": 34, "environment": 7}	유튜브	{안전,성장,공정}	경상북도에 거주하는 18-29 전문직. 정치 성향은 중도이며 안전, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 65, "ecoConsciousness": 64, "priceSensitivity": 56, "digitalConsumption": 74}	{"taxTolerance": 44, "governmentTrust": 30, "policyAcceptance": 54, "regulationPreference": 53, "publicServiceSatisfaction": 68}	1
403	서준서	28	18-29	Male	경상북도	36.538201	128.555088	전문대 졸	200-350만원	자영업	다세대 가구	28	보수 성향 무당층	51	{"economy": 4, "housing": 23, "welfare": 6, "security": -3, "environment": 13}	SNS	{공동체,자유,전통}	경상북도에 거주하는 18-29 자영업. 정치 성향은 중도이며 공동체, 자유, 전통 가치를 중시한다.	{"brandLoyalty": 23, "noveltySeeking": 60, "ecoConsciousness": 59, "priceSensitivity": 54, "digitalConsumption": 100}	{"taxTolerance": 45, "governmentTrust": 48, "policyAcceptance": 43, "regulationPreference": 65, "publicServiceSatisfaction": 68}	1
404	신경숙	23	18-29	Male	경상북도	36.505577	128.579162	대학교 졸	200-350만원	학생	1인 가구	0	중도 무당층	57	{"economy": 19, "housing": 25, "welfare": 19, "security": 3, "environment": -28}	포털 뉴스	{자유,혁신,성장}	경상북도에 거주하는 18-29 학생. 정치 성향은 중도이며 자유, 혁신, 성장 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 72, "ecoConsciousness": 60, "priceSensitivity": 78, "digitalConsumption": 85}	{"taxTolerance": 69, "governmentTrust": 42, "policyAcceptance": 60, "regulationPreference": 76, "publicServiceSatisfaction": 62}	1
405	강성호	37	30-39	Female	경상북도	36.557307	128.516226	대학원 졸	200-350만원	은퇴	다세대 가구	31	보수 성향 무당층	50	{"economy": 49, "housing": 19, "welfare": 5, "security": 28, "environment": 26}	SNS	{혁신,전통,자유}	경상북도에 거주하는 30-39 은퇴. 정치 성향은 중도이며 혁신, 전통, 자유 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 62, "ecoConsciousness": 68, "priceSensitivity": 82, "digitalConsumption": 83}	{"taxTolerance": 60, "governmentTrust": 30, "policyAcceptance": 27, "regulationPreference": 70, "publicServiceSatisfaction": 58}	1
406	안예준	32	30-39	Female	경상북도	36.616297	128.461718	대학교 졸	200만원 미만	생산직	다세대 가구	39	보수 성향 무당층	59	{"economy": 11, "housing": -2, "welfare": -26, "security": 23, "environment": 28}	유튜브	{안정,자유,다양성}	경상북도에 거주하는 30-39 생산직. 정치 성향은 보수이며 안정, 자유, 다양성 가치를 중시한다.	{"brandLoyalty": 31, "noveltySeeking": 63, "ecoConsciousness": 71, "priceSensitivity": 87, "digitalConsumption": 88}	{"taxTolerance": 55, "governmentTrust": 52, "policyAcceptance": 42, "regulationPreference": 61, "publicServiceSatisfaction": 59}	1
407	박현우	33	30-39	Male	경상북도	36.606368	128.523709	대학원 졸	200만원 미만	생산직	부부 가구	31	보수 성향 무당층	62	{"economy": 0, "housing": 31, "welfare": -13, "security": 16, "environment": 8}	SNS	{공동체,다양성,전통}	경상북도에 거주하는 30-39 생산직. 정치 성향은 중도이며 공동체, 다양성, 전통 가치를 중시한다.	{"brandLoyalty": 20, "noveltySeeking": 71, "ecoConsciousness": 63, "priceSensitivity": 82, "digitalConsumption": 84}	{"taxTolerance": 49, "governmentTrust": 56, "policyAcceptance": 36, "regulationPreference": 60, "publicServiceSatisfaction": 69}	1
408	홍정희	34	30-39	Male	경상북도	36.534779	128.4768	대학원 졸	350-500만원	공무원	부부 가구	16	보수 성향 무당층	59	{"economy": 22, "housing": 25, "welfare": -4, "security": 18, "environment": 10}	포털 뉴스	{공정,전통,공동체}	경상북도에 거주하는 30-39 공무원. 정치 성향은 중도이며 공정, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 77, "ecoConsciousness": 50, "priceSensitivity": 47, "digitalConsumption": 100}	{"taxTolerance": 37, "governmentTrust": 43, "policyAcceptance": 47, "regulationPreference": 68, "publicServiceSatisfaction": 94}	1
409	서정희	43	40-49	Female	경상북도	36.513885	128.604561	전문대 졸	200-350만원	생산직	다세대 가구	42	보수 성향 무당층	86	{"economy": 19, "housing": 22, "welfare": 32, "security": 20, "environment": 3}	SNS	{안정,혁신,공동체}	경상북도에 거주하는 40-49 생산직. 정치 성향은 보수이며 안정, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 71, "ecoConsciousness": 55, "priceSensitivity": 66, "digitalConsumption": 59}	{"taxTolerance": 39, "governmentTrust": 33, "policyAcceptance": 60, "regulationPreference": 61, "publicServiceSatisfaction": 91}	1
410	신혜진	46	40-49	Female	경상북도	36.567813	128.523752	고졸 이하	200-350만원	전문직	다세대 가구	-7	중도 무당층	66	{"economy": -30, "housing": -1, "welfare": 16, "security": 19, "environment": 30}	SNS	{혁신,안정,성장}	경상북도에 거주하는 40-49 전문직. 정치 성향은 중도이며 혁신, 안정, 성장 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 59, "ecoConsciousness": 51, "priceSensitivity": 50, "digitalConsumption": 58}	{"taxTolerance": 43, "governmentTrust": 53, "policyAcceptance": 35, "regulationPreference": 63, "publicServiceSatisfaction": 68}	1
411	이경숙	40	40-49	Male	경상북도	36.602152	128.554557	대학교 졸	700만원 이상	전문직	자녀 양육 가구	31	보수 성향 무당층	44	{"economy": 12, "housing": 11, "welfare": -13, "security": 1, "environment": 3}	신문/팟캐스트	{안정,안전,다양성}	경상북도에 거주하는 40-49 전문직. 정치 성향은 중도이며 안정, 안전, 다양성 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 52, "ecoConsciousness": 54, "priceSensitivity": 29, "digitalConsumption": 76}	{"taxTolerance": 43, "governmentTrust": 66, "policyAcceptance": 45, "regulationPreference": 58, "publicServiceSatisfaction": 54}	1
412	송동현	48	40-49	Male	경상북도	36.573081	128.551314	대학교 졸	500-700만원	공무원	1인 가구	39	보수 성향 무당층	70	{"economy": 10, "housing": 0, "welfare": 14, "security": 53, "environment": -11}	신문/팟캐스트	{공정,공동체,혁신}	경상북도에 거주하는 40-49 공무원. 정치 성향은 보수이며 공정, 공동체, 혁신 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 68, "ecoConsciousness": 60, "priceSensitivity": 38, "digitalConsumption": 66}	{"taxTolerance": 40, "governmentTrust": 35, "policyAcceptance": 60, "regulationPreference": 66, "publicServiceSatisfaction": 65}	1
413	한성호	56	50-59	Female	경상북도	36.633306	128.434598	대학교 졸	350-500만원	학생	다세대 가구	39	보수 성향 무당층	59	{"economy": 31, "housing": 35, "welfare": -2, "security": -2, "environment": 17}	포털 뉴스	{안정,공동체,공정}	경상북도에 거주하는 50-59 학생. 정치 성향은 보수이며 안정, 공동체, 공정 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 56, "ecoConsciousness": 58, "priceSensitivity": 65, "digitalConsumption": 76}	{"taxTolerance": 42, "governmentTrust": 53, "policyAcceptance": 55, "regulationPreference": 62, "publicServiceSatisfaction": 82}	1
414	황정희	59	50-59	Female	경상북도	36.504543	128.543351	고졸 이하	500-700만원	프리랜서	부부 가구	53	보수 정당 지지	71	{"economy": 16, "housing": 6, "welfare": -31, "security": 38, "environment": -6}	지상파/종편 뉴스	{성장,환경,다양성}	경상북도에 거주하는 50-59 프리랜서. 정치 성향은 보수이며 성장, 환경, 다양성 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 47, "ecoConsciousness": 45, "priceSensitivity": 70, "digitalConsumption": 73}	{"taxTolerance": 42, "governmentTrust": 57, "policyAcceptance": 58, "regulationPreference": 56, "publicServiceSatisfaction": 62}	1
415	정건우	59	50-59	Female	경상북도	36.622367	128.441001	고졸 이하	350-500만원	은퇴	다세대 가구	67	보수 정당 지지	73	{"economy": 49, "housing": 27, "welfare": 18, "security": 40, "environment": -4}	SNS	{환경,성장,공동체}	경상북도에 거주하는 50-59 은퇴. 정치 성향은 보수이며 환경, 성장, 공동체 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 52, "ecoConsciousness": 40, "priceSensitivity": 73, "digitalConsumption": 67}	{"taxTolerance": 30, "governmentTrust": 41, "policyAcceptance": 69, "regulationPreference": 52, "publicServiceSatisfaction": 63}	1
416	권건우	52	50-59	Male	경상북도	36.650171	128.467209	대학교 졸	200-350만원	서비스직	부부 가구	40	보수 성향 무당층	77	{"economy": 30, "housing": 13, "welfare": 8, "security": 42, "environment": -3}	SNS	{안정,안전,자유}	경상북도에 거주하는 50-59 서비스직. 정치 성향은 보수이며 안정, 안전, 자유 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 59, "ecoConsciousness": 46, "priceSensitivity": 67, "digitalConsumption": 79}	{"taxTolerance": 32, "governmentTrust": 62, "policyAcceptance": 52, "regulationPreference": 64, "publicServiceSatisfaction": 71}	1
417	장하은	56	50-59	Male	경상북도	36.516018	128.439409	고졸 이하	350-500만원	사무직	1인 가구	28	보수 성향 무당층	67	{"economy": 18, "housing": 6, "welfare": 0, "security": 18, "environment": 15}	유튜브	{혁신,안전,공정}	경상북도에 거주하는 50-59 사무직. 정치 성향은 중도이며 혁신, 안전, 공정 가치를 중시한다.	{"brandLoyalty": 63, "noveltySeeking": 41, "ecoConsciousness": 51, "priceSensitivity": 62, "digitalConsumption": 60}	{"taxTolerance": 41, "governmentTrust": 41, "policyAcceptance": 52, "regulationPreference": 59, "publicServiceSatisfaction": 91}	1
418	류동현	59	50-59	Male	경상북도	36.525907	128.428009	전문대 졸	350-500만원	사무직	자녀 양육 가구	41	보수 성향 무당층	76	{"economy": 59, "housing": -8, "welfare": -5, "security": 56, "environment": 20}	포털 뉴스	{혁신,자유,안전}	경상북도에 거주하는 50-59 사무직. 정치 성향은 보수이며 혁신, 자유, 안전 가치를 중시한다.	{"brandLoyalty": 74, "noveltySeeking": 35, "ecoConsciousness": 68, "priceSensitivity": 52, "digitalConsumption": 71}	{"taxTolerance": 27, "governmentTrust": 38, "policyAcceptance": 60, "regulationPreference": 54, "publicServiceSatisfaction": 74}	1
419	윤민서	68	60-69	Female	경상북도	36.622225	128.419313	대학원 졸	200만원 미만	은퇴	1인 가구	41	보수 성향 무당층	70	{"economy": 12, "housing": 18, "welfare": -12, "security": 33, "environment": -6}	SNS	{성장,전통,안정}	경상북도에 거주하는 60-69 은퇴. 정치 성향은 보수이며 성장, 전통, 안정 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 45, "ecoConsciousness": 52, "priceSensitivity": 81, "digitalConsumption": 56}	{"taxTolerance": 35, "governmentTrust": 48, "policyAcceptance": 38, "regulationPreference": 71, "publicServiceSatisfaction": 58}	1
420	박수아	65	60-69	Female	경상북도	36.650383	128.603973	전문대 졸	350-500만원	학생	부부 가구	64	보수 정당 지지	93	{"economy": 12, "housing": -4, "welfare": 3, "security": 41, "environment": -15}	SNS	{성장,안정,자유}	경상북도에 거주하는 60-69 학생. 정치 성향은 보수이며 성장, 안정, 자유 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 68, "ecoConsciousness": 38, "priceSensitivity": 53, "digitalConsumption": 67}	{"taxTolerance": 40, "governmentTrust": 48, "policyAcceptance": 40, "regulationPreference": 73, "publicServiceSatisfaction": 79}	1
421	오경숙	60	60-69	Male	경상북도	36.597589	128.585732	대학교 졸	700만원 이상	은퇴	부부 가구	47	보수 정당 지지	83	{"economy": 14, "housing": 24, "welfare": -31, "security": 17, "environment": -2}	유튜브	{안전,성장,안정}	경상북도에 거주하는 60-69 은퇴. 정치 성향은 보수이며 안전, 성장, 안정 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 57, "ecoConsciousness": 59, "priceSensitivity": 38, "digitalConsumption": 58}	{"taxTolerance": 30, "governmentTrust": 56, "policyAcceptance": 52, "regulationPreference": 77, "publicServiceSatisfaction": 59}	1
422	신준서	61	60-69	Male	경상북도	36.519564	128.411563	대학교 졸	200만원 미만	공무원	다세대 가구	57	보수 정당 지지	86	{"economy": 43, "housing": 1, "welfare": -14, "security": 33, "environment": -2}	신문/팟캐스트	{다양성,성장,자유}	경상북도에 거주하는 60-69 공무원. 정치 성향은 보수이며 다양성, 성장, 자유 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 81, "ecoConsciousness": 47, "priceSensitivity": 82, "digitalConsumption": 87}	{"taxTolerance": 64, "governmentTrust": 42, "policyAcceptance": 77, "regulationPreference": 58, "publicServiceSatisfaction": 65}	1
423	강유준	74	70+	Female	경상북도	36.618286	128.514652	대학원 졸	350-500만원	은퇴	자녀 양육 가구	33	보수 성향 무당층	69	{"economy": 2, "housing": 9, "welfare": -23, "security": 41, "environment": 22}	포털 뉴스	{성장,혁신,전통}	경상북도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 성장, 혁신, 전통 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 72, "ecoConsciousness": 45, "priceSensitivity": 50, "digitalConsumption": 64}	{"taxTolerance": 41, "governmentTrust": 52, "policyAcceptance": 54, "regulationPreference": 58, "publicServiceSatisfaction": 64}	1
424	전지민	70	70+	Female	경상북도	36.604343	128.546351	전문대 졸	350-500만원	은퇴	부부 가구	77	보수 정당 지지	66	{"economy": 44, "housing": -5, "welfare": -29, "security": 56, "environment": -4}	유튜브	{안정,혁신,환경}	경상북도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안정, 혁신, 환경 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 56, "ecoConsciousness": 56, "priceSensitivity": 66, "digitalConsumption": 63}	{"taxTolerance": 51, "governmentTrust": 57, "policyAcceptance": 55, "regulationPreference": 55, "publicServiceSatisfaction": 73}	1
425	안광수	70	70+	Male	경상북도	36.606693	128.490063	대학교 졸	200만원 미만	은퇴	1인 가구	32	보수 성향 무당층	74	{"economy": 11, "housing": 16, "welfare": -20, "security": 39, "environment": 2}	유튜브	{성장,공동체,혁신}	경상북도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 성장, 공동체, 혁신 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 51, "ecoConsciousness": 70, "priceSensitivity": 90, "digitalConsumption": 55}	{"taxTolerance": 51, "governmentTrust": 63, "policyAcceptance": 53, "regulationPreference": 65, "publicServiceSatisfaction": 57}	1
426	정동현	70	70+	Male	경상북도	36.509745	128.479362	대학교 졸	350-500만원	은퇴	부부 가구	43	보수 성향 무당층	94	{"economy": 31, "housing": 15, "welfare": -31, "security": 37, "environment": -7}	신문/팟캐스트	{안전,안정,다양성}	경상북도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안전, 안정, 다양성 가치를 중시한다.	{"brandLoyalty": 67, "noveltySeeking": 58, "ecoConsciousness": 69, "priceSensitivity": 57, "digitalConsumption": 54}	{"taxTolerance": 45, "governmentTrust": 50, "policyAcceptance": 58, "regulationPreference": 57, "publicServiceSatisfaction": 75}	1
427	송철수	28	18-29	Female	경상남도	35.409407	128.306945	대학교 졸	350-500만원	학생	1인 가구	10	중도 무당층	63	{"economy": 11, "housing": 18, "welfare": 33, "security": 31, "environment": 9}	유튜브	{안전,전통,공동체}	경상남도에 거주하는 18-29 학생. 정치 성향은 중도이며 안전, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 87, "ecoConsciousness": 56, "priceSensitivity": 63, "digitalConsumption": 72}	{"taxTolerance": 86, "governmentTrust": 37, "policyAcceptance": 55, "regulationPreference": 52, "publicServiceSatisfaction": 61}	1
428	김광수	18	18-29	Female	경상남도	35.517745	128.269177	대학원 졸	200-350만원	생산직	1인 가구	10	중도 무당층	53	{"economy": 41, "housing": -16, "welfare": -20, "security": 16, "environment": 44}	포털 뉴스	{자유,다양성,혁신}	경상남도에 거주하는 18-29 생산직. 정치 성향은 중도이며 자유, 다양성, 혁신 가치를 중시한다.	{"brandLoyalty": 17, "noveltySeeking": 78, "ecoConsciousness": 53, "priceSensitivity": 64, "digitalConsumption": 100}	{"taxTolerance": 58, "governmentTrust": 24, "policyAcceptance": 57, "regulationPreference": 67, "publicServiceSatisfaction": 77}	1
429	조수아	29	18-29	Female	경상남도	35.466337	128.199757	대학교 졸	200-350만원	전문직	부부 가구	-3	중도 무당층	62	{"economy": -9, "housing": 43, "welfare": 11, "security": 13, "environment": 23}	포털 뉴스	{안정,공정,공동체}	경상남도에 거주하는 18-29 전문직. 정치 성향은 중도이며 안정, 공정, 공동체 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 64, "ecoConsciousness": 56, "priceSensitivity": 60, "digitalConsumption": 81}	{"taxTolerance": 58, "governmentTrust": 51, "policyAcceptance": 52, "regulationPreference": 68, "publicServiceSatisfaction": 57}	1
430	한예준	18	18-29	Male	경상남도	35.435202	128.263794	전문대 졸	350-500만원	학생	자녀 양육 가구	-13	중도 무당층	39	{"economy": -35, "housing": 10, "welfare": 41, "security": -28, "environment": 27}	SNS	{전통,공동체,안전}	경상남도에 거주하는 18-29 학생. 정치 성향은 중도이며 전통, 공동체, 안전 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 69, "ecoConsciousness": 65, "priceSensitivity": 68, "digitalConsumption": 85}	{"taxTolerance": 57, "governmentTrust": 42, "policyAcceptance": 62, "regulationPreference": 56, "publicServiceSatisfaction": 68}	1
431	최지호	25	18-29	Male	경상남도	35.496786	128.2428	대학원 졸	200-350만원	사무직	부부 가구	14	중도 무당층	51	{"economy": 19, "housing": 16, "welfare": 62, "security": 7, "environment": -7}	포털 뉴스	{환경,전통,안전}	경상남도에 거주하는 18-29 사무직. 정치 성향은 중도이며 환경, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 25, "noveltySeeking": 72, "ecoConsciousness": 52, "priceSensitivity": 70, "digitalConsumption": 82}	{"taxTolerance": 54, "governmentTrust": 35, "policyAcceptance": 31, "regulationPreference": 56, "publicServiceSatisfaction": 74}	1
432	임채원	18	18-29	Male	경상남도	35.441997	128.144987	전문대 졸	200-350만원	공무원	다세대 가구	-36	진보 성향 무당층	43	{"economy": -58, "housing": 27, "welfare": 53, "security": -16, "environment": 19}	SNS	{자유,환경,혁신}	경상남도에 거주하는 18-29 공무원. 정치 성향은 진보이며 자유, 환경, 혁신 가치를 중시한다.	{"brandLoyalty": 19, "noveltySeeking": 86, "ecoConsciousness": 46, "priceSensitivity": 59, "digitalConsumption": 78}	{"taxTolerance": 42, "governmentTrust": 37, "policyAcceptance": 51, "regulationPreference": 53, "publicServiceSatisfaction": 76}	1
433	송지아	37	30-39	Female	경상남도	35.52145	128.252039	고졸 이하	200-350만원	사무직	자녀 양육 가구	-28	진보 성향 무당층	61	{"economy": -27, "housing": 40, "welfare": 21, "security": -17, "environment": 37}	SNS	{공정,다양성,혁신}	경상남도에 거주하는 30-39 사무직. 정치 성향은 중도이며 공정, 다양성, 혁신 가치를 중시한다.	{"brandLoyalty": 25, "noveltySeeking": 75, "ecoConsciousness": 74, "priceSensitivity": 58, "digitalConsumption": 97}	{"taxTolerance": 36, "governmentTrust": 40, "policyAcceptance": 39, "regulationPreference": 67, "publicServiceSatisfaction": 63}	1
434	전민준	35	30-39	Female	경상남도	35.528515	128.243331	전문대 졸	500-700만원	프리랜서	자녀 양육 가구	27	보수 성향 무당층	50	{"economy": -7, "housing": -2, "welfare": 4, "security": 39, "environment": 24}	유튜브	{다양성,환경,공정}	경상남도에 거주하는 30-39 프리랜서. 정치 성향은 중도이며 다양성, 환경, 공정 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 58, "ecoConsciousness": 59, "priceSensitivity": 52, "digitalConsumption": 77}	{"taxTolerance": 38, "governmentTrust": 38, "policyAcceptance": 60, "regulationPreference": 69, "publicServiceSatisfaction": 47}	1
435	강현우	35	30-39	Male	경상남도	35.446778	128.20521	대학원 졸	500-700만원	학생	1인 가구	29	보수 성향 무당층	38	{"economy": -20, "housing": 10, "welfare": 7, "security": 43, "environment": 23}	신문/팟캐스트	{다양성,성장,자유}	경상남도에 거주하는 30-39 학생. 정치 성향은 중도이며 다양성, 성장, 자유 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 69, "ecoConsciousness": 60, "priceSensitivity": 40, "digitalConsumption": 76}	{"taxTolerance": 22, "governmentTrust": 41, "policyAcceptance": 57, "regulationPreference": 60, "publicServiceSatisfaction": 72}	1
436	임성호	38	30-39	Male	경상남도	35.422561	128.251184	대학원 졸	500-700만원	학생	다세대 가구	21	보수 성향 무당층	61	{"economy": 23, "housing": 26, "welfare": 27, "security": 18, "environment": 9}	SNS	{혁신,전통,안정}	경상남도에 거주하는 30-39 학생. 정치 성향은 중도이며 혁신, 전통, 안정 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 74, "ecoConsciousness": 54, "priceSensitivity": 38, "digitalConsumption": 84}	{"taxTolerance": 33, "governmentTrust": 42, "policyAcceptance": 64, "regulationPreference": 52, "publicServiceSatisfaction": 75}	1
437	권지아	40	40-49	Female	경상남도	35.502033	128.296428	대학교 졸	700만원 이상	전문직	자녀 양육 가구	12	중도 무당층	65	{"economy": -18, "housing": 15, "welfare": 16, "security": 31, "environment": 16}	신문/팟캐스트	{안전,전통,다양성}	경상남도에 거주하는 40-49 전문직. 정치 성향은 중도이며 안전, 전통, 다양성 가치를 중시한다.	{"brandLoyalty": 39, "noveltySeeking": 66, "ecoConsciousness": 36, "priceSensitivity": 62, "digitalConsumption": 91}	{"taxTolerance": 62, "governmentTrust": 50, "policyAcceptance": 53, "regulationPreference": 72, "publicServiceSatisfaction": 54}	1
438	정지우	41	40-49	Female	경상남도	35.444584	128.134272	고졸 이하	350-500만원	학생	자녀 양육 가구	-30	진보 성향 무당층	63	{"economy": -26, "housing": 33, "welfare": 25, "security": -27, "environment": 50}	포털 뉴스	{혁신,공정,안전}	경상남도에 거주하는 40-49 학생. 정치 성향은 중도이며 혁신, 공정, 안전 가치를 중시한다.	{"brandLoyalty": 25, "noveltySeeking": 85, "ecoConsciousness": 65, "priceSensitivity": 57, "digitalConsumption": 84}	{"taxTolerance": 39, "governmentTrust": 58, "policyAcceptance": 50, "regulationPreference": 60, "publicServiceSatisfaction": 67}	1
439	정서연	49	40-49	Female	경상남도	35.423769	128.247795	전문대 졸	500-700만원	사무직	1인 가구	0	중도 무당층	75	{"economy": -18, "housing": 22, "welfare": -11, "security": 6, "environment": 17}	지상파/종편 뉴스	{다양성,안정,전통}	경상남도에 거주하는 40-49 사무직. 정치 성향은 중도이며 다양성, 안정, 전통 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 58, "ecoConsciousness": 29, "priceSensitivity": 51, "digitalConsumption": 49}	{"taxTolerance": 43, "governmentTrust": 50, "policyAcceptance": 33, "regulationPreference": 67, "publicServiceSatisfaction": 66}	1
440	황지민	44	40-49	Male	경상남도	35.489766	128.21925	전문대 졸	500-700만원	공무원	다세대 가구	29	보수 성향 무당층	56	{"economy": 8, "housing": 5, "welfare": 27, "security": 5, "environment": 9}	SNS	{다양성,성장,안전}	경상남도에 거주하는 40-49 공무원. 정치 성향은 중도이며 다양성, 성장, 안전 가치를 중시한다.	{"brandLoyalty": 60, "noveltySeeking": 49, "ecoConsciousness": 77, "priceSensitivity": 59, "digitalConsumption": 86}	{"taxTolerance": 49, "governmentTrust": 49, "policyAcceptance": 49, "regulationPreference": 59, "publicServiceSatisfaction": 67}	1
441	조성호	42	40-49	Male	경상남도	35.518274	128.174146	대학교 졸	350-500만원	서비스직	부부 가구	26	보수 성향 무당층	95	{"economy": 6, "housing": 21, "welfare": -32, "security": 13, "environment": -10}	유튜브	{공정,안정,안전}	경상남도에 거주하는 40-49 서비스직. 정치 성향은 중도이며 공정, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 88, "ecoConsciousness": 42, "priceSensitivity": 50, "digitalConsumption": 91}	{"taxTolerance": 55, "governmentTrust": 23, "policyAcceptance": 50, "regulationPreference": 57, "publicServiceSatisfaction": 43}	1
442	이민준	42	40-49	Male	경상남도	35.459297	128.259794	고졸 이하	500-700만원	자영업	부부 가구	41	보수 성향 무당층	70	{"economy": -3, "housing": -24, "welfare": 8, "security": 61, "environment": -16}	지상파/종편 뉴스	{다양성,공동체,혁신}	경상남도에 거주하는 40-49 자영업. 정치 성향은 보수이며 다양성, 공동체, 혁신 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 45, "ecoConsciousness": 52, "priceSensitivity": 47, "digitalConsumption": 66}	{"taxTolerance": 28, "governmentTrust": 34, "policyAcceptance": 64, "regulationPreference": 64, "publicServiceSatisfaction": 57}	1
443	김지아	51	50-59	Female	경상남도	35.380651	128.209074	대학원 졸	200-350만원	생산직	부부 가구	33	보수 성향 무당층	66	{"economy": -3, "housing": 6, "welfare": -8, "security": 13, "environment": 3}	지상파/종편 뉴스	{환경,전통,공동체}	경상남도에 거주하는 50-59 생산직. 정치 성향은 중도이며 환경, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 76, "ecoConsciousness": 37, "priceSensitivity": 76, "digitalConsumption": 62}	{"taxTolerance": 42, "governmentTrust": 54, "policyAcceptance": 47, "regulationPreference": 75, "publicServiceSatisfaction": 61}	1
444	최미경	54	50-59	Female	경상남도	35.462179	128.289322	대학교 졸	700만원 이상	전문직	부부 가구	-2	중도 무당층	95	{"economy": 22, "housing": 16, "welfare": 14, "security": 29, "environment": 38}	유튜브	{성장,안정,전통}	경상남도에 거주하는 50-59 전문직. 정치 성향은 중도이며 성장, 안정, 전통 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 51, "ecoConsciousness": 58, "priceSensitivity": 55, "digitalConsumption": 72}	{"taxTolerance": 50, "governmentTrust": 67, "policyAcceptance": 38, "regulationPreference": 66, "publicServiceSatisfaction": 68}	1
445	박정희	57	50-59	Female	경상남도	35.492853	128.239313	전문대 졸	200-350만원	프리랜서	다세대 가구	46	보수 정당 지지	69	{"economy": 44, "housing": 12, "welfare": -5, "security": 16, "environment": 1}	포털 뉴스	{성장,자유,다양성}	경상남도에 거주하는 50-59 프리랜서. 정치 성향은 보수이며 성장, 자유, 다양성 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 62, "ecoConsciousness": 45, "priceSensitivity": 73, "digitalConsumption": 48}	{"taxTolerance": 34, "governmentTrust": 57, "policyAcceptance": 58, "regulationPreference": 57, "publicServiceSatisfaction": 59}	1
446	김현우	57	50-59	Male	경상남도	35.521973	128.286083	전문대 졸	200-350만원	생산직	자녀 양육 가구	62	보수 정당 지지	86	{"economy": 45, "housing": 8, "welfare": -20, "security": 11, "environment": -7}	신문/팟캐스트	{전통,안전,공동체}	경상남도에 거주하는 50-59 생산직. 정치 성향은 보수이며 전통, 안전, 공동체 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 58, "ecoConsciousness": 44, "priceSensitivity": 54, "digitalConsumption": 71}	{"taxTolerance": 48, "governmentTrust": 35, "policyAcceptance": 53, "regulationPreference": 82, "publicServiceSatisfaction": 65}	1
447	임유준	56	50-59	Male	경상남도	35.485856	128.258164	대학원 졸	350-500만원	프리랜서	다세대 가구	11	중도 무당층	74	{"economy": 12, "housing": 12, "welfare": 20, "security": 10, "environment": -22}	신문/팟캐스트	{안정,혁신,다양성}	경상남도에 거주하는 50-59 프리랜서. 정치 성향은 중도이며 안정, 혁신, 다양성 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 72, "ecoConsciousness": 55, "priceSensitivity": 49, "digitalConsumption": 63}	{"taxTolerance": 54, "governmentTrust": 41, "policyAcceptance": 41, "regulationPreference": 49, "publicServiceSatisfaction": 59}	1
448	권민서	52	50-59	Male	경상남도	35.494848	128.203202	고졸 이하	350-500만원	서비스직	1인 가구	13	중도 무당층	72	{"economy": -1, "housing": 22, "welfare": 25, "security": 15, "environment": 24}	유튜브	{자유,전통,성장}	경상남도에 거주하는 50-59 서비스직. 정치 성향은 중도이며 자유, 전통, 성장 가치를 중시한다.	{"brandLoyalty": 25, "noveltySeeking": 50, "ecoConsciousness": 36, "priceSensitivity": 54, "digitalConsumption": 69}	{"taxTolerance": 33, "governmentTrust": 44, "policyAcceptance": 45, "regulationPreference": 63, "publicServiceSatisfaction": 78}	1
449	최지우	69	60-69	Female	경상남도	35.421453	128.280201	대학교 졸	350-500만원	은퇴	자녀 양육 가구	26	보수 성향 무당층	84	{"economy": 18, "housing": 16, "welfare": -30, "security": 5, "environment": 14}	지상파/종편 뉴스	{환경,공정,다양성}	경상남도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 환경, 공정, 다양성 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 55, "ecoConsciousness": 65, "priceSensitivity": 82, "digitalConsumption": 52}	{"taxTolerance": 56, "governmentTrust": 50, "policyAcceptance": 51, "regulationPreference": 76, "publicServiceSatisfaction": 58}	1
450	최서윤	69	60-69	Female	경상남도	35.465388	128.230408	전문대 졸	500-700만원	은퇴	다세대 가구	21	보수 성향 무당층	88	{"economy": 23, "housing": -12, "welfare": -24, "security": 15, "environment": 32}	유튜브	{전통,성장,공정}	경상남도에 거주하는 60-69 은퇴. 정치 성향은 중도이며 전통, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 36, "ecoConsciousness": 34, "priceSensitivity": 54, "digitalConsumption": 50}	{"taxTolerance": 58, "governmentTrust": 55, "policyAcceptance": 56, "regulationPreference": 59, "publicServiceSatisfaction": 68}	1
451	권미경	61	60-69	Female	경상남도	35.521397	128.235582	대학교 졸	200만원 미만	서비스직	1인 가구	43	보수 성향 무당층	76	{"economy": 7, "housing": 6, "welfare": 11, "security": 42, "environment": 6}	유튜브	{환경,성장,전통}	경상남도에 거주하는 60-69 서비스직. 정치 성향은 보수이며 환경, 성장, 전통 가치를 중시한다.	{"brandLoyalty": 61, "noveltySeeking": 47, "ecoConsciousness": 60, "priceSensitivity": 69, "digitalConsumption": 55}	{"taxTolerance": 28, "governmentTrust": 60, "policyAcceptance": 50, "regulationPreference": 74, "publicServiceSatisfaction": 62}	1
452	임은우	66	60-69	Male	경상남도	35.487094	128.239354	전문대 졸	200만원 미만	전문직	1인 가구	37	보수 성향 무당층	94	{"economy": -13, "housing": 8, "welfare": 0, "security": 23, "environment": 13}	신문/팟캐스트	{다양성,전통,안전}	경상남도에 거주하는 60-69 전문직. 정치 성향은 보수이며 다양성, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 48, "ecoConsciousness": 46, "priceSensitivity": 74, "digitalConsumption": 62}	{"taxTolerance": 30, "governmentTrust": 50, "policyAcceptance": 31, "regulationPreference": 70, "publicServiceSatisfaction": 74}	1
453	전민서	61	60-69	Male	경상남도	35.507331	128.193328	대학원 졸	200-350만원	사무직	1인 가구	50	보수 정당 지지	76	{"economy": 34, "housing": -1, "welfare": -9, "security": 13, "environment": 11}	SNS	{공동체,안정,안전}	경상남도에 거주하는 60-69 사무직. 정치 성향은 보수이며 공동체, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 51, "ecoConsciousness": 67, "priceSensitivity": 85, "digitalConsumption": 64}	{"taxTolerance": 56, "governmentTrust": 43, "policyAcceptance": 50, "regulationPreference": 43, "publicServiceSatisfaction": 52}	1
454	장수아	65	60-69	Male	경상남도	35.535884	128.219798	대학교 졸	200-350만원	은퇴	부부 가구	36	보수 성향 무당층	53	{"economy": 9, "housing": 1, "welfare": -6, "security": 29, "environment": 13}	SNS	{성장,공동체,다양성}	경상남도에 거주하는 60-69 은퇴. 정치 성향은 보수이며 성장, 공동체, 다양성 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 52, "ecoConsciousness": 47, "priceSensitivity": 64, "digitalConsumption": 62}	{"taxTolerance": 36, "governmentTrust": 52, "policyAcceptance": 35, "regulationPreference": 66, "publicServiceSatisfaction": 71}	1
455	조준서	82	70+	Female	경상남도	35.395666	128.283736	고졸 이하	700만원 이상	은퇴	부부 가구	39	보수 성향 무당층	85	{"economy": 25, "housing": 33, "welfare": 3, "security": 12, "environment": 2}	지상파/종편 뉴스	{성장,안정,공정}	경상남도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 성장, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 51, "ecoConsciousness": 52, "priceSensitivity": 39, "digitalConsumption": 46}	{"taxTolerance": 35, "governmentTrust": 57, "policyAcceptance": 43, "regulationPreference": 80, "publicServiceSatisfaction": 51}	1
456	송철수	79	70+	Female	경상남도	35.46787	128.291542	대학원 졸	350-500만원	은퇴	1인 가구	56	보수 정당 지지	89	{"economy": 13, "housing": -10, "welfare": -27, "security": 51, "environment": -24}	신문/팟캐스트	{안전,전통,공동체}	경상남도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안전, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 48, "ecoConsciousness": 38, "priceSensitivity": 56, "digitalConsumption": 64}	{"taxTolerance": 45, "governmentTrust": 28, "policyAcceptance": 38, "regulationPreference": 77, "publicServiceSatisfaction": 69}	1
457	신정희	81	70+	Male	경상남도	35.482919	128.29377	대학교 졸	200-350만원	은퇴	자녀 양육 가구	56	보수 정당 지지	82	{"economy": 20, "housing": -9, "welfare": -22, "security": 43, "environment": -10}	신문/팟캐스트	{공동체,혁신,전통}	경상남도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 공동체, 혁신, 전통 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 30, "ecoConsciousness": 63, "priceSensitivity": 81, "digitalConsumption": 47}	{"taxTolerance": 63, "governmentTrust": 56, "policyAcceptance": 53, "regulationPreference": 76, "publicServiceSatisfaction": 81}	1
458	윤광수	82	70+	Male	경상남도	35.44344	128.128804	대학원 졸	200-350만원	은퇴	다세대 가구	8	중도 무당층	95	{"economy": -3, "housing": 27, "welfare": 1, "security": -4, "environment": -13}	SNS	{안정,안전,혁신}	경상남도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안정, 안전, 혁신 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 37, "ecoConsciousness": 62, "priceSensitivity": 81, "digitalConsumption": 52}	{"taxTolerance": 52, "governmentTrust": 55, "policyAcceptance": 52, "regulationPreference": 51, "publicServiceSatisfaction": 63}	1
459	윤동현	18	18-29	Female	제주특별자치도	33.535897	126.618103	대학원 졸	500-700만원	서비스직	다세대 가구	-36	진보 성향 무당층	30	{"economy": -19, "housing": 39, "welfare": 42, "security": -6, "environment": 44}	포털 뉴스	{다양성,안정,자유}	제주특별자치도에 거주하는 18-29 서비스직. 정치 성향은 진보이며 다양성, 안정, 자유 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 83, "ecoConsciousness": 60, "priceSensitivity": 42, "digitalConsumption": 85}	{"taxTolerance": 54, "governmentTrust": 39, "policyAcceptance": 36, "regulationPreference": 71, "publicServiceSatisfaction": 68}	1
460	이서연	28	18-29	Male	제주특별자치도	33.486886	126.586858	고졸 이하	200-350만원	주부	다세대 가구	-28	진보 성향 무당층	70	{"economy": -51, "housing": 4, "welfare": 30, "security": -16, "environment": 45}	유튜브	{공동체,안전,혁신}	제주특별자치도에 거주하는 18-29 주부. 정치 성향은 중도이며 공동체, 안전, 혁신 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 57, "ecoConsciousness": 50, "priceSensitivity": 67, "digitalConsumption": 96}	{"taxTolerance": 55, "governmentTrust": 50, "policyAcceptance": 38, "regulationPreference": 66, "publicServiceSatisfaction": 74}	1
461	임민준	33	30-39	Female	제주특별자치도	33.515481	126.620029	대학교 졸	200-350만원	사무직	1인 가구	1	중도 무당층	56	{"economy": 18, "housing": 2, "welfare": 11, "security": 10, "environment": 2}	SNS	{혁신,안전,공정}	제주특별자치도에 거주하는 30-39 사무직. 정치 성향은 중도이며 혁신, 안전, 공정 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 73, "ecoConsciousness": 37, "priceSensitivity": 78, "digitalConsumption": 64}	{"taxTolerance": 52, "governmentTrust": 45, "policyAcceptance": 53, "regulationPreference": 63, "publicServiceSatisfaction": 61}	1
462	강건우	36	30-39	Male	제주특별자치도	33.566028	126.489065	대학원 졸	200만원 미만	은퇴	자녀 양육 가구	11	중도 무당층	51	{"economy": -22, "housing": 12, "welfare": -14, "security": 7, "environment": 26}	유튜브	{환경,안정,공정}	제주특별자치도에 거주하는 30-39 은퇴. 정치 성향은 중도이며 환경, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 64, "ecoConsciousness": 67, "priceSensitivity": 73, "digitalConsumption": 74}	{"taxTolerance": 49, "governmentTrust": 33, "policyAcceptance": 59, "regulationPreference": 66, "publicServiceSatisfaction": 70}	1
463	한건우	41	40-49	Female	제주특별자치도	33.431083	126.594393	대학교 졸	700만원 이상	주부	1인 가구	-17	진보 성향 무당층	59	{"economy": -13, "housing": 20, "welfare": 21, "security": -21, "environment": 9}	유튜브	{공정,공동체,안정}	제주특별자치도에 거주하는 40-49 주부. 정치 성향은 중도이며 공정, 공동체, 안정 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 73, "ecoConsciousness": 31, "priceSensitivity": 58, "digitalConsumption": 81}	{"taxTolerance": 69, "governmentTrust": 45, "policyAcceptance": 53, "regulationPreference": 60, "publicServiceSatisfaction": 82}	1
464	안영수	40	40-49	Male	제주특별자치도	33.533489	126.62825	고졸 이하	350-500만원	은퇴	부부 가구	16	보수 성향 무당층	48	{"economy": 10, "housing": 15, "welfare": 1, "security": 13, "environment": 19}	신문/팟캐스트	{전통,자유,다양성}	제주특별자치도에 거주하는 40-49 은퇴. 정치 성향은 중도이며 전통, 자유, 다양성 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 48, "ecoConsciousness": 51, "priceSensitivity": 77, "digitalConsumption": 57}	{"taxTolerance": 57, "governmentTrust": 49, "policyAcceptance": 48, "regulationPreference": 57, "publicServiceSatisfaction": 50}	1
465	서철수	51	50-59	Female	제주특별자치도	33.422855	126.609316	대학교 졸	500-700만원	프리랜서	자녀 양육 가구	37	보수 성향 무당층	62	{"economy": 39, "housing": -1, "welfare": -37, "security": 32, "environment": 25}	지상파/종편 뉴스	{성장,다양성,환경}	제주특별자치도에 거주하는 50-59 프리랜서. 정치 성향은 보수이며 성장, 다양성, 환경 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 62, "ecoConsciousness": 61, "priceSensitivity": 51, "digitalConsumption": 70}	{"taxTolerance": 57, "governmentTrust": 61, "policyAcceptance": 45, "regulationPreference": 68, "publicServiceSatisfaction": 67}	1
466	홍채원	58	50-59	Male	제주특별자치도	33.518331	126.441774	고졸 이하	500-700만원	학생	자녀 양육 가구	12	중도 무당층	60	{"economy": 14, "housing": 3, "welfare": 23, "security": 8, "environment": 21}	지상파/종편 뉴스	{자유,안정,환경}	제주특별자치도에 거주하는 50-59 학생. 정치 성향은 중도이며 자유, 안정, 환경 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 55, "ecoConsciousness": 46, "priceSensitivity": 57, "digitalConsumption": 51}	{"taxTolerance": 46, "governmentTrust": 54, "policyAcceptance": 52, "regulationPreference": 71, "publicServiceSatisfaction": 63}	1
467	송지민	64	60-69	Female	제주특별자치도	33.557203	126.546076	대학원 졸	350-500만원	자영업	부부 가구	15	보수 성향 무당층	57	{"economy": -15, "housing": 0, "welfare": -5, "security": -4, "environment": 15}	포털 뉴스	{전통,환경,성장}	제주특별자치도에 거주하는 60-69 자영업. 정치 성향은 중도이며 전통, 환경, 성장 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 48, "ecoConsciousness": 43, "priceSensitivity": 66, "digitalConsumption": 49}	{"taxTolerance": 56, "governmentTrust": 47, "policyAcceptance": 42, "regulationPreference": 82, "publicServiceSatisfaction": 60}	1
468	신동현	66	60-69	Male	제주특별자치도	33.503447	126.435077	전문대 졸	200-350만원	서비스직	1인 가구	43	보수 성향 무당층	63	{"economy": 15, "housing": 11, "welfare": -6, "security": 10, "environment": -9}	신문/팟캐스트	{혁신,전통,성장}	제주특별자치도에 거주하는 60-69 서비스직. 정치 성향은 보수이며 혁신, 전통, 성장 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 51, "ecoConsciousness": 41, "priceSensitivity": 68, "digitalConsumption": 49}	{"taxTolerance": 72, "governmentTrust": 40, "policyAcceptance": 47, "regulationPreference": 70, "publicServiceSatisfaction": 76}	1
469	전서연	82	70+	Female	제주특별자치도	33.552685	126.62767	전문대 졸	200만원 미만	은퇴	자녀 양육 가구	52	보수 정당 지지	90	{"economy": 27, "housing": 9, "welfare": -27, "security": 45, "environment": 13}	유튜브	{공동체,전통,안전}	제주특별자치도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 공동체, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 50, "ecoConsciousness": 49, "priceSensitivity": 80, "digitalConsumption": 55}	{"taxTolerance": 49, "governmentTrust": 47, "policyAcceptance": 51, "regulationPreference": 59, "publicServiceSatisfaction": 67}	1
470	권영수	80	70+	Male	제주특별자치도	33.530109	126.584584	전문대 졸	350-500만원	은퇴	부부 가구	10	중도 무당층	99	{"economy": 12, "housing": 22, "welfare": 20, "security": 20, "environment": 18}	유튜브	{공동체,환경,다양성}	제주특별자치도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공동체, 환경, 다양성 가치를 중시한다.	{"brandLoyalty": 50, "noveltySeeking": 55, "ecoConsciousness": 54, "priceSensitivity": 68, "digitalConsumption": 62}	{"taxTolerance": 36, "governmentTrust": 48, "policyAcceptance": 57, "regulationPreference": 58, "publicServiceSatisfaction": 56}	1
471	강민준	27	18-29	Female	강원특별자치도	37.840275	128.228901	대학원 졸	350-500만원	전문직	1인 가구	-31	진보 성향 무당층	62	{"economy": -13, "housing": 19, "welfare": 19, "security": -14, "environment": 62}	SNS	{안정,혁신,공정}	강원특별자치도에 거주하는 18-29 전문직. 정치 성향은 중도이며 안정, 혁신, 공정 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 59, "ecoConsciousness": 66, "priceSensitivity": 75, "digitalConsumption": 74}	{"taxTolerance": 49, "governmentTrust": 36, "policyAcceptance": 56, "regulationPreference": 68, "publicServiceSatisfaction": 91}	1
472	안수아	26	18-29	Male	강원특별자치도	37.816343	128.244757	대학원 졸	200-350만원	공무원	부부 가구	-45	진보 정당 지지	41	{"economy": -46, "housing": 20, "welfare": 44, "security": -28, "environment": 72}	신문/팟캐스트	{환경,안전,성장}	강원특별자치도에 거주하는 18-29 공무원. 정치 성향은 진보이며 환경, 안전, 성장 가치를 중시한다.	{"brandLoyalty": 12, "noveltySeeking": 81, "ecoConsciousness": 59, "priceSensitivity": 68, "digitalConsumption": 93}	{"taxTolerance": 49, "governmentTrust": 52, "policyAcceptance": 29, "regulationPreference": 53, "publicServiceSatisfaction": 76}	1
473	김경숙	30	30-39	Female	강원특별자치도	37.873145	128.240078	대학원 졸	200-350만원	생산직	다세대 가구	-46	진보 정당 지지	43	{"economy": -36, "housing": 32, "welfare": 23, "security": 4, "environment": 41}	신문/팟캐스트	{자유,다양성,성장}	강원특별자치도에 거주하는 30-39 생산직. 정치 성향은 진보이며 자유, 다양성, 성장 가치를 중시한다.	{"brandLoyalty": 23, "noveltySeeking": 91, "ecoConsciousness": 48, "priceSensitivity": 69, "digitalConsumption": 83}	{"taxTolerance": 28, "governmentTrust": 37, "policyAcceptance": 39, "regulationPreference": 53, "publicServiceSatisfaction": 69}	1
474	오동현	31	30-39	Male	강원특별자치도	37.901429	128.106744	대학원 졸	200만원 미만	학생	부부 가구	19	보수 성향 무당층	42	{"economy": 35, "housing": 13, "welfare": -8, "security": 11, "environment": 15}	유튜브	{전통,자유,공정}	강원특별자치도에 거주하는 30-39 학생. 정치 성향은 중도이며 전통, 자유, 공정 가치를 중시한다.	{"brandLoyalty": 25, "noveltySeeking": 66, "ecoConsciousness": 40, "priceSensitivity": 63, "digitalConsumption": 64}	{"taxTolerance": 77, "governmentTrust": 39, "policyAcceptance": 57, "regulationPreference": 36, "publicServiceSatisfaction": 84}	1
475	장지우	40	40-49	Female	강원특별자치도	37.857985	128.088885	전문대 졸	700만원 이상	주부	부부 가구	-35	진보 성향 무당층	82	{"economy": 0, "housing": 1, "welfare": 30, "security": 2, "environment": 28}	지상파/종편 뉴스	{혁신,안전,전통}	강원특별자치도에 거주하는 40-49 주부. 정치 성향은 진보이며 혁신, 안전, 전통 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 45, "ecoConsciousness": 50, "priceSensitivity": 49, "digitalConsumption": 91}	{"taxTolerance": 39, "governmentTrust": 43, "policyAcceptance": 47, "regulationPreference": 71, "publicServiceSatisfaction": 68}	1
476	서성호	46	40-49	Male	강원특별자치도	37.799337	128.132823	전문대 졸	350-500만원	공무원	1인 가구	34	보수 성향 무당층	75	{"economy": 25, "housing": 14, "welfare": 12, "security": 33, "environment": 26}	유튜브	{전통,환경,자유}	강원특별자치도에 거주하는 40-49 공무원. 정치 성향은 보수이며 전통, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 86, "ecoConsciousness": 34, "priceSensitivity": 54, "digitalConsumption": 76}	{"taxTolerance": 49, "governmentTrust": 52, "policyAcceptance": 77, "regulationPreference": 64, "publicServiceSatisfaction": 73}	1
477	김지호	50	50-59	Female	강원특별자치도	37.819207	128.120274	대학원 졸	350-500만원	주부	다세대 가구	4	중도 무당층	64	{"economy": -2, "housing": 18, "welfare": -2, "security": 22, "environment": 21}	포털 뉴스	{혁신,다양성,자유}	강원특별자치도에 거주하는 50-59 주부. 정치 성향은 중도이며 혁신, 다양성, 자유 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 69, "ecoConsciousness": 35, "priceSensitivity": 61, "digitalConsumption": 80}	{"taxTolerance": 61, "governmentTrust": 31, "policyAcceptance": 43, "regulationPreference": 69, "publicServiceSatisfaction": 64}	1
478	장정희	55	50-59	Female	강원특별자치도	37.880162	128.092136	대학원 졸	200-350만원	공무원	자녀 양육 가구	38	보수 성향 무당층	73	{"economy": 26, "housing": -3, "welfare": 23, "security": 15, "environment": -7}	유튜브	{혁신,성장,다양성}	강원특별자치도에 거주하는 50-59 공무원. 정치 성향은 보수이며 혁신, 성장, 다양성 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 82, "ecoConsciousness": 59, "priceSensitivity": 65, "digitalConsumption": 58}	{"taxTolerance": 59, "governmentTrust": 27, "policyAcceptance": 44, "regulationPreference": 63, "publicServiceSatisfaction": 72}	1
479	정서연	50	50-59	Male	강원특별자치도	37.796279	128.234678	대학교 졸	350-500만원	서비스직	1인 가구	-9	중도 무당층	79	{"economy": -38, "housing": 24, "welfare": -18, "security": 14, "environment": 11}	SNS	{공동체,성장,전통}	강원특별자치도에 거주하는 50-59 서비스직. 정치 성향은 중도이며 공동체, 성장, 전통 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 52, "ecoConsciousness": 59, "priceSensitivity": 64, "digitalConsumption": 76}	{"taxTolerance": 55, "governmentTrust": 36, "policyAcceptance": 33, "regulationPreference": 64, "publicServiceSatisfaction": 80}	1
480	한동현	56	50-59	Male	강원특별자치도	37.763013	128.198523	전문대 졸	700만원 이상	전문직	다세대 가구	26	보수 성향 무당층	48	{"economy": -13, "housing": 11, "welfare": -37, "security": 7, "environment": 15}	포털 뉴스	{혁신,자유,전통}	강원특별자치도에 거주하는 50-59 전문직. 정치 성향은 중도이며 혁신, 자유, 전통 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 47, "ecoConsciousness": 60, "priceSensitivity": 44, "digitalConsumption": 77}	{"taxTolerance": 50, "governmentTrust": 61, "policyAcceptance": 46, "regulationPreference": 66, "publicServiceSatisfaction": 74}	1
481	류유준	64	60-69	Female	강원특별자치도	37.767627	128.232701	대학교 졸	350-500만원	사무직	자녀 양육 가구	73	보수 정당 지지	93	{"economy": 53, "housing": -29, "welfare": -36, "security": 83, "environment": -7}	신문/팟캐스트	{자유,전통,혁신}	강원특별자치도에 거주하는 60-69 사무직. 정치 성향은 보수이며 자유, 전통, 혁신 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 65, "ecoConsciousness": 52, "priceSensitivity": 79, "digitalConsumption": 60}	{"taxTolerance": 55, "governmentTrust": 48, "policyAcceptance": 75, "regulationPreference": 72, "publicServiceSatisfaction": 74}	1
482	오광수	60	60-69	Male	강원특별자치도	37.902433	128.12677	대학원 졸	500-700만원	서비스직	다세대 가구	66	보수 정당 지지	58	{"economy": 52, "housing": 23, "welfare": 2, "security": 27, "environment": -36}	SNS	{성장,환경,전통}	강원특별자치도에 거주하는 60-69 서비스직. 정치 성향은 보수이며 성장, 환경, 전통 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 63, "ecoConsciousness": 50, "priceSensitivity": 45, "digitalConsumption": 41}	{"taxTolerance": 53, "governmentTrust": 43, "policyAcceptance": 47, "regulationPreference": 46, "publicServiceSatisfaction": 63}	1
483	한하은	80	70+	Female	강원특별자치도	37.886204	128.117655	대학원 졸	200만원 미만	은퇴	부부 가구	69	보수 정당 지지	99	{"economy": 42, "housing": 3, "welfare": -34, "security": 26, "environment": -42}	유튜브	{다양성,안정,안전}	강원특별자치도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 다양성, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 56, "ecoConsciousness": 40, "priceSensitivity": 81, "digitalConsumption": 71}	{"taxTolerance": 38, "governmentTrust": 44, "policyAcceptance": 49, "regulationPreference": 60, "publicServiceSatisfaction": 59}	1
484	조동현	79	70+	Male	강원특별자치도	37.794422	128.089306	전문대 졸	350-500만원	은퇴	다세대 가구	25	보수 성향 무당층	99	{"economy": 19, "housing": 5, "welfare": -15, "security": 33, "environment": -4}	유튜브	{안정,공동체,공정}	강원특별자치도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안정, 공동체, 공정 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 64, "ecoConsciousness": 34, "priceSensitivity": 46, "digitalConsumption": 57}	{"taxTolerance": 62, "governmentTrust": 57, "policyAcceptance": 53, "regulationPreference": 64, "publicServiceSatisfaction": 56}	1
485	전지민	28	18-29	Female	전북특별자치도	35.824951	127.067968	대학원 졸	500-700만원	은퇴	1인 가구	-16	진보 성향 무당층	55	{"economy": 1, "housing": 27, "welfare": 13, "security": 9, "environment": 20}	신문/팟캐스트	{환경,공동체,혁신}	전북특별자치도에 거주하는 18-29 은퇴. 정치 성향은 중도이며 환경, 공동체, 혁신 가치를 중시한다.	{"brandLoyalty": 61, "noveltySeeking": 87, "ecoConsciousness": 67, "priceSensitivity": 55, "digitalConsumption": 78}	{"taxTolerance": 63, "governmentTrust": 32, "policyAcceptance": 69, "regulationPreference": 65, "publicServiceSatisfaction": 65}	1
486	조경숙	28	18-29	Male	전북특별자치도	35.873999	127.146123	전문대 졸	200-350만원	주부	자녀 양육 가구	-54	진보 정당 지지	36	{"economy": -46, "housing": 54, "welfare": 18, "security": -36, "environment": 51}	포털 뉴스	{전통,안전,공정}	전북특별자치도에 거주하는 18-29 주부. 정치 성향은 진보이며 전통, 안전, 공정 가치를 중시한다.	{"brandLoyalty": 34, "noveltySeeking": 93, "ecoConsciousness": 49, "priceSensitivity": 75, "digitalConsumption": 62}	{"taxTolerance": 47, "governmentTrust": 28, "policyAcceptance": 48, "regulationPreference": 64, "publicServiceSatisfaction": 38}	1
487	강지우	36	30-39	Female	전북특별자치도	35.833287	127.040671	전문대 졸	350-500만원	생산직	자녀 양육 가구	-43	진보 성향 무당층	77	{"economy": -26, "housing": 34, "welfare": -5, "security": 0, "environment": 29}	유튜브	{공정,환경,혁신}	전북특별자치도에 거주하는 30-39 생산직. 정치 성향은 진보이며 공정, 환경, 혁신 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 78, "ecoConsciousness": 70, "priceSensitivity": 73, "digitalConsumption": 73}	{"taxTolerance": 26, "governmentTrust": 45, "policyAcceptance": 37, "regulationPreference": 54, "publicServiceSatisfaction": 71}	1
488	신지아	33	30-39	Male	전북특별자치도	35.830369	127.189314	전문대 졸	200-350만원	사무직	1인 가구	-28	진보 성향 무당층	51	{"economy": -45, "housing": 17, "welfare": 26, "security": -24, "environment": 44}	지상파/종편 뉴스	{안정,혁신,전통}	전북특별자치도에 거주하는 30-39 사무직. 정치 성향은 중도이며 안정, 혁신, 전통 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 60, "ecoConsciousness": 45, "priceSensitivity": 69, "digitalConsumption": 99}	{"taxTolerance": 53, "governmentTrust": 38, "policyAcceptance": 30, "regulationPreference": 66, "publicServiceSatisfaction": 66}	1
489	조현우	48	40-49	Female	전북특별자치도	35.846527	127.13513	대학원 졸	200-350만원	은퇴	1인 가구	-71	진보 정당 지지	78	{"economy": -32, "housing": 27, "welfare": 31, "security": -21, "environment": 38}	포털 뉴스	{공동체,안정,전통}	전북특별자치도에 거주하는 40-49 은퇴. 정치 성향은 진보이며 공동체, 안정, 전통 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 70, "ecoConsciousness": 43, "priceSensitivity": 55, "digitalConsumption": 50}	{"taxTolerance": 46, "governmentTrust": 34, "policyAcceptance": 32, "regulationPreference": 68, "publicServiceSatisfaction": 85}	1
490	박하은	41	40-49	Female	전북특별자치도	35.866815	127.040479	대학교 졸	500-700만원	서비스직	다세대 가구	-43	진보 성향 무당층	85	{"economy": -23, "housing": 34, "welfare": 53, "security": -7, "environment": 42}	지상파/종편 뉴스	{성장,공동체,자유}	전북특별자치도에 거주하는 40-49 서비스직. 정치 성향은 진보이며 성장, 공동체, 자유 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 58, "ecoConsciousness": 51, "priceSensitivity": 65, "digitalConsumption": 78}	{"taxTolerance": 35, "governmentTrust": 41, "policyAcceptance": 64, "regulationPreference": 63, "publicServiceSatisfaction": 69}	1
491	홍준서	49	40-49	Male	전북특별자치도	35.844752	127.073176	대학교 졸	350-500만원	전문직	1인 가구	-26	진보 성향 무당층	55	{"economy": -61, "housing": 36, "welfare": 26, "security": 5, "environment": 32}	SNS	{안전,환경,자유}	전북특별자치도에 거주하는 40-49 전문직. 정치 성향은 중도이며 안전, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 56, "ecoConsciousness": 54, "priceSensitivity": 70, "digitalConsumption": 69}	{"taxTolerance": 53, "governmentTrust": 27, "policyAcceptance": 24, "regulationPreference": 56, "publicServiceSatisfaction": 56}	1
492	송건우	48	40-49	Male	전북특별자치도	35.79946	127.065239	대학원 졸	350-500만원	공무원	자녀 양육 가구	1	중도 무당층	77	{"economy": -11, "housing": 37, "welfare": 15, "security": -7, "environment": -3}	신문/팟캐스트	{안전,환경,자유}	전북특별자치도에 거주하는 40-49 공무원. 정치 성향은 중도이며 안전, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 53, "ecoConsciousness": 59, "priceSensitivity": 58, "digitalConsumption": 64}	{"taxTolerance": 42, "governmentTrust": 52, "policyAcceptance": 44, "regulationPreference": 68, "publicServiceSatisfaction": 55}	1
493	강혜진	50	50-59	Female	전북특별자치도	35.784004	127.026088	대학교 졸	700만원 이상	생산직	다세대 가구	4	중도 무당층	60	{"economy": 10, "housing": 31, "welfare": 2, "security": 19, "environment": 17}	지상파/종편 뉴스	{전통,안정,공정}	전북특별자치도에 거주하는 50-59 생산직. 정치 성향은 중도이며 전통, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 65, "ecoConsciousness": 34, "priceSensitivity": 39, "digitalConsumption": 77}	{"taxTolerance": 51, "governmentTrust": 41, "policyAcceptance": 51, "regulationPreference": 48, "publicServiceSatisfaction": 64}	1
494	송지호	51	50-59	Female	전북특별자치도	35.857918	127.106035	대학원 졸	350-500만원	전문직	1인 가구	-28	진보 성향 무당층	84	{"economy": -22, "housing": 16, "welfare": 45, "security": -27, "environment": 39}	신문/팟캐스트	{안정,공정,안전}	전북특별자치도에 거주하는 50-59 전문직. 정치 성향은 중도이며 안정, 공정, 안전 가치를 중시한다.	{"brandLoyalty": 62, "noveltySeeking": 65, "ecoConsciousness": 62, "priceSensitivity": 63, "digitalConsumption": 71}	{"taxTolerance": 55, "governmentTrust": 54, "policyAcceptance": 43, "regulationPreference": 46, "publicServiceSatisfaction": 47}	1
495	오서윤	59	50-59	Male	전북특별자치도	35.743479	127.065427	대학원 졸	700만원 이상	서비스직	다세대 가구	-66	진보 정당 지지	90	{"economy": -83, "housing": 14, "welfare": 52, "security": -19, "environment": 29}	포털 뉴스	{전통,자유,안전}	전북특별자치도에 거주하는 50-59 서비스직. 정치 성향은 진보이며 전통, 자유, 안전 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 40, "ecoConsciousness": 61, "priceSensitivity": 55, "digitalConsumption": 57}	{"taxTolerance": 67, "governmentTrust": 42, "policyAcceptance": 67, "regulationPreference": 82, "publicServiceSatisfaction": 69}	1
496	강유준	58	50-59	Male	전북특별자치도	35.741512	127.143372	전문대 졸	500-700만원	주부	자녀 양육 가구	-4	중도 무당층	65	{"economy": -7, "housing": 32, "welfare": 28, "security": 9, "environment": 22}	신문/팟캐스트	{안정,자유,공정}	전북특별자치도에 거주하는 50-59 주부. 정치 성향은 중도이며 안정, 자유, 공정 가치를 중시한다.	{"brandLoyalty": 60, "noveltySeeking": 50, "ecoConsciousness": 57, "priceSensitivity": 33, "digitalConsumption": 62}	{"taxTolerance": 66, "governmentTrust": 41, "policyAcceptance": 57, "regulationPreference": 64, "publicServiceSatisfaction": 78}	1
497	최지아	61	60-69	Female	전북특별자치도	35.757253	127.19327	고졸 이하	350-500만원	학생	부부 가구	-6	중도 무당층	83	{"economy": -2, "housing": 16, "welfare": -13, "security": 2, "environment": 40}	유튜브	{안정,전통,안전}	전북특별자치도에 거주하는 60-69 학생. 정치 성향은 중도이며 안정, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 56, "noveltySeeking": 61, "ecoConsciousness": 57, "priceSensitivity": 54, "digitalConsumption": 42}	{"taxTolerance": 34, "governmentTrust": 50, "policyAcceptance": 46, "regulationPreference": 54, "publicServiceSatisfaction": 52}	1
380	이서연	70	70+	Female	충청남도	36.600852	126.762317	대학교 졸	200-350만원	은퇴	다세대 가구	18	보수 성향 무당층	97	{"economy": 4, "housing": 32, "welfare": 1, "security": 22, "environment": 31}	포털 뉴스	{혁신,공정,안전}	충청남도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 혁신, 공정, 안전 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 51, "ecoConsciousness": 61, "priceSensitivity": 75, "digitalConsumption": 58}	{"taxTolerance": 50, "governmentTrust": 56, "policyAcceptance": 58, "regulationPreference": 73, "publicServiceSatisfaction": 62}	1
381	안동현	78	70+	Female	충청남도	36.626215	126.574323	대학원 졸	200-350만원	은퇴	1인 가구	7	중도 무당층	99	{"economy": 4, "housing": -10, "welfare": 27, "security": 33, "environment": 45}	지상파/종편 뉴스	{안전,혁신,성장}	충청남도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 안전, 혁신, 성장 가치를 중시한다.	{"brandLoyalty": 60, "noveltySeeking": 61, "ecoConsciousness": 49, "priceSensitivity": 67, "digitalConsumption": 55}	{"taxTolerance": 54, "governmentTrust": 48, "policyAcceptance": 57, "regulationPreference": 60, "publicServiceSatisfaction": 58}	1
382	임경숙	83	70+	Male	충청남도	36.678885	126.610957	고졸 이하	200만원 미만	은퇴	부부 가구	62	보수 정당 지지	97	{"economy": 26, "housing": -6, "welfare": -32, "security": 39, "environment": -13}	지상파/종편 뉴스	{자유,혁신,성장}	충청남도에 거주하는 70+ 은퇴. 정치 성향은 보수이며 자유, 혁신, 성장 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 50, "ecoConsciousness": 34, "priceSensitivity": 64, "digitalConsumption": 71}	{"taxTolerance": 22, "governmentTrust": 71, "policyAcceptance": 43, "regulationPreference": 61, "publicServiceSatisfaction": 41}	1
498	전은우	68	60-69	Male	전북특별자치도	35.770253	127.043795	고졸 이하	200-350만원	은퇴	다세대 가구	-35	진보 성향 무당층	89	{"economy": -58, "housing": 32, "welfare": 19, "security": 17, "environment": 50}	신문/팟캐스트	{안정,다양성,안전}	전북특별자치도에 거주하는 60-69 은퇴. 정치 성향은 진보이며 안정, 다양성, 안전 가치를 중시한다.	{"brandLoyalty": 73, "noveltySeeking": 41, "ecoConsciousness": 48, "priceSensitivity": 65, "digitalConsumption": 52}	{"taxTolerance": 48, "governmentTrust": 56, "policyAcceptance": 67, "regulationPreference": 73, "publicServiceSatisfaction": 66}	1
499	류민준	82	70+	Female	전북특별자치도	35.847646	127.091653	전문대 졸	350-500만원	은퇴	자녀 양육 가구	-3	중도 무당층	80	{"economy": -31, "housing": -22, "welfare": 7, "security": -3, "environment": 23}	유튜브	{공정,전통,안전}	전북특별자치도에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공정, 전통, 안전 가치를 중시한다.	{"brandLoyalty": 63, "noveltySeeking": 51, "ecoConsciousness": 42, "priceSensitivity": 70, "digitalConsumption": 70}	{"taxTolerance": 38, "governmentTrust": 50, "policyAcceptance": 38, "regulationPreference": 66, "publicServiceSatisfaction": 48}	1
500	오민서	80	70+	Male	전북특별자치도	35.80342	127.198452	대학교 졸	200만원 미만	은퇴	부부 가구	-48	진보 정당 지지	88	{"economy": -14, "housing": 33, "welfare": 56, "security": -19, "environment": 4}	포털 뉴스	{안전,환경,혁신}	전북특별자치도에 거주하는 70+ 은퇴. 정치 성향은 진보이며 안전, 환경, 혁신 가치를 중시한다.	{"brandLoyalty": 73, "noveltySeeking": 63, "ecoConsciousness": 56, "priceSensitivity": 78, "digitalConsumption": 56}	{"taxTolerance": 30, "governmentTrust": 53, "policyAcceptance": 54, "regulationPreference": 86, "publicServiceSatisfaction": 70}	1
\.


--
-- Data for Name: calibration_settings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.calibration_settings (id, method, benchmark_weight, recency_weight, shrinkage_factor, outlier_trim_pct, description, updated_at, apply_to_population, user_id) FROM stdin;
1	베이지안 축소 (Bayesian Shrinkage)	0.6	0.3	0.4	5	과거 가상 이벤트 벤치마크에 가중치를 두고, 최근 데이터에 더 큰 비중을 부여하여 원시 예측을 보정합니다.	2026-06-17 09:25:00.093+00	t	1
2	베이지안 축소 (Bayesian Shrinkage)	0.6	0.3	0.4	5	과거 가상 이벤트 벤치마크에 가중치를 두고, 최근 데이터에 더 큰 비중을 부여하여 원시 예측을 보정합니다.	2026-06-18 03:38:35.779491+00	f	2
\.


--
-- Data for Name: calibrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.calibrations (id, title, event_type, target_date, metric, actual_value, raw_prediction, calibrated_prediction, raw_error, calibrated_error, method, product, user_id) FROM stdin;
1	2024 총선 서울 정당 득표율	선거	2024-04-10	여당 득표율(%)	42.3	46.8	43.1	4.5	0.8	사후 인구가중 + 성향 보정	Dynamo	1
2	2026 지방선거 서울시장 지지율	선거	2026-06-03	현직 지지율(%)	51.2	55.9	52.4	4.7	1.2	베이지안 수축 보정	Dynamo	1
3	생활폐기물 종량제 인상 수용도	정책	2025-09-15	찬성 비율(%)	38.7	31.2	37	-7.5	-1.7	이슈 민감도 재가중	Dynamo	1
4	심야 대중교통 확대 지지율	정책	2025-11-02	지지 비율(%)	67.4	73.1	68.8	5.7	1.4	사후 인구가중 + 성향 보정	Dynamo	1
5	신제품 구독 서비스 출시 반응	시장	2025-12-10	구매 의향(%)	24.6	30.4	25.9	5.8	1.3	세그먼트 캘리브레이션	Dynamo	1
6	청년 주거 지원 정책 인지·지지	정책	2026-01-20	지지 비율(%)	58.9	64.2	60.1	5.3	1.2	베이지안 수축 보정	Dynamo	1
7	탄소중립 교통 분담금 도입 찬반	정책	2026-02-14	찬성 비율(%)	33.5	27	32.2	-6.5	-1.3	이슈 민감도 재가중	Dynamo	1
9	신제품 A 출시 반응	제품 반응	2025-03-15	구매의향률	42	51	47.4	9	5.4	베이지안 축소 (Bayesian Shrinkage)	Lumen	1
10	봄 캠페인 전환율	제품 반응	2025-05-20	전환율	18	24	21.6	6	3.6	베이지안 축소 (Bayesian Shrinkage)	Lumen	1
11	프리미엄 요금제 수용	여론조사	2025-06-01	가입의향률	29	35	32.6	6	3.6	베이지안 축소 (Bayesian Shrinkage)	Lumen	1
12	주 4일제 시범 수용	정책 반응	2025-02-10	찬성률	58	66	62.8	8	4.8	베이지안 축소 (Bayesian Shrinkage)	Seraph	1
13	청년 주거지원 정책	정책 반응	2025-04-05	수용률	71	64	66.8	7	4.2	베이지안 축소 (Bayesian Shrinkage)	Seraph	1
14	대중교통 요금 인상안	여론조사	2025-05-30	찬성률	33	41	37.8	8	4.8	베이지안 축소 (Bayesian Shrinkage)	Seraph	1
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
103	한국갤럽 데일리 오피니언 (경기 전망)	한국갤럽	여론조사	경제 태도(시장·정부 역할)	1000	전국 만 18세 이상	2025	https://www.gallup.co.kr/gallupdb/report.asp
104	통계청 2023년 사회조사 (복지)	통계청	여론조사	복지 태도(복지 확대)	36000	전국 만 13세 이상	2023	https://kostat.go.kr/board.es?mid=a10301010000&bid=219&act=view&list_no=427913
105	서울대 통일평화연구원 통일의식조사	서울대학교 통일평화연구원	여론조사	안보 태도(대북 인식)	1200	전국 17개 시·도 만 19세 이상	2024	https://ipus.snu.ac.kr/blog/archives/news/9627
106	KEI 2024 국민환경의식조사	한국환경연구원(KEI)	여론조사	환경 태도(기후변화 인식)	3040	전국 성인 (웹조사)	2024	https://www.kei.re.kr/elibList.es?mid=a10101010000&elibName=researchreport&act=view&c_id=766481
107	국토교통부 2023년 주거실태조사	국토교통부	여론조사	주거 태도(보유의사·지원)	61000	전국 약 6.1만 가구	2023	https://www.molit.go.kr/USR/NEWS/m_71/dtl.jsp?lcmspage=1&id=95090538
108	방송통신위원회 2024 방송매체 이용행태조사	방송통신위원회	소비자조사	디지털소비(OTT·스마트폰 이용)	8316	전국 17개 시·도 13세 이상	2024	https://www.kcc.go.kr/user.do?mode=view&page=A05030000&dc=K05030000&boardId=1113&boardSeq=64951
109	과학기술정보통신부 2024 인터넷이용실태조사	과학기술정보통신부	소비자조사	신제품수용(AI·신기술 수용)	60229	전국 25,509가구 만 3세 이상	2024	https://www.korea.kr/briefing/pressReleaseView.do?newsId=156681493
110	한국소비자원 친환경 소비 제도 이용 실태조사	한국소비자원	소비자조사	친환경소비(인식·실천)	3200	전국 성인 소비자	2025	https://www.kca.go.kr/home/board/download.do?menukey=4002&fno=10046976&bid=00000013&did=1003867815
111	한국은행 소비자동향조사	한국은행	소비자조사	가격민감도(물가 전망)	2500	전국 약 2,500가구 (월간)	2025	https://www.bok.or.kr/portal/bbs/B0000501/view.do?nttId=10095310&menuNo=201264
112	대한상공회의소 소비 트렌드 조사	대한상공회의소	소비자조사	브랜드충성도(가성비·PB 전환)	1000	소비자 대상 설문	2024	http://www.korcham.net/nCham/Service/Economy/appl/KcciReportDetail.asp?SEQ_NO_C010=20120938356&CHAM_CD=B001
113	한국행정연구원 사회통합실태조사 (정부신뢰)	한국행정연구원(KIPA)	정책조사	정부신뢰(중앙정부 신뢰)	8000	전국 만 19세 이상	2023	https://www.kipa.re.kr/site/kipa/research/selectBaseList.do
114	한국행정연구원 사회통합실태조사 (정책수용성)	한국행정연구원(KIPA)	정책조사	정책수용성(정책 결정 과정 신뢰)	8000	전국 만 19세 이상	2023	https://www.kipa.re.kr/site/kipa/research/selectBaseList.do
115	한국조세재정연구원 재정패널조사	한국조세재정연구원(KIPF)	정책조사	증세수용(조세·재정 인식)	5000	전국 가구·개인 패널	2023	https://www.kipf.re.kr/panel/
116	통계청 2024 사회조사 (사회안전·규제)	통계청	정책조사	규제선호(사회안전·규제 인식)	36000	전국 만 13세 이상	2024	https://kostat.go.kr/board.es?mid=a10301010000&bid=219
117	행정안전부 전자정부서비스 이용실태조사	행정안전부	정책조사	공공서비스만족(전자정부 만족도)	4000	전국 만 16~74세	2022	https://www.mois.go.kr/frt/bbs/type010/commonSelectBoardList.do?bbsId=BBSMSTR_000000000008
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

COPY public.elections (id, name, election_type, election_date, region_code, metric, leaning, actual_value) FROM stdin;
1	제21대 대통령선거	대통령선거	2025-06-03	11	보수 후보(김문수) 득표율	conservative	41.56
2	제21대 대통령선거	대통령선거	2025-06-03	26	보수 후보(김문수) 득표율	conservative	51.4
3	제21대 대통령선거	대통령선거	2025-06-03	27	보수 후보(김문수) 득표율	conservative	67.63
4	제21대 대통령선거	대통령선거	2025-06-03	28	보수 후보(김문수) 득표율	conservative	38.45
5	제21대 대통령선거	대통령선거	2025-06-03	29	보수 후보(김문수) 득표율	conservative	8.02
6	제21대 대통령선거	대통령선거	2025-06-03	30	보수 후보(김문수) 득표율	conservative	40.59
7	제21대 대통령선거	대통령선거	2025-06-03	31	보수 후보(김문수) 득표율	conservative	47.57
8	제21대 대통령선거	대통령선거	2025-06-03	36	보수 후보(김문수) 득표율	conservative	33.22
9	제21대 대통령선거	대통령선거	2025-06-03	41	보수 후보(김문수) 득표율	conservative	37.95
10	제21대 대통령선거	대통령선거	2025-06-03	51	보수 후보(김문수) 득표율	conservative	47.31
11	제21대 대통령선거	대통령선거	2025-06-03	43	보수 후보(김문수) 득표율	conservative	43.22
12	제21대 대통령선거	대통령선거	2025-06-03	44	보수 후보(김문수) 득표율	conservative	43.27
13	제21대 대통령선거	대통령선거	2025-06-03	52	보수 후보(김문수) 득표율	conservative	10.9
14	제21대 대통령선거	대통령선거	2025-06-03	46	보수 후보(김문수) 득표율	conservative	8.54
15	제21대 대통령선거	대통령선거	2025-06-03	47	보수 후보(김문수) 득표율	conservative	66.87
16	제21대 대통령선거	대통령선거	2025-06-03	48	보수 후보(김문수) 득표율	conservative	51.99
17	제21대 대통령선거	대통령선거	2025-06-03	50	보수 후보(김문수) 득표율	conservative	34.79
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
-- Data for Name: session; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.session (sid, sess, expire) FROM stdin;
GcCXQk1Swp2fpco2WHLjv_VJ52iztEOz	{"cookie":{"originalMaxAge":604800000,"expires":"2026-06-25T00:34:37.493Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"userId":1}	2026-06-25 00:34:38
jGojkHQ9SQjZk_BjmVxFAxrOdtfpbXj0	{"cookie":{"originalMaxAge":604800000,"expires":"2026-06-25T02:57:33.463Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"userId":2}	2026-06-25 02:57:34
SonDNlm6UHu-d-qPQnhhFG73trCsNOss	{"cookie":{"originalMaxAge":604800000,"expires":"2026-06-25T03:12:35.403Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"userId":1}	2026-06-25 03:12:50
xUtdwfvfE4DS16EGls7dHva22E5Qrcr_	{"cookie":{"originalMaxAge":604800000,"expires":"2026-06-25T02:57:33.321Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"userId":1}	2026-06-25 02:57:34
pHunAka9OGuG5xU2RiqFRphb3MTizxyS	{"cookie":{"originalMaxAge":604800000,"expires":"2026-06-25T00:39:48.219Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"userId":3}	2026-06-25 00:39:49
rVuGgkAYPH3BvSIcg0-QifTiBKsYbznZ	{"cookie":{"originalMaxAge":604800000,"expires":"2026-06-25T03:15:08.021Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"userId":2}	2026-06-25 03:15:09
9kN2miQiGTtTsGN0R3y7gOIetzIGqBcL	{"cookie":{"originalMaxAge":604800000,"expires":"2026-06-25T00:42:49.330Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"userId":1}	2026-06-25 00:42:50
bj2OwxyCz7ajOqo-6pBrd7_AhXVfWXPh	{"cookie":{"originalMaxAge":604800000,"expires":"2026-06-25T03:14:53.690Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"userId":2}	2026-06-25 03:14:55
ZAAgVIRldKYGmAFlL_jUlU_vJFJBLfSR	{"cookie":{"originalMaxAge":604800000,"expires":"2026-06-25T02:58:23.305Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"userId":2}	2026-06-25 02:58:24
VCfhI0a4P_wF5QWm67Lo8D0RqHRCPtVD	{"cookie":{"originalMaxAge":604800000,"expires":"2026-06-25T03:15:40.796Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"userId":2}	2026-06-25 03:15:42
4CWFtR4qp35K-IZoex7OUvxhs77Rb8lu	{"cookie":{"originalMaxAge":604800000,"expires":"2026-06-25T02:54:08.140Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"userId":2}	2026-06-25 02:54:09
6NpMP1iLkd-cyG6h0arF7g4dXbi2WpZa	{"cookie":{"originalMaxAge":604800000,"expires":"2026-06-25T02:53:39.384Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"userId":1}	2026-06-25 02:54:34
5puNHyu7QmFhGkaHeRNMOPdeXrXtuWe6	{"cookie":{"originalMaxAge":604800000,"expires":"2026-06-25T03:13:46.448Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"userId":2}	2026-06-25 03:13:47
iBHeisIlDpCZcrnZWMPAA0UI9Eifg9Gd	{"cookie":{"originalMaxAge":604800000,"expires":"2026-06-25T02:58:23.192Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"userId":1}	2026-06-25 02:58:24
RzOfM_SCHhAF0eYuVD11nt0mEN4L2u9I	{"cookie":{"originalMaxAge":604800000,"expires":"2026-06-25T03:08:10.487Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"userId":2}	2026-06-25 03:08:11
gwqq7IeXfmGSopEldL9wIvxw9EHMTulA	{"cookie":{"originalMaxAge":604800000,"expires":"2026-06-25T03:13:46.308Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"userId":1}	2026-06-25 03:13:47
LKh3xAJ1AF4J8ZzTT6NepT8tk8n1vyZe	{"cookie":{"originalMaxAge":604800000,"expires":"2026-06-25T03:19:56.237Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"userId":2}	2026-06-25 03:19:57
pLKMpw4dDlvbp4uC1od7PCKENb8NyrNk	{"cookie":{"originalMaxAge":604800000,"expires":"2026-06-25T03:14:02.392Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"userId":1}	2026-06-25 03:14:03
xqhT5yGNE1m-h9ldT7_oKpI39f2o3Hic	{"cookie":{"originalMaxAge":604800000,"expires":"2026-06-25T03:14:53.405Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"userId":1}	2026-06-25 03:14:55
xyPgNMP0d1oGRtmzdiNyo1MsZKhrDXQf	{"cookie":{"originalMaxAge":604800000,"expires":"2026-06-25T03:15:40.683Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"userId":1}	2026-06-25 03:15:42
On5rbY8_hJDOIZvU9wLuz42ktNmloddd	{"cookie":{"originalMaxAge":604800000,"expires":"2026-06-25T03:15:07.908Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"userId":1}	2026-06-25 03:15:09
F3e_w5DtURm3b2g3MhzgSEnpDrTcDMME	{"cookie":{"originalMaxAge":604800000,"expires":"2026-06-25T03:20:10.870Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"userId":1}	2026-06-25 03:20:12
USEPpVaGbJZeAl9vFX8HDXu6WRUEA_1G	{"cookie":{"originalMaxAge":604800000,"expires":"2026-06-25T03:20:10.980Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"userId":2}	2026-06-25 03:20:12
DkC7tKd9wHDVRXxybPPZaJumNw23vgly	{"cookie":{"originalMaxAge":604800000,"expires":"2026-06-25T03:19:56.129Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"userId":1}	2026-06-25 03:19:57
EVjw6NXENwEDA9xpH2RYeQHIE3wPFcum	{"cookie":{"originalMaxAge":604800000,"expires":"2026-06-25T03:38:28.111Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"userId":2}	2026-06-25 03:58:34
\.


--
-- Data for Name: simulation_responses; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.simulation_responses (id, simulation_id, agent_id, agent_name, district, age_bracket, gender, stance, score, confidence, reasoning, political_leaning, policy_stances) FROM stdin;
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

COPY public.simulations (id, title, audience, product, policy_text, model, status, progress, total_agents, cost_estimate_usd, cost_actual_usd, overall_support, support_pct, oppose_pct, neutral_pct, summary, created_at, completed_at, user_id, locked_by, locked_at, heartbeat_at, last_error) FROM stdin;
1	청년 월세 지원 확대 정책 반응 테스트	정부	Seraph	서울시는 만 19~34세 무주택 청년을 대상으로 월 최대 30만원의 월세를 24개월간 지원하는 정책을 검토 중입니다. 재원은 지방채 발행과 기존 주거복지 예산 재편으로 충당합니다. 이 정책에 대한 시민 반응을 평가하세요.	gpt-5-mini	completed	100	500	0.2875	0.3071	50.8	40.6	38.2	21.2	서울 합성 인구 500명 시뮬레이션 결과 찬반이 팽팽하게 갈리는 반응이 나타났습니다. 찬성 40.6%, 반대 38.2%, 중립 21.2%로, 관악구 지역에서 지지가 가장 높았습니다.	2026-06-15 06:49:34.164375+00	2026-06-13 06:49:34.164375+00	1	\N	\N	\N	\N
2	프리미엄 구독형 모빌리티 서비스 출시 컨셉 테스트	비즈니스	Lumen	월 9만 9천원에 따릉이·심야버스·전기 킥보드·카셰어링을 무제한 이용할 수 있는 통합 구독형 모빌리티 멤버십 'SeoulPass+'를 출시하려 합니다. 직장인과 청년을 핵심 타깃으로 합니다. 이 신서비스에 대한 구매 의향과 반응을 평가하세요.	gpt-5-mini	completed	100	500	0.2875	0.2772	45.4	27.2	43.8	29	서울 합성 인구 500명 시뮬레이션 결과 찬반이 팽팽하게 갈리는 반응이 나타났습니다. 찬성 27.2%, 반대 43.8%, 중립 29%로, 서대문구 지역에서 지지가 가장 높았습니다.	2026-06-15 06:49:48.082029+00	2026-06-10 06:49:48.082029+00	1	\N	\N	\N	\N
13	예산 초과 회귀 테스트	비즈니스	Lumen	테스트	gpt-5	pending	0	500	1.4375	\N	\N	\N	\N	\N	\N	2026-06-18 03:19:56.623365+00	\N	1	\N	\N	\N	\N
14	예산 초과 회귀 테스트	비즈니스	Lumen	테스트	gpt-5	pending	0	500	1.4375	\N	\N	\N	\N	\N	\N	2026-06-18 03:20:11.340093+00	\N	1	\N	\N	\N	\N
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
101	방송통신위원회 2024 방송매체 이용행태조사 — 디지털·OTT 소비	전국 17개 시·도 13세 이상 8,316명 대상 방문면접(국가승인통계). 전체 OTT 이용률 79.2%, 주5일 이상 스마트폰 이용 92.2%로 디지털 매체 소비가 일상화 → 합성 인구의 디지털소비 성향을 높게 보정.	가구방문 면접조사 (국가승인통계 제164002호)	8316	2024-12-30	active	95	[{"issue": "디지털소비", "factor": "OTT·디지털 매체 이용", "weight": 0.7, "direction": "OTT 79.2%·스마트폰 92.2% → 디지털 채널 소비 성향 높음", "targetStance": 72}]	2026-06-17 05:32:58.429274+00	t	t	방송통신위원회	2024 방송매체 이용행태조사	2024 (연간 조사)	https://www.kcc.go.kr/user.do?mode=view&page=A05030000&dc=K05030000&boardId=1113&boardSeq=64951	commercial	1
102	과학기술정보통신부 2024 인터넷이용실태조사 — 신기술 수용	전국 25,509가구·만 3세 이상 60,229명 대상 면접조사. AI 서비스 경험률 60.3%, 생성형 AI 경험률 33.3%(전년 17.6% 대비 약 2배)로 신기술 수용이 빠르게 확산 → 신제품수용 성향을 중상위로 보정.	가구방문 면접조사 (국가승인통계)	60229	2025-03-31	active	95	[{"issue": "신제품수용", "factor": "AI·신기술 수용", "weight": 0.6, "direction": "AI 경험 60.3%·생성형 AI 33.3%(2배↑) → 신제품 수용 성향 중상위", "targetStance": 58}]	2026-06-17 05:32:58.429274+00	t	t	과학기술정보통신부	2024 인터넷이용실태조사	2024 (연간 조사)	https://www.korea.kr/briefing/pressReleaseView.do?newsId=156681493	commercial	1
103	한국소비자원 2025 친환경 소비 제도 이용 실태조사 — 친환경 소비	전국 성인 소비자 3,200명 대상 조사. 친환경 제도 이용 66.4%, 구매 의향 82.2%로 인식은 높으나 실제 친환경 제품 구매 노력은 25.5%에 그쳐 인식–실천 괴리가 큼 → 친환경소비 성향을 중간 수준으로 보정.	소비자 대상 설문조사	3200	2025-05-13	active	95	[{"issue": "친환경소비", "factor": "친환경 인식–실천 괴리", "weight": 0.55, "direction": "제도 이용 66.4%·의향 82.2% vs 실천 25.5% → 친환경소비 중간 수준", "targetStance": 50}]	2026-06-17 05:32:58.429274+00	t	t	한국소비자원	친환경 제도 소비자 이용 실태조사	2025	https://www.kca.go.kr/home/board/download.do?menukey=4002&fno=10046976&bid=00000013&did=1003867815	commercial	1
104	한국은행 2025 소비자동향조사 — 물가·가격 민감도	전국 약 2,500가구 대상 월간 소비자동향조사. 물가수준전망 CSI 148, 기대인플레이션율 2.6%로 향후 물가 상승 부담 인식이 높아 가격에 민감한 소비 태도가 우세 → 가격민감도 성향을 높게 보정.	가구 대상 월간 설문조사 (한국은행 통계)	2500	2025-12-23	active	95	[{"issue": "가격민감도", "factor": "물가 상승 부담", "weight": 0.6, "direction": "물가수준전망 CSI 148·기대인플레 2.6% → 가격민감 소비 우세", "targetStance": 68}]	2026-06-17 05:32:58.429274+00	t	t	한국은행	소비자동향조사(소비자심리지수)	2025-12	https://www.bok.or.kr/portal/bbs/B0000501/view.do?nttId=10095310&menuNo=201264	commercial	1
106	한국행정연구원 2023 사회통합실태조사 — 정부 신뢰	전국 만 19세 이상 약 8,000명 대상 1:1 면접조사(국가승인통계). 중앙정부 신뢰 응답이 절반에 못 미치는 수준(약 48%)에 머물러 정부 기관에 대한 신뢰가 중간 이하로 나타남 → 정부신뢰 성향을 중간 이하로 보정.	1:1 가구방문 면접조사 (국가승인통계 제417001호)	8000	2023-12-31	active	95	[{"issue": "정부신뢰", "factor": "중앙정부 신뢰", "weight": 0.6, "direction": "중앙정부 신뢰 약 48%로 절반 미만 → 정부신뢰 중간 이하", "targetStance": 48}]	2026-06-17 05:32:58.429274+00	t	t	한국행정연구원(KIPA)	2023 사회통합실태조사	2023 (연간 조사)	https://www.kipa.re.kr/site/kipa/research/selectBaseList.do	policy	1
107	한국행정연구원 2023 사회통합실태조사 — 정책 수용성	전국 만 19세 이상 약 8,000명 대상 면접조사(국가승인통계). 정부 정책 결정 과정의 공정성·반응성에 대한 긍정 평가가 절반에 못 미쳐(약 46%) 새 정책에 대한 자발적 수용·순응 의향이 중간 수준에 그침 → 정책수용성을 중간 수준으로 보정.	1:1 가구방문 면접조사 (국가승인통계 제417001호)	8000	2023-12-31	active	95	[{"issue": "정책수용성", "factor": "정책 결정 과정 신뢰", "weight": 0.5, "direction": "정책 결정 과정 공정성 긍정 약 46% → 정책수용성 중간 수준", "targetStance": 46}]	2026-06-17 05:32:58.429274+00	t	t	한국행정연구원(KIPA)	2023 사회통합실태조사 (정부 정책 인식)	2023 (연간 조사)	https://www.kipa.re.kr/site/kipa/research/selectBaseList.do	policy	1
105	대한상공회의소 2024 소비 트렌드 조사 — 브랜드 충성도	소비자 대상 소비 트렌드 조사. 고가 제품 구매 축소 49%, 저렴한 브랜드 의도적 탐색 43.8%, PB(자체 브랜드) 구매 증가 33%로 가성비 중심 전환이 뚜렷해 브랜드 충성도가 약화 → 브랜드충성도 성향을 낮게 보정.	소비자 대상 설문조사	1000	2024-08-31	active	90	[{"issue": "브랜드충성도", "factor": "가성비 전환·브랜드 이탈", "weight": 0.5, "direction": "저렴 브랜드 탐색 43.8%·PB 구매 33% → 브랜드 충성도 약화", "targetStance": 38}]	2026-06-17 05:32:58.429274+00	t	t	대한상공회의소	2024 하반기 소비트렌드 변화와 대응방안	2024 하반기	http://www.korcham.net/nCham/Service/Economy/appl/KcciReportDetail.asp?SEQ_NO_C010=20120938356&CHAM_CD=B001	commercial	1
96	한국갤럽 데일리 오피니언 — 향후 1년 경기 전망	전국 만 18세 이상 1,000명 대상 전화면접(CATI) 조사. 향후 1년 경기 전망에서 '나빠질 것' 47% vs '좋아질 것' 24%로 비관론 우세 → 정부의 경제 역할 확대 선호로 해석.	전화면접조사(CATI), 무선 가상번호 무작위 추출	1000	2025-04-17	active	95	[{"issue": "경제", "factor": "경기 전망", "weight": 0.4, "direction": "경기 비관론 우세(나빠질 47% vs 좋아질 24%) → 정부 경제 역할 확대 선호", "targetStance": -20}]	2026-06-17 05:32:58.429274+00	t	t	한국갤럽	데일리 오피니언 제634호 — 향후 1년 경기 전망	2025-04-15 ~ 2025-04-17	https://www.gallup.co.kr/gallupdb/report.asp	political	1
97	통계청 2023년 사회조사 — 복지 부문	전국 만 13세 이상 약 36,000명(약 19,000가구) 대상 면접조사. 늘려야 할 복지서비스로 고용(취업)지원 1위·보건의료 2위, 노후 준비 필요 인식이 높게 나타남 → 복지 확대 지지.	가구방문 면접조사 (국가지정통계)	36000	2023-05-31	active	95	[{"issue": "복지", "factor": "복지 수요", "weight": 0.55, "direction": "늘려야 할 복지 1위 고용지원·2위 보건의료 → 복지 확대 지지", "targetStance": 35}]	2026-06-17 05:32:58.429274+00	t	t	통계청	2023년 사회조사 결과 (복지·사회참여·여가·소득과 소비·노동)	2023-05 (16일간)	https://kostat.go.kr/board.es?mid=a10301010000&bid=219&act=view&list_no=427913	political	1
98	서울대 통일평화연구원 2024 통일의식조사 — 대북·안보 인식	전국 17개 시·도 만 19세 이상 1,200명 대상 1:1 면접조사(표본오차 ±2.8%, 95% 신뢰수준). 대북 적대의식이 22.3%로 역대 최고(3년 연속 상승), 통일 불필요 여론도 역대 최고 → 안보 강화 기조 강화.	1:1 대면 면접조사 (한국갤럽 수행)	1200	2024-07-23	active	95	[{"issue": "안보", "factor": "대북 인식", "weight": 0.45, "direction": "대북 적대의식 22.3% 역대 최고 → 안보 강화 기조 강화", "targetStance": 18}]	2026-06-17 05:32:58.429274+00	t	t	서울대학교 통일평화연구원	2024 통일의식조사	2024-07-01 ~ 2024-07-23	https://ipus.snu.ac.kr/blog/archives/news/9627	political	1
99	한국환경연구원(KEI) 2024 국민환경의식조사 — 기후변화 인식	전국 성인 3,040명 대상 웹조사(지역·성·연령 비례 할당). 기후변화를 가장 중요한 환경문제로 꼽은 응답이 68.2%로 2021년 39.8%에서 급증, 불안감 75.7% → 환경 보호 우선 강하게 지지.	웹조사 (온라인 패널, 비례 할당 추출)	3040	2024-12-31	active	95	[{"issue": "환경", "factor": "기후변화 심각성", "weight": 0.68, "direction": "기후변화를 최우선 환경문제로 꼽은 응답 68.2% → 환경 보호 우선", "targetStance": 45}]	2026-06-17 05:32:58.429274+00	t	t	한국환경연구원(KEI)	2024 국민환경의식조사	2024 (연간 조사)	https://www.kei.re.kr/elibList.es?mid=a10101010000&elibName=researchreport&act=view&c_id=766481	political	1
100	국토교통부 2023년 주거실태조사 — 주거 인식	전국 약 6.1만 가구 대상 1:1 개별 면접조사(국토연구원·한국리서치 수행). 내 집 보유 의사 87.3%인 반면 자가점유율은 57.4%에 그쳐 미충족 주거 수요가 큼 → 주거 지원·공급 확대 지지.	1:1 개별 면접조사 (국토연구원·한국리서치)	61000	2023-12-31	active	95	[{"issue": "주거", "factor": "주거 보유의사", "weight": 0.6, "direction": "내 집 보유의사 87.3% vs 자가점유율 57.4% → 주거 지원·공급 확대 지지", "targetStance": 42}]	2026-06-17 05:32:58.429274+00	t	t	국토교통부	2023년도 주거실태조사	2023 (연간 조사)	https://www.molit.go.kr/USR/NEWS/m_71/dtl.jsp?lcmspage=1&id=95090538	political	1
108	한국조세재정연구원 2023 재정패널 — 증세·조세 인식	전국 가구·개인 패널 대상 재정패널조사. 복지 확대를 위한 증세에 대한 찬성이 약 45% 수준으로, 복지 수요는 높으나 본인 세 부담 증가에는 신중한 태도가 우세 → 증세수용 성향을 중간 이하로 보정.	가구·개인 패널 설문조사 (재정패널)	5000	2023-12-31	active	90	[{"issue": "증세수용", "factor": "증세 수용성", "weight": 0.5, "direction": "복지 위한 증세 찬성 약 45% → 본인 세부담엔 신중, 증세수용 중간 이하", "targetStance": 45}]	2026-06-17 05:32:58.429274+00	t	t	한국조세재정연구원(KIPF)	재정패널조사 (조세·재정 인식)	2023 (연간 조사)	https://www.kipf.re.kr/panel/	policy	1
109	통계청 2024 사회조사 — 사회안전·규제 인식	전국 만 13세 이상 약 36,000명 대상 면접조사(국가지정통계). 식품·범죄·환경 등 위험으로부터의 사회안전 체감이 높지 않아 정부의 안전·환경 규제 강화 요구가 우세 → 규제선호 성향을 중상위로 보정.	가구방문 면접조사 (국가지정통계)	36000	2024-05-31	active	95	[{"issue": "규제선호", "factor": "사회안전·규제 요구", "weight": 0.55, "direction": "사회안전 체감 낮음 → 안전·환경 규제 강화 요구 우세, 규제선호 중상위", "targetStance": 64}]	2026-06-17 05:32:58.429274+00	t	t	통계청	2024년 사회조사 결과 (안전·환경·사회)	2024-05 (16일간)	https://kostat.go.kr/board.es?mid=a10301010000&bid=219	policy	1
110	행정안전부 2022 전자정부서비스 이용실태조사 — 공공서비스 만족	전국 만 16~74세 대상 전자정부서비스 이용실태조사. 전자정부서비스 이용자 만족도가 97.7%로 매우 높게 나타나 공공·행정 서비스 이용 경험에 대한 만족이 높은 수준 → 공공서비스만족 성향을 높게 보정.	이용자 대상 설문조사 (전자정부서비스 이용실태조사)	4000	2022-12-31	active	95	[{"issue": "공공서비스만족", "factor": "공공서비스 만족", "weight": 0.6, "direction": "전자정부서비스 만족도 97.7% → 공공서비스 만족 높음", "targetStance": 80}]	2026-06-17 05:32:58.429274+00	t	t	행정안전부	2022 전자정부서비스 이용실태조사	2022 (연간 조사)	https://www.mois.go.kr/frt/bbs/type010/commonSelectBoardList.do?bbsId=BBSMSTR_000000000008	policy	1
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, username, name, birth_date, password_hash, role, created_at, budget_limit_usd) FROM stdin;
1	test	테스트 사용자	\N	$2b$10$Jn9xW4nldMQupELahVBodevuFQAtmw6Aq13SsN5retYMm8JQuNxDS	user	2026-06-18 00:33:26.079448	1
2	admin	관리자	\N	$2b$10$YrwumnKnU0RS/L.rNj7G1eEwEQnd17iov7Xf.A5iJUpkzHnzHdhn6	admin	2026-06-18 00:33:26.079448	1
3	newuser_1781743078203	신규유저	\N	$2b$10$ufbcynACYqjRyBX8DQf9eu4GXyBKhnpHI0fJCxS2zqRx6/VL3I5PG	user	2026-06-18 00:39:48.213796	1
\.


--
-- Name: agents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.agents_id_seq', 500, true);


--
-- Name: calibration_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.calibration_settings_id_seq', 2, true);


--
-- Name: calibrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.calibrations_id_seq', 14, true);


--
-- Name: data_sources_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.data_sources_id_seq', 117, true);


--
-- Name: demographic_margins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.demographic_margins_id_seq', 25, true);


--
-- Name: elections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.elections_id_seq', 17, true);


--
-- Name: simulation_responses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.simulation_responses_id_seq', 1500, true);


--
-- Name: simulations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.simulations_id_seq', 14, true);


--
-- Name: survey_uploads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.survey_uploads_id_seq', 1, false);


--
-- Name: surveys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.surveys_id_seq', 110, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 3, true);


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

\unrestrict 6V1tAleduhCq9N5p6XqTvLR5mbNIssaHgijIXz4MxtBFIKHRZvkYfbTDIza7vnx

