package lk.acpt.demoee.dto;

public class EmployeeDto {

    private String nic;
    private String name;
    private int age;
    private double salary;

    public EmployeeDto() {}

    public EmployeeDto(String nic, String name, int age, double salary) {
        this.nic = nic;
        this.name = name;
        this.age = age;
        this.salary = salary;
    }

    public String getNic() { return nic; }
    public void setNic(String nic) { this.nic = nic; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }

    public double getSalary() { return salary; }
    public void setSalary(double salary) { this.salary = salary; }
}
