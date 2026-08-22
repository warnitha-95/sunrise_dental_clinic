<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
HttpSession sessionObj = request.getSession(false);

if (sessionObj == null || sessionObj.getAttribute("loggedInAdmin") == null) {
    response.sendRedirect("adminlogin.jsp");
    return;
}

String adminName = (String) sessionObj.getAttribute("loggedInAdmin");

int totalPatients = 0;
int totalAppointments = 0;
int todayAppointments = 0;
double totalRevenue = 0.0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Dashboard | Sunrise Dental Clinic</title>
<link rel="stylesheet" href="CSS/adminhomes.css">
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
            <a href="adminhome.jsp" class="active">
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
            <a href="manageappointments.jsp">
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

        <a href="registerappointment.jsp" class="appointment-btn">
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
                <p>Rs. <%= String.format("%.2f", totalRevenue) %></p>
                <span>Treatment revenue</span>
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
            <a href="registerappointment.jsp" class="quick-action">
                <div class="quick-icon">
                    <i class="fas fa-calendar-plus"></i>
                </div>
                <div>
                    <h3>New Appointment</h3>
                    <p>Register a new patient appointment</p>
                </div>
                <i class="fas fa-arrow-right action-arrow"></i>
            </a>

            <a href="appointmentdetails.jsp" class="quick-action">
                <div class="quick-icon">
                    <i class="fas fa-search"></i>
                </div>
                <div>
                    <h3>Find Appointment</h3>
                    <p>Search using appointment number</p>
                </div>
                <i class="fas fa-arrow-right action-arrow"></i>
            </a>

            <a href="billing.jsp" class="quick-action">
                <div class="quick-icon">
                    <i class="fas fa-calculator"></i>
                </div>
                <div>
                    <h3>Calculate Bill</h3>
                    <p>Calculate and print patient bills</p>
                </div>
                <i class="fas fa-arrow-right action-arrow"></i>
            </a>

            <a href="help.jsp" class="quick-action">
                <div class="quick-icon">
                    <i class="fas fa-circle-question"></i>
                </div>
                <div>
                    <h3>Help & Guide</h3>
                    <p>View system instructions</p>
                </div>
                <i class="fas fa-arrow-right action-arrow"></i>
            </a>
        </div>
    </section>

    <footer>
        <p>© 2026 Sunrise Dental Clinic. All Rights Reserved.</p>
        <span>Clinic Management System</span>
    </footer>
</div>

<script>
const toggleMenu = document.getElementById("toggleMenu");
const sidebar = document.getElementById("sidebar");

toggleMenu.addEventListener("click", function() {
    sidebar.classList.toggle("collapsed");
});
</script>

</body>
</html>