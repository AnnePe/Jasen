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
<title>Lis�� j�sen</title>
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
				<td><input type="submit" id="tallenna" value="Lis��"></td>
			</tr>
		</tbody>
	</table>
</form>
<span id="ilmo"></span>
</body>
<script>
$(document).ready(function(){      //jqueryn aloitustagi
	$("#takaisin").click(function(){  //kun takaisin teksti� painetaan siirryt��n takaisin listaaasiakkaat.jsp funktioon
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
			
			lisaaTiedot();//validointi onnistuneet l�pi, niin kutsu lis�� tieedot
		}		
	}); 
	$("#sukunimi").focus(); //vied��n kursori etunimi-kentt��n kun sivu ladataan
});
//funktio tietojen lis��mist� varten. Kutsutaan backin POST-metodia ja v�litet��n kutsun mukana uudet tiedot json-stringin�.
//POST /asiakkaat/
function lisaaTiedot(){	
	var formJsonStr = formDataJsonStr($("#tiedot").serializeArray()); //otetaan tiedot taulukon tiedo, muutetaan lomakkeen tiedot json-stringiksi(scripts/main.js) ja vied��n servletille Restiin
	console.log(formJsonStr);//tulostaa f12 seliamen consoliin
	$.ajax({url:"jasenet", data:formJsonStr, type:"POST", dataType:"json", success:function(result) {  //Restiss� POST tarkoittaa lis��    
		if(result.response==0){//result on joko {"response:1"} tai {"response:0"}  
    	$("#ilmo").html("J�senen lis��minen ep�onnistui.");
    }else if(result.response==1){			
    	$("#ilmo").html("J�senen lis��minen onnistui.");
    	$("#etunimi", "#sukunimi", "#puhelin", "#osoite", "#pono").val("");//tyhjent�� ruudulta tiedot, ei tyhjennet� painonappia
		}
}});	
}

</script>
</html>