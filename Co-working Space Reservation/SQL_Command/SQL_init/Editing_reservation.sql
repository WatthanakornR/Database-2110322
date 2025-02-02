CREATE TABLE IF NOT EXISTS Editing_reservation_log (
    Edit_ID SERIAL PRIMARY KEY,
    Reservation_ID INT,
    User_ID INT,
    Room_ID INT,
    Start_Time TIMESTAMP NOT NULL,
    End_Time TIMESTAMP NOT NULL,
    New_User_ID INT,
    New_Room_ID INT,
    New_Start_Time TIMESTAMP NOT NULL,
    New_End_Time TIMESTAMP NOT NULL,
    Role_Editing VARCHAR(255),
    Time_Stamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ปรับปรุงฟังก์ชันบันทึกการแก้ไขการจอง
CREATE OR REPLACE FUNCTION editing_reservation() 
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
DECLARE
    room_available BOOLEAN;
    existing_reservation INT;
BEGIN
    -- ตรวจสอบว่ามีการจองนี้อยู่จริงหรือไม่
    IF NOT EXISTS (SELECT 1 FROM "RESERVATION" WHERE Reservation_ID = OLD.Reservation_ID) THEN
        RAISE EXCEPTION 'Reservation ID % not found', OLD.Reservation_ID;
    END IF;

    -- ตรวจสอบว่าห้องใหม่ว่างหรือไม่ (ยกเว้นตัวเอง)
    SELECT COUNT(*)
    INTO existing_reservation
    FROM "RESERVATION"
    WHERE Room_ID = NEW.Room_ID
    AND (Start_Time, End_Time) OVERLAPS (NEW.Start_Time, NEW.End_Time)
    AND Reservation_ID != OLD.Reservation_ID;

    IF existing_reservation > 0 THEN
        RAISE EXCEPTION 'Room ID % is already booked during the requested time', NEW.Room_ID;
    END IF;

    -- บันทึกการเปลี่ยนแปลงลงในตาราง Editing_reservation_log
    INSERT INTO Editing_reservation_log (
        Reservation_ID, User_ID, Room_ID, Start_Time, End_Time,
        New_User_ID, New_Room_ID, New_Start_Time, New_End_Time,
        Role_Editing, Time_Stamp
    ) VALUES (
        OLD.Reservation_ID, OLD.User_ID, OLD.Room_ID, OLD.Start_Time, OLD.End_Time,
        NEW.User_ID, NEW.Room_ID, NEW.Start_Time, NEW.End_Time,
        SESSION_USER, -- บันทึกว่าใครเป็นผู้แก้ไข
        CURRENT_TIMESTAMP
    );

    RETURN NEW;
END;
$$;

-- Trigger ที่จะทำงานเมื่อมีการอัปเดตข้อมูลใน RESERVATION
CREATE TRIGGER trg_editing_reservation
AFTER UPDATE ON "RESERVATION"
FOR EACH ROW
WHEN (OLD.User_ID IS DISTINCT FROM NEW.User_ID OR
      OLD.Room_ID IS DISTINCT FROM NEW.Room_ID OR
      OLD.Start_Time IS DISTINCT FROM NEW.Start_Time OR
      OLD.End_Time IS DISTINCT FROM NEW.End_Time)
EXECUTE FUNCTION editing_reservation();


