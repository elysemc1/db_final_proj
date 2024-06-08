<?php
include 'pokeheader.php';

// Get the Pokémon ID from the URL parameter
if (isset($_GET['pokemon_id'])) {
    $pokemon_id = $_GET['pokemon_id'];

    // Fetch Pokémon details
    $sql = "SELECT * FROM Pokemon_Characters WHERE pokemon_id = ?";
    $stmt = $link->prepare($sql);
    $stmt->bind_param('i', $pokemon_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $pokemon = $result->fetch_assoc();
    
    if ($pokemon) {
        echo "<h1>" . htmlspecialchars($pokemon['pokemon_name']) . "</h1>";
        echo "<p>Generation: " . htmlspecialchars($pokemon['generation']) . "</p>";
        echo "<p>Height: " . htmlspecialchars($pokemon['height']) . " meters</p>";
        echo "<p>Weight: " . htmlspecialchars($pokemon['weight']) . " kilograms</p>";
        echo "<p>Gender Ratio: " . htmlspecialchars($pokemon['gender_ratio']) . "</p>";
        echo "<p>Base Experience: " . htmlspecialchars($pokemon['base_exp']) . "</p>";

        // Fetch evolution options
        $sql = "SELECT p.pokemon_name AS evolved_name 
                FROM Evolutions e 
                JOIN Pokemon_Characters p ON e.evolved_id = p.pokemon_id 
                WHERE e.original_id = ?";
        $stmt = $link->prepare($sql);
        $stmt->bind_param('i', $pokemon_id);
        $stmt->execute();
        $result = $stmt->get_result();
        
        if ($result->num_rows > 0) {
            echo "<h2>Evolutions</h2>";
            echo "<ul>";
            while ($row = $result->fetch_assoc()) {
                echo "<li>" . htmlspecialchars($row['evolved_name']) . "</li>";
            }
            echo "</ul>";
        } else {
            echo "<p>This Pokémon has no evolutions.</p>";
        }
    } else {
        echo "<p>Pokémon not found.</p>";
    }

    $stmt->close();
} else {
    echo "<p>No Pokémon ID provided.</p>";
}

$link->close();
?>
