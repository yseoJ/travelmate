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
	ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />
	<!-- 부트스트랩 CSS 추가하기 -->
	<link rel="stylesheet" href="./css/bootstrap.min.css">
	<!-- 커스텀 CSS 추가하기 -->
	<link rel="stylesheet" href="./css/custom.css">
	
	<!-- 부트스트랩 자바스크립트 추가하기 -->
	<script src="./js/bootstrap.min.js"></script>
	<!-- 제이쿼리 자바스크립트 추가하기 -->
	<script src="./js/jquery.min.js"></script>
	<!-- 파퍼 자바스크립트 추가하기 -->
	<script src="./js/pooper.js"></script>
	
	<title>TRAVELMATE</title>
</head>
<body>
	<nav class="navbar navbar-expand-lg navbar-light bg-light" style="justify-content: right !important">
		<a class="navbar-brand" href="index.jsp">TRAVELMATE</a>
		<div style="margin-left:90px; margin-right:10px;">
			<svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-person" viewBox="0 0 16 16">
	  			<path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0zm4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/>
			</svg>
		</div>
	</nav>
	<form class="form-inline my-2-my-lg-0">
		<input class="form-control mr-sm-2" type="search" placeholder="내용을 입력하세요" aria-label="Search"  style="width:80%; height:40px; float:left;">
		<button class="btn btn-outline-success my-2 my-sm-0" type="submit" style="width:20%; height:40px; float:right; margin: 0px !important">검색</button>
	</form>
	<br><br><br>
	<h4> 여행 목록 </h4>  
	
	    <%     
	    sql = "SELECT TRIP_TITLE, TO_CHAR(TRIP_MEET_DATE, 'YYYY/MM/DD') TRIP_MEET_DATE,  TOT_NUM FROM TRIP_INFO  ORDER BY TRIP_MEET_DATE" ;
	    rs = conn.prepareStatement(sql).executeQuery();
	    System.out.print(rs.next());
		
	    while(rs.next()) {            
	      String TRIP_TITLE = rs.getString("TRIP_TITLE");
	      String TRIP_MEET_DATE = rs.getString("TRIP_MEET_DATE");   
	      String TOT_NUM = rs.getString("TOT_NUM");
	      System.out.print(sql);
		%>
		<br>
		<table style="width: 100%; border: 1px solid #000;">
		<tr>
			<td>제목 : <%=TRIP_TITLE%>
			<br>날짜 : <%=TRIP_MEET_DATE%>
			<br>참여 인원 : <%=TOT_NUM%></td>
		</tr>   
		</table>
        <%
	    }
     	rs.close();
  		conn.close();
		%>             
</body>
</html>