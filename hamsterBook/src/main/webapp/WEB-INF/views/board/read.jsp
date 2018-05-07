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
		<table border="1">
			<tr>
				<th>제목</th>
				<td><c:out value="${board.title }" escapeXml="true" /></td>
			</tr>
			<tr>
				<th>글쓴이</th>
				<td>${board.nickname }</td>
			</tr>
			<tr>
				<th>작성일</th>
				<td>${board.inputdate }</td>
			</tr>
			<tr>
				<th>본문</th>
				<td><c:out value="${board.content }" escapeXml="false"/> </td>
			</tr>
			<c:if test="${board.originalfile != null}">
				<tr>
					<th>첨부파일</th>
					<td>
						<c:if test="${board.originalfile != null}">
						
						</c:if>
						<a href="download?boardnum=${board.boardnum }" id="downloadLink">
							${board.originalfile }
						</a>
					</td>
				</tr>
			</c:if>
		</table>
		
		<c:if test="${board.nickname == sessionScope.userNickname }">
			<input type="button" value="수정" onclick="updateBoard('${board.boardnum}')">
			<input type="button" value="삭제" onclick="deleteBoard('${board.boardnum}', '${board.savedfile }', '$${sessionScope.userNickname }')">
		</c:if>
		<c:if test="${sessionScope.userNickname != null }">	
		<table>
			<tr>
				<th>댓글 작성</th>
				<td>
					<form action="insertReply" method="post">
						<input type="text" name="replyText"  required="required">
						<input type="hidden" name="nickname" value="${sessionScope.userNickname }">
						<input type="hidden" name="boardnum" value="${board.boardnum }">
						<input type="submit" value="등록">
					</form>
				</td>
			</tr>
		</table>
		</c:if>	
		<br>
		<table>
			<tr>
				<th>[  댓글 목록  ]</th>
			</tr>
			<c:if test="${reply != null }">
				<c:forEach items="${reply }" var="re">
					<tr>
						<th>${re.nickname }</th>
						<td>| <c:out value="${re.replyText }" escapeXml="true"></c:out></td>
						<td>| ${re.inputdate }</td>
					</tr>
				</c:forEach>
			</c:if>
			<c:if test="${reply == null }">
				<tr><th>등록된 댓글이 없음.....</th></tr>
			</c:if>
		</table>
		
		<br>
		<button onclick="location.href='list'">목록으로</button>
	</div>
	
	
	
	</div>


</body>
</html>