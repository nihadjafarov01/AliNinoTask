--CREATE DATABASE AliNinoDb_Nihad
----------------------------------------------------- Begin of CreateTables procedure
ALTER PROCEDURE CreateTables
    AS
    BEGIN
CREATE TABLE PublishingHouses
(
	Id int identity primary key,
	Title nvarchar(30),
	IsDeleted bit DEFAULT 0
);

CREATE TABLE Bindings
(
	Id int identity primary key,
	Title nvarchar(20),
	IsDeleted bit DEFAULT 0
);

CREATE TABLE Authors
(
	Id int identity primary key,
	Name nvarchar(30) NOT NULL,
	Surname nvarchar(30),
	IsDeleted bit DEFAULT 0
);

CREATE TABLE Genres
(
	Id int identity primary key,
	Title nvarchar(25),
	IsDeleted bit DEFAULT 0
);

CREATE TABLE Languages
(
	Id int identity primary key,
	Title nvarchar(30),
	IsDeleted bit DEFAULT 0
);

CREATE TABLE Categories
(
	Id int identity primary key,
	Title nvarchar(50),
	ParentCategoryId int references Categories(Id),
    CHECK (ParentCategoryId != Id),
	IsDeleted bit DEFAULT 0
);

CREATE TABLE Books
(
	Id int identity primary key,
	Title nvarchar(100) NOT NULL,
	Description nvarchar(250),
	ActualPrice money  NOT NULL,
	DiscountPrice money NOT NULL,
	PublisherHouseId int REFERENCES PublishingHouses(Id),
	StockCount int,
	ArticleCode char(13),
	BindingId int REFERENCES Bindings(Id),
	PageCount int NOT NULL,
	CategoryId int REFERENCES Categories(Id),
	IsDeleted bit DEFAULT 0
);

CREATE TABLE BookAuthors
(
	Id int identity primary key,
	BookId int references Books(Id),
	AuthorId int references Authors(Id)
);

CREATE TABLE BooksLanguages
(
	Id int identity primary key,
	BookId int references Books(Id),
	LanguageId int references Languages(Id)
);

CREATE TABLE Comments
(
	Id int identity primary key,
	Description nvarchar(250),
	BookId int references Books(Id),
	Rating tinyint CHECK(Rating BETWEEN 0 AND 5),
	Name nvarchar(25) NOT NULL,
	Email nvarchar(25) NOT NULL,
	ImageUrl nvarchar(max),
	IsDeleted bit DEFAULT 0
);
    END
----------------------------------------------------- End of CreateTables procedure
----------------------------------------------------- Begin of DropTables procedure
ALTER PROCEDURE DropTables
    AS
    BEGIN
    DROP TABLE Comments
    DROP TABLE BooksLanguages
    DROP TABLE BookAuthors
    DROP TABLE Books
    DROP TABLE Categories
    DROP TABLE Languages
    DROP TABLE Genres
    DROP TABLE Authors
    DROP TABLE Bindings
    DROP TABLE PublishingHouses
    END
----------------------------------------------------- End of DropTables procedure
----------------------------------------------------- Begin of InsertValues procedure
ALTER PROCEDURE InsertValues
AS
    BEGIN
    INSERT INTO PublishingHouses (Title) VALUES
('Penguin Books'),
('HarperCollins Publishers'),
('Simon & Schuster'),
('Random House'),
('Hachette Livre');

    INSERT INTO Bindings (Title) VALUES
('Hardcover'),
('Paperback'),
('E-book'),
('Audio Book');


    INSERT INTO Authors (Name, Surname) VALUES
('Stephen King', 'Bachman'),
('J.R.R.', 'Tolkien'),
('George R.R.', 'Martin'),
('J.K.', 'Rowling'),
('Paulo', 'Coelho');


    INSERT INTO Genres (Title) VALUES
('Fantasy'),
('Science Fiction'),
('Mystery'),
('Romance'),
('Non-Fiction');


    INSERT INTO Languages (Title) VALUES
('English'),
('French'),
('German'),
('Spanish'),
('Italian');


    INSERT INTO Categories (Title, ParentCategoryId) VALUES
('Literature', NULL),
('Crime', NULL),
('Science', NULL),
('History', NULL),
('Art', NULL),
('Children', 1),
('Young Adult', 1);


    INSERT INTO Books (Title, Description, ActualPrice, DiscountPrice, PublisherHouseId, StockCount, ArticleCode, BindingId, PageCount, CategoryId) VALUES
('The Lord of the Rings', 'An epic high fantasy trilogy by J.R.R. Tolkien', 29.99, 23.99, 1, 1000, '978-0-395-179', 1, 1280, 1),
('The Hobbit', 'An epic high fantasy novel by J.R.R. Tolkien', 19.99, 15.99, 1, 500, '978-0-395-041', 1, 368, 1),
('Harry Potter and the Sorcerers Stone', 'The first book in the Harry Potter fantasy series by J.K. Rowling', 14.99, 11.99, 2, 2000, '978-0-590-353', 2, 223, 3),
('The Martian', 'A science fiction novel by Andy Weir', 17.99, 14.99, 3, 1000, '978-0-552-154', 3, 384, 4),
('A Brief History of Time', 'A popular science book by Stephen Hawking', 24.99, 19.99, 4, 1500, '978-0-8050-70', 4, 224, 6);


