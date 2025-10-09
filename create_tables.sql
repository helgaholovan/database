CREATE DATABASE IF NOT EXISTS A01;
USE A01;

CREATE TABLE Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100),
    birth_year INT,
    death_year INT
);

CREATE TABLE Genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(50)
);

CREATE TABLE Publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150),
    author_name VARCHAR(100),
    genre_name VARCHAR(50),
    publication_year INT,
    publisher_name VARCHAR(100)
);


CREATE TABLE Readers (
    reader_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    favorite_genre VARCHAR(50)
);