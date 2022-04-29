-- GROUP_CONCAT only Works in MySql, replace with STRING_AGG() for the query to work in MSSql
-- FULL JOIN does nor wotk in MySQL, instead it was replaced for the UNION of left and right joins
-- eliminating all duplicate values

-- 1.	Retrieve the total number of available schedules per instructor (include instructor name).
-- Cartesian product with where clause (PK=FK)
SELECT Instructor.InstructorName AS "Instructor name", COUNT(Instructor_InstructorSchedule.InstructorScheduleType) AS "Number of available schedules"
FROM Instructor_InstructorSchedule, Instructor
WHERE Instructor.InstructorId = Instructor_InstructorSchedule.InstructorId
GROUP BY Instructor.InstructorName
ORDER BY Instructor.InstructorName;
    
-- 2.	Retrieve the total number of available instructors for each schedule day.
SELECT InstructorScheduleDay AS "Instructor schedule day",COUNT(DISTINCT InstructorId)  AS "Number of available instructors"
FROM Instructor_InstructorSchedule
GROUP BY InstructorScheduleDay
ORDER BY InstructorScheduleDay;

-- 3. Retrieve the total number of available schedule days for each type of schedule only in the mornings (8am - 12pm)
SELECT InstructorScheduleType AS "Type of instructor schedule", COUNT(InstructorScheduleDay)  AS "Number of available schedule days in the mornings"
FROM Instructor_InstructorSchedule
WHERE InstructorScheduleStartTime >= '08:00:00' AND InstructorScheduleEndTime <= '12:00:00'
GROUP BY InstructorScheduleType
ORDER BY InstructorScheduleType;
    
-- 4. Update all the values in the attributes of the instructor with id = 4477 (JOHN DAVID)
UPDATE Instructor
SET InstructorId = '4123', InstructorName = 'CALVIN KLEIN', OfficePhoneNum = '(778)281-954', EmailAddress = 'cklein06@gmail.com', Title = 'MG'
WHERE InstructorId = '4477';

-- 5.	Display the list of courses id and total number of sections per each course taught by each instructor (include instructor name).
-- Cross join with where clause (PK=FK) or inner join (implicit)
SELECT Instructor.InstructorName AS "Instructor name", Course_Section.CourseId, COUNT(Course_Section.SectionId) AS "Number of sections"
FROM Course_Section CROSS JOIN Instructor
WHERE Instructor.InstructorId = Course_Section.InstructorId
GROUP BY Instructor.InstructorName,Course_Section.CourseId
ORDER BY Instructor.InstructorName,Course_Section.CourseId;

-- 6.	Retrieve the number of sections taught in online for each course (include course name).
-- Inner join (explicit)
SELECT Course.CourseName, Course_Section.CourseId AS "Course Id", COUNT(Course_Section.SectionId) AS "Number of sections taught in online mode"
FROM Course_Section INNER JOIN Course 
ON Course_Section.CourseId = Course.CourseId AND DeliveryMode = 'ONLINE'
GROUP BY Course.CourseName
ORDER BY Course.CourseName;

-- 7.	Retrieve the course name of the courses that only have masters and phd instructors
-- Create view (using inner join (explicit))
CREATE VIEW CoursesWIMGPHD AS
SELECT DISTINCT Course_Section.CourseId
FROM Course_Section INNER JOIN Instructor ON Course_section.InstructorId = Instructor.InstructorId
WHERE Instructor.Title = 'MG' OR Instructor.Title = 'PHD'
GROUP BY Course_Section.CourseId;
-- inner join (explicit)
SELECT Course.CourseName
FROM Course INNER JOIN CoursesWIMGPHD ON Course.CourseId = CoursesWIMGPHD.CourseId;

-- 8. Retrieve the total number of students enrolled per course (no matter if there is not any student in a course).
-- Include course name.
-- Left join
SELECT Course.CourseName AS "Course name", Course.CourseId, COUNT(Student.StudentId) AS "Number of students"
FROM Course LEFT JOIN Student ON Course.CourseId = Student.CourseId
GROUP BY Course.CourseName
ORDER BY Course.CourseName;

-- 9. Display the total number of available section schedules per section of each course (no matter if there are any
-- section that does not have any available section schedule). Include course name.
-- Left join with nested query (as a temporary table in from)
SELECT Course.CourseName, Course.CourseId, Course_Section.SectionId, COUNT(Section_Schedule_Room.SectionId) AS "Number of available section schedules"
FROM Course LEFT JOIN (Course_Section LEFT JOIN Section_Schedule_Room 
ON Course_Section.CourseId = Section_Schedule_Room.CourseId AND Course_Section.SectionId = Section_Schedule_Room.SectionId)
ON Course.CourseId = Course_Section.CourseId
GROUP BY Course.CourseName, Course_Section.SectionId
ORDER BY Course.CourseName, Course_Section.SectionId;

