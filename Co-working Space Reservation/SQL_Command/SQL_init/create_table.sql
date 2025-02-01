
-- Table creation for 'role'
CREATE TABLE IF NOT EXISTS "ROLE" (
    Role_ID SERIAL PRIMARY KEY,
    RoleName VARCHAR(255) NOT NULL UNIQUE
);

-- Table creation for 'user'
CREATE TABLE IF NOT EXISTS "REG_USER" (
    User_ID SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    Phone_Number VARCHAR(20) NOT NULL UNIQUE,
    Email VARCHAR(255) NOT NULL UNIQUE,
    Role_ID INT REFERENCES "ROLE"(Role_ID) ON DELETE SET NULL
);

-- Table creation for 'coworking space'
CREATE TABLE IF NOT EXISTS "COWORKING_SPACE" (
    CoWorking_ID SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL UNIQUE,
    Address TEXT NOT NULL,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Phone_Number VARCHAR(20) NOT NULL UNIQUE,
    Email VARCHAR(50) NOT NULL UNIQUE,
    Open_Time TIME NOT NULL,
    Close_Time TIME NOT NULL,
    CoWorking_Facilities TEXT
);

-- Table creation for 'room'
CREATE TABLE IF NOT EXISTS "ROOM" (
    Room_ID SERIAL PRIMARY KEY,
    Price INT NOT NULL CHECK (Price >= 0),
    Capacity INT NOT NULL CHECK (Capacity > 0), 
    Status VARCHAR(50) NOT NULL CHECK (Status IN ('Available', 'Booked', 'Maintenance')),
    CoWorkingID INT REFERENCES "COWORKING_SPACE"(CoWorking_ID) ON DELETE CASCADE,
    Room_Facilities TEXT
);

-- Table creation for 'reservation'
CREATE TABLE IF NOT EXISTS "RESERVATION" (
    Reservation_ID SERIAL PRIMARY KEY,
    User_ID INT REFERENCES "REG_USER" (User_ID) ON DELETE SET NULL,
    Room_ID INT REFERENCES "ROOM" (Room_ID) ON DELETE CASCADE,
    Time_Stamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Start_Time TIMESTAMP NOT NULL,
    End_Time TIMESTAMP NOT NULL
);
