# Script de réparation automatique pour Flyway V8
# Ce script exécute la commande Flyway repair via Maven

Write-Host "Réparation de l'historique Flyway..." -ForegroundColor Cyan

# Aller dans le répertoire Api
Set-Location $PSScriptRoot

# Exécuter la commande Flyway repair
Write-Host "Exécution de: mvn flyway:repair" -ForegroundColor Yellow
mvn flyway:repair

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Réparation terminée avec succès" -ForegroundColor Green
    Write-Host "Vous pouvez maintenant redémarrer le serveur avec: mvn spring-boot:run" -ForegroundColor Green
} else {
    Write-Host "✗ Erreur lors de la réparation" -ForegroundColor Red
    Write-Host "Essayez d'exécuter manuellement: mvn flyway:repair" -ForegroundColor Yellow
}

