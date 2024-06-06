<?php
include 'pokeHeader.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $team_id = $_POST['team_id'];
    $team_name = $_POST['team_name'];
    $pokemon_ids = $_POST['pokemon_ids'];

    // Update team name
    $sql = "UPDATE Teams SET team_name = '$team_name' WHERE team_id = '$team_id'";
    $link->query($sql);

    // Delete existing team members
    $sql = "DELETE FROM Team_Members WHERE team_id = '$team_id'";
    $link->query($sql);

    // Add new team members
    $slot_id = 1;
    foreach ($pokemon_ids as $pokemon_id) {
        $pokemon_level = 1; // Default level, you might want to change this
        $sql = "INSERT INTO Team_Members (team_id, user_id, slot_id, pokemon_id, pokemon_level) VALUES ('$team_id', '$user_id', '$slot_id', '$pokemon_id', '$pokemon_level')";
        $link->query($sql);
        $slot_id++;
    }

    echo "Team updated successfully";
    $link->close();
} else {
    $team_id = $_GET['team_id'];

    // Fetch team details
    $sql = "SELECT * FROM Teams WHERE team_id = '$team_id'";
    $result = $link->query($sql);
    $team = $result->fetch_assoc();

    // Fetch team members
    $sql = "SELECT pokemon_id FROM Team_Members WHERE team_id = '$team_id'";
    $result = $link->query($sql);
    $team_members = [];
    while ($row = $result->fetch_assoc()) {
        $team_members[] = $row['pokemon_id'];
    }

    // Fetch all Pokémon
    $sql = "SELECT pokemon_id, pokemon_name FROM Pokemon_Characters";
    $all_pokemon = $link->query($sql);
    ?>
    <!DOCTYPE html>
    <html>
    <head>
        <title>Edit Team</title>
    </head>
    <body>
        <h1>Edit Team</h1>
        <form action="updateTeam.php" method="post">
            <input type="hidden" name="team_id" value="<?php echo $team['team_id']; ?>">
            Team Name: <input type="text" name="team_name" value="<?php echo $team['team_name']; ?>" required><br>
            Select Pokémon: <br>
            <?php
            if ($all_pokemon->num_rows > 0) {
                while ($row = $all_pokemon->fetch_assoc()) {
                    $checked = in_array($row["pokemon_id"], $team_members) ? 'checked' : '';
                    echo '<input type="checkbox" name="pokemon_ids[]" value="' . $row["pokemon_id"] . '" ' . $checked . '>' . $row["pokemon_name"] . '<br>';
                }
            } else {
                echo "No Pokémon available";
            }
            ?>
            <input type="submit" value="Update Team">
        </form>
    </body>
    </html>
    <?php
}
?>
