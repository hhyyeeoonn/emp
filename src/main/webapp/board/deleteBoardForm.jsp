<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 1
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String msg = request.getParameter("msg"); // 수정실패 리다이렉시에는 null값이 아니고 메세지 有

	
	
	
	// 2
	
	
	
	// 3


%>



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>deleteBoardForm</title>
</head>
<body>

<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<h1>게시글 삭제</h1>
	<%
		if(msg != null) {
	%>		
			<div><%=msg%></div>
	<%		
		}
	%>
	
	<form action="<%=request.getContextPath()%>/board/deleteBoardAction.jsp" method="post">
		<input type="hidden" name="boardNo" value="<%=boardNo%>">
		비밀번호 :
		<input type="password" name="boardPw">
		<button type="submit">삭제</button>
	

	</form>

</body>
</html>