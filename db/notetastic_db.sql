DROP DATABASE Notetastic;

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
    department_name  VARCHAR(45),
    administrator_id INT,
    PRIMARY KEY (department_name),
    FOREIGN KEY (administrator_id)
        REFERENCES DepartmentAdministrators (administrator_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS Departments_Professors
(
    department_name VARCHAR(45),
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
    department_name VARCHAR(45),
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
    department_name  VARCHAR(45),
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
    department_name VARCHAR(45),
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

-- Mock Data

-- Professors
INSERT INTO Professors (title, first_name, last_name, email)
VALUES ('Dr.', 'John', 'Doe', 'john.doe@example.edu'),
       (NULL, 'Jane', 'Smith', 'jane.smith@example.edu'),
       ('Dr.', 'Mark', 'Fontenot', 'fontenot.mark@example.edu');

INSERT INTO Professors (title, first_name, last_name, email) VALUES ('title', 'first_name', 'last_name', 'email');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Dr', 'Gilberte', 'Halpin', 'ghalpin0@miibeian.gov.cn');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Mr', 'Mendy', 'Marvelley', 'mmarvelley1@telegraph.co.uk');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Dr', 'Pansy', 'Rudiger', 'prudiger2@adobe.com');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Mr', 'Valene', 'Yuryev', 'vyuryev3@nhs.uk');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Ms', 'Clarance', 'Lygoe', 'clygoe4@chronoengine.com');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Mr', 'Morissa', 'Leaning', 'mleaning5@huffingtonpost.com');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Ms', 'Bettina', 'Eynaud', 'beynaud6@yandex.ru');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Rev', 'Christopher', 'Dearlove', 'cdearlove7@patch.com');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Mrs', 'Toby', 'Rivenzon', 'trivenzon8@gov.uk');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Mr', 'Sherm', 'Rawcliff', 'srawcliff9@wordpress.org');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Dr', 'Francisco', 'Brooke', 'fbrookea@webeden.co.uk');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Ms', 'Ketti', 'Saul', 'ksaulb@fastcompany.com');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Mrs', 'Marie-jeanne', 'McWard', 'mmcwardc@themeforest.net');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Ms', 'Noreen', 'Grzegorek', 'ngrzegorekd@washingtonpost.com');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Mrs', 'Kennie', 'Roden', 'krodene@github.com');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Mrs', 'Teodora', 'Ambrosch', 'tambroschf@de.vu');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Mr', 'Gale', 'Kencott', 'gkencottg@google.com');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Ms', 'Arnoldo', 'Blaskett', 'ablasketth@purevolume.com');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Ms', 'Rachele', 'Sandom', 'rsandomi@shareasale.com');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Mrs', 'Lemuel', 'Worman', 'lwormanj@netlog.com');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Dr', 'Carly', 'Mahaddy', 'cmahaddyk@chron.com');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Dr', 'Kory', 'Dunbobin', 'kdunbobinl@51.la');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Mrs', 'Phylis', 'Mulberry', 'pmulberrym@google.pl');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Mr', 'Sayres', 'Quirke', 'squirken@cornell.edu');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Mrs', 'Matilde', 'Shucksmith', 'mshucksmitho@flavors.me');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Rev', 'Whittaker', 'Petricek', 'wpetricekp@springer.com');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Dr', 'Feodora', 'Brickner', 'fbricknerq@ucsd.edu');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Dr', 'Carol', 'Idenden', 'cidendenr@tiny.cc');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Dr', 'Welch', 'Ofener', 'wofeners@prnewswire.com');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Mrs', 'Thorstein', 'Bubbear', 'tbubbeart@vkontakte.ru');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Mrs', 'Percy', 'Hallgath', 'phallgathu@cargocollective.com');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Dr', 'Bourke', 'Pescud', 'bpescudv@guardian.co.uk');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Dr', 'Elfreda', 'Decourcy', 'edecourcyw@patch.com');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Dr', 'Leontyne', 'Forsyth', 'lforsythx@google.com.hk');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Dr', 'Monro', 'Yurkevich', 'myurkevichy@mtv.com');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Dr', 'Guilbert', 'Bawden', 'gbawdenz@unblog.fr');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Mrs', 'Riobard', 'Arcase', 'rarcase10@studiopress.com');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Dr', 'Dunstan', 'Henriquet', 'dhenriquet11@goo.ne.jp');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Mr', 'Lilli', 'Fullard', 'lfullard12@guardian.co.uk');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Mrs', 'Moselle', 'Pendrid', 'mpendrid13@walmart.com');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Mr', 'Laura', 'Spinelli', 'lspinelli14@howstuffworks.com');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Ms', 'Alwyn', 'Messruther', 'amessruther15@mac.com');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Ms', 'Aurelie', 'Lesly', 'alesly16@discuz.net');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Dr', 'Emmanuel', 'Count', 'ecount17@blogs.com');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Dr', 'Carree', 'Mitchener', 'cmitchener18@icio.us');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Mrs', 'Jackqueline', 'Juggings', 'jjuggings19@webeden.co.uk');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Rev', 'Townsend', 'Chateau', 'tchateau1a@addthis.com');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Mrs', 'Nick', 'Stains', 'nstains1b@cbsnews.com');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Ms', 'Felicia', 'Rickersey', 'frickersey1c@cnbc.com');
INSERT INTO Professors (title, first_name, last_name, email) VALUES ('Ms', 'Alano', 'Klich', 'aklich1d@irs.gov');

-- Department Administrator
INSERT INTO DepartmentAdministrators (first_name, last_name, email)
VALUES ('Bob', 'Johnson', 'bob.johnson@example.edu'),
       ('Samantha', 'Williams', 'samantha.williams@example.edu'),
       ('Nicole', 'Anderson', 'nicole.anderson@example.edu');

INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('first_name', 'last_name', 'email');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Elfie', 'McMylor', 'emcmylor0@123-reg.co.uk');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Grazia', 'Trayhorn', 'gtrayhorn1@quantcast.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Simone', 'Billingsley', 'sbillingsley2@princeton.edu');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Art', 'MacArthur', 'amacarthur3@kickstarter.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Ambrosio', 'Faltin', 'afaltin4@google.fr');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Stoddard', 'Danilevich', 'sdanilevich5@ft.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Sarena', 'Sneesby', 'ssneesby6@joomla.org');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Boony', 'Riggeard', 'briggeard7@ucoz.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Curtice', 'Insall', 'cinsall8@taobao.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Nikolia', 'Hethron', 'nhethron9@squidoo.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Emmott', 'Paulus', 'epaulusa@prlog.org');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Tadio', 'Eddins', 'teddinsb@prweb.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Gar', 'Ayton', 'gaytonc@bluehost.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Kat', 'Ebourne', 'kebourned@cpanel.net');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Tarah', 'Kleinholz', 'tkleinholze@meetup.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Nadine', 'Koeppke', 'nkoeppkef@wordpress.org');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Julius', 'Sime', 'jsimeg@techcrunch.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Dix', 'Coggon', 'dcoggonh@wikimedia.org');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Beryle', 'De Mitris', 'bdemitrisi@vkontakte.ru');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Wake', 'Merrison', 'wmerrisonj@xrea.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Nike', 'Skouling', 'nskoulingk@acquirethisname.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Dyana', 'Ternent', 'dternentl@wisc.edu');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Kimberly', 'Minchinton', 'kminchintonm@zimbio.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Burg', 'Twitchings', 'btwitchingsn@nih.gov');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Bax', 'Tysack', 'btysacko@icio.us');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Jerri', 'McGucken', 'jmcguckenp@vistaprint.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Filia', 'Dmtrovic', 'fdmtrovicq@pcworld.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Zack', 'Mortel', 'zmortelr@newsvine.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Nick', 'Venour', 'nvenours@boston.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Prudence', 'Rennenbach', 'prennenbacht@linkedin.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Carie', 'Faltin', 'cfaltinu@auda.org.au');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Cristobal', 'Crozier', 'ccrozierv@bluehost.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Elita', 'Turpin', 'eturpinw@addthis.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Neddy', 'Schule', 'nschulex@toplist.cz');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Rickie', 'Eginton', 'regintony@msn.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Reggi', 'Glozman', 'rglozmanz@wufoo.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Maggie', 'Boyson', 'mboyson10@si.edu');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Alexandr', 'Corter', 'acorter11@foxnews.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Paule', 'Laxe', 'plaxe12@wordpress.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Rosalie', 'Rockey', 'rrockey13@zimbio.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Stefania', 'Grunnell', 'sgrunnell14@sciencedirect.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Sibella', 'Skellon', 'sskellon15@prlog.org');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Maiga', 'Mayow', 'mmayow16@globo.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Gregorio', 'Petrulis', 'gpetrulis17@yellowbook.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Debora', 'Egginson', 'degginson18@artisteer.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Kyle', 'Radborne', 'kradborne19@feedburner.com');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Rubi', 'Kippin', 'rkippin1a@exblog.jp');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Lizette', 'Brickhill', 'lbrickhill1b@themeforest.net');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Lethia', 'Crookshank', 'lcrookshank1c@princeton.edu');
INSERT INTO DepartmentAdministrators (first_name, last_name, email) VALUES ('Rozina', 'Savege', 'rsavege1d@home.pl');

-- Departments
INSERT INTO Departments (department_name, administrator_id)
VALUES ('Computer Science', 1),
       ('Mathematics', 2),
       ('Physics', 3);
