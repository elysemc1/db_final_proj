<?php
include 'pokeheader.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $user_id = $_POST['user_id'];
    $team_name = $_POST['team_name'];
    $pokemon_ids = $_POST['pokemon_ids']; // Array of Pokémon IDs

    $sql = "INSERT INTO Teams (user_id, team_name) VALUES ('$user_id', '$team_name')";
    if ($conn->query($sql) === TRUE) {
        $team_id = $conn->insert_id;
        $slot_id = 1;
        foreach ($pokemon_ids as $pokemon_id) {
            $pokemon_level = 1; // Default level, you might want to change this
            $sql = "INSERT INTO Team_Members (team_id, user_id, slot_id, pokemon_id, pokemon_level) VALUES ('$team_id', '$user_id', '$slot_id', '$pokemon_id', '$pokemon_level')";
            $conn->query($sql);
            $slot_id++;
        }
        echo "New team created successfully";
    } else {
        echo "Error: " . $sql . "<br>" . $conn->error;
    }

    $conn->close();
}
?>
