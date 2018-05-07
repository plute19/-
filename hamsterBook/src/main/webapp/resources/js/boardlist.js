/**
 * 
 */
function boardlist(page) {
	
	//location.href = "boardlist?page=" + page;
	var form = document.createElement("form");
	form.action = "list";
	form.method = "get";

	var hiddenpage = document.createElement("input");
	hiddenpage.name = "page";
	hiddenpage.value = page;
	hiddenpage.type = "hidden";

	var limit = document.createElement("input");
	limit.name = "limit";
	limit.value = document.getElementById("limit").value;
	limit.type = "hidden";
	
	if(document.getElementById("option").value != '') {
		var option = document.createElement("input");
		option.name = "option";
		option.value = document.getElementById("option").value;
		option.type = "hidden";
		form.appendChild(option);
	}
	
	if(document.getElementById("keyword").value != '') {
		var keyword = document.createElement("input");
		keyword.name = "keyword";
		keyword.value = document.getElementById("keyword").value;
		keyword.type = "hidden";
		form.appendChild(keyword);
	}
	
	form.appendChild(hiddenpage);
	form.appendChild(limit);
	document.body.appendChild(form);
	
	form.submit();
}

function updateBoard(boardnum) {
	var form = document.createElement("form");
	form.action = "update";
	form.method = "post";
	
	var hiddenpage = document.createElement("input");
	hiddenpage.name = "boardnum";
	hiddenpage.value = boardnum;
	hiddenpage.type = "hidden";
	
	form.appendChild(hiddenpage);
	document.body.appendChild(form);
	
	form.submit();
	
}

function deleteBoard(boardnum, savedfile, username) {
	
	if(!confirm("정말 삭제하시겠습니까?")) return;
	
	var form = document.createElement("form");
	form.action = "delete";
	form.method = "post";
	
	var hiddenpage = document.createElement("input");
	hiddenpage.name = "boardnum";
	hiddenpage.value = boardnum;
	hiddenpage.type = "hidden";
	
	var hiddenpage2 = document.createElement("input");
	hiddenpage2.name = "savedfile";
	hiddenpage2.value = savedfile;
	hiddenpage2.type = "hidden";
	
	var hiddenpage3 = document.createElement("input");
	hiddenpage3.name = "nickname";
	hiddenpage3.value = username;
	hiddenpage3.type = "hidden";
	
	form.appendChild(hiddenpage);
	form.appendChild(hiddenpage2);
	document.body.appendChild(form);
	
	form.submit();
	
}