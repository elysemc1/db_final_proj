<?php
include 'pokeheader.php';

echo '<html>';
echo '<body>';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Assuming $link is your database connection object

    $user_id = $_POST['user_id'];
    $team_name = $_POST['team_name'];
    $pokemon_ids = $_POST['pokemon_ids']; // Array of Pokémon IDs

    // Escape inputs to prevent SQL injection
    $user_id = $link->real_escape_string($user_id);
    $team_name = $link->real_escape_string($team_name);

    $sql = "INSERT INTO Teams (user_id, team_name) VALUES ('$user_id', '$team_name')";

    if ($link->query($sql) === TRUE) {
        $team_id = $link->insert_id;
        $slot_id = 1;
        foreach ($pokemon_ids as $pokemon_id) {
            $pokemon_id = $link->real_escape_string($pokemon_id);
            $pokemon_level = 1; // Default level, you might want to change this

            $sql = "INSERT INTO Team_Members (team_id, user_id, slot_id, pokemon_id, pokemon_level) 
                    VALUES ('$team_id', '$user_id', '$slot_id', '$pokemon_id', '$pokemon_level')";
            
            if ($link->query($sql) === FALSE) {
                echo "Error inserting Pokemon ID $pokemon_id: " . $link->error;
                break; // Exit loop if there's an error
            }

            $slot_id++;
        }
        echo "New team created successfully";
    } else {
        echo "Error creating team: " . $link->error;
    }

    $link->close();
}

echo '</body>';
echo '</html>';
?>
