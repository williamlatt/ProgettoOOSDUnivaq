package model;
import dao_dto.DTO;

public class Model {
	String nome;
	
	public Model() {};
	
	public void setnomeModel() {
		this.nome = DTO.getnomeDTO();
	}
	
	public void stampanome() {
		System.out.println(this.nome);
	}
}
