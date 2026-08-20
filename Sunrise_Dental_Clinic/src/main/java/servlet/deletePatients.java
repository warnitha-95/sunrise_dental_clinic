package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import services.patientService;

@WebServlet("/deletePatients")
public class deletePatients extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private patientService patientService;

    @Override
    public void init() throws ServletException {
        patientService = new patientService();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
            session.getAttribute("loggedInAdmin") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/adminlogin.jsp"
            );

            return;
        }

        String patientIdParam =
                request.getParameter("patient_id");

        if (patientIdParam == null ||
            patientIdParam.trim().isEmpty()) {

            session.setAttribute(
                    "error",
                    "Patient ID is required."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/managePatients"
            );

            return;
        }

        int patientId;

        try {

            patientId =
                    Integer.parseInt(
                            patientIdParam.trim()
                    );

        } catch (NumberFormatException e) {

            session.setAttribute(
                    "error",
                    "Invalid patient ID."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/managePatients"
            );

            return;
        }

        try {

            boolean deleted =
                    patientService.deletePatient(
                            patientId
                    );

            if (deleted) {

                session.setAttribute(
                        "success",
                        "Patient " +
                        patientId +
                        " was deleted successfully."
                );

            } else {

                session.setAttribute(
                        "error",
                        "Patient " +
                        patientId +
                        " was not found."
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            session.setAttribute(
                    "error",
                    "Unable to delete patient."
            );
        }

        response.sendRedirect(
                request.getContextPath()
                + "/managePatients"
        );
    }


    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}