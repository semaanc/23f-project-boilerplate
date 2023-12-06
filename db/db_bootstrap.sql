-- This file is to bootstrap a database for the CS3200 project.

-- Create a new database.  You can change the name later.  You'll
-- need this name in the FLASK API file(s),  the AppSmith
-- data source creation.
drop database notetastic
create database if not exists notetastic;

-- Via the Docker Compose file, a special user called webapp will
-- be created in MySQL. We are going to grant that user
-- all privilages to the new database we just created.
-- TODO: If you changed the name of the database above, you need
-- to change it here too.
grant all privileges on notetastic.* to 'webapp'@'%';
flush privileges;

-- Move into the database we just created.
-- TODO: If you changed the name of the database above, you need to
-- change it here too.
use notetastic;

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
        ON UPDATE CASCADE ON DELETE cascade
);

CREATE TABLE IF NOT EXISTS Departments_Professors
(
    department_name VARCHAR(45),
    professor_id    INT,
    PRIMARY KEY (department_name, professor_id),
    FOREIGN KEY (department_name)
        REFERENCES Departments (department_name)
        ON UPDATE CASCADE ON DELETE cascade,
    FOREIGN KEY (professor_id)
        REFERENCES Professors (professor_id)
        ON UPDATE CASCADE ON DELETE cascade
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
        ON UPDATE CASCADE ON DELETE cascade,
    FOREIGN KEY (student_id) REFERENCES Students (student_id)
        ON UPDATE CASCADE ON DELETE cascade
);



CREATE TABLE IF NOT EXISTS Classes
(
    course_id       INTEGER,
    class_id        INTEGER,
    course_name     VARCHAR(100) NOT NULL,
    professor_id    INTEGER,
    department_name VARCHAR(45),

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
        ON UPDATE CASCADE ON DELETE cascade,
    FOREIGN KEY (student_folder)
        REFERENCES StudentFolders (folder_name)
        ON UPDATE CASCADE ON DELETE cascade,
    FOREIGN KEY (class_folder, course_id, class_id)
        REFERENCES ClassFolders (folder_name, course_id, class_id)
        ON UPDATE CASCADE ON DELETE cascade
);

CREATE TABLE IF NOT EXISTS Student_Classes
(
    student_id INT,
    course_id  INT,
    class_id   INT,
    PRIMARY KEY (student_id, course_id, class_id),
    FOREIGN KEY (student_id)
        REFERENCES Students (student_id)
        ON UPDATE CASCADE ON DELETE cascade,
    FOREIGN KEY (course_id, class_id)
        REFERENCES Classes (course_id, class_id)
        ON UPDATE CASCADE ON DELETE cascade
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
        ON UPDATE CASCADE ON DELETE cascade,
    FOREIGN KEY (ta_id)
        REFERENCES TAs (ta_id)
        ON UPDATE CASCADE ON DELETE cascade
);

