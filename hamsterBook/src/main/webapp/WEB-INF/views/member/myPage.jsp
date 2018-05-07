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
	getReview('../', 1, 10, 'userEmail', '${sessionScope.userEmail}', 'inputdate', '', '1');
	getBookList('../', 1, 6, '', '', 'hitdate', '', '1');
	getSentence('../', 1, 6, 'userEmail', '${sessionScope.userEmail}', 'inputdate', '', '');
	getSentence('../', 1, 6, 'userEmail', '${sessionScope.userEmail}', 'hitdate', '', '1');
	$('body').on('click', closeSearchResult);
	
});

//리뷰 보여주기
function showReview(result) {
	
	var html = '';
	
	if (result == 'fail' || result.reviewList == null || result.reviewList.length == 0) {
		// 리뷰 불러오기 실패
		html += '<p class="w3-center">등록된 후기가 없습니다.</p>'
		$('#review-section').html(html);
		return;
	} else {
		// 리뷰 불러오기 성공
		$(result.reviewList).each(function(i, review) {
			html += '<div class="review-div"><span class="rate-span">' + review.rate + '</span><span class="text-span">' + review.text + '</span>';
			html += '<span class="nickname-span">' + review.nickname + '</span></div>';
		});
	}
	
	$('#review-section').html(html);
	
	var page = result.page;	
	var totlaRecords = result.totalRecords;
	var totalPage = result.totalPage;
	var currentGroup = (result.currentGroup + 1);
	var startPage = result.startPage;
	var endPage = result.endPage;
	var totalGroup = totalPage / 10;
	
	var html2 = '';
	
	// 새로 들어올 경우 page = 1
	// 페이지번호 클릭할 경우 그 페이지로 이동
	// 다음/이전 누를 경우 이전 그룹의 가장 처음/마지막으로 이동
	// 가장 앞/가장 뒤 누를 경우 1 페이지 또는 totalPage로 이동
	if (page > 10) {
		html2 += '<span class="w3-medium review-paging" onclick="getReview(\'../\', 1, 10, \'userEmail\', \'${sessionScope.userEmail}\', \'inputdate\', \'\', 1)">처음</span>';
		html2 += '<span class="w3-medium review-paging" onclick="getReview(\'../\', ' + (startPage-1) + ', 10, \'userEmail\', \'${sessionScope.userEmail}\', \'inputdate\', \'\', 1)">이전</span>';
	}
	for (var i = startPage; i <= endPage; i++) {
		if(i == page) {
			html2 += '<span class="w3-medium review-paging" onclick="getReview(\'../\', ' + i + ', 10, \'userEmail\', \'${sessionScope.userEmail}\', \'inputdate\', \'\', 1)"><b>' + i + '</b></span>';
		} else {
			html2 += '<span class="w3-medium review-paging" onclick="getReview(\'../\', ' + i + ', 10, \'userEmail\', \'${sessionScope.userEmail}\', \'inputdate\', \'\', 1)">' + i + '</span>';				
		}
	}
	if (currentGroup < totalGroup) {
		html2 += '<span class="w3-medium review-paging" onclick="getReview(\'../\', ' + (endPage-1) + ', 10, \'userEmail\', \'${sessionScope.userEmail}\', \'inputdate\', \'\', 1)">다음</span>';
		html2 += '<span class="w3-medium review-paging" onclick="getReview(\'../\', ' + totalPage + ', 10, \'userEmail\', \'${sessionScope.userEmail}\', \'inputdate\', \'\', 1)">끝</span>';
	}
	
	$('#review-paging').html(html2);

}

