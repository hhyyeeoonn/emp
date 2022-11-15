<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import= "java.util.HashMap"%>
<%@ page import= "java.util.ArrayList"%>
<%@ page import= "vo.Student"%>
<%

	// Map 타입의 이해
	// 
	// Class를 사용하는것이 정석이지만 매번 클래스를 만들어야해서 번거롭다  /자바에는 익명개체는 없지만 맵을 사용해서 답을 얻을 수는 있다 단점은 정형화된 값이 아니라 매번 바뀌어서 실수를 할 수도...
	/*
	Class Student {
		public String name;
		public int age; 
	}
	*/
	Student s=new Student();
	s.name="김자바";
	s.age=29;
	
	System.out.println(s.name);
	System.out.println(s.age);
	
	// Student Class를 사용하지 않는다면.. 새로운 클래스를 매번 생성하지 않아도 됨. (키,값)<- 이렇게 들어가는 것을 맵이라고 부른다 object는 참조타입
	HashMap<String, Object> m=new HashMap<String, Object>(); // <제너릭>
	m.put("name", "김자바");
	m.put("age", 29);
	System.out.println("name");
	System.out.println("age");
	
	
	//배열 집합의 경우...
	
	// 1) Student 클래스 사용 시
	Student s1=new Student();
	s1.name="김자바";
	s1.age=26;
	Student s2=new Student();
	s2.name="이자바";
	s2.age=29;
	ArrayList<Student> studentList=new ArrayList<Student>();
	studentList.add(s1);
	studentList.add(s2);
	System.out.println();
	System.out.println();
	
	// 2) Map 사용 HashMap<String, Object>여기까지가 하나의 타입 <>생략해도 출력은 되는가봄?
	HashMap<String, Object> m1=new HashMap<String, Object>();
	m1.put("name","김자바");
	m1.put("age", 26);
	HashMap<String, Object> m2=new HashMap<String, Object>();
	m2.put("name","이자바");
	m2.put("age", 29);
	ArrayList<HashMap<String, Object>> mapList=new ArrayList<HashMap<String, Object>>();
	   mapList.add(m1);
	   mapList.add(m2);
	   System.out.println("mapList 출력");
	   for(HashMap<String, Object> hm : mapList) {
	      System.out.println(hm.get("name"));
	      System.out.println(hm.get("age"));
	   }

	

	



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