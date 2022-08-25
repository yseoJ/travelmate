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
	
	String participant_id = request.getParameter("participantId");
	String memb_id = request.getParameter("membId");
	
	sql = String.format("SELECT FULL_NM,ADDM_YEAR,PHONE_NUM,EMAIL_ADDR,NVL(MBTI,' ') MBTI FROM MEMB_INFO WHERE MEMB_ID = '%s'", participant_id);
	res = conn.prepareStatement(sql).executeQuery();
	res.next();
	
	String Name = res.getString("FULL_NM");
	String Year = res.getString("ADDM_YEAR");
	String Phone = res.getString("PHONE_NUM");	//비공개
	String MBTI  = res.getString("MBTI");
	String Email  = res.getString("EMAIL_ADDR");
	
	
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
	
	<title>Make Trip Check</title>
</head>
<body style="line-height: 200%">
	<div style="display: inline; position: relative; left: 10px; top: 5px;">
		<a href="#" onClick="history.go(-1); return false;">
			<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-arrow-left" viewBox="0 0 16 16">
			  <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8z"/>
			</svg>
		</a>
	</div>
	<br><h2 style="text-align: center">참여자 정보</h2>
	<hr> 
	<div style="display: inline-block; font-weight: bold; width: 50px">이름:</div>
	<div style="display: inline-block;"><%=Name %>
		<form name="frmReport" action="report.jsp" method="get" style="display: inline;">
			<button type="button" onclick="report()" style="background-color: rgba(0,0,0,0); border: 0; outline: 0; text-decoration-line: underline; color: red;">신고하기</button>
			<input type="hidden" name="participantId" value="<%=participant_id %>" />
			<input type="hidden" name="membId" value="<%=memb_id %>" />
			<input type="hidden" name="reportId"/>
		</form>
	</div><br>
	<div style="display: inline-block; font-weight: bold; width: 60px">학번:</div><div style="display: inline-block;"><%=Year %></div><br>
	<div style="display: inline-block; font-weight: bold; width: 60px">이메일:</div><div style="display: inline-block;"><%=Email %></div><br>
	<div style="display: inline-block; font-weight: bold; width: 80px">주최횟수:</div><div style="display: inline-block;"><%=countHost %></div><br>
	<div style="display: inline-block; font-weight: bold; width: 80px">참여횟수:</div><div style="display: inline-block;"><%=countJoin %></div><br>
	<hr>
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
	
	<hr> 
	<div>
		<a href="myEval.jsp?membId=<%=participant_id %>">
			<div style="float: left; font-weight: bold;">받은 매너/비매너 평가</div>
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
		%>
	</div>
	
	<script type="text/javascript">
		function report() {
			<%
			sql = String.format( "select * from REPORT where GIVE_MEMB_ID = '%s' and GET_MEMB_ID = '%s' ", memb_id, participant_id);
			res = conn.prepareStatement(sql).executeQuery();
			if(res.next()){%>
				alert('같은 참여자에 대해서는 한번만 신고가 가능합니다.');
			<% } else{%>
				var f = document.frmReport;
				var result = prompt('신고항목\n1. 다른 목적이 있어요(종교, 사기 등).\n2. 폭력적이에요.\n3. 기타');
				if(result == '1' || result == '2' || result == '3'){
				    f.reportId.value = result;
				    f.submit();
				}else{
					alert('신고항목에 없는 신고 내용입니다.');
				}
			<% }%>
		}
	</script>
	<%conn.close(); %>
</body>
</html>