CREATE TABLE IF NOT EXISTS Comments
(
    comment_id   INT AUTO_INCREMENT PRIMARY KEY,
    comment_content TEXT NOT NULL,
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
    announcement_id  INT AUTO_INCREMENT,
    date_posted      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    content          TEXT     NOT NULL,
    department_name  VARCHAR(45),
    administrator_id INT      NOT NULL,
    PRIMARY KEY (announcement_id),
    FOREIGN KEY (department_name)
        REFERENCES Departments (department_name)
        ON UPDATE cascade ON DELETE cascade,
    FOREIGN KEY (administrator_id)
        REFERENCES DepartmentAdministrators (administrator_id)
        ON UPDATE cascade ON DELETE cascade
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
        ON UPDATE cascade ON DELETE cascade,
    FOREIGN KEY (ta_id)
        REFERENCES TAs (ta_id)
        ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE IF NOT EXISTS Department_TAs
(
    department_name VARCHAR(45),
    ta_id           INT,
    PRIMARY KEY (department_name, ta_id),
    FOREIGN KEY (department_name)
        REFERENCES Departments (department_name)
        ON UPDATE cascade ON DELETE cascade,
    FOREIGN KEY (ta_id)
        REFERENCES TAs (ta_id)
        ON UPDATE cascade ON DELETE cascade
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
        ON UPDATE CASCADE ON DELETE cascade
);

-- Mock Data

-- Professors
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

INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (5801, 5, 'Data Structures and Algorithms', 28, 'School of Nursing');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (5994, 0, 'Cultural Anthropology', 41, 'College of Communication');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (5277, 1, 'Environmental Science and Sustainability', 10, 'Division of Social Sciences');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (797, 1, 'Fine Arts Workshop', 36, 'School of Nursing');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (6258, 8, 'Cognitive Psychology', 47, 'Division of Social Sciences');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (726, 8, 'Jazz Studies and Performance', 45, 'Division of Social Sciences');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (9404, 1, 'Cognitive Psychology', 24, 'College of Communication');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (9711, 0, 'Organic Chemistry Principles', 15, 'School of Public Health');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (8850, 9, 'Historical Geology', 20, 'College of Music');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (9402, 7, 'Financial Accounting Principles', 8, 'College of Information Technology');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (8551, 1, 'Mathematical Logic and Set Theory', 4, 'College of Information Technology');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (7008, 7, 'Media and Society', 40, 'Division of Philosophy');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (2633, 8, 'Linguistic Analysis and Theory', 18, 'School of Public Health');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (5850, 6, 'Media and Society', 38, 'College of Music');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (866, 5, 'Abnormal Psychology', 13, 'Department of Chemistry');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (5792, 0, 'Sociology of Globalization', 7, 'School of Public Health');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (3406, 1, 'Data Structures and Algorithms', 20, 'College of Information Technology');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (9664, 6, 'Sociology of Globalization', 47, 'Division of Economics');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (3597, 6, 'Marketing Management', 27, 'School of Nursing');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (2219, 8, 'Ethics in Philosophy', 27, 'Department of History');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (6439, 0, 'Marketing Management', 44, 'Division of Social Sciences');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (9603, 4, 'Film Studies and Criticism', 45, 'School of Public Health');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (1636, 5, 'Cellular Biology and Genetics', 22, 'School of Nursing');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (123, 0, 'Business Ethics and Corporate Governance', 48, 'College of Health Sciences');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (3768, 9, 'World History: Ancient to Modern', 38, 'Division of Philosophy');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (6064, 5, 'Microeconomics Principles', 25, 'Division of Geology');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (314, 2, 'World History: Ancient to Modern', 22, 'Division of Social Sciences');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (4248, 6, 'Cellular Biology and Genetics', 23, 'School of Public Health');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (3876, 4, 'Pediatric Nursing Practice', 12, 'College of Communication');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (3098, 6, 'Organic Chemistry Principles', 2, 'College of Information Technology');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (9206, 7, 'Marketing Management', 9, 'Department of Chemistry');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (3719, 6, 'Advanced Calculus and Analysis', 10, 'School of Public Health');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (7383, 2, 'Philosophy of Mind', 36, 'School of Nursing');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (2802, 7, 'Cellular Biology and Genetics', 2, 'Department of Graphic Design');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (4521, 3, 'Ethics in Philosophy', 32, 'School of Nursing');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (5639, 4, 'Molecular Biology Techniques', 48, 'School of Public Health');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (7509, 3, 'Geopolitics and Global Governance', 33, 'Division of Philosophy');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (3913, 2, 'Jazz Studies and Performance', 41, 'School of Architecture');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (702, 1, 'Film Studies and Criticism', 46, 'School of Physical Education');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (5281, 7, 'Sociology of Globalization', 30, 'Department of History');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (9552, 4, 'Educational Psychology', 9, 'School of Physical Education');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (3423, 2, 'Sociology of Globalization', 8, 'College of Health Sciences');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (4231, 0, 'Electrical Engineering Lab', 43, 'Division of Mathematics');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (3844, 2, 'Medical Anthropology', 41, 'Department of History');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (40, 7, 'Educational Psychology', 50, 'Division of Philosophy');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (8786, 8, 'Mechanical Engineering Fundamentals', 41, 'Department of Chemistry');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (9108, 6, 'Health Policy and Administration', 10, 'College of Information Technology');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (9091, 5, 'Web Design and Development', 9, 'School of Public Health');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (801, 6, 'Electrical Engineering Lab', 43, 'Department of Graphic Design');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (3658, 4, 'Information Systems Management', 27, 'College of Information Technology');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (5426, 6, 'Environmental Science and Sustainability', 48, 'College of Engineering');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (6383, 2, 'Abnormal Psychology', 30, 'College of Communication');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (8514, 6, 'Graphic Design Principles', 15, 'College of Information Technology');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (3274, 8, 'Linguistic Analysis and Theory', 6, 'College of Music');
INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) VALUES (1705, 2, 'Mechanical Engineering Fundamentals', 14, 'College of Communication');

-- ClassFolders

INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Chapter 3', '2021-05-21 19:59:42', 5639, 4);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 2', '2020-10-02 02:25:13', 9108, 6);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Chapter 4', '2021-06-03 00:57:42', 9402, 7);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 5.1', '2021-02-04 21:55:06', 5801, 5);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 1.1', '2021-02-09 19:04:19', 3913, 2);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 3', '2020-01-10 06:28:15', 5850, 6);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Chapter 2', '2021-07-08 18:31:27', 40, 7);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 1.1', '2020-04-25 18:51:11', 6383, 2);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Chapter 1', '2021-06-25 06:23:32', 2219, 8);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 4', '2021-06-30 10:21:37', 9404, 1);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 4', '2021-03-10 09:18:55', 4521, 3);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 3', '2020-03-29 15:21:55', 9091, 5);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 5', '2021-11-23 17:50:28', 6439, 0);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Chapter 1', '2020-12-11 01:48:34', 3768, 9);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 5.1', '2020-10-22 01:45:24', 314, 2);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 1', '2021-09-10 19:58:41', 3098, 6);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 5', '2020-12-27 13:25:15', 797, 1);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 4.1', '2021-03-04 17:42:26', 797, 1);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 3.1', '2021-04-16 03:30:41', 3597, 6);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Lecture 3', '2021-10-09 20:32:44', 5850, 6);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 5', '2020-09-26 00:49:45', 5792, 0);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Chapter 5', '2021-04-15 05:28:38', 4231, 0);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Lecture 1', '2021-07-18 09:32:19', 1636, 5);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 1.1', '2021-06-01 13:36:29', 123, 0);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 2.1', '2020-12-06 08:36:08', 2633, 8);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Chapter 2', '2021-06-09 07:54:52', 702, 1);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 3', '2021-01-14 04:16:51', 9552, 4);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 2', '2021-02-28 21:33:21', 8514, 6);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Lecture 3', '2021-02-27 08:26:35', 797, 1);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 1.1', '2021-08-08 06:32:10', 8850, 9);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 3', '2020-04-06 15:06:27', 1705, 2);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 3.1', '2021-09-01 04:33:58', 9206, 7);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 4', '2021-11-10 08:31:59', 3274, 8);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Chapter 4', '2021-02-16 10:35:58', 2219, 8);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 1', '2021-01-02 16:54:15', 3913, 2);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 2.1', '2021-04-01 06:47:33', 40, 7);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Lecture 2', '2021-08-05 16:15:16', 3719, 6);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Lecture 1', '2021-11-20 06:50:26', 5277, 1);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 3', '2020-10-04 01:19:56', 2219, 8);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 1', '2021-05-14 23:00:17', 2633, 8);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 5.1', '2020-11-08 08:58:08', 5277, 1);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 3.1', '2021-01-12 21:54:09', 5994, 0);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 5', '2021-03-19 04:58:34', 7008, 7);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 1.1', '2021-07-08 20:17:46', 4231, 0);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Chapter 3', '2021-11-01 20:05:45', 702, 1);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Lecture 4', '2021-10-18 21:28:20', 3913, 2);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Lecture 2', '2020-06-26 04:31:09', 1636, 5);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Lecture 1', '2021-05-28 07:45:09', 5639, 4);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 5.1', '2021-10-13 05:37:03', 123, 0);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Chapter 3', '2020-01-18 16:51:10', 3768, 9);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 4', '2020-02-17 20:44:39', 1636, 5);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 3.1', '2021-10-24 13:25:52', 6258, 8);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Lecture 4', '2021-11-20 08:35:21', 3597, 6);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 4.1', '2021-12-12 08:30:45', 40, 7);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 2.1', '2021-01-09 02:47:04', 9552, 4);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Chapter 3', '2021-10-08 00:30:25', 801, 6);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 1.1', '2021-02-08 12:55:52', 7383, 2);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 1', '2021-08-01 18:00:40', 7509, 3);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 3.1', '2021-07-28 04:17:47', 3876, 4);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Chapter 1', '2021-02-04 11:48:59', 9552, 4);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 1', '2021-03-16 21:50:31', 4231, 0);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 2', '2020-05-02 08:25:31', 123, 0);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 3', '2021-05-14 06:27:47', 2633, 8);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Module 1', '2021-08-17 23:08:00', 1636, 5);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Lecture 1', '2021-06-06 20:10:52', 5792, 0);
INSERT INTO ClassFolders (folder_name, date_created, course_id, class_id) VALUES ('Chapter 1', '2020-03-14 23:31:56', 314, 2);

