--ROLE TABLE
INSERT INTO "ROLE" (rolename) VALUES ('admin'), ('user');

--REG_USER TABLE
--User role
INSERT INTO "REG_USER" (Name, Password, Phone_Number, Email, Role_ID)
VALUES ('Korn Lin', 'password123', '0801234567', 'korn@example.com', 1);

-- 'admin_user' โดยใช้ Role เป็น 'Admin'
INSERT INTO "REG_USER" (Name, Password, Phone_Number, Email, Role_ID)
VALUES ('admin_user', 'adminpass', '0901234567', 'admin@example.com', 2);

--
INSERT INTO "COWORKING_SPACE" (CoWorking_ID,Name, Address, Rating, Phone_Number, Email, Open_Time, Close_Time, CoWorking_Facilities)
VALUES
    (1,'Space One', '1234 Main St, Bangkok', 5, '02-123-4567', 'spaceone@coworking.com', '08:00:00', '18:00:00', 'Free Wi-Fi, Meeting Rooms, Coffee Bar'),
    (2,'Creative Hub', '5678 Sukhumvit Rd, Bangkok', 4, '02-234-5678', 'creativehub@coworking.com', '09:00:00', '19:00:00', 'Free Wi-Fi, Hot Desks, Event Space'),
    (3,'WorkStation', '1357 Rama 9, Bangkok', 3, '02-345-6789', 'workstation@coworking.com', '07:30:00', '20:00:00', 'Private Offices, Meeting Rooms'),
    (4,'The Hive', '2468 Petchaburi Rd, Bangkok', 4, '02-456-7890', 'thehive@coworking.com', '09:00:00', '18:30:00', 'Co-Working Spaces, Lounge, Free Coffee'),
    (5,'Innovate Work', '3690 Ratchada Rd, Bangkok', 5, '02-567-8901', 'innovatework@coworking.com', '08:00:00', '21:00:00', 'Event Space, Private Rooms, High-Speed Internet');
  

--ROOM INSERT

INSERT INTO "ROOM" (Room_ID, Price, Capacity, Status, CoWorkingID, Room_Facilities) 
VALUES 
    (101, 500, 4, 'Available', 1, 'Projector, Whiteboard, Wi-Fi'),
    (102, 600, 6, 'Available', 1, 'Projector, Wi-Fi, Air Conditioning'),
    (103, 700, 10, 'Available', 1, 'Wi-Fi, Air Conditioning, Coffee Machine'),
    (104, 550, 5, 'Available', 1, 'Wi-Fi, Projector, Desk Space'),
    (105, 800, 12, 'Available', 1, 'Wi-Fi, Coffee Machine, Air Conditioning'),
    (106, 400, 3, 'Available', 1, 'Projector, Whiteboard, Wi-Fi'),
    (107, 650, 8, 'Available', 1, 'Wi-Fi, Coffee Machine, Desk Space'),
    
    (201, 550, 5, 'Available', 2, 'Wi-Fi, Whiteboard, Private Office'),
    (202, 750, 7, 'Available', 2, 'Air Conditioning, Standing Desks'),
    (203, 600, 6, 'Available', 2, 'High-Speed Internet, Lounge Access'),
    (204, 820, 10, 'Available', 2, 'Coffee Machine, Ergonomic Chairs'),
    (205, 500, 4, 'Available', 2, 'Projector, Whiteboard, Meeting Table'),
    (206, 650, 8, 'Available', 2, 'Wi-Fi, Printing Services, Free Coffee'),
    
    (301, 700, 10, 'Available', 3, 'Wi-Fi, Air Conditioning, Private Office'),
    (302, 400, 3, 'Available', 3, 'Projector, Whiteboard, Wi-Fi'),
    (303, 550, 5, 'Available', 3, 'Wi-Fi, Projector, Desk Space'),
    (304, 600, 6, 'Available', 3, 'Soundproof, High-Speed Internet'),
    (305, 800, 12, 'Available', 3, 'Wi-Fi, Coffee Machine, Air Conditioning'),
    (306, 750, 7, 'Available', 3, 'Meeting Room, Video Conference'),
    
    (401, 620, 6, 'Available', 4, 'Wi-Fi, Standing Desks, Quiet Zone'),
    (402, 500, 4, 'Available', 4, 'Projector, Whiteboard, Wi-Fi'),
    (403, 700, 10, 'Available', 4, 'Wi-Fi, Coffee Machine, Private Office'),
    (404, 850, 14, 'Available', 4, 'High-Speed Internet, Free Coffee'),
    (405, 540, 5, 'Available', 4, 'Soundproof, Lounge Access'),
    (406, 600, 6, 'Available', 4, 'Private Office, Printing Services'),
    
    (501, 650, 8, 'Available', 5, 'Wi-Fi, Whiteboard, Ergonomic Chairs'),
    (502, 720, 9, 'Available', 5, 'Air Conditioning, Standing Desks'),
    (503, 500, 4, 'Available', 5, 'Projector, Whiteboard, Wi-Fi'),
    (504, 900, 15, 'Available', 5, 'Lounge Access, Free Coffee, Printing Services'),
    (505, 620, 6, 'Available', 5, 'Meeting Table, Video Conference'),
    (506, 700, 10, 'Available', 5, 'Wi-Fi, High-Speed Internet, Private Office');



