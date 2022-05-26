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
	
	String memb_id = request.getParameter("memb_id");
	String trip_id = request.getParameter("trip_id");

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
	
	<title>joinPopup</title>
</head>
<body>
	<h2 style="text-align: center; background-color: rgba(66, 133, 244, 0.5); height: 30px; line-height: 30px;">참여 신청</h2>
	<br><div  style="margin: 0 auto; text-align: center;">여행에 참여를 신청하시겠습니까?</div><br>
	<div style="margin: 0 auto; text-align: center;">
		<button onClick="window.close();" style=" display: inline-block; border-radius: 6px; background-color: white; height: 25px;">아니요</button>
		<button onClick="join();" style=" display: inline-block; border-radius: 6px; background-color: rgba(51, 150, 51, 0.3); height: 25px;">네</button>
	</div>
	
	<script type="text/javascript">
		function join() {
			<%
			sql = String.format( "select * from TRIP_JOIN_LIST where TRIP_ID = '%s' and MEMB_ID = '%s'", trip_id, memb_id);
			res = conn.prepareStatement(sql).executeQuery();
			//System.out.println(res.next());
			
			if(!res.next()){
				sql = String.format( "Insert into TRIP_JOIN_LIST (TRIP_ID,MEMB_ID,PRG_STATUS)  values ('%s','%s','신청')", trip_id, memb_id); 
				conn.prepareStatement(sql).executeUpdate();
			}

			res.close();
			conn.close();
			%>
			openWindow('joinFinish.jsp','joinFinish','200','150','0','0');
		}
		function openWindow(url,name,w,h,top,left) {
			window.open(url,name,"width="+w+",height="+h+",scrollbars=yes,resizable=no,status=no,top="+top+",left="+left);
			window.close(); 
		}
	</script>
</body>
</html>