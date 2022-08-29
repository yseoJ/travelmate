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
	String tripStatus = res.getString("TRIP_STATUS");
	
	
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
	
	<title>My Trip Host</title>
</head>
<body style="line-height: 200%">
	<div style="display: inline; position: relative; left: 10px; top: 5px;">
		<a href="myTrip.jsp?membId=<%=memb_id %>">
			<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-arrow-left" viewBox="0 0 16 16">
			  <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8z"/>
			</svg>
		</a>
	</div>
	<br><h2 style="text-align: center"><%=Title %></h2>
	<hr> 
	<%if("삭제".equals(tripStatus)) {%>
		<div style="color: red; font-size: 13px; line-height:120%; border: 1px solid red; display: inline-block;"><p style="font-size: 20px; display:inline">삭제</p>된 여행입니다.</div>
	<%} else if("취소".equals(tripStatus)) {%>
			<div style="color: red; font-size: 13px; line-height:120%; border: 1px solid red; display: inline-block; text-align: center;">여행 참여자가 없어<br><p style="font-size: 20px; display:inline">취소</p>된 여행입니다.</div>
	<%} else{ %>
		<div style="color: blue; font-size: 13px; line-height:120%; border: 1px solid blue; display: inline-block;">진행중</div>
	<%} %>
	<table class="tripInfo">
	<tr>
		<td style="width: 100px;">
			<!-- 여행 날짜 -->
			<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-calendar-event" viewBox="0 0 16 16">
			  <path d="M11 6.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1z"/>
			  <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5zM1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4H1z"/>
			</svg>
			여행날짜
		</td>
		<td>
			&nbsp;<%=Date %>
		</td>
	</tr>
	<tr>
		<td>
			<!-- 인원 -->
			<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-person-plus" viewBox="0 0 16 16">
			  <path d="M6 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0zm4 8c0 1-1 1-1 1H1s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C9.516 10.68 8.289 10 6 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/>
			  <path fill-rule="evenodd" d="M13.5 5a.5.5 0 0 1 .5.5V7h1.5a.5.5 0 0 1 0 1H14v1.5a.5.5 0 0 1-1 0V8h-1.5a.5.5 0 0 1 0-1H13V5.5a.5.5 0 0 1 .5-.5z"/>
			</svg>
			인원
		</td>
		<td>
			&nbsp;<%=Num %> 명
		</td>
	</tr>
	<tr>
		<td>
			<!-- 예상 비용 -->
			<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-cash-coin" viewBox="0 0 16 16">
			  <path fill-rule="evenodd" d="M11 15a4 4 0 1 0 0-8 4 4 0 0 0 0 8zm5-4a5 5 0 1 1-10 0 5 5 0 0 1 10 0z"/>
			  <path d="M9.438 11.944c.047.596.518 1.06 1.363 1.116v.44h.375v-.443c.875-.061 1.386-.529 1.386-1.207 0-.618-.39-.936-1.09-1.1l-.296-.07v-1.2c.376.043.614.248.671.532h.658c-.047-.575-.54-1.024-1.329-1.073V8.5h-.375v.45c-.747.073-1.255.522-1.255 1.158 0 .562.378.92 1.007 1.066l.248.061v1.272c-.384-.058-.639-.27-.696-.563h-.668zm1.36-1.354c-.369-.085-.569-.26-.569-.522 0-.294.216-.514.572-.578v1.1h-.003zm.432.746c.449.104.655.272.655.569 0 .339-.257.571-.709.614v-1.195l.054.012z"/>
			  <path d="M1 0a1 1 0 0 0-1 1v8a1 1 0 0 0 1 1h4.083c.058-.344.145-.678.258-1H3a2 2 0 0 0-2-2V3a2 2 0 0 0 2-2h10a2 2 0 0 0 2 2v3.528c.38.34.717.728 1 1.154V1a1 1 0 0 0-1-1H1z"/>
			  <path d="M9.998 5.083 10 5a2 2 0 1 0-3.132 1.65 5.982 5.982 0 0 1 3.13-1.567z"/>
			</svg>
			예상비용
		</td>
		<td>
			&nbsp;<%=Cost %> 원
		</td>
	</tr>
	<tr>
		<td>
			<!-- 관광지 명 -->
			<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-pin-map-fill" viewBox="0 0 16 16">
			  <path fill-rule="evenodd" d="M3.1 11.2a.5.5 0 0 1 .4-.2H6a.5.5 0 0 1 0 1H3.75L1.5 15h13l-2.25-3H10a.5.5 0 0 1 0-1h2.5a.5.5 0 0 1 .4.2l3 4a.5.5 0 0 1-.4.8H.5a.5.5 0 0 1-.4-.8l3-4z"/>
			  <path fill-rule="evenodd" d="M4 4a4 4 0 1 1 4.5 3.969V13.5a.5.5 0 0 1-1 0V7.97A4 4 0 0 1 4 3.999z"/>
			</svg>
			관광지명
		</td>
		<td>
			&nbsp;<%=sightName %>
		</td>
	</tr>
	<tr>
		<td>
			<!-- 세부 내용 -->
			<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-chat-square-dots-fill" viewBox="0 0 16 16">
			  <path d="M0 2a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2h-2.5a1 1 0 0 0-.8.4l-1.9 2.533a1 1 0 0 1-1.6 0L5.3 12.4a1 1 0 0 0-.8-.4H2a2 2 0 0 1-2-2V2zm5 4a1 1 0 1 0-2 0 1 1 0 0 0 2 0zm4 0a1 1 0 1 0-2 0 1 1 0 0 0 2 0zm3 1a1 1 0 1 0 0-2 1 1 0 0 0 0 2z"/>
			</svg>
			세부내용
		</td>
		<td>
			&nbsp;<%=Detail %>
		</td>
	</tr>
	</table><br>
	<div style="color: red; font-size: 13px; line-height:120%; text-align: center;"><p style="font-size: 15px">모임시간 / 장소 / 오픈채팅링크 / 참여자 정보</p>는 수락된 참여자에 한하여 열람 가능합니다.</div>
	<div style="border: 1px solid black; margin: 5px;">
		<!-- 여행 시간 -->
		<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-clock" viewBox="0 0 16 16">
		  <path d="M8 3.5a.5.5 0 0 0-1 0V9a.5.5 0 0 0 .252.434l3.5 2a.5.5 0 0 0 .496-.868L8 8.71V3.5z"/>
		  <path d="M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16zm7-8A7 7 0 1 1 1 8a7 7 0 0 1 14 0z"/>
		</svg>
		시간
		&nbsp;<%=Time %>
		<br>
		<!-- 집합 장소 -->
		<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-signpost" viewBox="0 0 16 16">
		  <path d="M7 1.414V4H2a1 1 0 0 0-1 1v4a1 1 0 0 0 1 1h5v6h2v-6h3.532a1 1 0 0 0 .768-.36l1.933-2.32a.5.5 0 0 0 0-.64L13.3 4.36a1 1 0 0 0-.768-.36H9V1.414a1 1 0 0 0-2 0zM12.532 5l1.666 2-1.666 2H2V5h10.532z"/>
		</svg>
		장소
		&nbsp;<%=Place %>
		<br>
		<!-- 오픈 채팅 링크 -->
		<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-link-45deg" viewBox="0 0 16 16">
		  <path d="M4.715 6.542 3.343 7.914a3 3 0 1 0 4.243 4.243l1.828-1.829A3 3 0 0 0 8.586 5.5L8 6.086a1.002 1.002 0 0 0-.154.199 2 2 0 0 1 .861 3.337L6.88 11.45a2 2 0 1 1-2.83-2.83l.793-.792a4.018 4.018 0 0 1-.128-1.287z"/>
		  <path d="M6.586 4.672A3 3 0 0 0 7.414 9.5l.775-.776a2 2 0 0 1-.896-3.346L9.12 3.55a2 2 0 1 1 2.83 2.83l-.793.792c.112.42.155.855.128 1.287l1.372-1.372a3 3 0 1 0-4.243-4.243L6.586 4.672z"/>
		</svg>
		오픈채팅방
		&nbsp;<%=Link %>
		<br>
	</div>
	<br>
	<div style="margin: 0 auto; text-align: right;">
		<form name="frmDeleteTrip" action="deleteTrip.jsp" method="get" style="display: inline;">
			<button type="button" <%if(tripStatus.equals("삭제") || tripStatus.equals("취소")){ %>disabled = "disabled"<%} %> onClick="checkDelete();" style="line-height:25px; display: inline-block; border-radius: 6px; background-color: rgba(66, 133, 244, 0.3); height: 25px;">삭제</button>
			<input type="hidden" name="membId" value="<%=memb_id %>" />
			<input type="hidden" name="tripId" value="<%=tripid %>" />
		</form>
	</div>
	<br>
	<div style="color: red; font-size: 13px; line-height:200%; text-align: center;">수락된 참여자가 있으면 여행 삭제가 불가능합니다.</div>
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
						<input type="hidden" name="membId" value="<%=memb_id %>" />
					</form>
				</div>
			</td>
			<td style="font-size: 13px;">
				<div style="margin: 0 auto; text-align: center;">
				<%
				sql = "SELECT PRG_STATUS FROM TRIP_JOIN_LIST "+
						"WHERE TRIP_ID = " + tripid + " "+
						"AND MEMB_ID = '" + participantId + "' ";
				
				rs = conn.prepareStatement(sql).executeQuery();
				rs.next();
				String PRG_STATUS = rs.getString("PRG_STATUS");
				if(PRG_STATUS.equals("신청")) {
				%>
					<p id="status"></p>
					<div id="button">
						<form name="frmAccept" method="get" onsubmit="return confirm('수락하시겠습니까?');" style="display: inline;" action="acceptReject.jsp">		
							<button type="submit" style="display: inline-block; background-color: rgba(0,0,0,0); border: 0; outline: 0; text-decoration-line: underline;">수락</button>
							<input type="hidden" name="tripId" value="<%=tripid %>" />
							<input type="hidden" name="participantId" value="<%=participantId %>" />
							<input type="hidden" name="membId" value="<%=memb_id %>" />
							<input type="hidden" name="acceptReject" value="수락" />
						</form>
						|
						<form name="frmReject" method="get" onsubmit="return confirm('거절하시겠습니까?');" style="display: inline;" action="acceptReject.jsp">
							<button type="submit" style="display: inline-block; background-color: rgba(0,0,0,0); border: 0; outline: 0; text-decoration-line: underline;">거절</button>
							<input type="hidden" name="tripId" value="<%=tripid %>" />
							<input type="hidden" name="participantId" value="<%=participantId %>" />
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
		<%}%>
	</table> 
	<script type="text/javascript">
		function checkDelete() {
			<%
			sql = String.format( "select * from TRIP_JOIN_LIST where TRIP_ID = '%s' and MEMB_ID != '%s' and PRG_STATUS = '수락'", trip_id, memb_id);
			res = conn.prepareStatement(sql).executeQuery();
			if(res.next()){%>
				{
					alert("수락된 참여자가 존재해 여행 삭제가 불가능합니다.");
				}
			<% } else {%>
				{
					var result = confirm("삭제하시겠습니까?");
					if(result){
						document.frmDeleteTrip.submit();
						return true;
					}
					else{
						return false;
					}
				}
			<%}
			
			%>
		}
	</script>
	<%
	res.close();
	conn.close();
	%>
</body>
</html>