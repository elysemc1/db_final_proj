-- Made by Jace Palmer, Ellie Cohen, Jacob Strand, Lauren Edwardsen
-- Group 5



-- ////////////////////////// 1. CREATE TABLES //////////////////////////
-- --------------------- a) Pokemon Attributes -----------------------
-- note that the order of these create statements matters due to dependencies

-- Create table: Pokemon_Characters
CREATE TABLE IF NOT EXISTS Pokemon_Characters (
    -- auto_increment creates a unique ID each time we insert a Pokemon
    pokemon_id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    -- assume no Pokemon will have a name longer than 50 characters
    pokemon_name VARCHAR(50) NOT NULL,
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

-- ----------------- b) User and Team Associations -------------------
-- Create table: Users
CREATE TABLE IF NOT EXISTS Users (
    user_id INT AUTO_INCREMENT NOT NULL,
    user_name VARCHAR(25) NOT NULL,
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

-- Create table: Team_Members
CREATE TABLE IF NOT EXISTS Team_Members (
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

-- ///////////////////////// 2. DROP TABLES /////////////////////////
-- *** DO NOT UN-COMMENT THIS SECTION ***
-- these statements delete ALL TABLES, use this to clear the entire database
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
DROP TABLE IF EXISTS Team_Members;
DROP TABLE IF EXISTS Favorites;*/

-- ///////////////////////// 3. POPULATE TABLES /////////////////////////
-- this section populates the database with ~10 example Pokemon/evolutions
-- I will also add some users, teams, etc.
-- this should help demonstrate/test the functionality of the SQL and help the website programmers
-- CITATION: note that ChatGPT was used to help gather the information on pokemon to fill these tables with

-- populate Pokemon_Characters (first 4 and their evolutions, 12 total)
INSERT INTO Pokemon_Characters (pokemon_name, generation, height, weight, base_exp, gender_ratio)
VALUES
    -- note that height is in meters
    -- weight is in kilograms
    -- gender ratio is percent male
    ('Bulbasaur', 1, 0.7, 6.9, 64, 0.875),
    ('Ivysaur', 1, 1.0, 13.0, 142, 0.875),
    ('Venusaur', 1, 2.0, 100.0, 236, 0.875),
    ('Charmander', 1, 0.6, 8.5, 62, 0.875),
    ('Charmeleon', 1, 1.1, 19.0, 142, 0.875),
    ('Charizard', 1, 1.7, 90.5, 240, 0.875),
    ('Squirtle', 1, 0.5, 9.0, 63, 0.875),
    ('Wartortle', 1, 1.0, 22.5, 142, 0.875),
    ('Blastoise', 1, 1.6, 85.5, 239, 0.875),
    ('Caterpie', 1, 0.3, 2.9, 39, 0.5),
    ('Metapod', 1, 0.7, 9.9, 72, 0.5), 
    ('Butterfree', 1, 1.1, 32.0, 178, 0.5);

-- populate Evolutions
INSERT INTO Evolutions (evolved_id, original_id)
VALUES
    -- Bulbasaur
    (2, 1), -- Evolves into Ivysaur
    (3, 2), -- Evolves into Venusaur
    -- Charmander
    (5, 4), -- Evolves into Charmeleon
    (6, 5), -- Evolves into Charizard
    -- Squirtle
    (8, 7), -- Evolves into Wartortle
    (9, 8), -- Evolves into Blastoise
    -- Caterpie
    (11, 10), -- Evolves into Metapod
    (12, 11); -- Evolves into Butterfree

-- populate Types
INSERT INTO Types (type_name)
VALUES
    ('Normal'),
    ('Fire'),
    ('Water'),
    ('Electric'),
    ('Grass'),
    ('Ice'),
    ('Fighting'),
    ('Poison'),
    ('Ground'),
    ('Flying'),
    ('Psychic'),
    ('Bug'),
    ('Rock'),
    ('Ghost'),
    ('Dragon'),
    ('Dark'),
    ('Steel'),
    ('Fairy');

-- populate Pokemon_Types
INSERT INTO Pokemon_Types (pokemon_id, type_name)
VALUES
    -- Bulbasaur
    (1, 'Grass'),
    (1, 'Poison'),
    -- Ivysaur
    (2, 'Grass'),
    (2, 'Poison'),
    -- Venusaur
    (3, 'Grass'),
    (3, 'Poison'),
    -- Charmander
    (4, 'Fire'),
    -- Charmeleon
    (5, 'Fire'),
    -- Charizard
    (6, 'Fire'),
    (6, 'Flying'),
    -- Squirtle
    (7, 'Water'),
    -- Wartortle
    (8, 'Water'),
    -- Blastoise
    (9, 'Water'),
    -- Caterpie
    (10, 'Bug'),
    -- Metapod
    (11, 'Bug'),
    -- Butterfree
    (12, 'Bug'),
    (12, 'Flying');

-- populate Regions
INSERT INTO Regions (region_name)
VALUES
    ('Kanto'),
    ('Johto'),
    ('Hoenn'),
    ('Sinnoh'),
    ('Unova'),
    ('Kalos'),
    ('Alola'),
    ('Galar'),
    ('Paldea');

-- populate Pokemon_Regions
-- all of these first 4 Pokemon are from the Kanto region
INSERT INTO Pokemon_Regions (pokemon_id, region_name)
VALUES
    (1, 'Kanto'),
    (2, 'Kanto'),
    (3, 'Kanto'),
    (4, 'Kanto'),
    (5, 'Kanto'),
    (6, 'Kanto'),
    (7, 'Kanto'),
    (8, 'Kanto'),
    (9, 'Kanto'),
    (10, 'Kanto'),
    (11, 'Kanto'),
    (12, 'Kanto');

-- populate Pokemon_Egg_Groups
INSERT INTO Pokemon_Egg_Groups (pokemon_id, egg_group)
VALUES
    -- Bulbasaur
    (1, 'Monster'),
    (1, 'Grass'),
    -- Ivysaur
    (2, 'Monster'),
    (2, 'Grass'),
    -- Venusaur
    (3, 'Monster'),
    (3, 'Grass'),
    -- Charmander
    (4, 'Monster'),
    (4, 'Dragon'),
    -- Charmeleon
    (5, 'Monster'),
    (5, 'Dragon'),
    -- Charizard
    (6, 'Monster'),
    (6, 'Dragon'),
    -- Squirtle
    (7, 'Monster'),
    (7, 'Water 1'),
    -- Wartortle
    (8, 'Monster'),
    (8, 'Water 1'),
    -- Blastoise
    (9, 'Monster'),
    (9, 'Water 1'),
    -- Caterpie
    (10, 'Bug'),
    -- Metapod
    (11, 'Bug'),
    -- Butterfree
    (12, 'Bug');

-- populate Type_Efficacy
-- based on Pokemon Type Effectiveness chart
-- how effective an attack of <attacking_type> is against pokemon of <defending_type>
INSERT INTO Type_Efficacy (attacking_type, defending_type, type_effect)
VALUES
    -- Normal type
    ('Normal', 'Rock', 0.5),
    ('Normal', 'Ghost', 0.0),
    ('Normal', 'Steel', 0.5),

    -- Fire type
    ('Fire', 'Fire', 0.5),
    ('Fire', 'Water', 0.5),
    ('Fire', 'Grass', 2.0),
    ('Fire', 'Ice', 2.0),
    ('Fire', 'Bug', 2.0),
    ('Fire', 'Rock', 0.5),
    ('Fire', 'Dragon', 0.5),
    ('Fire', 'Steel', 2.0),

    -- Water type
    ('Water', 'Fire', 2.0),
    ('Water', 'Water', 0.5),
    ('Water', 'Grass', 0.5),
    ('Water', 'Ground', 2.0),
    ('Water', 'Rock', 2.0),
    ('Water', 'Dragon', 0.5),

    -- Electric type
    ('Electric', 'Water', 2.0),
    ('Electric', 'Electric', 0.5),
    ('Electric', 'Grass', 0.5),
    ('Electric', 'Ground', 0.0),
    ('Electric', 'Flying', 2.0),
    ('Electric', 'Dragon', 0.5),

    -- Grass type
    ('Grass', 'Fire', 0.5),
    ('Grass', 'Water', 2.0),
    ('Grass', 'Grass', 0.5),
    ('Grass', 'Poison', 0.5),
    ('Grass', 'Ground', 2.0),
    ('Grass', 'Flying', 0.5),
    ('Grass', 'Bug', 0.5),
    ('Grass', 'Rock', 2.0),
    ('Grass', 'Dragon', 0.5),
    ('Grass', 'Steel', 0.5),

    -- Ice type
    ('Ice', 'Fire', 0.5),
    ('Ice', 'Water', 0.5),
    ('Ice', 'Grass', 2.0),
    ('Ice', 'Ice', 0.5),
    ('Ice', 'Ground', 2.0),
    ('Ice', 'Flying', 2.0),
    ('Ice', 'Dragon', 2.0),
    ('Ice', 'Steel', 0.5),

    -- Fighting type
    ('Fighting', 'Normal', 2.0),
    ('Fighting', 'Fire', 1.0),
    ('Fighting', 'Water', 1.0),
    ('Fighting', 'Electric', 1.0),
    ('Fighting', 'Grass', 1.0),
    ('Fighting', 'Ice', 2.0),
    ('Fighting', 'Fighting', 1.0),
    ('Fighting', 'Poison', 0.5),
    ('Fighting', 'Ground', 1.0),
    ('Fighting', 'Flying', 0.5),
    ('Fighting', 'Psychic', 0.5),
    ('Fighting', 'Bug', 0.5),
    ('Fighting', 'Rock', 2.0),
    ('Fighting', 'Ghost', 0.0),
    ('Fighting', 'Dragon', 1.0),
    ('Fighting', 'Dark', 2.0),
    ('Fighting', 'Steel', 2.0),
    ('Fighting', 'Fairy', 0.5),

    -- Poison type
    ('Poison', 'Grass', 2.0),
    ('Poison', 'Poison', 0.5),
    ('Poison', 'Ground', 0.5),
    ('Poison', 'Rock', 0.5),
    ('Poison', 'Ghost', 0.5),
    ('Poison', 'Steel', 0.0),
    ('Poison', 'Fairy', 2.0),

    -- Ground type
    ('Ground', 'Fire', 2.0),
    ('Ground', 'Electric', 2.0),
    ('Ground', 'Grass', 0.5),
    ('Ground', 'Poison', 2.0),
    ('Ground', 'Flying', 0.0),
    ('Ground', 'Bug', 0.5),
    ('Ground', 'Rock', 2.0),
    ('Ground', 'Steel', 2.0),

    -- Flying type
    ('Flying', 'Electric', 0.5),
    ('Flying', 'Grass', 2.0),
    ('Flying', 'Fighting', 2.0),
    ('Flying', 'Bug', 2.0),
    ('Flying', 'Rock', 0.5),
    ('Flying', 'Steel', 0.5),

    -- Psychic type
    ('Psychic', 'Fighting', 2.0),
    ('Psychic', 'Poison', 2.0),
    ('Psychic', 'Psychic', 0.5),
    ('Psychic', 'Dark', 0.0),
    ('Psychic', 'Steel', 0.5),

    -- Bug type
    ('Bug', 'Fire', 0.5),
    ('Bug', 'Grass', 2.0),
    ('Bug', 'Fighting', 0.5),
    ('Bug', 'Poison', 0.5),
    ('Bug', 'Flying', 0.5),
    ('Bug', 'Psychic', 2.0),
    ('Bug', 'Ghost', 0.5),
    ('Bug', 'Dark', 2.0),
    ('Bug', 'Steel', 0.5),
    ('Bug', 'Fairy', 0.5),

    -- Rock type
    ('Rock', 'Fire', 2.0),
    ('Rock', 'Ice', 2.0),
    ('Rock', 'Fighting', 0.5),
    ('Rock', 'Ground', 0.5),
    ('Rock', 'Flying', 2.0),
    ('Rock', 'Bug', 2.0),
    ('Rock', 'Steel', 0.5),

    -- Ghost type
    ('Ghost', 'Normal', 0.0),
    ('Ghost', 'Psychic', 2.0),
    ('Ghost', 'Ghost', 2.0),
    ('Ghost', 'Dark', 0.5),

    -- Dragon type
    ('Dragon', 'Dragon', 2.0),
    ('Dragon', 'Steel', 0.5),
    ('Dragon', 'Fairy', 0.0),

    -- Dark type
    ('Dark', 'Fighting', 0.5),
    ('Dark', 'Psychic', 2.0),
    ('Dark', 'Ghost', 2.0),
    ('Dark', 'Dark', 0.5),
    ('Dark', 'Fairy', 0.5),

    -- Steel type
    ('Steel', 'Fire', 0.5),
    ('Steel', 'Water', 0.5),
    ('Steel', 'Electric', 0.5),
    ('Steel', 'Ice', 2.0),
    ('Steel', 'Rock', 2.0),
    ('Steel', 'Steel', 0.5),
    ('Steel', 'Fairy', 2.0),

    -- Fairy type
    ('Fairy', 'Fire', 0.5),
    ('Fairy', 'Fighting', 2.0),
    ('Fairy', 'Poison', 0.5),
    ('Fairy', 'Dragon', 2.0),
    ('Fairy', 'Dark', 2.0),
    ('Fairy', 'Steel', 0.5);

-- Insert data into the Attacks table
INSERT INTO Attacks (attack_name, category, attack_type, power_points, power, accuracy, effect)
VALUES
    -- Bulbasaur 
    ('Tackle', 'Physical', 'Normal', 35, 40, 1.0, NULL),
    ('Growl', 'Status', 'Normal', 40, NULL, 1.0, "Lowers the opponent's Attack"),
    ('Vine Whip', 'Physical', 'Grass', 25, 45, 1.0, NULL),
    ('Leech Seed', 'Status', 'Grass', 10, NULL, 0.9, 'Drains HP from opponent'),
    -- Ivysaur
    ('Razor Leaf', 'Physical', 'Grass', 25, 55, 0.95, 'High critical hit ratio'),
    -- Venusaur
    ('Solar Beam', 'Special', 'Grass', 10, 120, 1.0, 'Charges on first turn, attacks on second'),
    -- Charmander
    ('Scratch', 'Physical', 'Normal', 35, 40, 1.0, NULL),
    ('Ember', 'Special', 'Fire', 25, 40, 1.0, 'May cause burn'),
    -- Charmeleon
    ('Dragon Rage', 'Special', 'Dragon', 10, 0, 1.0, 'Always inflicts 40 HP damage'),
    -- Charizard
    ('Flamethrower', 'Special', 'Fire', 15, 90, 1.0, 'May cause burn'),
    -- Squirtle
    ('Tail Whip', 'Status', 'Normal', 30, NULL, 1.0, "Lowers the opponent's Defense"),
    ('Water Gun', 'Special', 'Water', 25, 40, 1.0, NULL),
    -- Wartortle
    ('Bite', 'Physical', 'Dark', 25, 60, 1.0, 'May cause flinching'),
    -- Blastoise
    ('Hydro Pump', 'Special', 'Water', 5, 110, 0.8, NULL),
    -- Caterpie
    ('String Shot', 'Status', 'Bug', 40, NULL, 0.95, "Lowers the opponent's Speed"),
    -- Metapod
    ('Harden', 'Status', 'Normal', 30, NULL, NULL, "Raises the user's Defense"),
    -- Butterfree
    ('Confusion', 'Special', 'Psychic', 25, 50, 1.0, 'May cause confusion'),
    ('Gust', 'Special', 'Flying', 35, 40, 1.0, NULL),
    ('Stun Spore', 'Status', 'Grass', 30, NULL, 0.75, 'May paralyze the opponent'),
    ('Poison Powder', 'Status', 'Poison', 35, NULL, 0.75, 'May poison the opponent');

-- populate Pokemon_Attacks
INSERT INTO Pokemon_Attacks (pokemon_id, attack_name, level_unlocked)
VALUES
    -- Bulbasaur
    (1, 'Tackle', 1),
    (1, 'Growl', 3),
    (1, 'Vine Whip', 7),
    (1, 'Leech Seed', 9),
    (1, 'Razor Leaf', 13),
    (1, 'Solar Beam', 20),

    -- Ivysaur
    (2, 'Tackle', 1),
    (2, 'Growl', 3),
    (2, 'Vine Whip', 7),
    (2, 'Leech Seed', 9),
    (2, 'Razor Leaf', 13),
    (2, 'Solar Beam', 20),

    -- Venusaur
    (3, 'Tackle', 1),
    (3, 'Growl', 3),
    (3, 'Vine Whip', 7),
    (3, 'Leech Seed', 9),
    (3, 'Razor Leaf', 13),
    (3, 'Solar Beam', 20),

    -- Charmander
    (4, 'Scratch', 1),
    (4, 'Growl', 3),
    (4, 'Ember', 7),
    (4, 'Dragon Rage', 15),
    (4, 'Flamethrower', 30),

    -- Charmeleon
    (5, 'Scratch', 1),
    (5, 'Growl', 3),
    (5, 'Ember', 7),
    (5, 'Dragon Rage', 15),
    (5, 'Flamethrower', 30),

    -- Charizard
    (6, 'Scratch', 1),
    (6, 'Growl', 3),
    (6, 'Ember', 7),
    (6, 'Dragon Rage', 15),
    (6, 'Flamethrower', 30),

    -- Squirtle
    (7, 'Tackle', 1),
    (7, 'Tail Whip', 4),
    (7, 'Water Gun', 7),
    (7, 'Bite', 10),
    (7, 'Hydro Pump', 30),

    -- Wartortle
    (8, 'Tackle', 1),
    (8, 'Tail Whip', 4),
    (8, 'Water Gun', 7),
    (8, 'Bite', 10),
    (8, 'Hydro Pump', 30),

    -- Blastoise
    (9, 'Tackle', 1),
    (9, 'Tail Whip', 4),
    (9, 'Water Gun', 7),
    (9, 'Bite', 10),
    (9, 'Hydro Pump', 30),

    -- Caterpie
    (10, 'Tackle', 1),
    (10, 'String Shot', 1),

    -- Metapod
    (11, 'Harden', 1),

    -- Butterfree
    (12, 'Confusion', 1),
    (12, 'Gust', 1),
    (12, 'Stun Spore', 12),
    (12, 'Poison Powder', 14);

-- Insert data into the EV_Yield table
INSERT INTO EV_Yield (pokemon_id, ev_strength, ev_ability)
VALUES
    -- Bulbasaur yields 1 Special Attack EV
    (1, 1, 'Special Attack'),

    -- Ivysaur yields 2 Special Attack EVs
    (2, 2, 'Special Attack'),

    -- Venusaur yields 3 Special Attack EVs
    (3, 3, 'Special Attack'),

    -- Charmander yields 1 Speed EV
    (4, 1, 'Speed'),

    -- Charmeleon yields 2 Speed EVs
    (5, 2, 'Speed'),

    -- Charizard yields 3 Speed EVs
    (6, 3, 'Speed'),

    -- Squirtle yields 1 Defense EV
    (7, 1, 'Defense'),

    -- Wartortle yields 2 Defense EVs
    (8, 2, 'Defense'),

    -- Blastoise yields 3 Defense EVs
    (9, 3, 'Defense'),

    -- Caterpie yields 1 HP EV
    (10, 1, 'HP'),

    -- Metapod yields 2 Defense EVs
    (11, 2, 'Defense'),

    -- Butterfree yields 3 Special Attack EVs
    (12, 3, 'Special Attack');

INSERT INTO Users (user_name, latest_team_id)
VALUES 
    ("Ellie", NULL), -- user ID 1
    ("Jace", NULL), -- user ID 2
    ("Lauren", NULL), -- user ID 3
    ("Jacob", NULL); -- user ID 4

INSERT INTO Teams (user_id, team_name)
VALUES
    (1, "NormieTeam"), -- team ID 1
    (1, "BuffTeam"), -- team ID 2
    (2, "AllBulbasaur"); -- team ID 3

INSERT INTO Team_Members (team_id, user_id, slot_id, pokemon_id, pokemon_level)
VALUES 
    -- manually select a slot value between 1 and 6
    -- create a team of first 6 Pokemon at levels 1-6
    -- NormieTeam
    (1, 1, 1, 1, 1),
    (1, 1, 2, 2, 2),
    (1, 1, 3, 3, 3),
    (1, 1, 4, 4, 4),
    (1, 1, 5, 5, 5),
    (1, 1, 6, 6, 6),

    -- create a team of 4 powerful evolutions at level 20
    -- BuffTeam
    (2, 1, 1, 3, 20),
    (2, 1, 2, 6, 20),
    (2, 1, 3, 9, 20),
    (2, 1, 4, 12, 20),

    -- create a team with multiple of the same Pokemon (all 6 Bulbasaur)
    -- AllBulbasaur
    (3, 2, 1, 1, 5),
    (3, 2, 2, 1, 5),
    (3, 2, 3, 1, 10),
    (3, 2, 4, 1, 3),
    (3, 2, 5, 1, 7),
    (3, 2, 6, 1, 5);

INSERT INTO Favorites (user_id, pokemon_id)
VALUES 
    -- Ellie likes Caterpie and its evolutions
    (1, 10),
    (1, 11),
    (1, 12),
    -- Jace must be a bulbasaur fan
    (2, 1),
    -- Lauren is giving Ivysaur 
    (3, 2),
    -- Jacob gets all the Charmander evolutions
    (4, 4),
    (4, 5),
    (4, 6);

-- ////////////////////////// 4. SQL QUERIES //////////////////////////
-- 6 queries of CREATE, RETRIEVE, UPDATE, DELETE (CRUD) operations
-- 1) insert level 0 Squirtle into BuffTeam at slot 5 (C)
INSERT INTO Team_Members (team_id, user_id, slot_id, pokemon_id, pokemon_level)
VALUES (2, 1, 5, 7, 0); 

-- 2) delete the level 0 Squirtle from BuffTeam using the primary key (D)
DELETE FROM Team_Members
WHERE team_id = 2
AND slot_id = 5
AND user_id = 1;

