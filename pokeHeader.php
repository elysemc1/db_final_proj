<!-- Made by Jace Palmer, Ellie Cohen, Jacob Strand, Lauren Edwardsen -->
<!-- Group 5 -->

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

	if (!isset($_SESSION["user_id"])) {
		echo '<a href="login.php">Login</a>';
	} else {
		echo '<a href="login.php">Logout</a>';
	}
	echo '<a href="index.php">Home</a>';
	echo '<a href="searchPokemon.php">Search Pokemon</a>';	
	echo '<a href="createTeam.php">Create Team</a>';
	echo '<a href="viewTeam.php">View Team</a>';

	echo '</nav>';

	

?>


	