-- StudentFolders

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
INSERT INTO StudentFolders (folder_name, date_created, student_id) VALUES ('Fundamentals of Computer Science', '2023-06-20 03:07:25', 40);
-- Notes

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
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (10, 3876, 4);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (32, 3098, 6);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (15, 4231, 0);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (24, 9711, 0);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (23, 4231, 0);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (1, 6383, 2);
INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (10, 4248, 6);
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
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (1636, 5, 11);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9091, 5, 49);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (1705, 2, 58);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (9711, 0, 32);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3913, 2, 14);
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
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (726, 8, 7);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3658, 4, 11);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3913, 2, 56);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3098, 6, 2);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (8786, 8, 54);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (6439, 0, 58);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (7383, 2, 36);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (123, 0, 7);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (5426, 6, 24);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (5994, 0, 25);
INSERT INTO Classes_TAs (course_id, class_id, ta_id) VALUES (3844, 2, 28);

-- Comments

INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-06-23 10:09:58', 35, NULL, NULL, 47, 'ut mauris eget massa tempor convallis nulla neque libero convallis');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-02-18 01:06:25', 37, NULL, NULL, 22, 'in porttitor pede justo eu massa donec dapibus duis at velit eu est');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-10-22 22:03:08', 46, NULL, NULL, 20, 'cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-06-25 07:54:58', 22, NULL, NULL, 46, 'at turpis donec posuere metus vitae ipsum aliquam non mauris');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-04-19 05:27:05', 27, NULL, NULL, 9, 'convallis eget eleifend luctus ultricies eu nibh quisque id justo');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-12-13 10:07:39', 26, NULL, NULL, 41, 'platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-10-11 02:10:01', 46, NULL, NULL, 30, 'semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-04-30 21:01:55', 15, NULL, NULL, 32, 'morbi porttitor lorem id ligula suspendisse ornare consequat lectus in');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-08-12 19:57:14', 30, NULL, NULL, 47, 'adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-10-30 10:07:51', 60, NULL, NULL, 30, 'amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-11-15 22:18:34', 22, NULL, NULL, 26, 'sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-02-13 15:10:54', 43, NULL, NULL, 41, 'suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-08-02 05:22:52', 40, NULL, NULL, 3, 'quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-10-07 00:49:00', 20, NULL, NULL, 46, 'in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-08-26 04:42:06', 26, NULL, NULL, 50, 'lobortis sapien sapien non mi integer ac neque duis bibendum morbi non');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-03-19 03:00:57', 10, NULL, NULL, 28, 'metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-03-05 05:27:04', 55, NULL, NULL, 5, 'mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-10-17 06:36:06', 25, NULL, NULL, 6, 'posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-04-02 15:21:05', 2, NULL, NULL, 32, 'ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-09-17 03:37:48', 17, NULL, 27, NULL, 'etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-11-02 05:40:35', 53, NULL, 2, NULL, 'semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at diam');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-11-26 03:29:43', 6, NULL, 12, NULL, 'ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-06-19 16:26:46', 44, NULL, 48, NULL, 'amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-05-29 19:32:12', 25, NULL, 44, NULL, 'sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-06-12 11:52:19', 47, NULL, 2, NULL, 'mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-06-06 23:09:05', 8, NULL, 45, NULL, 'et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-11-19 04:14:40', 39, NULL, 22, NULL, 'mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-03-28 11:17:20', 40, NULL, 47, NULL, 'vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-01-24 18:35:20', 56, NULL, 36, NULL, 'velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-02-21 08:49:46', 9, NULL, 37, NULL, 'erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-08-03 16:46:13', 38, NULL, 54, NULL, 'interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-10-13 05:04:52', 35, NULL, 38, NULL, 'justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-06-08 06:16:42', 23, NULL, 30, NULL, 'aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-01-14 15:04:36', 10, NULL, 10, NULL, 'molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-07-15 16:02:51', 23, NULL, 17, NULL, 'justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-03-03 17:20:49', 32, NULL, 58, NULL, 'ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-04-09 06:11:19', 35, NULL, 21, NULL, 'ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-07-21 00:59:21', 19, NULL, 26, NULL, 'ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-12-26 00:19:16', 23, NULL, 48, NULL, 'nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-01-22 04:39:29', 22, 18, NULL, NULL, 'aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-05-01 07:35:45', 39, 15, NULL, NULL, 'amet sem fusce consequat nulla nisl nunc nisl duis bibendum');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-09-15 04:54:02', 31, 40, NULL, NULL, 'ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-10-29 03:21:34', 29, 41, NULL, NULL, 'dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-12-21 10:53:05', 12, 46, NULL, NULL, 'sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-12-06 14:24:21', 11, 9, NULL, NULL, 'ac nulla sed vel enim sit amet nunc viverra dapibus');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-01-03 09:08:50', 48, 44, NULL, NULL, 'tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-11-26 00:06:28', 29, 45, NULL, NULL, 'aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-02-28 04:03:55', 12, 40, NULL, NULL, 'arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-12-20 04:47:47', 48, 29, NULL, NULL, 'pellentesque volutpat dui maecenas tristique est et tempus semper est quam');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-08-01 12:39:55', 20, 20, NULL, NULL, 'placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-10-25 13:27:22', 50, 54, NULL, NULL, 'in sagittis dui vel nisl duis ac nibh fusce lacus purus');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-02-22 11:47:23', 51, 57, NULL, NULL, 'justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-05-21 14:33:16', 52, 51, NULL, NULL, 'et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-10-23 16:44:06', 31, 25, NULL, NULL, 'rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-01-15 20:36:31', 50, 33, NULL, NULL, 'vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-06-11 02:45:30', 5, 56, NULL, NULL, 'lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-08-11 22:42:28', 50, 10, NULL, NULL, 'ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-06-02 15:03:06', 19, 26, NULL, NULL, 'nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-09-24 18:42:44', 25, 44, NULL, NULL, 'arcu libero rutrum ac lobortis vel dapibus at diam nam tristique');
INSERT INTO Comments (date_posted, note_id, student_id, ta_id, professor_id, comment_content) VALUES ('2023-08-02 03:08:45', 51, 15, NULL, NULL, 'rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis');