INSERT INTO Departments (department_name, administrator_id) VALUES ('Division of Philosophy', 43);
INSERT INTO Departments (department_name, administrator_id) VALUES ('School of Physical Education', 16);
INSERT INTO Departments (department_name, administrator_id) VALUES ('Division of Mathematics', 9);
INSERT INTO Departments (department_name, administrator_id) VALUES ('College of Communication', 19);
INSERT INTO Departments (department_name, administrator_id) VALUES ('College of Art', 40);
INSERT INTO Departments (department_name, administrator_id) VALUES ('Division of Social Sciences', 30);
INSERT INTO Departments (department_name, administrator_id) VALUES ('Department of History', 6);
INSERT INTO Departments (department_name, administrator_id) VALUES ('Department of Chemistry', 41);
INSERT INTO Departments (department_name, administrator_id) VALUES ('Division of Design', 18);
INSERT INTO Departments (department_name, administrator_id) VALUES ('College of Music', 36);
INSERT INTO Departments (department_name, administrator_id) VALUES ('College of Engineering', 7);
INSERT INTO Departments (department_name, administrator_id) VALUES ('College of Health Sciences', 9);
INSERT INTO Departments (department_name, administrator_id) VALUES ('College of Teaching', 10);
INSERT INTO Departments (department_name, administrator_id) VALUES ('Department of Biology', 28);
INSERT INTO Departments (department_name, administrator_id) VALUES ('School of Architecture', 11);
INSERT INTO Departments (department_name, administrator_id) VALUES ('School of Public Health', 26);
INSERT INTO Departments (department_name, administrator_id) VALUES ('School of Physics', 4);
INSERT INTO Departments (department_name, administrator_id) VALUES ('Division of Geology', 31);
INSERT INTO Departments (department_name, administrator_id) VALUES ('School of Nursing', 3);
INSERT INTO Departments (department_name, administrator_id) VALUES ('Division of Economics', 33);
INSERT INTO Departments (department_name, administrator_id) VALUES ('College of Information Technology', 10);
INSERT INTO Departments (department_name, administrator_id) VALUES ('College of Biomedical Sciences', 26);
INSERT INTO Departments (department_name, administrator_id) VALUES ('Department of Graphic Design', 39);
INSERT INTO Departments (department_name, administrator_id) VALUES ('School of Computer Science', 10);
INSERT INTO Departments (department_name, administrator_id) VALUES ('College of Political Science', 47);
INSERT INTO Departments (department_name, administrator_id) VALUES ('Division of Business', 46);
INSERT INTO Departments (department_name, administrator_id) VALUES ('College of Cybersecurity', 23);
INSERT INTO Departments (department_name, administrator_id) VALUES ('Department of Marketing', 12);
INSERT INTO Departments (department_name, administrator_id) VALUES ('Division of History', 8);
INSERT INTO Departments (department_name, administrator_id) VALUES ('School of Global Health', 30);

-- Departments_Professors
INSERT INTO Departments_Professors (department_name, professor_id)
VALUES ('Physics', 1),
       ('Mathematics', 2),
       ('Computer Science', 3);

INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Music', 33);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Philosophy', 34);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Music', 28);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of History', 5);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Geology', 40);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Health Sciences', 46);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of Graphic Design', 20);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Geology', 29);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of History', 16);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Nursing', 13);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Physical Education', 5);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Physical Education', 23);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Information Technology', 28);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of Chemistry', 16);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Philosophy', 21);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of History', 45);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of Graphic Design', 28);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Communication', 30);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Information Technology', 24);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Physical Education', 16);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Public Health', 48);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Communication', 12);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Architecture', 35);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Music', 17);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Geology', 30);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Communication', 34);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Engineering', 39);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Physical Education', 4);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Architecture', 25);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Social Sciences', 42);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Physical Education', 9);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Music', 41);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Information Technology', 36);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Geology', 50);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Information Technology', 18);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Economics', 43);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Architecture', 3);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Nursing', 48);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Economics', 6);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Biomedical Sciences', 24);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of History', 36);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Nursing', 15);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Public Health', 30);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Public Health', 3);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of Chemistry', 22);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Health Sciences', 13);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Information Technology', 43);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Mathematics', 7);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Nursing', 2);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Philosophy', 19);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Information Technology', 17);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Economics', 20);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Music', 9);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of History', 23);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of History', 6);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Communication', 42);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of Chemistry', 18);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Physical Education', 27);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Communication', 50);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Information Technology', 41);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of History', 18);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Geology', 16);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Engineering', 16);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Philosophy', 39);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Philosophy', 32);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Economics', 23);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Geology', 35);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of History', 26);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Information Technology', 37);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Philosophy', 1);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Architecture', 16);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of History', 25);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Mathematics', 21);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Public Health', 15);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of Chemistry', 48);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Philosophy', 49);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of History', 20);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Physical Education', 3);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Information Technology', 16);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of History', 11);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of History', 35);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Architecture', 10);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Geology', 37);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Public Health', 21);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Physical Education', 19);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Information Technology', 29);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Philosophy', 40);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Communication', 8);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Economics', 2);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Communication', 36);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Public Health', 43);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Health Sciences', 26);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Music', 44);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of Graphic Design', 44);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Geology', 32);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Health Sciences', 15);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Communication', 27);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Social Sciences', 25);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of Chemistry', 34);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Music', 50);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Health Sciences', 16);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of Chemistry', 17);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of Chemistry', 8);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Geology', 18);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Music', 3);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of History', 13);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Philosophy', 47);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Music', 21);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of Graphic Design', 23);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Music', 32);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Economics', 32);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Mathematics', 9);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Philosophy', 23);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Geology', 12);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Economics', 46);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Music', 1);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of History', 30);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Geology', 47);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Social Sciences', 27);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of History', 39);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of Chemistry', 49);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of Graphic Design', 18);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of Chemistry', 36);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Music', 6);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Music', 18);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Information Technology', 1);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Health Sciences', 27);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Engineering', 37);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Philosophy', 30);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of Chemistry', 21);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Philosophy', 33);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Geology', 46);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Economics', 12);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Social Sciences', 12);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of History', 41);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Philosophy', 41);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Social Sciences', 20);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Geology', 14);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Geology', 31);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Geology', 43);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Communication', 6);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Music', 27);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of Chemistry', 41);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Public Health', 29);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Engineering', 42);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Music', 8);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Mathematics', 11);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Engineering', 25);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Philosophy', 7);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Social Sciences', 36);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Information Technology', 35);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Music', 22);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Philosophy', 27);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Architecture', 49);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Public Health', 6);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of Graphic Design', 38);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Health Sciences', 14);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Nursing', 37);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Mathematics', 1);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Music', 11);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Architecture', 28);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Public Health', 35);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Information Technology', 22);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Geology', 3);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Engineering', 17);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Engineering', 47);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of Graphic Design', 15);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Information Technology', 14);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Communication', 1);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Information Technology', 30);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of Chemistry', 46);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Physical Education', 28);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Music', 39);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Public Health', 32);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Health Sciences', 48);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Engineering', 30);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Philosophy', 3);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Music', 40);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Philosophy', 5);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Public Health', 7);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Economics', 40);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Mathematics', 41);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Information Technology', 12);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Public Health', 19);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Music', 5);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Music', 24);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Music', 25);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Music', 37);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Communication', 43);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Public Health', 41);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Philosophy', 2);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Physical Education', 24);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Geology', 39);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('School of Architecture', 5);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of Chemistry', 39);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Information Technology', 39);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('College of Engineering', 4);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Philosophy', 45);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Department of Graphic Design', 40);
INSERT INTO Departments_Professors (department_name, professor_id) VALUES ('Division of Geology', 4);

-- Students
INSERT INTO Students (email, first_name, last_name)
VALUES ('damon.a@example.edu', 'Alice', 'Damon'),
       ('scott.m@example.edu', 'Michael', 'Scott'),
       ('halpert.c@example.edu', 'Charles', 'Halpert');

INSERT INTO Students (first_name, last_name, email) VALUES ('first_name', 'last_name', 'email');
INSERT INTO Students (first_name, last_name, email) VALUES ('Bryana', 'Rapier', 'brapier0@storify.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Simmonds', 'Woolway', 'swoolway1@paypal.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Abbye', 'Trainor', 'atrainor2@chronoengine.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Jaquith', 'Minet', 'jminet3@craigslist.org');
INSERT INTO Students (first_name, last_name, email) VALUES ('Bertram', 'Mildmott', 'bmildmott4@wiley.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Reinwald', 'Lougheed', 'rlougheed5@va.gov');
INSERT INTO Students (first_name, last_name, email) VALUES ('Ali', 'Blackney', 'ablackney6@tamu.edu');
INSERT INTO Students (first_name, last_name, email) VALUES ('Winthrop', 'Mowle', 'wmowle7@washington.edu');
INSERT INTO Students (first_name, last_name, email) VALUES ('Chev', 'Raven', 'craven8@printfriendly.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Dalenna', 'Glanister', 'dglanister9@lulu.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Janaya', 'Copplestone', 'jcopplestonea@people.com.cn');
INSERT INTO Students (first_name, last_name, email) VALUES ('Jess', 'Batch', 'jbatchb@myspace.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Neal', 'Mellows', 'nmellowsc@networkadvertising.org');
INSERT INTO Students (first_name, last_name, email) VALUES ('Caprice', 'Caplin', 'ccaplind@alibaba.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Waldemar', 'Insole', 'winsolee@berkeley.edu');
INSERT INTO Students (first_name, last_name, email) VALUES ('Alaster', 'Tanman', 'atanmanf@ezinearticles.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Hasheem', 'Moyser', 'hmoyserg@pagesperso-orange.fr');
INSERT INTO Students (first_name, last_name, email) VALUES ('Frans', 'Zavattiero', 'fzavattieroh@1688.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Earle', 'Chaves', 'echavesi@t.co');
INSERT INTO Students (first_name, last_name, email) VALUES ('Idalina', 'Piwall', 'ipiwallj@vimeo.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Marshal', 'Summerskill', 'msummerskillk@harvard.edu');
INSERT INTO Students (first_name, last_name, email) VALUES ('Lowe', 'Dundendale', 'ldundendalel@twitpic.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Virginie', 'Turban', 'vturbanm@plala.or.jp');
INSERT INTO Students (first_name, last_name, email) VALUES ('Mart', 'Benting', 'mbentingn@wisc.edu');
INSERT INTO Students (first_name, last_name, email) VALUES ('Vick', 'Rosthorn', 'vrosthorno@salon.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Clevey', 'Piers', 'cpiersp@dagondesign.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Corrie', 'Hattiff', 'chattiffq@slideshare.net');
INSERT INTO Students (first_name, last_name, email) VALUES ('Percy', 'Buscher', 'pbuscherr@google.fr');
INSERT INTO Students (first_name, last_name, email) VALUES ('Millard', 'Gosz', 'mgoszs@answers.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Nicol', 'Bradnocke', 'nbradnocket@macromedia.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Darill', 'Wolstencroft', 'dwolstencroftu@chron.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Hedy', 'Bothe', 'hbothev@plala.or.jp');
INSERT INTO Students (first_name, last_name, email) VALUES ('Sheree', 'Scherme', 'sschermew@sfgate.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Westleigh', 'Pashley', 'wpashleyx@kickstarter.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Lydia', 'Redmile', 'lredmiley@4shared.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Marie-jeanne', 'Domegan', 'mdomeganz@youtu.be');
INSERT INTO Students (first_name, last_name, email) VALUES ('Carmelia', 'Kulic', 'ckulic10@i2i.jp');
INSERT INTO Students (first_name, last_name, email) VALUES ('Catharine', 'Jakeway', 'cjakeway11@odnoklassniki.ru');
INSERT INTO Students (first_name, last_name, email) VALUES ('Claude', 'Barreau', 'cbarreau12@intel.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Janis', 'Boylund', 'jboylund13@home.pl');
INSERT INTO Students (first_name, last_name, email) VALUES ('Udell', 'Orknay', 'uorknay14@dedecms.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Derrick', 'Mayberry', 'dmayberry15@washington.edu');
INSERT INTO Students (first_name, last_name, email) VALUES ('Falito', 'Monni', 'fmonni16@ucla.edu');
INSERT INTO Students (first_name, last_name, email) VALUES ('Dita', 'Coil', 'dcoil17@imageshack.us');
INSERT INTO Students (first_name, last_name, email) VALUES ('Rozalin', 'Draude', 'rdraude18@paypal.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Nancee', 'Bluett', 'nbluett19@aboutads.info');
INSERT INTO Students (first_name, last_name, email) VALUES ('Arlin', 'Manford', 'amanford1a@washington.edu');
INSERT INTO Students (first_name, last_name, email) VALUES ('Marysa', 'Hanlin', 'mhanlin1b@blogspot.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Dewain', 'Yedy', 'dyedy1c@miitbeian.gov.cn');
INSERT INTO Students (first_name, last_name, email) VALUES ('Demetris', 'Soppett', 'dsoppett1d@livejournal.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Lura', 'Munro', 'lmunro1e@qq.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Lesya', 'Giorgini', 'lgiorgini1f@last.fm');
INSERT INTO Students (first_name, last_name, email) VALUES ('Basia', 'Hassur', 'bhassur1g@theglobeandmail.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Jammal', 'Halstead', 'jhalstead1h@seesaa.net');
INSERT INTO Students (first_name, last_name, email) VALUES ('Lazarus', 'Perrigo', 'lperrigo1i@dailymotion.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Julita', 'Howling', 'jhowling1j@forbes.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Ashly', 'Noblet', 'anoblet1k@samsung.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Tanney', 'Rottery', 'trottery1l@prweb.com');
INSERT INTO Students (first_name, last_name, email) VALUES ('Laurette', 'Trighton', 'ltrighton1m@cpanel.net');
INSERT INTO Students (first_name, last_name, email) VALUES ('Robyn', 'Duplan', 'rduplan1n@wikimedia.org');

