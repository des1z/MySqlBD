#1. Реализовать практические задания на примере других таблиц и запросов.
#WINDOW1
USE employees;
SHOW tables;
LOCK TABLE salaries READ;
UNLOCK TABLES;

#WINDOW2
USE employees;
SELECT * FROM salaries;
SHOW COLUMNS FROM salaries;
INSERT INTO salaries VALUES(30001, 6000, NOW(), NOW()); #WAITING UNLOCK
SELECT * FROM salaries WHERE salaries.salary=6000;

#2. Подумать, какие операции являются транзакционными, и написать несколько примеров с транзакционными запросами.
# MANUAL TRANSANCTION
SET AUTOCOMMIT = OFF;
START TRANSACTION;
SELECT @new_emp_no:=MAX(emp_no)+1 FROM employees;
INSERT INTO `employees`.`employees`(`emp_no`,`birth_date`,`first_name`,`last_name`,`gender`,`hire_date`)
VALUES(@new_emp_no,'1990-01-01','Ivan','Ivanov','M',NOW());
INSERT INTO `employees`.`dept_emp`(`emp_no`,`dept_no`,`from_date`,`to_date`)
VALUES(@new_emp_no,'d005',NOW(),'9999-01-01');
COMMIT;
SET AUTOCOMMIT = ON;
SELECT * FROM dept_emp ORDER BY emp_no DESC LIMIT 5;

# TRANSANCTION IN STORE PROCEDURE
DROP procedure IF EXISTS `add_emp`;
DELIMITER $$
USE `employees`$$
CREATE DEFINER=`root`@`%` PROCEDURE `add_emp`
 (IN emp_no INT(11),
  IN birth_date DATE,
  IN first_name VARCHAR(14),
  IN last_name VARCHAR(16),
  IN gender VARCHAR(1),
  IN dept_no CHAR(4))
BEGIN
   DECLARE exit handler for sqlexception
      BEGIN
      ROLLBACK;
   END;
   START TRANSACTION;
   INSERT INTO `employees`.`employees`(`emp_no`,`birth_date`,`first_name`,`last_name`,`gender`,`hire_date`)
    VALUES(emp_no, birth_date, first_name, last_name, gender, NOW());
   INSERT INTO `employees`.`dept_emp`(`emp_no`,`dept_no`,`from_date`,`to_date`)
    VALUES(emp_no, dept_no, NOW(), '9999-01-01');
   COMMIT;
END$$
DELIMITER ;
CALL `employees`.`add_ivanov`(500007, '1991-02-02', 'Igor', 'Sidorov', 'M', 'd006');

#3. Проанализировать несколько запросов с помощью EXPLAIN.
EXPLAIN SELECT MAX(s.salary), CONCAT(e.first_name, ' ', e.last_name) FROM salaries s
 LEFT JOIN employees e ON s.emp_no = e.emp_no
 GROUP BY e.emp_no;
 
EXPLAIN SELECT d.dept_name AS 'Отдел', COUNT(e.emp_no) AS 'num_of_employees'
 FROM dept_emp e
 LEFT JOIN departments d ON d.dept_no = e.dept_no
 WHERE e.to_date = '9999-01-01'
 GROUP BY d.dept_name;