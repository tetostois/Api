package iri.elearningapi.controller;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@CrossOrigin
public class FlywayRepairController {

	@Value("${spring.datasource.url}")
	private String datasourceUrl;

	@Value("${spring.datasource.username}")
	private String datasourceUsername;

	@Value("${spring.datasource.password:}")
	private String datasourcePassword;

	@PostMapping("/admin/flyway/repair-v8")
	public String repairFlywayV8() {
		try {
			// Extraire l'URL de la base de données
			String jdbcUrl = datasourceUrl;
			if (jdbcUrl.startsWith("jdbc:mysql://")) {
				jdbcUrl = datasourceUrl;
			} else {
				jdbcUrl = "jdbc:mysql://localhost:3306/elearningdata1000";
			}

			// Se connecter à la base de données
			Connection conn = DriverManager.getConnection(jdbcUrl, datasourceUsername, datasourcePassword);
			Statement stmt = conn.createStatement();

			// Supprimer l'entrée V8 de l'historique Flyway
			int deleted = stmt.executeUpdate("DELETE FROM flyway_schema_history WHERE version = '8'");

			// Vérifier si la colonne photo_url existe
			ResultSet rs = stmt.executeQuery(
				"SELECT COUNT(*) as count FROM INFORMATION_SCHEMA.COLUMNS " +
				"WHERE TABLE_SCHEMA = 'elearningdata1000' " +
				"AND TABLE_NAME = 'etudiant' " +
				"AND COLUMN_NAME = 'photo_url'"
			);
			rs.next();
			boolean columnExists = rs.getInt("count") > 0;
			rs.close();

			// Ajouter la colonne si elle n'existe pas
			if (!columnExists) {
				stmt.executeUpdate("ALTER TABLE etudiant ADD COLUMN photo_url LONGTEXT NULL");
			}

			stmt.close();
			conn.close();

			return "Réparation réussie: " + deleted + " entrée(s) V8 supprimée(s). Colonne photo_url: " + (columnExists ? "existait déjà" : "ajoutée");
		} catch (Exception e) {
			return "Erreur lors de la réparation: " + e.getMessage();
		}
	}
}

