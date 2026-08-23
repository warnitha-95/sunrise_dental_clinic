package servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.appointment;
import model.treatment;
import services.appointmentService;

@WebServlet("/generateBill")
public class generateBill extends HttpServlet {

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

        try {

            appointment appt =
                    appointmentService.getAppointmentSummary(appointmentId);

            if (appt == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/manageAppointments"
                );

                return;
            }

            List<treatment> treatmentList =
                    appointmentService.getTreatmentsForAppointment(appointmentId);

            BigDecimal treatmentTotal =
                    appointmentService.calculateTreatmentTotal(treatmentList);

            BigDecimal consultationFee =
                    appointmentService.CONSULTATION_FEE;

            BigDecimal grandTotal =
                    treatmentTotal.add(consultationFee);

            request.setAttribute("appointment", appt);
            request.setAttribute("treatmentList", treatmentList);
            request.setAttribute("treatmentTotal", treatmentTotal);
            request.setAttribute("consultationFee", consultationFee);
            request.setAttribute("grandTotal", grandTotal);

            request.getRequestDispatcher(
                    "/bill.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                    "Unable to generate bill.",
                    e
            );
        }
    }
}