package control;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;


import model.Jasen;
import model.dao.Dao;


@WebServlet("/jasenet/*")
public class Jasenet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   
    public Jasenet() {
        super();
    System.out.println("Jasen.Jasen()");
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Jasenet.doGet()");
		String pathInfo=request.getPathInfo();//haetaan kutsun polkutiedot esim. /matti
		System.out.println("polku: "+pathInfo);
		Dao dao = new Dao();
		ArrayList<Jasen> jasenet;
		
		String strJSON="";
		if(pathInfo==null) { //Haetaan kaikki j‰senet jos ei kauttaviivaa 
			jasenet = dao.listaaKaikki();
			strJSON = new JSONObject().put("jasenet", jasenet).toString();	
		}else if(pathInfo.indexOf("haeyksi")!=-1) {		//indexOf hakee, ett‰ polussa on sana "haeyksi", eli haetaan yhden j‰senen tiedot
			String ID = pathInfo.replace("/haeyksi/", ""); //poistetaan polusta "/haeyksi/", j‰ljelle j‰‰ j‰sen id	
			int id=Integer.parseInt(ID);
			System.out.println("polku: "+id);
			Jasen jasen = dao.etsiJasen(id);//joko asiakas objekti tai null
			System.out.println(jasen);
			if (jasen==null) {
				strJSON="{}";
			}else {
			JSONObject JSON = new JSONObject();
			JSON.put("ID", jasen.getId());
			JSON.put("sukunimi", jasen.getSukunimi());
			JSON.put("etunimi", jasen.getEtunimi());
			JSON.put("osoite", jasen.getOsoite());	
			JSON.put("pono", jasen.getPono());
			JSON.put("puhelin", jasen.getPuhelin());
			strJSON = JSON.toString();//palautus string
			}
			System.out.println(strJSON);//tulostetaan string
		}else{ //Haetaan hakusanan mukaiset asiakkaat eli kauttaviiva on
			String hakusana = pathInfo.replace("/", "");
			jasenet = dao.listaaKaikki(hakusana);
			strJSON = new JSONObject().put("jasenet", jasenet).toString();	
		}
		
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		out.println(strJSON);		
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		System.out.println("Jasenet.doPost()");
		JSONObject jsonObj = new JsonStrToObj().convert(request); //Muutetaan kutsun mukana tuleva json-string json-objektiksi	JsonStrToObj.java /control kansiossa
		Jasen jasen = new Jasen();
		jasen.setSukunimi(jsonObj.getString("sukunimi"));
		jasen.setEtunimi(jsonObj.getString("etunimi"));
		jasen.setOsoite(jsonObj.getString("osoite"));
		jasen.setPono(jsonObj.getString("pono"));
		jasen.setPuhelin(jsonObj.getString("puhelin"));
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();//v‰litet‰‰n daoon lis‰‰ asiakkaaseen
		if(dao.lisaaJasen(jasen)){ //metodi lisaaAsiakas palauttaa true/false
			out.println("{\"response\":1}");  //J‰senen lis‰‰minen onnistui {"response":1}
		}else{
			out.println("{\"response\":0}");  //J‰senen lis‰‰minen ep‰onnistui {"response":0}
		}	
	}

	
	protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Jasenet.doPut()");
		JSONObject jsonObj = new JsonStrToObj().convert(request); //Muutetaan kutsun mukana tuleva json-string json-objektiksi	JsonStrToObj.java /control kansiossa
		//String vanharekno = jsonObj.getString("vanharekno");//jos haluat muuttaa avainta niin vanha tieto t‰ytyy tuoda
		Jasen jasen = new Jasen();
		System.out.println("jsnopbj r85 doput"+jsonObj);//ID puuttuu!!!!
		jasen.setId(jsonObj.getInt("ID"));
		jasen.setSukunimi(jsonObj.getString("sukunimi"));
		jasen.setEtunimi(jsonObj.getString("etunimi"));
		jasen.setOsoite(jsonObj.getString("osoite"));
		jasen.setPono(jsonObj.getString("pono"));
		jasen.setPuhelin(jsonObj.getString("puhelin"));
		response.setContentType("application/json");
		System.out.println("do put jasen r 84:"+ jasen);
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();//v‰litet‰‰n daoon lis‰‰ asiakkaaseen
		if(dao.muutaJasen(jasen)){ //metodi lisaaAsiakas palauttaa true/false
			out.println("{\"response\":1}");  //J‰senen muuttaminen onnistui {"response":1}
		}else{
			out.println("{\"response\":0}");  //J‰senen muuttaminen ep‰onnistui {"response":0}
		}	
	}


	protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Jasenet.doDelete()");
		
		String pathInfo = request.getPathInfo();	//haetaan kutsun polkutiedot, esim. /ABC-222		
		System.out.println("polku: "+pathInfo);
		String Strpoistettavaid = pathInfo.replace("/", "");
		int poistettavaid=Integer.parseInt(Strpoistettavaid);
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();	
		if(dao.poistaJasen(poistettavaid)){ //metodi palauttaa true/false
			out.println("{\"response\":1}");  //J‰senen poistaminen onnistui {"response":1}
		}else{
			out.println("{\"response\":0}");  //J‰senen poistaminen ep‰onnistui {"response":0}
		}	
	}
}
