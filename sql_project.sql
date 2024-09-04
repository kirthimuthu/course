create database ticket_booking;
use ticket_booking;

-- Movies Table: Stores information about movies.
CREATE TABLE Movies (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    genre VARCHAR(50),
    duration INT,
    rating VARCHAR(5)
);

insert into Movies (title,genre,duration,rating) values('PT sir','comdey',120,'3.5'),
('star','emotional',130,4),
('Aranmanai 4','thriller',145,3.5),('godzilla','adventure',120,4.2),
('kung fu panda','comedy',110,4),
('karudan','action',150,4.5);

select * from Movies;

select  title,genre from Movies;

update Movies set title='karudan' where movie_id=1;

update Movies set genre='action' where movie_id=1;

select count(title) from Movies where title='PT sir';

drop table Movies;

-- Cinemas Table: Stores information about cinemas.
CREATE TABLE Cinemas (
    cinema_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL
);
 select* from Cinemas;

-- Shows Table: Stores information about movie show timings.
CREATE TABLE Shows (
    show_id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT,
    cinema_id INT,
    show_time DATETIME,
    available_seats INT,
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
    FOREIGN KEY (cinema_id) REFERENCES Cinemas(cinema_id)
);

 select* from Shows;
 
 -- Users Table: Stores user information.
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
);

 select* from Users;

-- Bookings Table: Stores booking information.
CREATE TABLE Bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    show_id INT,
    number_of_seats INT,
    booking_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (show_id) REFERENCES Shows(show_id)
);
-- Insert a new cinema:
INSERT INTO Cinemas (name, location)
VALUES ('Cinema City', 'Downtown'),('PVR','Banglore'),('Kamala','Chennai')
,('Niraj','Kovai'),('Sathiyan','karaikudi');

-- Insert a new show:
INSERT INTO Shows (movie_id, cinema_id, show_time, available_seats)
VALUES (1, 1, '2024-06-01 10:15:00', 100),(2,2,'2024-06-01 13:00:00',86),(3,3,'2024-06-01 18:30:00',20),
(4,4,'2024-06-02 11:00:00',115),(2,2,'2024-06-02 14:30:00',56);


drop table Shows;
drop table Bookings;

-- Register a new user:
INSERT INTO Users (name, email)
VALUES ('John Doe', 'John.doe@example.com'),('keerthi', 'Keerthi12@gmail.com'),
('kani', 'Kani01@gmail.com'),('bhuvana', 'Bhuvana1999gmail.com'),('manoj', 'mano2k@gmail.com');

 select* from Users;
 
-- Book tickets for a show:
INSERT INTO Bookings (user_id, show_id, number_of_seats)
VALUES (1, 1, 2),(2, 2, 9),(3, 3, 12),(4, 4, 5),(5, 5, 2);

 select* from Users;
 
UPDATE Shows
SET available_seats = available_seats - 2
WHERE show_id = 4;

-- View available movies and their showtimes:
SELECT m.title, s.show_time, c.name AS cinema_name, s.available_seats
FROM Shows s
JOIN Movies m ON s.movie_id = m.movie_id
JOIN Cinemas c ON s.cinema_id = c.cinema_id
WHERE s.show_time > NOW()
ORDER BY s.show_time;

-- View user bookings:
SELECT u.name, u.email, m.title, c.name AS cinema_name, s.show_time, b.number_of_seats
FROM Bookings b
LEFT JOIN Users u ON b.user_id = u.user_id AND u.user_id = 1
LEFT JOIN Shows s ON b.show_id = s.show_id
LEFT JOIN Movies m ON s.movie_id = m.movie_id
LEFT JOIN Cinemas c ON s.cinema_id = c.cinema_id
WHERE u.user_id IS NOT NULL

UNION

SELECT u.name, u.email, m.title, c.name AS cinema_name, s.show_time, b.number_of_seats
FROM Bookings b
RIGHT JOIN Users u ON b.user_id = u.user_id AND u.user_id = 1
RIGHT JOIN Shows s ON b.show_id = s.show_id
RIGHT JOIN Movies m ON s.movie_id = m.movie_id
RIGHT JOIN Cinemas c ON s.cinema_id = c.cinema_id
WHERE u.user_id IS NOT NULL;

-- Find All Movies with Shows Between Specific Dates
SELECT m.title, s.show_time, c.name AS cinema_name
FROM Shows s
JOIN Movies m ON s.movie_id = m.movie_id
JOIN Cinemas c ON s.cinema_id = c.cinema_id
WHERE s.show_time BETWEEN '2024-06-01' AND '2024-06-30';

-- List Users Who Have Made More Than One Booking
SELECT u.name, u.email, COUNT(b.booking_id) AS total_bookings
FROM Users u
JOIN Bookings b ON u.user_id = b.user_id
GROUP BY u.user_id
HAVING total_bookings >=1;

-- Find Shows with the Most Available Seats
SELECT m.title, c.name AS cinema_name, s.show_time, s.available_seats
FROM Shows s
JOIN Movies m ON s.movie_id = m.movie_id
JOIN Cinemas c ON s.cinema_id = c.cinema_id
ORDER BY s.available_seats DESC
LIMIT 5;

-- List of Users and the Movies They Have Not Watched
SELECT u.name, u.email, m.title
FROM Users u
CROSS JOIN Movies m
WHERE NOT EXISTS (
    SELECT 1
    FROM Bookings b
    JOIN Shows s ON b.show_id = s.show_id
    WHERE b.user_id = u.user_id AND s.movie_id = m.movie_id  
)
LIMIT 7;

-- List of Users and the Total Number of Seats They Have Booked
SELECT u.name, u.email, SUM(b.number_of_seats) AS total_seats
FROM Users u
JOIN Bookings b ON u.user_id = b.user_id
GROUP BY u.user_id;

-- Find All Movies with Titles Containing a Specific Word
SELECT title, genre, duration, rating
FROM Movies
WHERE title LIKE '%star%';

-- Count the Number of Shows for Movies with Titles Containing a Specific Word
SELECT COUNT(*) AS show_count
FROM Shows s
JOIN Movies m ON s.movie_id = m.movie_id
WHERE m.title LIKE '%godzilla%';

 -- creating view For AvailableMoviesShows
 CREATE VIEW AvailableMoviesShows AS
SELECT m.title, s.show_time, c.name AS cinema_name, s.available_seats
FROM Shows s
JOIN Movies m ON s.movie_id = m.movie_id
JOIN Cinemas c ON s.cinema_id = c.cinema_id
WHERE s.show_time > NOW();

SELECT * FROM AvailableMoviesShows;

-- creating view for UserBookings
CREATE VIEW UserBookings AS
SELECT u.name, u.email, m.title, c.name AS cinema_name, s.show_time, b.number_of_seats
FROM Bookings b
JOIN Users u ON b.user_id = u.user_id
JOIN Shows s ON b.show_id = s.show_id
JOIN Movies m ON s.movie_id = m.movie_id
JOIN Cinemas c ON s.cinema_id = c.cinema_id;

SELECT * FROM UserBookings;
