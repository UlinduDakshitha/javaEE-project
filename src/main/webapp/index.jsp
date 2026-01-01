<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Employee Management</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background: #f4f6f9;
        }
        .card {
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .btn-custom {
            min-width: 120px;
        }
    </style>
</head>

<body>

<div class="container mt-4">

    <h3 class="text-center mb-4">Employee Management System</h3>

    <!-- SEARCH -->
    <div class="card p-3 mb-4">
        <h5>Search Employee</h5>
        <div class="row g-2">
            <div class="col-md-4">
                <input type="text" id="searchId" class="form-control" placeholder="Enter NIC / ID">
            </div>
            <div class="col-md-2">
                <button class="btn btn-primary btn-custom" onclick="searchEmployee()">Search</button>
            </div>
        </div>
    </div>

    <!-- TABLE -->
    <div class="card p-3 mb-4">
        <h5>Employee Details</h5>
        <table class="table table-bordered mt-2">
            <thead class="table-dark">
            <tr>
                <th>NIC</th>
                <th>Name</th>
                <th>Age</th>
                <th>Salary</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody id="employeeTable">
            </tbody>
        </table>
    </div>

    <!-- ADD / UPDATE -->
    <div class="card p-3 mb-4">
        <h5>Add / Update Employee</h5>

        <div class="row g-2">
            <div class="col-md-3 d-flex">
                <input type="text" id="nic" class="form-control" placeholder="NIC">
                <button class="btn btn-outline-secondary ms-2" id="loadBtn" onclick="loadEmployee()">Load</button>
            </div>
            <div class="col-md-3">
                <input type="text" id="name" class="form-control" placeholder="Name">
            </div>
            <div class="col-md-3">
                <input type="number" id="age" class="form-control" placeholder="Age">
            </div>
            <div class="col-md-3">
                <input type="number" id="salary" class="form-control" placeholder="Salary">
            </div>
        </div>

        <div class="mt-3">
            <button id="saveBtn" class="btn btn-success btn-custom" onclick="saveEmployee()">Save</button>
            <button id="updateBtn" class="btn btn-primary btn-custom ms-2" onclick="updateEmployee()" disabled>Update</button>
            <button class="btn btn-secondary btn-custom ms-2" onclick="clearForm()">Clear</button>
        </div>
    </div>

    <!-- DELETE -->
    <div class="card p-3">
        <h5>Delete Employee</h5>
        <div class="row g-2">
            <div class="col-md-4">
                <input type="text" id="deleteId" class="form-control" placeholder="Enter NIC">
            </div>
            <div class="col-md-2">
                <button class="btn btn-danger btn-custom" onclick="deleteEmployee()">Delete</button>
            </div>
        </div>
    </div>

</div>

<script>
    // When an employee is loaded for editing this becomes true
    let isLoaded = false;

    function saveEmployee() {
        const employee = {
            nic: document.getElementById("nic").value,
            name: document.getElementById("name").value,
            age: parseInt(document.getElementById("age").value || 0),
            salary: parseFloat(document.getElementById("salary").value || 0)
        };

        if (!employee.nic) { alert('NIC is required'); return; }

        fetch("http://localhost:8080/demoEE_war_exploded/employee_db", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(employee)
        })
            .then(res => {
                if (!res.ok) throw new Error('Save failed');
                return res.text();
            })
            .then(() => {
                alert("Employee Saved Successfully!");
                clearForm();
                loadAll();
            })
            .catch(err => alert(err.message));
    }

    function loadEmployee() {
        const nic = document.getElementById("nic").value;
        if (!nic) { alert('Enter NIC to load'); return; }

        fetch("employee?nic=" + encodeURIComponent(nic))
            .then(res => {
                if (!res.ok) throw new Error('Employee not found');
                return res.json();
            })
            .then(data => {
                document.getElementById("nic").value = data.nic;
                document.getElementById("name").value = data.name;
                document.getElementById("age").value = data.age;
                document.getElementById("salary").value = data.salary;

                // Enable update
                isLoaded = true;
                document.getElementById('updateBtn').disabled = false;
                document.getElementById('saveBtn').disabled = true;
            })
            .catch(err => alert(err.message));
    }

    function updateEmployee() {
        if (!isLoaded) { alert('Load an employee first'); return; }

        const employee = {
            nic: document.getElementById("nic").value,
            name: document.getElementById("name").value,
            age: parseInt(document.getElementById("age").value || 0),
            salary: parseFloat(document.getElementById("salary").value || 0)
        };

        fetch("employee", {
            method: "PUT",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(employee)
        })
            .then(res => {
                if (!res.ok) throw new Error('Update failed');
                return res.text();
            })
            .then(() => {
                alert('Employee Updated Successfully!');
                clearForm();
                loadAll();
            })
            .catch(err => alert(err.message));
    }

    function searchEmployee() {
        let id = document.getElementById("searchId").value;
        if (!id) return;

        fetch("employee?nic=" + encodeURIComponent(id))
            .then(res => {
                if (!res.ok) throw new Error('Employee not found');
                return res.json();
            })
            .then(data => {
                let table = `
                    <tr>
                        <td>${data.nic}</td>
                        <td>${data.name}</td>
                        <td>${data.age}</td>
                        <td>${data.salary}</td>
                        <td>
                            <button class="btn btn-sm btn-primary me-1" onclick="loadForEdit('${data.nic}')">Edit</button>
                            <button class="btn btn-sm btn-danger" onclick="deleteEmployee('${data.nic}')">Delete</button>
                        </td>
                    </tr>`;
                document.getElementById("employeeTable").innerHTML = table;
            })
            .catch(err => { alert(err.message); document.getElementById("employeeTable").innerHTML = ''; });
    }

    function deleteEmployee(nic) {
        let id = nic || document.getElementById("deleteId").value;
        if (!id) { alert('NIC is required to delete.'); return; }
        if (!confirm('Delete employee ' + id + ' ?')) return;

        fetch("employee?nic=" + encodeURIComponent(id), { method: 'DELETE' })
            .then(res => {
                if (!res.ok) throw new Error('Delete failed');
                return res.text();
            })
            .then(() => {
                alert('Deleted Successfully');
                clearForm();
                loadAll();
            })
            .catch(err => alert(err.message));
    }

    function loadAll() {
        fetch("http://localhost:8080/demoEE_war_exploded/employee_db")
            .then(res => res.json())
            .then(data => {
                let rows = "";
                data.forEach(e => {
                    rows += `
                        <tr>
                            <td>${e.nic}</td>
                            <td>${e.name}</td>
                            <td>${e.age}</td>
                            <td>${e.salary}</td>
                            <td>
                                <button class="btn btn-sm btn-primary me-1" onclick="loadForEdit('${e.nic}')">Edit</button>
                                <button class="btn btn-sm btn-danger" onclick="deleteEmployee('${e.nic}')">Delete</button>
                            </td>
                        </tr>
                    `;
                });
                document.getElementById("employeeTable").innerHTML = rows;
            })
            .catch(err => { console.error(err); document.getElementById("employeeTable").innerHTML = ''; });
    }

    function loadForEdit(nic) {
        document.getElementById('nic').value = nic;
        loadEmployee();
        // Scroll to form
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    function clearForm() {
        document.getElementById("nic").value = "";
        document.getElementById("name").value = "";
        document.getElementById("age").value = "";
        document.getElementById("salary").value = "";
        document.getElementById('updateBtn').disabled = true;
        document.getElementById('saveBtn').disabled = false;
        isLoaded = false;
    }

    loadAll();
</script>

</body>
</html>
