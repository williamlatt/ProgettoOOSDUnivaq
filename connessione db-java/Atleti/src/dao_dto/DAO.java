package dao_dto;
import java.sql.*;
import java.util.*;

public class DAO {
	Connection myConn;
	Statement myStmt;
	public static ResultSet myRs;
	String sql;
	
	public DAO() throws SQLException {
		
	    try
	    {
	    	// 0. Load the driver
	        Class.forName("com.mysql.cj.jdbc.Driver");
	    }
	    catch(ClassNotFoundException e)
	    {
	       System.out.println("ClassNotFoundException: ");
	       System.err.println(e.getMessage());
	    }
	    // 1. Get a connection to database
		 myConn = DriverManager.getConnection("jdbc:mysql://localhost:3306/nuoto_atleti?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC&useSSL=false","root","root");
		 sql = "select Nome from atleti where atleti.Nome = 'willi'";
		 
		 try {
			// 2. Create a statement
			 myStmt = myConn.createStatement();
			// 3. Execute SQL query
			 myRs = myStmt.executeQuery(sql);
			 while(myRs.next() == true) {
				DTO.setnomeDTO(myRs);
			 }
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
