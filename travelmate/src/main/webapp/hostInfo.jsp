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
	String participant_id = request.getParameter("participantId");
	
	sql = String.format("SELECT FULL_NM,ADDM_YEAR,PHONE_NUM,NVL(MBTI,' ') MBTI, EMAIL_ADDR FROM MEMB_INFO WHERE MEMB_ID = '%s'", participant_id);
	res = conn.prepareStatement(sql).executeQuery();
	res.next();
	
	String Name = res.getString("FULL_NM");
	String Year = res.getString("ADDM_YEAR");
	String Phone = res.getString("PHONE_NUM");
	String MBTI  = res.getString("MBTI");
	String email = res.getString("EMAIL_ADDR");
	
	
	sql = "SELECT COUNT(*) countHost "+ 
			"FROM TRIP_JOIN_LIST l JOIN TRIP_INFO i "+
			"ON l.trip_id = i.trip_id AND i.memb_id = l.memb_id "+
			"WHERE i.trip_status = '진행중' "+
			"AND i.memb_id = '" + participant_id + "' ";
	res = conn.prepareStatement(sql).executeQuery();
	res.next();
	
	String countHost = res.getString("countHost");
	
	sql = "SELECT COUNT(*) countJoin "+
			"FROM TRIP_JOIN_LIST l JOIN TRIP_INFO i "+
			"ON l.trip_id = i.trip_id "+
			"WHERE i.trip_status = '진행중' "+
			"AND l.memb_id = '" + participant_id + "' "+
			"AND i.memb_id != '" + participant_id + "' "+
			"AND l.prg_status = '수락' ";
	res = conn.prepareStatement(sql).executeQuery();
	res.next();
	
	String countJoin = res.getString("countJoin");
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
	
	<title>Host Info</title>
