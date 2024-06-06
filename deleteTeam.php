<?php
include 'pokeheader.php';

$team_id = $_GET['team_id'];

// Delete team members first
$sql = "DELETE FROM Team_Members WHERE team_id = '$team_id'";
$conn->query($sql);

// Delete the team
$sql = "DELETE FROM Teams WHERE team_id = '$team_id'";
if ($conn->query($sql) === TRUE) {
    echo "Team deleted successfully";
} else {
    echo "Error: " . $conn->error;
}

$conn->close();
?>