-- 3) select all Pokemon in the database that are of the Water type (R)
SELECT pokemon_name, type_name
FROM Pokemon_Types, Pokemon_Characters 
WHERE type_name = 'Water'
AND Pokemon_Types.pokemon_id = Pokemon_Characters.pokemon_id;

-- 4) level up the pokemon in slot 1 of NormieTeam (team 1) (U)
UPDATE Team_Members 
SET pokemon_level = pokemon_level + 1
WHERE team_id = 1
AND slot_id = 1
AND user_id = 1;

-- 5) show the next evolution of Bulbasaur (R)
SELECT P1.pokemon_name, P2.pokemon_name AS 'evolved_name'
FROM Pokemon_Characters P1, Evolutions
JOIN Pokemon_Characters P2 ON P2.pokemon_id = Evolutions.evolved_id
WHERE P1.pokemon_name = 'Bulbasaur'
AND P1.pokemon_id = Evolutions.original_id;

-- 6) show Pokemon that are in both NormieTeam and BuffTeam (R)
SELECT pokemon_name
FROM Pokemon_Characters, Team_Members
WHERE Pokemon_Characters.pokemon_id IN (SELECT pokemon_id FROM Team_Members WHERE team_id = 1) 
AND Pokemon_Characters.pokemon_id IN (SELECT pokemon_id FROM Team_Members WHERE team_id = 2)
GROUP BY pokemon_name;

