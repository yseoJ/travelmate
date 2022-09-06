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
	
	<title>My Trip</title>
</head>
<body style="line-height: 200%">
	<div style="display: inline; position: relative; left: 10px; top: 5px;">
		<a href="index.jsp?ID=<%=memb_id %>">
			<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-arrow-left" viewBox="0 0 16 16">
			  <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8z"/>
			</svg>
		</a>
	</div>
	<div style="line-height: 120%"><br></div>
	<%
	sql = "SELECT TRIP_ID, MEMB_ID, PRG_STATUS "+
			"FROM TRIP_JOIN_LIST j "+
			"WHERE TRIP_ID IN (SELECT TRIP_ID "+
			                "FROM TRIP_JOIN_LIST "+
			                "WHERE MEMB_ID = '" + memb_id +"' "+
			                "AND PRG_STATUS = '수락') "+
			"AND MEMB_ID != '" + memb_id + "' "+
			"AND PRG_STATUS = '수락' "+
			"AND (SELECT TO_CHAR(TRIP_MEET_DATE,'YYYYMMDD') TRIP_MEET_DATE "+
			    "FROM TRIP_INFO i "+
			    "WHERE i.TRIP_ID = j.TRIP_ID)<TO_CHAR(SYSDATE,'YYYYMMDD') ";
	res = conn.prepareStatement(sql).executeQuery();
				
	if(res.next()){
		do{
			String trip_id = res.getString("TRIP_ID");
			String participant_id = res.getString("MEMB_ID");
				
			sql = "SELECT * FROM MEMB_SCORE "+
					"WHERE TRIP_ID = " + trip_id + " "+
					"AND GIVE_MEMB_ID = '" + memb_id + "' "+
					"AND GET_MEMB_ID = '" + participant_id + "' ";
			rs = conn.prepareStatement(sql).executeQuery();
			if(!rs.next()){
				sql2 = "SELECT TRIP_TITLE, TO_CHAR(TRIP_MEET_DATE, 'YYYY-MM-DD') TRIP_MEET_DATE, MEMB_ID "+
						"FROM TRIP_INFO "+
						"WHERE TRIP_ID = '" + trip_id + "' ";
				rs = conn.prepareStatement(sql2).executeQuery();
				rs.next();
				
				String trip_title = rs.getString("TRIP_TITLE");
				String trip_meet_date = rs.getString("TRIP_MEET_DATE");
				String host_id = rs.getString("MEMB_ID");
				
				sql2 = "SELECT * FROM MEMB_INFO WHERE MEMB_ID = '" + participant_id + "' ";
				rs = conn.prepareStatement(sql2).executeQuery();
				rs.next();
				
				String participant_nm = rs.getString("FULL_NM");
				%>
				<div style="text-align: center; border: 2px solid rgba(13, 45, 132); border-radius: 10px; width: 95%; margin: auto;">
					<div style="font-size: 15px; font-weight: bold; font-color: black; display: inline-block;">
						<form name="frmMyTripHost" action="pastTrip.jsp" method="get" style="display: inline-block;">
							<button class="myTripButton" type="submit" style="text-align: center; display: inline-block;"><%=trip_title %></button>
							<input type="hidden" name="tripId" value="<%=trip_id %>" />
							<input type="hidden" name="membId" value="<%=memb_id %>" />
						</form>
					</div>
					<div style="font-size: 12px; font-color: black; display: inline-block;">&nbsp;[<%=trip_meet_date %>]</div>
				</div>
				<div style="line-height: 50%;"><br></div>
				<table style="width: 95%; margin: 0 auto;">
					<tr style="color: white; background-color: rgb(14, 45, 132);">
						<th style="height: 20px; line-height: 20px; text-align: center;">참여자명</th>
						<th style="text-align: center;">평가</th>
					</tr>
					<tr>
						<td style="font-size: 13px;">
							<div style="margin: 0 auto; text-align: center;">
								<%if (participant_id.equals(host_id)){ %>
									<div style="position: absolute; float: left; line-height:230%; margin-left: 5px; margin-top: 5px; padding: 0px 3px 0px 3px; font-size: 10px; background-color: rgba(13, 45, 132); color: white; border-radius: 10px;">주최자</div>
								<%} %>
								<a style="font-weight: bold; font-size: 15px;">&nbsp;<%=participant_nm%></a>
								<form name="frmMembInfo" action="membInfo.jsp" method="get" style="display: inline;">
									<button type="submit" style="background-color: rgba(0,0,0,0); border: 0; outline: 0; text-decoration-line: underline;">자세히</button>
									<input type="hidden" name="participantId" value="<%=participant_id %>" />
									<input type="hidden" name="membId" value="<%=memb_id %>" />
								</form>
							</div>
						</td>
						<td style="font-size: 13px; width: 80px;">
							<div style="margin: 0 auto; text-align: center; font-size: 14px;">
								<form name="frmMembEval" action="membEval.jsp" method="get" style="display: inline;">
									<% 
									sql = "SELECT * FROM MEMB_SCORE "+
											"WHERE TRIP_ID = " + trip_id + " "+
											"AND GIVE_MEMB_ID = '" + memb_id + "' "+
											"AND GET_MEMB_ID = '" + participant_id + "' ";
									rs = conn.prepareStatement(sql).executeQuery();
									if(rs.next()){ %>
										<button type="submit" style="background-color: rgba(0,0,0,0); border: 0; outline: 0;" disabled='disabled'>평가완료</button>
									<%} else{ %>
										<button type="submit" style="background-color: rgba(0,0,0,0); border: 0; outline: 0; text-decoration-line: underline;">평가하기</button>
									<%} %>
									<input type="hidden" name="participantId" value="<%=participant_id %>" />
									<input type="hidden" name="membId" value="<%=memb_id %>" />
									<input type="hidden" name="tripId" value="<%=trip_id %>" />
								</form>
							</div>
						</td>
					</tr>
				</table> 
				<div style="line-height: 250%"><br></div>
			<%
			}
		}while(res.next());
	}
    res.close();
 	conn.close();
	%>
			
</body>
</html>