/*Détection des réseaux*/
/*Creation du squelette de la structure des données (table, séquence, trigger,...) */
/*init_bd_res_detec_10_squelette.sql */
/*PostGIS*/

/* GeoCompiegnois - http://geo.compiegnois.fr/ */
/* Auteur : Florent Vanhoutte */



-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        DROP                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- vue

--DROP VIEW IF EXISTS schema.vue;


-- fkey

-- ALTER TABLE IF EXISTS schema.table DROP CONSTRAINT IF EXISTS contrainte;


-- classe

DROP TABLE IF EXISTS m_reseau_detection.geo_opedetec;
DROP TABLE IF EXISTS m_reseau_detection.geo_ptdetec;


-- domaine de valeur

DROP TABLE IF EXISTS m_reseau_detection.lt_qualite_geoloc;


-- sequence

DROP SEQUENCE IF EXISTS m_reseau_detection.geo_ptdetec_id_seq;
DROP SEQUENCE IF EXISTS m_reseau_detection.geo_opedetec_id_seq;


-- schema

DROP SCHEMA IF EXISTS m_reseau_detection;


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                       SCHEMA                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- Schema: m_reseau_detection

-- DROP SCHEMA m_reseau_detection;

CREATE SCHEMA m_reseau_detection;

COMMENT ON SCHEMA m_reseau_detection
  IS 'Détection des réseaux';


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                DOMAINES DE VALEURS                                                           ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- Table: m_reseau_detection.lt_qualite_geoloc

-- DROP TABLE m_reseau_detection.lt_qualite_geoloc;

CREATE TABLE m_reseau_detection.lt_qualite_geoloc
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT m_reseau_detection_qualite_geoloc_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_reseau_detection.lt_qualite_geoloc
  IS 'Classe de précision au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';
COMMENT ON COLUMN m_reseau_detection.lt_qualite_geoloc.code IS 'Code de la liste énumérée relative à la classe de précision au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';
COMMENT ON COLUMN m_reseau_detection.lt_qualite_geoloc.valeur IS 'Valeur de la liste énumérée relative à la classe de précision au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';
COMMENT ON COLUMN m_reseau_detection.lt_qualite_geoloc.definition IS 'Définition de la liste énumérée relative à la classe de précision au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';

INSERT INTO m_reseau_detection.lt_qualite_geoloc(
            code, valeur, definition)
    VALUES
('01','Classe A','Classe de précision inférieure 40 cm'),
('02','Classe B','Classe de précision supérieure à 40 cm et inférieure à 1,50 m'),
('03','Classe C','Classe de précision supérieure à 1,50 m');




-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                     SEQUENCE                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- Sequence: m_reseau_detection.geo_opedetec_id_seq

-- DROP SEQUENCE m_reseau_detection.geo_opedetec_id_seq;

CREATE SEQUENCE m_reseau_detection.geo_opedetec_id_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

-- Sequence: m_reseau_detection.geo_ptdetec_id_seq

-- DROP SEQUENCE m_reseau_detection.geo_ptdetec_id_seq;

CREATE SEQUENCE m_reseau_detection.geo_ptdetec_id_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
  
  

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                  CLASSE OBJET                                                                ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- #################################################################### CLASSE OPERATION DE DETECTION ###############################################



-- Table: m_reseau_detection.geo_opedetec

-- DROP TABLE m_reseau_detection.geo_opedetec;

