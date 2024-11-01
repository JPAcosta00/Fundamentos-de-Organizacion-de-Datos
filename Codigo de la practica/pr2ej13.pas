program ej13;
const 
	valoralto = 'ZZZZ';
type
	cadena = string[40];
	infoMaestro = record
		destino:cadena;
		fecha:cadena;
		hora:integer;
		cantDisponibles:integer;
	end;
	maestro = file of infoMaestro;
	infoDetalle = record
		destino:cadena;
		fecha:cadena;
		hora:integer;
		cant:integer;
	end;
	detalle = file of infoDetalle;
	lista = ^nodo;
	info=record
		destino:cadena;
		fecha:cadena;
		hora:integer;
	end;
	nodo = record
		dato:info;
		sig:lista;
	end;


var
	lis:lista;
	maes:maestro;
	det1:detalle;
	det2:detalle;
	cantidad:integer;
	
procedure leer(var ar:detalle; var reg:infoDetalle);
begin
	if(not eof(ar))then 
		read(ar,reg);
	else 
		reg.destino = valoralto;
end;
	
procedure minimo (r1,r2:infoDetalle; var min:infoDetalle);
begin
	if(r1.destino < r2.destino)then begin
		min:= r1;
		leer(det1,r1);
	else
	    min:= r2;
	    leer(det2);
	end;
end;

procedure actualizaYcargaLista(var m:maestro; regMin:infoDetalle;cantP:integer);
var
	regM:infoMaestro;
	fecha:cadena;
	hora:integer;
begin
	read(m,regM);
	while(not eof(m))and(regM.destino <> regMin.destino)do begin
		fecha:=regM.fecha;
		while(not eof(m))and(regM.destino <> regMin.destino)and(fecha <> regMin.fecha)do begin
			hora:= regM.hora;
			while(not eof(m))and(regM.destino <> regMin.destino)and(regM.fecha <> regMin.fecha)and(hora <> regMin.hora)do begin
				read(m,regM);
			end;
		end;
	end,
	regM.cantDisponibles:= regM.cantDisponibles - cantP;
	seek(m,filepos(m)-1);
	write(m,regM);
end;

procedure actualizaVuelos(var ma:maestro;var de1:detalle;var de2:detalle);
var
	minimo:infoDetalle;
	regD1:infoDetalle;
	regD2:infoDetalle;
	mismoDestino:cadena;
	mismaFecha:cadena;
	mismaHora:integer;
	cantPasajes:integer;
begin
	reset(ma);
	reset(de1);
	reset(de2);
	leer(de1,regD1);
	leer(de2,regD2);
	minimo(regD1,regD2,minimo);
	while(minimo.destino <> valoralto)do begin
		mismoDestino := minimo.destino;
		while(minimo.destino = mismoDestino)do begin
			mismaFecha := minimo.fecha;
			while(minimo.destino = mismoDestino)and(minimo.fecha = mismaFecha)do begin
				mismaHora := minimo.hora;
				cantPasajes:=0;
				while(minimo.destino = mismoDestino)and(minimo.fecha = mismaFecha)and(minimo.hora = mismaHora)do begin
					cantPasajes:=cantPasajes + 1;
					minimo(regD1,regD2,minimo);
				end;
				actualizaYcargaLista(ma,minimo,cantPasajes);
			end;
		end;
	end;
	close(ma);
	close(de1);
	close(de2);
end;

procedure agregaAdelante(var l:lista; des:cadena; fe:cadena; horario:integer);
var
	nue:lista;
begin
	new(nue);
	nue^.dato.destino:= des;
	nue^.dat.fecha:= fe;
	nue^.dato.hora:= horario;
	nue^.sig:= l;
	l:=nue;
end;

procedure generaLista(var mas:maestro; var li:lista; ca:integer);
var
	destino:cadena;
	fecha:cadena;
	hs:integer;
	regis:infoMaestro;
begin
	reset(mas);
	read(mas,regis);
	while(not eof(mas))do begin
		destino:= regis.destino;
		while(regis.destino = destino)do begin
			fecha := regis.fecha;
			while(regis.destino = destino)and(regis.fecha = fecha)do begin
				hs:= regis.hora;
				while(regis.destino = destino)and(regis.fecha = fecha)and(regis.hora = hs)do begin
					if(regis.cantDisponible < ca)then
						agregaAdelante(li,regis.destino,regis.fecha,regis.hora);
					read(mas,regis);
				end;
			end;
		end;
	end;
	close(mas);
end;

begin
	lis:=nil;
	assign(maes,'MAESTRO');
	assign(det1,'Detalle1');
	assign(det2,'Detalle2');
	rewrite(maes);
	rewrite(det1);
	rewrite(det2);
	writeln('Ingrese la cantidad minima de pasajes para devolver la lista de vuelos');
	readln(cantidad);
	actualizaVuelos(maes,det1,det2);
	generaLista(maes,lis,cantidad);
end.
