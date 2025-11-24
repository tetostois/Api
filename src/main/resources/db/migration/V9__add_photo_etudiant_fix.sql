-- Migration V9: Ajouter la colonne photo_url à la table etudiant
-- Cette migration remplace V8 qui avait un problème de checksum

-- Ajouter la colonne photo_url si elle n'existe pas
SET @col_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'etudiant' 
    AND COLUMN_NAME = 'photo_url'
);

SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE etudiant ADD COLUMN photo_url LONGTEXT NULL', 
    'SELECT 1'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

