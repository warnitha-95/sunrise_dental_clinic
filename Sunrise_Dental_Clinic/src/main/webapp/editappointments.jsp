<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="model.dentist"%>
<%@ page import="model.treatment"%>
<%@ page import="model.appointment"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%
if (session == null || session.getAttribute("loggedInAdmin") == null) {
    response.sendRedirect(request.getContextPath() + "/adminlogin.jsp");
    return;
}

String adminName = (String) session.getAttribute("loggedInAdmin");

appointment appt = (appointment) request.getAttribute("appointment");
List<dentist> dentists = (List<dentist>) request.getAttribute("dentists");
List<treatment> treatments = (List<treatment>) request.getAttribute("treatments");
String errorMessage = (String) request.getAttribute("errorMessage");

if (appt == null) {
    response.sendRedirect(request.getContextPath() + "/manageAppointments");
    return;
}

SimpleDateFormat dateInputFormat = new SimpleDateFormat("yyyy-MM-dd");
SimpleDateFormat timeInputFormat = new SimpleDateFormat("HH:mm");

String currentDate = appt.getAppointmentDatetime() != null ? dateInputFormat.format(appt.getAppointmentDatetime()) : "";
String currentTime = appt.getAppointmentDatetime() != null ? timeInputFormat.format(appt.getAppointmentDatetime()) : "";

