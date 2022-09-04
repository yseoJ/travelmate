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
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />
	<!-- 부트스트랩 CSS 추가하기 -->
	<link rel="stylesheet" href="./css/bootstrap.min.css">
	<!-- 커스텀 CSS 추가하기 -->
	<link rel="stylesheet" href="./css/custom.css">
	<meta name="google-signin-scope" content="profile email">
    <meta name="google-signin-client_id" content="120857777045-1oeeagtes07pmn0n2q2kfnvja770b2eg.apps.googleusercontent.com"/>
    <script src="https://apis.google.com/js/platform.js" async defer></script>
	
	<!-- 부트스트랩 자바스크립트 추가하기 -->
	<script src="./js/bootstrap.min.js"></script>
	<!-- 제이쿼리 자바스크립트 추가하기 -->
	<script src="./js/jquery.min.js"></script>
	<!-- 파퍼 자바스크립트 추가하기 -->
	<script src="./js/pooper.js"></script>
	
	<title>My EVALUATION</title>
</head>
<body>
	<div style="display: inline; position: relative; left: 10px; top: 5px;">
		<a href="#" onClick="history.go(-1); return false;">
			<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-arrow-left" viewBox="0 0 16 16">
			  <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8z"/>
			</svg>
		</a>
	</div>
	<br><br>
	<div style="text-align: center;"><a style="font-weight:bold; margin: auto; font-size: 20px;">매너 평가</a></div><br>
	<div class="Evaltext">
	<%     
	sql = "SELECT i.EVAL_ITEM evalItem, e.EVAL_ID, COUNT(*) count "+
			"FROM MEMB_EVALUATION e "+
			"LEFT OUTER JOIN EVALUATION_ITEM i ON e.EVAL_ID = i.EVAL_ID "+
			"WHERE e.GET_MEMB_ID = '" + memb_id + "' "+
			"AND i.EVAL_ID BETWEEN 1 AND 10 "+
			"GROUP BY i.EVAL_ITEM, e.EVAL_ID "+
			"ORDER BY count DESC, EVAL_ID ";
    res = conn.prepareStatement(sql).executeQuery();
	
    while(res.next()) {            
      String evalItem = res.getString("evalItem");
      String count = res.getString("count");   
	%>
		<br><div style="display: flex; font-size: 18px;">
			<div style="display: inline-block; margin: auto; flex: 2; text-align: left; margin-left: 5px;">
				<%=evalItem %>
			</div>
			<div style="display: inline-block; margin: auto; flex: 1; text-align: center;">
				<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" class="bi bi-people" viewBox="0 0 16 16">
				  <path d="M15 14s1 0 1-1-1-4-5-4-5 3-5 4 1 1 1 1h8zm-7.978-1A.261.261 0 0 1 7 12.996c.001-.264.167-1.03.76-1.72C8.312 10.629 9.282 10 11 10c1.717 0 2.687.63 3.24 1.276.593.69.758 1.457.76 1.72l-.008.002a.274.274 0 0 1-.014.002H7.022zM11 7a2 2 0 1 0 0-4 2 2 0 0 0 0 4zm3-2a3 3 0 1 1-6 0 3 3 0 0 1 6 0zM6.936 9.28a5.88 5.88 0 0 0-1.23-.247A7.35 7.35 0 0 0 5 9c-4 0-5 3-5 4 0 .667.333 1 1 1h4.216A2.238 2.238 0 0 1 5 13c0-1.01.377-2.042 1.09-2.904.243-.294.526-.569.846-.816zM4.92 10A5.493 5.493 0 0 0 4 13H1c0-.26.164-1.03.76-1.724.545-.636 1.492-1.256 3.16-1.275zM1.5 5.5a3 3 0 1 1 6 0 3 3 0 0 1-6 0zm3-2a2 2 0 1 0 0 4 2 2 0 0 0 0-4z"/>
				</svg>
				<%=count %>
			</div>
		</div><br>
	<%
	 }
	%>
	</div>
	<br><br><br><br><br>
	<div style="text-align: center;"><a style="font-weight:bold; margin: auto; font-size: 20px;">비매너 평가</a></div><br>
	<div class="Evaltext">
	<%     
	sql = "SELECT i.EVAL_ITEM evalItem, e.EVAL_ID, COUNT(*) count "+
			"FROM MEMB_EVALUATION e "+
			"LEFT OUTER JOIN EVALUATION_ITEM i ON e.EVAL_ID = i.EVAL_ID "+
			"WHERE e.GET_MEMB_ID = '" + memb_id + "' "+
			"AND i.EVAL_ID BETWEEN 100 AND 110 "+
			"GROUP BY i.EVAL_ITEM, e.EVAL_ID "+
			"ORDER BY count DESC, EVAL_ID ";
    res = conn.prepareStatement(sql).executeQuery();
	
    while(res.next()) {            
      String evalItem = res.getString("evalItem");
      String count = res.getString("count");   
	%>
	<br><div style="display: flex; font-size: 18px;">
			<div style="display: inline-block; margin: auto; flex: 2; text-align: left; margin-left: 5px;">
				<%=evalItem %>
			</div>
			<div style="display: inline-block; margin: auto; flex: 1; text-align: center;">
				<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" class="bi bi-people" viewBox="0 0 16 16">
				  <path d="M15 14s1 0 1-1-1-4-5-4-5 3-5 4 1 1 1 1h8zm-7.978-1A.261.261 0 0 1 7 12.996c.001-.264.167-1.03.76-1.72C8.312 10.629 9.282 10 11 10c1.717 0 2.687.63 3.24 1.276.593.69.758 1.457.76 1.72l-.008.002a.274.274 0 0 1-.014.002H7.022zM11 7a2 2 0 1 0 0-4 2 2 0 0 0 0 4zm3-2a3 3 0 1 1-6 0 3 3 0 0 1 6 0zM6.936 9.28a5.88 5.88 0 0 0-1.23-.247A7.35 7.35 0 0 0 5 9c-4 0-5 3-5 4 0 .667.333 1 1 1h4.216A2.238 2.238 0 0 1 5 13c0-1.01.377-2.042 1.09-2.904.243-.294.526-.569.846-.816zM4.92 10A5.493 5.493 0 0 0 4 13H1c0-.26.164-1.03.76-1.724.545-.636 1.492-1.256 3.16-1.275zM1.5 5.5a3 3 0 1 1 6 0 3 3 0 0 1-6 0zm3-2a2 2 0 1 0 0 4 2 2 0 0 0 0-4z"/>
				</svg>
				<%=count %>
			</div>
	</div><br>
	<%
	 }
	res.close();
	conn.close();
	%>
	</div>
</body>
</html>