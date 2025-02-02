--Approve
-- Function to check if the username exists
CREATE OR REPLACE FUNCTION username_exists(uname VARCHAR)
RETURNS BOOLEAN AS $$
DECLARE
    user_count INT;
BEGIN
    SELECT COUNT(*) INTO user_count FROM "REG_USER" WHERE Name = uname;  -- 'Name' column in REG_USER table
    RETURN user_count > 0;
END;
$$ LANGUAGE plpgsql;
--Approve
-- Procedure to register a user
CREATE OR REPLACE PROCEDURE register_user(uname VARCHAR, passw VARCHAR, u_phone VARCHAR, u_email VARCHAR, u_role INT)
LANGUAGE plpgsql AS $$
BEGIN
    IF username_exists(uname) THEN
        RAISE EXCEPTION 'Username already exists.';
    ELSE
        INSERT INTO "REG_USER" (Name, Password, Phone_Number, Email, Role_ID)
        VALUES (uname, passw, u_phone, u_email, u_role);  -- 'REG_USER' table
    END IF;
END;
$$;


--Approve
-- Procedure for user login
CREATE OR REPLACE PROCEDURE user_login(uname VARCHAR, passw VARCHAR)
LANGUAGE plpgsql AS $$
DECLARE
    found_user_id INT;
BEGIN
    SELECT User_ID INTO found_user_id FROM "REG_USER" WHERE Name = uname AND Password = passw;
    IF FOUND THEN
        -- Log the login action
        INSERT INTO "LOG" (Log_Type, User_ID, Action_ID, Table_Name, Timestamp, IP_Address)
        VALUES ('login', found_user_id, NULL, 'REG_USER', CURRENT_TIMESTAMP, inet_client_addr());
    ELSE
        RAISE EXCEPTION 'Invalid username or password.';
    END IF;
END;
$$;

-- Procedure for user logout
CREATE OR REPLACE PROCEDURE user_logout(uname VARCHAR)
LANGUAGE plpgsql AS $$
DECLARE
    found_user_id INT;
BEGIN
    SELECT User_ID INTO found_user_id FROM "REG_USER" WHERE Name = uname;
    IF FOUND THEN
        -- Log the logout action
        INSERT INTO "LOG" (Log_Type, User_ID, Action_ID, Table_Name, Timestamp, IP_Address)
        VALUES ('logout', found_user_id, NULL, 'REG_USER', CURRENT_TIMESTAMP, inet_client_addr());
    ELSE
        RAISE EXCEPTION 'Invalid username.';
    END IF;
END;
$$;


--Approve
-- Procedure for user logout
CREATE OR REPLACE PROCEDURE user_logout(uname VARCHAR)
LANGUAGE plpgsql AS $$
DECLARE
    found_user_id INT;
BEGIN
    SELECT User_ID INTO found_user_id FROM "REG_USER" WHERE Name = uname;  -- 'Name' column in REG_USER table
    IF FOUND THEN
        INSERT INTO log (type, date_time, user_id) VALUES ('logout', CURRENT_TIMESTAMP, found_user_id);  -- Log the logout
    ELSE
        RAISE EXCEPTION 'Invalid username.';
    END IF;
END;
$$;





--Approve
CREATE OR REPLACE FUNCTION view_user_reservations(
    p_user_id INT
) RETURNS TABLE (Reservation_ID INT, Room_ID INT, Start_Time TIMESTAMP, End_Time TIMESTAMP) AS $$
BEGIN
    -- Return all reservations for the user
    RETURN QUERY
    SELECT r.Reservation_ID, r.Room_ID, r.Start_Time, r.End_Time
    FROM "RESERVATION" r
    WHERE User_ID = p_user_id;
END;
$$ LANGUAGE plpgsql;

--Approve
CREATE OR REPLACE FUNCTION edit_user_reservation(
    p_reservation_id INT,
    p_start_time TIMESTAMP,
    p_end_time TIMESTAMP
) RETURNS VOID AS $$
DECLARE
    old_start_time TIMESTAMP;
    old_end_time TIMESTAMP;
    v_room_name VARCHAR(255);
BEGIN
    -- ดึงข้อมูลเก่าของการจอง
    SELECT Start_Time, End_Time INTO old_start_time, old_end_time 
    FROM "RESERVATION" WHERE Reservation_ID = p_reservation_id;

    -- ตรวจสอบว่าไม่พบการจอง
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Reservation ID % not found', p_reservation_id;
    END IF;

    -- แก้ไขการจอง
    UPDATE "RESERVATION"
    SET Start_Time = p_start_time, End_Time = p_end_time
    WHERE Reservation_ID = p_reservation_id;

    -- ดึงชื่อห้อง
    SELECT Name INTO v_room_name FROM "ROOM" WHERE Room_ID = (SELECT Room_ID FROM "RESERVATION" WHERE Reservation_ID = p_reservation_id);

    -- บันทึกการแก้ไขลงใน log
    INSERT INTO "LOG" (Log_Type, User_ID, Action_ID, Table_Name, Old_Value, New_Value, Timestamp, IP_Address)
    VALUES ('reservation_updated', NULL, p_reservation_id, 'RESERVATION', 
            CONCAT('Start: ', old_start_time, ', End: ', old_end_time), 
            CONCAT('Start: ', p_start_time, ', End: ', p_end_time), CURRENT_TIMESTAMP, inet_client_addr());
END;
$$ LANGUAGE plpgsql;


--Approve
CREATE OR REPLACE FUNCTION delete_user_reservation(
    p_reservation_id INT
) RETURNS VOID AS $$
DECLARE
    v_reserved_count INT;
    v_room_id INT;
