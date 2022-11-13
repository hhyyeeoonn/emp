<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.net.URLEncoder" %>

<%	
	//1.요청분석
	request.setCharacterEncoding("utf-8");
	
	int boardNo=Integer.parseInt(request.getParameter("no"));
	String boardPw=request.getParameter("pw");
	String boardTitle=request.getParameter("title");
	String boardContent=request.getParameter("memo");
	String boardWriter=request.getParameter("name");
	
	
	System.out.println(boardNo);
	System.out.println(boardPw);
	System.out.println(boardTitle);
	System.out.println(boardWriter);
	System.out.println(boardContent);
	
	
	if(boardTitle == null || boardContent == null || boardWriter == null ||
		boardTitle.equals("") || boardContent.equals("") || boardWriter.equals("")) {
		response.sendRedirect(request.getContextPath() + "/board/updateBoardForm.jsp");
		return; // 실행끝
	}

	
	//2.요청처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn=DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	System.out.println("드라이버 로딩"); 
	
	
	String PwSql="SELECT board_pw boardPw FROM board WHERE board_no=?"; 
	PreparedStatement pwStmt=conn.prepareStatement(PwSql);  
	pwStmt.setInt(1, boardNo);
	ResultSet pwRs=pwStmt.executeQuery(); 
	
	
	String password=null;
	
	if(pwRs.next()){
		password=pwRs.getString("boardPw");
	} 

	if(!boardPw.equals(password)) {
		System.out.println("비밀번호");
		String msg=URLEncoder.encode("비밀번호를 확인하세요", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/updateBoardForm.jsp?boardNo="+boardNo+"&msg="+msg);
		return;
	}
	// equals 메소드는 비교하고자 하는 대상의 내용 자체를 비교/ == 연산자는 비교하고자 하는 대상의 참조값을 비교
	// !(equals.()) == !=
	
	String sql="UPDATE board SET board_title=?, board_content=?, board_writer=?, createdate=CURDATE() WHERE board_no=?"; 
	PreparedStatement stmt=conn.prepareStatement(sql);  
	stmt.setString(1, boardTitle);
	stmt.setString(2, boardContent);
	stmt.setString(3, boardWriter);
	stmt.setInt(4, boardNo);
	
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