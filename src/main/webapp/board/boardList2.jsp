<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*"%>

<%
	// 1 요청분석
	int currentPage=1;
	if(request.getParameter("currentPage") != null) {
		currentPage=Integer.parseInt(request.getParameter("currentPage"));
	}
	
	request.setCharacterEncoding("utf-8");
	String word = request.getParameter("word");
	
	if(word == null) {
		word="";
	}

	// 2 요청처리 후 필요하다면 모델데이터를 생성
	final int ROW_PER_PAGE=10; //int 앞에 final이 붙으면 변하지 않는 상수가 된다 상수는 대문자로 적어서(단어구분은 중간 언더바로) 이름만 보고도 이게 상수라는 걸 알 수 있게 한다
	int beginRow=(currentPage-1)*ROW_PER_PAGE; // ...Limit ?=beginRow, ?=ROW_PER_PAGE 

	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn=DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	String cntSql=null;
	PreparedStatement cntStmt=null;
	
	if((word == null) || (word.equals(""))) {
		cntSql="SELECT COUNT(*) cnt FROM board";
		cntStmt=conn.prepareStatement(cntSql);
	} else {
		cntSql = "SELECT COUNT(*) cnt FROM board WHERE board_title LIKE ?";
	    cntStmt = conn.prepareStatement(cntSql);
	    cntStmt.setString(1, "%"+word+"%");
	}
	
	
	
	ResultSet cntRs=cntStmt.executeQuery();
	int cnt=0; //전체 행의 수
	if(cntRs.next()) {
		cnt=cntRs.getInt("cnt");
		System.out.println(cnt);
	}
	 
	// 나누어 떨어지면 그대로 나누어 떨어지지 않으면 +1 double은 5가 아니가 5.0이므로 int로 변환
	int lastPage=(int)(Math.ceil((double)cnt / (double)ROW_PER_PAGE)); //소수점으로 계산되므로 올림
	System.out.println(lastPage+"<<<<<lastPage");
	
	
	
	String sql=null;
	PreparedStatement stmt=null;
	
	if((word == null) || (word.equals(""))) {
	    sql = "SELECT board_no boardNo, board_title boardTitle FROM board ORDER BY board_no ASC LIMIT ?, ?";
	    stmt = conn.prepareStatement(sql);
	    stmt.setInt(1, beginRow); //int beginRow=(currentPage-1)*ROW_PER_PAGE;
		stmt.setInt(2, ROW_PER_PAGE);
	} else {
	    /*
	       SELECT *
	       FROM departments
	       WHERE dept_name LIKE ?
	       ORDER BY dept_no ASC
	    */
		sql = "SELECT board_no boardNo, board_title boardTitle FROM board WHERE board_title LIKE ? ORDER BY board_no ASC LIMIT ?, ?";
	    stmt = conn.prepareStatement(sql);
	    stmt.setString(1, "%"+word+"%");
	    stmt.setInt(2, beginRow); 
		stmt.setInt(3, ROW_PER_PAGE);
	}
		
		ResultSet rs=stmt.executeQuery(); //모델 source data
		ArrayList<Board> boardList=new ArrayList<Board>(); //모델의 새로운 데이터
		while(rs.next()) {
			Board b=new Board();
			b.boardNo=rs.getInt("boardNo");
			b.boardTitle=rs.getString("boardTitle");
			boardList.add(b);
	}
%>
<!-- 여러 외래키들능ㄴ 동일한 넘버를 같이 가지고 있어야 한다 -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>

	<style>
		a { 
			text-decoration:none
		}
		
		a:link { 
		 	text-decoration:none; color:#000000;
		 }

 		a:visited { 
 			text-decoration:none;color:#000000;
 		}

 		a:active {
 			text-decoration:none; color:#000000; 
 		}

 		a:hover { 
 			text-decoration:none; color:#000000;
 		}
	</style>

</head>
<body>
	<!-- 메뉴 partial jsp 구성 -->
	<div class="container">
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<br>
	
	<!-- 3.1 모델데이터(ArrayList<Board>) 출력 -->
	<div class="container p-5 my-5 border">
		<h1>자유게시판</h1>
			<div class="text-right">
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
				<a href="<%=request.getContextPath()%>/board/boardList2.jsp?currentPage=1">처음</a>
			<%
				}
			%>
			<% 
				if(currentPage > 3) {
			%>
					<a href="<%=request.getContextPath()%>/board/boardList2.jsp?currentPage=<%=currentPage-3%>&word=<%=word%>">이전</a>
			<%
				}
			%>
			<%	
				if(currentPage > 1) {
			%>
					<a href="<%=request.getContextPath()%>/board/boardList2.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>"><%=currentPage-1%></a>
			<%
				}
			%>
			<span><%=currentPage%></span>
			<%
				if((currentPage >= 1) && (currentPage < lastPage)) {
			%>
					<a href="<%=request.getContextPath()%>/board/boardList2.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>"><%=currentPage+1%></a>
			<%
				}
			%>
			<%
				if((currentPage > 1) && (currentPage < lastPage)) {
			%>
					<a href="<%=request.getContextPath()%>/board/boardList2.jsp?currentPage=<%=currentPage+3%>&word=<%=word%>">다음</a>
			<%
				}
			%>
			<%
				if(currentPage > 1) {
			%>
				<a href="<%=request.getContextPath()%>/board/boardList2.jsp?currentPage=<%=lastPage%>&word=<%=word%>">마지막</a>
			<%
				}
			%>
		</div>
		
		<!-- 검색창 -->	
		<form action="<%=request.getContextPath()%>/board/boardList2.jsp" method="post">
			<label for="word">게시글 검색 : </label>
			<input type="text" name="word" id="word" value="<%=word%>">
			<button type="submit">검색</button>
		</form>
		
	</div>
</body>
</html>