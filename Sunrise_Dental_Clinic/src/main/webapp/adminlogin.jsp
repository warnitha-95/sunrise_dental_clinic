<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login | Sunrise Dental Clinic</title>
  <link rel="stylesheet" href="CSS/adminlogin.css">
</head>
<body>
  <div class="container">
    <!-- Title section -->
    <div class="title">Sunrise Dental Clinic Login</div>
    
    <div class="content">
      <form action="adminlogin" method="post">
        <div class="user-details">

          <div class="input-box">
            <span class="details">email</span>
            <input type="email" name="aemail" placeholder="Enter your email" required>
          </div>

          <div class="input-box">
            <span class="details">Password</span>
            <input type="password" name="apassword" placeholder="Enter your password" required>
          </div>
        </div>

        
        <!-- Submit button -->
        <div class="button">
          <input type="submit" value="Login">
        </div>
      </form>
    </div>
  </div>
</body>
</html>