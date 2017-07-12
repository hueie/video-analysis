<%@ page language="java"%>
<%@ page contentType="text/html;charset=euc-kr"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.io.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="org.json.*"%>
<%
String stackId = request.getParameter("stackId");
stackId = "000"+stackId;
stackId = stackId.substring(stackId.length()-3);
String booksfNm = request.getParameter("booksfNm");
String booksfRemk = request.getParameter("booksfRemk");
String booksfFCnt = request.getParameter("booksfFCnt");



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
    System.out.println(stackId);
    ora_sql = "SELECT NVL(MAX(BOOKSF_ID),0) FROM TB_PVBOOKSF WHERE STACK_ID = '"+ stackId +"'";
    System.out.println(ora_sql);
    
	ora_resultSet = ora_statement.executeQuery(ora_sql);
	ora_resultSet.next();
	int booksfId = new Integer(ora_resultSet.getString(1)) + 1;
	//ora_resultSet.close();
    
    
    ora_sql = "insert into TB_PVBOOKSF(STACK_ID, BOOKSF_ID, BOOKSF_NM, BOOKSF_F_CNT, BOOKSF_R_CNT, MAX_BOX_CNT, KEEP_BOX_CNT, REMK, REG_ID, REG_NAME, REG_DT, SYS_ID, SYS_NAME, SYS_DT, PVINVENCHK_YN, PEXAM_STATUS) values"+
    " (LPAD(?, 3, '0'), LPAD(?, 3, '0'), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	System.out.println(ora_sql);
	ora_preparedStatement = ora_connect.prepareStatement(ora_sql);
	ora_preparedStatement.setString(1, stackId);
	ora_preparedStatement.setInt(2, booksfId);
	ora_preparedStatement.setString(3, booksfNm);
	ora_preparedStatement.setString(4, booksfFCnt);
	ora_preparedStatement.setInt(5, 0);
	ora_preparedStatement.setInt(6, 0);
	ora_preparedStatement.setInt(7, 0);
	ora_preparedStatement.setString(8, booksfRemk);
	ora_preparedStatement.setString(9, "0000000001");
	ora_preparedStatement.setString(10, "包府磊");
	ora_preparedStatement.setString(11, "20170616104929");
	ora_preparedStatement.setString(12, "0000000001");
	ora_preparedStatement.setString(13, "包府磊");
	ora_preparedStatement.setString(14, "20170616104929");
	ora_preparedStatement.setString(15, "01");
	ora_preparedStatement.setString(16, "01");
	
	ora_preparedStatement.executeUpdate();
    
	
	for(int idx = 1; idx < new Integer(booksfFCnt)+1 ; idx++){
		ora_sql = "insert into TB_PVBOOKSF_FLW(STACK_ID, BOOKSF_ID, FLW_NO) values"+
			    " (LPAD(?, 3, '0'), LPAD(?, 3, '0'), ?)";
		System.out.println(ora_sql);
		ora_preparedStatement = ora_connect.prepareStatement(ora_sql);
		ora_preparedStatement.setString(1, stackId);
		ora_preparedStatement.setInt(2, booksfId);
		ora_preparedStatement.setInt(3, idx);
				
		ora_preparedStatement.executeUpdate();
	}
	
	
    ora_statement.close();
    ora_connect.close();
}catch(Exception ex){
            out.println(ex);
}finally{
}
out.print("Completely Insert Data Into DB.");


%>