/**
 * 
 */
// 로그인 창 보이기
function showLogin() {
	document.getElementById('login').style.display='block';
}

// 회원가입 창 보이기
function showJoin(userEmail) {
	document.getElementById('verify-email').style.display='none';
	document.getElementById('join').style.display='block';
	$('#join-email').attr('value', userEmail);
	$('#join-email').css('background', 'rgba(220, 220, 220, 0.7)');
}

//정보수정 창 보이기
function showUpdate() {
	$('#join-email').css('background', 'rgba(220, 220, 220, 0.7)');
	document.getElementById('update').style.display='block';
}

//회원 탈퇴 창 보이기
function showLeave() {
	document.getElementById('update').style.display='none';
	document.getElementById('leave').style.display='block';
}

//가입 전 이메일 검증 창 보이기
function openEmailCheck() {
	$('#verify-code').css('background', 'rgba(220, 220, 220, 0.7)');
	document.getElementById('login').style.display='none';
	document.getElementById('verify-email').style.display='block';
}

//비밀번호 찾기 창 보이기
function openFindPassword() {
	document.getElementById('login').style.display='none';
	document.getElementById('find-password').style.display='block';
}

//이메일 변경창 열기
function showUpdateEmail() {
	$('#verify-code').css('background', 'rgba(220, 220, 220, 0.7)');
	$('#before-email').css('background', 'rgba(220, 220, 220, 0.7)');
	document.getElementById('update').style.display='none';
	document.getElementById('update-email').style.display='block';
}

//입력한 이메일로 인증코드발송
function sendCode(goRoot) {
		
	$('#verify-userEmail').val()
	
	$('#verify-userEmail').css('background', 'rgba(220, 220, 220, 0.7)');
	$('#verify-userEmail').attr('readonly', 'readonry');
	$('#sendCode-button').attr('disabled', 'disabled');
	
	$.ajax({
		url: goRoot + 'sendMail/sendCode',
		type: 'post',
		data: {
			userEmail: $('#verify-userEmail').val()
		},
		dataType: 'text',
		success: function(result) {
			if (result == 'send') {
				alert('인증코드를 발송했습니다. 메일함을 확인해주세요.');
				$('#submitCode-button').removeAttr('disabled');
				$('#verify-code').removeAttr('disabled');
				$('#verify-code').css('background', '');
			} else {
				alert('메일 발송에 실패했습니다......');
				$('#verify-userEmail').css('background', '');
				$('#verify-userEmail').removeAttr('readonly');
				$('#sendCode-button').removeAttr('disabled');
			}
		},
		error: function(e) {
			alert('오류 발생, 코드 ->' + e.status)
			$('#verify-userEmail').css('background', '');
			$('#verify-userEmail').removeAttr('readonly');
			$('#sendCode-button').removeAttr('disabled');
		}
	});
}

//인증코드 입력
function submitCode(goRoot, isMyPage) {
	
	if ($('#verify-code').val() == '') {
		alert('인증코드를 입력해주세요.');
		return;
	}
	
	$.ajax({
		url: goRoot + 'member/submitCode',
		type: 'post',
		data: {
			userCode: $('#verify-code').val()
		},
		dataType: 'text',
		success: function(result) {
				if (result == 'ok') {
					alert('인증되었습니다.');
					if (isMyPage == '') {
						//회원가입 창 띄우고 가입 진행
						showJoin($('#verify-userEmail').val());
					} else {		
						updateEmail();
					}
				} else {
					alert("인증코드가 일치하지 않습니다.");
				}
		},
		error: function(e) {
			alert('오류 발생, 코드 ->' + e.status)
		}
	});
}

//비밀번호 찾기
function findPassword(goRoot) {
	
	$('#findPassword-email').attr('disabled', 'disabled');
	$('#findPassword-button').attr('disabled', 'disabled');
	
	$.ajax({
		url: goRoot + 'sendMail/password',
		type: 'post',
		data: {
			userEmail: $('#findPassword-email').val()
		},
		dataType: 'text',
		success: function(result) {
				if (result == 'send') {
					//회원가입 창 띄우고 가입 진행
					alert("임시 비밀번호를 메일로 발송했습니다.");
					location.reload();
				} else {
					alert("가입된 이메일 계정이 아닙니다.");
					$('#findPassword-email').removeAttr('disabled');
					$('#findPassword-button').removeAttr('disabled');
				}
		},
		error: function(e) {
			alert('오류 발생, 코드 ->' + e.status);
			$('#findPassword-email').removeAttr('disabled');
			$('#findPassword-button').removeAttr('disabled');
		}
	});
	
}

