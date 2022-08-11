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
	
	String memb_id = request.getParameter("membId");
	String[] checkedValue = request.getParameterValues("checkedValue");
	//기존 관심 태그 모두 삭제 후 재등록
	sql = "DELETE FROM MEMB_HOPE_LIST WHERE MEMB_ID = '" + memb_id + "' ";
	conn.prepareStatement(sql).executeUpdate();
	if(checkedValue != null){
		for(int i = 0; i < checkedValue.length; i++) {
			sql = String.format( "INSERT INTO MEMB_HOPE_LIST (MEMB_ID,TAG_ID) values ('%s',to_number('%s'))",
					memb_id, checkedValue[i]); 
			System.out.println(sql);
			conn.prepareStatement(sql).executeUpdate();
		}
	}


	//res.close();
	//conn.close();
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
	
	<title>Change Interest Finish</title>
</head>
<body style="line-height: 100%">
	<br><br><br><br>
	<div style="font-size: 20px; font-weight: bold; text-align:center;"><a>수정이 완료되었습니다.</a></div>
	<br><br><br>
	<div style="margin: 0 auto; text-align: center; height: 100px;">
		<form name="frm" action="myPage.jsp" method="get" >
			<button onClick="location.href='myPage.jsp'" style=" display: inline-block; border-radius: 6px; background-color: rgba(66, 133, 244, 0.3); height: 25px;">확인</button>
			<input type="hidden" name="MembId" value="<%=memb_id %>" />
		</form>
	</div>
</body>
</html>