-- Departments_Students
INSERT INTO Departments_Students (department_name, student_id)
VALUES ('Computer Science', 1),
       ('Mathematics', 2),
       ('Physics', 3);

INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Geology', 34);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Physical Education', 39);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Mathematics', 57);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Communication', 53);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Information Technology', 2);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of Chemistry', 21);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Information Technology', 59);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Physical Education', 59);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Music', 27);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Information Technology', 14);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Architecture', 9);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Philosophy', 35);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Economics', 10);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of Chemistry', 32);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Public Health', 33);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Geology', 49);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Health Sciences', 19);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Public Health', 9);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of Chemistry', 53);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Health Sciences', 31);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Architecture', 25);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Health Sciences', 15);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Mathematics', 22);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Health Sciences', 32);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Communication', 9);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Geology', 39);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Nursing', 42);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Physical Education', 18);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Physical Education', 19);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Geology', 44);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Music', 26);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Health Sciences', 26);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Economics', 9);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Economics', 59);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Physical Education', 30);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Music', 7);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Information Technology', 31);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Public Health', 6);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of History', 1);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Social Sciences', 35);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of History', 3);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Mathematics', 13);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of Chemistry', 23);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Information Technology', 5);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Public Health', 20);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Music', 2);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Architecture', 28);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Music', 58);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Engineering', 1);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Music', 34);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Philosophy', 45);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Philosophy', 33);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of History', 2);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Music', 31);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Nursing', 49);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Information Technology', 17);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Public Health', 19);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Architecture', 26);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Philosophy', 47);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Music', 30);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Communication', 49);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of Chemistry', 38);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Physical Education', 40);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Music', 39);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Health Sciences', 33);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Public Health', 29);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Information Technology', 40);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Health Sciences', 2);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Geology', 37);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Philosophy', 5);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Philosophy', 41);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of Graphic Design', 30);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Information Technology', 27);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Music', 32);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Communication', 7);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Public Health', 12);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Geology', 1);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of History', 55);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Music', 55);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Nursing', 14);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Music', 18);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Public Health', 59);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of Chemistry', 59);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Nursing', 11);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Philosophy', 54);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Mathematics', 31);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of Graphic Design', 35);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Philosophy', 1);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of Chemistry', 49);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Social Sciences', 7);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Public Health', 13);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Philosophy', 23);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Geology', 13);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Music', 60);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Geology', 46);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Geology', 50);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Health Sciences', 27);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Communication', 27);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Information Technology', 44);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Economics', 36);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Health Sciences', 48);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Physical Education', 54);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Mathematics', 28);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Architecture', 12);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Philosophy', 21);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Public Health', 48);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Engineering', 23);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of History', 48);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Public Health', 14);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Social Sciences', 12);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Public Health', 21);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Philosophy', 50);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of History', 40);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Music', 6);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Geology', 54);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Information Technology', 35);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Public Health', 60);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Public Health', 2);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of Chemistry', 30);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Information Technology', 34);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Philosophy', 22);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Geology', 51);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Geology', 10);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Architecture', 18);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Architecture', 50);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Philosophy', 60);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of Graphic Design', 19);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Information Technology', 45);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Communication', 15);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Physical Education', 22);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Information Technology', 53);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Physical Education', 7);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Mathematics', 17);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of Graphic Design', 56);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Physical Education', 43);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Information Technology', 33);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Geology', 58);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of Graphic Design', 29);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Physical Education', 5);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of Chemistry', 15);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Architecture', 27);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Information Technology', 47);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Music', 33);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Engineering', 47);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Music', 36);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Physical Education', 14);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Nursing', 2);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Engineering', 43);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Nursing', 48);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Information Technology', 51);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Nursing', 44);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Philosophy', 11);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Physical Education', 20);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Philosophy', 14);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Geology', 33);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Music', 61);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Health Sciences', 38);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of Chemistry', 14);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Music', 57);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Physical Education', 56);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Public Health', 42);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of History', 41);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Health Sciences', 25);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Music', 43);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Mathematics', 37);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Information Technology', 16);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Economics', 15);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Health Sciences', 9);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of History', 7);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of Chemistry', 44);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Geology', 20);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of History', 43);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Nursing', 47);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Music', 15);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Economics', 1);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Philosophy', 34);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Philosophy', 4);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Health Sciences', 51);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Nursing', 5);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Geology', 24);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Philosophy', 56);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Geology', 52);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Information Technology', 11);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Engineering', 8);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Music', 59);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of History', 31);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of History', 19);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of Chemistry', 29);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of Chemistry', 7);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Public Health', 46);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Public Health', 52);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Philosophy', 49);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Communication', 34);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of Graphic Design', 10);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Department of History', 25);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Nursing', 38);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Geology', 11);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('College of Music', 44);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('School of Nursing', 13);
INSERT INTO Departments_Students (department_name, student_id) VALUES ('Division of Geology', 38);

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

INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Heat Transfer and Fluid Mechanics', '2023-04-30 20:17:04', 37);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Data Structures and Algorithms', '2020-07-17 07:37:24', 29);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Heat Transfer and Fluid Mechanics', '2020-11-08 21:53:53', 10);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Microeconomics', '2023-03-07 01:29:25', 58);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Managerial Economics', '2021-12-28 07:16:42', 15);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Organic Chemistry', '2023-07-06 13:34:39', 59);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Thermodynamics', '2022-04-03 08:49:35', 41);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('U.S. History: Reconstruction to the Present', '2020-10-21 17:40:59', 14);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Renaissance Art History', '2021-08-20 06:29:15', 37);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Organic Chemistry', '2023-09-06 22:05:08', 17);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Social Psychology in Action', '2020-10-14 16:01:31', 39);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Partial Differential Equations', '2021-07-25 11:08:32', 29);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Abstract Algebra', '2021-08-14 16:05:39', 36);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Environmental Thermodynamics', '2020-05-17 12:40:23', 20);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Linear Algebra', '2020-05-01 19:54:19', 48);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Thermodynamics', '2022-03-29 02:20:24', 7);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Software Engineering Principles', '2022-12-13 11:06:43', 7);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('History of the USA', '2021-12-15 18:52:09', 16);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Introduction to Psychology', '2023-05-12 23:16:35', 52);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Linear Algebra', '2020-08-21 17:52:47', 45);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Data Structures and Algorithms', '2021-02-07 09:28:46', 28);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Thermodynamics', '2020-10-02 00:01:19', 28);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('American Political History', '2022-05-19 15:02:08', 22);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('History of the USA', '2022-05-19 02:26:23', 6);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Data Structures and Algorithms', '2023-04-07 12:06:19', 12);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Linear Algebra', '2021-03-23 22:32:43', 59);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Organic Chemistry', '2023-05-08 03:02:38', 31);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Inorganic Chemistry', '2022-04-16 06:26:49', 47);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Comparative World Literature', '2020-11-04 12:06:41', 22);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Linear Algebra', '2022-08-29 15:50:39', 44);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Managerial Economics', '2022-04-20 18:27:42', 48);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Linear Algebra', '2023-04-01 09:39:53', 30);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('World Literature', '2021-07-21 10:28:12', 41);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Software Engineering Principles', '2020-06-30 09:31:31', 47);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Organic Chemistry', '2020-06-30 12:50:16', 5);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Modern and Contemporary Art', '2023-09-15 10:12:58', 1);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Behavioral Neuroscience', '2021-09-24 13:30:07', 46);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Linear Algebra', '2020-03-29 02:56:47', 13);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Fundamentals of Computer Science', '2020-11-16 15:49:05', 53);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Linear Algebra', '2020-08-10 19:53:59', 54);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Contemporary Asian Literature', '2022-01-03 04:37:16', 50);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Organic Chemistry', '2023-07-30 12:24:23', 40);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Thermodynamics', '2022-03-28 15:30:40', 12);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Environmental Thermodynamics', '2020-02-26 20:41:04', 35);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Linear Algebra', '2022-04-23 10:50:30', 43);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Ordinary Differential Equations', '2020-06-14 00:05:52', 33);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('World Literature', '2020-02-24 18:59:17', 40);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Managerial Economics', '2020-03-29 10:41:16', 54);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('African American History', '2021-09-15 09:33:38', 23);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Physical Organic Chemistry', '2022-08-01 09:46:56', 19);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Introduction to Cognitive Psychology', '2023-09-02 00:41:16', 31);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Organic Chemistry', '2022-10-19 03:33:59', 10);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Fundamentals of Computer Science', '2023-10-29 16:05:48', 38);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Heat Transfer and Fluid Mechanics', '2023-05-26 11:49:14', 57);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Fundamentals of Computer Science', '2023-01-10 19:44:08', 19);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Environmental Thermodynamics', '2020-08-27 11:24:41', 26);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Organic Chemistry', '2022-05-06 05:50:40', 34);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Behavioral Neuroscience', '2021-03-12 22:21:55', 21);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Fundamentals of Computer Science', '2020-04-10 09:56:42', 43);
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Art History', '2023-06-20 03:07:25', 12);

