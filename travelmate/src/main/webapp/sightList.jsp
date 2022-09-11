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
	
	String memb_id = request.getParameter("MembId");
	String search = request.getParameter("search");
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
	<div style="display: inline; position: relative; left: 10px; top: 5px;">
		<a href="index.jsp?ID=<%=memb_id %>">
			<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-house-door" viewBox="0 0 16 16">
			  <path d="M8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4.5a.5.5 0 0 0 .5-.5v-4h2v4a.5.5 0 0 0 .5.5H14a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146zM2.5 14V7.707l5.5-5.5 5.5 5.5V14H10v-4a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5v4H2.5z"/>
			</svg>
		</a>
	</div>
	<br><h2 style="text-align: center">여행지 선택</h2>
	<hr>
	<form class="form-inline my-2-my-lg-0" action="sightList.jsp" method="get">
		<input class="form-control mr-sm-2" name="search" type="search" placeholder="내용을 입력하세요" aria-label="Search" <%if (search != null && search.trim() != "") { %> value="<%=search %>"<%} %> style="width:80%; height:40px; float:left;">
		<button class="btn btn-outline-primary my-2 my-sm-0" type="submit" style="width:20%; height:40px; float:right; margin: 0px !important">검색</button>
		<input type="hidden" name="MembId" value="<%=memb_id %>" />
	</form>
	<br><br><br>
	<h4> * 여행 계획을 등록할 관광지를 선택하세요. </h4>
	<br>
	<hr style="background-color: rgba(13, 45, 132);"><br>
	<!-- 인기 TOP 관광지 -->
	<div class="myPageText">인기 TOP 관광지</div><br>
	<div class="wrap-vertical" style="padding: 0; border: none;">
		<%     
			sql2 = "SELECT ROWNUM, SIGHTS_ID "+
					"FROM (SELECT SIGHTS_ID, AVG(SIGHTS_SCORE) score "+
						    "FROM SIGHTS_SCORE "+
						    "GROUP BY SIGHTS_ID "+
						    "ORDER BY score DESC) "+
					"WHERE ROWNUM <= 10 ";

		    rs = conn.prepareStatement(sql2).executeQuery();
			
		    if(rs.next()) {
		    	do{
		    		String grade = rs.getString("ROWNUM");
		    		String top_sights_id = rs.getString("SIGHTS_ID");
		    		
					sql = "SELECT * FROM SIGHTS_INFO "+
							"WHERE SIGHTS_ID = '" + top_sights_id + "' ";
					res = conn.prepareStatement(sql).executeQuery();
					res.next();
					String sightName = res.getString("SIGHTS_NM");
					if(sightName.length() >= 8){
						sightName = sightName.substring(0,8) + "..";
					}
					%>
					<div class="box" style="display: inline-block;">
						<form name="frmTripInfo" action="sightInfo.jsp" method="get" style="float:left; margin:5px;">
							<button type="submit" style="overflow: hidden; border: 4px solid rgba(13, 45, 132); width: 170px; height: 40px; text-align: left; padding: 0px; color: block; background-color: white;">
								<div style="display: flex; width: 100%; height: 100%;">
									<div style="flex: 1; background-color: rgba(13, 45, 132); color: white; font-size: 16px; font-weight: bold; text-align: center;">
										<p style="margin-top: 10px; color: white;"><%=grade%></p>
									</div>
									<div style="flex: 3; color: black; font-size: 15px; font-weight: bold; margin-top: 10px;">&nbsp<%=sightName%></div>
								</div>
							</button>
							<input type="hidden" name="sightId" value="<%=top_sights_id %>" />
							<input type="hidden" name="membId" value="<%=memb_id %>" />
						</form>
					</div>
				<%
		    	}while(rs.next());
		    }
			%>
	</div>
	<br>
	<hr style="background-color: rgba(13, 45, 132);"><br>
	
	<table class="sights">
		<tr style=" background-color: rgb(13, 45, 132); color: white;">
			<th>관광지 명</th>
			<th style="width: 150px; height: 20px; line-height: 20px;">지역</th>
			<th style="width: 50px; height: 20px; line-height: 20px;">테마</th>
			<th style="width: 60px; height: 20px; line-height: 20px;">선택</th>
		</tr>
		<%     
		    sql = "SELECT * FROM SIGHTS_INFO ";
		    		if (search != null && search.trim() != ""){
		        		search = search.trim();
			 			sql = sql + "WHERE SIGHTS_NM LIKE '%" + search + "%' "+
			 			    	"OR SIGHTS_ADDR LIKE '%" + search + "%' "+
			 			    	"OR SIGHTS_CLAS LIKE '%" + search + "%' "+
			 			    	"OR SIGHTS_TRAFFIC LIKE '%" + search + "%' ";
		        	}
		    sql = sql + "ORDER BY SIGHTS_CLAS, SIGHTS_ADDR " ;
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
				<form name="frmsightInfo" action="sightInfo.jsp" method="get" >
					<button type="submit" style="width: 100%; background-color: transparent; border: 1px solid transparent"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-check" viewBox="0 0 16 16">
						<path d="M10.97 4.97a.75.75 0 0 1 1.07 1.05l-3.99 4.99a.75.75 0 0 1-1.08.02L4.324 8.384a.75.75 0 1 1 1.06-1.06l2.094 2.093 3.473-4.425a.267.267 0 0 1 .02-.022z"/>
					</svg></button>
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