<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    /* 한글 깨짐 방지 */
    request.setCharacterEncoding("UTF-8");

    /* db connection */
	
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet res = null;
	
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
	<nav class="navbar navbar-expand-lg navbar-light bg-light">
		<a class="navbar-brand" href="index.jsp">TRAVELMATE</a>
	</nav>
	<form class="form-inline my-2-my-lg-0">
		<input class="form-control mr-sm-2" type="search" placeholder="내용을 입력하세요" aria-label="Search"  style="width:80%; height:50px;">
		<button class="btn btn-outline-success my-2 my-sm-0" type="submit">검색</button>
	</form>
	<h2> 여행 목록 </h2>  
	<table border="1" width="50%">
		<tr>
			<th>제목</th>
			<th>날짜</th>
			<th>참여 인원</th>
		</tr>
	    <%     
	    try{
	    	String url = "jdbc:oracle:thin:@mytripdb.crd3fcdurp5u.ap-northeast-2.rds.amazonaws.com:1521:ORCL";
	    	String user = "trip";
	    	String pw = "trip";
	    	Class.forName("oracle.jdbc.driver.OracleDriver");
	    	conn = DriverManager.getConnection(url, user, pw);
	    	String sql = "SELECT TRIP_TITLE, TRIP_MEET_DATE,  TOT_NUM FROM TRIP_INFO  ORDER BY TRIP_MEET_DATE" ;
	    	pstmt = conn.prepareStatement(sql);
	    	res = pstmt.executeQuery();
		    
		    while (res.next()) {            
		      String TRIP_TITLE = res.getString("TRIP_TITLE");
		      String TRIP_MEET_DATE = res.getString("TRIP_MEET_DATE");   
		      String TOT_NUM = res.getString("TOT_NUM");
		    %>   
			<tr>
				<td><%=TRIP_TITLE%></td>
				<td><%=TRIP_MEET_DATE%></td>
				<td><%=TOT_NUM%></td>
			</tr>   
	        <%
	        }
	    } catch(SQLException e){
	    	e.printStackTrace();
	    } finally{
	    	if(res!=null)
	    		try{res.close();}catch(SQLException sqle){}
	    	if(pstmt!=null)
	    		try{pstmt.close();}catch(SQLException sqle){}
	    	if(conn != null)
	    		try{conn.close();}catch(SQLException sqle){}
	    }
      	%>    
      </table>             
</body>
</html>