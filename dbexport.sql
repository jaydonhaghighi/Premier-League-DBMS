--
-- PostgreSQL database dump
--

-- Dumped from database version 12.18 (Ubuntu 12.18-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.18 (Ubuntu 12.18-0ubuntu0.20.04.1)

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
-- Name: competition_stages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.competition_stages (
    stage_id integer NOT NULL,
    name character varying(255)
);


ALTER TABLE public.competition_stages OWNER TO postgres;

--
-- Name: competitions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.competitions (
    competition_id integer NOT NULL,
    season_id integer NOT NULL,
    country_name character varying(255),
    competition_name character varying(255),
    competition_gender character varying(10),
    competition_youth boolean,
    competition_international boolean,
    season_name character varying(255),
    match_updated timestamp without time zone,
    match_updated_360 timestamp without time zone,
    match_available_360 timestamp without time zone,
    match_available timestamp without time zone
);


ALTER TABLE public.competitions OWNER TO postgres;

--
-- Name: countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.countries (
    country_id integer NOT NULL,
    country_name character varying(255)
);


ALTER TABLE public.countries OWNER TO postgres;

--
-- Name: event_50_50; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_50_50 (
    event_id uuid NOT NULL,
    outcome_id integer,
    outcome_name character varying(255)
);


ALTER TABLE public.event_50_50 OWNER TO postgres;

--
-- Name: event_bad_behaviour; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_bad_behaviour (
    event_id uuid NOT NULL,
    card_id integer,
    card_name character varying(255)
);


ALTER TABLE public.event_bad_behaviour OWNER TO postgres;

--
-- Name: event_ball_receipt; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_ball_receipt (
    event_id uuid NOT NULL,
    outcome_id integer,
    outcome_name character varying(255)
);


ALTER TABLE public.event_ball_receipt OWNER TO postgres;

--
-- Name: event_ball_recovery; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_ball_recovery (
    event_id uuid NOT NULL,
    recovery_failure boolean,
    offensive boolean
);


ALTER TABLE public.event_ball_recovery OWNER TO postgres;

--
-- Name: event_block; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_block (
    event_id uuid NOT NULL,
    deflection boolean,
    save_block boolean,
    offensive boolean,
    counterpress boolean
);


ALTER TABLE public.event_block OWNER TO postgres;

--
-- Name: event_carry; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_carry (
    event_id uuid NOT NULL,
    end_location jsonb
);


ALTER TABLE public.event_carry OWNER TO postgres;

--
-- Name: event_clearance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_clearance (
    event_id uuid NOT NULL,
    aerial_won boolean,
    body_part_id integer,
    body_part_name character varying(255)
);


ALTER TABLE public.event_clearance OWNER TO postgres;

--
-- Name: event_dribble; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_dribble (
    event_id uuid NOT NULL,
    outcome_id integer,
    outcome_name character varying(255),
    overrun boolean,
    nutmeg boolean,
    no_touch boolean
);


ALTER TABLE public.event_dribble OWNER TO postgres;

--
-- Name: event_duel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_duel (
    event_id uuid NOT NULL,
    duel_type_id integer,
    duel_type_name character varying(255),
    outcome_id integer,
    outcome_name character varying(255)
);


ALTER TABLE public.event_duel OWNER TO postgres;

--
-- Name: event_foul_committed; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_foul_committed (
    event_id uuid NOT NULL,
    offensive boolean,
    foul_type_id integer,
    foul_type_name character varying(255),
    card_id integer,
    card_name character varying(255)
);


ALTER TABLE public.event_foul_committed OWNER TO postgres;

--
-- Name: event_foul_won; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_foul_won (
    event_id uuid NOT NULL,
    defensive boolean
);


ALTER TABLE public.event_foul_won OWNER TO postgres;

--
-- Name: event_goalkeeper; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_goalkeeper (
    event_id uuid NOT NULL,
    body_part_id integer,
    body_part_name character varying(255),
    technique_id integer,
    technique_name character varying(255),
    position_id integer,
    position_name character varying(255),
    outcome_id integer,
    outcome_name character varying(255),
    type_id integer,
    type_name character varying(255)
);


ALTER TABLE public.event_goalkeeper OWNER TO postgres;

--
-- Name: event_half_end; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_half_end (
    event_id uuid NOT NULL,
    early_video_end boolean
);


ALTER TABLE public.event_half_end OWNER TO postgres;

--
-- Name: event_half_start; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_half_start (
    event_id uuid NOT NULL,
    late_video_start boolean
);


ALTER TABLE public.event_half_start OWNER TO postgres;

--
-- Name: event_injury_stoppage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_injury_stoppage (
    event_id uuid NOT NULL,
    in_chain boolean
);


ALTER TABLE public.event_injury_stoppage OWNER TO postgres;

--
-- Name: event_interception; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_interception (
    event_id uuid NOT NULL,
    outcome_id integer,
    outcome_name character varying(255)
);


ALTER TABLE public.event_interception OWNER TO postgres;

--
-- Name: event_pass; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_pass (
    event_id uuid NOT NULL,
    recipient_id integer,
    recipient_name character varying(255),
    length numeric,
    angle numeric,
    height_id integer,
    height_name character varying(255),
    end_location jsonb,
    assisted_shot_id uuid,
    backheel boolean,
    deflected boolean,
    miscommunication boolean,
    "cross" boolean,
    cut_back boolean,
    switch boolean,
    shot_assist boolean,
    goal_assist boolean,
    body_part_id integer,
    body_part_name character varying(255),
    pass_type_id integer,
    pass_type_name character varying(255),
    outcome_id integer,
    outcome_name character varying(255),
    technique_id integer,
    technique_name character varying(255)
);


ALTER TABLE public.event_pass OWNER TO postgres;

--
-- Name: event_player_off; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_player_off (
    event_id uuid NOT NULL,
    permanent boolean
);


ALTER TABLE public.event_player_off OWNER TO postgres;

--
-- Name: event_player_positions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_player_positions (
    event_id uuid NOT NULL,
    player_id integer NOT NULL,
    position_id integer,
    jersey_number integer
);


ALTER TABLE public.event_player_positions OWNER TO postgres;

--
-- Name: event_shot; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_shot (
    event_id uuid NOT NULL,
    key_pass_id uuid,
    end_location jsonb,
    aerial_won boolean,
    follows_dribble boolean,
    first_time boolean,
    freeze_frame jsonb,
    open_goal boolean,
    statsbomb_xg numeric,
    deflected boolean,
    technique_id integer,
    technique_name character varying(255),
    body_part_id integer,
    body_part_name character varying(255),
    shot_type_id integer,
    shot_type_name character varying(255),
    outcome_id integer,
    outcome_name character varying(255)
);


ALTER TABLE public.event_shot OWNER TO postgres;

--
-- Name: event_substitution; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_substitution (
    event_id uuid NOT NULL,
    outcome character varying(255),
    replacement_id integer,
    replacement_name character varying(255)
);


ALTER TABLE public.event_substitution OWNER TO postgres;

--
-- Name: events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events (
    event_id uuid NOT NULL,
    index integer,
    period integer,
    "timestamp" time without time zone,
    minute integer,
    second integer,
    type_id integer,
    type_name character varying(255),
    possession integer,
    possession_team_id integer,
    play_pattern_id integer,
    team_id integer,
    player_id integer,
    location jsonb,
    under_pressure boolean,
    related_events uuid[],
    duration double precision,
    tactics jsonb
);


ALTER TABLE public.events OWNER TO postgres;

--
-- Name: managers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.managers (
    manager_id integer NOT NULL,
    name character varying(255),
    nickname character varying(255),
    dob date,
    country_id integer
);


ALTER TABLE public.managers OWNER TO postgres;

--
-- Name: matches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.matches (
    match_id integer NOT NULL,
    match_date date,
    kick_off time without time zone,
    home_team_id integer,
    away_team_id integer,
    home_score integer,
    away_score integer,
    match_status character varying(50),
    match_week integer,
    competition_id integer,
    season_id integer,
    stadium_id integer,
    referee_id integer,
    competition_stage_id integer,
    last_updated timestamp without time zone
);


ALTER TABLE public.matches OWNER TO postgres;

--
-- Name: player_positions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.player_positions (
    player_id integer,
    position_id integer,
    start_time character varying,
    end_time character varying,
    from_period integer,
    to_period integer,
    start_reason character varying(255),
    end_reason character varying(255)
);


ALTER TABLE public.player_positions OWNER TO postgres;

--
-- Name: players; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.players (
    player_id integer NOT NULL,
    player_name character varying(255),
    jersey_number integer,
    country_id integer,
    team_id integer
);


ALTER TABLE public.players OWNER TO postgres;

--
-- Name: positions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.positions (
    position_id integer NOT NULL,
    position_name character varying(255)
);


ALTER TABLE public.positions OWNER TO postgres;

--
-- Name: referees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.referees (
    referee_id integer NOT NULL,
    name character varying(255),
    country_id integer
);


ALTER TABLE public.referees OWNER TO postgres;

--
-- Name: seasons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.seasons (
    season_id integer NOT NULL,
    season_name character varying(255)
);


ALTER TABLE public.seasons OWNER TO postgres;

--
-- Name: stadiums; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stadiums (
    stadium_id integer NOT NULL,
    name character varying(255),
    country_id integer
);


ALTER TABLE public.stadiums OWNER TO postgres;

--
-- Name: team_managers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.team_managers (
    team_id integer NOT NULL,
    manager_id integer NOT NULL
);


ALTER TABLE public.team_managers OWNER TO postgres;

--
-- Name: teams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teams (
    team_id integer NOT NULL,
    team_name character varying(255),
    team_gender character varying(50),
    country_id integer
);


ALTER TABLE public.teams OWNER TO postgres;

--
-- Name: types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.types (
    id integer NOT NULL,
    name character varying(255)
);


ALTER TABLE public.types OWNER TO postgres;

--
-- Data for Name: competition_stages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.competition_stages (stage_id, name) FROM stdin;
\.


--
-- Data for Name: competitions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.competitions (competition_id, season_id, country_name, competition_name, competition_gender, competition_youth, competition_international, season_name, match_updated, match_updated_360, match_available_360, match_available) FROM stdin;
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.countries (country_id, country_name) FROM stdin;
\.


--
-- Data for Name: event_50_50; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_50_50 (event_id, outcome_id, outcome_name) FROM stdin;
\.


--
-- Data for Name: event_bad_behaviour; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_bad_behaviour (event_id, card_id, card_name) FROM stdin;
\.


--
-- Data for Name: event_ball_receipt; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_ball_receipt (event_id, outcome_id, outcome_name) FROM stdin;
\.


--
-- Data for Name: event_ball_recovery; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_ball_recovery (event_id, recovery_failure, offensive) FROM stdin;
\.


--
-- Data for Name: event_block; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_block (event_id, deflection, save_block, offensive, counterpress) FROM stdin;
\.


--
-- Data for Name: event_carry; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_carry (event_id, end_location) FROM stdin;
\.


--
-- Data for Name: event_clearance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_clearance (event_id, aerial_won, body_part_id, body_part_name) FROM stdin;
\.


--
-- Data for Name: event_dribble; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_dribble (event_id, outcome_id, outcome_name, overrun, nutmeg, no_touch) FROM stdin;
\.


--
-- Data for Name: event_duel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_duel (event_id, duel_type_id, duel_type_name, outcome_id, outcome_name) FROM stdin;
\.


--
-- Data for Name: event_foul_committed; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_foul_committed (event_id, offensive, foul_type_id, foul_type_name, card_id, card_name) FROM stdin;
\.


--
-- Data for Name: event_foul_won; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_foul_won (event_id, defensive) FROM stdin;
\.


--
-- Data for Name: event_goalkeeper; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_goalkeeper (event_id, body_part_id, body_part_name, technique_id, technique_name, position_id, position_name, outcome_id, outcome_name, type_id, type_name) FROM stdin;
\.


--
-- Data for Name: event_half_end; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_half_end (event_id, early_video_end) FROM stdin;
\.


--
-- Data for Name: event_half_start; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_half_start (event_id, late_video_start) FROM stdin;
\.


--
-- Data for Name: event_injury_stoppage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_injury_stoppage (event_id, in_chain) FROM stdin;
\.


--
-- Data for Name: event_interception; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_interception (event_id, outcome_id, outcome_name) FROM stdin;
\.


--
-- Data for Name: event_pass; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_pass (event_id, recipient_id, recipient_name, length, angle, height_id, height_name, end_location, assisted_shot_id, backheel, deflected, miscommunication, "cross", cut_back, switch, shot_assist, goal_assist, body_part_id, body_part_name, pass_type_id, pass_type_name, outcome_id, outcome_name, technique_id, technique_name) FROM stdin;
\.


--
-- Data for Name: event_player_off; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_player_off (event_id, permanent) FROM stdin;
\.


--
-- Data for Name: event_player_positions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_player_positions (event_id, player_id, position_id, jersey_number) FROM stdin;
\.


--
-- Data for Name: event_shot; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_shot (event_id, key_pass_id, end_location, aerial_won, follows_dribble, first_time, freeze_frame, open_goal, statsbomb_xg, deflected, technique_id, technique_name, body_part_id, body_part_name, shot_type_id, shot_type_name, outcome_id, outcome_name) FROM stdin;
\.


--
-- Data for Name: event_substitution; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_substitution (event_id, outcome, replacement_id, replacement_name) FROM stdin;
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events (event_id, index, period, "timestamp", minute, second, type_id, type_name, possession, possession_team_id, play_pattern_id, team_id, player_id, location, under_pressure, related_events, duration, tactics) FROM stdin;
\.


--
-- Data for Name: managers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.managers (manager_id, name, nickname, dob, country_id) FROM stdin;
\.


--
-- Data for Name: matches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.matches (match_id, match_date, kick_off, home_team_id, away_team_id, home_score, away_score, match_status, match_week, competition_id, season_id, stadium_id, referee_id, competition_stage_id, last_updated) FROM stdin;
\.


--
-- Data for Name: player_positions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.player_positions (player_id, position_id, start_time, end_time, from_period, to_period, start_reason, end_reason) FROM stdin;
\.


--
-- Data for Name: players; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.players (player_id, player_name, jersey_number, country_id, team_id) FROM stdin;
\.


--
-- Data for Name: positions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.positions (position_id, position_name) FROM stdin;
\.


--
-- Data for Name: referees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.referees (referee_id, name, country_id) FROM stdin;
\.


--
-- Data for Name: seasons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.seasons (season_id, season_name) FROM stdin;
\.


--
-- Data for Name: stadiums; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stadiums (stadium_id, name, country_id) FROM stdin;
\.


--
-- Data for Name: team_managers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.team_managers (team_id, manager_id) FROM stdin;
\.


--
-- Data for Name: teams; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teams (team_id, team_name, team_gender, country_id) FROM stdin;
\.


--
-- Data for Name: types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.types (id, name) FROM stdin;
33	50/50
24	Bad Behaviour
42	Ball Receipt
2	Ball Recovery
6	Block
43	Carry
9	Clearance
3	Dispossessed
14	Dribble
39	Dribbled Past
4	Duel
37	Error
22	Foul Committed
21	Foul Won
23	Goal Keeper
34	Half End
18	Half Start
40	Injury Stoppage
10	Interception
38	Miscontrol
8	Offside
20	Own Goal Against
25	Own Goal For
30	Pass
27	Player Off
26	Player On
17	Pressure
41	Referee Ball-Drop
28	Shield
16	Shot
35	Starting XI
19	Substitution
36	Tactical Shift
29	Camera off
5	Camera on
\.


--
-- Name: competition_stages competition_stages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competition_stages
    ADD CONSTRAINT competition_stages_pkey PRIMARY KEY (stage_id);


--
-- Name: competitions competitions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competitions
    ADD CONSTRAINT competitions_pkey PRIMARY KEY (competition_id, season_id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (country_id);


--
-- Name: event_50_50 event_50_50_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_50_50
    ADD CONSTRAINT event_50_50_pkey PRIMARY KEY (event_id);


--
-- Name: event_bad_behaviour event_bad_behaviour_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_bad_behaviour
    ADD CONSTRAINT event_bad_behaviour_pkey PRIMARY KEY (event_id);


--
-- Name: event_ball_receipt event_ball_receipt_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_ball_receipt
    ADD CONSTRAINT event_ball_receipt_pkey PRIMARY KEY (event_id);


--
-- Name: event_ball_recovery event_ball_recovery_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_ball_recovery
    ADD CONSTRAINT event_ball_recovery_pkey PRIMARY KEY (event_id);


--
-- Name: event_block event_block_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_block
    ADD CONSTRAINT event_block_pkey PRIMARY KEY (event_id);


--
-- Name: event_carry event_carry_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_carry
    ADD CONSTRAINT event_carry_pkey PRIMARY KEY (event_id);


--
-- Name: event_clearance event_clearance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_clearance
    ADD CONSTRAINT event_clearance_pkey PRIMARY KEY (event_id);


--
-- Name: event_dribble event_dribble_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_dribble
    ADD CONSTRAINT event_dribble_pkey PRIMARY KEY (event_id);


--
-- Name: event_duel event_duel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_duel
    ADD CONSTRAINT event_duel_pkey PRIMARY KEY (event_id);


--
-- Name: event_foul_committed event_foul_committed_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_foul_committed
    ADD CONSTRAINT event_foul_committed_pkey PRIMARY KEY (event_id);


--
-- Name: event_foul_won event_foul_won_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_foul_won
    ADD CONSTRAINT event_foul_won_pkey PRIMARY KEY (event_id);


--
-- Name: event_goalkeeper event_goalkeeper_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_goalkeeper
    ADD CONSTRAINT event_goalkeeper_pkey PRIMARY KEY (event_id);


--
-- Name: event_half_end event_half_end_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_half_end
    ADD CONSTRAINT event_half_end_pkey PRIMARY KEY (event_id);


--
-- Name: event_half_start event_half_start_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_half_start
    ADD CONSTRAINT event_half_start_pkey PRIMARY KEY (event_id);


--
-- Name: event_injury_stoppage event_injury_stoppage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_injury_stoppage
    ADD CONSTRAINT event_injury_stoppage_pkey PRIMARY KEY (event_id);


--
-- Name: event_interception event_interception_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_interception
    ADD CONSTRAINT event_interception_pkey PRIMARY KEY (event_id);


--
-- Name: event_pass event_pass_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_pass
    ADD CONSTRAINT event_pass_pkey PRIMARY KEY (event_id);


--
-- Name: event_player_off event_player_off_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_player_off
    ADD CONSTRAINT event_player_off_pkey PRIMARY KEY (event_id);


--
-- Name: event_player_positions event_player_positions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_player_positions
    ADD CONSTRAINT event_player_positions_pkey PRIMARY KEY (event_id, player_id);


--
-- Name: event_shot event_shot_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_shot
    ADD CONSTRAINT event_shot_pkey PRIMARY KEY (event_id);


--
-- Name: event_substitution event_substitution_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_substitution
    ADD CONSTRAINT event_substitution_pkey PRIMARY KEY (event_id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (event_id);


--
-- Name: managers managers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.managers
    ADD CONSTRAINT managers_pkey PRIMARY KEY (manager_id);


--
-- Name: matches matches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_pkey PRIMARY KEY (match_id);


--
-- Name: players players_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_pkey PRIMARY KEY (player_id);


--
-- Name: positions positions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_pkey PRIMARY KEY (position_id);


--
-- Name: referees referees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referees
    ADD CONSTRAINT referees_pkey PRIMARY KEY (referee_id);


--
-- Name: seasons seasons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_pkey PRIMARY KEY (season_id);


--
-- Name: stadiums stadiums_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stadiums
    ADD CONSTRAINT stadiums_pkey PRIMARY KEY (stadium_id);


--
-- Name: team_managers team_managers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_managers
    ADD CONSTRAINT team_managers_pkey PRIMARY KEY (team_id, manager_id);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (team_id);


--
-- Name: types types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types
    ADD CONSTRAINT types_pkey PRIMARY KEY (id);


--
-- Name: event_50_50 event_50_50_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_50_50
    ADD CONSTRAINT event_50_50_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(event_id);


--
-- Name: event_bad_behaviour event_bad_behaviour_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_bad_behaviour
    ADD CONSTRAINT event_bad_behaviour_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(event_id);


--
-- Name: event_ball_receipt event_ball_receipt_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_ball_receipt
    ADD CONSTRAINT event_ball_receipt_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(event_id);


--
-- Name: event_ball_recovery event_ball_recovery_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_ball_recovery
    ADD CONSTRAINT event_ball_recovery_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(event_id);


--
-- Name: event_block event_block_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_block
    ADD CONSTRAINT event_block_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(event_id);


--
-- Name: event_carry event_carry_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_carry
    ADD CONSTRAINT event_carry_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(event_id);


--
-- Name: event_clearance event_clearance_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_clearance
    ADD CONSTRAINT event_clearance_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(event_id);


--
-- Name: event_dribble event_dribble_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_dribble
    ADD CONSTRAINT event_dribble_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(event_id);


--
-- Name: event_duel event_duel_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_duel
    ADD CONSTRAINT event_duel_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(event_id);


--
-- Name: event_foul_committed event_foul_committed_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_foul_committed
    ADD CONSTRAINT event_foul_committed_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(event_id);


--
-- Name: event_foul_won event_foul_won_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_foul_won
    ADD CONSTRAINT event_foul_won_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(event_id);


--
-- Name: event_goalkeeper event_goalkeeper_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_goalkeeper
    ADD CONSTRAINT event_goalkeeper_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(event_id);


--
-- Name: event_goalkeeper event_goalkeeper_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_goalkeeper
    ADD CONSTRAINT event_goalkeeper_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.types(id);


--
-- Name: event_half_end event_half_end_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_half_end
    ADD CONSTRAINT event_half_end_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(event_id);


--
-- Name: event_half_start event_half_start_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_half_start
    ADD CONSTRAINT event_half_start_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(event_id);


--
-- Name: event_injury_stoppage event_injury_stoppage_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_injury_stoppage
    ADD CONSTRAINT event_injury_stoppage_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(event_id);


--
-- Name: event_interception event_interception_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_interception
    ADD CONSTRAINT event_interception_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(event_id);


--
-- Name: event_pass event_pass_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_pass
    ADD CONSTRAINT event_pass_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(event_id);


--
-- Name: event_player_off event_player_off_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_player_off
    ADD CONSTRAINT event_player_off_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(event_id);


--
-- Name: event_player_positions event_player_positions_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_player_positions
    ADD CONSTRAINT event_player_positions_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(event_id);


--
-- Name: event_player_positions event_player_positions_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_player_positions
    ADD CONSTRAINT event_player_positions_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.players(player_id);


--
-- Name: event_player_positions event_player_positions_position_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_player_positions
    ADD CONSTRAINT event_player_positions_position_id_fkey FOREIGN KEY (position_id) REFERENCES public.positions(position_id);


--
-- Name: event_shot event_shot_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_shot
    ADD CONSTRAINT event_shot_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(event_id);


--
-- Name: event_substitution event_substitution_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_substitution
    ADD CONSTRAINT event_substitution_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(event_id);


--
-- Name: events events_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.players(player_id) ON DELETE SET NULL;


--
-- Name: events events_possession_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_possession_team_id_fkey FOREIGN KEY (possession_team_id) REFERENCES public.teams(team_id) ON DELETE SET NULL;


--
-- Name: events events_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(team_id) ON DELETE SET NULL;


--
-- Name: events events_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.types(id);


--
-- Name: managers managers_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.managers
    ADD CONSTRAINT managers_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(country_id) ON DELETE SET NULL;


--
-- Name: matches matches_away_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_away_team_id_fkey FOREIGN KEY (away_team_id) REFERENCES public.teams(team_id) ON DELETE SET NULL;


--
-- Name: matches matches_competition_id_season_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_competition_id_season_id_fkey FOREIGN KEY (competition_id, season_id) REFERENCES public.competitions(competition_id, season_id) ON DELETE CASCADE;


--
-- Name: matches matches_competition_stage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_competition_stage_id_fkey FOREIGN KEY (competition_stage_id) REFERENCES public.competition_stages(stage_id) ON DELETE SET NULL;


--
-- Name: matches matches_home_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_home_team_id_fkey FOREIGN KEY (home_team_id) REFERENCES public.teams(team_id) ON DELETE SET NULL;


--
-- Name: matches matches_referee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_referee_id_fkey FOREIGN KEY (referee_id) REFERENCES public.referees(referee_id) ON DELETE SET NULL;


--
-- Name: matches matches_stadium_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_stadium_id_fkey FOREIGN KEY (stadium_id) REFERENCES public.stadiums(stadium_id) ON DELETE SET NULL;


--
-- Name: player_positions player_positions_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.player_positions
    ADD CONSTRAINT player_positions_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.players(player_id);


--
-- Name: player_positions player_positions_position_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.player_positions
    ADD CONSTRAINT player_positions_position_id_fkey FOREIGN KEY (position_id) REFERENCES public.positions(position_id);


--
-- Name: players players_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(country_id) ON DELETE SET NULL;


--
-- Name: players players_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(team_id) ON DELETE SET NULL;


--
-- Name: referees referees_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referees
    ADD CONSTRAINT referees_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(country_id) ON DELETE SET NULL;


--
-- Name: stadiums stadiums_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stadiums
    ADD CONSTRAINT stadiums_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(country_id) ON DELETE SET NULL;


--
-- Name: team_managers team_managers_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_managers
    ADD CONSTRAINT team_managers_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.managers(manager_id);


--
-- Name: team_managers team_managers_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_managers
    ADD CONSTRAINT team_managers_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(team_id);


--
-- Name: teams teams_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(country_id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

