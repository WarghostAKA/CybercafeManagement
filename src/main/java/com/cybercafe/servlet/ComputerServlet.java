package com.cybercafe.servlet;

import com.cybercafe.dao.ComputerDAO;
import com.cybercafe.model.Computer;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/computers")
public class ComputerServlet extends HttpServlet {
    private ComputerDAO computerDAO = new ComputerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Computer> computers = computerDAO.getAllComputers();
            request.setAttribute("computers", computers);
            request.getRequestDispatcher("/WEB-INF/views/computers.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}