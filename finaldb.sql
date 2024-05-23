-- ////////////////////////// CREATE TABLES //////////////////////////
-- --------------------- 1. Pokemon Attributes -----------------------
-- note that the order of these create statements matters due to dependencies

-- Create table: Pokemon_Characters
CREATE TABLE IF NOT EXISTS Pokemon_Characters (
    -- auto_increment creates a unique ID each time we insert a Pokemon
    pokemon_id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    -- assume no Pokemon will have a name longer than 50 characters
    pokemon_name VARCHAR(50) NOT NULL,
    -- TODO implement a function to ensure 1 <= generation <= 9
    generation INT NOT NULL,
    height FLOAT NOT NULL,
    weight FLOAT NOT NULL,
    -- gender ratio may be NULL if gender is unknown
    gender_ratio FLOAT, 
    base_exp INT
);

-- Create table: Types
CREATE TABLE IF NOT EXISTS Types (
    -- types may apply to pokemon characters and/or their attacks
    -- each type has a unique name, <= 8 chars
    type_name VARCHAR(8) PRIMARY KEY
);

-- Create table: Pokemon_Types
-- This table links Pokemon to their Types, since this is many-to-many
CREATE TABLE IF NOT EXISTS Pokemon_Types (
    pokemon_id INT NOT NULL,
    type_name VARCHAR(8) NOT NULL,
    PRIMARY KEY (pokemon_id, type_name),
    -- CASCADE: if a Pokemon Character is deleted or a Type is deleted, delete this association too
    -- note that this does NOT mean that deleting a Pokemon Character => deleting its type from Types
    FOREIGN KEY (pokemon_id) REFERENCES Pokemon_Characters (pokemon_id) ON DELETE CASCADE,
    FOREIGN KEY (type_name) REFERENCES Types (type_name) ON DELETE CASCADE
);

-- Create table: Regions
CREATE TABLE IF NOT EXISTS Regions (
    -- assume region name is <= 50 chars and unique
    region_name VARCHAR(50) PRIMARY KEY
);

-- Create table: Pokemon_Region
-- This table links Pokemon to their Regions, since this is many-to-many
CREATE TABLE IF NOT EXISTS Pokemon_Regions (
    pokemon_id INT NOT NULL,
    region_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (pokemon_id, region_name),
    -- CASCADE: if a Pokemon Character or Region is deleted, delete this association too
    FOREIGN KEY (pokemon_id) REFERENCES Pokemon_Characters (pokemon_id) ON DELETE CASCADE,
    FOREIGN KEY (region_name) REFERENCES Regions (region_name) ON DELETE CASCADE
);

-- Create table: Pokemon_Egg_Groups
-- link Pokemon to their Egg Groups, must be its own table since pokemon may have >=1 egg group
CREATE TABLE IF NOT EXISTS Pokemon_Egg_Groups (
    egg_group VARCHAR(14) NOT NULL,
    pokemon_id INT NOT NULL,
    PRIMARY KEY (pokemon_id, egg_group),
    FOREIGN KEY (pokemon_id) REFERENCES Pokemon_Characters(pokemon_id) ON DELETE CASCADE
);

-- Create table: Type_Efficacy
CREATE TABLE IF NOT EXISTS Type_Efficacy (
    -- this will be 0.0, 0.5, or 2.0
    type_effect FLOAT NOT NULL, 
    attacking_type VARCHAR(8) NOT NULL,
    defending_type VARCHAR(8) NOT NULL,
    PRIMARY KEY (attacking_type, defending_type),
    -- CASCADE: if we delete a type, we delete its efficacy association(s)
    FOREIGN KEY (attacking_type) REFERENCES Types (type_name) ON DELETE CASCADE,
    FOREIGN KEY (defending_type) REFERENCES Types (type_name) ON DELETE CASCADE
);

-- Create table: Attacks
CREATE TABLE IF NOT EXISTS Attacks (
    attack_name VARCHAR(50) PRIMARY KEY,
    category VARCHAR(8) NOT NULL,
    attack_type VARCHAR(8) NOT NULL,
    power_points INT NOT NULL,
    -- power, accuracy, and effect are optional
    power INT,
    accuracy FLOAT,
    effect VARCHAR (50),
    -- CASCADE: if we delete a type, we can't have an attack of that type, so delete the attack
    FOREIGN KEY (attack_type) REFERENCES Types (type_name) ON DELETE CASCADE
);

-- Create table: Pokemon_Attacks
CREATE TABLE IF NOT EXISTS Pokemon_Attacks (
    level_unlocked INT NOT NULL,
    pokemon_id INT NOT NULL,
    attack_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (pokemon_id, attack_name),
    -- CASCADE: if we delete a character or an attack, delete the association
    FOREIGN KEY (pokemon_id) REFERENCES Pokemon_Characters (pokemon_id) ON DELETE CASCADE,
    FOREIGN KEY (attack_name) REFERENCES Attacks (attack_name) ON DELETE CASCADE
);

