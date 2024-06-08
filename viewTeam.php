<!-- Made by Jace Palmer, Ellie Cohen, Jacob Strand, Lauren Edwardsen -->
<!-- Group 5 -->

<?php
include 'pokeHeader.php';

echo '<html>';
echo '<body>';

if (isset($_SESSION["user_id"])) {
    $user_id = $_SESSION["user_id"];
    $sql = "SELECT Teams.team_id, Teams.team_name, Users.user_name, 
    GROUP_CONCAT( Pokemon_Characters.pokemon_name ORDER BY Team_Members.slot_id SEPARATOR ', ') AS pokemon_names
    FROM Teams
    JOIN Users ON Teams.user_id = Users.user_id
    JOIN Team_Members ON Teams.team_id = Team_Members.team_id AND Teams.user_id = Team_Members.user_id
    JOIN Pokemon_Characters ON Team_Members.pokemon_id = Pokemon_Characters.pokemon_id
    WHERE Users.user_id = $user_id
    GROUP BY Teams.team_id, Teams.team_name, Users.user_name
    ORDER BY Teams.team_id, Team_Members.slot_id";
        
$result = $link->query($sql);

if (!$result) {
    die("Query failed: " . $link->error);
}

if ($result->num_rows > 0) {
    echo "<table><tr><th>Team Name</th><th>User Name</th><th>Pokémon</th><th>Actions</th></tr>";
    while ($row = $result->fetch_assoc()) {
        echo "<tr><td>" . $row["team_name"] . "</td><td>" . $row["user_name"] . "</td><td>" . $row["pokemon_names"] . "</td><td>
        <a href='updateTeam.php?team_id=" . $row["team_id"] . "'>Edit</a> | 
        <a href='deleteTeam.php?team_id=" . $row["team_id"] . "'>Delete</a></td></tr>";
    }
    echo "</table>";
} else {
    echo "0 results";
}

$link->close();

} else {
    echo "You must log in to view your teams";
}

echo '</body>';
echo '</html>';
?>
