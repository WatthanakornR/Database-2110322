CREATE OR REPLACE FUNCTION check_room_availability(
    _room_id INT,
    _start_time TIMESTAMP,
    _end_time TIMESTAMP
) RETURNS BOOLEAN AS $$
DECLARE
    room_count INT;
    room_status TEXT;
BEGIN
    -- Check if the room is available during the requested time
    SELECT COUNT(*)
    INTO room_count
    FROM "RESERVATION"
    WHERE Room_ID = _room_id
    AND (Start_Time, End_Time) OVERLAPS (_start_time, _end_time);
    
    -- Check if the room exists in the "ROOM" table and get its status
    SELECT Status INTO room_status
    FROM "ROOM"
    WHERE Room_ID = _room_id;
    
    -- If the room does not exist, raise an exception
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Room ID % not found', _room_id;
    END IF;

    -- Check if the room is available
    IF room_count = 0 THEN
        -- Check the room status
        IF room_status = 'Available' THEN
            RETURN TRUE; -- Room is available
        ELSE
            RAISE EXCEPTION 'Room is not available due to its current status: %', room_status;
        END IF;
    ELSE
        RETURN FALSE; -- Room is already reserved during this time
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

-- บันทึกการจองลงใน log
    INSERT INTO "LOG" (Log_Type, User_ID, Action_ID, Table_Name, Old_Value, New_Value, Timestamp, IP_Address)
    VALUES ('reservation_created', _user_id, NULL, 'RESERVATION', NULL, 
            CONCAT('Room ID: ', _room_id, ', Start: ', _start_time, ', End: ', _end_time), CURRENT_TIMESTAMP, inet_client_addr());


    -- แจ้งเตือนว่าการจองสำเร็จ
    RAISE NOTICE 'Reservation made successfully for user ID %, room ID %, from % to %', _user_id, _room_id, _start_time, _end_time;
END;
$$ LANGUAGE plpgsql;





CREATE OR REPLACE PROCEDURE edit_reservation(
    p_reservation_id INT,
    p_start_time TIMESTAMP,
    p_end_time TIMESTAMP
) LANGUAGE plpgsql AS
$$
DECLARE
    old_start_time TIMESTAMP;
    old_end_time TIMESTAMP;
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

    
END;
$$;


CREATE OR REPLACE PROCEDURE delete_reservation(
    p_reservation_id INT
) LANGUAGE plpgsql AS
$$
DECLARE
    v_reserved_count INT;
    v_room_id INT;
BEGIN
    -- ดึงข้อมูลห้องจากการจอง
    SELECT room_id INTO v_room_id
    FROM "RESERVATION" 
    WHERE reservation_id = p_reservation_id;

    -- ตรวจสอบว่าไม่พบการจอง
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Reservation ID % not found', p_reservation_id;
    END IF;

    -- ลบการจอง
    DELETE FROM "RESERVATION"
    WHERE reservation_id = p_reservation_id;

    -- ตรวจสอบจำนวนการจองในห้องนั้นๆ
    SELECT COUNT(*) INTO v_reserved_count
    FROM "RESERVATION" 
    WHERE room_id = v_room_id;

    -- ถ้าไม่มีการจองในห้องนั้น ให้เปลี่ยนสถานะห้องเป็น 'Available'
    IF v_reserved_count = 0 THEN
        UPDATE "ROOM" 
        SET Status = 'Available' 
        WHERE room_ID = v_room_id;
    END IF;
END;
$$;
