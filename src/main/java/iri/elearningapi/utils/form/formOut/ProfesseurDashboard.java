package iri.elearningapi.utils.form.formOut;

import java.util.ArrayList;
import java.util.List;

import iri.elearningapi.model.courModel.Module;

public class ProfesseurDashboard {

	private int moduleTotal = 0;
	private int qroEnAttente = 0;
	private int qroTotal = 0;
	private int etudiantTotal = 0;

	List<Module> modules = new ArrayList<>();

	public int getModuleTotal() {
		return moduleTotal;
	}

	public void setModuleTotal(int moduleTotal) {
		this.moduleTotal = moduleTotal;
	}

	public int getQroEnAttente() {
		return qroEnAttente;
	}

	public void setQroEnAttente(int qroEnAttente) {
		this.qroEnAttente = qroEnAttente;
	}

	public int getQroTotal() {
		return qroTotal;
	}

	public void setQroTotal(int qroTotal) {
		this.qroTotal = qroTotal;
	}

	public int getEtudiantTotal() {
		return etudiantTotal;
	}

	public void setEtudiantTotal(int etudiantTotal) {
		this.etudiantTotal = etudiantTotal;
	}

	public List<Module> getModules() {
		return modules;
	}

	public void setModules(List<Module> modules) {
		this.modules = modules;
	}

}

