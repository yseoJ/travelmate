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
	
	String id = request.getParameter("MembId");
	String search = request.getParameter("search");
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
	
	<title>TRAVELMATE</title>
</head>
<body>
	<h4> 여행 목록 </h4>  
    <%     
    sql = "SELECT t.TRIP_ID, t.TRIP_TITLE, TO_CHAR(t.TRIP_MEET_DATE, 'YYYY/MM/DD') TRIP_MEET_DATE,  t.TOT_NUM "+
    		"FROM TRIP_INFO t JOIN SIGHTS_INFO s "+
    		"ON t.SIGHTS_ID = s.SIGHTS_ID "+
    		"WHERE t.TRIP_TITLE LIKE '%" + search + "%' "+
    		"OR s.SIGHTS_NM LIKE '%" + search + "%' "+
    		"OR s.SIGHTS_ADDR LIKE '%" + search + "%' "+
    		"OR s.SIGHTS_CLAS LIKE '%" + search + "%' "+
    		"OR s.SIGHTS_TRAFFIC LIKE '%" + search + "%' "+
    		"ORDER BY TRIP_MEET_DATE";
    				
    res = conn.prepareStatement(sql).executeQuery();
    System.out.println(sql);
	
    while(res.next()) {            
      String TRIP_TITLE = res.getString("TRIP_TITLE");
      String TRIP_MEET_DATE = res.getString("TRIP_MEET_DATE");   
      String TOT_NUM = res.getString("TOT_NUM");
      String TRIP_ID = res.getString("TRIP_ID");
      //System.out.print(sql);
	%>
	<br>
	<form name="frmTripInfo" action="tripInfo.jsp" method="post" >
		<button type="submit" class="tripList">
			<br>제목 : <%=TRIP_TITLE%>
			<br>날짜 : <%=TRIP_MEET_DATE%>
			<br>인원 : <%=TOT_NUM%>
			<br><br>
		</button>
		<input type="hidden" name="MembId" value="<%=id %>" />
		<input type="hidden" name="TripTitle" value="<%=TRIP_TITLE %>" />
		<input type="hidden" name="TripId" value="<%=TRIP_ID %>" />
	</form>
    <%
    }
   	res.close();
	conn.close();
	%>
</body>
</html>