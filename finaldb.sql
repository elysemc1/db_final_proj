-- ////////////////////////// CREATE TABLES //////////////////////////
----------------------- 1. Pokemon Attributes -----------------------

-- Create table: Pokemon_Characters
CREATE TABLE Pokemon_Characters (
    -- auto_increment creates a unique ID each time we insert a Pokemon
    pokemon_id INT AUTO_INCREMENT PRIMARY KEY,
    -- assume no Pokemon will have a name longer than 50 characters
    pokemon_name VARCHAR(50) NOT NULL,
    -- TODO implement a function to ensure 1 <= generation <= 9
    generation INT NOT NULL,
    height FLOAT NOT NULL,
    weight FLOAT NOT NULL,
    -- gender ratio may be NULL if gender is unknown
    gender_ratio FLOAT, 
    base_exp INT
)

-- Create table: Pokemon_Types
-- This table links Pokemon to their Types, since this is many-to-many
CREATE TABLE Pokemon_Types (
    PRIMARY KEY (pokemon_id, type),
    -- CASCADE: if a Pokemon Character is deleted or a Type is deleted, delete this association too
    FOREIGN KEY (pokemon_id) REFERENCES Pokemon_Characters(pokemon_id) ON DELETE CASCADE,
    FOREIGN KEY (type) REFERENCES Types(type) ON DELETE CASCADE
)

-- Create table: Pokemon_Region
-- This table links Pokemon to their Regions, since this is many-to-many
CREATE TABLE Pokemon_Regions (
    PRIMARY KEY (pokemon_id, region_name),
    -- CASCADE: if a Pokemon Character is deleted, delete this association too
    FOREIGN KEY (pokemon_id) REFERENCES Pokemon_Characters(pokemon_id) ON DELETE CASCADE
)

-- Create table: Pokemon_Egg_Group
-- link Pokemon to their Egg Groups
CREATE TABLE Pokemon_Egg_Group (
    egg_group 
    PRIMARY KEY (pokemon_id, egg_group)
)

-- Create table: Types
CREATE TABLE Types (
    -- types may apply to pokemon characters and/or their attacks
    -- each type has a unique name, <= 8 chars
    type_name VARCHAR(8) PRIMARY KEY
)

-- Create table: Regions
CREATE TABLE Regions (
    -- assume region name is <= 50 chars and unique
    region_name VARCHAR(50) PRIMARY KEY
)

-- Create table: EV_Yield
CREATE TABLE EV_Yield (
    ev_strength INT,
    ev_ability VARCHAR(50),
    PRIMARY KEY (pokemon_id, ev_strength, ev_ability),
    FOREIGN KEY (pokemon_id) REFERENCES Pokemon_Characters(pokemon_id) ON DELETE CASCADE
)

-- Create table: Evolutions
CREATE TABLE Evolutions (
    PRIMARY KEY (evolved_id, original_id),
    -- RESTRICT: we CANNOT delete a Pokemon Character if they have existing evolutions
    FOREIGN KEY (evolved_id) REFERENCES Pokemon_Characters(pokemon_id) ON DELETE RESTRICT,
    FOREIGN KEY (original_id) REFERENCES Pokemon_Characters(pokemon_id) ON DELETE RESTRICT
)


------------------- 2. User and Team Associations -------------------
-- Create table: Favorites
CREATE TABLE Favorites (

)