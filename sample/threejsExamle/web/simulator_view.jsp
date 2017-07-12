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

            sql = "SELECT * FROM cube_map";
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
		</style>
		<script type="text/javascript">
		function del(){
			$.ajax({
                type: "post",
                url: "simulator_del_result.jsp",
                data: {},
                success: function(msg){
                    alert(msg);
                    location.reload();
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
			var objects = [];
			// for loop Building Interior Automatically Using DB Data
			var cubes = [];
			
			initpushdata();
			init();
			render();
			function initpushdata(){
				<% while(resultSet.next()){ %>
				cubes.push({x:<%= resultSet.getString(2) %>, y:<%= resultSet.getString(3) %>, z:<%= resultSet.getString(4) %>, cube_type:<%= resultSet.getString(5) %>, linked_id:<%= resultSet.getString(6) %>});
	            <% } %>
			}
			
			function init() {
				container = document.createElement( 'div' );
				document.body.appendChild( container );
				scene = new THREE.Scene();
				
				/*Header Info Setting*/
				var info = document.createElement( 'div' );
				info.style.position = 'absolute';
				info.style.top = '10px';
				info.style.width = '100%';
				info.style.textAlign = 'center';
				info.innerHTML = '<strong>Small Shop Interior YS</strong><br>';
				info.innerHTML += '<strong>Left Key</strong>: Rotate Left, <strong>Right Key</strong>: Rotate Right<br>';
				info.innerHTML += '<a href=\"simulator.jsp\">Add</a> <button onclick=\"del()\">Del</button>';
				container.appendChild( info );
				
				
				/*Camera Setting*/
				camera = new THREE.PerspectiveCamera( 45, window.innerWidth / window.innerHeight, 1, 10000 );
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
					}
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
				renderer.setSize( window.innerWidth, window.innerHeight );
				container.appendChild( renderer.domElement );
				
				/*Event */
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
				camera.aspect = window.innerWidth / window.innerHeight;
				camera.updateProjectionMatrix();
				renderer.setSize( window.innerWidth, window.innerHeight );
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