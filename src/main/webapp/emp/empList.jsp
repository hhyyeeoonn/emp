<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	
	<div> <!-- jsp 액션태그 모델원에 사용하려고 탄생함 %와 같은 역할-->
		<jsp:include page="/inc/menu.jsp"></jsp:include> <!-- 서버가 주체 include는 절대주소를 적을 때 context가 필요없다 이미 같은 emp안에 있으니까(?) -->
	
	</div>

	<h1>사원목록</h1>
	<%
		//페이지 알고리즘
		int currentPage=1;
		if(request.getParameter("currentPage") != null) {
			currentPage=Integer.parseInt(request.getParameter("currentPage"));
		}
	%>
	<div>현재 페이지 : <%=currentPage%></div>


	<!-- 페이징 코드 -->
	<div>
		<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전</a> <!-- currentPage가 1보다 클 때만 나옴 -->
		<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>">다음</a> <!-- currentPage가 마지막페이지보다 작을 때만 나옴 -->
	</div>



</body>
</html>



