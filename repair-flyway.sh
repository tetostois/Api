#!/bin/bash

# Script de réparation automatique pour Flyway V8
# Ce script supprime l'entrée V8 problématique de l'historique Flyway

echo "Réparation de l'historique Flyway..."

# Configuration de la base de données
DB_NAME="elearningdata1000"
DB_USER="root"
DB_PASS=""
DB_HOST="localhost"

# Commande SQL pour supprimer l'entrée V8
mysql -h "$DB_HOST" -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" <<EOF
DELETE FROM flyway_schema_history WHERE version = '8';
SELECT 'Entrée V8 supprimée de l\'historique Flyway' AS message;
EOF

if [ $? -eq 0 ]; then
    echo "✓ Réparation terminée avec succès"
else
    echo "✗ Erreur lors de la réparation"
    exit 1
fi

