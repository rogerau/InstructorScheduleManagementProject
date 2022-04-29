-- CREATE TABLES FOR THE CSIS 2300 PROJECT: INSTRUCTOR SCHEDULE

-- "Location" namming attribute does not work in MySQL (only in MS SQL).  Remove the "" for it to work.

-- 1. Create the database
-- CREATE DATABASE CSIS2300_project;
-- 2. use the database created previously
USE CSIS2300_project;
-- 3. Create tables:
-- Course table

CREATE TABLE Course (
CourseId INT PRIMARY KEY, 
CourseName VARCHAR(40) NOT NULL UNIQUE 
);

-- Section Schedule table:
CREATE TABLE SectionSchedule (
SectionScheduleId INT PRIMARY KEY, 
SectionScheduleStartTime TIME(0) NOT NULL, 
SectionScheduleEndTime TIME(0) NOT NULL, 
SectionScheduleDay VARCHAR(15) NOT NULL 

);

-- Room table:
CREATE TABLE Room (
RoomId INT PRIMARY KEY, 
/*"*/Location/*"*/ CHAR(1) NOT NULL, 
RoomType CHAR(1) NOT NULL
);

-- Instructor table:
CREATE TABLE Instructor (
InstructorId INT PRIMARY KEY, 
InstructorName VARCHAR(40) NOT NULL, 
OfficePhoneNum CHAR(12) NOT NULL UNIQUE, 
EmailAddress VARCHAR(50) NOT NULL UNIQUE, 
Title CHAR(3) 
);

-- Instructor and Instructor Schedule table
CREATE TABLE Instructor_InstructorSchedule (
InstructorId INT, 
InstructorScheduleId INT, 
InstructorScheduleType CHAR(1) NOT NULL, 
InstructorScheduleStartTime TIME(0) NOT NULL, 
InstructorScheduleEndTime TIME(0) NOT NULL, 
InstructorScheduleDay VARCHAR(15) NOT NULL, 
PRIMARY KEY(InstructorId, InstructorScheduleId),
FOREIGN KEY(InstructorId) REFERENCES Instructor(InstructorId) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Course and Section table
CREATE TABLE Course_Section (
CourseId INT, 
SectionId INT, 
Semester VARCHAR(10), 
DeliveryMode VARCHAR(15), 
InstructorId INT, 
PRIMARY KEY(CourseId, SectionId),
FOREIGN KEY(CourseId) REFERENCES Course(CourseId) ON DELETE CASCADE,
FOREIGN KEY(InstructorId) REFERENCES Instructor(InstructorId) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Student table
CREATE TABLE Student (
StudentId INT PRIMARY KEY, 
StudentName VARCHAR(40) NOT NULL, 
SectionId INT, 
CourseId INT, 
FOREIGN KEY(CourseId,SectionId) REFERENCES Course_Section(CourseId,SectionId) ON DELETE SET NULL 
);

-- Instructor, student and appointment table
CREATE TABLE Instructor_Student_Appointment (
InstructorId INT, 
StudentId INT, 
AppointmentId INT, 
AppoinmentDay VARCHAR(15) NOT NULL,  
AppointmentStartTime TIME(0) NOT NULL, 
AppointmentEndTime TIME(0) NOT NULL, 
PRIMARY KEY(InstructorId, StudentId, AppointmentId),
FOREIGN KEY(InstructorId) REFERENCES Instructor(InstructorId) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(StudentId) REFERENCES Student(StudentId) ON DELETE CASCADE 
);

-- Section Schedule and Room table
CREATE TABLE Section_Schedule_Room (
CourseId INT, 
SectionId INT, 
SectionScheduleId INT, 
RoomId INT, 
PRIMARY KEY(CourseId, SectionId, SectionScheduleId, RoomId),
FOREIGN KEY(CourseId,SectionId) REFERENCES Course_Section(CourseId,SectionId) ON DELETE CASCADE,
FOREIGN KEY(SectionScheduleId) REFERENCES SectionSchedule(SectionScheduleId)  ON DELETE CASCADE,
FOREIGN KEY(RoomId) REFERENCES Room(RoomId)  ON DELETE CASCADE 
);

show tables;
