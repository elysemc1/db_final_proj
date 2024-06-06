<?php

	// include the stuff to connect to the database
	echo '<!DOCTYPE html>';
	echo '<html lang="en">';
	echo '<head>';
	echo '<meta charset="UTF-8">';
	
	echo '<title>Pokemon Database</title>';
	echo '<link rel="stylesheet" type="text/css" href="index.css">';
	echo '</head>';
	echo '<header>';
	echo '<h1>Pokemon Database</h1>';
	echo '</header>';
	echo '<nav>';

	echo '<a href="index.php">Home</a>';

	echo '<p>';
	echo '<a href="searchPokemon.php">Poke-Search</a> \n';
	echo '<a href="comparePokemon.php">Poke-Compare</a> \n';
	echo '<a href="viewPokemon.php">Poke-View</a>';
	echo '</p>';

	
	echo '<a href="createTeam.php">Team-Create</a>';
	echo '<a href="deleteTeam.php">Team-Delete</a>';
	echo '<a href="updateTeam.php">Team-Update</a>';
	echo '<a href="viewTeam.php">Team-View</a>';

	echo '<a href="createFav.php">Fav-Create</a>';
	echo '<a href="deleteFav.php">Fav-Delete</a>';
	echo '<a href="updateFav.php">Fav-Update</a>';
	echo '<a href="viewFav.php">Fav-View</a>';

	echo '</nav>';

?>


	
