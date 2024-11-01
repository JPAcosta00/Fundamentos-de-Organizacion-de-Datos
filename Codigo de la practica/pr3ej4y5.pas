program ej4;
const
	valoralto = 9999;
type
	reg_flor = record
       nombre: String[45];
       codigo:integer;
    end;
    tArchFlores = file of reg_flor;
    
    lista = ^nodo;
    nodo = record
		dato:reg_flor;
		sig:lista;
    end;


procedure agregarFlor (var a: tArchFlores ; nombre: string;codigo:integer);
var 
	cabecera:reg_flor;
	posicion:integer;
	aux:reg_flor;
begin
	reset(a);
	aux.nombre:= nombre;                                  //creo un registro para armar el registro de la flor
	aux.codigo:=codigo;
	read(a,cabecera);                                     //leo lo que hay en la cabecera
	if(cabecera.codigo < 0)then begin					  //si hay una marca para reasignar
		posicion:= cabecera.codigo * -1;                  
		seek(a,posicion);                                 //me posiciono en la marca
		read(a,cabecera);                                 //leo el contenido en esa posicion
	    seek(a,filepos(a)-1);                             
		write(a,aux);                                     //escribo la flor nueva
		cabecera.codigo := posicion * -1;                 //devuelvo la cabecera en negativa o en cero depende si habia marca de reasignacion
		seek(a,0);						                  //me posiciono en la cabecera
		write(a,cabecera);								  //escribo lo que habia en la posicion reasignada en la cabecera
		writeln('Se agrego la flor reasignando el espacio.');
	end;
	else begin											   //si no hay marca para reasignar el espacio
		seek(a,filesize(a));	
		write(a,aux);									   //agrego la flor en la ultima posicion
		writeln('Se agrego al novela en la ultima posicion.');
	end;
	close(a);
end;

procedure leer(var ar:archivo: reg:reg_flor);
begin
	if(not eof(ar))then
		read(ar,reg)
	else
		reg.codigo = valoralto;
end;

procedure agregaAdelante(registro:reg_flor; var ele:lista);
var
	nue:lista;
begin
	new(nue);
	nue^.dato:= registro;
	nue^.sig:= ele;
	ele:= nue;
end;

procedure enListaFlores(var archi:tArchFlores; var l:lista);
var
	regF:reg_flor;
begin
	reset(archi);
	read(archi,regF);                                  //lee cabecera
	leer(archi,regF);
	while(regF.codigo <> valoralto)do begin
		if(regF.codigo > 0)then begin                  //si no es una posicion a asignar el espacio lo guardo en la lista
			agregaAdelante(regF,l);
		end; 
		leer(archi,regF);
	end;
	close(archi);
end;

procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);
var
	cabecera:reg_flor;
	regF:reg_flor;
	posicion : integer;
begin
	reset(a);
	read(a,cabecera);
	leer(a,regF);
	while(regF.codigo <> valoralto)and(regF.codigo <> flor.codigo)do
		leer(a,regF);
	if(regF.codigo = flor.codigo)then begin
		posicion:= filepos(a)-1;                                    //guardo la posicion a borrar
		seek(a,posicion);                                           //me posiciono en la posicion a borrar
		write(a,cabecera);											//escribo lo que habia en la cabecera
		regF.codigo = posicion * -1;								//guardo la posicion en negativo en el codigo del registro que se elimino
		seek(a,0);													//me posiciono en la cabecera
		write(a,regF);											    //escribo el registro eliminado con la referencia al espacio a reasignar
		writeln('Se elimino la flor con exito');
	end
	else
		writeln('No se encontro la flor');
	close(a);
end;


var                                    //programa principal
    lis:lista;
    ar:tArchFlores;
begin
    lis:=nil;
    assign(ar,'Flores');
    cargaFlores(ar);                          //adentro esta el modulo "agregaFlor"
    enListaFlores(ar,lis);
end;
//EJERCICIO 4 Y 5
