program ej7;
const 
	valoralto = 9999;
type
	cadena = string[50];
	especies=record
		codigo:integer;
		nombre:cadena;
		familiaAve:cadena;
		descripcion:string;
		zona:string;
	end;
	archivo = file of especies;

procedure cargaEspecies(var archi:archivo);             //se dispone

procedure leer(var arm:archivo; var r:especies);
begin
	if(not eof(arm))then
		read(arm,r)
	else
		r.codigo = valoralto;
end;

procedure baja(var am:archivo; cod:integer);
var
	regE:especies;
begin
	leer(am,regE);
	while(regE.codigo <> valoralto)and(regE.codigo <> cod)do
		leer(am,regE);
	if(regE.codigo = cod)then                                         //hace baja logica
		regE.codigo := -1;
		seek(am,filepos(am)-1);
		write(am,regE);
	else
		writeln('No se encontro la especie con el codigo ',cod);
end;

procedure eliminaLogicamente(var a:archivo);

	procedure leeEspecie(var e:especies);
	begin
		readln(e.codigp);
		if(e.codigo <> 500000)then begin
			readln(e.nombre);
			readln(e.familiaAve);
			readln(e.descripcion);
			readln(e.zona);
		end;
	end;
	
var
	espe:especies;
begin
	writeln('Ingrese la especie a eliminar');
	leeEspecie(espe);
	while(espe.codigo <> 500000)do begin
		baja(a,espe.codigo);
	    writeln('Ingrese la especie a eliminar');
	    leeEspecie(espe);
	end;
end;

procedure haceTruncamiento(var ar:archivo);
var
	reg:especies;
	posicion:integer;
	aux:especies;
	posConEspecie:integer;
begin
    reset(ar);
	leer(ar,reg);
	while(reg.codigo <> valoralto)do begin
		if(reg.codigo = -1)then begin                   //si es una especie eliminada
			posicion:filePos(ar)-1;                     //guarda la posicion que estaba la especie eliminada 
			seek(ar,filesize(ar));                      //Se posiciona en lo ultimo del archivo
			read(ar,aux);                               //lee lo que hay a lo ultimo del archivo
		    if(aux.codigo <> -1)then begin              //si noy hay otra especie eliminada
				write(ar,reg);                          //escribe la especie eliminada
				posConEspecie:=filePos(ar)-1;           //guardo la posicion donde esta el ultimo valor real sin eliminar.
				seek(ar,posicion);                      //se posiciona en el lugar que habia dejado
				write(ar,aux);                          //escribe el ultimo elemento del archivo 
			else begin                                  //si esta una especie eliminada
				while(aux.codigo = -1)do  begin         //lee hacia atras hasta leer un elemento sin eliminar
					seek(ar,filepos(ar)-2);
					read(ar,aux);
				end;
				write(ar,reg);                          //cuando sale quiere decir que encontro una especie sin eliminar
				posConEspecie:= filepos(ar)-1;
				seek(ar,posicion);                      //Se posiciona en el lugar que dejo el eliminado
				write(ar,aux);                          //escribe el dato que estaba a lo ultimo
			end;
		end;
		leer(ar,reg);
	end;
	seek(ar,posConEspecie);                             //se posiciona en el ulimo elemento sin borrar del archivo (adelante de las especies elimnadas)
	Truncate(ar);                                       //trunca, compacta el archivo.
	close(ar);
end;

var                                                     //programa principal
	ar:archivo;
begin
	assign(ar,'ArchivoEspecies');
    rewrite(ar);
    cargaEspecies(ar);
    eliminaLogicamente(ar);
    haceTruncamiento(ar);
end.
