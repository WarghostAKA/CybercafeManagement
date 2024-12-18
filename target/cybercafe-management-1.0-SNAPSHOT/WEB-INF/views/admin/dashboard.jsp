<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - Cybercafe Management System</title>
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
                <h2>Welcome, Administrator</h2>
                <p>Please select a management option from the sidebar.</p>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>