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
	
	String memb_id = request.getParameter("MembId");
	
	sql = String.format("SELECT FULL_NM, MEMB_STATUS, NVL(MBTI,'입력해주세요') MBTI FROM MEMB_INFO WHERE MEMB_ID = '%s'", memb_id);
	res = conn.prepareStatement(sql).executeQuery();
	res.next();
	System.out.print(sql);
	String name = res.getString("FULL_NM");
	String status = res.getString("MEMB_STATUS");
	String mbti = res.getString("MBTI");
	
	sql = "SELECT COUNT(*) count_ing FROM TRIP_JOIN_LIST l JOIN TRIP_INFO i "+
			"ON l.trip_id = i.trip_id "+
			"WHERE i.trip_status = '진행중' "+
			"AND l.memb_id = '" + memb_id + "' "+
			"AND to_char(i.TRIP_MEET_DATE,'YYYY-MM-DD') >= to_char(SYSDATE, 'YYYY-MM-DD') ";
	res = conn.prepareStatement(sql).executeQuery();
	res.next();
	System.out.print(sql);
	String count_ing = res.getString("count_ing");
	
	sql = "SELECT COUNT(*) count_prev FROM TRIP_JOIN_LIST l JOIN TRIP_INFO i "+
			"ON l.trip_id = i.trip_id "+
			"WHERE i.trip_status = '진행중' "+
			"AND l.memb_id = '" + memb_id + "' "+
			"AND l.prg_status = '수락' "+
			"AND to_char(i.TRIP_MEET_DATE,'YYYY-MM-DD') < to_char(SYSDATE, 'YYYY-MM-DD') ";
	res = conn.prepareStatement(sql).executeQuery();
	res.next();
	System.out.print(sql);
	String count_prev = res.getString("count_prev");
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
	
	<title>MY PAGE</title>
</head>
<body style="line-height: 200%">
	<div style="background-color: rgba(66, 133, 244, 0.5);">
		<br><h2 style="text-align: center"><%=name %>님</h2><br>
	</div><hr style="margin-top: 0px; margin-bottom: 30px;">
	<!-- 만족도/재동행희망률 /동적 변환, db연동 필요 -->
	<div class="myPageText2">나에 대한 평가</div>
	<div style="margin: auto; width: 95%; height: 30px; background-color:#dedede;">           
		<div style="width: 80%; height: 30px; padding: 0; text-align:center; background-color: rgba(66, 133, 244, 0.5);"> </div>
	</div><br>
	<div class="myPageText2">재동행 희망률</div>
	<div style="margin: auto; width: 95%; height: 30px; background-color:#dedede;">           
		<div style="width: 70%; height: 30px; padding: 0; text-align:center; background-color: rgba(66, 133, 244, 0.5);"> </div>
	</div>
	<hr style="margin-top: 30px; margin-bottom: 30px;">
	<!-- 진행중인 여행 -->
	<form name="frmMyTrip" action="myTrip.jsp" method="get" >
		<button class="myTrip" type="submit">
			<div class="myPageButton">진행중인 여행</div>
			<div class="myPageButton2"><%=count_ing %>건 ></div>
		</button>
		<input type="hidden" name="membId" value="<%=memb_id %>" />
	</form>
	<!-- 완료한 여행 -->
	<form name="frmMyTripPast" action="myTripPast.jsp" method="get" >
		<button class="myTrip" type="submit">
			<div class="myPageButton">완료한 여행<br><p style="font-size: 10px;">*완료한 여행에 대해 평가하세요</p></div>
			<div class="myPageButton2"><%=count_prev %>건 ></div>
		</button>
		<input type="hidden" name="membId" value="<%=memb_id %>" />
	</form>
	<!-- 받은 매너 평가 -->
	<form name="frmMyEvaluation" action="myEvaluation.jsp" method="get" >
		<button class="myTrip" type="submit">
			<div class="myPageButton">받은 매너 평가</div>
			<div class="myPageButton2">></div>
		</button>
		<input type="hidden" name="membId" value="<%=memb_id %>" />
	</form>
	<!-- 나의 관심사 -->
	<div class="myPageText">나의 관심사</div>
	<form name="frmMyInterest" action="myInterset.jsp" method="get" >
		<button class="myTrip" type="submit">
			<div class="myPageButton">궁, 강 ..(db연동)</div>
			<div class="myPageButton2">></div>
		</button>
		<input type="hidden" name="membId" value="<%=memb_id %>" />
	</form>
	<!-- 나의 mbti -->
	<div class="myPageText">MBTI</div>
	<form name="frmMyMBTI" action="myMBTI.jsp" method="get" >
		<button class="myTrip" type="submit">
			<div class="myPageButton"><%=mbti %></div>
			<div class="myPageButton2">></div>
		</button>
		<input type="hidden" name="membId" value="<%=memb_id %>" />
	</form>
	<%
    	res.close();
		conn.close();
	%>
</body>
</html>