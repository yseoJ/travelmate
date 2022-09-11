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
	
	String memb_id = request.getParameter("MembId");
	String trip_id = request.getParameter("TripId");
	String trip_close = request.getParameter("TripClose");
	String join_num = request.getParameter("JoinNum");
	
	sql = "SELECT t.SIGHTS_ID, t.MEMB_ID, t.TRIP_TITLE, "+
				"TO_CHAR (t.TRIP_MEET_DATE, 'YYYY-MM-DD (DY)') TRIP_MEET_DATE, "+
				"t.TOT_NUM, t.PLAN_COST, t.TRIP_DETAIL, "+
				"m.FULL_NM, s.SIGHTS_NM, s.SIGHTS_ADDR, s.SIGHTS_TRAFFIC, s.SIGHTS_CLAS "+
			"FROM TRIP_INFO t LEFT OUTER JOIN MEMB_INFO m ON t.MEMB_ID = m.MEMB_ID "+
							"LEFT OUTER JOIN SIGHTS_INFO s ON t.SIGHTS_ID = s.SIGHTS_ID "+
			"WHERE t.TRIP_ID = '" + trip_id + "' ";
	res = conn.prepareStatement(sql).executeQuery();
	res.next();
	
	String HostId = res.getString("MEMB_ID");
	String sightId = res.getString("SIGHTS_ID");
	String title = res.getString("TRIP_TITLE");
	String tripDate = res.getString("TRIP_MEET_DATE");
	String totNum = res.getString("TOT_NUM");
	String cost = res.getString("PLAN_COST");
	String detail = res.getString("TRIP_DETAIL");
	
	String sightName = res.getString("SIGHTS_NM");
	String sightAddr = res.getString("SIGHTS_ADDR");
	String sightTraf = res.getString("SIGHTS_TRAFFIC");
	String sightClas = res.getString("SIGHTS_CLAS");

	String HostNM = res.getString("FULL_NM");
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
	
	<!-- 부트스트랩 자바스크립트 추가하기 -->
	<script src="./js/bootstrap.min.js"></script>
	<!-- 제이쿼리 자바스크립트 추가하기 -->
	<script src="./js/jquery.min.js"></script>
	<!-- 파퍼 자바스크립트 추가하기 -->
	<script src="./js/pooper.js"></script>
	
	<title>TRIP INFO</title>
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
			<p style="font-size: 20px; font-weight: bold; font-color: block;">여행 상세정보</p>
		</div>
	</div><br>
	<div style="width: 95%; height: 130px; overflow: hidden; margin: 0 auto; border-radius: 12px;">
		<img style="width: 100%; height: 100%; object-fit: cover;" src="image/<%=sightId %>.jpg" onerror="this.src='image/0.png'";>
	</div>
	<div class="tripInfo">
		<div class="tripInfoTitle"><%=title %></div>
		<table class="tripTable">
		<tr>
			<td class="tripInfoLeft">
				<!-- 여행 날짜 -->
				<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-calendar-event" viewBox="0 0 16 16">
				  <path d="M11 6.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1z"/>
				  <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5zM1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4H1z"/>
				</svg>
				<div style="font-size: 12px; line-height: 100%">여행날짜</div>
			</td>
			<td style="vertical-align: middle;">
				&nbsp;<%=tripDate %>
			</td>
		</tr>
		<tr>
			<td class="tripInfoLeft">
				<!-- 모집 인원 -->
				<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-person-plus" viewBox="0 0 16 16">
				  <path d="M6 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0zm4 8c0 1-1 1-1 1H1s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C9.516 10.68 8.289 10 6 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/>
				  <path fill-rule="evenodd" d="M13.5 5a.5.5 0 0 1 .5.5V7h1.5a.5.5 0 0 1 0 1H14v1.5a.5.5 0 0 1-1 0V8h-1.5a.5.5 0 0 1 0-1H13V5.5a.5.5 0 0 1 .5-.5z"/>
				</svg>
				<div style="font-size: 12px; line-height: 100%">모집인원</div>
			</td>
			<td style="vertical-align: middle;">
				&nbsp; <%=join_num %> / <%=totNum %>
			</td>
		</tr>
		<tr>
			<td class="tripInfoLeft">
				<!-- 예상 비용 -->
				<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-cash-coin" viewBox="0 0 16 16">
				  <path fill-rule="evenodd" d="M11 15a4 4 0 1 0 0-8 4 4 0 0 0 0 8zm5-4a5 5 0 1 1-10 0 5 5 0 0 1 10 0z"/>
				  <path d="M9.438 11.944c.047.596.518 1.06 1.363 1.116v.44h.375v-.443c.875-.061 1.386-.529 1.386-1.207 0-.618-.39-.936-1.09-1.1l-.296-.07v-1.2c.376.043.614.248.671.532h.658c-.047-.575-.54-1.024-1.329-1.073V8.5h-.375v.45c-.747.073-1.255.522-1.255 1.158 0 .562.378.92 1.007 1.066l.248.061v1.272c-.384-.058-.639-.27-.696-.563h-.668zm1.36-1.354c-.369-.085-.569-.26-.569-.522 0-.294.216-.514.572-.578v1.1h-.003zm.432.746c.449.104.655.272.655.569 0 .339-.257.571-.709.614v-1.195l.054.012z"/>
				  <path d="M1 0a1 1 0 0 0-1 1v8a1 1 0 0 0 1 1h4.083c.058-.344.145-.678.258-1H3a2 2 0 0 0-2-2V3a2 2 0 0 0 2-2h10a2 2 0 0 0 2 2v3.528c.38.34.717.728 1 1.154V1a1 1 0 0 0-1-1H1z"/>
				  <path d="M9.998 5.083 10 5a2 2 0 1 0-3.132 1.65 5.982 5.982 0 0 1 3.13-1.567z"/>
				</svg>
				<div style="font-size: 12px; line-height: 100%">예상비용</div>
			</td>
			<td style="vertical-align: middle;">
				&nbsp;<%=cost %> 원
			</td>
		</tr>
		<tr>
			<td class="tripInfoLeft">
				<!-- 관광지 명 -->
				<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-pin-map-fill" viewBox="0 0 16 16">
				  <path fill-rule="evenodd" d="M3.1 11.2a.5.5 0 0 1 .4-.2H6a.5.5 0 0 1 0 1H3.75L1.5 15h13l-2.25-3H10a.5.5 0 0 1 0-1h2.5a.5.5 0 0 1 .4.2l3 4a.5.5 0 0 1-.4.8H.5a.5.5 0 0 1-.4-.8l3-4z"/>
				  <path fill-rule="evenodd" d="M4 4a4 4 0 1 1 4.5 3.969V13.5a.5.5 0 0 1-1 0V7.97A4 4 0 0 1 4 3.999z"/>
				</svg>
				<div style="font-size: 12px; line-height: 100%">관광지명</div>
			</td>
			<td style="vertical-align: middle;">
				&nbsp;<%=sightName %>
				<div class="star-ratings">
					<div class="star-ratings-base space-x-2 text-lg" style="display: inline-block;">
						&nbsp;<span>★</span><span>★</span><span>★</span><span>★</span><span>★</span>
					</div>
				<% 
					String score = null;
					sql = "SELECT SIGHTS_SCORE "+
							"FROM SIGHTS_SCORE "+
							"WHERE SIGHTS_ID = '" + sightId + "' ";
					res = conn.prepareStatement(sql).executeQuery();
					if(res.next()){
						sql = "SELECT ROUND(AVG(SIGHTS_SCORE), 1) score "+
								"FROM SIGHTS_SCORE "+
								"WHERE SIGHTS_ID = '" + sightId + "' ";
						res = conn.prepareStatement(sql).executeQuery();
						res.next();
						score = res.getString("score");
						double scoreForStar = Double.valueOf(score);
						scoreForStar = scoreForStar/100.0*5.0;
					%>           
						<div class="star-ratings-fill space-x-2 text-lg" style="width: <%=score %>% !important;">
							&nbsp;<span>★</span><span>★</span><span>★</span><span>★</span><span>★</span>
						</div>
						<div style="display: inline; font-size: 10px; color: black;">(<%=scoreForStar %>)</div>
					<%}else{%>
						<div style="display: inline; font-size: 10px; color: black;">(-)</div>
					<%}
				%>
				</div>
			</td>
		</tr>
		<tr>
			<td class="tripInfoLeft">
				<!-- 세부 내용 -->
				<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-chat-square-dots-fill" viewBox="0 0 16 16">
				  <path d="M0 2a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2h-2.5a1 1 0 0 0-.8.4l-1.9 2.533a1 1 0 0 1-1.6 0L5.3 12.4a1 1 0 0 0-.8-.4H2a2 2 0 0 1-2-2V2zm5 4a1 1 0 1 0-2 0 1 1 0 0 0 2 0zm4 0a1 1 0 1 0-2 0 1 1 0 0 0 2 0zm3 1a1 1 0 1 0 0-2 1 1 0 0 0 0 2z"/>
				</svg>
				<div style="font-size: 12px; line-height: 100%">세부내용</div>
			</td>
			<td style="vertical-align: middle;">
				&nbsp;<%=detail %>
			</td>
		</tr>
		<tr>
			<td class="tripInfoLeft">
				<!-- 주소 -->
				<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-geo-alt-fill" viewBox="0 0 16 16">
				  <path d="M8 16s6-5.686 6-10A6 6 0 0 0 2 6c0 4.314 6 10 6 10zm0-7a3 3 0 1 1 0-6 3 3 0 0 1 0 6z"/>
				</svg>
				<div style="font-size: 12px; line-height: 100%">주소</div>
			</td>
			<td style="vertical-align: middle; font-size: 12px !important;">
				&nbsp;<%=sightAddr %>
			</td>
		</tr>
		<tr>
			<td class="tripInfoLeft">
				<!-- 교통 정보 -->
				<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-cursor" viewBox="0 0 16 16">
				  <path d="M14.082 2.182a.5.5 0 0 1 .103.557L8.528 15.467a.5.5 0 0 1-.917-.007L5.57 10.694.803 8.652a.5.5 0 0 1-.006-.916l12.728-5.657a.5.5 0 0 1 .556.103zM2.25 8.184l3.897 1.67a.5.5 0 0 1 .262.263l1.67 3.897L12.743 3.52 2.25 8.184z"/>
				</svg>
				<div style="font-size: 12px; line-height: 100%">교통정보</div>
			</td>
			<td style="vertical-align: middle; font-size: 12px !important;">
				&nbsp;<%=sightTraf %>
			</td>
		</tr>
		</table>
	</div>
	<div style="color: blue; margin-left: 3%;"> #<%=sightClas %></div>
	<br>
	<div style="margin-left: 10px;">
	<!-- 주최자 -->
		<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-person-circle" viewBox="0 0 16 16">
		  <path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
		  <path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z"/>
		</svg>
		<p style="font-size:10px; display:inline-block;">주최자</p>
		&nbsp;<%=HostNM %>
		<form name="frmHostInfo" action="hostInfo.jsp" method="get" style="display: inline;">
			<button type="submit" style="background-color: rgba(0,0,0,0); border: 0; outline: 0; text-decoration-line: underline;">자세히</button>
			<input type="hidden" name="participantId" value="<%=HostId %>" />
			<input type="hidden" name="membId" value="<%=memb_id %>" />
		</form>
	</div><br><br><br>
	<footer style="position: fixed; bottom: 0; width: 100%;">
		<!-- 여행 참여 -->
		<form name="frmJoin" method="get" action="joinFinish.jsp">
			<input type="hidden" name="membId" value="<%=memb_id %>" />
			<input type="hidden" name="tripId" value="<%=trip_id %>" />
		</form>
		<div style="margin: auto; text-align: center;">
			<%if ("마감".equals(trip_close)) { %>
				<button class="joinTrip" type='button' disabled='disabled'>마감</button>
			<%} else{ %>
				<button class="joinTrip" type="submit" onclick="openJoin()">참여하기</button>
			<%} %>
		</div>
	</footer>

	<script type="text/javascript">
		function openJoin() {
			<%
			sql = String.format( "select * from TRIP_JOIN_LIST where TRIP_ID = '%s' and MEMB_ID = '%s'", trip_id, memb_id);
			res = conn.prepareStatement(sql).executeQuery();
			if(res.next()){%>
				{
					alert("이미 신청한 여행입니다.");
				}
			<% } else {%>
				{
					var result = confirm("여행에 참여를 신청하시겠습니까?");
					if(result){
						document.frmJoin.submit();
						return true;
					}
					else{
						return false;
					}
				}
			<%}
			res.close();
			conn.close();
			%>
		}
	</script>
</body>
</html>