
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
 
    
<%
//클라이언트로부터 가져온 데이터를 이용해 DB에 접근하는 페이지
/* db connection */
	String user = "trip";
	String pw = "trip";
	String url = "jdbc:oracle:thin:@mytripdb.crd3fcdurp5u.ap-northeast-2.rds.amazonaws.com:1521:ORCL";
	String sql = "";
	Class.forName("oracle.jdbc.driver.OracleDriver");
	Connection conn = DriverManager.getConnection(url, user, pw);
	Statement stmt = conn.createStatement();
	ResultSet res;
	
	String id = request.getParameter("id");
	String mbti = request.getParameter("mbti");
	

	sql = "MERGE INTO MEMB_INFO "+
			"USING DUAL ON(MEMB_ID = '" + id + "') "+
			"WHEN MATCHED THEN "+
			"UPDATE SET MBTI = '" + mbti + "' "+
			"WHEN NOT MATCHED THEN "+
			"INSERT (MBTI) VALUES('" + mbti + "') ";
	
	
	res = stmt.executeQuery(sql);

	if(res.next()){%>
		{
			"val": "true"
		}
	<% } else {%>
		{
			"val": "false"
		}
	<%}
	
	System.out.println(mbti);
	
	response.setContentType("application/json");
	conn.close();
%>

