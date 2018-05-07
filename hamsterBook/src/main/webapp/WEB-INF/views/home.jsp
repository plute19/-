<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>흰둥이 책마당</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="resources/css/default.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Lato">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script type="text/javascript" src="resources/js/jquery-3.3.1.min.js"></script>

<script type="text/javascript">
$('document').ready(function() {
	getBookList('', 1, 6, '', '', 'hit', 7, '');
	$('body').on('click', closeSearchResult);
	getSentence('', 1, 3, '', '', 'hit', 7, '');
});

//베스트 6 책 보여주기
function showBookList(result) {
	
	var html = '';
 
	$(result.bookList).each(function(i, book) {
		
		html += '<div class="w3-third book-cover"><p>' + book.title + '</p>';
		if (book.image != '') {
			html += ' <img src="' + book.image + '" class="w3-round w3-margin-bottom w3-hover-opacity w3-books"'
			html += 'alt="Book' + (i+1) + '" onclick="location.href=\'book/info?isbn=' + book.isbn + '\'"'
		} else {
			html += ' <img src="resources/images/book_default.png" class="w3-round w3-margin-bottom w3-hover-opacity w3-books"'
			html += 'alt="Book' + (i+1) + '" onclick="location.href=\'book/info?isbn=' + book.isbn + '\'"'
		}
		html += ' style="width:60%"></div>'
	});
	
	$('#best6-book').html(html);
}

//베스트 3 문장 보여주기
function showSentence(result) {
	
	var html = '<div class="w3-row-padding w3-padding-32" style="margin:0 -16px">';
	
	$(result.sentenceList).each(function(i, sentence) {
		
		html += '<div class="w3-third w3-margin-bottom">';
			html += '<div class="w3-container w3-white best3-sentence"';
			html += 'onclick="location.href=\'book/info?isbn=' + $(this).attr('isbn') + '\'"><p><b>' ;
			html += sentence.title + '</b></p><p class="w3-opacity">' + sentence.author + '</p>' ;
			html += '<p class="sentence-p">' + sentence.sentence + '</p></div></div>';
	});
	
	$('#best3-sentence').html(html);
	
}

</script>
<style>
body {font-family: "Lato", sans-serif}
.mySlides {display: none}
</style>
</head>

<body>

<!-- Navbar -->
<div class="w3-top">
	<div class="w3-bar w3-black w3-card">
		<a class="w3-bar-item w3-button w3-padding-large w3-hide-medium w3-hide-large w3-right" onclick="myFunction()" title="Toggle Navigation Menu"><i class="fa fa-bars"></i></a>
		<a href="#" class="w3-bar-item w3-button w3-padding-large">HOME</a>
		<a href="book/list" class="w3-bar-item w3-button w3-padding-large w3-hide-small">BOOK</a>
		<a href="board/list" class="w3-bar-item w3-button w3-padding-large w3-hide-small">게시판</a>
		<div class="w3-dropdown-hover w3-dropdown-user w3-hide-small">
			<button class="w3-padding-large w3-button" title="User"><i class="fa fa-user"></i><i class="fa fa-caret-down"></i></button>     
			<div class="w3-dropdown-content w3-dropdown-content-user w3-bar-block w3-card-4">
				<c:if test="${sessionScope.userEmail == null }">
					<a href="javascript:showLogin()" class="w3-bar-item w3-button">Login</a>
					<a href="javascript:openEmailCheck()" class="w3-bar-item w3-button">Join</a>
				</c:if>
				<c:if test="${sessionScope.userEmail != null }">
					<a href="member/myPage" class="w3-bar-item w3-button">My Page</a>
					<a href="javascript:logout('')" class="w3-bar-item w3-button" id="logout-button">Logout</a>
				</c:if>
			</div>
	   </div>
	   <a class="w3-padding-large w3-hover-red w3-hide-small w3-right" id="searchButton-top" href="javascript:searchBook('')"><i class="fa fa-search"></i></a>
		<div class="w3-dropdown-hover w3-dropdown-search w3-hide-small w3-right">
			<input type="text" class="w3-padding-large" id="searchBar" oninput="autoSearch('')">    
			<div class="w3-dropdown-content w3-dropdown-content-search w3-bar-block w3-card-4" id="Div-searchResult">
			</div>
		</div>
	</div>
</div>

<!-- Navbar on small screens -->
<div id="navDemo" class="w3-bar-block w3-black w3-hide w3-hide-large w3-hide-medium w3-top" style="margin-top:46px">
	<a href="book/list" class="w3-bar-item w3-button w3-padding-large">BOOK</a>
	<a href="board/list" class="w3-bar-item w3-button w3-padding-large">게시판</a>
	<c:if test="${sessionScope.userEmail == null }">
		<a href="javascript:showLogin()" class="w3-bar-item w3-button w3-padding-large">LOGIN</a>
		<a href="javascript:openEmailCheck()" class="w3-bar-item w3-button w3-padding-large">JOIN</a>
	</c:if>
	<c:if test="${sessionScope.userEmail != null }">
		<a href="member/myPage" class="w3-bar-item w3-button w3-padding-large">My Page</a>
		<a href="javascript:logout('')" class="w3-bar-item w3-button w3-padding-large">Logout</a>
	</c:if>
