--
-- PostgreSQL database dump
--

\restrict W2R04auxTqxHvd2SUhC5CWKCMjXKBBb3pzF9ebYBkByKfXwbgvM6N9NXFofwGIJ

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
551	정예준	18	18-29	Female	서울특별시	37.566599	127.054194	대학원 졸	200-350만원	학생	부부 가구	30	보수 성향 무당층	36	{"economy": 13, "housing": -14, "welfare": -3, "security": 29, "environment": -6}	지상파/종편 뉴스	{혁신,공동체,다양성}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 혁신, 공동체, 다양성 가치를 중시한다.	{"brandLoyalty": 37, "noveltySeeking": 96, "ecoConsciousness": 63, "priceSensitivity": 60, "digitalConsumption": 93}	{"taxTolerance": 54, "governmentTrust": 39, "policyAcceptance": 60, "regulationPreference": 57, "publicServiceSatisfaction": 71}	1
552	이서윤	22	18-29	Female	서울특별시	37.639776	126.972986	대학원 졸	200-350만원	학생	다세대 가구	-37	진보 성향 무당층	60	{"economy": -9, "housing": 36, "welfare": 30, "security": -20, "environment": 65}	신문/팟캐스트	{자유,공정,다양성}	서울특별시에 거주하는 18-29 학생. 정치 성향은 진보이며 자유, 공정, 다양성 가치를 중시한다.	{"brandLoyalty": 28, "noveltySeeking": 87, "ecoConsciousness": 78, "priceSensitivity": 62, "digitalConsumption": 86}	{"taxTolerance": 54, "governmentTrust": 40, "policyAcceptance": 41, "regulationPreference": 56, "publicServiceSatisfaction": 66}	1
553	윤영수	22	18-29	Female	서울특별시	37.62274	126.95526	대학교 졸	200-350만원	학생	부부 가구	-1	중도 무당층	60	{"economy": 10, "housing": 17, "welfare": 55, "security": 13, "environment": 16}	포털 뉴스	{공동체,성장,혁신}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 공동체, 성장, 혁신 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 75, "ecoConsciousness": 53, "priceSensitivity": 48, "digitalConsumption": 67}	{"taxTolerance": 52, "governmentTrust": 38, "policyAcceptance": 61, "regulationPreference": 68, "publicServiceSatisfaction": 61}	1
554	임영수	23	18-29	Female	서울특별시	37.505012	126.939674	대학원 졸	350-500만원	학생	다세대 가구	-17	진보 성향 무당층	49	{"economy": -25, "housing": 45, "welfare": 47, "security": -32, "environment": 6}	지상파/종편 뉴스	{혁신,공동체,공정}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 혁신, 공동체, 공정 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 83, "ecoConsciousness": 58, "priceSensitivity": 73, "digitalConsumption": 65}	{"taxTolerance": 48, "governmentTrust": 46, "policyAcceptance": 52, "regulationPreference": 63, "publicServiceSatisfaction": 48}	1
555	류유준	21	18-29	Male	서울특별시	37.510722	126.998855	고졸 이하	200-350만원	학생	다세대 가구	-3	중도 무당층	42	{"economy": -13, "housing": 17, "welfare": 2, "security": -15, "environment": 38}	SNS	{공동체,혁신,안정}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 공동체, 혁신, 안정 가치를 중시한다.	{"brandLoyalty": 33, "noveltySeeking": 73, "ecoConsciousness": 39, "priceSensitivity": 65, "digitalConsumption": 78}	{"taxTolerance": 43, "governmentTrust": 49, "policyAcceptance": 40, "regulationPreference": 51, "publicServiceSatisfaction": 53}	1
556	윤경숙	26	18-29	Male	서울특별시	37.595766	127.031785	대학교 졸	500-700만원	은퇴	다세대 가구	-33	진보 성향 무당층	51	{"economy": -47, "housing": 15, "welfare": 15, "security": -16, "environment": 35}	포털 뉴스	{공동체,자유,환경}	서울특별시에 거주하는 18-29 은퇴. 정치 성향은 중도이며 공동체, 자유, 환경 가치를 중시한다.	{"brandLoyalty": 20, "noveltySeeking": 80, "ecoConsciousness": 54, "priceSensitivity": 70, "digitalConsumption": 82}	{"taxTolerance": 51, "governmentTrust": 48, "policyAcceptance": 56, "regulationPreference": 53, "publicServiceSatisfaction": 64}	1
557	오채원	29	18-29	Male	서울특별시	37.493959	127.053976	대학원 졸	200-350만원	생산직	1인 가구	-39	진보 성향 무당층	50	{"economy": -26, "housing": 22, "welfare": 33, "security": 7, "environment": 14}	지상파/종편 뉴스	{안정,환경,혁신}	서울특별시에 거주하는 18-29 생산직. 정치 성향은 진보이며 안정, 환경, 혁신 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 79, "ecoConsciousness": 44, "priceSensitivity": 62, "digitalConsumption": 63}	{"taxTolerance": 45, "governmentTrust": 57, "policyAcceptance": 44, "regulationPreference": 54, "publicServiceSatisfaction": 67}	1
558	조도윤	29	18-29	Male	서울특별시	37.645737	126.989025	전문대 졸	350-500만원	학생	1인 가구	-3	중도 무당층	52	{"economy": -19, "housing": 54, "welfare": 40, "security": 22, "environment": 8}	지상파/종편 뉴스	{안정,전통,공정}	서울특별시에 거주하는 18-29 학생. 정치 성향은 중도이며 안정, 전통, 공정 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 68, "ecoConsciousness": 42, "priceSensitivity": 58, "digitalConsumption": 74}	{"taxTolerance": 42, "governmentTrust": 60, "policyAcceptance": 41, "regulationPreference": 57, "publicServiceSatisfaction": 72}	1
559	임철수	38	30-39	Female	서울특별시	37.519491	126.932737	대학원 졸	200-350만원	생산직	다세대 가구	-8	중도 무당층	65	{"economy": 8, "housing": 32, "welfare": 24, "security": -1, "environment": 27}	유튜브	{공동체,공정,자유}	서울특별시에 거주하는 30-39 생산직. 정치 성향은 중도이며 공동체, 공정, 자유 가치를 중시한다.	{"brandLoyalty": 46, "noveltySeeking": 53, "ecoConsciousness": 62, "priceSensitivity": 42, "digitalConsumption": 75}	{"taxTolerance": 40, "governmentTrust": 39, "policyAcceptance": 31, "regulationPreference": 62, "publicServiceSatisfaction": 74}	1
560	송철수	30	30-39	Female	서울특별시	37.588713	127.077939	전문대 졸	200만원 미만	생산직	자녀 양육 가구	11	중도 무당층	63	{"economy": -18, "housing": -14, "welfare": -18, "security": -4, "environment": -8}	유튜브	{공동체,공정,혁신}	서울특별시에 거주하는 30-39 생산직. 정치 성향은 중도이며 공동체, 공정, 혁신 가치를 중시한다.	{"brandLoyalty": 16, "noveltySeeking": 91, "ecoConsciousness": 46, "priceSensitivity": 71, "digitalConsumption": 79}	{"taxTolerance": 74, "governmentTrust": 40, "policyAcceptance": 39, "regulationPreference": 58, "publicServiceSatisfaction": 68}	1
561	최서연	38	30-39	Female	서울특별시	37.502924	126.997723	대학교 졸	200-350만원	은퇴	자녀 양육 가구	-23	진보 성향 무당층	73	{"economy": -6, "housing": 37, "welfare": -5, "security": 11, "environment": 13}	SNS	{안정,자유,공정}	서울특별시에 거주하는 30-39 은퇴. 정치 성향은 중도이며 안정, 자유, 공정 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 59, "ecoConsciousness": 30, "priceSensitivity": 78, "digitalConsumption": 67}	{"taxTolerance": 58, "governmentTrust": 34, "policyAcceptance": 42, "regulationPreference": 48, "publicServiceSatisfaction": 67}	1
562	최동현	35	30-39	Female	서울특별시	37.617533	126.973049	대학교 졸	700만원 이상	자영업	1인 가구	-12	중도 무당층	61	{"economy": -33, "housing": 22, "welfare": 22, "security": -19, "environment": 40}	SNS	{혁신,공동체,안정}	서울특별시에 거주하는 30-39 자영업. 정치 성향은 중도이며 혁신, 공동체, 안정 가치를 중시한다.	{"brandLoyalty": 42, "noveltySeeking": 65, "ecoConsciousness": 38, "priceSensitivity": 46, "digitalConsumption": 80}	{"taxTolerance": 50, "governmentTrust": 50, "policyAcceptance": 42, "regulationPreference": 62, "publicServiceSatisfaction": 78}	1
563	김혜진	33	30-39	Male	서울특별시	37.568338	126.9064	대학원 졸	500-700만원	전문직	부부 가구	31	보수 성향 무당층	44	{"economy": 24, "housing": 2, "welfare": 4, "security": 16, "environment": -14}	포털 뉴스	{다양성,혁신,자유}	서울특별시에 거주하는 30-39 전문직. 정치 성향은 중도이며 다양성, 혁신, 자유 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 68, "ecoConsciousness": 60, "priceSensitivity": 68, "digitalConsumption": 81}	{"taxTolerance": 54, "governmentTrust": 43, "policyAcceptance": 39, "regulationPreference": 58, "publicServiceSatisfaction": 56}	1
564	박서연	39	30-39	Male	서울특별시	37.635754	126.894247	대학원 졸	350-500만원	공무원	1인 가구	-25	진보 성향 무당층	55	{"economy": -18, "housing": 26, "welfare": 19, "security": 7, "environment": 47}	SNS	{다양성,혁신,전통}	서울특별시에 거주하는 30-39 공무원. 정치 성향은 중도이며 다양성, 혁신, 전통 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 78, "ecoConsciousness": 72, "priceSensitivity": 64, "digitalConsumption": 70}	{"taxTolerance": 57, "governmentTrust": 38, "policyAcceptance": 33, "regulationPreference": 57, "publicServiceSatisfaction": 58}	1
565	류채원	33	30-39	Male	서울특별시	37.604653	127.017057	대학원 졸	700만원 이상	전문직	다세대 가구	-66	진보 정당 지지	61	{"economy": -40, "housing": 31, "welfare": 44, "security": -5, "environment": 43}	SNS	{혁신,다양성,성장}	서울특별시에 거주하는 30-39 전문직. 정치 성향은 진보이며 혁신, 다양성, 성장 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 60, "ecoConsciousness": 48, "priceSensitivity": 34, "digitalConsumption": 72}	{"taxTolerance": 47, "governmentTrust": 21, "policyAcceptance": 25, "regulationPreference": 68, "publicServiceSatisfaction": 60}	1
566	윤성호	31	30-39	Male	서울특별시	37.538339	126.879483	대학원 졸	200만원 미만	생산직	1인 가구	24	보수 성향 무당층	55	{"economy": 11, "housing": 37, "welfare": -7, "security": 8, "environment": 12}	신문/팟캐스트	{공동체,환경,자유}	서울특별시에 거주하는 30-39 생산직. 정치 성향은 중도이며 공동체, 환경, 자유 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 95, "ecoConsciousness": 48, "priceSensitivity": 69, "digitalConsumption": 76}	{"taxTolerance": 49, "governmentTrust": 46, "policyAcceptance": 46, "regulationPreference": 64, "publicServiceSatisfaction": 61}	1
567	윤지호	42	40-49	Female	서울특별시	37.496085	126.939161	대학교 졸	200-350만원	공무원	다세대 가구	-8	중도 무당층	69	{"economy": 2, "housing": 58, "welfare": 16, "security": 8, "environment": 38}	포털 뉴스	{혁신,다양성,안정}	서울특별시에 거주하는 40-49 공무원. 정치 성향은 중도이며 혁신, 다양성, 안정 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 52, "ecoConsciousness": 72, "priceSensitivity": 65, "digitalConsumption": 58}	{"taxTolerance": 53, "governmentTrust": 57, "policyAcceptance": 43, "regulationPreference": 83, "publicServiceSatisfaction": 84}	1
568	최미경	40	40-49	Female	서울특별시	37.597389	127.015369	전문대 졸	700만원 이상	생산직	1인 가구	6	중도 무당층	73	{"economy": 17, "housing": 17, "welfare": 16, "security": 17, "environment": 27}	유튜브	{다양성,안정,공정}	서울특별시에 거주하는 40-49 생산직. 정치 성향은 중도이며 다양성, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 51, "noveltySeeking": 52, "ecoConsciousness": 48, "priceSensitivity": 49, "digitalConsumption": 76}	{"taxTolerance": 40, "governmentTrust": 47, "policyAcceptance": 70, "regulationPreference": 61, "publicServiceSatisfaction": 55}	1
569	윤지호	49	40-49	Female	서울특별시	37.501335	127.002758	대학교 졸	700만원 이상	전문직	자녀 양육 가구	6	중도 무당층	75	{"economy": -30, "housing": 12, "welfare": 19, "security": 24, "environment": 5}	유튜브	{안전,성장,공정}	서울특별시에 거주하는 40-49 전문직. 정치 성향은 중도이며 안전, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 55, "ecoConsciousness": 69, "priceSensitivity": 51, "digitalConsumption": 73}	{"taxTolerance": 45, "governmentTrust": 43, "policyAcceptance": 44, "regulationPreference": 61, "publicServiceSatisfaction": 53}	1
570	정유준	43	40-49	Female	서울특별시	37.617942	126.890677	고졸 이하	350-500만원	프리랜서	자녀 양육 가구	-9	중도 무당층	59	{"economy": -48, "housing": 8, "welfare": 17, "security": -14, "environment": 37}	SNS	{전통,성장,공정}	서울특별시에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 전통, 성장, 공정 가치를 중시한다.	{"brandLoyalty": 36, "noveltySeeking": 80, "ecoConsciousness": 57, "priceSensitivity": 65, "digitalConsumption": 80}	{"taxTolerance": 45, "governmentTrust": 55, "policyAcceptance": 47, "regulationPreference": 61, "publicServiceSatisfaction": 72}	1
571	신혜진	41	40-49	Female	서울특별시	37.591614	127.042174	고졸 이하	500-700만원	학생	자녀 양육 가구	11	중도 무당층	60	{"economy": 13, "housing": 7, "welfare": 16, "security": -3, "environment": 45}	지상파/종편 뉴스	{안정,환경,공동체}	서울특별시에 거주하는 40-49 학생. 정치 성향은 중도이며 안정, 환경, 공동체 가치를 중시한다.	{"brandLoyalty": 30, "noveltySeeking": 53, "ecoConsciousness": 55, "priceSensitivity": 53, "digitalConsumption": 75}	{"taxTolerance": 43, "governmentTrust": 47, "policyAcceptance": 56, "regulationPreference": 66, "publicServiceSatisfaction": 54}	1
572	한정희	46	40-49	Male	서울특별시	37.573741	127.074231	고졸 이하	200-350만원	공무원	부부 가구	-45	진보 정당 지지	94	{"economy": -49, "housing": 22, "welfare": 26, "security": -8, "environment": 19}	유튜브	{다양성,안정,공정}	서울특별시에 거주하는 40-49 공무원. 정치 성향은 진보이며 다양성, 안정, 공정 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 51, "ecoConsciousness": 54, "priceSensitivity": 62, "digitalConsumption": 51}	{"taxTolerance": 55, "governmentTrust": 46, "policyAcceptance": 60, "regulationPreference": 72, "publicServiceSatisfaction": 78}	1
573	정현우	45	40-49	Male	서울특별시	37.562885	126.947878	대학원 졸	500-700만원	프리랜서	자녀 양육 가구	-33	진보 성향 무당층	62	{"economy": -11, "housing": 29, "welfare": 30, "security": -9, "environment": 22}	포털 뉴스	{다양성,전통,성장}	서울특별시에 거주하는 40-49 프리랜서. 정치 성향은 중도이며 다양성, 전통, 성장 가치를 중시한다.	{"brandLoyalty": 43, "noveltySeeking": 67, "ecoConsciousness": 48, "priceSensitivity": 71, "digitalConsumption": 59}	{"taxTolerance": 40, "governmentTrust": 57, "policyAcceptance": 46, "regulationPreference": 58, "publicServiceSatisfaction": 54}	1
574	이영수	41	40-49	Male	서울특별시	37.613727	126.997955	전문대 졸	350-500만원	자영업	1인 가구	8	중도 무당층	62	{"economy": 5, "housing": 10, "welfare": 25, "security": 9, "environment": 25}	지상파/종편 뉴스	{안전,전통,다양성}	서울특별시에 거주하는 40-49 자영업. 정치 성향은 중도이며 안전, 전통, 다양성 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 63, "ecoConsciousness": 57, "priceSensitivity": 63, "digitalConsumption": 66}	{"taxTolerance": 47, "governmentTrust": 52, "policyAcceptance": 32, "regulationPreference": 55, "publicServiceSatisfaction": 58}	1
575	박현우	48	40-49	Male	서울특별시	37.50839	127.02072	대학교 졸	500-700만원	자영업	1인 가구	-25	진보 성향 무당층	65	{"economy": -26, "housing": 14, "welfare": 11, "security": 5, "environment": 27}	SNS	{자유,안전,혁신}	서울특별시에 거주하는 40-49 자영업. 정치 성향은 중도이며 자유, 안전, 혁신 가치를 중시한다.	{"brandLoyalty": 55, "noveltySeeking": 57, "ecoConsciousness": 52, "priceSensitivity": 64, "digitalConsumption": 75}	{"taxTolerance": 48, "governmentTrust": 41, "policyAcceptance": 44, "regulationPreference": 39, "publicServiceSatisfaction": 72}	1
576	권은우	47	40-49	Male	서울특별시	37.497135	127.034272	대학원 졸	500-700만원	학생	다세대 가구	-19	진보 성향 무당층	47	{"economy": -29, "housing": 2, "welfare": 34, "security": -11, "environment": 8}	유튜브	{안정,공정,성장}	서울특별시에 거주하는 40-49 학생. 정치 성향은 중도이며 안정, 공정, 성장 가치를 중시한다.	{"brandLoyalty": 40, "noveltySeeking": 51, "ecoConsciousness": 60, "priceSensitivity": 39, "digitalConsumption": 80}	{"taxTolerance": 54, "governmentTrust": 37, "policyAcceptance": 41, "regulationPreference": 74, "publicServiceSatisfaction": 59}	1
577	임민서	54	50-59	Female	서울특별시	37.490129	126.952694	대학교 졸	350-500만원	생산직	자녀 양육 가구	-15	진보 성향 무당층	70	{"economy": -8, "housing": 24, "welfare": 35, "security": -9, "environment": 35}	SNS	{성장,전통,공동체}	서울특별시에 거주하는 50-59 생산직. 정치 성향은 중도이며 성장, 전통, 공동체 가치를 중시한다.	{"brandLoyalty": 38, "noveltySeeking": 68, "ecoConsciousness": 46, "priceSensitivity": 42, "digitalConsumption": 70}	{"taxTolerance": 36, "governmentTrust": 56, "policyAcceptance": 22, "regulationPreference": 53, "publicServiceSatisfaction": 56}	1
578	전준서	52	50-59	Female	서울특별시	37.575648	127.043751	대학교 졸	500-700만원	사무직	부부 가구	8	중도 무당층	70	{"economy": -17, "housing": 21, "welfare": 14, "security": 3, "environment": 17}	지상파/종편 뉴스	{다양성,자유,전통}	서울특별시에 거주하는 50-59 사무직. 정치 성향은 중도이며 다양성, 자유, 전통 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 47, "ecoConsciousness": 58, "priceSensitivity": 55, "digitalConsumption": 80}	{"taxTolerance": 54, "governmentTrust": 61, "policyAcceptance": 48, "regulationPreference": 51, "publicServiceSatisfaction": 87}	1
579	조광수	51	50-59	Female	서울특별시	37.615906	127.036771	전문대 졸	500-700만원	생산직	부부 가구	4	중도 무당층	70	{"economy": -17, "housing": 11, "welfare": 14, "security": 8, "environment": 28}	신문/팟캐스트	{공정,자유,공동체}	서울특별시에 거주하는 50-59 생산직. 정치 성향은 중도이며 공정, 자유, 공동체 가치를 중시한다.	{"brandLoyalty": 49, "noveltySeeking": 75, "ecoConsciousness": 42, "priceSensitivity": 68, "digitalConsumption": 59}	{"taxTolerance": 42, "governmentTrust": 31, "policyAcceptance": 64, "regulationPreference": 76, "publicServiceSatisfaction": 66}	1
580	임다은	53	50-59	Female	서울특별시	37.572175	126.925025	대학원 졸	200-350만원	사무직	부부 가구	-6	중도 무당층	71	{"economy": -17, "housing": -9, "welfare": 8, "security": 27, "environment": 19}	포털 뉴스	{안정,다양성,혁신}	서울특별시에 거주하는 50-59 사무직. 정치 성향은 중도이며 안정, 다양성, 혁신 가치를 중시한다.	{"brandLoyalty": 58, "noveltySeeking": 78, "ecoConsciousness": 42, "priceSensitivity": 70, "digitalConsumption": 50}	{"taxTolerance": 58, "governmentTrust": 58, "policyAcceptance": 42, "regulationPreference": 47, "publicServiceSatisfaction": 68}	1
581	정하은	59	50-59	Female	서울특별시	37.611457	126.987005	전문대 졸	350-500만원	전문직	자녀 양육 가구	34	보수 성향 무당층	93	{"economy": 2, "housing": -1, "welfare": -6, "security": 49, "environment": -10}	SNS	{성장,안전,전통}	서울특별시에 거주하는 50-59 전문직. 정치 성향은 보수이며 성장, 안전, 전통 가치를 중시한다.	{"brandLoyalty": 61, "noveltySeeking": 55, "ecoConsciousness": 54, "priceSensitivity": 69, "digitalConsumption": 78}	{"taxTolerance": 57, "governmentTrust": 40, "policyAcceptance": 60, "regulationPreference": 71, "publicServiceSatisfaction": 62}	1
582	황지우	57	50-59	Male	서울특별시	37.51547	126.932971	고졸 이하	200-350만원	자영업	자녀 양육 가구	32	보수 성향 무당층	73	{"economy": 1, "housing": -23, "welfare": 41, "security": 19, "environment": -5}	SNS	{안정,성장,자유}	서울특별시에 거주하는 50-59 자영업. 정치 성향은 중도이며 안정, 성장, 자유 가치를 중시한다.	{"brandLoyalty": 47, "noveltySeeking": 45, "ecoConsciousness": 49, "priceSensitivity": 78, "digitalConsumption": 85}	{"taxTolerance": 41, "governmentTrust": 45, "policyAcceptance": 66, "regulationPreference": 69, "publicServiceSatisfaction": 65}	1
583	오유준	52	50-59	Male	서울특별시	37.545103	126.976054	대학원 졸	350-500만원	공무원	부부 가구	-13	중도 무당층	66	{"economy": -38, "housing": 63, "welfare": 24, "security": 8, "environment": 27}	지상파/종편 뉴스	{다양성,안전,안정}	서울특별시에 거주하는 50-59 공무원. 정치 성향은 중도이며 다양성, 안전, 안정 가치를 중시한다.	{"brandLoyalty": 54, "noveltySeeking": 56, "ecoConsciousness": 45, "priceSensitivity": 36, "digitalConsumption": 55}	{"taxTolerance": 37, "governmentTrust": 51, "policyAcceptance": 42, "regulationPreference": 50, "publicServiceSatisfaction": 52}	1
584	서도윤	50	50-59	Male	서울특별시	37.551462	126.932572	대학교 졸	500-700만원	사무직	1인 가구	-37	진보 성향 무당층	94	{"economy": -18, "housing": 31, "welfare": 33, "security": -32, "environment": -4}	지상파/종편 뉴스	{혁신,안전,환경}	서울특별시에 거주하는 50-59 사무직. 정치 성향은 진보이며 혁신, 안전, 환경 가치를 중시한다.	{"brandLoyalty": 52, "noveltySeeking": 62, "ecoConsciousness": 53, "priceSensitivity": 57, "digitalConsumption": 65}	{"taxTolerance": 54, "governmentTrust": 37, "policyAcceptance": 40, "regulationPreference": 65, "publicServiceSatisfaction": 69}	1
585	신순자	58	50-59	Male	서울특별시	37.597483	127.028803	대학원 졸	350-500만원	서비스직	부부 가구	29	보수 성향 무당층	78	{"economy": 20, "housing": 9, "welfare": 8, "security": 19, "environment": 20}	유튜브	{성장,자유,안전}	서울특별시에 거주하는 50-59 서비스직. 정치 성향은 중도이며 성장, 자유, 안전 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 66, "ecoConsciousness": 51, "priceSensitivity": 74, "digitalConsumption": 52}	{"taxTolerance": 53, "governmentTrust": 52, "policyAcceptance": 37, "regulationPreference": 80, "publicServiceSatisfaction": 70}	1
586	장현우	55	50-59	Male	서울특별시	37.642491	127.049135	전문대 졸	500-700만원	사무직	부부 가구	28	보수 성향 무당층	70	{"economy": 17, "housing": 5, "welfare": 4, "security": 32, "environment": -9}	SNS	{안정,다양성,환경}	서울특별시에 거주하는 50-59 사무직. 정치 성향은 중도이며 안정, 다양성, 환경 가치를 중시한다.	{"brandLoyalty": 32, "noveltySeeking": 45, "ecoConsciousness": 31, "priceSensitivity": 51, "digitalConsumption": 74}	{"taxTolerance": 44, "governmentTrust": 46, "policyAcceptance": 42, "regulationPreference": 75, "publicServiceSatisfaction": 59}	1
587	송경숙	60	60-69	Female	서울특별시	37.57989	126.919567	대학교 졸	350-500만원	서비스직	1인 가구	6	중도 무당층	51	{"economy": 16, "housing": 19, "welfare": 11, "security": 2, "environment": 13}	지상파/종편 뉴스	{성장,혁신,공동체}	서울특별시에 거주하는 60-69 서비스직. 정치 성향은 중도이며 성장, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 44, "noveltySeeking": 50, "ecoConsciousness": 41, "priceSensitivity": 74, "digitalConsumption": 68}	{"taxTolerance": 44, "governmentTrust": 51, "policyAcceptance": 42, "regulationPreference": 65, "publicServiceSatisfaction": 64}	1
588	박주원	67	60-69	Female	서울특별시	37.527259	126.922792	전문대 졸	200-350만원	은퇴	다세대 가구	24	보수 성향 무당층	91	{"economy": -14, "housing": 40, "welfare": 0, "security": 17, "environment": 20}	유튜브	{안전,안정,성장}	서울특별시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 안전, 안정, 성장 가치를 중시한다.	{"brandLoyalty": 64, "noveltySeeking": 56, "ecoConsciousness": 22, "priceSensitivity": 76, "digitalConsumption": 41}	{"taxTolerance": 26, "governmentTrust": 50, "policyAcceptance": 60, "regulationPreference": 52, "publicServiceSatisfaction": 60}	1
589	김민준	61	60-69	Female	서울특별시	37.634598	127.045465	전문대 졸	350-500만원	프리랜서	자녀 양육 가구	23	보수 성향 무당층	92	{"economy": 4, "housing": 20, "welfare": -16, "security": 24, "environment": 26}	SNS	{공동체,안정,안전}	서울특별시에 거주하는 60-69 프리랜서. 정치 성향은 중도이며 공동체, 안정, 안전 가치를 중시한다.	{"brandLoyalty": 59, "noveltySeeking": 48, "ecoConsciousness": 59, "priceSensitivity": 62, "digitalConsumption": 69}	{"taxTolerance": 52, "governmentTrust": 57, "policyAcceptance": 76, "regulationPreference": 77, "publicServiceSatisfaction": 58}	1
590	신현우	68	60-69	Female	서울특별시	37.599308	127.002853	전문대 졸	350-500만원	은퇴	다세대 가구	46	보수 정당 지지	92	{"economy": 24, "housing": 16, "welfare": -7, "security": 33, "environment": 8}	포털 뉴스	{공정,혁신,공동체}	서울특별시에 거주하는 60-69 은퇴. 정치 성향은 보수이며 공정, 혁신, 공동체 가치를 중시한다.	{"brandLoyalty": 53, "noveltySeeking": 61, "ecoConsciousness": 52, "priceSensitivity": 71, "digitalConsumption": 50}	{"taxTolerance": 45, "governmentTrust": 46, "policyAcceptance": 52, "regulationPreference": 72, "publicServiceSatisfaction": 64}	1
591	한준서	68	60-69	Male	서울특별시	37.51717	126.912073	대학교 졸	350-500만원	은퇴	부부 가구	21	보수 성향 무당층	73	{"economy": -16, "housing": 12, "welfare": 10, "security": 11, "environment": 7}	SNS	{자유,성장,환경}	서울특별시에 거주하는 60-69 은퇴. 정치 성향은 중도이며 자유, 성장, 환경 가치를 중시한다.	{"brandLoyalty": 72, "noveltySeeking": 61, "ecoConsciousness": 47, "priceSensitivity": 61, "digitalConsumption": 52}	{"taxTolerance": 46, "governmentTrust": 50, "policyAcceptance": 42, "regulationPreference": 80, "publicServiceSatisfaction": 59}	1
592	전광수	62	60-69	Male	서울특별시	37.544637	126.899973	전문대 졸	500-700만원	서비스직	다세대 가구	21	보수 성향 무당층	77	{"economy": 16, "housing": -18, "welfare": 19, "security": -3, "environment": 11}	지상파/종편 뉴스	{안정,환경,성장}	서울특별시에 거주하는 60-69 서비스직. 정치 성향은 중도이며 안정, 환경, 성장 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 67, "ecoConsciousness": 62, "priceSensitivity": 73, "digitalConsumption": 62}	{"taxTolerance": 43, "governmentTrust": 52, "policyAcceptance": 53, "regulationPreference": 81, "publicServiceSatisfaction": 49}	1
593	류철수	66	60-69	Male	서울특별시	37.551488	126.996781	대학교 졸	350-500만원	서비스직	부부 가구	64	보수 정당 지지	84	{"economy": 15, "housing": 1, "welfare": -12, "security": 39, "environment": -4}	SNS	{안전,공정,안정}	서울특별시에 거주하는 60-69 서비스직. 정치 성향은 보수이며 안전, 공정, 안정 가치를 중시한다.	{"brandLoyalty": 45, "noveltySeeking": 61, "ecoConsciousness": 49, "priceSensitivity": 64, "digitalConsumption": 59}	{"taxTolerance": 50, "governmentTrust": 54, "policyAcceptance": 67, "regulationPreference": 65, "publicServiceSatisfaction": 71}	1
594	임지민	62	60-69	Male	서울특별시	37.635001	126.883251	전문대 졸	700만원 이상	주부	1인 가구	15	보수 성향 무당층	75	{"economy": 11, "housing": 2, "welfare": 13, "security": 29, "environment": -3}	지상파/종편 뉴스	{전통,혁신,안전}	서울특별시에 거주하는 60-69 주부. 정치 성향은 중도이며 전통, 혁신, 안전 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 44, "ecoConsciousness": 52, "priceSensitivity": 45, "digitalConsumption": 52}	{"taxTolerance": 31, "governmentTrust": 53, "policyAcceptance": 64, "regulationPreference": 79, "publicServiceSatisfaction": 70}	1
595	신지우	75	70+	Female	서울특별시	37.52757	126.955044	대학교 졸	200-350만원	은퇴	자녀 양육 가구	42	보수 성향 무당층	62	{"economy": 22, "housing": 8, "welfare": -8, "security": 24, "environment": 23}	포털 뉴스	{안전,전통,자유}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 안전, 전통, 자유 가치를 중시한다.	{"brandLoyalty": 41, "noveltySeeking": 46, "ecoConsciousness": 36, "priceSensitivity": 62, "digitalConsumption": 48}	{"taxTolerance": 30, "governmentTrust": 43, "policyAcceptance": 43, "regulationPreference": 84, "publicServiceSatisfaction": 63}	1
596	조민서	78	70+	Female	서울특별시	37.580293	126.895915	대학교 졸	350-500만원	은퇴	부부 가구	14	중도 무당층	94	{"economy": -7, "housing": 10, "welfare": 26, "security": 8, "environment": 19}	지상파/종편 뉴스	{자유,안정,혁신}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 자유, 안정, 혁신 가치를 중시한다.	{"brandLoyalty": 48, "noveltySeeking": 43, "ecoConsciousness": 39, "priceSensitivity": 69, "digitalConsumption": 56}	{"taxTolerance": 59, "governmentTrust": 51, "policyAcceptance": 38, "regulationPreference": 74, "publicServiceSatisfaction": 66}	1
597	한하은	82	70+	Female	서울특별시	37.495186	126.906356	전문대 졸	350-500만원	은퇴	1인 가구	42	보수 성향 무당층	99	{"economy": 5, "housing": -10, "welfare": -26, "security": -3, "environment": -1}	SNS	{자유,혁신,안전}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 자유, 혁신, 안전 가치를 중시한다.	{"brandLoyalty": 35, "noveltySeeking": 53, "ecoConsciousness": 37, "priceSensitivity": 50, "digitalConsumption": 45}	{"taxTolerance": 38, "governmentTrust": 41, "policyAcceptance": 62, "regulationPreference": 52, "publicServiceSatisfaction": 74}	1
598	오영수	77	70+	Male	서울특별시	37.573914	126.913695	대학교 졸	500-700만원	은퇴	부부 가구	-1	중도 무당층	76	{"economy": 16, "housing": 0, "welfare": 19, "security": -2, "environment": 24}	신문/팟캐스트	{공정,환경,혁신}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 중도이며 공정, 환경, 혁신 가치를 중시한다.	{"brandLoyalty": 61, "noveltySeeking": 58, "ecoConsciousness": 46, "priceSensitivity": 69, "digitalConsumption": 51}	{"taxTolerance": 31, "governmentTrust": 49, "policyAcceptance": 48, "regulationPreference": 76, "publicServiceSatisfaction": 49}	1
599	강지민	75	70+	Male	서울특별시	37.527359	127.042579	대학교 졸	500-700만원	은퇴	자녀 양육 가구	60	보수 정당 지지	71	{"economy": 43, "housing": -12, "welfare": 1, "security": 56, "environment": 11}	유튜브	{자유,환경,다양성}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 자유, 환경, 다양성 가치를 중시한다.	{"brandLoyalty": 67, "noveltySeeking": 51, "ecoConsciousness": 51, "priceSensitivity": 60, "digitalConsumption": 46}	{"taxTolerance": 38, "governmentTrust": 49, "policyAcceptance": 80, "regulationPreference": 77, "publicServiceSatisfaction": 38}	1
600	오준서	75	70+	Male	서울특별시	37.572716	127.021969	전문대 졸	200만원 미만	은퇴	다세대 가구	48	보수 정당 지지	81	{"economy": 22, "housing": -4, "welfare": 5, "security": 43, "environment": 18}	유튜브	{다양성,자유,성장}	서울특별시에 거주하는 70+ 은퇴. 정치 성향은 보수이며 다양성, 자유, 성장 가치를 중시한다.	{"brandLoyalty": 69, "noveltySeeking": 50, "ecoConsciousness": 59, "priceSensitivity": 75, "digitalConsumption": 54}	{"taxTolerance": 53, "governmentTrust": 38, "policyAcceptance": 31, "regulationPreference": 45, "publicServiceSatisfaction": 59}	1
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

