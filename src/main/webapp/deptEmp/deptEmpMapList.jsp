<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>

<%
	// 페이징
	int currentPage=1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	
	// 드라이버 로딩 
	String driver="org.mariadb.jdbc.Driver"; // 변수를 사용하면 유지보수에 용이
	String dbUrl="jdbc:mariadb://localhost:3306/employees";
	String dbUser="root";
	String dbPw="java1234";
	
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
		System.out.println("=드라이버로딩 성공=");
		
	
	// 페이징
	int rowPerPage=10;
	int beginRow=(currentPage-1) * rowPerPage;
			
	String cntSql="SELECT COUNT(*) cnt FROM dept_emp";
	PreparedStatement cntStmt=conn.prepareStatement(cntSql);
	ResultSet cntRs=cntStmt.executeQuery();
	int cnt=0; //전체 행의 수
	if(cntRs.next()) {
		cnt=cntRs.getInt("cnt");
	}	
	int lastPage=(int)(Math.ceil((double)cnt / (double)rowPerPage));
	
	
	// 쿼리실행
	String sql = "SELECT de.emp_no empNo, de.dept_no deptNo, de.from_date fromDate, de.to_date toDate, e.first_name firstName, e.last_name lastName, d.dept_name deptName FROM dept_emp de INNER JOIN employees e ON de.emp_no=e.emp_no INNER JOIN departments d ON de.dept_no=d.dept_no ORDER BY de.emp_no ASC LIMIT ?, ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, beginRow);
	stmt.setInt(2, rowPerPage);
	ResultSet rs = stmt.executeQuery();
		
	/*
	SELECT de.emp_no empNo
		, de.dept_no deptNo
		, de.from_date fromDate
		, de.to_date toDate 
		, e.first_name firstName
		, e.last_name lastName
		, d.dept_name deptName
	FROM dept_emp de 
	INNER JOIN employees e 
		ON de.emp_no=e.emp_no 
	INNER JOIN departments d 
		ON de.dept_no=d.dept_no 
	ORDER BY de.emp_no ASC LIMIT ?, ?
	*/
	
	ArrayList<HashMap<String, Object>> list=new ArrayList<HashMap<String, Object>>();
	while(rs.next()) {
		HashMap<String, Object> m=new HashMap<String, Object>();
		m.put("empNo", rs.getInt("empNo"));
		m.put("firstName", rs.getString("firstName"));
		m.put("lastName", rs.getString("lastName"));		
		m.put("deptNo",rs.getString("deptNo"));
		m.put("deptName",rs.getString("deptName"));
		m.put("fromDate",rs.getString("fromDate"));
		m.put("toDate",rs.getString("toDate"));
		list.add(m);
	}

	rs.close();
	stmt.close();
	conn.close();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h2>사원정보</h2>
		<table>
			<tr>
				<th>사원번호</th>
				<th>사원명</th>
				<th>부서명</th>			
				<th>근무기간</th>
			</tr>
			<%
				for(HashMap<String, Object> de:list) {
			%>
				<tr>
					<td><%=de.get("empNo")%></td>
					<td><%=de.get("firstName")+" "+de.get("lastName")%></td>
					<td><%=de.get("deptName")%></td>
					<td><%=de.get("fromDate")+" "+"-"+" "+de.get("toDate")%></td>
				</tr>
			<%
				}
			%>
		</table>
		
	<!-- 페이징 -->
	<div>
		<span>
			<%
				if(currentPage > 1) {
			%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=1">처음</a>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage-1%>">이전</a>
			<%
				}
			%>
		</span>
		<span><%=currentPage%></span>
		<span>
			<%
				if(currentPage < lastPage) { 
			%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage+1%>">다음</a>
			<%
				}
			%>		
		</span>
		<span>
			<%
				if(currentPage < lastPage) {
			%>
				<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=lastPage%>">마지막</a>
			<%
				}
			%>
		</span>
	</div>
	<div>
		<form action="<%=request.getContextPath()%>/deptEmp/deptEmpList2.jsp" method="post">
			<label for="word">찾기 : </label>
			<input type="text" name="word" id="word">
			<button type="submit">&#128269;</button>
			<button type="button" onclick="location.href='deptEmpList.jsp'">전체목록보기</button>
		</form>
	</div>
		
</body>
</html>