<%@ page language="java"%>
<%@ page contentType="text/html;charset=euc-kr"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.io.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="org.json.*"%>

<%
String stack_id = request.getParameter("stack_id");

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

            sql = "SELECT * FROM YS_CUBE_MAP WHERE STACK_ID = "+ stack_id;
            System.out.println(sql);
            resultSet = statement.executeQuery(sql);

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
		function add(){
			var stack_id = $("#stack_id").val();
			window.location = 'mms.jsp?stack_id='+stack_id;
		}
		
		function del(){
			$.ajax({
                type: "post",
                url: "mms_del_result.jsp",
                data: {},
                success: function(msg){
                    alert(msg);
                    var stack_id = $("#stack_id").val();
                    window.location = 'mms.jsp?stack_id='+stack_id;
                },
                error:function (xhr, ajaxOptions, thrownError){
                    alert(xhr.status);
                    alert(thrownError);
                } 
            });
		}
		
		function getStackList(stack_id){
			//서고
			$.ajax({
                type: "post",
                url: "getStackList.jsp",
                data: { "stack_id" : stack_id},
                success: function(msg){
                	var obj = JSON.parse(msg);
                	document.getElementById("view").innerHTML = "<span>"+ obj.stackId + ", " + obj.stackNm + "</span><br>"; 
                   },
                error:function (xhr, ajaxOptions, thrownError){
                    alert(xhr.status);
                    alert(thrownError);
                } 
            });
		}
		
		function getBooksfList(booksf_id){
			//서가
			$.ajax({
                type: "post",
                url: "getBooksfList.jsp",
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
		
		function getBoxList(box_id){
			//상자
			$.ajax({
                type: "post",
                url: "getBoxList.jsp",
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
			<div style="width:60%;display:inline;" id="container"></div>
			<div style="width:40%;display:inline;float:right;" >
				Stack ID : <input type="text" id="stack_id" value="<%=stack_id%>"></input><br>
				Linked ID : <input type="text" id="linked_id" value="0"></input>
				<br><hr><br>
				<%--
				<button onclick="getStackList()">getStackList</button>
				<button onclick="getBooksfList()">getBooksfList</button>
				<button onclick="getBoxList()">getBoxList</button>
				 --%>
				<button onclick="add()">추가</button>
				<button onclick="del()">삭제</button>
				 <br><hr><br>
				<div id="view"></div>
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
			var plane, cube, line; var ball;
			var mouse, raycaster, isShiftDown = false, isCtrlDown = false, isAltDown = false;
			var rollOverMesh, rollOverMaterial;
			var cubeGeo, cubeMaterial, cctvMaterial;
			var pen_type = 999;
			var objects = [];
			// for loop Building Interior Automatically Using DB Data
			var cubes = [];
			
			initpushdata();
			init();
			render();
			function initpushdata(){
				<% while(resultSet.next()){ %>
				cubes.push({x:<%= resultSet.getString("POS_X") %>, y:<%= resultSet.getString("POS_Y") %>, z:<%= resultSet.getString("POS_Z") %>, object_id:<%= resultSet.getString("OBJECT_ID") %>, cube_type:<%= resultSet.getString("CUBE_TYPE") %>, linked_id:<%= resultSet.getString("LINKED_ID") %>, size:<%= resultSet.getString("CUBE_SIZE") %>, axis:<%= resultSet.getString("CUBE_AXIS") %>});
	            <% } %>
			}
			
			function init() {
				//container = document.createElement( 'div' );
				//document.body.appendChild( container );
				container = document.getElementById( 'container' );
				scene = new THREE.Scene();
				
				/*Camera Setting*/
				camera = new THREE.PerspectiveCamera( 45, window.innerWidth*6/10 / window.innerHeight, 1, 10000 );
				camera.position.set( 1000, 1000, 0 );
				camera.lookAt( new THREE.Vector3() );
				// scene.add( camera ); ys
				
				/*White Cube Setting*/
				cubeGeo = new THREE.BoxGeometry( 50, 50, 50 );
				//cubeMaterial = new THREE.MeshLambertMaterial( { color: 0xfeb74c, map: new THREE.TextureLoader().load( "textures/square-outline-textured.png" ) } );
				cubeMaterial = new THREE.MeshLambertMaterial( { color: 0xffffff } ); //White Cube
				/*Red Cube Setting*/
				cctvMaterial = new THREE.MeshLambertMaterial( { color: 0xff0000 } ); //Red Cube
				
				
				/*Green Pen Setting (roll-over helpers)*/
				rollOverPenGeo = new THREE.CylinderGeometry(8,8,50,8);
				rollOverPenMaterial = new THREE.MeshBasicMaterial( { color: 0x00ff00, opacity: 0.5, transparent: true } );
				rollOverPenMesh = new THREE.Mesh( rollOverPenGeo, rollOverPenMaterial ); 
				
				
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
				geometry.rotateX( - Math.PI / 2 );
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
							var rollOverBooksfYMaterial = new THREE.MeshBasicMaterial( { color: 0x0000ff, opacity: 0.5, transparent: true } );
							voxel = new THREE.Mesh( rollOverBooksfYGeo, rollOverBooksfYMaterial ); 
							voxel.rotation.y = 0.5*Math.PI;
							voxel.position.set(cubes[key]['x'], cubes[key]['y'], cubes[key]['z']);
						} else if(cubes[key]['axis'] == 2){
							//ZMesh
							var rollOverBooksfZGeo = new THREE.BoxGeometry(8,8,50*cubes[key]['size']);
							var rollOverBooksfZMaterial = new THREE.MeshBasicMaterial( { color: 0x0000ff, opacity: 0.5, transparent: true } );
							voxel = new THREE.Mesh( rollOverBooksfZGeo, rollOverBooksfZMaterial ); 
							voxel.position.set(cubes[key]['x'], cubes[key]['y'], cubes[key]['z']);
						} else if(cubes[key]['axis'] == 3){
							//XMesh
							var rollOverBooksfXGeo = new THREE.BoxGeometry(50*cubes[key]['size'],8,8);
							var rollOverBooksfXMaterial = new THREE.MeshBasicMaterial( { color: 0x0000ff, opacity: 0.5, transparent: true } );
							voxel = new THREE.Mesh( rollOverBooksfXGeo, rollOverBooksfXMaterial ); 
							voxel.rotation.x = 0.5*Math.PI;
							voxel.position.set(cubes[key]['x'], cubes[key]['y'], cubes[key]['z']);
						}
					}
					voxel.name = "{ \"cube_type\":"+cubes[key]['cube_type']+", \"linked_id\":"+cubes[key]['linked_id']+", \"object_id\":"+cubes[key]['object_id']+", \"size\":"+cubes[key]['size']+", \"axis\":"+cubes[key]['axis']+" }";
					scene.add( voxel );
					objects.push( voxel );
				}
				
				/*Making Customers Green Ball*/
				var ballGeo = new THREE.SphereGeometry( 5, 10, 10 );
				var ballMaterial = new THREE.MeshLambertMaterial( { color: 0x00ff00 } ); 
				ball = new THREE.Mesh( ballGeo, ballMaterial );
				ball.position.set(-6, 50, 37);
				scene.add( ball );
				objects.push( ball );
				
				/*Render*/
				renderer = new THREE.WebGLRenderer( { antialias: true } );
				renderer.setClearColor( 0xf0f0f0 );
				renderer.setPixelRatio( window.devicePixelRatio );
				renderer.setSize( window.innerWidth*6/10, window.innerHeight );
				container.appendChild( renderer.domElement );
				
				/*Event */
				document.addEventListener( 'mousedown', onDocumentMouseDown, false );
				document.addEventListener( 'keydown', onDocumentKeyDown, false );
				document.addEventListener( 'keyup', onDocumentKeyUp, false );
				//When Window is Resized
				window.addEventListener( 'resize', onWindowResize, false );
			}
			/* Moving Action*/
			var keep = true;
			function play(){
				/*
				if(keep){
					if(ball.position.x>-55){
						ball.position.x -= 1;
					} else {
						keep = false;
					}
				} else {
					if(ball.position.x<55){
						ball.position.x += 1;
					} else{
						keep = true;
					}
				}
				*/
			}
			/* Moving Action*/
			
			function onWindowResize() {
				camera.aspect = (window.innerWidth*6/10) / window.innerHeight;
				camera.updateProjectionMatrix();
				renderer.setSize( (window.innerWidth*6/10), window.innerHeight );
			}
			function onDocumentMouseDown( event ) {
				event.preventDefault();
				mouse.set( ( event.clientX / (window.innerWidth*6/10) ) * 2 - 1, - ( event.clientY / window.innerHeight ) * 2 + 1 );
				raycaster.setFromCamera( mouse, camera );
				var intersects = raycaster.intersectObjects( objects );
				if ( intersects.length > 0 ) {
					var intersect = intersects[0];
					var voxel;
					if ( pen_type == 999 ) {
						if ( intersect.object != plane ) {
							//alert(intersect.object["name"]);
							var jsonobj = JSON.parse(intersect.object["name"]);
							if(jsonobj.cube_type == "1"){
								getBoxList(jsonobj.linked_id);
							} else if(jsonobj.cube_type == "7"){
								getBooksfList(jsonobj.linked_id);
							}
						}
					}
				}
			}
			function onDocumentKeyDown( event ) {
				switch( event.keyCode ) {
					case 16: isShiftDown = true; break; //shift key
					case 17: isCtrlDown = true; break; //ctrl key
					case 18: isAltDown = true; break; //ctrl key
					case 37:  //left = 37
						if(camera.position.z != -2000){
							camera.position.z -= 100;
							camera.lookAt( new THREE.Vector3() );
							renderer.render( scene, camera );
						}
						break;
					case 38:  //up = 38
						if(camera.position.y != 0){
							camera.position.x -= 100;
							camera.position.y -= 100;
							camera.lookAt( new THREE.Vector3() );
							renderer.render( scene, camera );
						}
						break;
					case 39:  //right = 39
						if(camera.position.z != 2000){
							camera.position.z += 100;
							camera.lookAt( new THREE.Vector3() );
							renderer.render( scene, camera );
						}
						break;
					case 40:  //down = 40
						camera.position.x += 100;
						camera.position.y += 100;
						camera.lookAt( new THREE.Vector3() );
						renderer.render( scene, camera );
						break;
				}
			}
			function onDocumentKeyUp( event ) {
				switch ( event.keyCode ) {
					case 16: isShiftDown = false; break;
					case 17: isCtrlDown = false; break;
					case 18: isAltDown = false; break;
				}
			}
			var play_flag = true;
			function render() {
				renderer.render( scene, camera );
				/* Moving Action*/
				play();
				requestAnimationFrame(render);
				/* Moving Action*/
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
            out.println(ioe);
}catch(Exception ex){
            out.println(ex);
}finally{
}
out.print("Completely Insert Data Into DB.");


%>