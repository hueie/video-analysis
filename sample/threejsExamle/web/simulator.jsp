<%@ page language="java"%>
<%@ page contentType="text/html;charset=euc-kr"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.io.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="org.json.*"%>


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
		var object_id = 0; //In Graph
		
		function sendtodb(){
            var str = "";
			var cube_list = [];
			var cube_idx, pos_x, pos_y, pos_z, cube_type, linked_id;
            for (var idx in objects) {
				if(idx != 0){
					str += '\n'+idx +'th ';
					cube_idx = idx;
					for (var key in objects[idx]) {
				        if (objects[idx].hasOwnProperty(key)) {
				            if(key == "position"){
				            	str += 'x:' + objects[idx][key]['x'] + ' ';
				            	str += 'y:' + objects[idx][key]['y'] + ' ';
				            	str += 'z:' + objects[idx][key]['z'] + ' ';
				            	
				            	pos_x = objects[idx][key]['x'];
				            	pos_y = objects[idx][key]['y'];
				            	pos_z = objects[idx][key]['z'];
				            }
				            if(key == "name"){
				            	var jsonobj = JSON.parse(objects[idx][key]);
				            	str += 'obj_id'+jsonobj.object_id +' ';
			        			if(jsonobj.cube_type == "1"){
			        				//white cube
			        				str += 'white Cube : ';
			        				cube_type = 1;
			        			} else if(jsonobj.cube_type == "2"){
			        				//red CCTV
			        				str += 'red Cube : ';
			        				cube_type = 2;
			        			} else if(jsonobj.cube_type == "3"){
			        				str += 'y-axis green Line : ';
			        				cube_type = 3;
			        			} else if(jsonobj.cube_type == "4"){
			        				str += 'z-axis green Line : ';
			        				cube_type = 4;
			        			} else if(jsonobj.cube_type == "5"){
			        				str += 'x-axis goriz Green Line : ';
			        				cube_type = 5;
			        			}  else if(jsonobj.cube_type == "7"){
			        				str += 'Green Rack : ';
			        				cube_type = 7;
			        			} else{
			        				cube_type = jsonobj.cube_type;
			        			}
			        			
			        			linked_id = jsonobj.linked_id;
				            }
				            /*
				            if(key == "material"){
			        			if(objects[idx][key]['color'].getHexString() == "ffffff"){
			        				//white cube
			        				str += 'White Cube\n';
			        				cube_type = 1;
			        			} else if(objects[idx][key]['color'].getHexString() == "ff0000"){
			        				//red CCTV
			        				str += 'Red Cube\n';
			        				cube_type = 2;
			        			} else if(objects[idx][key]['color'].getHexString() == "00ff00"){
			        				str += 'Green Line\n';
			        				cube_type = 3;
			        			}
				        	}
				            */
				        }
					}
					cube_list.push({cube_idx:cube_idx, pos_x:pos_x, pos_y:pos_y, pos_z:pos_z, cube_type:cube_type, linked_id:linked_id });
				}
		    }
			alert(str);
			
			var myJsonString = "{cube_list:"+JSON.stringify(cube_list)+"}";
            $.ajax({
                type: "post",
                url: "simulator_result.jsp",
                data: {"cube_list" : myJsonString},
                success: function(msg){
                    alert(msg);
                },
                error:function (xhr, ajaxOptions, thrownError){
                    alert(xhr.status);
                    alert(thrownError);
                } 
            });
			
		}
		var arrg_y = 1; //$("#arrg_y").val();
		var arrg_z = 1; 
		//$("#arrg_z").val();
		var arrg_x = 1; //$("#arrg_x").val();
		
		function upNdown(tag_id,i){
			var value =  $("#"+tag_id).val();
			value = parseInt(value) + parseInt(i);
			if(value >= 0){
				$("#"+tag_id).val(value);
			}
			if(tag_id == "arrg_y"){
				arrg_y = value;
			} else if(tag_id == "arrg_z"){
				arrg_z = value;
			} else if(tag_id == "arrg_x"){
				arrg_x = value;
			}
		}
		</script>
	</head>
	<body>
	 	<div style="display:inline">Linked ID : <input type="text" id="linked_id" value="0"></input><button onclick="upNdown('linked_id','1')">Up</button><button onclick="upNdown('linked_id','-1')">Down</button></div>
		<div style="display:inline">arrg_x : <input type="text" id="arrg_x" value="1"></input><button onclick="upNdown('arrg_x','1')">Up</button><button onclick="upNdown('arrg_x','-1')">Down</button></div>
		<div style="display:inline">arrg_z : <input type="text" id="arrg_z" value="1"></input><button onclick="upNdown('arrg_z','1')">Up</button><button onclick="upNdown('arrg_z','-1')">Down</button></div>
		<div style="display:inline">arrg_y : <input type="text" id="arrg_y" value="1"></input><button onclick="upNdown('arrg_y','1')">Up</button><button onclick="upNdown('arrg_y','-1')">Down</button></div>
	
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
			var rollOverPenGeo, rollOverPenMesh, rollOverPenMaterial;
			var rollOverRackGeo, rollOverRackMesh, rollOverRackMaterial, rollOverRack;
		
			
			var rollOverArrgXGeo, rollOverArrgXMaterial, rollOverArrgXMesh = [];
			var rollOverArrgYGeo, rollOverArrgYMaterial, rollOverArrgYMesh = [];
			var rollOverArrgZGeo, rollOverArrgZMaterial, rollOverArrgZMesh = [];

			var greenPenGeo, greenPenMesh, greenPenMaterial;
			var cubeGeo, cubeMaterial, cctvMaterial;
			
			var objects = [];
			var pen_type = 1; //0:eraser//1:white box//2:red box//3,4,5:y,z,x-axis green pen//6:rack
			
			init();
			render();
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
				//info.innerHTML += '<strong>Click</strong>: Add Cube, <strong>Ctrl + Click</strong>: Add CCTV Cube, <strong>Shift + Click</strong>: Remove Cubes<br>';
				info.innerHTML += '<strong>Left Key</strong>: Rotate Left, <strong>Right Key</strong>: Rotate Right<br>';
				info.innerHTML += '<button onclick=\"setPen_type(1)\">white box</button><button onclick=\"setPen_type(2)\">red box</button>';
				info.innerHTML += '<button onclick=\"setPen_type(3)\">y-axis green pen</button><button onclick=\"setPen_type(4)\">z-axis green pen</button><button onclick=\"setPen_type(5)\">x-axis green pen</button><button onclick=\"setPen_type(6)\">line rack</button><button onclick=\"setPen_type(7)\">green rack</button><button onclick=\"setPen_type(0)\">eraser</button><br>';
				info.innerHTML += '<button onclick=\"sendtodb()\">sendtodb</button> <a href=\"simulator_view.jsp\">View</a>';
				container.appendChild( info );
				
				/*Camera Setting*/
				camera = new THREE.PerspectiveCamera( 45, window.innerWidth / window.innerHeight, 1, 10000 );
				camera.position.set( 1000, 1000, 0 );
				camera.lookAt( new THREE.Vector3() );
				
				/*Helper!!!*/
				/*Blue Cube Setting (roll-over helpers)*/
				rollOverGeo = new THREE.BoxGeometry( 50, 50, 50 );
				rollOverMaterial = new THREE.MeshBasicMaterial( { color: 0x0000ff, opacity: 0.5, transparent: true } );
				rollOverMesh = new THREE.Mesh( rollOverGeo, rollOverMaterial ); 
				scene.add( rollOverMesh );
				
				/*Blue Pen Setting (roll-over helpers)*/
				rollOverPenGeo = new THREE.CylinderGeometry(8,8,50,8);
				rollOverPenMaterial = new THREE.MeshBasicMaterial( { color: 0x0000ff, opacity: 0.5, transparent: true } );
				rollOverPenMesh = new THREE.Mesh( rollOverPenGeo, rollOverPenMaterial ); 
				scene.add( rollOverPenMesh );
				
				/*Start Rack*/
				
				rollOverArrgYGeo = new THREE.BoxGeometry(8,50*arrg_y,8);
				rollOverArrgYMaterial = new THREE.MeshBasicMaterial( { color: 0x0000ff, opacity: 0.5, transparent: true } );
				rollOverArrgYMesh[1] = new THREE.Mesh( rollOverArrgYGeo, rollOverArrgYMaterial ); 
				rollOverArrgYMesh[1].rotation.y = 0.5*Math.PI;
				//rollOverArrgYMesh.position.copy( intersect.point ).add( intersect.face.normal );
				rollOverArrgYMesh[1].position.divideScalar( 50 ).round().multiplyScalar( 50 );//.addScalar( 25 );
				rollOverArrgYMesh[1].position.y += 25*arrg_y;
				scene.add( rollOverArrgYMesh[1] );
				
				rollOverArrgYMesh[2] = rollOverArrgYMesh[1].clone();
				rollOverArrgYMesh[2].position.x += 50*arrg_x;
				scene.add( rollOverArrgYMesh[2] );

				rollOverArrgYMesh[3] = rollOverArrgYMesh[1].clone();
				rollOverArrgYMesh[3].position.z += 50*arrg_z;
				scene.add( rollOverArrgYMesh[3] );

				rollOverArrgYMesh[4] = rollOverArrgYMesh[1].clone();
				rollOverArrgYMesh[4].position.x += 50*arrg_x;
				rollOverArrgYMesh[4].position.z += 50*arrg_z;
				scene.add( rollOverArrgYMesh[4] );
				
				
				rollOverArrgZGeo = new THREE.BoxGeometry(8,8,50*arrg_z);
				rollOverArrgZMaterial = new THREE.MeshBasicMaterial( { color: 0x0000ff, opacity: 0.5, transparent: true } );
				rollOverArrgZMesh[1] = new THREE.Mesh( rollOverArrgZGeo, rollOverArrgZMaterial ); 
				//rollOverArrgZMesh.position.copy( intersect.point ).add( intersect.face.normal );
				rollOverArrgZMesh[1].position.divideScalar( 50 ).round().multiplyScalar( 50 );
				rollOverArrgZMesh[1].position.z += 25*arrg_z;
				scene.add( rollOverArrgZMesh[1] );
				
				rollOverArrgZMesh[2] = rollOverArrgZMesh[1].clone();
				rollOverArrgZMesh[2].position.y += 50*arrg_y;
				scene.add( rollOverArrgZMesh[2] );
				
				rollOverArrgZMesh[3] = rollOverArrgZMesh[1].clone();
				rollOverArrgZMesh[3].position.x += 50*arrg_x;
				scene.add( rollOverArrgZMesh[3] );
				
				rollOverArrgZMesh[4] = rollOverArrgZMesh[1].clone();
				rollOverArrgZMesh[4].position.y += 50*arrg_y;
				rollOverArrgZMesh[4].position.x += 50*arrg_x;
				scene.add( rollOverArrgZMesh[4] );
				
				
				rollOverArrgXGeo = new THREE.BoxGeometry(50*arrg_x,8,8);
				rollOverArrgXMaterial = new THREE.MeshBasicMaterial( { color: 0x0000ff, opacity: 0.5, transparent: true } );
				rollOverArrgXMesh[1] = new THREE.Mesh( rollOverArrgXGeo, rollOverArrgXMaterial ); 
				rollOverArrgXMesh[1].rotation.x = 0.5*Math.PI;
				//rollOverArrgXMesh.position.copy( intersect.point ).add( intersect.face.normal );
				rollOverArrgXMesh[1].position.divideScalar( 50 ).round().multiplyScalar( 50 );
				rollOverArrgXMesh[1].position.x += 25*arrg_x;
				scene.add( rollOverArrgXMesh[1] );

				rollOverArrgXMesh[2] = rollOverArrgXMesh[1].clone();
				rollOverArrgXMesh[2].position.y += 50*arrg_y;
				scene.add( rollOverArrgXMesh[2] );
				
				rollOverArrgXMesh[3] = rollOverArrgXMesh[1].clone();
				rollOverArrgXMesh[3].position.z += 50*arrg_z;
				scene.add( rollOverArrgXMesh[3] );
				
				rollOverArrgXMesh[4] = rollOverArrgXMesh[1].clone();
				rollOverArrgXMesh[4].position.y += 50*arrg_y;
				rollOverArrgXMesh[4].position.z += 50*arrg_z;
				scene.add( rollOverArrgXMesh[4] );
				
				/*
				rollOverArrgYGeo = new THREE.CylinderGeometry(8,8,50*arrg_y,8);
				rollOverArrgYMaterial = new THREE.MeshBasicMaterial( { color: 0x0000ff, opacity: 0.5, transparent: true } );
				rollOverArrgYMesh[1] = new THREE.Mesh( rollOverArrgYGeo, rollOverArrgYMaterial ); 
				//rollOverArrgYMesh.position.copy( intersect.point ).add( intersect.face.normal );
				rollOverArrgYMesh[1].position.divideScalar( 50 ).round().multiplyScalar( 50 );//.addScalar( 25 );
				rollOverArrgYMesh[1].position.y += 25*arrg_y;
				scene.add( rollOverArrgYMesh[1] );
				
				rollOverArrgYMesh[2] = rollOverArrgYMesh[1].clone();
				rollOverArrgYMesh[2].position.x += 50*arrg_x;
				scene.add( rollOverArrgYMesh[2] );

				rollOverArrgYMesh[3] = rollOverArrgYMesh[1].clone();
				rollOverArrgYMesh[3].position.z += 50*arrg_z;
				scene.add( rollOverArrgYMesh[3] );

				rollOverArrgYMesh[4] = rollOverArrgYMesh[1].clone();
				rollOverArrgYMesh[4].position.x += 50*arrg_x;
				rollOverArrgYMesh[4].position.z += 50*arrg_z;
				scene.add( rollOverArrgYMesh[4] );
				
				
				rollOverArrgZGeo = new THREE.CylinderGeometry(8,8,50*arrg_z,8);
				rollOverArrgZMaterial = new THREE.MeshBasicMaterial( { color: 0x0000ff, opacity: 0.5, transparent: true } );
				rollOverArrgZMesh[1] = new THREE.Mesh( rollOverArrgZGeo, rollOverArrgZMaterial ); 
				rollOverArrgZMesh[1].rotation.x = 0.5*Math.PI;
				rollOverArrgZMesh[1].rotation.z = 0;
				//rollOverArrgZMesh.position.copy( intersect.point ).add( intersect.face.normal );
				rollOverArrgZMesh[1].position.divideScalar( 50 ).round().multiplyScalar( 50 );
				rollOverArrgZMesh[1].position.z += 25*arrg_z;
				scene.add( rollOverArrgZMesh[1] );
				
				rollOverArrgZMesh[2] = rollOverArrgZMesh[1].clone();
				rollOverArrgZMesh[2].position.y += 50*arrg_y;
				scene.add( rollOverArrgZMesh[2] );
				
				rollOverArrgZMesh[3] = rollOverArrgZMesh[1].clone();
				rollOverArrgZMesh[3].position.x += 50*arrg_x;
				scene.add( rollOverArrgZMesh[3] );
				
				rollOverArrgZMesh[4] = rollOverArrgZMesh[1].clone();
				rollOverArrgZMesh[4].position.y += 50*arrg_y;
				rollOverArrgZMesh[4].position.x += 50*arrg_x;
				scene.add( rollOverArrgZMesh[4] );
				
				
				rollOverArrgXGeo = new THREE.CylinderGeometry(8,8,50*arrg_x,8);
				rollOverArrgXMaterial = new THREE.MeshBasicMaterial( { color: 0x0000ff, opacity: 0.5, transparent: true } );
				rollOverArrgXMesh[1] = new THREE.Mesh( rollOverArrgXGeo, rollOverArrgXMaterial ); 
				rollOverArrgXMesh[1].rotation.x = 0.5*Math.PI;
				rollOverArrgXMesh[1].rotation.z = 0.5*Math.PI;
				//rollOverArrgXMesh.position.copy( intersect.point ).add( intersect.face.normal );
				rollOverArrgXMesh[1].position.divideScalar( 50 ).round().multiplyScalar( 50 );
				rollOverArrgXMesh[1].position.x += 25*arrg_x;
				scene.add( rollOverArrgXMesh[1] );

				rollOverArrgXMesh[2] = rollOverArrgXMesh[1].clone();
				rollOverArrgXMesh[2].position.y += 50*arrg_y;
				scene.add( rollOverArrgXMesh[2] );
				
				rollOverArrgXMesh[3] = rollOverArrgXMesh[1].clone();
				rollOverArrgXMesh[3].position.z += 50*arrg_z;
				scene.add( rollOverArrgXMesh[3] );
				
				rollOverArrgXMesh[4] = rollOverArrgXMesh[1].clone();
				rollOverArrgXMesh[4].position.y += 50*arrg_y;
				rollOverArrgXMesh[4].position.z += 50*arrg_z;
				scene.add( rollOverArrgXMesh[4] );
				*/
				
				
				/*End Rack*/
				
				/*Blue Rack Setting (roll-over helpers)*/
				rollOverRackGeo = new THREE.BoxGeometry(100, 100, 50);
				rollOverRackMaterial = new THREE.MeshBasicMaterial( { color: 0x0000ff, opacity: 0.5, transparent: true } );
				rollOverRackMesh = new THREE.Mesh( rollOverRackGeo, rollOverRackMaterial );
				rollOverRack = new THREE.BoxHelper( rollOverRackMesh, 0x0000ff );
				scene.add( rollOverRack );
				
				
				/*Textures !!! */
				/*Green Rack Setting */
				greenRackGeo = new THREE.BoxGeometry(100, 100, 50);
				greenRackMaterial = new THREE.MeshBasicMaterial( { color: 0x00ff00, opacity: 0.5, transparent: true } );
				/*Green Pen Setting */
				greenPenGeo = new THREE.CylinderGeometry(8,8,50,8);
				greenPenMaterial = new THREE.MeshBasicMaterial( { color: 0x00ff00, opacity: 0.5, transparent: true } );
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
				
				/*Render*/
				renderer = new THREE.WebGLRenderer( { antialias: true } );
				renderer.setClearColor( 0xf0f0f0 );
				renderer.setPixelRatio( window.devicePixelRatio );
				renderer.setSize( window.innerWidth, window.innerHeight );
				container.appendChild( renderer.domElement );
				
				/*Event*/
				document.addEventListener( 'mousemove', onDocumentMouseMove, false );
				document.addEventListener( 'mousedown', onDocumentMouseDown, false );
				document.addEventListener( 'keydown', onDocumentKeyDown, false );
				document.addEventListener( 'keyup', onDocumentKeyUp, false );
				//When Window is Resized
				window.addEventListener( 'resize', onWindowResize, false );
			}
			function onWindowResize() {
				camera.aspect = window.innerWidth / window.innerHeight;
				camera.updateProjectionMatrix();
				renderer.setSize( window.innerWidth, window.innerHeight );
			}
			function onDocumentMouseMove( event ) {
				event.preventDefault();
				mouse.set( ( event.clientX / window.innerWidth ) * 2 - 1, - ( event.clientY / window.innerHeight ) * 2 + 1 );
				raycaster.setFromCamera( mouse, camera );
				var intersects = raycaster.intersectObjects( objects );
				if ( intersects.length > 0 ) {
					var intersect = intersects[ 0 ];
					
					//alert("Point : "+intersect.point.x+" face : "+intersect.face.normal.x); 
					if(pen_type == 0 || pen_type == 1 || pen_type == 2){
						rollOverMesh.position.copy( intersect.point ).add( intersect.face.normal );
						rollOverMesh.position.divideScalar( 50 ).floor().multiplyScalar( 50 ).addScalar( 25 );
					} else if(pen_type == 3){
						//y-axis green pen
						rollOverPenMesh.position.copy( intersect.point ).add( intersect.face.normal );
						rollOverPenMesh.position.divideScalar( 50 ).round().multiplyScalar( 50 ); //.addScalar( 25 );
						rollOverPenMesh.position.y += 25;
					} else if(pen_type == 4){
						//z-axis green pen
						rollOverPenMesh.position.copy( intersect.point ).add( intersect.face.normal );
						rollOverPenMesh.position.divideScalar( 50 ).round().multiplyScalar( 50 );
						rollOverPenMesh.position.z += 25;
					} else if(pen_type == 5){
						//x-axis green pen
						rollOverPenMesh.position.copy( intersect.point ).add( intersect.face.normal );
						rollOverPenMesh.position.divideScalar( 50 ).round().multiplyScalar( 50 );
						rollOverPenMesh.position.x += 25;
					} else if(pen_type == 6){
						rollOverRackMesh.position.copy( intersect.point ).add( intersect.face.normal );
						rollOverRackMesh.position.divideScalar( 50 ).floor().multiplyScalar( 50 );//.addScalar( 25 );
						rollOverRackMesh.position.y += 50;
						rollOverRackMesh.position.z += 25;
						rollOverRack.setFromObject(rollOverRackMesh);
						rollOverRack.update();
					} else if(pen_type == 7){
						rollOverArrgYMesh[1].scale.y = arrg_y;//50*arrg_y;
						rollOverArrgYMesh[2].scale.y = arrg_y;
						rollOverArrgYMesh[3].scale.y = arrg_y;//50*arrg_y;
						rollOverArrgYMesh[4].scale.y = arrg_y;
						
						rollOverArrgYMesh[1].position.copy( intersect.point ).add( intersect.face.normal );
						rollOverArrgYMesh[1].position.divideScalar( 50 ).round().multiplyScalar( 50 );//.addScalar( 25 );
						rollOverArrgYMesh[1].position.y += 25*arrg_y;
						
						rollOverArrgYMesh[2].position.copy( intersect.point ).add( intersect.face.normal );
						rollOverArrgYMesh[2].position.divideScalar( 50 ).round().multiplyScalar( 50 );//.addScalar( 25 );
						rollOverArrgYMesh[2].position.y += 25*arrg_y;
						rollOverArrgYMesh[2].position.x += 50*arrg_x;
						
						rollOverArrgYMesh[3].position.copy( intersect.point ).add( intersect.face.normal );
						rollOverArrgYMesh[3].position.divideScalar( 50 ).round().multiplyScalar( 50 );//.addScalar( 25 );
						rollOverArrgYMesh[3].position.y += 25*arrg_y;
						rollOverArrgYMesh[3].position.z += 50*arrg_z;
						
						rollOverArrgYMesh[4].position.copy( intersect.point ).add( intersect.face.normal );
						rollOverArrgYMesh[4].position.divideScalar( 50 ).round().multiplyScalar( 50 );//.addScalar( 25 );
						rollOverArrgYMesh[4].position.y += 25*arrg_y;
						rollOverArrgYMesh[4].position.x += 50*arrg_x;
						rollOverArrgYMesh[4].position.z += 50*arrg_z;
						
						
						rollOverArrgZMesh[1].scale.z = arrg_z;
						rollOverArrgZMesh[2].scale.z = arrg_z;
						rollOverArrgZMesh[3].scale.z = arrg_z;
						rollOverArrgZMesh[4].scale.z = arrg_z;
						
						rollOverArrgZMesh[1].position.copy( intersect.point ).add( intersect.face.normal );
						rollOverArrgZMesh[1].position.divideScalar( 50 ).round().multiplyScalar( 50 );
						rollOverArrgZMesh[1].position.z += 25*arrg_z;
						
						rollOverArrgZMesh[2].position.copy( intersect.point ).add( intersect.face.normal );
						rollOverArrgZMesh[2].position.divideScalar( 50 ).round().multiplyScalar( 50 );
						rollOverArrgZMesh[2].position.z += 25*arrg_z;
						rollOverArrgZMesh[2].position.y += 50*arrg_y;
						
						rollOverArrgZMesh[3].position.copy( intersect.point ).add( intersect.face.normal );
						rollOverArrgZMesh[3].position.divideScalar( 50 ).round().multiplyScalar( 50 );
						rollOverArrgZMesh[3].position.z += 25*arrg_z;
						rollOverArrgZMesh[3].position.x += 50*arrg_x;
						
						rollOverArrgZMesh[4].position.copy( intersect.point ).add( intersect.face.normal );
						rollOverArrgZMesh[4].position.divideScalar( 50 ).round().multiplyScalar( 50 );
						rollOverArrgZMesh[4].position.z += 25*arrg_z;
						rollOverArrgZMesh[4].position.y += 50*arrg_y;
						rollOverArrgZMesh[4].position.x += 50*arrg_x;
						

						rollOverArrgXMesh[1].scale.x = arrg_x;
						rollOverArrgXMesh[2].scale.x = arrg_x;
						rollOverArrgXMesh[3].scale.x = arrg_x;
						rollOverArrgXMesh[4].scale.x = arrg_x;
						
						rollOverArrgXMesh[1].position.copy( intersect.point ).add( intersect.face.normal );
						rollOverArrgXMesh[1].position.divideScalar( 50 ).round().multiplyScalar( 50 );
						rollOverArrgXMesh[1].position.x += 25*arrg_x;
						
						rollOverArrgXMesh[2].position.copy( intersect.point ).add( intersect.face.normal );
						rollOverArrgXMesh[2].position.divideScalar( 50 ).round().multiplyScalar( 50 );
						rollOverArrgXMesh[2].position.x += 25*arrg_x;
						rollOverArrgXMesh[2].position.y += 50*arrg_y;
						
						rollOverArrgXMesh[3].position.copy( intersect.point ).add( intersect.face.normal );
						rollOverArrgXMesh[3].position.divideScalar( 50 ).round().multiplyScalar( 50 );
						rollOverArrgXMesh[3].position.x += 25*arrg_x;
						rollOverArrgXMesh[3].position.z += 50*arrg_z;
						
						rollOverArrgXMesh[4].position.copy( intersect.point ).add( intersect.face.normal );
						rollOverArrgXMesh[4].position.divideScalar( 50 ).round().multiplyScalar( 50 );
						rollOverArrgXMesh[4].position.x += 25*arrg_x;
						rollOverArrgXMesh[4].position.y += 50*arrg_y;
						rollOverArrgXMesh[4].position.z += 50*arrg_z;
					}
						
				}
				render();
			}
			function onDocumentMouseDown( event ) {
				event.preventDefault();
				mouse.set( ( event.clientX / window.innerWidth ) * 2 - 1, - ( event.clientY / window.innerHeight ) * 2 + 1 );
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
								alert("obj:"+jsonobj.object_id);
								//Rack
								var erased_id = jsonobj.object_id;
								var objectsdelflag = false, idx;
								for(idx in objects){
									if(objects[idx] != plane){
										var tmpjsonobj = JSON.parse(objects[idx]["name"]);
										if(tmpjsonobj.object_id == erased_id){
											scene.remove( objects[idx] );
											objectsdelflag = true;
										}
									}
								}
								if(objectsdelflag){
									objects.splice( objects.indexOf( objects[idx-12] ), 12 );
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
						voxel.name = "{ \"cube_type\":1, \"linked_id\":0, \"object_id\":"+object_id+" }";
						object_id++;
					} else if ( pen_type == 2 ) {
						// red box
						voxel = new THREE.Mesh( cubeGeo, cctvMaterial );
						voxel.position.copy( intersect.point ).add( intersect.face.normal );
						voxel.position.divideScalar( 50 ).floor().multiplyScalar( 50 ).addScalar( 25 );
						voxel.name = "{ \"cube_type\":2, \"linked_id\":0, \"object_id\":"+object_id+" }";
						object_id++;
					} else if ( pen_type == 3 ) {
						//y-axis green pen
						voxel = new THREE.Mesh( greenPenGeo, greenPenMaterial );
						voxel.position.copy( intersect.point ).add( intersect.face.normal );
						voxel.position.divideScalar( 50 ).round().multiplyScalar( 50 );//.addScalar( 25 );
						voxel.position.y += 25;
						var linked_id =  $("#linked_id").val();
						voxel.name = "{ \"cube_type\":3, \"linked_id\":"+linked_id+", \"object_id\":"+object_id+" }";
						//alert(voxel.position.x +" "+ voxel.position.y +" "+ voxel.position.z);
						object_id++;
					} else if ( pen_type == 4 ) {
						//z-axis green pen
						voxel = new THREE.Mesh( greenPenGeo, greenPenMaterial );
						voxel.rotation.x = 0.5*Math.PI;
						voxel.rotation.z = 0;
						voxel.position.copy( intersect.point ).add( intersect.face.normal );
						voxel.position.divideScalar( 50 ).round().multiplyScalar( 50 );
						voxel.position.z += 25;
						var linked_id =  $("#linked_id").val();
						voxel.name = "{ \"cube_type\":4, \"linked_id\":"+linked_id+", \"object_id\":"+object_id+" }";
						object_id++;
					} else if ( pen_type == 5 ) {
						//x-axis green pen
						voxel = new THREE.Mesh( greenPenGeo, greenPenMaterial );
						voxel.rotation.x = 0.5*Math.PI;
						voxel.rotation.z = 0.5*Math.PI;
						voxel.position.copy( intersect.point ).add( intersect.face.normal );
						voxel.position.divideScalar( 50 ).round().multiplyScalar( 50 );
						voxel.position.x += 25;
						var linked_id =  $("#linked_id").val();
						voxel.name = "{ \"cube_type\":5, \"linked_id\":"+linked_id+", \"object_id\":"+object_id+" }";
						//alert(voxel.position.x +" "+ voxel.position.y +" "+ voxel.position.z);
						object_id++;
					} else if( pen_type == 6) {
						// white pen
						var tmpvoxel = new THREE.Mesh( greenRackGeo, greenRackMaterial );
						tmpvoxel.position.copy( intersect.point ).add( intersect.face.normal );
						tmpvoxel.position.divideScalar( 50 ).floor().multiplyScalar( 50 );//.addScalar( 25 );
						tmpvoxel.position.y += 50;
						tmpvoxel.position.z += 25;
						tmpvoxel.name = "{ \"cube_type\":6, \"linked_id\":0, \"object_id\":"+object_id+" }";
						voxel = new THREE.BoxHelper( tmpvoxel, 0xff0000 );
						object_id++;
					} else if( pen_type == 7) {
						var voxel;
						for(var idx=0; idx<12; idx++){
							var remainder = idx%4;
							var quotient = parseInt(idx/4);
							if(quotient == 0){
								voxel = rollOverArrgYMesh[remainder+1].clone();
								voxel.name = "{ \"cube_type\":7, \"linked_id\":0, \"object_id\":"+object_id+" }";
							} else if(quotient == 1){
								voxel = rollOverArrgZMesh[remainder+1].clone();
								voxel.name = "{ \"cube_type\":7, \"linked_id\":0, \"object_id\":"+object_id+" }";
							} else if(quotient == 2){
								voxel = rollOverArrgXMesh[remainder+1].clone();
								voxel.name = "{ \"cube_type\":7, \"linked_id\":0, \"object_id\":"+object_id+" }";
							}
							scene.add( voxel );
							objects.push( voxel );
						}
						object_id++;
					}
					
					if ( pen_type == 0 || pen_type == 7 ) {
						
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