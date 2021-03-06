/*Détection des réseaux*/
/*Creation du squelette de la structure des données (table, séquence, trigger,...) */
/*init_bd_res_detec_10_squelette.sql */
/*PostGIS*/

/* GeoCompiegnois - http://geo.compiegnois.fr/ */
/* Auteur : Florent Vanhoutte */


/* TO DO

- chk update geom opération inclut toujours les classes liées. test ok sur une 1 classe mais code à reprendre pour gérer des références multiples

- habillage (txt, cote, hachure ...)
- enveloppes (lien avec objet du réseau, vue, trigger ...) faut il considérer ceci simplement comme une géométrie complémentaire de noeud ?
- chk neoud/troncon de natres = natres du ptleve
- voir si on considère qu'on peut avoir n plans autocad pour 1 opération, si oui, prévoir table media séparée
- statut : voir si on conserve l'info en considérant que cette info n'est pas possible en retour d'IC ou OL, mais bien uniquement en retour de DT ou DICT par l'exploitant
  ==> question en lien avec le volet urbanisation de la base detection avec celle de gestion des réseaux
- topologie : segmentation troncon par ptlevé ????, enveloppe > noeud ?

*/


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        DROP                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- trigger

DROP TRIGGER IF EXISTS t_t1_geo_v_detec_noeud_res ON m_reseau_detection.geo_v_detec_noeud_res;
DROP TRIGGER IF EXISTS t_t1_geo_v_detec_troncon_res ON m_reseau_detection.geo_v_detec_troncon_res;
DROP TRIGGER IF EXISTS t_t1_geo_detec_point ON m_reseau_detection.geo_detec_point;
DROP TRIGGER IF EXISTS t_t1_geo_detec_exclusion ON m_reseau_detection.geo_detec_exclusion;
DROP TRIGGER IF EXISTS t_t1_geo_detec_operation ON m_reseau_detection.geo_detec_operation;


-- fonction trigger

DROP FUNCTION IF EXISTS m_reseau_detection.ft_m_geo_v_detec_noeud_res();
DROP FUNCTION IF EXISTS m_reseau_detection.ft_m_geo_v_detec_troncon_res();
DROP FUNCTION IF EXISTS m_reseau_detection.ft_m_geo_detec_point();
DROP FUNCTION IF EXISTS m_reseau_detection.ft_m_geo_detec_exclusion();
DROP FUNCTION IF EXISTS m_reseau_detection.ft_m_geo_detec_operation();


-- vue

DROP VIEW IF EXISTS m_reseau_detection.geo_v_detec_troncon_res;
DROP VIEW IF EXISTS m_reseau_detection.geo_v_detec_noeud_res;

-- fkey

ALTER TABLE IF EXISTS m_reseau_detection.geo_detec_noeud DROP CONSTRAINT IF EXISTS idobjdetec_fkey;
ALTER TABLE IF EXISTS m_reseau_detection.geo_detec_troncon DROP CONSTRAINT IF EXISTS idobjdetec_fkey;
ALTER TABLE IF EXISTS m_reseau_detection.geo_detec_point DROP CONSTRAINT IF EXISTS lt_clprecxy_fkey;
ALTER TABLE IF EXISTS m_reseau_detection.geo_detec_point DROP CONSTRAINT IF EXISTS lt_clprecz_fkey;
ALTER TABLE IF EXISTS m_reseau_detection.geo_detec_point DROP CONSTRAINT IF EXISTS lt_clprec_fkey;
ALTER TABLE IF EXISTS m_reseau_detection.an_detec_reseau DROP CONSTRAINT IF EXISTS lt_clprecxy_fkey;
ALTER TABLE IF EXISTS m_reseau_detection.an_detec_reseau DROP CONSTRAINT IF EXISTS lt_clprecz_fkey;
ALTER TABLE IF EXISTS m_reseau_detection.an_detec_reseau DROP CONSTRAINT IF EXISTS lt_clprec_fkey;
ALTER TABLE IF EXISTS m_reseau_detection.geo_detec_operation DROP CONSTRAINT IF EXISTS lt_typeope_fkey;
--ALTER TABLE IF EXISTS m_reseau_detection.geo_detec_point DROP CONSTRAINT IF EXISTS lt_typeleve_fkey;
ALTER TABLE IF EXISTS m_reseau_detection.geo_detec_point DROP CONSTRAINT IF EXISTS lt_natres_fkey;
ALTER TABLE IF EXISTS m_reseau_detection.an_detec_reseau DROP CONSTRAINT IF EXISTS lt_natres_fkey;
ALTER TABLE IF EXISTS m_reseau_detection.geo_detec_operation DROP CONSTRAINT IF EXISTS lt_natres_fkey;
ALTER TABLE IF EXISTS m_reseau_detection.geo_detec_enveloppe_s DROP CONSTRAINT IF EXISTS lt_natres_fkey;
ALTER TABLE IF EXISTS m_reseau_detection.geo_detec_enveloppe_l DROP CONSTRAINT IF EXISTS lt_natres_fkey;
ALTER TABLE IF EXISTS m_reseau_detection.geo_detec_noeud DROP CONSTRAINT IF EXISTS lt_typeaffleu_fkey;
ALTER TABLE IF EXISTS m_reseau_detection.an_detec_reseau DROP CONSTRAINT IF EXISTS lt_statut_fkey;
ALTER TABLE IF EXISTS m_reseau_detection.geo_detec_point DROP CONSTRAINT IF EXISTS refope_fkey;
ALTER TABLE IF EXISTS m_reseau_detection.an_detec_reseau DROP CONSTRAINT IF EXISTS refope_fkey;
ALTER TABLE IF EXISTS m_reseau_detection.geo_detec_exclusion DROP CONSTRAINT IF EXISTS refope_fkey;
ALTER TABLE IF EXISTS m_reseau_detection.geo_detec_enveloppe_s DROP CONSTRAINT IF EXISTS refope_fkey;
ALTER TABLE IF EXISTS m_reseau_detection.geo_detec_enveloppe_s DROP CONSTRAINT IF EXISTS idobjope_fkey;


-- classe

DROP TABLE IF EXISTS m_reseau_detection.geo_detec_operation;
DROP TABLE IF EXISTS m_reseau_detection.geo_detec_exclusion;
DROP TABLE IF EXISTS m_reseau_detection.geo_detec_point;
DROP TABLE IF EXISTS m_reseau_detection.an_detec_reseau;
DROP TABLE IF EXISTS m_reseau_detection.geo_detec_troncon;
DROP TABLE IF EXISTS m_reseau_detection.geo_detec_noeud;
DROP TABLE IF EXISTS m_reseau_detection.geo_detec_enveloppe_s;
DROP TABLE IF EXISTS m_reseau_detection.geo_detec_enveloppe_l;


-- domaine de valeur

DROP TABLE IF EXISTS m_reseau_detection.lt_natres;
DROP TABLE IF EXISTS m_reseau_detection.lt_clprec;
--DROP TABLE IF EXISTS m_reseau_detection.lt_typeleve;
DROP TABLE IF EXISTS m_reseau_detection.lt_statut;
DROP TABLE IF EXISTS m_reseau_detection.lt_typeope;
DROP TABLE IF EXISTS m_reseau_detection.lt_typeaffleu;

-- sequence

DROP SEQUENCE IF EXISTS m_reseau_detection.geo_detec_operation_id_seq;
DROP SEQUENCE IF EXISTS m_reseau_detection.geo_detec_exclusion_id_seq;
DROP SEQUENCE IF EXISTS m_reseau_detection.geo_detec_point_id_seq;
DROP SEQUENCE IF EXISTS m_reseau_detection.an_detec_reseau_id_seq;
DROP SEQUENCE IF EXISTS m_reseau_detection.geo_detec_enveloppe_s_id_seq;
DROP SEQUENCE IF EXISTS m_reseau_detection.geo_detec_enveloppe_l_id_seq;


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
  IS 'Détection/géoréférencement des réseaux (DT-DICT)';


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                DOMAINES DE VALEURS                                                           ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- ### domaine de valeur hérité du standard StaR-DT, préexistant au PCRS mais avec des variantes

-- Table: m_reseau_detection.lt_natres

-- DROP TABLE m_reseau_detection.lt_natres;

