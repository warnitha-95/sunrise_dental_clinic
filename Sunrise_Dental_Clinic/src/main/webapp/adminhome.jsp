<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    HttpSession sessionObj = request.getSession(false);

    if (sessionObj == null || sessionObj.getAttribute("loggedInAdmin") == null) {
        response.sendRedirect("adminlogin.jsp");
        return;
    }

    String adminName = (String) sessionObj.getAttribute("loggedInAdmin");

    int totalCustomers = 0;
    int totalOrders = 0;
    double totalRevenue = 0.0;
    int totalFeedback = 0;

%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pahana Edu Home</title>
    <link rel="stylesheet" href="CSS/adminhomes.css">
    <script defer src="JS/admin_home.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body>
    <div class="sidebar">
        <h2 class="logo"><i class="fas fa-book-open"></i> Pahana Edu</h2>
        <ul>
            <li><a href="adminhome.jsp" class="active"><i class="fas fa-chart-line"></i> Dashboard</a></li>
            <li><a href="managecustomers.jsp"><i class="fas fa-users"></i> Manage Customers</a></li>
            <li><a href="manageitem.jsp"><i class="fa-solid fa-boxes-stacked"></i> Manage Items</a></li>
            <li><a href="adminviewbooking.jsp"><i class="fas fa-book"></i> All Orders</a></li>
            <li><a href="help.jsp" ><i class="fas fa-question-circle"></i> Help</a></li>
            <li><a href="adminlogout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>

    <div class="main-content">
        <header>
            <h2><i class="fas fa-chart-line"></i> Dashboard</h2>
           
            <button id="toggleMenu"><i class="fas fa-bars"></i></button>
        </header>
        
        <div class="cards">
            <div class="card">
                <i class="fas fa-users"></i>
                <h3>Total Customers</h3>
                <p>10</p>
            </div>
            <div class="card">
                <i class="fas fa-shopping-cart"></i>
                <h3>Total Orders</h3>
                <p>269</p>
            </div>
            <div class="card">
                <i class="fas fa-dollar-sign"></i>
                <h3>Revenue</h3>
                <p>Rs. 35700</p>
            </div>
            <div class="card">
                <i class="fas fa-comments"></i>
                <h3>Feedback</h3>
                <p>0</p>
            </div>
        </div>
    </div>
</body>
</html>
