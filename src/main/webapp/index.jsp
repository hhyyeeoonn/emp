<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>index</title>
</head>
<body>
	<h1>INDEX</h1>
	<ol>
		<li>
			<a href="<%=request.getContextPath()%>/dept/deptList.jsp">
				부서관리
			</a>
		</li>
		<li>
			<a href="<%=request.getContextPath()%>/dept/insertDeptForm.jsp">
				부서추가
			</a>
		</li>
		<li>
			<a href="<%=request.getContextPath()%>/emp/empList.jsp">
				사원관리
			</a>
		</li>
	</ol>
</body>
</html>