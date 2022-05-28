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
	
	String sightId = request.getParameter("sightId");
	String membId = request.getParameter("membId");
	String Title = request.getParameter("Title");
	String Date = request.getParameter("Date");
	String Place = request.getParameter("Place");
	String Time = request.getParameter("Time");
	String Num = request.getParameter("Num");
	String Cost = request.getParameter("Cost");
	String Detail = request.getParameter("Detail");
	String Link = request.getParameter("Link");
	
	
	sql = String.format("SELECT TRIP_SEQ.NEXTVAL tripId FROM DUAL ");
	res = conn.prepareStatement(sql).executeQuery();
	res.next();
	String tripId = res.getString("tripId");
   
	//trip_id 넣어서 trip_info에등록
	sql = String.format( "INSERT INTO TRIP_INFO (TRIP_ID,SIGHTS_ID,MEMB_ID,TRIP_TITLE,TRIP_MEET_DATE,TRIP_MEET_PLACE,TRIP_MEET_TIME,TOT_NUM,PLAN_COST,TRIP_DETAIL,TRIP_CHATLINK,TRIP_STATUS) values (to_number('%s'),to_number('%s'),'%s','%s',to_date('%s','YYYY-MM-DD'),'%s','%s',to_number('%s'),to_number('%s'),'%s','%s','진행중')",
			tripId, sightId, membId, Title, Date, Place, Time, Num, Cost, Detail, Link); 
	System.out.println(sql);
	conn.prepareStatement(sql).executeUpdate();
	//주최자도 trip_join_list에 등록 (수락상태로 등록)
	sql = String.format( "INSERT INTO TRIP_JOIN_LIST (TRIP_ID,MEMB_ID,PRG_STATUS) values (to_number('%s'),'%s','수락')",
			tripId, membId); 
	System.out.println(sql);
	conn.prepareStatement(sql).executeUpdate();
	
	res.close();
	conn.close();
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
	<br><br><br><br><div style="font-size: 13px; font-weight: bold; text-align:center;"><a>여행 개설이 완료되었습니다.</a></div><br><br>
	<div style="margin: 0 auto; text-align: center; height: 100px;">
		<form name="frmTripInfo" action="index.jsp" method="get" >
			<button onClick="location.href='index.jsp'" style=" display: inline-block; border-radius: 6px; background-color: rgba(66, 133, 244, 0.3); height: 25px;">확인</button>
			<input type="hidden" name="ID" value="<%=membId %>" />
		</form>
	</div>
</body>
</html>