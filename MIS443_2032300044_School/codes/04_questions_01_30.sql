-- ============================================================
-- MIS443 - Individual PostgreSQL Database Project: School Schema
-- 04_questions_01_30.sql
-- Student: [Your Name] / [Your Student ID]
-- Source: https://www.sql-practice.online/practice/school?engine=postgresql
--
-- Schema reference (4 tables):
--   students   (student_id PK, first_name, last_name, email, enrollment_date, graduation_year, major)
--   professors (professor_id PK, first_name, last_name, email, department, hire_date)
--   courses    (course_id PK, course_name, credits, department, professor_id FK -> professors)
--   enrollments(enrollment_id PK, student_id FK -> students, course_id FK -> courses,
--                semester, year, grade)
--
-- Run this script in pgAdmin's Query Tool after 01_create_database.sql,
-- 02_create_tables_relationships.sql and 03_insert_data.sql have been executed.
-- Each answer is labelled with its question number, difficulty, and prompt.
-- ============================================================


-- =====================================================
-- EASY (Q1 - Q13)
-- =====================================================

-- Q1 [Easy] List All Students
-- Return the complete student roster from the students table. Include every column, no filtering.
SELECT *
FROM students;


-- Q2 [Easy] Computer Science Students
-- Find all students majoring in Computer Science; show their names and expected graduation year.
SELECT first_name, last_name, graduation_year
FROM students
WHERE major = 'Computer Science';


-- Q3 [Easy] Courses Ordered by Credits
-- List all courses showing name and credit hours, highest-credit courses first.
SELECT course_name, credits
FROM courses
ORDER BY credits DESC;


-- Q4 [Easy] Students Graduating in 2026
-- Find all students whose expected graduation year is 2026; show names and majors.
SELECT first_name, last_name, major
FROM students
WHERE graduation_year = 2026;


-- Q5 [Easy] Total Number of Courses
-- Return a single count of all available courses in the catalog.
SELECT COUNT(*) AS total_courses
FROM courses;


-- Q6 [Easy] Average Course Credits
-- Calculate the average number of credit hours across all courses.
SELECT ROUND(AVG(credits), 2) AS average_credits
FROM courses;


-- Q7 [Easy] Students Enrolled After 2022
-- Find all students who enrolled after December 31, 2022.
SELECT *
FROM students
WHERE enrollment_date > '2022-12-31';


-- Q8 [Easy] Professors in Computer Science Department
-- Find all professors in the Computer Science department; show names and hire dates.
SELECT first_name, last_name, hire_date
FROM professors
WHERE department = 'Computer Science';


-- Q9 [Easy] Students with University Email
-- Find all students whose email contains 'university.edu'.
-- Show first name, last name, email, and major, ordered by last name.
SELECT first_name, last_name, email, major
FROM students
WHERE email LIKE '%university.edu%'
ORDER BY last_name;


-- Q10 [Easy] Professor Course List
-- Show each professor's name, department, and the courses they teach.
-- Order by professor last name, then course name.
SELECT p.first_name, p.last_name, p.department, c.course_name
FROM professors p
JOIN courses c ON c.professor_id = p.professor_id
ORDER BY p.last_name, c.course_name;


-- Q11 [Easy] Distinct Student Majors
-- List each unique major (no duplicates), excluding students without a declared major.
-- Order alphabetically.
SELECT DISTINCT major
FROM students
WHERE major IS NOT NULL
ORDER BY major;


-- Q12 [Easy] Students Enrolled Between 2022 and 2023
-- Find all students whose enrollment_date falls within 2022-2023 (inclusive).
-- Show first name, last name, enrollment_date, and major. Order by enrollment_date, then last name.
SELECT first_name, last_name, enrollment_date, major
FROM students
WHERE enrollment_date BETWEEN '2022-01-01' AND '2023-12-31'
ORDER BY enrollment_date, last_name;


-- Q13 [Easy] Students Without a Declared Major
-- Find all students whose major has not been declared (NULL). Show first name, last name, email.
SELECT first_name, last_name, email
FROM students
WHERE major IS NULL;


-- =====================================================
-- MEDIUM (Q14 - Q24)
-- =====================================================

-- Q14 [Medium] Student Course Enrollments
-- Show student first name, last name, course name, and grade for all enrollment records.
SELECT s.first_name, s.last_name, c.course_name, e.grade
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id;


-- Q15 [Medium] Course Enrollment Count
-- For each course, show the course name and how many students are enrolled.
-- Include courses with zero enrollments.
SELECT c.course_name, COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
LEFT JOIN enrollments e ON e.course_id = c.course_id
GROUP BY c.course_name
ORDER BY c.course_name;


-- Q16 [Medium] Popular Courses
-- Find courses with more than 1 student enrolled; show the enrollment count for each.
SELECT c.course_name, COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
JOIN enrollments e ON e.course_id = c.course_id
GROUP BY c.course_name
HAVING COUNT(e.enrollment_id) > 1;


