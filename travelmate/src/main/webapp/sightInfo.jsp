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
	String sight_id = request.getParameter("sightId");
	
	sql = "SELECT SIGHTS_ID, SIGHTS_NM, SIGHTS_CLAS, NVL(SIGHTS_ADDR, '-') SIGHTS_ADDR , NVL(SIGHTS_PHONE_NUM, '-') SIGHTS_PHONE_NUM, "+
			"NVL(SIGHTS_WEBSITE, '-') SIGHTS_WEBSITE, NVL(SIGHTS_TIME, '-') SIGHTS_TIME, NVL(SIGHTS_WEEK, '-') SIGHTS_WEEK, "+
			"NVL(SIGHTS_OFF, '-') SIGHTS_OFF, NVL(SIGHTS_TRAFFIC, '-') SIGHTS_TRAFFIC "+
			"FROM SIGHTS_INFO WHERE SIGHTS_ID = '" + sight_id + "' ";
	res = conn.prepareStatement(sql).executeQuery();
	res.next();
	
	String sightId = res.getString("SIGHTS_ID");
	String sightName = res.getString("SIGHTS_NM");
	String sightAddr = res.getString("SIGHTS_ADDR");
	String sightTraf = res.getString("SIGHTS_TRAFFIC");
	String sightClas = res.getString("SIGHTS_CLAS");
	String sightPhone = res.getString("SIGHTS_PHONE_NUM");
	String sightWeb = res.getString("SIGHTS_WEBSITE");
	String sightTime = res.getString("SIGHTS_TIME");
	String sightWeek = res.getString("SIGHTS_WEEK");
	String sightOff = res.getString("SIGHTS_OFF");
	
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
	
	<title>SIGHTS INFO</title>
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
		<div style="margin: auto; position: relative; top: 5px; text-align: center; z-index: 1;">
			<p style="font-size: 20px; font-weight: bold; font-color: block;">관광지 상세정보</p>
		</div>
	</div><br>
	<div style="width: 95%; height: 130px; overflow: hidden; margin: 0 auto; border-radius: 12px;">
		<img style="width: 100%; height: 100%; object-fit: cover;" src="image/<%=sightId %>.jpg" onerror="this.src='image/0.png'";>
	</div>
	<div class="tripInfo">
		<div class="tripInfoTitle"><%=sightName %></div>
		<table class="tripTable">
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
			</td>
		</tr>
		<tr>
			<td class="tripInfoLeft">
				<!-- 테마 -->
				<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-bookmark-dash" viewBox="0 0 16 16">
				  <path fill-rule="evenodd" d="M5.5 6.5A.5.5 0 0 1 6 6h4a.5.5 0 0 1 0 1H6a.5.5 0 0 1-.5-.5z"/>
				  <path d="M2 2a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v13.5a.5.5 0 0 1-.777.416L8 13.101l-5.223 2.815A.5.5 0 0 1 2 15.5V2zm2-1a1 1 0 0 0-1 1v12.566l4.723-2.482a.5.5 0 0 1 .554 0L13 14.566V2a1 1 0 0 0-1-1H4z"/>
				</svg>
				<div style="font-size: 12px; line-height: 100%">테마</div>
			</td>
			<td style="vertical-align: middle;">
				&nbsp;<%=sightClas %>
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
			<td style="vertical-align: middle;">
				&nbsp;<%=sightAddr %>
			</td>
		</tr>
		<tr>
			<td class="tripInfoLeft">
				<!-- 전화번호 -->
				<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-telephone" viewBox="0 0 16 16">
				  <path d="M3.654 1.328a.678.678 0 0 0-1.015-.063L1.605 2.3c-.483.484-.661 1.169-.45 1.77a17.568 17.568 0 0 0 4.168 6.608 17.569 17.569 0 0 0 6.608 4.168c.601.211 1.286.033 1.77-.45l1.034-1.034a.678.678 0 0 0-.063-1.015l-2.307-1.794a.678.678 0 0 0-.58-.122l-2.19.547a1.745 1.745 0 0 1-1.657-.459L5.482 8.062a1.745 1.745 0 0 1-.46-1.657l.548-2.19a.678.678 0 0 0-.122-.58L3.654 1.328zM1.884.511a1.745 1.745 0 0 1 2.612.163L6.29 2.98c.329.423.445.974.315 1.494l-.547 2.19a.678.678 0 0 0 .178.643l2.457 2.457a.678.678 0 0 0 .644.178l2.189-.547a1.745 1.745 0 0 1 1.494.315l2.306 1.794c.829.645.905 1.87.163 2.611l-1.034 1.034c-.74.74-1.846 1.065-2.877.702a18.634 18.634 0 0 1-7.01-4.42 18.634 18.634 0 0 1-4.42-7.009c-.362-1.03-.037-2.137.703-2.877L1.885.511z"/>
				</svg>
				<div style="font-size: 12px; line-height: 100%">전화번호</div>
			</td>
			<td style="vertical-align: middle;">
				&nbsp;<%=sightPhone %>
			</td>
		</tr>
		<tr>
			<td class="tripInfoLeft">
				<!-- 웹사이트 -->
				<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-globe" viewBox="0 0 16 16">
				  <path d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm7.5-6.923c-.67.204-1.335.82-1.887 1.855A7.97 7.97 0 0 0 5.145 4H7.5V1.077zM4.09 4a9.267 9.267 0 0 1 .64-1.539 6.7 6.7 0 0 1 .597-.933A7.025 7.025 0 0 0 2.255 4H4.09zm-.582 3.5c.03-.877.138-1.718.312-2.5H1.674a6.958 6.958 0 0 0-.656 2.5h2.49zM4.847 5a12.5 12.5 0 0 0-.338 2.5H7.5V5H4.847zM8.5 5v2.5h2.99a12.495 12.495 0 0 0-.337-2.5H8.5zM4.51 8.5a12.5 12.5 0 0 0 .337 2.5H7.5V8.5H4.51zm3.99 0V11h2.653c.187-.765.306-1.608.338-2.5H8.5zM5.145 12c.138.386.295.744.468 1.068.552 1.035 1.218 1.65 1.887 1.855V12H5.145zm.182 2.472a6.696 6.696 0 0 1-.597-.933A9.268 9.268 0 0 1 4.09 12H2.255a7.024 7.024 0 0 0 3.072 2.472zM3.82 11a13.652 13.652 0 0 1-.312-2.5h-2.49c.062.89.291 1.733.656 2.5H3.82zm6.853 3.472A7.024 7.024 0 0 0 13.745 12H11.91a9.27 9.27 0 0 1-.64 1.539 6.688 6.688 0 0 1-.597.933zM8.5 12v2.923c.67-.204 1.335-.82 1.887-1.855.173-.324.33-.682.468-1.068H8.5zm3.68-1h2.146c.365-.767.594-1.61.656-2.5h-2.49a13.65 13.65 0 0 1-.312 2.5zm2.802-3.5a6.959 6.959 0 0 0-.656-2.5H12.18c.174.782.282 1.623.312 2.5h2.49zM11.27 2.461c.247.464.462.98.64 1.539h1.835a7.024 7.024 0 0 0-3.072-2.472c.218.284.418.598.597.933zM10.855 4a7.966 7.966 0 0 0-.468-1.068C9.835 1.897 9.17 1.282 8.5 1.077V4h2.355z"/>
				</svg>
				<div style="font-size: 12px; line-height: 100%">웹사이트</div>
			</td>
			<td style="vertical-align: middle;">
				&nbsp;<%=sightWeb %>
			</td>
		</tr>
		<tr>
			<td class="tripInfoLeft">
				<!-- 운영 시간 -->
				<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-clock-fill" viewBox="0 0 16 16">
				  <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zM8 3.5a.5.5 0 0 0-1 0V9a.5.5 0 0 0 .252.434l3.5 2a.5.5 0 0 0 .496-.868L8 8.71V3.5z"/>
				</svg>
				<div style="font-size: 12px; line-height: 100%">운영시간</div>
			</td>
			<td style="vertical-align: middle;">
				&nbsp;<%=sightTime %>
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
			<td style="vertical-align: middle;">
				&nbsp;<%=sightTraf %>
			</td>
		</tr>
		<tr>
			<td class="tripInfoLeft">운영요일</td>
			<td style="vertical-align: middle;"><%=sightWeek %></td>
		</tr>
		<tr>
			<td class="tripInfoLeft">휴무일</td>
			<td style="vertical-align: middle;"><%=sightOff %></td>
		</tr>
		<tr>
			<td class="tripInfoLeft">평가</td>
			<td style="vertical-align: middle;">
				<div class="star-ratings">
					<div class="star-ratings-base space-x-2 text-lg" style="display: inline-block;">
						<span>★</span><span>★</span><span>★</span><span>★</span><span>★</span>
					</div>
				<% 
					sql2 = "SELECT SIGHTS_SCORE "+
							"FROM SIGHTS_SCORE "+
							"WHERE SIGHTS_ID = '" + sightId + "' ";
					rs = conn.prepareStatement(sql2).executeQuery();
					if(rs.next()){
						sql2 = "SELECT ROUND(AVG(SIGHTS_SCORE), 1) score "+
								"FROM SIGHTS_SCORE "+
								"WHERE SIGHTS_ID = '" + sightId + "' ";
						rs = conn.prepareStatement(sql2).executeQuery();
						rs.next();
						double score = 0;
						score = rs.getDouble("score");
						double scoreForStar = 0;
						scoreForStar = score - 20;
						double scoreForStarscode = 0;
						scoreForStarscode = score/100*5;
					%>           
						<div class="star-ratings-fill space-x-2 text-lg" style="width: <%=scoreForStar %>% !important;">
							<span>★</span><span>★</span><span>★</span><span>★</span><span>★</span>
						</div>
						<div style="display: inline; font-size: 10px; color: black;">(<%=scoreForStarscode %>)</div>
					<%}else{%>
						<div style="display: inline; font-size: 10px; color: black;">(-)</div>
					<%}
				%>
				</div>
			</td>
		</tr>
		</table>
	</div>
	<div style="width: 95%; margin: auto; ">
		<%
		sql = "SELECT t.TAG_NM tagnm "+
				"FROM TAG_LIST t LEFT OUTER JOIN SIGHTS_TAG_LIST s "+
				"ON t.TAG_ID = s.TAG_ID "+
				"WHERE SIGHTS_ID = '" + sightId + "' ";
		res = conn.prepareStatement(sql).executeQuery();
		
	    while(res.next()) {            
	      String tagnm = res.getString("tagnm");
		%>
		<div style="display: inline-block; text-align:center; font-size: 15px; padding: 0px 3px 0px 3px; color: rgb(13, 45, 132);">
			#<%=tagnm%>
		</div>
		<%} 
	    res.close();
		conn.close();
		%>
	</div>
	<br><br><br>
	<footer style="position: fixed; bottom: 0; width: 100%; z-index: 1;">
	<!-- 여행 개설 -->
	<div style="margin: auto; text-align: center;">
		<form name="frmMakeTrip" action="makeTrip.jsp" method="get" >
			<button class="makeTripButton" type="submit">선택하기</button>
			<input type="hidden" name="membId" value="<%=memb_id %>" />
			<input type="hidden" name="sightId" value="<%=sight_id %>" />
		</form>												
	</div>
	</footer>
</body>
</html>