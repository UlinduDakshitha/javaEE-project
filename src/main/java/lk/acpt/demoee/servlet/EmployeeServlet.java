package lk.acpt.demoee.servlet;
import com.google.gson.Gson;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import lk.acpt.demoee.dto.EmployeeDto;
import lk.acpt.demoee.Service.EmployeeService;
import lk.acpt.demoee.Service.impl.EmployeeServiceImpl;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.List;

@WebServlet("/employee")
public class EmployeeServlet extends HttpServlet {

    private final EmployeeService service = new EmployeeServiceImpl();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");

        String nic =  req.getParameter("nic");

        if (nic != null) {
            EmployeeDto dto = service.getEmployee(nic);
            if (dto == null) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write("{\"error\":\"Employee not found\"}");
            } else {
                resp.getWriter().write(gson.toJson(dto));
            }
        } else {
            List<EmployeeDto> list = service.getAllEmployees();
            resp.getWriter().write(gson.toJson(list));
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        BufferedReader reader = req.getReader();
        EmployeeDto dto = gson.fromJson(reader, EmployeeDto.class);

        service.saveEmployee(dto);
        resp.getWriter().write("Saved Successfully");
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String nic = req.getParameter("nic");
        service.deleteEmployee(nic);
        resp.getWriter().write("Deleted Successfully");
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        BufferedReader reader = req.getReader();
        EmployeeDto dto = gson.fromJson(reader, EmployeeDto.class);

        service.updateEmployee(dto);
        resp.getWriter().write("Updated Successfully");
    }
}
