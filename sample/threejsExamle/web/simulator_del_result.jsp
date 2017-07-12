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
            String url = "jdbc:mysql://localhost:3306/recognitiontestdb";
            String uid = "root";
            String pw = "1234";    
                                               
            Class.forName("com.mysql.jdbc.Driver");
           
            // Mysql DB Connection!!
            connect = DriverManager.getConnection(url,uid,pw);
            statement = connect.createStatement();

            // Making Table!!!
            DatabaseMetaData dbm = connect.getMetaData();
            ResultSet tables = dbm.getTables(null, null, "cube_map", null);
            if (tables.next()) {
            	sql = "DELETE FROM cube_map";
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