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
	<br><h3> 검색 여행 목록 </h3>  
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
			<br><div style="font-weight:bold; line-height:50%;"><%=TRIP_TITLE%></div>
			<br>
			<!-- 여행 날짜 -->
			<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-calendar-event" viewBox="0 0 16 16">
				<path d="M11 6.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1z"/>
				<path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5zM1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4H1z"/>
			</svg>
			&nbsp;<%=TRIP_MEET_DATE%>
			<br>
			<!-- 모집 인원 -->
			<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-person-plus" viewBox="0 0 16 16">
				<path d="M6 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0zm4 8c0 1-1 1-1 1H1s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C9.516 10.68 8.289 10 6 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/>
				<path fill-rule="evenodd" d="M13.5 5a.5.5 0 0 1 .5.5V7h1.5a.5.5 0 0 1 0 1H14v1.5a.5.5 0 0 1-1 0V8h-1.5a.5.5 0 0 1 0-1H13V5.5a.5.5 0 0 1 .5-.5z"/>
			</svg>
			&nbsp;<%=TOT_NUM%>
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