<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>정보입력</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>

</head>
<body>
<div class = "container p-5 my-5 border">
	<div>
		<h3>부서정보등록</h3>
	</div>
	<br>
		
	<!-- msg 파라메타 값이 있으면 출력 -->
	<%
		if(request.getParameter("msg1") != null) {
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
	<form method="post" action="<%=request.getContextPath()%>/dept/insertDeptAction.jsp">
		
	<%
		if(request.getParameter("msg1") != null) {
	%>
		<div>
			<div>
				부서번호
			</div>
			<div>
				<input type="text" name="no" value=<%=request.getParameter("deptNo")%>>
			</div>
		</div>
		<div>
			<div>
				부서명
			</div>
			<div>
				<input type="text" name="name">
			</div>
		</div>
	<%
		} else if(request.getParameter("msg2") != null) {
	%>
		<div>
			<div>
				부서번호
			</div>
			<div>
				<input type="text" name="no">
			</div>
		</div>
		<div>
			<div>
				부서명
			</div>
			<div>
				<input type="text" name="name" value=<%=request.getParameter("deptName")%>>
			</div>
		</div>
	<%
		}
	%>
		
		<div>
			<button type="submit" class="btn btn-outline-success">정보등록</button>
		</div>
	</form>
</div>
</body>
</html>