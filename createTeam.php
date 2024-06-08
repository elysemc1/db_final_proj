<!-- Made by Jace Palmer, Ellie Cohen, Jacob Strand, Lauren Edwardsen -->
<!-- Group 5 -->

<?php

include 'pokeHeader.php';

echo '<body>';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $user_id = $_POST['user_id'];
    $team_name = $_POST['team_name'];
    $pokemon_ids = $_POST['pokemon_ids']; // Array of Pokémon IDs

    $sql = "INSERT INTO Teams (user_id, team_name) VALUES ('$user_id', '$team_name')";
    if ($link->query($sql) === TRUE) {
        $team_id = $link->insert_id;
        $slot_id = 1;
        foreach ($pokemon_ids as $pokemon_id) {
            $pokemon_level = 1; // Default level, you might want to change this
            $sql = "INSERT INTO Team_Members (team_id, user_id, slot_id, pokemon_id, pokemon_level) VALUES ('$team_id', '$user_id', '$slot_id', '$pokemon_id', '$pokemon_level')";
            $link->query($sql);
            $slot_id++;
        }
        echo "New team created successfully";
    } else {
        echo "Error: " . $sql . "<br>" . $link->error;
    }

    $link->close();
} else {
    echo '<body>';
    echo '<h1>Pokédex Team Builder</h1>';
    echo '<h2>Add a Team</h2>';
    echo '<form action="createTeam.php" method="post">';
    echo 'User ID: <input type="number" name="user_id" required><br>';
    echo 'Team Name: <input type="text" name="team_name" required><br>';
    echo 'Select Pokémon: <br>';
        
    
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
}

echo '</body>';
echo '</html>';

?>
