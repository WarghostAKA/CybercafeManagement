package com.cybercafe.service;

import com.cybercafe.dao.UserDAO;
import com.cybercafe.model.User;
import java.sql.SQLException;
import java.time.LocalDateTime;

public class UserService {
	private final UserDAO userDAO;
	
	public UserService() {
		this.userDAO = new UserDAO();
	}
	
	public void addUser(User user) throws SQLException {
		user.setCreatedAt(LocalDateTime.now());
		user.setAdmin(false);
		userDAO.registerUser(user);
	}
}