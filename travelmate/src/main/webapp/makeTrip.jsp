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
	String sight_id = request.getParameter("sightId");
	
	sql = String.format("SELECT * FROM SIGHTS_INFO WHERE SIGHTS_ID = '%s'", sight_id);
	res = conn.prepareStatement(sql).executeQuery();
	res.next();
	
	String sightId = res.getString("SIGHTS_ID");
	String sightName = res.getString("SIGHTS_NM");
	String sightAddr = res.getString("SIGHTS_ADDR");
	String sightTraf = res.getString("SIGHTS_TRAFFIC");
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
	<meta name="google-signin-scope" content="profile email">
    <meta name="google-signin-client_id" content="120857777045-1oeeagtes07pmn0n2q2kfnvja770b2eg.apps.googleusercontent.com"/>
    <script src="https://apis.google.com/js/platform.js" async defer></script>
	
	<!-- 부트스트랩 자바스크립트 추가하기 -->
	<script src="./js/bootstrap.min.js"></script>
	<!-- 제이쿼리 자바스크립트 추가하기 -->
	<script src="./js/jquery.min.js"></script>
	<!-- 파퍼 자바스크립트 추가하기 -->
	<script src="./js/pooper.js"></script>
	
	<title>Make Trip</title>
</head>
<body style="line-height: 100%">
	<br><h2 style="text-align: center">여행 계획하기</h2>
	<hr> 
	<form name="frmMakeTrip" action="makeTripCheck.jsp" method="post" >
		<div class="makeTripInput">
			<div style="width:100%; height:25px; float:left; line-height: 25px;">제목</div><input type="text" name="Title" id="txtTitle" value=""/><br><br>
			<div style="width:100%; height:25px; float:left; line-height: 25px;">여행날짜</div><input type="text" name="Date" id="txtDate" value="" placeholder="YYYY-MM-DD"/><br><br>
			<div style="border: 1px solid black;"><br>
				<p style="color: red; font-size: 13px;">*모임시간,장소,오픈채팅링크는<br>수락이 결정된 참여자에 한하여 열람 가능합니다.</p><br>
				<div style="width:100%; height:25px; float:left; line-height: 25px;">모임시간</div><input type="text" name="Time" id="txtTime" value=""/><br><br>
				<div style="width:100%; height:25px; float:left; line-height: 25px;">모임장소</div><input type="text" name="Place" id="txtPlace" value=""/><br><br>
				<div style="width:100%; height:25px; float:left; line-height: 25px;">오픈채팅방</div><input type="text" name="Link" id="txtLink" value=""  placeholder="*필수 항목 아님"/><br><br>
			</div><br>
			<div style="width:100%; height:25px; float:left; line-height: 25px;">모객인원</div><input type="number" name="Num" id="txtNum" value=""/><br><br>
			<div style="width:100%; height:25px; float:left; line-height: 25px;">예상비용</div><input type="number" name="Cost" id="txtCost" value=""/><br><br>
			<div style="width:100%; height:25px; float:left; line-height: 25px;">관광지명</div><div style="border: 2px solid black; width : 90%; display:inline-block; line-height: 25px;"> <%=sightName %> </div>
			<br><br><div style="width:100%; height:25px; float:left; line-height: 25px;">주소</div><div style="border: 2px solid black; width : 90%; display:inline-block; line-height: 25px;"> <%=sightAddr %> </div>
			<br><br><div style="width:100%; height:25px; float:left; line-height: 25px;">교통정보</div><div style="border: 2px solid black; width : 90%; display:inline-block; line-height: 25px;"> <%=sightTraf %> </div>
			<br><br><div style="width:100%; height:25px; float:left; line-height: 25px;">세부정보</div><textarea name="Detail" id="txtDetail" rows="7" style="border: 2px solid black; border-radius: 30px; padding: 0 1em; width:90%; font-size:15px;"></textarea><br><br><br><br><br>
		</div>
		<footer style="position: fixed; bottom: 0; width: 100%;">
			<!-- 여행 개설 -->
			<button class="makeTripButton" type="submit">개설하기</button>
			<input type="hidden" name="membId" value="<%=memb_id %>" />
			<input type="hidden" name="sightId" value="<%=sight_id %>" />
		</footer>
	</form>
</body>
</html>