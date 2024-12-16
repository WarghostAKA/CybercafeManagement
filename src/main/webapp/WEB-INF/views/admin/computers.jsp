<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Computer Management - Admin Dashboard</title>
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
        .search-section {
            background-color: #f8f9fa;
            padding: 1.5rem;
            border-radius: 8px;
            margin: 2rem 0;
        }
        .modal-dialog {
            display: flex;
            align-items: center;
            min-height: calc(100% - 1rem);
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/computers">
                            <i class="bi bi-pc-display me-2"></i> Computer Management
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/sessions">
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
                <h2 class="mb-4">Computer Management</h2>

                <!-- Search Section -->
                <div class="search-section">
                    <form id="searchForm" class="row g-3">
                        <div class="col-md-3">
                            <label for="searchComputerNumber" class="form-label">Computer Number</label>
                            <input type="text" class="form-control" id="searchComputerNumber" placeholder="Search by number">
                        </div>
                        <div class="col-md-3">
                            <label for="searchStatus" class="form-label">Status</label>
                            <select class="form-select" id="searchStatus">
                                <option value="">All</option>
                                <option value="true">In Use</option>
                                <option value="false">Available</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="searchRate" class="form-label">Hourly Rate</label>
                            <input type="number" class="form-control" id="searchRate" placeholder="Search by rate">
                        </div>
                        <div class="col-12">
                            <button type="button" class="btn btn-primary" onclick="searchComputers()">
                                <i class="bi bi-search"></i> Search
                            </button>
                            <button type="button" class="btn btn-secondary" onclick="resetSearch()">
                                <i class="bi bi-x-circle"></i> Reset
                            </button>
                        </div>
                    </form>
                </div>

                <c:if test="${param.deleted}">
                    <div class="alert alert-success">Computer deleted successfully!</div>
                </c:if>
                <c:if test="${param.updated}">
                    <div class="alert alert-success">Computer updated successfully!</div>
                </c:if>

                <div class="table-responsive">
                    <table class="table table-striped" id="computersTable">
                        <thead>
                            <tr>
                                <th>Computer Number</th>
                                <th>Status</th>
                                <th>Hourly Rate</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${computers}" var="computer">
                                <tr>
                                    <td>${computer.computerNumber}</td>
                                    <td>
                                        <span class="badge ${computer.occupied ? 'bg-danger' : 'bg-success'}">
                                            ${computer.occupied ? 'In Use' : 'Available'}
                                        </span>
                                    </td>
                                    <td>$${computer.hourlyRate}</td>
                                    <td>
                                        <button class="btn btn-sm btn-primary" 
                                                onclick="showEditModal('${computer.id}', '${computer.computerNumber}', '${computer.hourlyRate}')">
                                            <i class="bi bi-pencil"></i> Edit
                                        </button>
                                        <button class="btn btn-sm btn-danger" 
                                                onclick="confirmDelete('${computer.id}')"
                                                ${computer.occupied ? 'disabled' : ''}>
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

    <!-- Edit Computer Modal -->
    <div class="modal fade" id="editComputerModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Computer</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="editComputerForm" action="${pageContext.request.contextPath}/admin/computers" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="computerId" id="editComputerId">
                        <div class="mb-3">
                            <label for="editComputerNumber" class="form-label">Computer Number</label>
                            <input type="text" class="form-control" id="editComputerNumber" name="computerNumber" required>
                        </div>
                        <div class="mb-3">
                            <label for="editHourlyRate" class="form-label">Hourly Rate ($)</label>
                            <input type="number" step="0.01" class="form-control" id="editHourlyRate" name="hourlyRate" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                    </div>
                </form>
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

        function showEditModal(computerId, computerNumber, hourlyRate) {
            document.getElementById('editComputerId').value = computerId;
            document.getElementById('editComputerNumber').value = computerNumber;
            document.getElementById('editHourlyRate').value = hourlyRate;
            new bootstrap.Modal(document.getElementById('editComputerModal')).show();
        }

        function confirmDelete(computerId) {
            if (confirm('Are you sure you want to delete this computer?')) {
                const form = document.createElement('form');
                form.method = 'post';
                form.action = '${pageContext.request.contextPath}/admin/computers';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                
                const computerIdInput = document.createElement('input');
                computerIdInput.type = 'hidden';
                computerIdInput.name = 'computerId';
                computerIdInput.value = computerId;
                
                form.appendChild(actionInput);
                form.appendChild(computerIdInput);
                document.body.appendChild(form);
                form.submit();
            }
        }

        function searchComputers() {
            const searchNumber = document.getElementById('searchComputerNumber').value.toLowerCase();
            const searchStatus = document.getElementById('searchStatus').value;
            const searchRate = document.getElementById('searchRate').value;
            
            const table = document.getElementById('computersTable');
            const rows = table.getElementsByTagName('tr');
            
            for (let i = 1; i < rows.length; i++) {
                const row = rows[i];
                const cells = row.getElementsByTagName('td');
                
                const number = cells[0].textContent.toLowerCase();
                const status = cells[1].textContent.includes('In Use').toString();
                const rate = cells[2].textContent.replace('$', '');
                
                const matchNumber = !searchNumber || number.includes(searchNumber);
                const matchStatus = !searchStatus || status === searchStatus;
                const matchRate = !searchRate || parseFloat(rate) === parseFloat(searchRate);
                
                row.style.display = 
                    matchNumber && matchStatus && matchRate
                    ? '' 
                    : 'none';
            }
        }

        function resetSearch() {
            document.getElementById('searchForm').reset();
            const table = document.getElementById('computersTable');
            const rows = table.getElementsByTagName('tr');
            for (let i = 1; i < rows.length; i++) {
                rows[i].style.display = '';
            }
        }
    </script>
</body>
</html>