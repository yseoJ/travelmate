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
	
	sql = String.format("SELECT * FROM SIGHTS_INFO WHERE SIGHTS_ID = '%s'", sight_id);
	res = conn.prepareStatement(sql).executeQuery();
	res.next();
	
	String sightId = res.getString("SIGHTS_ID");
	String sightName = res.getString("SIGHTS_NM");
	String sightAddr = res.getString("SIGHTS_ADDR");
	String sightTraf = res.getString("SIGHTS_TRAFFIC");
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
	
	<title>Make Trip</title>
</head>
<body style="line-height: 100%">
	<div style="background-color: transparent; top: 5px;">
		<div style="position: absolute; left: 10px; top: 5px; z-index: 2;">
			<a href="#" onClick="history.go(-1); return false;">
				<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-arrow-left" viewBox="0 0 16 16">
				  <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8z"/>
				</svg>
			</a>
		</div>
		<div style="margin: auto; position: relative; top: 12px; text-align: center; z-index: 1;">
			<p style="font-size: 22px; font-weight: bold; font-color: block;">여행 계획하기</p>
		</div>
	</div>
	<br><br>
	<form name="frmMakeTrip" action="makeTripCheck.jsp" method="get" >
		<div class="makeTripInput">
			<div style="width:100%; height:25px; float:left; line-height: 25px;">제목</div><input type="text" name="Title" id="txtTitle" value=""/><br><br>
			<div style="width:100%; height:25px; float:left; line-height: 25px;">여행날짜</div><input type="date" name="Date" id="Date"/><br><br>
			<div style="border: 1px solid black;"><br>
				<p style="color: red; font-size: 13px;">*모임시간,장소,오픈채팅링크는<br>수락이 결정된 참여자에 한하여 열람 가능합니다.</p><br>
				<div style="width:100%; height:25px; float:left; line-height: 25px;">모임시간</div><input type="time" name="Time" /><br><br>
				<div style="width:100%; height:25px; float:left; line-height: 25px;">모임장소</div><input type="text" name="Place" id="txtPlace" value=""/><br><br>
				<div style="width:100%; height:25px; float:left; line-height: 25px;">오픈채팅방</div><input type="text" name="Link" id="txtLink" value="" /><br>
				<p style="color: gray; font-size: 13px;">*참여자와의 연락을 위해 올바르게 입력해주세요.</p><br>
			</div><br>
			<div style="width:100%; height:25px; float:left; line-height: 25px;">모객인원</div>
			<div>
				<select name="Num" size="1">
					<option value="">--</option>
					<option value="2">2</option>
					<option value="3">3</option>
					<option value="4">4</option>
					<option value="5">5</option>
					<option value="6">6</option>
					<option value="7">7</option>
					<option value="8">8</option>
				</select>
				명
			</div>
			<p style="color: gray; font-size: 13px;">*주최자를 포함한 인원수를 입력해주세요.</p><br>
			<div style="width:100%; height:25px; float:left; line-height: 25px;">예상비용</div><input type="number" name="Cost" id="txtCost" value=""/><br><br>
			<div style="width:100%; height:25px; float:left; line-height: 25px;">관광지명</div><div style="border: 2px solid black; width : 90%; display:inline-block; line-height: 25px;"> <%=sightName %> </div>
			<br><br><div style="width:100%; height:25px; float:left; line-height: 25px;">주소</div><div style="border: 2px solid black; width : 90%; display:inline-block; line-height: 25px;"> <%=sightAddr %> </div>
			<br><br><div style="width:100%; height:25px; float:left; line-height: 25px;">교통정보</div><div style="border: 2px solid black; width : 90%; display:inline-block; line-height: 25px;"> <%=sightTraf %> </div>
			<br><br><div style="width:100%; height:25px; float:left; line-height: 25px;">세부정보</div><textarea name="Detail" id="txtDetail" rows="7" style="border: 2px solid black; border-radius: 30px; padding: 0 1em; width:90%; font-size:15px;"></textarea><br><br><br><br><br>
		</div><br><br>
		<footer style="position: fixed; bottom: 0; width: 100%;">
		<div style="margin: auto; text-align: center;">
			<!-- 여행 개설 -->
			<button class="makeTripButton" type="button" onClick="checkPlan();">개설하기</button>
			<input type="hidden" name="membId" value="<%=memb_id %>" />
			<input type="hidden" name="sightId" value="<%=sight_id %>" />
		</div>
		</footer>	
	</form>
	
	<script type="text/javascript">
		
		var today = new Date();
		var tomorrow = new Date();
		var day = today.getDate() + 1;		//최소 일자를 내일로 설정
		var month = today.getMonth() + 1;	// 1월이 0부터 시작하여 1을 더해준다.
		var year = today.getFullYear();
		if (day < 10) day = '0' + day;
		if (month < 10) month = '0' + month;
		tomorrow = year + '-' + month + '-' + day;

		document.getElementById("Date").setAttribute("min", tomorrow);
		
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
		function checkPlan(){
			var f = document.frmMakeTrip;
			if (isEmpty(f.Title, "제목을 입력하세요")) return;
			if (isEmpty(f.Date, "여행날짜를 입력하세요")) return;
			if (isEmpty(f.Time, "모임시간을 입력하세요")) return;
			if (isEmpty(f.Place, "모임장소를 입력하세요")) return;
			if (isEmpty(f.Link, "오픈채팅방링크를 입력하세요")) return;
			if (isEmpty(f.Num, "모객인원을 입력하세요")) return;
			if (isEmpty(f.Cost, "예상비용을 입력하세요")) return;
			if (isEmpty(f.Detail, "세부정보를 입력하세요")) return;
			
			f.submit();	
		}

	</script>
</body>
</html>