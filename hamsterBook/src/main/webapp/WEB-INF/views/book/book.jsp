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
	$('#insertReview').on('click', insertReview);
	getReview('../', 1, 10, 'isbn', '${book.isbn}', 'inputdate', '', '');
	getSentence('../', 1, 10, 'isbn', '${book.isbn}', 'inputdate', '', '');
});

//리뷰 보여주기
function showReview(result) {
	
	var html = '';
	
	if (result == 'fail' || result.reviewList == null || result.reviewList.length == 0) {
		// 리뷰 불러오기 실패
		html += '<p class="">등록된 후기가 없습니다.</p>'
		$('#review-section').html(html);
		return;
	} else {
		// 리뷰 불러오기 성공
		$(result.reviewList).each(function(i, review) {
			html += '<div class="review-div"><span class="rate-span">' + review.rate + '</span><span class="text-span">' + review.text 
			html += '</span><span class="nickname-span"">' + review.nickname + '</span></div>';
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
		html2 += '<span class="w3-medium review-paging" onclick="getReview(\'../\', 1, 10, \'isbn\', \'${book.isbn}\', \'inputdate\', \'\', \'\')">처음</span>';
		html2 += '<span class="w3-medium review-paging" onclick="getReview(\'../\',' + (startPage-1) + ', 10, \'isbn\', \'${book.isbn}\', \'inputdate\', \'\', \'\')">이전</span>';
	}
	for (var i = startPage; i <= endPage; i++) {
		if(i == page) {
			html2 += '<span class="w3-medium review-paging" onclick="getReview(\'../\',' + i + ', 10, \'isbn\', \'${book.isbn}\', \'inputdate\', \'\', \'\')"><b>' + i + '</b></span>';
		} else {
			html2 += '<span class="w3-medium review-paging" onclick="getReview(\'../\',' + i + ', 10, \'isbn\', \'${book.isbn}\', \'inputdate\', \'\', \'\')">' + i + '</span>';				
		}
	}
	if (currentGroup < totalGroup) {
		html2 += '<span class="w3-medium review-paging" onclick="getReview(\'../\',' + (endPage+1) + ', 10, \'isbn\', \'${book.isbn}\', \'inputdate\', \'\', \'\')">다음</span>';
		html2 += '<span class="w3-medium review-paging" onclick="getReview(\'../\',' + totalPage + ', 10, \'isbn\', \'${book.isbn}\', \'inputdate\', \'\', \'\')">끝</span>';
	}
	
	$('#review-paging').html(html2);
	
}

function insertReview() {
	
	$.ajax({
		url: 'insertReview',
		type: 'post',
		data: $('#insertReviewForm').serialize(),
		dataType: 'text',
		beforeSend : function(xmlHttpRequest){
            xmlHttpRequest.setRequestHeader("AJAX", "true"); // ajax 호출을  header에 기록
		},	
		success: function(result) {
			if (result == 1) {
				getReview('../', 1, 10, 'isbn', '${book.isbn}', 'inputdate', '', '');
				alert('등록되었습니다.');
			} else {
				alert('에러 발생');
			}
		},
		error: function(e) {
			if (e.status == 999) {
				// 로그인 정보 없음
				document.getElementById('login').style.display='block';
			} else {
				alert('에러 발생 -> ' + e.status);
			}
		}
	});
}

function rateCheck() {
	var rate = $('#rate').val().substring(0,2);
	var tmpRate = '';
	var tmpRate = rate.split(/\D/);
	var modifiedRate = '';
	for (var i = 0; i < tmpRate.length; i++) {
		modifiedRate += tmpRate[i]; 
	}
	
	if (modifiedRate > 10) {
		modifiedRate = 10;
	}
	
	$('#rate').val(modifiedRate);
	
}

function addHit() {

	$.ajax({
		url: 'insertBookHit',
		type: 'post',
		data: {
			isbn: $('#isbn').val(),
			keyword: 'hit'
		},
		dataType: 'text',
		beforeSend : function(xmlHttpRequest){
            xmlHttpRequest.setRequestHeader("AJAX", "true"); // ajax 호출을  header에 기록
		},
		success: function(result) {
			if (result == 1) {
				//좋아요 추가 됨
				getBookInfo(isbn);
			} else {
				alert('오류 발생.. 문제가 반복될 경우 연락바랍니다.');
			}
		},
		error: function(e) {
			if (e.status == 999) {
				document.getElementById('login').style.display='block';
			} else {
				alert('오류 발생.. 문제가 반복될 경우 연락바랍니다. -> ' + e.status);
			}
		}
	});
}

function selectBookHit() {
	
	$.ajax({
		url: 'selectBookHit',
		type: 'post',
		data: {
			isbn: $('#isbn').val()
		},
		dataType: 'text',
		beforeSend : function(xmlHttpRequest){
            xmlHttpRequest.setRequestHeader("AJAX", "true"); // ajax 호출을  header에 기록
		},
		success: function(result) {
			if (result != 0) {
				//이미 좋아요를 한 상태
				alert('이미 좋아요를 한 책입니다.');
				return;
			} else {
				//좋아요를 누른 적 없는 상태
				addHit();
			}
		},
		error: function(e) {
			if (e.status == 999) {
				document.getElementById('login').style.display='block';
			} else {
				alert('오류 발생.. 문제가 반복될 경우 연락바랍니다. -> ' + e.status);
			}
			return;
		}
	});
}

function getBookInfo() {
	$.ajax({
		url: 'getBookInfo',
		type: 'post',
		data: {
			isbn: $('#isbn').val()
		},
		dataType: 'json',
		success: function(result) {
			if (result == null) {
				// 반환값이 null일 경우 아무것도 하지 않는다..
			} else {
				// 각 정보를 새로 고친다..
				$('#bookHit').val(result.hit);
			}
		},
		error: function(e) {
			alert('오류 발생.. 문제가 반복될 경우 연락바랍니다. -> ' + e.status);
		}
	});
}

function showSentence(result) {
	
	var html = '';
	
	if (result == 'fail' || result.sentenceList.length == 0) {
		// 문장 불러오기 실패
		html += '<p class="">등록된 문장이 없습니다.</p>';
		$('#sentence-section').html(html);
		return;
	} else {
		// 문장 불러오기 성공
		$(result.sentenceList).each(function(i, sentence) {
			html += '<div class="sentence-div"><span class="page-span">' + sentence.page + '</span><span class="sentence-span">' + sentence.sentence 
			html += '</span><span class="nickname-span">' + sentence.nickname + '</span>';
			html += '<input class="w3-sentence-good w3-button w3-black w3-right" value="' + sentence.hit + '">'
			 + '<input class="w3-sentence-good w3-button w3-black w3-right" value="좋아요" onclick="selectSentenceHit(\'' + sentence.sentenceNum + '\')"></div>';
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
		html2 += '<span class="w3-medium sentence-paging" onclick="getSentence(\'../\', 1, 10, \'isbn\', \'${book.isbn}\', \'inputdate\', \'\', \'\')">처음</span>';
		html2 += '<span class="w3-medium sentence-paging" onclick="getSentence(\'../\',' + (startPage-1) + '\', 10, \'isbn\', \'${book.isbn}\', \'inputdate\', \'\', \'\')">이전</span>';
	}
	for (var i = startPage; i <= endPage; i++) {
		if(i == page) {
			html2 += '<span class="w3-medium sentence-paging" onclick="getSentence(\'../\',' + i + ', 10, \'isbn\', \'${book.isbn}\', \'inputdate\', \'\', \'\')"><b>' + i + '</b></span>';
		} else {
			html2 += '<span class="w3-medium sentence-paging" onclick="getSentence(\'../\',' + i + ', 10, \'isbn\', \'${book.isbn}\', \'inputdate\', \'\', \'\')">' + i + '</span>';			
		}
	}
	if (currentGroup < totalGroup) {
		html2 += '<span class="w3-medium sentence-paging" onclick="getSentence(\'../\',' + (endPage+1) + ', 10, \'isbn\', \'${book.isbn}\', \'inputdate\', \'\', \'\')">다음</span>';
		html2 += '<span class="w3-medium sentence-paging" onclick="getSentence(\'../\',' + totalPage + ', 10, \'isbn\', \'${book.isbn}\', \'inputdate\', \'\', \'\')">끝</span>'; 
	}
	
	
	$('#sentence-paging').html(html2);
}

function insertSentence() {
	
	$.ajax({
		url: '../sentence/insertSentence',
		type: 'post',
		data: $('#insertSentenceForm').serialize(),
		dataType: 'text',
		beforeSend : function(xmlHttpRequest){
            xmlHttpRequest.setRequestHeader("AJAX", "true"); // ajax 호출을  header에 기록
		},	
		success: function(result) {
			if (result == 1) {
				alert('등록되었습니다.');
				getSentence('../', 1, 10, 'isbn', '${book.isbn}', 'inputdate', '', '');
			} else {
				alert('에러 발생');
			}
		},
		error: function(e) {
			if (e.status == 999) {
				// 로그인 정보 없음
				document.getElementById('login').style.display='block';
			} else {
				alert('에러 발생 -> ' + e.status);
			}
		}
	});
}

function pageCheck() {
	var sentencePage = $('#sentencePage').val().substring(0,4);
	var tmpPage = '';
	var tmpPage = sentencePage.split(/\D/);
	var modifiedPage = '';
	for (var i = 0; i < tmpPage.length; i++) {
		modifiedPage += tmpPage[i]; 
	}
	
	$('#sentencePage').val(modifiedPage);
	
}


function addSentenceHit(sentenceNum) {
	
	var isbn = '${book.isbn }';
	
	$.ajax({
		url: '../sentence/insertSentenceHit',
		type: 'post',
		data: {
			sentenceNum: sentenceNum
		},
		dataType: 'text',
		beforeSend : function(xmlHttpRequest){
            xmlHttpRequest.setRequestHeader("AJAX", "true"); // ajax 호출을  header에 기록
		},
		success: function(result) {
			if (result == 1) {
				//좋아요 추가 됨
				getSentence('../', 1, 10, 'isbn', '${book.isbn}', 'inputdate', '', '');
			} else {
				alert('오류 발생.. 문제가 반복될 경우 연락바랍니다.');
			}
		},
		error: function(e) {
			if (e.status == 999) {
				document.getElementById('login').style.display='block';
			} else {
				alert('오류 발생.. 문제가 반복될 경우 연락바랍니다. -> ' + e.status);
			}
		}
	});
}

function selectSentenceHit(sentenceNum) {
	
	$.ajax({
		url: '../sentence/selectSentenceHit',
		type: 'post',
		data: {
			sentenceNum: sentenceNum
		},
		dataType: 'text',
		beforeSend : function(xmlHttpRequest){
            xmlHttpRequest.setRequestHeader("AJAX", "true"); // ajax 호출을  header에 기록
		},		
		success: function(result) {
			if (result != 0) {
				//이미 좋아요를 한 상태
				alert('이미 좋아요를 한 문장입니다.');
				return;
			} else {
				//좋아요를 누른 적 없는 상태
				addSentenceHit(sentenceNum);
			}
		},
		error: function(e) {
			if (e.status == 999) {
				document.getElementById('login').style.display='block';
			} else {
				alert('오류 발생.. 문제가 반복될 경우 연락바랍니다. -> ' + e.status);
			}
			return;
		}
	});
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
		<a href="list" class="w3-bar-item w3-button w3-padding-large w3-hide-small">BOOK</a>
		<a href="../board/list" class="w3-bar-item w3-button w3-padding-large w3-hide-small">게시판</a>
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
	<a href="list" class="w3-bar-item w3-button w3-padding-large">BOOK</a>
	<a href="../board/list" class="w3-bar-item w3-button w3-padding-large">게시판</a>
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

 <!-- The Book Section -->
  <div class="w3-container w3-content w3-center w3-padding-64" style="max-width:800px" id="book">
    <h2 class="w3-wide">${book.title } <input class="w3-good w3-button w3-black w3-right" value="${book.hit }" id="bookHit"><input class="w3-good w3-button w3-black w3-right" value="좋아요" onclick="selectBookHit()"></h2>
    <p class="w3-opacity"><i>${book.author }</i></p>
    <p class="w3-justify">${book.description }</p>
    <a class="w3-justify" href='${book.link}' target="_blank">자세한 정보 읽으러 가기</a>
  </div>
  
<!-- The Review Section -->
<div class="w3-container w3-content w3-padding-64" style="max-width:800px" id="review">
	<h2 class="w3-wide w3-center">REVIEW</h2>
	<p class="w3-opacity w3-center">
	<span class="w3-opacity">이 책을 읽으셨나요? 후기를 남겨주세요!</span>
	</p>
	<!-- insert Review -->
	<div class="w3-row w3-padding-32">
		<div class="w3-wide">
			<form id="insertReviewForm">
				<div class="w3-wide" style="margin:0 -16px 8px -16px">
					<div class="w3-third">
						<input class="w3-input w3-border" type="text" placeholder="별점" required name="rate" id="rate" oninput="rateCheck()">
					</div>
					<div class="w3-third">
						<textarea rows="3" cols="40" class="w3-border w3-textarea" placeholder="후기" required name="text"></textarea>
					</div>
					<div class="w3-third">
						<input type="button" class="w3-button w3-black w3-right" id="insertReview" value="등록">
					</div>
					<div class="w3-half">
						 <!-- 숨겨서 보낼 내용들 -->
						<input type="text" hidden="" name="isbn" value="${book.isbn }" id="isbn">
					</div>
				</div>
			</form>
		</div>
	</div>
	<!-- show review -->
	<div id="review-section"></div>
	<!-- review paging -->
	<div id="review-paging" class="review-paging"></div>
</div>

<!-- The Sentence Section -->
<div class="w3-container w3-content w3-padding-64" style="max-width:800px" id="sentence">
	<h2 class="w3-wide w3-center">SENTENCE</h2>
	<p class="w3-opacity w3-center">
	<span class="w3-opacity">마음에 든 문장이 있나요? 공유해주세요!</span>
	</p>
	<!-- insert Sentence -->
	<div class="w3-row w3-padding-32">
		<div class="w3-wide">
			<form id="insertSentenceForm">
				<div class="w3-wide" style="margin:0 -16px 8px -16px">
					<div class="w3-third">
						<input class="w3-input w3-border" type="text" placeholder="페이지(필수 아님)" required="required" name="page" id="sentencePage" oninput="pageCheck()">
					</div>
					<div class="w3-third">
						<textarea rows="3" cols="40" class="w3-border w3-textarea" placeholder="문장" required="required" name="sentence"></textarea>
					</div>
					<div class="w3-third">
						<input type="button" class="w3-button w3-black w3-right" type="submit" value="등록" onclick="insertSentence()">
					</div>
					<div class="w3-half">
						 <!-- 숨겨서 보낼 내용들 -->
						<input type="text" hidden="" name="isbn" value="${book.isbn }" id="isbn">
					</div>
				</div>
			</form>
		</div>
	</div>
	<!-- show review -->
	<div id="sentence-section"></div>
	<!-- review paging -->
	<div id="sentence-paging" class="sentence-paging"></div>
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
  
<!-- End Page Content -->
</div>


<!-- Footer -->
<footer class="w3-container w3-padding-64 w3-center w3-opacity w3-light-grey w3-xlarge">
	<p class="w3-medium">Powered by Hindoog, 2018</p>
</footer>
<script type="text/javascript" src="../resources/js/common.js"></script>
</body>
</html>

