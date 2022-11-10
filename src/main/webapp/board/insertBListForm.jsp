<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insertBListForm</title>
</head>
<body>

	<form method="post" action="<%=request.getContextPath()%>/board/insertBListAction.jsp">
	<div>
		<span>제목</span>
		<span>
			<input type="text" name="title">
		</span>
	</div>
	<div>
		<span>글쓴이</span>
		<span>
			<input type="text" name="name" width="25%;">
		</span>
		<span>비밀번호</span>
		<span>
			<input type="text" name="pw">
		</span>
	</div>
	<div>내용</div>
	<div>
		<textarea row = "30" cols = "100" name = "memo"></textarea>
	</div>
	
	
	<div>
		<button type="submit">등록</button>
	</div>
	
	<%
		if(request.getParameter("msg") != null) {
	%>
		<div>
		<h5><small><%=request.getParameter("msg")%></small></h5>
		</div>
	<%
		}
	%>
	
	</form>
	
	
</body>
</html>

		