-- Notes
INSERT INTO Notes (student_id, note_content, class_folder, student_folder)
VALUES (1, 'This is a note for CS1001', 'CS1001_Folder', 'Alice Folder'),
       (2, 'This is a note for Math2001', 'Math2001_Folder', 'Michael S. Folder'),
       (3, 'Physics is fascinating', 'Physics3001_Folder', 'Charles Folder');

INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (47, '2023-08-21 18:38:44', 'Stand-alone uniform encoding', TRUE, TRUE,'Module 1.1','Microeconomics',2,6383);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (14, '2020-07-24 22:03:51', 'Reactive contextually-based functionalities', FALSE, FALSE,'Chapter 3','Organic Chemistry',1,702);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (25, '2020-07-27 02:18:30', 'Right-sized 3rd generation capacity', TRUE, TRUE,'Module 4.1','Behavioral Neuroscience',1,797);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (57, '2022-01-06 21:26:41', 'Seamless full-range time-frame', FALSE, FALSE,'Module 1','Behavioral Neuroscience',8,2633);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (53, '2023-06-22 14:35:46', 'Balanced zero administration moderator', FALSE, TRUE,'Chapter 3','World Literature',9,3768);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (9, '2021-06-03 23:10:18', 'Pre-emptive maximized migration', FALSE, TRUE,'Module 2.1','Modern and Contemporary Art',4,9552);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (23, '2020-06-27 15:10:10', 'Quality-focused bandwidth-monitored protocol', TRUE, TRUE,'Lecture 1','Art History',1,5277);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (51, '2023-06-06 20:57:30', 'Enhanced object-oriented core', FALSE, TRUE,'Chapter 4','Data Structures and Algorithms',8,2219);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (11, '2023-11-10 11:15:49', 'Distributed 24 hour standardization', TRUE, FALSE,'Module 2','Ordinary Differential Equations',0,123);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (27, '2020-11-04 07:13:05', 'Self-enabling zero defect synergy', TRUE, TRUE,'Lecture 1','Managerial Economics',5,1636);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (24, '2023-05-03 03:36:37', 'Advanced web-enabled approach', TRUE, FALSE,'Chapter 1','Thermodynamics',2,314);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (57, '2022-11-09 02:35:56', 'Vision-oriented methodical firmware', FALSE, TRUE,'Module 1','U.S. History: Reconstruction to the Present',5,1636);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (33, '2020-12-08 13:17:50', 'Visionary discrete function', TRUE, FALSE,'Chapter 1','Heat Transfer and Fluid Mechanics',9,3768);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (5, '2021-12-18 09:42:46', 'Universal multi-state time-frame', TRUE, FALSE,'Chapter 4','Renaissance Art History',7,9402);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (25, '2020-03-06 13:35:34', 'Mandatory directional local area network', TRUE, TRUE,'Module 1.1','Linear Algebra',2,3913);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (58, '2021-05-31 15:20:35', 'Automated global encryption', FALSE, FALSE,'Module 2.1','Linear Algebra',4,9552);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (6, '2022-12-16 09:07:28', 'Decentralized responsive internet solution', FALSE, FALSE,'Module 1','Linear Algebra',6,3098);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (41, '2020-10-24 22:34:50', 'Implemented executive protocol', FALSE, FALSE,'Module 4','Environmental Thermodynamics',5,1636);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (36, '2021-02-10 04:04:10', 'Synergized didactic focus group', FALSE, TRUE,'Chapter 1','Linear Algebra',4,9552);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (53, '2022-12-28 16:50:08', 'Robust logistical forecast', FALSE, TRUE,'Chapter 1','Thermodynamics',8,2219);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (19, '2020-03-10 11:04:22', 'Open-architected radical complexity', FALSE, FALSE,'Module 4','Managerial Economics',8,3274);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (54, '2022-07-14 11:50:48', 'Enhanced 4th generation success', TRUE, FALSE,'Module 4','U.S. History: Reconstruction to the Present',5,1636);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (38, '2022-09-14 05:56:26', 'Total background installation', FALSE, TRUE,'Chapter 1','Inorganic Chemistry',9,3768);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (56, '2022-02-14 07:59:23', 'Triple-buffered radical frame', FALSE, FALSE,'Module 5','Linear Algebra',0,5792);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (5, '2020-10-03 10:03:09', 'Intuitive well-modulated challenge', TRUE, FALSE,'Module 1.1','Organic Chemistry',0,4231);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (46, '2023-04-06 17:56:16', 'Upgradable upward-trending local area network', FALSE, FALSE,'Module 5.1','Contemporary Asian Literature',1,5277);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (16, '2021-01-02 23:54:51', 'Optimized mission-critical ability', FALSE, TRUE,'Module 1.1','Heat Transfer and Fluid Mechanics',2,3913);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (29, '2020-02-14 19:12:24', 'Re-engineered secondary extranet', FALSE, FALSE,'Chapter 3','Organic Chemistry',1,702);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (46, '2022-08-29 05:32:59', 'Synergized neutral project', FALSE, TRUE,'Module 1.1','Thermodynamics',9,8850);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (8, '2022-05-26 15:19:07', 'Future-proofed 3rd generation toolset', TRUE, TRUE,'Module 1.1','Software Engineering Principles',2,6383);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (17, '2022-11-13 18:25:35', 'Centralized object-oriented architecture', FALSE, FALSE,'Module 2','Inorganic Chemistry',0,123);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (15, '2023-04-06 01:43:00', 'Decentralized explicit structure', FALSE, FALSE,'Lecture 2','Fundamentals of Computer Science',5,1636);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (45, '2020-11-07 06:54:34', 'Multi-tiered eco-centric info-mediaries', FALSE, FALSE,'Module 4','Data Structures and Algorithms',3,4521);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (21, '2020-12-13 11:18:16', 'Extended discrete help-desk', TRUE, FALSE,'Module 1.1','Introduction to Psychology',2,3913);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (38, '2022-12-31 19:30:45', 'Quality-focused bi-directional instruction set', FALSE, FALSE,'Chapter 4','Environmental Thermodynamics',8,2219);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (24, '2022-04-20 23:50:26', 'Open-architected well-modulated neural-net', TRUE, TRUE,'Module 5.1','Modern and Contemporary Art',0,123);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (57, '2020-12-17 10:11:25', 'Profound tertiary migration', FALSE, FALSE,'Lecture 1','Comparative World Literature',0,5792);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (29, '2023-08-31 08:26:06', 'Mandatory multimedia Graphic Interface', TRUE, FALSE,'Module 4','Linear Algebra',8,3274);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (55, '2021-03-12 00:00:34', 'Seamless multi-state moderator', TRUE, FALSE,'Chapter 1','Environmental Thermodynamics',2,314);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (24, '2021-05-18 04:23:17', 'Cloned solution-oriented task-force', TRUE, FALSE,'Module 3','Thermodynamics',8,2219);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (4, '2020-06-29 20:17:24', 'Virtual heuristic model', TRUE, TRUE,'Lecture 4','Inorganic Chemistry',2,3913);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (47, '2021-04-16 14:58:57', 'Up-sized interactive data-warehouse', FALSE, FALSE,'Chapter 4','Ordinary Differential Equations',7,9402);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (16, '2020-07-14 12:57:14', 'Progressive non-volatile firmware', TRUE, TRUE,'Lecture 4','Organic Chemistry',6,3597);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (37, '2020-08-10 07:04:50', 'Reverse-engineered bandwidth-monitored support', TRUE, TRUE,'Module 3','Environmental Thermodynamics',5,9091);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (24, '2021-07-02 12:45:51', 'Virtual user-facing portal', TRUE, TRUE,'Lecture 4','Linear Algebra',6,3597);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (7, '2022-04-27 15:10:52', 'Organic holistic frame', FALSE, FALSE,'Module 1','Ordinary Differential Equations',2,3913);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (45, '2021-12-16 00:20:17', 'Enhanced impactful infrastructure', TRUE, TRUE,'Module 3','Managerial Economics',6,5850);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (53, '2023-01-12 19:48:27', 'Automated 24/7 projection', TRUE, TRUE,'Module 5','Software Engineering Principles',1,797);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (21, '2021-08-29 15:09:23', 'Function-based human-resource forecast', TRUE, TRUE,'Module 4','Managerial Economics',8,3274);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (3, '2020-11-07 09:46:35', 'Implemented stable paradigm', TRUE, FALSE,'Lecture 1','Linear Algebra',5,1636);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (50, '2023-01-23 18:48:40', 'Object-based contextually-based frame', TRUE, FALSE,'Chapter 1','Environmental Thermodynamics',2,314);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (54, '2022-02-21 01:09:36', 'Optimized dedicated protocol', TRUE, TRUE,'Chapter 1','Linear Algebra',9,3768);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (35, '2021-05-20 09:47:38', 'Adaptive value-added data-warehouse', FALSE, TRUE,'Lecture 4','World Literature',2,3913);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (48, '2020-03-05 12:04:19', 'Configurable leading edge hierarchy', FALSE, FALSE,'Lecture 3','Contemporary Asian Literature',6,5850);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (12, '2020-04-26 00:19:22', 'Front-line transitional moratorium', FALSE, FALSE,'Module 1.1','African American History',2,7383);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (20, '2023-04-23 19:41:00', 'Integrated cohesive hardware', TRUE, FALSE,'Module 1.1','Behavioral Neuroscience',0,123);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (26, '2020-05-06 21:04:59', 'Fundamental tertiary orchestration', FALSE, TRUE,'Module 2','Introduction to Cognitive Psychology',6,8514);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (26, '2023-11-05 14:31:43', 'Multi-lateral actuating database', FALSE, FALSE,'Module 2','African American History',6,8514);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (34, '2023-06-05 01:55:48', 'Cross-platform real-time website', FALSE, FALSE,'Module 3','Microeconomics',4,9552);
INSERT INTO Notes (student_id, date_posted, note_content, reported, pinned, class_folder, student_folder, class_id, course_id) VALUES (49, '2021-02-09 02:26:30', 'Visionary empowering utilisation', FALSE, TRUE,'Module 1','Introduction to Cognitive Psychology',3,7509);

