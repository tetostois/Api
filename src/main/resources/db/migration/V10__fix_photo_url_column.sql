-- Migration V10: S'assurer que la colonne photo_url est de type LONGTEXT
-- Cette migration modifie la colonne si elle existe déjà avec un type plus petit

-- Vérifier si la colonne existe et modifier son type
SET @col_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'etudiant' 
    AND COLUMN_NAME = 'photo_url'
);

SET @sql = IF(@col_exists > 0, 
    'ALTER TABLE etudiant MODIFY COLUMN photo_url LONGTEXT NULL', 
    'SELECT 1'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

