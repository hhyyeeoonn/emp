<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>

<%	
	//1.요청분석
	request.setCharacterEncoding("utf-8");
	String deptNo=request.getParameter("deptNo");
	String deptName=request.getParameter("deptName");
	
	
	//2.요청처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn=DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	String sql="update departments set deptNo=?, deptName=?"; 
	PreparedStatement stmt=conn.prepareStatement(sql);  // no은 윗줄의 ?를 채울 값
	stmt.setString(1, deptNo);
	stmt.setString(2, deptName);
	
	int row=stmt.executeUpdate();

	if(row==1) { 
		System.out.println("수정성공");
	} else {
		System.out.println("수정실패");
	}

	
	//3.출력
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
%>