-- Q17 [Medium] Students in Same Graduation Year
-- Find all pairs of different students who share the same graduation year (each pair once).
-- Show both students' names, the graduation year, and their majors (as major1, major2).
-- Order by graduation_year, then student_id.
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


-- Q18 [Medium] Department Course Distribution
-- For each department, show department name, course count, total credit hours,
-- and average credits per course. Order by course count descending, then department name.
SELECT
    department,
    COUNT(*) AS course_count,
    SUM(credits) AS total_credits,
    ROUND(AVG(credits), 2) AS avg_credits
FROM courses
GROUP BY department
ORDER BY course_count DESC, department;


-- Q19 [Medium] Students Not Enrolled in Any Course
-- Find students who have not registered for any course. Show first name, last name, major.
SELECT s.first_name, s.last_name, s.major
FROM students s
LEFT JOIN enrollments e ON e.student_id = s.student_id
WHERE e.enrollment_id IS NULL;


-- Q20 [Medium] Student Enrollment Count by Year
-- Count how many students enrolled each year (extracted from enrollment_date).
-- Show enrollment_year and student_count, ordered by year.
SELECT
    EXTRACT(YEAR FROM enrollment_date)::INT AS enrollment_year,
    COUNT(*) AS student_count
FROM students
GROUP BY EXTRACT(YEAR FROM enrollment_date)
ORDER BY enrollment_year;


-- Q21 [Medium] Student Best Grade
-- For each student with at least one enrollment, show their name, best grade letter,
-- and the corresponding grade points. Order by grade points descending, then last name.
-- Grade scale: A=4.0, A-=3.7, B+=3.3, B=3.0.
WITH ranked_grades AS (
    SELECT
        e.student_id,
        e.grade,
        CASE e.grade
            WHEN 'A'  THEN 4.0
            WHEN 'A-' THEN 3.7
            WHEN 'B+' THEN 3.3
            WHEN 'B'  THEN 3.0
            ELSE 0
        END AS grade_points,
        ROW_NUMBER() OVER (
            PARTITION BY e.student_id
            ORDER BY CASE e.grade
                        WHEN 'A'  THEN 4.0
                        WHEN 'A-' THEN 3.7
                        WHEN 'B+' THEN 3.3
                        WHEN 'B'  THEN 3.0
                        ELSE 0
                     END DESC
        ) AS rn
    FROM enrollments e
)
SELECT s.first_name, s.last_name, g.grade AS best_grade, g.grade_points
FROM ranked_grades g
JOIN students s ON s.student_id = g.student_id
WHERE g.rn = 1
ORDER BY g.grade_points DESC, s.last_name;


-- Q22 [Medium] Total Credits per Student
-- Show each student's total enrolled credits along with their name and major.
-- Order by total credits from highest to lowest.
SELECT
    s.first_name, s.last_name, s.major,
    SUM(c.credits) AS total_credits
FROM students s
JOIN enrollments e ON e.student_id = s.student_id
JOIN courses c ON c.course_id = e.course_id
GROUP BY s.student_id, s.first_name, s.last_name, s.major
ORDER BY total_credits DESC;


-- Q23 [Medium] Enrollments in 2022 and 2023
-- Show student first name, last name, course name, and year for all enrollments
-- in year 2022 and year 2023 combined. Order by year, then last name.
SELECT s.first_name, s.last_name, c.course_name, e.year
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id
WHERE e.year IN (2022, 2023)
ORDER BY e.year, s.last_name;


-- Q24 [Medium] Student Enrollment Status
-- For every student, show their name and whether they are 'Enrolled' (has at least one
-- course) or 'Not Enrolled' (no courses registered). Order by last name.
SELECT
    s.first_name, s.last_name,
    CASE WHEN en.student_id IS NULL THEN 'Not Enrolled' ELSE 'Enrolled' END AS status
FROM students s
LEFT JOIN (SELECT DISTINCT student_id FROM enrollments) en
    ON en.student_id = s.student_id
ORDER BY s.last_name;


-- =====================================================
-- HARD (Q25 - Q30)
-- =====================================================

-- Q25 [Hard] Student GPA Calculation
-- Convert letter grades to numeric points (A=4.0, A-=3.7, B+=3.3, B=3.0, other=0) and
-- calculate each student's GPA and how many courses they have taken. Students with no
-- enrollments should also appear. Show first_name, last_name, major, gpa, courses_taken.
-- Order by GPA descending.
SELECT
    s.first_name, s.last_name, s.major,
    COALESCE(ROUND(AVG(
        CASE e.grade
            WHEN 'A'  THEN 4.0
            WHEN 'A-' THEN 3.7
            WHEN 'B+' THEN 3.3
            WHEN 'B'  THEN 3.0
            ELSE 0
        END), 2), 0) AS gpa,
    COUNT(e.enrollment_id) AS courses_taken
