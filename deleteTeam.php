<?php
include 'pokeheader.php';

if (isset($_GET['team_id'])) {
    $team_id = $_GET['team_id'];

    // Delete team members first
    $sql = "DELETE FROM Team_Members WHERE team_id = ?";
    $stmt = $link->prepare($sql);
    $stmt->bind_param('i', $team_id);
    if ($stmt->execute()) {
        // Delete the team
        $sql = "DELETE FROM Teams WHERE team_id = ?";
        $stmt = $link->prepare($sql);
        $stmt->bind_param('i', $team_id);
        if ($stmt->execute()) {
            echo "Team deleted successfully";
        } else {
            echo "Error deleting team: " . $stmt->error;
        }
    } else {
        echo "Error deleting team members: " . $stmt->error;
    }
    $stmt->close();
} else {
    echo "No team ID provided";
}

$link->close();
?>
