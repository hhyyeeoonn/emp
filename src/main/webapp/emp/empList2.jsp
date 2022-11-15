<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>

<%
	// 페이지 알고리즘
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
		
		System.out.println("currentPage->request.getParameter() = "+currentPage);
	}
	
	int rowPerPage = 10; // 한 페이지당 출력할 데이터의 개수
	System.out.println("-----EMP_LIST------");

	
	
	// 1
	request.setCharacterEncoding("utf-8");
	String word = request.getParameter("word");
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	
	// lastPage 처리
	String countSql=null;
	PreparedStatement countStmt =null;
	
	if(word == null) {
		word="";
	}
	
	if((word == null) || (word.equals(""))) {
		countSql="SELECT COUNT(*) cnt FROM employees";
		countStmt=conn.prepareStatement(countSql);
	} else {
		countSql="SELECT COUNT(*) cnt FROM employees WHERE first_name LIKE ? OR last_name LIKE ?";
		countStmt = conn.prepareStatement(countSql);
		countStmt.setString(1, "%"+word+"%");
		countStmt.setString(2, "%"+word+"%");
	}
	
	ResultSet countRs = countStmt.executeQuery();
	int count = 0;
	if(countRs.next()) {
		count = countRs.getInt("cnt");
	}
	System.out.println(count+"<<<<<cnt");
	
	
	int lastPage = count / rowPerPage;
	if(count % rowPerPage != 0) {
		lastPage = lastPage + 1; 
	}
		System.out.println(count+"<<<<<cnt");
	
	
	
	// 한페이지당 출력할 emp목록
	
	String empSql2=null;
	PreparedStatement empStmt2 =null;
	
	if((word == null) || (word.equals(""))) {
		empSql2= "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no ASC LIMIT ?, ?";
		empStmt2 = conn.prepareStatement(empSql2);
		empStmt2.setInt(1, rowPerPage * (currentPage - 1)); //int beginRow=(currentPage-1)*ROW_PER_PAGE;
		empStmt2.setInt(2, rowPerPage);
	} else {
		empSql2= "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees WHERE first_name LIKE ? OR last_name LIKE ? ORDER BY emp_no ASC LIMIT ?, ?";
		empStmt2 = conn.prepareStatement(empSql2);
		empStmt2.setString(1, "%"+word+"%");
		empStmt2.setString(2, "%"+word+"%");
		empStmt2.setInt(3, rowPerPage * (currentPage - 1)); 
		empStmt2.setInt(4, rowPerPage);
	}
	
	ResultSet empRs=empStmt2.executeQuery();
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
</head>
<body>
	
	<!-- 메뉴 partial jsp 구성 -->
	<div> <!-- jsp 액션태그 모델원에 사용하려고 탄생함 %와 같은 역할-->
		<jsp:include page="/inc/menu.jsp"></jsp:include> <!-- 서버가 주체 include는 절대주소를 적을 때 context가 필요없다 이미 같은 emp안에 있으니까(?) -->
	
	</div>

	<h1>사원목록</h1>
	<div>현재 페이지 : <%=currentPage%></div>
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
				<a href="<%=request.getContextPath()%>/emp/empList2.jsp?currentPage=1&word=<%=word%>">처음</a>
				<a href="<%=request.getContextPath()%>/emp/empList2.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>">이전</a>
		<%
			}
		%>
			<span><%=currentPage%></span>
		<% 
			if(currentPage < lastPage) {
		%>
				<a href="<%=request.getContextPath()%>/emp/empList2.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>">다음</a>	
		<%	
			}
		%>
		<%
			if((currentPage > 1) && (currentPage <= (lastPage - 1))) {
		%>
			<a href="<%=request.getContextPath()%>/emp/empList2.jsp?currentPage=<%=lastPage%>&word=<%=word%>">마지막</a>
		<%
			}
		%>
	</div>
	
	<!-- 검색창 -->	
		<form action="<%=request.getContextPath()%>/emp/empList2.jsp" method="post">
			<label for="word">사원 검색 : </label>
			<input type="text" name="word" id="word" value="<%=word%>">
			<button type="submit">검색</button> 
			<button type="button" onclick="location.href='empList.jsp'">전체목록보기</button>
		</form>
		
	
</body>
</html>
