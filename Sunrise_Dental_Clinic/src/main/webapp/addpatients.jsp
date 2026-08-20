<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("loggedInAdmin") == null) {
        response.sendRedirect("adminlogin.jsp");
        return;
    }
    String adminName = (String) sessionObj.getAttribute("loggedInAdmin");
    String error = (String) sessionObj.getAttribute("error");
    sessionObj.removeAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Patient | Sunrise Dental Clinic</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="CSS/adminpatients.css">
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
            <a href="adminhome.jsp">
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
            <a href="registerappointment.jsp">
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
            <button class="mobile-menu" id="toggleMenu" type="button">
                <i class="fas fa-bars"></i>
            </button>
            <div class="header-title">
                <h2>
                    <i class="fas fa-user-plus"></i>
                    Add Patient
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
        <div class="heading-left">
            <div class="heading-icon">
                <i class="fas fa-user-plus"></i>
            </div>
            <div>
                <h1>Register New Patient</h1>
                <p>Enter patient information to create a new clinic record.</p>
            </div>
        </div>
        <a href="<%= request.getContextPath() %>/managePatients" class="primary-btn">
            <i class="fas fa-arrow-left"></i>
            Back to Patients
        </a>
    </section>
    <% if (error != null && !error.trim().isEmpty()) { %>
        <div class="alert error-alert" id="errorAlert">
            <div class="alert-icon">
                <i class="fas fa-circle-exclamation"></i>
            </div>
            <div class="alert-content">
                <strong>Unable to Register Patient</strong>
                <span><%= error %></span>
            </div>
            <button type="button" class="alert-close" onclick="closeAlert('errorAlert')">
                <i class="fas fa-xmark"></i>
            </button>
        </div>
    <% } %>
    <section class="form-page">
        <div class="form-header">
            <div class="form-header-icon">
                <i class="fas fa-id-card"></i>
            </div>
            <div>
                <h2>Patient Information</h2>
                <p>Complete the patient details below.</p>
            </div>
        </div>
        <form action="<%= request.getContextPath() %>/addPatients" method="post" class="patient-form" id="patientForm" autocomplete="off">
            <div class="form-grid">
                <div class="form-group">
                    <label class="form-label" for="patient_name">
                        Patient Name
                        <span class="required">*</span>
                    </label>
                    <div class="input-wrapper">
                        <input type="text" id="patient_name" name="patient_name" class="form-control" placeholder="Enter patient's full name" maxlength="100" required>
                        <i class="fas fa-user"></i>
                    </div>
                    <span class="input-help">Enter the patient's full name.</span>
                </div>
                <div class="form-group full-width">
                    <label class="form-label" for="address">
                        Address
                        <span class="required">*</span>
                    </label>
                    <div class="input-wrapper">
                        <textarea id="address" name="address" class="form-control" placeholder="Enter patient's residential address" maxlength="255" required></textarea>
                        <i class="fas fa-location-dot"></i>
                    </div>
                    <span class="input-help">Enter the patient's current residential address.</span>
                </div>
                <div class="form-group">
                    <label class="form-label" for="contact_number">
                        Contact Number
                        <span class="required">*</span>
                    </label>
                    <div class="input-wrapper">
                        <input type="tel" id="contact_number" name="contact_number" class="form-control" placeholder="0771234567" maxlength="10" inputmode="numeric" required>
                        <i class="fas fa-phone"></i>
                    </div>
                    <span class="input-help">Enter a 10-digit Sri Lankan mobile number.</span>
                    <span class="validation-message" id="phoneError">Enter a valid 10-digit contact number.</span>
                </div>
                <div class="form-group">
                    <label class="form-label">
                        Gender
                        <span class="required">*</span>
                    </label>
                    <div class="gender-options">
                        <div class="gender-option">
                            <input type="radio" id="male" name="gender" value="Male" required>
                            <label for="male" class="gender-label">
                                <i class="fas fa-mars"></i>
                                <span>Male</span>
                            </label>
                        </div>
                        <div class="gender-option">
                            <input type="radio" id="female" name="gender" value="Female">
                            <label for="female" class="gender-label">
                                <i class="fas fa-venus"></i>
                                <span>Female</span>
                            </label>
                        </div>
                        <div class="gender-option">
                            <input type="radio" id="other" name="gender" value="Other">
                            <label for="other" class="gender-label">
                                <i class="fas fa-user"></i>
                                <span>Other</span>
                            </label>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">
                        Status
                        <span class="required">*</span>
                    </label>
                    <div class="status-options">
                        <div class="status-option active-option">
                            <input type="radio" id="active" name="status" value="Active" checked required>
                            <label for="active" class="status-label">
                                <span class="status-dot"></span>
                                Active
                            </label>
                        </div>
                        <div class="status-option inactive-option">
                            <input type="radio" id="inactive" name="status" value="Inactive">
                            <label for="inactive" class="status-label">
                                <span class="status-dot"></span>
                                Inactive
                            </label>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Registered Date &amp; Time</label>
                    <div class="input-wrapper">
                        <input type="text" class="form-control readonly-field" value="Automatically generated" readonly>
                        <i class="far fa-calendar"></i>
                    </div>
                    <span class="input-help">Registration date and time will be generated automatically by the system.</span>
                </div>
            </div>
            <div class="form-actions">
                <a href="<%= request.getContextPath() %>/managePatients" class="btn cancel-btn">
                    <i class="fas fa-xmark"></i>
                    Cancel
                </a>
                <button type="submit" class="btn save-btn" id="savePatientBtn">
                    <i class="fas fa-user-plus"></i>
                    Register Patient
                </button>
            </div>
        </form>
    </section>
    <footer>
        <p>© 2026 Sunrise Dental Clinic. All Rights Reserved.</p>
        <span>Clinic Management System</span>
    </footer>
