package controller;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnect {
	
public static Connection getConnection() throws ClassNotFoundException, SQLException {
		
		String username = "root";
		String password = "123456";
		
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/sunrise_db?useSSL=false&allowPublicKeyRetrieval=true",username,password);
	
		return con;
	}

		public static void main(String[] args) {
		    try {
		        Connection conn = DBConnect .getConnection();
		        if (conn != null) {
		            System.out.println("Database connected successfully!");
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		}
}


