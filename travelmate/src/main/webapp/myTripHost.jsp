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
	
	String trip_id = request.getParameter("tripId");
	String memb_id = request.getParameter("membId");
	
	int tripid = Integer.parseInt(trip_id);
	
	sql = String.format("SELECT * FROM TRIP_INFO WHERE TRIP_ID = %d", tripid);
	res = conn.prepareStatement(sql).executeQuery();
	res.next();
	
	String Title = res.getString("TRIP_TITLE");
	String Time = res.getString("TRIP_MEET_TIME");
	String Place = res.getString("TRIP_MEET_PLACE");
	String Num = res.getString("TOT_NUM");
	String Cost = res.getString("PLAN_COST");
	String Detail = res.getString("TRIP_Detail");
	String sightId = res.getString("SIGHTS_ID");
	
	
	sql = String.format("SELECT TO_CHAR(TRIP_MEET_DATE, 'YYYY-MM-DD') TRIP_MEET_DATE, NVL(TRIP_CHATLINK, ' ') TRIP_CHATLINK FROM TRIP_INFO WHERE TRIP_ID = %d", tripid);
	res = conn.prepareStatement(sql).executeQuery();
	res.next();
	
	String Date = res.getString("TRIP_MEET_DATE");
	String Link = res.getString("TRIP_CHATLINK");
	
	
	sql = String.format("SELECT SIGHTS_NM FROM SIGHTS_INFO WHERE SIGHTS_ID = '%s'", sightId);
	res = conn.prepareStatement(sql).executeQuery();
	res.next();
	
	String sightName = res.getString("SIGHTS_NM");
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
	
	<title>Make Trip</title>
</head>
<body style="line-height: 200%">
	<div style="display: inline; position: relative; left: 10px; top: 5px;">
		<a href="#" onClick="history.go(-1); return false;">
			<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-arrow-left" viewBox="0 0 16 16">
			  <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8z"/>
			</svg>
		</a>
	</div>
	<br><h2 style="text-align: center"><%=Title %></h2>
	<hr> 
	<div style="display: inline-block; font-weight: bold; width: 50px">날짜:</div><div style="display: inline-block;"><%=Date %></div><br>
	<div style="display: inline-block; font-weight: bold; width: 50px">인원:</div><div style="display: inline-block;"><%=Num %></div><br>
	<div style="display: inline-block; font-weight: bold; width: 50px">비용:</div><div style="display: inline-block;"><%=Cost %></div><br>
	<div style="display: inline-block; font-weight: bold; width: 80px">관광지명:</div><div style="display: inline-block;"><%=sightName %></div><br>
	<div style="display: inline-block; font-weight: bold; width: 80px">세부정보:</div><div style="display: inline-block;"><%=Detail %></div><br><br>
	<div style="color: red; font-size: 13px; line-height:120%">*모임시간,장소,오픈채팅링크, 참여자 정보*는 수락된 참여자에 한하여 열람 가능합니다.</div>
	<div style="border: 1px solid black;">
		<div style="display: inline-block; font-weight: bold; width: 50px">시간:</div><div style="display: inline-block;"><%=Time %></div><br>
		<div style="display: inline-block; font-weight: bold; width: 50px">장소:</div><div style="display: inline-block;"><%=Place %></div><br>
		<div style="display: inline-block; font-weight: bold; width: 100px">오픈채팅방:</div><div style="display: inline-block;"><%=Link %></div><br>
	</div>
	<br>
	<table style="width: 95%; margin: 0 auto;">
		<tr style=" background-color: rgba(66, 133, 244, 0.1);">
			<th style="height: 20px; line-height: 20px; text-align: center;">참여자명</th>
			<th style="text-align: center;">수락 / 거절</th>
		</tr>
		<%     
		sql = "SELECT * FROM TRIP_JOIN_LIST l JOIN MEMB_INFO m ON l.MEMB_ID = m.MEMB_ID "+
				"WHERE l.TRIP_ID = " + tripid + " "+
				"AND l.MEMB_ID != '" + memb_id + "' ";
		res = conn.prepareStatement(sql).executeQuery();
			
		while(res.next()) {            
		      String Name = res.getString("FULL_NM");
		      String participantId = res.getString("MEMB_ID");   
		%>
		<tr>
			<td style="font-size: 13px;">
				<div style="margin: 0 auto; text-align: center;">
					<a style="font-weight: bold; font-size: 15px;">&nbsp;<%=Name%></a>
					<form name="frmMembInfo" action="membInfo.jsp" method="get" style="display: inline;">
						<button type="submit" style="background-color: rgba(0,0,0,0); border: 0; outline: 0; text-decoration-line: underline;">자세히</button>
						<input type="hidden" name="participantId" value="<%=participantId %>" />
					</form>
				</div>
			</td>
			<td style="font-size: 13px;">
				<div style="margin: 0 auto; text-align: center;">
				<%
				sql = "SELECT PRG_STATUS FROM TRIP_JOIN_LIST "+
							"WHERE TRIP_ID = " + tripid + " "+
							"AND MEMB_ID != '" + memb_id + "' ";
				res = conn.prepareStatement(sql).executeQuery();
				res.next();
				String PRG_STATUS = res.getString("PRG_STATUS");
				String apply = "신청";
				if(PRG_STATUS.equals(apply)) {
				%>
					<p id="status"></p>
					<div id="button">
						<form name="frmAccept" method="get" style="display: inline;" action="acceptReject.jsp">		
							<input type="hidden" name="tripId" value="<%=tripid %>" />
							<input type="hidden" name="participantId" value="<%=participantId %>" />
							<input type="hidden" name="membId" value="<%=memb_id %>" />
							<input type="hidden" name="acceptReject" value="수락" />
						</form>
						<button onClick="accept();" type="submit" style="display: inline-block; background-color: rgba(0,0,0,0); border: 0; outline: 0; text-decoration-line: underline;">수락</button>
						|
						<form name="frmReject" method="get" style="display: inline;" action="acceptReject.jsp">
							<input type="hidden" name="tripId" value="<%=tripid %>" />
							<input type="hidden" name="participantId" value="<%=participantId %>" />
							<input type="hidden" name="membId" value="<%=memb_id %>" />
							<input type="hidden" name="acceptReject" value="거절" />
						</form>
						<button onClick="reject();" type="submit" style="display: inline-block; background-color: rgba(0,0,0,0); border: 0; outline: 0; text-decoration-line: underline;">거절</button>
					</div>
				<%
				} else{
				%>
				<p id="status"><%=PRG_STATUS %>됨</p>
				<%} %>
				</div>
				
				<script type="text/javascript">
					function accept() {
							var result = confirm("수락하시겠습니까?");
							if(result){
								document.frmAccept.submit();
								return true;
							}
							else{
								return false;
							}
					}
					function reject() {
						var result = confirm("거절하시겠습니까?");
						if(result){
							document.frmReject.submit();
							return true;
						}
						else{
							return false;
						}
				}
				</script>
			</td>
		</tr>
		<%}
		res.close();
		conn.close();
		%>
	</table> 
</body>
</html>