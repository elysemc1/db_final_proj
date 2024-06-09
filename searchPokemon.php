<!-- Made by Jace Palmer, Ellie Cohen, Jacob Strand, Lauren Edwardsen -->
<!-- Group 5 -->

<?php
include 'pokeHeader.php';

echo "<body>";

echo '<form action="searchPokemon.php" method="get">';
echo 'Search by: ';
echo '<select name="search_by">';
echo '<option value="name">Name</option>';
echo '<option value="type">Type</option>';
echo '<option value="number">Number</option>';
echo '</select>';
echo '<input type="text" name="query" required>';
echo '<input type="submit" value="Search">';
echo '</form>';

if (isset($_GET['search_by']) && isset($_GET['query'])) {

    $search_by = $_GET['search_by'];
    $query = $_GET['query'];

    $sql = "";

    switch ($search_by) {
        case 'name':
            $sql = "SELECT * FROM Pokemon_Characters WHERE pokemon_name LIKE '%$query%'";
            break;
        case 'type':
            $sql = "SELECT pc.pokemon_id, pc.pokemon_name, pc.generation, pc.height, pc.weight, pt.type_name 
                    FROM Pokemon_Characters pc
                    JOIN Pokemon_Types pt ON pc.pokemon_id = pt.pokemon_id
                    WHERE pt.type_name LIKE '%$query%'";
            break;
        case 'number':
            $sql = "SELECT * FROM Pokemon_Characters WHERE pokemon_id = '$query'";
            break;
    }

    $result = $link->query($sql);

    if ($result->num_rows > 0) {
        echo "<h2>Search Results</h2>";
        echo "<table><tr><th>Number</th><th>Name</th><th>Type(s)</th><th>Generation</th><th>Height</th><th>Weight</th></tr>";
        while ($row = $result->fetch_assoc()) {
            // Fetch all types for the current Pokémon
            $pokemon_id = $row['pokemon_id'];
            $types_result = $link->query("SELECT type_name FROM Pokemon_Types WHERE pokemon_id = $pokemon_id");
            $types = [];
            while ($type_row = $types_result->fetch_assoc()) {
                $types[] = $type_row['type_name'];
            }
            $types_str = implode(', ', $types);

            echo "<tr><td>" . $row["pokemon_id"] . "</td><td><a href='viewPokemon.php?pokemon_id=" . $row["pokemon_id"] . "'>" . htmlspecialchars($row["pokemon_name"]) . "</a></td><td>" . htmlspecialchars($types_str) . "</td><td>" . $row["generation"] . "</td><td>" . $row["height"] . "</td><td>" . $row["weight"] . "</td></tr>";
        }
        echo "</table>";
    } else {
        echo "No results found";
    }

    $link->close();
}
?>
</body>
</html>
