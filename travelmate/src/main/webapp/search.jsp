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
	String sql2 = "";
	
	
	Class.forName("oracle.jdbc.driver.OracleDriver");
	Connection conn = DriverManager.getConnection(url, user, pw);
	ResultSet res = null;
	ResultSet result = null;
	
	String id = request.getParameter("ID");
	String search = request.getParameter("search"); 

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
	
	<title>TRAVELMATE</title>
</head>
<body>
	<header style="position: fixed; top: 0; width: 100%; height:100px; z-index: 1">
		<nav class="navbar navbar-expand-lg navbar-light bg-light">
			<div style="display: inline; margin: 0; top: 5px; z-index: 2;">
				<a href="index.jsp?ID=<%=id %>">
					<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-house-door" viewBox="0 0 16 16">
					  <path d="M8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4.5a.5.5 0 0 0 .5-.5v-4h2v4a.5.5 0 0 0 .5.5H14a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146zM2.5 14V7.707l5.5-5.5 5.5 5.5V14H10v-4a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5v4H2.5z"/>
					</svg>
				</a>
			</div>
			<div style="margin: 0 auto; text-align: center;"><a class="navbar-brand" href="index.jsp?ID=<%=id %>">TRAVELMATE</a></div>
		</nav>
		<form class="form-inline my-2-my-lg-0" action="search.jsp" method="get">
			<input class="form-control mr-sm-2" name="search" type="search" placeholder="내용을 입력하세요" aria-label="Search" <%if (search != null && search.trim() != "") { %> value="<%=search %>"<%} %> style="width:80%; height:40px; float:left;">
			<button class="btn btn-outline-primary my-2 my-sm-0" type="submit" style="width:20%; height:40px; float:right; margin: 0px !important">검색</button>
			<input type="hidden" name="ID" value="<%=id %>" />
		</form>
		<br>
	</header>
	<main style="position: absolute; top: 100px; width:95%; margin-left:10px; ">
		<div class="myPageText">여행목록</div>
		
		
		<div class="include-past">
			<div class="form-element">
				<input type="checkbox" name="past" value="past" id="past">
				<label for="past">
					<div class="title">지난 여행 포함</div>
				</label>
			</div>
			<div class="form-element">
				<input type="checkbox" name="delete" value="delete" id="delete">
				<label for="delete">
					<div class="title">삭제 여행 포함</div>
				</label>
			</div>
			<div class="form-element">
				<input type="checkbox" name="cancel" value="cancel" id="cancel">
				<label for="cancel">
					<div class="title">취소 여행 포함</div>
				</label>
			</div>
		</div>
		
		<div id='result1' name="check" value="check"></div>
		<div id='result2' name="check" value="check"></div>
		<div id='result3' name="check" value="check"></div>
		<%     
	    sql = "SELECT x.TRIP_ID, x.SIGHTS_ID, x.TRIP_TITLE, x.TRIP_MEET_DATE, x.TOT_NUM, x.JOIN_NUM, "+
	          			"CASE WHEN join_num < tot_num THEN '모집중' "+
	          			"ELSE '마감' "+
	          			"END TRIP_CLOSE "+
				"FROM ( "+
	         			"SELECT m.TRIP_ID, m.TRIP_TITLE, TO_CHAR(m.TRIP_MEET_DATE, 'YYYY/MM/DD') TRIP_MEET_DATE,  m.TOT_NUM, m.SIGHTS_ID, "+
	                	"(SELECT COUNT(*) FROM TRIP_JOIN_LIST j WHERE j.TRIP_ID = m.TRIP_ID AND (PRG_STATUS = '수락' OR PRG_STATUS = '신청')) JOIN_NUM "+
	        			"FROM TRIP_INFO m "+
	        			"WHERE to_char(m.TRIP_MEET_DATE,'YYYY-MM-DD') > to_char(SYSDATE, 'YYYY-MM-DD') "+
	        			"AND m.TRIP_STATUS != '삭제' "+
	        			") x LEFT OUTER JOIN SIGHTS_INFO s ON x.SIGHTS_ID = s.SIGHTS_ID ";
	        	if (search != null && search.trim() != ""){
	        		search = search.trim();
		 			sql = sql + "WHERE x.TRIP_TITLE LIKE '%" + search + "%' "+
		        				"OR s.SIGHTS_NM LIKE '%" + search + "%' "+
					 			"OR s.SIGHTS_ADDR LIKE '%" + search + "%' "+
					 			"OR s.SIGHTS_CLAS LIKE '%" + search + "%' "+
					 			"OR s.SIGHTS_TRAFFIC LIKE '%" + search + "%' ";
	        	}
	    sql = sql + "ORDER BY TRIP_MEET_DATE ";
	    res = conn.prepareStatement(sql).executeQuery();
	    //System.out.print(rs.next());
		
	    while(res.next()) {            
	      String TRIP_TITLE = res.getString("TRIP_TITLE");
	      String TRIP_MEET_DATE = res.getString("TRIP_MEET_DATE");   
	      String TOT_NUM = res.getString("TOT_NUM");
	      String TRIP_ID = res.getString("TRIP_ID");
	      String TRIP_CLOSE = res.getString("TRIP_CLOSE");
	      String JOIN_NUM = res.getString("JOIN_NUM");
	      String SIGHTS_ID = res.getString("SIGHTS_ID");
	      //System.out.println(sql);
		%>
		<br>
		<form name="frmTripInfo" action="tripInfo.jsp" method="get" style="text-align: center;" >
			<button type="submit" class="trip_list_button_search">
			<div style="display: flex">
				<div style="flex: 3; float:left; width: 75%;">
					<br><div class="trip_list_title" style="color:black;"><%=TRIP_TITLE%></div>
					<br>
					<!-- 여행 날짜 -->
					<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="black" class="bi bi-calendar-event" viewBox="0 0 16 16">
					  <path d="M11 6.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1z"/>
					  <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5zM1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4H1z"/>
					</svg>
					<div style="font-size: 13px; display: inline-block;color:black;">&nbsp;<%=TRIP_MEET_DATE%></div>
					<br>
					<!-- 모집 인원 -->
					<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="black" class="bi bi-person-plus" viewBox="0 0 16 16">
					  <path d="M6 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0zm4 8c0 1-1 1-1 1H1s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C9.516 10.68 8.289 10 6 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/>
					  <path fill-rule="evenodd" d="M13.5 5a.5.5 0 0 1 .5.5V7h1.5a.5.5 0 0 1 0 1H14v1.5a.5.5 0 0 1-1 0V8h-1.5a.5.5 0 0 1 0-1H13V5.5a.5.5 0 0 1 .5-.5z"/>
					</svg>
					<div style="font-size: 13px; display: inline-block;color:black;">&nbsp;<%=JOIN_NUM %> / <%=TOT_NUM %></div>
					<br><br>
				</div>
				<div style="flex: 1;">
					<div style="text-align: center; margin-right: 5px; margin-top: 5px; margin-bottom: 5px; width: 100%; border: 2px solid <%if ("모집중".equals(TRIP_CLOSE)){%>green<%} else{%>red<%} %>;">
						<div style="color: <%if ("모집중".equals(TRIP_CLOSE)){%>green<%} else{%>red<%} %>; vertical-align: middle; margin: 5px;"><%=TRIP_CLOSE%></div>
					</div>
					<% 
					sql2 = "SELECT t.TAG_NM tagnm "+
							"FROM TAG_LIST t LEFT OUTER JOIN SIGHTS_TAG_LIST s "+
							"ON t.TAG_ID = s.TAG_ID "+
							"WHERE SIGHTS_ID = '" + SIGHTS_ID + "' ";
					result = conn.prepareStatement(sql2).executeQuery();
					
				    while(result.next()) {            
				      String tagnm = result.getString("tagnm");
					%>
					<div style="display: inline-block; border-radius: 18px; text-align:center; font-size: 12px; padding: 0px 5px 0px 5px; background-color: rgba(13, 45, 132); color: white;">
					#<%=tagnm%>
					</div>
					<%} %>
				</div>
			</div>
			</button>
			<input type="hidden" name="MembId" value="<%=id %>" />
			<input type="hidden" name="TripTitle" value="<%=TRIP_TITLE %>" />
			<input type="hidden" name="TripId" value="<%=TRIP_ID %>" />
			<input type="hidden" name="TripClose" value="<%=TRIP_CLOSE %>" />
			<input type="hidden" name="JoinNum" value="<%=JOIN_NUM %>" />
		</form>
	    <%
	    }
		%>

		<script type="text/javascript">
			$(document).ready(function(){
			    $("#past").change(function(){
			    	var p = document.getElementById('result1')
			        if($("#past").is(":checked")){
						p.innerHTML = "<br><div style=\"color: red; font-size: 15px;\">완료된 여행 목록입니다</div><br> "+
										<%
										    sql = "SELECT TRIP_ID, TRIP_TITLE, TO_CHAR(TRIP_MEET_DATE, 'YYYY-MM-DD') TRIP_MEET_DATE FROM TRIP_INFO WHERE TRIP_STATUS='완료' ORDER BY TRIP_MEET_DATE ";
										    res = conn.prepareStatement(sql).executeQuery();
										    while(res.next()) {       
										      String past_trip_id = res.getString("TRIP_ID");
										      String past_trip_title = res.getString("TRIP_TITLE");
										      String past_trip_date = res.getString("TRIP_MEET_DATE");%>
										      "<form name=\"frmTripInfo\" action=\"tripInfo.jsp\" method=\"get\" style=\"text-align: center;\" > "+
													"<button type=\"submit\" class=\"trip_list_button_search\" style=\"background-color: #ddd;\"> "+
													"<div style=\"display: flex\"> "+
														"<div style=\"flex: 3; float:left; width: 75%;\"> "+
															"<br><div class=\"trip_list_title\" style=\"color: black;\"><%=past_trip_title%></div> "+
															"<br> "+
															"<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"20\" height=\"20\" fill=\"black\" class=\"bi bi-calendar-event\" viewBox=\"0 0 16 16\"> "+
															  "<path d=\"M11 6.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1z\"/> "+
															  "<path d=\"M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5zM1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4H1z\"/> "+
															"</svg> "+
															"<div style=\"font-size: 13px; display: inline-block; color: black;\">&nbsp;<%=past_trip_date%></div> "+
															"<br><br> "+
														"</div> "+
														"<div style=\"flex: 1;\"> "+
															"<div style=\"text-align: center; margin-right: 5px; margin-top: 5px; margin-bottom: 5px; width: 100%; border: 2px solid red;\"> "+
																"<div style=\"color: red; vertical-align: middle; margin: 5px;\">완료</div> "+
															"</div> "+
														"</div> "+
													"</div> "+
													"</button> "+
													"<input type=\"hidden\" name=\"MembId\" value=\"<%=id %>\" /> "+
													"<input type=\"hidden\" name=\"TripTitle\" value=\"<%=past_trip_title %>\" /> "+
													"<input type=\"hidden\" name=\"TripId\" value=\"<%=past_trip_id %>\" /> "+
												"</form> "+
												"</br> "+
										   <% }
										    %>
										"";
			        }else{
			            p.innerHTML = "";
			        }
			    });
			    $("#delete").change(function(){
			    	var d = document.getElementById('result2')
			        if($("#delete").is(":checked")){
						d.innerHTML = "<br><div style=\"color: red; font-size: 15px;\">주최자가 삭제한 여행 목록입니다</div><br> "+
										<%
									    sql = "SELECT TRIP_ID, TRIP_TITLE, TO_CHAR(TRIP_MEET_DATE, 'YYYY-MM-DD') TRIP_MEET_DATE FROM TRIP_INFO WHERE TRIP_STATUS='삭제' ORDER BY TRIP_MEET_DATE ";
									    res = conn.prepareStatement(sql).executeQuery();
									    while(res.next()) {       
									      String delete_trip_id = res.getString("TRIP_ID");
									      String delete_trip_title = res.getString("TRIP_TITLE");
									      String delete_trip_date = res.getString("TRIP_MEET_DATE");%>
									      "<form name=\"frmTripInfo\" action=\"tripInfo.jsp\" method=\"get\" style=\"text-align: center;\" > "+
												"<button type=\"submit\" class=\"trip_list_button_search\" style=\"background-color: #ddd;\"> "+
												"<div style=\"display: flex\"> "+
													"<div style=\"flex: 3; float:left; width: 75%;\"> "+
														"<br><div class=\"trip_list_title\" style=\"color: black;\"><%=delete_trip_title%></div> "+
														"<br> "+
														"<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"20\" height=\"20\" fill=\"black\" class=\"bi bi-calendar-event\" viewBox=\"0 0 16 16\"> "+
														  "<path d=\"M11 6.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1z\"/> "+
														  "<path d=\"M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5zM1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4H1z\"/> "+
														"</svg> "+
														"<div style=\"font-size: 13px; display: inline-block; color: black;\">&nbsp;<%=delete_trip_date%></div> "+
														"<br><br> "+
													"</div> "+
													"<div style=\"flex: 1;\"> "+
														"<div style=\"text-align: center; margin-right: 5px; margin-top: 5px; margin-bottom: 5px; width: 100%; border: 2px solid red;\"> "+
															"<div style=\"color: red; vertical-align: middle; margin: 5px;\">삭제</div> "+
														"</div> "+
													"</div> "+
												"</div> "+
												"</button> "+
												"<input type=\"hidden\" name=\"MembId\" value=\"<%=id %>\" /> "+
												"<input type=\"hidden\" name=\"TripTitle\" value=\"<%=delete_trip_title %>\" /> "+
												"<input type=\"hidden\" name=\"TripId\" value=\"<%=delete_trip_id %>\" /> "+
											"</form> "+
											"</br> "+
									   <% }
									    %>
									"";
			        }else{
			            d.innerHTML = "";
			        }
			    });
			    $("#cancel").change(function(){
			    	var c = document.getElementById('result3')
			        if($("#cancel").is(":checked")){
						c.innerHTML = "<br><div style=\"color: red; font-size: 15px;\">참여자가 없어 취소된 여행 목록입니다</div><br> "+
										<%
									    sql = "SELECT TRIP_ID, TRIP_TITLE, TO_CHAR(TRIP_MEET_DATE, 'YYYY-MM-DD') TRIP_MEET_DATE FROM TRIP_INFO WHERE TRIP_STATUS='취소' ORDER BY TRIP_MEET_DATE ";
									    res = conn.prepareStatement(sql).executeQuery();
									    while(res.next()) {       
									      String cancel_trip_id = res.getString("TRIP_ID");
									      String cancel_trip_title = res.getString("TRIP_TITLE");
									      String cancel_trip_date = res.getString("TRIP_MEET_DATE");%>
									      "<form name=\"frmTripInfo\" action=\"tripInfo.jsp\" method=\"get\" style=\"text-align: center;\" > "+
												"<button type=\"submit\" class=\"trip_list_button_search\" style=\"background-color: #ddd;\"> "+
												"<div style=\"display: flex\"> "+
													"<div style=\"flex: 3; float:left; width: 75%;\"> "+
														"<br><div class=\"trip_list_title\" style=\"color: black;\"><%=cancel_trip_title%></div> "+
														"<br> "+
														"<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"20\" height=\"20\" fill=\"black\" class=\"bi bi-calendar-event\" viewBox=\"0 0 16 16\"> "+
														  "<path d=\"M11 6.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1z\"/> "+
														  "<path d=\"M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5zM1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4H1z\"/> "+
														"</svg> "+
														"<div style=\"font-size: 13px; display: inline-block; color: black\">&nbsp;<%=cancel_trip_date%></div> "+
														"<br><br> "+
													"</div> "+
													"<div style=\"flex: 1;\"> "+
														"<div style=\"text-align: center; margin-right: 5px; margin-top: 5px; margin-bottom: 5px; width: 100%; border: 2px solid red;\"> "+
															"<div style=\"color: red; vertical-align: middle; margin: 5px;\">취소</div> "+
														"</div> "+
													"</div> "+
												"</div> "+
												"</button> "+
												"<input type=\"hidden\" name=\"MembId\" value=\"<%=id %>\" /> "+
												"<input type=\"hidden\" name=\"TripTitle\" value=\"<%=cancel_trip_title %>\" /> "+
												"<input type=\"hidden\" name=\"TripId\" value=\"<%=cancel_trip_id %>\" /> "+
											"</form> "+
											"</br> "+
									   <% }
									    %>
									"";
			        }else{
			            c.innerHTML = "";
			        }
			    });
			});
		</script>
		<%
	   	res.close();
	 	conn.close();
		%>
	<br><br><br><br><br><br>
	</main>
	<footer style="position: fixed; bottom: 0px; width: 100%;">
	<div style="width: 100%; background-color: #f8f9fa; height: 50px; display: flex;">
		<!-- 진행/완료 여행 -->
		<div class="dropup">
		  <button class="dropbtn">
		  	<svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-list" viewBox="0 0 16 16">
				<path fill-rule="evenodd" d="M2.5 12a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5zm0-4a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5zm0-4a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5z"/>
			</svg>
		  </button>
		  <div id="myDropup" class="dropup-content">
		    <form name="frmMyTrip" action="allAcceptReject.jsp" method="get" >
				<button style="background-color:transparent; border: none;" type="submit">
					<a>참여자 수락/거절</a>
				</button>
				<input type="hidden" name="membId" value="<%=id %>" />
			</form>
		    <form name="frmMyTripPast" action="allEval.jsp" method="get" >
				<button style="background-color:transparent; border: none;" type="submit">
					<a>참여자 평가</a>
				</button>
				<input type="hidden" name="membId" value="<%=id %>" />
			</form>
		  </div>
		</div>
		<!-- 여행 개설 -->
		<div style="display: inline-block; margin: auto; flex: 1; text-align: center;">
			<form name="frmSightList" action="sightList.jsp" method="get" >
				<button type="submit" class="addTrip" style="color: black;">
					<svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-plus-lg" viewBox="0 0 16 16">
						<path fill-rule="evenodd" d="M8 2a.5.5 0 0 1 .5.5v5h5a.5.5 0 0 1 0 1h-5v5a.5.5 0 0 1-1 0v-5h-5a.5.5 0 0 1 0-1h5v-5A.5.5 0 0 1 8 2Z"/>
					</svg>
				</button>
				<input type="hidden" name="MembId" value="<%=id %>" />
			</form>
		</div>
		<!-- 마이페이지 -->
		<div style="display: inline-block; margin: auto; flex: 1; text-align: center;">
				<form name="frmMyPage" action="myPage.jsp" method="get" style="display:inline;">
					<button type="submit" class="myPage"">
					<svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="black" class="bi bi-person" viewBox="0 0 16 16">
			  			<path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0zm4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/>
					</svg>
					</button>
					<input type="hidden" name="MembId" value="<%=id %>" />
				</form>
		</div>
	</div>
	</footer>
</body>
</html>