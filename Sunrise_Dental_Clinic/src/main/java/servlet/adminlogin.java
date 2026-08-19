package servlet;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.admin;
import services.adminService;

@WebServlet("/adminlogin")
public class adminlogin extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public adminlogin() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("aemail");
        String password = request.getParameter("apassword");

        adminService service = new adminService();
        admin adm = service.validateAdmin(email, password);

        if (adm != null) {

            HttpSession session = request.getSession();

            session.setAttribute("loggedInAdmin", adm.getA_name());
            session.setAttribute("adminEmail", adm.getA_email());

            response.sendRedirect("adminhomes.jsp");

        } else {

            request.setAttribute(
                "errorMessage",
                "Invalid email or password. Please try again."
            );

            RequestDispatcher dispatcher =
                    request.getRequestDispatcher("adminlogin.jsp");

            dispatcher.forward(request, response);
        }
    }
}