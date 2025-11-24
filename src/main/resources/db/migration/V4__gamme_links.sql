-- Flyway V4: liaisons gamme_etudiant

CREATE TABLE IF NOT EXISTS gamme_etudiant_module (
  id INT PRIMARY KEY,
  id_Gamme_Etudiant INT,
  id_module INT,
  CONSTRAINT fk_gem_gamme FOREIGN KEY (id_Gamme_Etudiant) REFERENCES gamme_etudiant(id),
  CONSTRAINT fk_gem_module FOREIGN KEY (id_module) REFERENCES module(id_module)
);


