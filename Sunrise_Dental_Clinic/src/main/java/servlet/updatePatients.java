package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import controller.DBConnect;

@WebServlet("/updatePatients")
public class updatePatients extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String patientId = request.getParameter("patient_id");

        if (patientId == null || patientId.trim().isEmpty()) {

            request.getSession().setAttribute(
                    "error",
                    "Patient ID is required."
            );

            response.sendRedirect(
                    request.getContextPath() + "/managePatients"
            );

            return;
        }

        patientId = patientId.trim();

        String sql =
                "SELECT patient_id, patient_name, address, " +
                "contact_number, gender, registered_datetime, status " +
                "FROM patients " +
                "WHERE patient_id = ?";

        try (
            Connection conn = DBConnect.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            stmt.setString(1, patientId);

            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {


                    request.setAttribute(
                            "patient_id",
                            rs.getString("patient_id")
                    );

                    request.setAttribute(
                            "patient_name",
                            rs.getString("patient_name")
                    );

                    request.setAttribute(
                            "address",
                            rs.getString("address")
                    );

                    request.setAttribute(
                            "contact_number",
                            rs.getString("contact_number")
                    );

                    request.setAttribute(
                            "gender",
                            rs.getString("gender")
                    );

                    request.setAttribute(
                            "registered_datetime",
                            rs.getTimestamp("registered_datetime")
                    );

                    request.setAttribute(
                            "status",
                            rs.getString("status")
                    );

                    request.getRequestDispatcher(
                            "updatepatients.jsp"
                    ).forward(request, response);

                } else {

                    request.getSession().setAttribute(
                            "error",
                            "Patient " + patientId + " was not found."
                    );

                    response.sendRedirect(
                            request.getContextPath() + "/managePatients"
                    );
                }
            }

        } catch (Exception e) {

            e.printStackTrace();

            request.getSession().setAttribute(
                    "error",
                    "Unable to load patient details."
            );

            response.sendRedirect(
                    request.getContextPath() + "/managePatients"
            );
        }
    }


    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");


        String patientId =
                request.getParameter("patient_id");

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


        if (patientId != null) {
            patientId = patientId.trim();
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



        if (patientId == null ||
            patientId.isEmpty() ||

            patientName == null ||
            patientName.isEmpty() ||

            address == null ||
            address.isEmpty() ||

            contactNumber == null ||
            contactNumber.isEmpty() ||

            gender == null ||
            gender.isEmpty() ||

            status == null ||
            status.isEmpty()) {

            request.getSession().setAttribute(
                    "error",
                    "Please fill all required patient fields."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/updatePatients?patient_id="
                    + patientId
            );

            return;
        }


        if (!patientId.matches("^PN-\\d{4}$")) {

            request.getSession().setAttribute(
                    "error",
                    "Invalid Patient ID format. Example: PN-0001."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/updatePatients?patient_id="
                    + patientId
            );

            return;
        }



        if (!contactNumber.matches("\\d{9,10}")) {

            request.getSession().setAttribute(
                    "error",
                    "Please enter a valid contact number."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/updatePatients?patient_id="
                    + patientId
            );

            return;
        }



        if (!gender.equalsIgnoreCase("Male") &&
            !gender.equalsIgnoreCase("Female") &&
            !gender.equalsIgnoreCase("Other")) {

            request.getSession().setAttribute(
                    "error",
                    "Invalid gender selected."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/updatePatients?patient_id="
                    + patientId
            );

            return;
        }



        if (!status.equalsIgnoreCase("Active") &&
            !status.equalsIgnoreCase("Inactive")) {

            request.getSession().setAttribute(
                    "error",
                    "Invalid patient status."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/updatePatients?patient_id="
                    + patientId
            );

            return;
        }



        String sql =
                "UPDATE patients SET " +
                "patient_name = ?, " +
                "address = ?, " +
                "contact_number = ?, " +
                "gender = ?, " +
                "status = ? " +
                "WHERE patient_id = ?";


        try (
            Connection conn = DBConnect.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            stmt.setString(1, patientName);
            stmt.setString(2, address);
            stmt.setString(3, contactNumber);
            stmt.setString(4, gender);
            stmt.setString(5, status);
            stmt.setString(6, patientId);


            int rowsUpdated = stmt.executeUpdate();


            if (rowsUpdated > 0) {

                request.getSession().setAttribute(
                        "success",
                        "Patient " + patientId +
                        " was updated successfully."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/managePatients"
                );

            } else {

                request.getSession().setAttribute(
                        "error",
                        "No patient was found with ID " + patientId + "."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/managePatients"
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            request.getSession().setAttribute(
                    "error",
                    "Error updating patient: "
                    + e.getMessage()
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/updatePatients?patient_id="
                    + patientId
            );
        }
    }
}