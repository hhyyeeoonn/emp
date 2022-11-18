<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- partial jsp 페이지 사용할 코드 /html그 자체는부분코드 가져올 수도 될 수도 없다 -->

<ul class="nav nav-pills">
	<li class="nav-item">
		<a href="<%=request.getContextPath()%>/index.jsp" class="nav-link"> 홈 </a>
	</li>
	<li class="nav-item">
		<a href="<%=request.getContextPath()%>/dept/deptList.jsp" class="nav-link"> 부서관리 </a>
	</li>
	<li class="nav-item">
		<a href="<%=request.getContextPath()%>/emp/empList.jsp" class="nav-link"> 사원관리 </a>
	</li>
	<li class="nav-item">
		<a href="<%=request.getContextPath()%>/dept/deptEmpList.jsp" class="nav-link"> 사원정보 </a>
	</li>
	<li class="nav-item">
		<a href="<%=request.getContextPath()%>/salary/salaryList.jsp" class="nav-link"> 연봉정보 </a>
	</li>
	<li class="nav-item">
		<a href="<%=request.getContextPath()%>/board/boardList.jsp" class="nav-link"> 자유게시판 </a>
	</li>
</ul>