-- Student_Classes
INSERT INTO Student_Classes (student_id, course_id, class_id)
VALUES (1, 1001, 1),
       (2, 2001, 1),
       (3, 3001, 1);

INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (50, 3098, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (42, 2802, 7);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (11, 6258, 8);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (20, 6258, 8);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (26, 7008, 7);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (26, 8850, 9);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (13, 4248, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (31, 2633, 8);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (37, 2633, 8);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (9, 40, 7);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (59, 8850, 9);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (2, 5801, 5);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (45, 3876, 4);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (30, 123, 0);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (18, 5281, 7);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (55, 6258, 8);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (60, 3098, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (43, 3876, 4);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (43, 3597, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (23, 2633, 8);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (44, 3597, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (29, 4248, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (43, 702, 1);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (50, 3423, 2);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (40, 9404, 1);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (25, 8850, 9);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (51, 3597, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (35, 8850, 9);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (59, 4521, 3);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (31, 123, 0);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (39, 8551, 1);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (26, 6439, 0);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (50, 5426, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (16, 9108, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (39, 3844, 2);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (38, 9664, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (41, 6064, 5);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (9, 866, 5);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (41, 7383, 2);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (43, 8786, 8);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (56, 40, 7);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (50, 3274, 8);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (53, 314, 2);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (8, 3844, 2);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (6, 9404, 1);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (38, 3876, 4);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (9, 801, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (51, 866, 5);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (31, 3719, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (11, 3913, 2);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (55, 6258, 8);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (36, 3423, 2);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (60, 2219, 8);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (17, 726, 8);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (44, 3423, 2);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (24, 40, 7);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (46, 7383, 2);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (3, 5792, 0);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (42, 5850, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (36, 4248, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (2, 9206, 7);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (18, 3423, 2);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (27, 3913, 2);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (34, 797, 1);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (46, 1705, 2);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (4, 9552, 4);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (42, 314, 2);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (54, 726, 8);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (31, 5994, 0);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (23, 8551, 1);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (54, 5994, 0);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (19, 5281, 7);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (59, 5281, 7);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (44, 3406, 1);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (45, 5801, 5);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (15, 9404, 1);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (59, 3768, 9);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (59, 3913, 2);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (6, 5850, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (28, 8514, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (36, 6383, 2);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (50, 866, 5);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (55, 8551, 1);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (3, 8551, 1);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (52, 3913, 2);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (12, 3423, 2);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (49, 3844, 2);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (32, 2802, 7);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (10, 123, 0);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (10, 6258, 8);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (29, 3876, 4);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (34, 5277, 1);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (34, 2633, 8);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (43, 3098, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (39, 3406, 1);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (58, 9552, 4);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (11, 8786, 8);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (11, 3876, 4);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (43, 5792, 0);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (15, 4248, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (23, 6064, 5);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (55, 8551, 1);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (50, 9108, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (31, 866, 5);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (26, 797, 1);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (60, 5639, 4);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (2, 6064, 5);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (60, 9206, 7);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (46, 9404, 1);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (34, 726, 8);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (36, 3913, 2);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (8, 3597, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (54, 3658, 4);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (6, 5792, 0);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (48, 40, 7);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (55, 3406, 1);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (58, 6064, 5);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (47, 6258, 8);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (4, 3658, 4);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (37, 123, 0);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (20, 1705, 2);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (27, 9711, 0);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (9, 4231, 0);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (26, 6258, 8);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (16, 3274, 8);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (49, 3098, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (52, 3768, 9);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (15, 3844, 2);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (2, 9402, 7);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (55, 3406, 1);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (47, 3876, 4);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (30, 8514, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (24, 866, 5);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (54, 5277, 1);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (39, 2802, 7);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (12, 9091, 5);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (5, 123, 0);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (6, 3913, 2);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (4, 4248, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (15, 40, 7);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (16, 9711, 0);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (6, 801, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (21, 9664, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (43, 314, 2);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (28, 9404, 1);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (60, 2633, 8);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (48, 5277, 1);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (46, 4521, 3);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (34, 5426, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (24, 9206, 7);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (42, 5994, 0);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (26, 5277, 1);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (21, 5792, 0);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (40, 2219, 8);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (39, 40, 7);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (5, 123, 0);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (10, 3876, 4);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (20, 6258, 8);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (32, 3098, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (15, 4231, 0);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (24, 9711, 0);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (23, 4231, 0);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (1, 6383, 2);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (10, 4248, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (59, 8850, 9);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (28, 866, 5);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (27, 3719, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (51, 7008, 7);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (25, 5639, 4);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (38, 5792, 0);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (37, 3274, 8);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (7, 9206, 7);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (19, 314, 2);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (21, 5850, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (5, 9108, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (1, 7509, 3);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (32, 9402, 7);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (55, 5281, 7);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (19, 801, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (54, 8850, 9);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (31, 6258, 8);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (31, 4248, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (42, 3876, 4);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (20, 9603, 4);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (38, 8786, 8);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (28, 5801, 5);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (17, 9664, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (48, 5801, 5);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (60, 9091, 5);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (2, 9402, 7);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (43, 5281, 7);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (6, 9206, 7);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (10, 7509, 3);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (18, 9402, 7);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (49, 7008, 7);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (21, 9711, 0);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (53, 5994, 0);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (50, 5801, 5);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (5, 5639, 4);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (46, 8850, 9);

-- TAs
INSERT INTO TAs (first_name, last_name, email)
VALUES ('Tasmiha', 'Amir', 'amir.t@example.edu'),
       ('Alex', 'Peterson', 'peterson.a@example.edu'),
       ('Celine', 'Semaan', 'semaan.c@example.edu'),
       ('Neeti', 'Desai', 'desai.n@example.edu');

INSERT INTO TAs (first_name, last_name, email) VALUES ('first_name', 'last_name', 'email');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Steffane', 'Angear', 'sangear0@webnode.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Wheeler', 'Issitt', 'wissitt1@xinhuanet.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Eydie', 'Goskar', 'egoskar2@godaddy.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Natal', 'MacArthur', 'nmacarthur3@bravesites.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Raynard', 'Trevance', 'rtrevance4@netvibes.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Rowen', 'Samples', 'rsamples5@huffingtonpost.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Bobby', 'Slater', 'bslater6@purevolume.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Ella', 'Idale', 'eidale7@live.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Ronalda', 'Mitchelmore', 'rmitchelmore8@discuz.net');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Opaline', 'Cracoe', 'ocracoe9@amazon.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Nanete', 'Pagen', 'npagena@sogou.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Morten', 'Redmond', 'mredmondb@va.gov');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Olly', 'Tourry', 'otourryc@ft.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Leah', 'McPake', 'lmcpaked@ihg.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Almire', 'Blodget', 'ablodgete@blog.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Saxe', 'Bendley', 'sbendleyf@admin.ch');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Page', 'Schlagh', 'pschlaghg@ca.gov');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Jennine', 'Lamming', 'jlammingh@disqus.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Davin', 'Andrassy', 'dandrassyi@wikia.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Brnaba', 'Trevan', 'btrevanj@symantec.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Nanon', 'Gatman', 'ngatmank@privacy.gov.au');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Abran', 'Squibe', 'asquibel@whitehouse.gov');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Clywd', 'Ritchings', 'critchingsm@nbcnews.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Kleon', 'Londesborough', 'klondesboroughn@comsenz.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Tonie', 'Mathieu', 'tmathieuo@privacy.gov.au');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Genni', 'Vice', 'gvicep@ask.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Ody', 'Cundict', 'ocundictq@va.gov');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Innis', 'Gathwaite', 'igathwaiter@list-manage.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Tamiko', 'Suggett', 'tsuggetts@ca.gov');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Issy', 'Poundford', 'ipoundfordt@mail.ru');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Valerie', 'Glentz', 'vglentzu@unblog.fr');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Brooke', 'Carnilian', 'bcarnilianv@statcounter.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Ulrich', 'Murkitt', 'umurkittw@addthis.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Kirk', 'McCunn', 'kmccunnx@booking.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Blancha', 'Glenny', 'bglennyy@msu.edu');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Lebbie', 'Bennetts', 'lbennettsz@nature.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Chrisse', 'Donke', 'cdonke10@tinyurl.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Bernelle', 'Cadlock', 'bcadlock11@mac.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Arlyne', 'Conlon', 'aconlon12@epa.gov');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Morty', 'Benfell', 'mbenfell13@economist.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Tracey', 'Trotton', 'ttrotton14@accuweather.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Julita', 'Halfacree', 'jhalfacree15@icq.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Sela', 'Slograve', 'sslograve16@chicagotribune.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Augusta', 'Tallman', 'atallman17@craigslist.org');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Aguie', 'Nunnery', 'anunnery18@yolasite.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Becca', 'Lukacs', 'blukacs19@icio.us');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Evan', 'Blizard', 'eblizard1a@gravatar.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Hall', 'Ellor', 'hellor1b@feedburner.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Horst', 'Hawes', 'hhawes1c@freewebs.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Mendie', 'Novacek', 'mnovacek1d@kickstarter.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Bunni', 'McCreagh', 'bmccreagh1e@usgs.gov');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Finn', 'Edgington', 'fedgington1f@woothemes.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Jenifer', 'Gillbe', 'jgillbe1g@blogspot.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Sabra', 'Ballaam', 'sballaam1h@usatoday.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Gilemette', 'Heersma', 'gheersma1i@google.com.br');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Garrott', 'Norquoy', 'gnorquoy1j@yelp.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Phyllida', 'Caswall', 'pcaswall1k@comsenz.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Maury', 'Jennins', 'mjennins1l@hhs.gov');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Ardella', 'Frays', 'afrays1m@bing.com');
INSERT INTO TAs (first_name, last_name, email) VALUES ('Clemente', 'Shaplin', 'cshaplin1n@dyndns.org');

-- Classes_TAs
INSERT INTO Classes_TAs (course_id, class_id, ta_id)
VALUES (1001, 1, 1),
       (1001, 2, 1),
       (2001, 1, 2),
       (2001, 1, 3);

INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (7008, 7, 48);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (5281, 7, 42);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (4521, 3, 54);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (2219, 8, 15);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9108, 6, 51);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (6258, 8, 21);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (702, 1, 21);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3844, 2, 43);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3406, 1, 30);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (4231, 0, 37);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9091, 5, 30);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3768, 9, 32);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (5277, 1, 23);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3597, 6, 57);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9206, 7, 7);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (1705, 2, 23);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (5850, 6, 29);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (314, 2, 42);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (797, 1, 58);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (4248, 6, 34);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (6064, 5, 55);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (6383, 2, 25);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (5277, 1, 36);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (2633, 8, 9);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3406, 1, 43);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (4231, 0, 19);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (1705, 2, 30);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (6439, 0, 12);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3768, 9, 15);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9552, 4, 5);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9404, 1, 25);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (6383, 2, 37);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (5850, 6, 11);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9711, 0, 5);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (801, 6, 46);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (8850, 9, 13);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (797, 1, 55);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (314, 2, 14);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3913, 2, 6);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (2802, 7, 15);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (8551, 1, 19);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (866, 5, 45);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (8514, 6, 29);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9552, 4, 2);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (5281, 7, 39);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (6383, 2, 5);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3423, 2, 34);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9206, 7, 44);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (6383, 2, 27);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3597, 6, 6);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (8850, 9, 30);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (2633, 8, 39);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (5850, 6, 1);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9664, 6, 43);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3876, 4, 4);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (6383, 2, 44);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (866, 5, 32);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9404, 1, 5);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (7383, 2, 26);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (6064, 5, 33);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (4248, 6, 32);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3913, 2, 57);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (4248, 6, 51);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (1636, 5, 53);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (4521, 3, 58);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3768, 9, 28);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (5801, 5, 46);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (2802, 7, 5);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (7383, 2, 12);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (5639, 4, 33);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (726, 8, 12);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (702, 1, 14);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (702, 1, 39);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (7509, 3, 32);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9711, 0, 15);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3719, 6, 19);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (1636, 5, 16);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (5277, 1, 21);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (2219, 8, 59);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3876, 4, 14);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (5426, 6, 50);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (801, 6, 5);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (2633, 8, 13);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9404, 1, 42);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (1636, 5, 6);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9711, 0, 28);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (5277, 1, 11);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9404, 1, 36);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9402, 7, 58);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9404, 1, 3);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (4231, 0, 3);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3274, 8, 27);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (801, 6, 28);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3719, 6, 6);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (40, 7, 18);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9402, 7, 30);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3423, 2, 6);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (797, 1, 52);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (1705, 2, 18);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (8850, 9, 7);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (801, 6, 34);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9664, 6, 30);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (5639, 4, 2);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (1636, 5, 36);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (8850, 9, 30);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (1636, 5, 11);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9091, 5, 49);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (1705, 2, 58);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9711, 0, 32);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3913, 2, 14);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (801, 6, 46);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (8551, 1, 28);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (797, 1, 53);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (801, 6, 9);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (8514, 6, 13);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3719, 6, 28);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (6383, 2, 32);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (7383, 2, 50);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (6064, 5, 7);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (4248, 6, 21);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9664, 6, 47);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3719, 6, 18);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (6439, 0, 20);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3274, 8, 5);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (1705, 2, 50);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (702, 1, 22);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (5994, 0, 55);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (5277, 1, 12);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (8514, 6, 51);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (5801, 5, 43);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3597, 6, 4);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3423, 2, 21);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (1705, 2, 44);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9711, 0, 9);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (797, 1, 41);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (5277, 1, 56);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (123, 0, 28);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (5994, 0, 44);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (4248, 6, 2);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9206, 7, 32);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (4231, 0, 19);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9108, 6, 7);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (314, 2, 41);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3876, 4, 18);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (7008, 7, 17);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3406, 1, 46);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9404, 1, 33);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3658, 4, 24);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (4231, 0, 30);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3423, 2, 51);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (2633, 8, 12);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9206, 7, 29);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (726, 8, 54);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3768, 9, 53);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3913, 2, 52);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3597, 6, 57);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9552, 4, 37);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (1636, 5, 59);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3844, 2, 11);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (7509, 3, 19);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3876, 4, 54);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9091, 5, 51);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (8850, 9, 52);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (2219, 8, 33);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (7008, 7, 6);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (7383, 2, 43);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3913, 2, 2);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3597, 6, 55);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (8551, 1, 34);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (6064, 5, 33);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (5426, 6, 46);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (2219, 8, 6);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9603, 4, 49);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (726, 8, 60);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (314, 2, 9);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (797, 1, 54);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3719, 6, 9);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (797, 1, 14);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9404, 1, 48);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9402, 7, 18);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (4248, 6, 29);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3844, 2, 31);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3658, 4, 44);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (7509, 3, 52);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (123, 0, 60);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9206, 7, 57);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (7383, 2, 13);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (6439, 0, 12);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (726, 8, 7);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3658, 4, 11);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3913, 2, 56);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3098, 6, 2);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (8786, 8, 54);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (6439, 0, 58);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (7383, 2, 36);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (123, 0, 7);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (5426, 6, 24);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (8786, 8, 54);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (5994, 0, 25);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3844, 2, 28);