COPY public.elections (id, name, election_type, election_date, region_code, metric, leaning, actual_value) FROM stdin;
35	제20대 대통령선거	대통령선거	2022-03-09	11	보수 후보(윤석열) 득표율	conservative	50.56
36	제20대 대통령선거	대통령선거	2022-03-09	26	보수 후보(윤석열) 득표율	conservative	58.25
37	제20대 대통령선거	대통령선거	2022-03-09	27	보수 후보(윤석열) 득표율	conservative	75.14
38	제20대 대통령선거	대통령선거	2022-03-09	28	보수 후보(윤석열) 득표율	conservative	47.05
39	제20대 대통령선거	대통령선거	2022-03-09	29	보수 후보(윤석열) 득표율	conservative	12.72
40	제20대 대통령선거	대통령선거	2022-03-09	30	보수 후보(윤석열) 득표율	conservative	49.55
41	제20대 대통령선거	대통령선거	2022-03-09	31	보수 후보(윤석열) 득표율	conservative	54.41
42	제20대 대통령선거	대통령선거	2022-03-09	36	보수 후보(윤석열) 득표율	conservative	44.14
43	제20대 대통령선거	대통령선거	2022-03-09	41	보수 후보(윤석열) 득표율	conservative	45.62
44	제20대 대통령선거	대통령선거	2022-03-09	43	보수 후보(윤석열) 득표율	conservative	50.67
45	제20대 대통령선거	대통령선거	2022-03-09	44	보수 후보(윤석열) 득표율	conservative	51.08
46	제20대 대통령선거	대통령선거	2022-03-09	46	보수 후보(윤석열) 득표율	conservative	11.44
47	제20대 대통령선거	대통령선거	2022-03-09	47	보수 후보(윤석열) 득표율	conservative	72.76
48	제20대 대통령선거	대통령선거	2022-03-09	48	보수 후보(윤석열) 득표율	conservative	58.24
49	제20대 대통령선거	대통령선거	2022-03-09	50	보수 후보(윤석열) 득표율	conservative	42.69
50	제20대 대통령선거	대통령선거	2022-03-09	51	보수 후보(윤석열) 득표율	conservative	54.18
51	제20대 대통령선거	대통령선거	2022-03-09	52	보수 후보(윤석열) 득표율	conservative	14.42
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
1	1	뉴스	청년 월세지원 관련 보도 급증	2026-06-03 00:10:52.678+00	642	41	38	21	주요 일간지·방송에서 청년 월세지원 확대를 다룬 보도가 한 주 새 급증했습니다. 긍정 41% · 중립 38% · 부정 21%로 우호적 논조가 우세하며, 합성 여론의 정책수용도가 52.4% → 56.1% (+3.7%p) 상승하는 것으로 추정됩니다. (데모 · 예시 수치)	Seraph	17	정책수용도(%)	52.4	56.1	완료	2026-06-22 00:10:57.260924+00
2	1	검색트렌드	온누리 상품권 지급 검색량 주간 급상승	2026-06-06 00:10:52.678+00	880	47	33	20	'온누리 상품권 100만원' 연관 검색량이 주간 기준 가파르게 상승했습니다. 관심도 확대가 수용 여론으로 이어져 정책수용도가 55.0% → 58.2% (+3.2%p) 변동하는 것으로 추정됩니다. (데모 · 예시 수치)	Seraph	17	정책수용도(%)	55	58.2	완료	2026-06-22 00:10:57.260924+00
3	1	SNS·커뮤니티	구독형 모빌리티 출시 커뮤니티 반응 확산	2026-06-09 00:10:52.678+00	514	39	24	37	온라인 커뮤니티에서 프리미엄 구독형 모빌리티 출시에 대한 갑론을박이 확산됐습니다. 긍정 39% · 부정 37%로 양극화 양상이나 구매의향은 38.6% → 41.9% (+3.3%p) 상승하는 것으로 추정됩니다. (데모 · 예시 수치)	Lumen	2	구매의향(%)	38.6	41.9	완료	2026-06-22 00:10:57.260924+00
4	1	뉴스	신제품 구독 모델 주요 매체 일제 보도	2026-06-12 00:10:52.678+00	421	36	45	19	구독형 신제품 출시를 주요 매체가 일제히 보도했습니다. 중립 45%로 관망 논조가 많으나 구매의향이 40.1% → 43.2% (+3.1%p) 개선되는 것으로 추정됩니다. (데모 · 예시 수치)	Lumen	2	구매의향(%)	40.1	43.2	완료	2026-06-22 00:10:57.260924+00
5	1	검색트렌드	정책 키워드 검색 관심도 확대	2026-06-15 00:10:52.678+00	733	42	36	22	핵심 정책 키워드의 검색 관심도가 확대됐습니다. 긍정 42%의 우호 신호가 관측되며 합성 여론 지지율이 41.2% → 43.8% (+2.6%p) 상승하는 것으로 추정됩니다. (데모 · 예시 수치)	Dynamo	\N	지지율(%)	41.2	43.8	완료	2026-06-22 00:10:57.260924+00
6	1	SNS·커뮤니티	현안 해시태그 언급량 급증	2026-06-18 00:10:52.678+00	968	35	21	44	SNS 해시태그 언급량이 급증했으나 부정 44%로 비판 여론이 우세했습니다. 합성 여론 지지율이 43.0% → 39.5% (−3.5%p) 하락하는 것으로 추정됩니다. (데모 · 예시 수치)	Dynamo	\N	지지율(%)	43	39.5	완료	2026-06-22 00:10:57.260924+00
7	1	뉴스	물가 안정 대책 언론 집중 조명	2026-06-20 00:10:52.678+00	388	44	40	16	물가 안정 대책을 언론이 집중 조명했습니다. 긍정 44% · 부정 16%로 호의적 논조가 뚜렷해 정책수용도가 53.5% → 57.0% (+3.5%p) 상승하는 것으로 추정됩니다. (데모 · 예시 수치)	Seraph	1	정책수용도(%)	53.5	57	완료	2026-06-22 00:10:57.260924+00
8	1	검색트렌드	브랜드 연관 검색어 상위권 진입	2026-06-21 00:10:52.678+00	556	45	35	20	브랜드 연관 검색어가 포털 상위권에 진입했습니다. 긍정 45%의 관심이 구매의향으로 전이되어 42.0% → 45.4% (+3.4%p) 상승하는 것으로 추정됩니다. (데모 · 예시 수치)	Lumen	2	구매의향(%)	42	45.4	완료	2026-06-22 00:10:57.260924+00
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

