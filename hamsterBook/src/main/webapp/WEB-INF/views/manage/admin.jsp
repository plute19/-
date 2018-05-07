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
<style>
body {font-family: "Lato", sans-serif}
.mySlides {display: none}
</style>
<script type="text/javascript" src="../resources/js/jquery-3.3.1.min.js"></script>
<script type="text/javascript">
$('document').ready(function() {
	$('body').on('click', closeSearchResult);
	getCategory();
});

function insertCategory() {
	$.ajax({
		url: "../manage/insertCategory",
		type: "post",
		dataType: "json",
		success: function(result) {
			if(result != 0) {
				alert(result +'개의 카테고리가 추가되었습니다.');
			} else {
				alert('추가할 카테고리가 없습니다.');	
			}
		},
		error: function(e) {
			alert('에러 발생.. 코드 -> ' + e.status)
		}
	});
}

function getCategory() {
	$.ajax({
		url: "../manage/selectCategory",
		type: "post",
		dataType: "json",
		success: function(result) {
			showCategory(result);
		},
		error: function(e) {
			alert('에러 발생.. 코드 -> ' + e.status)
		}
	});
}

function showCategory(result) {
	
	var html = '<div class="category-div"><b class="category-span">카테고리 코드</b>';
	html += '<b class="category-span">카테고리명</b>';
	html += '<b class="category-span">데이터 수</b>';
	html += '<b class="category-span">최근 업데이트</b></div>';
	
	if (result == null || result.length == 0) {
		// 카테고리 불러오기 실패
		html += '<p class="">오류가 발생했습니다...</p>';
		$('#category-section').html(html);
		return;
	} else {
		// 문장 불러오기 성공
		var totalVolume = 0;
		
		$(result).each(function(i, category) {
			html += '<div class="category-div"><span class="category-span">' + category.category + '</span>';
			html += '<span class="category-span">' + category.c_name +  '</span>';
			html += '<span class="category-span">' + category.volume + '</span>';
			html += '<span class="category-span">' + category.updateDate + '</span>';
			html += '<span class="category-span"><input class="w3-button w3-black category-button" value="업데이트"';
			html += 'onclick="insertBookInfo(\'' + category.category + '\')"></span></div>';
			totalVolume += category.volume;
		});
		
		html += '<div class="category-div"><b class="category-span">총합</b>';
		html += '<b class="category-span"></b>';
		html += '<b class="category-span">' + totalVolume + '</b></div>';
	}
	
	
	
	$('#category-section').html(html);	
	
}


function insertBookInfo(category) {
	
	$('.category-button').attr('disabled', 'disabled');
	$('.category-button').attr('value', '업데이트 중');
	alert('업데이트를 시작합니다. 5~10분 가량 소요되니 페이지를 이동하지 말고 기다려주세요. 끝나면 알려드립니다!');
	
	if (category == '') {
		alert("카테고리를 선택해주세요.");
		return;
	}
	
	$.ajax({
		url: '../manage/insertBookInfo',
		type: 'post',
		data: {
			category: category
		},
		dataType: 'text',
		success: function(result) {
			$('.category-button').removeAttr('disabled');
			$('.category-button').attr('value', '업데이트');
			getCategory();
		},
		error: function(e) {
			alert('오류 발생, 코드 -> ' + e.status);
		}
	})
}

</script>
</head>

<body>

<!-- Navbar -->
<div class="w3-top">
	<div class="w3-bar w3-black w3-card">
		<a class="w3-bar-item w3-button w3-padding-large w3-hide-medium w3-hide-large w3-right" href="javascript:void(0)" onclick="myFunction()" title="Toggle Navigation Menu"><i class="fa fa-bars"></i></a>
		<a href="../" class="w3-bar-item w3-button w3-padding-large">HOME</a>
		<a href="../book/list" class="w3-bar-item w3-button w3-padding-large w3-hide-small">BOOK</a>
		<a href="../board/list" class="w3-bar-item w3-button w3-padding-large w3-hide-small">게시판</a>
		<div class="w3-dropdown-hover w3-dropdown-user w3-hide-small">
			<button class="w3-padding-large w3-button" title="User"><i class="fa fa-user"></i><i class="fa fa-caret-down"></i></button>     
			<div class="w3-dropdown-content w3-dropdown-content-user w3-bar-block w3-card-4">
				<c:if test="${sessionScope.userEmail != null }">
					<a href="javascript:location.reload()" class="w3-bar-item w3-button">My Page</a>
					<a href="javascript:logout('../')" class="w3-bar-item w3-button" id="logout-button">Logout</a>
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
	<a href="#sentence" class="w3-bar-item w3-button w3-padding-large">SENTENCE</a>
	<c:if test="${sessionScope.userEmail != null }">
		<a href="#" class="w3-bar-item w3-button w3-padding-large">My Page</a>
		<a href="javascript:logout('')" class="w3-bar-item w3-button w3-padding-large">Logout</a>
	</c:if>
</div>


<!-- Page content -->
<div class="w3-content" style="max-width:2000px;margin-top:46px">

<div class="w3-container w3-content w3-center w3-padding-16" style="max-width:800px" id="update-section">
	<input type="button" class="w3-button w3-black w3-center" id="updateMember" value="정보수정" onclick="javascript:showUpdate()">
</div>


<div class="w3-container w3-content w3-padding-32" style="max-width:800px" id="title">
	<h1 class="w3-wide w3-center">[manager page]</h1>
	<a href="javascript:insertCategory()">카테고리 초기 설정(카테고리가 나오지 않을 경우 눌러주세요.)</a>
