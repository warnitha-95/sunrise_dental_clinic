package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.patient;
import services.patientService;

@WebServlet("/addPatients")
public class addPatients extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public addPatients() {
        super();
    }


    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check admin login
        if (session == null ||
            session.getAttribute("loggedInAdmin") == null) {

            response.sendRedirect(
                request.getContextPath() + "/adminlogin.jsp"
            );

            return;
        }

        request.getRequestDispatcher(
            "addpatients.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        // =====================================================
        // CHECK ADMIN LOGIN
        // =====================================================

        if (session == null ||
            session.getAttribute("loggedInAdmin") == null) {

            response.sendRedirect(
                request.getContextPath() + "/adminlogin.jsp"
            );

            return;
        }

        String patientName =
                request.getParameter("patient_name");

        String address =
                request.getParameter("address");

        String contactNumber =
                request.getParameter("contact_number");

        String gender =
                request.getParameter("gender");

        String status =
                request.getParameter("status");


        if (patientName != null) {
            patientName = patientName.trim();
        }

        if (address != null) {
            address = address.trim();
        }

        if (contactNumber != null) {
            contactNumber = contactNumber.trim();
        }

        if (gender != null) {
            gender = gender.trim();
        }

        if (status != null) {
            status = status.trim();
        }


        // =====================================================
        // VALIDATION
        // =====================================================

        if (patientName == null ||
            patientName.isEmpty()) {

            session.setAttribute(
                "error",
                "Please enter the patient name."
            );

            response.sendRedirect(
                request.getContextPath() + "/addpatients.jsp"
            );

            return;
        }


        if (address == null ||
            address.isEmpty()) {

            session.setAttribute(
                "error",
                "Please enter the patient address."
            );

            response.sendRedirect(
                request.getContextPath() + "/addpatients.jsp"
            );

            return;
        }


        if (contactNumber == null ||
            contactNumber.isEmpty()) {

            session.setAttribute(
                "error",
                "Please enter the contact number."
            );

            response.sendRedirect(
                request.getContextPath() + "/addpatients.jsp"
            );

            return;
        }


        // Sri Lankan phone number validation
        if (!contactNumber.matches("0[0-9]{9}")) {

            session.setAttribute(
                "error",
                "Please enter a valid 10-digit contact number."
            );

            response.sendRedirect(
                request.getContextPath() + "/addpatients.jsp"
            );

            return;
        }


        if (gender == null ||
            gender.isEmpty()) {

            session.setAttribute(
                "error",
                "Please select the patient's gender."
            );

            response.sendRedirect(
                request.getContextPath() + "/addpatients.jsp"
            );

            return;
        }


        if (status == null ||
            status.isEmpty()) {

            status = "Active";
        }

        patient pat = new patient();

        pat.setPatient_name(patientName);
        pat.setAddress(address);
        pat.setContact_number(contactNumber);
        pat.setGender(gender);
        pat.setStatus(status);


        patientService service =
                new patientService();

        boolean success =
                service.addPatient(pat);


        if (success) {

            session.setAttribute(
                "success",
                "Patient added successfully."
            );

            response.sendRedirect(
                request.getContextPath() + "/managePatients"
            );

        }


        else {

            session.setAttribute(
                "error",
                "Unable to add patient. Please try again."
            );

            response.sendRedirect(
                request.getContextPath() + "/addpatients.jsp"
            );
        }
    }
}