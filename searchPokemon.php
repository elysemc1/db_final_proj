<!DOCTYPE html>
<html>
<head>
    <title>Search Pokémon</title>
</head>
<body>
    <h1>Search Pokémon</h1>
    <form action="searchPokemon.php" method="get">
        Search by: 
        <select name="search_by">
            <option value="name">Name</option>
            <option value="type">Type</option>
            <option value="number">Number</option>
        </select>
        <input type="text" name="query" required>
        <input type="submit" value="Search">
    </form>

    <?php
    if (isset($_GET['search_by']) && isset($_GET['query'])) {
        include 'pokeConfig.php';

        $search_by = $_GET['search_by'];
        $query = $_GET['query'];

        $sql = "";

        switch ($search_by) {
            case 'name':
                $sql = "SELECT * FROM Pokemon_Characters WHERE pokemon_name LIKE '%$query%'";
                break;
            case 'type':
                $sql = "SELECT pc.* FROM Pokemon_Characters pc
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
            echo "<table><tr><th>Number</th><th>Name</th><th>Generation</th><th>Height</th><th>Weight</th></tr>";
            while ($row = $result->fetch_assoc()) {
                echo "<tr><td>" . $row["pokemon_id"] . "</td><td>" . $row["pokemon_name"] . "</td><td>" . $row["generation"] . "</td><td>" . $row["height"] . "</td><td>" . $row["weight"] . "</td></tr>";
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
