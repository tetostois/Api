package iri.elearningapi.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import iri.elearningapi.model.courModel.QroEtudiant;
import iri.elearningapi.service.ProfesseurService;
import iri.elearningapi.utils.form.formOut.FormViewProfesseur;
import iri.elearningapi.utils.form.formOut.ProfesseurDashboard;

@RestController
@CrossOrigin
public class ProfesseurController {

	@Autowired
	private ProfesseurService professeurService;

	@GetMapping("/professeur/dashboard/{matricule}")
	public ProfesseurDashboard getProfesseurDashboard(@PathVariable("matricule") String matricule) {
		return professeurService.getProfesseurDashboard(matricule);
	}

	@GetMapping("/professeur/modules/{matricule}")
	public FormViewProfesseur getProfesseurModules(@PathVariable("matricule") String matricule) {
		return professeurService.getFormViewProfesseur(matricule);
	}

	@GetMapping("/professeur/qro/{matricule}/{idModule}")
	public List<QroEtudiant> getQROForModule(@PathVariable("matricule") String matricule,
			@PathVariable("idModule") int idModule) {
		return professeurService.getQROForProfesseurModule(matricule, idModule);
	}

	@GetMapping("/professeur/qro/chapitre/{matricule}/{idChapitre}")
	public List<QroEtudiant> getQROForChapitre(@PathVariable("matricule") String matricule,
			@PathVariable("idChapitre") int idChapitre) {
		return professeurService.getQROForChapitre(matricule, idChapitre);
	}

	@PostMapping("/professeur/qro/reponse/{idQroEtudiant}")
	public boolean addReponseToQRO(@PathVariable("idQroEtudiant") int idQroEtudiant,
			@RequestBody String reponse) {
		return professeurService.addReponseToQRO(idQroEtudiant, reponse);
	}

}

