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
	String participantId = request.getParameter("participantId");
	String tripId = request.getParameter("tripId");
	
	String rating = request.getParameter("rating");
	String[] checkedValue = request.getParameterValues("checkedValue");
	
	if(rating.equals("happy")){
		sql = String.format( "INSERT INTO MEMB_SCORE (TRIP_ID,GIVE_MEMB_ID,GET_MEMB_ID,SATIS_SCORE) values (to_number('%s'),'%s','%s',100)",
				tripId, membId, participantId); 
		System.out.println(sql);
		conn.prepareStatement(sql).executeUpdate();
	} else if(rating.equals("neutral")){
		sql = String.format( "INSERT INTO MEMB_SCORE (TRIP_ID,GIVE_MEMB_ID,GET_MEMB_ID,SATIS_SCORE) values (to_number('%s'),'%s','%s',70)",
				tripId, membId, participantId); 
		System.out.println(sql);
		conn.prepareStatement(sql).executeUpdate();
	} else{
		sql = String.format( "INSERT INTO MEMB_SCORE (TRIP_ID,GIVE_MEMB_ID,GET_MEMB_ID,SATIS_SCORE) values (to_number('%s'),'%s','%s',40)",
				tripId, membId, participantId); 
		System.out.println(sql);
		conn.prepareStatement(sql).executeUpdate();
	}
	
	for(int i = 0; i < checkedValue.length; i++) {
		sql = String.format( "INSERT INTO MEMB_EVALUATION (TRIP_ID,GIVE_MEMB_ID,GET_MEMB_ID,EVAL_ID) values (to_number('%s'),'%s','%s',to_number('%s'))",
				tripId, membId, participantId, checkedValue[i]); 
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
			<button onClick="location.href='pastTrip.jsp'" style=" display: inline-block; border-radius: 6px; background-color: rgba(66, 133, 244, 0.3); height: 25px;">확인</button>
			<input type="hidden" name="membId" value="<%=membId %>" />
			<input type="hidden" name="tripId" value="<%=tripId %>" />
		</form>
	</div>
</body>
</html>