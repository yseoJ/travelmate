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
	
	String participantId = request.getParameter("participantId");
	String membId = request.getParameter("membId");
	
	sql = String.format("SELECT FULL_NM,ADDM_YEAR,PHONE_NUM,NVL(MBTI,' ') MBTI FROM MEMB_INFO WHERE MEMB_ID = '%s'", participantId);
	res = conn.prepareStatement(sql).executeQuery();
	res.next();
	
	String Name = res.getString("FULL_NM");
	String Year = res.getString("ADDM_YEAR");
	String Phone = res.getString("PHONE_NUM");
	String MBTI  = res.getString("MBTI");
	
	sql = "SELECT COUNT(*) countHost "+ 
			"FROM TRIP_JOIN_LIST l JOIN TRIP_INFO i "+
			"ON l.trip_id = i.trip_id AND i.memb_id = l.memb_id "+
			"WHERE i.trip_status = '진행중' "+
			"AND i.memb_id = '" + participantId + "' ";
	res = conn.prepareStatement(sql).executeQuery();
	res.next();
	
	String countHost = res.getString("countHost");
	
	sql = "SELECT COUNT(*) countJoin "+
			"FROM TRIP_JOIN_LIST l JOIN TRIP_INFO i "+
			"ON l.trip_id = i.trip_id "+
			"WHERE i.trip_status = '진행중' "+
			"AND l.memb_id = '" + participantId + "' "+
			"AND i.memb_id != '" + participantId + "' "+
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
	<br><h2 style="text-align: center">참여자 정보</h2>
	<hr> 
	<div style="display: inline-block; font-weight: bold; width: 50px">이름:</div>
	<div style="display: inline-block;"><%=Name %>
		<form name="frmReport" action="report.jsp" method="get" style="display: inline;">
			<input type="hidden" name="participantId" value="<%=participantId %>" />
			<input type="hidden" name="membId" value="<%=membId %>" />
		</form>
		<button type="submit" onclick="report()" style="background-color: rgba(0,0,0,0); border: 0; outline: 0; text-decoration-line: underline; color: red;">신고하기</button>
	</div><br>
	<div style="display: inline-block; font-weight: bold; width: 50px">학번:</div><div style="display: inline-block;"><%=Year %></div><br>
	<div style="display: inline-block; font-weight: bold; width: 80px">전화번호:</div><div style="display: inline-block;"><%=Phone %></div><br>
	<div style="display: inline-block; font-weight: bold; width: 50px">MBTI:</div><div style="display: inline-block;"><%=MBTI %></div><br>
	<div style="display: inline-block; font-weight: bold; width: 80px">주최횟수:</div><div style="display: inline-block;"><%=countHost %></div><br>
	<div style="display: inline-block; font-weight: bold; width: 80px">참여횟수:</div><div style="display: inline-block;"><%=countJoin %></div><br><br>
	<div style="background-color: rgba(66, 133, 244, 0.5); height: 100px;">매너평가</div><br>
	<div style="background-color: rgba(66, 133, 244, 0.5); height: 100px;">평가정보</div>
	
	<script type="text/javascript">
		function report() {
			var result = prompt('신고항목\n1.약속에 나오지 않았어요.\n2. 비매너 참여자에요.\n3. 욕설을 해요.\n4. 다른 목적이 있어요.\n5. 다른 문제가 있어요.');
			if(result == '1' || result == '2' || result == '3' || result == '4' || result == '5'){
			    alert(result + '신고처리');
			}else{
				alert('신고항목에 없는 신고 내용입니다.');
			}
		}
	</script>
</body>
</html>