-- Create table: EV_Yield
CREATE TABLE IF NOT EXISTS EV_Yield (
    pokemon_id INT NOT NULL,
    ev_strength INT,
    ev_ability VARCHAR(50),
    PRIMARY KEY (pokemon_id, ev_strength, ev_ability),
    FOREIGN KEY (pokemon_id) REFERENCES Pokemon_Characters (pokemon_id) ON DELETE CASCADE
);

-- Create table: Evolutions
CREATE TABLE IF NOT EXISTS Evolutions (
    evolved_id INT NOT NULL,
    original_id INT NOT NULL,
    PRIMARY KEY (evolved_id, original_id),
    -- RESTRICT: we CANNOT delete a Pokemon Character if they have existing evolutions
    FOREIGN KEY (evolved_id) REFERENCES Pokemon_Characters (pokemon_id) ON DELETE RESTRICT,
    FOREIGN KEY (original_id) REFERENCES Pokemon_Characters (pokemon_id) ON DELETE RESTRICT
);

-- ----------------- 2. User and Team Associations -------------------
-- Create table: Users
CREATE TABLE IF NOT EXISTS Users (
    user_id INT AUTO_INCREMENT NOT NULL,
    user_name VARCHAR(25) NOT NULL,
    -- TODO write a trigger/function to update this value when user CRUDs a team
    latest_team_id INT,
    PRIMARY KEY (user_id, latest_team_id)
);

-- Create table: Teams
CREATE TABLE IF NOT EXISTS Teams (
    user_id INT NOT NULL,
    team_id INT AUTO_INCREMENT NOT NULL,
    team_name VARCHAR(25) NOT NULL,
    PRIMARY KEY (team_id, user_id),
    -- CASCADE: if we delete a user, also delete their teams
    FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE CASCADE 
);

-- Create table: TeamMembers
CREATE TABLE IF NOT EXISTS TeamMembers (
    team_id INT NOT NULL,
    user_id INT NOT NULL,
    -- slot_id won't auto-increment, but will be unique within team/user combo since it's part of the pk
    slot_id INT NOT NULL,
    pokemon_id INT NOT NULL,
    pokemon_level INT NOT NULL,
    PRIMARY KEY (team_id, user_id, slot_id),
    -- CASCADE: if a Pokemon is deleted, it's also deleted from this team
    FOREIGN KEY (pokemon_id) REFERENCES Pokemon_Characters (pokemon_id) ON DELETE CASCADE,
    -- CASCADE: if we delete a team, delete all of its members
    FOREIGN KEY (team_id) REFERENCES Teams (team_id) ON DELETE CASCADE,
    -- CASCADE: if we delete a user, also delete their team associations
    FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE CASCADE
);

-- Create table: Favorites
CREATE TABLE IF NOT EXISTS Favorites (
    user_id INT NOT NULL,
    pokemon_id INT NOT NULL,
    PRIMARY KEY (user_id, pokemon_id),
    -- CASCADE: if we delete a user, also delete their favorites
    FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE CASCADE,
    -- CASCADE: if a Pokemon is deleted, it's also deleted from the favorites
    FOREIGN KEY (pokemon_id) REFERENCES Pokemon_Characters (pokemon_id) ON DELETE CASCADE
);

-- DO NOT UN-COMMENT 
-- keeping these around in case I need to reset the tables while testing
/*DROP TABLE IF EXISTS Pokemon_Characters;
DROP TABLE IF EXISTS Types;
DROP TABLE IF EXISTS Pokemon_Types;
DROP TABLE IF EXISTS Regions;
DROP TABLE IF EXISTS Pokemon_Regions;
DROP TABLE IF EXISTS Pokemon_Egg_Groups;
DROP TABLE IF EXISTS Type_Efficacy;
DROP TABLE IF EXISTS Attacks;
DROP TABLE IF EXISTS Pokemon_Attacks;
DROP TABLE IF EXISTS EV_Yield;
DROP TABLE IF EXISTS Evolutions;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Teams;
DROP TABLE IF EXISTS TeamMembers;
DROP TABLE IF EXISTS Favorites;*/

-- ///////////////////////// POPULATE TABLES /////////////////////////
-- this section populates the database with 10 example Pokemon and their evolutions
-- I will also add some users, teams, etc.
-- this should help demonstrate/test the functionality of the SQL and help the website programmers

-- populate Pokemon_Characters


-- //////////////////////// TRIGGERS/FUNCTIONS ///////////////////////