</div>

<!-- The Category Section -->
<div class="w3-container w3-content w3-padding-16" style="max-width:800px" id="category">
	<h2 class="w3-wide w3-center">CATEGORY</h2>
	<!-- show category -->
	<div id="category-section"></div>
</div>

<!-- update -->
<div id="update" class="w3-modal">
	<div class="w3-modal-content w3-animate-top w3-card-4">
		<header class="w3-container w3-teal w3-center w3-padding-32"> 
			<span onclick="document.getElementById('update').style.display='none'" 
				class="w3-button w3-teal w3-xlarge w3-display-topright">×</span>
			<h2 class="w3-wide">
				<i class="fa fa-user"></i>정보 수정
			</h2>
		</header>
		<div class="w3-container">
			<form id="update-form">
				<p>
					<label>계정(이메일)</label>
				</p>
				<input class="w3-input w3-border" type="email" placeholder="Enter email" id="join-email" 
					name="userEmail" value="${sessionScope.userEmail }" readonly="readonly">
				<p>
					<label>닉네임</label>
					<span id="nicknameCheck"></span>
				</p>
				<input class="w3-input w3-border" type="text" placeholder="Enter nickname" id="join-nickname" 
					name="nickname" oninput="nicknameCheck('../', '${sessionScope.userNickname }')"
					value="${sessionScope.userNickname }">
				<p>
					<label>비밀번호</label>
					<span id="passwordCheck"></span>
				</p>
				<input class="w3-input w3-border" type="password" placeholder="Enter password" 
					id="join-pw" name="userPassword" oninput="passwordCheck()">
				<p>
					<label>비밀번호 확인</label>
					<span id="passwordCheck2"></span>
				</p>
				<input class="w3-input w3-border" type="password" placeholder="Enter password" 
					id="join-pw2" name="userPassword2" oninput="passwordCheck()">
				<input type="button" class="w3-button w3-block w3-teal w3-padding-16 w3-section w3-right" 
					id="update-button" onclick="update('../')" value="정보 수정">
				<input type="button" class="w3-button w3-red w3-section" 
					onclick="document.getElementById('update').style.display='none'" value="닫기">
				<input type="button" class="w3-button w3-red w3-section" onclick="showLeave()" value="회원 탈퇴">
				<input type="button" class="w3-button w3-red w3-section" onclick="showUpdateEmail()" value="이메일 변경">
				<p class="w3-right">Need <a href="#" class="w3-text-blue">help?</a></p>
			</form>
		</div>
	</div>
</div>

<!-- update-email -->
<div id="update-email" class="w3-modal">
	<div class="w3-modal-content w3-animate-top w3-card-4">
		<header class="w3-container w3-teal w3-center w3-padding-32"> 
			<span onclick="document.getElementById('update-email').style.display='none'" class="w3-button w3-teal w3-xlarge w3-display-topright">×</span>
			<h2 class="w3-wide"><i class="fa fa-user"></i>이메일 변경</h2>
		</header>
		<div class="w3-container">
			<p><label>기존 이메일</label><span id="emailCheck"></span></p>
			<input class="w3-input w3-border" type="email" placeholder="Enter email" id="before-email" 
				name="beforeUserEmail" value="${sessionScope.userEmail }" readonly="readonly">
			<p><label>변경할 이메일</label><span id="emailCheck"></span></p>
			<input class="w3-input w3-border" type="email" placeholder="Enter email" id="verify-userEmail" 
				name="userEmail" oninput="emailCheck('../', '${sessionScope.userEmail }')">
			<input type="button" class="w3-button w3-block w3-teal w3-padding-16 w3-section w3-right" 
				id="sendCode-button" value="발송" onclick="sendCode('../')" disabled="disabled">
			<p><label>인증 코드 입력</label></p>
			<input class="w3-input w3-border" type="text" placeholder="Enter Code" id="verify-code" 
				name="userCode" disabled="disabled">
			<input type="button" class="w3-button w3-block w3-teal w3-padding-16 w3-section w3-right" 
				id="submitCode-button" value="확인" onclick="submitCode('../', 'myPage')" disabled="disabled">
			<p class="w3-right">Need <a href="#" class="w3-text-blue">help?</a></p>
		</div>
	</div>
</div>

<!-- 회원 탈퇴 -->
<div id="leave" class="w3-modal">
	<div class="w3-modal-content w3-animate-top w3-card-4">
		<header class="w3-container w3-teal w3-center w3-padding-32"> 
			<span onclick="document.getElementById('leave').style.display='none'" class="w3-button w3-teal w3-xlarge w3-display-topright">×</span>
			<h2 class="w3-wide">
				<i class="fa fa-user"></i>탈퇴...
			</h2>
		</header>
		<div class="w3-container">
			<form id="leave-form">
				<p><label>비밀번호 재확인</label>
				<input class="w3-input w3-border" type="password" placeholder="Enter password" name="userPassword">
				<input type="hidden" name="userEmail" value="${sessionScope.userEmail}">
				<input type="button" class="w3-button w3-red w3-teal w3-padding-16 w3-section w3-right" onclick="leave()" value="회원 탈퇴">
				<input type="button" class="w3-button w3-red w3-section" onclick="document.getElementById('leave').style.display='none'" value="닫기">
				<p class="w3-right">Need <a href="#" class="w3-text-blue">help?</a></p>
			</form>
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

