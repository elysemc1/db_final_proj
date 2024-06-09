<!-- Made by Jace Palmer, Ellie Cohen, Jacob Strand, Lauren Edwardsen -->
<!-- Group 5 -->

<?php
include 'pokeHeader.php';

echo '<body>';

$team_id = $_GET['team_id'];

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
