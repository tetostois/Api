package iri.elearningapi.service;

import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.stream.Collectors;

import iri.elearningapi.model.courModel.Chapitre;
import iri.elearningapi.model.courModel.Module;
import iri.elearningapi.model.courModel.ProfesseurModule;
import iri.elearningapi.model.courModel.Qro;
import iri.elearningapi.model.courModel.QroEtudiant;
import iri.elearningapi.model.userModel.Professeur;
import iri.elearningapi.repository.courRepository.ChapitreRepository;
import iri.elearningapi.repository.courRepository.ModuleRepository;
import iri.elearningapi.repository.courRepository.ProfesseurModuleRepository;
import iri.elearningapi.repository.courRepository.QroEtudiantRepository;
import iri.elearningapi.repository.courRepository.QroRepository;
import iri.elearningapi.repository.userRepository.EtudiantRepository;
import iri.elearningapi.repository.userRepository.ProfesseurRepository;
import iri.elearningapi.utils.elearningFunction.Cryptage;
import iri.elearningapi.utils.elearningFunction.Methode;
import iri.elearningapi.utils.elearningFunction.PasswordGenerator;
import iri.elearningapi.utils.elearningFunction.SenderMail;
import iri.elearningapi.utils.errorClass.ElearningException;
import iri.elearningapi.utils.errorClass.ErrorAPI;
import iri.elearningapi.utils.form.formInt.FormLink;
import iri.elearningapi.utils.form.formOut.FormViewProfesseur;
import iri.elearningapi.utils.form.formOut.ProfesseurDashboard;
import iri.elearningapi.utils.form.formOut.UserElearning;
import iri.elearningapi.utils.elearningData.Profil;

@Service
public class ProfesseurService {
	@Autowired
	private ProfesseurRepository professeurRepository;

	@Autowired
	private EtudiantRepository etudiantRepository;

	@Autowired
	private ModuleRepository moduleRepository;

	@Autowired
	private ProfesseurModuleRepository professeurModuleRepository;

	@Autowired
	private SenderMail senderMail;

	@Autowired
	private QroEtudiantRepository qroEtudiantRepository;

	@Autowired
	private QroRepository qroRepository;

	@Autowired
	private ChapitreRepository chapitreRepository;

	private static final Random RANDOM = new Random();

	public Page<Professeur> getListProfesseurs(String filter, int pageNumber) {
		Pageable pageable = PageRequest.of(pageNumber, 50);

		Page<Professeur> pageProfesseurs;

		if (filter != null) {
			pageProfesseurs = professeurRepository
					.findByNomStartingWithOrPrenomStartingWithOrProfessionStartingWithOrEmailStartingWithOrderByNomAsc(
							filter, filter, filter, filter, pageable);

			if (pageProfesseurs.isEmpty()) {
				pageProfesseurs = professeurRepository
						.findByNomContainingOrPrenomContainingOrProfessionContainingOrEmailContainingOrderByNomAsc(
								filter, filter, filter, filter, pageable);
			}

		} else {
			pageProfesseurs = professeurRepository.findAllByOrderByNomAsc(pageable);
		}
		return pageProfesseurs;
	}

	public Professeur createProfesseur(Professeur professeur) {
		controlFormProfesseur(professeur, true);
		String passworrd = PasswordGenerator.generatePassword(8);
		professeur.setPassword(Cryptage.getMd5(passworrd));
		professeur.setDateInscription(new Date());
		professeur.setMatricule(generateMatriculeForProfesseur());
		professeur = professeurRepository.save(professeur);
		professeur.setPassword(passworrd);
		// System.out.println("Pass Word: "+professeur.getPassword());
		senderMail.sendMailAfterRegistration(professeur);
		professeur.setPassword("");
		return professeur;
	}