-- //////////////////////// 5. TRIGGERS/FUNCTIONS /////////////////////
-- require at least 3 triggers/functions/procedures
-- 1) Insert a Pokemon to a Team via user name, team name, and pokemon name at level 0
--    Make sure no more than 6 slots are filled
DELIMITER //
CREATE FUNCTION addToTeam(user_name VARCHAR(25), team_name VARCHAR(25), pokemon_name VARCHAR(50))
    RETURNS INT -- return 0 if we were able to complete the insertion, 1 otherwise
    
    BEGIN
        DECLARE sid INT;
        SET sid = (SELECT MAX(slot_id) + 1 AS sid FROM Team_Members WHERE team_id IN (SELECT team_id FROM Teams WHERE Teams.team_name = team_name));
        IF sid > 6 THEN
            RETURN 1;
        ELSE
            INSERT INTO Team_Members (user_id, team_id, slot_id, pokemon_id, pokemon_level)
            VALUES (
                (SELECT user_id FROM Users WHERE Users.user_name = user_name),
                (SELECT team_id FROM Teams WHERE Teams.team_name = team_name),
                sid,
                (SELECT pokemon_id FROM Pokemon_Characters WHERE Pokemon_Characters.pokemon_name = pokemon_name),
                0
            );
        END IF;
        RETURN 0;
    END //
