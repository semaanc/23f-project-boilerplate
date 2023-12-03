CREATE DATABASE Notetastic;

USE Notetastic;

CREATE TABLE IF NOT EXISTS Professors
(
    professor_id INT AUTO_INCREMENT,
    title        VARCHAR(5),
    first_name   VARCHAR(25)         NOT NULL,
    last_name    VARCHAR(25)         NOT NULL,
    email        VARCHAR(150) UNIQUE NOT NULL,
    PRIMARY KEY (professor_id)
);

CREATE TABLE IF NOT EXISTS DepartmentAdministrators
(
    administrator_id INT AUTO_INCREMENT,
    first_name       VARCHAR(25)         NOT NULL,
    last_name        VARCHAR(25)         NOT NULL,
    email            VARCHAR(150) UNIQUE NOT NULL,
    PRIMARY KEY (administrator_id)
);

CREATE TABLE IF NOT EXISTS Departments
(
    department_name  VARCHAR(25),
    administrator_id INT,
    PRIMARY KEY (department_name),
    FOREIGN KEY (administrator_id)
        REFERENCES DepartmentAdministrators (administrator_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS Departments_Professors
(
    department_name VARCHAR(25),
    professor_id    INT,
    PRIMARY KEY (department_name, professor_id),
    FOREIGN KEY (department_name)
        REFERENCES Departments (department_name)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (professor_id)
        REFERENCES Professors (professor_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE IF NOT EXISTS Students
(
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    email      VARCHAR(150) UNIQUE NOT NULL,
    first_name VARCHAR(25),
    last_name  VARCHAR(25)
);

CREATE TABLE IF NOT EXISTS Departments_Students
(
    department_name VARCHAR(25),
    student_id      INT,
    PRIMARY KEY (department_name, student_id),
    FOREIGN KEY (department_name) REFERENCES Departments (department_name)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (student_id) REFERENCES Students (student_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);



CREATE TABLE IF NOT EXISTS Classes
(
    course_id       INTEGER,
    class_id        INTEGER,
    course_name     VARCHAR(100) NOT NULL,
    professor_id    INTEGER,
    department_name VARCHAR(25),

    PRIMARY KEY (course_id, class_id),
    FOREIGN KEY (professor_id)
        REFERENCES Professors (professor_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (department_name)
        REFERENCES Departments (department_name)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ClassFolders
(
    folder_name  VARCHAR(50),
    date_created DATETIME DEFAULT CURRENT_TIMESTAMP,
    course_id    INTEGER,
    class_id     INTEGER,
    PRIMARY KEY (folder_name, course_id, class_id),
    FOREIGN KEY (course_id, class_id)
        REFERENCES Classes (course_id, class_id)
        ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE IF NOT EXISTS StudentFolders
(
    folder_name  VARCHAR(50),
    date_created DATETIME DEFAULT CURRENT_TIMESTAMP,
    student_id   INTEGER,
    PRIMARY KEY (folder_name, student_id),
    FOREIGN KEY (student_id) references Students (student_id)
);

CREATE TABLE IF NOT EXISTS Notes
(
    note_id        INTEGER AUTO_INCREMENT PRIMARY KEY,
    student_id     INTEGER,
    date_posted    DATETIME DEFAULT CURRENT_TIMESTAMP,
    note_content   TEXT,
    reported       BOOLEAN,
    pinned         BOOLEAN,
    class_folder   VARCHAR(50),
    student_folder VARCHAR(50),
    class_id       INTEGER,
    course_id      INTEGER,

    FOREIGN KEY (student_id)
        REFERENCES Students (student_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (student_folder)
        REFERENCES StudentFolders (folder_name)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (class_folder, course_id, class_id)
        REFERENCES ClassFolders (folder_name, course_id, class_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS Student_Classes
(
    student_id INT,
    course_id  INT,
    class_id   INT,
    PRIMARY KEY (student_id, course_id, class_id),
    FOREIGN KEY (student_id)
        REFERENCES Students (student_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (course_id, class_id)
        REFERENCES Classes (course_id, class_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS TAs
(
    ta_id      INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(25),
    last_name  VARCHAR(25),
    email      VARCHAR(150) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS Classes_TAs
(
    course_id INT,
    class_id  INT,
    ta_id     INT,
    PRIMARY KEY (course_id, class_id, ta_id),
    FOREIGN KEY (course_id, class_id)
        REFERENCES Classes (course_id, class_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (ta_id)
        REFERENCES TAs (ta_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS Comments
(
    comment_id   INT AUTO_INCREMENT PRIMARY KEY,
    date_posted  DATETIME DEFAULT CURRENT_TIMESTAMP,
    note_id      INT,
    student_id   INT,
    ta_id        INT,
    professor_id INT,
    FOREIGN KEY (note_id)
        REFERENCES Notes (note_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (student_id)
        REFERENCES Students (student_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (ta_id)
        REFERENCES TAs (ta_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (professor_id)
        REFERENCES Professors (professor_id)
        ON UPDATE CASCADE ON DELETE CASCADE

);


CREATE TABLE IF NOT EXISTS DepartmentAnnouncements
(
    department_name  VARCHAR(25),
    announcement_id  INT,
    date_posted      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    content          TEXT     NOT NULL,
    administrator_id INT      NOT NULL,
    PRIMARY KEY (department_name, announcement_id),
    FOREIGN KEY (department_name)
        REFERENCES Departments (department_name)
        ON UPDATE cascade ON DELETE restrict,
    FOREIGN KEY (administrator_id)
        REFERENCES DepartmentAdministrators (administrator_id)
        ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS OfficeHours
(
    ta_id     INT,
    course_id INT,
    class_id  INT,
    time      TIME,
    date      DATE,
    PRIMARY KEY (ta_id, course_id, class_id, date, time),
    FOREIGN KEY (course_id, class_id)
        REFERENCES Classes (course_id, class_id)
        ON UPDATE cascade ON DELETE restrict,
    FOREIGN KEY (ta_id)
        REFERENCES TAs (ta_id)
        ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS Department_TAs
(
    department_name VARCHAR(25),
    ta_id           INT,
    PRIMARY KEY (department_name, ta_id),
    FOREIGN KEY (department_name)
        REFERENCES Departments (department_name)
        ON UPDATE cascade ON DELETE restrict,
    FOREIGN KEY (ta_id)
        REFERENCES TAs (ta_id)
        ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS OHLocations
(
    ta_id     INT,
    course_id INT,
    class_id  INT,
    date      DATE,
    time      TIME,
    location  VARCHAR(250),
    PRIMARY KEY (ta_id, course_id, class_id, date, time, location),
    FOREIGN KEY (ta_id, course_id, class_id, date, time)
        REFERENCES OfficeHours (ta_id, course_id, class_id, date, time)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

# Mock Data

-- Professors
INSERT INTO Professors (title, first_name, last_name, email)
VALUES ('Dr.', 'John', 'Doe', 'john.doe@example.edu'),
       (NULL, 'Jane', 'Smith', 'jane.smith@example.edu'),
       ('Dr.', 'Mark', 'Fontenot', 'fontenot.mark@example.edu');

-- Department Administrator
INSERT INTO DepartmentAdministrators (first_name, last_name, email)
VALUES ('Bob', 'Johnson', 'bob.johnson@example.edu'),
       ('Samantha', 'Williams', 'samantha.williams@example.edu'),
       ('Nicole', 'Anderson', 'nicole.anderson@example.edu');

-- Departments
INSERT INTO Departments (department_name, administrator_id)
VALUES ('Computer Science', 1),
       ('Mathematics', 2),
       ('Physics', 3);

-- Departments_Professors
INSERT INTO Departments_Professors (department_name, professor_id)
VALUES ('Physics', 1),
       ('Mathematics', 2),
       ('Computer Science', 3);

-- Students
INSERT INTO Students (email, first_name, last_name)
VALUES ('damon.a@example.edu', 'Alice', 'Damon'),
       ('scott.m@example.edu', 'Michael', 'Scott'),
       ('halpert.c@example.edu', 'Charles', 'Halpert');

-- Departments_Students
INSERT INTO Departments_Students (department_name, student_id)
VALUES ('Computer Science', 1),
       ('Mathematics', 2),
       ('Physics', 3);

-- Classes
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name)
VALUES (1001, 1, 'Fundamentals of Computer Science 1', 1, 'Computer Science'),
       (1001, 2, 'Fundamentals of Computer Science 1', 1, 'Computer Science'),
       (2001, 1, 'Calculus I', 2, 'Mathematics'),
       (3001, 1, 'Physics I: Mechanics', 3, 'Physics');


-- ClassFolders
INSERT INTO ClassFolders (folder_name, course_id, class_id)
VALUES ('CS1001_Folder', 1001, 1),
       ('CS1001_Folder2', 1001, 1),
       ('CS1001_Folder', 1001, 2),
       ('Math2001_Folder', 2001, 1),
       ('Physics3001_Folder', 3001, 1);

-- StudentFolders
INSERT INTO StudentFolders (folder_name, student_id)
VALUES ('Alice Folder', 1),
       ('Michael S. Folder', 2),
       ('Charles Folder', 3);

-- Notes
INSERT INTO Notes (student_id, note_content, class_folder, student_folder)
VALUES (1, 'This is a note for CS1001', 'CS1001_Folder', 'Alice Folder'),
       (2, 'This is a note for Math2001', 'Math2001_Folder', 'Michael S. Folder'),
       (3, 'Physics is fascinating', 'Physics3001_Folder', 'Charles Folder');

-- Student_Classes
INSERT INTO Student_Classes (student_id, course_id, class_id)
VALUES (1, 1001, 1),
       (2, 2001, 1),
       (3, 3001, 1);

-- TAs
INSERT INTO TAs (first_name, last_name, email)
VALUES ('Tasmiha', 'Amir', 'amir.t@example.edu'),
       ('Alex', 'Peterson', 'peterson.a@example.edu'),
       ('Celine', 'Semaan', 'semaan.c@example.edu'),
       ('Neeti', 'Desai', 'desai.n@example.edu');

-- Classes_TAs
INSERT INTO Classes_TAs (course_id, class_id, ta_id)
VALUES (1001, 1, 1),
       (1001, 2, 1),
       (2001, 1, 2),
       (2001, 1, 3);

-- Comments
INSERT INTO Comments (note_id, student_id, ta_id, professor_id)
VALUES (1, NULL, 1, NULL), # posted by TA
       (2, 2, NULL, NULL), # posted by student
       (3, NULL, NULL, 1); # posted by professor

-- DepartmentAnnouncements
INSERT INTO DepartmentAnnouncements (department_name, announcement_id, content, administrator_id)
VALUES ('Computer Science', 1, 'Important Announcement for CS', 1),
       ('Mathematics', 2, 'Math Department Update', 2),
       ('Physics', 3, 'Physics Department News', 3);

-- OfficeHours
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date)
VALUES (1, 1001, 1, '10:00:00', '2023-01-01'),
       (2, 2001, 1, '14:00:00', '2023-01-02'),
       (3, 3001, 1, '09:30:00', '2023-01-03');

-- Department_TAs
INSERT INTO Department_TAs (department_name, ta_id)
VALUES ('Computer Science', 1),
       ('Mathematics', 2),
       ('Physics', 3);

-- OHLocations
INSERT INTO OHLocations (ta_id, course_id, class_id, date, time, location)
VALUES (1, 1001, 1, '2023-01-01', '10:00:00', 'Cargill 097'),
       (2, 2001, 1, '2023-01-02', '14:00:00', 'https://example.zoom.us/j/123456789'),
       (3, 3001, 1, '2023-01-03', '09:30:00', 'Robinson 305');

