package com.cybercafe.servlet.admin;

import com.cybercafe.model.DailyRevenue;
import com.cybercafe.model.RevenueStatistics;
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

@WebServlet("/admin/revenue")
public class RevenueServlet extends HttpServlet {
    private final RevenueService revenueService = new RevenueService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<DailyRevenue> revenues = getRevenueData(request);
            RevenueStatistics statistics = revenueService.calculateStatistics(revenues);
            
            request.setAttribute("revenues", revenues);
            request.setAttribute("statistics", statistics);
            request.getRequestDispatcher("/WEB-INF/views/admin/revenue.jsp")
                   .forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    private List<DailyRevenue> getRevenueData(HttpServletRequest request) throws SQLException {
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        
        if (startDateStr != null && endDateStr != null) {
            LocalDate startDate = LocalDate.parse(startDateStr);
            LocalDate endDate = LocalDate.parse(endDateStr);
            return revenueService.getRevenuesByDateRange(startDate, endDate);
        }
        
        return revenueService.getAllRevenues();
    }
}