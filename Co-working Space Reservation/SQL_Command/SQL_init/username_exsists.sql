--Approve
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