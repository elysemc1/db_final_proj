<?php
include 'pokeHeader.php';

// Enable error reporting
error_reporting(E_ALL);
ini_set('display_errors', 1);
ini_set('log_errors', 1);
ini_set('error_log', 'error_log.txt'); // Log errors to a file named error_log.txt

echo '<html>';
echo '<body>';

// Get the Pokémon ID from the URL parameter
if (isset($_GET['pokemon_id'])) {
    $pokemon_id = intval($_GET['pokemon_id']);  // Ensure the ID is treated as an integer

    // Fetch Pokémon details
    $sql = "SELECT * FROM Pokemon_Characters WHERE pokemon_id = ?";
    $stmt = $link->prepare($sql);
    if (!$stmt) {
        error_log("Error preparing statement: " . $link->error);
        die("Error preparing statement: " . $link->error);
    }
    $stmt->bind_param('i', $pokemon_id);
    if (!$stmt->execute()) {
        error_log("Error executing statement: " . $stmt->error);
        die("Error executing statement: " . $stmt->error);
    }
    $result = $stmt->get_result();
    $pokemon = $result->fetch_assoc();
    
    if ($pokemon) {
		echo "<h2>" . htmlspecialchars($pokemon['pokemon_name']) . "</h2>";
        echo "<h1>" . "" . "</h1>";
        
		echo "<table>";
		echo "<tr><th>Image</th><th>Generation</th><th>Height</th><th>Weight</th><th>Gender Ratio</th><th>Base Experience</th><th>Next Evolution</th></tr>";
		echo "<tr><td><img src='https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/" . htmlspecialchars($pokemon_id) . ".png' alt='Image of " . htmlspecialchars($pokemon['pokemon_name']) . "'></td>";
		echo "<td>" . htmlspecialchars($pokemon['generation']) . "</td>";
		echo "<td>" . htmlspecialchars($pokemon['height']) . " meters</td>";
		echo "<td>" . htmlspecialchars($pokemon['weight']) . " kilograms</td>";
		echo "<td>" . htmlspecialchars($pokemon['gender_ratio']) . "</td>";
		echo "<td>" . htmlspecialchars($pokemon['base_exp']) . "</td>";

        // Fetch evolution options
        $sql = "SELECT e.evolved_id, p.pokemon_name AS evolved_name 
        FROM Evolutions e 
        JOIN Pokemon_Characters p ON e.evolved_id = p.pokemon_id 
        WHERE e.original_id = ?";

        $stmt = $link->prepare($sql);
        if (!$stmt) {
            error_log("Error preparing statement: " . $link->error);
            die("Error preparing statement: " . $link->error);
        }
        $stmt->bind_param('i', $pokemon_id);
        if (!$stmt->execute()) {
            error_log("Error executing statement: " . $stmt->error);
            die("Error executing statement: " . $stmt->error);
        }
        $result = $stmt->get_result();

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        // Generate the link to the Pokémon's view page
        echo "<td><a href='viewPokemon.php?pokemon_id=" . htmlspecialchars($row['evolved_id']) . "'>" . htmlspecialchars($row['evolved_name']) . "</a></td>";
    }
} else {
    echo "<td>This Pokémon has no evolutions.</td>";
}
echo "</tr></table>";

    } else {
        echo "<p>Pokémon not found.</p>";
    }

    $stmt->close();
} else {
    echo "<p>No Pokémon ID provided.</p>";
	
}

$link->close();

echo '</body>';
echo '</html>';
?>