INSERT INTO "REG_USER" (User_ID, Name, Password, Phone_Number, Email, Role_ID) VALUES
(1, 'Eva Green', 'p@ssEvaG12', '956789012', 'eva@example.com', 1),
(2, 'Leo Turner', 'TrnL30!pass', '923456780', 'leo@example.com', 2),

(5, 'Charlie Brown', 'Ch@rBrownX3', '934567890', 'charlie@example.com', 2),
(6, 'Daniel Gray', 'DanGray#P30', '901234569', 'daniel@example.com', 1),
(7, 'Quinn Allen', 'Quinn!Allen17', '978901235', 'quinn@example.com', 2),
(8, 'Zane Reed', 'ZaneR$eed26', '967890125', 'zane@example.com', 2),
(9, 'Isabel Lewis', 'IsabelL!09', '990123456', 'isabel@example.com', 2),
(10, 'Alice Johnson', 'AliceJ@hn1', '912345678', 'alice@example.com', 2),
(11, 'Noah Harris', 'NoahHarris14!', '945678902', 'noah@example.com', 1),
(12, 'Uma Rivera', 'UmaR!vera21', '912345670', 'uma@example.com', 2),
(13, 'Frank Adams', 'FrankA$dam6', '967890123', 'frank@example.com', 2),
(14, 'Sophia Wright', 'SophiaW@right19', '990123457', 'sophia@example.com', 2),
(15, 'Brian Torres', 'BrianTorr28!', '989012347', 'brian@example.com', 2),
(16, 'Olivia Hall', 'OliHall#Pass15', '956789013', 'olivia@example.com', 2),
(17, 'Bob Smith', 'BobSm!th2', '923456789', 'bob@example.com', 2),
(18, 'Victor Lee', 'V!ctorL22', '923456781', 'victor@example.com', 1),
(19, 'Jack Carter', 'JackCar#t10', '901234567', 'jack@example.com', 2),
(20, 'Yara Jenkins', 'Yar@Jenkins25', '956789014', 'yara@example.com', 2),
(21, 'Kate Baker', 'KateB@ker11', '912345679', 'kate@example.com', 1),
(22, 'Ryan King', 'RyanK!ng18', '989012346', 'ryan@example.com', 1),
(23, 'Grace Miller', 'GraceM#iller7', '978901234', 'grace@example.com', 2),
(24, 'Paul Young', 'PaulY@oung16', '967890124', 'paul@example.com', 2),
(25, 'Chloe Foster', 'Chl0eFoster29', '990123458', 'chloe@example.com', 2),
(26, 'Xander Morgan', 'XandMorgan24!', '945678903', 'xander@example.com', 2),
(27, 'David White', 'DavidW!hite4', '945678901', 'david@example.com', 2),
(28, 'Tom Nelson', 'TomNel!son20', '901234568', 'tom@example.com', 1),
(29, 'Mia Scott', 'MiaS#cott13', '934567891', 'mia@example.com', 2),
(30, 'Amy Cox', 'AmyCox@27', '978901236', 'amy@example.com', 2);

