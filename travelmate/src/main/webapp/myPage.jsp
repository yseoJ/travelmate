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
	
	sql = String.format("SELECT FULL_NM, MEMB_STATUS, NVL(MBTI,'입력해주세요') MBTI, EMAIL_ADDR, ADDM_YEAR FROM MEMB_INFO WHERE MEMB_ID = '%s' ", memb_id);
	res = conn.prepareStatement(sql).executeQuery();
	res.next();
	System.out.print(sql);
	String name = res.getString("FULL_NM");
	String status = res.getString("MEMB_STATUS");
	String mbti = res.getString("MBTI");
	String email = res.getString("EMAIL_ADDR");
	String year = res.getString("ADDM_YEAR");
	
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
	<div style="background-color: transparent; top: 5px;">
		<div style="position: absolute; left: 10px; top: 5px; z-index: 2;">
			<a href="index.jsp?ID=<%=memb_id %>">
				<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-house-door" viewBox="0 0 16 16">
				  <path d="M8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4.5a.5.5 0 0 0 .5-.5v-4h2v4a.5.5 0 0 0 .5.5H14a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146zM2.5 14V7.707l5.5-5.5 5.5 5.5V14H10v-4a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5v4H2.5z"/>
				</svg>
			</a>
		</div>
		<div style="margin: auto; position: relative; top: 5px; text-align: center; z-index: 1;">
			<p style="font-size: 20px; font-weight: bold; font-color: block;">마이페이지</p>
		</div>
	</div><br>
	<!--
	<div style="margin: 0 auto; text-align: center;">	
		<div class="box" style="background: #000; width: 100px;height: 100px; border-radius: 70%; overflow: hidden; margin: 0 auto; border: 2px solid rgba(13, 45, 132);">
		    <img class="profile" style="width: 100%;height: 100%;object-fit: cover;" src="/images/<%=memb_id %>.JPG">
		</div>
		<form name="frmImge" action="changeImage.jsp" method="get" >
			<button class="changeImage" type="submit" style="line-height:25px; display: inline-block; border-radius: 6px; background-color: rgba(13, 45, 132); height: 25px; color: white;">수정</button>
			<input type="hidden" name="membId" id="membId" value="<%=memb_id %>" />
		</form>
	</div>
	<br>
	-->
	<div style="width: 95%; margin: auto; border: 4px solid rgba(13, 45, 132); border-radius: 12px;">
		<div style="line-height:120%;"><br></div>
		<div style="display: flex">
			<div style="display: inline-block; margin: auto; flex: 1; text-align: center;"></div>
			<div style="display: inline-block; margin: auto; flex: 1; text-align: center;"><h2 style="text-align: center; display: inline;"><%=name %></h2></div>
			<div style="display: inline-block; margin: auto; flex: 1; text-align: left;">
				<!-- 매너top10 -->
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
						if(memb_id.equals(top_id)){
							%>
							<div style="display: inline-block">
								<img src="image/manner.jpg" width="80px" height="70px">
							</div>
							<% 
						}
					}while(res.next());
				}
				%>
			</div>
		</div>
		<div style="line-height:120%;"><br></div>
		<div style="display: flex;  margin: auto;">
			<div style="display: inline-block; margin: auto; flex: 1; text-align: center;">
				<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" class="bi bi-person" viewBox="0 0 16 16">
				  <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0zm4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/>
				</svg>
				<div style="display: inline; font-size: 15px;"><%=year %></div>
			</div>
			<div style="display: inline-block; margin: auto; flex: 2; text-align: center;">
				<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" class="bi bi-envelope" viewBox="0 0 16 16">
				  <path d="M0 4a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V4Zm2-1a1 1 0 0 0-1 1v.217l7 4.2 7-4.2V4a1 1 0 0 0-1-1H2Zm13 2.383-4.708 2.825L15 11.105V5.383Zm-.034 6.876-5.64-3.471L8 9.583l-1.326-.795-5.64 3.47A1 1 0 0 0 2 13h12a1 1 0 0 0 .966-.741ZM1 11.105l4.708-2.897L1 5.383v5.722Z"/>
				</svg>
				<div style="display: inline; font-size: 12px;"><%=email %></div>
			</div>
		</div>
		<div style="line-height:120%;"><br></div>
	</div>
	<br>
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
				<div style="color: red; margin-left: 10px; font-weight: bold; font-size:10px;">
				동일 항목 신고 3번 누적 시 사이트 이용 불가
				</div>
			</details>
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
	
</body>
</html>