DELIMITER ;
-- Confirm the function works by adding two team members (Squirtle) and failing to add a third (since that would be more than 6 members)
SELECT addToTeam('Ellie', 'BuffTeam', 'Squirtle');
SELECT addToTeam('Ellie', 'BuffTeam', 'Squirtle');
SELECT addToTeam('Ellie', 'BuffTeam', 'Squirtle');

-- 2) Remove a Pokemon from a team via user_name, slot_id, and team_name
--    Don't remove if there is only 1 member of the team
DELIMITER //
CREATE FUNCTION removeFromTeam(user_name VARCHAR(25), team_name VARCHAR(25), slot INT)
    RETURNS INT -- return 0 if we were able to complete the deletion, 1 otherwise
    
    BEGIN
        DECLARE sid INT; -- simply to make sure we won't end up with an empty team by removing a member
        SET sid = (SELECT MAX(slot_id) - 1 AS sid FROM Team_Members WHERE team_id IN (SELECT team_id FROM Teams WHERE Teams.team_name = team_name));
        IF sid < 1 THEN
            RETURN 1;
        ELSE
            DELETE FROM Team_Members 
            WHERE team_id = (SELECT team_id FROM Teams WHERE Teams.team_name = team_name)
            AND user_id = (SELECT user_id FROM Users WHERE Users.user_name = user_name)
            AND slot_id = slot;
        END IF;
        RETURN 0;
    END //
