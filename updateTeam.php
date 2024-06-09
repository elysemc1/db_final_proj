<!-- Made by Jace Palmer, Ellie Cohen, Jacob Strand, Lauren Edwardsen -->
<!-- Group 5 -->
 
<?php
include 'pokeHeader.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $user_id = $_POST['user_id'];
    $team_id = $_POST['team_id'];
    $team_name = $_POST['team_name'];
    $pokemon_ids = $_POST['pokemon_ids'];

    // Update team name and user_id
    $sql = "UPDATE Teams SET team_name = ?, user_id = ? WHERE team_id = ?";
    $stmt = $link->prepare($sql);
    $stmt->bind_param('sii', $team_name, $user_id, $team_id);
    if (!$stmt->execute()) {
        die("Error updating team name and user_id: " . $stmt->error);
    }

    // Fetch current team members
    $sql = "SELECT slot_id, pokemon_id FROM Team_Members WHERE team_id = ?";
    $stmt = $link->prepare($sql);
    $stmt->bind_param('i', $team_id);
    if (!$stmt->execute()) {
        die("Error fetching current team members: " . $stmt->error);
    }
    $result = $stmt->get_result();
    $current_team_members = [];
    while ($row = $result->fetch_assoc()) {
        $current_team_members[$row['slot_id']] = $row['pokemon_id'];
    }

    // Calculate the maximum slot ID
    $max_slot_id = !empty($current_team_members) ? max(array_keys($current_team_members)) : 0;

    // Determine which Pokémon IDs to add and delete
    $pokemon_ids_to_add = array_diff($pokemon_ids, $current_team_members);
    $pokemon_ids_to_delete = array_diff($current_team_members, $pokemon_ids);

    // Add new team members
    $slot_id = $max_slot_id + 1;
    foreach ($pokemon_ids_to_add as $pokemon_id) {
        $pokemon_level = 1; // Default level, you might want to change this
        $sql = "INSERT INTO Team_Members (team_id, user_id, slot_id, pokemon_id, pokemon_level) VALUES (?, ?, ?, ?, ?)";
        $stmt = $link->prepare($sql);
        $stmt->bind_param('iiiii', $team_id, $user_id, $slot_id, $pokemon_id, $pokemon_level);
        if (!$stmt->execute()) {
            die("Error adding team member: " . $stmt->error);
        }
        $slot_id++;
    }

    // Delete removed team members
    foreach ($pokemon_ids_to_delete as $slot_id => $pokemon_id) {
        $sql = "DELETE FROM Team_Members WHERE team_id = ? AND slot_id = ?";
        $stmt = $link->prepare($sql);
        $stmt->bind_param('ii', $team_id, $slot_id);
        if (!$stmt->execute()) {
            die("Error deleting team member: " . $stmt->error);
        }
    }

    echo "Team updated successfully";
    $link->close();
} else {
    $team_id = $_GET['team_id'];

    // Fetch team details along with user_id
    $sql = "SELECT Teams.*, Users.user_id FROM Teams JOIN Users ON Teams.user_id = Users.user_id WHERE team_id = ?";
    $stmt = $link->prepare($sql);
    $stmt->bind_param('i', $team_id);
    if (!$stmt->execute()) {
        die("Error fetching team details: " . $stmt->error);
    }
    $result = $stmt->get_result();
    $team = $result->fetch_assoc();

    // Fetch team members
    $sql = "SELECT pokemon_id FROM Team_Members WHERE team_id = ?";
    $stmt = $link->prepare($sql);
    $stmt->bind_param('i', $team_id);
    if (!$stmt->execute()) {
        die("Error fetching team members: " . $stmt->error);
    }
    $result = $stmt->get_result();
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
            User ID: <input type="text" name="user_id" value="<?php echo $team['user_id']; ?>" required><br>
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