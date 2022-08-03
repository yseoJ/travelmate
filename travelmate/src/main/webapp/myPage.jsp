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
	ResultSet rs = null;
	
	String memb_id = request.getParameter("MembId");
	
	sql = String.format("SELECT FULL_NM, MEMB_STATUS, NVL(MBTI,'입력해주세요') MBTI FROM MEMB_INFO WHERE MEMB_ID = '%s' ", memb_id);
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
		<div style="display: inline; position: relative; left: 10px; top: 5px;">
			<a href="index.jsp?ID=<%=memb_id %>">
				<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-house-door" viewBox="0 0 16 16">
				  <path d="M8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4.5a.5.5 0 0 0 .5-.5v-4h2v4a.5.5 0 0 0 .5.5H14a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146zM2.5 14V7.707l5.5-5.5 5.5 5.5V14H10v-4a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5v4H2.5z"/>
				</svg>
			</a>
		</div>
		<br><h2 style="text-align: center"><%=name %>님</h2><br>
	</div><hr style="margin-top: 0px; margin-bottom: 30px;">
	<% 
	String score = null;
	sql = "SELECT SATIS_SCORE "+
			"FROM MEMB_SCORE "+
			"WHERE GET_MEMB_ID = '" + memb_id + "' ";
	res = conn.prepareStatement(sql).executeQuery();
	if(res.next()){
		sql = "SELECT ROUND(AVG(SATIS_SCORE), 1) score "+
				"FROM MEMB_SCORE "+
				"WHERE GET_MEMB_ID = '" + memb_id + "' ";
		res = conn.prepareStatement(sql).executeQuery();
		res.next();
		score = res.getString("score");
		int scoreForText = 0;
	%>
		<div class="myPageText2">만족도 (<%=score %>%)</div>
		<div class="statisBack">           
			<div class="statis" style="width: <%=score %>% !important;"> </div>
		</div>
	<%}else{ %>
		<div class="myPageText2">만족도 </div>
		<div class="statisBack"></div>
		<div style="text-align:center;">평가 내용이 업습니다.</div>
	<%} %>
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
			<div class="myPageButton" style="line-height: 50px;">완료한 여행<p style="font-size: 10px; line-height: 0px;">*완료한 여행에 대해 평가하세요</p></div>
			<div class="myPageButton2" style="line-height: 60px;"><%=count_prev %>건 ></div>
		</button>
		<input type="hidden" name="membId" value="<%=memb_id %>" />
	</form>
	<!-- 받은 매너/비매너 평가 -->
	<form name="frmMyEvaluation" action="myEval.jsp" method="get" >
		<button class="myTrip" type="submit">
			<div class="myPageButton">받은 매너/비매너 평가</div>
			<div class="myPageButton2">></div>
		</button>
		<input type="hidden" name="membId" value="<%=memb_id %>" />
	</form>
	<!-- 추천 여행 -->
	<form name="frmTopKTrip" action="topKTrip.jsp" method="get" >
		<button class="myTrip" type="submit">
			<div class="myPageButton">추천 여행 (top-K)<br></div>
			<div class="myPageButton2">></div>
		</button>
		<input type="hidden" name="membId" value="<%=memb_id %>" />
	</form>
	<!-- 나의 관심사 -->
	<div class="myPageText">나의 관심사</div>
	<form name="frmMyInterest" action="myInterest.jsp" method="get" >
		<button class="myTrip" type="submit">
			<div class="myPageButton">
				<div style="text-align: left; width: 250px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
					<%
					sql = "SELECT * FROM MEMB_HOPE_LIST WHERE MEMB_ID = '" + memb_id + "' ";
					res = conn.prepareStatement(sql).executeQuery();
					if(res.next()){
						do{
							String tag_id = res.getString("TAG_ID");
							sql = "SELECT * FROM TAG_LIST WHERE TAG_ID = '" + tag_id + "' ";
							rs = conn.prepareStatement(sql).executeQuery();
							rs.next();
							String tag_nm = rs.getString("TAG_NM");
							%>
							<%=tag_nm %>,
							<% 
						}while(res.next());
					}else{
						%>
						설정해주세요
						<%
					}%>
				</div>
			</div>
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