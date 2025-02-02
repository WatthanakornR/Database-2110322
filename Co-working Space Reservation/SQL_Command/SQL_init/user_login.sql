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