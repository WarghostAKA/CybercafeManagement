<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Usage Records - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .sidebar {
            min-height: 100vh;
            background-color: #343a40;
        }
        .sidebar .nav-link {
            color: #fff;
            padding: 1rem;
        }
        .sidebar .nav-link:hover {
            background-color: #495057;
        }
        .sidebar .nav-link.active {
            background-color: #0d6efd;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 px-0 sidebar">
                <div class="py-4 px-3 mb-4 text-white">
                    <h5>Admin Dashboard</h5>
                </div>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                            <i class="bi bi-people me-2"></i> User Management
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/computers">
                            <i class="bi bi-pc-display me-2"></i> Computer Management
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/sessions">
                            <i class="bi bi-clock-history me-2"></i> Usage Records
                        </a>
                    </li>
                    <li class="nav-item mt-4">
                        <a class="nav-link" href="#" onclick="confirmLogout(); return false;">
                            <i class="bi bi-box-arrow-right me-2"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Main Content -->
            <div class="col-md-10 p-4">
                <h2 class="mb-4">Usage Records</h2>

                <c:if test="${param.deleted}">
                    <div class="alert alert-success">Session record deleted successfully!</div>
                </c:if>

                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Computer</th>
                                <th>User</th>
                                <th>Start Time</th>
                                <th>End Time</th>
                                <th>Duration (Hours)</th>
                                <th>Total Cost</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${sessions}" var="session">
                                <tr>
                                    <td>Computer ${session.computerNumber}</td>
                                    <td>${session.username}</td>
                                    <td><fmt:formatDate value="${session.startTimeAsDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                                    <td>
                                        <c:if test="${session.endTimeAsDate != null}">
                                            <fmt:formatDate value="${session.endTimeAsDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                        </c:if>
                                    </td>
                                    <td>${session.duration}</td>
                                    <td>
                                        <c:if test="${session.totalCost > 0}">
                                            $${session.totalCost}
                                        </c:if>
                                    </td>
                                    <td>
                                        <span class="badge ${session.active ? 'bg-success' : 'bg-secondary'}">
                                            ${session.active ? 'Active' : 'Completed'}
                                        </span>
                                    </td>
                                    <td>
                                        <button class="btn btn-sm btn-danger" 
                                                onclick="confirmDelete('${session.id}')"
                                                ${session.active ? 'disabled' : ''}>
                                            <i class="bi bi-trash"></i> Delete
                                        </button>
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
        function confirmLogout() {
            if (confirm('Are you sure you want to logout?')) {
                window.location.href = '${pageContext.request.contextPath}/auth/logout';
            }
        }

        function confirmDelete(sessionId) {
            if (confirm('Are you sure you want to delete this session record?')) {
                const form = document.createElement('form');
                form.method = 'post';
                form.action = '${pageContext.request.contextPath}/admin/sessions';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                
                const sessionIdInput = document.createElement('input');
                sessionIdInput.type = 'hidden';
                sessionIdInput.name = 'sessionId';
                sessionIdInput.value = sessionId;
                
                form.appendChild(actionInput);
                form.appendChild(sessionIdInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>