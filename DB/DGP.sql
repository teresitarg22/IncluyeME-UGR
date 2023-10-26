--
-- PostgreSQL database dump
--

-- Dumped from database version 16.0
-- Dumped by pg_dump version 16.0

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
-- Name: aula; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aula (
    nombre character varying(50) NOT NULL
);


ALTER TABLE public.aula OWNER TO postgres;

--
-- Name: discapacidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discapacidad (
    nombre character varying(50) NOT NULL,
    nivel character varying(50) NOT NULL
);


ALTER TABLE public.discapacidad OWNER TO postgres;

--
-- Name: discapacidad_de; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discapacidad_de (
    dni character varying(50) NOT NULL,
    nombre character varying(50) NOT NULL,
    nivel character varying(50) NOT NULL,
    informacionadicionaldiscapacidad text,
    necesidadesespecificas character varying(50)
);


ALTER TABLE public.discapacidad_de OWNER TO postgres;

--
-- Name: estudiante; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estudiante (
    dni character varying(50) NOT NULL,
    genero character varying(50),
    nombre character varying(50),
    apellidos character varying(50),
    fechanacimiento date,
    "contraseña" character varying(50),
    tarjetasanitaria character varying(50),
    direcciondomiciliar character varying(50),
    numerotelefono character varying(50),
    correoelectronico character varying(50),
    foto character varying(50),
    archivomedico character varying(50),
    alergiasintolerancias text,
    informacionadicionalmedico text,
    tipodeletra character varying(50),
    minmay character varying(50),
    formatodeapp text,
    pantallatactil boolean,
    dni_tutor character varying(50) NOT NULL
);


ALTER TABLE public.estudiante OWNER TO postgres;

--
-- Name: imparte_en; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.imparte_en (
    dni character varying(50) NOT NULL,
    nombre character varying(50) NOT NULL
);


ALTER TABLE public.imparte_en OWNER TO postgres;

--
-- Name: supervisor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supervisor (
    dni character varying(50) NOT NULL,
    genero character varying(50),
    nombre character varying(50),
    apellidos character varying(50),
    fechanacimiento date,
    "contraseña" character varying(50),
    tarjetasanitaria character varying(50),
    direcciondomiciliar text,
    nacionalidad character varying(50),
    numerotelefono character varying(50),
    numerotelefonoemergencia character varying(50),
    correoelectronico character varying(50),
    foto character varying(50),
    nivelestudios character varying(50),
    tituloacademico text NOT NULL,
    experiencialaboralprevia text,
    certificacionesadicionales text,
    curriculumvitae character varying(50),
    informacionacademicaadicional text,
    puesto character varying(50),
    fechacontratacion date,
    departamento character varying(50),
    admin boolean
);


ALTER TABLE public.supervisor OWNER TO postgres;

--
-- Name: tutor_legal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tutor_legal (
    dni character varying(50) NOT NULL,
    genero character varying(50),
    nombre character varying(50),
    apellidos character varying(50),
    direcciondomiciliar text,
    numerotelefono character varying(50),
    correoelectronico character varying(50),
    contactoemergencia character varying(50),
    relacion character varying(50)
);


ALTER TABLE public.tutor_legal OWNER TO postgres;

--
-- Data for Name: aula; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.aula (nombre) FROM stdin;
\.


--
-- Data for Name: discapacidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discapacidad (nombre, nivel) FROM stdin;
\.


--
-- Data for Name: discapacidad_de; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discapacidad_de (dni, nombre, nivel, informacionadicionaldiscapacidad, necesidadesespecificas) FROM stdin;
\.


--
-- Data for Name: estudiante; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.estudiante (dni, genero, nombre, apellidos, fechanacimiento, "contraseña", tarjetasanitaria, direcciondomiciliar, numerotelefono, correoelectronico, foto, archivomedico, alergiasintolerancias, informacionadicionalmedico, tipodeletra, minmay, formatodeapp, pantallatactil, dni_tutor) FROM stdin;
\.


--
-- Data for Name: imparte_en; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.imparte_en (dni, nombre) FROM stdin;
\.


--
-- Data for Name: supervisor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.supervisor (dni, genero, nombre, apellidos, fechanacimiento, "contraseña", tarjetasanitaria, direcciondomiciliar, nacionalidad, numerotelefono, numerotelefonoemergencia, correoelectronico, foto, nivelestudios, tituloacademico, experiencialaboralprevia, certificacionesadicionales, curriculumvitae, informacionacademicaadicional, puesto, fechacontratacion, departamento, admin) FROM stdin;
\.


--
-- Data for Name: tutor_legal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tutor_legal (dni, genero, nombre, apellidos, direcciondomiciliar, numerotelefono, correoelectronico, contactoemergencia, relacion) FROM stdin;
\.


--
-- Name: aula aula_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aula
    ADD CONSTRAINT aula_pkey PRIMARY KEY (nombre);


--
-- Name: discapacidad_de discapacidad_de_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discapacidad_de
    ADD CONSTRAINT discapacidad_de_pkey PRIMARY KEY (dni, nombre, nivel);


--
-- Name: discapacidad discapacidad_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discapacidad
    ADD CONSTRAINT discapacidad_pkey PRIMARY KEY (nombre, nivel);


--
-- Name: estudiante estudiante_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estudiante
    ADD CONSTRAINT estudiante_pkey PRIMARY KEY (dni);


--
-- Name: imparte_en imparte_en_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imparte_en
    ADD CONSTRAINT imparte_en_pkey PRIMARY KEY (dni, nombre);


--
-- Name: supervisor supervisor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supervisor
    ADD CONSTRAINT supervisor_pkey PRIMARY KEY (dni);


--
-- Name: tutor_legal tutor_legal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutor_legal
    ADD CONSTRAINT tutor_legal_pkey PRIMARY KEY (dni);


--
-- Name: discapacidad_de discapacidad_de_dni_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discapacidad_de
    ADD CONSTRAINT discapacidad_de_dni_fkey FOREIGN KEY (dni) REFERENCES public.estudiante(dni);


--
-- Name: discapacidad_de discapacidad_de_nombre_nivel_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discapacidad_de
    ADD CONSTRAINT discapacidad_de_nombre_nivel_fkey FOREIGN KEY (nombre, nivel) REFERENCES public.discapacidad(nombre, nivel);


--
-- Name: estudiante estudiante_dni_tutor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estudiante
    ADD CONSTRAINT estudiante_dni_tutor_fkey FOREIGN KEY (dni_tutor) REFERENCES public.tutor_legal(dni);


--
-- Name: imparte_en imparte_en_dni_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imparte_en
    ADD CONSTRAINT imparte_en_dni_fkey FOREIGN KEY (dni) REFERENCES public.supervisor(dni);


--
-- Name: imparte_en imparte_en_nombre_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imparte_en
    ADD CONSTRAINT imparte_en_nombre_fkey FOREIGN KEY (nombre) REFERENCES public.aula(nombre);


--
-- PostgreSQL database dump complete
--

