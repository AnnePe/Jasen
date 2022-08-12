<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.15.0/jquery.validate.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Lisää jäsen</title>
</head>
<body>
<form id="tiedot">
	<table>
		<thead>	
			<tr>
				<th colspan="6" class="oikealle"><span id="takaisin">Takaisin listaukseen</span></th>
			</tr>		
			<tr>
				<th>Sukunimi</th>
				<th>Etunimi</th>
				<th>Osoite</th>
				<th>Pono</th>
				<th>Puhelin</th>
				<th>Hallinta</th>
				
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><input type="text" name="sukunimi" id="sukunimi"></td>
				<td><input type="text" name="etunimi" id="etunimi"></td>
				<td><input type="text" name="osoite" id="osoite"></td> 
				<td><input type="text" name="pono" id="pono"></td> 
				<td><input type="text" name="puhelin" id="puhelin"></td>
				<td><input type="submit" id="tallenna" value="Lisää"></td>
			</tr>
		</tbody>
	</table>
</form>
<span id="ilmo"></span>
</body>
<script>
$(document).ready(function(){      //jqueryn aloitustagi
	$("#takaisin").click(function(){  //kun takaisin tekstiä painetaan siirrytään takaisin listaaasiakkaat.jsp funktioon
		document.location="listaajasenet.jsp";
	});
	$("#tiedot").validate({						
		rules: {
			etunimi:  {
				required: true,
				minlength: 2				
			},	
			sukunimi:  {
				required: true,
				minlength: 2				
			},
			puhelin:  {
				required: true,
				minlength: 4
			},	
		
			osoite:  {
				required: true,
				minlength: 4
			}	
		},
		messages: {
			etunimi: {     
				required: "Puuttuu",
				minlength: "Liian lyhyt"			
			},
			sukunimi: {
				required: "Puuttuu",
				minlength: "Liian lyhyt"
			},
			puhelin: {
				required: "Puuttuu",
				minlength: "Liian lyhyt"
			},
			
			osoite: {
				required: "Puuttuu",
				minlength: "Liian lyhyt"
			}
			
		},			
		submitHandler: function(form) {	
			
			lisaaTiedot();//validointi onnistuneet läpi, niin kutsu lisää tieedot
		}		
	}); 
	$("#sukunimi").focus(); //viedään kursori etunimi-kenttään kun sivu ladataan
});
//funktio tietojen lisäämistä varten. Kutsutaan backin POST-metodia ja välitetään kutsun mukana uudet tiedot json-stringinä.
//POST /asiakkaat/
function lisaaTiedot(){	
	var formJsonStr = formDataJsonStr($("#tiedot").serializeArray()); //otetaan tiedot taulukon tiedo, muutetaan lomakkeen tiedot json-stringiksi(scripts/main.js) ja viedään servletille Restiin
	console.log(formJsonStr);//tulostaa f12 seliamen consoliin
	$.ajax({url:"jasenet", data:formJsonStr, type:"POST", dataType:"json", success:function(result) {  //Restissä POST tarkoittaa lisää    
		if(result.response==0){//result on joko {"response:1"} tai {"response:0"}  
    	$("#ilmo").html("Jäsenen lisääminen epäonnistui.");
    }else if(result.response==1){			
    	$("#ilmo").html("Jäsenen lisääminen onnistui.");
    	$("#etunimi", "#sukunimi", "#puhelin", "#osoite", "#pono").val("");//tyhjentää ruudulta tiedot, ei tyhjennetä painonappia
		}
}});	
}

</script>
</html>