List<Integer> selectedTreatmentIds = appt.getTreatmentIds();
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Edit Appointment | Sunrise Dental Clinic</title>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/CSS/adminhomes.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/CSS/newappointments.css">
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
            <a href="<%= request.getContextPath() %>/adminhome.jsp">
                <i class="fas fa-chart-line"></i>
                <span>Dashboard</span>
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/managepatients.jsp">
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
            <a href="<%= request.getContextPath() %>/manageappointments.jsp" class="active">
                <i class="fas fa-calendar-check"></i>
                <span>All Appointments</span>
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/billing.jsp">
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
            <div>
                <h2>
                    <i class="fas fa-pen"></i>
                    Edit Appointment
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

    <div class="appointment-page">
        <div class="page-header">
            <div class="header-content">
                <span class="page-label">APPOINTMENT MANAGEMENT</span>
                <h1>Edit Appointment</h1>
                <p>Update the dentist, schedule, treatments, or status for <%= appt.getAppointmentNumber() %>.</p>
            </div>

            <a href="<%= request.getContextPath() %>/manageAppointments" class="back-button">
                <span>←</span>
                Appointments
            </a>
        </div>
        <% if (errorMessage != null && !errorMessage.trim().isEmpty()) { %>
            <div class="error-message">
                <span class="error-icon">!</span>
                <div>
                    <strong>Appointment Error</strong>
                    <p><%= errorMessage %></p>
                </div>
            </div>
        <% } %>
        <form action="<%= request.getContextPath() %>/editAppointment" method="post" id="appointmentForm">

            <input type="hidden" name="appointmentId" value="<%= appt.getAppointmentId() %>">
            <input type="hidden" name="patientId" value="<%= appt.getPatientId() %>">

            <div class="form-card">

                <div class="card-header">
                    <div class="card-icon">01</div>
                    <div>
                        <h2>Patient Information</h2>
                        <p>Update the patient's contact details.</p>
                    </div>
                </div>
                <div class="form-grid">

                    <div class="form-group full-width">
                        <label for="patientName">
                            Patient Name
                            <span>*</span>
                        </label>
                        <input
                            type="text"
                            id="patientName"
                            name="patientName"
                            value="<%= appt.getPatientName() %>"
                            placeholder="Enter patient name"
                            maxlength="150"
                            autocomplete="name"
                            required>
                    </div>

                    <div class="form-group full-width">
                        <label for="address">
                            Address
                            <span>*</span>
                        </label>
                        <textarea
                            id="address"
                            name="address"
                            rows="3"
                            maxlength="255"
                            placeholder="Enter patient address"
                            required><%= appt.getAddress() %></textarea>
                    </div>

                    <div class="form-group full-width">
                        <label for="contactNumber">
                            Contact Number
                            <span>*</span>
                        </label>
                        <input
                            type="tel"
                            id="contactNumber"
                            name="contactNumber"
                            value="<%= appt.getContactNumber() %>"
                            placeholder="0771234567"
                            maxlength="20"
                            autocomplete="tel"
                            required>
                        <small>Example: 0771234567</small>
                    </div>

                    <div class="form-group">
                        <label for="gender">
                            Gender
                            <span>*</span>
                        </label>
                        <select id="gender" name="gender" required>
                            <option value="">Select gender</option>
                            <option value="Male" <%= "Male".equalsIgnoreCase(appt.getGender()) ? "selected" : "" %>>Male</option>
                            <option value="Female" <%= "Female".equalsIgnoreCase(appt.getGender()) ? "selected" : "" %>>Female</option>
                            <option value="Other" <%= "Other".equalsIgnoreCase(appt.getGender()) ? "selected" : "" %>>Other</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="form-card">

                <div class="card-header">
                    <div class="card-icon">02</div>
                    <div>
                        <h2>Appointment Details</h2>
                        <p>Select the dentist, schedule, and status.</p>
                    </div>
                </div>

                <div class="form-grid">

                    <div class="form-group">

                        <label for="dentistId">
                            Dentist
                            <span>*</span>
                        </label>

                        <select id="dentistId" name="dentistId" required>

                            <option value="">Select dentist</option>

                            <%
                                if (dentists != null && !dentists.isEmpty()) {
                                    for (dentist d : dentists) {
                                        boolean isSelected = d.getDentistId() == appt.getDentistId();
                            %>
                                <option value="<%= d.getDentistId() %>" <%= isSelected ? "selected" : "" %>>
                                    Dr. <%= d.getDentistName() %>
                                    <%
                                        if (d.getSpecialization() != null && !d.getSpecialization().trim().isEmpty()) {
                                    %>
                                        - <%= d.getSpecialization() %>
                                    <%
                                        }
                                    %>
                                </option>
                            <%
                                    }
                                } else {
                            %>
                                <option value="" disabled>No active dentists available</option>
                            <%
                                }
                            %>

                        </select>

                    </div>

                    <div class="form-group">
                        <label for="appointmentDate">
                            Appointment Date
                            <span>*</span>
                        </label>
                        <input type="date" id="appointmentDate" name="appointmentDate" value="<%= currentDate %>" required>
                    </div>

                    <div class="form-group">
                        <label for="appointmentTime">
                            Appointment Time
                            <span>*</span>
                        </label>
                        <input type="time" id="appointmentTime" name="appointmentTime" value="<%= currentTime %>" required>
                    </div>

                    <div class="form-group">

                        <label for="status">
                            Status
                            <span>*</span>
                        </label>

                        <select id="status" name="status" required>
                            <option value="Scheduled" <%= "Scheduled".equalsIgnoreCase(appt.getStatus()) ? "selected" : "" %>>Scheduled</option>
                            <option value="Completed" <%= "Completed".equalsIgnoreCase(appt.getStatus()) ? "selected" : "" %>>Completed</option>
                            <option value="Cancelled" <%= "Cancelled".equalsIgnoreCase(appt.getStatus()) ? "selected" : "" %>>Cancelled</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="form-card">

                <div class="card-header">
                    <div class="card-icon">03</div>
                    <div>
                        <h2>Treatment Selection</h2>
                        <p>Select between 1 and 3 treatments.</p>
                    </div>
                </div>

                <div class="treatment-section">

                    <div class="treatment-title">
                        <div>
                            <label>
                                Treatment Type
                                <span>*</span>
                            </label>
                            <p>You can select up to 3 treatments for this appointment.</p>
                        </div>
                        <div class="treatment-count">
                            <strong id="treatmentCount">0</strong>
                            <span>/ 3</span>
                        </div>
                    </div>

                    <div class="treatment-list">

                        <%
                            if (treatments != null && !treatments.isEmpty()) {
                                for (treatment t : treatments) {
                                    boolean isChecked = selectedTreatmentIds != null && selectedTreatmentIds.contains(t.getTreatmentId());
                        %>

                            <label class="treatment-option">

                                <input
                                    type="checkbox"
                                    name="treatmentIds"
                                    value="<%= t.getTreatmentId() %>"
                                    data-treatment-name="<%= t.getTreatmentName() %>"
                                    data-treatment-price="<%= t.getPriceLkr() %>"
                                    <%= isChecked ? "checked" : "" %>>

                                <span class="treatment-check"></span>

                                <span class="treatment-info">
                                    <strong><%= t.getTreatmentName() %></strong>
                                    <small>LKR <%= String.format("%,.2f", t.getPriceLkr()) %></small>
                                </span>

                            </label>

                        <%
                                }
                            } else {
                        %>

                            <div class="empty-treatment">
                                <span class="empty-icon">!</span>
                                <div>
                                    <strong>No active treatments available</strong>
                                    <p>Please add an active treatment before editing this appointment.</p>
                                </div>
                            </div>

                        <%
                            }
                        %>

                    </div>

                    <div class="selected-box">
                        <div class="selected-header">
                            <span>Selected Treatments</span>
                            <span id="selectedTotal">LKR 0.00</span>
                        </div>
                        <div class="selected-treatments" id="selectedTreatments">
                            <span class="selected-placeholder">No treatments selected.</span>
                        </div>
                    </div>

                </div>

            </div>

            <div class="form-actions">

                <a href="<%= request.getContextPath() %>/manageAppointments" class="cancel-button">Cancel</a>

                <button type="submit" class="submit-button" id="submitButton">
                    <span>✓</span>
                    Save Changes
                </button>
            </div>
        </form>
    </div>
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

<script src="<%= request.getContextPath() %>/JS/newappointments.js"></script>

</body>

</html>