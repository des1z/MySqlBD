#1. Создать VIEW на основе запросов, которые вы сделали в ДЗ к уроку 3.
CREATE VIEW salary_avg AS 
 SELECT AVG(s.salary) , dep.dept_name FROM dept_emp emp
 INNER JOIN salaries s ON emp.emp_no = s.emp_no
 INNER JOIN departments dep ON dep.dept_no = emp.dept_no
 GROUP BY dep.dept_name;

SELECT * FROM salary_avg;
 
#2. Создать функцию, которая найдет менеджера по имени и фамилии.
DELIMITER //
CREATE FUNCTION find_manager_id(first_name VARCHAR(50), last_name VARCHAR(50)) RETURNS INT DETERMINISTIC
 BEGIN
 DECLARE manager_id INT;
 SET manager_id = (SELECT dept_manager.emp_no FROM dept_manager 
 INNER JOIN departments ON dept_manager.dept_no = departments.dept_no
 INNER JOIN employees ON dept_manager.emp_no = employees.emp_no
 WHERE dept_manager.to_date = '9999-01-01'
 AND employees.first_name = first_name
 AND employees.last_name = last_name);
 RETURN manager_id;
 END //
 DELIMITER ; 
 
SELECT find_manager_id(first_name, last_name) AS 'ID' FROM employees WHERE first_name = 'Hilary' AND last_name = 'Kambil';
 
#3. Создать триггер, который при добавлении нового сотрудника будет выплачивать ему вступительный бонус, занося запись об этом в таблицу salary.
DELIMITER //
CREATE TRIGGER bonus AFTER INSERT ON employees
 FOR EACH ROW
 BEGIN
  INSERT INTO salaries
  VALUES(NEW.emp_no, 5000, NOW(), NOW());
 END //
DELIMITER ;

INSERT INTO employees (emp_no, birth_date, first_name, last_name, gender, hire_date) VALUES ('9999','1999-01-01', 'Nikolai', 'Petrov', 'M', curdate());
SELECT * from salaries WHERE salary = 5000;