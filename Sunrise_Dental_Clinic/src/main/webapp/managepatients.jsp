<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="model.patient"%>
<%
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("loggedInAdmin") == null) {
        response.sendRedirect(request.getContextPath() + "/adminlogin.jsp");
        return;
    }
    String adminName = (String) sessionObj.getAttribute("loggedInAdmin");
    ArrayList<patient> patientList = (ArrayList<patient>) request.getAttribute("patientList");
    if (patientList == null) {
        patientList = new ArrayList<patient>();
    }
    String keyword = (String) request.getAttribute("keyword");
    if (keyword == null) {
        keyword = request.getParameter("keyword");
    }
    if (keyword == null) {
        keyword = "";
    }
    String success = (String) sessionObj.getAttribute("success");
    String error = (String) sessionObj.getAttribute("error");
    sessionObj.removeAttribute("success");
    sessionObj.removeAttribute("error");
    int activeCount = 0;
    int inactiveCount = 0;
    for (patient pat : patientList) {
        if (pat.getStatus() != null) {
            if (pat.getStatus().equalsIgnoreCase("Active")) {
                activeCount++;
            } else if (pat.getStatus().equalsIgnoreCase("Inactive")) {
                inactiveCount++;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Patients | Sunrise Dental Clinic</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/CSS/adminpatients.css">
</head>
<body>
<div class="sidebar" id="sidebar">
    <div class="logo">
        <div class="logo-icon">
            <i class="fas fa-tooth"></i>
        </div>
        <div class="logo-text">
            <h2>Sunrise Dental</h2>
            <span>Clinic Management</span>
        </div>
    </div>
    <ul class="sidebar-menu">
        <li>
            <a href="<%= request.getContextPath() %>/adminhomes.jsp">
                <i class="fas fa-chart-line"></i>
                <span>Dashboard</span>
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/managePatients" class="active">
                <i class="fas fa-user-injured"></i>
                <span>Manage Patients</span>
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/newappointments.jsp">
                <i class="fas fa-calendar-plus"></i>
                <span>New Appointment</span>
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/manageappointments.jsp">
                <i class="fas fa-calendar-check"></i>
                <span>All Appointments</span>
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/bill.jsp">
                <i class="fas fa-file-invoice-dollar"></i>
                <span>Billing</span>
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/help.jsp">
                <i class="fas fa-circle-question"></i>
                <span>Help</span>
            </a>
        </li>
        <li class="logout-item">
            <a href="<%= request.getContextPath() %>/adminlogout.jsp">
                <i class="fas fa-right-from-bracket"></i>
                <span>Logout</span>
            </a>
        </li>
    </ul>
</div>
<div class="main-content">
    <header>
        <div class="header-left">
            <button class="mobile-menu" id="toggleMenu" type="button">
                <i class="fas fa-bars"></i>
            </button>
            <div class="header-title">
                <h2>
                    <i class="fas fa-user-injured"></i>
                    Manage Patients
                </h2>
            </div>
        </div>
        <div class="admin-profile">
            <div class="admin-icon">
                <i class="fas fa-user-shield"></i>
            </div>
            <div class="admin-details">
                <strong><%= adminName %></strong>
                <span>Administrator</span>
            </div>
        </div>
    </header>
    <section class="page-heading">
        <div class="heading-content">
            <div class="heading-icon">
                <i class="fas fa-users"></i>
            </div>
            <div>
                <h1>Patient Management</h1>
                <p>View, search, update and manage registered patients.</p>
            </div>
        </div>
        <a href="<%= request.getContextPath() %>/addpatients.jsp" class="primary-btn">
            <i class="fas fa-user-plus"></i>
            Add New Patient
        </a>
    </section>
    <% if (success != null && !success.isEmpty()) { %>
        <div class="alert success-alert" id="successAlert">
            <div class="alert-icon">
                <i class="fas fa-circle-check"></i>
            </div>
            <div class="alert-content">
                <strong>Success</strong>
                <span><%= success %></span>
            </div>
            <button type="button" class="alert-close" onclick="closeAlert('successAlert')">
                <i class="fas fa-xmark"></i>
            </button>
        </div>
    <% } %>
    <% if (error != null && !error.isEmpty()) { %>
        <div class="alert error-alert" id="errorAlert">
            <div class="alert-icon">
                <i class="fas fa-circle-exclamation"></i>
            </div>
            <div class="alert-content">
                <strong>Error</strong>
                <span><%= error %></span>
            </div>
            <button type="button" class="alert-close" onclick="closeAlert('errorAlert')">
                <i class="fas fa-xmark"></i>
            </button>
        </div>
    <% } %>
    <section class="patient-stats">
        <div class="stat-card total-stat">
            <div class="stat-icon purple">
                <i class="fas fa-users"></i>
            </div>
            <div>
                <span>Total Patients</span>
                <strong><%= patientList.size() %></strong>
            </div>
        </div>
        <div class="stat-card active-stat">
            <div class="stat-icon green">
                <i class="fas fa-user-check"></i>
            </div>
            <div>
                <span>Active Patients</span>
                <strong><%= activeCount %></strong>
            </div>
        </div>
        <div class="stat-card inactive-stat">
            <div class="stat-icon blue">
                <i class="fas fa-user-clock"></i>
            </div>
            <div>
                <span>Inactive Patients</span>
                <strong><%= inactiveCount %></strong>
            </div>
        </div>
        <div class="stat-card records-stat">
            <div class="stat-icon orange">
                <i class="fas fa-database"></i>
            </div>
            <div>
                <span>Records Available</span>
                <strong><%= patientList.size() %></strong>
            </div>
        </div>
    </section>
    <section class="patient-panel">
        <div class="panel-header">
            <div>
                <h2>
                    <i class="fas fa-list"></i>
                    Patient Records
                </h2>
                <p>All registered patient information</p>
            </div>
            <div class="record-count">
                <i class="fas fa-database"></i>
                <%= patientList.size() %> Records
            </div>
        </div>
        <div class="search-area">
            <form action="<%= request.getContextPath() %>/managePatients" method="get" class="search-form">
                <div class="search-input">
                    <i class="fas fa-search"></i>
                    <input type="text" name="keyword" value="<%= keyword %>" placeholder="Search by Patient ID, name or contact number..." autocomplete="off">
                    <% if (!keyword.isEmpty()) { %>
                        <button type="button" class="clear-search" onclick="clearSearch()">
                            <i class="fas fa-xmark"></i>
                        </button>
                    <% } %>
                </div>
                <button type="submit" class="search-btn">
                    <i class="fas fa-search"></i>
                    Search
                </button>
                <a href="<%= request.getContextPath() %>/managePatients" class="view-data-btn">
                    <i class="fas fa-table-list"></i>
                    View Data
                </a>
            </form>
        </div>
        <div class="table-wrapper">
            <table class="patient-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Patient ID</th>
                        <th>Patient</th>
                        <th>Address</th>
                        <th>Contact Number</th>
                        <th>Gender</th>
                        <th>Registered</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% if (patientList.isEmpty()) { %>
                    <tr>
                        <td colspan="9" class="empty-state">
                            <div class="empty-icon">
                                <i class="fas fa-user-slash"></i>
                            </div>
                            <h3>No Patients Found</h3>
                            <p>
                                <% if (!keyword.isEmpty()) { %>
                                    No patients match "<%= keyword %>".
                                <% } else { %>
                                    There are currently no registered patients.
                                <% } %>
                            </p>
                            <a href="<%= request.getContextPath() %>/addpatients.jsp" class="empty-btn">
                                <i class="fas fa-user-plus"></i>
                                Add First Patient
                            </a>
                        </td>
                    </tr>
                <% } else { %>
                    <%
                        int rowNumber = 1;
                        for (patient pat : patientList) {
                            String patientName = pat.getPatient_name() == null ? "" : pat.getPatient_name();
                            String safePatientName = patientName.replace("\\", "\\\\").replace("'", "\\'");
                    %>
                    <tr class="patient-row">
                        <td>
                            <span class="row-number"><%= rowNumber++ %></span>
                        </td>
                        <td>
                            <span class="patient-id">
                                <%= pat.getPatient_id() %>
                            </span>
                        </td>
                        <td>
                            <div class="patient-info">
                                <div class="patient-avatar">
                                    <i class="fas fa-user"></i>
                                </div>
                                <div>
                                    <strong><%= patientName %></strong>
                                    <span>Patient</span>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="address-cell">
                                <span><%= pat.getAddress() == null ? "" : pat.getAddress() %></span>
                            </div>
                        </td>
                        <td>
                            <a class="phone-link" href="tel:<%= pat.getContact_number() %>">
                                <%= pat.getContact_number() %>
                            </a>
                        </td>
                        <td>
                            <span class="gender-badge">
                                <% if ("Male".equalsIgnoreCase(pat.getGender())) { %>
                                <% } else if ("Female".equalsIgnoreCase(pat.getGender())) { %>
                                <% } else { %>
                                <% } %>
                                <%= pat.getGender() == null ? "" : pat.getGender() %>
                            </span>
                        </td>
                        <td>
                            <div class="date-cell">
                                <i class="far fa-calendar"></i>
                                <span><%= pat.getRegister_datetime() == null ? "" : pat.getRegister_datetime() %></span>
                            </div>
                        </td>
                        <td>
                            <% if ("Active".equalsIgnoreCase(pat.getStatus())) { %>
                                <span class="status active">
                                    <span class="status-dot"></span>
                                    Active
                                </span>
                            <% } else { %>
                                <span class="status inactive">
                                    <span class="status-dot"></span>
                                    Inactive
                                </span>
                            <% } %>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <a href="<%= request.getContextPath() %>/updatePatients?patient_id=<%= pat.getPatient_id() %>" class="action-btn edit-btn" title="Edit Patient">
                                    <i class="fas fa-pen"></i>
                                </a>
                                <button type="button" class="action-btn delete-btn" title="Delete Patient" onclick="confirmDelete('<%= pat.getPatient_id() %>','<%= safePatientName %>')">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>
    <footer>
        <p>© 2026 Sunrise Dental Clinic. All Rights Reserved.</p>
        <span>Clinic Management System</span>
    </footer>
</div>
<div class="modal-overlay" id="deleteModal">
    <div class="delete-modal">
        <div class="delete-modal-icon">
            <i class="fas fa-trash-can"></i>
        </div>
        <h2>Delete Patient?</h2>
        <p>
            Are you sure you want to delete
            <strong id="deletePatientName">this patient</strong>?
            <br>
            This action cannot be undone.
        </p>
        <div class="modal-actions">
            <button type="button" class="modal-cancel" onclick="closeDeleteModal()">Cancel</button>
            <a href="#" id="confirmDeleteLink" class="modal-delete">
                <i class="fas fa-trash"></i>
                Delete Patient
            </a>
        </div>
    </div>
</div>
<script src="<%= request.getContextPath() %>/JS/adminpatients.js"></script>
<script>
function clearSearch() {
    const input = document.querySelector('input[name="keyword"]');
    if (input) {
        input.value = "";
        input.form.submit();
    }
}
function closeAlert(id) {
    const alert = document.getElementById(id);
    if (!alert) {
        return;
    }
    alert.style.opacity = "0";
    alert.style.transform = "translateY(-5px)";
    setTimeout(function() {
        alert.remove();
    }, 250);
}
function confirmDelete(patientId, patientName) {
    const modal = document.getElementById("deleteModal");
    const nameElement = document.getElementById("deletePatientName");
    const deleteLink = document.getElementById("confirmDeleteLink");
    if (!modal || !nameElement || !deleteLink) {
        return;
    }
    nameElement.textContent = patientName;
    deleteLink.href = "<%= request.getContextPath() %>/deletePatients?patient_id=" + encodeURIComponent(patientId);
    modal.classList.add("show");
    document.body.classList.add("modal-open");
}
function closeDeleteModal() {
    const modal = document.getElementById("deleteModal");
    if (!modal) {
        return;
    }
    modal.classList.remove("show");
    document.body.classList.remove("modal-open");
}
document.addEventListener("DOMContentLoaded", function() {
    const toggleMenu = document.getElementById("toggleMenu");
    const sidebar = document.getElementById("sidebar");
    if (toggleMenu && sidebar) {
        toggleMenu.addEventListener("click", function() {
            sidebar.classList.toggle("collapsed");
        });
    }
    const deleteModal = document.getElementById("deleteModal");
    if (deleteModal) {
        deleteModal.addEventListener("click", function(event) {
            if (event.target === deleteModal) {
                closeDeleteModal();
            }
        });
    }
    document.addEventListener("keydown", function(event) {
        if (event.key === "Escape") {
            closeDeleteModal();
        }
    });
});
</script>
</body>
</html>