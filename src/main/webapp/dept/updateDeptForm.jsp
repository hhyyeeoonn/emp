<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>

<%
	//1.요청분석
	String deptNo=request.getParameter("deptNo");

	//2.요청처리
	Class.forName("org.mariadb.jdbc.Driver"); //드라이버로딩
	System.out.println("드라이버 로딩 성공"); 				//>>>>>>>>>>>>>>>디버깅코드
	Connection conn=DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	String sql="SELECT dept_Name deptName FROM departments WHERE dept_no=?";
	//쿼리와 자바 변수이름의 불일치할 때는 쿼리의 Alias 이용하여 이름 맞춰주기
	PreparedStatement stmt=conn.prepareStatement(sql);
	stmt.setString(1, deptNo); 
	ResultSet rs=stmt.executeQuery(); 
	
	String deptName=null;
	ArrayList<Department> list = new ArrayList<Department>();
	
	if(rs.next()) { 
		Department d=new Department();
		d.deptName=rs.getString("deptName");
		list.add(d);
		deptName=d.deptName;
	}
	
	
		
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>정보수정</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>

</head>
<body>
<div class = "container p-5 my-5 border">
	<div>
		<h3>부서정보수정</h3>
	</div>
		
	<form method="post" action="<%=request.getContextPath()%>/dept/updateDeptAction.jsp">
		
		<div>
			<div>
				부서번호
			</div>
			<div>
				<input type="text" name="deptNo" value=<%=deptNo%>>
			</div>
		
		</div>
		
		<div>
			<div>
				부서명
			</div>
			<div>
				<input type="text" name="deptName" value=<%=deptName%>>
			</div>
		
		</div>
		
		<div>
			<button type="submit" class="btn btn-outline-success">수정등록</button>
		</div>
	</form>
</div>
</body>
</html>