package dao_dto;
import java.sql.*;
import java.util.*;


public class DTO {
	static String nomeDTO;
	
	public static void setnomeDTO(ResultSet myRs) throws SQLException {
		nomeDTO = myRs.getString("Nome");
	}
	
	public static String getnomeDTO() {
		return nomeDTO;
	}
	
}
