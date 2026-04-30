-- V15 : lier les fichiers vidéo aux chapitres (chemins servis par Spring sous /elearningapi/videos/**)
-- Fichiers attendus dans app.media.video-directory, ex. Api/videos/NEW/*.mp4
-- Idempotent : réapplique les mêmes URLs que V7 pour les titres connus.

UPDATE chapitre
SET video = '/elearningapi/videos/NEW/prjeanemmanuelpondisurleleadershipculturelidentitaire.mp4'
WHERE titre = 'Vision et objectifs';

UPDATE chapitre
SET video = '/elearningapi/videos/NEW/entrepreneuriatvocationnel.mp4'
WHERE titre = 'Proposition de valeur';

UPDATE chapitre
SET video = '/elearningapi/videos/NEW/ngangene2.mp4'
WHERE titre = 'Processus opérationnels';
