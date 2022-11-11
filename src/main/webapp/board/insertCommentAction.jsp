<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.net.URLEncoder" %>

<%
	// 데이터 받아오기 요청분석
	request.setCharacterEncoding("utf-8");
	int boardNo=Integer.parseInt(request.getParameter("boardNo"));
	String commentContent=request.getParameter("commentContent");
	String commentPw=request.getParameter("commentPw");

	System.out.println(boardNo);
	System.out.println(commentContent);
	System.out.println(commentPw);
	
	//요청처리
	// db 사용을 위한 드라이버로딩과 연결과정
	Class.forName("org.mariadb.jdbc.Driver"); 
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	//db가 바뀌면 포트도 바뀐다
	
	//2-2. 입력
	String sql="INSERT INTO comment(board_no, comment_pw, comment_content, createdate) values(?, ?, ?, curdate())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	stmt.setString(2, commentPw);
	stmt.setString(3, commentContent);
	
	// >>>>>>>>>>>>>>>쿼리 실행코드
	int row = stmt.executeUpdate();
	
	//>>>>>>>>>디버깅코드
	if(row == 1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}
	
	
	// 요청결과출력
	response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo="+boardNo);
%>
