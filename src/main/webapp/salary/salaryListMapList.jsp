<%@ page import="javax.print.attribute.standard.PresentationDirection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %> <!-- HashMap<키, 값> ArrayList<요소> -->

<%
	// 1 요청분석
	// 페이징 currentPage, ...
	
	
	// 2 요청처리
	// 페이징 currentPage, ...
	int rowPerPage=10;
	int beginRow=0;
	
	// db 연결 -> 모델생성
	String driver="org.mariadb.jdbc.Driver"; // 변수를 사용하면 유지보수에 용이
	String dbUrl="jdbc:mariadb://localhost:3306/employees";
	String dbUser="root";
	String dbPw="java1234";
	
	Class.forName(driver);
	Connection conn=DriverManager.getConnection(dbUrl, dbUser, dbPw); 
	String sql="SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, CONCAT(e.first_name, ' ', e.last_name) name FROM salaries s INNER JOIN employees e ON s.emp_no=e.emp_no ORDER BY s.emp_no ASC LIMIT ?, ?"; 
	//DriverManager.getConnection("프로토콜://주소:포트번호", "", ""); // CONCAT(괄호 안은 as쓰면 안됨)
	// 커넥션을 연결하는 메소드 /tcpip(?) 주소:아이피(숫자 0~255)or도메인(영문자로 맵핑) 프로토콜:http(s)://,jdbc:...
	PreparedStatement stmt=conn.prepareStatement(sql);
	stmt.setInt(1,beginRow);
	stmt.setInt(2,rowPerPage);
	ResultSet rs=stmt.executeQuery();
	
	ArrayList<HashMap<String, Object>> list=new ArrayList<HashMap<String, Object>>(); // 여러가지 타입은 Object 한 가지로 받을 수 있다
	while(rs.next()) { // 맵은 정형화되어있지 않다 
		HashMap<String, Object> m=new HashMap<String, Object>();
		m.put("empNo", rs.getInt("empNo"));
		m.put("fromDate", rs.getString("fromDate"));
		m.put("name", rs.getString("name"));		
		m.put("salary",rs.getString("salary"));
		
		list.add(m);
	}
	
	
	rs.close();
	stmt.close();
	conn.close(); // db연결을 끊는 메소드
%>
<%
	// 1
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 2
	int rowPerPage = 10;
	int beginRow = 0;
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	/*
	SELECT s.emp_no empNo
		, s.salary salary
		, s.from_date fromDate
		, s.to_date toDate
		, e.first_name firstName 
		, e.last_name lastName
	FROM salaries s INNER JOIN employees e  # 테이블 두개를 합칠때 : 테이블1 JOIN 테이블2 ON 합치는 조건식 
	ON s.emp_no = e.emp_no
	ORDER BY s.emp_no ASC
	LIMIT ?, ?
	*/
	
	String sql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?,?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, beginRow);
	stmt.setInt(2, rowPerPage);
	ResultSet rs = stmt.executeQuery();
	
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
<title>SalaryMapList</title>

	

</head>
<body>
	<h1>연봉목록</h1>
	<table>
		<tr>
			<th>사원번호</th>
			<th>사원이름</th>
			<th>연봉</th>
			<th>계약일자</th>
		</tr>
		<%
			for(HashMap<String, Object> m:list) {
		%>
				<tr>
					<td><%=m.get("empNo")%></td>
					<td><%=m.get("name")%></td>
					<td><%=m.get("salary")%></td>
					<td><%=m.get("fromDate")%></td>
				</tr>
		<%
			}
		%>
	
	
	</table>




</body>
</html>