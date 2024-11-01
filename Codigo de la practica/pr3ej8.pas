program ej8;
const
	valoralto = 'ZZZZ';
type
	cadena=string[30];
	distribucion=record
		nombre:cadena;
		año:integer;
		version:integer;
		cantDev:integer;
		descripcion:string;
	end;
	archivo:file of distribucion;
	
procedure cargaDistribuciones(var ard:archivo);                       //se dispone

procedure leer(var ar:archivo; var regis:distribucion);
begin
	if(not eof(ar))then
		read(ar,regis);
	else
		regis.nombre:= valoralto;
end;

function ExisteDistribucion(var ar:archivo; nom:cadena):boolean;
var
	reg:distribucion;
begin
	reset(ar);
	leer(ar,reg);
	while(reg.nombre <> valoralto)and(reg.nombre <> nom)do 
		leer(ar,reg);
	if(reg.nombre = nom)then
		ExisteDistribucion := true;
	else
		ExisteDistribucion := false;
	close(ar);
end;

procedure leeDistribucion(var di:distribucion);

procedure AltaDistribucion(var a:archivo; d:distribucion);
var
	posicion:integer;
	cabecera:distribucion;
	reg:distribucion;
begin
	reset(a);
	read(a,cabecera); 										//lee lo que hay en la cabecera
	if(cabecera.año < 0)then begin							//INTERCAMBIA LOS DATOS QUE ESTABAN EN LA CABECERA Y EN LA POSICION A LA QUE APUNTA LA CABECERA.
		posicion := cabecera.año * -1;                      //guarda la posicion para asignar
		seek(a,posicion);									//se posiciona en la posicion a reasignar
		read(a,reg);									    //lee lo que hay ahi
		seek(a,filepos(a)-1);								//me posiciono devuelta en la posicion a reasignar
		write(a,d);										    //escribe el registro a dar a alta
		seek(a,0);											//me posiciono en la cabecera 
		write(a,reg);									    //escribo en la cabecera el registro que estaba en la posicion a reasignar
		writeln('Reasigno el espacio con la lista invertida');
	end;
	else begin
		seek(a,filesize(a));								//me posiciono en lo ultimo del archivo
		write(a,d);											//escribe el archivo a dar a alta
		writeln('Agrego el archivo atras del archivo');
	end;
	close(a);
end;

procedure bajaDistribucion(var ar:archivo; n:cadena);
var
	cabecera:distribucion;
	regA:archivo;
begin
	reset(ar);
	read(ar,cabecera);
	leer(ar,regA);
	while(regA.nombre <> valoralto)and(regA.nombre <> n)do 
		leer(ar,regA);
	if(regA.nombre = n)then begin					//si se encontro la distribucion a eliminar
		seek(ar,filepos(ar)-1);						//se vuelve a posicionar en la posicion donde la encontro
		write(ar,cabecera);							//escribe lo que habia en la cabecera
		regA.año:= (filepos(ar)-1)* -1;				//escribe la nueva posicion a reasignar en el campo "año" del registro eliminado de forma logica
		seek(ar,0);								    //se posiciona en la cabecera
		write(ar,regA);             				//escribe la nueva cabecera con el dato eliminado y la referencia a la nueva posicion a reasignar
	end
	else 
		writeln('No se encontro una distribucion con el nombre ',n);
	close(ar);
end;

var																	  //programa principal
	archi:archivo;
	nombreD:cadena;
	existe:boolean;
begin
	assign(archi,'DistribucionesLinux');
	rewrite(archi);
	cargaDistribuciones(archi);                                        //se dispone
	writeln('Ingrese el nombre de una distribucion');
	readln(nombreD);
	existe = ExisteDistribucion(archi,nombreD);
	leeDistribucion(dis);
	if(ExisteDistribucion(dis.nombre))then
		AltaDistribucion(archi,dis);
	else
		writeln('Ya existe la distribucion');
	writeln('Ingrese el nombre de una distribucion a elimnar');
	readln(nombreD);
    bajaDistribucion(archi,nombreD);
end.
