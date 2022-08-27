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
	<link rel="stylesheet" href="./css/custom.css?next">
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
	<div style="background-color: rgba(13, 45, 125);">
		<div style="display: inline; position: relative; left: 10px; top: 5px;">
			<a href="index.jsp?ID=<%=memb_id %>">
				<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-house-door" viewBox="0 0 16 16">
				  <path d="M8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4.5a.5.5 0 0 0 .5-.5v-4h2v4a.5.5 0 0 0 .5.5H14a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146zM2.5 14V7.707l5.5-5.5 5.5 5.5V14H10v-4a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5v4H2.5z"/>
				</svg>
			</a>
		</div>
		<br><h2 style="text-align: center"><%=name %>님</h2><br>
	</div>
	<hr style="margin-top: 0px; margin-bottom: 30px;">
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
		<div style="text-align:center;">평가 내용이 없습니다.</div>

	<%}%><br>
	<%
	sql = "SELECT SUM(cnt) sum "+
			"FROM (SELECT REPORT_ID, COUNT(REPORT_ID) cnt "+
			        "FROM REPORT "+
			        "WHERE GET_MEMB_ID = '" + memb_id + "' "+
			        "GROUP BY REPORT_ID) ";
	res = conn.prepareStatement(sql).executeQuery();
	if(res.next()){
		String sum = res.getString("sum");
		if(sum != null)
		{
		%>
			<div style="color: red; margin-left:10px; font-weight: bold; font-size: 14px;">
				<svg style="color: red" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-megaphone-fill" viewBox="0 0 16 16">
				  <path d="M13 2.5a1.5 1.5 0 0 1 3 0v11a1.5 1.5 0 0 1-3 0v-11zm-1 .724c-2.067.95-4.539 1.481-7 1.656v6.237a25.222 25.222 0 0 1 1.088.085c2.053.204 4.038.668 5.912 1.56V3.224zm-8 7.841V4.934c-.68.027-1.399.043-2.008.053A2.02 2.02 0 0 0 0 7v2c0 1.106.896 1.996 1.994 2.009a68.14 68.14 0 0 1 .496.008 64 64 0 0 1 1.51.048zm1.39 1.081c.285.021.569.047.85.078l.253 1.69a1 1 0 0 1-.983 1.187h-.548a1 1 0 0 1-.916-.599l-1.314-2.48a65.81 65.81 0 0 1 1.692.064c.327.017.65.037.966.06z"/>
				</svg>
				신고 누적 횟수: <%=sum %>
			</div>
			<details style="margin-left: 15px; font-size: 13px;">
				<summary>자세히</summary>
				<%
				do{
					sql = "SELECT i.REPORT_ID report, i.REPORT_ITEM report_nm, COUNT(i.REPORT_ID) cnt "+
							"FROM REPORT r JOIN REPORT_ITEM i "+
							"ON r.REPORT_ID = i.REPORT_ID "+
							"WHERE GET_MEMB_ID = '" + memb_id + "' "+
							"GROUP BY i.REPORT_ID, i.REPORT_ITEM ";
							
					rs = conn.prepareStatement(sql).executeQuery();
					if(rs.next()){
						do{
							String report = rs.getString("report");
							String cnt = rs.getString("cnt");
							String report_nm = rs.getString("report_nm");
							%>
							<div style="margin-left: 10px;">- <%=report_nm %>
							<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-plus-circle" viewBox="0 0 16 16">
							  <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
							  <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4z"/>
							</svg>
							<%=cnt %><br></div>
							
							<%
						}while(rs.next());
					}
				}while(res.next());
				%>
			</details>
			<div style="color: red; margin-left: 10px; font-weight: bold; font-size:10px;">
				같은 항목에 대해 3번 신고 누적 시 사이트를 사용할 수 없습니다.
			</div>
		<%}
	} %>

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
	<!-- 나의 성격 -->
	<div class="myPageText">나의 성격</div>
	<form name="frmMyCHARACTER" action="myCharacter.jsp" method="get" >
		<button class="myTrip" type="submit">
			<div class="myPageButton">
				<div style="text-align: left; width: 250px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
					<%
					sql = "SELECT * FROM MEMB_CHARACTER WHERE MEMB_ID = '" + memb_id + "' ";
					res = conn.prepareStatement(sql).executeQuery();
					if(res.next()){
						do{
							String character_id = res.getString("CHARACTER_ID");
							sql = "SELECT * FROM CHARACTER_LIST WHERE CHARACTER_ID = '" + character_id + "' ";
							rs = conn.prepareStatement(sql).executeQuery();
							rs.next();
							String character_nm = rs.getString("CHARACTER_NM");
							%>
							<%=character_nm %>,
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
	<!-- 나의 mbti 
	<div class="myPageText">MBTI</div>
	<form name="frmMyMBTI" action="myMBTI.jsp" method="get" >
		<button class="myTrip" type="submit">
			<div class="myPageButton"></div>
			<div class="myPageButton2">></div>
		</button>
		<input type="hidden" name="membId" value="" />
	</form>
	-->
	<!-- 추천 여행 -->
	<div class="myPageText">추천여행</div>
	<div class="wrap-vertical" style="padding: 0; border: none;">
		<%     
		sql = "SELECT SIGHTS_ID, COUNT(TAG_ID) cnt "+
				"FROM SIGHTS_TAG_LIST "+
				"WHERE TAG_ID IN (SELECT TAG_ID "+
				                "FROM MEMB_HOPE_LIST "+
				                "WHERE MEMB_ID = '" + memb_id +"') "+
				"GROUP BY SIGHTS_ID "+
				"ORDER BY COUNT(TAG_ID) DESC ";
		res = conn.prepareStatement(sql).executeQuery();
		if(res.next()){
			do{
				String cnt = res.getString("cnt");
				String sights_id = res.getString("SIGHTS_ID");
				sql = "SELECT x.TRIP_ID, x.TRIP_TITLE, x.TRIP_MEET_DATE, x.TOT_NUM, x.JOIN_NUM "+
			    		"FROM (SELECT m.TRIP_ID, m.TRIP_TITLE, TO_CHAR(m.TRIP_MEET_DATE, 'YYYY/MM/DD') TRIP_MEET_DATE, "+
			    				  "m.TOT_NUM, m.SIGHTS_ID, (SELECT COUNT(*) "+
			    			                              "FROM TRIP_JOIN_LIST j "+
			    			                              "WHERE j.TRIP_ID = m.TRIP_ID "+
			    			                              "AND (PRG_STATUS = '수락' OR PRG_STATUS = '신청')) JOIN_NUM "+
			    				  "FROM TRIP_INFO m "+
			    				  "WHERE to_char(m.TRIP_MEET_DATE,'YYYY-MM-DD') > to_char(SYSDATE, 'YYYY-MM-DD') "+
			    				  "AND m.TRIP_STATUS != '삭제' "+
			    			      "AND m.SIGHTS_ID = '" + sights_id + "' "+
			    			      "AND '" + memb_id + "' NOT IN (SELECT MEMB_ID FROM TRIP_JOIN_LIST WHERE TRIP_ID = m.TRIP_ID) "+
			    				  ") x LEFT OUTER JOIN SIGHTS_INFO s "+
			    			"ON x.SIGHTS_ID = s.SIGHTS_ID "+
			    			"WHERE x.JOIN_NUM < x.TOT_NUM ";

			    rs = conn.prepareStatement(sql).executeQuery();
				
			    if(rs.next()) {            
			      String TRIP_TITLE = rs.getString("TRIP_TITLE");
			      String TRIP_MEET_DATE = rs.getString("TRIP_MEET_DATE");   
			      String TOT_NUM = rs.getString("TOT_NUM");
			      String TRIP_ID = rs.getString("TRIP_ID");
			      String JOIN_NUM = rs.getString("JOIN_NUM");
			      //System.out.println(sql);
				
				%>
				<div class="box" style="display: inline-block; padding: 0; border: none;">
					<form name="frmTripInfo" action="tripInfo.jsp" method="get" style="float:left; margin:5px;">
						<button type="submit" style="text-align: left; border-radius: 20px; border: 4px solid rgba(66, 133, 244, 0.5);">
							<br><div style="font-weight:bold; line-height:50%;"><%=TRIP_TITLE%></div>
							<div style="line-height: 80%;"><br></div>
							<!-- 여행 날짜 -->
							<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-calendar-event" viewBox="0 0 16 16">
							  <path d="M11 6.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1z"/>
							  <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5zM1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4H1z"/>
							</svg>
							&nbsp;<%=TRIP_MEET_DATE%>
							<div style="line-height: 80%;"><br></div>
							<% 
							sql2 = "SELECT t.TAG_NM tagnm "+
									"FROM TAG_LIST t LEFT OUTER JOIN SIGHTS_TAG_LIST s "+
									"ON t.TAG_ID = s.TAG_ID "+
									"WHERE SIGHTS_ID = '" + sights_id + "' "+
									"AND t.TAG_ID IN (SELECT TAG_ID "+
														"FROM MEMB_HOPE_LIST "+
														"WHERE MEMB_ID = '" + memb_id + "') ";
							result = conn.prepareStatement(sql2).executeQuery();
							
						    while(result.next()) {            
						      String tagnm = result.getString("tagnm");
							%>
							<div style="display: inline-block; border-radius: 18px; text-align:center; font-size: 12px; padding: 0px 5px 0px 5px; background-color: rgba(13, 45, 132); color: white;">
							#<%=tagnm%>
							</div>
							<%} %>
						</button>
						<input type="hidden" name="MembId" value="<%=memb_id %>" />
						<input type="hidden" name="TripTitle" value="<%=TRIP_TITLE %>" />
						<input type="hidden" name="TripId" value="<%=TRIP_ID %>" />
						<input type="hidden" name="JoinNum" value="<%=JOIN_NUM %>" />
					</form>
				</div>
		
	    		<%
				}
			}while(res.next());
		} else{
				%>
				<div style="margin: 0 auto; border: 2px solid black; width: 80%; text-align:center; font-weight: bold ;">관심사를 설정해주세요.</div><br>
		<% }
    	res.close();
 		conn.close();
		%>
	</div><br>
</body>
</html>