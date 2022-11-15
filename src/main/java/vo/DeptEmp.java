package vo;

public class DeptEmp {
	// 테이블 컬럼과 일치하는 도메인 타입
	// 단점은 이 도메인타입으로 JOIN 결과를 처리할 수 없다
	//public int empNo;
	//public int deptNo;
	//public String FromDate;
	//public String toDate;
	
	// 장점은 dept_emp테이블의 행 뿐만 아니라 JOIN 결과의 행도 함께 처리할 수 있다
	// 단점은 복잡하다는 것..
	public Employee emp;
	public Department dept;
	public String fromDate;
	public String toDate;
}
