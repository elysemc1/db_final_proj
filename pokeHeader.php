// Made by Jace Palmer, Ellie Cohen, Jacob Strand, Lauren Edwardsen
// Group 5

<?php


	// include the stuff to connect to the database
	include 'pokeConfig.php';

	echo '<!DOCTYPE html>';
	echo '<html lang="en">';
	echo '<head>';
	echo '<meta charset="UTF-8">';
	
	echo '<title>Pokemon Database</title>';
	echo '<link rel="stylesheet" type="text/css" href="index.css">';
	echo '</head>';
	echo '<header>';
	echo '<h1>Pokemon Database</h1>';
	echo 'Jace Palmer, Ellie Cohen, Jacob Strand, Lauren Edwardsen - Group 5';
	echo '</header>';
	echo '<nav>';

	echo '<a href="index.php">Home</a>';

	echo 'Pokemon -&gt; ';
	echo '<a href="searchPokemon.php">Search</a>';
	echo '<a href="comparePokemon.php">Compare</a>';
	echo '<a href="viewPokemon.php">View</a>';
	
	echo 'Team -&gt; ';
	echo '<a href="createTeam.php">Create</a>';
	echo '<a href="deleteTeam.php">Delete</a>';
	echo '<a href="updateTeam.php">Update</a>';
	echo '<a href="viewTeam.php">View</a>';

	echo '</nav>';

?>


	
