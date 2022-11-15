<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insertBListForm</title>

	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>


</head>
<body>

	<form method="post" action="<%=request.getContextPath()%>/board/insertBListAction.jsp">
	<%
		if(request.getParameter("msg1") != null) {
	%>
		<div>
			<span>제목</span>
			<span>
				<input type="text" name="title">
			</span>
		</div>
		<div>
			<span>글쓴이</span>
			<span>
				<input type="text" name="name" value="<%=request.getParameter("boardWriter")%>">
			</span>
			<span>비밀번호</span>
			<span>
				<input type="text" name="pw">
			</span>
		</div>
	<%
		} else if(request.getParameter("msg2") != null) {
	%>
		<div>
			<span>제목</span>
			<span>
				<input type="text" name="title" value="<%=request.getParameter("boardTitle")%>">
			</span>
		</div>
		<div>
			<span>글쓴이</span>
			<span>
				<input type="text" name="name" value="<%=request.getParameter("boardWriter")%>">
			</span>
			<span>비밀번호</span>
			<span>
				<input type="text" name="pw">
			</span>
		</div>
	<%
		}	
	%>
	
	<div>내용</div>
	
	<%
		if(request.getParameter("msg1") != null || request.getParameter("msg2") != null) {
	%>
		<div>
			<textarea row = "30" cols = "100" name = "memo" value="<%=request.getParameter("boardContent")%>"></textarea>
		</div>
		
	<%
		}
	%>
	
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
		} else if(request.getParameter("msg1") != null) {
	%>
		<div>
			<h5><small><%=request.getParameter("msg1")%></small></h5>
		</div>
	<%		
		} else if(request.getParameter("msg2") != null) {
	%>
		<div>
			<h5><small><%=request.getParameter("msg2")%></small></h5>
		</div>
	<% 
		}
	%>
	
	
	</form>
	
	
</body>
</html>

		
