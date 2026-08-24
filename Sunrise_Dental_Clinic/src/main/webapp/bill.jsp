<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="model.appointment"%>
<%@ page import="model.treatment"%>

<%
if (session == null || session.getAttribute("loggedInAdmin") == null) {
    response.sendRedirect(request.getContextPath() + "/adminlogin.jsp");
    return;
}

String adminName = (String) session.getAttribute("loggedInAdmin");

appointment appt = (appointment) request.getAttribute("appointment");
List<treatment> treatmentList = (List<treatment>) request.getAttribute("treatmentList");
BigDecimal treatmentTotal = (BigDecimal) request.getAttribute("treatmentTotal");
BigDecimal consultationFee = (BigDecimal) request.getAttribute("consultationFee");
BigDecimal grandTotal = (BigDecimal) request.getAttribute("grandTotal");

if (appt == null) {
    response.sendRedirect(request.getContextPath() + "/manageAppointments");
    return;
}

SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
SimpleDateFormat printedFormat = new SimpleDateFormat("dd MMM yyyy, hh:mm a");

String appointmentDateText =
        appt.getAppointmentDatetime() != null
        ? dateFormat.format(appt.getAppointmentDatetime())
        : "-";

String printedAtText = printedFormat.format(new java.util.Date());
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Bill | <%= appt.getAppointmentNumber() %> | Sunrise Dental Clinic</title>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/CSS/adminhomes.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/CSS/billing.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

</head>

<body>

<div class="sidebar no-print" id="sidebar">
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
            <a href="<%= request.getContextPath() %>/manageappointments.jsp">
                <i class="fas fa-calendar-check"></i>
                <span>All Appointments</span>
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/bill.jsp"  class="active">
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

    <header class="no-print">
        <div class="header-left">
            
            <div>
                <h2>
                    <i class="fas fa-file-invoice-dollar"></i>
                    Appointment Bill
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

    <div class="bill-page">

        <div class="bill-toolbar no-print">

            <a href="<%= request.getContextPath() %>/manageAppointments" class="back-button">
                <span>&larr;</span>
                Appointments
            </a>

            <button type="button" class="print-button" id="printButton">
                <i class="fas fa-print"></i>
                Print Bill
            </button>

        </div>

        <div class="bill-receipt" id="billReceipt">

            <div class="bill-header">

                <div class="clinic-identity">
                    <div class="clinic-icon">
                        <i class="fas fa-tooth"></i>
                    </div>
                    <div>
                        <h1>Sunrise Dental Clinic</h1>
                        <p>Clinic Management System</p>
                    </div>
                </div>

                <div class="bill-meta">
                    <h2>Patient Bill</h2>
                    <p><strong>Bill Ref:</strong> <%= appt.getAppointmentNumber() %></p>
                    <p><strong>Printed:</strong> <%= printedAtText %></p>
                </div>

            </div>

            <div class="bill-divider"></div>

            <div class="bill-info-grid">

                <div class="bill-info-block">
                    <span class="info-label">Patient Name</span>
                    <span class="info-value"><%= appt.getPatientName() %></span>
                </div>
                <div class="bill-info-block">
                    <span class="info-label">Contact Number</span>
                    <span class="info-value"><%= appt.getContactNumber() %></span>
                </div>
                <div class="bill-info-block full">
                    <span class="info-label">Address</span>
                    <span class="info-value"><%= appt.getAddress() %></span>
                </div>
                <div class="bill-info-block">
                    <span class="info-label">Dentist</span>
                    <span class="info-value"><%= appt.getDentistName() %></span>
                </div>
                <div class="bill-info-block">
                    <span class="info-label">Appointment Date &amp; Time</span>
                    <span class="info-value"><%= appointmentDateText %></span>
                </div>
                <div class="bill-info-block">
                    <span class="info-label">Status</span>
                    <span class="info-value"><%= appt.getStatus() %></span>
                </div>

            </div>

            <div class="bill-divider"></div>

            <table class="bill-table">

                <thead>
                    <tr>
                        <th>#</th>
                        <th>Description</th>
                        <th class="amount-col">Amount (LKR)</th>
                    </tr>
                </thead>

                <tbody>

                    <tr>
                        <td>1</td>
                        <td>Consultation Fee</td>
                        <td class="amount-col">
                            <%= String.format("%,.2f", consultationFee) %>
                        </td>
                    </tr>

                    <%
                        int rowNumber = 2;

                        if (treatmentList != null && !treatmentList.isEmpty()) {

                            for (treatment t : treatmentList) {
                    %>

                    <tr>
                        <td><%= rowNumber %></td>
                        <td><%= t.getTreatmentName() %></td>
                        <td class="amount-col">
                            <%= String.format("%,.2f", t.getPriceLkr()) %>
                        </td>
                    </tr>
                    <%
                                rowNumber++;
                            }

                        } else {
                    %>

                    <tr>
                        <td colspan="3" class="no-treatments">
                            No treatments recorded for this appointment.
                        </td>
                    </tr>

                    <%
                        }
                    %>

                </tbody>

                <tfoot>

                    <tr>
                        <td colspan="2">Treatment Subtotal</td>
                        <td class="amount-col">
                            <%= String.format("%,.2f", treatmentTotal) %>
                        </td>
                    </tr>

                    <tr>
                        <td colspan="2">Consultation Fee</td>
                        <td class="amount-col">
                            <%= String.format("%,.2f", consultationFee) %>
                        </td>
                    </tr>

                    <tr class="grand-total-row">
                        <td colspan="2">Grand Total</td>
                        <td class="amount-col">
                            LKR <%= String.format("%,.2f", grandTotal) %>
                        </td>
                    </tr>

                </tfoot>

            </table>

            <div class="bill-footer">
                <p>Thank you for choosing Sunrise Dental Clinic.</p>
                <p>This is a computer-generated bill and does not require a signature.</p>
            </div>

        </div>

    </div>

    <footer class="no-print">
        <p>&copy; 2026 Sunrise Dental Clinic. All Rights Reserved.</p>
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

const printButton = document.getElementById("printButton");

if (printButton) {
    printButton.addEventListener("click", function () {
        window.print();
    });
}
</script>

</body>

</html>