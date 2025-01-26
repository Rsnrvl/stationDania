-- Séquence pour la table commune
CREATE SEQUENCE seq_commune
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
----Table commune
CREATE TABLE commune (
    id VARCHAR2(50) PRIMARY KEY,
    nom VARCHAR2(100) NOT NULL,
    mdp VARCHAR2(100) NOT NULL
);

-- Séquence pour la table arrondissemnt
CREATE SEQUENCE seq_arrondissement
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
-- Table for arrondissements
CREATE TABLE arrondissement (
    id VARCHAR2(50) PRIMARY KEY,
    nom VARCHAR2(100) NOT NULL,
    geom SDO_GEOMETRY,
    idCommune VARCHAR2(100) REFERENCES commune(id)
);

-- Séquence pour la table tafp
CREATE SEQUENCE seq_tafo
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
--Table tafo
CREATE TABLE tafo (
    id VARCHAR2(50) PRIMARY KEY,
    nom VARCHAR2(100) NOT NULL,
    coefficient NUMBER(6,3)  NOT NULL
);

-- Séquence pour la table rindrina
CREATE SEQUENCE seq_rindrina
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
--Table rindirna
CREATE TABLE rindrina (
    id VARCHAR2(50) PRIMARY KEY,
    nom VARCHAR2(100) NOT NULL,
    coefficient NUMBER(6,3)  NOT NULL
);

-- Séquence pour la table proprietaire
CREATE SEQUENCE seq_proprietaire
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
--Table proprio
CREATE TABLE proprietaire (
    id VARCHAR2(50) PRIMARY KEY,
    nom VARCHAR2(100) NOT NULL
);

-- Séquence pour la table taxe
CREATE SEQUENCE seq_taxe
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
--Table taxe
CREATE TABLE taxe (
   id VARCHAR2(50) PRIMARY KEY,
   prix NUMBER(10,2)  NOT NULL,
   idCommune VARCHAR2(100) REFERENCES commune(id)
);

-- Séquence pour la table maison
CREATE SEQUENCE seq_maison
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

--Table maison
CREATE TABLE maison(
    id VARCHAR2(50) PRIMARY KEY,
    longitude NUMBER(10,6),
    lattitude NUMBER(10,6),
    longueur NUMBER(10,2),
    largeur NUMBER(10,2),
    etage NUMBER(2) DEFAULT 1 CHECK (etage >= 1),
    geom SDO_GEOMETRY,
    idProprietaire VARCHAR2(100) REFERENCES proprietaire(id),
    idArrondissement VARCHAR2(100) REFERENCES arrondissement(id),
    idTafo VARCHAR2(100) REFERENCES tafo(id),
    idRindrina VARCHAR2(100) REFERENCES rindrina(id)
);


-- Séquence pour la table facture
CREATE SEQUENCE seq_facture
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE facture(
    id VARCHAR2(50) PRIMARY KEY,
    mois NUMBER(2) NOT NULL CHECK (mois BETWEEN 1 AND 12), 
    annee NUMBER(4) NOT NULL,
    surfaceTotale NUMBER(10,2),
    idTafo VARCHAR2(100) REFERENCES tafo(id),
    coefficientTafo NUMBER(6,3) REFERENCES tafo(coefficient),
    idRindrina VARCHAR2(100) REFERENCES rindrina(id),
    coefficientRindrina NUMBER(6,3) REFERENCES rindrina(coefficient),
    statut INTEGER,
    puTrano NUMBER(10,2),
    puTaxe NUMBER(10,2),
    idMaison VARCHAR2(50) REFERENCES maison(id)
);

-- Séquence pour la table detail_facture
CREATE SEQUENCE seq_detail_facture
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE detail_facture (
    id VARCHAR2(50),
    montantTotal NUMBER(10,2),
    idFacture VARCHAR2(50) REFERENCES facture(id),
    idProprietaire VARCHAR2(50) REFERENCES proprietaire(id)
);

INSERT INTO user_sdo_geom_metadata (
    TABLE_NAME,
    COLUMN_NAME,
    DIMINFO,
    SRID
) VALUES (
    'ARRONDISSEMENT',
    'GEOM',
    SDO_DIM_ARRAY(
        SDO_DIM_ELEMENT('Longitude', -180, 180, 0.005),
        SDO_DIM_ELEMENT('Latitude', -90, 90, 0.005)
    ),
    4326
);

INSERT INTO user_sdo_geom_metadata (
    TABLE_NAME,
    COLUMN_NAME,
    DIMINFO,
    SRID
) VALUES (
    'MAISON',
    'GEOM',
    SDO_DIM_ARRAY(
        SDO_DIM_ELEMENT('Longitude', -180, 180, 0.005),
        SDO_DIM_ELEMENT('Latitude', -90, 90, 0.005)
    ),
    4326
);

-- Create spatial index for maison
CREATE INDEX maison_spatial_idx ON maison(geom) 
INDEXTYPE IS MDSYS.SPATIAL_INDEX;

-- Create spatial index for arrondissement
CREATE INDEX maison_spatial_idx ON arrondissement(geom) 
INDEXTYPE IS MDSYS.SPATIAL_INDEX;