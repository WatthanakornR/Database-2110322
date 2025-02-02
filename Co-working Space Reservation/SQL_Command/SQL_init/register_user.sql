--Approve
-- Procedure to register a user
CREATE OR REPLACE PROCEDURE register_user(uname VARCHAR, passw VARCHAR, u_phone VARCHAR, u_email VARCHAR, u_role INT)
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