<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %> 
<%@ page import = "java.util.*" %>
<%
int cnt1=0;
	//페이징
	int currentPage=1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	request.setCharacterEncoding("utf-8");
	String word = request.getParameter("word");
	System.out.println("디버깅" + cnt1++);
	
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
	
	String cntSql=null;
	PreparedStatement cntStmt=null;
	
	if(word == null) {
		word="";
	}
	
	System.out.println("디버깅" + cnt1++);
	
	if((word == null) || (word.equals(""))) {
		cntSql="SELECT COUNT(*) cnt FROM salaries";
		cntStmt=conn.prepareStatement(cntSql);
	} else {
		cntSql = "SELECT COUNT(*) cnt FROM salaries s INNER JOIN employees e ON s.emp_no=e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE ?";
	    cntStmt = conn.prepareStatement(cntSql);
	    cntStmt.setString(1, "%"+word+"%");
	    cntStmt.setString(2, "%"+word+"%");
	}
	ResultSet cntRs=cntStmt.executeQuery();
	
	System.out.println("디버깅" + cnt1++);
	
	int cnt=0; //전체 행의 수
	if(cntRs.next()) {
		cnt=cntRs.getInt("cnt");
	}	
	int lastPage=(int)(Math.ceil((double)cnt / (double)rowPerPage));
	
	
	// 쿼리실행
	
	/*
	SELECT s.emp_no empNo
		, s.salary salary
		, s.from_date fromDate
		, s.to_date toDate
		, e.first_name firstName
		, e.last_name lastName 
	FROM salaries s 
	INNER JOIN employees e 
		ON s.emp_no = e.emp_no 
	ORDER BY s.emp_no ASC LIMIT ?,?
	*/
	
	String sql=null;
	PreparedStatement stmt=null;
	
	if((word == null) || (word.equals(""))) {
		sql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
	} else {
		sql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE ? ORDER BY s.emp_no ASC LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+word+"%");
	    stmt.setString(2, "%"+word+"%");
		stmt.setInt(3, beginRow);
		stmt.setInt(4, rowPerPage);
	}
	ResultSet rs=stmt.executeQuery();
	
	/*
	ArrayList<Salary> salaryList = new ArrayList<>();
	while(rs.next()) {
		Salary s = new Salary();
		s.emp = new Employee(); // ☆☆☆☆☆
		s.emp.empNo = rs.getInt("empNo");
		s.salary = rs.getInt("salary");
		s.fromDate = rs.getString("fromDate");
		s.toDate = rs.getString("toDate");
		s.emp.firstName = rs.getString("firstName");
		s.emp.lastName = rs.getString("lastName");
		salaryList.add(s);
	}
	*/
	
	ArrayList<HashMap<String, Object>> list=new ArrayList<HashMap<String, Object>>(); // class Salary... ArrayList<Salary> salaryList = new ArrayList<>();
	while(rs.next()) {
		HashMap<String, Object> m=new HashMap<String, Object>(); // class Salary... Salary s = new Salary();
		m.put("empNo", rs.getInt("empNo"));
		m.put("salary", rs.getInt("salary"));
		m.put("firstName", rs.getString("firstName"));		
		m.put("fromDate",rs.getString("fromDate"));
		m.put("toDate",rs.getString("toDate"));
		m.put("fromDate",rs.getString("fromDate"));
		m.put("lastName",rs.getString("lastName"));
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

	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>

</head>
<body>
<div class="container">
	<div class="container p-5 my-5 border">
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<div class="container p-5 my-5 border">
		<h3>사원별 연봉정보</h3>
		<table class="table">
			<tr>
				<th>사원번호</th>
				<th>이름</th>
				<th>연봉</th>
				<th>근무일자</th>
			</tr>
			<%
				for(HashMap<String, Object> s:list) {
			%>
					<tr>
						<td><%=s.get("empNo")%></td>
						<td><%=s.get("firstName")+" "+s.get("lastName")%></td>
						<td><%=s.get("salary")%></td>
						<td><%=s.get("fromDate")+" "+"-"+" "+s.get("toDate")%></td>
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
						<a href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=1&word=<%=word%>">처음</a>
						<a href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>">이전</a>
				<%
					}
				%>
			</span>
			<span><%=currentPage%></span>
			<span>
				<%
					if(currentPage < lastPage) { 
				%>
						<a href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>">다음</a>
				<%
					}
				%>		
			</span>
			<span>
				<%
					if(currentPage < lastPage) {
				%>
					<a href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=lastPage%>&word=<%=word%>">마지막</a>
				<%
					}
				%>
			</span>
		</div>
		
		
		<!-- 검색기능 -->
		<div>
			<form action="<%=request.getContextPath()%>/salary/salaryMapList.jsp" method="post">
				<label for="word">사원검색 : </label>
				<input type="text" name="word" id="word" value="<%=word%>">
				<button type="submit">&#128269;</button>
				<button type="button" onclick="location.href='salaryList.jsp'">전체목록보기</button>
			</form>
		</div>
		
	</div>
</div>
</body>
</html>