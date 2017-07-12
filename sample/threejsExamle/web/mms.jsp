<%@ page language="java"%>
<%@ page contentType="text/html;charset=euc-kr"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.io.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="org.json.*"%>

<%
String stack_id = request.getParameter("stack_id");
if(stack_id == null || stack_id.equals("")){
	stack_id = "0";
}

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
            // Mysql DB Connection!!
            
            // DB Open: oracle Server
		    // JDBC Driver Loading
		    String url = "jdbc:oracle:thin:@123.212.43.252:1521:ARCHIVE1";
		    String uid = "CBCK";
		    String pw = "CBCK";    
		                                       
		    Class.forName("oracle.jdbc.driver.OracleDriver");
		   
            connect = DriverManager.getConnection(url,uid,pw);
            statement = connect.createStatement();

            if(!stack_id.equals("0")){
                sql = "SELECT * FROM YS_CUBE_MAP WHERE STACK_ID = "+ stack_id;
                System.out.println(sql);
                resultSet = statement.executeQuery(sql);
            }

%>

<!DOCTYPE html>
<html lang="en">
	<head>
		<title>Small Shop Interior YS</title>
		<!-- https://threejs.org/examples/#canvas_interactive_voxelpainter -->
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
		<style>
			body {
				font-family: Monospace;
				background-color: #f0f0f0;
				margin: 0px;
				overflow: hidden;
			}
			#oldie { background-color: #ddd !important }
			canvas{
			    display: inline;
			    margin: 0 auto;
			}
		</style>
		<script type="text/javascript">
		var object_id = 0; //In Graph
		var static_linked_id = 0;
		
		function view(){
			var stack_id = $("#stack_id").val();
			window.location = 'mms_view.jsp?stack_id='+stack_id;
		}
		
		function sendtodb(){
            var str = "";
			var cube_list = [];
			//axis : none:0 y:1 z:2 x:3
			var cube_idx, pos_x, pos_y, pos_z, object_id, cube_type, linked_id, size, axis;
            for (var idx in objects) {
				if(idx != 0){
					str += '\n'+idx +'th ';
					cube_idx = idx;
					for (var key in objects[idx]) {
				        if (objects[idx].hasOwnProperty(key)) {
				            if(key == "position"){
				            	str += ' x:' + objects[idx][key]['x'];
				            	str += ' y:' + objects[idx][key]['y'];
				            	str += ' z:' + objects[idx][key]['z'];
				            	
				            	pos_x = objects[idx][key]['x'];
				            	pos_y = objects[idx][key]['y'];
				            	pos_z = objects[idx][key]['z'];
				            }
				            if(key == "name"){
				            	//alert(objects[idx][key]);
				            	var jsonobj = JSON.parse(objects[idx][key]);
				            	str += ' obj_id : '+jsonobj.object_id +' ';
			        			str += ' object_id : ' + jsonobj.object_id +' ';
				            	str += ' cube_type : '+jsonobj.cube_type +' ';
			        			str += ' linked_id : ' + jsonobj.linked_id +' ';
			        			str += ' size : ' + jsonobj.size +' ';
			        			str += ' axis : ' + jsonobj.axis +' ';

			        			object_id = jsonobj.object_id;
			        			cube_type = jsonobj.cube_type;
			        			linked_id = jsonobj.linked_id;
			        			size = jsonobj.size;
			        			axis = jsonobj.axis;
				            }
				        }
					}
					cube_list.push({cube_idx:cube_idx, pos_x:pos_x, pos_y:pos_y, pos_z:pos_z, object_id:object_id, cube_type:cube_type, linked_id:linked_id, size:size, axis:axis });
				}
		    }
			alert(str);
			
			var stack_id = $("#stack_id").val();
			var myJsonString = "{cube_list:"+JSON.stringify(cube_list)+"}";
            $.ajax({
                type: "post",
                url: "mms_send_result.jsp",
                data: {"cube_list" : myJsonString, "stack_id":stack_id},
                success: function(msg){
                    alert(msg);
                },
                error:function (xhr, ajaxOptions, thrownError){
                    alert(xhr.status);
                    alert(thrownError);
                } 
            });
			
		}
		function adapt(stackId){
			$.ajax({
                type: "post",
                url: "mms_adapt.jsp",
                data: {"stackId" : stackId},
                success: function(msg){
                    alert(msg);
                },
                error:function (xhr, ajaxOptions, thrownError){
                    alert(xhr.status);
                    alert(thrownError);
                } 
            });
			//window.location = 'mms_adapt.jsp?stackId='+stackId;
		}
		
		function addStack(){
			var stackNm = $("#stack_nm").val();
			var stackRemk = $("#stack_remk").val();
			
			$.ajax({
                type: "post",
                url: "mms_addStack.jsp",
                data: {"stackNm" : stackNm, "stackRemk" : stackRemk},
                success: function(msg){
                    alert(msg);
                    getStackList();
                },
                error:function (xhr, ajaxOptions, thrownError){
                    alert(xhr.status);
                    alert(thrownError);
                } 
            });
		}
		
		function addBooksf(){
			var stackId = $("#stack_id").val();
			var booksfNm = $("#booksf_nm").val();
			var booksfRemk = $("#booksf_remk").val();
			var booksfFCnt = $("#booksf_y").val();
			
			$.ajax({
                type: "post",
                url: "mms_addBooksf.jsp",
                data: {"stackId" : stackId, "booksfNm" : booksfNm, "booksfRemk" : booksfRemk, "booksfFCnt":booksfFCnt},
                success: function(msg){
                    alert(msg);
                    getBooksfList();
                },
                error:function (xhr, ajaxOptions, thrownError){
                    alert(xhr.status);
                    alert(thrownError);
                } 
            });
		}
		
		function setStackId(stackId){
			window.location = 'mms.jsp?stack_id='+stackId;
		}
		
		function getStackList(){
			$("#stack_add_form").css("display","block");
			$("#booksf_add_form").css("display","none");
			$("#box_add_form").css("display","none");
			//서고
	        var stack_id = 0;
	        
			$.ajax({
                type: "post",
                url: "getStackList.jsp",
                data: { },
                success: function(msg){
                	var objs = JSON.parse(msg);
                	var obj = objs.data;
                	var html = "";
                	for(var idx in obj){
                		html += "<span><button onclick=\"setStackId("+obj[idx].stackId+")\">서고배치</button> "+ obj[idx].stackId + ", " + obj[idx].stackNm + "</span><br>"; 
                	}
                	document.getElementById("list").innerHTML = html;
                },
                error:function (xhr, ajaxOptions, thrownError){
                    alert(xhr.status);
                    alert(thrownError);
                } 
            });
		}
		
		function getBooksfList(){
			$("#stack_add_form").css("display","none");
			$("#booksf_add_form").css("display","block");
			$("#box_add_form").css("display","none");
			//서가
	        var stack_id = $("#stack_id").val();
			$.ajax({
                type: "post",
                url: "getBooksfList.jsp",
                data: {"stackId":stack_id },
                success: function(msg){
                	var objs = JSON.parse(msg);
                	var obj = objs.data;
                	var html = "";
                	for(var idx in obj){
                		
                		html += "<span><button onclick=\"upNdown('static_booksf_y',"+obj[idx].booksfFCnt+");upNdown('linked_id',"+obj[idx].booksfId+");setPen_type(7)\">서가배치</button> "+ obj[idx].stackId + ", " + obj[idx].booksfId + ", " + obj[idx].booksfNm + "</span><br>"; 
                	}
                	document.getElementById("list").innerHTML = html;
                },
                error:function (xhr, ajaxOptions, thrownError){
                    alert(xhr.status);
                    alert(thrownError);
                } 
            });
		}
		
		function getBoxList(){
			$("#stack_add_form").css("display","none");
			$("#booksf_add_form").css("display","none");
			$("#box_add_form").css("display","block");
			//상자
	        var box_id = 0;
	        
			$.ajax({
                type: "post",
                url: "getBoxList.jsp",
                data: { },
                success: function(msg){
                	var objs = JSON.parse(msg);
                	var obj = objs.data;
                	var html = "";
                	for(var idx in obj){
                		html += "<span><button onclick=\"upNdown('linked_id',"+obj[idx].boxId+");setPen_type(1)\">흰상자배치</button><button onclick=\"upNdown('linked_id',"+obj[idx].boxId+");setPen_type(2)\">빨간상자배치</button> "+ obj[idx].boxId + ", " + obj[idx].boxNo + "</span><br>"; 
                	}
                	document.getElementById("list").innerHTML = html;
                },
                error:function (xhr, ajaxOptions, thrownError){
                    alert(xhr.status);
                    alert(thrownError);
                } 
            });
		}
		
		function getBooksfView(booksf_id){
			//서가
			$.ajax({
                type: "post",
                url: "getBooksfView.jsp",
                data: { "booksf_id" : booksf_id},
                success: function(msg){
                	var obj = JSON.parse(msg);
                	document.getElementById("view").innerHTML = "<span>"+ obj.stackId + ", " + obj.booksfId + ", " + obj.booksfNm + "</span><br>"; 
                },
                error:function (xhr, ajaxOptions, thrownError){
                    alert(xhr.status);
                    alert(thrownError);
                } 
            });
		}
		
		function getBoxView(box_id){
			//상자
			$.ajax({
                type: "post",
                url: "getBoxView.jsp",
                data: { "box_id" : box_id},
                success: function(msg){
                	var obj = JSON.parse(msg);
                	document.getElementById("view").innerHTML = "<span>"+ obj.boxId + ", " + obj.boxNo + "</span><br>"; 
                },
                error:function (xhr, ajaxOptions, thrownError){
                    alert(xhr.status);
                    alert(thrownError);
                } 
            });
		}
		
		
		var booksf_y = 1; 
		var booksf_z = 1; 
		var booksf_x = 1; 
		
		function upNdown(tag_id,i){
			var value =  $("#"+tag_id).val();
			if(tag_id == "linked_id"){
				value = i;
			} else if(tag_id == "static_booksf_y"){
				value = i;
			} else{
				value = parseInt(value) + parseInt(i);
			}
			
			if(value >= 0){
				if(tag_id == "static_booksf_y"){
					$("#booksf_y").val(value);
				} else {
					$("#"+tag_id).val(value);
				}
			}
			
			if(tag_id == "booksf_y"){
				booksf_y = value;
			} else if(tag_id == "booksf_z"){
				booksf_z = value;
			} else if(tag_id == "booksf_x"){
				booksf_x = value;
			} else if(tag_id == "linked_id"){
				static_linked_id = value;
			} else if(tag_id == "static_booksf_y"){
				booksf_y = value;
			}
		}
		</script>
	</head>
	<body>
		<div style="width:60%;position:absolute">
			<div id="info">
				<!-- <strong>Small Shop Interior YS</strong><br> -->
				<strong>Left Key</strong>: Rotate Left, <strong>Right Key</strong>: Rotate Right<br><hr><br>
			</div>
		</div>
		<div>
			<div style="width:60%;display:inline;" id="container" ></div>
			<div style="width:40%;display:inline;float:right;" >
				서고 ID : <input type="text" id="stack_id" value="<%=stack_id%>" ><br>
				연결 ID : <input type="text" id="linked_id" value="0" ><br>
				<%--
				<button onclick="setPen_type(1)">white box</button><button onclick="setPen_type(2)">red box</button>
				<button onclick="setPen_type(7)">green rack</button><button onclick="setPen_type(0)">eraser</button><br><hr><br>
				 --%>
				<button onclick="getStackList()">서고 목록 가져오기</button>
				<button onclick="getBooksfList()">서가 목록 가져오기</button>
				<button onclick="getBoxList()">상자 목록 가져오기</button>
				<button onclick="setPen_type(0)">지우개</button>
				<button onclick="setPen_type(999)">상세정보</button>
				<button onclick="sendtodb()">배치도 저장</button> 
				<button onclick="adapt(<%=stack_id%>)">배치도 반영</button> 
				<button onclick="location.reload()">되돌리기</button> 
				<%--
				<button onclick="view()">확인</button> 
				 --%>
				<br><hr><br>
				<div id="view"></div>
				<br><hr><br>
				<div id="stack_add_form" style="display:none">
					<span>
					<button onclick="addStack()">새 서고등록</button> 
					서고명 : <input type="text" id="stack_nm">
					비고 : <input type="text" id="stack_remk" >
					</span>
					<br>
				</div>
				<div id="booksf_add_form" style="display:none">
					<span>
					<button onclick="addBooksf()">새 서가등록</button> 
					서가명 : <input type="text" id="booksf_nm">
					<!-- 단계수 : <input type="text" id="booksf_f_cnt"><br> -->
					비고 : <input type="text" id="booksf_remk" >
					</span>
					<br><br>
					<div style="display:inline">x : <input type="text" id="booksf_x" style="width:20px" value="1"></input><button onclick="upNdown('booksf_x','1')">+</button><button onclick="upNdown('booksf_x','-1')">-</button></div>
					<div style="display:inline">z : <input type="text" id="booksf_z" style="width:20px" value="1"></input><button onclick="upNdown('booksf_z','1')">+</button><button onclick="upNdown('booksf_z','-1')">-</button></div>
					<div style="display:inline">단계수 : <input type="text" id="booksf_y" style="width:20px" value="1"></input><button onclick="upNdown('booksf_y','1')">+</button><button onclick="upNdown('booksf_y','-1')">-</button></div>
				</div>
				
				<div id="box_add_form" style="display:none">
					<%--
					<span>
					<button onclick="">새 상자등록</button> 
					부서명 : <input type="text" id="org_nm"><input type="hidden" name="org_cd" id="org_cd">
					상자번호 : <input type="text" id="box_no" >
					</span>
					<br>
					 --%>
				</div>
				<br><hr><br>
				<div id="list"></div>
			</div>
		</div>
		
		<script src="js/threejs/three.js"></script>
		<!-- https://github.com/mrdoob/three.js/blob/master/build/three.js -->
		<script src="js/threejs/Detector.js"></script>
		<!-- https://github.com/mrdoob/three.js/blob/master/examples/js/Detector.js -->

		<script>
			if ( ! Detector.webgl ) Detector.addGetWebGLMessage();
			var container;
			var camera, scene, renderer;
			var plane, cube, line;
			var mouse, raycaster, isShiftDown = false, isCtrlDown = false, isAltDown = false;
			var rollOverGeo, rollOverMesh, rollOverMaterial;
		
			
			var rollOverBooksfXGeo, rollOverBooksfXMaterial, realBooksfXMaterial, rollOverBooksfXMesh = [];
			var rollOverBooksfYGeo, rollOverBooksfYMaterial, realBooksfYMaterial, rollOverBooksfYMesh = [];
			var rollOverBooksfZGeo, rollOverBooksfZMaterial, realBooksfZMaterial, rollOverBooksfZMesh = [];

			var cubeGeo, cubeMaterial, cctvMaterial;
			
			var objects = [];
			var pen_type = 999; //0:eraser//1:white box//2:red box//3,4,5:y,z,x-axis green pen//6:rack
			var cubes = [];
			
			initpushdata();
			init();
			render();
			
			function initpushdata(){
				<% 
				if(!stack_id.equals("0")){
					while(resultSet.next()){ 
				%>
				cubes.push({x:<%= resultSet.getString("POS_X") %>, y:<%= resultSet.getString("POS_Y") %>, z:<%= resultSet.getString("POS_Z") %>, object_id:<%= resultSet.getString("OBJECT_ID") %>, cube_type:<%= resultSet.getString("CUBE_TYPE") %>, linked_id:<%= resultSet.getString("LINKED_ID") %>, size:<%= resultSet.getString("CUBE_SIZE") %>, axis:<%= resultSet.getString("CUBE_AXIS") %>});
	            <% 
	            	} 
				}
	            %>
			}
			
			function init() {
				//container = document.createElement( 'div' );
				//document.body.appendChild( container );
				container = document.getElementById( 'container' );
				
				/*Create Scene*/
				scene = new THREE.Scene();
				/*Camera Setting*/
				camera = new THREE.PerspectiveCamera( 45, window.innerWidth*6/10 / window.innerHeight, 1, 10000 );
				camera.position.set( 1000, 1000, 0 );
				camera.lookAt( new THREE.Vector3() );
				
				/*Blue Cube Setting (roll-over helpers)*/
				rollOverGeo = new THREE.BoxGeometry( 50, 50, 50 );
				rollOverMaterial = new THREE.MeshBasicMaterial( { color: 0x0000ff, opacity: 0.5, transparent: true } );
				rollOverMesh = new THREE.Mesh( rollOverGeo, rollOverMaterial ); 
				scene.add( rollOverMesh );
				
				/*Start Rack*/
				rollOverBooksfYGeo = new THREE.BoxGeometry(8,50*booksf_y,8);
				rollOverBooksfYMaterial = new THREE.MeshBasicMaterial( { color: 0x0000ff, opacity: 0.5, transparent: true } );
				realBooksfYMaterial = new THREE.MeshBasicMaterial( { color: 0x000000, opacity: 1, transparent: true } );
				
				rollOverBooksfYMesh[1] = new THREE.Mesh( rollOverBooksfYGeo, realBooksfYMaterial ); 
				rollOverBooksfYMesh[1].rotation.y = 0.5*Math.PI;
				//rollOverBooksfYMesh.position.copy( intersect.point ).add( intersect.face.normal );
				rollOverBooksfYMesh[1].position.divideScalar( 50 ).round().multiplyScalar( 50 );//.addScalar( 25 );
				rollOverBooksfYMesh[1].position.y += 25*booksf_y;
				scene.add( rollOverBooksfYMesh[1] );
				
				rollOverBooksfYMesh[2] = rollOverBooksfYMesh[1].clone();
				rollOverBooksfYMesh[2].position.x += 50*booksf_x;
				scene.add( rollOverBooksfYMesh[2] );

				rollOverBooksfYMesh[3] = rollOverBooksfYMesh[1].clone();
				rollOverBooksfYMesh[3].position.z += 50*booksf_z;
				scene.add( rollOverBooksfYMesh[3] );

				rollOverBooksfYMesh[4] = rollOverBooksfYMesh[1].clone();
				rollOverBooksfYMesh[4].position.x += 50*booksf_x;
				rollOverBooksfYMesh[4].position.z += 50*booksf_z;
				scene.add( rollOverBooksfYMesh[4] );
				
				
				rollOverBooksfZGeo = new THREE.BoxGeometry(8,8,50*booksf_z);
				rollOverBooksfZMaterial = new THREE.MeshBasicMaterial( { color: 0x0000ff, opacity: 0.5, transparent: true } );
				realBooksfZMaterial = new THREE.MeshBasicMaterial( { color: 0x000000, opacity: 1, transparent: true } );
				
				rollOverBooksfZMesh[1] = new THREE.Mesh( rollOverBooksfZGeo, realBooksfZMaterial ); 
				//rollOverBooksfZMesh.position.copy( intersect.point ).add( intersect.face.normal );
				rollOverBooksfZMesh[1].position.divideScalar( 50 ).round().multiplyScalar( 50 );
				rollOverBooksfZMesh[1].position.z += 25*booksf_z;
				scene.add( rollOverBooksfZMesh[1] );
				
				rollOverBooksfZMesh[2] = rollOverBooksfZMesh[1].clone();
				rollOverBooksfZMesh[2].position.y += 50*booksf_y;
				scene.add( rollOverBooksfZMesh[2] );
				
				rollOverBooksfZMesh[3] = rollOverBooksfZMesh[1].clone();
				rollOverBooksfZMesh[3].position.x += 50*booksf_x;
				scene.add( rollOverBooksfZMesh[3] );
				
				rollOverBooksfZMesh[4] = rollOverBooksfZMesh[1].clone();
				rollOverBooksfZMesh[4].position.y += 50*booksf_y;
				rollOverBooksfZMesh[4].position.x += 50*booksf_x;
				scene.add( rollOverBooksfZMesh[4] );
				
				
				rollOverBooksfXGeo = new THREE.BoxGeometry(50*booksf_x,8,8);
				rollOverBooksfXMaterial = new THREE.MeshBasicMaterial( { color: 0x0000ff, opacity: 0.5, transparent: true } );
				realBooksfXMaterial = new THREE.MeshBasicMaterial( { color: 0x000000, opacity: 1, transparent: true } );
				
				rollOverBooksfXMesh[1] = new THREE.Mesh( rollOverBooksfXGeo, realBooksfXMaterial ); 
				rollOverBooksfXMesh[1].rotation.x = 0.5*Math.PI;
				//rollOverBooksfXMesh.position.copy( intersect.point ).add( intersect.face.normal );
				rollOverBooksfXMesh[1].position.divideScalar( 50 ).round().multiplyScalar( 50 );
				rollOverBooksfXMesh[1].position.x += 25*booksf_x;
				scene.add( rollOverBooksfXMesh[1] );

				rollOverBooksfXMesh[2] = rollOverBooksfXMesh[1].clone();
				rollOverBooksfXMesh[2].position.y += 50*booksf_y;
				scene.add( rollOverBooksfXMesh[2] );
				
				rollOverBooksfXMesh[3] = rollOverBooksfXMesh[1].clone();
				rollOverBooksfXMesh[3].position.z += 50*booksf_z;
				scene.add( rollOverBooksfXMesh[3] );
				
				rollOverBooksfXMesh[4] = rollOverBooksfXMesh[1].clone();
				rollOverBooksfXMesh[4].position.y += 50*booksf_y;
				rollOverBooksfXMesh[4].position.z += 50*booksf_z;
				scene.add( rollOverBooksfXMesh[4] );
				/*End Rack*/
				
				
				/*Textures !!! */
				/*White Cube Setting*/
				cubeGeo = new THREE.BoxGeometry( 50, 50, 50 );
				//cubeMaterial = new THREE.MeshLambertMaterial( { color: 0xfeb74c, map: new THREE.TextureLoader().load( "textures/square-outline-textured.png" ) } );
				cubeMaterial = new THREE.MeshLambertMaterial( { color: 0xffffff } ); //White Cube
				/*Red Cube Setting*/
				cctvMaterial = new THREE.MeshLambertMaterial( { color: 0xff0000 } ); //Red Cube
				
				
				/*Grid Floor Setting*/
				var size = 500, step = 50;
				var geometry = new THREE.Geometry();
				for ( var i = - size; i <= size; i += step ) {
					geometry.vertices.push( new THREE.Vector3( - size, 0, i ) );
					geometry.vertices.push( new THREE.Vector3(   size, 0, i ) );
					geometry.vertices.push( new THREE.Vector3( i, 0, - size ) );
					geometry.vertices.push( new THREE.Vector3( i, 0,   size ) );
				}
				var material = new THREE.LineBasicMaterial( { color: 0x000000, opacity: 0.2, transparent: true } );
				line = new THREE.LineSegments( geometry, material );
				scene.add( line );
				
				/*Raycaster Setting : Renders a 3D world based on a 2D map*/
				raycaster = new THREE.Raycaster();
				mouse = new THREE.Vector2();
				var geometry = new THREE.PlaneBufferGeometry( 1000, 1000 );
				geometry.rotateX( -Math.PI/2 );
				plane = new THREE.Mesh( geometry, new THREE.MeshBasicMaterial( { visible: false } ) );
				scene.add( plane );
				objects.push( plane );
				
				/*Lights Setting*/
				var ambientLight = new THREE.AmbientLight( 0x606060 );
				scene.add( ambientLight );
				var directionalLight = new THREE.DirectionalLight( 0xffffff );
				directionalLight.position.set( 1, 0.75, 0.5 ).normalize();
				scene.add( directionalLight );
				
				
				/* Build Boxes*/
				for(var key in cubes){
					var voxel;
					if(cubes[key]['cube_type'] == 1){
						voxel = new THREE.Mesh( cubeGeo, cubeMaterial );
						voxel.position.set(cubes[key]['x'], cubes[key]['y'], cubes[key]['z']);
					} else if(cubes[key]['cube_type'] == 2){
						voxel = new THREE.Mesh( cubeGeo, cctvMaterial );
						voxel.position.set(cubes[key]['x'], cubes[key]['y'], cubes[key]['z']);
					} else if(cubes[key]['cube_type'] == 3){
						// green pen
						voxel = new THREE.Mesh( rollOverPenGeo, rollOverPenMaterial );
						voxel.position.set(cubes[key]['x'], cubes[key]['y'], cubes[key]['z']);
					} else if(cubes[key]['cube_type'] == 4){
						//green pen
						voxel = new THREE.Mesh( rollOverPenGeo, rollOverPenMaterial );
						voxel.rotation.x = 0.5*Math.PI;
						voxel.rotation.z = 0;
						voxel.position.set(cubes[key]['x'], cubes[key]['y'], cubes[key]['z']);
					} else if(cubes[key]['cube_type'] == 5){
						//green pen
						voxel = new THREE.Mesh( rollOverPenGeo, rollOverPenMaterial );
						voxel.rotation.x = 0.5*Math.PI;
						voxel.rotation.z = 0.5*Math.PI;
						voxel.position.set(cubes[key]['x'], cubes[key]['y'], cubes[key]['z']);
					} else if(cubes[key]['cube_type'] == 7){
						//axis : none:0 y:1 z:2 x:3
						if(cubes[key]['axis'] == 1){
							//YMesh
							var rollOverBooksfYGeo = new THREE.BoxGeometry(8,50*cubes[key]['size'],8);
							var rollOverBooksfYMaterial = new THREE.MeshBasicMaterial( { color: 0x000000, opacity: 1, transparent: true } );
							voxel = new THREE.Mesh( rollOverBooksfYGeo, rollOverBooksfYMaterial ); 
							voxel.rotation.y = 0.5*Math.PI;
							voxel.position.set(cubes[key]['x'], cubes[key]['y'], cubes[key]['z']);
						} else if(cubes[key]['axis'] == 2){
							//ZMesh
							var rollOverBooksfZGeo = new THREE.BoxGeometry(8,8,50*cubes[key]['size']);
							var rollOverBooksfZMaterial = new THREE.MeshBasicMaterial( { color: 0x000000, opacity: 1, transparent: true } );
							voxel = new THREE.Mesh( rollOverBooksfZGeo, rollOverBooksfZMaterial ); 
							voxel.position.set(cubes[key]['x'], cubes[key]['y'], cubes[key]['z']);
						} else if(cubes[key]['axis'] == 3){
							//XMesh
							var rollOverBooksfXGeo = new THREE.BoxGeometry(50*cubes[key]['size'],8,8);
							var rollOverBooksfXMaterial = new THREE.MeshBasicMaterial( { color: 0x000000, opacity: 1, transparent: true } );
							voxel = new THREE.Mesh( rollOverBooksfXGeo, rollOverBooksfXMaterial ); 
							voxel.rotation.x = 0.5*Math.PI;
							voxel.position.set(cubes[key]['x'], cubes[key]['y'], cubes[key]['z']);
						}
					}
					voxel.name = "{ \"cube_type\":"+cubes[key]['cube_type']+", \"linked_id\":"+cubes[key]['linked_id']+", \"object_id\":"+cubes[key]['object_id']+", \"size\":"+cubes[key]['size']+", \"axis\":"+cubes[key]['axis']+" }";
					scene.add( voxel );
					objects.push( voxel );
				}
				
				
				
				
				
				
				/*Render*/
				renderer = new THREE.WebGLRenderer( { antialias: true } );
				renderer.setClearColor( 0xf0f0f0 );
				renderer.setPixelRatio( window.devicePixelRatio );
				renderer.setSize( window.innerWidth*6/10, window.innerHeight );
				container.appendChild( renderer.domElement );
				
				/*Event*/
				document.getElementById('container').addEventListener( 'mousemove', onDocumentMouseMove, false );
				document.getElementById('container').addEventListener( 'mousedown', onDocumentMouseDown, false );
				document.addEventListener( 'keydown', onDocumentKeyDown, false );
				document.addEventListener( 'keyup', onDocumentKeyUp, false );
				//When Window is Resized
				window.addEventListener( 'resize', onWindowResize, false );
			}
			function onWindowResize() {
				camera.aspect = (window.innerWidth*6/10) / window.innerHeight;
				camera.updateProjectionMatrix();
				renderer.setSize( (window.innerWidth*6/10), window.innerHeight );
			}
			function onDocumentMouseMove( event ) {
				event.preventDefault();
				mouse.set( ( event.clientX / (window.innerWidth*6/10) ) * 2 - 1, - ( event.clientY / window.innerHeight ) * 2 + 1 );
				raycaster.setFromCamera( mouse, camera );
				var intersects = raycaster.intersectObjects( objects );
				if ( intersects.length > 0 ) {
					var intersect = intersects[ 0 ];
					
					//alert("Point : "+intersect.point.x+" face : "+intersect.face.normal.x); 
					if(pen_type == 0 || pen_type == 999){
						
					} else if(pen_type == 1 || pen_type == 2){
						rollOverMesh.position.copy( intersect.point ).add( intersect.face.normal );
						rollOverMesh.position.divideScalar( 50 ).floor().multiplyScalar( 50 ).addScalar( 25 );
					} else if(pen_type == 7){
						rollOverBooksfYMesh[1].scale.y = booksf_y;//50*booksf_y;
						rollOverBooksfYMesh[2].scale.y = booksf_y;
						rollOverBooksfYMesh[3].scale.y = booksf_y;//50*booksf_y;
						rollOverBooksfYMesh[4].scale.y = booksf_y;
						
						rollOverBooksfYMesh[1].position.copy( intersect.point ).add( intersect.face.normal );
						rollOverBooksfYMesh[1].position.divideScalar( 50 ).round().multiplyScalar( 50 );//.addScalar( 25 );
						rollOverBooksfYMesh[1].position.y += 25*booksf_y;
						
						rollOverBooksfYMesh[2].position.copy( intersect.point ).add( intersect.face.normal );
						rollOverBooksfYMesh[2].position.divideScalar( 50 ).round().multiplyScalar( 50 );//.addScalar( 25 );
						rollOverBooksfYMesh[2].position.y += 25*booksf_y;
						rollOverBooksfYMesh[2].position.x += 50*booksf_x;
						
						rollOverBooksfYMesh[3].position.copy( intersect.point ).add( intersect.face.normal );
						rollOverBooksfYMesh[3].position.divideScalar( 50 ).round().multiplyScalar( 50 );//.addScalar( 25 );
						rollOverBooksfYMesh[3].position.y += 25*booksf_y;
						rollOverBooksfYMesh[3].position.z += 50*booksf_z;
						
						rollOverBooksfYMesh[4].position.copy( intersect.point ).add( intersect.face.normal );
						rollOverBooksfYMesh[4].position.divideScalar( 50 ).round().multiplyScalar( 50 );//.addScalar( 25 );
						rollOverBooksfYMesh[4].position.y += 25*booksf_y;
						rollOverBooksfYMesh[4].position.x += 50*booksf_x;
						rollOverBooksfYMesh[4].position.z += 50*booksf_z;
						
						
						rollOverBooksfZMesh[1].scale.z = booksf_z;
						rollOverBooksfZMesh[2].scale.z = booksf_z;
						rollOverBooksfZMesh[3].scale.z = booksf_z;
						rollOverBooksfZMesh[4].scale.z = booksf_z;
						
						rollOverBooksfZMesh[1].position.copy( intersect.point ).add( intersect.face.normal );
						rollOverBooksfZMesh[1].position.divideScalar( 50 ).round().multiplyScalar( 50 );
						rollOverBooksfZMesh[1].position.z += 25*booksf_z;
						
						rollOverBooksfZMesh[2].position.copy( intersect.point ).add( intersect.face.normal );
						rollOverBooksfZMesh[2].position.divideScalar( 50 ).round().multiplyScalar( 50 );
						rollOverBooksfZMesh[2].position.z += 25*booksf_z;
						rollOverBooksfZMesh[2].position.y += 50*booksf_y;
						
						rollOverBooksfZMesh[3].position.copy( intersect.point ).add( intersect.face.normal );
						rollOverBooksfZMesh[3].position.divideScalar( 50 ).round().multiplyScalar( 50 );
						rollOverBooksfZMesh[3].position.z += 25*booksf_z;
						rollOverBooksfZMesh[3].position.x += 50*booksf_x;
						
						rollOverBooksfZMesh[4].position.copy( intersect.point ).add( intersect.face.normal );
						rollOverBooksfZMesh[4].position.divideScalar( 50 ).round().multiplyScalar( 50 );
						rollOverBooksfZMesh[4].position.z += 25*booksf_z;
						rollOverBooksfZMesh[4].position.y += 50*booksf_y;
						rollOverBooksfZMesh[4].position.x += 50*booksf_x;
						

						rollOverBooksfXMesh[1].scale.x = booksf_x;
						rollOverBooksfXMesh[2].scale.x = booksf_x;
						rollOverBooksfXMesh[3].scale.x = booksf_x;
						rollOverBooksfXMesh[4].scale.x = booksf_x;
						
						rollOverBooksfXMesh[1].position.copy( intersect.point ).add( intersect.face.normal );
						rollOverBooksfXMesh[1].position.divideScalar( 50 ).round().multiplyScalar( 50 );
						rollOverBooksfXMesh[1].position.x += 25*booksf_x;
						
						rollOverBooksfXMesh[2].position.copy( intersect.point ).add( intersect.face.normal );
						rollOverBooksfXMesh[2].position.divideScalar( 50 ).round().multiplyScalar( 50 );
						rollOverBooksfXMesh[2].position.x += 25*booksf_x;
						rollOverBooksfXMesh[2].position.y += 50*booksf_y;
						
						rollOverBooksfXMesh[3].position.copy( intersect.point ).add( intersect.face.normal );
						rollOverBooksfXMesh[3].position.divideScalar( 50 ).round().multiplyScalar( 50 );
						rollOverBooksfXMesh[3].position.x += 25*booksf_x;
						rollOverBooksfXMesh[3].position.z += 50*booksf_z;
						
						rollOverBooksfXMesh[4].position.copy( intersect.point ).add( intersect.face.normal );
						rollOverBooksfXMesh[4].position.divideScalar( 50 ).round().multiplyScalar( 50 );
						rollOverBooksfXMesh[4].position.x += 25*booksf_x;
						rollOverBooksfXMesh[4].position.y += 50*booksf_y;
						rollOverBooksfXMesh[4].position.z += 50*booksf_z;
					}
						
				}
				render();
			}
			function onDocumentMouseDown( event ) {
				event.preventDefault();
				mouse.set( ( event.clientX / (window.innerWidth*6/10) ) * 2 - 1, - ( event.clientY / window.innerHeight ) * 2 + 1 );
				raycaster.setFromCamera( mouse, camera );
				var intersects = raycaster.intersectObjects( objects );
				if ( intersects.length > 0 ) {
					var intersect = intersects[0];
					var voxel;
					if ( pen_type == 0 ) {
						// eraser
						if ( intersect.object != plane ) {
							var jsonobj = JSON.parse(intersect.object["name"]);
							if(jsonobj.cube_type == "7"){
								//alert("obj:"+jsonobj.object_id);
								//Rack
								var erased_id = jsonobj.object_id;
								var objectsdel_flag = false, objectsdel_idx=0;
								for(var idx in objects){
									//alert(idx);
									if(objects[idx] != plane){
										var tmpjsonobj = JSON.parse(objects[idx]["name"]);
										if(tmpjsonobj.object_id == erased_id){
											scene.remove( objects[idx] );
											if(objectsdel_flag == false){
												objectsdel_idx = idx;
												objectsdel_flag = true;
											}
										}
									}
								}
								if(objectsdel_flag){
									//objects.splice( objects.indexOf( objects[objectsdel_idx-12] ), 12 );
									objects.splice( objectsdel_idx, 12 );
								}
							} else{
								scene.remove( intersect.object );
								objects.splice( objects.indexOf( intersect.object ), 1 );
							}
						}
					} else if( pen_type == 1) {
						// white pen
						voxel = new THREE.Mesh( cubeGeo, cubeMaterial );
						voxel.position.copy( intersect.point ).add( intersect.face.normal );
						voxel.position.divideScalar( 50 ).floor().multiplyScalar( 50 ).addScalar( 25 );
						voxel.name = "{ \"cube_type\":1, \"linked_id\":"+static_linked_id+", \"object_id\":"+object_id+", \"size\":1, \"axis\":0 }";
						object_id++;
					} else if ( pen_type == 2 ) {
						// red box
						voxel = new THREE.Mesh( cubeGeo, cctvMaterial );
						voxel.position.copy( intersect.point ).add( intersect.face.normal );
						voxel.position.divideScalar( 50 ).floor().multiplyScalar( 50 ).addScalar( 25 );
						voxel.name = "{ \"cube_type\":2, \"linked_id\":"+static_linked_id+", \"object_id\":"+object_id+", \"size\":1, \"axis\":0 }";
						object_id++;
					} else if( pen_type == 7) {
						var voxel;
						for(var idx=0; idx<12; idx++){
							var remainder = idx%4;
							var quotient = parseInt(idx/4);
							if(quotient == 0){
								voxel = rollOverBooksfYMesh[remainder+1].clone();
								voxel.name = "{ \"cube_type\":7, \"linked_id\":"+static_linked_id+", \"object_id\":"+object_id+", \"size\":"+booksf_y+", \"axis\":1 }";
							} else if(quotient == 1){
								voxel = rollOverBooksfZMesh[remainder+1].clone();
								voxel.name = "{ \"cube_type\":7, \"linked_id\":"+static_linked_id+", \"object_id\":"+object_id+", \"size\":"+booksf_z+", \"axis\":2 }";
							} else if(quotient == 2){
								voxel = rollOverBooksfXMesh[remainder+1].clone();
								voxel.name = "{ \"cube_type\":7, \"linked_id\":"+static_linked_id+", \"object_id\":"+object_id+", \"size\":"+booksf_x+", \"axis\":3 }";
							}
							scene.add( voxel );
							objects.push( voxel );
						}
						object_id++;
					} else if ( pen_type == 999 ) {
						if ( intersect.object != plane ) {
							var jsonobj = JSON.parse(intersect.object["name"]);
							if(jsonobj.cube_type == "1" || jsonobj.cube_type == "2"){
								getBoxView(jsonobj.linked_id);
							} else if(jsonobj.cube_type == "7"){
								getBooksfView(jsonobj.linked_id);
							}
						}
					}
				
					
					if ( pen_type == 0 || pen_type == 7 || pen_type == 999 ) {
						
					} else {
						scene.add( voxel );
						objects.push( voxel );
					}
				
					render();
				}
			}
			function onDocumentKeyDown( event ) {
				switch( event.keyCode ) {
					//case 16: isShiftDown = true; break; //shift key
					//case 17: isCtrlDown = true; break; //ctrl key
					//case 18: isAltDown = true; break; //ctrl key
					case 37:  //left = 37
						if(camera.position.z != -2000){
							camera.position.z -= 100;
							camera.lookAt( new THREE.Vector3() );
							render();
						}
						break;
					case 38:  //up = 38
						if(camera.position.y != 0){
							camera.position.x -= 100;
							camera.position.y -= 100;
							camera.lookAt( new THREE.Vector3() );
							render();
						}
						break;
					case 39:  //right = 39
						if(camera.position.z != 2000){
							camera.position.z += 100;
							camera.lookAt( new THREE.Vector3() );
							render();
						}
						break;
					case 40:  //down = 40
						camera.position.x += 100;
						camera.position.y += 100;
						camera.lookAt( new THREE.Vector3() );
						render();
						break;
				}
			}
			function onDocumentKeyUp( event ) {
				switch ( event.keyCode ) {
					//case 16: isShiftDown = false; break;
					//case 17: isCtrlDown = false; break;
					//case 18: isAltDown = false; break;
				}
			}
			function render() {
				renderer.render( scene, camera );
			}
			function setPen_type(i){
				if(i==3){
					//y-axis green pen
					rollOverPenMesh.rotation.x = 0;
					rollOverPenMesh.rotation.z = 0;
				} else if(i==4){
					//z-axis green pen
					rollOverPenMesh.rotation.x = 0.5*Math.PI;
					rollOverPenMesh.rotation.z = 0;
				} else if(i==5){
					//x-axis green pen
					rollOverPenMesh.rotation.z = 0.5*Math.PI;
				} else if(i==7){
					
				}
				pen_type=i;
			}
		</script>
	</body>
</html>


<%
//resultSet.close();
preparedStatement.close();
statement.close();
connect.close();

}catch(IOException ioe){
}catch(Exception ex){
}finally{
}

%>