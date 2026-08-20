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
import javax.servlet.http.HttpSession;
import controller.DBConnect;

@WebServlet("/updatePatients")
public class updatePatients extends HttpServlet {
    private static final long serialVersionUID = 1L;
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInAdmin") == null) {
            response.sendRedirect(request.getContextPath() + "/adminlogin.jsp");
            return;
        }
        String patientId = request.getParameter("patient_id");
        if (patientId == null || patientId.trim().isEmpty()) {
            session.setAttribute("error", "Patient ID is required.");
            response.sendRedirect(request.getContextPath() + "/managePatients");
            return;
        }
        patientId = patientId.trim();
        if (!patientId.matches("\\d+")) {
            session.setAttribute("error", "Invalid patient ID.");
            response.sendRedirect(request.getContextPath() + "/managePatients");
            return;
        }
        String sql = "SELECT patient_id, patient_name, address, contact_number, gender, registered_datetime, status FROM patients WHERE patient_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, Integer.parseInt(patientId));
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    request.setAttribute("patient_id", rs.getInt("patient_id"));
                    request.setAttribute("patient_name", rs.getString("patient_name"));
                    request.setAttribute("address", rs.getString("address"));
                    request.setAttribute("contact_number", rs.getString("contact_number"));
                    request.setAttribute("gender", rs.getString("gender"));
                    request.setAttribute("registered_datetime", rs.getTimestamp("registered_datetime"));
                    request.setAttribute("status", rs.getString("status"));
                    request.getRequestDispatcher("updatepatients.jsp").forward(request, response);
                } else {
                    session.setAttribute("error", "Patient ID " + patientId + " was not found.");
                    response.sendRedirect(request.getContextPath() + "/managePatients");
                }
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid patient ID.");
            response.sendRedirect(request.getContextPath() + "/managePatients");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Unable to load patient details.");
            response.sendRedirect(request.getContextPath() + "/managePatients");
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInAdmin") == null) {
            response.sendRedirect(request.getContextPath() + "/adminlogin.jsp");
            return;
        }
        String patientId = request.getParameter("patient_id");
        String patientName = request.getParameter("patient_name");
        String address = request.getParameter("address");
        String contactNumber = request.getParameter("contact_number");
        String gender = request.getParameter("gender");
        String status = request.getParameter("status");
        if (patientId != null) patientId = patientId.trim();
        if (patientName != null) patientName = patientName.trim();
        if (address != null) address = address.trim();
        if (contactNumber != null) contactNumber = contactNumber.trim();
        if (gender != null) gender = gender.trim();
        if (status != null) status = status.trim();
        if (patientId == null || patientId.isEmpty()) {
            session.setAttribute("error", "Patient ID is required.");
            response.sendRedirect(request.getContextPath() + "/managePatients");
            return;
        }
        if (!patientId.matches("\\d+")) {
            session.setAttribute("error", "Invalid patient ID.");
            response.sendRedirect(request.getContextPath() + "/managePatients");
            return;
        }
        if (patientName == null || patientName.isEmpty()) {
            session.setAttribute("error", "Please enter the patient name.");
            response.sendRedirect(request.getContextPath() + "/updatePatients?patient_id=" + patientId);
            return;
        }
        if (patientName.length() > 100) {
            session.setAttribute("error", "Patient name cannot exceed 100 characters.");
            response.sendRedirect(request.getContextPath() + "/updatePatients?patient_id=" + patientId);
            return;
        }
        if (address == null || address.isEmpty()) {
            session.setAttribute("error", "Please enter the patient address.");
            response.sendRedirect(request.getContextPath() + "/updatePatients?patient_id=" + patientId);
            return;
        }
        if (address.length() > 255) {
            session.setAttribute("error", "Address cannot exceed 255 characters.");
            response.sendRedirect(request.getContextPath() + "/updatePatients?patient_id=" + patientId);
            return;
        }
        if (contactNumber == null || contactNumber.isEmpty()) {
            session.setAttribute("error", "Please enter the contact number.");
            response.sendRedirect(request.getContextPath() + "/updatePatients?patient_id=" + patientId);
            return;
        }
        if (!contactNumber.matches("0[0-9]{9}")) {
            session.setAttribute("error", "Please enter a valid 10-digit contact number.");
            response.sendRedirect(request.getContextPath() + "/updatePatients?patient_id=" + patientId);
            return;
        }
        if (gender == null || gender.isEmpty()) {
            session.setAttribute("error", "Please select the patient's gender.");
            response.sendRedirect(request.getContextPath() + "/updatePatients?patient_id=" + patientId);
            return;
        }
        if (!gender.equalsIgnoreCase("Male") && !gender.equalsIgnoreCase("Female") && !gender.equalsIgnoreCase("Other")) {
            session.setAttribute("error", "Invalid gender selected.");
            response.sendRedirect(request.getContextPath() + "/updatePatients?patient_id=" + patientId);
            return;
        }
        if (status == null || status.isEmpty()) {
            status = "Active";
        }
        if (!status.equalsIgnoreCase("Active") && !status.equalsIgnoreCase("Inactive")) {
            session.setAttribute("error", "Invalid patient status.");
            response.sendRedirect(request.getContextPath() + "/updatePatients?patient_id=" + patientId);
            return;
        }
        String sql = "UPDATE patients SET patient_name = ?, address = ?, contact_number = ?, gender = ?, status = ? WHERE patient_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, patientName);
            stmt.setString(2, address);
            stmt.setString(3, contactNumber);
            stmt.setString(4, gender);
            stmt.setString(5, status);
            stmt.setInt(6, Integer.parseInt(patientId));
            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                session.setAttribute("success", "Patient ID " + patientId + " was updated successfully.");
                response.sendRedirect(request.getContextPath() + "/managePatients");
            } else {
                session.setAttribute("error", "No patient was found with ID " + patientId + ".");
                response.sendRedirect(request.getContextPath() + "/managePatients");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid patient ID.");
            response.sendRedirect(request.getContextPath() + "/managePatients");
        } catch (Exception e) {
            e.printStackTrace();
            String errorMessage = e.getMessage();
            if (errorMessage == null || errorMessage.trim().isEmpty()) {
                errorMessage = "Unable to update patient.";
            }
            session.setAttribute("error", "Error updating patient: " + errorMessage);
            response.sendRedirect(request.getContextPath() + "/updatePatients?patient_id=" + patientId);
        }
    }
}