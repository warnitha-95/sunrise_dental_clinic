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

@WebServlet("/newAppointment")
public class newAppointment extends HttpServlet {

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

        loadForm(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

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

        String patientName =
                request.getParameter("patientName");

        String address =
                request.getParameter("address");

        String contactNumber =
                request.getParameter("contactNumber");

        String dentistIdValue =
                request.getParameter("dentistId");

        String appointmentDate =
                request.getParameter("appointmentDate");

        String appointmentTime =
                request.getParameter("appointmentTime");

        String[] treatmentValues =
                request.getParameterValues("treatmentIds");

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

            if (dentistIdValue == null ||
                dentistIdValue.trim().isEmpty()) {

                throw new IllegalArgumentException(
                        "Please select a dentist."
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

            int dentistId =
                    Integer.parseInt(
                            dentistIdValue
                    );

            List<Integer> treatmentIds =
                    new ArrayList<>();

            for (String value : treatmentValues) {

                if (value == null ||
                    value.trim().isEmpty()) {

                    continue;
                }

                int treatmentId =
                        Integer.parseInt(value);

                if (!treatmentIds.contains(
                        treatmentId)) {

                    treatmentIds.add(
                            treatmentId
                    );
                }
            }

            if (treatmentIds.size() < 1 ||
                treatmentIds.size() > 3) {

                throw new IllegalArgumentException(
                        "Please select between 1 and 3 treatments."
                );
            }

            DateTimeFormatter formatter =
                    DateTimeFormatter.ofPattern(
                            "yyyy-MM-dd'T'HH:mm"
                    );

            LocalDateTime dateTime =
                    LocalDateTime.parse(
                            appointmentDate
                            + "T"
                            + appointmentTime,
                            formatter
                    );

            if (dateTime.isBefore(
                    LocalDateTime.now())) {

                throw new IllegalArgumentException(
                        "Appointment date and time cannot be in the past."
                );
            }

            appointment appt =
                    new appointment();

            appt.setPatientName(
                    patientName.trim()
            );

            appt.setAddress(
                    address.trim()
            );

            appt.setContactNumber(
                    contactNumber.trim()
            );

            appt.setDentistId(
                    dentistId
            );

            appt.setAppointmentDatetime(
                    Timestamp.valueOf(dateTime)
            );

            appt.setTreatmentIds(
                    treatmentIds
            );

            boolean created =
                    appointmentService
                    .createAppointment(appt);

            if (created) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/appointments.jsp"
                );

                return;
            }

            request.setAttribute(
                    "errorMessage",
                    "Unable to create appointment."
            );

            loadForm(request, response);

        } catch (NumberFormatException e) {

            request.setAttribute(
                    "errorMessage",
                    "Invalid dentist or treatment selected."
            );

            loadForm(request, response);

        } catch (IllegalArgumentException e) {

            request.setAttribute(
                    "errorMessage",
                    e.getMessage()
            );

            loadForm(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                    "Unable to create appointment.",
                    e
            );
        }
    }

    private void loadForm(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            List<?> dentists =
                    appointmentService
                    .getActiveDentists();

            List<?> treatments =
                    appointmentService
                    .getActiveTreatments();

            System.out.println(
                    "Dentists returned: "
                    + dentists.size()
            );

            System.out.println(
                    "Treatments returned: "
                    + treatments.size()
            );

            request.setAttribute(
                    "dentists",
                    dentists
            );

            request.setAttribute(
                    "treatments",
                    treatments
            );

            request.getRequestDispatcher(
                    "/newappointments.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            throw new ServletException(
                    "Unable to load appointment form.",
                    e
            );
        }
    }
}