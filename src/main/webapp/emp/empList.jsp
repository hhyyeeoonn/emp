<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>

<%
	// 1
	// 페이지 알고리즘
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
		
		System.out.println("currentPage->request.getParameter() = "+currentPage);
	}
	
	// 2
	int rowPerPage = 10; // 한 페이지당 출력할 데이터의 개수
	System.out.println("--------------------------------EMP_LIST--------------------------------");

	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// lastPage 처리
	String countSql = "SELECT COUNT(*) FROM employees";
	PreparedStatement countStmt = conn.prepareStatement(countSql);
	
	ResultSet countRs = countStmt.executeQuery();
	int count = 0;
	if(countRs.next()) {
		count = countRs.getInt("COUNT(*)");
	}
	
	int lastPage = count / rowPerPage;
	if(count % rowPerPage != 0) {
		lastPage = lastPage + 1; // lastPage++, lastPage+=1
	}
	
	
	// 한페이지당 출력할 emp목록
	String empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no DESC LIMIT ?, ?";
	PreparedStatement empStmt = conn.prepareStatement(empSql);
	empStmt.setInt(1, rowPerPage * (currentPage - 1));
	empStmt.setInt(2 , rowPerPage);
	ResultSet empRs = empStmt.executeQuery();
	
	ArrayList<Employee> empList=new ArrayList<Employee>();
	while(empRs.next()) {
		Employee e = new Employee();
		e.empNo = empRs.getInt("empNo");
		e.firstName = empRs.getString("firstName");
		e.lastName = empRs.getString("lastName");
		empList.add(e);
	}
	
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>

</head>
<body>
	
	<!-- 메뉴 partial jsp 구성 -->
	<div> <!-- jsp 액션태그 모델원에 사용하려고 탄생함 %와 같은 역할-->
		<jsp:include page="/inc/menu.jsp"></jsp:include> <!-- 서버가 주체 include는 절대주소를 적을 때 context가 필요없다 이미 같은 emp안에 있으니까(?) -->
	
	</div>

	<h1>사원목록</h1>
	<table border="1">
		<tr>
			<th>사원번호</th>
			<th>퍼스트네임</th>
			<th>라스트네임</th>
		</tr>
		<%
			for(Employee e : empList) {
		%>
				<tr>
					<td><%=e.empNo%></td>
					<td><a href="/dept/deptList.jsp"><%=e.firstName%></a></td>
					<td><%=e.lastName%></td>
				</tr>
		<%		
			}
		%>
	</table>
	
	
	<!-- 페이징 코드 -->
	<div>
		<%
			if(currentPage > 1) {				
		%>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1">처음</a>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전</a>
		<%
			}
		%>
			<span><%=currentPage%></span>
		<%
		
			if(currentPage < lastPage) {
		%>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>">다음</a>	
		<%	
			}
		%>
		<%
			if((currentPage > 1) && (currentPage <= (lastPage - 1))) {
		%>
			<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>">마지막</a>
		<%
			}
		%>
	</div>
	
	<!-- 검색창 -->	
		<form action="<%=request.getContextPath()%>/emp/empList2.jsp" method="post">
			<label for="word">사원 검색 : </label>
			<input type="text" name="word" id="word">
			<button type="submit">검색</button>
		</form>
	
</body>
</html>