	public Professeur updateProfesseur(Professeur professeur) {
		if (professeur.getId() == 0 && professeur.getMatricule() != null) {
			Professeur existingProfesseur = professeurRepository.findByMatricule(professeur.getMatricule());
			if (existingProfesseur != null) {
				professeur.setId(existingProfesseur.getId());
			}
		}
		controlFormProfesseur(professeur, false);
		// Ne pas modifier le mot de passe si ce n'est pas fourni
		if (professeur.getPassword() == null || professeur.getPassword().isEmpty()) {
			Professeur existing = professeurRepository.findById(professeur.getId()).orElse(null);
			if (existing != null) {
				professeur.setPassword(existing.getPassword());
			}
		}
		// Ne pas modifier la date d'inscription
		Professeur existing = professeurRepository.findById(professeur.getId()).orElse(null);
		if (existing != null) {
			professeur.setDateInscription(existing.getDateInscription());
		}
		return professeurRepository.save(professeur);
	}

	private String generateMatriculeForProfesseur() {
		String matricule;
		do {
			int prefix = RANDOM.nextInt(90) + 10; // Génère un nombre aléatoire à deux chiffres
			int suffix = RANDOM.nextInt(9000) + 1000; // Génère un nombre aléatoire à quatre chiffres
			matricule = prefix + "PROF" + suffix;
		} while (professeurRepository.findByMatricule(matricule) != null);
		return matricule;
	}

	public UserElearning getLogin(UserElearning userLogin) {
		Professeur professeur = null;
		professeur = professeurRepository.findByEmailOrTelephone(userLogin.getLogin(), userLogin.getLogin());
		
		if (professeur != null && professeurRepository.existsByMatricule(professeur.getMatricule())) {
			// Vérifier le mot de passe si fourni
			if (userLogin.getPassword() != null && !userLogin.getPassword().isEmpty()) {
				String hashedPassword = Cryptage.getMd5(userLogin.getPassword());
				if (!professeur.getPassword().equals(hashedPassword)) {
					return null; // Mot de passe incorrect
				}
			}
			
			UserElearning user = new UserElearning();
			user.setEmail(professeur.getEmail());
			user.setId(professeur.getId());
			user.setMatricule(professeur.getMatricule());
			user.setNom(professeur.getNom());
			user.setPrenom(professeur.getPrenom());
			user.setProfil(Profil.PROFESSEUR_USER);
			user.setPassword(professeur.getPassword());
			user.setOpenDashboard(true);
			return user;
		}
		return null;
	}

	public Professeur getProfesseur(String matricule) {
		Professeur professeur = new Professeur();

		if (professeurRepository.existsByMatricule(matricule)) {
			professeur = professeurRepository.findByMatricule(matricule);
		}

		return professeur;
	}

	public FormViewProfesseur getFormViewProfesseur(String matricule) {
		Professeur professeur = getProfesseur(matricule);
		FormViewProfesseur formViewProfesseur = new FormViewProfesseur(professeur.getId(), professeurRepository,
				moduleRepository);

		return formViewProfesseur;
	}

	private void controlFormProfesseur(Professeur professeur, Boolean isNew) {
		if (professeur.getNom() == null || professeur.getNom().isBlank() || professeur.getNom().length() < 2) {
			throw new ElearningException(new ErrorAPI(
					"Le nom du professeur ne doit pas être vide, ou contenir moins de trois(03) caractères", 0));
		}

		if (professeur.getEmail() == null || !Methode.isValidEmail(professeur.getEmail())) {
			throw new ElearningException(new ErrorAPI("L'adresse mail du professeur est invalide", 0));
		}

		if (professeur.getEmail() != null && professeurRepository.existsByEmail(professeur.getEmail())) {
			if (professeurRepository.findByEmail(professeur.getEmail()).getId() != professeur.getId()) {
				throw new ElearningException(
						new ErrorAPI("L'adresse mail entrée est deja attribuer a un autre professeur", 0));
			}
		}

		if (professeur.getTelephone() != null && professeurRepository.existsByTelephone(professeur.getTelephone())) {
			if (professeurRepository.findByTelephone(professeur.getTelephone()).getId() != professeur.getId()) {
				throw new ElearningException(
						new ErrorAPI("Le numero de téléphone entré est deja attribuer a un autre professeur", 0));
			}
		}

		if (professeur.getTelephone() != null && etudiantRepository.existsByTelephone(professeur.getTelephone())) {
			throw new ElearningException(
					new ErrorAPI("Le numero de téléphone entré est deja utiliser par un compte Etudiant", 0));
		}

		if (professeur.getEmail() != null && etudiantRepository.existsByEmail(professeur.getEmail())) {
			throw new ElearningException(
					new ErrorAPI("L'adresse mail entrée est deja utiliser par un compte Etudiant", 0));
		}
	}

