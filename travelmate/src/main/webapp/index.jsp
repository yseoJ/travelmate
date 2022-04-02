<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	/* db connection */
	 String user = "trip";
	 String pw = "trip";
	 String url = "jdbc:oracle:thin:@mytripdb.crd3fcdurp5u.ap-northeast-2.rds.amazonaws.com:1521:ORCL";
	 String sql = "";
	 Class.forName("oracle.jdbc.driver.OracleDriver");
	 Connection conn = DriverManager.getConnection(url, user, pw);
	 ResultSet res;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />
<title>TRAVELMATE</title>
</head>
<body>
	<h2> 관광지 목록 </h2>
	<table border="1" width="50%">
		<tr>
			<th>관광지 ID </th>
			<th>관광지 명</th>
		</tr>    
	    <%     
	    sql = "SELECT SIGHTS_ID, SIGHTS_NM FROM SIGHTS_INFO ORDER BY SIGHTS_ID" ;
	    res = conn.prepareStatement(sql).executeQuery(); 
	    
	    while (res.next()) {            
	      String SIGHTS_ID = res.getString("SIGHTS_ID");
	      String SIGHTS_NM = res.getString("SIGHTS_NM");   
	    %>   
	      <tr>
	         <td><%=SIGHTS_ID%></td> 
	         <td><%=SIGHTS_NM%></td> 
	      </tr>      
	         <%
	         }
	       %>                 
	</table> 
</body>
</html>