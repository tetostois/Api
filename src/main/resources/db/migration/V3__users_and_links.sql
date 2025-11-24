-- Flyway V3: utilisateurs, liaisons et messages

CREATE TABLE IF NOT EXISTS professeur (
  id INT PRIMARY KEY AUTO_INCREMENT,
  email LONGTEXT,
  etat VARCHAR(255),
  date_inscription DATETIME,
  last_connexion DATETIME,
  matricule VARCHAR(255),
  nom LONGTEXT,
  password LONGTEXT,
  prenom LONGTEXT,
  profession LONGTEXT,
  telephone LONGTEXT,
  id_Region INT,
  CONSTRAINT fk_prof_region FOREIGN KEY (id_Region) REFERENCES region(id)
);

CREATE TABLE IF NOT EXISTS admin (
  id INT PRIMARY KEY AUTO_INCREMENT,
  email LONGTEXT,
  etat INT,
  level INT,
  nom LONGTEXT,
  password LONGTEXT,
  prenom LONGTEXT,
  statut VARCHAR(255),
  telephone LONGTEXT
);

CREATE TABLE IF NOT EXISTS professeur_module (
  id INT PRIMARY KEY AUTO_INCREMENT,
  Moduleid_module INT,
  Professeurid INT,
  CONSTRAINT fk_prof_module_module FOREIGN KEY (Moduleid_module) REFERENCES module(id_module),
  CONSTRAINT fk_prof_module_prof FOREIGN KEY (Professeurid) REFERENCES professeur(id)
);

CREATE TABLE IF NOT EXISTS gamme_etudiant_professeur (
  id INT PRIMARY KEY,
  id_Gamme_Etudiant INT,
  id_Professeur INT,
  CONSTRAINT fk_gep_gamme FOREIGN KEY (id_Gamme_Etudiant) REFERENCES gamme_etudiant(id),
  CONSTRAINT fk_gep_prof FOREIGN KEY (id_Professeur) REFERENCES professeur(id)
);

CREATE TABLE IF NOT EXISTS message (
  id INT PRIMARY KEY AUTO_INCREMENT,
  date DATETIME,
  etat VARCHAR(255),
  texte LONGTEXT,
  id_admin INT,
  id_Etudiant INT,
  id_Message_parent INT,
  id_Professeur INT,
  CONSTRAINT fk_message_admin FOREIGN KEY (id_admin) REFERENCES admin(id),
  CONSTRAINT fk_message_etudiant FOREIGN KEY (id_Etudiant) REFERENCES etudiant(id),
  CONSTRAINT fk_message_parent FOREIGN KEY (id_Message_parent) REFERENCES message(id),
  CONSTRAINT fk_message_professeur FOREIGN KEY (id_Professeur) REFERENCES professeur(id)
);


