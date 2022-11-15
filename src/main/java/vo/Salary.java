package vo;

public class Salary { 
	// public int empNo 이 방법으로는 조인 결과를 알 수 없다
	public Employee emp; // inner join 결과물을 저장하기 위해서 만듦
	public int salary;
	public String fromDate;
	public String toDate;

	/*
	public static void main(String[] args) {
		Salary s =new Salary();
		s.emp=new Employee(); // 클래스 객체 변수 = new 클래스();
		//  new 연산자를 통해 메모리(Heap 영역)에 데이터를 저장할 공간을 할당받고 그 공간의 참조값(reference value /해시코드)을 객체에게 반환하여 주고 이어서 생성자를 호출하게 된다.
		// https://devlogofchris.tistory.com/35
		s.emp.empNo=1;
		s.salary=5000;
		s.fromDate="2021-01-01";
		s.toDate="2021-12-31";
		
	}
	*/
}