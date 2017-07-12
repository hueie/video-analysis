<%@ page language="java"%>
<%@ page contentType="text/html;charset=euc-kr"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.io.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="org.json.*"%>
<%
int stackId = 0;
String stackNm = request.getParameter("stackNm");
String stackRemk = request.getParameter("stackRemk");



Connection ora_connect = null;
Statement ora_statement = null;
PreparedStatement ora_preparedStatement = null;
ResultSet ora_resultSet = null;
String ora_sql = "";

try{
	// DB Open: oracle Server
    // JDBC Driver Loading
    String ora_url = "jdbc:oracle:thin:@123.212.43.252:1521:ARCHIVE1";
    String ora_uid = "CBCK";
    String ora_pw = "CBCK";    
                                       
    Class.forName("oracle.jdbc.driver.OracleDriver");
   
    // Oracle DB Connection!!
    ora_connect = DriverManager.getConnection(ora_url,ora_uid,ora_pw);

    ora_statement = ora_connect.createStatement();
    ora_sql = "SELECT COUNT(*) FROM TB_PVSTACK";
	ora_resultSet = ora_statement.executeQuery(ora_sql);
	ora_resultSet.next();
	stackId = new Integer(ora_resultSet.getString(1));
	ora_resultSet.close();
    
    
    ora_sql = "insert into TB_PVSTACK(STACK_ID, STACK_NM, KEEP_BOOKSF_CNT, REMK, REG_ID, REG_NAME, REG_DT, SYS_ID, SYS_NAME, SYS_DT) values"+
    " (LPAD(?, 3, '0'), ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	System.out.println(ora_sql);
	ora_preparedStatement = ora_connect.prepareStatement(ora_sql);
	ora_preparedStatement.setInt(1, stackId+1);
	ora_preparedStatement.setString(2, stackNm);
	ora_preparedStatement.setInt(3, 0);
	ora_preparedStatement.setString(4, stackNm);
	ora_preparedStatement.setString(5, "0000000001");
	ora_preparedStatement.setString(6, "包府磊");
	ora_preparedStatement.setString(7, "20170616104929");
	ora_preparedStatement.setString(8, "0000000001");
	ora_preparedStatement.setString(9, "包府磊");
	ora_preparedStatement.setString(10, "20170616104929");
	
	ora_preparedStatement.executeUpdate();
    
    ora_statement.close();
    ora_connect.close();
}catch(Exception ex){
            out.println(ex);
}finally{
}
out.print("Completely Delte Data Into DB.");


%>