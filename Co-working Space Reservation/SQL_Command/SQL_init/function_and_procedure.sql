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


-- Procedure to register a user
CREATE OR REPLACE PROCEDURE register_user(uname VARCHAR, passw VARCHAR, u_name VARCHAR, u_phone VARCHAR, u_email VARCHAR, u_role INT)
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


-- Procedure for user login
CREATE OR REPLACE PROCEDURE user_login(uname VARCHAR, passw VARCHAR)
LANGUAGE plpgsql AS $$
DECLARE
    found_user_id INT;
BEGIN
    SELECT User_ID INTO found_user_id FROM "REG_USER" WHERE Name = uname AND Password = passw;  -- 'Name' column in REG_USER table
    IF FOUND THEN
        INSERT INTO log (type, date_time, user_id) VALUES ('login', CURRENT_TIMESTAMP, found_user_id);  -- Log the login
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
    SELECT User_ID INTO found_user_id FROM "REG_USER" WHERE Name = uname;  -- 'Name' column in REG_USER table
    IF FOUND THEN
        INSERT INTO log (type, date_time, user_id) VALUES ('logout', CURRENT_TIMESTAMP, found_user_id);  -- Log the logout
    ELSE
        RAISE EXCEPTION 'Invalid username.';
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION reserve_room(
    p_user_id INT,
    p_room_id INT,
    p_start_time TIMESTAMP,
    p_end_time TIMESTAMP
) RETURNS VOID AS $$
DECLARE
    v_reserved_count INT;
    v_room_status VARCHAR;
BEGIN
    -- Check if user has already reserved 3 rooms
    SELECT COUNT(*) INTO v_reserved_count
    FROM "RESERVATION"
    WHERE User_ID = p_user_id;

    IF v_reserved_count >= 3 THEN
        RAISE EXCEPTION 'User cannot reserve more than 3 rooms';
    END IF;

    -- Check if the room is available (no overlapping reservations)
    SELECT Status INTO v_room_status
    FROM "ROOM"
    WHERE Room_ID = p_room_id;

    IF v_room_status = 'Booked' THEN
        RAISE EXCEPTION 'Room is already booked';
    END IF;

    -- Insert the reservation
    INSERT INTO "RESERVATION" (User_ID, Room_ID, Start_Time, End_Time)
    VALUES (p_user_id, p_room_id, p_start_time, p_end_time);

    -- Update the room status to "Booked"
    UPDATE "ROOM"
    SET Status = 'Booked'
    WHERE Room_ID = p_room_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION view_user_reservations(
    p_user_id INT
) RETURNS TABLE (Reservation_ID INT, Room_ID INT, Start_Time TIMESTAMP, End_Time TIMESTAMP) AS $$
BEGIN
    -- Return all reservations for the user
    RETURN QUERY
    SELECT Reservation_ID, Room_ID, Start_Time, End_Time
    FROM "RESERVATION"
    WHERE User_ID = p_user_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION edit_user_reservation(
    p_reservation_id INT,
    p_start_time TIMESTAMP,
    p_end_time TIMESTAMP
) RETURNS VOID AS $$
BEGIN
    -- Update the reservation with the new times
    UPDATE "RESERVATION"
    SET Start_Time = p_start_time, End_Time = p_end_time
    WHERE Reservation_ID = p_reservation_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION delete_user_reservation(
    p_reservation_id INT
) RETURNS VOID AS $$
BEGIN
    -- Delete the reservation
    DELETE FROM "RESERVATION"
    WHERE Reservation_ID = p_reservation_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION view_all_reservations() 
RETURNS TABLE (Reservation_ID INT, User_ID INT, Room_ID INT, Start_Time TIMESTAMP, End_Time TIMESTAMP) AS $$
BEGIN
    -- Return all reservations in the system
    RETURN QUERY
    SELECT Reservation_ID, User_ID, Room_ID, Start_Time, End_Time
    FROM "RESERVATION";
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION edit_admin_reservation(
    p_reservation_id INT,
    p_start_time TIMESTAMP,
    p_end_time TIMESTAMP
) RETURNS VOID AS $$
BEGIN
    -- Update the reservation with the new times
    UPDATE "RESERVATION"
    SET Start_Time = p_start_time, End_Time = p_end_time
    WHERE Reservation_ID = p_reservation_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION delete_admin_reservation(
    p_reservation_id INT
) RETURNS VOID AS $$
BEGIN
    -- Delete the reservation
    DELETE FROM "RESERVATION"
    WHERE Reservation_ID = p_reservation_id;
END;
$$ LANGUAGE plpgsql;
