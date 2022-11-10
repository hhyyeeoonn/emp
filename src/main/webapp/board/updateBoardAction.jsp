<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.net.URLEncoder" %>

<%	
	//1.요청분석
	request.setCharacterEncoding("utf-8");
	
	int boardNo=Integer.parseInt(request.getParameter("no"));
	String boardPw=request.getParameter("no");
	String boardTitle=request.getParameter("title");
	String boardContent=request.getParameter("memo");
	String boardWriter=request.getParameter("name");
	String pw=request.getParameter("pw");
	
	if(boardTitle == null || boardContent == null || boardWriter == null ||
		boardTitle.equals("") || boardContent.equals("") || boardWriter.equals("")) {
		response.sendRedirect(request.getContextPath() + "/board/updateBoardForm.jsp");
		return; // 실행끝
	}

	
	//2.요청처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn=DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	String PwSql="SELECT board_pw boardPw FROM board WHERE board_no=? AND board_pw=?"; 
	PreparedStatement pwStmt=conn.prepareStatement(PwSql);  
	pwStmt.setInt(1, boardNo);
	pwStmt.setString(2, boardPw);
	ResultSet pwRs=pwStmt.executeQuery(); 
	
	if(pwRs.next()){
		System.out.println("pwRs.next()값");
	}
	
	if(pwRs.next() && boardPw != pwRs.getString("boardPw")){
		String msg=URLEncoder.encode("비밀번호를 확인해주세요", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/updateBoardForm.jsp?msg="+msg);
		return;
	} 
	
	


	String sql="UPDATE board SET boardTitle=?, board_content boardContent=?, boardWriter=?, createdate=CURDATE() WHERE board_no=?"; 
	PreparedStatement stmt=conn.prepareStatement(sql);  
	stmt.setString(1, boardTitle);
	stmt.setString(2, boardContent);
	stmt.setString(3, boardWriter);
	stmt.setInt(4, boardNo);
	
	int row=stmt.executeUpdate();

	//>>>>>>>>>디버깅코드
	if(row==4) { 
		System.out.println("수정성공");
	} else {
		System.out.println("수정실패");
	}

	
	//3.출력
	response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp");
%>