-- DepartmentAnnouncements

INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (30, 'Division of Mathematics', '2022-06-23 10:09:58', 'Guest lecture announcement');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (2, 'Division of Philosophy', '2022-02-18 01:06:25', 'Change in class location');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (9, 'College of Music', '2022-10-22 22:03:08', 'Reminder: class participation requirements');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (26, 'College of Information Technology', '2022-06-25 07:54:58', 'Change in exam format announcement');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (25, 'Department of Chemistry', '2022-04-19 05:27:05', 'Reminder: assignment submission guidelines');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (17, 'Department of History', '2022-12-13 10:07:39', 'Change in class timings');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (5, 'School of Nursing', '2022-10-11 02:10:01', 'New resource added to course website');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (49, 'College of Health Sciences', '2022-04-30 21:01:55', 'Guest lecture announcement');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (18, 'School of Physical Education', '2022-08-12 19:57:14', 'Change in course prerequisites announcement');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (12, 'School of Public Health', '2022-10-30 10:07:51', 'Exciting project announcement');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (41, 'Department of History', '2022-11-15 22:18:34', 'Exciting project announcement');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (10, 'College of Music', '2022-02-13 15:10:54', 'Extra credit opportunity announced');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (38, 'College of Music', '2022-08-02 05:22:52', 'Exciting project announcement');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (26, 'Division of Geology', '2022-10-07 00:49:00', 'Excursion announcement');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (11, 'College of Music', '2022-08-26 04:42:06', 'Announcement: class mentorship program');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (17, 'College of Health Sciences', '2022-03-19 03:00:57', 'New reading material uploaded');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (37, 'School of Public Health', '2022-03-05 05:27:04', 'Reminder: group project proposal due');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (23, 'Division of Economics', '2022-10-17 06:36:06', 'Announcement: class debate');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (25, 'Department of History', '2022-04-02 15:21:05', 'Exciting guest speaker announcement');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (6, 'School of Physical Education', '2022-09-17 03:37:48', 'Announcement: class party');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (50, 'School of Public Health', '2022-11-02 05:40:35', 'Announcement: class study session');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (42, 'College of Music', '2022-11-26 03:29:43', 'Announcement: class registration deadline');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (46, 'College of Information Technology', '2022-06-19 16:26:46', 'Reminder: class participation requirements');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (21, 'Division of Philosophy', '2022-05-29 19:32:12', 'Reminder: class presentation guidelines');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (42, 'Department of Chemistry', '2022-06-12 11:52:19', 'Reminder: office hours extended');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (12, 'School of Nursing', '2022-06-06 23:09:05', 'Announcement: class debate');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (28, 'School of Physical Education', '2022-11-19 04:14:40', 'Important announcement: class rescheduled');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (39, 'Department of History', '2022-03-28 11:17:20', 'Study group formation announcement');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (50, 'Department of History', '2022-01-24 18:35:20', 'Change in exam format announcement');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (45, 'College of Health Sciences', '2022-02-21 08:49:46', 'Change in office hours');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (43, 'Division of Geology', '2022-08-03 16:46:13', 'Reminder: class presentation guidelines');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (39, 'School of Physical Education', '2022-10-13 05:04:52', 'Reminder: class project progress report due');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (32, 'College of Information Technology', '2022-06-08 06:16:42', 'Exciting project announcement');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (37, 'College of Music', '2022-01-14 15:04:36', 'Announcement: class debate');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (5, 'School of Physical Education', '2022-07-15 16:02:51', 'New resource added to course website');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (6, 'College of Music', '2022-03-03 17:20:49', 'Study group formation announcement');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (21, 'School of Physical Education', '2022-04-09 06:11:19', 'Announcement: class debate');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (28, 'School of Architecture', '2022-07-21 00:59:21', 'Announcement: class discussion topic');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (31, 'School of Physical Education', '2022-12-25 23:19:16', 'Reminder: assignment due next week');
INSERT INTO DepartmentAnnouncements (administrator_id, department_name, date_posted, content) VALUES (48, 'College of Information Technology', '2022-01-22 04:39:29', 'Announcement: class registration deadline');

