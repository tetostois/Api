-- Flyway V2: tables cours et relations

CREATE TABLE IF NOT EXISTS module (
  id_module INT PRIMARY KEY AUTO_INCREMENT,
  date_Deblocage DATETIME,
  description LONGTEXT,
  description_en VARCHAR(255),
  etat VARCHAR(255),
  nom_image VARCHAR(255),
  titre VARCHAR(255),
  titre_en VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS chapitre (
  id_chapitre INT PRIMARY KEY AUTO_INCREMENT,
  date_ajout DATETIME,
  description LONGTEXT,
  texte LONGTEXT,
  image LONGTEXT,
  pdf LONGTEXT,
  preanbule LONGTEXT,
  qcm INT,
  ordre INT,
  titre LONGTEXT,
  etat VARCHAR(255),
  video LONGTEXT,
  id_module INT,
  CONSTRAINT fk_chapitre_module FOREIGN KEY (id_module) REFERENCES module(id_module)
);

CREATE TABLE IF NOT EXISTS chapitre_en (
  id INT PRIMARY KEY AUTO_INCREMENT,
  description LONGTEXT,
  texte LONGTEXT,
  image LONGTEXT,
  pdf LONGTEXT,
  preanbule LONGTEXT,
  qcm INT,
  titre LONGTEXT,
  video LONGTEXT,
  id_chapitre INT,
  CONSTRAINT fk_chapitre_en_chapitre FOREIGN KEY (id_chapitre) REFERENCES chapitre(id_chapitre)
);

CREATE TABLE IF NOT EXISTS bloc (
  id INT PRIMARY KEY AUTO_INCREMENT,
  image VARCHAR(255),
  texte LONGTEXT,
  titre LONGTEXT,
  video VARCHAR(255),
  id_chapitre INT,
  id_Chapitre_En INT,
  CONSTRAINT fk_bloc_chapitre FOREIGN KEY (id_chapitre) REFERENCES chapitre(id_chapitre),
  CONSTRAINT fk_bloc_chapitre_en FOREIGN KEY (id_Chapitre_En) REFERENCES chapitre_en(id)
);

CREATE TABLE IF NOT EXISTS sous_bloc (
  id INT PRIMARY KEY AUTO_INCREMENT,
  image VARCHAR(255),
  texte LONGTEXT,
  titre LONGTEXT,
  video VARCHAR(255),
  id_bloc INT,
  CONSTRAINT fk_sous_bloc_bloc FOREIGN KEY (id_bloc) REFERENCES bloc(id)
);

CREATE TABLE IF NOT EXISTS item (
  id INT PRIMARY KEY AUTO_INCREMENT,
  texte LONGTEXT,
  id_bloc INT,
  id_sous_bloc INT,
  CONSTRAINT fk_item_bloc FOREIGN KEY (id_bloc) REFERENCES bloc(id),
  CONSTRAINT fk_item_sous_bloc FOREIGN KEY (id_sous_bloc) REFERENCES sous_bloc(id)
);

CREATE TABLE IF NOT EXISTS qcm (
  id INT PRIMARY KEY AUTO_INCREMENT,
  description LONGTEXT,
  intitule LONGTEXT,
  intitule_en LONGTEXT,
  note LONGTEXT,
  id_chapitre INT,
  CONSTRAINT fk_qcm_chapitre FOREIGN KEY (id_chapitre) REFERENCES chapitre(id_chapitre)
);

CREATE TABLE IF NOT EXISTS proposition (
  id INT PRIMARY KEY AUTO_INCREMENT,
  etat INT,
  valeur LONGTEXT,
  valeur_en LONGTEXT,
  id_QCM INT,
  CONSTRAINT fk_proposition_qcm FOREIGN KEY (id_QCM) REFERENCES qcm(id)
);

CREATE TABLE IF NOT EXISTS question_cour (
  id INT PRIMARY KEY AUTO_INCREMENT,
  date DATETIME,
  texte LONGTEXT,
  id_chapitre INT,
  id_Etudiant INT,
  id_module INT,
  CONSTRAINT fk_question_chapitre FOREIGN KEY (id_chapitre) REFERENCES chapitre(id_chapitre),
  CONSTRAINT fk_question_module FOREIGN KEY (id_module) REFERENCES module(id_module),
  CONSTRAINT fk_question_etudiant FOREIGN KEY (id_Etudiant) REFERENCES etudiant(id)
);

CREATE TABLE IF NOT EXISTS reponse (
  id INT PRIMARY KEY AUTO_INCREMENT,
  date DATETIME,
  texte LONGTEXT,
  id_Professeur INT,
  id_Question_cour INT,
  CONSTRAINT fk_reponse_question FOREIGN KEY (id_Question_cour) REFERENCES question_cour(id)
);

CREATE TABLE IF NOT EXISTS etudiant_chapitre (
  id INT PRIMARY KEY AUTO_INCREMENT,
  etat VARCHAR(255),
  qcm_valide INT,
  id_chapitre INT,
  id_etudiant INT,
  date_debut DATETIME,
  date_validation_qcm DATETIME,
  CONSTRAINT fk_etudiant_chapitre_chapitre FOREIGN KEY (id_chapitre) REFERENCES chapitre(id_chapitre),
  CONSTRAINT fk_etudiant_chapitre_etudiant FOREIGN KEY (id_etudiant) REFERENCES etudiant(id)
);

CREATE TABLE IF NOT EXISTS etudiant_module (
  id INT PRIMARY KEY AUTO_INCREMENT,
  id_etudiant INT,
  id_module INT,
  date_debut DATETIME,
  CONSTRAINT fk_etudiant_module_etudiant FOREIGN KEY (id_etudiant) REFERENCES etudiant(id),
  CONSTRAINT fk_etudiant_module_module FOREIGN KEY (id_module) REFERENCES module(id_module)
);

CREATE TABLE IF NOT EXISTS qro (
  id INT PRIMARY KEY AUTO_INCREMENT,
  intitule LONGTEXT,
  intitule_en LONGTEXT,
  note LONGTEXT,
  id_chapitre INT,
  CONSTRAINT fk_qro_chapitre FOREIGN KEY (id_chapitre) REFERENCES chapitre(id_chapitre)
);

CREATE TABLE IF NOT EXISTS qro_etudiant (
  id INT PRIMARY KEY AUTO_INCREMENT,
  date_ajout DATETIME,
  date_modification DATETIME,
  reponse LONGTEXT,
  id_Etudiant INT,
  id_QRO INT,
  CONSTRAINT fk_qro_etudiant_etudiant FOREIGN KEY (id_Etudiant) REFERENCES etudiant(id),
  CONSTRAINT fk_qro_etudiant_qro FOREIGN KEY (id_QRO) REFERENCES qro(id)
);


