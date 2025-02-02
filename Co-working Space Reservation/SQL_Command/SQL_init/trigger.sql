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
CREATE OR REPLACE FUNCTION log_user_login()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO "LOG" (Log_Type, User_ID, Timestamp, IP_Address)
    VALUES ('login', NEW.User_ID, CURRENT_TIMESTAMP, inet_client_addr());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER user_login_trigger
AFTER INSERT ON "LOG"
FOR EACH ROW
WHEN (NEW.Log_Type = 'login')
EXECUTE FUNCTION log_user_login();


--Reservation Actions
-- Trigger เมื่อการจองห้องถูกสร้าง
CREATE OR REPLACE FUNCTION log_reservation_creation()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO "LOG" (Log_Type, User_ID, Action_ID, Table_Name, Timestamp)
    VALUES ('reservation_created', NEW.User_ID, NEW.Reservation_ID, 'RESERVATION', CURRENT_TIMESTAMP);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER reservation_creation_trigger
AFTER INSERT ON "RESERVATION"
FOR EACH ROW
EXECUTE FUNCTION log_reservation_creation();

-- Trigger เมื่อการจองห้องถูกแก้ไข
CREATE OR REPLACE FUNCTION log_reservation_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO "LOG" (Log_Type, User_ID, Action_ID, Table_Name, Old_Value, New_Value, Timestamp)
    VALUES ('reservation_updated', NEW.User_ID, NEW.Reservation_ID, 'RESERVATION', OLD.Start_Time || ' - ' || OLD.End_Time, NEW.Start_Time || ' - ' || NEW.End_Time, CURRENT_TIMESTAMP);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER reservation_update_trigger
AFTER UPDATE ON "RESERVATION"
FOR EACH ROW
EXECUTE FUNCTION log_reservation_update();

-- Trigger เมื่อการจองห้องถูกลบ
CREATE OR REPLACE FUNCTION log_reservation_deletion()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO "LOG" (Log_Type, User_ID, Action_ID, Table_Name, Timestamp)
    VALUES ('reservation_deleted', OLD.User_ID, OLD.Reservation_ID, 'RESERVATION', CURRENT_TIMESTAMP);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER reservation_deletion_trigger
AFTER DELETE ON "RESERVATION"
FOR EACH ROW
EXECUTE FUNCTION log_reservation_deletion();

--Admin

-- Trigger เมื่อมีการแก้ไขข้อมูลในตารางโดย Admin
CREATE OR REPLACE FUNCTION log_admin_changes()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO "LOG" (Log_Type, User_ID, Action_ID, Table_Name, Old_Value, New_Value, Timestamp)
    VALUES ('admin_update', NEW.User_ID, NEW.User_ID, TG_TABLE_NAME, OLD.Name, NEW.Name, CURRENT_TIMESTAMP);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER admin_update_trigger
AFTER UPDATE ON "REG_USER"
FOR EACH ROW
WHEN (NEW.Role_ID = 1)  -- เช็คว่าเป็น Admin
EXECUTE FUNCTION log_admin_changes();

-- Trigger เมื่อมีการลบข้อมูลโดย Admin
CREATE OR REPLACE FUNCTION log_admin_deletion()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO "LOG" (Log_Type, User_ID, Action_ID, Table_Name, Timestamp)
    VALUES ('admin_delete', NEW.User_ID, OLD.User_ID, TG_TABLE_NAME, CURRENT_TIMESTAMP);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER admin_delete_trigger
AFTER DELETE ON "REG_USER"
FOR EACH ROW
WHEN (OLD.Role_ID = 1)  -- เช็คว่าเป็น Admin
EXECUTE FUNCTION log_admin_deletion();

-- Trigger สำหรับการเกิดข้อผิดพลาดในระบบ
CREATE OR REPLACE FUNCTION log_error_event()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO "LOG" (Log_Type, User_ID, Action_ID, Table_Name, Timestamp)
    VALUES ('error_event', NEW.User_ID, NEW.Reservation_ID, 'RESERVATION', CURRENT_TIMESTAMP);
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER error_event_trigger
AFTER INSERT ON "LOG"
FOR EACH ROW
WHEN (NEW.Log_Type = 'error_event')
EXECUTE FUNCTION log_error_event();


