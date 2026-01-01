package lk.acpt.demoee.Service.impl;
import lk.acpt.demoee.database.DBConnection;
import lk.acpt.demoee.dto.EmployeeDto;
import lk.acpt.demoee.Service.EmployeeService;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeeServiceImpl implements EmployeeService {

    @Override
    public void saveEmployee(EmployeeDto dto) {
        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO employee (nic, name, age, salary) VALUES (?,?,?,?)"
            );

            ps.setString(1, dto.getNic());
            ps.setString(2, dto.getName());
            ps.setInt(3, dto.getAge());
            ps.setDouble(4, dto.getSalary());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public EmployeeDto getEmployee(String nic) {
        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps = con.prepareStatement(
                    "SELECT * FROM employee WHERE nic=?"
            );
            ps.setString(1, nic);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new EmployeeDto(
                        rs.getString("nic"),
                        rs.getString("name"),
                        rs.getInt("age"),
                        rs.getDouble("salary")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<EmployeeDto> getAllEmployees() {
        List<EmployeeDto> list = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            ResultSet rs = con.createStatement()
                    .executeQuery("SELECT * FROM employee");

            while (rs.next()) {
                list.add(new EmployeeDto(
                        rs.getString("nic"),
                        rs.getString("name"),
                        rs.getInt("age"),
                        rs.getDouble("salary")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public void deleteEmployee(String nic) {
        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps =
                    con.prepareStatement("DELETE FROM employee WHERE nic=?");
            ps.setString(1, nic);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void updateEmployee(EmployeeDto dto) {
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                    "UPDATE employee SET name=?, age=?, salary=? WHERE nic=?"
            );

            ps.setString(1, dto.getName());
            ps.setInt(2, dto.getAge());
            ps.setDouble(3, dto.getSalary());
            ps.setString(4, dto.getNic());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
