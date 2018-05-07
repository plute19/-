<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>흰둥이 책마당</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="../resources/css/default.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Lato">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script type="text/javascript" src="../resources/js/jquery-3.3.1.min.js"></script>
<script type="text/javascript">

$('document').ready(function() {
	$('body').on('click', closeSearchResult);
});

</script>
<script type="text/javascript" src="../resources/js/boardlist.js"></script>
<style type="text/css">
 #boardTable a:link { color: blue; text-decoration: none;}
 #boardTable a:visited { color: blue; text-decoration: none;}
 #boardTable a:hover { color: maroon; text-decoration: none;}
 #boardTable td {
 	text-align: center;
 }
 
</style>
<style>
body {font-family: "Lato", sans-serif}
.mySlides {display: none}
</style>
</head>

<body>

<!-- Navbar -->
<div class="w3-top">
	<div class="w3-bar w3-black w3-card">
		<a class="w3-bar-item w3-button w3-padding-large w3-hide-medium w3-hide-large w3-right" href="javascript:void(0)" onclick="myFunction()" title="Toggle Navigation Menu"><i class="fa fa-bars"></i></a>
		<a href="../" class="w3-bar-item w3-button w3-padding-large">HOME</a>
		<a href="../book/list" class="w3-bar-item w3-button w3-padding-large w3-hide-small">BOOK</a>
		<a href="list" class="w3-bar-item w3-button w3-padding-large w3-hide-small">게시판</a>
		<div class="w3-dropdown-hover w3-dropdown-user w3-hide-small">
			<button class="w3-padding-large w3-button" title="User"><i class="fa fa-user"></i><i class="fa fa-caret-down"></i></button>     
			<div class="w3-dropdown-content w3-dropdown-content-user w3-bar-block w3-card-4">
				<c:if test="${sessionScope.userEmail == null }">
					<a href="javascript:showLogin()" class="w3-bar-item w3-button">Login</a>
					<a href="javascript:openEmailCheck()" class="w3-bar-item w3-button">Join</a>
				</c:if>
				<c:if test="${sessionScope.userEmail != null }">
					<a href="../member/myPage" class="w3-bar-item w3-button">My Page</a>
					<a href="javascript:logout('../')" class="w3-bar-item w3-button">Logout</a>
				</c:if>
			</div>
	   </div>
	   <a class="w3-padding-large w3-hover-red w3-hide-small w3-right" id="searchButton-top" href="javascript:searchBook('../')"><i class="fa fa-search"></i></a>
		<div class="w3-dropdown-hover w3-dropdown-search w3-hide-small w3-right">
			<input type="text" class="w3-padding-large" id="searchBar" oninput="autoSearch('../')">    
			<div class="w3-dropdown-content w3-dropdown-content-search w3-bar-block w3-card-4" id="Div-searchResult"></div>
		</div>
	</div>
</div>

<!-- Navbar on small screens -->
<div id="navDemo" class="w3-bar-block w3-black w3-hide w3-hide-large w3-hide-medium w3-top" style="margin-top:46px">
	<a href="../book/list" class="w3-bar-item w3-button w3-padding-large">BOOK</a>
	<a href="list" class="w3-bar-item w3-button w3-padding-large">게시판</a>
	<c:if test="${sessionScope.userEmail == null }">
		<a href="javascript:showLogin()" class="w3-bar-item w3-button w3-padding-large">LOGIN</a>
		<a href="javascript:openEmailCheck()" class="w3-bar-item w3-button w3-padding-large">JOIN</a>
	</c:if>
	<c:if test="${sessionScope.userEmail != null }">
		<a href="../member/myPage" class="w3-bar-item w3-button w3-padding-large">My Page</a>
		<a href="javascript:logout('../')" class="w3-bar-item w3-button w3-padding-large">Logout</a>
	</c:if>
</div>

<!-- Page content -->
<div class="w3-content" style="max-width:2000px;margin-top:46px">
	
	<!-- 본문이 들어가는 div -->
	<div class="articleDIV">
		<h1>여기는 게시판</h1>
			
		<c:if test="${!empty updateResult}">
			<c:if test="${updateResult }">
				글이 수정되었습니다.
			</c:if>		
			<c:if test="${!updateResult }">
				오류가 발생했습니다...<br>
				오류가 계속될 경우 연락....
			</c:if>				
		</c:if>
		
		<c:if test="${!empty deleteResult}">
			<c:if test="${deleteResult }">
				글이 삭제되었습니다.
			</c:if>		
			<c:if test="${!deleteResult }">
				오류가 발생했습니다...<br>
				오류가 계속될 경우 연락....
			</c:if>				
		</c:if>			
		<br>
		<button onclick="location.href='list'">목록으로</button>
		
	</div>
	
