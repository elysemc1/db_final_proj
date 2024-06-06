<?php
include 'pokeheader.php';

echo '<html>';
echo '<body>';

$team_id = $_GET['team_id'];

// Delete team members first
$sql = "DELETE FROM Team_Members WHERE team_id = '$team_id'";
$link->query($sql);

// Delete the team
$sql = "DELETE FROM Teams WHERE team_id = '$team_id'";
if ($link->query($sql) === TRUE) {
    echo "Team deleted successfully";
} else {
    echo "Error: " . $link->error;
}

$link->close();

echo '</body>';
echo '</html>';

?>
