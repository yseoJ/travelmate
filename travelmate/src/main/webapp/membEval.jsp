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
	String participant_id = request.getParameter("participantId");
	String trip_id = request.getParameter("tripId");
	
	sql = String.format("SELECT FULL_NM FROM MEMB_INFO WHERE MEMB_ID = '%s'", participant_id);
	res = conn.prepareStatement(sql).executeQuery();
	res.next();
	
	String Name = res.getString("FULL_NM");

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
	<br><h2 style="text-align: center"> <%=Name %>님 평가하기 </h2>
	<hr>
	<form name="frmEval" method="get" action="evalFinish.jsp">
		<div style="text-align: center;"><a style="font-weight:bold; margin: auto;">만족도 평가</a></div><br>
		<div class="rating" style="text-align: center; border: 2px solid;">
			<label for="super-sad" style="padding: 8px">
		 		<input type="radio" name="rating" class="super-sad" id="super-sad" value="super-sad" />
				<svg width="50px" height="50px" viewBox="0 0 24 24"><path d="M12,2C6.47,2 2,6.47 2,12C2,17.53 6.47,22 12,22A10,10 0 0,0 22,12C22,6.47 17.5,2 12,2M12,20A8,8 0 0,1 4,12A8,8 0 0,1 12,4A8,8 0 0,1 20,12A8,8 0 0,1 12,20M16.18,7.76L15.12,8.82L14.06,7.76L13,8.82L14.06,9.88L13,10.94L14.06,12L15.12,10.94L16.18,12L17.24,10.94L16.18,9.88L17.24,8.82L16.18,7.76M7.82,12L8.88,10.94L9.94,12L11,10.94L9.94,9.88L11,8.82L9.94,7.76L8.88,8.82L7.82,7.76L6.76,8.82L7.82,9.88L6.76,10.94L7.82,12M12,14C9.67,14 7.69,15.46 6.89,17.5H17.11C16.31,15.46 14.33,14 12,14Z" /></svg>
		  	</label>
	        <label for="sad" style="padding: 8px">
				<input type="radio" name="rating" class="sad" id="sad" value="sad" />
				<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" width="50px" height="50px" viewBox="0 0 24 24"><path d="M20,12A8,8 0 0,0 12,4A8,8 0 0,0 4,12A8,8 0 0,0 12,20A8,8 0 0,0 20,12M22,12A10,10 0 0,1 12,22A10,10 0 0,1 2,12A10,10 0 0,1 12,2A10,10 0 0,1 22,12M15.5,8C16.3,8 17,8.7 17,9.5C17,10.3 16.3,11 15.5,11C14.7,11 14,10.3 14,9.5C14,8.7 14.7,8 15.5,8M10,9.5C10,10.3 9.3,11 8.5,11C7.7,11 7,10.3 7,9.5C7,8.7 7.7,8 8.5,8C9.3,8 10,8.7 10,9.5M12,14C13.75,14 15.29,14.72 16.19,15.81L14.77,17.23C14.32,16.5 13.25,16 12,16C10.75,16 9.68,16.5 9.23,17.23L7.81,15.81C8.71,14.72 10.25,14 12,14Z" /></svg>
			</label>
			<label for="neutral" style="padding: 8px">
				<input type="radio" name="rating" class="neutral" id="neutral" value="neutral" />
				<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" width="50px" height="50px" viewBox="0 0 24 24"><path d="M8.5,11A1.5,1.5 0 0,1 7,9.5A1.5,1.5 0 0,1 8.5,8A1.5,1.5 0 0,1 10,9.5A1.5,1.5 0 0,1 8.5,11M15.5,11A1.5,1.5 0 0,1 14,9.5A1.5,1.5 0 0,1 15.5,8A1.5,1.5 0 0,1 17,9.5A1.5,1.5 0 0,1 15.5,11M12,20A8,8 0 0,0 20,12A8,8 0 0,0 12,4A8,8 0 0,0 4,12A8,8 0 0,0 12,20M12,2A10,10 0 0,1 22,12A10,10 0 0,1 12,22C6.47,22 2,17.5 2,12A10,10 0 0,1 12,2M9,14H15A1,1 0 0,1 16,15A1,1 0 0,1 15,16H9A1,1 0 0,1 8,15A1,1 0 0,1 9,14Z" /></svg>
			</label>
			<label for="happy" style="padding: 8px">
				<input type="radio" name="rating" class="happy" id="happy" value="happy" />
				<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" width="50px" height="50px" viewBox="0 0 24 24"><path d="M20,12A8,8 0 0,0 12,4A8,8 0 0,0 4,12A8,8 0 0,0 12,20A8,8 0 0,0 20,12M22,12A10,10 0 0,1 12,22A10,10 0 0,1 2,12A10,10 0 0,1 12,2A10,10 0 0,1 22,12M10,9.5C10,10.3 9.3,11 8.5,11C7.7,11 7,10.3 7,9.5C7,8.7 7.7,8 8.5,8C9.3,8 10,8.7 10,9.5M17,9.5C17,10.3 16.3,11 15.5,11C14.7,11 14,10.3 14,9.5C14,8.7 14.7,8 15.5,8C16.3,8 17,8.7 17,9.5M12,17.23C10.25,17.23 8.71,16.5 7.81,15.42L9.23,14C9.68,14.72 10.75,15.23 12,15.23C13.25,15.23 14.32,14.72 14.77,14L16.19,15.42C15.29,16.5 13.75,17.23 12,17.23Z" /></svg>
			</label>
			<label for="super-happy" style="padding: 8px">
			  <input type="radio" name="rating" class="super-happy" id="super-happy" value="super-happy" />
			  <svg width="50px" height="50px" viewBox="0 0 24 24"><path d="M12,17.5C14.33,17.5 16.3,16.04 17.11,14H6.89C7.69,16.04 9.67,17.5 12,17.5M8.5,11A1.5,1.5 0 0,0 10,9.5A1.5,1.5 0 0,0 8.5,8A1.5,1.5 0 0,0 7,9.5A1.5,1.5 0 0,0 8.5,11M15.5,11A1.5,1.5 0 0,0 17,9.5A1.5,1.5 0 0,0 15.5,8A1.5,1.5 0 0,0 14,9.5A1.5,1.5 0 0,0 15.5,11M12,20A8,8 0 0,1 4,12A8,8 0 0,1 12,4A8,8 0 0,1 20,12A8,8 0 0,1 12,20M12,2C6.47,2 2,6.5 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2Z" /></svg>
			 </label>
		</div>
		<br>
		<hr>
		<div style="text-align: center;"><a style="font-weight:bold; margin: auto;">매너 평가</a></div><br>
		<ul class="list">
		    <li class="list__item">
		      <label class="manner1">
		          <input type="checkbox" class="checkbox" name="checkedValue" value="1" />시간 약속을 잘 지켜요
		      </label>
		    </li>
		    <li class="list__item">
		      <label class="manner2">
		          <input type="checkbox" class="checkbox" name="checkedValue" value="2" />유머러스해요
		      </label>
		    </li>
		    <li class="list__item">
		      <label class="manner3">
		          <input type="checkbox" class="checkbox" name="checkedValue" value="3" />성격이 밝아요
		      </label>
		    </li>
		    <li class="list__item">
		      <label class="manner4">
		          <input type="checkbox" class="checkbox" name="checkedValue" value="4" />적극적으로 참여해요
		      </label>
		    </li>
		    <li class="list__item">
		      <label class="manner5">
		          <input type="checkbox" class="checkbox" name="checkedValue" value="5" />소통이 잘 돼요
		      </label>
		    </li>
		    <li class="list__item">
		      <label class="manner6">
		          <input type="checkbox" class="checkbox" name="checkedValue" value="6" />연락을 잘 받아요
		      </label>
		    </li>
		    <li class="list__item">
		      <label class="manner7">
		          <input type="checkbox" class="checkbox" name="checkedValue" value="7" />청결해요
		      </label>
		    </li>
		    <li class="list__item">
		      <label class="manner8">
		          <input type="checkbox" class="checkbox" name="checkedValue" value="8" />리더쉽이 있어요
		      </label>
		    </li>
		    <li class="list__item">
		      <label class="manner9">
		          <input type="checkbox" class="checkbox" name="checkedValue" value="9" />아는 것이 많아요
		      </label>
		    </li>
		    <li class="list__item">
		      <label class="manner10">
		          <input type="checkbox" class="checkbox" name="checkedValue" value="10" />매너가 좋아요
		      </label>
		    </li>
		</ul>
		<br>
		<hr>
		<div style="text-align: center;"><a style="font-weight:bold; margin: auto;">비매너 평가</a></div><br>
		<ul class="list">
		    <li class="list__item">
		      <label class="nomanner1">
		          <input type="checkbox" class="checkbox" name="checkedValue" value="101" />약속에 나오지 않았어요
		      </label>
		    </li>
		    <li class="list__item">
		      <label class="nomanner2">
		          <input type="checkbox" class="checkbox" name="checkedValue" value="102" />약속 시간을 지키지 않았어요
		      </label>
		    </li>
		    <li class="list__item">
		      <label class="nomanner3">
		          <input type="checkbox" class="checkbox" name="checkedValue" value="103" />연락을 잘 안 받아요
		      </label>
		    </li>
		    <li class="list__item">
		      <label class="nomanner4">
		          <input type="checkbox" class="checkbox" name="checkedValue" value="104" />여행에 적극적으로 참여하지 않아요
		      </label>
		    </li>
		    <li class="list__item">
		      <label class="nomanner5">
		          <input type="checkbox" class="checkbox" name="checkedValue" value="105" />매너가 좋지 않아요
		      </label>
		    </li>
		</ul>
		<br><br><br>
		<footer style="position: fixed; bottom: 0; width: 100%;">
			<button class="Eval" type="button" onClick="checkEval();">평가하기</button>
			<input type="hidden" name="membId" value="<%=memb_id %>" />
			<input type="hidden" name="participantId" value="<%=participant_id %>" />
			<input type="hidden" name="tripId" value="<%=trip_id %>" />
		</footer>
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
			if (isEmpty(f.rating, "만족도를 골라주세요")) return;
			
			f.submit();	
		}
	</script>
</body>
</html>