-- Comments
INSERT INTO Comments (note_id, student_id, ta_id, professor_id)
VALUES (1, NULL, 1, NULL), # posted by TA
       (2, 2, NULL, NULL), # posted by student
       (3, NULL, NULL, 1); # posted by professor

INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('06-23-2023 10:09:58', 35, 23, 11, 47);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('02-18-2023 01:06:25', 37, 34, 50, 22);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('10-22-2023 22:03:08', 46, 19, 38, 20);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('06-25-2023 07:54:58', 22, 33, 55, 46);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('04-19-2023 05:27:05', 27, 58, 28, 9);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('12-13-2023 10:07:39', 26, 31, 54, 41);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('10-11-2023 02:10:01', 46, 21, 24, 30);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('04-30-2023 21:01:55', 15, 60, 12, 32);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('08-12-2023 19:57:14', 30, 17, 3, 47);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('10-30-2023 10:07:51', 60, 41, 7, 30);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('11-15-2023 22:18:34', 22, 58, 56, 26);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('02-13-2023 15:10:54', 43, 4, 43, 41);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('08-2-2023 05:22:52', 40, 43, 44, 3);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('10-7-2023 00:49:00', 20, 7, 41, 46);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('08-26-2023 04:42:06', 26, 9, 17, 50);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('03-19-2023 03:00:57', 10, 15, 53, 28);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('03-5-2023 05:27:04', 55, 41, 54, 5);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('10-17-2023 06:36:06', 25, 5, 15, 6);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('04-2-2023 15:21:05', 2, 52, 18, 32);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('09-17-2023 03:37:48', 17, 39, 27, 30);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('11-2-2023 05:40:35', 53, 41, 2, 23);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('11-26-2023 03:29:43', 6, 9, 12, 40);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('06-19-2023 16:26:46', 44, 13, 48, 36);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('05-29-2023 19:32:12', 25, 43, 44, 37);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('06-12-2023 11:52:19', 47, 1, 2, 21);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('06-6-2023 23:09:05', 8, 55, 45, 18);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('11-19-2023 04:14:40', 39, 49, 22, 37);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('03-28-2023 11:17:20', 40, 48, 47, 19);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('01-24-2023 18:35:20', 56, 44, 36, 5);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('02-21-2023 08:49:46', 9, 9, 37, 7);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('08-3-2023 16:46:13', 38, 24, 54, 2);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('10-13-2023 05:04:52', 35, 30, 38, 15);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('06-8-2023 06:16:42', 23, 23, 30, 27);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('01-14-2023 15:04:36', 10, 19, 10, 38);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('07-15-2023 16:02:51', 23, 50, 17, 44);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('03-3-2023 17:20:49', 32, 34, 58, 16);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('04-9-2023 06:11:19', 35, 13, 21, 25);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('07-21-2023 00:59:21', 19, 35, 26, 1);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('12-26-2023 00:19:16', 23, 17, 48, 14);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('01-22-2023 04:39:29', 22, 18, 3, 11);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('05-1-2023 07:35:45', 39, 15, 38, 48);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('09-15-2023 04:54:02', 31, 40, 59, 42);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('10-29-2023 03:21:34', 29, 41, 9, 38);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('12-21-2023 10:53:05', 12, 46, 44, 47);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('12-6-2023 14:24:21', 11, 9, 20, 28);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('01-3-2023 09:08:50', 48, 44, 41, 2);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('11-26-2023 00:06:28', 29, 45, 11, 9);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('02-28-2023 04:03:55', 12, 40, 26, 7);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('12-20-2023 04:47:47', 48, 29, 13, 37);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('08-1-2023 12:39:55', 20, 20, 13, 50);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('10-25-2023 13:27:22', 50, 54, 36, 1);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('02-22-2023 11:47:23', 51, 57, 16, 22);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('05-21-2023 14:33:16', 52, 51, 2, 49);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('10-23-2023 16:44:06', 31, 25, 7, 41);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('01-15-2023 20:36:31', 50, 33, 34, 3);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('06-11-2023 02:45:30', 5, 56, 44, 7);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('08-11-2023 22:42:28', 50, 10, 15, 5);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('06-2-2023 15:03:06', 19, 26, 54, 37);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('09-24-2023 18:42:44', 25, 44, 59, 50);
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id) VALUES ('08-2-2023 03:08:45', 51, 15, 37, 28);

