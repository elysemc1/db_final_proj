<?php
	session_start();	

    echo '<!DOCTYPE html>';

    include 'pokeHeader.php';

    echo '<body>';
    echo '<h1>Pokédex Team Builder</h1>';
    echo '<h2>Add a Team</h2>';
    echo '<form action="createTeam.php" method="post">';
    echo 'User ID: <input type="number" name="user_id" required><br>';
    echo 'Team Name: <input type="text" name="team_name" required><br>';
    echo 'Select Pokémon: <br>';
        
    include 'pokeConfig.php';
    $sql = "SELECT pokemon_id, pokemon_name FROM Pokemon_Characters";
    $result = $link->query($sql);

    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            echo '<input type="checkbox" name="pokemon_ids[]" value="' . $row["pokemon_id"] . '">' . $row["pokemon_name"] . '<br>';
        }
    } else {
        echo "No Pokémon available";
    }
    $link->close();
    echo '<input type="submit" value="Add Team">';
    echo '</form>';

    echo '<h2>Search Pokémon</h2>';
    echo '<a href=\'searchPokemon.php\'>Search Pokémon</a>';

    echo '<h2>View Teams</h2>';
    echo '<a href=\'viewTeams.php\'>View Teams</a>';
    echo '</body>';
    echo '</html>';
?>
