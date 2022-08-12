<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>

<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Jasenet</title>

</head>
<body>
<table id="listaus" border="1"> 
	<thead>
	<tr>
			<th colspan="8" class="oikealle"><span id="uusiJasen">Lis�� uusi j�sen</span></th>
		</tr>				
		<tr>
			<th colspan="3" class="oikealle">Hakusana:</th>
			<th colspan="2" class="vasemmalle"><input type="text" id="hakusana"></th>
			<th colspan="2" class="vasemmalle"><input type="button" value="Hae" id="hakunappi"></th>
		</tr>
		<tr>
			
			<th class="vasemmalle">Id</th>
			<th class="vasemmalle">Sukunimi</th>
			<th class="vasemmalle">Etunimi</th>
			<th class="vasemmalle">Osoite</th>
			<th class="vasemmalle">Pono</th>
			<th class="vasemmalle">Puhelin</th>
			<th></th>
										
		</tr>
	</thead>
	<tbody>
	</tbody>
</table>
<script>
$(document).ready(function(){                         //kaikki jquery hommat t�n alle
	
	$("#uusiJasen").click(function(){ //ohjataan lisaaasiakas.jsp sivulle
		document.location="lisaajasen.jsp";
	});
	haeJasenet();
	$("#hakunappi").click(function(){
    	//console.log($("#hakusana").val()); /kutsu haku funktiota
    	haeJasenet();
     });
	 $(document.body).on("keydown",function(event){
	    	if(event.which==13){
	    		haeJasenet();
	    	}
	    });
	    $("#hakusana").focus();//vied��n kursori hakusana kentt��n, ajetaan kun sivu ladataan
});
function haeJasenet(){
	$("#listaus tbody").empty();
	$.ajax({url:"jasenet/"+$("#hakusana").val(), type:"GET", dataType:"json", success:function(result){   //Funktio palauttaa tiedot json-objektina
		
		$.each(result.jasenet, function(i, field){    //haetaan backendist� autot ajaxilla @webservlet"autot" Autot servletiss�
        	var htmlStr;						   //m��ritell��n metodi mill� haeteen GET
        	htmlStr+="<tr id='rivi_"+field.id+"'>";
        	htmlStr+="<td>"+field.id+"</td>";
        	htmlStr+="<td>"+field.sukunimi+"</td>";
        	htmlStr+="<td>"+field.etunimi+"</td>";
        	htmlStr+="<td>"+field.osoite+"</td>";
        	htmlStr+="<td>"+field.pono+"</td>";
        	htmlStr+="<td>"+field.puhelin+"</td>";
        	htmlStr+="<td><a href='muutajasen.jsp?ID="+field.id+"'>Muuta</a>&nbsp;";  
        	htmlStr+="<span class='poista' onclick=poista("+field.id+",'"+field.sukunimi+"','"+field.etunimi+"')>Poista</span></td>"; 
        	
        	htmlStr+="</tr>";
        	$("#listaus tbody").append(htmlStr);//elementin id=listaus lis�t��n tbody
        });	
				
		console.log(result.jasenet); //jos haluat n�ytt�� consolissa toimiiko ajax kutsu
	}});
}
function poista(id,etunimi,sukunimi){
		if(confirm("Poista j�sen " + id +" "+ sukunimi +" "+ etunimi +"?")){
		$.ajax({url:"jasenet/"+id, type:"DELETE", dataType:"json", success:function(result) { //result on joko {"response:1"} tai {"response:0"}
	        if(result.response==0){
	        	$("#ilmo").html("J�senen poisto ep�onnistui.");
	        }else if(result.response==1){
	        	$("#rivi_"+id).css("background-color", "red"); //V�rj�t��n poistetun asiakkaan rivi
	        	alert("J�sen id:ll� " + id +" poisto onnistui.");
				haeJasenet();        	
			}
	    }});
	};
	
	
}


</script>
</body>
</html>