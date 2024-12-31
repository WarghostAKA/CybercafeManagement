package com.cybercafe.servlet;

import com.cybercafe.dao.ComputerDAO;
import com.cybercafe.dao.SessionDAO;
import com.cybercafe.model.Session;
import com.cybercafe.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;

@WebServlet("/sessions/*")
public class SessionServlet extends HttpServlet {
    private SessionDAO sessionDAO = new SessionDAO();
    private ComputerDAO computerDAO = new ComputerDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
       throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if ("/history".equals(pathInfo)) {
            showSessionHistory(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
       throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if ("start".equals(action)) {
                handleStartSession(request, response);
            } else if ("end".equals(action)) {
                handleEndSession(request, response);
            } else if ("pay".equals(action)) {
                handlePaySession(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
    
    private void handleStartSession(HttpServletRequest request, HttpServletResponse response)
       throws SQLException, IOException {
        int computerId = Integer.parseInt(request.getParameter("computerId"));
        HttpSession httpSession = request.getSession();
        User user = (User) httpSession.getAttribute("user");
        
        sessionDAO.startSession(computerId, user.getId());
        computerDAO.updateComputerStatus(computerId, true);
        response.sendRedirect(request.getContextPath() + "/computers");
    }
    
    private void handleEndSession(HttpServletRequest request, HttpServletResponse response)
       throws SQLException, IOException {
        int computerId = Integer.parseInt(request.getParameter("computerId"));
        Session session = sessionDAO.getActiveSession(computerId);
        if (session != null) {
            double totalCost = calculateCost(session.getStartTime());
            sessionDAO.endSession(session.getId(), totalCost);
            computerDAO.updateComputerStatus(computerId, false);
        }
        response.sendRedirect(request.getContextPath() + "/computers");
    }
    
    private void handlePaySession(HttpServletRequest request, HttpServletResponse response)
       throws SQLException, IOException {
        int sessionId = Integer.parseInt(request.getParameter("sessionId"));
        sessionDAO.paySession(sessionId);
        response.sendRedirect(request.getContextPath() + "/sessions/history?paid=true");
    }
    
    private void showSessionHistory(HttpServletRequest request, HttpServletResponse response)
       throws ServletException, IOException {
        try {
            User user = (User) request.getSession().getAttribute("user");
            List<Session> sessions = sessionDAO.getUserSessions(user.getId());
            request.setAttribute("sessions", sessions);
            request.getRequestDispatcher("/WEB-INF/views/session-history.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
    
    private double calculateCost(LocalDateTime startTime) {
        long minutes = ChronoUnit.MINUTES.between(startTime, LocalDateTime.now());
        double hours = Math.ceil(minutes / 60.0);
        return hours * 10.0;
    }
}