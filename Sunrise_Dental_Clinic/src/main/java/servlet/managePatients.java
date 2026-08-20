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

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("loggedInAdmin") == null) {

            response.sendRedirect(
                request.getContextPath() + "/adminlogin.jsp"
            );

            return;
        }

        patientService service = new patientService();

        String keyword = request.getParameter("keyword");

        ArrayList<patient> patientList;

        if (keyword != null && !keyword.trim().isEmpty()) {

            keyword = keyword.trim();

            patientList = service.searchPatients(keyword);

        } else {

            keyword = "";

            patientList = service.getAllPatients();

        }

        if (patientList == null) {

            patientList = new ArrayList<patient>();

        }

        request.setAttribute(
            "patientList",
            patientList
        );

        request.setAttribute(
            "keyword",
            keyword
        );

        request.setAttribute(
            "totalPatients",
            patientList.size()
        );

        RequestDispatcher dispatcher =
            request.getRequestDispatcher(
                "/managepatients.jsp"
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