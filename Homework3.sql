#1. ������� ������, � ������� �� ������� ��� ������ � ������ � ������, ������.
SELECT * FROM _cities LEFT JOIN (_regions, _countries) ON (_regions.id = _cities.region_id AND _countries.id = _cities.country_id) LIMIT 100;

#2. ������� ��� ������ �� ���������� �������.
SELECT * FROM _cities LEFT JOIN (_regions, _countries) ON (_regions.id = _cities.region_id AND _countries.id = _cities.country_id) WHERE _regions.title = '���������� �������' LIMIT 100;

#���� ������ �����������:
#1. ������� ������� �������� �� �������.
SELECT AVG(s.salary) avg_salary, d.dept_name 
FROM dept_emp de 
LEFT JOIN departments d ON de.dept_no = d.dept_no 
LEFT JOIN salaries s ON de.emp_no = s.emp_no
GROUP BY d.dept_name
ORDER BY avg_salary;

#2. ������� ������������ �������� � ����������.
SELECT CONCAT (e.first_name,',',last_name) AS full_name, MAX(salary) max_salary
FROM salaries s
LEFT JOIN employees e
ON s.emp_no = e.emp_no
GROUP BY full_name;

#3. ������� ������ ����������, � �������� ������������ ��������.
DELETE FROM employees WHERE emp_no IN (SELECT MAX(salary) FROM salaries);


#4. ��������� ���������� ����������� �� ���� �������.
SELECT COUNT(emp_no) AS emp_cnt, d.dept_name
FROM dept_emp
LEFT JOIN departments d
ON dept_emp.dept_no = d.dept_no
WHERE dept_emp.to_date > now()
GROUP BY dept_emp.dept_no
ORDER BY emp_cnt;

# 5. ����� ���������� ����������� � ������� � ����������, ������� ����� ����� �������� �����.
SELECT COUNT(dept_emp.emp_no) AS emp_cnt, SUM(s.salary) AS total_salary, d.dept_name
FROM dept_emp
LEFT JOIN salaries s
ON dept_emp.emp_no = s.emp_no
LEFT JOIN departments d
ON dept_emp.dept_no = d.dept_no
WHERE dept_emp.to_date > now()
AND s.to_date > now()
GROUP BY d.dept_name
ORDER BY emp_cnt;