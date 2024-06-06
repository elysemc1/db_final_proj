<?php
	session_start();	
?>

<!DOCTYPE html>
<?php

//include 'pokeHeader.php';

?>
<body>
    <h1>Pokédex Team Builder</h1>

    <h2>Add a Team</h2>
    <form action="add_team.php" method="post">
        User ID: <input type="number" name="user_id" required><br>
        Team Name: <input type="text" name="team_name" required><br>
        Select Pokémon: <br>
        <?php
        include 'pokeConfig.php';
        $sql = "SELECT pokemon_id, pokemon_name FROM Pokemon_Characters";
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) {
                echo '<input type="checkbox" name="pokemon_ids[]" value="' . $row["pokemon_id"] . '">' . $row["pokemon_name"] . '<br>';
            }
        } else {
            echo "No Pokémon available";
        }
        $conn->close();
        ?>
        <input type="submit" value="Add Team">
    </form>

    <h2>Search Pokémon</h2>
    <a href="search.php">Search Pokémon</a>

    <h2>View Teams</h2>
    <a href="view_teams.php">View Teams</a>
</body>
</html>
