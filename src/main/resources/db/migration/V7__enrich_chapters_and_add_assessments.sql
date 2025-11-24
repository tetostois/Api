-- Flyway V7: enrichissement des chapitres et ajouts d'évaluations

-- 1) Mise à jour des contenus de chapitres
UPDATE chapitre
SET
  preanbule = 'Découvrez comment transformer votre vision personnelle en objectifs concrets et motivants.',
  description = 'Principes clés pour définir une vision inspirante et des objectifs mesurables pour votre projet.',
  texte = '<h3>Clarifier sa vision</h3><p>Une vision efficace décrit l''avenir souhaité avec précision tout en embarquant les parties prenantes. Elle se construit à partir de vos valeurs, de votre mission et des besoins de vos bénéficiaires.</p><ul><li>Identifier l''impact recherché</li><li>Décrire le futur désiré avec des mots simples</li><li>Partager la vision pour susciter l''adhésion</li></ul><p>Pour rester mobilisatrice, une vision s''accompagne d''objectifs SMART permettant de mesurer les progrès et d''ajuster la trajectoire.</p>',
  video = '/elearningapi/videos/NEW/prjeanemmanuelpondisurleleadershipculturelidentitaire.mp4',
  qcm = 1
WHERE titre = 'Vision et objectifs';

UPDATE chapitre
SET
  preanbule = 'Analysez la proposition de valeur de votre projet pour démontrer sa pertinence auprès de votre marché cible.',
  description = 'Méthodologie pour articuler une proposition de valeur différenciante alignée sur les attentes clients.',
  texte = '<h3>Comprendre son client</h3><p>Une proposition de valeur convaincante commence par l''écoute des besoins, frustrations et aspirations de vos clients. Cartographiez les segments prioritaires et synthétisez leurs attentes.</p><h3>Formuler la promesse</h3><p>La proposition doit expliciter :</p><ol><li>Le problème résolu ou le gain généré</li><li>La solution proposée et ses preuves</li><li>Les bénéfices différenciants par rapport à la concurrence</li></ol><p>Structurez votre message autour du trio <strong>client – solution – preuves</strong> pour faciliter la compréhension et l''adhésion.</p>',
  video = '/elearningapi/videos/NEW/entrepreneuriatvocationnel.mp4',
  qcm = 1
WHERE titre = 'Proposition de valeur';

UPDATE chapitre
SET
  preanbule = 'Structurez vos processus opérationnels pour garantir qualité, délais et efficacité au quotidien.',
  description = 'Organisation et pilotage des processus clés afin d''assurer la performance opérationnelle.',
  texte = '<h3>Cartographier les processus</h3><p>Identifiez les activités critiques qui créent de la valeur pour vos bénéficiaires. Pour chacune, précisez les responsables, les intrants, les livrables attendus et les indicateurs de contrôle.</p><h3>Amélioration continue</h3><p>Mettre en place un pilotage régulier (revues, tableaux de bord, remontée des anomalies) permet d''ancrer une culture d''amélioration continue et d''impliquer les équipes dans la recherche de solutions.</p><p>À terme, formalisez vos procédures pour faciliter l''intégration de nouveaux collaborateurs et fiabiliser la transmission du savoir-faire.</p>',
  video = '/elearningapi/videos/NEW/ngangene2.mp4',
  qcm = 1
WHERE titre = 'Processus opérationnels';

-- 2) Ajout de QCM (1 par chapitre)
INSERT INTO qcm (description, intitule, intitule_en, note, id_chapitre)
VALUES (
  'Évaluer la compréhension des éléments constitutifs d''une vision stratégique.',
  'Quel énoncé décrit le mieux une vision inspirante pour un projet ?',
  'Which statement best describes an inspiring vision for a project?',
  '5',
  (SELECT id_chapitre FROM chapitre WHERE titre = 'Vision et objectifs')
);
SET @qcm_vision := LAST_INSERT_ID();

INSERT INTO proposition (etat, valeur, valeur_en, id_QCM) VALUES
(1, 'Une description claire de l''avenir souhaité et de l''impact recherché.', 'A clear description of the desired future and expected impact.', @qcm_vision),
(0, 'Une liste détaillée des tâches prévues pour la semaine suivante.', 'A detailed list of tasks planned for the coming week.', @qcm_vision),
(0, 'Un bilan financier de l''année précédente.', 'A financial review of the previous year.', @qcm_vision);

INSERT INTO qcm (description, intitule, intitule_en, note, id_chapitre)
VALUES (
  'Tester la maîtrise des éléments d''une proposition de valeur.',
  'Quel élément doit obligatoirement apparaître dans une proposition de valeur convaincante ?',
  'Which element must appear in a compelling value proposition?',
  '5',
  (SELECT id_chapitre FROM chapitre WHERE titre = 'Proposition de valeur')
);
SET @qcm_modele := LAST_INSERT_ID();

INSERT INTO proposition (etat, valeur, valeur_en, id_QCM) VALUES
(1, 'Le bénéfice concret apporté au client visé.', 'The concrete benefit delivered to the target customer.', @qcm_modele),
(0, 'Le curriculum vitae complet du fondateur.', 'The founder''s full résumé.', @qcm_modele),
(0, 'Le prix moyen de la concurrence sur 5 ans.', 'The competitors'' average price over five years.', @qcm_modele);

INSERT INTO qcm (description, intitule, intitule_en, note, id_chapitre)
VALUES (
  'Vérifier la compréhension de la formalisation des processus.',
  'Quel est le principal objectif de la cartographie des processus opérationnels ?',
  'What is the main objective of mapping operational processes?',
  '5',
  (SELECT id_chapitre FROM chapitre WHERE titre = 'Processus opérationnels')
);
SET @qcm_gestion := LAST_INSERT_ID();

INSERT INTO proposition (etat, valeur, valeur_en, id_QCM) VALUES
(1, 'Visualiser les activités clés, leurs responsables et les livrables attendus.', 'Visualize key activities, their owners and expected deliverables.', @qcm_gestion),
(0, 'Remplacer l''ensemble des réunions d''équipe hebdomadaires.', 'Replace all weekly team meetings.', @qcm_gestion),
(0, 'Éliminer systématiquement toute tâche administrative.', 'Systematically eliminate every administrative task.', @qcm_gestion);

-- 3) Ajout de QRO (1 par chapitre)
INSERT INTO qro (intitule, intitule_en, note, id_chapitre) VALUES
(
  'Décrivez en quelques lignes la vision à trois ans de votre projet et les indicateurs qui prouveront sa réussite.',
  'Describe your project''s three-year vision and the indicators that will prove its success.',
  '10',
  (SELECT id_chapitre FROM chapitre WHERE titre = 'Vision et objectifs')
),
(
  'Formulez une proposition de valeur en précisant le client cible, la problématique adressée et la preuve de votre solution.',
  'Craft a value proposition detailing the target customer, the pain point addressed and the proof of your solution.',
  '10',
  (SELECT id_chapitre FROM chapitre WHERE titre = 'Proposition de valeur')
),
(
  'Identifiez un processus opérationnel clé dans votre organisation et listez trois actions concrètes pour en améliorer l''efficacité.',
  'Identify a key operational process in your organization and list three concrete actions to improve its efficiency.',
  '10',
  (SELECT id_chapitre FROM chapitre WHERE titre = 'Processus opérationnels')
);

