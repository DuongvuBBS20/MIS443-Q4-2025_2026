-- MIS443 - Assignment 4: Individual PostgreSQL Database Project
-- Schema: School (SQL Practice Online)
-- File 04: SQL Questions 1-30

-- 1. Return the complete student roster from the students table.
SELECT * FROM students;
	
-- 2. Return students who are majoring in Computer Science.
SELECT first_name, last_name, graduation_year FROM students
WHERE major = 'Computer Science';


-- 3. Return all courses ordered by credit hours from highest to lowest.
SELECT course_name, credits FROM courses
ORDER BY credits DESC;
	
-- 4. Return students who are expected to graduate in 2026.
SELECT first_name, last_name, major FROM students
WHERE graduation_year = 2026;
	
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

-- 21. The honors committee wants to highlight each student's best academic achievement. For each student who 
-- has at least one enrollment, show their name, best grade letter, and the corresponding grade points. Order 
-- by grade points descending, then last name. Grade scale: A=4.0, A-=3.7, B+=3.3, B=3.0.
-- Note: the best letter cannot be found with MAX(grade) because alphabetical order puts 'B' before 'B+',
-- while B+ is worth more points. The grade must be converted to points first, then ranked.
WITH graded AS (
    SELECT s.student_id,
           s.first_name,
           s.last_name,
           e.grade,
           CASE e.grade
               WHEN 'A'  THEN 4.0
               WHEN 'A-' THEN 3.7
               WHEN 'B+' THEN 3.3
               WHEN 'B'  THEN 3.0
           END AS grade_points
    FROM students s
    JOIN enrollments e ON e.student_id = s.student_id
),
ranked AS (
    SELECT graded.*,
           ROW_NUMBER() OVER (PARTITION BY student_id ORDER BY grade_points DESC) AS rn
    FROM graded
)
SELECT first_name, last_name, grade AS best_grade, grade_points
FROM ranked
WHERE rn = 1
ORDER BY grade_points DESC, last_name;

-- 22. Academic advisors want to see which students are carrying the heaviest course loads. Show each 
-- student's total enrolled credits along with their name and major. Order by total credits from highest to 
-- lowest.
SELECT s.first_name,
       s.last_name,
       s.major,
       SUM(c.credits) AS total_credits
FROM students s
JOIN enrollments e ON e.student_id = s.student_id
JOIN courses c ON c.course_id = e.course_id
GROUP BY s.student_id, s.first_name, s.last_name, s.major
ORDER BY total_credits DESC, s.last_name;

-- 23. The academic records office needs a combined enrollment list covering the 2022 and 2023 academic years 
-- for a period review report. Show student first name, last name, course name, and year for all enrollments 
-- in year 2022 and year 2023 combined. Order by year, then last name.
SELECT s.first_name, s.last_name, c.course_name, e.year
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c  ON c.course_id  = e.course_id
WHERE e.year = 2022
UNION ALL
SELECT s.first_name, s.last_name, c.course_name, e.year
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c  ON c.course_id  = e.course_id
WHERE e.year = 2023
ORDER BY year, last_name;

-- 24. Student services needs a complete enrollment status report for all students. For every student in the 
-- system, show their name and whether they are 'Enrolled' (has at least one course) or 'Not Enrolled' (no 
-- courses registered yet). Order by last name.
SELECT s.first_name,
       s.last_name,
       CASE WHEN COUNT(e.enrollment_id) > 0 THEN 'Enrolled' ELSE 'Not Enrolled' END AS enrollment_status
FROM students s
LEFT JOIN enrollments e ON e.student_id = s.student_id
GROUP BY s.student_id, s.first_name, s.last_name
ORDER BY s.last_name;

-- 25. Calculate each student's GPA by converting letter grades to numeric points and averaging them, along 
-- with the number of courses taken.
SELECT s.first_name,
       s.last_name,
       ROUND(AVG(CASE e.grade
                     WHEN 'A'  THEN 4.0
                     WHEN 'A-' THEN 3.7
                     WHEN 'B+' THEN 3.3
                     WHEN 'B'  THEN 3.0
                 END), 2) AS gpa,
       COUNT(e.enrollment_id) AS courses_taken
FROM students s
JOIN enrollments e ON e.student_id = s.student_id
GROUP BY s.student_id, s.first_name, s.last_name
ORDER BY gpa DESC, s.last_name;

