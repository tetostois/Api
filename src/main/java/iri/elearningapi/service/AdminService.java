package iri.elearningapi.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import iri.elearningapi.model.Message;
import iri.elearningapi.model.courModel.Chapitre;
import iri.elearningapi.model.courModel.EtudiantChapitre;
import iri.elearningapi.model.courModel.Module;
import iri.elearningapi.model.userModel.Admin;
import iri.elearningapi.model.userModel.Etudiant;
import iri.elearningapi.model.userModel.GammeEtudiant;
import iri.elearningapi.repository.MessageRepository;
import iri.elearningapi.repository.courRepository.ChapitreRepository;
import iri.elearningapi.repository.courRepository.EtudiantChapitreRepository;
import iri.elearningapi.repository.courRepository.ModuleRepository;
import iri.elearningapi.repository.courRepository.QuestionCourRepository;
import iri.elearningapi.repository.userRepository.AdminRepository;
import iri.elearningapi.repository.userRepository.EtudiantRepository;
import iri.elearningapi.repository.userRepository.GammeEtudiantRepository;
import iri.elearningapi.repository.userRepository.ProfesseurRepository;
import iri.elearningapi.utils.elearningData.Profil;
import iri.elearningapi.utils.elearningFunction.Cryptage;
import iri.elearningapi.utils.elearningFunction.SenderMail;
import iri.elearningapi.utils.errorClass.ElearningException;
import iri.elearningapi.utils.errorClass.ErrorAPI;
import iri.elearningapi.utils.form.formInt.FormMail;
import iri.elearningapi.utils.form.formOut.UserAdminDashboard;
import iri.elearningapi.utils.form.formOut.UserElearning;

@Service
public class AdminService {
	@Autowired
	private EtudiantRepository etudiantRepository;

	@Autowired
	private ProfesseurRepository professeurRepository;

	@Autowired
	private ModuleRepository moduleRepository;

	@Autowired
	private QuestionCourRepository questionCourRepository;
	
	@Autowired
	private GammeEtudiantRepository gammeEtudiantRepository;
	
	//@Autowired
	//private EtudiantModuleRepository etudiantModuleRepository;

	@Autowired
	private EtudiantChapitreRepository etudiantChapitreRepository;

	@Autowired
	private ChapitreRepository chapitreRepository;

	@Autowired
	private AdminRepository adminRepository;
	
	@Autowired
	private SenderMail senderMail;
	
	@Autowired
	private MessageRepository messageRepository;

	public UserElearning getLoginAdmin(UserElearning userLogin) {
		Admin admin = new Admin();
		//Admin admin2 = new Admin();

		admin = adminRepository.findByEmailOrTelephone(userLogin.getLogin(), userLogin.getLogin());
		if (admin != null && adminRepository.existsById(admin.getId())) {
			UserElearning user = new UserElearning();
			user.setEmail(admin.getEmail());
			user.setId(admin.getId());
			// user.setMatricule(etudiant.getMatricule());
			user.setNom(admin.getNom());
			user.setPrenom(admin.getPrenom());
			user.setProfil(Profil.ADMIN_USER);
			user.setPassword(admin.getPassword());
			user.setLevel(admin.getLevel());
			user.setConfirmation(1);
			user.setOpenDashboard(true);
			return user;
		}

		return null;
	}

	public UserAdminDashboard getAdminDashboard() {
		UserAdminDashboard userAdminDashboard = new UserAdminDashboard();

		userAdminDashboard.setEtudiantInscrit((int) etudiantRepository.count());
		userAdminDashboard.setProfTotal((int) professeurRepository.count());
		userAdminDashboard.setChapitreTotal((int) chapitreRepository.count());
		userAdminDashboard.setCourLu((int) etudiantChapitreRepository.count());
		userAdminDashboard.setModuleTotal((int) moduleRepository.count());
		userAdminDashboard.setModuleActif((int) ((List<Module>) moduleRepository.findAll()).stream()
				.filter(module -> (module.getDateDeblocage() != null && module.getDateDeblocage().before(new Date())))
				.count());
		userAdminDashboard.setQcmValide(
				etudiantChapitreRepository.findAll().stream().mapToInt(item -> item.getQcmValide()).sum());

		userAdminDashboard
				.setTauxReuissite((userAdminDashboard.getQcmValide()*100) / (((List<Chapitre>) chapitreRepository.findAll())
						.stream().mapToInt(item -> item.getQcms().size()).sum()));
		
		System.out.println("Total QCM == "+(((List<Chapitre>) chapitreRepository.findAll())
				.stream().mapToInt(item -> item.getQcms().size()).sum()));
		
		userAdminDashboard.setQuestionPose((int) questionCourRepository.count());

		return userAdminDashboard;
	}
	
