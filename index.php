<!-- Made by Jace Palmer, Ellie Cohen, Jacob Strand, Lauren Edwardsen -->
<!-- Group 5 -->

<?php

include 'pokeHeader.php';

echo "<h2>Welcome to the Pokemon Database!</h2>";
if (isset($_SESSION["user_id"])) {
    $userID = $_SESSION["user_id"];
    $sql = "SELECT Users.latest_team_id, Users.user_name, Users.user_id
    FROM Users 
    WHERE Users.user_id = $userID";

    $result = $link->query($sql);

    if (!$result) {
        die("Query failed: " . $link->error);
    }

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        echo "<h3>Welcome " . $row['user_name'] . "!</h3>";
        echo "<p>Your User ID is $userID. The last team you created or modified had the Team ID " . $row['latest_team_id'] . ".</p>";
    }

    $link->close();
}

echo '</body>';
echo '</html>';

?>
