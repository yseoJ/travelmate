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
	
	<title>SIGHTS LIST</title>
</head>
<body>
	<br><h2 style="text-align: center">여행지 선택</h2>
	<hr>
	<form class="form-inline my-2-my-lg-0" action="searchSight.jsp">
		<input class="form-control mr-sm-2" name="search" type="search" placeholder="내용을 입력하세요" aria-label="Search"  style="width:80%; height:40px; float:left;">
		<button class="btn btn-outline-primary my-2 my-sm-0" type="submit" style="width:20%; height:40px; float:right; margin: 0px !important">검색</button>
		<input type="hidden" name="MembId" value="<%=memb_id %>" />
	</form>
	<br><br><br>
	<h4> * 여행 계획을 등록할 관광지를 선택하세요. </h4>
	<br>
	<table class="sights">
		<tr style=" background-color: rgba(66, 133, 244, 0.1);">
			<th>관광지 명</th>
			<th style="width: 150px; height: 20px; line-height: 20px;">지역</th>
			<th style="width: 50px; height: 20px; line-height: 20px;">테마</th>
			<th style="width: 60px; height: 20px; line-height: 20px;">선택</th>
		</tr>
		<%     
		    sql = "select * from SIGHTS_INFO order by SIGHTS_CLAS, SIGHTS_ADDR" ;
		    res = conn.prepareStatement(sql).executeQuery();
			
		    while(res.next()) {            
		      String sightName = res.getString("SIGHTS_NM");
		      String sightAddr = res.getString("SIGHTS_ADDR");   
		      String sightClas = res.getString("SIGHTS_CLAS");
		      String sightId = res.getString("SIGHTS_ID");
		      
		      String splitAddr = sightAddr.substring(0,10) + "...";
		%>
		<tr>
			<td style="font-size: 13px;"><%=sightName%></td>
			<td style="font-size: 13px;"><%=splitAddr%></td>
			<td><%=sightClas%></td>
			<td style="vertical-align:middle;">
				<form name="frmsightInfo" action="sightInfo.jsp" method="post" >
					<button type="submit" style="width: 100%; background-color: rgba(66, 133, 244, 0.5);">선택</button>
					<input type="hidden" name="sightId" value="<%=sightId %>" />
					<input type="hidden" name="membId" value="<%=memb_id %>" />
				</form>
			</td>
		</tr>
		<%
		    }
		    res.close();
	 		conn.close();
		%>
	</table> 
</body>
</html>