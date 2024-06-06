<?php
include 'pokeheader.php';

echo '<html>';
echo '<body>';

$sql = "SELECT Teams.team_id, Teams.team_name, Users.user_name, GROUP_CONCAT(Pokemon_Characters.pokemon_name) AS pokemon_names 
        FROM Teams 
        JOIN Team_Members ON Teams.team_id = Team_Members.team_id 
        JOIN Pokemon_Characters ON Team_Members.pokemon_id = Pokemon_Characters.pokemon_id 
        JOIN Users ON Teams.user_id = Users.user_id
        GROUP BY Teams.team_id, Teams.team_name, Users.user_name";
$result = $link->query($sql);

if ($result->num_rows > 0) {
    echo "<table><tr><th>Team Name</th><th>User Name</th><th>Pokémon</th><th>Actions</th></tr>";
    while ($row = $result->fetch_assoc()) {
        echo "<tr><td>" . $row["team_name"] . "</td><td>" . $row["user_name"] . "</td><td>" . $row["pokemon_names"] . "</td><td>
        <a href='edit_team.php?team_id=" . $row["team_id"] . "'>Edit</a> | 
        <a href='delete_team.php?team_id=" . $row["team_id"] . "'>Delete</a></td></tr>";
    }
    echo "</table>";
} else {
    echo "0 results";
}
$link->close();

echo '</body>';
echo '</html>';

?>


