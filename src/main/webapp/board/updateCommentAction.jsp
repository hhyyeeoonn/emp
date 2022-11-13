<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.net.URLEncoder" %>

<%	
	//1.요청분석
	request.setCharacterEncoding("utf-8");
	
	int boardNo=Integer.parseInt(request.getParameter("boardNo"));
	int commentNo=Integer.parseInt(request.getParameter("commentNo"));
	String commentPw=request.getParameter("commentPw");
	String commentContent=request.getParameter("commentContent");
	
	System.out.println(boardNo);
	System.out.println(commentPw);
	System.out.println(commentNo);
	
	//2.요청처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn=DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	System.out.println("드라이버 로딩"); 
	
	// 댓글 수정을 위한 비밀번호 확인 
	String PwSql="SELECT comment_pw commentPw FROM comment WHERE comment_no=?"; 
	PreparedStatement pwStmt=conn.prepareStatement(PwSql);  
	pwStmt.setInt(1, commentNo);
	ResultSet pwRs=pwStmt.executeQuery(); 
	
	String password=null;
	
	if(pwRs.next()){
		password=pwRs.getString("commentPw");
		System.out.println(password);
		System.out.println(">>>"+commentPw);
	} 
	
	if(!commentPw.equals(password)) {
		System.out.println("비밀번호");
		String msg=URLEncoder.encode("비밀번호를 확인하세요", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/updateCommentForm.jsp?boardNo="+boardNo+"&commentNo="+commentNo+"&msg="+msg);
		return;
	}
		
	
	String sql="UPDATE comment SET comment_content=?, createdate=CURDATE() WHERE board_no=? AND comment_no=?"; 
	PreparedStatement stmt=conn.prepareStatement(sql);  
	stmt.setString(1, commentContent);
	stmt.setInt(2, boardNo);
	stmt.setInt(3, commentNo);
	
	int row=stmt.executeUpdate();

	//>>>>>>>>>디버깅코드
	if(row==1) { 
		System.out.println("수정성공");
	} else {
		System.out.println("수정실패");
	}

	
	//3.출력
	response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
%>