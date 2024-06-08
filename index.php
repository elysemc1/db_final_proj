<!-- Made by Jace Palmer, Ellie Cohen, Jacob Strand, Lauren Edwardsen -->
<!-- Group 5 -->

<?php
session_start();	

include 'pokeHeader.php';

echo '</body>';
echo '</html>';
echo 'Welcome to the Pokemon Database!';

$sql = "SELECT Users.latest_team_id, Users.user_name, Users.user_id
    FROM Users 
    WHERE Users.user_id = 1";
    
$result = $link->query($sql);

if (!$result) {
    die("Query failed: " . $link->error);
}

if ($result->num_rows > 0) {
    echo "<table><tr><th>User ID</th><th>User Name</th><th>Latest Team ID</th></tr>";
    while ($row = $result->fetch_assoc()) {
        echo "<tr><td>" . $row["user_id"] . "</td><td>" . $row["user_name"] . "</td><td>" . $row["latest_team_id"] . "</tr>";
    }
    echo "</table>";
} else {
    echo "0 results";
}

$link->close();

echo '</body>';
echo '</html>';

?>
