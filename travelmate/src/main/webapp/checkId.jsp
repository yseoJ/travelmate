
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
 
    
<%
//checkId.jsp
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
	String name = request.getParameter("name");
	String PHONE_NUM = "";
	String GENDER = "";
	String MEMB_STATUS = "";
	String ADDM_YEAR = "";
	
	sql = String.format( "select * from MEMB_INFO where MEMB_ID = '%s' and FULL_NM = '%s'", id, name);
	
	res = stmt.executeQuery(sql);

	

	if(res.next()){%>
		{
			"isExist": "true"
		}
	<% } else {%>
		{
			"isExist": "false"
		}
	<%}
	System.out.println(sql);
	System.out.println(ADDM_YEAR);
	
	response.setContentType("application/json");
	conn.close();
%>

