package iri.elearningapi.config;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import iri.elearningapi.service.AdminService;

/**
 * Initialisation automatique de l'administrateur par défaut au démarrage.
 */
@Component
public class DefaultAdminInitializer {

    private final AdminService adminService;

    @Autowired
    public DefaultAdminInitializer(AdminService adminService) {
        this.adminService = adminService;
    }

    @PostConstruct
    public void initializeDefaultAdmin() {
        try {
            String result = adminService.createDefaultAdmin();
            System.out.println("[DefaultAdminInitializer] " + result);
        } catch (Exception e) {
            System.err.println("[DefaultAdminInitializer] Impossible de créer l'administrateur par défaut : " + e.getMessage());
        }
    }
}

