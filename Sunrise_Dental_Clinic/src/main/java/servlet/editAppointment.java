package servlet;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.appointment;
import services.appointmentService;

@WebServlet("/editAppointment")
public class editAppointment extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private appointmentService appointmentService;

    private static final List<String> VALID_STATUSES =
            List.of("Scheduled", "Completed", "Cancelled");

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

        String idValue = request.getParameter("id");

        int appointmentId;

        try {

            appointmentId = Integer.parseInt(idValue);

        } catch (Exception e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/manageAppointments"
            );

            return;
        }

        loadForm(request, response, appointmentId, null);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("loggedInAdmin") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/adminlogin.jsp"
            );

            return;
        }

        String idValue = request.getParameter("appointmentId");
        String patientIdValue = request.getParameter("patientId");

        String patientName = request.getParameter("patientName");
        String address = request.getParameter("address");
        String contactNumber = request.getParameter("contactNumber");
        String gender = request.getParameter("gender");

        String dentistIdValue = request.getParameter("dentistId");

        String appointmentDate = request.getParameter("appointmentDate");
        String appointmentTime = request.getParameter("appointmentTime");

        String status = request.getParameter("status");

        String[] treatmentValues = request.getParameterValues("treatmentIds");

        int appointmentId;

        try {

            appointmentId = Integer.parseInt(idValue);

        } catch (Exception e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/manageAppointments"
            );

            return;
        }

        try {

            if (patientName == null ||
                patientName.trim().isEmpty()) {

                throw new IllegalArgumentException(
                        "Patient name is required."
                );
            }

            if (address == null ||
                address.trim().isEmpty()) {

                throw new IllegalArgumentException(
                        "Address is required."
                );
            }

            if (contactNumber == null ||
                contactNumber.trim().isEmpty()) {

                throw new IllegalArgumentException(
                        "Contact number is required."
                );
            }

            if (gender == null ||
                gender.trim().isEmpty()) {

                throw new IllegalArgumentException(
                        "Please select gender."
                );
            }

            if (dentistIdValue == null ||
                dentistIdValue.trim().isEmpty()) {

                throw new IllegalArgumentException(
                        "Please select a dentist."
                );
            }

            if (status == null ||
                !VALID_STATUSES.contains(status)) {

                throw new IllegalArgumentException(
                        "Please select a valid status."
                );
            }

            if (treatmentValues == null ||
                treatmentValues.length < 1 ||
                treatmentValues.length > 3) {

                throw new IllegalArgumentException(
                        "Please select between 1 and 3 treatments."
                );
            }

            if (appointmentDate == null ||
                appointmentDate.trim().isEmpty() ||
                appointmentTime == null ||
                appointmentTime.trim().isEmpty()) {

                throw new IllegalArgumentException(
                        "Appointment date and time are required."
                );
            }

            int dentistId = Integer.parseInt(dentistIdValue);

            int patientId = Integer.parseInt(patientIdValue);

            List<Integer> treatmentIds = new ArrayList<>();

            for (String value : treatmentValues) {

                if (value == null || value.trim().isEmpty()) {
                    continue;
                }

                int treatmentId = Integer.parseInt(value);

                if (!treatmentIds.contains(treatmentId)) {
                    treatmentIds.add(treatmentId);
                }
            }

            if (treatmentIds.size() < 1 ||
                treatmentIds.size() > 3) {

                throw new IllegalArgumentException(
                        "Please select between 1 and 3 treatments."
                );
            }

            DateTimeFormatter formatter =
                    DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

            LocalDateTime dateTime =
                    LocalDateTime.parse(
                            appointmentDate + "T" + appointmentTime,
                            formatter
                    );

            appointment appt = new appointment();

            appt.setAppointmentId(appointmentId);
            appt.setPatientId(patientId);
            appt.setPatientName(patientName.trim());
            appt.setAddress(address.trim());
            appt.setContactNumber(contactNumber.trim());
            appt.setGender(gender.trim());
            appt.setDentistId(dentistId);
            appt.setAppointmentDatetime(Timestamp.valueOf(dateTime));
            appt.setStatus(status);
            appt.setTreatmentIds(treatmentIds);

            boolean updated = appointmentService.updateAppointment(appt);

            if (updated) {

                request.getSession().setAttribute(
                        "successMessage",
                        "Appointment updated successfully."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/manageAppointments"
                );

                return;
            }

            loadForm(
                    request,
                    response,
                    appointmentId,
                    "Unable to update appointment."
            );

        } catch (NumberFormatException e) {

            loadForm(
                    request,
                    response,
                    appointmentId,
                    "Invalid dentist or treatment selected."
            );

        } catch (IllegalArgumentException e) {

            loadForm(
                    request,
                    response,
                    appointmentId,
                    e.getMessage()
            );

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                    "Unable to update appointment.",
                    e
            );
        }
    }

    private void loadForm(
            HttpServletRequest request,
            HttpServletResponse response,
            int appointmentId,
            String errorMessage)
            throws ServletException, IOException {

        try {

            appointment appt =
                    appointmentService.getAppointmentById(appointmentId);

            if (appt == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/manageAppointments"
                );

                return;
            }

            List<?> dentists = appointmentService.getActiveDentists();
            List<?> treatments = appointmentService.getActiveTreatments();

            request.setAttribute("appointment", appt);
            request.setAttribute("dentists", dentists);
            request.setAttribute("treatments", treatments);
            request.setAttribute("errorMessage", errorMessage);

            request.getRequestDispatcher(
                    "/editappointments.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            throw new ServletException(
                    "Unable to load appointment for editing.",
                    e
            );
        }
    }
}