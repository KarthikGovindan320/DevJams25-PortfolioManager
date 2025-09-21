CREATE DATABASE IF NOT EXISTS karthik_PortfolioManager;
USE karthik_PortfolioManager;

CREATE TABLE IF NOT EXISTS stocks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    date DATE NOT NULL,
    stock_name VARCHAR(100) NOT NULL,
    recommended_action ENUM('BUY', 'SELL', 'HOLD') NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    source VARCHAR(100) NOT NULL,
    predicted_target DECIMAL(10, 2) NOT NULL,
    ltp DECIMAL(10, 2) NOT NULL,
    upside DECIMAL(5, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
