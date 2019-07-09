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

DROP TABLE IF EXISTS m_reseau_detection.geo_detec_operation;
DROP TABLE IF EXISTS m_reseau_detection.geo_detec_point;
DROP TABLE IF EXISTS m_reseau_detection.geo_detec_noeud;
DROP TABLE IF EXISTS m_reseau_detection.geo_detec_troncon;

-- domaine de valeur

DROP TABLE IF EXISTS m_reseau_detection.lt_qualite_geoloc;


-- sequence

DROP SEQUENCE IF EXISTS m_reseau_detection.geo_detec_operation_id_seq;
DROP SEQUENCE IF EXISTS m_reseau_detection.geo_detec_point_id_seq;
DROP SEQUENCE IF EXISTS m_reseau_detection.geo_detec_reseau_id_seq;

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


-- Sequence: m_reseau_detection.geo_detec_operation_id_seq

-- DROP SEQUENCE m_reseau_detection.geo_detec_operation_id_seq;

CREATE SEQUENCE m_reseau_detection.geo_detec_operation_id_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

-- Sequence: m_reseau_detection.geo_detec_point_id_seq

-- DROP SEQUENCE m_reseau_detection.geo_detec_point_id_seq;

CREATE SEQUENCE m_reseau_detection.geo_detec_point_id_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
  
-- Sequence: m_reseau_detection.geo_detec_reseau_id_seq

-- DROP SEQUENCE m_reseau_detection.geo_detec_reseau_id_seq;

CREATE SEQUENCE m_reseau_detection.geo_detec_reseau_id_seq
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



-- Table: m_reseau_detection.geo_detec_operation

-- DROP TABLE m_reseau_detection.geo_detec_operation;

