<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%@ page import="services.patientService"%>
<%@ page import="services.appointmentService"%>
<%@ page import="model.appointment"%>
<%@ page import="java.util.List"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="java.util.Calendar"%>
<%
HttpSession sessionObj = request.getSession(false);

if (sessionObj == null || sessionObj.getAttribute("loggedInAdmin") == null) {
    response.sendRedirect(request.getContextPath() + "/adminlogin.jsp");
    return;
}

String adminName = (String) sessionObj.getAttribute("loggedInAdmin");

patientService patientService = new patientService();
appointmentService appointmentService = new appointmentService();

int totalPatients = 0;
int totalAppointments = 0;
int todayAppointments = 0;
BigDecimal totalRevenue = BigDecimal.ZERO;

try {

    totalPatients = patientService.getAllPatients().size();

    List<appointment> allAppointments = appointmentService.getAllAppointments();

    totalAppointments = allAppointments.size();

    Calendar todayStart = Calendar.getInstance();
    todayStart.set(Calendar.HOUR_OF_DAY, 0);
    todayStart.set(Calendar.MINUTE, 0);
    todayStart.set(Calendar.SECOND, 0);
    todayStart.set(Calendar.MILLISECOND, 0);

    Calendar todayEnd = (Calendar) todayStart.clone();
    todayEnd.add(Calendar.DAY_OF_MONTH, 1);

    for (appointment appt : allAppointments) {

        if (appt.getAppointmentDatetime() != null) {

            long apptTime = appt.getAppointmentDatetime().getTime();

            if (apptTime >= todayStart.getTimeInMillis() &&
                apptTime < todayEnd.getTimeInMillis()) {

                todayAppointments++;
            }
        }

        if ("Completed".equalsIgnoreCase(appt.getStatus()) &&
            appt.getTotalPrice() != null) {

            totalRevenue = totalRevenue
                    .add(appt.getTotalPrice())
                    .add(appointmentService.CONSULTATION_FEE);
        }
    }

} catch (Exception e) {

    e.printStackTrace();
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Dashboard | Sunrise Dental Clinic</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/CSS/adminhomes.css">
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
            <a href="<%= request.getContextPath() %>/adminhomes.jsp" class="active">
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
            
            <div>
                <h2>
                    <i class="fas fa-chart-line"></i>
                    Dashboard
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
            <h1>Welcome, <%= adminName %>!</h1>
            <p>Manage patients, appointments and billing efficiently from your dashboard.</p>
        </div>

        <a href="<%= request.getContextPath() %>/newAppointment" class="appointment-btn">
            <i class="fas fa-calendar-plus"></i>
            Register Appointment
        </a>
    </section>

    <div class="cards">
        <div class="card patients-card">
            <div class="card-icon">
                <i class="fas fa-user-injured"></i>
            </div>
            <div class="card-info">
                <h3>Total Patients</h3>
                <p><%= totalPatients %></p>
                <span>Registered patients</span>
            </div>
        </div>

        <div class="card appointment-card">
            <div class="card-icon">
                <i class="fas fa-calendar-check"></i>
            </div>
            <div class="card-info">
                <h3>Total Appointments</h3>
                <p><%= totalAppointments %></p>
                <span>Scheduled appointments</span>
            </div>
        </div>

        <div class="card today-card">
            <div class="card-icon">
                <i class="fas fa-calendar-day"></i>
            </div>
            <div class="card-info">
                <h3>Today's Appointments</h3>
                <p><%= todayAppointments %></p>
                <span>Appointments today</span>
            </div>
        </div>

        <div class="card revenue-card">
            <div class="card-icon">
                <i class="fas fa-file-invoice-dollar"></i>
            </div>
            <div class="card-info">
                <h3>Total Revenue</h3>
                <p>Rs. <%= String.format("%,.2f", totalRevenue) %></p>
                <span>Completed appointments</span>
            </div>
        </div>
    </div>

    <section class="dashboard-section">
        <div class="section-header">
            <div>
                <h2>Quick Actions</h2>
                <p>Frequently used clinic functions</p>
            </div>
        </div>

        <div class="quick-actions">
            <a href="<%= request.getContextPath() %>/newAppointment" class="quick-action">
                <div class="quick-icon">
                    <i class="fas fa-calendar-plus"></i>
                </div>
                <div>
                    <h3>New Appointment</h3>
                    <p>Register a new patient appointment</p>
                </div>
                <i class="fas fa-arrow-right action-arrow"></i>
            </a>

            <a href="<%= request.getContextPath() %>/manageappointments.jsp" class="quick-action">
                <div class="quick-icon">
                    <i class="fas fa-search"></i>
                </div>
                <div>
                    <h3>Find Appointment</h3>
                    <p>Search appointments by patient, number, or dentist</p>
                </div>
                <i class="fas fa-arrow-right action-arrow"></i>
            </a>

            <a href="<%= request.getContextPath() %>/billing.jsp" class="quick-action">
                <div class="quick-icon">
                    <i class="fas fa-calculator"></i>
                </div>
                <div>
                    <h3>Calculate Bill</h3>
                    <p>Calculate and print patient bills</p>
                </div>
                <i class="fas fa-arrow-right action-arrow"></i>
            </a>

            <a href="<%= request.getContextPath() %>/help.jsp" class="quick-action">
                <div class="quick-icon">
                    <i class="fas fa-circle-question"></i>
                </div>
                <div>
                    <h3>Help &amp; Guide</h3>
                    <p>View system instructions</p>
                </div>
                <i class="fas fa-arrow-right action-arrow"></i>
            </a>
        </div>
    </section>

    <footer>
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
</script>

</body>
</html>