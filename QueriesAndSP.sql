SELECT FirstName+ ' ' + LastName AS Name,
	DATEDIFF(DAY,Dob,CAST(GETDATE() AS Date)) AS [Age in days]
FROM Foundation.Actors


CREATE FUNCTION Foundation.ActorsWhoWorkedWithGivenProducer(@ProducerId int)
RETURNS table
AS
RETURN (
		SELECT DISTINCT A.Id,
			A.FirstName,
			A.LastName
		FROM Foundation.Producers P
			INNER JOIN Foundation.Movies M
				ON P.Id = M.ProducerId
			INNER JOIN Foundation.Actors_Movies AM
				ON M.Id = AM.MovieId
			INNER JOIN Foundation.Actors A
				ON A.Id = AM.ActorId
		WHERE P.Id = @ProducerId)


SELECT AM1.ActorId AS [First actor],
	AM2.ActorId AS [Second actor]
FROM Foundation.Actors_Movies AM1
	CROSS JOIN Foundation.Actors_Movies AM2
WHERE AM1.MovieId = AM2.MovieId 
	AND AM1.ActorId < AM2.ActorId
Group by Am1.ActorId,
	AM2.ActorId
HAVING COUNT(*)>=2


SELECT TOP 1 
	Id,
	FirstName,
	LastName,
	Bio,
	Sex,
	Dob AS [Date of birth]
FROM Foundation.Actors
ORDER BY Dob DESC


SELECT AM1.ActorId AS [First actor],
	AM2.ActorId AS [Second actor]
FROM Foundation.Actors_Movies AM1
	CROSS JOIN Foundation.Actors_Movies AM2
WHERE AM1.ActorId < AM2.ActorId
EXCEPT
SELECT AM1.ActorId,
	AM2.ActorId
FROM Foundation.Actors_Movies AM1
	CROSS JOIN Foundation.Actors_Movies AM2
WHERE AM1.MovieId = AM2.MovieId 
	AND AM1.ActorId < AM2.ActorId


SELECT Language,
	COUNT(Id) AS [Number of Movies]
FROM Foundation.Movies
GROUP BY Language


SELECT Language,
	SUM(Profit) AS [Total profit]
FROM Foundation.Movies
GROUP BY Language


CREATE FUNCTION ProfitByActorInEachLanguage(@ActorId int)
RETURNS table
AS
RETURN(
	SELECT Language,
		SUM(Profit) AS [Total profit]
	FROM Foundation.Movies M
		INNER JOIN Foundation.Actors_Movies AM
			ON M.Id = AM.MovieId
	WHERE AM.ActorId=@ActorId
	GROUP BY Language)


CREATE PROC Foundation.usp_insert_Movie
@Id int,
@Name varchar(50),
@Plot varchar(50),
@Year int,
@Poster varchar(200),
@ProducerId int,
@Profit int,
@Language varchar(50),
@ActorList varchar(50)
AS
INSERT INTO 
	Foundation.Movies(Id,Name,Plot,YearOfRelease,Poster,ProducerId,Profit,UpdatedAt,Language) 
	VALUES(@Id,@Name,@Plot,@Year,@Poster,@ProducerId,@Profit,Null,@Language)
DECLARE @MaxId int
SELECT @MaxId=MAX(Id)
FROM Foundation.Actors_Movies
INSERT INTO 
	Foundation.Actors_Movies(Id,MovieId,ActorId,UpdatedAt)
SELECT @MaxId+ordinal,
	@Id,
	value,
	NULL
FROM string_split(@ActorList,',',1)


CREATE PROC Foundation.usp_delete_Movie
@Id int
AS
DELETE FROM Foundation.Actors_Movies
WHERE MovieId = @Id;
DELETE FROM Foundation.Movies
WHERE Id = @Id;


CREATE PROC Foundation.usp_delete_Producer
@Id int
AS
DECLARE @RowCount int = 
	(SELECT COUNT(*) 
	FROM Foundation.Movies
	WHERE ProducerId=@Id)
DECLARE @MovieToDelete int
WHILE @RowCount>0
BEGIN
	SELECT @MovieToDelete=Id
	FROM Foundation.Movies
	WHERE ProducerId=@Id
	
	EXEC Foundation.usp_delete_Movie @MovieToDelete
	SELECT @RowCount-=1
END
DELETE FROM Foundation.Producers
WHERE Id = @Id


CREATE PROC Foundation.usp_delete_Actor
@Id int
AS
DELETE FROM Foundation.Actors_Movies
WHERE @Id=ActorId
DELETE FROM Foundation.Actors
WHERE @Id=Id