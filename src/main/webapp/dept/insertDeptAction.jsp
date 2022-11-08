<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>


<%
	if(request.getParameter("no")==null||request.getParameter("name")==null) {
		response.sendRedirect(request.getContextPath() + "/dept/insertDeptForm.jsp");
		return;
	}
	
	// 데이터 받아오기
	request.setCharacterEncoding("utf-8");
	String deptNo=request.getParameter("no");
	String deptName=request.getParameter("name");
	
	// db 사용을 위한 드라이버로딩과 연결과정
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
	String sql="INSERT INTO departments(dept_no, dept_name) values(?, ?)";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, deptNo);
	stmt.setString(2, deptName);
	
	// >>>>>>>>>>>>>>>쿼리 실행코드
	stmt.executeUpdate(); 
	
	/*
	int row = stmt.executeUpdate();
	if(row == 1) {// 디버깅
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}
	*/
	
	// 요청결과출력
	response.sendRedirect(request.getContextPath() + "/dept/deptList.jsp");
	
	%>
