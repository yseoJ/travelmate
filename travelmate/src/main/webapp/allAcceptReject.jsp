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
	String sql3 = "";
	
	
	Class.forName("oracle.jdbc.driver.OracleDriver");
	Connection conn = DriverManager.getConnection(url, user, pw);
	ResultSet res = null;
	ResultSet rs = null;
	ResultSet result = null;
	
	String memb_id = request.getParameter("membId");
		
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
	
	<title>Accept/Reject</title>
</head>
<body style="line-height: 200%">
	<div style="background-color: transparent; top: 5px;">
		<div style="position: absolute; left: 10px; top: 5px; z-index: 2;">
			<a href="index.jsp?ID=<%=memb_id %>">
				<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-arrow-left" viewBox="0 0 16 16">
				  <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8z"/>
				</svg>
			</a>
		</div>
		<div style="margin: auto; position: relative; top: 5px; text-align: center; z-index: 1;">
			<p style="font-size: 20px; font-weight: bold; font-color: block;">미완료 수락/거절</p>
		</div>
	</div>
	<div style="line-height: 120%"><br></div>
	<%
	sql = "SELECT i.TRIP_ID, i.TRIP_TITLE, TO_CHAR(i.TRIP_MEET_DATE, 'YYYY-MM-DD') TRIP_MEET_DATE, j.MEMB_ID "+
			"FROM (SELECT * "+
				    "FROM TRIP_INFO "+
				    "WHERE MEMB_ID = '" + memb_id + "') i LEFT OUTER JOIN TRIP_JOIN_LIST j "+
				"ON i.TRIP_ID = j.TRIP_ID "+
				"WHERE j.PRG_STATUS = '신청' "+
				"AND TO_CHAR(i.TRIP_MEET_DATE,'YYYYMMDD') > TO_CHAR(SYSDATE, 'YYYYMMDD') "+
			"ORDER BY TRIP_MEET_DATE ";
	res = conn.prepareStatement(sql).executeQuery();
				
	if(res.next()){
		do{
			String trip_id = res.getString("TRIP_ID");
			String trip_title = res.getString("TRIP_TITLE");
			String trip_meet_date = res.getString("TRIP_MEET_DATE");
			String participant_id = res.getString("MEMB_ID");
			%>
			<div style="text-align: center; border: 2px solid rgba(13, 45, 132); border-radius: 10px; width: 95%; margin: auto;">
				<div style="font-size: 15px; font-weight: bold; font-color: black; display: inline-block;">
					<form name="frmMyTripHost" action="myTripHost.jsp" method="get" style="display: inline-block;">
						<button class="myTripButton" type="submit" style="text-align: center; display: inline-block;""><%=trip_title %></button>
						<input type="hidden" name="tripId" value="<%=trip_id %>" />
						<input type="hidden" name="membId" value="<%=memb_id %>" />
					</form>
				</div>
				<div style="font-size: 12px; font-color: black; display: inline-block;">&nbsp;[<%=trip_meet_date %>]</div>
			</div>
			<div style="line-height: 50%;"><br></div>
			<table style="width: 95%; margin: 0 auto;">
				<tr style="height: 18px; line-height: 18px; color: white; background-color: rgb(14, 45, 132);">
					<th style="text-align: center;">참여자명</th>
					<th style="text-align: center;">수락 / 거절</th>
				</tr>
				<%
				sql2 = "SELECT FULL_NM FROM MEMB_INFO WHERE MEMB_ID = '" + participant_id + "' ";
				rs = conn.prepareStatement(sql2).executeQuery();
				rs.next();
				String name = rs.getString("FULL_NM");
				%>
				<tr style="height: 18px; line-height: 18px; color: black;">
					<td style="font-size: 13px;">
						<div style="margin: 0 auto; text-align: center;">
							<a style="font-weight: bold; font-size: 15px;">&nbsp;<%=name%></a>
							<form name="frmMembInfo" action="membInfo.jsp" method="get" style="display: inline;">
								<button type="submit" style="background-color: rgba(0,0,0,0); border: 0; outline: 0; text-decoration-line: underline; color: black;">자세히</button>
								<input type="hidden" name="participantId" value="<%=participant_id %>" />
								<input type="hidden" name="membId" value="<%=memb_id %>" />
							</form>
						</div>
					</td>
					<td style="font-size: 13px;">
						<div style="margin: 0 auto; text-align: center;">
						<%
						sql3 = "SELECT PRG_STATUS FROM TRIP_JOIN_LIST "+
								"WHERE TRIP_ID = " + trip_id + " "+
								"AND MEMB_ID = '" + participant_id + "' ";
						
						result = conn.prepareStatement(sql3).executeQuery();
						result.next();
						String PRG_STATUS = result.getString("PRG_STATUS");
						if(PRG_STATUS.equals("신청")) {
						%>
							<p id="status"></p>
							<div id="button">
								<form name="frmAccept" method="get" onsubmit="return confirm('수락하시겠습니까?');" style="display: inline;" action="acceptReject.jsp">		
									<button type="submit" style="display: inline-block; background-color: rgba(0,0,0,0); color: black; border: 0; outline: 0; text-decoration-line: underline;">수락</button>
									<input type="hidden" name="tripId" value="<%=trip_id %>" />
									<input type="hidden" name="participantId" value="<%=participant_id %>" />
									<input type="hidden" name="membId" value="<%=memb_id %>" />
									<input type="hidden" name="acceptReject" value="수락" />
								</form>
								|
								<form name="frmReject" method="get" onsubmit="return confirm('거절하시겠습니까?');" style="display: inline;" action="acceptReject.jsp">
									<button type="submit" style="display: inline-block; background-color: rgba(0,0,0,0); color: black; border: 0; outline: 0; text-decoration-line: underline;">거절</button>
									<input type="hidden" name="tripId" value="<%=trip_id %>" />
									<input type="hidden" name="participantId" value="<%=participant_id %>" />
									<input type="hidden" name="membId" value="<%=memb_id %>" />
									<input type="hidden" name="acceptReject" value="거절" />
								</form>			
							</div>
						<%
						} else{
						%>
						<p id="status"><%=PRG_STATUS %>됨</p>
						<%} 
						%>
						</div>
					</td>
				</tr>
			</table>
			<div style="line-height: 250%"><br></div>
		<%}while(res.next());
	}
	res.close();
	conn.close();
	%>
</body>
</html>