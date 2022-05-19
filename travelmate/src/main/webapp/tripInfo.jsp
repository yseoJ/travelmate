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
	
	sql = String.format("SELECT MEMB_ID, SIGHTS_ID, TRIP_TITLE, TO_CHAR (TRIP_MEET_DATE, 'YYYY-MM-DD (DY)') TRIP_MEET_DATE, TOT_NUM, PLAN_COST, TRIP_DETAIL FROM TRIP_INFO WHERE TRIP_ID = '%s'", trip_id);
	res = conn.prepareStatement(sql).executeQuery();
	res.next();
	
	String makerId = res.getString("MEMB_ID");
	String sightId = res.getString("SIGHTS_ID");
	String title = res.getString("TRIP_TITLE");
	String tripDate = res.getString("TRIP_MEET_DATE");
	String totNum = res.getString("TOT_NUM");
	String cost = res.getString("PLAN_COST");
	String detail = res.getString("TRIP_DETAIL");
	
	sql = String.format("SELECT COUNT(MEMB_ID) JOIN_NUM FROM TRIP_JOIN_LIST WHERE TRIP_ID = '%s' AND PRG_STATUS = '수락'", trip_id);
	res = conn.prepareStatement(sql).executeQuery();
	res.next();
	
	String joinNum = res.getString("JOIN_NUM");
	
	sql = String.format("SELECT * FROM SIGHTS_INFO WHERE SIGHTS_ID = '%s'", sightId);
	res = conn.prepareStatement(sql).executeQuery();
	res.next();
	
	String sightName = res.getString("SIGHTS_NM");
	String sightAddr = res.getString("SIGHTS_ADDR");
	String sightTraf = res.getString("SIGHTS_TRAFFIC");
	String sightClas = res.getString("SIGHTS_CLAS");
	
	sql = String.format("SELECT * FROM MEMB_INFO WHERE MEMB_ID = '%s'", makerId);
	res = conn.prepareStatement(sql).executeQuery();
	res.next();
	
	String makerName = res.getString("FULL_NM");
	
	sql = String.format("SELECT * FROM MEMB_EVALUATION WHERE MEMB_ID = '%s'", makerId);
	res = conn.prepareStatement(sql).executeQuery();
	res.next();

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
	
	<title>TRIP_INFO</title>
</head>
<body style="line-height: 200%">
	<br><h2 style="text-align: center"> <%=title %> </h2>
	<hr>  
	여행 날짜 : <%=tripDate %>
	<br>모객 인원 : <%=totNum %> 명
	<br>참여 인원 : <%=joinNum %> 명
	<br>예상 비용 : <%=cost %> 원
	<br>관광지 명 : <%=sightName %>
	<br>주소 : <%=sightAddr %>
	<br>교통 정보 : <%=sightTraf %>
	<br>#<%=sightClas %>
	<br><br>세부 내용 : <%=detail %>
	<br><br>주최자 : <%=makerName %>
	<br>safety level :
	<br><br><br>
	<footer style="position: fixed; bottom: 0; width: 100%;">
		<!-- 여행 참여 -->
		<form name="frmJoin" method="post">
			<input type="hidden" name="memb_id" value="<%=memb_id %>" />
			<input type="hidden" name="trip_id" value="<%=trip_id %>" />
		</form>
		<button class="joinTrip" type="button" onclick="openJoin();">참여하기</button>
	</footer>

	<script type="text/javascript">
		function openJoin() {
			<%
			sql = String.format( "select * from TRIP_JOIN_LIST where TRIP_ID = '%s' and MEMB_ID = '%s'", trip_id, memb_id);
			res = conn.prepareStatement(sql).executeQuery();
			if(res.next()){%>
				{
					openWindow('joinExist.jsp','joinExist','250','150','0','0');
				}
			<% } else {%>
				{
					openWindow('joinPopup.jsp','joinPopup','250','150','0','0');
					document.frmJoin.target='joinPopup'; // 팝업창 윈도우 이름
					document.frmJoin.action = 'joinPopup.jsp'; // 팝업창 주소
					frmJoin.submit();
				}
			<%}
			res.close();
			conn.close();
			%>
		}
		function openWindow(url,name,w,h,top,left) {
			window.open(url,name,"width="+w+",height="+h+",scrollbars=yes,resizable=no,status=no,top="+top+",left="+left);
		}
	</script>
</body>
</html>