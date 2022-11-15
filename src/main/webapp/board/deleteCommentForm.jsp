<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>

<%
	// 1
	int boardNo=Integer.parseInt(request.getParameter("boardNo"));	


	// 2 게시글 하나
	Class.forName("org.mariadb.jdbc.Driver"); //요청처리
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
	String boardSql="SELECT board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate FROM board WHERE board_no=?";
	PreparedStatement boardStmt=conn.prepareStatement(boardSql);
	boardStmt.setInt(1, boardNo);
	ResultSet boardRs=boardStmt.executeQuery();
	Board board=null;
	if(boardRs.next()) {
		board=new Board();
		board.boardNo=boardNo;
		board.boardTitle=boardRs.getString("boardTitle");
		board.boardContent=boardRs.getString("boardContent");
		board.boardWriter=boardRs.getString("boardWriter");
		board.createdate=boardRs.getString("createdate");
	}


	//댓글 페이징--------------------------------------------------------------------------
	
	// 1 요청분석
	int currentPage=1;
	if(request.getParameter("currentPage") != null) {
		currentPage=Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 2
	int rowPerPage=5; // 한 페이지당 보여줄 댓글 수 
	int beginRow=(currentPage-1) * rowPerPage; // 몇 번째 행부터 보여지는가?
	
	String cntSql="SELECT COUNT(*) cnt FROM board"; 
	PreparedStatement cntStmt=conn.prepareStatement(cntSql); // SQL 구문 실행
	ResultSet cntRs=cntStmt.executeQuery(); // ResultSet. SELECT문의 결과를 저장하는 객체
	int cnt=0; //전체 행의 수
	if(cntRs.next()) {
		cnt=cntRs.getInt("cnt");
	}
	
	// 나누어 떨어지면 그대로 나누어 떨어지지 않으면 +1 double은 5가 아니가 5.0이므로 int로 변환
	int lastPage=(int)(Math.ceil((double)cnt / (double)rowPerPage)); //소수점으로 계산되므로 올림
	
	// Math.ceil 올림값을 얻을 수 있다

	String commentSql = "SELECT comment_no commentNo, comment_content commentContent, createdate FROM comment WHERE board_no = ? ORDER BY comment_no DESC LIMIT ?, ?";
	PreparedStatement commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1, boardNo);
	commentStmt.setInt(2, beginRow);
	commentStmt.setInt(3, rowPerPage);
	ResultSet commentRs = commentStmt.executeQuery();
	
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while(commentRs.next()) {
		Comment c=new Comment();
		c.commentNo=commentRs.getInt("commentNo");
		c.commentContent=commentRs.getString("commentContent");
		c.createdate=commentRs.getString("createdate");
		commentList.add(c);
	}
	
%>



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
	

</head>
<body>
	<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	
	<h1>게시글 상세보기</h1>
	<table border="1">
		<tr>
			<td>번호</td>
			<td><%=board.boardNo%></td>
		</tr>
		<tr>
			<td>제목</td>
			<td><%=board.boardTitle%></td>
		</tr>
		<tr>
			<td>내용</td>
			<td><%=board.boardContent%></td>
		</tr>
		<tr>
			<td>글쓴이</td>
			<td><%=board.boardWriter%></td>
		</tr>
		<tr>
			<td>작성일</td>
			<td><%=board.createdate%></td>
		</tr>
	</table>
		<a href="<%=request.getContextPath()%>/board/updateBoardForm.jsp?boardNo=<%=boardNo%>">수정</a>
		<a href="<%=request.getContextPath()%>/board/deleteBoardForm.jsp?boardNo=<%=boardNo%>">삭제</a>


	<div>
		<!-- 댓글입력폼 -->
		<h2>댓글입력</h2>
		<form action="<%=request.getContextPath()%>/board/insertCommentAction.jsp" method="post">
			<input type="hidden" name="boardNo" value="<%=board.boardNo%>">
			<table>
				<tr>
					<td>내용</td>
					<td>
						<textarea rows="3" cols="80" name="commentContent"></textarea>
					</td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td>
						<input type="password" name="commentPw">
					</td>
				</tr>
			</table>
			<button type="submit">댓글입력</button>
		</form>
	</div>		

	<!-- 댓글 목록 -->
	<div>
		<h2>댓글목록</h2>
		<%
			for(Comment c : commentList) {
		%>
				<div>
					<div>
						<span><%=c.commentContent%></span>
						<span><%=c.createdate%></span>
					</div>
				</div>
		<%		
			}
		%>
	</div>
	
	<!-- 댓글삭제 -->
	<div>
		<h5>댓글 삭제</h5>
	</div>
	
		<% 
			String msg = request.getParameter("msg"); 
		%>
	
	<form action="<%=request.getContextPath()%>/board/deleteCommentAction.jsp" method="post">
		<input type="hidden" name="boardNo" value="<%=boardNo%>">
			비밀번호 :
		<input type="password" name="commentPw">
		<button type="submit">삭제</button>
	  
	  	<%
			if(msg != null) {
		%>		
			<div><%=msg%></div>
		<%		
			}
		%>
	</form>
	
	
	<!-- 댓글 페이징 -->
	
	<div>
		<%
			if(currentPage > 1) { // 현재페이지가 1이라면 이전으로 넘어가능 링크는 나오지 않는다
		%>
				<a href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=currentPage-1%>">이전</a>
		<%
			}
		%>
		<span><%=currentPage%></span>
		<%
			if(currentPage < lastPage) {
		%>
				<a href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=currentPage+1%>">다음</a>
		<%
			}
		%>
		<a href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=lastPage%>">마지막</a>
	</div>
</body>
</html>