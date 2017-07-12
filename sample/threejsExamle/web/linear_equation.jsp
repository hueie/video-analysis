<%@ page language="java"%>
<%@ page contentType="text/html;charset=euc-kr"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.io.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="org.json.*"%>
<%@ page import="org.apache.commons.math3.util.Precision"%>
<%@ page import="org.apache.commons.math3.stat.regression.SimpleRegression"%>
<%
//Sorting method : a : more x, more z , b : more y, more x
//Shelves Lines In Video Image From camera_angle Table
int [][] a1 = {{94,227}, {170,407}};
int [][] a2 = {{268,280}, {336,138}};
int [][] a3 = {{173,128}, {215,24}};

//Shelves Lines In Simulator From YS_CUBE_MAP Table
int [][] b1 = {{-50,-75}, {-50,75}};
int [][] b2 = {{75,50}, {175,50}};
int [][] b3 = {{75,0}, {175,0}};

//Training Simple Regression after sorting
//http://commons.apache.org/proper/commons-math/download_math.cgi
SimpleRegression simpleRegression_1 = new SimpleRegression(true);
SimpleRegression simpleRegression_2 = new SimpleRegression(true);

simpleRegression_1.addData(new double[][] {
	{a1[0][0], b1[0][0]},
	{a1[1][0], b1[1][0]},
	{a2[0][0], b2[0][0]},
	{a2[1][0], b2[1][0]},
	{a3[0][0], b3[0][0]},
	{a3[1][0], b3[1][0]}
});

simpleRegression_2.addData(new double[][] {
	{a1[0][1], b1[0][1]},
	{a1[1][1], b1[1][1]},
	{a2[0][1], b2[0][1]},
	{a2[1][1], b2[1][1]},
	{a3[0][1], b3[0][1]},
	{a3[1][1], b3[1][1]}
});

//Testing
int [][] c1 = {{130,331} }; //(y,x) A Example Point About Cluster Centers(Human Heads) Per One Frame

double dp1 = simpleRegression_1.predict(c1[0][0]);
double dp2 = simpleRegression_2.predict(c1[0][1]);
double ip1 = Precision.round(dp1, 0);
double ip2 = Precision.round(dp2, 0);

out.print("Transformed : ("+ip1+ " , "+ip2+")");
//You Can See (-6.0 , 37.0) and dot this position in our simulator

/*
out.println("prediction for C1_X = " + simpleRegression_1.predict(c1[0][0]));
out.println("slope = " + simpleRegression_1.getSlope());
out.println("intercept = " + simpleRegression_1.getIntercept());

out.println("prediction for C1_Y = " + simpleRegression_2.predict(c1[0][1]));
out.println("slope = " + simpleRegression_2.getSlope());
out.println("intercept = " + simpleRegression_2.getIntercept());
*/
%>