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
<title>Muuta jäsen</title>
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
				<td><input type="submit" id="tallenna" value="Hyväksy"></td>
			</tr>
		</tbody>
	</table>
	<td><input type="hidden" name="ID" id="ID"></td>
</form>
<span id="ilmo"></span>
</body>
<script>
$(document).ready(function(){ 
	$("#takaisin").click(function(){
		document.location="listaajasenet.jsp";
	});
	 $("#sukunimi").focus();//viedään kursori hakusana kenttään, ajetaan kun sivu ladataan
	//Haetaan muutettavan asiakkaan tiedot. Kutsutaan backin GET-metodia ja välitetään kutsun mukana muutettavan tiedon id
	//GET /autot/haeyksi/asiakas_id
	var id = requestURLParam("ID"); //Funktio löytyy scripts/main.js 	
	console.log(id);
	$.ajax({url:"jasenet/haeyksi/"+id, type:"GET", dataType:"json", success:function(result){	
		$("#ID").val(result.ID);	
		$("#sukunimi").val(result.sukunimi);
		$("#etunimi").val(result.etunimi);	
		$("#osoite").val(result.osoite);
		$("#pono").val(result.pono);	
		$("#puhelin").val(result.puhelin);
				
    }});
	
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
				paivitaTiedot();//validointi onnistuneet läpi, niin kutsu lisää tieedot
			}		
		}); 
});
//funktio tietojen päivittämistä varten. Kutsutaan backin PUT-metodia ja välitetään kutsun mukana uudet tiedot json-stringinä.
//PUT /asiakkaat/
function paivitaTiedot(){	
		var formJsonStr = formDataJsonStr($("#tiedot").serializeArray()); //otetaan tiedot taulukon tiedo, muutetaan lomakkeen tiedot json-stringiksi(scripts/main.js) ja viedään servletille Restiin
		console.log(formJsonStr);//tulostaa f12 seliamen consoliin
		$.ajax({url:"jasenet", data:formJsonStr, type:"PUT", dataType:"json", success:function(result) {  
			if(result.response==0){//result on joko {"response:1"} tai {"response:0"}  
	    	$("#ilmo").html("Jäsenen päivittäminen epäonnistui.");
	    }else if(result.response==1){			
	    	$("#ilmo").html("Jäsenen päivittäminen onnistui.");
	    	$("#sukunimi", "#etunimi", "#osoite", "#pono", "#puhelin").val("");//tyhjentää ruudulta tiedot, ei tyhjennetä painonappia
		}
   }});	
}
</script>
</html>