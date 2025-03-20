

-- Table CHEF

CREATE TABLE CHEF (
    id_chef INT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    date_naissance DATE,
    experience_annees INT,
    telephone VARCHAR(20),
    email VARCHAR(100),
    nationalite VARCHAR(50)
);


-- Table RESTAURANT

CREATE TABLE RESTAURANT (
    id_restaurant INT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    adresse VARCHAR(255),
    ville VARCHAR(100),
    code_postal VARCHAR(20),
    pays VARCHAR(50),
    style_cuisine_principal VARCHAR(100),
    capacite_couverts INT,
    date_ouverture DATE,
    telephone VARCHAR(20),
    email VARCHAR(100),
    site_web VARCHAR(255)
);


-- Table TYPE_CUISINE

CREATE TABLE TYPE_CUISINE (
    id_type_cuisine INT PRIMARY KEY,
    libelle VARCHAR(100),
    description TEXT,
    origine_geographique VARCHAR(100)
);


-- Table MENU

CREATE TABLE MENU (
    id_menu INT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    description TEXT,
    prix DECIMAL(10,2),
    disponibilite BOOLEAN,
    saison VARCHAR(50)
);


-- Table PLAT

CREATE TABLE PLAT (
    id_plat INT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    description TEXT,
    categorie VARCHAR(100),
    prix DECIMAL(10,2),
    temps_preparation INT  -- en minutes
);


-- Table SPECIALITE

CREATE TABLE SPECIALITE (
    id_specialite INT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    description TEXT
);


-- Table EVALUATION

CREATE TABLE EVALUATION (
    id_evaluation INT PRIMARY KEY,
    date DATE,
    note DECIMAL(3,2),
    commentaire TEXT,
    source VARCHAR(100),
    id_restaurant INT,
    CONSTRAINT fk_evaluation_restaurant FOREIGN KEY (id_restaurant)
        REFERENCES RESTAURANT(id_restaurant)
);


-- Table DISTINCTION

CREATE TABLE DISTINCTION (
    id_distinction INT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    organisme VARCHAR(100),
    annee INT,
    description TEXT,
    id_specialite INT,
    id_restaurant INT,
    CONSTRAINT fk_distinction_specialite FOREIGN KEY (id_specialite)
        REFERENCES SPECIALITE(id_specialite),
    CONSTRAINT fk_distinction_restaurant FOREIGN KEY (id_restaurant)
        REFERENCES RESTAURANT(id_restaurant)
);


-- Table TRAVAILLE (association CHEF – RESTAURANT)

CREATE TABLE TRAVAILLE (
    id_chef INT,
    id_restaurant INT,
    role_principal VARCHAR(100),
    date_debut DATE,
    date_fin DATE,
    salaire DECIMAL(10,2),
    PRIMARY KEY (id_chef, id_restaurant),
    CONSTRAINT fk_travaille_chef FOREIGN KEY (id_chef)
        REFERENCES CHEF(id_chef),
    CONSTRAINT fk_travaille_restaurant FOREIGN KEY (id_restaurant)
        REFERENCES RESTAURANT(id_restaurant)
);


-- Table MAITRISER (association CHEF – TYPE_CUISINE)

CREATE TABLE MAITRISER (
    id_chef INT,
    id_type_cuisine INT,
    niveau_maitrise VARCHAR(50),
    annees_pratique INT,
    PRIMARY KEY (id_chef, id_type_cuisine),
    CONSTRAINT fk_maitriser_chef FOREIGN KEY (id_chef)
        REFERENCES CHEF(id_chef),
    CONSTRAINT fk_maitriser_type FOREIGN KEY (id_type_cuisine)
        REFERENCES TYPE_CUISINE(id_type_cuisine)
);


-- Table PROPOSER (association RESTAURANT – MENU)

CREATE TABLE PROPOSER (
    id_restaurant INT,
    id_menu INT,
    PRIMARY KEY (id_restaurant, id_menu),
    CONSTRAINT fk_proposer_restaurant FOREIGN KEY (id_restaurant)
        REFERENCES RESTAURANT(id_restaurant),
    CONSTRAINT fk_proposer_menu FOREIGN KEY (id_menu)
        REFERENCES MENU(id_menu)
);


-- Table CONTENIR (association MENU – PLAT)

CREATE TABLE CONTENIR (
    id_menu INT,
    id_plat INT,
    PRIMARY KEY (id_menu, id_plat),
    CONSTRAINT fk_contenir_menu FOREIGN KEY (id_menu)
        REFERENCES MENU(id_menu),
    CONSTRAINT fk_contenir_plat FOREIGN KEY (id_plat)
        REFERENCES PLAT(id_plat)
);


-- Table APPARTENIR (association PLAT – TYPE_CUISINE)

CREATE TABLE APPARTENIR (
    id_plat INT,
    id_type_cuisine INT,
    PRIMARY KEY (id_plat, id_type_cuisine),
    CONSTRAINT fk_appartenir_plat FOREIGN KEY (id_plat)
        REFERENCES PLAT(id_plat),
    CONSTRAINT fk_appartenir_type FOREIGN KEY (id_type_cuisine)
        REFERENCES TYPE_CUISINE(id_type_cuisine)
);


-- Table POSSEDER (association CHEF – SPECIALITE)

CREATE TABLE POSSEDER (
    id_chef INT,
    id_specialite INT,
    PRIMARY KEY (id_chef, id_specialite),
    CONSTRAINT fk_posseder_chef FOREIGN KEY (id_chef)
        REFERENCES CHEF(id_chef),
    CONSTRAINT fk_posseder_specialite FOREIGN KEY (id_specialite)
        REFERENCES SPECIALITE(id_specialite)
);


-- Table CREER (association CHEF – PLAT avec attribut)

CREATE TABLE CREER (
    id_chef INT,
    id_plat INT,
    date_creation DATE,
    PRIMARY KEY (id_chef, id_plat),
    CONSTRAINT fk_creer_chef FOREIGN KEY (id_chef)
        REFERENCES CHEF(id_chef),
    CONSTRAINT fk_creer_plat FOREIGN KEY (id_plat)
        REFERENCES PLAT(id_plat)
);

