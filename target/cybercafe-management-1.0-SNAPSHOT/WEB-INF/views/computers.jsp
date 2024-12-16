<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Computers - Cybercafe Management System</title>
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/computers">Computers</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/sessions/history">Session History</a>
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
        <h1 class="mb-4">Available Computers</h1>
        
        <div class="row">
            <c:forEach items="${computers}" var="computer">
                <div class="col-md-4 mb-4">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Computer ${computer.computerNumber}</h5>
                            <p class="card-text">
                                Status: ${computer.occupied ? 'In Use' : 'Available'}<br>
                                Hourly Rate: $${computer.hourlyRate}
                            </p>
                            
                            <form action="${pageContext.request.contextPath}/sessions" method="post">
                                <input type="hidden" name="computerId" value="${computer.id}">
                                <c:choose>
                                    <c:when test="${computer.occupied}">
                                        <input type="hidden" name="action" value="end">
                                        <button type="submit" class="btn btn-danger" onclick="return confirmEndSession();">End Session</button>
                                    </c:when>
                                    <c:otherwise>
                                        <input type="hidden" name="action" value="start">
                                        <button type="submit" class="btn btn-success">Start Session</button>
                                    </c:otherwise>
                                </c:choose>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmLogout() {
            if (confirm('Are you sure you want to logout?')) {
                window.location.href = '${pageContext.request.contextPath}/auth/logout';
            }
        }

        function confirmEndSession() {
            return confirm('Are you sure you want to end this session? The total cost will be calculated.');
        }
    </script>
</body>
</html>