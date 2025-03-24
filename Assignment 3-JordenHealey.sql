DROP DATABASE IF EXISTS MovieStreamingService; -- Start fresh by deleting the old database 
CREATE DATABASE MovieStreamingService;
USE MovieStreamingService;

-- Users Table: Stores user account information
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique identifier for each user
    username VARCHAR(50) NOT NULL UNIQUE, -- Unique username
    email VARCHAR(100) NOT NULL UNIQUE, -- Unique email
    password_hash VARCHAR(255) NOT NULL, -- Hashed password for security
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Timestamp of account creation
);

-- Subscriptions Table: Stores user subscription details
CREATE TABLE Subscriptions (
    subscription_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique identifier for each subscription
    user_id INT NOT NULL, -- Foreign key referencing Users table
    plan_name ENUM('Basic', 'Standard', 'Premium') NOT NULL, -- Subscription plan type
    start_date DATE NOT NULL, -- Subscription start date
    end_date DATE NOT NULL, -- Subscription end date
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Movies Table: Stores information about movies available for streaming
CREATE TABLE Movies (
    movie_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique identifier for each movie
    title VARCHAR(255) NOT NULL, -- Movie title
    release_year YEAR NOT NULL, -- Year of movie release
    genre VARCHAR(100) NOT NULL, -- Movie genre (alternative: separate Genres table)
    director VARCHAR(255) NOT NULL, -- Movie director name
    description TEXT, -- Brief movie description
    duration INT NOT NULL CHECK (duration > 0) -- Movie duration in minutes
);

-- Watch History Table: Tracks movies watched by users
CREATE TABLE Watch_History (
    history_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique identifier for each watch history record
    user_id INT NOT NULL, -- Foreign key referencing Users table
    movie_id INT NOT NULL, -- Foreign key referencing Movies table
    watched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Timestamp of when the movie was watched
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id) ON DELETE CASCADE
);

-- Ratings Table: Stores user ratings and reviews for movies
CREATE TABLE Ratings (
    rating_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique identifier for each rating
    user_id INT NOT NULL, -- Foreign key referencing Users table
    movie_id INT NOT NULL, -- Foreign key referencing Movies table
    rating TINYINT CHECK (rating BETWEEN 1 AND 5), -- User rating (1 to 5 stars)
    review TEXT, -- Optional review text
    rated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Timestamp of when the rating was given
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id) ON DELETE CASCADE
);

-- Optional: Genres Table (Normalization of genres)
CREATE TABLE Genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique identifier for each genre
    genre_name VARCHAR(100) UNIQUE NOT NULL -- Genre name (e.g., Action, Comedy, Drama)
);

-- Add foreign key reference in Movies table for genre_id
ALTER TABLE Movies
ADD COLUMN genre_id INT,
ADD FOREIGN KEY (genre_id) REFERENCES Genres(genre_id);

-- Optional: Actors Table: Stores actor details
CREATE TABLE Actors (
    actor_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique identifier for each actor
    name VARCHAR(255) NOT NULL UNIQUE -- Actor's full name
);

-- Movie_Actors Table: Many-to-Many relationship between Movies and Actors
CREATE TABLE Movie_Actors (
    movie_id INT NOT NULL, -- Foreign key referencing Movies table
    actor_id INT NOT NULL, -- Foreign key referencing Actors table
    PRIMARY KEY (movie_id, actor_id), -- Composite primary key to ensure uniqueness
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id) ON DELETE CASCADE,
    FOREIGN KEY (actor_id) REFERENCES Actors(actor_id) ON DELETE CASCADE
);

-- Sample Data Insertion

-- Insert Users
INSERT INTO Users (username, email, password_hash) VALUES 
('john_doe', 'john@example.com', 'hashedpassword123'),
('jane_smith', 'jane@example.com', 'hashedpassword456'),
('michael_brown', 'michael@example.com', 'hashedpassword789'),
('susan_lee', 'susan@example.com', 'hashedpassword101'),
('david_clark', 'david@example.com', 'hashedpassword202');

-- Insert Subscriptions
INSERT INTO Subscriptions (user_id, plan_name, start_date, end_date) VALUES 
(1, 'Premium', '2024-01-01', '2025-01-01'),
(2, 'Standard', '2024-02-01', '2025-02-01'),
(3, 'Basic', '2024-03-05', '2025-03-05'),
(4, 'Premium', '2024-04-10', '2025-04-10'),
(5, 'Standard', '2024-05-15', '2025-05-15');

-- Insert Genres
INSERT INTO Genres (genre_name) VALUES 
('Action'),
('Comedy'),
('Drama'),
('Thriller'),
('Sci-Fi'),
('Horror'),
('Fantasy');

-- Insert Movies
INSERT INTO Movies (title, release_year, genre, director, description, duration) VALUES  
('Inception', 2010, 'Action', 'Christopher Nolan', 'A mind-bending thriller', 148),  
('The Godfather', 1972, 'Drama', 'Francis Ford Coppola', 'A mafia classic', 175),  
('Interstellar', 2014, 'Sci-Fi', 'Christopher Nolan', 'A space exploration drama', 169),  
('Parasite', 2019, 'Thriller', 'Bong Joon Ho', 'A social thriller', 132),  
('The Dark Knight', 2008, 'Action', 'Christopher Nolan', 'A superhero action movie', 152),  
('Joker', 2019, 'Drama', 'Todd Phillips', 'A deep character study', 122),  
('Avengers: Endgame', 2019, 'Action', 'Anthony Russo, Joe Russo', 'An epic superhero conclusion', 181);


-- Insert Watch History
INSERT INTO Watch_History (user_id, movie_id, watched_at) VALUES 
(1, 1, NOW()),
(2, 2, NOW()),
(3, 3, NOW()),
(4, 4, NOW()),
(1, 5, NOW()),
(2, 6, NOW()),
(3, 7, NOW());

-- Insert Ratings
INSERT INTO Ratings (user_id, movie_id, rating, review) VALUES 
(1, 1, 5, 'Amazing movie!'),
(2, 2, 4, 'Classic and timeless.'),
(3, 3, 5, 'Visually stunning and thought-provoking'),
(4, 4, 4, 'Gripping and suspenseful'),
(1, 5, 5, 'Best superhero movie ever!'),
(2, 6, 3, 'A bit too dark for my taste.'),
(3, 7, 5, 'A perfect ending to the saga!');

-- Insert Actors
INSERT INTO Actors (name) VALUES 
('Leonardo DiCaprio'),
('Marlon Brando'),
('Matthew McConaughey'),
('Song Kang-ho'),
('Christian Bale'),
('Joaquin Phoenix'),
('Robert Downey Jr.');

-- Insert Movie_Actors
INSERT INTO Movie_Actors (movie_id, actor_id) VALUES 
(1, 1), -- Inception - Leonardo DiCaprio
(2, 2), -- The Godfather - Marlon Brando
(3, 3), -- Interstellar - Matthew McConaughey
(4, 4), -- Parasite - Song Kang-ho
(5, 5), -- The Dark Knight - Christian Bale
(6, 6), -- Joker - Joaquin Phoenix
(7, 7); -- Avengers: Endgame - Robert Downey Jr.








