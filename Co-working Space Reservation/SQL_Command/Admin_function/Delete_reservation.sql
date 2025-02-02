-- Crate log table
CREATE TABLE IF NOT EXISTS Delete_reservation_log (
	Delete_ID SERIAL PRIMARY KEY,
	Reservation_ID INT ,
    User_ID INT ,
    Room_ID INT ,
    Start_Time TIMESTAMP NOT NULL,
    End_Time TIMESTAMP NOT NULL,
	Editing_ID int,
	Role_Editing varchar(255),
	Time_Stamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)


-- Function to delete reservation and log the action

CREATE OR REPLACE FUNCTION Admin_delete_reservation() 
RETURNS TRIGGER 
LANGUAGE plpgsql
AS 
$$
BEGIN
    -- Log the deletion in Delete_reservation_log
    INSERT INTO Delete_reservation_log (Reservation_ID, User_ID, Room_ID, Start_Time, End_Time, Editing_ID, Role_Editing, Time_Stamp)
    VALUES (OLD.Reservation_ID, OLD.User_ID, OLD.Room_ID, OLD.Start_Time, OLD.End_Time, NULL, 'Admin', CURRENT_TIMESTAMP);

    -- Delete the reservation
    --DELETE FROM "RESERVATION" WHERE Reservation_ID = OLD.Reservation_ID;

    RETURN OLD;
END;
$$


-- Trigger to call the function before delete
CREATE TRIGGER before_delete_reservation
BEFORE DELETE ON "RESERVATION"
FOR EACH ROW
WHEN (OLD.Reservation_ID IS NOT NULL)
EXECUTE FUNCTION Admin_delete_reservation();




