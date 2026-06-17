-- V17 : contenu de démonstration pour l'espace professeur
-- Lie le professeur test (99PROF9999) aux modules seedés et ajoute des réponses QRO d'étudiants démo.

-- 1) Associer le professeur test à tous les modules existants
INSERT INTO professeur_module (Moduleid_module, Professeurid)
SELECT m.id_module, p.id
FROM module m
INNER JOIN professeur p ON p.matricule = '99PROF9999'
WHERE NOT EXISTS (
  SELECT 1 FROM professeur_module pm
  WHERE pm.Professeurid = p.id AND pm.Moduleid_module = m.id_module
);

-- 2) Réponses QRO — Vision et objectifs (étudiant C002)
INSERT INTO qro_etudiant (date_ajout, date_modification, reponse, id_Etudiant, id_QRO)
SELECT
  NOW(), NOW(),
  'Ma vision sur trois ans est de lancer une coopérative agricole viable dans la région du Littoral. Les indicateurs clés seront : 50 membres actifs, un chiffre d''affaires annuel de 25 millions FCFA et un taux de satisfaction client supérieur à 85 %.',
  e.id,
  q.id
FROM etudiant e
INNER JOIN qro q ON q.id_chapitre = (SELECT c.id_chapitre FROM chapitre c WHERE c.titre = 'Vision et objectifs' LIMIT 1)
WHERE e.email = 'seed-etudiant@example.com'
  AND NOT EXISTS (
    SELECT 1 FROM qro_etudiant qe WHERE qe.id_Etudiant = e.id AND qe.id_QRO = q.id
  );

-- 3) Réponses QRO — Proposition de valeur (entrepreneur C001)
INSERT INTO qro_etudiant (date_ajout, date_modification, reponse, id_Etudiant, id_QRO)
SELECT
  NOW(), NOW(),
  'Nous proposons des solutions numériques sur mesure pour les PME camerounaises. Client cible : dirigeants de TPE/PME. Problème : manque de visibilité et de suivi commercial. Preuve : 12 projets livrés avec un NPS moyen de 8,5/10.',
  e.id,
  q.id
FROM etudiant e
INNER JOIN qro q ON q.id_chapitre = (SELECT c.id_chapitre FROM chapitre c WHERE c.titre = 'Proposition de valeur' LIMIT 1)
WHERE e.email = 'seed-entrepreneur@example.com'
  AND NOT EXISTS (
    SELECT 1 FROM qro_etudiant qe WHERE qe.id_Etudiant = e.id AND qe.id_QRO = q.id
  );

-- 4) Réponses QRO — Processus opérationnels (académique C004)
INSERT INTO qro_etudiant (date_ajout, date_modification, reponse, id_Etudiant, id_QRO)
SELECT
  NOW(), NOW(),
  'Le processus clé est la préparation des cours hybrides. Actions : (1) standardiser les fiches de séance, (2) mettre en place un suivi hebdomadaire des devoirs, (3) former deux assistants à la plateforme LMS.',
  e.id,
  q.id
FROM etudiant e
INNER JOIN qro q ON q.id_chapitre = (SELECT c.id_chapitre FROM chapitre c WHERE c.titre = 'Processus opérationnels' LIMIT 1)
WHERE e.email = 'seed-academique@example.com'
  AND NOT EXISTS (
    SELECT 1 FROM qro_etudiant qe WHERE qe.id_Etudiant = e.id AND qe.id_QRO = q.id
  );

-- 5) Deuxième réponse sur Vision (famille C003) pour enrichir le module Leadership
INSERT INTO qro_etudiant (date_ajout, date_modification, reponse, id_Etudiant, id_QRO)
SELECT
  DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY),
  'En tant que parent accompagnant un jeune porteur de projet, je souhaite qu''il développe une vision claire de son activité artisanale et qu''il mesure ses progrès chaque trimestre.',
  e.id,
  q.id
FROM etudiant e
INNER JOIN qro q ON q.id_chapitre = (SELECT c.id_chapitre FROM chapitre c WHERE c.titre = 'Vision et objectifs' LIMIT 1)
WHERE e.email = 'seed-famille@example.com'
  AND NOT EXISTS (
    SELECT 1 FROM qro_etudiant qe WHERE qe.id_Etudiant = e.id AND qe.id_QRO = q.id
  );