-- 10.	For each instructor, retrieve the instructor name, identification, and the total number of booked appointments  
-- within all students (no matter is there any instructor without any booked appointment). Include instructor name.
-- Right join
SELECT Instructor.InstructorName, Instructor.InstructorId, 
COUNT(Instructor_Student_Appointment.AppointmentId) AS "Number of booked appointments"
FROM Instructor_Student_Appointment RIGHT JOIN Instructor 
ON  Instructor_Student_Appointment.InstructorId = Instructor.InstructorId
GROUP BY Instructor.InstructorName
ORDER BY Instructor.InstructorName;

-- 11.	Retrieve the number of students that are gonna be attended by each instructor
SELECT InstructorId, COUNT(DISTINCT StudentId) AS "Number of students that are gonna be attended"
FROM Instructor_Student_Appointment
GROUP BY InstructorId
ORDER BY InstructorId;

-- 12.	Retrieve the number of instructors that will provide appointments to each student
SELECT StudentId, COUNT(DISTINCT InstructorId) AS "Number of instructors that will provide appointments"
FROM Instructor_Student_Appointment
GROUP BY StudentId
ORDER BY StudentId;

-- 13.	Retrieve the number of booked appointments for each student and instructor
SELECT InstructorId, StudentId, COUNT(AppointmentId) AS "Number of booked appointments"
FROM Instructor_Student_Appointment
GROUP BY InstructorId, StudentId
ORDER BY InstructorId, StudentId;

-- 14. Delete the student with id = 3003 (Roger Ravi) and all values related 
DELETE FROM Student
WHERE StudentId = '3003';

-- 15. Retrieve all the Courses with Semester Details in 2021
-- Cartesian product with where clause (PK=FK)
SELECT Course.CourseName , GROUP_CONCAT(' ',Course_Section.Semester) AS SEMESTERS
FROM Course, Course_Section
WHERE Course_Section.CourseId = Course.CourseId
AND Course_Section.Semester LIKE ('%2021')
GROUP BY Course.CourseName
ORDER BY Course.CourseName;

-- 16.	Retrieve the Student names who booked appoinments with Instructors and DIsplay with respect to Instructor Name
-- Cartesian product with where clause (PK=FK)
SELECT InstructorName, GROUP_CONCAT(DISTINCT ' ',  StudentName) AS "Student Name" 
FROM Instructor_Student_Appointment,Student,Instructor
WHERE Instructor_Student_Appointment.StudentId = Student.StudentId AND 
Instructor_Student_Appointment.InstructorId = Instructor.InstructorId
GROUP BY InstructorName
ORDER BY Instructor.InstructorName;

-- 17. Display  all CourseID's whose Lectures are given in Buildings A,B or C
-- Natural join and nested query in where clause
SELECT DISTINCT C.CourseName, SSR.CourseId 
FROM Section_Schedule_Room SSR NATURAL JOIN Course C
WHERE RoomId IN (SELECT RoomId FROM Room WHERE Location in ('A','B','C'))
GROUP BY C.CourseName
ORDER BY C.CourseName;

-- 18. Display the name of all students and all instructors that have appointments 
-- (no matter if a student has not booked an appointment and no matter if an instructor has not provide an appointment)
-- Left and right joins merge with UNION to emulate Full join.
SELECT DISTINCT S.StudentName, I.InstructorName, COUNT(ISA.AppointmentId) AS "Number of booked appointments"
FROM Student S LEFT JOIN (Instructor_Student_Appointment ISA INNER JOIN Instructor I
ON I.InstructorId = ISA.InstructorId)
ON S.StudentId = ISA.StudentId
GROUP BY S.StudentName, I.InstructorName
UNION
SELECT DISTINCT S.StudentName, I.InstructorName, COUNT(ISA.AppointmentId) AS "Number of booked appointments"
FROM Student S RIGHT JOIN (Instructor_Student_Appointment ISA RIGHT JOIN Instructor I
ON I.InstructorId = ISA.InstructorId)
ON S.StudentId = ISA.StudentId
GROUP BY S.StudentName, I.InstructorName;

-- 19. Display all Instructor ID and Names who have schedules in Monday or Friday and have MG or BA Title USING VIEW
-- View and natural join (explicit)
CREATE VIEW Instructor_Temp AS 
SELECT InstructorId, InstructorName 
FROM Instructor WHERE Title IN ('MG','BA');

SELECT DISTINCT I.InstructorId, I. InstructorName
FROM Instructor_Temp I NATURAL JOIN Instructor_InstructorSchedule I_S 
WHERE I_S.InstructorScheduleDay IN ('MONDAY','FRIDAY');

-- 20. Display the course names of the courses that have 2 rooms avaiable
SELECT DISTINCT CourseName
FROM Course
WHERE Course.CourseId IN (SELECT CourseId
FROM Section_Schedule_Room
GROUP BY CourseId
HAVING COUNT(RoomId) = 2);


