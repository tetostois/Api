-- Flyway V6: contenus de formation de base et liaisons avec la gamme "Etudiant"

-- Modules (accessibles immédiatement: date_Deblocage NULL)
INSERT INTO module (date_Deblocage, description, description_en, etat, nom_image, titre, titre_en)
VALUES
(NULL, 'Introduction au leadership et à la capacitation entrepreneuriale', 'Introduction to leadership and entrepreneurial capacity building', 'ACTIF', '/images/illustration/default.png', 'Leadership et Vision', 'Leadership and Vision'),
(NULL, 'Fondamentaux du modèle économique et proposition de valeur', 'Business model fundamentals and value proposition', 'ACTIF', '/images/illustration/default.png', 'Modèle économique', 'Business Model'),
(NULL, 'Gestion opérationnelle: processus, qualité, performance', 'Operations management: process, quality, performance', 'ACTIF', '/images/illustration/default.png', 'Gestion opérationnelle', 'Operations Management');

-- Liaisons modules ↔ gamme_etudiant (profil Etudiant C002)
-- Note: la table gamme_etudiant_module n''est pas AUTO_INCREMENT, on fournit des id uniques
INSERT INTO gamme_etudiant_module (id, id_Gamme_Etudiant, id_module)
VALUES
(1001, (SELECT id FROM gamme_etudiant WHERE code = 'C002'), (SELECT MIN(id_module) FROM module)),
(1002, (SELECT id FROM gamme_etudiant WHERE code = 'C002'), (SELECT MIN(id_module) + 1 FROM module)),
(1003, (SELECT id FROM gamme_etudiant WHERE code = 'C002'), (SELECT MIN(id_module) + 2 FROM module));

-- Chapitres de démonstration (un par module)
INSERT INTO chapitre (date_ajout, description, texte, image, pdf, preanbule, qcm, ordre, titre, etat, video, id_module)
VALUES
(NOW(), 'Découvrir sa vision et fixer des objectifs', 'Contenu du chapitre 1', NULL, NULL, NULL, 0, 1, 'Vision et objectifs', 'ACTIF', NULL, (SELECT MIN(id_module) FROM module)),
(NOW(), 'Comprendre la proposition de valeur', 'Contenu du chapitre 2', NULL, NULL, NULL, 0, 1, 'Proposition de valeur', 'ACTIF', NULL, (SELECT MIN(id_module) + 1 FROM module)),
(NOW(), 'Cartographier les processus clés', 'Contenu du chapitre 3', NULL, NULL, NULL, 0, 1, 'Processus opérationnels', 'ACTIF', NULL, (SELECT MIN(id_module) + 2 FROM module));




