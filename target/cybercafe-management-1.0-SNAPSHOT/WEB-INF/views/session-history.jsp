<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Session History - Cybercafe Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/computers">Cybercafe System</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/computers">Computers</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/sessions/history">Session History</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/auth/profile">
                            <i class="bi bi-person"></i> ${user.username}'s Profile
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#" onclick="confirmLogout(); return false;">
                            <i class="bi bi-box-arrow-right"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-5">
        <h2 class="mb-4">Session History</h2>
        
        <div class="table-responsive">
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Computer</th>
                        <th>Start Time</th>
                        <th>End Time</th>
                        <th>Duration (Hours)</th>
                        <th>Total Cost</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${sessions}" var="session">
                        <tr>
                            <td>Computer ${session.computerNumber}</td>
                            <td><fmt:formatDate value="${session.startTimeAsDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                            <td>
                                <c:if test="${session.endTimeAsDate != null}">
                                    <fmt:formatDate value="${session.endTimeAsDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                </c:if>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${session.active}">
                                        Ongoing
                                    </c:when>
                                    <c:otherwise>
                                        ${session.duration}
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:if test="${session.totalCost > 0}">
                                    $${session.totalCost}
                                </c:if>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${session.active}">
                                        <span class="badge bg-success">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">Completed</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmLogout() {
            if (confirm('Are you sure you want to logout?')) {
                window.location.href = '${pageContext.request.contextPath}/auth/logout';
            }
        }
    </script>
</body>
</html>