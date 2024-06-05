<!DOCTYPE html>
<!-- CS 340 Example -->
<html>
	<head>
		<title>Grade Viewer</title>
		<link rel="stylesheet" href="index.css">
	</head>
<body>

<?php
/*  Note: if you want css you will need a index.css in the same directory as this file 
	In this versiion if you do not add a spectific ?sid=*** in the URL 				   
	the grades for all students are displayed 
*/
	
//   Change for your username, password and datadase name which is your username 

define('DB_SERVER', 'classmysql.engr.oregonstate.edu');
define('DB_USERNAME', 'cs340_palmjace');
define('DB_PASSWORD', '1982');
define('DB_NAME', 'cs340_palmjace');
 
/* Attempt to connect to MySQL database */
	$link = mysqli_connect(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_NAME);
 
// Check connection
	if($link === false){
		die("ERROR: Could not connect. " . mysqli_connect_error());
	}	
	$student_number =  mysqli_real_escape_string($link, $_GET['sid']);
	
	if ($student_number == "") {
	/* No student number list all students in the database */
	
		$query2 = "SELECT STUDENT.Name, COURSE.Course_name, GRADE_REPORT.Grade, SECTION.Instructor
					FROM GRADE_REPORT, STUDENT, COURSE, SECTION 
					WHERE GRADE_REPORT.Student_number=STUDENT.Student_number AND
					GRADE_REPORT.Section_identifier=SECTION.Section_id AND
					SECTION.Course_number=COURSE.Course_number";
						
	/* submit sql query to the database associated with the link */
		$result2 = mysqli_query($link, $query2);
		
		if (!$result2) {
		/* No result returned from the database */
			die("Query2 to show fields from table failed");
		}
	/* echo html to build table for grades */
	
		echo "<h1>Grades for Everyone</h1>";
		echo "<table id='t01'><tr>";	
		echo "<td><b>Name</b></td>";
		echo "<td><b>Course</b></td>";
		echo "<td><b>Grade</b></td>";
		echo "<td><b>Instructor</b></td>";
		echo "</tr>";

		while($row = mysqli_fetch_row($result2)) {	
			echo "<tr>";	
			echo "<td>$row[0]</td>";
			echo "<td>$row[1]</td>";	
			echo "<td>$row[2]</td>";				
			echo "<td>$row[3]</td>";				
			echo "</tr>\n";
		}
		mysqli_free_result($result2);
	
	} else {
	// Only display grades for $ student_number 
		$query = "SELECT STUDENT.Name, COURSE.Course_name, GRADE_REPORT.Grade, SECTION.Instructor
				FROM GRADE_REPORT, STUDENT, COURSE, SECTION 
				WHERE GRADE_REPORT.Student_number=STUDENT.Student_number AND
				GRADE_REPORT.Section_identifier=SECTION.Section_id AND
				SECTION.Course_number=COURSE.Course_number AND
				STUDENT.Student_number=$student_number";

		$result = mysqli_query($link, $query);
	
		echo "<h1>Transcript </h1>";
		echo "<h2>Student Number: {$student_number} </h2>";
	
		// Fetch the first row.  If there is a student then dispaly course & grade
		if ($row = mysqli_fetch_row($result)) {
			echo "<h2>Student Name: $row[0] </h2>";
			// printing table headers
			echo "<table id='t01'><tr>";	
			echo "<td><b>Course</b></td>";
			echo "<td><b>Grade</b></td>";
			echo "<td><b>Instructor</b></td>";
			echo "</tr>";
			echo "<tr>";	
			// $row[1] is the course & $row[2] is the grade
		
			echo "<td>$row[1]</td>";
			echo "<td>$row[2]</td>";		
			echo "<td>$row[3]</td>";		
			echo "</tr>\n";		
		
		} else { 
			// There was no student with that student number
			echo "No student with that number";
		}
		// display course and grade
		
		while($row = mysqli_fetch_row($result)) {	
			echo "<tr>";				
			echo "<td>$row[1]</td>";
			echo "<td>$row[2]</td>";		
			echo "<td>$row[3]</td>";		
			echo "</tr>\n";
		}
	
		mysqli_free_result($result);
	}
	mysqli_close($link);
?>
</body>

</html>

	
