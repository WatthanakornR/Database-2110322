CREATE TABLE IF NOT EXISTS "LOG" (
    Log_ID SERIAL PRIMARY KEY,
    Log_Type VARCHAR(50) NOT NULL, -- (login, logout, reservation_created, etc.)
    User_ID INT,                   
    Action_ID INT,                 
    Table_Name VARCHAR(50),        
    Old_Value TEXT,              
    New_Value TEXT,                
    Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    IP_Address VARCHAR(50)        
);

-- Trigger user_login
CREATE OR REPLACE FUNCTION log_user_login() RETURNS TRIGGER AS $$
BEGIN
    -- ป้องกันไม่ให้ทำงานซ้ำเมื่อเป็นการแทรกข้อมูลลงใน LOG
    IF TG_TABLE_NAME = 'log' THEN
        RETURN NULL;
    END IF;

    INSERT INTO "LOG" (Log_Type, User_ID, Timestamp, IP_Address)
    VALUES ('login', NEW.User_ID, CURRENT_TIMESTAMP, inet_client_addr());

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_room_status_on_reservation_change() 
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
BEGIN
    -- หากมีการแก้ไขการจองในห้องที่มีสถานะจองแล้ว
    IF TG_OP = 'UPDATE' AND 
       (OLD.Room_ID IS DISTINCT FROM NEW.Room_ID OR
        OLD.Start_Time IS DISTINCT FROM NEW.Start_Time OR
        OLD.End_Time IS DISTINCT FROM NEW.End_Time) THEN

        -- อัปเดตสถานะห้องที่เคยจองให้เป็น "ว่าง"
        UPDATE "ROOM"
        SET Status = 'Available'
        WHERE Room_ID = OLD.Room_ID;

        -- อัปเดตสถานะห้องใหม่ให้เป็น "จองแล้ว"
        UPDATE "ROOM"
        SET Status = 'Booked'
        WHERE Room_ID = NEW.Room_ID;

    -- หากการจองถูกลบ
    ELSIF TG_OP = 'DELETE' THEN
        -- อัปเดตสถานะห้องให้เป็น "ว่าง"
        UPDATE "ROOM"
        SET Status = 'Available'
        WHERE Room_ID = OLD.Room_ID;
    END IF;

    RETURN NEW;
END;
$$;

-- Trigger สำหรับการแก้ไขและลบการจอง
CREATE TRIGGER trg_update_room_status_on_change
AFTER UPDATE OR DELETE ON "RESERVATION"
FOR EACH ROW
EXECUTE FUNCTION update_room_status_on_reservation_change();
