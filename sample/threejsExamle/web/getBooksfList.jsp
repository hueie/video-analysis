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

String stackId = request.getParameter("stackId");
String booksfId = "";
String booksfNm = "";
String booksfFCnt = "";
JSONObject obj = new JSONObject();
JSONArray jsonlist = new JSONArray();

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

sql = "SELECT * FROM TB_PVBOOKSF WHERE 1=1 AND STACK_ID = "+stackId;
if(!booksfId.equals("") ){
	sql += " AND BOOKSF_ID = " + booksfId;
}
System.out.println(sql);
resultSet = statement.executeQuery(sql);    
while (resultSet.next()) {
    stackId = resultSet.getString("STACK_ID");
    booksfId = resultSet.getString("BOOKSF_ID");
    booksfNm = resultSet.getString("BOOKSF_NM");
    booksfFCnt = resultSet.getString("BOOKSF_F_CNT");
    
    
    JSONObject jsonobj = new JSONObject();
    jsonobj.put("stackId", stackId);
    jsonobj.put("booksfId", booksfId);
    jsonobj.put("booksfNm", booksfNm);
    jsonobj.put("booksfFCnt", booksfFCnt);
    jsonlist.put(jsonobj);
    System.out.println(booksfNm);
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

obj.put("data", jsonlist);
out.print(obj.toString());
%>