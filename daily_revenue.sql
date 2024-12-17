-- Create table daily_revenue
CREATE TABLE IF NOT EXISTS daily_revenue (
    date DATE PRIMARY KEY,
    theoretical_revenue DECIMAL(10, 2) NOT NULL,
    actual_revenue DECIMAL(10, 2) NOT NULL
);

INSERT INTO daily_revenue (date, theoretical_revenue, actual_revenue) VALUES ('2023-01-01', 2560.28, 2350.95);
INSERT INTO daily_revenue (date, theoretical_revenue, actual_revenue) VALUES ('2023-01-02', 2414.2, 1997.03);
INSERT INTO daily_revenue (date, theoretical_revenue, actual_revenue) VALUES ('2023-01-03', 2456.54, 698.97);