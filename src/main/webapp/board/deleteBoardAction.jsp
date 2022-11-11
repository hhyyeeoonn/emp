<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>

<%	
	//1.요청분석
	// 1
	System.out.println(request.getParameter("boardNo"));
	System.out.println(request.getParameter("boardPw"));
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String boardPw = request.getParameter("boardPw");
	
	
	//2.요청처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn=DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	
	//쿼리 문자열
	String sql="DELETE FROM board WHERE board_no=? AND board_pw=?";
	
	// 쿼리세팅
	PreparedStatement stmt=conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	stmt.setString(2, boardPw);
	
	int row=stmt.executeUpdate();
	
	
	
	if(row == 1) { // 1이 아니라 2이면 삭제가 두 개가 된다(?) 오류...
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
	} else {
		String msg=URLEncoder.encode("비밀번호를 확인하세요", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/deleteBoardForm.jsp?boardNo="+boardNo+"&msg="+msg); // Form에는 보드넘버까지 받아야하니까 넘버도 같이 넘기기
	}
	

%>

