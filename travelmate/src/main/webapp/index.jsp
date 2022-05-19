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
	
	String id = request.getParameter("ID");

	sql = String.format( "select * from MEMB_INFO where MEMB_ID = '%s'", id);
	res = conn.prepareStatement(sql).executeQuery();
	//System.out.println(res.next());
	
	if(!res.next()){
		String name = request.getParameter("NAME");
		String email = request.getParameter("EMAIL");
		String phone = request.getParameter("PHONE_NUM");
		String gender = request.getParameter("GENDER");
		String adyear = request.getParameter("ADDM_YEAR");

		sql = String.format( "Insert into MEMB_INFO (MEMB_ID,FULL_NM,EMAIL_ADDR,ADDM_YEAR,PHONE_NUM,GENDER,MEMB_STATUS) values ('%s','%s','%s','%s','%s','%s','가입') ", id, name, email, adyear, phone, gender); 
		conn.prepareStatement(sql).executeUpdate();
	}
	
	sql = String.format( "select * from MEMB_INFO where MEMB_ID = '%s'", id);
	System.out.println(sql);
	res = conn.prepareStatement(sql).executeQuery();
	res.next();
	String DbId = res.getString("MEMB_ID");
	String DbName = res.getString("FULL_NM");
	String DbEmail = res.getString("EMAIL_ADDR");
	String DbPhone = res.getString("PHONE_NUM");
	String DbGender = res.getString("GENDER");
	String DbAdyear = res.getString("ADDM_YEAR");
	String DbStatus = res.getString("MEMB_STATUS");
	System.out.print(DbId); System.out.print(DbName); System.out.print(DbEmail); System.out.print(DbPhone); System.out.print(DbGender); System.out.print(DbAdyear); System.out.print(DbStatus);
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
	<header style="position: fixed; top: 0; width: 100%; height:50px; z-index: 1">
		<nav class="navbar navbar-expand-lg navbar-light bg-light">
			<div style="display: inline; margin: 0 auto; margin-right: 55px;"><a class="navbar-brand" href="index.jsp?ID=<%=DbId %>">TRAVELMATE</a></div>
			<div style="display: inline; float: right; margin: 0;">
				<!-- 로그아웃 -->
				<a href="userLogin.jsp" onclick="signOut();">
					<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-unlock" viewBox="0 0 16 16">
						<path d="M11 1a2 2 0 0 0-2 2v4a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V9a2 2 0 0 1 2-2h5V3a3 3 0 0 1 6 0v4a.5.5 0 0 1-1 0V3a2 2 0 0 0-2-2zM3 8a1 1 0 0 0-1 1v5a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V9a1 1 0 0 0-1-1H3z"/>
					</svg>
				</a>
				<!-- 마이페이지 -->
				<form name="frmMyPage" action="myPage.jsp" method="post" style="display:inline;">
					<button type="submit" class="myPage">
					<svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-person" viewBox="0 0 16 16">
			  			<path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0zm4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/>
					</svg>
					</button>
					<input type="hidden" name="MembId" value="<%=DbId %>" />
				</form>
			</div>
		</nav>
	</header>
	<main style="position: absolute; top: 48px; width:100%">
		<form class="form-inline my-2-my-lg-0">
			<input class="form-control mr-sm-2" type="search" placeholder="내용을 입력하세요" aria-label="Search"  style="width:80%; height:40px; float:left;">
			<button class="btn btn-outline-success my-2 my-sm-0" type="submit" style="width:20%; height:40px; float:right; margin: 0px !important">검색</button>
		</form>
		<br><br><br><br>
		<h4> 여행 목록 </h4>  
	    <%     
	    sql = "SELECT TRIP_ID, TRIP_TITLE, TO_CHAR(TRIP_MEET_DATE, 'YYYY/MM/DD') TRIP_MEET_DATE,  TOT_NUM FROM TRIP_INFO  ORDER BY TRIP_MEET_DATE" ;
	    res = conn.prepareStatement(sql).executeQuery();
	    //System.out.print(rs.next());
		
	    while(res.next()) {            
	      String TRIP_TITLE = res.getString("TRIP_TITLE");
	      String TRIP_MEET_DATE = res.getString("TRIP_MEET_DATE");   
	      String TOT_NUM = res.getString("TOT_NUM");
	      String TRIP_ID = res.getString("TRIP_ID");
	      System.out.print(sql);
		%>
		<br>
		<form name="frmTripInfo" action="tripInfo.jsp" method="post" >
			<button type="submit" class="tripList">
				<br>제목 : <%=TRIP_TITLE%>
				<br>날짜 : <%=TRIP_MEET_DATE%>
				<br>인원 : <%=TOT_NUM%>
				<br><br>
			</button>
			<input type="hidden" name="MembId" value="<%=DbId %>" />
			<input type="hidden" name="TripTitle" value="<%=TRIP_TITLE %>" />
			<input type="hidden" name="TripId" value="<%=TRIP_ID %>" />
		</form>
	    <%
	    }
    	res.close();
 		conn.close();
		%>
		<script>
			function signOut() {
		      var auth2 = gapi.auth2.getAuthInstance();
		      auth2.signOut().then(function () {
		        console.log('User signed out.');
		      });
		    }

		    function onLoad() {
		      gapi.load('auth2', function() {
		        gapi.auth2.init();
		      });
		    }
		</script> 
	</main>
	<footer style="position: fixed; bottom: 10px; width: 100%;">
	<!-- 여행 개설 -->
		<div style="margin-left: 85%;">
		<br>
		<form name="frmSightList" action="sightList.jsp" method="post" >
			<button type="submit" class="addTrip">
				+
			</button>
			<input type="hidden" name="MembId" value="<%=DbId %>" />
		</form>
		</div>
	</footer>
	<script src="https://apis.google.com/js/platform.js?onload=onLoad" async defer></script>
</body>
</html>