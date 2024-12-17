<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Revenue Analysis - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <%@ include file="../common/admin-styles.jsp" %>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <%@ include file="../common/admin-sidebar.jsp" %>

            <!-- Main Content -->
            <div class="col-md-10 p-4">
                <h2 class="mb-4">Revenue Analysis</h2>

                <!-- Search Section -->
                <div class="search-section">
                    <form id="searchForm" class="row g-3" action="${pageContext.request.contextPath}/admin/revenue" method="get">
                        <div class="col-md-4">
                            <label for="startDate" class="form-label">Start Date</label>
                            <input type="date" class="form-control" id="startDate" name="startDate" value="${param.startDate}">
                        </div>
                        <div class="col-md-4">
                            <label for="endDate" class="form-label">End Date</label>
                            <input type="date" class="form-control" id="endDate" name="endDate" value="${param.endDate}">
                        </div>
                        <div class="col-12">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-search"></i> Search
                            </button>
                            <button type="button" class="btn btn-secondary" onclick="resetSearch()">
                                <i class="bi bi-x-circle"></i> Reset
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Revenue Statistics -->
                <div class="revenue-stats">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="stat-card">
                                <h6 class="text-muted">Total Theoretical Revenue</h6>
                                <h4>$<fmt:formatNumber value="${statistics.totalTheoretical}" pattern="#,##0.00"/></h4>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="stat-card">
                                <h6 class="text-muted">Total Actual Revenue</h6>
                                <h4>$<fmt:formatNumber value="${statistics.totalActual}" pattern="#,##0.00"/></h4>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="stat-card">
                                <h6 class="text-muted">Average Daily Revenue</h6>
                                <h4>$<fmt:formatNumber value="${statistics.averageDaily}" pattern="#,##0.00"/></h4>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="stat-card">
                                <h6 class="text-muted">Total Records</h6>
                                <h4>${statistics.totalRecords}</h4>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Revenue Table -->
                <div class="table-responsive">
                    <table class="table table-striped" id="revenueTable">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Theoretical Revenue</th>
                                <th>Actual Revenue</th>
                                <th>Difference</th>
                                <th>Achievement Rate</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${revenues}" var="revenue">
                                <tr>
                                    <td>${revenue.date}</td>
                                    <td>$<fmt:formatNumber value="${revenue.theoreticalRevenue}" pattern="#,##0.00"/></td>
                                    <td>$<fmt:formatNumber value="${revenue.actualRevenue}" pattern="#,##0.00"/></td>
                                    <td class="${revenue.revenueDifference >= 0 ? 'text-success' : 'text-danger'}">
                                        $<fmt:formatNumber value="${revenue.revenueDifference}" pattern="#,##0.00"/>
                                    </td>
                                    <td>
                                        <div class="progress" style="height: 20px;">
                                            <div class="progress-bar ${revenue.revenuePercentage >= 100 ? 'bg-success' : revenue.revenuePercentage >= 80 ? 'bg-warning' : 'bg-danger'}" 
                                                 role="progressbar" 
                                                 style="width: ${revenue.revenuePercentage}%"
                                                 aria-valuenow="${revenue.revenuePercentage}" 
                                                 aria-valuemin="0" 
                                                 aria-valuemax="100">
                                                <fmt:formatNumber value="${revenue.revenuePercentage}" pattern="#,##0.0"/>%
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function resetSearch() {
            window.location.href = '${pageContext.request.contextPath}/admin/revenue';
        }

        // Set max date to today
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('startDate').max = today;
        document.getElementById('endDate').max = today;

        // Ensure end date is not before start date
        document.getElementById('startDate').addEventListener('change', function() {
            document.getElementById('endDate').min = this.value;
        });

        document.getElementById('endDate').addEventListener('change', function() {
            document.getElementById('startDate').max = this.value;
        });
    </script>
</body>
</html>