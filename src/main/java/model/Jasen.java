package model;

public class Jasen {
private int id;
private String sukunimi, etunimi, osoite, pono,puhelin;
public Jasen() {
	super();
	
}
public Jasen(int id, String sukunimi, String etunimi, String osoite, String pono, String puhelin) {
	super();
	this.id = id;
	this.sukunimi = sukunimi;
	this.etunimi = etunimi;
	this.osoite = osoite;
	this.pono = pono;
	this.puhelin = puhelin;
}
public int getId() {
	return id;
}
public void setId(int id) {
	this.id = id;
}
public String getSukunimi() {
	return sukunimi;
}
public void setSukunimi(String sukunimi) {
	this.sukunimi = sukunimi;
}
public String getEtunimi() {
	return etunimi;
}
public void setEtunimi(String etunimi) {
	this.etunimi = etunimi;
}
public String getOsoite() {
	return osoite;
}
public void setOsoite(String osoite) {
	this.osoite = osoite;
}
public String getPono() {
	return pono;
}
public void setPono(String pono) {
	this.pono = pono;
}
public String getPuhelin() {
	return puhelin;
}
public void setPuhelin(String puhelin) {
	this.puhelin = puhelin;
}
@Override
public String toString() {
	return "Jasen [id=" + id + ", sukunimi=" + sukunimi + ", etunimi=" + etunimi + ", osoite=" + osoite + ", pono="
			+ pono + ", puhelin=" + puhelin + "]";
}

}
