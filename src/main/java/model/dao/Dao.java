package model.dao;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.Jasen;


public class Dao {
	private Connection con=null;
	private ResultSet rs = null;
	private PreparedStatement stmtPrep=null; 
	private String sql;
	private String db ="Jasen.sqlite";
	
	private Connection yhdista(){
    	Connection con = null;    	
    	String path = System.getProperty("catalina.base");    	
    	path = path.substring(0, path.indexOf(".metadata")).replace("\\", "/"); 
    	String url = "jdbc:sqlite:"+path+db;    	
    	try {	       
    		Class.forName("org.sqlite.JDBC");
	        con = DriverManager.getConnection(url);	
	        System.out.println("Yhteys avattu.");
	     }catch (Exception e){	
	    	 System.out.println("Yhteyden avaus epäonnistui.");
	        e.printStackTrace();	         
	     }
	     return con;
	}
	public ArrayList<Jasen> listaaKaikki(){
		ArrayList<Jasen> jasenet = new ArrayList<Jasen>();
		sql = "SELECT * FROM Jasendata";    
		System.out.println(sql);
		try {
			con=yhdista();
			if(con!=null){ //jos yhteys onnistui
				stmtPrep = con.prepareStatement(sql);        		
        		rs = stmtPrep.executeQuery();   
				if(rs!=null){ //jos kysely onnistui
					//con.close();					
					while(rs.next()){
						Jasen Jasen = new Jasen();
						Jasen.setId(rs.getInt(1));
						Jasen.setSukunimi(rs.getString(3));
						Jasen.setEtunimi(rs.getString(2));
						Jasen.setOsoite(rs.getString(4));
						Jasen.setPono(rs.getString(5));
						Jasen.setPuhelin(rs.getString(6));
						jasenet.add(Jasen);
						System.out.println(jasenet);
					}					
				}				
			}	
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}		
		return jasenet;
	}
	public ArrayList<Jasen> listaaKaikki(String hakusana){//metodien kuormittaminen 2 samannimistä metodia, toinen parametrillä
		ArrayList<Jasen> jasenet = new ArrayList<Jasen>();
		sql = "SELECT * FROM Jasendata WHERE etunimi LIKE ? or sukunimi LIKE ? or puhelin LIKE ? or osoite LIKE ?";  //and poistettu=0 
		try {
			con=yhdista();
			if(con!=null){ //jos yhteys onnistui
				stmtPrep = con.prepareStatement(sql); 
				stmtPrep.setString(1, "%" + hakusana +"%");
				stmtPrep.setString(2, "%" + hakusana +"%");
				stmtPrep.setString(3, "%" + hakusana +"%");
				stmtPrep.setString(4, "%" + hakusana +"%");
        		rs = stmtPrep.executeQuery();   
				if(rs!=null){ //jos kysely onnistui
					//con.close();					
					while(rs.next()){
						Jasen Jasen = new Jasen();//tehdään uusi Jasen
						Jasen.setId(rs.getInt(1));//viedään tiedot 
						Jasen.setSukunimi(rs.getString(2));
						Jasen.setEtunimi(rs.getString(3));
						Jasen.setOsoite(rs.getString(4));
						Jasen.setPono(rs.getString(5));
						Jasen.setPuhelin(rs.getString(6));
						jasenet.add(Jasen);//työnnetään Jasen arraylistiin
						System.out.println(Jasen);
					}					
				}				
			}	
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}	
		
		return jasenet;
	}
	public boolean lisaaJasen(Jasen Jasen){
		boolean paluuArvo=true;
		sql="INSERT INTO Jasendata (sukunimi,etunimi,osoite,pono,puhelin) VALUES(?,?,?,?,?)";						  
		try {
			con = yhdista();
			stmtPrep=con.prepareStatement(sql); 
			stmtPrep.setString(1, Jasen.getSukunimi());//asetetaan 1 kysymysmerkin kohdalle
			stmtPrep.setString(2, Jasen.getEtunimi());
			stmtPrep.setString(3, Jasen.getOsoite());
			stmtPrep.setString(4, Jasen.getPono());
			stmtPrep.setString(5, Jasen.getPuhelin());
			stmtPrep.executeUpdate();
			//System.out.println("Uusin id on " + stmtPrep.getGeneratedKeys().getInt(1);//UUSIN ID
	        con.close();
		} catch (Exception e) {				
			e.printStackTrace();
			paluuArvo=false;
		}				
		return paluuArvo;
	}
	public boolean poistaJasen(int id){ //Oikeassa elämässä tiedot ensisijaisesti merkitään poistetuksi.
		boolean paluuArvo=true;
		
		sql="DELETE FROM Jasendata WHERE id=?";						  
		try {
			con = yhdista();
			stmtPrep=con.prepareStatement(sql); 
			stmtPrep.setInt(1, id);			
			stmtPrep.executeUpdate();
	        con.close();
		} catch (Exception e) {				
			e.printStackTrace();
			paluuArvo=false;
		}				
		return paluuArvo;
	}	
	public Jasen etsiJasen(int id) {//Jasen Jasen_id:n perusteella
		Jasen jasen = null;
		sql = "SELECT * FROM Jasendata WHERE id=?";       
		try {
			con=yhdista();
			if(con!=null){ 
				stmtPrep = con.prepareStatement(sql); 
				stmtPrep.setInt(1, id);	
        		rs = stmtPrep.executeQuery();  
        		if(rs.isBeforeFirst()){ //jos kysely tuotti dataa, eli Jasen_id on käytössä
        			rs.next();
        			jasen = new Jasen(rs.getInt("id"),rs.getString("sukunimi"), rs.getString("etunimi"), rs.getString("osoite"), rs.getString("pono"),rs.getString("puhelin"));        			
        				
				}        		
			}	
			con.close();  
		} catch (Exception e) {
			e.printStackTrace();
		}	
		
		return jasen;		//palautetaan Jasen objekti tai null
	}
	public boolean muutaJasen(Jasen Jasen){
		boolean paluuArvo=true;
		sql="UPDATE Jasendata SET sukunimi=?, etunimi=?, osoite=?, pono=?, puhelin=? WHERE id=?";						  
		try {
			con = yhdista();
			stmtPrep=con.prepareStatement(sql); 
			stmtPrep.setString(1, Jasen.getSukunimi());
			stmtPrep.setString(2, Jasen.getEtunimi());
			stmtPrep.setString(3, Jasen.getOsoite());
			stmtPrep.setString(4, Jasen.getPono());
			stmtPrep.setString(5, Jasen.getPuhelin());
			stmtPrep.setInt(6, Jasen.getId());
			stmtPrep.executeUpdate();
	        con.close();
		} catch (Exception e) {				
			e.printStackTrace();
			paluuArvo=false;
		}				
		return paluuArvo;
	}
}

