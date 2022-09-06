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
	
	<title>My Trip</title>
</head>
<body>
	<div style="background-color: transparent; top: 5px;">
		<div style="position: absolute; left: 10px; top: 5px; z-index: 2;">
			<a href="myPage.jsp?MembId=<%=memb_id %>">
				<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-arrow-left" viewBox="0 0 16 16">
				  <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8z"/>
				</svg>
			</a>
			<a href="index.jsp?ID=<%=memb_id %>">
				<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-house-door" viewBox="0 0 16 16">
				  <path d="M8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4.5a.5.5 0 0 0 .5-.5v-4h2v4a.5.5 0 0 0 .5.5H14a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146zM2.5 14V7.707l5.5-5.5 5.5 5.5V14H10v-4a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5v4H2.5z"/>
				</svg>
			</a>
		</div>
		<div style="margin: auto; position: relative; top: 10px; text-align: center; z-index: 1;">
			<p style="font-size: 20px; font-weight: bold; font-color: block;">완료한 여행목록</p>
		</div>
	</div>
	<br><br><br>
	<div style="margin: auto; text-align: center;">
		<div style="display: inline-block; padding: 10px; font-size: 15px; font-weight: bold; background-color: rgba(13, 45, 132); color: white; border-radius: 10px;">"완료한 여행에 대해 평가를 진행해주세요."</div>
	</div><br><br>
	<h4 style="margin-left: 2%;"> 주최한 여행 </h4>
	<br>
	<table class="myTripList">
		<tr style="color: white; background-color: rgb(14, 45, 132);">
			<th style="height: 20px; line-height: 20px; text-align: center; font-size: 15px;">제목</th>
			<th style="text-align: center; font-size: 15px;">여행 날짜</th>
		</tr>
		<%     
		sql = "SELECT i.TRIP_ID, i.TRIP_TITLE, TO_CHAR(i.TRIP_MEET_DATE, 'YYYY-MM-DD') AS TRIP_MEET_DATE FROM TRIP_JOIN_LIST l JOIN TRIP_INFO i "+
				"ON l.trip_id = i.trip_id AND i.memb_id = l.memb_id "+
				"WHERE i.trip_status = '진행중' "+
				"AND i.memb_id = '" + memb_id + "' "+
				"AND to_char(i.TRIP_MEET_DATE,'YYYY-MM-DD') < to_char(SYSDATE, 'YYYY-MM-DD') "+
				"ORDER BY TRIP_MEET_DATE DESC";
		    res = conn.prepareStatement(sql).executeQuery();
			
		    while(res.next()) {            
		      String tripId = res.getString("TRIP_ID");
		      String tripTitle = res.getString("TRIP_TITLE");   
		      String date = res.getString("TRIP_MEET_DATE");
		%>
		<tr>
			<td style="height: 15px; line-height: 15px; font-size: 13px;">
				<form name="frmMyTripHost" action="pastTrip.jsp" method="get" >
					<button class="myTripButton" type="submit" style="text-align: center;"><%=tripTitle%></button>
					<input type="hidden" name="tripId" value="<%=tripId %>" />
					<input type="hidden" name="membId" value="<%=memb_id %>" />
				</form>
			</td>
			<td style="font-size: 13px; text-align:center; "><%=date%></td>
		</tr>
		<%
		    }
		%>
	</table> 
	<br><br>
	<h4 style="margin-left: 2%;"> 참여한 여행 </h4>
	<br>
	<table class="myTripList">
		<tr style="color: white; background-color: rgb(14, 45, 132);">
			<th style="height: 20px; line-height: 20px; text-align: center; font-size: 15px;">제목</th>
			<th style="text-align: center; font-size: 15px;">여행 날짜</th>
		</tr>
		<%     
		sql = "SELECT i.TRIP_ID, i.TRIP_TITLE, TO_CHAR(i.TRIP_MEET_DATE, 'YYYY-MM-DD') AS TRIP_MEET_DATE FROM TRIP_JOIN_LIST l JOIN TRIP_INFO i "+
				"ON l.trip_id = i.trip_id "+
				"WHERE i.trip_status = '진행중' "+
				"AND l.memb_id = '" + memb_id + "' "+
				"AND i.memb_id != '" + memb_id + "' "+
				"AND l.prg_status = '수락' "+
				"AND to_char(i.TRIP_MEET_DATE,'YYYY-MM-DD') < to_char(SYSDATE, 'YYYY-MM-DD') "+
				"ORDER BY TRIP_MEET_DATE DESC";
		    res = conn.prepareStatement(sql).executeQuery();
			
		    while(res.next()) {            
		      String tripId = res.getString("TRIP_ID");
		      String tripTitle = res.getString("TRIP_TITLE");   
		      String date = res.getString("TRIP_MEET_DATE");
		%>
		<tr>
			<td style="height: 15px; line-height: 15px; font-size: 13px;">
				<form name="frmMyTripHost" action="pastTrip.jsp" method="get" >
					<button class="myTripButton" type="submit" style="text-align: center; "><%=tripTitle%></button>
					<input type="hidden" name="tripId" value="<%=tripId %>" />
					<input type="hidden" name="membId" value="<%=memb_id %>" />
				</form>
			</td>
			<td style="font-size: 13px; text-align: center;"><%=date%></td>
		</tr>
		<%
		    }
		    res.close();
	 		conn.close();
		%>
	</table> 
</body>
</html>