<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>

<%
	// MVC구조
	// 1.요청분석(Controller)
	// 2.업무처리(Model) -> 모델데이터(모델)남음 (단일값, 자료구조형태(배열, 리스트))
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn=DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	//System.out.println("드라이버 로딩 성공");
	
	String sql="SELECT dept_no deptNo, dept_name deptName FROM departments ORDER BY dept_no ASC";
	PreparedStatement stmt=conn.prepareStatement(sql); //쿼리 문장을 실행
	ResultSet rs=stmt.executeQuery(); // <- 모델데이터 rs는 모델객체
	// 모델데이터로서 ResultSet은 일반적인 타입(외부api없이 사용할 수 있는 타입), 독립적인 타입도 아니다 즉 특수한 곳에서만 쓸 수 있는 타입이라는 것 mariadb 라이브러리가 있어야 함
	// ResultSet rs라는 모델자료구조를 좀더 일반적이고 독립적인 자료구조 변경을 하자
	ArrayList<Department> list=new ArrayList<Department>();
	// 항상 ResultSet은 ArrayList로 변경
	while(rs.next()) { // ResultSet의 API(사용방법)를 머른다면 사용할 수 없는 반복문 
		Department d=new Department(); //rs의 개수만큼 반복
		d.deptNo=rs.getString("deptNo");
		d.deptName=rs.getString("deptName");
		list.add(d);
	}
	// 3.출력(View) -> 모델데이터를 고객(최종사용자)이 원하는 형태로 출력 -> 뷰(리포트)
	

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>DEPT LIST</h1>
	<div>
		<table>
			<tr>
				<th>부서번호</th>
				<th>부서명</th>
				<th></th>
				<th></th>
			</tr>
			<%
				for(Department d:list) { // 자바문법에서 제공하는 Foreach문
			%>
			<tr>
				<td><%=d.deptNo%></td>
				<td><%=d.deptName%></td>
			
				<td>
					<a href="<%=request.getContextPath()%>/dept/updateDeptForm.jsp?deptNo=<%=d.deptNo%>"> <!-- ?뒤에 나머지를 적지않아서 오류남-->
						수정
					</a>
				</td>
				<td>
					<a href="<%=request.getContextPath()%>/dept/deleteDept.jsp?deptNo=<%=d.deptNo%>">
						삭제
					</a>
				</td>	
			</tr>
			<%
				}
			%>	
		</table>
	</div>
	<br>
	<div>
		<button type="button" onclick="location.href='<%=request.getContextPath()%>/index.jsp';"><-index</button>
	</div>
</body>
</html>