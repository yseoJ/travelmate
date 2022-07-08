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
	
	String membId = request.getParameter("membId");

	sql = String.format("SELECT MBTI FROM MEMB_INFO WHERE MEMB_ID = '%s'", membId);
	res = conn.prepareStatement(sql).executeQuery();
	res.next();
	
	String MBTI = res.getString("MBTI");
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
	
	<title>MBTI</title>
</head>
<body style="line-height: 100%">
	<div style="display: inline; position: relative; left: 10px; top: 5px;">
		<a href="#" onClick="history.go(-1); return false;">
			<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-arrow-left" viewBox="0 0 16 16">
			  <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8z"/>
			</svg>
		</a>
	</div>
	<br><h2 style="text-align: center">MBTI</h2>
	<hr> 
	<div style="margin: 0 auto; text-align: center;">
		<form name="frmMBTI">
			<div class="inputMBTI">
				<input type="text" name="MBTI" id="txtMBTI" value="<%=MBTI %>"/><br><br>
			</div>
			<input type="hidden" name="membId" id="membId" value="<%=membId %>" />
			<button type="button" onClick="onChange();" style="line-height:25px; display: inline-block; border-radius: 6px; background-color: rgba(66, 133, 244, 0.3); height: 25px;">수정</button>
		</form>
		
	</div>
	
	<script type="text/javascript">
		function onChange() {
			var i = document.getElementById("membId").value;
			var m = document.getElementById("txtMBTI").value;
    	  
	  	  	console.log("ID: " + i);
	        console.log("MBTI: " + m);
	        
  	  		id = i;
  	  		mbti = m;
		  	  		
  	  		$.ajax({ url: "changeMBTI.jsp", // 클라이언트가 HTTP 요청을 보낼 서버의 URL 주소 
	  	  		data:{ 
	  	  				id: i,
	  	  				mbti: m
	  	  			}, // HTTP 요청과 함께 서버로 보낼 데이터 
	  	  		method: "GET", // HTTP 요청 메소드(GET, POST 등) 
	  	  		dataType: "json" // 서버에서 보내줄 데이터의 타입 
  	  		}) 
  	  		// HTTP 요청이 성공하면 요청한 데이터가 done() 메소드로 전달됨. 
  	  		.done(function(json) { 
  	  			console.debug(json);
	  	  		if(json.val == 'true'){
	  	  			post_to_url("myPage.jsp", {'MembId': id});
	  	  		}
	  	  		else{
	  	  			post_to_url("myPage.jsp", {'MembId': id});
	  	  		}
  	  		}) 
  	  		// HTTP 요청이 실패하면 오류와 상태에 관한 정보가 fail() 메소드로 전달됨. 
  	  		.fail(function(xhr, status, errorThrown) { 
  	  			$("#text").html("오류가 발생했다.<br>") 
  	  			.append("오류명: " + errorThrown + "<br>") 
  	  			.append("상태: " + status); 
  	  		}) 
  	  		// 
  	  		.always(function(xhr, status) { 
  	  			$("#text").html("요청이 완료되었습니다!"); 
  	  		});
      }
	  
	  function post_to_url(path, params, method) {
		  method = method||"get";		//DB에 저장한 임의의 계정으로 접근하기 위해 get 방식으로 설정
		  
		  var form = document.createElement("form");
		  form.setAttribute("method", method);
		  form.setAttribute("action", path);
		  
		  for(var key in params){
			  var hiddenField = document.createElement("input");
			  hiddenField.setAttribute("type", "hidden");
			  hiddenField.setAttribute("name", key);
			  hiddenField.setAttribute("value", params[key]);
			  
			  form.appendChild(hiddenField);
		  }
		  document.body.appendChild(form);
		  form.submit();
	  }

	  
    </script>
</body>
</html>