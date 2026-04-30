-- V13 : s'assurer que les 4 profils de formation (UI inscription) existent.
-- Idempotent : ne duplique pas si le code (C001–C004) existe déjà.
-- Référence : même logique que V5__seed_data.sql (Entrepreneur, Etudiant, Famille, Académique).

INSERT INTO gamme_etudiant (code, nom, description, state)
SELECT 'C001', 'Entrepreneur', 'Profil entrepreneur / porteur de projet', 1
WHERE NOT EXISTS (SELECT 1 FROM gamme_etudiant WHERE code = 'C001');

INSERT INTO gamme_etudiant (code, nom, description, state)
SELECT 'C002', 'Etudiant', 'Profil étudiant', 1
WHERE NOT EXISTS (SELECT 1 FROM gamme_etudiant WHERE code = 'C002');

INSERT INTO gamme_etudiant (code, nom, description, state)
SELECT 'C003', 'Famille', 'Profil représentant famille', 1
WHERE NOT EXISTS (SELECT 1 FROM gamme_etudiant WHERE code = 'C003');

INSERT INTO gamme_etudiant (code, nom, description, state)
SELECT 'C004', 'Académique', 'Profil académique / professionnel', 1
WHERE NOT EXISTS (SELECT 1 FROM gamme_etudiant WHERE code = 'C004');