INSERT INTO "RESERVATION" (User_ID, Room_ID, Start_Time, End_Time) VALUES
(1, 101, '2025-02-03 09:00:00', '2025-02-03 11:00:00'),
(2, 102, '2025-02-03 14:00:00', '2025-02-03 16:00:00'),
(5, 103, '2025-02-04 10:00:00', '2025-02-04 12:00:00'),
(6, 104, '2025-02-04 13:30:00', '2025-02-04 15:30:00'),
(7, 105, '2025-02-05 08:00:00', '2025-02-05 10:00:00'),
(8, 106, '2025-02-05 11:00:00', '2025-02-05 13:00:00'),
(9, 107, '2025-02-06 15:00:00', '2025-02-06 17:00:00'),
(10, 201, '2025-02-07 09:30:00', '2025-02-07 11:30:00'),
(11, 202, '2025-02-07 14:30:00', '2025-02-07 16:30:00'),
(12, 203, '2025-02-08 10:00:00', '2025-02-08 12:00:00'),
(13, 204, '2025-02-08 13:00:00', '2025-02-08 15:00:00'),
(14, 205, '2025-02-09 08:30:00', '2025-02-09 10:30:00'),
(15, 206, '2025-02-09 11:30:00', '2025-02-09 13:30:00'),
(16, 301, '2025-02-10 14:00:00', '2025-02-10 16:00:00'),
(17, 302, '2025-02-10 09:00:00', '2025-02-10 11:00:00'),
(18, 303, '2025-02-11 10:30:00', '2025-02-11 12:30:00'),
(19, 304, '2025-02-11 13:30:00', '2025-02-11 15:30:00'),
(20, 305, '2025-02-12 08:00:00', '2025-02-12 10:00:00'),
(21, 306, '2025-02-12 11:00:00', '2025-02-12 13:00:00'),
(22, 401, '2025-02-13 15:00:00', '2025-02-13 17:00:00'),
(23, 402, '2025-02-14 09:30:00', '2025-02-14 11:30:00'),
(24, 403, '2025-02-14 14:30:00', '2025-02-14 16:30:00'),
(25, 404, '2025-02-15 10:00:00', '2025-02-15 12:00:00'),
(26, 405, '2025-02-15 13:00:00', '2025-02-15 15:00:00'),
(27, 406, '2025-02-16 08:30:00', '2025-02-16 10:30:00'),

NSERT INTO "REG_USER" (User_ID, Name, Password, Phone_Number, Email, Role_ID) VALUES
(1, 'Eva Green', 'p@ssEvaG12', '956789012', 'eva@example.com', 1),
(2, 'Leo Turner', 'TrnL30!pass', '923456780', 'leo@example.com', 2),

