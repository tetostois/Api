@echo off
REM Script de réparation automatique pour Flyway V8 (Windows)
REM Ce script supprime l'entrée V8 problématique de l'historique Flyway

echo Réparation de l'historique Flyway...

REM Configuration de la base de données
set DB_NAME=elearningdata1000
set DB_USER=root
set DB_PASS=

REM Commande SQL pour supprimer l'entrée V8
mysql -u %DB_USER% %DB_NAME% -e "DELETE FROM flyway_schema_history WHERE version = '8'; SELECT 'Entree V8 supprimee de l''historique Flyway' AS message;"

if %ERRORLEVEL% EQU 0 (
    echo ✓ Réparation terminée avec succès
) else (
    echo ✗ Erreur lors de la réparation
    exit /b 1
)

