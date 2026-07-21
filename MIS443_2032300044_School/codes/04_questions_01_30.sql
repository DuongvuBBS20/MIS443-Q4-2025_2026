-- MIS443 - Assignment 4: Individual PostgreSQL Database Project
-- Schema: School (SQL Practice Online)
-- File 04: SQL Questions 1-30

-- 1. Return the complete student roster from the students table.
SELECT * FROM students;
	
-- 2. Return students who are majoring in Computer Science.
SELECT first_name, last_name, graduation_year FROM students
WHERE major = 'Computer Science'
	
-- 3. Return all courses ordered by credit hours from highest to lowest.
SELECT course_name, credits FROM courses
ORDER BY credits DESC;
	
-- 4. Return students who are expected to graduate in 2026.
SELECT first_name, last_name, major FROM students
WHERE graduation_year = '2026';
	
-- 5. Count the total number of courses available. 
SELECT COUNT(course_id) AS total_courses FROM courses;

-- 6. Calculate the average number of credit hours across all courses.
SELECT ROUND(AVG(credits), 2) AS average_credits
FROM courses;


-- 7. Return students who enrolled after December 31, 2022.
SELECT *
FROM students
WHERE enrollment_date > '2022-12-31';


-- 8. Return professors who work in the Computer Science department.
SELECT first_name, last_name, hire_date
FROM professors
WHERE department = 'Computer Science';


-- 9. Return students whose email addresses contain the university.edu domain.
SELECT first_name, last_name, email, major
FROM students
WHERE email LIKE '%university.edu%'
ORDER BY last_name;


-- 10. Show each professor's name, department, and the courses they teach. Order by professor last name, then course name.
SELECT p.first_name, p.last_name, p.department, c.course_name
FROM professors p
JOIN courses c ON c.professor_id = p.professor_id
ORDER BY p.last_name, c.course_name;


-- 11. List each unique major (no duplicates), excluding students without a declared major. Order alphabetically.
SELECT DISTINCT major
FROM students
WHERE major IS NOT NULL
ORDER BY major;


-- 12. Find all students whose enrollment_date falls within 2022-2023 (inclusive). 
-- Show first name, last name, enrollment_date, and major. Order by enrollment_date, then last name.
SELECT first_name, last_name, enrollment_date, major
FROM students
WHERE enrollment_date BETWEEN '2022-01-01' AND '2023-12-31'
ORDER BY enrollment_date, last_name;


-- 13. Find all students whose major has not been declared (NULL). Show first name, last name, email.
SELECT first_name, last_name, email
FROM students
WHERE major IS NULL;

-- 14. Return student names together with their enrolled courses and grades.
SELECT s.first_name, s.last_name, c.course_name, e.grade
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id;

-- 15. Count the number of students enrolled in each course.
SELECT c.course_name, COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
LEFT JOIN enrollments e ON e.course_id = c.course_id
GROUP BY c.course_name
ORDER BY c.course_name;
-- 16. Return courses with more than one student enrolled.
SELECT c.course_name, COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
JOIN enrollments e ON e.course_id = c.course_id
GROUP BY c.course_name
HAVING COUNT(e.enrollment_id) > 1;
-- 17. Return pairs of students who share the same graduation year.
SELECT
    s1.first_name AS first_name1, s1.last_name AS last_name1,
    s2.first_name AS first_name2, s2.last_name AS last_name2,
    s1.graduation_year,
    s1.major AS major1,
    s2.major AS major2
FROM students s1
JOIN students s2
    ON s1.graduation_year = s2.graduation_year
   AND s1.student_id < s2.student_id
ORDER BY s1.graduation_year, s1.student_id;
-- 18. Return course count, total credits, and average credits per department.
SELECT
    department,
    COUNT(*) AS course_count,
    SUM(credits) AS total_credits,
    ROUND(AVG(credits), 2) AS avg_credits
FROM courses
GROUP BY department
ORDER BY course_count DESC, department;

-- 19. Find students who have not registered for any course. Show first name, last name, major.
SELECT s.first_name, s.last_name, s.major
FROM students s
LEFT JOIN enrollments e ON e.student_id = s.student_id
WHERE e.enrollment_id IS NULL;

-- 20. Count how many students enrolled each year (extracted from enrollment_date).
-- Show enrollment_year and student_count, ordered by year.
SELECT
    EXTRACT(YEAR FROM enrollment_date)::INT AS enrollment_year,
    COUNT(*) AS student_count
FROM students
GROUP BY EXTRACT(YEAR FROM enrollment_date)
ORDER BY enrollment_year;
	