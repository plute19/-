/**
 * 
 */

function deleteConfirm() {
	if(confirm("정말 삭제하시겠습니까?")) {
		return true;
	}
	return false;
}

function formCheck() {
	var id = document.getElementById("id");
	var retext = document.getElementById("retext");
	
	if(retext.value == '') {
		alert("본문을 작성해주세요");
		retext.focus();
		return false;
	}
	
	return true;
}