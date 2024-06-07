<?php
	include 'pokeConfig.php';
  session_start();
  if (isset($_SESSION["user_id"])) {
    session_unset();
    session_destroy();
    header("Location: index.php");
    exit();
  }
  if ($_SERVER["REQUEST_METHOD"] == "POST") {
    //$_SESSION["user_id"] = $_POST["usernameInput"];

    // Retrieve the input value from the form
    $username = $_POST['usernameInput'];
    //if user doesn't exist in database, add them
    $findUserQuery = "SELECT user_id FROM Users WHERE user_name=\"$username\"";
    $findUserResult = mysqli_query($link, $findUserQuery);
    if ($findUserResult && empty($userResult = mysqli_fetch_all($findUserResult, MYSQLI_ASSOC))) {
      //if find user failed
      mysqli_free_result($findUserResult);
      $addUserQuery = "INSERT INTO Users (user_name) VALUES (\"$username\")";
      $addUserResult = mysqli_query($link, $addUserQuery);
      $findUserQuery = "SELECT user_id FROM Users WHERE user_name=\"$username\"";
      $findUserResult = mysqli_query($link, $findUserQuery);
      //if $findUserResult fails or is still empty, refresh page?
      $userResult = mysqli_fetch_all($findUserResult, MYSQLI_ASSOC);
    }  //add else for bad orig $findUserResult?
    $_SESSION["user_id"] = $userResult[0]["user_id"];

    header("Location: index.php");  //navigate to homepage
    exit();
  }
?>
<!DOCTYPE html>
  <!-- Sessions Code -->
<html>
<body>
  <h1>Login Page</h1>
  <form action="" method="post" target="_self" name="loginForm">
    <input type="text" id="usernameInput" name="usernameInput" pattern="[a-zA-Z0-9]+" maxlength="25" required>
    <input type="submit" value="Login">
  </form>
  <!-- make link here for continue as guest -->
  <a href='index.php'>Continue as Guest</a>
  
</body>
</html>
