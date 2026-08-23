<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
if (session == null || session.getAttribute("loggedInAdmin") == null) {
    response.sendRedirect(request.getContextPath() + "/adminlogin.jsp");
    return;
}

String adminName = (String) session.getAttribute("loggedInAdmin");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Help | Sunrise Dental Clinic</title>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/CSS/adminhomes.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/CSS/help.css">
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
            <a href="<%= request.getContextPath() %>/adminhomes.jsp">
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
            <a href="<%= request.getContextPath() %>/help.jsp" class="active">
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
                    <i class="fas fa-circle-question"></i>
                    Help &amp; User Guide
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

    <div class="help-page">

        <div class="page-header">

            <div class="header-content">

                <span class="page-label">
                    STAFF GUIDE
                </span>

                <h1>
                    How to Use the Clinic Management System
                </h1>

                <p>
                    A quick reference for new staff. Click any section below
                    to expand step-by-step instructions.
                </p>

            </div>

        </div>

        <div class="help-search">
            <i class="fas fa-magnifying-glass"></i>
            <input
                type="text"
                id="helpSearch"
                placeholder="Search help topics, e.g. 'create appointment', 'delete patient', 'print bill'...">
        </div>

        <div class="help-accordion" id="helpAccordion">

            <!-- 1. Getting Started -->
            <div class="help-card" data-keywords="login logout password sign in admin">

                <button type="button" class="help-card-header">

                    <div class="help-card-title">
                        <span class="help-icon"><i class="fas fa-right-to-bracket"></i></span>
                        <div>
                            <h2>1. Getting Started</h2>
                            <p>Logging in and finding your way around</p>
                        </div>
                    </div>

                    <span class="chevron"><i class="fas fa-chevron-down"></i></span>

                </button>

                <div class="help-card-body">

                    <ol class="step-list">

                        <li>
                            <strong>Log in.</strong>
                            Open the login page and enter your admin username and
                            password. If you don't have credentials yet, ask your
                            clinic administrator to create an account for you.
                        </li>

                        <li>
                            <strong>Use the sidebar to navigate.</strong>
                            The menu on the left is always visible and takes you to
                            Dashboard, Manage Patients, New Appointment, All
                            Appointments, Billing, and Help.
                        </li>

                        <li>
                            <strong>Check your session.</strong>
                            Your name appears in the top-right corner of every page.
                            If you're ever redirected back to the login page
                            unexpectedly, it means your session expired - simply log
                            in again.
                        </li>

                        <li>
                            <strong>Log out when you're done.</strong>
                            Click <em>Logout</em> at the bottom of the sidebar,
                            especially on shared computers.
                        </li>

                    </ol>

                </div>

            </div>

            <!-- 2. Registering / Managing Patients -->
            <div class="help-card" data-keywords="patient register search edit delete new patient managepatients">

                <button type="button" class="help-card-header">

                    <div class="help-card-title">
                        <span class="help-icon"><i class="fas fa-user-injured"></i></span>
                        <div>
                            <h2>2. Managing Patients</h2>
                            <p>Viewing, searching, and updating patient records</p>
                        </div>
                    </div>

                    <span class="chevron"><i class="fas fa-chevron-down"></i></span>

                </button>

                <div class="help-card-body">

                    <ol class="step-list">

                        <li>
                            <strong>Open Manage Patients.</strong>
                            Click <em>Manage Patients</em> in the sidebar to see
                            every registered patient, most recently added first.
                        </li>

                        <li>
                            <strong>Search for a patient.</strong>
                            Use the search box to look up a patient by name,
                            contact number, or patient ID.
                        </li>

                        <li>
                            <strong>New patients are registered automatically.</strong>
                            You don't need to manually add a patient here - when you
                            create a New Appointment, entering a contact number that
                            isn't already in the system automatically registers that
                            person as a new patient.
                        </li>

                        <li>
                            <strong>Editing patient details.</strong>
                            Patient name, address, and gender can be updated from the
                            Edit Appointment screen for any of their appointments -
                            changes there also update the patient's master record.
                        </li>

                    </ol>

                </div>

            </div>

            <!-- 3. New Appointment -->
            <div class="help-card" data-keywords="new appointment create book schedule treatment dentist registered patient">

                <button type="button" class="help-card-header">

                    <div class="help-card-title">
                        <span class="help-icon"><i class="fas fa-calendar-plus"></i></span>
                        <div>
                            <h2>3. Creating a New Appointment</h2>
                            <p>Booking a visit for a new or returning patient</p>
                        </div>
                    </div>

                    <span class="chevron"><i class="fas fa-chevron-down"></i></span>

                </button>

                <div class="help-card-body">

                    <ol class="step-list">

                        <li>
                            <strong>Click New Appointment</strong> in the sidebar.
                        </li>

                        <li>
                            <strong>Enter the contact number first.</strong>
                            The system checks automatically after a short pause.
                            <ul class="sub-list">
                                <li>
                                    <span class="tag tag-found">Existing patient</span>
                                    - their name, address, and gender fill in
                                    automatically and lock so details can't be
                                    accidentally changed here.
                                </li>
                                <li>
                                    <span class="tag tag-new">New patient</span>
                                    - the fields stay editable; fill in their name,
                                    address, and gender. A new patient record is
                                    created automatically when you submit.
                                </li>
                            </ul>
                        </li>

                        <li>
                            <strong>Choose a dentist</strong> from the dropdown, and
                            set the <strong>appointment date and time</strong>. The
                            date/time cannot be in the past.
                        </li>

                        <li>
                            <strong>Select treatments.</strong>
                            Tick between 1 and 3 treatments. The total price updates
                            automatically as you select.
                        </li>

                        <li>
                            <strong>Click Create Appointment</strong> to save. You'll
                            be taken back to the appointments list, and the new
                            appointment gets a unique appointment number
                            automatically.
                        </li>

                    </ol>

                    <div class="help-note">
                        <i class="fas fa-circle-info"></i>
                        <p>
                            If required fields are missing or a date is invalid, an
                            error message appears at the top of the form - correct
                            the highlighted issue and submit again.
                        </p>
                    </div>

                </div>

            </div>

            <!-- 4. Managing Appointments -->
            <div class="help-card" data-keywords="all appointments edit delete status cancel complete search list">

                <button type="button" class="help-card-header">

                    <div class="help-card-title">
                        <span class="help-icon"><i class="fas fa-calendar-check"></i></span>
                        <div>
                            <h2>4. Editing, Cancelling &amp; Deleting Appointments</h2>
                            <p>Making changes to appointments already booked</p>
                        </div>
                    </div>

                    <span class="chevron"><i class="fas fa-chevron-down"></i></span>

                </button>

                <div class="help-card-body">

                    <ol class="step-list">

                        <li>
                            <strong>Open All Appointments</strong> in the sidebar to
                            see every booked appointment with patient, dentist,
                            schedule, treatments, and status.
                        </li>

                        <li>
                            <strong>Search the list</strong> using the search box -
                            it matches patient name, appointment number, contact
                            number, or dentist.
                        </li>

                        <li>
                            <strong>To edit an appointment,</strong> click the pencil
                            icon on its row. You can update the patient's details,
                            dentist, schedule, treatments, and status
                            (<em>Scheduled</em>, <em>Completed</em>, or
                            <em>Cancelled</em>), then click <em>Save Changes</em>.
                        </li>

                        <li>
                            <strong>To delete an appointment,</strong> click the
                            trash icon on its row and confirm. This cannot be undone
                            — the appointment and its treatment records are removed
                            permanently.
                        </li>

                        <li>
                            <strong>Marking a visit complete.</strong>
                            Once the patient has been treated, edit the appointment
                            and set its status to <em>Completed</em> so it's
                            reflected correctly on the dashboard and in billing.
                        </li>

                    </ol>

                </div>

            </div>

            <!-- 5. Billing -->
            <div class="help-card" data-keywords="bill billing receipt print invoice total consultation fee">

                <button type="button" class="help-card-header">

                    <div class="help-card-title">
                        <span class="help-icon"><i class="fas fa-file-invoice-dollar"></i></span>
                        <div>
                            <h2>5. Generating &amp; Printing a Bill</h2>
                            <p>Producing a patient receipt for an appointment</p>
                        </div>
                    </div>

                    <span class="chevron"><i class="fas fa-chevron-down"></i></span>

                </button>

                <div class="help-card-body">

                    <ol class="step-list">

                        <li>
                            <strong>Go to All Appointments</strong> and find the
                            appointment you want to bill.
                        </li>

                        <li>
                            <strong>Click the invoice icon</strong> on that row to
                            open the bill.
                        </li>

                        <li>
                            <strong>Review the bill.</strong>
                            It lists the patient and appointment details, a flat
                            consultation fee, each treatment with its price, and a
                            grand total (treatments + consultation fee).
                        </li>

                        <li>
                            <strong>Click Print Bill</strong> to print or save the
                            receipt as a PDF using your browser's print dialog. The
                            sidebar and menus are automatically hidden on the printed
                            copy so only the receipt itself is printed.
                        </li>

                    </ol>

                    <div class="help-note">
                        <i class="fas fa-circle-info"></i>
                        <p>
                            The consultation fee is a fixed amount applied to every
                            appointment automatically - you don't need to enter it
                            manually.
                        </p>
                    </div>

                </div>

            </div>

            <!-- 6. Troubleshooting -->
            <div class="help-card" data-keywords="error problem issue not working troubleshoot">

                <button type="button" class="help-card-header">

                    <div class="help-card-title">
                        <span class="help-icon"><i class="fas fa-triangle-exclamation"></i></span>
                        <div>
                            <h2>6. Troubleshooting</h2>
                            <p>Common issues and what to do about them</p>
                        </div>
                    </div>

                    <span class="chevron"><i class="fas fa-chevron-down"></i></span>

                </button>

                <div class="help-card-body">

                    <ol class="step-list">

                        <li>
                            <strong>"No active dentists/treatments available"</strong>
                            when creating an appointment means none are marked
                            Active in the system. Contact your administrator to add
                            or activate one.
                        </li>

                        <li>
                            <strong>Redirected to the login page unexpectedly?</strong>
                            Your session has expired for security reasons. Simply
                            log back in - no data is lost for appointments that were
                            already saved.
                        </li>

                        <li>
                            <strong>An existing patient's details didn't auto-fill?</strong>
                            Double check the contact number is typed exactly as it
                            appears in Manage Patients, with no extra spaces or
                            symbols.
                        </li>

                        <li>
                            <strong>Still stuck?</strong>
                            Reach out to your system administrator with the exact
                            error message shown on screen - this makes it much
                            faster to resolve.
                        </li>

                    </ol>

                </div>

            </div>

        </div>

    </div>

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

document.addEventListener("DOMContentLoaded", function () {

    const cards = document.querySelectorAll(".help-card");

    cards.forEach(function (card) {

        const header = card.querySelector(".help-card-header");

        header.addEventListener("click", function () {
            card.classList.toggle("open");
        });
    });

    if (cards.length > 0) {
        cards[0].classList.add("open");
    }

    const searchInput = document.getElementById("helpSearch");

    if (searchInput) {

        searchInput.addEventListener("input", function () {

            const query = searchInput.value.trim().toLowerCase();

            cards.forEach(function (card) {

                const keywords = (card.getAttribute("data-keywords") || "").toLowerCase();
                const titleText = card.querySelector("h2").textContent.toLowerCase();
                const bodyText = card.querySelector(".help-card-body").textContent.toLowerCase();

                const matches =
                    query === "" ||
                    keywords.indexOf(query) !== -1 ||
                    titleText.indexOf(query) !== -1 ||
                    bodyText.indexOf(query) !== -1;

                card.style.display = matches ? "" : "none";

                if (query !== "" && matches) {
                    card.classList.add("open");
                }
            });
        });
    }
});
</script>
</body>
</html>