INSERT INTO BookAuthors (BookId, AuthorId) VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 2),
(3, 3);

INSERT INTO BooksLanguages (BookId, LanguageId) VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 2),
(3, 1),
(3, 2),
(3, 3),
(4, 1),
(4, 3),
(5, 1),
(5, 2),
(5, 3);

INSERT INTO Comments (Description, BookId, Rating, Name, Email, ImageUrl) VALUES
('The Lord of the Rings is an amazing trilogy that I highly recommend to everyone!', 1, 5, 'John Smith', 'johnsmith@email.com', 'https://picsum.photos/200/300?image=1005'),
('I really enjoyed reading The Hobbit. It was a fun and exciting adventure', 2, 4, 'Jane Doe', 'janedoe@email.com', 'https://picsum.photos/200/300?image=1010'),
('Harry Potter and the Sorcerers Stone is a great book for kids and adults alike!', 3, 5, 'Peter Jones', 'peterjones@email.com', 'https://picsum.photos/200/300?image=1015'),
('The Martian is a gripping and suspenseful story that I couldnt put down.', 4, 5, 'Mary Brown', 'marybrown@email.com', 'https://picsum.photos/200/300?image=1020'),
('A Brief History of Time is a fascinating and informative book that has changed the way I see the universe.', 5, 5, 'David Miller', 'davidmiller@email.com', 'https://picsum.photos/200/300?image=1025');
END
----------------------------------------------------- End of InsertValues procedure
----------------------------------------------------- Begin of Triggers per tables
CREATE TRIGGER DeleteBooks
    ON Books
    INSTEAD OF DELETE
    AS
    BEGIN
        UPDATE Books
        SET IsDeleted = 1
        WHERE Id IN (SELECT Id FROM deleted)
    END;

CREATE TRIGGER DeletePublishingHouses
    ON PublishingHouses
    INSTEAD OF DELETE
    AS
    BEGIN
        UPDATE PublishingHouses
        SET IsDeleted = 1
        WHERE Id IN (SELECT Id FROM deleted)
    END;

CREATE TRIGGER DeleteBindings
    ON Bindings
    INSTEAD OF DELETE
    AS
    BEGIN
        UPDATE Bindings
        SET IsDeleted = 1
        WHERE Id IN (SELECT Id FROM deleted)
    END;

CREATE TRIGGER DeleteCategories
    ON Categories
    INSTEAD OF DELETE
    AS
    BEGIN
        UPDATE Categories
        SET IsDeleted = 1
        WHERE Id IN (SELECT Id FROM deleted)
    END;

CREATE TRIGGER DeleteAuthors
    ON Authors
    INSTEAD OF DELETE
    AS
    BEGIN
        UPDATE Authors
        SET IsDeleted = 1
        WHERE Id IN (SELECT Id FROM deleted)
    END;

CREATE TRIGGER DeleteGenres
    ON Genres
    INSTEAD OF DELETE
    AS
    BEGIN
        UPDATE Genres
        SET IsDeleted = 1
        WHERE Id IN (SELECT Id FROM deleted)
    END;

CREATE TRIGGER DeleteLanguages
    ON Languages
    INSTEAD OF DELETE
    AS
    BEGIN
        UPDATE Languages
        SET IsDeleted = 1
        WHERE Id IN (SELECT Id FROM deleted)
    END;

CREATE TRIGGER DeleteComments
    ON Comments
    INSTEAD OF DELETE
    AS
    BEGIN
        UPDATE Comments
        SET IsDeleted = 1
        WHERE Id IN (SELECT Id FROM deleted)
    END;
----------------------------------------------
CREATE PROCEDURE UpdateLanguage @Id int, @Title nvarchar(25)
AS
BEGIN
	UPDATE Languages
	SET Title = @Title
	WHERE Id = @Id
END;

CREATE PROCEDURE UpdateAuthor @Id int, @Name nvarchar(25),@Surname nvarchar(25)
AS
BEGIN
	UPDATE Authors
	SET Name = @Name, Surname = @Surname
	WHERE Id = @Id
END;
    
CREATE PROCEDURE UpdatePublishingHouses @Id int, @Title nvarchar(25)
AS
BEGIN
	UPDATE PublishingHouses
	SET Title = @Title
	WHERE Id = @Id
END;

CREATE PROCEDURE UpdateBinding @Id int, @Title nvarchar(25)
AS
BEGIN
	UPDATE Bindings
	SET Title = @Title
	WHERE Id = @Id
END;

CREATE PROCEDURE UpdateGenre @Id int, @Title nvarchar(25)
AS
BEGIN
	UPDATE Genres
	SET Title = @Title
	WHERE Id = @Id
END;

CREATE PROCEDURE UpdateCategory @Id int, @Title nvarchar(25), @ParentCategoryId int
AS
BEGIN
    UPDATE Categories
    SET Title = @Title, ParentCategoryId = @ParentCategoryId
    WHERE Id = @Id
END;
----------------------------------------------------- End of Triggers per tables

