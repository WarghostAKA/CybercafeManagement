package com.cybercafe.service;

import com.cybercafe.dao.ComputerDAO;
import com.cybercafe.model.Computer;
import java.sql.SQLException;

public class ComputerService {
	private final ComputerDAO computerDAO;
	
	public ComputerService() {
		this.computerDAO = new ComputerDAO();
	}
	
	public void addComputer(Computer computer) throws SQLException {
		computer.setOccupied(false); // New computers are always available
		computerDAO.addComputer(computer);
	}
}