DELIMITER ;
-- Confirm the function works by deleting the 2 previously added Squirtles
SELECT removeFromTeam('Ellie', 'BuffTeam', 6);
SELECT removeFromTeam('Ellie', 'BuffTeam', 5);

-- 3) Add a pokemon to the user's favorites by user name and pokemon name 
--    Make sure no more than 30 favorites exist
DELIMITER //
CREATE FUNCTION addToFavs(user_name VARCHAR(25), pokemon_name VARCHAR(50))
    RETURNS INT -- return 0 if we were able to complete the insertion, 1 otherwise
    
    BEGIN
        DECLARE num_favs INT; -- simply to make sure we won't end up with an empty team by removing a member
        SET num_favs = (SELECT COUNT(user_id) AS num_favs FROM Favorites WHERE user_id IN (SELECT user_id FROM Users WHERE Users.user_name = user_name));
        IF num_favs >= 30 THEN
            RETURN 1;
        ELSE
            INSERT INTO Favorites (user_id, pokemon_id)
            VALUES (
                (SELECT user_id FROM Users WHERE Users.user_name = user_name),
                (SELECT pokemon_id FROM Pokemon_Characters WHERE Pokemon_Characters.pokemon_name = pokemon_name)
            );
        END IF;
        RETURN 0;
    END //
