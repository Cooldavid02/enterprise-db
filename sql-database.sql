-- =============================================
-- ENTERPRISE MANAGEMENT DATABASE 
-- 5 Core Tables for Medium Business
-- MySQL Compatible
-- =============================================

CREATE DATABASE IF NOT EXISTS enterprise_management;
USE enterprise_management;

-- =============================================
-- TABLE 1: Companies - Core company information
-- =============================================
CREATE TABLE companies (
    company_id INT PRIMARY KEY AUTO_INCREMENT,
    company_name VARCHAR(255) NOT NULL,
    tax_id VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(255),
    address TEXT,
    founded_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- TABLE 2: Departments - Organizational structure
-- =============================================
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    department_name VARCHAR(100) NOT NULL,
    manager_name VARCHAR(100),
    budget DECIMAL(15,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(company_id) ON DELETE CASCADE
);

-- =============================================
-- TABLE 3: Employees - Staff management
-- =============================================
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    department_id INT NOT NULL,
    employee_code VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    position_title VARCHAR(100),
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2),
    status ENUM('Active', 'On Leave', 'Terminated') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE CASCADE
);

-- =============================================
-- TABLE 4: Customers - Client management
-- =============================================
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    customer_name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(20),
    address TEXT,
    customer_type ENUM('Individual', 'Business') DEFAULT 'Business',
    status ENUM('Active', 'Inactive') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(company_id) ON DELETE CASCADE
);

-- =============================================
-- TABLE 5: Projects - Project tracking
-- =============================================
CREATE TABLE projects (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    customer_id INT NOT NULL,
    project_name VARCHAR(255) NOT NULL,
    description TEXT,
    project_manager_id INT NOT NULL,
    start_date DATE,
    end_date DATE,
    budget DECIMAL(15,2),
    status ENUM('Planning', 'In Progress', 'Completed', 'Cancelled') DEFAULT 'Planning',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(company_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (project_manager_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

-- =============================================
-- SAMPLE DATA INSERTION
-- =============================================

-- Insert sample company
INSERT INTO companies (company_name, tax_id, phone, email, address) 
VALUES ('Tech Solutions Inc', 'TAX-123456', '+1-555-0123', 'info@techsolutions.com', '123 Business Ave, City, State 12345');

-- Insert sample departments
INSERT INTO departments (company_id, department_name, manager_name, budget) VALUES
(1, 'Executive', 'John CEO', 500000.00),
(1, 'Sales', 'Sarah Sales', 200000.00),
(1, 'IT', 'Mike Tech', 300000.00),
(1, 'HR', 'Lisa HR', 150000.00);

-- Insert sample employees
INSERT INTO employees (department_id, employee_code, first_name, last_name, email, phone, position_title, hire_date, salary) VALUES
(1, 'EMP001', 'John', 'Smith', 'john.smith@techsolutions.com', '+1-555-0001', 'CEO', '2020-01-15', 120000.00),
(2, 'EMP002', 'Sarah', 'Johnson', 'sarah.johnson@techsolutions.com', '+1-555-0002', 'Sales Manager', '2020-03-20', 80000.00),
(3, 'EMP003', 'Mike', 'Brown', 'mike.brown@techsolutions.com', '+1-555-0003', 'IT Manager', '2020-02-10', 90000.00),
(4, 'EMP004', 'Lisa', 'Davis', 'lisa.davis@techsolutions.com', '+1-555-0004', 'HR Manager', '2020-04-05', 75000.00),
(2, 'EMP005', 'David', 'Wilson', 'david.wilson@techsolutions.com', '+1-555-0005', 'Sales Executive', '2021-06-15', 60000.00);

-- Insert sample customers
INSERT INTO customers (company_id, customer_name, email, phone, address, customer_type) VALUES
(1, 'Global Corp Inc', 'purchasing@globalcorp.com', '+1-555-1001', '456 Corporate Blvd, City, State 12345', 'Business'),
(1, 'Small Business LLC', 'owner@smallbiz.com', '+1-555-1002', '789 Main St, City, State 12345', 'Business'),
(1, 'Jane Doe', 'jane.doe@email.com', '+1-555-1003', '321 Personal Lane, City, State 12345', 'Individual');

-- Insert sample projects
INSERT INTO projects (company_id, customer_id, project_name, description, project_manager_id, start_date, end_date, budget, status) VALUES
(1, 1, 'Website Redesign', 'Complete website redesign and development', 3, '2024-01-15', '2024-06-15', 50000.00, 'In Progress'),
(1, 2, 'CRM Implementation', 'Implement customer relationship management system', 3, '2024-02-01', '2024-05-01', 25000.00, 'Planning'),
(1, 3, 'Personal Portfolio', 'Develop personal portfolio website', 5, '2024-01-20', '2024-03-20', 5000.00, 'Completed');

-- =============================================
-- USEFUL VIEWS FOR REPORTING
-- =============================================

-- Employee Directory View
CREATE VIEW employee_directory AS
SELECT 
    e.employee_id,
    e.employee_code,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    e.email,
    e.phone,
    e.position_title,
    d.department_name,
    e.hire_date,
    e.salary,
    e.status
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

-- Project Overview View
CREATE VIEW project_overview AS
SELECT 
    p.project_id,
    p.project_name,
    c.customer_name,
    CONCAT(e.first_name, ' ', e.last_name) AS project_manager,
    p.start_date,
    p.end_date,
    p.budget,
    p.status
FROM projects p
JOIN customers c ON p.customer_id = c.customer_id
JOIN employees e ON p.project_manager_id = e.employee_id;

-- Department Summary View
CREATE VIEW department_summary AS
SELECT 
    d.department_id,
    d.department_name,
    d.manager_name,
    d.budget,
    COUNT(e.employee_id) AS employee_count,
    AVG(e.salary) AS avg_salary
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id AND e.status = 'Active'
GROUP BY d.department_id, d.department_name, d.manager_name, d.budget;

-- =============================================
-- INDEXES FOR PERFORMANCE
-- =============================================

CREATE INDEX idx_employees_department ON employees(department_id);
CREATE INDEX idx_employees_status ON employees(status);
CREATE INDEX idx_projects_status ON projects(status);
CREATE INDEX idx_projects_dates ON projects(start_date, end_date);
CREATE INDEX idx_customers_type ON customers(customer_type);

-- =============================================
-- USEFUL QUERIES
-- =============================================

-- Get all active employees with department info
SELECT * FROM employee_directory WHERE status = 'Active';

-- Get projects in progress
SELECT * FROM project_overview WHERE status = 'In Progress';

-- Get department budget vs actual salary cost
SELECT 
    d.department_name,
    d.budget AS department_budget,
    SUM(e.salary) AS total_salary_cost,
    (d.budget - SUM(e.salary)) AS budget_remaining
FROM departments d
JOIN employees e ON d.department_id = e.department_id AND e.status = 'Active'
GROUP BY d.department_id, d.department_name, d.budget;

-- Get customer project count
SELECT 
    c.customer_name,
    COUNT(p.project_id) AS project_count,
    SUM(p.budget) AS total_project_value
FROM customers c
LEFT JOIN projects p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.customer_name;