	public void linkProfesseurToModule(String matriculeProfesseur, List<FormLink> formLinks) {
		for (FormLink formLink : formLinks) {
			System.out.println("les lien idmodule: "+formLink.getIdModule()+" || islinked= "+formLink.isLinked());
		}
		if (professeurRepository.existsByMatricule(matriculeProfesseur)) {
			Professeur professeur = professeurRepository.findByMatricule(matriculeProfesseur);
			for (FormLink formLink : formLinks) {
				if (moduleRepository.existsById(formLink.getIdModule())) {
					Module module = moduleRepository.findById(formLink.getIdModule()).get();
					boolean isAlReadyLink = module.getProfesseurModules().stream()
							.anyMatch(item -> (item.getProfesseur() != null
									&& item.getProfesseur().getMatricule() == professeur.getMatricule()));

					//
					if (formLink.isLinked()) {
						if (!isAlReadyLink) {
							ProfesseurModule professeurModule = new ProfesseurModule();
							professeurModule.setModule(module);
							professeurModule.setProfesseur(professeur);
							professeurModuleRepository.save(professeurModule);
							//System.out.println("enregistrement du lien");
						}

					} else {
						if (isAlReadyLink) {
							Optional<ProfesseurModule> professeurModuleOptional = module.getProfesseurModules().stream()
									.filter(item -> (item.getProfesseur() != null
											&& item.getProfesseur().getMatricule() == professeur.getMatricule()))
									.findAny();
							if (professeurModuleOptional.isPresent()) {
								professeurModuleRepository.deleteEasy(professeurModuleOptional.get().getId());
								//System.out.println("supression du lien");
							}
						}
					}
					//
				}
			}
		}
	}

	public ProfesseurDashboard getProfesseurDashboard(String matricule) {
		ProfesseurDashboard dashboard = new ProfesseurDashboard();
		Professeur professeur = getProfesseur(matricule);
		
		if (professeur != null && professeur.getId() > 0) {
			List<Module> modulesAssigned = new ArrayList<>();
			if (professeur.getProfesseurModules() != null) {
				for (ProfesseurModule pm : professeur.getProfesseurModules()) {
					modulesAssigned.add(pm.getModule());
				}
			}
			dashboard.setModules(modulesAssigned);
			dashboard.setModuleTotal(modulesAssigned.size());
			
			// Compter les QRO en attente (sans réponse du professeur)
			int qroEnAttente = 0;
			int qroTotal = 0;
			for (Module module : modulesAssigned) {
				if (module.getChapitres() != null) {
					for (Chapitre chapitre : module.getChapitres()) {
						if (chapitre.getQros() != null) {
							for (Qro qro : chapitre.getQros()) {
								if (qro.getQroEtudiants() != null) {
									qroTotal += qro.getQroEtudiants().size();
									// Pour l'instant, on considère tous les QRO comme en attente
									// On pourra ajouter un champ pour marquer ceux qui ont une réponse
									qroEnAttente += qro.getQroEtudiants().size();
								}
							}
						}
					}
				}
			}
			dashboard.setQroTotal(qroTotal);
			dashboard.setQroEnAttente(qroEnAttente);
		}
		
		return dashboard;
	}

