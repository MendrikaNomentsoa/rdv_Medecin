--
-- PostgreSQL database dump
--

\restrict JEEeUcAJQfK3V4w7Fj1wHf1HqSsDWpYb6iKlEdVrFihveDFL6kgQf3CM4St6Und

-- Dumped from database version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)

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

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: medecin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medecin (
    idmed character varying(36) DEFAULT (public.uuid_generate_v4())::text NOT NULL,
    nommed character varying(100) NOT NULL,
    specialite character varying(100) NOT NULL,
    taux_horaire integer NOT NULL,
    lieu character varying(150) NOT NULL,
    email character varying(150) NOT NULL,
    mot_de_passe character varying(255) NOT NULL,
    CONSTRAINT medecin_taux_horaire_check CHECK ((taux_horaire > 0))
);


ALTER TABLE public.medecin OWNER TO postgres;

--
-- Name: patient; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patient (
    idpat character varying(36) DEFAULT (public.uuid_generate_v4())::text NOT NULL,
    nom_pat character varying(100) NOT NULL,
    datenais date NOT NULL,
    email character varying(150) NOT NULL,
    mot_de_passe character varying(255) NOT NULL
);


ALTER TABLE public.patient OWNER TO postgres;

--
-- Name: rdv; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rdv (
    idrdv character varying(36) DEFAULT (public.uuid_generate_v4())::text NOT NULL,
    idmed character varying(36) NOT NULL,
    idpat character varying(36) NOT NULL,
    date_rdv timestamp without time zone NOT NULL,
    statut character varying(20) DEFAULT 'CONFIRME'::character varying NOT NULL,
    CONSTRAINT rdv_statut_check CHECK (((statut)::text = ANY ((ARRAY['CONFIRME'::character varying, 'ANNULE'::character varying])::text[])))
);


ALTER TABLE public.rdv OWNER TO postgres;

--
-- Name: medecin medecin_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medecin
    ADD CONSTRAINT medecin_email_key UNIQUE (email);


--
-- Name: medecin medecin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medecin
    ADD CONSTRAINT medecin_pkey PRIMARY KEY (idmed);


--
-- Name: patient patient_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient
    ADD CONSTRAINT patient_email_key UNIQUE (email);


--
-- Name: patient patient_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient
    ADD CONSTRAINT patient_pkey PRIMARY KEY (idpat);


--
-- Name: rdv rdv_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rdv
    ADD CONSTRAINT rdv_pkey PRIMARY KEY (idrdv);


--
-- Name: rdv uq_rdv_creneau; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rdv
    ADD CONSTRAINT uq_rdv_creneau UNIQUE (idmed, date_rdv);


--
-- Name: idx_medecin_nom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_medecin_nom ON public.medecin USING btree (nommed varchar_pattern_ops);


--
-- Name: idx_medecin_specialite; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_medecin_specialite ON public.medecin USING btree (specialite);


--
-- Name: idx_rdv_medecin_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rdv_medecin_date ON public.rdv USING btree (idmed, date_rdv);


--
-- Name: idx_rdv_patient; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rdv_patient ON public.rdv USING btree (idpat);


--
-- Name: idx_rdv_statut; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rdv_statut ON public.rdv USING btree (statut);


--
-- Name: rdv fk_rdv_medecin; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rdv
    ADD CONSTRAINT fk_rdv_medecin FOREIGN KEY (idmed) REFERENCES public.medecin(idmed) ON DELETE CASCADE;


--
-- Name: rdv fk_rdv_patient; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rdv
    ADD CONSTRAINT fk_rdv_patient FOREIGN KEY (idpat) REFERENCES public.patient(idpat) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict JEEeUcAJQfK3V4w7Fj1wHf1HqSsDWpYb6iKlEdVrFihveDFL6kgQf3CM4St6Und

