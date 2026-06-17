-- Création de la table libelle
CREATE TABLE IF NOT EXISTS libelle (
    id INT PRIMARY KEY AUTO_INCREMENT,
    titre LONGTEXT,
    titre_en LONGTEXT,
    texte LONGTEXT,
    texte_en LONGTEXT,
    id_module INT NOT NULL,
    CONSTRAINT fk_libelle_module FOREIGN KEY (id_module) REFERENCES module(id_module) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Créer un index sur id_module pour les performances
CREATE INDEX idx_libelle_id_module ON libelle(id_module);
