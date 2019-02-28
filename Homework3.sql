#1. Сделать запрос, в котором мы выберем все данные о городе – регион, страна.
SELECT * FROM _cities LEFT JOIN (_regions, _countries) ON (_regions.id = _cities.region_id AND _countries.id = _cities.country_id) LIMIT 100;

#2. Выбрать все города из Московской области.
SELECT * FROM _cities LEFT JOIN (_regions, _countries) ON (_regions.id = _cities.region_id AND _countries.id = _cities.country_id) WHERE _regions.title = 'Московская область' LIMIT 100;

#База данных «Сотрудники»:
#1. Выбрать среднюю зарплату по отделам.
SELECT AVG(s.salary) avg_salary, d.dept_name 
FROM dept_emp de 
LEFT JOIN departments d ON de.dept_no = d.dept_no 
LEFT JOIN salaries s ON de.emp_no = s.emp_no
GROUP BY d.dept_name
ORDER BY avg_salary;

#2. Выбрать максимальную зарплату у сотрудника.
SELECT CONCAT (e.first_name,',',last_name) AS full_name, MAX(salary) max_salary
FROM salaries s
LEFT JOIN employees e
ON s.emp_no = e.emp_no
GROUP BY full_name;

#3. Удалить одного сотрудника, у которого максимальная зарплата.
DELETE FROM employees WHERE emp_no IN (SELECT MAX(salary) FROM salaries);


#4. Посчитать количество сотрудников во всех отделах.
SELECT COUNT(emp_no) AS emp_cnt, d.dept_name
FROM dept_emp
LEFT JOIN departments d
ON dept_emp.dept_no = d.dept_no
WHERE dept_emp.to_date > now()
GROUP BY dept_emp.dept_no
ORDER BY emp_cnt;

# 5. Найти количество сотрудников в отделах и посмотреть, сколько всего денег получает отдел.
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