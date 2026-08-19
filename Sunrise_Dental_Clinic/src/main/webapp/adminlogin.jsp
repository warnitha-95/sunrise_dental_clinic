<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Login | Sunrise Dental Clinic</title>

    <link rel="stylesheet" href="CSS/adminlogins.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>

<body>

<div class="container">

    <div class="logo-section">

        <div class="logo">
            <i class="fas fa-tooth"></i>
        </div>

        <div class="clinic-name">
            Sunrise Dental Clinic
        </div>

    </div>

    <div class="title">
         Login
    </div>

    <% 
        String errorMessage = (String) request.getAttribute("errorMessage");

        if (errorMessage != null) {
    %>

    <div class="system-message error" id="systemMessage">

        <div class="message-icon">
            <i class="fas fa-exclamation"></i>
        </div>

        <span>
            <%= errorMessage %>
        </span>

        <button type="button"
                class="message-close"
                onclick="closeMessage()">
            <i class="fas fa-xmark"></i>
        </button>

    </div>

    <% 
        }
    %>

    <form action="adminlogin" method="post" id="loginForm">

        <div class="input-box">

            <span class="details">
                Email Address
            </span>

            <input
                type="email"
                name="aemail"
                id="email"
                placeholder="Enter your email"
                autocomplete="off"
                required>

        </div>

        <div class="input-box">

            <span class="details">
                Password
            </span>

            <div class="password-wrapper">

                <input
                    type="password"
                    name="apassword"
                    id="password"
                    placeholder="Enter your password"
                    autocomplete="new-password"
                    required>

                <button
                    type="button"
                    class="password-toggle"
                    id="passwordToggle"
                    onclick="togglePassword()">

                    <i class="fas fa-eye"></i>

                </button>

            </div>

        </div>

        <div class="login-options">

            <label class="remember">

                <input
                    type="checkbox"
                    name="remember">

                <span>
                    Remember me
                </span>

            </label>

            <div class="pass">
                <a href="#">
                    Forgot Password?
                </a>
            </div>

        </div>

        <div class="button">

            <input
                type="submit"
                value="Login">

        </div>

    </form>

</div>

<script>

function togglePassword() {

    const password = document.getElementById("password");
    const toggleIcon = document.querySelector("#passwordToggle i");

    if (password.type === "password") {

        password.type = "text";

        toggleIcon.classList.remove("fa-eye");
        toggleIcon.classList.add("fa-eye-slash");

    } else {

        password.type = "password";

        toggleIcon.classList.remove("fa-eye-slash");
        toggleIcon.classList.add("fa-eye");
    }
}

function closeMessage() {

    const message = document.getElementById("systemMessage");

    if (message) {

        message.style.opacity = "0";
        message.style.transform = "translateY(-5px)";

        setTimeout(function() {
            message.remove();
        }, 300);
    }
}

document.addEventListener("DOMContentLoaded", function() {

    const message = document.getElementById("systemMessage");

    if (message) {

        setTimeout(function() {
            closeMessage();
        }, 4000);

        document.getElementById("email").value = "";
        document.getElementById("password").value = "";
    }

});

document.getElementById("loginForm").addEventListener("submit", function() {

    const button = this.querySelector(".button input");

    button.value = "Logging in...";
    button.disabled = true;

});

</script>

</body>
</html>