CREATE TABLE m_reseau_detection.geo_opedetec
(
  idopedetec character varying(254) NOT NULL,
  refope character varying(254) NOT NULL, -- fkey vers classe opedetec
  mouvrage character varying(80) NOT NULL,
  presta character varying(80) NOT NULL,
-- voir pour préciser la nature de la presta (multiréseau, monoréseau, si oui lequel)
-- voir pour préciser le contexte (IC ou OL)  
  dateope date NOT NULL,
  geom geometry(MultiPolygon,2154),
  CONSTRAINT geo_opedetec_pkey PRIMARY KEY (idopedetec) 
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_reseau_detection.geo_opedetec
  IS 'Opération de détection de réseaux';
COMMENT ON COLUMN m_reseau_detection.geo_opedetec.idopedetec IS 'Identifiant unique de l''opération de détection dans la base de données';
COMMENT ON COLUMN m_reseau_detection.geo_opedetec.refope IS 'Référence de l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_opedetec.presta IS 'Prestataire';
COMMENT ON COLUMN m_reseau_detection.geo_opedetec.mouvrage IS 'Maitre d''ouvrage';
COMMENT ON COLUMN m_reseau_detection.geo_opedetec.dateope IS 'Date de l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_opedetec.geom IS 'Géométrie de l''objet';

ALTER TABLE m_reseau_detection.geo_opedetec ALTER COLUMN idopedetec SET DEFAULT nextval('m_reseau_detection.geo_opedetec_id_seq'::regclass);


--  mouvrage character varying(100),

-- #################################################################### CLASSE POINT DE DETECTION/GEOREF ###############################################

-- Table: m_reseau_detection.geo_ptdetec

-- DROP TABLE m_reseau_detection.geo_ptdetec;

CREATE TABLE m_reseau_detection.geo_ptdetec
(
  idptdetec character varying(254) NOT NULL,
  refope character varying(254) NOT NULL, -- fkey vers classe opedetec
  idptope integer NOT NULL,
  num character varying(30) NOT NULL,  -- voir si conserver
  insee character varying(5) NOT NULL,
  typedetec character varying(2) NOT NULL, -- fkey vers domaine de valeur
  methode character varying(80) NOT NULL,  
  typeres character varying(5) NOT NULL,         -- fkey vers domaine de valeur  
  x numeric(10,3) NOT NULL,
  y numeric(11,3) NOT NULL,
  z_gn numeric (7,3) NOT NULL,
  z numeric (7,3),
  p_gn numeric (5,3),
--  presta character varying(80) NOT NULL, -- voir nécessité si dispo dans couche opedetec
  prec_xy numeric (7,3) NOT NULL,
  prec_z_gn numeric (7,3) NOT NULL,
  horodatage timestamp NOT NULL,
  geom geometry(PointZ,2154),
  CONSTRAINT geo_ptdetec_pkey PRIMARY KEY (idptdetec) 
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_reseau_detection.geo_ptdetec
  IS 'Point de détection/géoréférencement d''un réseau';
COMMENT ON COLUMN m_reseau_detection.geo_ptdetec.idptdetec IS 'Identifiant unique du point de détection dans la base de données';
COMMENT ON COLUMN m_reseau_detection.geo_ptdetec.refope IS 'Référence de l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_ptdetec.idptope IS 'Identifiant du point de détection dans l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_ptdetec.num IS 'Numéro du point';
COMMENT ON COLUMN m_reseau_detection.geo_ptdetec.typedetec IS 'Type de ';
COMMENT ON COLUMN m_reseau_detection.geo_ptdetec.methode IS 'Méthode employée pour la détection';
COMMENT ON COLUMN m_reseau_detection.geo_ptdetec.typeres IS 'Type de réseau détecté';
COMMENT ON COLUMN m_reseau_detection.geo_ptdetec.x IS 'Coordonnée X Lambert 93 (en mètres)';
COMMENT ON COLUMN m_reseau_detection.geo_ptdetec.y IS 'Coordonnée X Lambert 93 (en mètres)';
COMMENT ON COLUMN m_reseau_detection.geo_ptdetec.z_gn IS 'Altimétrie Z de la génératrice (supérieure si enterrée, inférieure si aérienne) du réseau en mètre NGF)';
COMMENT ON COLUMN m_reseau_detection.geo_ptdetec.z IS 'Altimétrie Z du terrain affleurant en mètre NGF)';
COMMENT ON COLUMN m_reseau_detection.geo_ptdetec.p_gn IS 'Profondeur de la génératrice du réseau en mètre';
COMMENT ON COLUMN m_reseau_detection.geo_ptdetec.geom IS 'Géométrie 3D de l''objet';

ALTER TABLE m_reseau_detection.geo_ptdetec ALTER COLUMN idptdetec SET DEFAULT nextval('m_reseau_detection.geo_ptdetec_id_seq'::regclass);


/*
COMMENT ON COLUMN m_reseau_detection.geo_ptdetec.gexploit IS 'Gestionnaire exploitant du réseau';
COMMENT ON COLUMN m_reseau_detection.geo_ptdetec.mouvrage IS 'Maître d''ouvrage du réseau';
*/
  
  
  
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                           FKEY (clé étrangère)                                                               ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################
  
