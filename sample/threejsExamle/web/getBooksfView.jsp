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

String stackId = "";
String booksfId = "";
String booksfNm = "";

if(request.getParameter("booksf_id") != null && !request.getParameter("booksf_id").equals("")){
	booksfId = request.getParameter("booksf_id");
}
	
try{
            // DB Open: mysql Server
            // JDBC Driver Loading
            String url = "jdbc:oracle:thin:@123.212.43.252:1521:ARCHIVE1";
            String uid = "CBCK";
            String pw = "CBCK";    
                                               
            Class.forName("oracle.jdbc.driver.OracleDriver");
           
            // Mysql DB Connection!!
            connect = DriverManager.getConnection(url,uid,pw);
            statement = connect.createStatement();
            
%>

<%
/*
String cube_list = request.getParameter("cube_list");
JSONObject obj = new JSONObject(cube_list);
JSONArray items = obj.getJSONArray("cube_list");
*/

sql = "SELECT * FROM TB_PVBOOKSF WHERE 1=1 ";
if(!booksfId.equals("") ){
	sql += "AND BOOKSF_ID = " + booksfId;
}
System.out.println(sql);
resultSet = statement.executeQuery(sql);    
while (resultSet.next()) {
    stackId = resultSet.getString("STACK_ID");
    booksfId = resultSet.getString("BOOKSF_ID");
    booksfNm = resultSet.getString("BOOKSF_NM");
}
%>

<%
resultSet.close();
statement.close();
connect.close();
}catch(IOException ioe){
            out.println(ioe);
}catch(Exception ex){
            out.println(ex);
}finally{
	
}

JSONObject obj = new JSONObject();
obj.put("stackId", stackId);
obj.put("booksfId", booksfId);
obj.put("booksfNm", booksfNm);


out.print(obj.toString());


%>