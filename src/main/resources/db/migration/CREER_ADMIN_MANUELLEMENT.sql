-- Script SQL pour créer un administrateur manuellement
-- À exécuter directement dans MySQL si la migration V11 n'a pas encore été appliquée

USE elearningdata1000;

-- Vérifier si l'admin existe déjà
SELECT * FROM admin WHERE email = 'admin@programmeleadership.org' OR telephone = '+237 695 83 58 77';

-- Si aucun résultat, créer l'admin
INSERT INTO admin (email, telephone, nom, prenom, password, etat, level, statut)
VALUES (
    'admin@programmeleadership.org',
    '+237 695 83 58 77',
    'Administrateur',
    'Principal',
    MD5(CONCAT('admin123', 'e@l#e$a%r^n&i*n(g')),
    1,
    1,
    'ACTIF'
);

-- Vérifier que l'admin a été créé
SELECT * FROM admin WHERE email = 'admin@programmeleadership.org';


