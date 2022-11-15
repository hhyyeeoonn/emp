<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 내장객체.서버가 만들어주는 객체
	// 1 요청분석 : 로그인 시 사용할 아이디와 비밀번호 입력받아 사용
	String id=
	String pw

	// 2 요청처리 : 1의 분석한 내용과 db의 내용을 비교
	String dbUserId=
	String dbUserPw=

	
	//로그인 성공정보를 세션공간에 저장
	session.setAttribute("x", "y"); // x라는 변수에 y값을 session안에 저장 다른 페이지에서도 읽을 수 있다 맵의 형태와 같음 setAttribute는 일반메소드 
	//session 값을 읽을 때는 형변환이 필요
	String x=(String)(session.getAttribute("x")); // x값을 불러오기 x안에는 y라는 값이 저장되어있기 때문에 y가 나옴
	// 만약 x값이 null 이라면즉  session에 attribute값이 없다면, 로그인하지 않았다는 의미 출력은 형변환 따로 안해도 됨 자동으로 됨	
	// 로그아웃은 session을 초기화시키는 것
	session.invalidate(); // 강제로 세션공간이 초기화됨 /서버를 끄면 세션 초기화됨 또는 특정 시간이 지나면 초기화시킬 수도 있음
	
%>




<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>