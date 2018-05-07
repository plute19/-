/**
 * 
 */

function formCheck() {
	var title = document.getElementById("title");
	var content = document.getElementById("content");
	
	if(title.value == '') {
		alert("제목을 작성해주세요");
		title.focus();
		return false;
	} else if(content.value == '') {
		alert("본문을 작성해주세요");
		content.focus();
		return false;
	}
	
	if (content.value.match(/<\/script>/) != null) {
		alert('부적절한 내용이 포함되어 있습니다..');
		content.focus();
		return false;
	}
	
	return true;
	
}

function userConfirm(massage) {
	if(confirm(massage)) {
		return true;
	}
}