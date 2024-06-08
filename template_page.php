// Made by Jace Palmer, Ellie Cohen, Jacob Strand, Lauren Edwardsen
// Group 5

<!DOCTYPE html>
<html>
	<head>
		<title>Template</title>
		<link rel="stylesheet" href="index.css">
	</head>
<body>

<?php

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
	
	


	// free result, use after you do a query
	mysqli_free_result($result); 

	// close connection to db, use after done doing queries for page
	mysqli_close($link); 
?>
</body>

</html>

	
