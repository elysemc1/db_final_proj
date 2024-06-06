<?php
    mysqli_report(MYSQLI_REPORT_ERROR );

    //   Change for your username, password and datadase name which is your username 

    define('DB_SERVER', 'classmysql.engr.oregonstate.edu');
    define('DB_USERNAME', 'cs340_palmjace');
    define('DB_PASSWORD', '1982');
    define('DB_NAME', 'cs340_palmjace');
 
	// Attempt to connect to MySQL database
	$link = mysqli_connect(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_NAME);
 
	// Check connection
	if($link === false){
		exit("ERROR: Could not connect. " . mysqli_connect_error());
	}	

    /* TODO:

	WHO DOES WHAT
	
	Jace
	- Create
	- Delete
	- Search

	Jacob
	- Update
	- View

	Undecided
	- Compare

	MUST DO
	- The user can create, edit, and delete teams of Pokemon to simulate in-game teams
	-- pages made
	- The user can search for Pokemon by type, number, or name
	-- page made
	- When a user is viewing a Pokemon, they can also see its evolution options
	-- page made
	- A user can compare two different Pokemon and identify which is stronger 
	-- page made
	- Users can add Pokemon to their ‘favorites’ list
	-- pages made

	MUST DO REQUIREMENTS
	- The user can select up to 6 Pokemon for their team
	- The user can have a maximum of 30 favorites 
	- The user can compare only 2 Pokemon at once
	- Each Pokemon can be identified uniquely by an ID
	- Each attack will be uniquely identified by its name
	- Each Pokemon that is added to the database must include one or more types

	STRETCH GOALS
	- The user could test their team in an attack against other teams
	- The user can select up to 5 Pokemon in the comparison screen
	- Sesions for users
	- Images for each pokemon

	*/


?>