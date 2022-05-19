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
	String sightClas = res.getString("SIGHTS_CLAS");
	String sightPhone = res.getString("SIGHTS_PHONE_NUM");
	String sightWeb = res.getString("SIGHTS_WEBSITE");
	String sightTime = res.getString("SIGHTS_TIME");
	String sightWeek = res.getString("SIGHTS_WEEK");
	String sightOff = res.getString("SIGHTS_OFF");
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
	
	<title>SIGHTS INFO</title>
</head>
<body style="line-height: 200%">
	<br><h2 style="text-align: center">관광지 상세정보</h2>
	<hr> 
	관광지 명 : <%=sightName %>
	<br>테마 : <%=sightClas %>
	<br>주소 : <%=sightAddr %>
	<br>전화번호 : <%=sightPhone %>
	<br>웹사이트 : <%=sightWeb %>
	<br>운영 시간 : <%=sightTime %>
	<br>운영 요일 : <%=sightWeek %>
	<br>휴무일 : <%=sightOff %>
	<br>교통 정보 : <%=sightTraf %>
	<br>#<%=sightClas %>
	<%
    	res.close();
		conn.close();
	%>
	<br><br><br>
	<footer style="position: fixed; bottom: 0; width: 100%;">
	<!-- 여행 개설 -->
	<form name="frmMakeTrip" action="makeTrip.jsp" method="post" >
		<button class="makeTripButton" type="submit">선택하기</button>
		<input type="hidden" name="membId" value="<%=memb_id %>" />
		<input type="hidden" name="sightId" value="<%=sight_id %>" />
	</form>
	</footer>
</body>
</html>