-- OfficeHours

INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (43, 3423, 2, '21:55:00', '2020-09-23');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (50, 7008, 7, '19:26:00', '2020-07-31');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (42, 4231, 0, '13:12:00', '2021-03-22');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (23, 5281, 7, '13:04:00', '2020-08-29');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (25, 702, 1, '7:07:00', '2021-10-26');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (3, 797, 1, '7:44:00', '2021-01-18');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (3, 8786, 8, '22:35:00', '2023-03-01');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (47, 2219, 8, '13:25:00', '2020-09-22');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (21, 2219, 8, '10:00:00', '2021-10-05');
INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date) VALUES (5, 2219, 8, '07:00:00', '2021-03-15');
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
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Health Sciences', 17);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Economics', 34);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 11);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 40);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Graphic Design', 7);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 53);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Chemistry', 6);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Communication', 37);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Graphic Design', 12);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Physical Education', 33);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Music', 35);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Architecture', 23);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Information Technology', 43);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Music', 17);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 45);
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
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Health Sciences', 25);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 36);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Chemistry', 53);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Philosophy', 7);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 49);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Mathematics', 24);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Philosophy', 34);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Physical Education', 59);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Health Sciences', 55);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Economics', 5);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Economics', 28);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 16);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 9);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 47);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Mathematics', 12);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Philosophy', 4);
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
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Graphic Design', 43);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 46);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Health Sciences', 8);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Architecture', 13);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Philosophy', 37);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Social Sciences', 20);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 22);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Health Sciences', 48);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Graphic Design', 41);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Communication', 1);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Health Sciences', 7);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Philosophy', 26);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Social Sciences', 3);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Chemistry', 33);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Philosophy', 12);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Chemistry', 51);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Health Sciences', 12);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Nursing', 2);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Communication', 56);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 60);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Geology', 1);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 38);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Health Sciences', 45);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Geology', 59);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Geology', 4);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Philosophy', 28);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Communication', 25);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Chemistry', 32);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Chemistry', 46);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Music', 33);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 16);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Economics', 45);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Information Technology', 48);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Economics', 12);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Geology', 28);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 20);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Philosophy', 6);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Philosophy', 9);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Nursing', 1);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Information Technology', 50);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Information Technology', 26);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Engineering', 49);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Social Sciences', 8);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Information Technology', 34);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Nursing', 11);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Health Sciences', 24);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 26);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Chemistry', 20);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Social Sciences', 26);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 8);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Music', 13);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 5);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Philosophy', 49);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 24);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Chemistry', 35);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 54);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Graphic Design', 38);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Health Sciences', 36);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Engineering', 17);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of Chemistry', 1);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Division of Social Sciences', 41);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Health Sciences', 29);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Communication', 32);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('School of Public Health', 48);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('Department of History', 34);
INSERT INTO Department_TAs (department_name, ta_id) VALUES ('College of Engineering', 57);

-- OHLocations

INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (43, 3423, 2, '21:55:00', '2020-09-23', 'Room 401 - Philosophy Discussion Room; Technology Hub: Room 110 - Computer Science Lab');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (50, 7008, 7, '19:26:00', '2020-07-31', 'Room 420 - Sports Medicine Workshop');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (42, 4231, 0, '13:12:00', '2021-03-22', 'Room 330 - Cybersecurity Workshop; Fine Arts Studio: Room 201 - Painting Studio');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (23, 5281, 7, '13:04:00', '2020-08-29', 'Room 220 - Data Analytics Classroom');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (25, 702, 1, '7:07:00', '2021-10-26', 'Room 308 - Physics Seminar Room');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (3, 797, 1, '7:44:00', '2021-01-18', 'Room 320 - Mandarin Chinese Classroom; Health Sciences Building: Room 106 - Nursing Simulation Lab');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (3, 8786, 8, '22:35:00', '2023-03-01', 'Room 420 - Sports Medicine Workshop');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (47, 2219, 8, '13:25:00', '2020-09-22', 'Room 308 - Physics Seminar Room');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (35, 3597, 6, '8:47:00', '2020-11-18', 'Room 420 - Sports Medicine Workshop');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (3, 797, 1, '18:19:00', '2021-09-11', 'Room 420 - Sports Medicine Workshop');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (24, 3844, 2, '21:48:00', '2020-09-16', 'Room 415 - Photography Darkroom; Business Complex: Room 103 - Marketing Classroom');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (50, 2633, 8, '11:25:00', '2021-04-13', 'Science Center: Room 101 - Biology Lecture Hall');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (14, 4521, 3, '18:11:00', '2023-08-03', 'Room 420 - Sports Medicine Workshop');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (42, 3597, 6, '13:00:00', '2022-08-21', 'https://zoom.us/j/5555555555');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (20, 5277, 1, '12:27:00', '2023-08-03', 'Room 401 - Philosophy Discussion Room; Technology Hub: Room 110 - Computer Science Lab');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (6, 3597, 6, '10:05:00', '2022-07-23', 'Room 215 - History Lecture Hall');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (33, 5994, 0, '7:53:00', '2020-10-14', 'Science Center: Room 101 - Biology Lecture Hall');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (29, 9402, 7, '15:34:00', '2022-11-05', 'https://zoom.us/j/5555555555');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (30, 123, 0, '12:52:00', '2021-11-10', 'Room 210 - Spanish Conversation Room');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (18, 9404, 1, '14:16:00', '2020-08-08', 'Room 335 - Anthropology Discussion Room; Language Center: Room 104 - French Language Lab');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (24, 1705, 2, '18:01:00', '2022-12-28', 'Science Center: Room 101 - Biology Lecture Hall');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (23, 9603, 4, '13:49:00', '2020-04-28', 'Room 305 - Sculpture Workshop');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (26, 6439, 0, '7:39:00', '2020-03-15', 'Room 215 - Public Health Classroom');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (41, 2802, 7, '8:13:00', '2023-06-25', 'Room 401 - Philosophy Discussion Room; Technology Hub: Room 110 - Computer Science Lab');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (50, 3597, 6, '11:15:00', '2022-03-02', 'Room 330 - Cybersecurity Workshop; Fine Arts Studio: Room 201 - Painting Studio');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (4, 3597, 6, '18:07:00', '2022-08-12', 'Room 225 - Sociology Classroom');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (56, 866, 5, '12:10:00', '2022-10-06', 'https://zoom.us/j/5555555555');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (53, 7383, 2, '9:47:00', '2022-11-26', 'Room 305 - Sculpture Workshop');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (50, 3844, 2, '20:13:00', '2021-01-07', 'Room 310 - Entrepreneurship Lab; Social Sciences Wing: Room 111 - Psychology Lecture Hall');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (10, 5281, 7, '7:33:00', '2020-07-31', 'Room 215 - Public Health Classroom');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (53, 9711, 0, '16:01:00', '2023-06-02', 'Room 320 - Mandarin Chinese Classroom; Health Sciences Building: Room 106 - Nursing Simulation Lab');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (22, 8514, 6, '15:32:00', '2020-08-28', 'Room 401 - Philosophy Discussion Room; Technology Hub: Room 110 - Computer Science Lab');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (47, 3768, 9, '14:43:00', '2023-06-22', 'Room 420 - Sports Medicine Workshop');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (36, 797, 1, '22:48:00', '2022-05-04', 'Room 207 - Finance Seminar Room');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (31, 9552, 4, '18:35:00', '2021-03-15', 'https://zoom.us/j/5555555555');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (1, 5426, 6, '12:36:00', '2020-07-13', 'Room 330 - Cybersecurity Workshop; Fine Arts Studio: Room 201 - Painting Studio');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (9, 40, 7, '12:47:00', '2023-02-12', 'Room 308 - Physics Seminar Room');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (33, 7383, 2, '17:49:00', '2023-07-17', 'Room 415 - Photography Darkroom; Business Complex: Room 103 - Marketing Classroom');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (41, 6439, 0, '9:32:00', '2023-08-31', 'Room 420 - Sports Medicine Workshop');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (14, 1636, 5, '8:59:00', '2020-02-06', 'Room 330 - Cybersecurity Workshop; Fine Arts Studio: Room 201 - Painting Studio');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (34, 9091, 5, '19:49:00', '2023-02-26', 'Room 415 - Photography Darkroom; Business Complex: Room 103 - Marketing Classroom');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (50, 5994, 0, '7:13:00', '2020-11-14', 'Room 308 - Physics Seminar Room');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (28, 9091, 5, '9:03:00', '2020-12-01', 'Science Center: Room 101 - Biology Lecture Hall');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (7, 797, 1, '7:41:00', '2020-04-29', 'Room 207 - Finance Seminar Room');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (59, 3597, 6, '12:01:00', '2022-07-18', 'Room 308 - Physics Seminar Room');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (20, 3597, 6, '14:09:00', '2022-02-19', 'Room 215 - History Lecture Hall');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (37, 9711, 0, '10:46:00', '2023-11-27', 'Room 415 - Photography Darkroom; Business Complex: Room 103 - Marketing Classroom');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (23, 9603, 4, '18:11:00', '2021-06-16', 'Room 305 - Sculpture Workshop');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (1, 5281, 7, '19:06:00', '2022-08-29', 'Room 415 - Photography Darkroom; Business Complex: Room 103 - Marketing Classroom');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (3, 3658, 4, '18:17:00', '2021-12-21', 'Room 305 - Sculpture Workshop');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (49, 4521, 3, '11:51:00', '2020-05-03', 'Room 305 - Sculpture Workshop');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (12, 314, 2, '8:05:00', '2022-08-21', 'Room 310 - Entrepreneurship Lab; Social Sciences Wing: Room 111 - Psychology Lecture Hall');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (28, 4521, 3, '20:03:00', '2023-11-06', 'Room 215 - Public Health Classroom');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (42, 9402, 7, '22:30:00', '2020-04-27', 'Room 320 - Mandarin Chinese Classroom; Health Sciences Building: Room 106 - Nursing Simulation Lab');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (49, 4521, 3, '12:05:00', '2022-02-22', 'Room 401 - Philosophy Discussion Room; Technology Hub: Room 110 - Computer Science Lab');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (56, 9603, 4, '19:55:00', '2022-03-03', 'Room 420 - Sports Medicine Workshop');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (26, 3913, 2, '7:31:00', '2022-12-15', 'Room 207 - Finance Seminar Room');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (17, 9711, 0, '13:11:00', '2021-10-07', 'https://zoom.us/j/5555555555');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (17, 8786, 8, '21:48:00', '2022-05-19', 'Room 330 - Cybersecurity Workshop; Fine Arts Studio: Room 201 - Painting Studio');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (17, 6439, 0, '9:40:00', '2022-10-31', 'Room 308 - Physics Seminar Room');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (21, 2633, 8, '9:35:00', '2020-03-19', 'Room 415 - Photography Darkroom; Business Complex: Room 103 - Marketing Classroom');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (17, 5850, 6, '10:37:00', '2023-08-22', 'Room 420 - Sports Medicine Workshop');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (9, 6064, 5, '20:56:00', '2022-11-20', 'Room 330 - Cybersecurity Workshop; Fine Arts Studio: Room 201 - Painting Studio');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (52, 3658, 4, '9:04:00', '2020-03-23', 'Room 415 - Photography Darkroom; Business Complex: Room 103 - Marketing Classroom');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (16, 8514, 6, '11:11:00', '2021-06-03', 'Room 308 - Physics Seminar Room');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (10, 8514, 6, '18:37:00', '2022-04-09', 'Science Center: Room 101 - Biology Lecture Hall');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (51, 5994, 0, '22:21:00', '2020-03-15', 'Room 207 - Finance Seminar Room');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (7, 7509, 3, '16:05:00', '2023-09-27', 'https://zoom.us/j/5555555553');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (15, 5281, 7, '10:12:00', '2022-09-20', 'https://zoom.us/j/5555555657');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (29, 3098, 6, '14:06:00', '2022-01-31', 'https://zoom.us/j/5555555556');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (26, 8551, 1, '13:01:00', '2023-03-28', 'https://zoom.us/j/5555555551');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (19, 1636, 5, '18:32:00', '2023-09-16', 'https://zoom.us/j/5555555555');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (41, 1705, 2, '16:58:00', '2020-04-09', 'https://zoom.us/j/5555555552');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (21, 6064, 5, '9:03:00', '2023-05-12', 'https://zoom.us/j/55555566555');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (34, 1636, 5, '16:09:00', '2022-06-08', 'https://zoom.us/j/5555555555');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (34, 2802, 7, '7:37:00', '2022-12-31', 'https://zoom.us/j/5555555557');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (29, 9552, 4, '16:43:00', '2023-01-04', 'https://zoom.us/j/5555555554');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (17, 5281, 7, '8:25:00', '2021-07-31', 'https://zoom.us/j/5555555557');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (30, 702, 1, '11:46:00', '2020-09-24', 'https://zoom.us/j/5555555551');
INSERT INTO OHLocations (ta_id, course_id, class_id, time, date, location) VALUES (7, 5426, 6, '9:31:00', '2020-06-20', 'https://zoom.us/j/5555557856');