FROM students s
LEFT JOIN enrollments e ON e.student_id = s.student_id
GROUP BY s.student_id, s.first_name, s.last_name, s.major
ORDER BY gpa DESC;


-- Q26 [Hard] GPA Ranking
-- Calculate each student's GPA and rank them from highest to lowest.
-- Show first name, last name, rounded GPA (2 decimals), and rank.
-- Grade scale: A=4.0, A-=3.7, B+=3.3, B=3.0.
SELECT
    s.first_name, s.last_name,
    ROUND(AVG(
        CASE e.grade
            WHEN 'A'  THEN 4.0
            WHEN 'A-' THEN 3.7
            WHEN 'B+' THEN 3.3
            WHEN 'B'  THEN 3.0
            ELSE 0
        END), 2) AS gpa,
    RANK() OVER (
        ORDER BY AVG(
            CASE e.grade
                WHEN 'A'  THEN 4.0
                WHEN 'A-' THEN 3.7
                WHEN 'B+' THEN 3.3
                WHEN 'B'  THEN 3.0
                ELSE 0
            END) DESC
    ) AS gpa_rank
FROM students s
JOIN enrollments e ON e.student_id = s.student_id
GROUP BY s.student_id, s.first_name, s.last_name
ORDER BY gpa DESC;


-- Q27 [Hard] Below-Average Course Performers
-- Find all enrollments where the student's grade points are strictly below the average
-- grade points for that course. Show student name, course name, and grade.
WITH points AS (
    SELECT
        e.enrollment_id, e.student_id, e.course_id, e.grade,
        CASE e.grade
            WHEN 'A'  THEN 4.0
            WHEN 'A-' THEN 3.7
            WHEN 'B+' THEN 3.3
            WHEN 'B'  THEN 3.0
            ELSE 0
        END AS grade_points
    FROM enrollments e
),
course_avg AS (
    SELECT course_id, AVG(grade_points) AS avg_points
    FROM points
    GROUP BY course_id
)
SELECT s.first_name, s.last_name, c.course_name, p.grade
FROM points p
JOIN course_avg ca ON ca.course_id = p.course_id
JOIN students s ON s.student_id = p.student_id
JOIN courses c ON c.course_id = p.course_id
WHERE p.grade_points < ca.avg_points;


-- Q28 [Hard] Professor with Most Students
-- Find the professor who has taught the most distinct students across all their courses.
-- Show first name, last name, department, and student_count.
SELECT p.first_name, p.last_name, p.department,
       COUNT(DISTINCT e.student_id) AS student_count
FROM professors p
JOIN courses c ON c.professor_id = p.professor_id
JOIN enrollments e ON e.course_id = c.course_id
GROUP BY p.professor_id, p.first_name, p.last_name, p.department
ORDER BY student_count DESC
LIMIT 1;


-- Q29 [Hard] Academic Performance Band Summary
-- Classify each enrolled student's GPA into bands — Distinction (GPA >= 3.7),
-- Merit (GPA >= 3.0), Pass (below 3.0) — then show how many students are in each
-- band and their average GPA. Grade scale: A=4.0, A-=3.7, B+=3.3, B=3.0.
WITH student_gpa AS (
    SELECT
        s.student_id,
        AVG(
            CASE e.grade
                WHEN 'A'  THEN 4.0
                WHEN 'A-' THEN 3.7
                WHEN 'B+' THEN 3.3
                WHEN 'B'  THEN 3.0
                ELSE 0
            END) AS gpa
    FROM students s
    JOIN enrollments e ON e.student_id = s.student_id
    GROUP BY s.student_id
),
banded AS (
    SELECT
        gpa,
        CASE
            WHEN gpa >= 3.7 THEN 'Distinction'
            WHEN gpa >= 3.0 THEN 'Merit'
            ELSE 'Pass'
        END AS band
    FROM student_gpa
)
SELECT band, COUNT(*) AS student_count, ROUND(AVG(gpa), 2) AS avg_gpa
FROM banded
GROUP BY band
ORDER BY avg_gpa DESC;


-- Q30 [Hard] High Credit Load Students
-- Find all enrolled students whose total credits exceed the average total credits
-- among all enrolled students. Show first name, last name, major, and total_credits.
-- Order by total_credits descending.
WITH student_credits AS (
    SELECT
        s.student_id, s.first_name, s.last_name, s.major,
        SUM(c.credits) AS total_credits
    FROM students s
    JOIN enrollments e ON e.student_id = s.student_id
    JOIN courses c ON c.course_id = e.course_id
    GROUP BY s.student_id, s.first_name, s.last_name, s.major
)
SELECT first_name, last_name, major, total_credits
FROM student_credits
WHERE total_credits > (SELECT AVG(total_credits) FROM student_credits)
ORDER BY total_credits DESC;

-- ============================================================
-- End of 04_questions_01_30.sql
-- ============================================================
