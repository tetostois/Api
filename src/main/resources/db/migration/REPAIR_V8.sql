-- Script de réparation pour supprimer l'entrée V8 problématique de l'historique Flyway
-- À exécuter manuellement dans MySQL avant de redémarrer le serveur

USE elearningdata1000;

-- Supprimer l'entrée V8 de l'historique Flyway
DELETE FROM flyway_schema_history WHERE version = '8';

-- Vérifier que la colonne photo_url existe, sinon l'ajouter
SET @col_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'elearningdata1000' 
    AND TABLE_NAME = 'etudiant' 
    AND COLUMN_NAME = 'photo_url'
);

SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE etudiant ADD COLUMN photo_url LONGTEXT NULL', 
    'SELECT "La colonne photo_url existe déjà" AS message'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