//좋아요 누른 책 보여주기
function showLikeBookList(result) {
	
	var html = '';
	if (result == 'fail' || result.bookList == null || result.bookList.length == 0) {
		// 리뷰 불러오기 실패
		html += '<p class="w3-center">좋아요를 누른 책이 없습니다.</p>'
		$('#likeBook-section').html(html);
		return;
	} else {
		$(result.bookList).each(function(i, book) {		
			html += '<div class="w3-third book-cover"><p>' + book.title + '</p>';
			if (book.image != '') {
				html += ' <img src="' + book.image + '" class="w3-round w3-margin-bottom w3-hover-opacity w3-books"'
				html += 'alt="Book' + (i+1) + '" onclick="location.href=\'../book/info?isbn=' + book.isbn + '\'"'
			} else {
				html += ' <img src="resources/images/book_default.png" class="w3-round w3-margin-bottom w3-hover-opacity w3-books"'
				html += 'alt="Book' + (i+1) + '" onclick="location.href=\'../book/info?isbn=' + book.isbn + '\'"'
			}
			html += ' style="width:60%"></div>'
		});
	}
	
	$('#likeBook-section').html(html);
	
	var page = result.page;	
	var totlaRecords = result.totalRecords;
	var totalPage = result.totalPage;
	var currentGroup = (result.currentGroup + 1);
	var startPage = result.startPage;
	var endPage = result.endPage;
	var totalGroup = totalPage / 10;
	
	var html2 = '';
	
	// 새로 들어올 경우 page = 1
	// 페이지번호 클릭할 경우 그 페이지로 이동
	// 다음/이전 누를 경우 이전 그룹의 가장 처음/마지막으로 이동
	// 가장 앞/가장 뒤 누를 경우 1 페이지 또는 totalPage로 이동
	if (page > 10) {
		html2 += '<span class="w3-medium likeBook-paging" onclick="getBookList(\'../\', 1, 6, \'\', \'\', \'hitdate\', \'\', 1)">처음</span>';
		html2 += '<span class="w3-medium likeBook-paging" onclick="getBookList(\'../\', ' + (startPage-1) + ', 6, \'\', \'\', \'hitdate\', \'\', 1)">이전</span>';
	}
	for (var i = startPage; i <= endPage; i++) {
		if(i == page) {
			html2 += '<span class="w3-medium likeBook-paging" onclick="getBookList(\'../\', ' + i + ', 6, \'\', \'\', \'hitdate\', \'\', 1)"><b>' + i + '</b></span>';
		} else {
			html2 += '<span class="w3-medium likeBook-paging" onclick="getBookList(\'../\', ' + i + ', 6, \'\', \'\', \'hitdate\', \'\', 1)">' + i + '</span>';				
		}
	}
	if (currentGroup < totalGroup) {
		html2 += '<span class="w3-medium likeBook-paging" onclick="getBookList(\'../\', ' + (endPage+1) + ', 6, \'\', \'\', \'hitdate\', \'\', 1)">다음</span>';
		html2 += '<span class="w3-medium likeBook-paging" onclick="getBookList(\'../\', ' + totalPage + ', 6, \'\', \'\', \'hitdate\', \'\', 1)">끝</span>';
	}
	
	
	$('#likeBook-paging').html(html2);
}

