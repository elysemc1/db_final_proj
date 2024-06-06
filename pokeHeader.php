<?php

	// include the stuff to connect to the database
	echo '<!DOCTYPE html>';
	echo '<html lang="en">';
	echo '<head>';
	echo '<meta charset="UTF-8">';
	echo '<meta http-equiv="X-UA-Compatible" content="IE=edge">';
	echo '<meta name="viewport" content="width=device-width, initial-scale=1.0">';
	echo '<title>Pokemon Database</title>';
	echo '<link rel="stylesheet" href="index.css">';
	echo '</head>';
	echo '<header>';
	echo '<h1>Pokemon Database</h1>';
	echo '</header>';


	echo '<div class="navbar">';

	echo '<a href="index.php">Home</a>';

	echo '<div class="dropdown">';
	echo '<button class="dropbtn">Pokemon';
	echo '<i class="fa fa-caret-down"></i>';
	echo '</button>';
	echo '<div class="dropdown-content">';
	echo '<a href="searchPokemon.php">Search</a>';
	echo '<a href="comparePokemon.php">Compare</a>';
	echo '<a href="viewPokemon.php">View</a>';
	echo '</div>';
	echo '</div>';

	echo '<button class="dropbtn">Team';
	echo '<i class="fa fa-caret-down"></i>';
	echo '</button>';
	echo '<div class="dropdown-content">';
	echo '<a href="createTeam.php">Create</a>';
	echo '<a href="deleteTeam.php">Delete</a>';
	echo '<a href="updateTeam.php">Update</a>';
	echo '<a href="viewTeam.php">View</a>';
	echo '</div>';
	echo '</div>';

	echo '<button class="dropbtn">Favorites';
	echo '<i class="fa fa-caret-down"></i>';
	echo '</button>';
	echo '<div class="dropdown-content">';
	echo '<a href="createFav.php">Create</a>';
	echo '<a href="deleteFav.php">Delete</a>';
	echo '<a href="updateFav.php">Update</a>';
	echo '<a href="viewFav.php">View</a>';
	echo '</div>';
	echo '</div>';



	echo '</div>';

?>


	