//이메일 변경
function updateEmail() {
	$.ajax({
		url: 'updateEmail',
		type: 'post',
		data: {
			beforeUserEmail: $('#before-email').val(),
			userEmail: $('#before-userEmail').val()
		},
		dataType: 'text',
		success: function(result) {
				if (result == 1) {
					alert("변경되었습니다.");
					location.reload();
				} else {
					alert("오류 발생...");
				}
		},
		error: function(e) {
			alert('오류 발생, 코드 ->' + e.status)
		}
	});
}

// 로그인 처리
function login(goRoot) {

	if (!loginFormCheck()) {
		return;
	}
	
	$.ajax({
		url: goRoot + 'member/login',
		type: 'post',
		data: $('#login-form').serialize(),
		dataType: 'text',
		success: function(result) {
			if (result == 1) {
				alert('로그인되었습니다.');
				location.reload();
			} else {
				alert('이메일 또는 비밀번호가 잘못되었습니다.');
			}
		},
		error: function(e) {
			alert('문제 발생. 문제가 반복되면 고객센터에 문의해주세요. 에러코드 -> ' + e.status);
		}
	});
}

// 회원가입 처리
function join(goRoot) {
	
	if(!joinFormCheck()) {
		return;
	}
	
	$.ajax({
		url: goRoot + 'member/join',
		type: 'post',
		data: $('#join-form').serialize(),
		dataType: 'text',
		success: function(result) {
			if (result == 1) {
				alert('가입되었습니다.');
				location.reload();
			} else {
				alert('문제 발생. 문제가 반복되면 고객센터에 문의해주세요.');
			}		
		},
		error: function(e) {
			alert('문제 발생. 문제가 반복되면 고객센터에 문의해주세요. 에러코드 -> ' + e.status);
		}
	});
}

//회원 정보 수정
function update(goRoot) {
	
	if(!joinFormCheck()) {
		return;
	}
	
	$.ajax({
		url: goRoot + 'member/updateMember',
		type: 'post',
		data: $('#update-form').serialize(),
		dataType: 'text',
		success: function(result) {
			if (result == 1) {
				alert('수정되었습니다.');
				location.reload();
			} else {
				alert('문제 발생. 문제가 반복되면 고객센터에 문의해주세요.');
			}		
		},
		error: function(e) {
			alert('문제 발생. 문제가 반복되면 고객센터에 문의해주세요. 에러코드 -> ' + e.status);
		}
	});
}

// 회원가입.수정 폼 유효성 2차 검사
function joinFormCheck() {
	var email = $('#join-email');
	var nickname = $('#join-nickname');
	var pw = $('#join-pw');
	var pw2 = $('#join-pw2');
	
	//이메일 유효성 검사
	var regEmail = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
	if (regEmail.test(email.val())) {
		if (email.val().length < 30) {
			//이메일 유효성 통과		
		} else {
			alert('길이가 너무 깁니다.');
			return false;
		}
	} else {
		//실패
		alert('이메일 형식에 맞지 않습니다.');
		return false;
	}
	
	//닉네임 유효성 검사
	var regNickname = /[0-9a-zA-Z가-힣]{2,14}/;
	if (regNickname.test(nickname.val())) {
		// 통과
	} else {
		// fail
		alert('닉네임은 특수문자 제외 2~14자리만 가능합니다.');
		return false;
	}
	
 	//비밀번호 유효성 검사
	var regPw = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,14}$/;
	if (regPw.test(pw.val())) {
		// 비밀번호 유효성 통과
	} else {
		// fail
		alert('비밀번호는 8~14자리, 하나 이상의 영문, 숫자, 특수문자가 포함되어야 합니다.');	
		return false;
	} 
	
	if (pw.val() == pw2.val()) {
		// 비밀번호 일치
	} else {
		// fail
		alert('비밀번호가 일치하지 않습니다.');
		return false;
	}
	
	return true;
}

// 로그인 폼 유효성 검사
function loginFormCheck() {
	if ($('#login-email').val() == '') {
		alert('이메일을 입력해주세요.');
		return false;
	}
	
	if ($('#login-pw').val() == '') {
		alert('비밀번호를 입력해주세요.');
		return false;
	}
	
	return true;
}

// 로그아웃 처리
function logout(goRoot) {
	$.ajax({
		url: goRoot + 'member/logout',
		type: 'post',
		dataType: 'text',
		success: function (result) {
			if (result == 1) {
				alert('로그아웃 되었습니다.');
				location.reload();
			} else {
				alert('문제 발생. 문제가 반복되면 연락바랍니다.');
			}
		},
		error: function (e) {
			alert('문제 발생. 문제가 반복되면 연락바랍니다. 에러코드 -> ' + e.status);
		}
	});
}

