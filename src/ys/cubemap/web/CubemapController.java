package kams.ys.cubemap.web;

import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kams.clas.busclas.service.ClasBusclasVO;
import kams.ys.cubemap.service.CubemapVO;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class CubemapController {

	@RequestMapping("/ys/cubemap/Cubemap.do")
	public String Cubemap(@ModelAttribute("CubemapVO")CubemapVO CubemapVO, ModelMap model, HttpSession session) throws Exception {
		String stack_id = CubemapVO.getStack_id();
		if (stack_id == null || stack_id.equals("")) {
			stack_id = "0";
		}

		Connection connect = null;
		Statement statement = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "";

		JSONObject obj = new JSONObject();
		JSONArray jsonlist = new JSONArray();
		
		try {
			// DB Open: mysql Server
			// JDBC Driver Loading
			/*
			 * String url = "jdbc:mysql://localhost:3306/mmstestdb"; String uid
			 * = "root"; String pw = "1234";
			 * 
			 * Class.forName("com.mysql.jdbc.Driver");
			 */
			// Mysql DB Connection!!

			// DB Open: oracle Server
			// JDBC Driver Loading
			String url = "jdbc:oracle:thin:@123.212.43.252:1521:ARCHIVE1";
			String uid = "CBCK";
			String pw = "CBCK";

			Class.forName("oracle.jdbc.driver.OracleDriver");

			connect = DriverManager.getConnection(url, uid, pw);
			statement = connect.createStatement();


			if (!stack_id.equals("0")) {
				sql = "SELECT * FROM YS_CUBE_MAP WHERE STACK_ID = " + stack_id + " ORDER BY STACK_ID";
				System.out.println(sql);
				resultSet = statement.executeQuery(sql);
				 
				while (resultSet.next()) {
					JSONObject jsonobj = new JSONObject();
					jsonobj.put("x", resultSet.getString("POS_X"));
					jsonobj.put("y", resultSet.getString("POS_Y"));
					jsonobj.put("z", resultSet.getString("POS_Z"));
					jsonobj.put("object_id", resultSet.getString("OBJECT_ID"));
					jsonobj.put("cube_type", resultSet.getString("CUBE_TYPE"));
					jsonobj.put("linked_id", resultSet.getString("LINKED_ID"));
					jsonobj.put("size", resultSet.getString("CUBE_SIZE"));
					jsonobj.put("axis", resultSet.getString("CUBE_AXIS"));
				    jsonlist.put(jsonobj);
				}
			}

			// resultSet.close();
			preparedStatement.close();
			statement.close();
			connect.close();

		} catch (Exception ex) {
		} finally {
		}
		obj.put("data", jsonlist);
		CubemapVO.setCubes(obj.toString());
		model.addAttribute("CubemapVO", CubemapVO);
		return "/ys/cubemap/Cubemap";
	}
	
	@RequestMapping("/ys/cubemap/CubemapStackList.do")
	public void CubemapStackList(ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		//@RequestParam("clss_cd")String clss_cd, 
		
		//ClasBusclasVO clasBusclasVO = regProdService.RegProdClsBuscls(clss_cd);
		//model.addAttribute("clasBusclasVO", obj);
		//model.addAttribute("clss_cd", clss_cd);
		
		Connection connect = null;
		Statement statement = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "";

		String stackId = "";
		String stackNm = "";
		JSONObject obj = new JSONObject();
		JSONArray jsonlist = new JSONArray();

		/*
		if(request.getParameter("stack_id") != null && !request.getParameter("stack_id").equals("")){
			stackId = request.getParameter("stack_id");
		}
			*/
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
		            
		/*
		String cube_list = request.getParameter("cube_list");
		JSONObject obj = new JSONObject(cube_list);
		JSONArray items = obj.getJSONArray("cube_list");
		*/

		sql = "SELECT * FROM TB_PVSTACK WHERE 1=1 ";
		if(!stackId.equals("") ){
			sql += "AND STACK_ID = " + stackId;
		}
		sql += " ORDER BY STACK_ID";
		resultSet = statement.executeQuery(sql);    
		while (resultSet.next()) {
			stackId = resultSet.getString("STACK_ID");
		    stackNm = resultSet.getString("STACK_NM");

		    JSONObject jsonobj = new JSONObject();
		    jsonobj.put("stackId", stackId);
		    jsonobj.put("stackNm", stackNm);
		    jsonlist.put(jsonobj);
		    System.out.println(stackNm);
		}
		resultSet.close();
		statement.close();
		connect.close();
		}catch(Exception ex){
		}finally{
			
		}

		obj.put("data", jsonlist);
		response.setContentType("application/json; charset=UTF-8");
		response.setHeader("Cache-Control", "no-cache");
		PrintWriter out = response.getWriter();
		out.write(obj.toString());
		out.flush();
	}
	
	@RequestMapping(value = "/ys/cubemap/CubemapBooksfList.do", method = RequestMethod.POST)
	public void CubemapBooksfList(@RequestParam(value="stackId", required = false)String stackId, 
			@RequestParam(value="booksf_id", required = false)String booksfId, 
			HttpServletResponse response) throws Exception {
		Connection connect = null;
		Statement statement = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "";
		
		//String stackId = request.getParameter("stackId");
		//String booksfId = "";
		String booksfNm = "";
		String booksfFCnt = "";
		JSONObject obj = new JSONObject();
		JSONArray jsonlist = new JSONArray();
		
		/*
		if(request.getParameter("booksf_id") != null && !request.getParameter("booksf_id").equals("")){
			booksfId = request.getParameter("booksf_id");
		}
		*/
		if(booksfId == null){
			booksfId = "";
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
		resultSet.close();
		statement.close();
		connect.close();
		}catch(Exception ex){
		}finally{
			
		}

		
		
		
		obj.put("data", jsonlist);
		response.setContentType("application/json; charset=UTF-8");
		response.setHeader("Cache-Control", "no-cache");
		PrintWriter out = response.getWriter();
		out.write(obj.toString());
		out.flush();
	}
	
	@RequestMapping(value = "/ys/cubemap/CubemapAddStack.do", method = RequestMethod.POST)
	public void CubemapAddStack(@RequestParam(value="stackNm", required = false)String stackNm, 
			@RequestParam(value="stackRemk", required = false)String stackRemk, 
			HttpServletResponse response) throws Exception {
		
		int stackId = 0;

		Connection connect = null;
		Statement statement = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "";

		try{
			// DB Open: oracle Server
		    // JDBC Driver Loading
		    String url = "jdbc:oracle:thin:@123.212.43.252:1521:ARCHIVE1";
		    String uid = "CBCK";
		    String pw = "CBCK";    
		                                       
		    Class.forName("oracle.jdbc.driver.OracleDriver");
		   
		    // Oracle DB Connection!!
		    connect = DriverManager.getConnection(url,uid,pw);

		    statement = connect.createStatement();
		    sql = "SELECT COUNT(*) FROM TB_PVSTACK";
			resultSet = statement.executeQuery(sql);
			resultSet.next();
			stackId = new Integer(resultSet.getString(1));
			resultSet.close();
		    
		    
		    sql = "insert into TB_PVSTACK(STACK_ID, STACK_NM, KEEP_BOOKSF_CNT, REMK, REG_ID, REG_NAME, REG_DT, SYS_ID, SYS_NAME, SYS_DT) values"+
		    " (LPAD(?, 3, '0'), ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			System.out.println(sql);
			preparedStatement = connect.prepareStatement(sql);
			preparedStatement.setInt(1, stackId+1);
			preparedStatement.setString(2, stackNm);
			preparedStatement.setInt(3, 0);
			preparedStatement.setString(4, stackNm);
			preparedStatement.setString(5, "0000000001");
			preparedStatement.setString(6, "관리자");
			preparedStatement.setString(7, "20170616104929");
			preparedStatement.setString(8, "0000000001");
			preparedStatement.setString(9, "관리자");
			preparedStatement.setString(10, "20170616104929");
			
			preparedStatement.executeUpdate();
		    
		    statement.close();
		    connect.close();
		}catch(Exception ex){
		}finally{
		}
		
		//response.setContentType("application/json; charset=UTF-8");
		response.setHeader("Cache-Control", "no-cache");
		PrintWriter out = response.getWriter();
		out.write("Completely Delte Data Into DB.");
		out.flush();
	}
	
	
	@RequestMapping(value = "/ys/cubemap/CubemapAddBooksf.do", method = RequestMethod.POST)
	public void CubemapAddBooksf(@RequestParam(value="stackId", required = false)String stackId, 
			@RequestParam(value="booksfNm", required = false)String booksfNm, 
			@RequestParam(value="booksfRemk", required = false)String booksfRemk, 
			@RequestParam(value="booksfFCnt", required = false)String booksfFCnt, 
			HttpServletResponse response) throws Exception {
		
		stackId = "000"+stackId;
		stackId = stackId.substring(stackId.length()-3);
		
		System.out.println(stackId + " " + booksfNm + " " + booksfRemk + " " + booksfFCnt);
		
		Connection connect = null;
		Statement statement = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "";

		try{
			// DB Open: oracle Server
		    // JDBC Driver Loading
		    String url = "jdbc:oracle:thin:@123.212.43.252:1521:ARCHIVE1";
		    String uid = "CBCK";
		    String pw = "CBCK";    
		                                       
		    Class.forName("oracle.jdbc.driver.OracleDriver");
		   
		    // Oracle DB Connection!!
		    connect = DriverManager.getConnection(url,uid,pw);

		    statement = connect.createStatement();
		    System.out.println(stackId);
		    sql = "SELECT NVL(MAX(BOOKSF_ID),0) FROM TB_PVBOOKSF WHERE STACK_ID = '"+ stackId +"'";
		    System.out.println(sql);
		    
			resultSet = statement.executeQuery(sql);
			resultSet.next();
			int booksfId = new Integer(resultSet.getString(1)) + 1;
			//resultSet.close();
		    
		    
		    sql = "insert into TB_PVBOOKSF(STACK_ID, BOOKSF_ID, BOOKSF_NM, BOOKSF_F_CNT, BOOKSF_R_CNT, MAX_BOX_CNT, KEEP_BOX_CNT, REMK, REG_ID, REG_NAME, REG_DT, SYS_ID, SYS_NAME, SYS_DT, PVINVENCHK_YN, PEXAM_STATUS) values"+
		    " (LPAD(?, 3, '0'), LPAD(?, 3, '0'), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			System.out.println(sql);
			preparedStatement = connect.prepareStatement(sql);
			preparedStatement.setString(1, stackId);
			preparedStatement.setInt(2, booksfId);
			preparedStatement.setString(3, booksfNm);
			preparedStatement.setString(4, booksfFCnt);
			preparedStatement.setInt(5, 0);
			preparedStatement.setInt(6, 0);
			preparedStatement.setInt(7, 0);
			preparedStatement.setString(8, booksfRemk);
			preparedStatement.setString(9, "0000000001");
			preparedStatement.setString(10, "관리자");
			preparedStatement.setString(11, "20170616104929");
			preparedStatement.setString(12, "0000000001");
			preparedStatement.setString(13, "관리자");
			preparedStatement.setString(14, "20170616104929");
			preparedStatement.setString(15, "01");
			preparedStatement.setString(16, "01");
			
			preparedStatement.executeUpdate();
		    
			
			for(int idx = 1; idx < new Integer(booksfFCnt)+1 ; idx++){
				sql = "insert into TB_PVBOOKSF_FLW(STACK_ID, BOOKSF_ID, FLW_NO) values"+
					    " (LPAD(?, 3, '0'), LPAD(?, 3, '0'), ?)";
				System.out.println(sql);
				preparedStatement = connect.prepareStatement(sql);
				preparedStatement.setString(1, stackId);
				preparedStatement.setInt(2, booksfId);
				preparedStatement.setInt(3, idx);
						
				preparedStatement.executeUpdate();
			}
			
			
		    statement.close();
		    connect.close();
		}catch(Exception ex){
		}finally{
		}

	
	response.setHeader("Cache-Control", "no-cache");
	PrintWriter out = response.getWriter();
	out.write("Completely Delte Data Into DB.");
	out.flush();
}
	
	@RequestMapping(value = "/ys/cubemap/CubemapBoxList.do", method = RequestMethod.POST)
	public void CubemapBoxList(@RequestParam(value="box_id", required = false)String boxId, 
			@RequestParam(value="booksf_id", required = false)String booksfId, 
			HttpServletResponse response) throws Exception {
		
		Connection connect = null;
		Statement statement = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "";

		String boxNo = "";
		JSONObject obj = new JSONObject();
		JSONArray jsonlist = new JSONArray();

		if(boxId == null){
			boxId =  "";
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

		resultSet.close();
		statement.close();
		connect.close();
		}catch(Exception ex){
		}finally{
			
		}

		obj.put("data", jsonlist);
		
		response.setHeader("Cache-Control", "no-cache");
		PrintWriter out = response.getWriter();
		out.write(obj.toString());
		out.flush();
	}
	
	
	@RequestMapping(value = "/ys/cubemap/CubemapBoxView.do", method = RequestMethod.POST)
	public void CubemapBoxView(@RequestParam(value="box_id", required = false)String boxId, 
			HttpServletResponse response) throws Exception {
		
		Connection connect = null;
		Statement statement = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "";

		String boxNo = "";

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
		    
		}
		resultSet.close();
		statement.close();
		connect.close();
		}catch(Exception ex){
		}finally{
			
		}

		JSONObject obj = new JSONObject();
		obj.put("boxId", boxId);
		obj.put("boxNo", boxNo);
		
		response.setHeader("Cache-Control", "no-cache");
		PrintWriter out = response.getWriter();
		out.write(obj.toString());
		out.flush();
	}
	
	
	
	@RequestMapping(value = "/ys/cubemap/CubemapBooksfView.do", method = RequestMethod.POST)
	public void CubemapBooksfView(@RequestParam(value="booksf_id", required = false)String booksfId, 
			HttpServletResponse response) throws Exception {
	
		Connection connect = null;
		Statement statement = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "";

		String stackId = "";
		String booksfNm = "";
			
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
		resultSet.close();
		statement.close();
		connect.close();
		}catch(Exception ex){
		}finally{
			
		}

		JSONObject obj = new JSONObject();
		obj.put("stackId", stackId);
		obj.put("booksfId", booksfId);
		obj.put("booksfNm", booksfNm);


		
		response.setHeader("Cache-Control", "no-cache");
		PrintWriter out = response.getWriter();
		out.write(obj.toString());
		out.flush();
	}	
	
	@RequestMapping(value = "/ys/cubemap/CubemapSavemap.do", method = RequestMethod.POST)
	public void CubemapSavemap(@RequestParam(value="cube_list", required = false)String cube_list, 
			@RequestParam(value="stack_id", required = false)String stack_id, 
			HttpServletResponse response) throws Exception {
		
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

		sql = "DELETE FROM YS_CUBE_MAP WHERE STACK_ID = "+stack_id;
		statement.executeUpdate(sql);

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
		//resultSet.close();
		preparedStatement.close();
		statement.close();
		connect.close();
		}catch(Exception ex){
		}finally{
		}


		
		response.setHeader("Cache-Control", "no-cache");
		PrintWriter out = response.getWriter();
		out.write("Completely Insert Data Into DB.");
		out.flush();
	}	
	
	@RequestMapping(value = "/ys/cubemap/CubemapSavestack.do", method = RequestMethod.POST)
	public void CubemapSavestack(@RequestParam(value="stackId", required = false)String stackId, 
			HttpServletResponse response) throws Exception {
		
		Connection connect = null;
		Statement statement = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet, resultSet2 = null;
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
					
					sql = "SELECT MAX(arng_id) FROM TB_PVBOOKARNG";
					resultSet = statement.executeQuery(sql);
					resultSet.next();
					arngId = resultSet.getInt(1);
					System.out.println("arrgId : " + arngId);
					resultSet.close();
					
					sql = "insert into TB_PVBOOKARNG(ARNG_ID, BOX_ID, STACK_ID, BOOKSF_ID, BOOKSF_F_NO, BOOKSF_R_NO, BOOKSF_R_SNO, ARNG_CD, BOX_ARNG_DT) values (?, ?, LPAD(?, 3, '0'), LPAD(?, 3, '0'), ?, ?, ?, ?, TO_CHAR(SYSDATE, 'YYYYMMDDhh24miss'))";
					System.out.println(sql);
					preparedStatement = connect.prepareStatement(sql);
					preparedStatement.setInt(1, arngId+1);
					preparedStatement.setInt(2, boxId);
					preparedStatement.setString(3, stackId);
					preparedStatement.setString(4, booksfId);
					preparedStatement.setInt(5, (box_pos_y-25)/50 + 1);
					System.out.println((box_pos_y-25)/50 + 1);
					
					preparedStatement.setInt(6, 0);
					preparedStatement.setInt(7, arngId+1);
					preparedStatement.setString(8, "01");
					preparedStatement.executeUpdate();
				}
				resultSet2.close();
			}
			idx++;
		}

		//resultSet.close();
		preparedStatement.close();
		statement.close();
		connect.close();

		preparedStatement.close();
		statement.close();
		connect.close();
		}catch(Exception ex){
		}finally{
		}
		
		response.setHeader("Cache-Control", "no-cache");
		PrintWriter out = response.getWriter();
		out.write("Completely Insert Data Into DB.");
		out.flush();
	}	
		
}