DELIMITER ;
-- Confirm the function works by adding Squirtle and Bulbasaur to my favorites
SELECT addToFavs('Ellie', 'Squirtle');
SELECT addToFavs('Ellie', 'Bulbasaur');

-- 4) Delete a pokemon from a user's favorites by user name and pokemon name
DELIMITER //
CREATE PROCEDURE delFromFavs(user_name VARCHAR(25), pokemon_name VARCHAR(50))
    BEGIN
        DELETE FROM Favorites
        WHERE user_id = (SELECT user_id FROM Users WHERE Users.user_name = user_name)
        AND pokemon_id = (SELECT pokemon_id FROM Pokemon_Characters WHERE Pokemon_Characters.pokemon_name = pokemon_name);
    END //
DELIMITER ;
-- Confirm the function works by deleting Squirtle and Bulbasaur from my favorites
CALL delFromFavs('Ellie', 'Squirtle');
CALL delFromFavs('Ellie', 'Bulbasaur');

-- 5) Update latest_updated_team if a user inserts, deletes, or updates their teams/members
DELIMITER //
CREATE TRIGGER teamUpdate AFTER UPDATE ON Teams
    FOR EACH ROW
    BEGIN
        UPDATE Users
        SET Users.latest_team_id = NEW.team_id
        WHERE user_id = NEW.user_id;
    END //
