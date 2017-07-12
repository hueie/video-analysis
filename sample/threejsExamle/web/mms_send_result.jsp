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

            // DB Open: oracle Server
		    // JDBC Driver Loading
		    String url = "jdbc:oracle:thin:@123.212.43.252:1521:ARCHIVE1";
		    String uid = "CBCK";
		    String pw = "CBCK";    
		                                       
		    Class.forName("oracle.jdbc.driver.OracleDriver");
		   
            connect = DriverManager.getConnection(url,uid,pw);
            statement = connect.createStatement();

            // Making Table!!!
            /*
            DatabaseMetaData dbm = connect.getMetaData();
            ResultSet tables = dbm.getTables(null, null, "YS_CUBE_MAP", null);
            if (tables.next()) {
                        //if test exists, pass this stage.
            } else {
                        sql = "CREATE TABLE YS_CUBE_MAP " +
                        "(cube_idx decimal(10,0), " +
                        " stack_id decimal(10,0), " +
                        " pos_x decimal(10,0), " +
                        " pos_y decimal(10,0), " +
                        " pos_z decimal(10,0), " +
                        " object_id decimal(10,0), " +
                        " cube_type decimal(10,0), " +
                        " linked_id decimal(10,0), " +
                        " size decimal(10,0), " +
                        " axis decimal(10,0) " +
                        " )";
                        statement.executeUpdate(sql);
            }
            */
%>

<%

String stack_id = request.getParameter("stack_id");

sql = "DELETE FROM YS_CUBE_MAP WHERE STACK_ID = "+stack_id;
statement.executeUpdate(sql);

String cube_list = request.getParameter("cube_list");
if(cube_list != null && !cube_list.equals("")){
	JSONObject obj = new JSONObject(cube_list);
	JSONArray items = obj.getJSONArray("cube_list");

	for (int i = 0; i < items.length(); i++) {
	            JSONObject item = items.getJSONObject(i);
	            int cube_idx = item.getInt("cube_idx");
	            int pos_x = item.getInt("pos_x");
	            int pos_y = item.getInt("pos_y");
	            int pos_z = item.getInt("pos_z");
	            int object_id = item.getInt("object_id");
	            int cube_type = item.getInt("cube_type");
	            int linked_id = item.getInt("linked_id");
	            int size = item.getInt("size");
	            int axis = item.getInt("axis");
	
	            sql = "insert into YS_CUBE_MAP(cube_idx, stack_id, pos_x, pos_y, pos_z, object_id, cube_type, linked_id, cube_size, cube_axis) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	            preparedStatement = connect.prepareStatement(sql);
	            preparedStatement.setInt(1, cube_idx);
	            preparedStatement.setInt(2, new Integer(stack_id));
	            preparedStatement.setInt(3, pos_x);
	            preparedStatement.setInt(4, pos_y);
	            preparedStatement.setInt(5, pos_z);
	            preparedStatement.setInt(6, object_id);
	            preparedStatement.setInt(7, cube_type);
	            preparedStatement.setInt(8, linked_id);
	            preparedStatement.setInt(9, size);
	            preparedStatement.setInt(10, axis);
	            preparedStatement.executeUpdate();
	}

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