-- defines users table
CREATE TABLE users (
  userId STRING NOT NULL,             -- uid from Firebase Auth
  userName STRING NOT NULL,                    
  userEmail STRING NOT NULL,                  
  userPassword STRING NOT NULL,      -- hashed password
  userCreateAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- creation date 
  PRIMARY KEY(userId)
);
