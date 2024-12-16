<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Management - Admin Dashboard</title>
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/users">
                            <i class="bi bi-people me-2"></i> User Management
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/computers">
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
                <h2 class="mb-4">User Management</h2>

                <!-- Search Section -->
                <div class="search-section">
                    <form id="searchForm" class="row g-3">
                        <div class="col-md-3">
                            <label for="searchId" class="form-label">User ID</label>
                            <input type="text" class="form-control" id="searchId" placeholder="Search by ID">
                        </div>
                        <div class="col-md-3">
                            <label for="searchUsername" class="form-label">Username</label>
                            <input type="text" class="form-control" id="searchUsername" placeholder="Search by username">
                        </div>
                        <div class="col-md-3">
                            <label for="searchEmail" class="form-label">Email</label>
                            <input type="text" class="form-control" id="searchEmail" placeholder="Search by email">
                        </div>
                        <div class="col-md-3">
                            <label for="searchPhone" class="form-label">Phone</label>
                            <input type="text" class="form-control" id="searchPhone" placeholder="Search by phone">
                        </div>
                        <div class="col-md-3">
                            <label for="searchGender" class="form-label">Gender</label>
                            <select class="form-select" id="searchGender">
                                <option value="">All</option>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <button type="button" class="btn btn-primary" onclick="searchUsers()">
                                <i class="bi bi-search"></i> Search
                            </button>
                            <button type="button" class="btn btn-secondary" onclick="resetSearch()">
                                <i class="bi bi-x-circle"></i> Reset
                            </button>
                        </div>
                    </form>
                </div>

                <c:if test="${param.deleted}">
                    <div class="alert alert-success">User deleted successfully!</div>
                </c:if>
                <c:if test="${param.updated}">
                    <div class="alert alert-success">User updated successfully!</div>
                </c:if>

                <div class="table-responsive">
                    <table class="table table-striped" id="usersTable">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Username</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Gender</th>
                                <th>Created At</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${users}" var="user">
                                <tr>
                                    <td>${user.id}</td>
                                    <td>${user.username}</td>
                                    <td>${user.email}</td>
                                    <td>${user.phone}</td>
                                    <td>${user.gender}</td>
                                    <td>${user.createdAt}</td>
                                    <td>
                                        <button class="btn btn-sm btn-primary" 
                                                onclick="showEditModal('${user.id}', '${user.username}', '${user.email}', '${user.phone}', '${user.gender}')">
                                            <i class="bi bi-pencil"></i> Edit
                                        </button>
                                        <button class="btn btn-sm btn-danger" onclick="confirmDelete('${user.id}')">
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

    <!-- Edit User Modal -->
    <div class="modal fade" id="editUserModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="editUserForm" action="${pageContext.request.contextPath}/admin/users" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="userId" id="editUserId">
                        
                        <div class="mb-3">
                            <label for="editUsername" class="form-label">Username</label>
                            <input type="text" class="form-control" id="editUsername" name="username" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="editEmail" class="form-label">Email</label>
                            <input type="email" class="form-control" id="editEmail" name="email" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="editPhone" class="form-label">Phone</label>
                            <input type="text" class="form-control" id="editPhone" name="phone" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="editGender" class="form-label">Gender</label>
                            <select class="form-select" id="editGender" name="gender" required>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
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

        function showEditModal(userId, username, email, phone, gender) {
            document.getElementById('editUserId').value = userId;
            document.getElementById('editUsername').value = username;
            document.getElementById('editEmail').value = email;
            document.getElementById('editPhone').value = phone;
            document.getElementById('editGender').value = gender;
            new bootstrap.Modal(document.getElementById('editUserModal')).show();
        }

        function confirmDelete(userId) {
            if (confirm('Are you sure you want to delete this user?')) {
                const form = document.createElement('form');
                form.method = 'post';
                form.action = '${pageContext.request.contextPath}/admin/users';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                
                const userIdInput = document.createElement('input');
                userIdInput.type = 'hidden';
                userIdInput.name = 'userId';
                userIdInput.value = userId;
                
                form.appendChild(actionInput);
                form.appendChild(userIdInput);
                document.body.appendChild(form);
                form.submit();
            }
        }

        function searchUsers() {
            const searchId = document.getElementById('searchId').value.toLowerCase();
            const searchUsername = document.getElementById('searchUsername').value.toLowerCase();
            const searchEmail = document.getElementById('searchEmail').value.toLowerCase();
            const searchPhone = document.getElementById('searchPhone').value.toLowerCase();
            const searchGender = document.getElementById('searchGender').value;
            
            const table = document.getElementById('usersTable');
            const rows = table.getElementsByTagName('tr');
            
            for (let i = 1; i < rows.length; i++) {
                const row = rows[i];
                const cells = row.getElementsByTagName('td');
                
                const id = cells[0].textContent.toLowerCase();
                const username = cells[1].textContent.toLowerCase();
                const email = cells[2].textContent.toLowerCase();
                const phone = cells[3].textContent.toLowerCase();
                const gender = cells[4].textContent;
                
                const matchId = !searchId || id.includes(searchId);
                const matchUsername = !searchUsername || username.includes(searchUsername);
                const matchEmail = !searchEmail || email.includes(searchEmail);
                const matchPhone = !searchPhone || phone.includes(searchPhone);
                const matchGender = !searchGender || gender === searchGender;
                
                row.style.display = 
                    matchId && matchUsername && matchEmail && matchPhone && matchGender
                    ? '' 
                    : 'none';
            }
        }

        function resetSearch() {
            document.getElementById('searchForm').reset();
            const table = document.getElementById('usersTable');
            const rows = table.getElementsByTagName('tr');
            for (let i = 1; i < rows.length; i++) {
                rows[i].style.display = '';
            }
        }
    </script>
</body>
</html>