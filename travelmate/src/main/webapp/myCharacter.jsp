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
	ResultSet rs = null;
	
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
	<link rel="stylesheet" href="./css/custom.css?next">
	<meta name="google-signin-scope" content="profile email">
    <meta name="google-signin-client_id" content="120857777045-1oeeagtes07pmn0n2q2kfnvja770b2eg.apps.googleusercontent.com"/>
    <script src="https://apis.google.com/js/platform.js" async defer></script>
	
	<!-- 부트스트랩 자바스크립트 추가하기 -->
	<script src="./js/bootstrap.min.js"></script>
	<!-- 제이쿼리 자바스크립트 추가하기 -->
	<script src="./js/jquery.min.js"></script>
	<!-- 파퍼 자바스크립트 추가하기 -->
	<script src="./js/pooper.js"></script>
	
	<title>Character</title>
</head>
<body style="line-height: 100%">
	<div style="display: inline; position: relative; left: 10px; top: 5px;">
		<a href="#" onClick="history.go(-1); return false;">
			<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-arrow-left" viewBox="0 0 16 16">
			  <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8z"/>
			</svg>
		</a>
	</div>
	<br><h2 style="text-align: center">나의 성격</h2>
	<hr> 
	<div style="margin: 0 auto; text-align: center;">
		<form name="frmCharacter" method="get" action="characterFinish.jsp">
			<div class="character-container">
				<div class="character-list">
					<div style="font-weight: bold; text-align: left; margin-left: 30px; font-size: 17px;">MBTI</div><br>
					<%
					sql = "SELECT * FROM CHARACTER_LIST ORDER BY CHARACTER_ID ";
					res = conn.prepareStatement(sql).executeQuery();
					
				    while(res.next()) {   
						String character_id = res.getString("CHARACTER_ID");
					    String character_nm = res.getString("CHARACTER_NM");
					%>
					<%if("17".equals(character_id)) {%>
					<br><br><hr style="background-color: #555; height: 2px; width: 95%; margin:auto;"><br><div style="font-weight: bold; text-align: left; margin-left: 30px; font-size: 17px;">#성격</div><br>
					<%} %>
						<div class="form-element">
							<input type="checkbox" name="checkedValue" value="<%=character_id %>" id="<%=character_id %>"
							<%
							sql = "SELECT * FROM MEMB_CHARACTER WHERE MEMB_ID = '" + memb_id + "' AND CHARACTER_ID = '" + character_id + "' ";
							rs = conn.prepareStatement(sql).executeQuery();
						
							if(rs.next()){%>
								checked
							<%} %>
							>
							<label for="<%=character_id %>">
								<div class="title">
								<%if("17".equals(character_id)||"18".equals(character_id)||"19".equals(character_id)||"20".equals(character_id)||"21".equals(character_id)||"22".equals(character_id)||"23".equals(character_id)||"24".equals(character_id)||"25".equals(character_id)) {%>#<%}%>
								<%=character_nm %></div>
							</label>
						</div>
					<%} %>
				</div>
			</div>
			<br><br><br><br>
			<footer style="position: fixed; bottom: 0; width: 100%;">
				<!-- 성격 수정 -->
				<button class="changeCharacter" type="submit" style="color: white; font-size: 22px; border-radius: 5em; width: 300px; margin-left: 8%; margin-bottom: 4%; background-color: rgb(13, 45, 132); border: 2px solid rgb(13, 45, 132);">수정하기</button>
				<input type="hidden" name="membId" id="membId" value="<%=memb_id %>" />
			</footer>
		</form>
	</div>
</body>
</html>