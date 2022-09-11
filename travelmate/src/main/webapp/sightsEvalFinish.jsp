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
	
	String membId = request.getParameter("membId");
	String sightId = request.getParameter("sightId");
	String tripId = request.getParameter("tripId");
	
	String rating = request.getParameter("reviewStar");
	
	if(rating.equals("5")){
		sql = String.format( "INSERT INTO SIGHTS_SCORE (SIGHTS_ID,GIVE_MEMB_ID,TRIP_ID,SIGHTS_SCORE) values ('%s','%s','%s',100)",
				sightId, membId, tripId); 
		System.out.println(sql);
		conn.prepareStatement(sql).executeUpdate();
	} else if(rating.equals("4")){
		sql = String.format( "INSERT INTO SIGHTS_SCORE (SIGHTS_ID,GIVE_MEMB_ID,TRIP_ID,SIGHTS_SCORE) values ('%s','%s','%s',80)",
				sightId, membId, tripId); 
		System.out.println(sql);
		conn.prepareStatement(sql).executeUpdate();
	} else if(rating.equals("3")){
		sql = String.format( "INSERT INTO SIGHTS_SCORE (SIGHTS_ID,GIVE_MEMB_ID,TRIP_ID,SIGHTS_SCORE) values ('%s','%s','%s',60)",
				sightId, membId, tripId); 
		System.out.println(sql);
		conn.prepareStatement(sql).executeUpdate();
	} else if(rating.equals("2")){
		sql = String.format( "INSERT INTO SIGHTS_SCORE (SIGHTS_ID,GIVE_MEMB_ID,TRIP_ID,SIGHTS_SCORE) values ('%s','%s','%s',40)",
				sightId, membId, tripId); 
		System.out.println(sql);
		conn.prepareStatement(sql).executeUpdate();
	} else{
		sql = String.format( "INSERT INTO SIGHTS_SCORE (SIGHTS_ID,GIVE_MEMB_ID,TRIP_ID,SIGHTS_SCORE) values ('%s','%s','%s',20)",
				sightId, membId, tripId); 
		System.out.println(sql);
		conn.prepareStatement(sql).executeUpdate();
	}

	//res.close();
	//conn.close();
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
	
	<title>Make Trip Finish</title>
</head>
<body style="line-height: 100%">
	<br><br><br><br>
	<div style="font-size: 20px; font-weight: bold; text-align:center;"><a>평가가 완료되었습니다.</a></div>
	<br><br><br>
	<div style="margin: 0 auto; text-align: center; height: 100px;">
		<form name="frm" action="pastTrip.jsp" method="get" >
			<button onClick="location.href='pastTrip.jsp'" style=" display: inline-block; border-radius: 6px; background-color: rgba(13, 45, 132); color: white; height: 25px;">확인</button>
			<input type="hidden" name="membId" value="<%=membId %>" />
			<input type="hidden" name="tripId" value="<%=tripId %>" />
		</form>
	</div>
</body>
</html>