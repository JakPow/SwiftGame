<?php

$con = mysqli_connect("localhost", "root");
mysqli_select_db($con,"testdb") or die("No Dbase Connection");

$winner = $_POST['winner'];
$totalTime = $_POST['totalTime'];

$query = "INSERT INTO test VALUES('','$winner','$totalTime')";
mysqli_query($con,$query) or die("error in write");
mysqli_close($con);

?>