DELIMITER ;
-- test this by updating the level on team 1
UPDATE Team_Members
SET pokemon_level = 10
WHERE user_id = 1
AND team_id = 1 
AND pokemon_id = 1;
-- another trigger for INSERT...
DELIMITER //
CREATE TRIGGER teamInsert AFTER INSERT ON Teams
    FOR EACH ROW
    BEGIN
        UPDATE Users
        SET Users.latest_team_id = NEW.team_id
        WHERE user_id = NEW.user_id;
    END //
DELIMITER ;
-- and another for DELETE
DELIMITER //
CREATE TRIGGER teamDelete AFTER DELETE ON Teams
    FOR EACH ROW
    BEGIN
        UPDATE Users
        -- set to null, which for an int is 0
        SET Users.latest_team_id = 0
        WHERE user_id = OLD.user_id;
    END //
DELIMITER ;

-- 6) Search for Pokemon by type
DELIMITER //
CREATE PROCEDURE searchByType(type_name VARCHAR(8))
    BEGIN
        SELECT Pokemon_Characters.*
        FROM Pokemon_Characters
        JOIN Pokemon_Types ON Pokemon_Characters.pokemon_id = Pokemon_Types.pokemon_id
        WHERE Pokemon_Types.type_name = type_name;
    END //
DELIMITER ;
-- test by searching for water type
CALL searchByType('Water');

