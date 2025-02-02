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

CREATE OR REPLACE FUNCTION Admin_editing_reservation() 
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
BEGIN
    -- Update the reservation
    UPDATE "RESERVATION"
    SET User_ID = NEW.User_ID,
        Room_ID = NEW.Room_ID,
        Start_Time = NEW.Start_Time,
        End_Time = NEW.End_Time
    WHERE Reservation_ID = OLD.Reservation_ID;
    
    -- Log the changes
    INSERT INTO Editing_reservation_log (
        Reservation_ID, User_ID, Room_ID, Start_Time, End_Time,
        New_User_ID, New_Room_ID, New_Start_Time, New_End_Time,
        Role_Editing
    ) VALUES (
        OLD.Reservation_ID, OLD.User_ID, OLD.Room_ID, OLD.Start_Time, OLD.End_Time,
        NEW.User_ID, NEW.Room_ID, NEW.Start_Time, NEW.End_Time,
        'Admin'
    );

    RETURN NEW;
END;
$$;


CREATE TRIGGER trg_Admin_editing_reservation
AFTER UPDATE ON "RESERVATION"
FOR EACH ROW
WHEN (OLD.User_ID IS DISTINCT FROM NEW.User_ID OR
      OLD.Room_ID IS DISTINCT FROM NEW.Room_ID OR
      OLD.Start_Time IS DISTINCT FROM NEW.Start_Time OR
      OLD.End_Time IS DISTINCT FROM NEW.End_Time)
EXECUTE FUNCTION Admin_editing_reservation();

