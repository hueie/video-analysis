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
ResultSet resultSet, resultSet2 = null;
String sql = "";

Connection ora_connect = null;
Statement ora_statement = null;
PreparedStatement ora_preparedStatement = null;
ResultSet ora_resultSet = null;
String ora_sql = "";

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
            
            
         	// DB Open: oracle Server
            // JDBC Driver Loading
            String ora_url = "jdbc:oracle:thin:@123.212.43.252:1521:ARCHIVE1";
            String ora_uid = "CBCK";
            String ora_pw = "CBCK";    
                                               
            Class.forName("oracle.jdbc.driver.OracleDriver");
           
            // Oracle DB Connection!!
            ora_connect = DriverManager.getConnection(ora_url,ora_uid,ora_pw);
            ora_statement = ora_connect.createStatement();

%>

<%
String stackId = request.getParameter("stackId");


sql = "SELECT object_id, linked_id, pos_y, pos_x, pos_z FROM YS_CUBE_MAP where stack_id = "+stackId+" and cube_type = 7 order by object_id, pos_y";

resultSet = statement.executeQuery(sql);    
System.out.println(sql);

String obejctId="", booksfId = "";
int posY, posX, posZ;

int idx = 12;
int minPosY=9999, maxPosY=-9999, minPosX=9999, maxPosX=-9999, minPosZ=9999, maxPosZ=-9999; 
while (resultSet.next()) {
	if(idx == 12){
		idx = 0;
		minPosY=9999; maxPosY=-9999; minPosX=9999; maxPosX=-9999; minPosZ=9999; maxPosZ=-9999; 
		obejctId = resultSet.getString("object_id");
		booksfId = resultSet.getString("linked_id");
	}
	if( (0 <= idx && idx <= 3) || (8 <= idx && idx <= 11)){
		posY = resultSet.getInt("pos_y");
		posX = resultSet.getInt("pos_x");
		posZ = resultSet.getInt("pos_z");
		
		if(posX > maxPosX){
			maxPosX = posX;
		}
		if(posX < minPosX){
			minPosX = posX;
		}
		if(posZ > maxPosZ){
			maxPosZ = posZ;
		}
		if(posZ < minPosZ){
			minPosZ = posZ;
		}
		
		if(idx == 3){
			minPosY = posY;
		} else if(idx == 11){
			maxPosY = posY;
		}
	}
	if(idx == 11){
		sql = "SELECT linked_id, pos_y FROM YS_CUBE_MAP where stack_id = "+stackId+" and cube_type = 1"+ 
				" AND pos_y between "+minPosY+" and "+maxPosY+
				" AND pos_x between "+minPosX+" and "+maxPosX+
				" AND pos_z between "+minPosZ+" and "+maxPosZ;
		System.out.println(sql);

		resultSet2 = statement.executeQuery(sql);  
		int boxId = 0, arngId = 0, box_pos_y = 0;
		while (resultSet2.next()) {
			boxId = resultSet2.getInt("linked_id");
			box_pos_y = resultSet2.getInt("pos_y");
			
			ora_sql = "SELECT MAX(arng_id) FROM TB_PVBOOKARNG";
			ora_resultSet = ora_statement.executeQuery(ora_sql);
			ora_resultSet.next();
			arngId = ora_resultSet.getInt(1);
			System.out.println("arrgId : " + arngId);
			ora_resultSet.close();
			
			ora_sql = "insert into TB_PVBOOKARNG(ARNG_ID, BOX_ID, STACK_ID, BOOKSF_ID, BOOKSF_F_NO, BOOKSF_R_NO, BOOKSF_R_SNO, ARNG_CD, BOX_ARNG_DT) values (?, ?, LPAD(?, 3, '0'), LPAD(?, 3, '0'), ?, ?, ?, ?, TO_CHAR(SYSDATE, 'YYYYMMDDhh24miss'))";
			System.out.println(ora_sql);
			ora_preparedStatement = ora_connect.prepareStatement(ora_sql);
			ora_preparedStatement.setInt(1, arngId+1);
			ora_preparedStatement.setInt(2, boxId);
			ora_preparedStatement.setString(3, stackId);
			ora_preparedStatement.setString(4, booksfId);
			ora_preparedStatement.setInt(5, (box_pos_y-25)/50 + 1);
			System.out.println((box_pos_y-25)/50 + 1);
			
			ora_preparedStatement.setInt(6, 0);
			ora_preparedStatement.setInt(7, arngId+1);
			ora_preparedStatement.setString(8, "01");
			ora_preparedStatement.executeUpdate();
		}
		resultSet2.close();
	}
	idx++;
}

%>

<%
//resultSet.close();
preparedStatement.close();
statement.close();
connect.close();

ora_preparedStatement.close();
ora_statement.close();
ora_connect.close();
}catch(IOException ioe){
            out.println(ioe);
}catch(Exception ex){
            out.println(ex);
}finally{
}
out.print("Completely Insert Data Into DB.");


%>