// 실시간 이메일 유효성&중복 검사
function emailCheck(goRoot, inputUserEmail) {
	
	//내용 입력 시마다 우선 전송 버튼을 비활성화
	$('#sendCode-button').attr('disabled', 'disabled');
	
	//정보 수정의 경우 기존 이메일과 동일하면 그냥 리턴
	if ($('#verify-userEmail').val() == inputUserEmail) {
		$('#emailCheck').html('')
		return;
	}
	
	//이메일 유효성 검사
	var regEmail = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
	if (regEmail.test($('#verify-userEmail').val())) {
		if ($('#verify-userEmail').val().length < 30) {
			//이메일 유효성 통과		
		} else {
			$('#emailCheck').html('너무 깁니다.').css('color', 'red');
			return false;
		}
	} else {
		//실패
		$('#emailCheck').html('이메일 형식에 맞지 않습니다.').css('color', 'red');
		return false;
	}

	$.ajax({
		url: goRoot+'member/duplicateCheck',
		type: 'post',
		data: {
			userEmail: $('#verify-userEmail').val()
		},
		dataType: 'text',
		success: function(result) {
			
			if (result == 1) {
				// 존재하는 이메일
				$('#emailCheck').html('이미 존재하는 이메일').css('color', 'red');
			} else {
				// 가입 또는 수정 가능한 이메일일 경우 보내기버튼 활성화
				$('#sendCode-button').removeAttr('disabled');
				if (inputUserEmail == '') {
					// 가입가능
					$('#emailCheck').html('가입 가능').css('color', 'green');
				} else {
					// 수정가능
					$('#emailCheck').html('수정 가능').css('color', 'green');
				}
				
			}
		},
		error: function(e) {
			alert('오류 발생 -> ' + e.status);
		}
	});
}

// 실시간 닉네임 유효성&중복 검사
function nicknameCheck(goRoot, userNickname) {
	
	//정보 수정의 경우 기존 닉네임과 동일하면 그냥 리턴
	if ($('#join-nickname').val() == userNickname) {
		$('#nicknameCheck').html('');
		return;
	}
	
	//닉네임 유효성 검사
	var regNickname = /[0-9a-zA-Z가-힣]{2,14}/;
	if (regNickname.test($('#join-nickname').val())) {
		// 통과
	} else {
		// fail
		$('#nicknameCheck').html('닉네임은 특수문자 제외 2~14자리만 가능합니다').css('color', 'red');
		return;
	}

	$.ajax({
		url: goRoot+'member/duplicateCheck',
		type: 'post',
		data: {
			nickname: $('#join-nickname').val()
		},
		dataType: 'text',
		success: function(result) {
			if (result == 1) {
				// 존재하는 닉네임
				$('#nicknameCheck').html('존재하는 닉네임').css('color', 'red');
			} else {
				// 가입가능한 닉네임
				if (userNickname == '') {
					//회원 가입의 경우
					$('#nicknameCheck').html('가입 가능').css('color', 'green');					
				} else {
					//정보 수정의 경우
					$('#nicknameCheck').html('수정 가능').css('color', 'green');
				}
			}
		},
		error: function(e) {
			$('#nicknameCheck').html('오류 발생. 잠시 후 다시 시도해보세요.').css('color', 'red');
		}
	});
}

// 실시간 비밀번호 유효성 검사
function passwordCheck() {
	
	var pw = $('#join-pw');
	var pw2 = $('#join-pw2');
	
	//비밀번호 유효성 검사
	var regPw = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,14}$/;
	if (regPw.test(pw.val())) {
		// 비밀번호 유효성 통과
	} else {
		// fail
		$('#passwordCheck').html('비밀번호는 8~14자리, 하나 이상의 영문,숫자,특수문자가 포함되어야 합니다.').css('color', 'red');
		return false;
	} 
	
	$('#passwordCheck').html('가입 가능').css('color', 'green');
	
	if (pw.val() == pw2.val()) {
		// 비밀번호 일치
	} else {
		// fail
		$('#passwordCheck2').html('비밀번호가 일치하지 않습니다.').css('color', 'red');
		return false;
	}
	
	$('#passwordCheck2').html('가입 가능').css('color', 'green');
	
}

//회원 탈퇴..
function leave() {
	
	if (!confirm('정말 탈퇴...?')) {
		return;
	}
	
	$.ajax({
		url: 'deleteMember',
		type: 'post',
		data: $('#leave-form').serialize(),
		dataType: 'text',
		success: function(result) {
			if (result == 1) {
				alert('안녕.......');
				location.href='../';
			} else {
				alert('비밀번호가 맞지 않음.....');
			}
		},
		error: function(e) {
			alert('오류 발생.. 코드-> ' + e.status);
		}
	});
}

