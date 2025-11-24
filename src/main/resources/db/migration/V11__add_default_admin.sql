-- Migration V11: Ajouter un administrateur par défaut
-- Cet admin peut être utilisé pour accéder à l'interface d'administration
-- 
-- IMPORTANT: Le backend ne vérifie PAS le mot de passe lors de la connexion admin
-- Il cherche uniquement par email ou téléphone. Le champ password peut donc contenir n'importe quelle valeur.
--
-- Identifiants par défaut:
-- Email: admin@programmeleadership.org
-- Téléphone: +237 695 83 58 77
-- Mot de passe: (non vérifié, peut être n'importe quoi)

-- Vérifier si un admin existe déjà
SET @admin_exists = (
    SELECT COUNT(*) 
    FROM admin 
    WHERE email = 'admin@programmeleadership.org' 
    OR telephone = '+237 695 83 58 77'
);

-- Insérer l'admin seulement s'il n'existe pas
INSERT INTO admin (email, telephone, nom, prenom, password, etat, level, statut)
SELECT 
    'admin@programmeleadership.org' as email,
    '+237 695 83 58 77' as telephone,
    'Administrateur' as nom,
    'Principal' as prenom,
    MD5(CONCAT('admin123', 'e@l#e$a%r^n&i*n(g')) as password,
    1 as etat,
    1 as level,
    'ACTIF' as statut
WHERE @admin_exists = 0;
