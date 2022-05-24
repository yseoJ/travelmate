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
	
	String Title = request.getParameter("Title");
	String Date = request.getParameter("Date");
	String Time = request.getParameter("Time");
	String Place = request.getParameter("Place");
	String Link = request.getParameter("Link");
	String Num = request.getParameter("Num");
	String Cost = request.getParameter("Cost");
	String sightId = request.getParameter("sightId");
	String membId = request.getParameter("membId");
	String Detail = request.getParameter("Detail");
	
	sql = String.format("SELECT * FROM SIGHTS_INFO WHERE SIGHTS_ID = '%s'", sightId);
	res = conn.prepareStatement(sql).executeQuery();
	res.next();
	
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
	
	<title>Make Trip Check</title>
</head>
<body style="line-height: 200%">
	<br><h2 style="text-align: center">여행 계획 확인</h2>
	<hr> 
	<div style="display: inline-block; font-weight: bold; width: 50px">제목:</div><div style="display: inline-block; text-decoration: underline;"><%=Title %></div><br>
	<div style="display: inline-block; font-weight: bold; width: 50px">날짜:</div><div style="display: inline-block; text-decoration: underline;"><%=Date %></div><br>
	<div style="display: inline-block; font-weight: bold; width: 50px">시간:</div><div style="display: inline-block; text-decoration: underline;"><%=Time %></div><br>
	<div style="display: inline-block; font-weight: bold; width: 50px">장소:</div><div style="display: inline-block; text-decoration: underline;"><%=Place %></div><br>
	<div style="display: inline-block; font-weight: bold; width: 100px">오픈채팅방:</div><div style="display: inline-block; text-decoration: underline;"><%=Link %></div><br>
	<div style="display: inline-block; font-weight: bold; width: 50px">인원:</div><div style="display: inline-block; text-decoration: underline;"><%=Num %></div><br>
	<div style="display: inline-block; font-weight: bold; width: 50px">비용:</div><div style="display: inline-block; text-decoration: underline;"><%=Cost %></div><br>
	<div style="display: inline-block; font-weight: bold; width: 80px">관광지명:</div><div style="display: inline-block; text-decoration: underline;"><%=sightName %></div><br>
	<div style="display: inline-block; font-weight: bold; width: 50px">주소:</div><div style="display: inline-block; text-decoration: underline;"><%=sightAddr %></div><br>
	<div style="display: inline-block; font-weight: bold; width: 80px">교통정보:</div><div style="display: inline-block; text-decoration: underline;"><%=sightTraf %></div><br>
	<div style="display: inline-block; font-weight: bold; width: 80px">세부정보:</div><div style="display: inline-block; text-decoration: underline;"><%=Detail %></div><br><br>
	<div style="margin: 0 auto; text-align: center;">
		<button onClick="history.back();" style="line-height:25px; display: inline-block; border-radius: 6px; background-color: white; height: 25px;">이전</button>
		<form name="frmMakeTripCheck" action="makeTripFinish.jsp" method="post" style="display: inline;">
			<button type="submit" style="line-height:25px; display: inline-block; border-radius: 6px; background-color: rgba(51, 150, 51, 0.3); height: 25px;">확인</button>
			<input type="hidden" name="membId" value="<%=membId %>" />
			<input type="hidden" name="sightId" value="<%=sightId %>" />
			<input type="hidden" name="Title" value="<%=Title %>" />
			<input type="hidden" name="Date" value="<%=Date %>" />
			<input type="hidden" name="Time" value="<%=Time %>" />
			<input type="hidden" name="Place" value="<%=Place %>" />
			<input type="hidden" name="Num" value="<%=Num %>" />
			<input type="hidden" name="Cost" value="<%=Cost %>" />
			<input type="hidden" name="Detail" value="<%=Detail %>" />
			<input type="hidden" name="Link" value="<%=Link %>" />
		</form>
	</div>
</body>
</html>