program ARBOLESB;
const 
	M = ... //orden del arbol;
type	
	cadena = string[70];
	alumno = record
		nomApe:cadena;
		DNI:integer;
		legajo:integer;
		año:integer;
	end;
	
	nodoBIndizado=record
		hijos = array[1..M]of integer;
		claves = array[1..M-1]of integer;
		enlacesHijos = array[1..M-1] of integer;
		cantClaves:integer;
	end;
	archivoDatos = file of alumno;
	archivoIndice = file of nodoBIndizado;
	
	nodoBPlus=record
		elementos = array[1..M-1]of alumnos;
		enlacesHijos = array[0..M] of ^snodoBPlus;
		cantElementos:integer;
		EsHoja:boolean;
	end;
	arbolBPlus = file of nodoBPlus;
	
var								//programa principal
	Bindice:archivoIndice;
	Bdatos:archivoDatos;
	
	Bplus:arbolBPlus;
begin

end.
