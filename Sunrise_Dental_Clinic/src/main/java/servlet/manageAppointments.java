package servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import services.appointmentService;

@WebServlet("/manageAppointments")
public class manageAppointments extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private appointmentService appointmentService;

    @Override
    public void init() throws ServletException {
        appointmentService = new appointmentService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("loggedInAdmin") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/adminlogin.jsp"
            );

            return;
        }

        String action = request.getParameter("action");

        if ("delete".equals(action)) {

            String idValue = request.getParameter("id");

            try {

                int appointmentId = Integer.parseInt(idValue);

                boolean deleted =
                        appointmentService.deleteAppointment(appointmentId);

                if (deleted) {

                    request.getSession().setAttribute(
                            "successMessage",
                            "Appointment deleted successfully."
                    );

                } else {

                    request.getSession().setAttribute(
                            "errorMessage",
                            "Unable to delete appointment."
                    );
                }

            } catch (NumberFormatException e) {

                request.getSession().setAttribute(
                        "errorMessage",
                        "Invalid appointment id."
                );
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/manageAppointments"
            );

            return;
        }

        loadList(request, response);
    }

    private void loadList(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            List<?> appointments =
                    appointmentService.getAllAppointments();

            request.setAttribute(
                    "appointments",
                    appointments
            );

            HttpSession session = request.getSession(false);

            if (session != null) {

                Object successMessage =
                        session.getAttribute("successMessage");

                Object errorMessage =
                        session.getAttribute("errorMessage");

                if (successMessage != null) {

                    request.setAttribute(
                            "successMessage",
                            successMessage
                    );

                    session.removeAttribute("successMessage");
                }

                if (errorMessage != null) {

                    request.setAttribute(
                            "errorMessage",
                            errorMessage
                    );

                    session.removeAttribute("errorMessage");
                }
            }

            request.getRequestDispatcher(
                    "/manageappointments.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            throw new ServletException(
                    "Unable to load appointments.",
                    e
            );
        }
    }
}