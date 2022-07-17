<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    /* 한글 깨짐 방지 */
    request.setCharacterEncoding("UTF-8");

    /* db connection */
	String user = "trip";
	String pw = "trip";
	String url = "jdbc:oracle:thin:@mytripdb.crd3fcdurp5u.ap-northeast-2.rds.amazonaws.com:1521:ORCL";
	String sql = "";
	Class.forName("oracle.jdbc.driver.OracleDriver");
	Connection conn = DriverManager.getConnection(url, user, pw);
	Statement stmt = conn.createStatement();
	ResultSet res;
	
	String query="";
	String id="";
	String name="";
	String email="";
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />
	<!-- 부트스트랩 CSS 추가하기 -->
	<link rel="stylesheet" href="./css/bootstrap.min.css">
	<!-- 커스텀 CSS 추가하기 -->
	<link rel="stylesheet" href="./css/custom.css?after">
	<meta name="google-signin-scope" content="profile email">
    <meta name="google-signin-client_id" content="120857777045-1oeeagtes07pmn0n2q2kfnvja770b2eg.apps.googleusercontent.com"/>
    <!-- <script src="https://apis.google.com/js/platform.js" async defer></script> -->
    <script src="https://apis.google.com/js/platform.js?onload=init" async defer></script>
    
    <!-- 부트스트랩 자바스크립트 추가하기 -->
	<script src="./js/bootstrap.min.js"></script>
    <!-- 제이쿼리 자바스크립트 추가하기 -->
	<script src="./js/jquery.min.js"></script>
	<!-- 파퍼 자바스크립트 추가하기 -->
	<script src="./js/pooper.js"></script>

	<title> 로그인 | travelmate </title>
</head>
<body style="background-color: rgba(66, 133, 244, 0.5);">
	<br><br><br>
	<h2 align="center" style="text-decoration: underline; text-decoration-style: wavy; text-underline-position: under;">TRAVELMATE</h2>
	<br><br><br><br><br><br>
	<div style="width: 150px; border: 5px solid blue; margin: 0 auto; border-radius: 20px;">
		<div class="g-signin2" data-onsuccess="onSignIn" style="text-align: center; margin: 10px;"></div>
   	</div>
    <script type="text/javascript">
	  //구글 로그인
      function onSignIn() {
        //var profile = gapi.auth2.getAuthInstance().currentUser.get().getBasicProfile();
        const googleuser = gapi.auth2.getAuthInstance().currentUser.get();   
        const profile = googleuser.getBasicProfile();
        
        const sookemail = "@sookmyung.ac.kr";
        
        if(!profile.getEmail().endsWith(sookemail)){
  			alert("해당 사이트는 숙명여자대학교 재학생만 사용 가능합니다.");
  			gapi.auth2.getAuthInstance().signOut();
  	  	} else {
	  	  	console.log("ID: " + profile.getId());
	        console.log('Full Name: ' + profile.getName());
	        console.log("Email: " + profile.getEmail());
	        
  	  		id = profile.getId();
  	  		name = profile.getName();
  	  		email = profile.getEmail();
		  	  		
  	  		$.ajax({ url: "checkId.jsp", // 클라이언트가 HTTP 요청을 보낼 서버의 URL 주소 
	  	  		data:{ 
	  	  				id: profile.getId(),
	  	  				name: profile.getName()
	  	  			}, // HTTP 요청과 함께 서버로 보낼 데이터 
	  	  		method: "GET", // HTTP 요청 메소드(GET, POST 등) 
	  	  		dataType: "json" // 서버에서 보내줄 데이터의 타입 
  	  		}) 
  	  		// HTTP 요청이 성공하면 요청한 데이터가 done() 메소드로 전달됨. 
  	  		.done(function(json) { 
  	  			console.debug(json);
  	  			if(json.isExist == 'expulsion'){
  	  				alert("신고 당한 계정이므로 더 이상 서비스를 사용할 수 없습니다.");
  	  				gapi.auth2.getAuthInstance().signOut();
  	  			} else if(json.isExist == 'true'){
  	  				//DB에 값이 존재하면
  	  				post_to_url("index.jsp", {'ID': id});
  	  			} else {
  	  				//존재하지 않으면
  	  	  			post_to_url("join.jsp", {'id': id, 'name': name, 'email': email});
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
    <br>
    <div style="text-align: center">
    	<a style="font-size: 0.5em;">*해당 사이트는 숙명여자대학교 계정으로만 접근 가능합니다.</a>
    </div>
</body>
</html>