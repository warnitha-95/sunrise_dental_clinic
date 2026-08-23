<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="model.appointment"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
HttpSession sessionObj = request.getSession(false);

if (sessionObj == null || sessionObj.getAttribute("loggedInAdmin") == null) {
    response.sendRedirect("adminlogin.jsp");
    return;
}

String adminName = (String) sessionObj.getAttribute("loggedInAdmin");

List<appointment> appointments = (List<appointment>) request.getAttribute("appointments");

if (appointments == null) {
    response.sendRedirect(request.getContextPath() + "/manageAppointments");
    return;
}

String successMessage = (String) request.getAttribute("successMessage");
String errorMessage = (String) request.getAttribute("errorMessage");

SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manage Appointments | Sunrise Dental Clinic</title>
<link rel="stylesheet" href="CSS/adminhomes.css">
<link rel="stylesheet" href="CSS/manageappointments.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body>

<div class="sidebar" id="sidebar">
    <div class="logo">
        <div class="logo-icon">
            <i class="fas fa-tooth"></i>
        </div>
        <div>
            <h2>Sunrise Dental</h2>
            <span>Clinic Management</span>
        </div>
    </div>

    <ul class="sidebar-menu">
        <li>
            <a href="adminhome.jsp">
                <i class="fas fa-chart-line"></i>
                <span>Dashboard</span>
            </a>
        </li>
        <li>
            <a href="managepatients.jsp">
                <i class="fas fa-user-injured"></i>
                <span>Manage Patients</span>
            </a>
        </li>
        <li>
            <a href="newappointments.jsp">
                <i class="fas fa-calendar-plus"></i>
                <span>New Appointment</span>
            </a>
        </li>
        <li>
            <a href="manageappointments.jsp" class="active">
                <i class="fas fa-calendar-check"></i>
                <span>All Appointments</span>
            </a>
        </li>
        <li>
            <a href="billing.jsp">
                <i class="fas fa-file-invoice-dollar"></i>
                <span>Billing</span>
            </a>
        </li>
        <li>
            <a href="help.jsp">
                <i class="fas fa-circle-question"></i>
                <span>Help</span>
            </a>
        </li>
        <li class="logout-item">
            <a href="adminlogout.jsp">
                <i class="fas fa-right-from-bracket"></i>
                <span>Logout</span>
            </a>
        </li>
    </ul>
</div>

<div class="main-content">
    <header>
        <div class="header-left">
            <div>
                <h2>
                    <i class="fas fa-calendar-check"></i>
                    All Appointments
                </h2>
            </div>
        </div>

        <div class="admin-profile">
            <div class="admin-icon">
                <i class="fas fa-user-shield"></i>
            </div>
            <div>
                <strong><%= adminName %></strong>
                <span>Administrator</span>
            </div>
        </div>
    </header>

    <section class="welcome-section">
        <div>
            <h1>Manage Appointments</h1>
            <p>View, update, and remove patient appointments.</p>
        </div>

        <a href="<%= request.getContextPath() %>/newAppointment" class="appointment-btn">
            <i class="fas fa-calendar-plus"></i>
            New Appointment
        </a>
    </section>

    <% if (successMessage != null && !successMessage.trim().isEmpty()) { %>
        <div class="alert-message alert-success">
            <span class="alert-icon"><i class="fas fa-circle-check"></i></span>
            <p><%= successMessage %></p>
        </div>
    <% } %>

    <% if (errorMessage != null && !errorMessage.trim().isEmpty()) { %>
        <div class="alert-message alert-error">
            <span class="alert-icon"><i class="fas fa-triangle-exclamation"></i></span>
            <p><%= errorMessage %></p>
        </div>
    <% } %>

    <section class="dashboard-section">
        <div class="section-header">
            <div>
                <h2>Appointments</h2>
                <p><%= appointments.size() %> total appointment<%= appointments.size() == 1 ? "" : "s" %></p>
            </div>
        </div>

        <% if (!appointments.isEmpty()) { %>
            <div class="table-toolbar">
                <div class="search-box">
                    <i class="fas fa-magnifying-glass"></i>
                    <input
                        type="text"
                        id="appointmentSearch"
                        placeholder="Search by patient, appointment #, contact, or dentist...">
                </div>
                <span class="search-count" id="searchCount"></span>
            </div>
        <% } %>

        <% if (appointments.isEmpty()) { %>

            <div class="empty-state">
                <i class="fas fa-calendar-xmark"></i>
                <h3>No appointments yet</h3>
                <p>Create a new appointment to get started.</p>
            </div>
        <% } else { %>
            <div class="table-wrapper">
                <table class="appointments-table" id="appointmentsTable">
                    <thead>
                        <tr>
                            <th>Appointment #</th>
                            <th>Patient</th>
                            <th>Contact</th>
                            <th>Dentist</th>
                            <th>Date &amp; Time</th>
                            <th>Treatments</th>
                            <th>Total</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (appointment appt : appointments) {

                            String statusClass = "status-badge";
                            String status = appt.getStatus() == null ? "" : appt.getStatus();

                            if ("Completed".equalsIgnoreCase(status)) {
                                statusClass += " status-completed";
                            } else if ("Cancelled".equalsIgnoreCase(status)) {
                                statusClass += " status-cancelled";
                            } else {
                                statusClass += " status-scheduled";
                            }

                            String treatmentsText = (appt.getTreatmentNames() != null && !appt.getTreatmentNames().isEmpty())
                                    ? String.join(", ", appt.getTreatmentNames())
                                    : "-";
                        %>
                        <tr>
                            <td class="mono"><%= appt.getAppointmentNumber() %></td>
                            <td><%= appt.getPatientName() %></td>
                            <td><%= appt.getContactNumber() %></td>
                            <td> <%= appt.getDentistName() %></td>
                            <td><%= appt.getAppointmentDatetime() != null ? dateFormat.format(appt.getAppointmentDatetime()) : "-" %></td>
                            <td><%= treatmentsText %></td>
                            <td>LKR <%= String.format("%,.2f", appt.getTotalPrice()) %></td>
                            <td><span class="<%= statusClass %>"><%= status %></span></td>
                            <td class="actions-cell">
                                <a href="<%= request.getContextPath() %>/editAppointment?id=<%= appt.getAppointmentId() %>" class="action-btn edit-btn" title="Edit">
                                    <i class="fas fa-pen"></i>
                                </a>
                                <a href="<%= request.getContextPath() %>/manageAppointments?action=delete&id=<%= appt.getAppointmentId() %>"
                                   class="action-btn delete-btn"
                                   title="Delete"
                                   onclick="return confirm('Delete appointment <%= appt.getAppointmentNumber() %> for <%= appt.getPatientName() %>? This cannot be undone.');">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </section>
    <footer>
        <p>© 2026 Sunrise Dental Clinic. All Rights Reserved.</p>
        <span>Clinic Management System</span>
    </footer>
</div>

<script>
const toggleMenu = document.getElementById("toggleMenu");
const sidebar = document.getElementById("sidebar");

if (toggleMenu) {
    toggleMenu.addEventListener("click", function() {
        sidebar.classList.toggle("collapsed");
    });
}
</script>
<script src="<%= request.getContextPath() %>/JS/manageappointments.js"></script>

</body>
</html>
