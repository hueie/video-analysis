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
                        //if test exists, pass this stage.
            } else {
                        sql = "CREATE TABLE cube_map " +
                        "(cube_idx decimal(10,0), " +
                        " pos_x decimal(10,0), " +
                        " pos_y decimal(10,0), " +
                        " pos_z decimal(10,0), " +
                        " cube_type decimal(10,0), " +
                        " linked_id decimal(10,0) " +
                        " )";
                        statement.executeUpdate(sql);
            }
%>

<%
String cube_list = request.getParameter("cube_list");
JSONObject obj = new JSONObject(cube_list);
JSONArray items = obj.getJSONArray("cube_list");

for (int i = 0; i < items.length(); i++) {
            JSONObject item = items.getJSONObject(i);
            int cube_idx = item.getInt("cube_idx");
            int pos_x = item.getInt("pos_x");
            int pos_y = item.getInt("pos_y");
            int pos_z = item.getInt("pos_z");
            int cube_type = item.getInt("cube_type");
            int linked_id = item.getInt("linked_id");

            sql = "insert into cube_map(cube_idx, pos_x, pos_y, pos_z, cube_type, linked_id) values (?, ?, ?, ?, ?, ?)";
            preparedStatement = connect.prepareStatement(sql);
            preparedStatement.setInt(1, cube_idx);
            preparedStatement.setInt(2, pos_x);
            preparedStatement.setInt(3, pos_y);
            preparedStatement.setInt(4, pos_z);
            preparedStatement.setInt(5, cube_type);
            preparedStatement.setInt(6, linked_id);
            preparedStatement.executeUpdate();
}
%>

<%
//resultSet.close();
preparedStatement.close();
statement.close();
connect.close();
}catch(IOException ioe){
            out.println(ioe);
}catch(Exception ex){
            out.println(ex);
}finally{
}
out.print("Completely Insert Data Into DB.");


%>