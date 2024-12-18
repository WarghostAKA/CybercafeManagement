package com.cybercafe.servlet;

import com.cybercafe.dao.ComputerDAO;
import com.cybercafe.dao.SessionDAO;
import com.cybercafe.dao.UserDAO;
import com.cybercafe.dao.RevenueDAO;
import com.cybercafe.model.Computer;
import com.cybercafe.model.Session;
import com.cybercafe.model.User;
import com.cybercafe.model.DailyRevenue;
import com.cybercafe.service.RevenueService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private ComputerDAO computerDAO = new ComputerDAO();
    private SessionDAO sessionDAO = new SessionDAO();
    private RevenueService revenueService = new RevenueService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                showDashboard(request, response);
            } else if (pathInfo.equals("/users")) {
                showUsers(request, response);
            } else if (pathInfo.equals("/computers")) {
                showComputers(request, response);
            } else if (pathInfo.equals("/sessions")) {
                showSessions(request, response);
            } else if (pathInfo.equals("/revenue")) {
                showRevenue(request, response);
            } else if (pathInfo.equals("/dashboard")) {
                showDashboard(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }

    private void showUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);
    }

    private void showComputers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        List<Computer> computers = computerDAO.getAllComputers();
        request.setAttribute("computers", computers);
        request.getRequestDispatcher("/WEB-INF/views/admin/computers.jsp").forward(request, response);
    }

    private void showSessions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        List<Session> sessions = sessionDAO.getAllSessions();
        request.setAttribute("sessions", sessions);
        request.getRequestDispatcher("/WEB-INF/views/admin/sessions.jsp").forward(request, response);
    }

    private void showRevenue(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        
        List<DailyRevenue> revenues;
        if (startDateStr != null && endDateStr != null) {
            LocalDate startDate = LocalDate.parse(startDateStr);
            LocalDate endDate = LocalDate.parse(endDateStr);
            revenues = revenueService.getRevenuesByDateRange(startDate, endDate);
        } else {
            revenues = revenueService.getAllRevenues();
        }
        
        request.setAttribute("revenues", revenues);
        request.setAttribute("statistics", revenueService.calculateStatistics(revenues));
        request.getRequestDispatcher("/WEB-INF/views/admin/revenue.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        String action = request.getParameter("action");

        try {
            if ("/users".equals(pathInfo)) {
                handleUserAction(request, response, action);
            } else if ("/computers".equals(pathInfo)) {
                handleComputerAction(request, response, action);
            } else if ("/sessions".equals(pathInfo)) {
                handleSessionAction(request, response, action);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    private void handleUserAction(HttpServletRequest request, HttpServletResponse response, String action)
            throws SQLException, IOException {
        if ("delete".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            userDAO.deleteUser(userId);
            response.sendRedirect(request.getContextPath() + "/admin/users?deleted=true");
        } else if ("update".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String email = request.getParameter("email");
            userDAO.updateUserEmail(userId, email);
            response.sendRedirect(request.getContextPath() + "/admin/users?updated=true");
        }
    }

    private void handleComputerAction(HttpServletRequest request, HttpServletResponse response, String action)
            throws SQLException, IOException {
        if ("delete".equals(action)) {
            int computerId = Integer.parseInt(request.getParameter("computerId"));
            computerDAO.deleteComputer(computerId);
            response.sendRedirect(request.getContextPath() + "/admin/computers?deleted=true");
        } else if ("update".equals(action)) {
            int computerId = Integer.parseInt(request.getParameter("computerId"));
            String computerNumber = request.getParameter("computerNumber");
            double hourlyRate = Double.parseDouble(request.getParameter("hourlyRate"));
            computerDAO.updateComputer(computerId, computerNumber, hourlyRate);
            response.sendRedirect(request.getContextPath() + "/admin/computers?updated=true");
        }
    }

    private void handleSessionAction(HttpServletRequest request, HttpServletResponse response, String action)
            throws SQLException, IOException {
        if ("delete".equals(action)) {
            int sessionId = Integer.parseInt(request.getParameter("sessionId"));
            sessionDAO.deleteSession(sessionId);
            response.sendRedirect(request.getContextPath() + "/admin/sessions?deleted=true");
        }
    }
}