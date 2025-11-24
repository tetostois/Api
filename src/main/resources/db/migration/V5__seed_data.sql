-- Flyway V5: données de référence minimales

-- Gamme Etudiant (profils)
INSERT INTO gamme_etudiant (code, nom, description, state)
VALUES 
  ('C001', 'Entrepreneur', 'Profil entrepreneur / porteur de projet', 1),
  ('C002', 'Etudiant', 'Profil étudiant', 1),
  ('C003', 'Famille', 'Profil représentant famille', 1),
  ('C004', 'Académique', 'Profil académique / professionnel', 1);

-- Régions (Cameroun) – ajustez si besoin
INSERT INTO region (code, description, nom) VALUES 
  ('RG-CE', NULL, 'Centre'),
  ('RG-LT', NULL, 'Littoral'),
  ('RG-OU', NULL, 'Ouest'),
  ('RG-NO', NULL, 'Nord-Ouest'),
  ('RG-SO', NULL, 'Sud-Ouest'),
  ('RG-AD', NULL, 'Adamaoua'),
  ('RG-EN', NULL, 'Extrême-Nord'),
  ('RG-NR', NULL, 'Nord'),
  ('RG-SD', NULL, 'Sud'),
  ('RG-ES', NULL, 'Est');


