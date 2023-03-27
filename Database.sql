CREATE DATABASE IMDB;
CREATE SCHEMA Foundation;
USE IMDB;
CREATE TABLE Foundation.Producers
(
Id int PRIMARY KEY NOT NULL,
FirstName varchar(50),
LastName varchar(50),
Sex varchar(6),
Dob Date,
Bio varchar(1000)
);

CREATE TABLE Foundation.Actors
(
Id int PRIMARY KEY NOT NULL,
FirstName varchar(50),
LastName varchar(50),
Sex varchar(6),
Dob Date,
Bio varchar(1000)
);

CREATE TABLE Foundation.Movies
(
Id int PRIMARY KEY NOT NULL,
Name varchar(50),
Plot varchar(50),
YearOfRelease int,
Poster varchar(200),
ProducerId int FOREIGN KEY REFERENCES Foundation.Producers(Id)
);

CREATE TABLE Foundation.Actors_Movies
(
Id int PRIMARY KEY NOT NULL,
MovieId int FOREIGN KEY REFERENCES Foundation.Movies(Id),
ActorId int FOREIGN KEY REFERENCES Foundation.Actors(Id)
);

INSERT INTO Foundation.Producers VALUES('1','Jon','Watts','Male','1990-11-12','A good producer');

INSERT INTO Foundation.Actors VALUES('1','James','Smith','Male','1990-01-12','A good actor');
INSERT INTO Foundation.Actors VALUES('2','Daniel','Redcliff','Male','1992-04-29','A good actor');
INSERT INTO Foundation.Actors VALUES('3','Brad','Pitt','Male','1993-10-19','A good actor');

INSERT INTO Foundation.Movies VALUES('1','Harry Potter','Fiction','2001','www.poster.com','1');
INSERT INTO Foundation.Movies VALUES('2','Terminator','scifi','2003','www.poster.com','1');
INSERT INTO Foundation.Movies VALUES('3','Wolves','Action','2002','www.poster.com','1');
INSERT INTO Foundation.Movies VALUES('4','Godfather','Action','2001','www.poster.com','1');

INSERT INTO Foundation.Actors_Movies VALUES('1','1','1');
INSERT INTO Foundation.Actors_Movies VALUES('2','1','2');
INSERT INTO Foundation.Actors_Movies VALUES('3','1','3');

INSERT INTO Foundation.Actors_Movies VALUES('4','2','1');
INSERT INTO Foundation.Actors_Movies VALUES('5','2','2');

INSERT INTO Foundation.Actors_Movies VALUES('6','3','1');
INSERT INTO Foundation.Actors_Movies VALUES('7','3','2');

INSERT INTO Foundation.Actors_Movies VALUES('8','4','2');
INSERT INTO Foundation.Actors_Movies VALUES('9','4','3');

ALTER TABLE Foundation.Movies ADD CreatedAt Date DEFAULT CAST(GETDATE() AS Date),UpdatedAt Date;
ALTER TABLE Foundation.Actors ADD CreatedAt Date DEFAULT CAST(GETDATE() AS Date),UpdatedAt Date;
ALTER TABLE Foundation.Producers ADD CreatedAt Date DEFAULT CAST(GETDATE() AS Date),UpdatedAt Date;
ALTER TABLE Foundation.Actors_Movies ADD CreatedAt Date DEFAULT CAST(GETDATE() AS Date),UpdatedAt Date;

ALTER TABLE Foundation.Movies ADD Profit int, Language varchar;
