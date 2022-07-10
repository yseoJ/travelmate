<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    /* 한글 깨짐 방지 */
    request.setCharacterEncoding("UTF-8");

    /* db connection */
	String url = "jdbc:oracle:thin:@mytripdb.crd3fcdurp5u.ap-northeast-2.rds.amazonaws.com:1521:ORCL";
	String user = "trip";
	String pw = "trip";
	String sql = "";
	
	
	Class.forName("oracle.jdbc.driver.OracleDriver");
	Connection conn = DriverManager.getConnection(url, user, pw);
	ResultSet res = null;
	
	String memb_id = request.getParameter("membId");
	String trip_id = request.getParameter("tripId");

	sql = "DELETE FROM TRIP_JOIN_LIST "+
			"WHERE TRIP_ID = " + trip_id + " "+
			"AND MEMB_ID = '" + memb_id + "' "; 
	conn.prepareStatement(sql).executeUpdate();
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />
	<!-- 부트스트랩 CSS 추가하기 -->
	<link rel="stylesheet" href="./css/bootstrap.min.css">
	<!-- 커스텀 CSS 추가하기 -->
	<link rel="stylesheet" href="./css/custom.css?after">
	
	<!-- 부트스트랩 자바스크립트 추가하기 -->
	<script src="./js/bootstrap.min.js"></script>
	<!-- 제이쿼리 자바스크립트 추가하기 -->
	<script src="./js/jquery.min.js"></script>
	<!-- 파퍼 자바스크립트 추가하기 -->
	<script src="./js/pooper.js"></script>
	
	<title>Delete Trip</title>
</head>
<body>
	<br><br><br><br>
	<div style="font-size: 20px; font-weight: bold; text-align:center;"><a>삭제되었습니다.</a></div>
	<br><br><br>
	<div style="margin: 0 auto; text-align: center;">
	<form name="frmInex" action="index.jsp" method="get" >
		<button onClick="window.close();" style=" display: inline-block; border-radius: 6px; background-color: rgba(66, 133, 244, 0.3); height: 25px;">확인</button>
		<input type="hidden" name="ID" value="<%=memb_id %>" />
	</form>
	</div>
	<%
	conn.close();
	%>
</body>
</html>