<!-- login -->
<div id="login" class="w3-modal">
	<div class="w3-modal-content w3-animate-top w3-card-4">
		<header class="w3-container w3-teal w3-center w3-padding-32"> 
			<span onclick="document.getElementById('login').style.display='none'" class="w3-button w3-teal w3-xlarge w3-display-topright">×</span>
			<h2 class="w3-wide"><i class="fa fa-user"></i>로그인</h2>
		</header>
		<div class="w3-container">
  			<form id="login-form">
				<p><label> 계정(이메일)</label></p>
				<input class="w3-input w3-border" type="email" placeholder="Enter email" id="login-email" name="userEmail">
				<p><label> 비밀번호</label></p>
				<input class="w3-input w3-border" type="password" placeholder="Enter password" id="login-pw" name="userPassword">
				<input type="button" class="w3-button w3-block w3-teal w3-padding-16 w3-section w3-right" value="로그인" onclick="login('../')">
				<input type="button" class="w3-button w3-red w3-section" onclick="openEmailCheck()" value="회원 등록">
				<input type="button" class="w3-button w3-red w3-section" onclick="openFindPassword()" value="비밀번호 찾기">
				<p class="w3-right">Need <a href="#" class="w3-text-blue">help?</a></p>
			</form>   
		</div>
	</div>
</div>

<!-- join -->
<div id="join" class="w3-modal">
	<div class="w3-modal-content w3-animate-top w3-card-4">
		<header class="w3-container w3-teal w3-center w3-padding-32"> 
			<span onclick="document.getElementById('join').style.display='none'" class="w3-button w3-teal w3-xlarge w3-display-topright">×</span>
			<h2 class="w3-wide">
				<i class="fa fa-user"></i>회원 등록
			</h2>
		</header>
		<div class="w3-container">
			<form id="join-form">
				<p><label> 계정(이메일)</label></p>
				<input class="w3-input w3-border" type="email" placeholder="Enter email" id="join-email" name="userEmail" value="${sessionScope.joinEmail }" readonly="readonly">
				<p><label> 닉네임</label><span id="nicknameCheck"></span></p>
				<input class="w3-input w3-border" type="text" placeholder="Enter nickname" id="join-nickname" name="nickname" oninput="nicknameCheck('../', '')">
				<p><label> 비밀번호</label><span id="passwordCheck"></span></p>
				<input class="w3-input w3-border" type="password" placeholder="Enter password" id="join-pw" name="userPassword" oninput="passwordCheck()">
				<p><label> 비밀번호 확인</label><span id="passwordCheck2"></span></p>
				<input class="w3-input w3-border" type="password" placeholder="Enter password" id="join-pw2" name="userPassword2" oninput="passwordCheck()">
				<input type="button" class="w3-button w3-block w3-teal w3-padding-16 w3-section w3-right" onclick="join('../')" value="회원 등록">
				<input type="button" class="w3-button w3-red w3-section" onclick="document.getElementById('join').style.display='none'" value="닫기">
				<p class="w3-right">Need <a href="#" class="w3-text-blue">help?</a></p>
			</form>
		</div>
	</div>
</div>

<!-- verify - email -->
<div id="verify-email" class="w3-modal">
	<div class="w3-modal-content w3-animate-top w3-card-4">
		<header class="w3-container w3-teal w3-center w3-padding-32"> 
			<span onclick="document.getElementById('verify-email').style.display='none'" 
				class="w3-button w3-teal w3-xlarge w3-display-topright">×</span>
			<h2 class="w3-wide">
				<i class="fa fa-user"></i>이메일 확인
			</h2>
		</header>
		<div class="w3-container">
			<p>
				<label>계정으로 사용할 이메일</label>
				<span id="emailCheck"></span>
			</p>
			<input class="w3-input w3-border" type="email" placeholder="Enter email" id="verify-userEmail" 
				name="userEmail" oninput="emailCheck('../', '')">
			<input type="button" class="w3-button w3-block w3-teal w3-padding-16 w3-section w3-right" id="sendCode-button" 
				value="발송" onclick="sendCode('../')" disabled="disabled">
			<p><label>인증 코드 입력</label></p>
			<input class="w3-input w3-border" type="text" placeholder="Enter Code" id="verify-code" 
				name="userCode" disabled="disabled">
			<input type="button" class="w3-button w3-block w3-teal w3-padding-16 w3-section w3-right" value="확인" 
				id="submitCode-button" disabled="disabled" onclick="submitCode('../', '')">
			<p class="w3-right">Need <a href="#" class="w3-text-blue">help?</a></p>
		</div>
	</div>
</div>

<!-- find Password -->
<div id="find-password" class="w3-modal">
	<div class="w3-modal-content w3-animate-top w3-card-4">
		<header class="w3-container w3-teal w3-center w3-padding-32"> 
			<span onclick="document.getElementById('find-password').style.display='none'" 
				class="w3-button w3-teal w3-xlarge w3-display-topright">×</span>
			<h2 class="w3-wide">
				<i class="fa fa-user"></i>비밀번호 찾기
			</h2>
		</header>
		<div class="w3-container">
			<p>
				<label>계정(이메일)</label>
			</p>
			<input class="w3-input w3-border" type="email" placeholder="Enter email" 
				id="findPassword-email" name="userEmail">
			<input type="button" class="w3-button w3-block w3-teal w3-padding-16 w3-section w3-right" 
				id="findPassword-button" value="임시비밀번호 발급" onclick="findPassword('../')">
			<p class="w3-right">Need <a href="#" class="w3-text-blue">help?</a></p> 
		</div>
	</div>
</div>
  
</div>


<!-- Footer -->
<footer class="w3-container w3-padding-64 w3-center w3-opacity w3-light-grey w3-xlarge">
	<p class="w3-medium">Powered by Hindoog, 2018</p>
</footer>
<script type="text/javascript" src="../resources/js/common.js"></script>
</body>
</html>