// 우상단 검색창 검색 쿼리
function autoSearch (goRoot) {
	
	if ($('#searchBar').val() == '') {
		return;
	}
	
	$.ajax({
		url: goRoot + 'book/getBookList',
		type: 'post',
		data: {
			keyword: $('#searchBar').val(),
			limit: '5',
			page: '1',
			searchOption: 'title',
			opderOption: 'hit'
		},
		dataType: 'json',
		success: function(result) {
			searchResult(result.bookList, goRoot)
		}
	});
}

// 우상단 검색창 검색 결과 보여주기
function searchResult(bookList, goRoot) {
	
	var html = '';
	
	$(bookList).each(function(i, book) {
		if (book.isbn.length > 13) {
			//두 가지 isbn을 모두 가진 경우
			var isbn = book.isbn.split(' ')[1];
		} else {
			//한 가지 isbn만 가진 경우
			var isbn = book.isbn;
		}
		html += '<a href="'+ goRoot + 'book/info?isbn=' + isbn + '" class="w3-bar-item w3-button w3-search-result">' + book.title + '</a>';
	});
	
	$('#Div-searchResult').html(html);
	$('.w3-dropdown-content-search').css('display', 'block');
	
}

// 우상단 검색결과를 제외한 윈도우 클릭시 검색 결과 닫기
function closeSearchResult() {
	$('.w3-dropdown-content-search').css('display', 'none');
}

// 우상단 검색결과에서 책 클릭 시 책 정보 페이지로 이동
function searchBook(goRoot) {
	var keyword = $('#searchBar').val();
	location.href= goRoot + "book/list?searchOption=title&keyword=" + keyword;
}

// 책 리스트 요청(루트 경로, 요청할 페이지, 페이지 당 결과, 검색 옵션, 검색어, 정렬 순서, 기간 설정, 마이페이지 여부)
function getBookList(goRoot, page, limit, searchOption, keyword, orderOption, period, myPage) {
	
	$.ajax({
		url: goRoot + 'book/getBookList',
		type: 'post',
		data: {
			limit: limit,
			page: page,
			searchOption: searchOption,
			keyword : keyword,
			orderOption: orderOption,
			period : period,
			myPage : myPage
		},
		dataType: 'json',
		success: function(result) {
			if (orderOption == 'hitdate') {
				//좋아요 누른 날짜 순서이므로 마이페이지의 좋아요 한 책 목록임.
				showLikeBookList(result)
			} else {
				showBookList(result)
			}
		},
		error: function(e) {
			alert(JSON.stringify(e));
		}
	});
}

// 문장 리스트 요청(루트 경로, 요청할 페이지, 페이지 당 결과, 검색 옵션, 검색어, 정렬 순서, 기간 설정, 마이페이지 여부)
function getSentence(goRoot, page, limit, searchOption, keyword, orderOption, period, myPage) {
	$.ajax({
		url: goRoot + 'sentence/getSentenceList',
		type: 'post',
		data: {
			page: page,
			limit: limit,
			searchOption: searchOption,
			keyword: keyword,
			orderOption: orderOption,
			period: period,
			myPage: myPage
		},
		dataType: 'json',
		success: function(result) {
			if (orderOption == 'hitdate') {
				//좋아요 누른 날짜 순서이므로 마이페이지의 좋아요 한 책 목록임.
				showLikeSentence(result)
			} else {
				showSentence(result);
			}
		},
		error: function(result) {
			showSentence('fail');		
		}
	});
}

// 리뷰 가져오기(루트 경로, 요청할 페이지, 페이지 당 결과, 검색 옵션, 검색어, 정렬 순서, 기간 설정)
function getReview(goRoot, page, limit, searchOption, keyword, orderOption, period, myPage) {
	
	$.ajax({
		url: goRoot + 'book/getReview',
		type: 'post',
		data: {
			page: page,
			limit: limit,
			searchOption: searchOption,
			keyword: keyword,
			orderOption: orderOption,
			period: period
		},
		dataType: 'json',
		success: function(result) {
			showReview(result);
		},
		error: function(result) {
			showReview('fail');		
		}
	});
}

// 메뉴 접고 펴기
function myFunction() {
    var x = document.getElementById("navDemo");
    if (x.className.indexOf("w3-show") == -1) {
        x.className += " w3-show";
    } else { 
        x.className = x.className.replace(" w3-show", "");
    }
}
