<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>


<%
	//1.요청분석
	String No=request.getParameter("boardNo");
	if(No == null) { // updateForm 주소창에 직접 호출하는 거 막기
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
		return;
	}
	
	
	int boardNo=Integer.parseInt(request.getParameter("boardNo"));
	
	//2.요청처리
	Class.forName("org.mariadb.jdbc.Driver"); //드라이버로딩
	System.out.println("드라이버 로딩 성공"); 				//>>>>>>>>>>>>>>>디버깅코드
	Connection conn=DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
	String Sql="SELECT board_no boardNo, board_title boardTitle, board_writer boardWriter, board_content boardContent FROM board WHERE board_no=?";
	//쿼리와 자바 변수이름의 불일치할 때는 쿼리의 Alias 이용하여 이름 맞춰주기
	
	PreparedStatement stmt=conn.prepareStatement(Sql);
	stmt.setInt(1, boardNo); 
	ResultSet rs=stmt.executeQuery(); 
	

	ArrayList<Board> list = new ArrayList<Board>(); //어차피 데이터는 하나니까 굳이 배열을 만들 필요가 없겠구나...
	
	while(rs.next()) { 
		Board b=new Board();
		b.boardNo=rs.getInt("boardNo");
		b.boardTitle=rs.getString("boardTitle");
		b.boardWriter=rs.getString("boardWriter");
		b.boardContent=rs.getString("boardContent");
		list.add(b);
	}
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글수정</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>

</head>
<body>
<div class = "container p-5 my-5 border">
	<div>
		<h3>게시글 수정</h3>
	</div>
		
		
		<%
			for(Board b : list) {
		
		%>
			<form method="post" action="<%=request.getContextPath()%>/board/updateBoardAction.jsp?b.boardNo=<%=b.boardNo%>">	
				<div>
					<span>글번호</span>
					<span>
						<input type="number" name="no" value=<%=b.boardNo%> readonly="readonly">
					</span>
				</div>
				<div>
					<span>제목</span>
					<span>
						<input type="text" name="title" value=<%=b.boardTitle%>>
					</span>
				</div>
				<div>
					<span>글쓴이</span>
					<span>
						<input type="text" name="name" width="25%;" value=<%=b.boardWriter%>>
					</span>
					<span>비밀번호</span>
					<span>
						<input type="text" name="pw">
					</span>
				</div>
				<div>내용</div>
				<div>
					<textarea name = "memo"><%=b.boardContent%></textarea>
					<!-- textarea는 value에 값을 넣어주는 것이 아니라 괄호 바깥쪽에 데이터를 넣어주면 된다 -->
				</div>
				
				<div>
					<button type="submit">수정</button>
				</div>
			</form>
		<%
			}
		%>
				
				
		
		
	<%
		if(request.getParameter("msg") != null) {
	%>
		<div>
		<h5><small><%=request.getParameter("msg")%></small></h5>
		</div>
	<%
		}
	%>
			
</div>
</body>
</html>