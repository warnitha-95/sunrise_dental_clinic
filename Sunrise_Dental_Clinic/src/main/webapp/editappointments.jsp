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

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/newappointments.css">

</head>

<body>

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

        <div class="form-card">

            <div class="card-header">
                <div class="card-icon">01</div>
                <div>
                    <h2>Patient Information</h2>
                    <p>Patient details cannot be changed here.</p>
                </div>
            </div>

            <div class="form-grid">

                <div class="form-group full-width">
                    <label>Patient Name</label>
                    <input type="text" value="<%= appt.getPatientName() %>" disabled>
                </div>

                <div class="form-group full-width">
                    <label>Address</label>
                    <textarea rows="3" disabled><%= appt.getAddress() %></textarea>
                </div>

                <div class="form-group">
                    <label>Contact Number</label>
                    <input type="text" value="<%= appt.getContactNumber() %>" disabled>
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

<script src="<%= request.getContextPath() %>/js/newappointments.js"></script>

<script>
    document.addEventListener("DOMContentLoaded", function () {

        const checkboxes = document.querySelectorAll('input[name="treatmentIds"]');
        const countLabel = document.getElementById("treatmentCount");
        const totalLabel = document.getElementById("selectedTotal");
        const selectedBox = document.getElementById("selectedTreatments");

        function refresh() {

            const checked = Array.from(checkboxes).filter(cb => cb.checked);

            countLabel.textContent = checked.length;

            let total = 0;

            if (checked.length === 0) {

                selectedBox.innerHTML = '<span class="selected-placeholder">No treatments selected.</span>';

            } else {

                selectedBox.innerHTML = checked.map(cb => {
                    total += parseFloat(cb.dataset.treatmentPrice || "0");
                    return '<span class="selected-chip">' + cb.dataset.treatmentName + '</span>';
                }).join("");
            }

            totalLabel.textContent = "LKR " + total.toLocaleString("en-US", { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        }

        checkboxes.forEach(cb => cb.addEventListener("change", refresh));

        refresh();
    });
</script>

</body>

</html>
