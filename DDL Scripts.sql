CREATE SCHEMA Eventhub;
SET SEARCH_PATH TO Eventhub;

CREATE TABLE userdata
(
    userid VARCHAR(20) PRIMARY KEY,
    firstname VARCHAR(20) NOT NULL,
    lastname VARCHAR(20),
    email VARCHAR(50) NOT NULL,
    "password" VARCHAR(15) NOT NULL
);

CREATE TABLE artist
(
    artist_name VARCHAR(50) PRIMARY KEY,
    nationality VARCHAR(20) NOT NULL,
    birthdate DATE
);


CREATE TABLE artist_occupation
(
    artist_name VARCHAR(50),
    occupation VARCHAR(20),
    PRIMARY KEY (artist_name, occupation),
    FOREIGN KEY (artist_name) REFERENCES artist(artist_name) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE showdetails
(
    title VARCHAR(100) PRIMARY KEY,
    eventdate DATE NOT NULL,
    duration TIME,
    country VARCHAR(20),
    "language" VARCHAR(20) NOT NULL,
    category VARCHAR(20)
); 

CREATE TABLE genre_link
(
    genre VARCHAR(20),
    title VARCHAR(100),
    PRIMARY KEY (genre, title),
    FOREIGN KEY (title) REFERENCES showdetails(title) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE show_to_artist
(
    title VARCHAR(100),
    artist_name VARCHAR(50),
    PRIMARY KEY (title, artist_name),
    FOREIGN KEY (title) REFERENCES showdetails(title) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (artist_name) REFERENCES artist(artist_name) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE admin
(
    Admin_id VARCHAR(50) PRIMARY KEY,
    firstname VARCHAR(20) NOT NULL,
    lastname VARCHAR(20),
    email VARCHAR(50) NOT NULL,
    "password" VARCHAR(15) NOT NULL
);

CREATE TABLE City
(
    Pincode DECIMAL(6,0) PRIMARY KEY,
    Cityname VARCHAR(20) NOT NULL,
    State VARCHAR(20)
);

CREATE TABLE location
(
    venueid INT primary key,
    location_name VARCHAR(100) NOT NULL,
    area VARCHAR(255),
    contact DECIMAL(10,0),
    Admin_id VARCHAR(50) NOT NULL,
    Pincode DECIMAL(6,0) NOT NULL,
    FOREIGN KEY (Admin_id) REFERENCES admin(Admin_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Pincode) REFERENCES City(Pincode) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE show
(
    showid INT primary key,
    "date" DATE NOT NULL,
    starttime TIME,
    endtime TIME,
    venueid INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    FOREIGN KEY (venueid) REFERENCES location(venueid) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (title) REFERENCES showdetails(title) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE booking
(
    booking_no BIGINT primary key,
    No_of_seats INT NOT NULL,
    userid VARCHAR(20) NOT NULL,
    bookingdate Timestamp,
    showid INT NOT NULL,
    seating_type VARCHAR(10) NOT NULL,
    FOREIGN KEY (userid) REFERENCES userdata(userid) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (showid) REFERENCES show(showid) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE Seat
(
    showid INT ,
    seating_type VARCHAR(10) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    primary key (showid,seating_type),
    FOREIGN KEY (showid) REFERENCES show(showid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE payment
(
    transaction_no BIGINT primary key,
    booking_no BIGINT NOT NULL,
    payment_type VARCHAR(30) NOT NULL,
    payment_time TIMESTAMP,
    FOREIGN KEY (booking_no) REFERENCES booking(booking_no) ON DELETE CASCADE ON UPDATE CASCADE
    
); 


