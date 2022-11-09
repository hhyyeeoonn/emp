<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- partial jsp /html그 자체는부분코드 가져올 수도 될 수도 없다 -->
<a href="<%=request.getContextPath()%>/index.jsp">-홈으로-</a> <!-- 밖에 있는 것을 부를 때 클라이언트가 주체-->
<a href="<%=request.getContextPath()%>/dept/deptList.jsp">-부서관리-</a>
<a href="<%=request.getContextPath()%>/dept/">-사원관리-</a>
<a href="<%=request.getContextPath()%>"></a>
<a href="<%=request.getContextPath()%>"></a>