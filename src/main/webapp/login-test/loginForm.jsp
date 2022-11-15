<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<form method="post" action="<%=request.getContextPath()%>/loginAction.jsp">
		<table>
			<tr>
				<td>ID</td>
				<td><input tpye="text" name="id"></td>
			</tr>
			<tr>
				<td>PW</td>
				<td><input type="password" name="pw"></td>
			</tr>
		
		</table>
	</form>


</body>
</html>