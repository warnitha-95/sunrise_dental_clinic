package servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.patient;
import services.patientService;

@WebServlet("/checkPatient")
public class checkPatient extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private patientService patientService;

    @Override
    public void init() throws ServletException {
        patientService = new patientService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("loggedInAdmin") == null) {

            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);

            try (PrintWriter out = response.getWriter()) {
                out.write("{\"found\":false}");
            }

            return;
        }

        String contactNumber = request.getParameter("contactNumber");

        try (PrintWriter out = response.getWriter()) {

            if (contactNumber == null || contactNumber.trim().isEmpty()) {
                out.write("{\"found\":false}");
                return;
            }

            patient pat = patientService.getPatientByContactNumber(contactNumber.trim());

            if (pat == null) {

                out.write("{\"found\":false}");

            } else {

                StringBuilder json = new StringBuilder();

                json.append("{");
                json.append("\"found\":true,");
                json.append("\"patientId\":").append(pat.getPatient_id()).append(",");
                json.append("\"patientName\":\"").append(esc(pat.getPatient_name())).append("\",");
                json.append("\"address\":\"").append(esc(pat.getAddress())).append("\",");
                json.append("\"gender\":\"").append(esc(pat.getGender())).append("\",");
                json.append("\"status\":\"").append(esc(pat.getStatus())).append("\"");
                json.append("}");

                out.write(json.toString());
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.getWriter().write("{\"found\":false}");
        }
    }

    private String esc(String value) {

        if (value == null) {
            return "";
        }

        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", " ")
                .replace("\r", " ");
    }
}