</head>
<body style="line-height: 200%">
	<div style="background-color: transparent; top: 5px;">
		<div style="position: absolute; left: 10px; top: 5px; z-index: 2;">
			<a href="#" onClick="history.go(-1); return false;">
				<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-arrow-left" viewBox="0 0 16 16">
				  <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8z"/>
				</svg>
			</a>
			<a href="index.jsp?ID=<%=memb_id %>">
				<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-house-door" viewBox="0 0 16 16">
				  <path d="M8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4.5a.5.5 0 0 0 .5-.5v-4h2v4a.5.5 0 0 0 .5.5H14a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146zM2.5 14V7.707l5.5-5.5 5.5 5.5V14H10v-4a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5v4H2.5z"/>
				</svg>
			</a>
		</div>
		<div style=" margin: auto; position: relative; top: 5px; text-align: center; z-index: 1;">
			<p style="font-size: 20px; font-weight: bold; font-color: block;">주최자 정보</p>
		</div>
	</div>
	<div style="line-height:120%;"><br></div>
	<div style="display: flex">
		<div style="display: inline-block; margin: auto; flex: 1; text-align: center;"></div>
		<div style="display: inline-block; margin: auto; flex: 1; text-align: center;"><h2 style="text-align: center; display: inline;"><%=Name %></h2></div>
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
					if(participant_id.equals(top_id)){
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
	<div style="width: 95%; margin: auto; border: 4px solid rgba(13, 45, 132); border-radius: 12px;">
		<div style="display: inline-block; margin-left: 5px; margin-right: 5px;">
			<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-person" viewBox="0 0 16 16">
			  <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0zm4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/>
			</svg>
		</div>
		<div style="display: inline; font-size: 18px;"><%=Year %></div><br>
		<div style="display: inline-block; margin-left: 5px; margin-right: 5px;">
			<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-envelope" viewBox="0 0 16 16">
			  <path d="M0 4a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V4Zm2-1a1 1 0 0 0-1 1v.217l7 4.2 7-4.2V4a1 1 0 0 0-1-1H2Zm13 2.383-4.708 2.825L15 11.105V5.383Zm-.034 6.876-5.64-3.471L8 9.583l-1.326-.795-5.64 3.47A1 1 0 0 0 2 13h12a1 1 0 0 0 .966-.741ZM1 11.105l4.708-2.897L1 5.383v5.722Z"/>
			</svg>
		</div>
		<div style="display: inline; font-size: 18;"><%=email %></div><br>
		<div style="display: inline-block; margin-left: 5px; margin-right: 5px; font-size: 18px;">주최횟수:</div>
		<div style="display: inline-block; font-size: 18;""><%=countHost %></div><br>
		<div style="display: inline-block; margin-left: 5px; margin-right: 5px; font-size: 18px;">참여횟수:</div>
		<div style="display: inline-block; font-size: 18;""><%=countJoin %></div><br>
	</div><br>
	<% 
	String score = null;
	sql = "SELECT SATIS_SCORE "+
			"FROM MEMB_SCORE "+
			"WHERE GET_MEMB_ID = '" + participant_id + "' ";
	res = conn.prepareStatement(sql).executeQuery();
	if(res.next()){
		sql = "SELECT ROUND(AVG(SATIS_SCORE), 1) score "+
				"FROM MEMB_SCORE "+
				"WHERE GET_MEMB_ID = '" + participant_id + "' ";
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
	<%} %>
	<br>
	
	<hr>
		<div class="myPageText2">성격</div>
		<div style="margin: auto; width: 90%;">
			<%     
			sql = "SELECT l.CHARACTER_NM character "+
					"FROM MEMB_CHARACTER c LEFT OUTER JOIN CHARACTER_LIST l "+
					"ON c.CHARACTER_ID = l.CHARACTER_ID "+
					"WHERE MEMB_ID= '" + participant_id + "' "+
					"ORDER BY l.CHARACTER_ID ";
		    res = conn.prepareStatement(sql).executeQuery();
		    while(res.next()) {            
				String character = res.getString("character");  
				%>
					<div style="display:inline-block; width: 80px; height: 50px; margin: 5px;">
						<label style="width:100%; border:2px solid #ddd; text-align:center; border-radius:20px; font-size:14px; color:#555;">#<%=character %></label>
					</div>
			<%
			}
			%>
		</div>
	<br>
	<hr> 
	<div>
		<a href="myEval.jsp?membId=<%=participant_id %>">
			<div style="float: left; font-weight: bold; margin-left: 3%;">받은 매너/비매너 평가</div>
			<div style="float: right; display: inline-block; font-weight: bold;">>&nbsp;</div>
		</a>
		<br><br>
		<%     
		sql = "SELECT * FROM "+
				"(SELECT i.EVAL_ITEM evalItem, e.EVAL_ID, COUNT(*) count "+
				"FROM MEMB_EVALUATION e "+
				"LEFT OUTER JOIN EVALUATION_ITEM i ON e.EVAL_ID = i.EVAL_ID "+
				"WHERE e.GET_MEMB_ID = '" + participant_id + "' "+
				"GROUP BY i.EVAL_ITEM, e.EVAL_ID "+
				"ORDER BY count DESC, EVAL_ID) "+
				"WHERE ROWNUM <= 3 ";
	    res = conn.prepareStatement(sql).executeQuery();
		
	    while(res.next()) {            
			String evalItem = res.getString("evalItem");
			String count = res.getString("count");   
			%>
			<table class="myEval" style="margin: 0 auto; border-collapse: collapse;">
				<tr style="border:none;">
					<td style="width: 300px; border:none;">
						<%=evalItem %>
					</td>
					<td style="border:none;">
						<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-people" viewBox="0 0 16 16">
						  <path d="M15 14s1 0 1-1-1-4-5-4-5 3-5 4 1 1 1 1h8zm-7.978-1A.261.261 0 0 1 7 12.996c.001-.264.167-1.03.76-1.72C8.312 10.629 9.282 10 11 10c1.717 0 2.687.63 3.24 1.276.593.69.758 1.457.76 1.72l-.008.002a.274.274 0 0 1-.014.002H7.022zM11 7a2 2 0 1 0 0-4 2 2 0 0 0 0 4zm3-2a3 3 0 1 1-6 0 3 3 0 0 1 6 0zM6.936 9.28a5.88 5.88 0 0 0-1.23-.247A7.35 7.35 0 0 0 5 9c-4 0-5 3-5 4 0 .667.333 1 1 1h4.216A2.238 2.238 0 0 1 5 13c0-1.01.377-2.042 1.09-2.904.243-.294.526-.569.846-.816zM4.92 10A5.493 5.493 0 0 0 4 13H1c0-.26.164-1.03.76-1.724.545-.636 1.492-1.256 3.16-1.275zM1.5 5.5a3 3 0 1 1 6 0 3 3 0 0 1-6 0zm3-2a2 2 0 1 0 0 4 2 2 0 0 0 0-4z"/>
						</svg>
						<%=count %>
					</td>
				</tr>
			</table>
		<%
		}
		res.close();
		conn.close();
		%>
		<br><br>
	</div>
</body>
</html>