-- 26. The honors office wants to rank all students by their GPA to identify top performers. Calculate each 
-- student's GPA and rank them from highest to lowest. Show first name, last name, rounded GPA (2 decimals), 
-- and their rank. Grade scale: A=4.0, A-=3.7, B+=3.3, B=3.0.
WITH student_gpa AS (
    SELECT s.student_id,
           s.first_name,
           s.last_name,
           AVG(CASE e.grade
                   WHEN 'A'  THEN 4.0
                   WHEN 'A-' THEN 3.7
                   WHEN 'B+' THEN 3.3
                   WHEN 'B'  THEN 3.0
               END) AS gpa
    FROM students s
    JOIN enrollments e ON e.student_id = s.student_id
    GROUP BY s.student_id, s.first_name, s.last_name
)
SELECT first_name,
       last_name,
       ROUND(gpa, 2) AS gpa,
       RANK() OVER (ORDER BY gpa DESC) AS gpa_rank
FROM student_gpa
ORDER BY gpa_rank, last_name;

-- 27. The academic support team wants to identify students who are underperforming relative to their 
-- classmates in the same course. Find all enrollments where the student's grade points are strictly below the 
-- average grade points for that course. Show student name, course name, and grade.
WITH graded AS (
    SELECT e.course_id,
           s.first_name,
           s.last_name,
           c.course_name,
           e.grade,
           CASE e.grade
               WHEN 'A'  THEN 4.0
               WHEN 'A-' THEN 3.7
               WHEN 'B+' THEN 3.3
               WHEN 'B'  THEN 3.0
           END AS grade_points
    FROM enrollments e
    JOIN students s ON s.student_id = e.student_id
    JOIN courses c  ON c.course_id  = e.course_id
)
SELECT g.first_name, g.last_name, g.course_name, g.grade
FROM graded g
WHERE g.grade_points < (SELECT AVG(g2.grade_points)
                        FROM graded g2
                        WHERE g2.course_id = g.course_id)
ORDER BY g.course_name, g.last_name;

-- 28. The university wants to recognize the professor with the broadest student reach. Find the professor 
-- who has taught the most distinct students across all their courses. Show first name, last name, department, 
-- and student_count.
SELECT p.first_name,
       p.last_name,
       p.department,
       COUNT(DISTINCT e.student_id) AS student_count
FROM professors p
JOIN courses c     ON c.professor_id = p.professor_id
JOIN enrollments e ON e.course_id    = c.course_id
GROUP BY p.professor_id, p.first_name, p.last_name, p.department
ORDER BY student_count DESC
LIMIT 1;

-- 29. The academic board needs a high-level summary of student performance across the cohort. Classify each 
-- enrolled student's GPA into bands — Distinction (GPA ≥ 3.7), Merit (GPA ≥ 3.0), Pass (below 3.0) — then 
-- show how many students are in each band and their average GPA. Grade scale: A=4.0, A-=3.7, B+=3.3, B=3.0.
WITH student_gpa AS (
    SELECT s.student_id,
           AVG(CASE e.grade
                   WHEN 'A'  THEN 4.0
                   WHEN 'A-' THEN 3.7
                   WHEN 'B+' THEN 3.3
                   WHEN 'B'  THEN 3.0
               END) AS gpa
    FROM students s
    JOIN enrollments e ON e.student_id = s.student_id
    GROUP BY s.student_id
),
banded AS (
    SELECT student_id,
           gpa,
           CASE
               WHEN gpa >= 3.7 THEN 'Distinction'
               WHEN gpa >= 3.0 THEN 'Merit'
               ELSE 'Pass'
           END AS gpa_band
    FROM student_gpa
)
SELECT gpa_band,
       COUNT(*) AS student_count,
       ROUND(AVG(gpa), 2) AS avg_gpa
FROM banded
GROUP BY gpa_band
ORDER BY avg_gpa DESC;

--30. The academic support team wants to identify students carrying above-average credit loads who may need 
-- extra support. Find all enrolled students whose total credits exceed the average total credits among all 
-- enrolled students. Show first name, last name, major, and total_credits. Order by total_credits descending.
WITH student_credits AS (
    SELECT s.student_id,
           s.first_name,
           s.last_name,
           s.major,
           SUM(c.credits) AS total_credits
    FROM students s
    JOIN enrollments e ON e.student_id = s.student_id
    JOIN courses c     ON c.course_id  = e.course_id
    GROUP BY s.student_id, s.first_name, s.last_name, s.major
)
SELECT first_name, last_name, major, total_credits
FROM student_credits
WHERE total_credits > (SELECT AVG(total_credits) FROM student_credits)
ORDER BY total_credits DESC, last_name;
