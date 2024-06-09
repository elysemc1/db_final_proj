<?php
include 'pokeHeader.php';
  if (isset($_SESSION["user_id"])) {
    session_unset();
    session_destroy();
    header("Location: index.php");
    exit();
  }
  if ($_SERVER["REQUEST_METHOD"] == "POST") {
    //$_SESSION["user_id"] = $_POST["usernameInput"];

    // Retrieve the input value from the form
    $userID = $_POST['userID'];
    //if user doesn't exist in database, add them
    //$findUserQuery = "SELECT Users.user_name, Users.user_id FROM Users WHERE user_id =\"$username\"";
    $userQuery = "SELECT Users.user_name FROM Users WHERE user_id = $userID";
    $result = $link->query($userQuery);
    if (!$result) {
        die("Query failed: " . $link->error);
    }
    $username = $result->fetch_assoc()["user_name"];
    if (!$username) {
        echo "Could not locate user with user ID $userID";
    } else {
        echo "Logged in as $username!";
        $_SESSION["user_id"] = $userID;
        header("Location: index.php");
        exit();
    }
  }
?>

<body>
  <h1>Login Page</h1>
  <h3>Please enter your User ID</h3>
  <form action="" method="post" target="_self" name="loginForm">
    <input type="text" id="userID" name="userID" pattern="[0-9]+" maxlength="25" required>
    <input type="submit" value="Login">
  </form>
</body>
</html>