-- 7) Search for Pokemon by name
DELIMITER //
CREATE PROCEDURE searchByName(pokemon_name VARCHAR(50))
    BEGIN
        SELECT Pokemon_Characters.*
        FROM Pokemon_Characters
        WHERE Pokemon_Characters.pokemon_name = pokemon_name;
    END //
DELIMITER ;
-- test by searching for Squirtle
CALL searchByName('Squirtle');

-- 8) Search for Pokemon by ID
DELIMITER //
CREATE PROCEDURE searchById(pokemon_id INT)
    BEGIN
        SELECT Pokemon_Characters.*
        FROM Pokemon_Characters
        WHERE Pokemon_Characters.pokemon_id = pokemon_id;
    END //
DELIMITER ;
-- test by searching for Pokemon with ID 9
CALL searchById(9);

-- 9) See a Pokemon's next evolution based on their name
DELIMITER //
CREATE PROCEDURE getEvolution(pokemon_name VARCHAR(50))
    BEGIN
        SELECT P1.pokemon_name, P2.pokemon_name AS 'evolved_name'
        FROM Pokemon_Characters P1, Evolutions
        JOIN Pokemon_Characters P2 ON P2.pokemon_id = Evolutions.evolved_id
        WHERE P1.pokemon_name = pokemon_name
        AND P1.pokemon_id = Evolutions.original_id;
    END //
DELIMITER ;
-- get Caterpie's and Metapod's evolutions to test
CALL getEvolution('Caterpie'); -- Metapod
CALL getEvolution('Metapod'); -- Butterfree