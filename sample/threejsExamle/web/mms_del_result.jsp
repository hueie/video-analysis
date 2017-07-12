<%@ page language="java"%>
<%@ page contentType="text/html;charset=euc-kr"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.io.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="org.json.*"%>
<%
Connection connect = null;
Statement statement = null;
PreparedStatement preparedStatement = null;
ResultSet resultSet = null;
String sql = "";

try{
            // DB Open: mysql Server
            // JDBC Driver Loading
            /*
            String url = "jdbc:mysql://localhost:3306/mmstestdb";
            String uid = "root";
            String pw = "1234";    
                                               
            Class.forName("com.mysql.jdbc.Driver");
            */
            // Mysql DB Connection!!
            
            // DB Open: oracle Server
		    // JDBC Driver Loading
		    String url = "jdbc:oracle:thin:@123.212.43.252:1521:ARCHIVE1";
		    String uid = "CBCK";
		    String pw = "CBCK";    
		                                       
		    Class.forName("oracle.jdbc.driver.OracleDriver");
            
            connect = DriverManager.getConnection(url,uid,pw);
            statement = connect.createStatement();

            // Making Table!!!
            DatabaseMetaData dbm = connect.getMetaData();
            ResultSet tables = dbm.getTables(null, null, "YS_CUBE_MAP", null);
            if (tables.next()) {
            	sql = "DELETE FROM YS_CUBE_MAP";
                statement.executeUpdate(sql);
            } else {
                        
            }
statement.close();
connect.close();
}catch(Exception ex){
            out.println(ex);
}finally{
}
out.print("Completely Delte Data Into DB.");


%>