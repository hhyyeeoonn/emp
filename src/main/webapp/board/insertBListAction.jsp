<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.net.URLEncoder" %>

<%
	// 데이터 받아오기 요청분석
	request.setCharacterEncoding("utf-8");
	String boardPw=request.getParameter("pw");
	String boardTitle=request.getParameter("title");
	String boardContent=request.getParameter("memo");
	String boardWriter=request.getParameter("name");
	
	if((boardPw == null && boardTitle == null && boardContent == null) 
		|| (boardPw.equals("") && boardTitle.equals("") && boardContent.equals("") && boardWriter.equals(""))) {
		String msg=URLEncoder.encode("제목과 비밀번호를 입력하세요", "utf-8"); 
		response.sendRedirect(request.getContextPath() + "/board/insertBListForm.jsp?msg="+msg);// <- 분기 메세지값이 있을 때
		return;
	} else if(boardPw != null && (boardTitle == null || boardTitle.equals(""))) {
		String msg1=URLEncoder.encode("제목을 입력하세요", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/insertBListform2.jsp?msg1="+msg1+"&boardWriter="+boardWriter+"&boardcontent="+boardContent);
		return;	
	} else if(boardTitle != null && (boardPw == null || boardPw.equals(""))) {
		String msg2=URLEncoder.encode("비밀번호를 입력하세요", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/insertBListform2.jsp?msg2="+msg2+"&boardTitle="+boardTitle+"&boardWriter="+boardWriter+"&boardcontent="+boardContent);
		return;
	}
	
	
	if(boardWriter == null || boardWriter.equals("")) {
		boardWriter="글쓴이";
	}
	
	
	
	// 이미 존재하는 key(dept_no)값 동일한 값이 입력되면 예외(에러)가 발생한다. -> 동일한 dept_no값이 입력되었을 때 예외가 발생하지 않도록 무언가를....
	
	
	// db 사용을 위한 드라이버로딩과 연결과정
	Class.forName("org.mariadb.jdbc.Driver"); //요청처리
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	//db가 바뀌면 포트도 바뀐다
	
	
	
	//2-2. 입력
	String sql="INSERT INTO board(board_pw, board_title, board_content, board_writer, createdate) values(?, ?, ?, ?, curdate())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, boardPw);
	stmt.setString(2, boardTitle);
	stmt.setString(3, boardContent);
	stmt.setString(4, boardWriter);
	
	
	// >>>>>>>>>>>>>>>쿼리 실행코드
	int row = stmt.executeUpdate();
	
	//>>>>>>>>>디버깅코드
	if(row == 1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}
	
	
	// 요청결과출력
	response.sendRedirect(request.getContextPath() + "/board/boardList.jsp");
%>
