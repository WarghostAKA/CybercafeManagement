package com.cybercafe.servlet;

import com.cybercafe.dao.UserDAO;
import com.cybercafe.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/auth/*")
public class AuthServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if ("/logout".equals(pathInfo)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        } else if ("/profile".equals(pathInfo)) {
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if ("/login".equals(pathInfo)) {
                handleLogin(request, response);
            } else if ("/register".equals(pathInfo)) {
                handleRegister(request, response);
            } else if ("/update-password".equals(pathInfo)) {
                handlePasswordUpdate(request, response);
            } else if ("/update-profile".equals(pathInfo)) {
                handleProfileUpdate(request, response);
            }
        } catch (Exception e) {
            throw new ServletException("Authentication error", e);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        boolean isAdminLogin = "on".equals(request.getParameter("isAdmin"));
        
        User user = userDAO.login(username, password);
        if (user != null) {
            // Check if trying to login as admin
            if (isAdminLogin) {
                if (user.isAdmin()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else {
                    request.setAttribute("error", "Invalid administrator credentials");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                }
            } else {
                if (!user.isAdmin()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);
                    response.sendRedirect(request.getContextPath() + "/computers");
                } else {
                    request.setAttribute("error", "Please use administrator login option");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                }
            }
        } else {
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        User user = new User();
        user.setUsername(request.getParameter("username"));
        user.setPassword(request.getParameter("password"));
        user.setEmail(request.getParameter("email"));
        user.setAdmin(false); // Regular users can only register as non-admin
        
        userDAO.registerUser(user);
        response.sendRedirect(request.getContextPath() + "/login.jsp?registered=true");
    }

    private void handlePasswordUpdate(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        String newPassword = request.getParameter("newPassword");
        
        userDAO.updatePassword(user.getId(), newPassword);
        session.invalidate();
        response.sendRedirect(request.getContextPath() + "/login.jsp?passwordChanged=true");
    }

    private void handleProfileUpdate(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        user.setEmail(request.getParameter("email"));
        
        userDAO.updateProfile(user);
        session.setAttribute("user", user);
        response.sendRedirect(request.getContextPath() + "/auth/profile?updated=true");
    }
}