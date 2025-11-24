-- Flyway V1: schéma minimal initial pour débloquer l'application

CREATE TABLE IF NOT EXISTS region (
  id INT PRIMARY KEY AUTO_INCREMENT,
  code VARCHAR(255),
  description LONGTEXT,
  nom VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS gamme_etudiant (
  id INT PRIMARY KEY AUTO_INCREMENT,
  code VARCHAR(255),
  description LONGTEXT,
  nom VARCHAR(255),
  state INT
);

CREATE TABLE IF NOT EXISTS rubrique (
  id INT PRIMARY KEY AUTO_INCREMENT,
  categorie VARCHAR(255),
  date DATETIME,
  description LONGTEXT,
  etat INT,
  nom LONGTEXT,
  ordre INT,
  statut VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS article (
  id INT PRIMARY KEY AUTO_INCREMENT,
  auteur LONGTEXT,
  categorie VARCHAR(255),
  date DATETIME,
  date_publication DATETIME,
  date_modification DATETIME,
  etat INT,
  nombre_vue INT,
  image_URL LONGTEXT,
  lien VARCHAR(255),
  sous_titre LONGTEXT,
  statut VARCHAR(255),
  texte LONGTEXT,
  titre LONGTEXT,
  sur_titre LONGTEXT,
  titre_auteur LONGTEXT,
  type LONGTEXT,
  video_URL LONGTEXT,
  id_rubrique INT,
  CONSTRAINT fk_article_rubrique FOREIGN KEY (id_rubrique) REFERENCES rubrique(id)
);

CREATE TABLE IF NOT EXISTS image_article (
  id INT PRIMARY KEY AUTO_INCREMENT,
  image_data LONGBLOB,
  nom LONGTEXT,
  titre LONGTEXT,
  date DATETIME,
  type LONGTEXT,
  id_article INT,
  CONSTRAINT fk_image_article_article FOREIGN KEY (id_article) REFERENCES article(id)
);

CREATE TABLE IF NOT EXISTS etudiant (
  id INT PRIMARY KEY AUTO_INCREMENT,
  date_inscription DATETIME,
  date_naissance DATE,
  email VARCHAR(255) UNIQUE,
  last_connexion DATETIME,
  statut INT,
  lieu_naissance VARCHAR(255),
  matricule VARCHAR(255) UNIQUE,
  nom VARCHAR(255),
  password VARCHAR(255),
  password_clear VARCHAR(255),
  prenom VARCHAR(255),
  telephone VARCHAR(255) UNIQUE,
  profession VARCHAR(255),
  chiffre_affaire FLOAT,
  nom_entreprise VARCHAR(255),
  id_Gamme_Etudiant INT,
  id_Region INT,
  date_confiramtion DATETIME,
  lien_confirmation VARCHAR(255),
  code_change_password VARCHAR(255),
  confirmation INT,
  CONSTRAINT fk_etudiant_region FOREIGN KEY (id_Region) REFERENCES region(id),
  CONSTRAINT fk_etudiant_gamme FOREIGN KEY (id_Gamme_Etudiant) REFERENCES gamme_etudiant(id)
);

CREATE TABLE IF NOT EXISTS information (
  id INT PRIMARY KEY AUTO_INCREMENT,
  amelioration_durant LONGTEXT,
  annee_entreprise INT,
  annee_experience INT,
  autre_commentaire LONGTEXT,
  bien_fonde_universitaire LONGTEXT,
  chiffre_affaire LONGTEXT,
  connaissance_marche_local LONGTEXT,
  definition_entrepreneuriat LONGTEXT,
  departement LONGTEXT,
  disposer_accompagnement LONGTEXT,
  domaine_activite LONGTEXT,
  domaine_famille LONGTEXT,
  entreprise_creer LONGTEXT,
  etudiant_entrepreneur LONGTEXT,
  faculte LONGTEXT,
  filiere LONGTEXT,
  fonction LONGTEXT,
  format_formation LONGTEXT,
  grade LONGTEXT,
  idee_projet LONGTEXT,
  marche_cible LONGTEXT,
  menbre_famille INT,
  motivation LONGTEXT,
  niveau_academique LONGTEXT,
  niveau_connaissance LONGTEXT,
  niveau_connexion LONGTEXT,
  niveau_etude_famille LONGTEXT,
  nom_entreprise LONGTEXT,
  nombre_entrepreneur_famille LONGTEXT,
  obstacle_famille LONGTEXT,
  preference_horaire LONGTEXT,
  profession LONGTEXT,
  secteur_activite LONGTEXT,
  sexe LONGTEXT,
  souhait_acquisition_durant LONGTEXT,
  souhait_acquisition_fin LONGTEXT,
  souhait_formation LONGTEXT,
  taille_entreprise LONGTEXT,
  tranche_age LONGTEXT,
  universite LONGTEXT,
  id_etudiant INT,
  CONSTRAINT fk_information_etudiant FOREIGN KEY (id_etudiant) REFERENCES etudiant(id)
);

