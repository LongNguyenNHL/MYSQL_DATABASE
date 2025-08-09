CREATE DATABASE be8;
USE be8;

CREATE TABLE FILM (
	id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100),
    length_min INT,
    genre VARCHAR(50),
    country VARCHAR(10)
);

CREATE TABLE ROOM (
	id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE SCREENING (
	id VARCHAR(12) PRIMARY KEY,
    film_id VARCHAR(10),
    room_id VARCHAR(10),
    FOREIGN KEY (film_id) REFERENCES FILM(id),
    FOREIGN KEY (room_id) REFERENCES ROOM(id),
    start_time DATETIME
);

CREATE TABLE CUSTOMER (
	id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(20),
    phone VARCHAR(20)
);

CREATE TABLE BOOKING (
	id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10),
    screening_id VARCHAR(10),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(id),
    FOREIGN KEY (screening_id) REFERENCES SCREENING(id),
	booking_time DATETIME,
    total INT
);

CREATE TABLE SEAT (
	id VARCHAR(10) PRIMARY KEY,
    room_id VARCHAR(10),
    FOREIGN KEY (room_id) REFERENCES ROOM(id),
    row_seat CHAR(1),
    number INT,
    UNIQUE (row_seat, number),
    x INT,
    y INT,
    UNIQUE (x, y)
);

CREATE TABLE RESERVED_SEAT (
	id VARCHAR(10) PRIMARY KEY,
    booking_id VARCHAR(10),
    seat_id VARCHAR(10),
	FOREIGN KEY (booking_id) REFERENCES BOOKING(id),
    FOREIGN KEY (seat_id) REFERENCES SEAT(id),
    UNIQUE (booking_id, seat_id),
    price INT
);

INSERT INTO FILM (id, name, length_min, genre, country)
VALUES
('FM001', 'Movie A', 120, 'Comedy', 'VN'),
('FM002', 'Movie B', 125, 'Horror', 'AU'),
('FM003', 'Movie C', 162, 'Horror', 'JP');

INSERT INTO ROOM (id, name)
VALUES
('T001', 'Theater A'),
('T002', 'Theater B'),
('T003', 'Theater C');

INSERT INTO SCREENING (id, film_id, room_id, start_time)
VALUES
('SC001', 'FM003', 'T002', '2025/10/10 10:00:00'),
('SC002', 'FM002', 'T001', '2025/10/11 08:00:00'),
('SC003', 'FM002', 'T001', '2025/10/12 09:00:00'),
('SC004', 'FM001', 'T003', '2025/10/13 18:00:00');

INSERT INTO CUSTOMER (id, name)
VALUES
('C001', 'Leslie'),
('C002', 'Noah'),
('C003', 'Ivy'),
('C004', 'Jayden'),
('C005', 'Jonathan');

INSERT INTO BOOKING (id, customer_id, screening_id)
VALUES
('B001', 'C001', 'SC002'),
('B002', 'C001', 'SC003'),
('B003', 'C003', 'SC004'),
('B004', 'C004', 'SC004');

INSERT INTO SEAT (id, room_id, row_seat, number, x, y)
VALUES 
('S001', 'T001', 'A', 1, 1, 1),
('S002', 'T002', 'A', 5, 1, 3),
('S003', 'T003', 'G', 4, 1, 2),
('S004', 'T003', 'F', 6, 2, 1);

INSERT INTO RESERVED_SEAT (id, booking_id, seat_id)
VALUES
('RS001', 'B001', 'S001'),
('RS002', 'B002', 'S002'),
('RS003', 'B003', 'S004'),
('RS004', 'B003', 'S003');
