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
