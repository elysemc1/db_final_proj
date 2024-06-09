<!-- Made by Jace Palmer, Ellie Cohen, Jacob Strand, Lauren Edwardsen -->
<!-- Group 5 -->

<?php
session_start();
include 'pokeHeader.php';

echo '<body>';

$team_id = $_GET['team_id'];
$user_id = $_SESSION["user_id"];

// Delete the team
$sql = "DELETE FROM Teams WHERE team_id = '$team_id' AND user_id = '$user_id'";
if ($link->query($sql) === TRUE) {
    echo "Team deleted successfully";
} else {
    echo "Error: " . $link->error;
}

$link->close();

echo '</body>';
echo '</html>';

?>
