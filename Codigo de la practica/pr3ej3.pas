program ej3;
const
    valoralto = 9999;
type 
	cadena = string[40];
	novela = record
		codigo:integer;
		genero:integer;
		nombre:cadena;
		duracion:integer;
		director:cadena;
		precio:real;
	end;
	archivo = file of novela;

procedure inicializaCabecera(var mas:maestro);
var
	reg:novela;
begin
	reg.codigo:= 0;
	write(mas,reg);
end;

procedure leer(var ar:archivo; reg:novela);
begin
	if(not eof(ar))then
		read(ar,reg)
	else
		reg.codigo := valoralto;
end;

procedure lector(var n:novela);
begin
    writeln('Ingrese el codigo de la novela');
	readln(n.codigo);
	if(n.codigo <> 0)then begin
	    writeln('Ingrese el genero ');
		readln(n.genero);
		writeln('Ingrese el nombre');
		readln(n.nombre);
		writeln('Ingrese la duracion');
		readln(n.duracion);
		writeln('Ingrese el director');
		readln(n.director);
		writeln('Ingrese el precio');
		readln(n.precio);
		writeln('----------------------------');
	end;
end;

procedure cargaArchivo(var m:maestro);
var
	no:novela;
begin
	lector(no);
	while(no.codigo <> 0)do begin
		write(m,no);
		lector(no);
	end;
end;

procedure daAlta(var mas:maestro; reg:novela);
var
	rMaes:novela;
	aux:novela;
	posicion:integer;
begin
	reset(mas);
	read(mas,rMaes);                                       //leo el registro cabecera
	if(rMaes.codigo < 0)then begin
		posicion:= rMaes.codigo * -1;                      //Posicion positiva 
		seek(mas,posicion);                                //me posiciono en la marca que habria lugar
        read(mas,aux);                                     //leo lo que hay en la posicion de la marca
        
		seek(mas,filepos(mas)-1);
		write(mas,reg);                                //escribo la novela a dar alta
		
		seek(mas,0);                                   //posiciona en la cabecera
		write(mas,aux);                                //escribe la marca del siguiente lugar a reasignar  
	    writeln('Se realizo la operacion Alta usando la cabecera correctamente.');
	end;
	else                                                    //si no hay lugares en el medio para reasignar entonces lo agrega atras 
	   seek(mas,filesize(mas));
	   write(mas,reg);
	   writeln('Se agrego la novela en la ultima posicion del archivo.');
	close(mas);
end;

procedure modificaNovela(var m:maestro; rn:novela);
var
	regis:novela;
begin
    reset(m);
	leer(m,regis);
	while(regis.codigo <> valoralto)and(novela.codigo <> rn.codigo)do 
		leer(m,regis);
	if(regis.codigo = rn.codigo)then begin
		seek(m,filepos(m)-1);
		regis.genero:= rn.genero;                                              //actualiza todos los campos menos el codigo de la novela
		regis.nombre:= rn.nombre;
		regis.duracion:= rn.duracion;
		regis.director:= rn.director;
		regis.precio:= rn.precio;
		write(m,regis);
		writeln('Se modifico la novela correctamente.');
	end;
	else
		writeln('No se encontro ninguna novela con el codigo de novela ',rn.codigo);
	close(m);
end;

procedure daBaja(var arm:archivo; cod:integer);
var
	cabecera:novela;
	regM:novela;
	posBorrar:integer;
begin
	reset(arm);
	read(arm,cabecera);
	leer(arm,regM);
	while(regM.codigo <> valoralto)and(regM.codigo <> cod)do 
		leer(arm,regM);
	if(regM.codigo = cod)then begin
		posBorrar := filepos(arm)-1;                          //guardo la posicion a borrar
		seek(arm,posBorrar);
		write(arm,cabecera);								  //escribo el contenido de la cabecera en el lugar a borrar
		regM.codigo := posBorrar * -1;					      //guardo en el codigo la posicion en negativa para poder reasignar el espacio de ser necesario en un futuro
		seek(arm,0);									      //me posiciono en la cabecera
		write(arm,regM);									  //escribe el la cabecera (codigo = posicion libre en negativo)
		writeln('Se elimino la novela correctamente');
	end;
	else
		writeln('No se encontro una novela con ese codigo');
	close(arm);
end;

procedure cargaArTexto(var am:archivo; var at:Text);
var
	reg:novela;
begin
	reset(am);
	reset(at);
	read(am,reg);                                              //lee la cabecera
	leer(am,reg);
	while(reg.codigo <> valoralto)do begin
		writeln(at,' ',
			'Codigo: ',reg.codigo,' ',
			'Genero: ',reg.genero,' ',
			'Nombre: ',reg.nombre,' ',
			'Duracion: ',reg.duracion,' ',
			'Director: ',reg.director,' ',
			'Precio: ',reg.precio);
		leer(am,reg);
	end;
	close(am);
	close(at);
end;

var 
	maestro:archivo;
	nombre:cadena;
	opcion:integer;
	opcionB:integer;
	novel:novela;
	codigo:integer;
	deTexto:Text;
begin
	writeln('Menu de opciones:');
	writeln('Opcion 1: crear archivo');
    writeln('Opcion 2: Hacer mantenimiento del archivo');
    writeln('Opcion 3: Crear archivo de texto');
    writeln('Ingrese la opcion a realizar');
    readln(opcion);
    case opcion of
       1: begin
			writeln('Ingrese el nombre del archivo');
			readln(nombre);
			assign(maestro,nombre);
			rewrite(maestro);
			inicializaCabecera(maestro);
			cargaArchivo(maestro);
			writeln('Archivo cargado correctamente');
		  end;
	   2:begin
			writeln('Elegir el tipo de mantenimiento que se quiere hacer');
			writeln('Mantenimiento 1: Dar de alta una novela');
			writeln('Mantenimiento 2: Modificar la novela sin incluir el codigo');
			writeln('Mantenimiento 3: Dar de baja una novela');
			writeln('Ingrese el tipo de mantenimiento a realizar');
			readln(opcionB);
			case opcionB of
				1: begin
					lector(novel);
					daAlta(maestro,novel);
				   end;
				2: begin
				    lector(novel);
				    modificaNovela(maestro,novel);
				   end;
				3: begin
					writeln('Ingrese el codigo de la novela que quiere eliminar');
					readln(codigo);
					daBaja(maestro,codigo);
				   end;
	     end;
	   3:begin
			assign(deTexto,'Novelas.txt');
			rewrite(deTexto);
			cargaArTexto(maestro,deTexto);
	     end;
end.
