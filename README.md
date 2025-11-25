# 🏢 Enterprise Management System

![Database Schema](https://i.postimg.cc/R00FM6Fh/sql-database.jpg)

A simplified relational database system for medium-scale enterprises with 5 core tables covering essential business operations.

## 📊 Database Overview

**Simple • Efficient • MySQL Compatible**

## 🗂️ Database Schema

### Core Tables
1. **`companies`** - Company master data
2. **`departments`** - Organizational structure  
3. **`employees`** - Staff management
4. **`customers`** - Client information
5. **`projects`** - Work tracking

### Relationships
```
COMPANIES (1) ←→ (Many) DEPARTMENTS (1) ←→ (Many) EMPLOYEES
    ↓
CUSTOMERS (1) ←→ (Many) PROJECTS
    ↓
EMPLOYEES (Project Managers)
```

## 🚀 Quick Start

### Prerequisites
- MySQL 5.7+ or MariaDB
- PHP 7.0+ (for application integration)

### Installation

1. **Create the database:**
```sql
mysql -u root -p < database.sql
```

2. **Or run manually:**
```sql
CREATE DATABASE enterprise_management;
USE enterprise_management;
-- Copy and execute the SQL from database.sql
```

3. **Verify installation:**
```sql
SHOW TABLES;
SELECT * FROM employee_directory;
```

## 📋 Sample Data Included

The database comes pre-loaded with:
- ✅ 1 Sample company
- ✅ 4 Departments (Executive, Sales, IT, HR)
- ✅ 5 Employees with roles
- ✅ 3 Customers
- ✅ 3 Active projects

## 🔍 Key Features

### 📈 Reporting Views
- **`employee_directory`** - Complete staff listing
- **`project_overview`** - Project status dashboard  
- **`department_summary`** - Budget and staffing overview

### ⚡ Performance Optimized
- Foreign key constraints
- Strategic indexes
- Efficient data types

## 💡 Usage Examples

### Get Active Employees
```sql
SELECT * FROM employee_directory WHERE status = 'Active';
```

### Project Status Report
```sql
SELECT * FROM project_overview WHERE status = 'In Progress';
```

### Department Budget Analysis
```sql
SELECT * FROM department_summary;
```

## 🛠️ Integration

### PHP Connection
```php
<?php
$servername = "localhost";
$username = "your_username";
$password = "your_password";
$dbname = "enterprise_management";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$result = $conn->query("SELECT * FROM employee_directory");
while($row = $result->fetch_assoc()) {
    echo $row['full_name'] . " - " . $row['position_title'];
}
?>
```

## 📊 Sample Queries

### Employee Count by Department
```sql
SELECT d.department_name, COUNT(e.employee_id) as employee_count
FROM departments d 
LEFT JOIN employees e ON d.department_id = e.department_id 
GROUP BY d.department_name;
```

### Active Projects with Managers
```sql
SELECT p.project_name, c.customer_name, e.first_name, e.last_name
FROM projects p
JOIN customers c ON p.customer_id = c.customer_id
JOIN employees e ON p.project_manager_id = e.employee_id
WHERE p.status = 'In Progress';
```

## 🔧 Maintenance

### Backup Database
```bash
mysqldump -u username -p enterprise_management > backup.sql
```

### Restore Database
```bash
mysql -u username -p enterprise_management < backup.sql
```

## 📈 Business Benefits

- **Centralized Data** - Single source of truth
- **Relationship Tracking** - Clear organizational structure
- **Reporting Ready** - Built-in views for analytics
- **Scalable Design** - Easy to extend with new features

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/improvement`)
3. Commit your changes (`git commit -m 'Add some improvement'`)
4. Push to the branch (`git push origin feature/improvement`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

For issues and questions:
1. Check the sample queries above
2. Review MySQL documentation
3. Open an issue in the repository

---

<div align="center">

**Built for MySQL • Ready for Production**

</div>