CREATE TABLE m_reseau_detection.lt_natres
(
  code character varying(7) NOT NULL,
  valeur character varying(80) NOT NULL,
  couleur character varying(7) NOT NULL,
  CONSTRAINT lt_natres_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_reseau_detection.lt_natres
  IS 'Type de réseau conformément à la liste des réseaux de la NF P98-332';
COMMENT ON COLUMN m_reseau_detection.lt_natres.code IS 'Code de la liste énumérée relative à la nature du réseau';
COMMENT ON COLUMN m_reseau_detection.lt_natres.valeur IS 'Valeur de la liste énumérée relative à la nature du réseau';
COMMENT ON COLUMN m_reseau_detection.lt_natres.couleur IS 'Code couleur (hexadecimal) des réseaux enterrés selon la norme NF P 98-332';

INSERT INTO m_reseau_detection.lt_natres(
            code, valeur, couleur)
    VALUES
('00','Non défini','#FFFFFF'),
('ELEC','Electricité','#FF0000'),
('ELECECL','Eclairage public','#FF0000'),
('ELECSLT','Signalisation lumineuse tricolore','#FF0000'),
('ELECTRD','Eléctricité transport/distribution','#FF0000'), -- PCRS décomposé en 2
-- PCRS : ('ELECBT','Eléctricité basse tension','#FF0000'),
-- PCRS : ('ELECHT','Eléctricité haute tension','#FF0000'),
('GAZ','Gaz','#FFFF00'),
('CHIM','Produits chimiques','#F99707'),
('AEP','Eau potable','#00B0F0'),
('ASS','Assainissement et pluvial','#663300'), -- PCRS : ('ASSA','Assainissement et pluvial','#663300'),
('ASSEP','Eaux pluviales','#663300'),
('ASSEU','Eaux usées','#663300'),
('ASSUN','Réseau unitaire','#663300'), -- PCRS : ('ASSRU','Réseau unitaire','#663300'), 
('CHAU','Chauffage et climatisation','#7030A0'),
('COM','Télécom','#00FF00'),
('DECH','Déchets','#663300'),
('INCE','Incendie','#00B0F0'),
('PINS','Protection Inondation-Submersion','#663300'), -- n'existe pas PCRS
('MULT','Multi réseaux','#FF00FF');


-- ### domaine de valeur hérité du standard StaR-DT

-- Table: m_reseau_detection.lt_clprec

-- DROP TABLE m_reseau_detection.lt_clprec;

CREATE TABLE m_reseau_detection.lt_clprec
(
  code character varying(1) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT lt_clprec_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_reseau_detection.lt_clprec
  IS 'Classe de précision au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';
COMMENT ON COLUMN m_reseau_detection.lt_clprec.code IS 'Code de la liste énumérée relative à la classe de précision au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';
COMMENT ON COLUMN m_reseau_detection.lt_clprec.valeur IS 'Valeur de la liste énumérée relative à la classe de précision au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';
COMMENT ON COLUMN m_reseau_detection.lt_clprec.definition IS 'Définition de la liste énumérée relative à la classe de précision au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';

INSERT INTO m_reseau_detection.lt_clprec(
            code, valeur, definition)
    VALUES
('A','Classe A','Classe de précision inférieure 40 cm'),
('B','Classe B','Classe de précision supérieure à 40 cm et inférieure à 1,50 m'),
('C','Classe C','Classe de précision supérieure à 1,50 m ou inconnue');

/*
-- ### domaine de valeur hérité du standard StaR-DT

-- Table: m_reseau_detection.lt_typeleve

-- DROP TABLE m_reseau_detection.lt_typeleve;

CREATE TABLE m_reseau_detection.lt_typeleve
(
  code character varying(1) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT lt_typeleve_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_reseau_detection.lt_typeleve
  IS 'Type de levé';
COMMENT ON COLUMN m_reseau_detection.lt_typeleve.code IS 'Code de la liste énumérée relative au type de levé';
COMMENT ON COLUMN m_reseau_detection.lt_typeleve.valeur IS 'Valeur de la liste énumérée relative au type de levé';
COMMENT ON COLUMN m_reseau_detection.lt_typeleve.definition IS 'Définition de la liste énumérée relative au type de levé';

INSERT INTO m_reseau_detection.lt_typeleve(
            code, valeur, definition)
    VALUES
('C','ChargeGeneratrice','Charge à la génératrice'),
('G','AltitudeGeneratrice','Altitude à la génératrice'),
('F','AltitudeFluide','Altitude du fluide');
*/

-- ### domaine de valeur hérité du standard StaR-DT, lui même d'INSPIRE

-- Table: m_reseau_detection.lt_statut

-- DROP TABLE m_reseau_detection.lt_statut;

CREATE TABLE m_reseau_detection.lt_statut
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  inspire character varying(20),
  definition character varying(255),
  CONSTRAINT lt_statut_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_reseau_detection.lt_statut
  IS 'Statut de l''objet concernant son état et son usage';
COMMENT ON COLUMN m_reseau_detection.lt_statut.code IS 'Code de la liste énumérée relative au statut de l''objet concernant son état et son usage';
COMMENT ON COLUMN m_reseau_detection.lt_statut.valeur IS 'Valeur de la liste énumérée relative au statut de l''objet concernant son état et son usage';
COMMENT ON COLUMN m_reseau_detection.lt_statut.inspire IS 'Code INSPIRE de la liste énumérée relative au statut de l''objet concernant son état et son usage';
COMMENT ON COLUMN m_reseau_detection.lt_statut.definition IS 'Définition de la liste énumérée relative au statut de l''objet concernant son état et son usage';

INSERT INTO m_reseau_detection.lt_statut(
            code, valeur, inspire, definition)
    VALUES
('00','Non renseigné',NULL,'Statut non renseigné'),
('01','Déclassé','decommissionned','Arrêt définitif d''exploitation si non enregistré au GU'),
('02','En cours de construction/modification','underConstruction','Modifications en cours sur le réseau/ouvrage'),
('03','En projet','projected','Modification ou une extension de l''ouvrage envisagée'),
('04','Opérationnel','functionnal','Actif- Ouvrages ou tronçons d''ouvrages exploités');


-- Table: m_reseau_detection.lt_typeope

-- DROP TABLE m_reseau_detection.lt_typeope;

CREATE TABLE m_reseau_detection.lt_typeope
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT lt_typeope_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_reseau_detection.lt_typeope
  IS 'Type d''opération de détection des réseaux enterrés';
COMMENT ON COLUMN m_reseau_detection.lt_typeope.code IS 'Code de la liste énumérée relative au type d''opération de détection des réseaux enterrés';
COMMENT ON COLUMN m_reseau_detection.lt_typeope.valeur IS 'Valeur de la liste énumérée relative au type d''opération de détection des réseaux enterrés';
COMMENT ON COLUMN m_reseau_detection.lt_typeope.definition IS 'Définition de la liste énumérée relative au type d''opération de détection des réseaux enterrés';

INSERT INTO m_reseau_detection.lt_typeope(
            code, valeur, definition)
    VALUES
('00','Non renseigné','Non renseigné'),
('IC','Investigation complémentaire','Opération menée dans le cadre de travaux par le maitre d''ouvrage'),
('OL','Opération de localisation','Opération menée dans le cadre de démarches d''amélioration continue par l''exploitant du réseau'),
('99','Autre','Autre');


-- ### domaine de valeur hérité du standard PCRS v2,

-- Table: m_reseau_detection.lt_typeaffleu

-- DROP TABLE m_reseau_detection.lt_typeaffleu;

CREATE TABLE m_reseau_detection.lt_typeaffleu
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT lt_typeaffleu_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_reseau_detection.lt_typeaffleu
  IS 'Type de noeud affleurant de réseau';
COMMENT ON COLUMN m_reseau_detection.lt_typeaffleu.code IS 'Code de la liste énumérée relative au type de noeud affleurant de réseau';
COMMENT ON COLUMN m_reseau_detection.lt_typeaffleu.valeur IS 'Valeur de la liste énumérée relative au type de noeud affleurant de réseau';
COMMENT ON COLUMN m_reseau_detection.lt_typeaffleu.definition IS 'Définition de la liste énumérée relative au type de noeud affleurant de réseau';

INSERT INTO m_reseau_detection.lt_typeaffleu(
            code, valeur, definition)
    VALUES
('00','Non renseigné','Non renseigné'),
('01','Avaloir',''),
('02','Boîte, Coffret, Armoire',''),
('03','Tampon, plaque, chambre',''),
('04','Branchement, vanne, bouche à clé',''),
('05','Bouche incendie, Poteau incendie',''),
('06','Poteau',''),
('07','Poteau d''éclairage',''),
('99','Autre','Autre');



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

-- Sequence: m_reseau_detection.geo_detec_exclusion_id_seq

-- DROP SEQUENCE m_reseau_detection.geo_detec_exclusion_id_seq;

CREATE SEQUENCE m_reseau_detection.geo_detec_exclusion_id_seq
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
  
-- Sequence: m_reseau_detection.an_detec_reseau_id_seq

-- DROP SEQUENCE m_reseau_detection.an_detec_reseau_id_seq;

CREATE SEQUENCE m_reseau_detection.an_detec_reseau_id_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
  
-- Sequence: m_reseau_detection.geo_detec_enveloppe_s_id_seq

-- DROP SEQUENCE m_reseau_detection.geo_detec_enveloppe_s_id_seq;

CREATE SEQUENCE m_reseau_detection.geo_detec_enveloppe_s_id_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;    

-- Sequence: m_reseau_detection.geo_detec_enveloppe_l_id_seq

-- DROP SEQUENCE m_reseau_detection.geo_detec_enveloppe_l_id_seq;

CREATE SEQUENCE m_reseau_detection.geo_detec_enveloppe_l_id_seq
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
  refope character varying(80) NOT NULL, -- fkey vers classe opedetec
  typeope character varying(2) NOT NULL, -- fkey vers domaine de valeur lt_typeope
  natres character varying(7) NOT NULL, -- fkey vers domaine de valeur lt_natres
  mouvrage character varying(80) NOT NULL,
  presta character varying(80) NOT NULL,
  dateope date NOT NULL,
  nomplan character varying(80),
  urlplan character varying(254),
  observ character varying(254),
  sup_m2 integer,
  date_sai timestamp without time zone NOT NULL DEFAULT now(),  
  date_maj timestamp without time zone,
  geom geometry(MultiPolygon,2154) NOT NULL,
  CONSTRAINT geo_detec_operation_pkey PRIMARY KEY (idopedetec),
  CONSTRAINT refope_ukey UNIQUE (refope) 
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_reseau_detection.geo_detec_operation
  IS 'Opération de détection de réseaux';
COMMENT ON COLUMN m_reseau_detection.geo_detec_operation.idopedetec IS 'Identifiant unique de l''opération de détection dans la base de données';
COMMENT ON COLUMN m_reseau_detection.geo_detec_operation.refope IS 'Référence de l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_detec_operation.typeope IS 'Type d''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_detec_operation.natres IS 'Nature du réseau faisant l''objet de l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_detec_operation.mouvrage IS 'Maitre d''ouvrage de l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_detec_operation.presta IS 'Prestataire de l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_detec_operation.dateope IS 'Date de l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_detec_operation.nomplan IS 'Nom du fichier du plan';
COMMENT ON COLUMN m_reseau_detection.geo_detec_operation.urlplan IS 'Lien vers le fichier du plan';
COMMENT ON COLUMN m_reseau_detection.geo_detec_operation.observ IS 'Commentaires divers';
COMMENT ON COLUMN m_reseau_detection.geo_detec_operation.sup_m2 IS 'Superficie de l''opération de détection (en mètres carrés)';
COMMENT ON COLUMN m_reseau_detection.geo_detec_operation.date_sai IS 'Horodatage de l''intégration en base de l''objet';
COMMENT ON COLUMN m_reseau_detection.geo_detec_operation.date_maj IS 'Horodatage de la mise à jour en base de l''objet';
COMMENT ON COLUMN m_reseau_detection.geo_detec_operation.geom IS 'Géométrie de l''objet';

ALTER TABLE m_reseau_detection.geo_detec_operation ALTER COLUMN idopedetec SET DEFAULT nextval('m_reseau_detection.geo_detec_operation_id_seq'::regclass);


-- #################################################################### CLASSE ZONE D'EXCLUSION ###############################################

-- Table: m_reseau_detection.geo_detec_exclusion

-- DROP TABLE m_reseau_detection.geo_detec_exclusion;

CREATE TABLE m_reseau_detection.geo_detec_exclusion
(
  idexcdetec character varying(254) NOT NULL,
  refope character varying(80) NOT NULL, -- fkey vers classe opedetec
  observ character varying(254),
  sup_m2 integer,
  date_sai timestamp without time zone NOT NULL DEFAULT now(),  
  date_maj timestamp without time zone,
  geom geometry(MultiPolygon,2154) NOT NULL,
  CONSTRAINT geo_detec_exclusion_pkey PRIMARY KEY (idexcdetec)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_reseau_detection.geo_detec_exclusion
  IS 'Secteur d''exclusion de détection de réseaux';
COMMENT ON COLUMN m_reseau_detection.geo_detec_exclusion.idexcdetec IS 'Identifiant unique du secteur d''exclusion de détection dans la base de données';
COMMENT ON COLUMN m_reseau_detection.geo_detec_exclusion.refope IS 'Référence de l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_detec_exclusion.observ IS 'Commentaires divers';
COMMENT ON COLUMN m_reseau_detection.geo_detec_exclusion.sup_m2 IS 'Superficie du secteur d''exclusion de détection (en mètres carrés)';
COMMENT ON COLUMN m_reseau_detection.geo_detec_exclusion.date_sai IS 'Horodatage de l''intégration en base de l''objet';
COMMENT ON COLUMN m_reseau_detection.geo_detec_exclusion.date_maj IS 'Horodatage de la mise à jour en base de l''objet';
COMMENT ON COLUMN m_reseau_detection.geo_detec_exclusion.geom IS 'Géométrie de l''objet';

ALTER TABLE m_reseau_detection.geo_detec_exclusion ALTER COLUMN idexcdetec SET DEFAULT nextval('m_reseau_detection.geo_detec_exclusion_id_seq'::regclass);




-- #################################################################### CLASSE POINT DE DETECTION/GEOREF ###############################################

-- ## revoir cette classe par rapport à celle du PCRS


-- Table: m_reseau_detection.geo_detec_point

-- DROP TABLE m_reseau_detection.geo_detec_point;

CREATE TABLE m_reseau_detection.geo_detec_point
(
  idptdetec character varying(254) NOT NULL, -- pkey
  idptope character varying(254) NOT NULL, -- unique
  refope character varying(80) NOT NULL, -- fkey vers classe opedetec
  refptope character varying(30) NOT NULL,
  insee character varying(5) NOT NULL,
  typedetec character varying(2) NOT NULL, -- fkey vers domaine de valeur
  methode character varying(80) NOT NULL,  
  natres character varying(7) NOT NULL, -- fkey vers domaine de valeur lt_natres  
  x numeric(10,3) NOT NULL,
  y numeric(11,3) NOT NULL,
  zgn numeric (7,3) NOT NULL,
  ztn numeric (7,3),
  c numeric (5,3),
  precxy numeric (7,3) NOT NULL,
  preczgn numeric (7,3) NOT NULL,
--  precztn
--  precz  
  clprecxy character varying (1) NOT NULL DEFAULT 'C',  -- fkey vers domaine de valeur
  clprecz character varying (1) NOT NULL DEFAULT 'C', -- fkey vers domaine de valeur
  clprec character varying (1) NOT NULL, -- fkey vers domaine de valeur #resultat combinaison prec xy et z généré par trigger
  horodatage timestamp without time zone NOT NULL,
  date_sai timestamp without time zone NOT NULL DEFAULT now(),  
  date_maj timestamp without time zone,
  geom geometry(Point,2154) NOT NULL,
  CONSTRAINT geo_detec_point_pkey PRIMARY KEY (idptdetec),
  CONSTRAINT idptope_ukey UNIQUE (idptope)   
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_reseau_detection.geo_detec_point
  IS 'Point de détection/géoréférencement d''un réseau';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.idptdetec IS 'Identifiant unique du point de détection dans la base de données';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.idptope IS 'Identifiant unique du point de détection de l''opération';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.refope IS 'Référence de l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.refptope IS 'Référence du point levé dans l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.insee IS 'Code INSEE de la commmune';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.typedetec IS 'Type de détection/géoréférencement';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.methode IS 'Méthode employée pour la détection';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.natres IS 'Nature du réseau détecté';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.x IS 'Coordonnée X Lambert 93 (en mètres)';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.y IS 'Coordonnée X Lambert 93 (en mètres)';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.zgn IS 'Altimétrie Z NGF de la génératrice (supérieure si enterrée, inférieure si aérienne) du réseau (en mètres)';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.ztn IS 'Altimétrie Z NGF du terrain naturel (en mètres)';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.c IS 'Charge sur réseau (en mètres)';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.precxy IS 'Précision absolue en planimètre (en mètres)';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.preczgn IS 'Précision absolue en altimétrie de la génératrice supérieure (en mètres)';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.clprecxy IS 'Classe de précision planimétrique (XY)';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.clprecz IS 'Classe de précision altimétrique (Z)';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.clprec IS 'Classe de précision planimétrique et altimétrique (XYZ)';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.horodatage IS 'Horodatage détection/géoréfécement du point';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.date_sai IS 'Horodatage de l''intégration en base de l''objet';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.date_maj IS 'Horodatage de la mise à jour en base de l''objet';
COMMENT ON COLUMN m_reseau_detection.geo_detec_point.geom IS 'Géométrie 3D de l''objet';

ALTER TABLE m_reseau_detection.geo_detec_point ALTER COLUMN idptdetec SET DEFAULT nextval('m_reseau_detection.geo_detec_point_id_seq'::regclass);


-- #################################################################### CLASSE RESEAU ###############################################


-- Table: m_reseau_detection.an_detec_reseau

-- DROP TABLE m_reseau_detection.an_detec_reseau;

CREATE TABLE m_reseau_detection.an_detec_reseau
(
  idobjdetec character varying(254) NOT NULL,
  idobjope character varying(254) NOT NULL, -- unique
  refope character varying(80) NOT NULL, -- fkey vers classe opedetec
  refobjope character varying(30) NOT NULL,
  insee character varying(5) NOT NULL,
  natres character varying(7) NOT NULL, -- fkey vers domaine de valeur
  statut character varying(2) NOT NULL, -- fkey vers domaine de valeur
  clprecxy character varying (1) NOT NULL DEFAULT 'C', -- fkey vers domaine de valeur
  clprecz character varying (1) NOT NULL DEFAULT 'C', -- fkey vers domaine de valeur
  clprec character varying (1) NOT NULL, -- fkey vers domaine de valeur #resultat combinaison prec xy et z généré par trigger     
  date_sai timestamp without time zone NOT NULL DEFAULT now(),  
  date_maj timestamp without time zone, 
  CONSTRAINT an_detec_reseau_pkey PRIMARY KEY (idobjdetec),
  CONSTRAINT idobjope_ukey UNIQUE (idobjope) 
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_reseau_detection.an_detec_reseau
  IS 'Noeud de réseau (ouvrage/appareillage) détecté';
COMMENT ON COLUMN m_reseau_detection.an_detec_reseau.idobjdetec IS 'Identifiant unique de l''élément de réseau détecté dans la base de données';
COMMENT ON COLUMN m_reseau_detection.an_detec_reseau.idobjope IS 'Identifiant unique de l''élément de réseau détecté de l''opération';
COMMENT ON COLUMN m_reseau_detection.an_detec_reseau.refope IS 'Référence de l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.an_detec_reseau.refobjope IS 'Référence de l''objet de réseau dans l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.an_detec_reseau.insee IS 'Code INSEE de la commmune';
COMMENT ON COLUMN m_reseau_detection.an_detec_reseau.natres IS 'Nature du réseau détecté';
COMMENT ON COLUMN m_reseau_detection.an_detec_reseau.statut IS 'Statut de l''objet concernant son état et son usage';
COMMENT ON COLUMN m_reseau_detection.an_detec_reseau.clprecxy IS 'Classe de précision planimétrique (XY)';
COMMENT ON COLUMN m_reseau_detection.an_detec_reseau.clprecz IS 'Classe de précision altimétrique (Z)';
COMMENT ON COLUMN m_reseau_detection.an_detec_reseau.clprec IS 'Classe de précision planimétrique et altimétrique (XYZ)';
COMMENT ON COLUMN m_reseau_detection.an_detec_reseau.date_sai IS 'Horodatage de l''intégration en base de l''objet';
COMMENT ON COLUMN m_reseau_detection.an_detec_reseau.date_maj IS 'Horodatage de la mise à jour en base de l''objet';

ALTER TABLE m_reseau_detection.an_detec_reseau ALTER COLUMN idobjdetec SET DEFAULT nextval('m_reseau_detection.an_detec_reseau_id_seq'::regclass);



-- #################################################################### SOUS CLASSE NOEUD (OUVRAGE/APPAREILLAGE) ###############################################

-- Table: m_reseau_detection.geo_detec_noeud

-- DROP TABLE m_reseau_detection.geo_detec_noeud;

CREATE TABLE m_reseau_detection.geo_detec_noeud
(
  idobjdetec character varying(254) NOT NULL,
  typeaffleu character varying(2), -- fkey vers lt_typeaffleu
  symbnom character varying(254),
  symbangle numeric(5,2),
  symblong real,
  symblarg real,
  geom geometry(Point,2154) NOT NULL,
  CONSTRAINT geo_detec_noeud_pkey PRIMARY KEY (idobjdetec) 
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_reseau_detection.geo_detec_noeud
  IS 'Noeud de réseau (ouvrage/appareillage) détecté';
COMMENT ON COLUMN m_reseau_detection.geo_detec_noeud.idobjdetec IS 'Identifiant unique de l''élément de réseau détecté dans la base de données';
COMMENT ON COLUMN m_reseau_detection.geo_detec_noeud.typeaffleu IS 'Type de noeud affleurant de réseau';
COMMENT ON COLUMN m_reseau_detection.geo_detec_noeud.symbnom IS 'Nom du symbole employé pour la représentation du noeud';
COMMENT ON COLUMN m_reseau_detection.geo_detec_noeud.symbangle IS 'Angle de rotation du symbole employé pour la représentation du noeud';
COMMENT ON COLUMN m_reseau_detection.geo_detec_noeud.symblong IS 'Facteur d''étirement en longueur du symbole';
COMMENT ON COLUMN m_reseau_detection.geo_detec_noeud.symblarg IS 'Facteur d''étirement en largeur du symbole';
COMMENT ON COLUMN m_reseau_detection.geo_detec_noeud.geom IS 'Géométrie 2D de l''objet';


-- #################################################################### SOUS CLASSE TRONCON ###############################################

-- Table: m_reseau_detection.geo_detec_troncon

-- DROP TABLE m_reseau_detection.geo_detec_troncon;

CREATE TABLE m_reseau_detection.geo_detec_troncon
(
  idobjdetec character varying(254) NOT NULL,
  diametre integer,
-- materiau
  geom geometry(LineString,2154) NOT NULL,
  CONSTRAINT geo_detec_troncon_pkey PRIMARY KEY (idobjdetec) 
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_reseau_detection.geo_detec_troncon
  IS 'Noeud de réseau (ouvrage/appareillage) détecté';
COMMENT ON COLUMN m_reseau_detection.geo_detec_troncon.idobjdetec IS 'Identifiant unique de l''élément de réseau détecté dans la base de données';
COMMENT ON COLUMN m_reseau_detection.geo_detec_troncon.diametre IS 'Diamètre nominal de la canalisation (en millimètres)';
COMMENT ON COLUMN m_reseau_detection.geo_detec_troncon.geom IS 'Géométrie 3D de l''objet';


-- #################################################################### CLASSE ENVELOPPE ###############################################

-- Table: m_reseau_detection.geo_detec_enveloppe_s

-- DROP TABLE m_reseau_detection.geo_detec_enveloppe_s;

CREATE TABLE m_reseau_detection.geo_detec_enveloppe_s
(
  idenvdetec character varying(254) NOT NULL,
  refenvope character varying(30),
  -- la clé étrangère pour un livrable fichier nécessite donc de concaténer refope|'-'|refobjope ex : m2019A-AEP1.1
  idobjope character varying(254) NOT NULL, -- fkey vers 
  refope character varying(80) NOT NULL, -- fkey vers classe opedetec
  refobjope character varying(30) NOT NULL,
  natres character varying(7) NOT NULL, -- fkey vers domaine de valeur
  date_sai timestamp without time zone NOT NULL DEFAULT now(),  
  date_maj timestamp without time zone, 
  geom geometry(Polygon,2154),
  CONSTRAINT geo_detec_enveloppe_s_pkey PRIMARY KEY (idenvdetec) 
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_reseau_detection.geo_detec_enveloppe_s
  IS 'Enveloppe de l''affleurant du réseau détecté';
COMMENT ON COLUMN m_reseau_detection.geo_detec_enveloppe_s.idenvdetec IS 'Identifiant unique de l''enveloppe de réseau détecté dans la base de données';
COMMENT ON COLUMN m_reseau_detection.geo_detec_enveloppe_s.refenvope IS 'Référence de l''enveloppe de réseau détecté dans l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_detec_enveloppe_s.idobjope IS 'Identifiant du noeud affleurant dans l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_detec_enveloppe_s.refope IS 'Référence de l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_detec_enveloppe_s.refobjope IS 'Référence du noeud de réseau dans l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_detec_enveloppe_s.natres IS 'Nature du réseau de l''affleurant du réseau détecté';
COMMENT ON COLUMN m_reseau_detection.geo_detec_enveloppe_s.date_sai IS 'Horodatage de l''intégration en base de l''objet';
COMMENT ON COLUMN m_reseau_detection.geo_detec_enveloppe_s.date_maj IS 'Horodatage de la mise à jour en base de l''objet';
COMMENT ON COLUMN m_reseau_detection.geo_detec_enveloppe_s.geom IS 'Géométrie de l''objet';

ALTER TABLE m_reseau_detection.geo_detec_enveloppe_s ALTER COLUMN idenvdetec SET DEFAULT nextval('m_reseau_detection.geo_detec_enveloppe_s_id_seq'::regclass);


-- Table: m_reseau_detection.geo_detec_enveloppe_l

-- DROP TABLE m_reseau_detection.geo_detec_enveloppe_l;

CREATE TABLE m_reseau_detection.geo_detec_enveloppe_l
(
  idenvldetec character varying(254) NOT NULL,
  natres character varying(7) NOT NULL, -- fkey vers domaine de valeur
  date_sai timestamp without time zone NOT NULL DEFAULT now(),  
  date_maj timestamp without time zone, 
  geom geometry(LineString,2154),
  CONSTRAINT geo_detec_enveloppe_l_pkey PRIMARY KEY (idenvldetec) 
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_reseau_detection.geo_detec_enveloppe_l
  IS 'Habillage de l''enveloppe de l''affleurant du réseau détecté';
COMMENT ON COLUMN m_reseau_detection.geo_detec_enveloppe_l.idenvldetec IS 'Identifiant unique de l''enveloppe de réseau détecté dans la base de données';
COMMENT ON COLUMN m_reseau_detection.geo_detec_enveloppe_l.natres IS 'Nature du réseau de l''affleurant du réseau détecté';
COMMENT ON COLUMN m_reseau_detection.geo_detec_enveloppe_l.date_sai IS 'Horodatage de l''intégration en base de l''objet';
COMMENT ON COLUMN m_reseau_detection.geo_detec_enveloppe_l.date_maj IS 'Horodatage de la mise à jour en base de l''objet';
COMMENT ON COLUMN m_reseau_detection.geo_detec_enveloppe_l.geom IS 'Géométrie de l''objet';

ALTER TABLE m_reseau_detection.geo_detec_enveloppe_l ALTER COLUMN idenvldetec SET DEFAULT nextval('m_reseau_detection.geo_detec_enveloppe_l_id_seq'::regclass);


 
  
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                           FKEY (clé étrangère)                                                               ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- #### domaine de valeur ####

-- ## NATURE DU RESEAU

-- Foreign Key: m_reseau_detection.lt_natres_fkey

-- ALTER TABLE m_reseau_detection.geo_detec_point DROP CONSTRAINT lt_natres_fkey;

ALTER TABLE m_reseau_detection.geo_detec_point
  ADD CONSTRAINT lt_natres_fkey FOREIGN KEY (natres)
      REFERENCES m_reseau_detection.lt_natres (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Foreign Key: m_reseau_detection.lt_natres_fkey

-- ALTER TABLE m_reseau_detection.an_detec_reseau DROP CONSTRAINT lt_natres_fkey;   

ALTER TABLE m_reseau_detection.an_detec_reseau               
  ADD CONSTRAINT lt_natres_fkey FOREIGN KEY (natres)
      REFERENCES m_reseau_detection.lt_natres (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
      
-- Foreign Key: m_reseau_detection.lt_natres_fkey

-- ALTER TABLE m_reseau_detection.geo_detec_operation DROP CONSTRAINT lt_natres_fkey;   

ALTER TABLE m_reseau_detection.geo_detec_operation               
  ADD CONSTRAINT lt_natres_fkey FOREIGN KEY (natres)
      REFERENCES m_reseau_detection.lt_natres (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Foreign Key: m_reseau_detection.lt_natres_fkey

-- ALTER TABLE m_reseau_detection.geo_detec_enveloppe_s DROP CONSTRAINT lt_natres_fkey;   

ALTER TABLE m_reseau_detection.geo_detec_enveloppe_s               
  ADD CONSTRAINT lt_natres_fkey FOREIGN KEY (natres)
      REFERENCES m_reseau_detection.lt_natres (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
      
-- Foreign Key: m_reseau_detection.lt_natres_fkey

-- ALTER TABLE m_reseau_detection.geo_detec_enveloppe_l DROP CONSTRAINT lt_natres_fkey;   

ALTER TABLE m_reseau_detection.geo_detec_enveloppe_l               
  ADD CONSTRAINT lt_natres_fkey FOREIGN KEY (natres)
      REFERENCES m_reseau_detection.lt_natres (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;      


-- ## TYPE AFFLEURANT

-- Foreign Key: m_reseau_detection.lt_typeaffleu_fkey

-- ALTER TABLE m_reseau_detection.geo_detec_noeud DROP CONSTRAINT lt_typeaffleu_fkey;

ALTER TABLE m_reseau_detection.geo_detec_noeud
  ADD CONSTRAINT lt_typeaffleu_fkey FOREIGN KEY (typeaffleu)
      REFERENCES m_reseau_detection.lt_typeaffleu (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;      
    

-- ## STATUT

-- Foreign Key: m_reseau_detection.lt_statut_fkey

-- ALTER TABLE m_reseau_detection.an_detec_reseau DROP CONSTRAINT lt_statut_fkey;   

ALTER TABLE m_reseau_detection.an_detec_reseau               
  ADD CONSTRAINT lt_statut_fkey FOREIGN KEY (statut)
      REFERENCES m_reseau_detection.lt_statut (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;      
     
-- ## TYPE OPE

-- Foreign Key: m_reseau_detection.lt_typeope_fkey

-- ALTER TABLE m_reseau_detection.geo_detec_operation DROP CONSTRAINT lt_typeope_fkey;   

ALTER TABLE m_reseau_detection.geo_detec_operation               
  ADD CONSTRAINT lt_typeope_fkey FOREIGN KEY (typeope)
      REFERENCES m_reseau_detection.lt_typeope (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION; 

-- ## CLASSE GEOLOC DT-DICT      

-- Foreign Key: m_reseau_detection.lt_clprecxy_fkey

-- ALTER TABLE m_reseau_detection.geo_detec_point DROP CONSTRAINT lt_clprecxy_fkey;

ALTER TABLE m_reseau_detection.geo_detec_point
  ADD CONSTRAINT lt_clprecxy_fkey FOREIGN KEY (clprecxy)
      REFERENCES m_reseau_detection.lt_clprec (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Foreign Key: m_reseau_detection.lt_clprecz_fkey

-- ALTER TABLE m_reseau_detection.geo_detec_point DROP CONSTRAINT lt_clprecz_fkey;   

ALTER TABLE m_reseau_detection.geo_detec_point               
  ADD CONSTRAINT lt_clprecz_fkey FOREIGN KEY (clprecz)
      REFERENCES m_reseau_detection.lt_clprec (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Foreign Key: m_reseau_detection.lt_clprec_fkey

-- ALTER TABLE m_reseau_detection.geo_detec_point DROP CONSTRAINT lt_clprec_fkey;   

ALTER TABLE m_reseau_detection.geo_detec_point               
  ADD CONSTRAINT lt_clprec_fkey FOREIGN KEY (clprec)
      REFERENCES m_reseau_detection.lt_clprec (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Foreign Key: m_reseau_detection.lt_clprecxy_fkey

-- ALTER TABLE m_reseau_detection.an_detec_reseau DROP CONSTRAINT lt_clprecxy_fkey;

ALTER TABLE m_reseau_detection.an_detec_reseau
  ADD CONSTRAINT lt_clprecxy_fkey FOREIGN KEY (clprecxy)
      REFERENCES m_reseau_detection.lt_clprec (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Foreign Key: m_reseau_detection.lt_clprecz_fkey

-- ALTER TABLE m_reseau_detection.an_detec_reseau DROP CONSTRAINT lt_clprecz_fkey;   

ALTER TABLE m_reseau_detection.an_detec_reseau               
  ADD CONSTRAINT lt_clprecz_fkey FOREIGN KEY (clprecz)
      REFERENCES m_reseau_detection.lt_clprec (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Foreign Key: m_reseau_detection.lt_clprec_fkey

-- ALTER TABLE m_reseau_detection.an_detec_reseau DROP CONSTRAINT lt_clprec_fkey;   

ALTER TABLE m_reseau_detection.an_detec_reseau               
  ADD CONSTRAINT lt_clprec_fkey FOREIGN KEY (clprec)
      REFERENCES m_reseau_detection.lt_clprec (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

-- #### FKEY ####


-- ## idobjdetec

-- Foreign Key: m_reseau_detection.idobjdetec_fkey

-- ALTER TABLE m_reseau_detection.geo_detec_noeud DROP CONSTRAINT idobjdetec_fkey;   

ALTER TABLE m_reseau_detection.geo_detec_noeud               
  ADD CONSTRAINT idobjdetec_fkey FOREIGN KEY (idobjdetec)
      REFERENCES m_reseau_detection.an_detec_reseau (idobjdetec) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Foreign Key: m_reseau_detection.idobjdetec_fkey

-- ALTER TABLE m_reseau_detection.geo_detec_troncon DROP CONSTRAINT idobjdetec_fkey;   

ALTER TABLE m_reseau_detection.geo_detec_troncon               
  ADD CONSTRAINT idobjdetec_fkey FOREIGN KEY (idobjdetec)
      REFERENCES m_reseau_detection.an_detec_reseau (idobjdetec) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

      
-- ## refope

-- Foreign Key: m_reseau_detection.refope_fkey

-- ALTER TABLE m_reseau_detection.geo_detec_exclusion DROP CONSTRAINT refope_fkey;   

ALTER TABLE m_reseau_detection.geo_detec_exclusion               
  ADD CONSTRAINT refope_fkey FOREIGN KEY (refope)
      REFERENCES m_reseau_detection.geo_detec_operation (refope) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Foreign Key: m_reseau_detection.refope_fkey

-- ALTER TABLE m_reseau_detection.an_detec_reseau DROP CONSTRAINT refope_fkey;   

ALTER TABLE m_reseau_detection.an_detec_reseau               
  ADD CONSTRAINT refope_fkey FOREIGN KEY (refope)
      REFERENCES m_reseau_detection.geo_detec_operation (refope) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
      
-- Foreign Key: m_reseau_detection.refope_fkey

-- ALTER TABLE m_reseau_detection.geo_detec_point DROP CONSTRAINT refope_fkey;   

ALTER TABLE m_reseau_detection.geo_detec_point               
  ADD CONSTRAINT refope_fkey FOREIGN KEY (refope)
      REFERENCES m_reseau_detection.geo_detec_operation (refope) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION; 

-- Foreign Key: m_reseau_detection.refope_fkey

-- ALTER TABLE m_reseau_detection.geo_detec_enveloppe_s DROP CONSTRAINT refope_fkey;   

ALTER TABLE m_reseau_detection.geo_detec_enveloppe_s               
  ADD CONSTRAINT refope_fkey FOREIGN KEY (refope)
      REFERENCES m_reseau_detection.geo_detec_operation (refope) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

/*      
-- ## idobjope

-- Foreign Key: m_reseau_detection.idobjope_fkey

-- ALTER TABLE m_reseau_detection.geo_detec_enveloppe_s DROP CONSTRAINT idobjope_fkey;   

ALTER TABLE m_reseau_detection.geo_detec_enveloppe_s               
  ADD CONSTRAINT idobjope_fkey FOREIGN KEY (idobjope)
      REFERENCES m_reseau_detection.an_detec_reseau (idobjope) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
*/      

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        VUES                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- #################################################################### VUE TRONCON RES ###############################################
        
-- View: m_reseau_detection.geo_v_detec_troncon_res

-- DROP VIEW m_reseau_detection.geo_v_detec_troncon_res;

CREATE OR REPLACE VIEW m_reseau_detection.geo_v_detec_troncon_res AS 
 SELECT 
  g.idobjdetec,
  a.idobjope,
  a.refope,
  a.refobjope,  
  a.insee,
  a.natres,
  a.statut,
  g.diametre,
  a.clprecxy,
  a.clprecz,
  a.clprec, 
  a.date_sai,
  a.date_maj,
  g.geom
  
FROM m_reseau_detection.geo_detec_troncon g
LEFT JOIN m_reseau_detection.an_detec_reseau a ON g.idobjdetec = a.idobjdetec
ORDER BY g.idobjdetec;

COMMENT ON VIEW m_reseau_detection.geo_v_detec_troncon_res
  IS 'Troncon de réseau detecté';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_troncon_res.idobjdetec IS 'Identifiant unique de l''élément de réseau détecté dans la base de données';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_troncon_res.idobjope IS 'Identifiant unique de l''élément de réseau détecté de l''opération';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_troncon_res.refope IS 'Référence de l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_troncon_res.refobjope IS 'Identifiant de l''objet de réseau dans l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_troncon_res.insee IS 'Code INSEE de la commmune';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_troncon_res.natres IS 'Nature du réseau détecté';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_troncon_res.statut IS 'Statut de l''objet selon son état et son usage';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_troncon_res.diametre IS 'Diamètre nominal de la canalisation (en millimètres)';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_troncon_res.clprecxy IS 'Classe de précision planimétrique (XY)';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_troncon_res.clprecz IS 'Classe de précision altimétrique (Z)';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_troncon_res.clprec IS 'Classe de précision planimétrique et altimétrique (XYZ)';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_troncon_res.date_sai IS 'Horodatage de l''intégration en base de l''objet';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_troncon_res.date_maj IS 'Horodatage de la mise à jour en base de l''objet';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_troncon_res.geom IS 'Géométrie de l''objet';  

-- #################################################################### VUE NOEUD RES ###############################################
        
-- View: m_reseau_detection.geo_v_detec_noeud_res

-- DROP VIEW m_reseau_detection.geo_v_detec_noeud_res;

CREATE OR REPLACE VIEW m_reseau_detection.geo_v_detec_noeud_res AS 
 SELECT 
  g.idobjdetec,
  a.idobjope,
  a.refope,
  a.refobjope,  
  a.insee,
  a.natres,
  a.statut,
  g.typeaffleu,
  a.clprecxy,
  a.clprecz,
  a.clprec,
  g.symbnom,
  g.symbangle,
  g.symblong,
  g.symblarg, 
  a.date_sai,
  a.date_maj,
  g.geom
  
FROM m_reseau_detection.geo_detec_noeud g
LEFT JOIN m_reseau_detection.an_detec_reseau a ON g.idobjdetec = a.idobjdetec
ORDER BY g.idobjdetec;

COMMENT ON VIEW m_reseau_detection.geo_v_detec_noeud_res
  IS 'Noeud de réseau detecté'; 
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_noeud_res.idobjdetec IS 'Identifiant unique de l''élément de réseau détecté dans la base de données';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_noeud_res.idobjope IS 'Identifiant unique de l''élément de réseau détecté de l''opération';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_noeud_res.refope IS 'Référence de l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_noeud_res.refobjope IS 'Identifiant de l''objet de réseau détecté dans l''opération de détection';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_noeud_res.insee IS 'Code INSEE de la commmune';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_noeud_res.natres IS 'Nature du réseau détecté';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_noeud_res.statut IS 'Statut de l''objet selon son état et son usage';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_noeud_res.typeaffleu IS 'Type de noeud affleurant de réseau';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_noeud_res.clprecxy IS 'Classe de précision planimétrique (XY)';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_noeud_res.clprecz IS 'Classe de précision altimétrique (Z)';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_noeud_res.clprec IS 'Classe de précision planimétrique et altimétrique (XYZ)';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_noeud_res.symbnom IS 'Nom du symbole employé pour la représentation du noeud';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_noeud_res.symbangle IS 'Angle de rotation du symbole employé pour la représentation du noeud';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_noeud_res.symblong IS 'Facteur d''étirement en longueur du symbole';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_noeud_res.symblarg IS 'Facteur d''étirement en largeur du symbole';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_noeud_res.date_sai IS 'Horodatage de l''intégration en base de l''objet';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_noeud_res.date_maj IS 'Horodatage de la mise à jour en base de l''objet';
COMMENT ON COLUMN m_reseau_detection.geo_v_detec_noeud_res.geom IS 'Géométrie de l''objet';  
  

 
  
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      TRIGGER                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################



-- #################################################################### FONCTION TRIGGER - GEO_V_TRONCON_RES ###################################################

-- Function: m_reseau_detection.ft_m_geo_v_detec_troncon_res()

-- DROP FUNCTION m_reseau_detection.ft_m_geo_v_detec_troncon_res();

CREATE OR REPLACE FUNCTION m_reseau_detection.ft_m_geo_v_detec_troncon_res()
  RETURNS trigger AS
$BODY$

--déclaration variable pour stocker la séquence des id
DECLARE v_idobjdetec character varying(254);

BEGIN

-- INSERT
IF (TG_OP = 'INSERT') THEN

v_idobjdetec := nextval('m_reseau_detection.an_detec_reseau_id_seq'::regclass);

-- an_detec_reseau
INSERT INTO m_reseau_detection.an_detec_reseau (idobjdetec, idobjope, refope, refobjope, insee, natres, statut, clprecxy, clprecz, clprec, date_sai, date_maj)
SELECT v_idobjdetec,
CONCAT(NEW.refope,'-',NEW.refobjope),
NEW.refope,
NEW.refobjope,
CASE WHEN NEW.insee IS NULL THEN (SELECT insee FROM r_osm.geo_vm_osm_commune_arc WHERE st_intersects(NEW.geom,geom)) ELSE NEW.insee END,
CASE WHEN NEW.natres IS NULL THEN '00' ELSE NEW.natres END,
CASE WHEN NEW.statut IS NULL THEN '00' ELSE NEW.statut END,
CASE WHEN NEW.clprecxy IS NULL THEN 'C' ELSE NEW.clprecxy END,
CASE WHEN NEW.clprecz IS NULL THEN 'C' ELSE NEW.clprecz END,
CASE WHEN (NEW.clprecxy = 'A' AND NEW.clprecz = 'A') THEN 'A' WHEN ((NEW.clprecxy IN ('A','B')) AND (NEW.clprecz = 'B')) THEN 'B' WHEN (NEW.clprecxy = 'B' AND NEW.clprecz IN ('A','B')) THEN 'B' ELSE 'C' END,
now(),
NULL;

-- geo_detec_troncon
INSERT INTO m_reseau_detection.geo_detec_troncon (idobjdetec, diametre, geom)
SELECT v_idobjdetec,
NEW.diametre,
CASE WHEN (SELECT geom FROM m_reseau_detection.geo_detec_operation WHERE (st_contains(st_buffer(geom,0.1),NEW.geom)) AND NEW.refope = refope) IS NOT NULL THEN NEW.geom ELSE NULL END;

RETURN NEW;


-- UPDATE
ELSIF (TG_OP = 'UPDATE') THEN

-- an_detec_reseau
UPDATE
m_reseau_detection.an_detec_reseau
SET
idobjdetec=OLD.idobjdetec,
idobjope=CONCAT(NEW.refope,'-',NEW.refobjope),
refope=NEW.refope,
refobjope=NEW.refobjope,
insee=CASE WHEN NEW.insee IS NULL THEN (SELECT insee FROM r_osm.geo_vm_osm_commune_arc WHERE st_intersects(NEW.geom,geom)) ELSE NEW.insee END,
natres=CASE WHEN NEW.natres IS NULL THEN '00' ELSE NEW.natres END,
statut=CASE WHEN NEW.statut IS NULL THEN '00' ELSE NEW.statut END,
clprecxy=CASE WHEN NEW.clprecxy IS NULL THEN 'C' ELSE NEW.clprecxy END,
clprecz=CASE WHEN NEW.clprecz IS NULL THEN 'C' ELSE NEW.clprecz END,
clprec=CASE WHEN (NEW.clprecxy = 'A' AND NEW.clprecz = 'A') THEN 'A' WHEN ((NEW.clprecxy IN ('A','B')) AND (NEW.clprecz = 'B')) THEN 'B' WHEN (NEW.clprecxy = 'B' AND NEW.clprecz IN ('A','B')) THEN 'B' ELSE 'C' END,
date_sai=OLD.date_sai,
date_maj=now()
WHERE m_reseau_detection.an_detec_reseau.idobjdetec = OLD.idobjdetec;

-- geo_detec_troncon
UPDATE
m_reseau_detection.geo_detec_troncon
SET
idobjdetec=OLD.idobjdetec,
diametre=NEW.diametre,
geom=CASE WHEN (SELECT geom FROM m_reseau_detection.geo_detec_operation WHERE (st_contains(st_buffer(geom,0.1),NEW.geom)) AND NEW.refope = refope) IS NOT NULL THEN NEW.geom ELSE NULL END
WHERE m_reseau_detection.geo_detec_troncon.idobjdetec = OLD.idobjdetec;

RETURN NEW;


-- DELETE
ELSIF (TG_OP = 'DELETE') THEN

-- geo_detec_troncon
DELETE FROM m_reseau_detection.geo_detec_troncon
WHERE m_reseau_detection.geo_detec_troncon.idobjdetec = OLD.idobjdetec;

-- an_detec_reseau
DELETE FROM m_reseau_detection.an_detec_reseau
WHERE m_reseau_detection.an_detec_reseau.idobjdetec = OLD.idobjdetec;


RETURN NEW;
           
END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

COMMENT ON FUNCTION m_reseau_detection.ft_m_geo_v_detec_troncon_res() IS 'Fonction trigger pour mise à jour des entités depuis la vue de gestion des tronçons de réseau détectés';


-- Trigger: t_t1_geo_v_detec_troncon_res on m_reseau_detection.detec_troncon_res

-- DROP TRIGGER t_t1_detec_troncon_res ON m_reseau_detection.detec_troncon_res;

CREATE TRIGGER t_t1_geo_v_detec_troncon_res
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON m_reseau_detection.geo_v_detec_troncon_res
  FOR EACH ROW
  EXECUTE PROCEDURE m_reseau_detection.ft_m_geo_v_detec_troncon_res();
  
  

-- #################################################################### FONCTION TRIGGER - GEO_V_NOEUD_RES ###################################################

-- Function: m_reseau_detection.ft_m_geo_v_detec_noeud_res()

-- DROP FUNCTION m_reseau_detection.ft_m_geo_v_detec_noeud_res();

CREATE OR REPLACE FUNCTION m_reseau_detection.ft_m_geo_v_detec_noeud_res()
  RETURNS trigger AS
$BODY$

--déclaration variable pour stocker la séquence des id
DECLARE v_idobjdetec character varying(254);

BEGIN

-- INSERT
IF (TG_OP = 'INSERT') THEN

v_idobjdetec := nextval('m_reseau_detection.an_detec_reseau_id_seq'::regclass);

-- an_detec_reseau
INSERT INTO m_reseau_detection.an_detec_reseau (idobjdetec, idobjope, refope, refobjope, insee, natres, statut, clprecxy, clprecz, clprec, date_sai, date_maj)
SELECT v_idobjdetec,
CONCAT(NEW.refope,'-',NEW.refobjope),
NEW.refope,
NEW.refobjope,
CASE WHEN NEW.insee IS NULL THEN (SELECT insee FROM r_osm.geo_vm_osm_commune_arc WHERE st_intersects(NEW.geom,geom)) ELSE NEW.insee END,
CASE WHEN NEW.natres IS NULL THEN '00' ELSE NEW.natres END,
CASE WHEN NEW.statut IS NULL THEN '00' ELSE NEW.statut END,
CASE WHEN NEW.clprecxy IS NULL THEN 'C' ELSE NEW.clprecxy END,
CASE WHEN NEW.clprecz IS NULL THEN 'C' ELSE NEW.clprecz END,
CASE WHEN (NEW.clprecxy = 'A' AND NEW.clprecz = 'A') THEN 'A' WHEN ((NEW.clprecxy IN ('A','B')) AND (NEW.clprecz = 'B')) THEN 'B' WHEN (NEW.clprecxy = 'B' AND NEW.clprecz IN ('A','B')) THEN 'B' ELSE 'C' END,
now(),
NULL;

-- geo_detec_noeud
INSERT INTO m_reseau_detection.geo_detec_noeud (idobjdetec, typeaffleu, symbnom, symbangle, symblong, symblarg, geom)
SELECT v_idobjdetec,
NEW.typeaffleu,
NEW.symbnom,
CASE WHEN NEW.symbangle >= 360 THEN NEW.symbangle - 360 ELSE NEW.symbangle END,
NEW.symblong,
NEW.symblarg,
CASE WHEN (SELECT geom FROM m_reseau_detection.geo_detec_operation WHERE (st_contains(st_buffer(geom,0.1),NEW.geom)) AND NEW.refope = refope) IS NOT NULL THEN NEW.geom ELSE NULL END;

RETURN NEW;


-- UPDATE
ELSIF (TG_OP = 'UPDATE') THEN

-- an_detec_reseau
UPDATE
m_reseau_detection.an_detec_reseau
SET
idobjdetec=OLD.idobjdetec,
idobjope=CONCAT(NEW.refope,'-',NEW.refobjope),
refope=NEW.refope,
refobjope=NEW.refobjope,
insee=CASE WHEN NEW.insee IS NULL THEN (SELECT insee FROM r_osm.geo_vm_osm_commune_arc WHERE st_intersects(NEW.geom,geom)) ELSE NEW.insee END,
natres=CASE WHEN NEW.natres IS NULL THEN '00' ELSE NEW.natres END,
statut=CASE WHEN NEW.statut IS NULL THEN '00' ELSE NEW.statut END,
clprecxy=CASE WHEN NEW.clprecxy IS NULL THEN 'C' ELSE NEW.clprecxy END,
clprecz=CASE WHEN NEW.clprecz IS NULL THEN 'C' ELSE NEW.clprecz END,
clprec=CASE WHEN (NEW.clprecxy = 'A' AND NEW.clprecz = 'A') THEN 'A' WHEN ((NEW.clprecxy IN ('A','B')) AND (NEW.clprecz = 'B')) THEN 'B' WHEN (NEW.clprecxy = 'B' AND NEW.clprecz IN ('A','B')) THEN 'B' ELSE 'C' END,
date_sai=OLD.date_sai,
date_maj=now()
WHERE m_reseau_detection.an_detec_reseau.idobjdetec = OLD.idobjdetec;

-- geo_detec_noeud
UPDATE
m_reseau_detection.geo_detec_noeud
SET
idobjdetec=OLD.idobjdetec,
typeaffleu=NEW.typeaffleu,
symbnom=NEW.symbnom,
symbangle=CASE WHEN NEW.symbangle >= 360 THEN (NEW.symbangle - 360) ELSE NEW.symbangle END,
symblong=NEW.symblong,
symblarg=NEW.symblarg,
geom=CASE WHEN (SELECT geom FROM m_reseau_detection.geo_detec_operation WHERE (st_contains(st_buffer(geom,0.1),NEW.geom)) AND NEW.refope = refope) IS NOT NULL THEN NEW.geom ELSE NULL END
WHERE m_reseau_detection.geo_detec_noeud.idobjdetec = OLD.idobjdetec;

RETURN NEW;


-- DELETE
ELSIF (TG_OP = 'DELETE') THEN

-- geo_detec_noeud
DELETE FROM m_reseau_detection.geo_detec_noeud
WHERE m_reseau_detection.geo_detec_noeud.idobjdetec = OLD.idobjdetec;

-- an_detec_reseau
DELETE FROM m_reseau_detection.an_detec_reseau
WHERE m_reseau_detection.an_detec_reseau.idobjdetec = OLD.idobjdetec;


RETURN NEW;
           
END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

COMMENT ON FUNCTION m_reseau_detection.ft_m_geo_v_detec_noeud_res() IS 'Fonction trigger pour mise à jour des entités depuis la vue de gestion des noeuds de réseau détectés';


-- Trigger: t_t1_geo_v_detec_noeud_res on m_reseau_detection.detec_noeud_res

-- DROP TRIGGER t_t1_detec_noeud_res ON m_reseau_detection.detec_noeud_res;

CREATE TRIGGER t_t1_geo_v_detec_noeud_res
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON m_reseau_detection.geo_v_detec_noeud_res
  FOR EACH ROW
  EXECUTE PROCEDURE m_reseau_detection.ft_m_geo_v_detec_noeud_res();
  

  
-- #################################################################### FONCTION TRIGGER - GEO_DETEC_POINT ###################################################

-- Function: m_reseau_detection.ft_m_geo_detec_point()

-- DROP FUNCTION m_reseau_detection.ft_m_geo_detec_point();

CREATE OR REPLACE FUNCTION m_reseau_detection.ft_m_geo_detec_point()
  RETURNS trigger AS
$BODY$

--déclaration variable pour stocker la séquence des id
DECLARE v_idptdetec character varying(254);

BEGIN

-- INSERT
IF (TG_OP = 'INSERT') THEN

NEW.idptope = CONCAT(NEW.refope,'-',NEW.refptope);
NEW.insee=(SELECT insee FROM r_osm.geo_vm_osm_commune_arc WHERE st_intersects(NEW.geom,geom));
NEW.x=st_x(NEW.geom);
NEW.y=st_y(NEW.geom);
-- simplification ici car si réseau souple la classe A est <0.5 et non 0.4 comme pour une canalisation rigide. De même, règles différentes pour les branchements
NEW.clprecxy=CASE WHEN NEW.precxy <= 0.4 THEN 'A' WHEN NEW.precxy > 0.4 AND NEW.precxy < 1.5 THEN 'B' ELSE 'C' END;
NEW.clprecz=CASE WHEN NEW.preczgn <= 0.4 THEN 'A' WHEN NEW.preczgn > 0.4 AND NEW.preczgn < 1.5 THEN 'B' ELSE 'C' END;
NEW.clprec=CASE WHEN (NEW.clprecxy = 'A' AND NEW.clprecz = 'A') THEN 'A' WHEN ((NEW.clprecxy IN ('A','B')) AND (NEW.clprecz = 'B')) THEN 'B' WHEN (NEW.clprecxy = 'B' AND NEW.clprecz IN ('A','B')) THEN 'B' ELSE 'C' END;
NEW.date_sai=now();
NEW.date_maj=NULL;
NEW.geom=CASE WHEN (SELECT geom FROM m_reseau_detection.geo_detec_operation WHERE (st_contains(st_buffer(geom,0.1),NEW.geom)) AND NEW.refope = refope) IS NOT NULL THEN NEW.geom ELSE NULL END;

RETURN NEW;


-- UPDATE
ELSIF (TG_OP = 'UPDATE') THEN

NEW.idptdetec=OLD.idptdetec;
NEW.idptope = CONCAT(NEW.refope,'-',NEW.refptope);
NEW.insee=(SELECT insee FROM r_osm.geo_vm_osm_commune_arc WHERE st_intersects(NEW.geom,geom));
NEW.x=st_x(NEW.geom);
NEW.y=st_y(NEW.geom);
NEW.clprecxy=CASE WHEN NEW.precxy <= 0.4 THEN 'A' WHEN NEW.precxy > 0.4 AND NEW.precxy < 1.5 THEN 'B' ELSE 'C' END;
NEW.clprecz=CASE WHEN NEW.preczgn <= 0.4 THEN 'A' WHEN NEW.preczgn > 0.4 AND NEW.preczgn < 1.5 THEN 'B' ELSE 'C' END;
NEW.clprec=CASE WHEN (NEW.clprecxy = 'A' AND NEW.clprecz = 'A') THEN 'A' WHEN ((NEW.clprecxy IN ('A','B')) AND (NEW.clprecz = 'B')) THEN 'B' WHEN (NEW.clprecxy = 'B' AND NEW.clprecz IN ('A','B')) THEN 'B' ELSE 'C' END;
NEW.horodatage=OLD.horodatage;
NEW.date_sai=OLD.date_sai;
NEW.date_maj=now();
NEW.geom=CASE WHEN (SELECT geom FROM m_reseau_detection.geo_detec_operation WHERE (st_contains(st_buffer(geom,0.1),NEW.geom)) AND NEW.refope = refope) IS NOT NULL THEN NEW.geom ELSE NULL END;

RETURN NEW;
          
END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

COMMENT ON FUNCTION m_reseau_detection.ft_m_geo_detec_point() IS 'Fonction trigger pour mise à jour des entités depuis la classe des points de réseau détectés';


-- Trigger: t_t1_geo_detec_point on m_reseau_detection.geo_detec_point

-- DROP TRIGGER t_t1_geo_detec_point ON m_reseau_detection.geo_detec_point;

CREATE TRIGGER t_t1_geo_detec_point
  BEFORE INSERT OR UPDATE
  ON m_reseau_detection.geo_detec_point
  FOR EACH ROW
  EXECUTE PROCEDURE m_reseau_detection.ft_m_geo_detec_point();
  
  

-- #################################################################### FONCTION TRIGGER - GEO_DETEC_EXCLUSION ###################################################

-- Function: m_reseau_detection.ft_m_geo_detec_exclusion()

-- DROP FUNCTION m_reseau_detection.ft_m_geo_detec_exclusion();

CREATE OR REPLACE FUNCTION m_reseau_detection.ft_m_geo_detec_exclusion()
  RETURNS trigger AS
$BODY$

--déclaration variable pour stocker la séquence des id
DECLARE v_idexcdetec character varying(254);

BEGIN

-- INSERT
IF (TG_OP = 'INSERT') THEN

NEW.sup_m2=round(st_area(NEW.geom));
NEW.date_sai=now();
NEW.date_maj=NULL;
NEW.geom=CASE WHEN (SELECT geom FROM m_reseau_detection.geo_detec_operation WHERE (st_contains(st_buffer(geom,0.1),NEW.geom)) AND NEW.refope = refope) IS NOT NULL THEN NEW.geom ELSE NULL END;

RETURN NEW;


-- UPDATE
ELSIF (TG_OP = 'UPDATE') THEN

NEW.idexcdetec=OLD.idexcdetec;
NEW.sup_m2=round(st_area(NEW.geom));
NEW.date_sai=OLD.date_sai;
NEW.date_maj=now();
NEW.geom=CASE WHEN (SELECT geom FROM m_reseau_detection.geo_detec_operation WHERE (st_contains(st_buffer(geom,0.1),NEW.geom)) AND NEW.refope = refope) IS NOT NULL THEN NEW.geom ELSE NULL END;

RETURN NEW;
          
END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

COMMENT ON FUNCTION m_reseau_detection.ft_m_geo_detec_exclusion() IS 'Fonction trigger pour mise à jour des entités depuis la classe des secteurs d''exclusion de détection des réseaux';

-- Trigger: t_t1_geo_detec_exclusion on m_reseau_detection.geo_detec_exclusion

-- DROP TRIGGER t_t1_geo_detec_exclusion ON m_reseau_detection.geo_detec_exclusion;

CREATE TRIGGER t_t1_geo_detec_exclusion
  BEFORE INSERT OR UPDATE
  ON m_reseau_detection.geo_detec_exclusion
  FOR EACH ROW
  EXECUTE PROCEDURE m_reseau_detection.ft_m_geo_detec_exclusion();
  

  
-- #################################################################### FONCTION TRIGGER - GEO_DETEC_OPERATION ###################################################

-- Function: m_reseau_detection.ft_m_geo_detec_operation()

-- DROP FUNCTION m_reseau_detection.ft_m_geo_detec_operation();

CREATE OR REPLACE FUNCTION m_reseau_detection.ft_m_geo_detec_operation()
  RETURNS trigger AS
$BODY$

--déclaration variable pour stocker la séquence des id
DECLARE v_idopedetec character varying(254);

BEGIN

-- INSERT
IF (TG_OP = 'INSERT') THEN

NEW.sup_m2=round(st_area(NEW.geom));
NEW.date_sai=now();
NEW.date_maj=NULL;

RETURN NEW;


-- UPDATE
ELSIF (TG_OP = 'UPDATE') THEN

NEW.idopedetec=OLD.idopedetec;
NEW.sup_m2=round(st_area(NEW.geom));
NEW.date_sai=OLD.date_sai;
NEW.date_maj=now();
-- revoir code. fonctionne pour référence à 1 seule et unique classe tierce, mais pas si on en référence plusieurs (exclusion, pt levé, noeud, troncon ...)
--NEW.geom=CASE WHEN (SELECT ST_Union(geom) FROM m_reseau_detection.geo_detec_exclusion e, m_reseau_detection.geo_v_detec_troncon_res t WHERE ((st_contains(st_buffer(NEW.geom,0.1),e.geom) AND NEW.refope = e.refope) IS NOT NULL AND (st_contains(st_buffer(NEW.geom,0.1),t.geom) AND NEW.refope = t.refope) IS NOT NULL)) THEN NEW.geom ELSE NULL END;

RETURN NEW;
          
END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

COMMENT ON FUNCTION m_reseau_detection.ft_m_geo_detec_operation() IS 'Fonction trigger pour mise à jour des entités depuis la classe des opérations de détection des réseaux';

-- Trigger: t_t1_geo_detec_operation on m_reseau_detection.geo_detec_operation

-- DROP TRIGGER t_t1_geo_detec_operation ON m_reseau_detection.geo_detec_operation;

CREATE TRIGGER t_t1_geo_detec_operation
  BEFORE INSERT OR UPDATE
  ON m_reseau_detection.geo_detec_operation
  FOR EACH ROW
  EXECUTE PROCEDURE m_reseau_detection.ft_m_geo_detec_operation();
  
  

        
