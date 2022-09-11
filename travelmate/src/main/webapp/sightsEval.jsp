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
	String sight_id = request.getParameter("sightId");
	String trip_id = request.getParameter("tripId");
	
	sql = String.format("SELECT SIGHTS_NM FROM SIGHTS_INFO WHERE SIGHTS_ID = '%s'", sight_id);
	res = conn.prepareStatement(sql).executeQuery();
	res.next();
	
	String Name = res.getString("SIGHTS_NM");

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
	
	<title>EVALUATION</title>
</head>
<body style="line-height: 200%;">
	<div style="display: inline; position: relative; left: 10px; top: 5px;">
		<a href="#" onClick="history.go(-1); return false;">
			<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-arrow-left" viewBox="0 0 16 16">
			  <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8z"/>
			</svg>
		</a>
	</div>
	<br><div style="text-align: center; font-size: 20px; font-weight: bold;"> <%=Name %> 평가하기 </div>
	<br>
	<form name="frmEval" method="get" action="sightsEvalFinish.jsp" class="eval" name="myform" id="myform" method="post"> 
		<div style="text-align: center;">
			<fieldset>
				<input type="radio" name="reviewStar" value="5" id="5">
				<label for="5">★</label>
				<input type="radio" name="reviewStar" value="4" id="4">
				<label for="4">★</label>
				<input type="radio" name="reviewStar" value="3" id="3">
				<label for="3">★</label>
				<input type="radio" name="reviewStar" value="2" id="2">
				<label for="5">★</label>
				<input type="radio" name="reviewStar" value="1" id="1">
				<label for="1">★</label>
			</fieldset>
		</div>
		<br><br><br>
		<div style="margin: 0 auto; text-align: center;">
			<footer>
				<button class="Eval" type="button" onClick="checkEval();">평가하기</button>
				<input type="hidden" name="membId" value="<%=memb_id %>" />
				<input type="hidden" name="sightId" value="<%=sight_id %>" />
				<input type="hidden" name="tripId" value="<%=trip_id %>" />
			</footer>
		</div>
	</form>
	<script type="text/javascript">
		function isEmpty(obj, msg) {
			if (typeof obj == "string") {
				obj = document.querySelector("#" + obj);
			}
			if(obj.value == "") {
				alert(msg);
				obj.focus();
				return true;
			}
			return false;
		}
		function checkEval(){
			var f = document.frmEval;
			if (isEmpty(f.reviewStar, "별점을 선택해주세요")) return;
			
			f.submit();	
		}
	</script>
</body>
</html>