(5, 'Charlie Brown', 'Ch@rBrownX3', '934567890', 'charlie@example.com', 2),
(6, 'Daniel Gray', 'DanGray#P30', '901234569', 'daniel@example.com', 1),
(7, 'Quinn Allen', 'Quinn!Allen17', '978901235', 'quinn@example.com', 2),
(8, 'Zane Reed', 'ZaneR$eed26', '967890125', 'zane@example.com', 2),
(9, 'Isabel Lewis', 'IsabelL!09', '990123456', 'isabel@example.com', 2),
(10, 'Alice Johnson', 'AliceJ@hn1', '912345678', 'alice@example.com', 2),
(11, 'Noah Harris', 'NoahHarris14!', '945678902', 'noah@example.com', 1),
(12, 'Uma Rivera', 'UmaR!vera21', '912345670', 'uma@example.com', 2),
(13, 'Frank Adams', 'FrankA$dam6', '967890123', 'frank@example.com', 2),
(14, 'Sophia Wright', 'SophiaW@right19', '990123457', 'sophia@example.com', 2),
(15, 'Brian Torres', 'BrianTorr28!', '989012347', 'brian@example.com', 2),
(16, 'Olivia Hall', 'OliHall#Pass15', '956789013', 'olivia@example.com', 2),
(17, 'Bob Smith', 'BobSm!th2', '923456789', 'bob@example.com', 2),
(18, 'Victor Lee', 'V!ctorL22', '923456781', 'victor@example.com', 1),
(19, 'Jack Carter', 'JackCar#t10', '901234567', 'jack@example.com', 2),
(20, 'Yara Jenkins', 'Yar@Jenkins25', '956789014', 'yara@example.com', 2),
(21, 'Kate Baker', 'KateB@ker11', '912345679', 'kate@example.com', 1),
(22, 'Ryan King', 'RyanK!ng18', '989012346', 'ryan@example.com', 1),
(23, 'Grace Miller', 'GraceM#iller7', '978901234', 'grace@example.com', 2),
(24, 'Paul Young', 'PaulY@oung16', '967890124', 'paul@example.com', 2),
(25, 'Chloe Foster', 'Chl0eFoster29', '990123458', 'chloe@example.com', 2),
(26, 'Xander Morgan', 'XandMorgan24!', '945678903', 'xander@example.com', 2),
(27, 'David White', 'DavidW!hite4', '945678901', 'david@example.com', 2),
(28, 'Tom Nelson', 'TomNel!son20', '901234568', 'tom@example.com', 1),
(29, 'Mia Scott', 'MiaS#cott13', '934567891', 'mia@example.com', 2),
(30, 'Amy Cox', 'AmyCox@27', '978901236', 'amy@example.com', 2);

INSERT INTO "RESERVATION" (User_ID, Room_ID, Start_Time, End_Time) VALUES
(1, 101, '2025-02-03 09:00:00', '2025-02-03 11:00:00'),
(2, 102, '2025-02-03 14:00:00', '2025-02-03 16:00:00'),
(5, 103, '2025-02-04 10:00:00', '2025-02-04 12:00:00'),
(6, 104, '2025-02-04 13:30:00', '2025-02-04 15:30:00'),
(7, 105, '2025-02-05 08:00:00', '2025-02-05 10:00:00'),
(8, 106, '2025-02-05 11:00:00', '2025-02-05 13:00:00'),
(9, 107, '2025-02-06 15:00:00', '2025-02-06 17:00:00'),
(10, 201, '2025-02-07 09:30:00', '2025-02-07 11:30:00'),
(11, 202, '2025-02-07 14:30:00', '2025-02-07 16:30:00'),
(12, 203, '2025-02-08 10:00:00', '2025-02-08 12:00:00'),
(13, 204, '2025-02-08 13:00:00', '2025-02-08 15:00:00'),
(14, 205, '2025-02-09 08:30:00', '2025-02-09 10:30:00'),
(15, 206, '2025-02-09 11:30:00', '2025-02-09 13:30:00'),
(16, 301, '2025-02-10 14:00:00', '2025-02-10 16:00:00'),
(17, 302, '2025-02-10 09:00:00', '2025-02-10 11:00:00'),
(18, 303, '2025-02-11 10:30:00', '2025-02-11 12:30:00'),
(19, 304, '2025-02-11 13:30:00', '2025-02-11 15:30:00'),
(20, 305, '2025-02-12 08:00:00', '2025-02-12 10:00:00'),
(21, 306, '2025-02-12 11:00:00', '2025-02-12 13:00:00'),
(22, 401, '2025-02-13 15:00:00', '2025-02-13 17:00:00'),
(23, 402, '2025-02-14 09:30:00', '2025-02-14 11:30:00'),
(24, 403, '2025-02-14 14:30:00', '2025-02-14 16:30:00'),
(25, 404, '2025-02-15 10:00:00', '2025-02-15 12:00:00'),
(26, 405, '2025-02-15 13:00:00', '2025-02-15 15:00:00'),
(27, 406, '2025-02-16 08:30:00', '2025-02-16 10:30:00'),

