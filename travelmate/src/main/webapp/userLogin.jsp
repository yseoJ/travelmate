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
	<link rel="stylesheet" href="./css/custom.css">
	<meta name="google-signin-scope" content="profile email">
    <meta name="google-signin-client_id" content="120857777045-1oeeagtes07pmn0n2q2kfnvja770b2eg.apps.googleusercontent.com">
    <script src="https://apis.google.com/js/platform.js" async defer></script>
    
    <!-- 부트스트랩 자바스크립트 추가하기 -->
	<script src="./js/bootstrap.min.js"></script>
    <!-- 제이쿼리 자바스크립트 추가하기 -->
	<script src="./js/jquery.min.js"></script>
	<!-- 파퍼 자바스크립트 추가하기 -->
	<script src="./js/pooper.js"></script>
	
	<title> 로그인 | travelmate </title>
</head>
<body>
	<h2>로그인</h2>
	<div class="g-signin2" data-onsuccess="onSignIn"></div>
    <script type="text/javascript">
	  //구글 로그아웃
	  function signOut() {
	        var auth2 = gapi.auth2.getAuthInstance();
	        auth2.signOut().then(function(){
	      console.log('User signed out.'); 
	            });
	        auth2.disconnect();
	  }
	  
	  //구글 로그인
      function onSignIn() {
        var profile = gapi.auth2.getAuthInstance().currentUser.get().getBasicProfile();
        
        
        const sookemail = "@sookmyung.ac.kr";
        if(!profile.getEmail().endsWith(sookemail)){
  		  alert("해당 사이트는 숙명여자대학교 재학생만 사용 가능합니다.");
  		  history.back();
  	  	} else {
	  	  	console.log("ID: " + profile.getId());
	        console.log('Full Name: ' + profile.getName());
	        console.log("Email: " + profile.getEmail());
	        
  	  		id = profile.getId();
  	  		name = profile.getName();
  	  		email = profile.getEmail();
  	  		<%
  	  			String query = "select * from MEMB_INFO where MEMB_ID = '" + id + "'";
  	  			//res = conn.prepareStatement(sql).executeQuery();
  	  			res = stmt.executeQuery(query);
  	  		
	  	  		if(res.next()){%>
	  	  			post_to_url("index.jsp", {'id': id, 'name': name, 'email': email});
	  	  			//window.location.replace("index.jsp");
	  	  		<%} else {%>
			  	  	post_to_url("join.jsp", {'id': id, 'name': name, 'email': email});	
			  	  	//window.location.replace("join.jsp");
	  	  		<%}%>
  	  	}
      }
	  
	  function post_to_url(path, params, method) {
		  method = method||"post";
		  
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