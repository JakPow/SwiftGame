<?php

$con = mysqli_connect("localhost", "root");
mysqli_select_db($con,"testdb") or die("No Dbase Connection");


    $query = "SELECT * FROM test ORDER BY totalTime DESC";
$result = mysqli_query($con,$query) or die("query failed"); 
$num = mysqli_num_rows($result);

mysqli_close($con);

$rows = array();
While ($r = mysqli_fetch_assoc($result))
{
$rows[] = $r;
}

echo json_encode($rows);
?>
