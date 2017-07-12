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

String boxId = "";
String boxNo = "";
JSONObject obj = new JSONObject();
JSONArray jsonlist = new JSONArray();

if(request.getParameter("box_id") != null && !request.getParameter("box_id").equals("")){
	boxId = request.getParameter("box_id");
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

sql = "SELECT * FROM TB_PVBOX WHERE 1=1 ";
if(!boxId.equals("") ){
	sql += "AND BOX_ID = " + boxId;
}

resultSet = statement.executeQuery(sql);    

while (resultSet.next()) {
    boxId = resultSet.getString("BOX_ID");
    boxNo = resultSet.getString("BOX_NO");
    
    JSONObject jsonobj = new JSONObject();
    jsonobj.put("boxId", boxId);
    jsonobj.put("boxNo", boxNo);
    jsonlist.put(jsonobj);
    System.out.println(boxNo);
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