	public List<QroEtudiant> getQROForProfesseurModule(String matricule, int idModule) {
		Professeur professeur = getProfesseur(matricule);
		List<QroEtudiant> qroEtudiants = new ArrayList<>();
		
		if (professeur != null && professeur.getId() > 0) {
			// Vérifier que le professeur est assigné à ce module
			boolean isAssigned = professeur.getProfesseurModules().stream()
					.anyMatch(pm -> pm.getModule().getIdModule() == idModule);
			
			if (isAssigned && moduleRepository.existsById(idModule)) {
				Module module = moduleRepository.findById(idModule).get();
				if (module.getChapitres() != null) {
					for (Chapitre chapitre : module.getChapitres()) {
						if (chapitre.getQros() != null) {
							for (Qro qro : chapitre.getQros()) {
								if (qro.getQroEtudiants() != null) {
									for (QroEtudiant qroEtudiant : qro.getQroEtudiants()) {
										QroEtudiant qe = new QroEtudiant();
										qe.setId(qroEtudiant.getId());
										qe.setReponse(qroEtudiant.getReponse());
										qe.setDateAjout(qroEtudiant.getDateAjout());
										qe.setDateModification(qroEtudiant.getDateModification());
										qe.setQro(qro);
										qe.setEtudiant(qroEtudiant.getEtudiant());
										qroEtudiants.add(qe);
									}
								}
							}
						}
					}
				}
			}
		}
		
		return qroEtudiants;
	}

	public List<QroEtudiant> getQROForChapitre(String matricule, int idChapitre) {
		Professeur professeur = getProfesseur(matricule);
		List<QroEtudiant> qroEtudiants = new ArrayList<>();
		
		if (professeur != null && professeur.getId() > 0 && chapitreRepository.existsById(idChapitre)) {
			Chapitre chapitre = chapitreRepository.findById(idChapitre).get();
			
			// Vérifier que le professeur est assigné au module de ce chapitre
			boolean isAssigned = professeur.getProfesseurModules().stream()
					.anyMatch(pm -> pm.getModule().getIdModule() == chapitre.getModule().getIdModule());
			
			if (isAssigned && chapitre.getQros() != null) {
				for (Qro qro : chapitre.getQros()) {
					if (qro.getQroEtudiants() != null) {
						for (QroEtudiant qroEtudiant : qro.getQroEtudiants()) {
							QroEtudiant qe = new QroEtudiant();
							qe.setId(qroEtudiant.getId());
							qe.setReponse(qroEtudiant.getReponse());
							qe.setDateAjout(qroEtudiant.getDateAjout());
							qe.setDateModification(qroEtudiant.getDateModification());
							qe.setQro(qro);
							qe.setEtudiant(qroEtudiant.getEtudiant());
							qroEtudiants.add(qe);
						}
					}
				}
			}
		}
		
		return qroEtudiants;
	}

	public boolean addReponseToQRO(int idQroEtudiant, String reponse) {
		if (qroEtudiantRepository.existsById(idQroEtudiant)) {
			QroEtudiant qroEtudiant = qroEtudiantRepository.findById(idQroEtudiant).get();
			// Pour l'instant, on stocke la réponse dans le champ note du QRO
			// On pourra ajouter un champ dédié plus tard
			if (qroEtudiant.getQro() != null) {
				Qro qro = qroEtudiant.getQro();
				String currentNote = qro.getNote() != null ? qro.getNote() : "";
				// Ajouter la réponse du professeur dans les notes
				String newNote = currentNote + "\n\n[Professeur]: " + reponse;
				qro.setNote(newNote);
				qroRepository.save(qro);
				return true;
			}
		}
		return false;
	}

	public boolean deleteProfesseur(String matricule) {
		if (professeurRepository.existsByMatricule(matricule)) {
			Professeur professeur = professeurRepository.findByMatricule(matricule);
			// Supprimer les liens avec les modules
			if (professeur.getProfesseurModules() != null) {
				for (ProfesseurModule pm : professeur.getProfesseurModules()) {
					professeurModuleRepository.delete(pm);
				}
			}
			// Supprimer le professeur
			professeurRepository.delete(professeur);
			return true;
		}
		return false;
	}

	public boolean deleteProfesseurs(List<String> matricules) {
		boolean allDeleted = true;
		for (String matricule : matricules) {
			if (!deleteProfesseur(matricule)) {
				allDeleted = false;
			}
		}
		return allDeleted;
	}
}
