SET SEARCH_PATH TO Eventhub;


--1  who manage the maximum number of locations among all administrators.
SELECT admin.Admin_id, admin.firstname, admin.lastname, COUNT(location.venueid) AS num_locations
FROM admin
JOIN location ON admin.Admin_id = location.Admin_id
GROUP BY admin.Admin_id, admin.firstname, admin.lastname
HAVING COUNT(location.venueid) = (
    SELECT MAX(location_count)
    FROM (
        SELECT COUNT(venueid) AS location_count
        FROM location
        GROUP BY Admin_id
    ) AS location_counts
);


--2  How many locations are managed by each administrator 
SELECT admin.Admin_id, COUNT(location.venueid) AS num_locations
FROM admin
LEFT JOIN location ON admin.Admin_id = location.Admin_id
GROUP BY admin.Admin_id;


-- 3  shows and events related to Naseeruddin Shah.
SELECT title,eventdate
FROM showdetails
WHERE title IN (
    SELECT title
    FROM show_to_artist
    WHERE artist_name = 'Naseeruddin Shah'
);


--4 artist who has performed in the maximum number of shows.
SELECT artist_name, title
FROM show_to_artist
WHERE artist_name = (
    SELECT artist_name
    FROM show_to_artist
    GROUP BY artist_name
    ORDER BY COUNT(*) DESC
    LIMIT 1
);


--5 total amount spent by user 'aayush1107' on the show 'Animal'.
SELECT SUM(ss.price*b.no_of_seats) FROM booking as b
JOIN  show AS s ON s.showid = b.showid
JOIN showdetails AS sd ON sd.title = s.title
JOIN seat AS ss ON s.showid = ss.showid
where b.userid = 'aayush1107' AND sd.title='Animal' AND b.seating_type=ss.seating_type;


--6 total amount spent by user 'bella181' on each show.
SELECT sd.title, SUM(ss.price * b.no_of_seats) AS total_spend
FROM booking AS b
JOIN show AS s ON s.showid = b.showid
JOIN showdetails AS sd ON sd.title = s.title
JOIN seat AS ss ON s.showid = ss.showid
WHERE b.userid = 'bella181' AND b.seating_type=ss.seating_type
GROUP BY sd.title;


--7 shows and events happening in each hall of 'PVR Cinemas'.
SELECT s.title, COUNT(s.showid), s.date
FROM show AS s
JOIN location AS h ON h.venueid = s.venueid
WHERE location_name = 'PVR Cinemas'
GROUP BY s.title, s.date;


--8 who has booked the maximum number of Seats.
SELECT b.userid, SUM(b.no_of_seats) AS total_seats
FROM booking AS b
JOIN show AS s ON s.showid = b.showid
GROUP BY b.userid
ORDER BY total_seats DESC
LIMIT 1;


--9 which show has the maximum number of bookings.
SELECT s.title, COUNT(b.no_of_seats) AS tc
FROM booking AS b
JOIN show AS s ON s.showid = b.showid
GROUP BY s.title
ORDER BY tc DESC
LIMIT 1;


--10 which event earn the maximum revenue.
SELECT s.title, SUM(b.no_of_seats*ss.price) AS tc
FROM booking AS b
JOIN show AS s ON s.showid = b.showid
JOIN seat ss ON s.showid = ss.showid AND b.seating_type = ss.seating_type
GROUP BY s.title
ORDER BY tc DESC
LIMIT 1;


--11 filter the shows tickets price in Low to High.
SELECT s.*,ss.price FROM show as s
JOIN seat as ss ON s.showid = ss.showid
ORDER BY  ss.price DESC;


--12 filter the shows which are happening in Mumbai.
SELECT s.title,s.date,h.venueid,h.location_name 
FROM show AS s 
JOIN location AS h ON s.venueid = h.venueid
JOIN City AS c ON h.pincode = c.pincode
WHERE c.cityname = 'Mumbai';


--13 Anubhav Singh Bassi all shows details.
SELECT s.title,s.date,h.venueid,h.location_name,c.cityname 
FROM artist as a
NATURAL JOIN show_to_artist AS sa
NATURAL JOIN showdetails AS sd
NATURAL JOIN show AS s
NATURAL JOIN location AS h
NATURAL JOIN city as c
WHERE a.artist_name = 'Anubhav Singh Bassi';


--14 total revenue earned by 'yatin777'.
SELECT a.Admin_id,SUM(b.no_of_seats*ss.price) AS total_revenue
FROM admin a
JOIN location h ON a.Admin_id = h.Admin_id
JOIN show s ON s.venueid = h.venueid
JOIN booking b ON s.showid= b.showid
JOIN seat ss ON ss.showid = s.showid
WHERE a.Admin_id = 'yatin777' AND ss.seating_type=b.seating_type
GROUP BY a.Admin_id;


--15 how many shows are happening in each location
SELECT h.location_name, COUNT(s.date) AS dd 
FROM location AS h
JOIN show AS s ON s.venueid = h.venueid
GROUP BY h.location_name
ORDER BY dd DESC
LIMIT 1 ;


--16 Give me stand up comedy shows with more than 1 artist.
SELECT sd.title AS comedy_show,COUNT(sa.artist_name) AS num_artists
FROM showdetails sd
JOIN show_to_artist sta ON sd.title = sta.title
JOIN artist sa ON sta.artist_name = sa.artist_name
WHERE sd.category = 'Stand_Up'
GROUP BY sd.title
HAVING COUNT(sa.artist_name) > 1;


--17 The user with the highest count of movies watched.
SELECT u.userid, u.firstname, u.lastname, COUNT(b.showid) AS num_movies_watched
FROM userdata u
JOIN booking b ON u.userid = b.userid
JOIN show s ON b.showid = s.showid
JOIN showdetails sd ON s.title = sd.title
WHERE sd.category = 'Movie'
GROUP BY u.userid, u.firstname, u.lastname
ORDER BY COUNT(b.showid) DESC
LIMIT 1;


--18 shows where the total number of booked seats exceeds 25. 
SELECT s.title, SUM(b.no_of_seats ) AS total_seats
FROM show s 
JOIN booking b ON s.showid = b.showid
JOIN seat AS ss ON s.showid = ss.showid AND b.seating_type = ss.seating_type
GROUP BY s.title
HAVING SUM(b.no_of_seats ) > 25
ORDER BY total_seats;



--19 user who has booked seats more than 20 times.
SELECT u.userid, u.firstname, u.lastname, SUM(b.no_of_seats) AS total_seats
FROM userdata u
JOIN booking b ON u.userid = b.userid
GROUP BY u.userid, u.firstname, u.lastname
HAVING SUM(b.no_of_seats) > 20
ORDER BY total_seats;


--20 filtering only users who have booked tickets for theater plays
SELECT DISTINCT u.userid, u.firstname, u.lastname
FROM userdata u
JOIN booking b ON u.userid = b.userid
JOIN show s ON b.showid = s.showid
JOIN showdetails sd ON s.title = sd.title
WHERE sd.category = 'Theater_Play';


--21 give the name of all city where Shah Rukh Khan relatd show will happen between 2006-10-01 to 2007-12-30
SELECT DISTINCT Cityname
FROM City
JOIN location ON City.Pincode = location.Pincode
JOIN show ON location.venueid = show.venueid
JOIN show_to_artist ON show.title = show_to_artist.title
JOIN artist ON show_to_artist.artist_name = artist.artist_name
WHERE artist.artist_name = 'Shah Rukh Khan' 
AND show.date 
BETWEEN '2006-10-01'AND'2007-12-30';


