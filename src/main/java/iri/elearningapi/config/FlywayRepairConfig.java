package iri.elearningapi.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import org.flywaydb.core.Flyway;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.flyway.FlywayMigrationStrategy;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class FlywayRepairConfig {

	@Value("${spring.datasource.url}")
	private String datasourceUrl;

	@Value("${spring.datasource.username}")
	private String datasourceUsername;

	@Value("${spring.datasource.password:}")
	private String datasourcePassword;

	@Bean
	public FlywayMigrationStrategy flywayMigrationStrategy() {
		FlywayRepairConfig config = this;
		return new FlywayMigrationStrategy() {
			@Override
			public void migrate(Flyway flyway) {
				// Réparer avant de migrer
				config.repairFlywayV8();
				// Puis exécuter la migration normale
				flyway.migrate();
			}
		};
	}

	private void repairFlywayV8() {
		try {
			// Extraire l'URL de la base de données
			String jdbcUrl = datasourceUrl;
			if (!jdbcUrl.startsWith("jdbc:mysql://")) {
				jdbcUrl = "jdbc:mysql://localhost:3306/elearningdata1000";
			}

			// Se connecter à la base de données
			Connection conn = DriverManager.getConnection(jdbcUrl, datasourceUsername, datasourcePassword);
			Statement stmt = conn.createStatement();

			// Supprimer l'entrée V8 de l'historique Flyway si elle existe
			try {
				int deleted = stmt.executeUpdate("DELETE FROM flyway_schema_history WHERE version = '8'");
				if (deleted > 0) {
					System.out.println("[FlywayRepair] ✓ Entrée V8 supprimée de l'historique Flyway");
				}
			} catch (Exception e) {
				// Ignorer si la table n'existe pas encore ou si l'entrée n'existe pas
				System.out.println("[FlywayRepair] Table flyway_schema_history: " + e.getMessage());
			}

			// Vérifier si la colonne photo_url existe
			ResultSet rs = stmt.executeQuery(
				"SELECT COUNT(*) as count FROM INFORMATION_SCHEMA.COLUMNS " +
				"WHERE TABLE_SCHEMA = DATABASE() " +
				"AND TABLE_NAME = 'etudiant' " +
				"AND COLUMN_NAME = 'photo_url'"
			);
			rs.next();
			boolean columnExists = rs.getInt("count") > 0;
			rs.close();

			// Ajouter la colonne si elle n'existe pas
			if (!columnExists) {
				stmt.executeUpdate("ALTER TABLE etudiant ADD COLUMN photo_url LONGTEXT NULL");
				System.out.println("[FlywayRepair] ✓ Colonne photo_url ajoutée à la table etudiant");
			} else {
				System.out.println("[FlywayRepair] ✓ Colonne photo_url existe déjà");
			}

			stmt.close();
			conn.close();
		} catch (Exception e) {
			System.err.println("[FlywayRepair] ⚠ Erreur lors de la réparation automatique: " + e.getMessage());
			// Ne pas bloquer le démarrage si la réparation échoue
		}
	}
}

