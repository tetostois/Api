-- V14 : comptes de démonstration (1 étudiant par profil gamme C001–C004).
-- Connexion : email ou téléphone + mot de passe en clair demo1234 (hash MD5+sell comme Cryptage.java).
-- Idempotent : pas d’insert si email ou matricule existe déjà.

-- Entrepreneur (C001)
INSERT INTO etudiant (
  date_inscription, date_naissance, email, last_connexion, statut, lieu_naissance,
  matricule, nom, password, password_clear, prenom, telephone, profession,
  chiffre_affaire, nom_entreprise, id_Gamme_Etudiant, id_Region,
  date_confiramtion, lien_confirmation, code_change_password, confirmation
)
SELECT
  NOW(), DATE '1995-01-15', 'seed-entrepreneur@example.com', NOW(), 1, 'Yaounde',
  '88IRI9001', 'Demo', MD5(CONCAT('demo1234', 'e@l#e$a%r^n&i*n(g')), 'demo1234', 'Entrepreneur',
  '+237 610 001 001', 'Demo', 0, 'Demo', (SELECT id FROM gamme_etudiant WHERE code = 'C001' LIMIT 1),
  (SELECT MIN(id) FROM region), NOW(), NULL, NULL, 1
WHERE NOT EXISTS (
  SELECT 1 FROM etudiant WHERE email = 'seed-entrepreneur@example.com' OR matricule = '88IRI9001'
);

-- Etudiant (C002)
INSERT INTO etudiant (
  date_inscription, date_naissance, email, last_connexion, statut, lieu_naissance,
  matricule, nom, password, password_clear, prenom, telephone, profession,
  chiffre_affaire, nom_entreprise, id_Gamme_Etudiant, id_Region,
  date_confiramtion, lien_confirmation, code_change_password, confirmation
)
SELECT
  NOW(), DATE '1996-02-20', 'seed-etudiant@example.com', NOW(), 1, 'Douala',
  '88IRI9002', 'Demo', MD5(CONCAT('demo1234', 'e@l#e$a%r^n&i*n(g')), 'demo1234', 'Etudiant',
  '+237 610 001 002', 'Etudiant', 0, NULL, (SELECT id FROM gamme_etudiant WHERE code = 'C002' LIMIT 1),
  (SELECT MIN(id) FROM region), NOW(), NULL, NULL, 1
WHERE NOT EXISTS (
  SELECT 1 FROM etudiant WHERE email = 'seed-etudiant@example.com' OR matricule = '88IRI9002'
);

-- Famille (C003)
INSERT INTO etudiant (
  date_inscription, date_naissance, email, last_connexion, statut, lieu_naissance,
  matricule, nom, password, password_clear, prenom, telephone, profession,
  chiffre_affaire, nom_entreprise, id_Gamme_Etudiant, id_Region,
  date_confiramtion, lien_confirmation, code_change_password, confirmation
)
SELECT
  NOW(), DATE '1988-07-10', 'seed-famille@example.com', NOW(), 1, 'Bafoussam',
  '88IRI9003', 'Demo', MD5(CONCAT('demo1234', 'e@l#e$a%r^n&i*n(g')), 'demo1234', 'Famille',
  '+237 610 001 003', 'Parent', 0, NULL, (SELECT id FROM gamme_etudiant WHERE code = 'C003' LIMIT 1),
  (SELECT MIN(id) FROM region), NOW(), NULL, NULL, 1
WHERE NOT EXISTS (
  SELECT 1 FROM etudiant WHERE email = 'seed-famille@example.com' OR matricule = '88IRI9003'
);

-- Académique (C004)
INSERT INTO etudiant (
  date_inscription, date_naissance, email, last_connexion, statut, lieu_naissance,
  matricule, nom, password, password_clear, prenom, telephone, profession,
  chiffre_affaire, nom_entreprise, id_Gamme_Etudiant, id_Region,
  date_confiramtion, lien_confirmation, code_change_password, confirmation
)
SELECT
  NOW(), DATE '1992-11-05', 'seed-academique@example.com', NOW(), 1, 'Yaounde',
  '88IRI9004', 'Demo', MD5(CONCAT('demo1234', 'e@l#e$a%r^n&i*n(g')), 'demo1234', 'Academique',
  '+237 610 001 004', 'Enseignant', 0, NULL, (SELECT id FROM gamme_etudiant WHERE code = 'C004' LIMIT 1),
  (SELECT MIN(id) FROM region), NOW(), NULL, NULL, 1
WHERE NOT EXISTS (
  SELECT 1 FROM etudiant WHERE email = 'seed-academique@example.com' OR matricule = '88IRI9004'
);
