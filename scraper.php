<?php
if(isset($_POST['submit'])) {
    include('simple_html_dom.php');
    /********************* Create database connection ****************************/
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "test";

    // Create connection
    $conn = new mysqli($servername, $username, $password, $dbname);
    // Check connection
    if ($conn->connect_error) {
	die("Connection failed: " . $conn->connect_error);
    } 
    /*********************** File Upload ********************/    
    $target_dir = "uploads/";
    $target_file = $target_dir . basename($_FILES["fileToUpload"]["name"]);
    $imageFileType = pathinfo($target_file,PATHINFO_EXTENSION);
    // Allow certain file formats
    if($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg"
    && $imageFileType != "csv" ) {
	echo "Sorry, only CSV files are allowed.";
	die;
    }
    if (move_uploaded_file($_FILES["fileToUpload"]["tmp_name"], $target_file)) {
	echo "The file ". basename( $_FILES["fileToUpload"]["name"]). " has been uploaded.";
    } else {
	echo "Sorry, there was an error uploading your file.";
    }
    /************************* Extract data from CSV files ***********************/
    $row = 1;
    if (($handle = fopen($target_file, "r")) !== FALSE) {
	while (($data = fgetcsv($handle, 1000, ",")) !== FALSE) {
	    $number = $data[0];
	    $html = file_get_html("https://w2.brreg.no/enhet/sok/detalj.jsp?orgnr=".$number);
	    $keyArray = $html->find(".col-sm-4 p");
	    $valueArray = $html->find(".col-sm-8 p");

	    $valueString = '';
	    foreach($valueArray as $key => $value) {
		if($keyArray[$key]->plaintext !='') {
		    if($value->plaintext == '') {
			$value->plaintext = '-';
		    }
		    $valueString.=',"'.$value->plaintext.'"';
		}
	    }
	    $valueString = substr($valueString,1);
	    //echo $valueString; die;
	    $query = " INSERT INTO scrap (organisasjonsnummer,foretaksnavn,organisasjonsform,forretningsadresse,kommune,postadresse,internettadresse,enhetsregisteret,stiftelsesdato,dagligleder,vedtektfestet,virksomhet,naringskode,sektorkode,opplysninger,styre,styrets,virksomheter) 
		VALUES (".$valueString.")";
	    //echo $query; die;
	    $conn->query($query);
	}
	fclose($handle);
    }
}    
?>

<html>
    <body>
	<form action="" method="post" enctype="multipart/form-data">
	    <input type="file" name="fileToUpload" id="fileToUpload">
	    <input type="submit" name="submit" id="submit" value="Submit" onclick="return checkValidation();">
	</form>
    </body>
    <script>
    function checkValidation() {
	
    }	 
    </script>	
</html>    