-- DepartmentAnnouncements
INSERT INTO DepartmentAnnouncements (department_name, announcement_id, content, administrator_id)
VALUES ('Computer Science', 1, 'Important Announcement for CS', 1),
       ('Mathematics', 2, 'Math Department Update', 2),
       ('Physics', 3, 'Physics Department News', 3);

INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (30, 'Division of Mathematics', '6/23/2022 10:09:58', 'Guest lecture announcement');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (2, 'Division of Philosophy', '2/18/2022 01:06:25', 'Change in class location');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (9, 'College of Music', '10/22/2022 22:03:08', 'Reminder: class participation requirements');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (26, 'College of Information Technology', '6/25/2022 07:54:58', 'Change in exam format announcement');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (25, 'Department of Chemistry', '4/19/2022 05:27:05', 'Reminder: assignment submission guidelines');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (17, 'Department of History', '12/13/2022 09:67:39', 'Change in class timings');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (5, 'School of Nursing', '10/11/2022 02:10:01', 'New resource added to course website');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (49, 'College of Health Sciences', '4/30/2022 21:01:55', 'Guest lecture announcement');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (18, 'School of Physical Education', '8/12/2022 19:57:14', 'Change in course prerequisites announcement');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (12, 'School of Public Health', '10/30/2022 10:07:51', 'Exciting project announcement');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (41, 'Department of History', '11/15/2022 22:18:34', 'Exciting project announcement');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (10, 'College of Music', '2/13/2022 15:10:54', 'Extra credit opportunity announced');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (38, 'College of Music', '8/2/2022 05:22:52', 'Exciting project announcement');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (26, 'Division of Geology', '10/7/2022 00:49:00', 'Excursion announcement');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (11, 'College of Music', '8/26/2022 04:42:06', 'Announcement: class mentorship program');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (17, 'College of Health Sciences', '3/19/2022 03:00:57', 'New reading material uploaded');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (37, 'School of Public Health', '3/5/2022 05:27:04', 'Reminder: group project proposal due');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (23, 'Division of Economics', '10/17/2022 06:36:06', 'Announcement: class debate');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (25, 'Department of History', '4/2/2022 15:21:05', 'Exciting guest speaker announcement');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (6, 'School of Physical Education', '9/17/2022 03:37:48', 'Announcement: class party');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (50, 'School of Public Health', '11/2/2022 05:40:35', 'Announcement: class study session');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (42, 'College of Music', '11/26/2022 03:29:43', 'Announcement: class registration deadline');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (46, 'College of Information Technology', '6/19/2022 16:26:46', 'Reminder: class participation requirements');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (21, 'Division of Philosophy', '5/29/2022 19:32:12', 'Reminder: class presentation guidelines');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (42, 'Department of Chemistry', '6/12/2022 11:52:19', 'Reminder: office hours extended');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (12, 'School of Nursing', '6/6/2022 23:09:05', 'Announcement: class debate');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (28, 'School of Physical Education', '11/19/2022 04:14:40', 'Important announcement: class rescheduled');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (39, 'Department of History', '3/28/2022 11:17:20', 'Study group formation announcement');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (50, 'Department of History', '1/24/2022 18:35:20', 'Change in exam format announcement');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (45, 'College of Health Sciences', '2/21/2022 08:49:46', 'Change in office hours');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (43, 'Division of Geology', '8/3/2022 16:46:13', 'Reminder: class presentation guidelines');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (39, 'School of Physical Education', '10/13/2022 05:04:52', 'Reminder: class project progress report due');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (32, 'College of Information Technology', '6/8/2022 06:16:42', 'Exciting project announcement');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (37, 'College of Music', '1/14/2022 15:04:36', 'Announcement: class debate');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (5, 'School of Physical Education', '7/15/2022 16:02:51', 'New resource added to course website');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (6, 'College of Music', '3/3/2022 17:20:49', 'Study group formation announcement');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (21, 'School of Physical Education', '4/9/2022 06:11:19', 'Announcement: class debate');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (28, 'School of Architecture', '7/21/2022 00:59:21', 'Announcement: class discussion topic');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (31, 'School of Physical Education', '12/25/2022 23:19:16', 'Reminder: assignment due next week');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (48, 'College of Information Technology', '1/22/2022 04:39:29', 'Announcement: class registration deadline');

-- OfficeHours
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date)
VALUES (1, 1001, 1, '10:00:00', '2023-01-01'),
       (2, 2001, 1, '14:00:00', '2023-01-02'),
       (3, 3001, 1, '09:30:00', '2023-01-03');

INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (43, 3423, 2, '21:55:00', '2020-09-23');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (50, 7008, 7, '19:26:00', '2020-07-31');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (42, 4231, 0, '13:12:00', '2021-03-22');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (23, 5281, 7, '13:04:00', '2020-08-29');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (25, 702, 1, '7:07:00', '2021-10-26');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (3, 797, 1, '7:44:00', '2021-01-18');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (3, 8786, 8, '22:35:00', '2023-03-01');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (47, 2219, 8, '13:25:00', '2020-09-22');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (35, 3597, 6, '8:47:00', '2020-11-18');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (3, 797, 1, '18:19:00', '2021-09-11');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (24, 3844, 2, '21:48:00', '2020-09-16');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (50, 2633, 8, '11:25:00', '2021-04-13');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (14, 4521, 3, '18:11:00', '2023-08-03');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (42, 3597, 6, '13:00:00', '2022-08-21');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (20, 5277, 1, '12:27:00', '2023-08-03');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (6, 3597, 6, '10:05:00', '2022-07-23');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (33, 5994, 0, '7:53:00', '2020-10-14');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (29, 9402, 7, '15:34:00', '2022-11-05');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (30, 123, 0, '12:52:00', '2021-11-10');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (18, 9404, 1, '14:16:00', '2020-08-08');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (24, 1705, 2, '18:01:00', '2022-12-28');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (23, 9603, 4, '13:49:00', '2020-04-28');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (26, 6439, 0, '7:39:00', '2020-03-15');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (41, 2802, 7, '8:13:00', '2023-06-25');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (50, 3597, 6, '11:15:00', '2022-03-02');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (4, 3597, 6, '18:07:00', '2022-08-12');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (56, 866, 5, '12:10:00', '2022-10-06');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (53, 7383, 2, '9:47:00', '2022-11-26');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (50, 3844, 2, '20:13:00', '2021-01-07');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (10, 5281, 7, '7:33:00', '2020-07-31');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (53, 9711, 0, '16:01:00', '2023-06-02');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (22, 8514, 6, '15:32:00', '2020-08-28');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (47, 3768, 9, '14:43:00', '2023-06-22');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (36, 797, 1, '22:48:00', '2022-05-04');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (31, 9552, 4, '18:35:00', '2021-03-15');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (1, 5426, 6, '12:36:00', '2020-07-13');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (9, 40, 7, '12:47:00', '2023-02-12');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (33, 7383, 2, '17:49:00', '2023-07-17');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (41, 6439, 0, '9:32:00', '2023-08-31');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (14, 1636, 5, '8:59:00', '2020-02-06');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (34, 9091, 5, '19:49:00', '2023-02-26');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (50, 5994, 0, '7:13:00', '2020-11-14');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (28, 9091, 5, '9:03:00', '2020-12-01');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (7, 797, 1, '7:41:00', '2020-04-29');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (59, 3597, 6, '12:01:00', '2022-07-18');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (20, 3597, 6, '14:09:00', '2022-02-19');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (37, 9711, 0, '10:46:00', '2023-11-27');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (23, 9603, 4, '18:11:00', '2021-06-16');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (1, 5281, 7, '19:06:00', '2022-08-29');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (3, 3658, 4, '18:17:00', '2021-12-21');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (49, 4521, 3, '11:51:00', '2020-05-03');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (12, 314, 2, '8:05:00', '2022-08-21');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (28, 4521, 3, '20:03:00', '2023-11-06');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (42, 9402, 7, '22:30:00', '2020-04-27');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (49, 4521, 3, '12:05:00', '2022-02-22');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (56, 9603, 4, '19:55:00', '2022-03-03');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (26, 3913, 2, '7:31:00', '2022-12-15');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (17, 9711, 0, '13:11:00', '2021-10-07');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (17, 8786, 8, '21:48:00', '2022-05-19');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (17, 6439, 0, '9:40:00', '2022-10-31');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (21, 2633, 8, '9:35:00', '2020-03-19');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (17, 5850, 6, '10:37:00', '2023-08-22');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (9, 6064, 5, '20:56:00', '2022-11-20');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (52, 3658, 4, '9:04:00', '2020-03-23');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (16, 8514, 6, '11:11:00', '2021-06-03');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (10, 8514, 6, '18:37:00', '2022-04-09');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (51, 5994, 0, '22:21:00', '2020-03-15');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (7, 7509, 3, '16:05:00', '2023-09-27');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (15, 5281, 7, '10:12:00', '2022-09-20');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (29, 3098, 6, '14:06:00', '2022-01-31');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (26, 8551, 1, '13:01:00', '2023-03-28');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (19, 1636, 5, '18:32:00', '2023-09-16');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (41, 1705, 2, '16:58:00', '2020-04-09');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (21, 6064, 5, '9:03:00', '2023-05-12');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (34, 1636, 5, '16:09:00', '2022-06-08');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (34, 2802, 7, '7:37:00', '2022-12-31');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (29, 9552, 4, '16:43:00', '2023-01-04');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (17, 5281, 7, '8:25:00', '2021-07-31');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (30, 702, 1, '11:46:00', '2020-09-24');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (7, 5426, 6, '9:31:00', '2020-06-20');

-- Department_TAs
INSERT INTO Department_TAs (department_name, ta_id)
VALUES ('Computer Science', 1),
       ('Mathematics', 2),
       ('Physics', 3);

INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 11);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Chemistry', 60);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Music', 15);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Information Technology', 27);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Physical Education', 38);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Information Technology', 52);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 59);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Physical Education', 6);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Nursing', 41);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Chemistry', 7);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Philosophy', 40);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Information Technology', 29);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 19);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Information Technology', 11);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 39);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 39);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Information Technology', 9);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Geology', 10);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Chemistry', 2);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Information Technology', 53);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 4);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Physical Education', 11);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Nursing', 56);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 43);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Geology', 11);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Health Sciences', 39);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Music', 45);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 45);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Communication', 3);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Music', 23);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Mathematics', 14);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 52);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Philosophy', 10);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Geology', 35);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Economics', 52);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 35);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Communication', 28);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 58);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 40);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Mathematics', 53);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Philosophy', 59);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Music', 23);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Engineering', 47);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Physical Education', 41);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Music', 28);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Geology', 25);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Graphic Design', 33);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 52);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Philosophy', 3);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Mathematics', 49);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Physical Education', 34);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Nursing', 25);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Social Sciences', 29);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 19);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Health Sciences', 17);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Economics', 34);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 11);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 40);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Graphic Design', 7);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 53);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Chemistry', 6);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Communication', 37);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 39);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Graphic Design', 12);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Physical Education', 33);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Economics', 34);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Music', 35);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Architecture', 23);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Information Technology', 43);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Music', 17);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 45);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Mathematics', 14);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Graphic Design', 28);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Music', 32);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Communication', 6);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Geology', 54);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Social Sciences', 50);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 28);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Social Sciences', 15);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Mathematics', 2);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Information Technology', 12);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Music', 59);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Graphic Design', 48);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Graphic Design', 25);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Chemistry', 37);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Physical Education', 11);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Music', 28);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Health Sciences', 25);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 36);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Chemistry', 53);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Philosophy', 7);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 49);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Mathematics', 24);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Information Technology', 52);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Philosophy', 34);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Physical Education', 59);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Health Sciences', 55);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Economics', 5);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Economics', 28);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Graphic Design', 12);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 16);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 9);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 47);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Mathematics', 12);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Philosophy', 4);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Music', 23);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Architecture', 11);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Music', 42);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Health Sciences', 30);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Physical Education', 42);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 23);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Health Sciences', 26);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Physical Education', 37);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Architecture', 2);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Nursing', 14);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Nursing', 42);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 5);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Information Technology', 49);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Music', 30);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 2);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 28);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Music', 40);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Graphic Design', 25);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Graphic Design', 43);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 46);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Health Sciences', 8);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Architecture', 13);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Philosophy', 37);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Social Sciences', 20);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 22);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Health Sciences', 48);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Graphic Design', 41);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Geology', 35);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Communication', 1);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Health Sciences', 7);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Health Sciences', 55);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Philosophy', 26);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Social Sciences', 3);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Chemistry', 33);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Philosophy', 12);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Chemistry', 51);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Health Sciences', 12);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Nursing', 2);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Communication', 56);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Communication', 6);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 60);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Geology', 1);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 38);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Health Sciences', 45);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Physical Education', 38);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Geology', 59);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Geology', 4);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Philosophy', 28);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Communication', 25);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Chemistry', 32);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Philosophy', 40);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Chemistry', 46);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Music', 33);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 16);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Nursing', 56);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Economics', 45);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 16);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Information Technology', 48);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Economics', 12);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Geology', 28);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 20);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Philosophy', 6);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Philosophy', 9);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Nursing', 1);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Information Technology', 50);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Information Technology', 26);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Nursing', 41);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Engineering', 49);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Social Sciences', 8);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Information Technology', 34);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Nursing', 11);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Health Sciences', 24);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 26);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Chemistry', 20);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 22);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Social Sciences', 26);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 8);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Music', 13);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 5);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Philosophy', 49);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 24);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Chemistry', 60);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Chemistry', 35);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 54);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Graphic Design', 38);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Health Sciences', 36);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Engineering', 17);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Chemistry', 1);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 40);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Social Sciences', 41);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Health Sciences', 29);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Communication', 32);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 48);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 34);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Engineering', 57);

-- OHLocations
INSERT INTO OHLocations (ta_id, course_id, class_id, date, time, location)
VALUES (1, 1001, 1, '2023-01-01', '10:00:00', 'Cargill 097'),
       (2, 2001, 1, '2023-01-02', '14:00:00', 'https://example.zoom.us/j/123456789'),
       (3, 3001, 1, '2023-01-03', '09:30:00', 'Robinson 305');

INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (46, 7509, 3, '2023-08-03', '12:27:00', 'Room 401 - Philosophy Discussion Room; Technology Hub: Room 110 - Computer Science Lab');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (41, 801, 6, '2023-03-22', '13:12:00', 'Room 420 - Sports Medicine Workshop');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (33, 9552, 4, '2023-06-02', '16:01:00', 'Room 330 - Cybersecurity Workshop; Fine Arts Studio: Room 201 - Painting Studio');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (2, 866, 5, '2023-11-14', '7:13:00', 'Room 220 - Data Analytics Classroom');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (30, 4521, 3, '2023-08-28', '15:32:00', 'Room 308 - Physics Seminar Room');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (35, 2802, 7, '2023-12-31', '7:37:00', 'Room 320 - Mandarin Chinese Classroom; Health Sciences Building: Room 106 - Nursing Simulation Lab');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (45, 726, 8, '2023-02-22', '12:05:00', 'Room 420 - Sports Medicine Workshop');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (55, 3913, 2, '2023-08-03', '18:11:00', 'Room 308 - Physics Seminar Room');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (3, 5281, 7, '2023-09-20', '10:12:00', 'Room 420 - Sports Medicine Workshop');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (11, 3876, 4, '2023-10-26', '7:07:00', 'Room 420 - Sports Medicine Workshop');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (45, 9404, 1, '2023-10-14', '7:53:00', 'Room 415 - Photography Darkroom; Business Complex: Room 103 - Marketing Classroom');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (46, 9664, 6, '2023-03-02', '11:15:00', 'Science Center: Room 101 - Biology Lecture Hall');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (31, 8786, 8, '2023-05-03', '11:51:00', 'Room 420 - Sports Medicine Workshop');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (41, 1705, 2, '2023-08-12', '18:07:00', 'https://zoom.us/j/5555555555');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (16, 4521, 3, '2023-08-21', '8:05:00', 'Room 401 - Philosophy Discussion Room; Technology Hub: Room 110 - Computer Science Lab');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (27, 3406, 1, '2023-08-21', '8:05:00', 'Room 215 - History Lecture Hall');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (12, 3658, 4, '2023-04-28', '13:49:00', 'Science Center: Room 101 - Biology Lecture Hall');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (17, 9404, 1, '2023-02-06', '8:59:00', 'https://zoom.us/j/5555555555');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (5, 1705, 2, '2023-03-22', '13:12:00', 'Room 210 - Spanish Conversation Room');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (35, 4248, 6, '2023-06-20', '9:31:00', 'Room 335 - Anthropology Discussion Room; Language Center: Room 104 - French Language Lab');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (6, 3406, 1, '2023-08-21', '13:00:00', 'Science Center: Room 101 - Biology Lecture Hall');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (60, 5801, 5, '2023-09-11', '18:19:00', 'Room 305 - Sculpture Workshop');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (4, 3658, 4, '2023-05-04', '22:48:00', 'Room 215 - Public Health Classroom');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (26, 9404, 1, '2023-06-08', '16:09:00', 'Room 401 - Philosophy Discussion Room; Technology Hub: Room 110 - Computer Science Lab');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (39, 6439, 0, '2023-10-31', '9:40:00', 'Room 330 - Cybersecurity Workshop; Fine Arts Studio: Room 201 - Painting Studio');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (43, 6064, 5, '2023-06-25', '8:13:00', 'Room 225 - Sociology Classroom');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (27, 5281, 7, '2023-04-29', '7:41:00', 'https://zoom.us/j/5555555555');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (36, 5426, 6, '2023-02-06', '8:59:00', 'Room 305 - Sculpture Workshop');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (6, 8850, 9, '2023-04-29', '7:41:00', 'Room 310 - Entrepreneurship Lab; Social Sciences Wing: Room 111 - Psychology Lecture Hall');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (9, 866, 5, '2023-02-06', '8:59:00', 'Room 215 - Public Health Classroom');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (49, 1636, 5, '2023-12-31', '7:37:00', 'Room 320 - Mandarin Chinese Classroom; Health Sciences Building: Room 106 - Nursing Simulation Lab');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (9, 6258, 8, '2023-06-16', '18:11:00', 'Room 401 - Philosophy Discussion Room; Technology Hub: Room 110 - Computer Science Lab');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (19, 9091, 5, '2023-01-18', '7:44:00', 'Room 420 - Sports Medicine Workshop');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (50, 5994, 0, '2023-02-12', '12:47:00', 'Room 207 - Finance Seminar Room');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (59, 3876, 4, '2023-09-20', '10:12:00', 'https://zoom.us/j/5555555555');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (43, 3844, 2, '2023-03-02', '11:15:00', 'Room 330 - Cybersecurity Workshop; Fine Arts Studio: Room 201 - Painting Studio');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (35, 8514, 6, '2023-02-06', '8:59:00', 'Room 308 - Physics Seminar Room');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (36, 9402, 7, '2023-08-03', '18:11:00', 'Room 415 - Photography Darkroom; Business Complex: Room 103 - Marketing Classroom');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (16, 7383, 2, '2023-05-04', '22:48:00', 'Room 420 - Sports Medicine Workshop');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (36, 5801, 5, '2023-03-28', '13:01:00', 'Room 330 - Cybersecurity Workshop; Fine Arts Studio: Room 201 - Painting Studio');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (30, 5639, 4, '2023-09-23', '21:55:00', 'Room 415 - Photography Darkroom; Business Complex: Room 103 - Marketing Classroom');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (46, 5801, 5, '2023-07-31', '7:33:00', 'Room 308 - Physics Seminar Room');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (44, 3597, 6, '2023-11-26', '9:47:00', 'Science Center: Room 101 - Biology Lecture Hall');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (60, 314, 2, '2023-02-19', '14:09:00', 'Room 207 - Finance Seminar Room');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (48, 123, 0, '2023-10-31', '9:40:00', 'Room 308 - Physics Seminar Room');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (21, 8514, 6, '2023-03-02', '11:15:00', 'Room 215 - History Lecture Hall');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (39, 2802, 7, '2023-08-28', '15:32:00', 'Room 415 - Photography Darkroom; Business Complex: Room 103 - Marketing Classroom');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (48, 9402, 7, '2023-09-20', '10:12:00', 'Room 305 - Sculpture Workshop');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (46, 866, 5, '2023-04-09', '18:37:00', 'Room 415 - Photography Darkroom; Business Complex: Room 103 - Marketing Classroom');