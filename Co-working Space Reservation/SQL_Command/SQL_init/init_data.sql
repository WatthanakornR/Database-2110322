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



