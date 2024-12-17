<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Sidebar -->
<div class="col-md-2 px-0 sidebar">
    <div class="py-4 px-3 mb-4 text-white">
        <h5>Admin Dashboard</h5>
    </div>
    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.servletPath.endsWith('/users.jsp') ? 'active' : ''}" 
               href="${pageContext.request.contextPath}/admin/users">
                <i class="bi bi-people me-2"></i> User Management
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.servletPath.endsWith('/computers.jsp') ? 'active' : ''}" 
               href="${pageContext.request.contextPath}/admin/computers">
                <i class="bi bi-pc-display me-2"></i> Computer Management
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.servletPath.endsWith('/sessions.jsp') ? 'active' : ''}" 
               href="${pageContext.request.contextPath}/admin/sessions">
                <i class="bi bi-clock-history me-2"></i> Usage Records
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.servletPath.endsWith('/revenue.jsp') ? 'active' : ''}" 
               href="${pageContext.request.contextPath}/admin/revenue">
                <i class="bi bi-graph-up me-2"></i> Revenue Analysis
            </a>
        </li>
        <li class="nav-item mt-4">
            <a class="nav-link" href="#" onclick="confirmLogout(); return false;">
                <i class="bi bi-box-arrow-right me-2"></i> Logout
            </a>
        </li>
    </ul>
</div>

<script>
    function confirmLogout() {
        if (confirm('Are you sure you want to logout?')) {
            window.location.href = '${pageContext.request.contextPath}/auth/logout';
        }
    }
</script>