BEGIN
    
    SELECT room_id INTO v_room_id
    FROM "RESERVATION" 
    WHERE reservation_id = p_reservation_id;

    
    IF FOUND THEN
        
        DELETE FROM "RESERVATION"
        WHERE reservation_id = p_reservation_id;

        
        SELECT COUNT(*) INTO v_reserved_count
        FROM "RESERVATION" 
        WHERE room_id = v_room_id;

        IF v_reserved_count = 0 THEN
            UPDATE "ROOM" 
            SET Status = 'Available' 
            WHERE room_ID = v_room_id;
        END IF;
    ELSE
        RAISE EXCEPTION 'Reservation ID % not found', p_reservation_id;
    END IF;

END;
$$ LANGUAGE plpgsql;




--Approve it work
CREATE OR REPLACE FUNCTION view_all_reservations() 
RETURNS TABLE (Reservation_ID INT, User_ID INT, Room_ID INT, Start_Time TIMESTAMP, End_Time TIMESTAMP) AS $$
BEGIN
    -- Return all reservations in the system
    RETURN QUERY
    SELECT r.Reservation_ID, r.User_ID, r.Room_ID, r.Start_Time, r.End_Time
    FROM "RESERVATION" r;
END;
$$ LANGUAGE plpgsql;





--Approve
--check role_id
CREATE OR REPLACE FUNCTION edit_admin_reservation(
    p_admin_id INT,
    p_reservation_id INT,
    p_start_time TIMESTAMP,
    p_end_time TIMESTAMP
) RETURNS VOID AS $$
DECLARE
    v_role_id INT;
BEGIN
    SELECT Role_ID INTO v_role_id FROM "REG_USER" WHERE User_ID = p_admin_id;
    IF v_role_id <> 1 THEN
        RAISE EXCEPTION 'Permission denied: Only admins can edit reservations.';
    END IF;
    
    UPDATE "RESERVATION" SET Start_Time = p_start_time, End_Time = p_end_time WHERE Reservation_ID = p_reservation_id;
END;
$$ LANGUAGE plpgsql;


--Approve
CREATE OR REPLACE FUNCTION delete_admin_reservation(
    p_admin_id INT,
    p_reservation_id INT
) RETURNS VOID AS $$
DECLARE
    v_role_id INT;
BEGIN
    SELECT Role_ID INTO v_role_id FROM "REG_USER" WHERE User_ID = p_admin_id;
    IF v_role_id <> 1 THEN
        RAISE EXCEPTION 'Permission denied: Only admins can delete reservations.';
    END IF;
    
    DELETE FROM "RESERVATION" WHERE Reservation_ID = p_reservation_id;
END;
$$ LANGUAGE plpgsql;





--Approve
CREATE OR REPLACE FUNCTION check_room_availability(
    _room_id INT,
    _start_time TIMESTAMP,
    _end_time TIMESTAMP
) RETURNS BOOLEAN AS $$
DECLARE
    room_count INT;
BEGIN
    -- Check if the room is available during the requested time
    SELECT COUNT(*)
    INTO room_count
    FROM "RESERVATION"
    WHERE Room_ID = _room_id
    AND (Start_Time, End_Time) OVERLAPS (_start_time, _end_time);
    
    IF room_count = 0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE PROCEDURE user_reserve_room(
    _user_id INT,
    _room_id INT,
    _start_time TIMESTAMP,
    _end_time TIMESTAMP
) AS $$
DECLARE
    room_available BOOLEAN;
    reservation_count INT;
    room_name VARCHAR(255);
BEGIN
    -- ตรวจสอบว่าผู้ใช้มีการจองมากเกินไปหรือไม่ (จำกัดที่ 3 ครั้ง)
    SELECT COUNT(*) INTO reservation_count
    FROM "RESERVATION"
    WHERE User_ID = _user_id;

    IF reservation_count >= 3 THEN
        RAISE EXCEPTION 'User can only have up to 3 reservations at a time';
    END IF;

    -- ตรวจสอบว่าห้องว่างหรือไม่
    SELECT check_room_availability(_room_id, _start_time, _end_time)
    INTO room_available;

    IF NOT room_available THEN
        RAISE EXCEPTION 'Room is not available at the requested time';
    END IF;

    -- ทำการจองห้อง
    INSERT INTO "RESERVATION" (User_ID, Room_ID, Start_Time, End_Time)
    VALUES (_user_id, _room_id, _start_time, _end_time);

    -- อัปเดตสถานะห้องเป็น "Booked"
    UPDATE "ROOM"
    SET Status = 'Booked'
    WHERE Room_ID = _room_id;

    -- ดึงชื่อห้องสำหรับบันทึกใน log
    SELECT Name INTO room_name FROM "ROOM" WHERE Room_ID = _room_id;

    -- บันทึกการจองลงใน log
    INSERT INTO "LOG" (Log_Type, User_ID, Action_ID, Table_Name, Old_Value, New_Value, Timestamp, IP_Address)
    VALUES ('reservation_created', _user_id, NULL, 'RESERVATION', NULL, 
            CONCAT('Room: ', room_name, ', Start: ', _start_time, ', End: ', _end_time), CURRENT_TIMESTAMP, inet_client_addr());

    -- แจ้งเตือนว่าการจองสำเร็จ
    RAISE NOTICE 'Reservation made successfully for user ID %, room ID %, from % to %', _user_id, _room_id, _start_time, _end_time;
END;
$$ LANGUAGE plpgsql;