COPY public.simulations (id, title, audience, product, policy_text, model, status, progress, total_agents, cost_estimate_usd, cost_actual_usd, overall_support, support_pct, oppose_pct, neutral_pct, summary, created_at, completed_at, user_id, locked_by, locked_at, heartbeat_at, last_error) FROM stdin;
1	청년 월세 지원 확대 정책 반응 테스트	정부	Seraph	서울시는 만 19~34세 무주택 청년을 대상으로 월 최대 30만원의 월세를 24개월간 지원하는 정책을 검토 중입니다. 재원은 지방채 발행과 기존 주거복지 예산 재편으로 충당합니다. 이 정책에 대한 시민 반응을 평가하세요.	gpt-5-mini	completed	100	500	0.2875	0.3071	50.8	40.6	38.2	21.2	서울 합성 인구 500명 시뮬레이션 결과 찬반이 팽팽하게 갈리는 반응이 나타났습니다. 찬성 40.6%, 반대 38.2%, 중립 21.2%로, 관악구 지역에서 지지가 가장 높았습니다.	2026-06-15 06:49:34.164375+00	2026-06-13 06:49:34.164375+00	1	\N	\N	\N	\N
2	프리미엄 구독형 모빌리티 서비스 출시 컨셉 테스트	비즈니스	Lumen	월 9만 9천원에 따릉이·심야버스·전기 킥보드·카셰어링을 무제한 이용할 수 있는 통합 구독형 모빌리티 멤버십 'SeoulPass+'를 출시하려 합니다. 직장인과 청년을 핵심 타깃으로 합니다. 이 신서비스에 대한 구매 의향과 반응을 평가하세요.	gpt-5-mini	completed	100	500	0.2875	0.2772	45.4	27.2	43.8	29	서울 합성 인구 500명 시뮬레이션 결과 찬반이 팽팽하게 갈리는 반응이 나타났습니다. 찬성 27.2%, 반대 43.8%, 중립 29%로, 서대문구 지역에서 지지가 가장 높았습니다.	2026-06-15 06:49:48.082029+00	2026-06-10 06:49:48.082029+00	1	\N	\N	\N	\N
17	서울지역 20대 청년 온누리 상품권 100만원권 일괄 지급	정부	Seraph	서울시 20대 청년의 자산 형성을 위해서 일괄적으로 100만원 온누리 상품권을 지급합니다.\n이 상품권은 서울 지역에서만 사용가능하면 사용기간은 3개월 이내이고, 3개월 후 소멸됩니다.	gpt-5-nano	completed	100	50	0.0058	0.0417	43.6	16	22	62	전국 합성 인구 50명 시뮬레이션 결과 수용과 거부가 팽팽하게 갈리는 반응이 나타났습니다. 수용 16%, 거부 22%, 중립 62%로, 서울특별시 지역에서 수용도가 가장 높았습니다.	2026-06-19 03:26:22.824226+00	2026-06-19 03:34:57.19+00	1	\N	\N	\N	\N
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
126	한국갤럽 데일리 오피니언 — 향후 1년 경기 전망	전국 만 18세 이상 1,000명 대상 전화면접(CATI) 조사. 향후 1년 경기 전망에서 '나빠질 것' 47% vs '좋아질 것' 24%로 비관론 우세 → 정부의 경제 역할 확대 선호로 해석.	전화면접조사(CATI), 무선 가상번호 무작위 추출	1000	2025-04-17	active	95	[{"issue": "경제", "factor": "경기 전망", "weight": 0.4, "direction": "경기 비관론 우세(나빠질 47% vs 좋아질 24%) → 정부 경제 역할 확대 선호", "targetStance": -20}]	2026-06-19 05:13:52.922662+00	t	t	한국갤럽	데일리 오피니언 제634호 — 향후 1년 경기 전망	2025-04-15 ~ 2025-04-17	https://www.gallup.co.kr/gallupdb/report.asp	political	1
127	통계청 2023년 사회조사 — 복지 부문	전국 만 13세 이상 약 36,000명(약 19,000가구) 대상 면접조사. 늘려야 할 복지서비스로 고용(취업)지원 1위·보건의료 2위, 노후 준비 필요 인식이 높게 나타남 → 복지 확대 지지.	가구방문 면접조사 (국가지정통계)	36000	2023-05-31	active	95	[{"issue": "복지", "factor": "복지 수요", "weight": 0.55, "direction": "늘려야 할 복지 1위 고용지원·2위 보건의료 → 복지 확대 지지", "targetStance": 35}]	2026-06-19 05:13:52.922662+00	t	t	통계청	2023년 사회조사 결과 (복지·사회참여·여가·소득과 소비·노동)	2023-05 (16일간)	https://kostat.go.kr/board.es?mid=a10301010000&bid=219&act=view&list_no=427913	political	1
128	서울대 통일평화연구원 2024 통일의식조사 — 대북·안보 인식	전국 17개 시·도 만 19세 이상 1,200명 대상 1:1 면접조사(표본오차 ±2.8%, 95% 신뢰수준). 대북 적대의식이 22.3%로 역대 최고(3년 연속 상승), 통일 불필요 여론도 역대 최고 → 안보 강화 기조 강화.	1:1 대면 면접조사 (한국갤럽 수행)	1200	2024-07-23	active	95	[{"issue": "안보", "factor": "대북 인식", "weight": 0.45, "direction": "대북 적대의식 22.3% 역대 최고 → 안보 강화 기조 강화", "targetStance": 18}]	2026-06-19 05:13:52.922662+00	t	t	서울대학교 통일평화연구원	2024 통일의식조사	2024-07-01 ~ 2024-07-23	https://ipus.snu.ac.kr/blog/archives/news/9627	political	1
129	한국환경연구원(KEI) 2024 국민환경의식조사 — 기후변화 인식	전국 성인 3,040명 대상 웹조사(지역·성·연령 비례 할당). 기후변화를 가장 중요한 환경문제로 꼽은 응답이 68.2%로 2021년 39.8%에서 급증, 불안감 75.7% → 환경 보호 우선 강하게 지지.	웹조사 (온라인 패널, 비례 할당 추출)	3040	2024-12-31	active	95	[{"issue": "환경", "factor": "기후변화 심각성", "weight": 0.68, "direction": "기후변화를 최우선 환경문제로 꼽은 응답 68.2% → 환경 보호 우선", "targetStance": 45}]	2026-06-19 05:13:52.922662+00	t	t	한국환경연구원(KEI)	2024 국민환경의식조사	2024 (연간 조사)	https://www.kei.re.kr/elibList.es?mid=a10101010000&elibName=researchreport&act=view&c_id=766481	political	1
130	국토교통부 2023년 주거실태조사 — 주거 인식	전국 약 6.1만 가구 대상 1:1 개별 면접조사(국토연구원·한국리서치 수행). 내 집 보유 의사 87.3%인 반면 자가점유율은 57.4%에 그쳐 미충족 주거 수요가 큼 → 주거 지원·공급 확대 지지.	1:1 개별 면접조사 (국토연구원·한국리서치)	61000	2023-12-31	active	95	[{"issue": "주거", "factor": "주거 보유의사", "weight": 0.6, "direction": "내 집 보유의사 87.3% vs 자가점유율 57.4% → 주거 지원·공급 확대 지지", "targetStance": 42}]	2026-06-19 05:13:52.922662+00	t	t	국토교통부	2023년도 주거실태조사	2023 (연간 조사)	https://www.molit.go.kr/USR/NEWS/m_71/dtl.jsp?lcmspage=1&id=95090538	political	1
131	방송통신위원회 2024 방송매체 이용행태조사 — 디지털·OTT 소비	전국 17개 시·도 13세 이상 8,316명 대상 방문면접(국가승인통계). 전체 OTT 이용률 79.2%, 주5일 이상 스마트폰 이용 92.2%로 디지털 매체 소비가 일상화 → 합성 인구의 디지털소비 성향을 높게 보정.	가구방문 면접조사 (국가승인통계 제164002호)	8316	2024-12-30	active	95	[{"issue": "디지털소비", "factor": "OTT·디지털 매체 이용", "weight": 0.7, "direction": "OTT 79.2%·스마트폰 92.2% → 디지털 채널 소비 성향 높음", "targetStance": 72}]	2026-06-19 05:13:52.922662+00	t	t	방송통신위원회	2024 방송매체 이용행태조사	2024 (연간 조사)	https://www.kcc.go.kr/user.do?mode=view&page=A05030000&dc=K05030000&boardId=1113&boardSeq=64951	commercial	1
132	과학기술정보통신부 2024 인터넷이용실태조사 — 신기술 수용	전국 25,509가구·만 3세 이상 60,229명 대상 면접조사. AI 서비스 경험률 60.3%, 생성형 AI 경험률 33.3%(전년 17.6% 대비 약 2배)로 신기술 수용이 빠르게 확산 → 신제품수용 성향을 중상위로 보정.	가구방문 면접조사 (국가승인통계)	60229	2025-03-31	active	95	[{"issue": "신제품수용", "factor": "AI·신기술 수용", "weight": 0.6, "direction": "AI 경험 60.3%·생성형 AI 33.3%(2배↑) → 신제품 수용 성향 중상위", "targetStance": 58}]	2026-06-19 05:13:52.922662+00	t	t	과학기술정보통신부	2024 인터넷이용실태조사	2024 (연간 조사)	https://www.korea.kr/briefing/pressReleaseView.do?newsId=156681493	commercial	1
133	한국소비자원 2025 친환경 소비 제도 이용 실태조사 — 친환경 소비	전국 성인 소비자 3,200명 대상 조사. 친환경 제도 이용 66.4%, 구매 의향 82.2%로 인식은 높으나 실제 친환경 제품 구매 노력은 25.5%에 그쳐 인식–실천 괴리가 큼 → 친환경소비 성향을 중간 수준으로 보정.	소비자 대상 설문조사	3200	2025-05-13	active	95	[{"issue": "친환경소비", "factor": "친환경 인식–실천 괴리", "weight": 0.55, "direction": "제도 이용 66.4%·의향 82.2% vs 실천 25.5% → 친환경소비 중간 수준", "targetStance": 50}]	2026-06-19 05:13:52.922662+00	t	t	한국소비자원	친환경 제도 소비자 이용 실태조사	2025	https://www.kca.go.kr/home/board/download.do?menukey=4002&fno=10046976&bid=00000013&did=1003867815	commercial	1
134	한국은행 2025 소비자동향조사 — 물가·가격 민감도	전국 약 2,500가구 대상 월간 소비자동향조사. 물가수준전망 CSI 148, 기대인플레이션율 2.6%로 향후 물가 상승 부담 인식이 높아 가격에 민감한 소비 태도가 우세 → 가격민감도 성향을 높게 보정.	가구 대상 월간 설문조사 (한국은행 통계)	2500	2025-12-23	active	95	[{"issue": "가격민감도", "factor": "물가 상승 부담", "weight": 0.6, "direction": "물가수준전망 CSI 148·기대인플레 2.6% → 가격민감 소비 우세", "targetStance": 68}]	2026-06-19 05:13:52.922662+00	t	t	한국은행	소비자동향조사(소비자심리지수)	2025-12	https://www.bok.or.kr/portal/bbs/B0000501/view.do?nttId=10095310&menuNo=201264	commercial	1
135	대한상공회의소 2024 소비 트렌드 조사 — 브랜드 충성도	소비자 대상 소비 트렌드 조사. 고가 제품 구매 축소 49%, 저렴한 브랜드 의도적 탐색 43.8%, PB(자체 브랜드) 구매 증가 33%로 가성비 중심 전환이 뚜렷해 브랜드 충성도가 약화 → 브랜드충성도 성향을 낮게 보정.	소비자 대상 설문조사	1000	2024-08-31	active	90	[{"issue": "브랜드충성도", "factor": "가성비 전환·브랜드 이탈", "weight": 0.5, "direction": "저렴 브랜드 탐색 43.8%·PB 구매 33% → 브랜드 충성도 약화", "targetStance": 38}]	2026-06-19 05:13:52.922662+00	t	t	대한상공회의소	2024 하반기 소비트렌드 변화와 대응방안	2024 하반기	http://www.korcham.net/nCham/Service/Economy/appl/KcciReportDetail.asp?SEQ_NO_C010=20120938356&CHAM_CD=B001	commercial	1
136	한국행정연구원 2023 사회통합실태조사 — 정부 신뢰	전국 만 19세 이상 약 8,000명 대상 1:1 면접조사(국가승인통계). 중앙정부 신뢰 응답이 절반에 못 미치는 수준(약 48%)에 머물러 정부 기관에 대한 신뢰가 중간 이하로 나타남 → 정부신뢰 성향을 중간 이하로 보정.	1:1 가구방문 면접조사 (국가승인통계 제417001호)	8000	2023-12-31	active	95	[{"issue": "정부신뢰", "factor": "중앙정부 신뢰", "weight": 0.6, "direction": "중앙정부 신뢰 약 48%로 절반 미만 → 정부신뢰 중간 이하", "targetStance": 48}]	2026-06-19 05:13:52.922662+00	t	t	한국행정연구원(KIPA)	2023 사회통합실태조사	2023 (연간 조사)	https://www.kipa.re.kr/site/kipa/research/selectBaseList.do	policy	1
137	한국행정연구원 2023 사회통합실태조사 — 정책 수용성	전국 만 19세 이상 약 8,000명 대상 면접조사(국가승인통계). 정부 정책 결정 과정의 공정성·반응성에 대한 긍정 평가가 절반에 못 미쳐(약 46%) 새 정책에 대한 자발적 수용·순응 의향이 중간 수준에 그침 → 정책수용성을 중간 수준으로 보정.	1:1 가구방문 면접조사 (국가승인통계 제417001호)	8000	2023-12-31	active	95	[{"issue": "정책수용성", "factor": "정책 결정 과정 신뢰", "weight": 0.5, "direction": "정책 결정 과정 공정성 긍정 약 46% → 정책수용성 중간 수준", "targetStance": 46}]	2026-06-19 05:13:52.922662+00	t	t	한국행정연구원(KIPA)	2023 사회통합실태조사 (정부 정책 인식)	2023 (연간 조사)	https://www.kipa.re.kr/site/kipa/research/selectBaseList.do	policy	1
138	한국조세재정연구원 2023 재정패널 — 증세·조세 인식	전국 가구·개인 패널 대상 재정패널조사. 복지 확대를 위한 증세에 대한 찬성이 약 45% 수준으로, 복지 수요는 높으나 본인 세 부담 증가에는 신중한 태도가 우세 → 증세수용 성향을 중간 이하로 보정.	가구·개인 패널 설문조사 (재정패널)	5000	2023-12-31	active	90	[{"issue": "증세수용", "factor": "증세 수용성", "weight": 0.5, "direction": "복지 위한 증세 찬성 약 45% → 본인 세부담엔 신중, 증세수용 중간 이하", "targetStance": 45}]	2026-06-19 05:13:52.922662+00	t	t	한국조세재정연구원(KIPF)	재정패널조사 (조세·재정 인식)	2023 (연간 조사)	https://www.kipf.re.kr/panel/	policy	1
139	통계청 2024 사회조사 — 사회안전·규제 인식	전국 만 13세 이상 약 36,000명 대상 면접조사(국가지정통계). 식품·범죄·환경 등 위험으로부터의 사회안전 체감이 높지 않아 정부의 안전·환경 규제 강화 요구가 우세 → 규제선호 성향을 중상위로 보정.	가구방문 면접조사 (국가지정통계)	36000	2024-05-31	active	95	[{"issue": "규제선호", "factor": "사회안전·규제 요구", "weight": 0.55, "direction": "사회안전 체감 낮음 → 안전·환경 규제 강화 요구 우세, 규제선호 중상위", "targetStance": 64}]	2026-06-19 05:13:52.922662+00	t	t	통계청	2024년 사회조사 결과 (안전·환경·사회)	2024-05 (16일간)	https://kostat.go.kr/board.es?mid=a10301010000&bid=219	policy	1
140	행정안전부 2022 전자정부서비스 이용실태조사 — 공공서비스 만족	전국 만 16~74세 대상 전자정부서비스 이용실태조사. 전자정부서비스 이용자 만족도가 97.7%로 매우 높게 나타나 공공·행정 서비스 이용 경험에 대한 만족이 높은 수준 → 공공서비스만족 성향을 높게 보정.	이용자 대상 설문조사 (전자정부서비스 이용실태조사)	4000	2022-12-31	active	95	[{"issue": "공공서비스만족", "factor": "공공서비스 만족", "weight": 0.6, "direction": "전자정부서비스 만족도 97.7% → 공공서비스 만족 높음", "targetStance": 80}]	2026-06-19 05:13:52.922662+00	t	t	행정안전부	2022 전자정부서비스 이용실태조사	2022 (연간 조사)	https://www.mois.go.kr/frt/bbs/type010/commonSelectBoardList.do?bbsId=BBSMSTR_000000000008	policy	1
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, username, name, birth_date, password_hash, role, created_at, budget_limit_usd, avatar) FROM stdin;
2	admin	관리자	\N	***MASKED***	admin	2026-06-18 00:33:26.079448	1	\N
3	newuser_1781743078203	신규유저	\N	***MASKED***	user	2026-06-18 00:39:48.213796	1	\N
1	test	테스트 사용자	1990-05-15	***MASKED***	user	2026-06-18 00:33:26.079448	3	av4
\.


--
-- Name: agents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.agents_id_seq', 600, true);


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

SELECT pg_catalog.setval('public.data_sources_id_seq', 147, true);


--
-- Name: demographic_margins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.demographic_margins_id_seq', 25, true);


--
-- Name: elections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.elections_id_seq', 51, true);


--
-- Name: signal_batches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.signal_batches_id_seq', 8, true);


--
-- Name: simulation_responses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.simulation_responses_id_seq', 1600, true);


--
-- Name: simulations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.simulations_id_seq', 17, true);


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
-- Name: signal_batches signal_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.signal_batches
    ADD CONSTRAINT signal_batches_pkey PRIMARY KEY (id);


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

\unrestrict W2R04auxTqxHvd2SUhC5CWKCMjXKBBb3pzF9ebYBkByKfXwbgvM6N9NXFofwGIJ