	public void envoiMail(FormMail formMail) {
		if (formMail==null) {
			throw new ElearningException(new ErrorAPI("le mail ne peut etre null"));
		}
		
		if (formMail.getObjet()==null || formMail.getObjet().length()<5) {
			throw new ElearningException(new ErrorAPI("L'objet du mail ne peut contenir moins de 5 carractere"));
		}
		
		if (formMail.getBodyHtml()==null || formMail.getBodyHtml().length()<10) {
			throw new ElearningException(new ErrorAPI("Le corps du mail ne peut contenir moins de 10 carractere"));
		}
		List<Etudiant> etudiants=new ArrayList<Etudiant>();
		
		List<GammeEtudiant> gammeEtudiants=gammeEtudiantRepository.findAll();
		
		for (GammeEtudiant gammeEtudiant : gammeEtudiants) {
			String nombre  = formMail.getProfil();
			int chiffre = gammeEtudiant.getId();
	        char chiffreChar = (char) (chiffre + '0');
	        
	        if (nombre.indexOf(chiffreChar) != -1) {
	        	etudiants.addAll(gammeEtudiant.getEtudiants());
	        }
		}
		
		senderMail.sendFromFormMailToStutend(etudiants, formMail);
	}

	public String createDefaultAdmin() {
		String email = "admin@programmeleadership.org";
		String telephone = "+237 695 83 58 77";
		
		// Vérifier si l'admin existe déjà
		Admin existingAdmin = adminRepository.findByEmailOrTelephone(email, telephone);
		
		if (existingAdmin != null) {
			return "L'administrateur existe déjà avec l'ID: " + existingAdmin.getId();
		}
		
		// Créer le nouvel admin
		Admin admin = new Admin();
		admin.setEmail(email);
		admin.setTelephone(telephone);
		admin.setNom("Administrateur");
		admin.setPrenom("Principal");
		// Utiliser Cryptage.getMd5 pour hasher le mot de passe avec le salt
		admin.setPassword(Cryptage.getMd5("admin123"));
		admin.setEtat(1);
		admin.setLevel(1);
		admin.setStatut("ACTIF");
		
		adminRepository.save(admin);
		
		return "Administrateur créé avec succès! ID: " + admin.getId() + 
		       " | Email: " + email + 
		       " | Téléphone: " + telephone;
	}

	public Page<Message> getListMessages(String filter, int pageNumber) {
		Pageable pageable = PageRequest.of(pageNumber, 20, Sort.by(Sort.Direction.DESC, "date"));
		// Pour l'instant, retourner tous les messages (sans filtre)
		// TODO: Implémenter le filtrage si nécessaire
		return messageRepository.findAll(pageable);
	}

	public Map<String, Object> getForumStatistics() {
		Map<String, Object> stats = new HashMap<>();
		List<Message> allMessages = messageRepository.findAll();
		
		int totalMessages = allMessages.size();
		int messagesActifs = 0;
		int messagesResolus = 0;
		int totalReponses = 0;
		int etudiantsActifs = 0;
		int professeursActifs = 0;
		
		// Compter les messages par état et par type d'auteur
		for (Message message : allMessages) {
			// Compter les réponses (messages enfants)
			if (message.getMessages() != null) {
				totalReponses += message.getMessages().size();
			}
			
			// Compter par état
			if (message.getEtat() != null) {
				if (message.getEtat().equals("ACTIF") || message.getEtat().equals("ACTIVE")) {
					messagesActifs++;
				} else if (message.getEtat().equals("RESOLU") || message.getEtat().equals("RESOLVED")) {
					messagesResolus++;
				}
			}
			
			// Compter les auteurs uniques (étudiants et professeurs)
			if (message.getEtudiant() != null) {
				etudiantsActifs++;
			}
			if (message.getProfesseur() != null) {
				professeursActifs++;
			}
		}
		
		stats.put("totalMessages", totalMessages);
		stats.put("messagesActifs", messagesActifs);
		stats.put("messagesResolus", messagesResolus);
		stats.put("totalReponses", totalReponses);
		stats.put("etudiantsActifs", etudiantsActifs);
		stats.put("professeursActifs", professeursActifs);
		
		return stats;
	}

}
