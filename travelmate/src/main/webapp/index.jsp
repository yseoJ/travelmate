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
	String sql2 = "";
	
	
	Class.forName("oracle.jdbc.driver.OracleDriver");
	Connection conn = DriverManager.getConnection(url, user, pw);
	ResultSet res = null;
	ResultSet rs = null;
	ResultSet result = null;
	
	String id = request.getParameter("ID");
	String search = request.getParameter("search"); 

	sql = String.format( "select * from MEMB_INFO where MEMB_ID = '%s'", id);
	res = conn.prepareStatement(sql).executeQuery();
	//System.out.println(res.next());
	
	if(!res.next()){		//회원 정보가 없으면 저장
		String name = request.getParameter("NAME");
		String email = request.getParameter("EMAIL");
		String phone = request.getParameter("PHONE_NUM");
		String adyear = request.getParameter("ADDM_YEAR");

		sql = String.format( "Insert into MEMB_INFO (MEMB_ID,FULL_NM,EMAIL_ADDR,ADDM_YEAR,PHONE_NUM,MEMB_STATUS) values ('%s','%s','%s','%s','%s','가입') ", id, name, email, adyear, phone); 
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
	String DbAdyear = res.getString("ADDM_YEAR");
	String DbStatus = res.getString("MEMB_STATUS");
	System.out.print(DbId); System.out.print(DbName); System.out.print(DbEmail); System.out.print(DbPhone); System.out.print(DbAdyear); System.out.println(DbStatus);

	sql = "SELECT TRIP_ID FROM TRIP_INFO i "+
			"WHERE i.TRIP_STATUS = '진행중' "+
			"AND to_char(i.TRIP_MEET_DATE,'YYYY-MM-DD') <= to_char(SYSDATE, 'YYYY-MM-DD') "+
			"AND NOT EXISTS (SELECT * FROM TRIP_JOIN_LIST l "+
			"				WHERE l.TRIP_ID = i.TRIP_ID "+
			"				AND l.PRG_STATUS = '수락' "+
			"				AND l.MEMB_ID != i.MEMB_ID) ";
	res = conn.prepareStatement(sql).executeQuery();
	while(res.next()){		//날짜가 지난 여행 중 수락한 참여자가 없으면 여행 취소 처리
		String deleteTripId = res.getString("TRIP_ID");
		System.out.println(deleteTripId);
		sql = "UPDATE TRIP_INFO "+
				"SET TRIP_STATUS = '취소' "+
				"WHERE TRIP_ID = " + deleteTripId + " ";
		conn.prepareStatement(sql).executeUpdate();
	}
	
	sql = "SELECT TRIP_ID FROM TRIP_INFO i "+
			"WHERE i.TRIP_STATUS = '진행중' "+
			"AND to_char(i.TRIP_MEET_DATE,'YYYY-MM-DD') < to_char(SYSDATE, 'YYYY-MM-DD') "+
			"AND EXISTS (SELECT * FROM TRIP_JOIN_LIST l "+
			"				WHERE l.TRIP_ID = i.TRIP_ID "+
			"				AND l.PRG_STATUS = '수락' "+
			"				AND l.MEMB_ID != i.MEMB_ID) ";
	res = conn.prepareStatement(sql).executeQuery();
	while(res.next()){		//날짜가 지난 여행 중 수락한 참여자가 없으면 여행 취소 처리
		String updateTripId = res.getString("TRIP_ID");
		System.out.println(updateTripId);
		sql = "UPDATE TRIP_INFO "+
				"SET TRIP_STATUS = '완료' "+
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
			<div style="margin: 0 auto; text-align: center;"><a class="navbar-brand" href="index.jsp?ID=<%=DbId %>" style="padding-left: 50px;">TRAVELMATE</a></div>
			<div style="display: inline; float: right; margin: 0;">
				<!-- 로그아웃 -->
				<a href="userLogin.jsp" onclick="signOut();">
					<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-unlock" viewBox="0 0 16 16">
						<path d="M11 1a2 2 0 0 0-2 2v4a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V9a2 2 0 0 1 2-2h5V3a3 3 0 0 1 6 0v4a.5.5 0 0 1-1 0V3a2 2 0 0 0-2-2zM3 8a1 1 0 0 0-1 1v5a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V9a1 1 0 0 0-1-1H3z"/>
					</svg>
				</a>
				
			</div>
		</nav>
		<form class="form-inline my-2-my-lg-0" action="search.jsp" method="get">
			<input class="form-control mr-sm-2" name="search" type="search" placeholder="내용을 입력하세요" aria-label="Search" <%if (search != null && search.trim() != "") { %> value="<%=search %>"<%} %> style="width:80%; height:40px; float:left;">
			<button class="btn btn-outline-primary my-2 my-sm-0" type="submit" style="width:20%; height:40px; float:right; margin: 0px !important;" <%if(memb_status.equals("제명")){%>disabled='disabled'<%}%>>검색</button>
			<input type="hidden" name="ID" value="<%=DbId %>" />
		</form>
		<br>
	</header>
	<main style="position: absolute; top: 100px; width:95%; margin-left:10px; ">
		<%if(memb_status.equals("제명")){%>
			<div style=" margin: 0 auto; background-color: red; border-radius: 10px; text-align: center;"><br>
				<div style="color: black; font-size: 17px; font-weight: bold; line-height: 120%;">
					동일 항목에 대한 신고 횟수 3번 누적으로<br>서비스 사용이 불가능합니다.
				</div><br>
			</div><br><br>
		<%}%>
		<!-- 미완료 수락/거절 -->
		<%
		sql = "SELECT i.TRIP_ID, i.TRIP_TITLE, TO_CHAR(i.TRIP_MEET_DATE, 'YYYY-MM-DD') TRIP_MEET_DATE, j.MEMB_ID "+
				"FROM (SELECT * "+
						"FROM TRIP_INFO "+
						"WHERE MEMB_ID = '" + DbId + "') i LEFT OUTER JOIN TRIP_JOIN_LIST j "+
						"ON i.TRIP_ID = j.TRIP_ID "+
						"WHERE j.PRG_STATUS = '신청' "+
						"AND TO_CHAR(i.TRIP_MEET_DATE,'YYYYMMDD') > TO_CHAR(SYSDATE, 'YYYYMMDD') ";
		res = conn.prepareStatement(sql).executeQuery();
		int acceptReject = 0;
		
		if(res.next()){
			acceptReject=1;
		%>
			<div style="border: 3px solid red; border-radius: 10px; width: 90%; margin: 0 auto;"><br>
				<div style="text-align: center; background-color: red; color: white; font-size: 15px; font-weight: bold;">
					<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="white" class="bi bi-bell-fill" viewBox="0 0 16 16">
						<path d="M8 16a2 2 0 0 0 2-2H6a2 2 0 0 0 2 2zm.995-14.901a1 1 0 1 0-1.99 0A5.002 5.002 0 0 0 3 6c0 1.098-.5 6-2 7h14c-1.5-1-2-5.902-2-7 0-2.42-1.72-4.44-4.005-4.901z"/>
					</svg>
					알림
					<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="white" class="bi bi-bell-fill" viewBox="0 0 16 16">
						<path d="M8 16a2 2 0 0 0 2-2H6a2 2 0 0 0 2 2zm.995-14.901a1 1 0 1 0-1.99 0A5.002 5.002 0 0 0 3 6c0 1.098-.5 6-2 7h14c-1.5-1-2-5.902-2-7 0-2.42-1.72-4.44-4.005-4.901z"/>
					</svg>
				</div><br>
				<div style="color: red; font-size: 15px; font-weight: bold; line-height: 120%; text-align: center;">
					수락/거절을 하지 않은 참여자가 있습니다.<br>
					해당 참여자에 대해 수락 또는 거절을 해주세요.
				</div>
			<%}
		%>
		<!-- 미완료 참여자평가 -->
		<%
		sql = "SELECT TRIP_ID, MEMB_ID, PRG_STATUS "+
				"FROM TRIP_JOIN_LIST j "+
				"WHERE TRIP_ID IN (SELECT TRIP_ID "+
				                "FROM TRIP_JOIN_LIST "+
				                "WHERE MEMB_ID = '" + DbId +"' "+
				                "AND PRG_STATUS = '수락') "+
				"AND MEMB_ID != '" + DbId + "' "+
				"AND PRG_STATUS = '수락' "+
				"AND (SELECT TO_CHAR(TRIP_MEET_DATE,'YYYYMMDD') TRIP_MEET_DATE "+
				    "FROM TRIP_INFO i "+
				    "WHERE i.TRIP_ID = j.TRIP_ID)<TO_CHAR(SYSDATE,'YYYYMMDD') ";
		res = conn.prepareStatement(sql).executeQuery();
		
		int evalcnt = 0;
		
		if(res.next()){
			do{
			String trip_id = res.getString("TRIP_ID");
			String participant_id = res.getString("MEMB_ID");
				
			sql = "SELECT * FROM MEMB_SCORE "+
					"WHERE TRIP_ID = " + trip_id + " "+
					"AND GIVE_MEMB_ID = '" + DbId + "' "+
					"AND GET_MEMB_ID = '" + participant_id + "' ";
			rs = conn.prepareStatement(sql).executeQuery();
			
			
			if(!rs.next()){
				evalcnt = evalcnt + 1;
			}
			}while(res.next());
		}
		if(evalcnt > 0){
			if(acceptReject != 1){%>
			<div style="border: 3px solid red; border-radius: 10px; width: 90%; margin: 0 auto;"><br>
			<div style="text-align: center; background-color: red; color: white; font-size: 15px; font-weight: bold;">
				<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="white" class="bi bi-bell-fill" viewBox="0 0 16 16">
					<path d="M8 16a2 2 0 0 0 2-2H6a2 2 0 0 0 2 2zm.995-14.901a1 1 0 1 0-1.99 0A5.002 5.002 0 0 0 3 6c0 1.098-.5 6-2 7h14c-1.5-1-2-5.902-2-7 0-2.42-1.72-4.44-4.005-4.901z"/>
				</svg>
				알림
				<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="white" class="bi bi-bell-fill" viewBox="0 0 16 16">
					<path d="M8 16a2 2 0 0 0 2-2H6a2 2 0 0 0 2 2zm.995-14.901a1 1 0 1 0-1.99 0A5.002 5.002 0 0 0 3 6c0 1.098-.5 6-2 7h14c-1.5-1-2-5.902-2-7 0-2.42-1.72-4.44-4.005-4.901z"/>
				</svg>
			</div><br>
			<%}else{ %>
				<hr style="color: red; height: 4px;">
			<%} %>
				<div style="color: red; font-size: 15px; font-weight: bold; line-height: 120%; text-align: center;">
					평가를 하지 않은 참여자가 있습니다.<br>
					해당 참여자에 대해 평가를 해주세요.
				</div>
		<%}
		if(acceptReject == 1 || evalcnt > 0){%>
			<br></div>
			<br><hr style="background-color: rgba(13, 45, 132);">
		<%}
		%>
		<br>
		<!-- 추천 여행 -->
		<div class="myPageText">추천여행</div><br>
		<div class="wrap-vertical" style="padding: 0; border: none;">
			<%     
			sql = "SELECT SIGHTS_ID, COUNT(TAG_ID) cnt "+
					"FROM SIGHTS_TAG_LIST "+
					"WHERE TAG_ID IN (SELECT TAG_ID "+
					                "FROM MEMB_HOPE_LIST "+
					                "WHERE MEMB_ID = '" + DbId +"') "+
					"GROUP BY SIGHTS_ID "+
					"ORDER BY COUNT(TAG_ID) DESC ";
			res = conn.prepareStatement(sql).executeQuery();
			if(res.next()){
				do{
					String cnt = res.getString("cnt");
					String recom_sights_id = res.getString("SIGHTS_ID");
					sql = "SELECT x.TRIP_ID, x.TRIP_TITLE, x.TRIP_MEET_DATE, x.TOT_NUM, x.JOIN_NUM "+
				    		"FROM (SELECT m.TRIP_ID, m.TRIP_TITLE, TO_CHAR(m.TRIP_MEET_DATE, 'YYYY/MM/DD') TRIP_MEET_DATE, "+
				    				  "m.TOT_NUM, m.SIGHTS_ID, (SELECT COUNT(*) "+
				    			                              "FROM TRIP_JOIN_LIST j "+
				    			                              "WHERE j.TRIP_ID = m.TRIP_ID "+
				    			                              "AND (PRG_STATUS = '수락' OR PRG_STATUS = '신청')) JOIN_NUM "+
				    				  "FROM TRIP_INFO m "+
				    				  "WHERE to_char(m.TRIP_MEET_DATE,'YYYY-MM-DD') > to_char(SYSDATE, 'YYYY-MM-DD') "+
				    				  "AND m.TRIP_STATUS != '삭제' "+
				    			      "AND m.SIGHTS_ID = '" + recom_sights_id + "' "+
				    			      "AND '" + DbId + "' NOT IN (SELECT MEMB_ID FROM TRIP_JOIN_LIST WHERE TRIP_ID = m.TRIP_ID) "+
				    				  ") x LEFT OUTER JOIN SIGHTS_INFO s "+
				    			"ON x.SIGHTS_ID = s.SIGHTS_ID "+
				    			"WHERE x.JOIN_NUM < x.TOT_NUM ";
	
				    rs = conn.prepareStatement(sql).executeQuery();
					
				    if(rs.next()) {            
				      String recom_title = rs.getString("TRIP_TITLE");
				      String recom_meet_date = rs.getString("TRIP_MEET_DATE");   
				      String recom_tot_num = rs.getString("TOT_NUM");
				      String recom_trip_id = rs.getString("TRIP_ID");
				      String recom_join_num = rs.getString("JOIN_NUM");
				      //System.out.println(sql);
					
					%>
					<div class="box" style="display: inline-block; padding: 0; border: none;">
						<form name="frmTripInfo" action="tripInfo.jsp" method="get" style="float:left; margin:5px;">
							<button class="trip_list_button" type="submit"<%if(memb_status.equals("제명")){%>disabled='disabled'<%}%>>
								<div style="width: 100%; height: 100px; overflow: hidden; margin: 0 auto; border-radius: 20px">
									<img style="width: 100%; height: 100%; object-fit: cover;" src="image/<%=recom_sights_id %>.jpg" onerror="this.src='image/0.png'";>
								</div>
								<br><div class="trip_list_title"><%=recom_title%></div>
								<div style="line-height: 80%;"><br></div>
								<div style="display: flex;">
									<div style="display: inline-block; flex: 2;">
										<!-- 여행 날짜 -->
										<svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" fill="black" class="bi bi-calendar-event" viewBox="0 0 16 16">
										  <path d="M11 6.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1z"/>
										  <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5zM1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4H1z"/>
										</svg>
										<div style="font-size: 12px; display: inline-block; color: black;">&nbsp;<%=recom_meet_date%></div>
									</div>
									<div style="display: inline-block; flex: 1;">
										<svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" fill="black" class="bi bi-person-plus" viewBox="0 0 16 16">
										  <path d="M6 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0zm4 8c0 1-1 1-1 1H1s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C9.516 10.68 8.289 10 6 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/>
										  <path fill-rule="evenodd" d="M13.5 5a.5.5 0 0 1 .5.5V7h1.5a.5.5 0 0 1 0 1H14v1.5a.5.5 0 0 1-1 0V8h-1.5a.5.5 0 0 1 0-1H13V5.5a.5.5 0 0 1 .5-.5z"/>
										</svg>
										<div style="font-size: 12px; display: inline-block; color: black;">&nbsp;<%=recom_join_num %> / <%=recom_tot_num %></div>
									</div>
								</div>
								<div style="line-height: 80%;"><br></div>
								<% 
								sql2 = "SELECT t.TAG_NM tagnm "+
										"FROM TAG_LIST t LEFT OUTER JOIN SIGHTS_TAG_LIST s "+
										"ON t.TAG_ID = s.TAG_ID "+
										"WHERE SIGHTS_ID = '" + recom_sights_id + "' "+
										"AND t.TAG_ID IN (SELECT TAG_ID "+
															"FROM MEMB_HOPE_LIST "+
															"WHERE MEMB_ID = '" + DbId + "') ";
								result = conn.prepareStatement(sql2).executeQuery();
								
							    while(result.next()) {            
							      String recom_tagnm = result.getString("tagnm");
								%>
								<div style="display: inline-block; border-radius: 18px; text-align:center; font-size: 12px; padding: 0px 5px 0px 5px; background-color: rgba(13, 45, 132); color: white;">
								#<%=recom_tagnm%>
								</div>
								<%} %>
							</button>
							<input type="hidden" name="MembId" value="<%=DbId %>" />
							<input type="hidden" name="TripTitle" value="<%=recom_title %>" />
							<input type="hidden" name="TripId" value="<%=recom_trip_id %>" />
							<input type="hidden" name="JoinNum" value="<%=recom_join_num %>" />
						</form>
					</div>
			
		    		<%
					}
				}while(res.next());
			} else{
					%>
					<div style="margin: auto; text-align: center;">
						<form name="frmSightList" action="myInterest.jsp" method="get" >
							<button class="changeCharacter" type="submit"<%if(memb_status.equals("제명")){%>disabled='disabled'<%}%>>관심사 설정하러 가기</button>
							<input type="hidden" name="membId" id="membId" value="<%=DbId %>" />
						</form>
					</div>
			<% }
			%>
		</div><br>
		<!-- 여행 임박 -->
		<hr style="background-color: rgba(13, 45, 132);"><br>
		<div class="myPageText">여행임박</div><br>
		<div class="wrap-vertical" style="padding: 0; border: none;">
			<%     
				sql = "SELECT m.TRIP_ID, m.TRIP_TITLE, TO_CHAR(m.TRIP_MEET_DATE, 'YYYY/MM/DD') TRIP_MEET_DATE, "+
										     "m.TOT_NUM, m.SIGHTS_ID, (SELECT COUNT(*) "+
																		"FROM TRIP_JOIN_LIST j "+
																		"WHERE j.TRIP_ID = m.TRIP_ID "+
																		"AND (PRG_STATUS = '수락' OR PRG_STATUS = '신청')) JOIN_NUM "+
						"FROM TRIP_INFO m "+
						"WHERE TO_CHAR(m.TRIP_MEET_DATE,'YYYYMMDD') > TO_CHAR(SYSDATE, 'YYYYMMDD') "+
						"AND TO_NUMBER(TO_CHAR(TRIP_MEET_DATE, 'YYYYMMDD')) - TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMMDD')) <= 10 "+
						"AND m.TRIP_STATUS != '삭제' ";
	
			    rs = conn.prepareStatement(sql).executeQuery();
				
			    if(rs.next()) {
			    	do{            
				      String close_title = rs.getString("TRIP_TITLE");
				      String close_meet_date = rs.getString("TRIP_MEET_DATE");   
				      String close_tot_num = rs.getString("TOT_NUM");
				      String close_trip_id = rs.getString("TRIP_ID");
				      String close_sights_id = rs.getString("SIGHTS_ID");
				      String close_join_num = rs.getString("JOIN_NUM");
				      //System.out.println(sql);
					
					%>
					<div class="box" style="display: inline-block; padding: 0; border: none;">
						<form name="frmTripInfo" action="tripInfo.jsp" method="get" style="float:left; margin:5px;">
							<button class="trip_list_button" type="submit"<%if(memb_status.equals("제명")){%>disabled='disabled'<%}%>>
								<div style="width: 100%; height: 100px; overflow: hidden; margin: 0 auto; border-radius: 20px">
									<img style="width: 100%; height: 100%; object-fit: cover;" src="image/<%=close_sights_id %>.jpg" onerror="this.src='image/0.png'";>
								</div>
								<br><div class="trip_list_title"><%=close_title%></div>
								<div style="line-height: 80%;"><br></div>
								<div style="display: flex;">
									<div style="display: inline-block; flex: 2;">
										<!-- 여행 날짜 -->
										<svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" fill="black" class="bi bi-calendar-event" viewBox="0 0 16 16">
										  <path d="M11 6.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1z"/>
										  <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5zM1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4H1z"/>
										</svg>
										<div style="font-size: 12px; display: inline-block; color: black;">&nbsp;<%=close_meet_date%></div>
									</div>
									<div style="display: inline-block; flex: 1;">
										<svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" fill="black" class="bi bi-person-plus" viewBox="0 0 16 16">
										  <path d="M6 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0zm4 8c0 1-1 1-1 1H1s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C9.516 10.68 8.289 10 6 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/>
										  <path fill-rule="evenodd" d="M13.5 5a.5.5 0 0 1 .5.5V7h1.5a.5.5 0 0 1 0 1H14v1.5a.5.5 0 0 1-1 0V8h-1.5a.5.5 0 0 1 0-1H13V5.5a.5.5 0 0 1 .5-.5z"/>
										</svg>
										<div style="font-size: 12px; display: inline-block; color: black;">&nbsp;<%=close_join_num %> / <%=close_tot_num %></div>
									</div>
								</div>
								<div style="line-height: 80%;"><br></div>
								<%
								sql2 = "SELECT t.TAG_NM tagnm "+
										"FROM TAG_LIST t LEFT OUTER JOIN SIGHTS_TAG_LIST s "+
										"ON t.TAG_ID = s.TAG_ID "+
										"WHERE SIGHTS_ID = '" + close_sights_id + "' ";
								result = conn.prepareStatement(sql2).executeQuery();
								
							    while(result.next()) {            
							      String close_tagnm = result.getString("tagnm");
								%>
								<div style="display: inline-block; border-radius: 18px; text-align:center; font-size: 12px; padding: 0px 5px 0px 5px; background-color: rgba(13, 45, 132); color: white;">
									#<%=close_tagnm%>
								</div>
								<%} %>
							</button>
							<input type="hidden" name="MembId" value="<%=DbId %>" />
							<input type="hidden" name="TripTitle" value="<%=close_title %>" />
							<input type="hidden" name="TripId" value="<%=close_trip_id %>" />
							<input type="hidden" name="JoinNum" value="<%=close_join_num %>" />
						</form>
					</div>
					<%}while(rs.next());
			    }%>
		</div><br>
		<!-- 마감 임박 -->
		<hr style="background-color: rgba(13, 45, 132);"><br>
		<div class="myPageText">마감임박</div><br>
		<div class="wrap-vertical" style="padding: 0; border: none;">
			<%     
				sql = "SELECT TRIP_ID, SIGHTS_ID, TRIP_TITLE, TRIP_MEET_DATE, TOT_NUM, JOIN_NUM "+
						"FROM (SELECT m.TRIP_ID, m.TRIP_TITLE, TO_CHAR(m.TRIP_MEET_DATE, 'YYYY/MM/DD') TRIP_MEET_DATE, "+
					            "m.TOT_NUM, m.SIGHTS_ID, (SELECT COUNT(*) "+
					                                       "FROM TRIP_JOIN_LIST j "+
					                                       "WHERE j.TRIP_ID = m.TRIP_ID "+
					                                       "AND (PRG_STATUS = '수락' OR PRG_STATUS = '신청')) JOIN_NUM "+
					        	"FROM TRIP_INFO m "+
					        	"WHERE TO_CHAR(m.TRIP_MEET_DATE,'YYYYMMDD') > TO_CHAR(SYSDATE, 'YYYYMMDD') "+
					        	"AND m.TRIP_STATUS != '삭제') "+
						"WHERE TOT_NUM - JOIN_NUM = 1 ";
	
			    rs = conn.prepareStatement(sql).executeQuery();
				
			    if(rs.next()) {
			    	do{            
				      String pop_title = rs.getString("TRIP_TITLE");
				      String pop_meet_date = rs.getString("TRIP_MEET_DATE");   
				      String pop_tot_num = rs.getString("TOT_NUM");
				      String pop_trip_id = rs.getString("TRIP_ID");
				      String pop_sights_id = rs.getString("SIGHTS_ID");
				      String pop_join_num = rs.getString("JOIN_NUM");
				      //System.out.println(sql);
					
					%>
					<div class="box" style="display: inline-block; padding: 0; border: none;">
						<form name="frmTripInfo" action="tripInfo.jsp" method="get" style="float:left; margin:5px;">
							<button class="trip_list_button" type="submit"<%if(memb_status.equals("제명")){%>disabled='disabled'<%}%>>
								<div style="width: 100%; height: 100px; overflow: hidden; margin: 0 auto; border-radius: 20px">
									<img style="width: 100%; height: 100%; object-fit: cover;" src="image/<%=pop_sights_id %>.jpg" onerror="this.src='image/0.png'";>
								</div>
								<br><div class="trip_list_title"><%=pop_title%></div>
								<div style="line-height: 80%;"><br></div>
								<div style="display: flex;">
									<div style="display: inline-block; flex: 2;">
										<!-- 여행 날짜 -->
										<svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" fill="black" class="bi bi-calendar-event" viewBox="0 0 16 16">
										  <path d="M11 6.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1z"/>
										  <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5zM1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4H1z"/>
										</svg>
										<div style="font-size: 12px; display: inline-block;color: black;">&nbsp;<%=pop_meet_date%></div>
									</div>
									<div style="display: inline-block; flex: 1;">
										<svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" fill="black" class="bi bi-person-plus" viewBox="0 0 16 16">
										  <path d="M6 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0zm4 8c0 1-1 1-1 1H1s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C9.516 10.68 8.289 10 6 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/>
										  <path fill-rule="evenodd" d="M13.5 5a.5.5 0 0 1 .5.5V7h1.5a.5.5 0 0 1 0 1H14v1.5a.5.5 0 0 1-1 0V8h-1.5a.5.5 0 0 1 0-1H13V5.5a.5.5 0 0 1 .5-.5z"/>
										</svg>
										<div style="font-size: 12px; display: inline-block;color: black;">&nbsp;<%=pop_join_num %> / <%=pop_tot_num %></div>
									</div>
								</div>
								<div style="line-height: 80%;"><br></div>
								<% 
								sql2 = "SELECT t.TAG_NM tagnm "+
										"FROM TAG_LIST t LEFT OUTER JOIN SIGHTS_TAG_LIST s "+
										"ON t.TAG_ID = s.TAG_ID "+
										"WHERE SIGHTS_ID = '" + pop_sights_id + "' ";
								result = conn.prepareStatement(sql2).executeQuery();
								
							    while(result.next()) {            
							      String pop_tagnm = result.getString("tagnm");
								%>
								<div style="display: inline-block; border-radius: 18px; text-align:center; font-size: 12px; padding: 0px 5px 0px 5px; background-color: rgba(13, 45, 132); color: white;">
								#<%=pop_tagnm%>
								</div>
								<%} %>
							</button>
							<input type="hidden" name="MembId" value="<%=DbId %>" />
							<input type="hidden" name="TripTitle" value="<%=pop_title %>" />
							<input type="hidden" name="TripId" value="<%=pop_trip_id %>" />
							<input type="hidden" name="JoinNum" value="<%=pop_join_num %>" />
						</form>
					</div>
					<%}while(rs.next());
			    }%>
		</div><br>
		<!-- 새싹주최자 -->
		<hr style="background-color: rgba(13, 45, 132);"><br>
		<div class="myPageText">새싹주최자</div><br>
		<div class="wrap-vertical" style="padding: 0; border: none;">
			<%     
				sql = "SELECT MEMB_ID, SIGHTS_ID, TRIP_ID, TRIP_TITLE, TRIP_MEET_DATE, TOT_NUM, JOIN_NUM "+
						"FROM (SELECT m.MEMB_ID, m.TRIP_ID, m.TRIP_TITLE, TO_CHAR(m.TRIP_MEET_DATE, 'YYYY/MM/DD') TRIP_MEET_DATE, "+
					              "m.TOT_NUM, m.SIGHTS_ID, (SELECT COUNT(*) "+
					                                       "FROM TRIP_JOIN_LIST j "+
					                                       "WHERE j.TRIP_ID = m.TRIP_ID "+
					                                       "AND (PRG_STATUS = '수락' OR PRG_STATUS = '신청')) JOIN_NUM "+
					        "FROM TRIP_INFO m "+
					        "WHERE TO_CHAR(m.TRIP_MEET_DATE,'YYYYMMDD') > TO_CHAR(SYSDATE, 'YYYYMMDD') "+
					        "AND m.TRIP_STATUS != '삭제') "+
					"WHERE MEMB_ID IN (SELECT MEMB_ID "+
					                    "FROM (SELECT MEMB_ID, COUNT(*) cnt "+
					                            "FROM TRIP_INFO "+
					                            "GROUP BY MEMB_ID) "+
					                    "WHERE cnt = 1) ";
	
			    rs = conn.prepareStatement(sql).executeQuery();
				
			    if(rs.next()) {
			    	do{            
				      String new_title = rs.getString("TRIP_TITLE");
				      String new_meet_date = rs.getString("TRIP_MEET_DATE");   
				      String new_tot_num = rs.getString("TOT_NUM");
				      String new_trip_id = rs.getString("TRIP_ID");
				      String new_sights_id = rs.getString("SIGHTS_ID");
				      String new_join_num = rs.getString("JOIN_NUM");
				      //System.out.println(sql);
					
					%>
					<div class="box" style="display: inline-block; padding: 0; border: none;">
						<form name="frmTripInfo" action="tripInfo.jsp" method="get" style="float:left; margin:5px;">
							<button class="trip_list_button" type="submit"<%if(memb_status.equals("제명")){%>disabled='disabled'<%}%>>
								<div style="width: 100%; height: 100px; overflow: hidden; margin: 0 auto; border-radius: 20px">
									<img style="width: 100%; height: 100%; object-fit: cover;" src="image/<%=new_sights_id %>.jpg" onerror="this.src='image/0.png'";>
								</div>
								<br><div class="trip_list_title"><%=new_title%></div>
								<div style="line-height: 80%;"><br></div>
								<div style="display: flex;">
									<div style="display: inline-block; flex: 2;">
										<!-- 여행 날짜 -->
										<svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" fill="black" class="bi bi-calendar-event" viewBox="0 0 16 16">
										  <path d="M11 6.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1z"/>
										  <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5zM1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4H1z"/>
										</svg>
										<div style="font-size: 12px; display: inline-block;color: black;">&nbsp;<%=new_meet_date%></div>
									</div>
									<div style="display: inline-block; flex: 1;">
										<svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" fill="black" class="bi bi-person-plus" viewBox="0 0 16 16">
										  <path d="M6 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0zm4 8c0 1-1 1-1 1H1s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C9.516 10.68 8.289 10 6 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/>
										  <path fill-rule="evenodd" d="M13.5 5a.5.5 0 0 1 .5.5V7h1.5a.5.5 0 0 1 0 1H14v1.5a.5.5 0 0 1-1 0V8h-1.5a.5.5 0 0 1 0-1H13V5.5a.5.5 0 0 1 .5-.5z"/>
										</svg>
										<div style="font-size: 12px; display: inline-block;color: black;">&nbsp;<%=new_join_num %> / <%=new_tot_num %></div>
									</div>
								</div>
								<div style="line-height: 80%;"><br></div>
								<% 
								sql2 = "SELECT t.TAG_NM tagnm "+
										"FROM TAG_LIST t LEFT OUTER JOIN SIGHTS_TAG_LIST s "+
										"ON t.TAG_ID = s.TAG_ID "+
										"WHERE SIGHTS_ID = '" + new_sights_id + "' ";
								result = conn.prepareStatement(sql2).executeQuery();
								
							    while(result.next()) {            
							      String pop_tagnm = result.getString("tagnm");
								%>
								<div style="display: inline-block; border-radius: 18px; text-align:center; font-size: 12px; padding: 0px 5px 0px 5px; background-color: rgba(13, 45, 132); color: white;">
								#<%=pop_tagnm%>
								</div>
								<%} %>
							</button>
							<input type="hidden" name="MembId" value="<%=DbId %>" />
							<input type="hidden" name="TripTitle" value="<%=new_title %>" />
							<input type="hidden" name="TripId" value="<%=new_trip_id %>" />
							<input type="hidden" name="JoinNum" value="<%=new_join_num %>" />
						</form>
					</div>
					<%}while(rs.next());
			    }%>
		</div><br>
		<!-- 매너Top10 주최자 -->
		<hr style="background-color: rgba(13, 45, 132);"><br>
		<div class="myPageText">매너TOP10 주최자</div><br>
		<div class="wrap-vertical" style="padding: 0; border: none;">
			<%     
			sql = "SELECT top_id, top "+
					"FROM (SELECT NVL(p.GET_MEMB_ID, n.GET_MEMB_ID) top_id, NVL(positive, 0)-NVL(negative, 0) top "+
					        "FROM (SELECT GET_MEMB_ID, NVL(COUNT(*), 0) negative "+
					        "FROM MEMB_EVALUATION "+
					        "WHERE 101<=EVAL_ID "+
					        "AND EVAL_ID<=105 "+
					        "GROUP BY GET_MEMB_ID) p FULL OUTER JOIN (SELECT GET_MEMB_ID, COUNT(*) positive "+
					                                                "FROM MEMB_EVALUATION "+
					                                                "WHERE 1<=EVAL_ID "+
					                                                "AND EVAL_ID<=10 "+
					                                                "GROUP BY GET_MEMB_ID) n "+
					        "ON p.GET_MEMB_ID = n.GET_MEMB_ID "+
					        "ORDER BY top DESC) "+
					"WHERE ROWNUM <= 10 ";
			res = conn.prepareStatement(sql).executeQuery();
			if(res.next()){
				do{
					String top_id = res.getString("top_id");
					sql = "SELECT m.TRIP_ID, m.TRIP_TITLE, TO_CHAR(m.TRIP_MEET_DATE, 'YYYY/MM/DD') TRIP_MEET_DATE, "+
								"m.TOT_NUM, m.SIGHTS_ID, (SELECT COUNT(*) "+
															"FROM TRIP_JOIN_LIST j "+
															"WHERE j.TRIP_ID = m.TRIP_ID "+
															"AND (PRG_STATUS = '수락' OR PRG_STATUS = '신청')) JOIN_NUM "+
							"FROM TRIP_INFO m "+
							"WHERE TO_CHAR(m.TRIP_MEET_DATE,'YYYYMMDD') > TO_CHAR(SYSDATE, 'YYYYMMDD') "+
							"AND MEMB_ID = '" + top_id + "' "+
							"AND m.TRIP_STATUS != '삭제' ";
	
				    rs = conn.prepareStatement(sql).executeQuery();
					
				    if(rs.next()) {
				    	do{
					      String top_title = rs.getString("TRIP_TITLE");
					      String top_meet_date = rs.getString("TRIP_MEET_DATE");   
					      String top_tot_num = rs.getString("TOT_NUM");
					      String top_trip_id = rs.getString("TRIP_ID");
					      String top_join_num = rs.getString("JOIN_NUM");
					      String top_sights_id = rs.getString("SIGHTS_ID");
					      //System.out.println(sql);
						
						%>
						<div class="box" style="display: inline-block; padding: 0; border: none;">
							<form name="frmTripInfo" action="tripInfo.jsp" method="get" style="float:left; margin:5px;">
								<button class="trip_list_button" type="submit"<%if(memb_status.equals("제명")){%>disabled='disabled'<%}%>>
									<div style="width: 100%; height: 100px; overflow: hidden; margin: 0 auto; border-radius: 20px">
										<img style="width: 100%; height: 100%; object-fit: cover;" src="image/<%=top_sights_id %>.jpg" onerror="this.src='image/0.png'";>
									</div>
									<br><div class="trip_list_title"><%=top_title%></div>
									<div style="line-height: 80%;"><br></div>
									<div style="display: flex;">
										<div style="display: inline-block; flex: 2;">
											<!-- 여행 날짜 -->
											<svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" fill="black" class="bi bi-calendar-event" viewBox="0 0 16 16">
											  <path d="M11 6.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1z"/>
											  <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5zM1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4H1z"/>
											</svg>
											<div style="font-size: 12px; display: inline-block;color: black;">&nbsp;<%=top_meet_date%></div>
										</div>
										<div style="display: inline-block; flex: 1;">
											<svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" fill="black" class="bi bi-person-plus" viewBox="0 0 16 16">
											  <path d="M6 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0zm4 8c0 1-1 1-1 1H1s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C9.516 10.68 8.289 10 6 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/>
											  <path fill-rule="evenodd" d="M13.5 5a.5.5 0 0 1 .5.5V7h1.5a.5.5 0 0 1 0 1H14v1.5a.5.5 0 0 1-1 0V8h-1.5a.5.5 0 0 1 0-1H13V5.5a.5.5 0 0 1 .5-.5z"/>
											</svg>
											<div style="font-size: 12px; display: inline-block;color: black;">&nbsp;<%=top_join_num %> / <%=top_tot_num %></div>
										</div>
									</div>
									<div style="line-height: 80%;"><br></div>
									<% 
									sql2 = "SELECT t.TAG_NM tagnm "+
											"FROM TAG_LIST t LEFT OUTER JOIN SIGHTS_TAG_LIST s "+
											"ON t.TAG_ID = s.TAG_ID "+
											"WHERE SIGHTS_ID = '" + top_sights_id + "' ";
									result = conn.prepareStatement(sql2).executeQuery();
									
								    while(result.next()) {            
								      String top_tagnm = result.getString("tagnm");
									%>
									<div style="display: inline-block; border-radius: 18px; text-align:center; font-size: 12px; padding: 0px 5px 0px 5px; background-color: rgba(13, 45, 132); color: white;">
									#<%=top_tagnm%>
									</div>
									<%} %>
								</button>
								<input type="hidden" name="MembId" value="<%=DbId %>" />
								<input type="hidden" name="TripTitle" value="<%=top_title %>" />
								<input type="hidden" name="TripId" value="<%=top_trip_id %>" />
								<input type="hidden" name="JoinNum" value="<%=top_join_num %>" />
							</form>
						</div>
				    	<%
						}while(rs.next());
				    }
				}while(res.next());
			}
						%>
		</div><br><br><br><br><br>
		
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
	<footer style="position: fixed; bottom: 0px; width: 100%;">
	<div style="width: 100%; background-color: #f8f9fa; height: 50px; display: flex;">
		<!-- 진행/완료 여행 -->
		<div class="dropup">
		  <button class="dropbtn"<%if(memb_status.equals("제명")){%>disabled='disabled'<%}%>>
		  	<svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-list" viewBox="0 0 16 16">
				<path fill-rule="evenodd" d="M2.5 12a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5zm0-4a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5zm0-4a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5z"/>
			</svg>
		  </button>
		  <div id="myDropup" class="dropup-content">
		    <form name="frmMyTrip" action="allAcceptReject.jsp" method="get" >
				<button style="background-color:transparent; border: none;" type="submit" <%if(memb_status.equals("제명")){%>disabled='disabled'<%}%>>
					<a style="color: black; font-color: black; font-size: 12px;">참여자 수락/거절</a>
				</button>
				<input type="hidden" name="membId" value="<%=DbId %>" />
			</form>
		    <form name="frmMyTripPast" action="allEval.jsp" method="get" >
				<button style="background-color:transparent; border: none;" type="submit" <%if(memb_status.equals("제명")){%>disabled='disabled'<%}%>>
					<a style="color: black; font-color: black; font-size: 12px;">참여자 평가</a>
				</button>
				<input type="hidden" name="membId" value="<%=DbId %>" />
			</form>
		  </div>
		</div>
		<!-- 여행 개설 -->
		<div style="display: inline-block; margin: auto; flex: 1; text-align: center;">
			<form name="frmSightList" action="sightList.jsp" method="get" >
				<button type="submit" class="addTrip" style="color: black;" <%if(memb_status.equals("제명")){%>disabled='disabled'<%}%>>
					<svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-plus-lg" viewBox="0 0 16 16">
						<path fill-rule="evenodd" d="M8 2a.5.5 0 0 1 .5.5v5h5a.5.5 0 0 1 0 1h-5v5a.5.5 0 0 1-1 0v-5h-5a.5.5 0 0 1 0-1h5v-5A.5.5 0 0 1 8 2Z"/>
					</svg>
				</button>
				<input type="hidden" name="MembId" value="<%=DbId %>" />
			</form>
		</div>
		<!-- 마이페이지 -->
		<div style="display: inline-block; margin: auto; flex: 1; text-align: center;">
				<form name="frmMyPage" action="myPage.jsp" method="get" style="display:inline;">
					<button type="submit" class="myPage" <%if(memb_status.equals("제명")){%>disabled='disabled'<%}%>>
					<svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="black" class="bi bi-person" viewBox="0 0 16 16">
			  			<path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0zm4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/>
					</svg>
					</button>
					<input type="hidden" name="MembId" value="<%=DbId %>" />
				</form>
		</div>
	</div>
	</footer>
	<script src="https://apis.google.com/js/platform.js?onload=onLoad" async defer></script>
</body>
</html>