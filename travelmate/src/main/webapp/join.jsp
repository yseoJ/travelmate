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
	
	String id=request.getParameter("id");
	String name=request.getParameter("name");
	String email=request.getParameter("email");
	
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
	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

	<!-- 부트스트랩 자바스크립트 추가하기 -->
	<script src="./js/bootstrap.min.js"></script>
	<!-- 제이쿼리 자바스크립트 추가하기 -->
	<script src="./js/jquery.min.js"></script>
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	<!-- 파퍼 자바스크립트 추가하기 -->
	<script src="./js/pooper.js"></script>
	
	<script> $(function(){ $("#datepicker").datepicker(); }); </script>
	
	<title>Join</title>
</head>
<body>
	<br>
	<h2 align="center">회원가입</h2>
	<br><br>
	<!--  <a>아이디 : <%=id %></a><br> -->
	<a>이름 : <%=name %></a><br>
	<a>이메일 : <%=email %></a><br><br><br>
	
	<form name="InsertPerson" action="index.jsp" method="post" >
		<input type="hidden" name="ID" value="<%=id %>" />
		<input type="hidden" name="NAME" value="<%=name %>" />
		<input type="hidden" name="EMAIL" value="<%=email %>" />
		
		<label for="ADDM_YEAR">학번&emsp;&emsp;&emsp;</label><input type="number" name="ADDM_YEAR" oninput='handleOnInput(this, 2)'><br>
		<a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ex)19</a><br><br>
		
		<label>성별&emsp;&emsp;&emsp;</label>
		<input type="radio" name="GENDER" id="rdoGenderFemale" value="F" checked/><label for="rdoGenderFemale">&nbsp;여성</label>
	    <input type="radio" name="GENDER" id="rdoGenderMale" value="M" /><label for="rdoGenderMale">&nbsp;남성</label><br><br>
	    
		<label for="txtPhoneNum">핸드폰번호&nbsp;</label><input type="text" name="PHONE_NUM" id="txtPhoneNum" placeholder="01012345678" size="20" value="" pattern="[0-9]+" minlength="10" maxlength="11"/><br>
		<a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*숫자만 입력하세요</a> 
		<br><br><br>
		<footer style="position: fixed; bottom: 0; width: 100%;">
			<div class="d-grid gap-2">
				<button class="btn btn-primary btn-ls" type="button" onclick="checkJoin();">회원가입</button>
			</div>
		</footer>
	</form> 
	
	<script>
		function handleOnInput(el, maxlength) {
			if(el.value.length > maxlength)  {
				el.value  = el.value.substr(0, maxlength);
		  }
		}
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
		function checkPhone(firstPhone, msg2){
			if(firstPhone == "010"||"011"||"017"||"019"){
				return false;
			}
			alert(msg2);
			firstPhone.focus();
			return true;
		}
		function checkJoin(){
			var f = document.InsertPerson;
			if (isEmpty(f.ADDM_YEAR, "학번을 입력하세요")) return;
			if (isEmpty(f.PHONE_NUM, "핸드폰 번호를 입력하세요")) return;
			
			//if (f.PhoneNum.substr(0,3) != "010"){ alert("전화번호 형식이 잘못되었습니다"); }
			
			//if(checkPhone(firstPhone,"전화번호 형식이 잘못되었습니다")) return;
			
			f.submit();
			//adyear=Integer.parseInt(request.getParameter("ADDM_YEAR"));
			//phone=request.getParameter("Gender");
			//gender=request.getParameter("PhoneNum");
			//status="진행중";
			
		}

	</script>
</body>
</html>