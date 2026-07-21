-- MIS443 - Assignment 4: Individual PostgreSQL Database Project
-- Schema: School (SQL Practice Online)
-- File 02: Create Tables and Relationships

create table students (
student_id INTEGER primary key,
first_name VARCHAR(50),
last_name VARCHAR(50),
email VARCHAR(100),
enrollment_date DATE,
graduation_year INTEGER,
major VARCHAR(100)
);

create table professors (
professor_id INTEGER primary key,
first_name VARCHAR(50),
last_name VARCHAR(50),
email VARCHAR(100),
department VARCHAR(100),
hire_date DATE
);

create table courses (
course_id VARCHAR(10) primary key,
course_name VARCHAR(100),
credits INTEGER,
department VARCHAR(100),
professor_id INTEGER references professors(professor_id)
);

create table enrollments(
enrollment_id INTEGER primary key,
student_id INTEGER references students(student_id),
course_id VARCHAR(10) references courses(course_id),
semester VARCHAR(20),
year INTEGER,
grade VARCHAR(2)
);