// 내가 등록한 문장
function showSentence(result) {
	
	var html = '';
	
	if (result == 'fail' || result.sentenceList.length == 0) {
		// 문장 불러오기 실패
		html += '<p class="w3-center">등록된 문장이 없습니다.</p>';
		$('#sentence-section').html(html);
		return;
	} else {
		// 문장 불러오기 성공
		$(result.sentenceList).each(function(i, sentence) {
			html += '<div class="sentence-div"><span class="nickname-span">' + sentence.title + '</span>';
			html += '<span class="page-span">' + sentence.page + '</span><span class="sentence-span">' + sentence.sentence + '</span>';
			html += '<input class="w3-sentence-good w3-button w3-black w3-right" value="' + sentence.hit + '"></div>';
		});
	}
	
	$('#sentence-section').html(html);
	
	var page = result.page;	
	var totlaRecords = result.totalRecords;
	var totalPage = result.totalPage;
	var currentGroup = (result.currentGroup + 1);
	var startPage = result.startPage;
	var endPage = result.endPage;
	var totalGroup = totalPage / 10;
	
	var html2 = '';
	
	// 새로 들어올 경우 page = 1
	// 페이지번호 클릭할 경우 그 페이지로 이동
	// 다음/이전 누를 경우 이전 그룹의 가장 처음/마지막으로 이동
	// 가장 앞/가장 뒤 누를 경우 1 페이지 또는 totalPage로 이동
	if (page > 10) {
		html2 += '<span class="w3-medium sentence-paging" onclick="getSentence(\'../\', 1, 6, \'userEmail\', \'${sessionScope.userEmail}\', \'inputdate\', \'\', \'\')">처음</span>';
		html2 += '<span class="w3-medium sentence-paging" ponclick="getSentence(\'../\', ' + (startPage-1) + ', 6, \'userEmail\', \'${sessionScope.userEmail}\', \'inputdate\', \'\', \'\')">이전</span>';
	}
	for (var i = startPage; i <= endPage; i++) {
		if(i == page) {
			html2 += '<span class="w3-medium sentence-paging" onclick="getSentence(\'../\', ' + i + ', 6, \'userEmail\', \'${sessionScope.userEmail}\', \'inputdate\', \'\', \'\')"><b>' + i + '</b></span>';
		} else {
			html2 += '<span class="w3-medium sentence-paging" onclick="getSentence(\'../\', ' + i + ', 6, \'userEmail\', \'${sessionScope.userEmail}\', \'inputdate\', \'\', \'\')">' + i + '</span>';				
		}
	}
	if (currentGroup < totalGroup) {
		html2 += '<span class="w3-medium sentence-paging" onclick="getSentence(\'../\', ' + (endPage+1) + ', 6, \'userEmail\', \'${sessionScope.userEmail}\', \'inputdate\', \'\', \'\')">다음</span>';
		html2 += '<span class="w3-medium sentence-paging" onclick="getSentence(\'../\', ' + totalPage + ', 6, \'userEmail\', \'${sessionScope.userEmail}\', \'inputdate\', \'\', \'\')">끝</span>';
	}
	
	
	$('#sentence-paging').html(html2);
}

