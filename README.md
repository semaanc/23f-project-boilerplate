# MySQL + Flask Boilerplate Project

This repo contains a boilerplate setup for spinning up 3 Docker containers: 
1. A MySQL 8 container for obvious reasons
1. A Python Flask container to implement a REST API
1. A Local AppSmith Server

## Overview video
https://drive.google.com/file/d/1ntyNYZN72XA0SgaoM4NvOPBkTwTNDcZB/view?usp=sharing

## How to setup and start the containers
**Important** - you need Docker Desktop installed

1. Clone this repository.  
1. Create a file named `db_root_password.txt` in the `secrets/` folder and put inside of it the root password for MySQL. 
1. Create a file named `db_password.txt` in the `secrets/` folder and put inside of it the password you want to use for the a non-root user named webapp. 
1. In a terminal or command prompt, navigate up to the folder with the `docker-compose.yml` file.  
1. Build the images with `docker compose build`
1. Start the containers with `docker compose up`.  To run in detached mode, run `docker compose up -d`. 

## Project Overview
The project outlines the data structures and interactions for the Notetastic app. It contains the following major entities:
1. Professors:
   Professors have the ability to create or delete Classes and class folders.
   They can access folders of Notes or the office hours associated with their class.
   They can add or remove students or TAs in their class.
   They can also comment on, edit, pin, and delete notes.
3. TAs:
   TAs can view the Classes that they are assigned to.
   They can add to/remove from their office hours for a Class.
   They can access folders of Notes associated with the classes they TA in.
   The can comment on, pin, or report Notes.
5. Students:
   Students can view the Classes that they are in.
   They can access folders of Notes associated with the Classes they are in.
   They can create or comment on a Note.
   They can organize their Notes into folders
7. Classes:
   Classes are created by a Professor.
   They may have Students, TAs, and Note folders associated with them.
9. Notes:
   Notes can be created by a Student.
   Notes can be viewed and commented on by a Student, TA, or Professor.
   Notes can be reported by a TA and reported or pinned by a TA or Professor.
