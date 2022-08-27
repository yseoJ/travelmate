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
	String search = request.getParameter("search"); 

	sql = String.format( "select * from MEMB_INFO where MEMB_ID = '%s'", id);
	res = conn.prepareStatement(sql).executeQuery();
	//System.out.println(res.next());
	
	if(!res.next()){		//회원 정보가 없으면 저장
		String name = request.getParameter("NAME");
		String email = request.getParameter("EMAIL");
		String phone = request.getParameter("PHONE_NUM");
		String gender = request.getParameter("GENDER");
		String adyear = request.getParameter("ADDM_YEAR");

		sql = String.format( "Insert into MEMB_INFO (MEMB_ID,FULL_NM,EMAIL_ADDR,ADDM_YEAR,PHONE_NUM,GENDER,MEMB_STATUS) values ('%s','%s','%s','%s','%s','%s','가입') ", id, name, email, adyear, phone, gender); 
		conn.prepareStatement(sql).executeUpdate();
		
	}
	//회원 정보 있으면
	
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
	System.out.print(DbId); System.out.print(DbName); System.out.print(DbEmail); System.out.print(DbPhone); System.out.print(DbGender); System.out.print(DbAdyear); System.out.println(DbStatus);

	sql = "SELECT TRIP_ID FROM TRIP_INFO i "+
			"WHERE i.TRIP_STATUS = '진행중' "+
			"AND i.MEMB_ID = '" + DbId + "' "+
			"AND to_char(i.TRIP_MEET_DATE,'YYYY-MM-DD') <= to_char(SYSDATE, 'YYYY-MM-DD') "+
			"AND NOT EXISTS (SELECT * FROM TRIP_JOIN_LIST l "+
			"				WHERE l.TRIP_ID = i.TRIP_ID "+
			"				AND l.PRG_STATUS = '수락' "+
			"				AND l.MEMB_ID != '" + DbId + "') ";
	res = conn.prepareStatement(sql).executeQuery();
	while(res.next()){		//날짜가 지난 여행 중 수락한 참여자가 없으면 여행 취소 처리
		String updateTripId = res.getString("TRIP_ID");
		System.out.println(updateTripId);
		sql = "UPDATE TRIP_INFO "+
				"SET TRIP_STATUS = '취소' "+
				"WHERE TRIP_ID = " + updateTripId + " ";
		conn.prepareStatement(sql).executeUpdate();
	}
	
	sql = "SELECT COUNT(*) count FROM REPORT "+
			"WHERE GET_MEMB_ID = '" + DbId + "' "+
			"GROUP BY REPORT_ID ";
	res = conn.prepareStatement(sql).executeQuery();
	while(res.next()){
		String count = res.getString("count");
		System.out.println(count);
		int reportCount = Integer.parseInt(count);
		if(reportCount >= 3) {
			sql = "UPDATE MEMB_INFO SET MEMB_STATUS = '제명' "+
					"WHERE MEMB_ID = '" + DbId + "' ";
			conn.prepareStatement(sql).executeUpdate();
		}
	}

	sql = "SELECT MEMB_STATUS FROM MEMB_INFO "+
			"WHERE MEMB_ID = '" + DbId + "' ";
	res = conn.prepareStatement(sql).executeQuery();
	res.next();
	String memb_status = res.getString("MEMB_STATUS");
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
	<header style="position: fixed; top: 0; width: 100%; height:100px; z-index: 1">
		<nav class="navbar navbar-expand-lg navbar-light bg-light">
			<div style="margin: 0 auto; text-align: center;"><a class="navbar-brand" href="index.jsp?ID=<%=DbId %>" style="padding-left: 59.5px;">TRAVELMATE</a></div>
			<div style="display: inline; float: right; margin: 0;">
				<!-- 로그아웃 -->
				<a href="userLogin.jsp" onclick="signOut();">
					<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-unlock" viewBox="0 0 16 16">
						<path d="M11 1a2 2 0 0 0-2 2v4a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V9a2 2 0 0 1 2-2h5V3a3 3 0 0 1 6 0v4a.5.5 0 0 1-1 0V3a2 2 0 0 0-2-2zM3 8a1 1 0 0 0-1 1v5a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V9a1 1 0 0 0-1-1H3z"/>
					</svg>
				</a>
				<!-- 마이페이지 -->
				<form name="frmMyPage" action="myPage.jsp" method="get" style="display:inline;">
					<button type="submit" class="myPage">
					<svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-person" viewBox="0 0 16 16">
			  			<path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0zm4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/>
					</svg>
					</button>
					<input type="hidden" name="MembId" value="<%=DbId %>" />
				</form>
			</div>
		</nav>
		<form class="form-inline my-2-my-lg-0" action="index.jsp" method="get">
			<input class="form-control mr-sm-2" name="search" type="search" placeholder="내용을 입력하세요" aria-label="Search" <%if (search != null && search.trim() != "") { %> value="<%=search %>"<%} %> style="width:80%; height:40px; float:left;">
			<button class="btn btn-outline-primary my-2 my-sm-0" type="submit" style="width:20%; height:40px; float:right; margin: 0px !important">검색</button>
			<input type="hidden" name="ID" value="<%=DbId %>" />
		</form>
		<br>
	</header>
	<main style="position: absolute; top: 100px; width:95%; margin-left:10px; ">
		<h4> 여행 목록 </h4>  
	    <%     
	    sql = "SELECT x.TRIP_ID, x.TRIP_TITLE, x.TRIP_MEET_DATE, x.TOT_NUM, x.JOIN_NUM, "+
	          			"CASE WHEN join_num < tot_num THEN '모집중' "+
	          			"ELSE '마감' "+
	          			"END TRIP_CLOSE "+
				"FROM ( "+
	         			"SELECT m.TRIP_ID, m.TRIP_TITLE, TO_CHAR(m.TRIP_MEET_DATE, 'YYYY/MM/DD') TRIP_MEET_DATE,  m.TOT_NUM, m.SIGHTS_ID, "+
	                	"(SELECT COUNT(*) FROM TRIP_JOIN_LIST j WHERE j.TRIP_ID = m.TRIP_ID AND (PRG_STATUS = '수락' OR PRG_STATUS = '신청')) JOIN_NUM "+
	        			"FROM TRIP_INFO m "+
	        			"WHERE to_char(m.TRIP_MEET_DATE,'YYYY-MM-DD') > to_char(SYSDATE, 'YYYY-MM-DD') "+
	        			"AND m.TRIP_STATUS != '삭제' "+
	        			") x LEFT OUTER JOIN SIGHTS_INFO s ON x.SIGHTS_ID = s.SIGHTS_ID ";
	        	if (search != null && search.trim() != ""){
	        		search = search.trim();
		 			sql = sql + "WHERE x.TRIP_TITLE LIKE '%" + search + "%' "+
		        				"OR s.SIGHTS_NM LIKE '%" + search + "%' "+
					 			"OR s.SIGHTS_ADDR LIKE '%" + search + "%' "+
					 			"OR s.SIGHTS_CLAS LIKE '%" + search + "%' "+
					 			"OR s.SIGHTS_TRAFFIC LIKE '%" + search + "%' ";
	        	}
	    sql = sql + "ORDER BY TRIP_MEET_DATE ";
	    res = conn.prepareStatement(sql).executeQuery();
	    //System.out.print(rs.next());
		
	    while(res.next()) {            
	      String TRIP_TITLE = res.getString("TRIP_TITLE");
	      String TRIP_MEET_DATE = res.getString("TRIP_MEET_DATE");   
	      String TOT_NUM = res.getString("TOT_NUM");
	      String TRIP_ID = res.getString("TRIP_ID");
	      String TRIP_CLOSE = res.getString("TRIP_CLOSE");
	      String JOIN_NUM = res.getString("JOIN_NUM");
	      //System.out.println(sql);
		%>
		<br>
		<form name="frmTripInfo" action="tripInfo.jsp" method="get" >
			<button type="submit" class="tripList">
			<div style="float:left; width: 75%;">
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
				&nbsp;<%=JOIN_NUM %> / <%=TOT_NUM %>
				<br><br>
			</div>
			<div style="display:inline-block; float:right; text-align:center; border: 2px solid <%if ("모집중".equals(TRIP_CLOSE)){%>green<%} else{%>red<%} %>; margin: 5px; width: 20%;">
				<div style="color: <%if ("모집중".equals(TRIP_CLOSE)){%>green<%} else{%>red<%} %>; vertical-align: middle; margin: 5px;"><%=TRIP_CLOSE%></div>
			</div>
			</button>
			<input type="hidden" name="MembId" value="<%=DbId %>" />
			<input type="hidden" name="TripTitle" value="<%=TRIP_TITLE %>" />
			<input type="hidden" name="TripId" value="<%=TRIP_ID %>" />
			<input type="hidden" name="TripClose" value="<%=TRIP_CLOSE %>" />
			<input type="hidden" name="JoinNum" value="<%=JOIN_NUM %>" />
		</form>
	    <%
	    }
    	res.close();
 		conn.close();
		%>
		<script type="text/javascript">		
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
		<form name="frmSightList" action="sightList.jsp" method="get" >
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