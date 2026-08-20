package servlet;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.patient;
import services.patientService;

@WebServlet("/managePatients")
public class managePatients extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public managePatients() {
        super();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("loggedInAdmin") == null) {

            response.sendRedirect("adminlogin.jsp");
            return;
        }

        String keyword = request.getParameter("keyword");
        patientService service = new patientService();
        ArrayList<patient> patientList;


        if (keyword != null && !keyword.trim().isEmpty()) {
            patientList =
                    service.searchPatients(keyword.trim());
        } else {

            patientList =
                    service.getAllPatients();
        }

        if (patientList == null) {
            patientList = new ArrayList<patient>();
        }

        System.out.println(
                "======================================"
        );

        System.out.println(
                "Manage Patients Servlet"
        );

        System.out.println(
                "Patients loaded: "
                + patientList.size()
        );

        System.out.println(
                "======================================"
        );

        request.setAttribute(
                "patientList",
                patientList
        );

        request.setAttribute(
                "totalPatients",
                patientList.size()
        );

        RequestDispatcher dispatcher =
                request.getRequestDispatcher(
                        "managepatients.jsp"
                );

        dispatcher.forward(request, response);
    }


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}