//내가 좋아요 한 문장 보여주기
function showLikeSentence(result) {
	
	var html = '';
	if (result == 'fail' || result.sentenceList.length == 0) {
		// 문장 불러오기 실패
		html += '<p class="w3-center">좋아요를 누른 문장이 없습니다.</p>';
		$('#likeSentence-section').html(html);
		return;
	} else {
		$(result.sentenceList).each(function(i, sentence) {			
			html += '<div class="w3-third w3-margin-bottom">';
				html += '<div class="w3-container w3-white best3-sentence"';
				html += 'onclick="location.href=\'../book/info?isbn=' + $(this).attr('isbn') + '\'"><p><b>' ;
				html += sentence.title + '</b></p><p class="w3-opacity">' + sentence.author + '</p>' ;
				html += '<p class="sentence-p">' + sentence.sentence + '</p></div></div>';
		});
	}
	
	$('#likeSentence-section').html(html);

	var page = result.page;	
	var totlaRecords = result.totalRecords;
	var totalPage = result.totalPage;
	var currentGroup = (result.currentGroup + 1);
	var startPage = result.startPage;
	var endPage = result.endPage;
	var totalGroup = totalPage / 10;
	
	var html2 = '';
	
	// 새로 들어올 경우 page = 1
	// 페이지번호 클릭할 경우 그 페이지로 이동
	// 다음/이전 누를 경우 이전 그룹의 가장 처음/마지막으로 이동
	// 가장 앞/가장 뒤 누를 경우 1 페이지 또는 totalPage로 이동
	if (page > 10) {
		html2 += '<span class="w3-medium likeSentence-paging" onclick="getSentence(\'../\', 1, 6, \'\', \'\', \'hitdate\', \'\', 1)">처음</span>';
		html2 += '<span class="w3-medium likeSentence-paging" onclick="getSentence(\'../\', ' + (startPage-1) +', 6, \'\', \'\', \'hitdate\', \'\', 1)">이전</span>';
	}
	for (var i = startPage; i <= endPage; i++) {
		if(i == page) {
			html2 += '<span class="w3-medium likeSentence-paging" onclick="getSentence(\'../\', ' + i +', 6, \'\', \'\', \'hitdate\', \'\', 1)"><b>' + i + '</b></span>';
		} else {
			html2 += '<span class="w3-medium likeSentence-paging" onclick="getSentence(\'../\', ' + i +', 6, \'\', \'\', \'hitdate\', \'\', 1)">' + i + '</span>';				
		}
	}
	if (currentGroup < totalGroup) {
		html2 += '<span class="w3-medium likeSentence-paging" onclick="getSentence(\'../\', ' + (endPage+1) +', 6, \'\', \'\', \'hitdate\', \'\', 1)">다음</span>';
		html2 += '<span class="w3-medium likeSentence-paging" onclick="getSentence(\'../\', ' + totalPage +', 6, \'\', \'\', \'hitdate\', \'\', 1)">끝</span>';
	}
	
	
	$('#likeSentence-paging').html(html2);

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
		<a class="w3-bar-item w3-button w3-padding-large w3-hide-medium w3-hide-large w3-right" href="javascript:void(0)" onclick="myFunction()" title="Toggle Navigation Menu"><i class="fa fa-bars"></i></a>
		<a href="../" class="w3-bar-item w3-button w3-padding-large">HOME</a>
		<a href="../book/list" class="w3-bar-item w3-button w3-padding-large w3-hide-small">BOOK</a>
		<a href="#sentence" class="w3-bar-item w3-button w3-padding-large w3-hide-small">SENTENCE</a>
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
	<a href="../board/list" class="w3-bar-item w3-button w3-padding-large">게시판</a>
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

<!-- The myReview Section -->
<div class="w3-container w3-content w3-center w3-padding-24" style="max-width:800px" id="review">
	<h2 class="w3-wide">내가 남긴 리뷰</h2>
	<p class="w3-opacity"><i>자신이 등록한 리뷰를 확인하세요.</i></p>
	<div class="w3-row w3-padding-32" id="review-section"></div>
	<div class="w3-row w3-padding-32 review-paging" id="review-paging"></div>
</div>

<!-- The likeBook Section -->
<div class="w3-black" id="likeBook">
	<div class="w3-container w3-content w3-padding-24" style="max-width:800px">
		<h2 class="w3-wide w3-center">좋아요 한 책</h2>
		<p class="w3-opacity w3-center"><i>좋아요 한 책을 확인하세요.</i></p><br>
		<div class="w3-row-padding w3-padding-32" style="margin:0 -16px" id="likeBook-section"></div>
		<div class="w3-row-padding w3-padding-32 likeBook-paging" style="margin:0 -16px" id="likeBook-paging"></div>
	</div>
</div>
  
<!-- The mySentence Section -->
<div class="w3-container w3-content w3-center w3-padding-24" style="max-width:800px" id="sentence">
	<h2 class="w3-wide">내가 등록한 문장</h2>
	<p class="w3-opacity"><i>자신이 등록한 문장을 확인하세요.</i></p>
	<!-- <p class="w3-justify">지난 한 주 간 가장 리뷰가 많았던 소설들입니다.</p> -->
	<div class="w3-row w3-padding-32" id="sentence-section"></div>
	<div class="w3-row w3-padding-32 sentence-paging" id="sentence-paging"></div>
</div>

 <!-- The likeSentence Section -->
<div class="w3-black" id="likeSentence">
	<div class="w3-container w3-content w3-padding-24" style="max-width:800px">
		<h2 class="w3-wide w3-center">좋아요 한 문장</h2>
		<p class="w3-opacity w3-center"><i>자신이 좋아요 한 문장을 확인하세요.</i></p><br>
		<div class="w3-row-padding w3-padding-32" style="margin:0 -16px" id="likeSentence-section"></div>
		<div class="w3-row-padding w3-padding-32 likeSentence-paging" style="margin:0 -16px" id="likeSentence-paging"></div>
	</div>
</div>

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
  
<!-- Footer -->
<footer class="w3-container w3-padding-64 w3-center w3-opacity w3-light-grey w3-xlarge">
	<p class="w3-medium">Powered by Hindoo, 2018</p>
</footer>
<script type="text/javascript" src="../resources/js/common.js"></script>
</body>
</html>