CREATE TABLE m_reseau_detection.geo_detec_operation
(
  idopedetec character varying(254) NOT NULL,
  refope character varying(254) NOT NULL, -- fkey vers classe opedetec
  mouvrage character varying(80) NOT NULL,
  presta character varying(80) NOT NULL,
-- voir pour préciser la nature de la presta (multiréseau, monoréseau, si oui lequel)
-- voir pour préciser le contexte (IC ou OL)  
  dateope date NOT NULL,
  date_sai timestamp without time zone NOT NULL DEFAULT now(),  
  date_maj timestamp without time zone,
  geom geometry(MultiPolygon,2154),
  CONSTRAINT geo_detec_operation_pkey PRIMARY KEY (idopedetec) 
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_reseau_detection.geo_detec_operation
  IS 'Opération de détection de réseaux';
COMMENT ON COLUMN m_reseau_detection.geo_detec_operation.idopedetec IS 'Identifiant unique de l''opération de détection dans la base de données';
COMMENT ON COLUMN m_reseau_detection.geo_detec_operation.refope IS 'Référence de l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_detec_operation.presta IS 'Prestataire de l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_detec_operation.mouvrage IS 'Maitre d''ouvrage de l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_detec_operation.dateope IS 'Date de l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_detec_operation.date_sai IS 'Horodatage de l''intégration en base de l''objet';
COMMENT ON COLUMN m_reseau_detection.geo_detec_operation.date_maj IS 'Horodatage de la mise à jour en base de l''objet';
COMMENT ON COLUMN m_reseau_detection.geo_detec_operation.geom IS 'Géométrie de l''objet';


ALTER TABLE m_reseau_detection.geo_detec_operation ALTER COLUMN idopedetec SET DEFAULT nextval('m_reseau_detection.geo_detec_operation_id_seq'::regclass);


-- #################################################################### CLASSE POINT DE DETECTION/GEOREF ###############################################

-- Table: m_reseau_detection.geo_detec_point

-- DROP TABLE m_reseau_detection.geo_detec_point;

CREATE TABLE m_reseau_detection.geo_detec_point
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
  prec_xy numeric (7,3) NOT NULL,
  prec_z_gn numeric (7,3) NOT NULL,
  horodatage timestamp without time zone NOT NULL,
  date_sai timestamp without time zone NOT NULL DEFAULT now(),  
  date_maj timestamp without time zone,
  geom geometry(PointZ,2154),
  CONSTRAINT geo_detec_point_pkey PRIMARY KEY (idptdetec) 
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_reseau_detection.geo_detec_point
  IS 'Point de détection/géoréférencement d''un réseau';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.idptdetec IS 'Identifiant unique du point de détection dans la base de données';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.refope IS 'Référence de l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.idptope IS 'Identifiant du point de détection dans l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.num IS 'Numéro du point';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.insee IS 'Code INSEE de la commmune';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.typedetec IS 'Type de ';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.methode IS 'Méthode employée pour la détection';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.typeres IS 'Type de réseau détecté';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.x IS 'Coordonnée X Lambert 93 (en mètres)';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.y IS 'Coordonnée X Lambert 93 (en mètres)';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.z_gn IS 'Altimétrie Z de la génératrice (supérieure si enterrée, inférieure si aérienne) du réseau en mètre NGF)';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.z IS 'Altimétrie Z du terrain affleurant en mètre NGF)';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.p_gn IS 'Profondeur de la génératrice du réseau en mètre';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.prec_xy IS '**********';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.prec_z_gn IS '**********';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.horodatage IS 'Horodatage détection/géoréfécement du point';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.date_sai IS 'Horodatage de l''intégration en base de l''objet';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.date_maj IS 'Horodatage de la mise à jour en base de l''objet';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.geom IS 'Géométrie 3D de l''objet';

ALTER TABLE m_reseau_detection.geo_detec_point ALTER COLUMN idptdetec SET DEFAULT nextval('m_reseau_detection.geo_detec_point_id_seq'::regclass);


-- #################################################################### CLASSE NOEUD (OUVRAGE/APPAREILLAGE) ###############################################

-- Table: m_reseau_detection.geo_detec_noeud

-- DROP TABLE m_reseau_detection.geo_detec_noeud;

CREATE TABLE m_reseau_detection.geo_detec_noeud
(
  idnddetec character varying(254) NOT NULL,
  refope character varying(254) NOT NULL, -- fkey vers classe opedetec
  idndope integer NOT NULL,
  insee character varying(5) NOT NULL,
  typeres character varying(5) NOT NULL,         -- fkey vers domaine de valeur  
  typenoeud character varying(5) NOT NULL,         -- fkey vers domaine de valeur
-- angle
-- symbole  
  date_sai timestamp without time zone NOT NULL DEFAULT now(),  
  date_maj timestamp without time zone, 
  geom geometry(PointZ,2154),
  CONSTRAINT geo_detec_noeud_pkey PRIMARY KEY (idnddetec) 
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_reseau_detection.geo_detec_noeud
  IS 'Noeud de réseau (ouvrage/appareillage) détecté';
COMMENT ON COLUMN m_reseau_detection.geo_detec_noeud.idptdetec IS 'Identifiant unique du noeud de réseau détecté dans la base de données';
COMMENT ON COLUMN m_reseau_detection.geo_detec_noeud.refope IS 'Référence de l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_detec_noeud.idndope IS 'Identifiant du noeud de réseau détecté dans l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_detec_noeud.insee IS 'Code INSEE de la commmune';
COMMENT ON COLUMN m_reseau_detection.geo_detec_noeud.typeres IS 'Type de réseau détecté';
COMMENT ON COLUMN m_reseau_detection.geo_detec_noeud.typenoeud IS 'Type d''ouvrage ou d''appareillage';
COMMENT ON COLUMN m_reseau_detection.geo_detec_noeud.date_sai IS 'Horodatage de l''intégration en base de l''objet';
COMMENT ON COLUMN m_reseau_detection.geo_detec_noeud.date_maj IS 'Horodatage de la mise à jour en base de l''objet';
COMMENT ON COLUMN m_reseau_detection.geo_detec_noeud.geom IS 'Géométrie 3D de l''objet';

ALTER TABLE m_reseau_detection.geo_detec_noeud ALTER COLUMN idnddetec SET DEFAULT nextval('m_reseau_detection.geo_detec_reseau_id_seq'::regclass);


-- #################################################################### CLASSE TRONCON ###############################################

-- Table: m_reseau_detection.geo_detec_troncon

-- DROP TABLE m_reseau_detection.geo_detec_troncon;

CREATE TABLE m_reseau_detection.geo_detec_troncon
(
  idtrdetec character varying(254) NOT NULL,
  refope character varying(254) NOT NULL, -- fkey vers classe opedetec
  idndope integer NOT NULL,
  insee character varying(5) NOT NULL,
  typeres character varying(5) NOT NULL,         -- fkey vers domaine de valeur  
-- diam
-- materiau
  date_sai timestamp without time zone NOT NULL DEFAULT now(),  
  date_maj timestamp without time zone, 
  geom geometry(LineStringZ,2154),
  CONSTRAINT geo_detec_troncon_pkey PRIMARY KEY (idtrdetec) 
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_reseau_detection.geo_detec_troncon
  IS 'Noeud de réseau (ouvrage/appareillage) détecté';
COMMENT ON COLUMN m_reseau_detection.geo_detec_troncon.idtrdetec IS 'Identifiant unique du tronçon de réseau détecté dans la base de données';
COMMENT ON COLUMN m_reseau_detection.geo_detec_troncon.refope IS 'Référence de l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_detec_troncon.idndope IS 'Identifiant du tronçon de réseau détecté dans l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_detec_troncon.insee IS 'Code INSEE de la commmune';
COMMENT ON COLUMN m_reseau_detection.geo_detec_troncon.typeres IS 'Type de réseau détecté';
COMMENT ON COLUMN m_reseau_detection.geo_detec_troncon.date_sai IS 'Horodatage de l''intégration en base de l''objet';
COMMENT ON COLUMN m_reseau_detection.geo_detec_troncon.date_maj IS 'Horodatage de la mise à jour en base de l''objet';
COMMENT ON COLUMN m_reseau_detection.geo_detec_troncon.geom IS 'Géométrie 3D de l''objet';

ALTER TABLE m_reseau_detection.geo_detec_troncon ALTER COLUMN idtrdetec SET DEFAULT nextval('m_reseau_detection.geo_detec_reseau_id_seq'::regclass);




  
  
  
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                           FKEY (clé étrangère)                                                               ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################
  
