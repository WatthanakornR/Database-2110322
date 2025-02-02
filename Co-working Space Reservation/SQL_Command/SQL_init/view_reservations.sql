CREATE OR REPLACE FUNCTION view_all_reservations()
RETURNS TABLE (
    Reservation_ID INT,
    User_ID INT,
    Room_ID INT,
    Time_Stamp TIMESTAMP,
    Start_Time TIMESTAMP,
    End_Time TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        r.Reservation_ID, 
        r.User_ID, 
        r.Room_ID, 
        r.Time_Stamp, 
        r.Start_Time, 
        r.End_Time
    FROM "RESERVATION" r
    WHERE r.Start_Time >= CURRENT_DATE
    ORDER BY r.Start_Time;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION view_reservations_by_user(p_user_id INT)
RETURNS TABLE (
    Reservation_ID INT,
    User_ID INT,
    Room_ID INT,
    Time_Stamp TIMESTAMP,
    Start_Time TIMESTAMP,
    End_Time TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        r.Reservation_ID, 
        r.User_ID, 
        r.Room_ID, 
        r.Time_Stamp, 
        r.Start_Time, 
        r.End_Time
    FROM "RESERVATION" r
    WHERE r.User_ID = p_user_id
      AND r.Start_Time >= CURRENT_DATE
    ORDER BY r.Start_Time;
END;
$$ LANGUAGE plpgsql;
