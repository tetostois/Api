-- Migration V12: Ajouter un professeur de test
-- Ce professeur peut être utilisé pour tester l'interface professeur
-- 
-- Identifiants de connexion:
-- Email: professeur@test.com
-- Téléphone: +237 600 000 000
-- Mot de passe: professeur123
-- Matricule: 99PROF9999

-- Vérifier si un professeur existe déjà avec cet email ou téléphone
SET @prof_exists = (
    SELECT COUNT(*) 
    FROM professeur 
    WHERE email = 'professeur@test.com' 
    OR telephone = '+237 600 000 000'
    OR matricule = '99PROF9999'
);

-- Insérer le professeur seulement s'il n'existe pas
INSERT INTO professeur (matricule, nom, prenom, email, telephone, profession, password, date_inscription, etat, id_region)
SELECT 
    '99PROF9999' as matricule,
    'Test' as nom,
    'Professeur' as prenom,
    'professeur@test.com' as email,
    '+237 600 000 000' as telephone,
    'Enseignant' as profession,
    MD5(CONCAT('professeur123', 'e@l#e$a%r^n&i*n(g')) as password,
    NOW() as date_inscription,
    'ACTIF' as etat,
    (SELECT id FROM region LIMIT 1) as id_region
WHERE @prof_exists = 0;

