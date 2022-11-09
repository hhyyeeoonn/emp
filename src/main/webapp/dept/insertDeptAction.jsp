<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.net.URLEncoder" %>

<%
	// 데이터 받아오기 요청분석
	request.setCharacterEncoding("utf-8");
	String deptNo=request.getParameter("no");
	String deptName=request.getParameter("name");
	
	if((deptNo == null && deptName == null) || (deptNo.equals("") && deptName.equals(""))) {
		String msg=URLEncoder.encode("부서번호와 부서명을 입력하세요", "utf-8"); // get방식 주소창에 문자열 인코딩 브라우저에 맞게 인코딩해줌 매개변수 두 개...?
		response.sendRedirect(request.getContextPath() + "/dept/insertDeptForm.jsp?msg="+msg);// <- 분기 메세지값이 있을 때
		return;
	} else if(deptNo != null && (deptName == null || deptName.equals(""))) {
		String msg1=URLEncoder.encode("부서명을 입력하세요", "utf-8");
		response.sendRedirect(request.getContextPath() + "/dept/insertDeptForm2.jsp?msg1="+msg1+"&deptNo="+deptNo);
		return;	
	} else if(deptName != null && (deptNo.equals("") || deptNo == null)) {
		String msg2=URLEncoder.encode("부서번호를 입력하세요", "utf-8");
		response.sendRedirect(request.getContextPath() + "/dept/insertDeptForm2.jsp?msg2="+msg2+"&deptName="+deptName);
		return;
	}
	
	// ?????응답이 이미 커밋된 후에는, sendRedirect()를 호출할 수 없습니다.
	
	
	// 이미 존재하는 key(dept_no)값 동일한 값이 입력되면 예외(에러)가 발생한다. -> 동일한 dept_no값이 입력되었을 때 예외가 발생하지 않도록 무언가를....
	
	
	// db 사용을 위한 드라이버로딩과 연결과정
	Class.forName("org.mariadb.jdbc.Driver"); //요청처리
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	//db가 바뀌면 포트도 바뀐다
	
	//2-1. dept_no dept_name 중복검사
	String sql1="SELECT * FROM departments WHERE Dept_no=? OR dept_name=?"; // 입력 전에 동일한 정보가 존재하는지 확인 둘 중 하나라도 중복이 된다면 메시지 출력
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1, deptNo);
	stmt1.setString(2, deptName);
	ResultSet rs=stmt1.executeQuery();
	
	if(rs.next()) { //결과물이 있다=동일한, 중복되는 정보가 이미 존재한다
		String msg=URLEncoder.encode("부서번호 또는 부서명이 중복되었습니다", "utf-8");
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+msg);
		//사용할 수 없습니다 라는 데이터가 넘어감 입력값이 null일 때는 또 다른 것을...
		return;
	}
	
	
	//2-2. 입력
	String sql2="INSERT INTO departments(dept_no, dept_name) values(?, ?)";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, deptNo);
	stmt2.setString(2, deptName);
	
	// >>>>>>>>>>>>>>>쿼리 실행코드
	int row = stmt2.executeUpdate();
	
	//>>>>>>>>>디버깅코드
	if(row == 1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}
	
	
	// 요청결과출력
	response.sendRedirect(request.getContextPath() + "/dept/deptList.jsp");
%>
