-- INT
-- DECIMAL(M, N)
-- VARCHAR(l)
-- BLOB
-- DATE
-- TIMESTAMP

CREATE TABLE `student` (
    `student_id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(30),
    `major` VARCHAR(20) DEFAULT 'undecided'
);
DROP TABLE `student`;
ALTER TABLE `student` ADD `gpa` DECIMAL(3, 2);
ALTER TABLE `student` DROP COLUMN `gpa`;

DESCRIBE `student`;
SELECT * FROM `student`;


INSERT INTO student (name, major) VALUES ('Mike', 'Comp. Science');
INSERT INTO student (student_id, name) VALUES (2, 'Nick');


UPDATE student
SET major = 'History'
WHERE student_id = 2;

UPDATE student
SET major = 'Comp Sci'
WHERE major = 'Comp. Science';

UPDATE student
SET major = 'Biochemistry'
WHERE major = 'Bio' OR major = 'Chemistry';

UPDATE student
SET name = 'Tom', major = 'undecided'
WHERE student_id = 1;

UPDATE student
SET major = 'undecided';


DELETE FROM student
WHERE name='Tom' AND major='undecided';

DELETE FROM student;


SELECT student.student_id, student.major
FROM student
ORDER BY student_id ASC;

SELECT *
FROM student
WHERE major = 'History' AND name <> 'Jack'
ORDER BY major, student_id DESC
LIMIT 2;

-- <, >, <=, >=, =, <>, AND, OR

SELECT *
FROM student
WHERE name IN ('Claire', 'Kate', 'Mike');


-- For company database

    -- Find all employees:
    SELECT *
    FROM employee;

    -- Find all employees ordered by salary:
    SELECT *
    FROM employee
    ORDER BY salary ASC;

    -- Find all employees ordered by sex, then name:
    SELECT *
    FROM employee
    ORDER BY sex, first_name, last_name ASC;

    -- Find first 5 employees
    SELECT *
    FROM employee
    LIMIT 5;

    -- Find the first and the last names of all employees:
    SELECT first_name, last_name
    FROM employee;

    -- Find the forename and surenames names of all employees:
    SELECT first_name AS forename, last_name AS surname
    FROM employee;

    -- Find out all the different supervisors:
    SELECT DISTINCT super_id
    FROM employee;

    -- Find the number of supervised employees:
    SELECT COUNT(super_id)  -- not sum
    FROM employee;

    -- Find the number of female employees born after 1970:
    SELECT COUNT(emd_id)
    FROM employee
    WHERE sex = 'F' AND birth_date >= '1971-01-01';

    -- Find the average of all male employee's salariers:
    SELECT AVG(salary)
    FROM employee
    WHERE sex = 'M';

    -- Find the total amount of money, that company pays to employees:
    SELECT SUM(salary)
    FROM employee;

    -- Find out how many males and females there are:
    SELECT COUNT(sex), sex
    FROM employee
    GROUP BY sex;

    -- Find the total sales of each salesman:
    SELECT SUM(total_sales), emp_id
    FROM works_with
    GROUP BY emd_id;

    -- Find the total amount of money each client has spent:
    SELECT SUM(total_sales), client_id
    FROM works_with
    GROUP BY client_id
    ORDER BY SUM(total_sales) DESC;

    -- % = any number characters, _ = one character

    -- Find all client's who are an LLC
    SELECT *
    FROM client
    WHERE client_name LIKE '%LLC';

    -- Find any branch suppliers who are in the label business
    SELECT *
    FROM branch_supplier
    WHERE supplier_name LIKE '%Label%';

    -- Find any employer who born in October
    SELECT *
    FROM employee
    WHERE birth_day LIKE '____-10-%'

    -- Find any clients who are schools
    SELECT *
    FROM clients
    WHERE client_name LIKE '%school%';

    -- Find a list of employee and branch names
    SELECT  first_name AS company_names
    FROM employee
    UNION
    SELECT branch_name
    FROM branch;

    -- Find a list of all clients & branch suppliers names
    SELECT client_name, client.branch_id
    FROM client
    UNION
    SELECT supplier_name, branch_supplier.branch_id
    FROM branch_supplier;

    -- Find a list of all money spent or earned by company
    SELECT SUM(salary)
    FROM employee
    UNION
    SELECT SUM(total_sales)
    FROM works_with;

    -- Find all branches and the names of their managers
    SELECT branch.branch_name, employee.emp_id AS mgr_id, employee.first_name AS mgr_name
    FROM branch
    JOIN employee
    ON employee.emp_id = branch.mgr_id;

    SELECT branch.branch_name, employee.emp_id AS mgr_id, employee.first_name AS mgr_name
    FROM branch
    LEFT JOIN employee
    ON employee.emp_id = branch.mgr_id;

    SELECT branch.branch_name, employee.emp_id AS mgr_id, employee.first_name AS mgr_name
    FROM branch
    RIGHT JOIN employee
    ON employee.emp_id = branch.mgr_id;

    -- Find names of all employees who have sold 
    -- over 30.000 to a single client
    SELECT employee.first_name, employee.last_name
    FROM employee
    WHERE employee.emp_id IN (
        SELECT works_with.emp_id
        FROM works_with
        WHERE works_with.total_sales > 30000
    );

    --* My solvation:
    SELECT employee.first_name, employee.last_name, works_with.total_sales, works_with.client_id
    FROM employee
    JOIN works_with
    ON employee.emp_id = works_with.emp_id
    WHERE works_with.total_sales > 30000;


    -- Find all clients who are handled by the branch
    -- that Michael Scott manages
    -- Assume you know Michael's ID
    SELECT client.client_name
    FROM client
    WHERE client.branch_id = (
        SELECT branch.branch_id
        FROM branch
        WHERE branch.mgr_id = 102
        LIMIT 1
    );

    -- ON DELETE:
    CREATE TABLE branch (
        branch_id INT PRIMARY KEY,
        branch_name VARCHAR(40),
        mgr_id INT,
        mgr_start_date DATE,
        FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
    );

    DELETE FROM employee
    WHERE emp_id = 102;

    SELECT * FROM branch;  -- mgr_id = NULL

    CREATE TABLE branch_supplier (
        branch_id INT,
        supplier_name VARCHAR(40),
        supply_type VARCHAR(40),
        PRIMARY KEY(branch_id, supplier_name),
        FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
    );

    DELETE FROM branch
    WHERE branch_id = 2;

    SELECT * FROM branch_supplier;  -- only rows with id = 3

    --Triggers:
    CREATE TABLE trigger_test (
        message VARCHAR(100)
    );

    DELIMITER $$
        CREATE TRIGGER my_trigger 
        BEFORE INSERT ON employee
        FOR EACH ROW BEGIN
            INSERT INTO trigger_test VALUES('added new employee');
        END$$
    DELIMITER ;

    INSERT INTO employee
    VALUES(109, 'Oscar', 'Nartinez', '1968-02-19', 'M', 69000, 106, 3);

    SELECT * FROM trigger_test;


    DELIMITER $$
        CREATE TRIGGER my_trigger_1 
        BEFORE INSERT ON employee
        FOR EACH ROW BEGIN
            INSERT INTO trigger_test VALUES(NEW.first_name);
        END$$
    DELIMITER ;

    INSERT INTO employee
    VALUES(110, 'Kelvin', 'Malone', '1995-02-19', 'M', 59000, 106, 3);

    SELECT * FROM trigger_test;


    DELIMITER $$
        CREATE TRIGGER my_trigger_2
        AFTER INSERT ON employee -- (update, delete)
        FOR EACH ROW BEGIN
            IF NEW.sex = 'M' THEN
                INSERT INTO trigger_test VALUES('added male employee');
            ELSEIF NEW.sex = 'F' THEN
                INSERT INTO trigger_test VALUES('added female employee');
            ELSE 
                INSERT INTO trigger_test VALUES('added custom employee');
            END IF;
        END$$
    DELIMITER ;

    INSERT INTO employee
    VALUES(111, 'Anna', 'Slavkina', '2003-03-27', 'F', 83000, 106, 3);

    DROP TRIGGER my_trigger;
