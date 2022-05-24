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
	<br><h2 style="text-align: center">완료한 여행 목록</h2>
	<hr><br>
	<h4> 주최한 여행 </h4>
	<br>
	<table class="myTripList">
		<tr style=" background-color: rgba(51, 150, 51, 0.1);">
			<th style="height: 20px; line-height: 20px;">제목</th>
			<th>여행 날짜</th>
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
			<td style="font-size: 13px;">
				<form name="frmMyTripHost" action="myTripHost.jsp" method="post" >
					<button class="myTripButton" type="submit"><%=tripTitle%></button>
					<input type="hidden" name="tripId" value="<%=tripId %>" />
					<input type="hidden" name="membId" value="<%=memb_id %>" />
				</form>
			</td>
			<td style="font-size: 13px;"><%=date%></td>
		</tr>
		<%
		    }
		%>
	</table> 
	<br><br>
	<h4> 참여한 여행 </h4>
	<br>
	<table class="myTripList">
		<tr style=" background-color: rgba(51, 150, 51, 0.1);">
			<th style="height: 20px; line-height: 20px;">제목</th>
			<th>여행 날짜</th>
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
			<td style="font-size: 13px;">
				<form name="frmMyTripHost" action="myTripHost.jsp" method="post" >
					<button class="myTripButton" type="submit"><%=tripTitle%></button>
					<input type="hidden" name="tripId" value="<%=tripId %>" />
					<input type="hidden" name="membId" value="<%=memb_id %>" />
				</form>
			</td>
			<td style="font-size: 13px;"><%=date%></td>
		</tr>
		<%
		    }
		    res.close();
	 		conn.close();
		%>
	</table> 
</body>
</html>