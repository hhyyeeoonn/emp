<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*"%>
<%
	// 
	int currentPage=1;
	if(request.getParameter("currentPage") != null) {
		currentPage=Integer.parseInt(request.getParameter("currentPage"));
	}

	// 
	final int ROW_PER_PAGE=10; 
	int beginRow=(currentPage-1)*ROW_PER_PAGE; 

	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn=DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	String cntSql="SELECT COUNT(*) cnt FROM board";
	PreparedStatement cntStmt=conn.prepareStatement(cntSql);
	ResultSet cntRs=cntStmt.executeQuery();
	int cnt=0; //전체 행의 수
	if(cntRs.next()) {
		cnt=cntRs.getInt("cnt");
	}
	
	
	int lastPage=(int)(Math.ceil((double)cnt / (double)ROW_PER_PAGE)); 
	
	String listSql="SELECT board_no boardNo, board_title boardTitle FROM board ORDER BY board_no DESC LIMIT ?, ?";
	PreparedStatement listStmt=conn.prepareStatement(listSql);
	listStmt.setInt(1, beginRow); //int beginRow=(currentPage-1)*ROW_PER_PAGE;
	listStmt.setInt(2, ROW_PER_PAGE);
	
	ResultSet listRs=listStmt.executeQuery(); 
	ArrayList<Board> boardList=new ArrayList<Board>(); 
	while(listRs.next()) {
		Board b=new Board();
		b.boardNo=listRs.getInt("boardNo");
		b.boardTitle=listRs.getString("boardTitle");
		boardList.add(b);
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
<div class="container mt-3">
	<!-- 메뉴 partial jsp 구성 -->
	<div class="container mt-5">
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<br>


	<!-- 3.1 모델데이터(ArrayList<Board>) 출력 -->
	<h1 class="text-center">자유게시판</h1>
	<div class="container p-5 my-5 border">
		<div>	
			<a href="<%=request.getContextPath()%>/board/insertBListForm.jsp">새 게시글 작성</a>
		</div>
		<table class="table table-hover">
			<thead>
				<tr>
					<th>No</th>
					<th>제목</th>
				</tr>
			</thead>
			<tbody>
					<%
						for(Board b : boardList) {
					%>
				<tr>
					<td><%=b.boardNo%></td>
					<td> <!-- 제목을 클릭하면 상세보기로 이동 -->
						<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.boardNo%>">
							<%=b.boardTitle%>
						</a>
					</td>
				</tr>
					<%
						}
					%>
			</tbody>
		</table>

		<!-- 3.2 페이징 currentPage만 바뀐다-->
		<div>
			<%
				if(currentPage > 1) {
			%>
				<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1">처음</a>
			<%
				}
			%>
			<% 
				if(currentPage > 3) {
			%>
					<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-3%>">이전</a>
			<%
				}
			%>
			<%	
				if(currentPage > 1) {
			%>
				<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>"><%=currentPage-1%></a>
			<%
				}
			%>
			<span><%=currentPage%></span>
			<% 
				if(currentPage > 1) {
			%>
				<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>"><%=currentPage+1%></a>
			<%
				}
			%>
			<%
				if(currentPage < lastPage) {
			%>
					<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+3%>">다음</a>
			<%
				}
			%>
			<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>">마지막</a>
		</div>
	
	<!-- 검색창 -->	
		<form action="<%=request.getContextPath()%>/board/boardList2.jsp" method="post">
			<label for="word">게시글 검색 : </label>
			<input type="text" name="word" id="word">
			<button type="submit">검색</button>
		</form>
	</div>
</div>
</body>
</html>