</div>
<script>
document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("patientForm");
    const phone = document.getElementById("contact_number");
    const patientName = document.getElementById("patient_name");
    const address = document.getElementById("address");
    const toggleMenu = document.getElementById("toggleMenu");
    const sidebar = document.getElementById("sidebar");
    if (toggleMenu && sidebar) {
        toggleMenu.addEventListener("click", function () {
            sidebar.classList.toggle("collapsed");
        });
    }
    if (phone) {
        phone.addEventListener("input", function () {
            this.value = this.value.replace(/[^0-9]/g, "");
            if (this.value.length > 10) {
                this.value = this.value.substring(0, 10);
            }
            if (/^0\d{9}$/.test(this.value)) {
                this.classList.remove("invalid");
                const phoneError = document.getElementById("phoneError");
                if (phoneError) {
                    phoneError.classList.remove("show");
                }
            }
        });
    }
    if (patientName) {
        patientName.addEventListener("input", function () {
            if (this.value.trim().length >= 2) {
                this.classList.remove("invalid");
            }
        });
    }
    if (address) {
        address.addEventListener("input", function () {
            if (this.value.trim().length >= 3) {
                this.classList.remove("invalid");
            }
        });
    }
    if (form) {
        form.addEventListener("submit", function (event) {
            let valid = true;
            const phoneError = document.getElementById("phoneError");
            if (!phone || !/^0\d{9}$/.test(phone.value.trim())) {
                if (phone) {
                    phone.classList.add("invalid");
                }
                if (phoneError) {
                    phoneError.classList.add("show");
                }
                valid = false;
            } else {
                phone.classList.remove("invalid");
                if (phoneError) {
                    phoneError.classList.remove("show");
                }
            }
            if (!patientName || patientName.value.trim().length < 2) {
                if (patientName) {
                    patientName.classList.add("invalid");
                }
                valid = false;
            } else {
                patientName.classList.remove("invalid");
            }
            if (!address || address.value.trim().length < 3) {
                if (address) {
                    address.classList.add("invalid");
                }
                valid = false;
            } else {
                address.classList.remove("invalid");
            }
            if (!valid) {
                event.preventDefault();
                return;
            }
            const button = document.getElementById("savePatientBtn");
            if (button) {
                button.disabled = true;
                button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Registering...';
            }
        });
    }
});
function closeAlert(id) {
    const alert = document.getElementById(id);
    if (!alert) {
        return;
    }
    alert.style.opacity = "0";
    alert.style.transform = "translateY(-5px)";
    setTimeout(function () {
        alert.remove();
    }, 250);
}
</script>
</body>
</html>