</div>

<!-- Page content -->
<div class="w3-content" style="max-width:2000px;margin-top:46px">

  <!-- Automatic Slideshow Images -->
<div class="mySlides w3-display-container w3-center">
    <img src="resources/images/slide1.jpg" style="width:100%">
    <div class="w3-display-bottommiddle w3-container w3-text-white w3-padding-32 w3-hide-small"></div>
  </div>
  <div class="mySlides w3-display-container w3-center">
    <img src="resources/images/slide2.jpg" style="width:100%">
    <div class="w3-display-bottommiddle w3-container w3-text-white w3-padding-32 w3-hide-small"></div>
  </div>
  <div class="mySlides w3-display-container w3-center">
    <img src="resources/images/slide3.jpg" style="width:100%">
    <div class="w3-display-bottommiddle w3-container w3-text-white w3-padding-32 w3-hide-small"></div>
  </div>

<!-- The Book Section -->
<div class="w3-container w3-content w3-center w3-padding-64" style="max-width:800px" id="book">
	<h2 class="w3-wide">소설</h2>
	<p class="w3-opacity"><i>지난 한 주 간 가장 많은 추천을 받은 소설들입니다.</i></p>
	<div class="w3-row w3-padding-32" id="best6-book"></div>
</div>

<!-- The Tour Section -->
<div class="w3-black" id="sentence">
	<div class="w3-container w3-content w3-padding-64" style="max-width:800px">
		<h2 class="w3-wide w3-center">문장들</h2>
		<p class="w3-opacity w3-center"><i>지난 한 주간 가장 많은 추천을 받은 문장들입니다.</i></p><br>
		<div class="w3-row-padding w3-padding-32" style="margin:0 -16px" id="best3-sentence"></div>
	</div>
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
				<input type="button" class="w3-button w3-block w3-teal w3-padding-16 w3-section w3-right" value="로그인" onclick="login('')">
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
				<input class="w3-input w3-border" type="email" placeholder="Enter email" id="join-email" name="userEmail" readonly="readonly">
				<p><label> 닉네임</label><span id="nicknameCheck"></span></p>
				<input class="w3-input w3-border" type="text" placeholder="Enter nickname" id="join-nickname" name="nickname" oninput="nicknameCheck('', '')">
				<p><label> 비밀번호</label><span id="passwordCheck"></span></p>
				<input class="w3-input w3-border" type="password" placeholder="Enter password" id="join-pw" name="userPassword" oninput="passwordCheck()">
				<p><label> 비밀번호 확인</label><span id="passwordCheck2"></span></p>
				<input class="w3-input w3-border" type="password" placeholder="Enter password" id="join-pw2" name="userPassword2" oninput="passwordCheck()">
				<input type="button" class="w3-button w3-block w3-teal w3-padding-16 w3-section w3-right" onclick="join('')" value="회원 등록">
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
			<span onclick="document.getElementById('verify-email').style.display='none'" class="w3-button w3-teal w3-xlarge w3-display-topright">×</span>
			<h2 class="w3-wide"><i class="fa fa-user"></i>이메일 확인</h2>
		</header>
		<div class="w3-container">
		<p><label>계정으로 사용할 이메일</label><span id="emailCheck"></span></p>
			<input class="w3-input w3-border" type="email" placeholder="Enter email" id="verify-userEmail" name="userEmail" oninput="emailCheck('', '')">
			<input type="button" class="w3-button w3-block w3-teal w3-padding-16 w3-section w3-right" id="sendCode-button" value="발송" 
				onclick="sendCode('')" disabled="disabled">
			<p><label>인증 코드 입력</label></p>
			<input class="w3-input w3-border" type="text" placeholder="Enter Code" id="verify-code" 
				name="userCode" disabled="disabled">
			<input type="button" class="w3-button w3-block w3-teal w3-padding-16 w3-section w3-right" value="확인" 
				id="submitCode-button" disabled="disabled" onclick="submitCode('', '')">
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
				id="findPassword-button" value="임시비밀번호 발급" onclick="findPassword('')">
			<p class="w3-right">Need <a href="#" class="w3-text-blue">help?</a></p> 
		</div>
	</div>
</div>

<!-- End Page Content -->
</div>


<!-- Footer -->
<footer class="w3-container w3-padding-64 w3-center w3-opacity w3-light-grey w3-xlarge">
	<p class="w3-medium">Powered by Hindoog, 2018</p>
</footer>

<script>
// Automatic Slideshow - change image every 4 seconds
var myIndex = 0;
carousel();

function carousel() {
    var i;
    var x = document.getElementsByClassName("mySlides");
    for (i = 0; i < x.length; i++) {
       x[i].style.display = "none";  
    }
    myIndex++;
    if (myIndex > x.length) {myIndex = 1}    
    x[myIndex-1].style.display = "block";  
    setTimeout(carousel, 4000);    
}
</script>
<script type="text/javascript" src="resources/js/common.js"></script>
</body>
</html>

