--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.5
-- Dumped by pg_dump version 9.6.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: diaper_changes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE diaper_changes (
    id integer NOT NULL,
    type character varying(255),
    user_id integer NOT NULL,
    occurred_at timestamp without time zone NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: diaper_changes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE diaper_changes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: diaper_changes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE diaper_changes_id_seq OWNED BY diaper_changes.id;


--
-- Name: locality_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE locality_settings (
    id integer NOT NULL,
    user_id character varying(255) NOT NULL,
    timezone_identifier character varying(255) DEFAULT 'Etc/UTC'::character varying,
    zip_code character varying(255),
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: locality_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE locality_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locality_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE locality_settings_id_seq OWNED BY locality_settings.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp without time zone
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    amazon_id character varying(255) NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    timezone_identifier character varying(255) DEFAULT 'Etc/UTC'::character varying,
    device_id character varying(255),
    consent_token text,
    zip_code character varying(255)
);


--
-- Name: TABLE users; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE users IS 'User in our system';


--
-- Name: COLUMN users.amazon_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN users.amazon_id IS 'unique Amazon-assigned Alexa user identifier';


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: diaper_changes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY diaper_changes ALTER COLUMN id SET DEFAULT nextval('diaper_changes_id_seq'::regclass);


--
-- Name: locality_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY locality_settings ALTER COLUMN id SET DEFAULT nextval('locality_settings_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: diaper_changes diaper_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY diaper_changes
    ADD CONSTRAINT diaper_changes_pkey PRIMARY KEY (id);


--
-- Name: locality_settings locality_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY locality_settings
    ADD CONSTRAINT locality_settings_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: diaper_changes_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX diaper_changes_user_id_index ON diaper_changes USING btree (user_id);


--
-- Name: users_amazon_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_amazon_id_index ON users USING btree (amazon_id);


--
-- Name: diaper_changes diaper_changes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY diaper_changes
    ADD CONSTRAINT diaper_changes_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

INSERT INTO "schema_migrations" (version) VALUES (20170908024821), (20170908032116), (20171111045049), (20171111054748), (20171111055052), (20171125033309), (20171212075425), (20171224043823), (20171226203431);

