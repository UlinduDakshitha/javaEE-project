package lk.acpt.demoee.Service;

import lk.acpt.demoee.dto.EmployeeDto;
import java.util.List;


public interface EmployeeService {


    void saveEmployee(EmployeeDto dto);

    EmployeeDto getEmployee(String nic);

    List<EmployeeDto> getAllEmployees();

    void deleteEmployee(String nic);

    void updateEmployee(EmployeeDto dto);
}
