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
	<div style="display: inline; position: relative; left: 10px; top: 5px;">
		<a href="#" onClick="history.go(-1); return false;">
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
	<br><h2 style="text-align: center">진행중인 여행 목록</h2>
	<hr><br>
	<h4> 주최한 여행 </h4>
	<br>
	<table class="myTripList">
		<tr style=" background-color: rgba(66, 133, 244, 0.1);">
			<th style="height: 20px; line-height: 20px;">제목</th>
			<th>여행 날짜</th>
			<th>비고</th>
		</tr>
		<%     
		sql = "SELECT i.TRIP_ID, i.TRIP_TITLE, i.TRIP_STATUS, TO_CHAR(i.TRIP_MEET_DATE, 'YYYY-MM-DD') AS TRIP_MEET_DATE "+
				"FROM TRIP_JOIN_LIST l JOIN TRIP_INFO i ON l.trip_id = i.trip_id AND i.memb_id = l.memb_id "+
				"WHERE i.memb_id = '" + memb_id + "' "+
				"AND to_char(i.TRIP_MEET_DATE,'YYYY-MM-DD') >= to_char(SYSDATE, 'YYYY-MM-DD') "+
				"ORDER BY TRIP_MEET_DATE ";
		    res = conn.prepareStatement(sql).executeQuery();
			
		    while(res.next()) {            
		      String tripId = res.getString("TRIP_ID");
		      String tripTitle = res.getString("TRIP_TITLE");   
		      String date = res.getString("TRIP_MEET_DATE");
		      String tripStatus = res.getString("TRIP_STATUS");
		%>
		<tr>
			<td style="font-size: 13px;">
				<form name="frmMyTripHost" action="myTripHost.jsp" method="get" >
					<button class="myTripButton" type="submit"><%=tripTitle%></button>
					<input type="hidden" name="tripId" value="<%=tripId %>" />
					<input type="hidden" name="membId" value="<%=memb_id %>" />
				</form>
			</td>
			<td style="font-size: 13px;"><%=date%></td>
			<td style="font-size: 13px;"><%=tripStatus%></td>
		</tr>
		<%
		    }
		%>
	</table> 
	<br><br>
	<h4> 참여한 여행 </h4>
	<br>
	<table class="myTripList">
		<tr style=" background-color: rgba(66, 133, 244, 0.1);">
			<th style="height: 20px; line-height: 20px;">제목</th>
			<th>여행 날짜</th>
			<th>진행 상태</th>
		</tr>
		<%     
		sql = "SELECT i.TRIP_ID, i.TRIP_TITLE, TO_CHAR(i.TRIP_MEET_DATE, 'YYYY-MM-DD') AS TRIP_MEET_DATE, PRG_STATUS FROM TRIP_JOIN_LIST l JOIN TRIP_INFO i "+
				"ON l.trip_id = i.trip_id "+
				"WHERE l.memb_id = '" + memb_id + "' "+
				"AND i.memb_id != '" + memb_id + "' "+
				"AND to_char(i.TRIP_MEET_DATE,'YYYY-MM-DD') >= to_char(SYSDATE, 'YYYY-MM-DD') "+
				"ORDER BY TRIP_MEET_DATE ";
		    res = conn.prepareStatement(sql).executeQuery();
			
		    while(res.next()) {            
		      String tripId = res.getString("TRIP_ID");
		      String tripTitle = res.getString("TRIP_TITLE");   
		      String date = res.getString("TRIP_MEET_DATE");
		      String status = res.getString("PRG_STATUS");
		%>
		<tr>
			<td style="font-size: 13px;">
				<form name="frmMyTripHost" action="myTripJoin.jsp" method="get" >
					<button class="myTripButton" type="submit"><%=tripTitle%></button>
					<input type="hidden" name="tripId" value="<%=tripId %>" />
					<input type="hidden" name="membId" value="<%=memb_id %>" />
					<input type="hidden" name="status" value="<%=status %>" />
				</form>
			</td>
			<td style="font-size: 13px;"><%=date%></td>
			<td style="font-size: 13px;"><%=status%></td>
		</tr>
		<%
		    }
		    res.close();
	 		conn.close();
		%>
	</table> 
</body>
</html>