package servlet;

import java.io.IOException;
import java.sql.Timestamp;

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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Open add patient page
        response.sendRedirect("addpatients.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        try {

            String patientId = request.getParameter("patient_id");
            String patientName = request.getParameter("patient_name");
            String address = request.getParameter("address");
            String contactNumber = request.getParameter("contact_number");
            String gender = request.getParameter("gender");
            String status = request.getParameter("status");


            if (patientId != null) {
                patientId = patientId.trim().toUpperCase();
            }

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

            if (patientId == null || patientId.isEmpty()) {

                session.setAttribute(
                        "error",
                        "Patient ID is required."
                );

                response.sendRedirect("addpatients.jsp");
                return;
            }

            if (!patientId.matches("^PN-\\d{4}$")) {

                session.setAttribute(
                        "error",
                        "Invalid Patient ID. Use format PN-0001."
                );

                response.sendRedirect("addpatients.jsp");
                return;
            }

            if (patientName == null || patientName.isEmpty()) {

                session.setAttribute(
                        "error",
                        "Patient name is required."
                );

                response.sendRedirect("addpatients.jsp");
                return;
            }

            if (!patientName.matches("^[a-zA-Z .'-]+$")) {

                session.setAttribute(
                        "error",
                        "Patient name contains invalid characters."
                );

                response.sendRedirect("addpatients.jsp");
                return;
            }

            if (address == null || address.isEmpty()) {

                session.setAttribute(
                        "error",
                        "Address is required."
                );

                response.sendRedirect("addpatients.jsp");
                return;
            }

            if (contactNumber == null || contactNumber.isEmpty()) {

                session.setAttribute(
                        "error",
                        "Contact number is required."
                );

                response.sendRedirect("addpatients.jsp");
                return;
            }

            if (!contactNumber.matches("^0\\d{9}$")) {

                session.setAttribute(
                        "error",
                        "Invalid contact number. Enter a 10-digit number starting with 0."
                );

                response.sendRedirect("addpatients.jsp");
                return;
            }

            if (gender == null || gender.isEmpty()) {

                session.setAttribute(
                        "error",
                        "Please select gender."
                );

                response.sendRedirect("addpatients.jsp");
                return;
            }

            if (status == null || status.isEmpty()) {
                status = "Active";
            }


            Timestamp registeredDateTime =
                    new Timestamp(System.currentTimeMillis());


            patient pat = new patient();

            pat.setPatient_id(patientId);
            pat.setPatient_name(patientName);
            pat.setAddress(address);
            pat.setContact_number(contactNumber);
            pat.setGender(gender);
            pat.setRegister_datetime(registeredDateTime);
            pat.setStatus(status);

            patientService service = new patientService();

            boolean success = service.addPatient(pat);

            if (success) {

                session.setAttribute(
                        "success",
                        "Patient " + patientId +
                        " has been registered successfully."
                );

                response.sendRedirect("managePatients");

            } else {

                session.setAttribute(
                        "error",
                        "Unable to add patient. Patient ID may already exist."
                );

                response.sendRedirect("addpatients.jsp");
            }

        } catch (Exception e) {

            e.printStackTrace();

            session.setAttribute(
                    "error",
                    "An error occurred while registering the patient: "
                    + e.getMessage()
            );

            response.sendRedirect("addpatients.jsp");
        }
    }
}