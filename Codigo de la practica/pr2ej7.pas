program ej7;
const 
	valorAlto = 9999;
type 
	cadena = string[35];
	info=record
		codigoLocalidad:integer;
		codigoCepa:integer;
		cantA:integer;
		cantN:integer;
		cantR:integer;
		cantF:integer;
	end;
	arDetalle = file of info;
	detalles=array[1..10] of arDetalle;
	vector=array[1..10]of info;
	
	datosMaestro=record
		codigoLocalidad:integer;
		nombreLocalidad:integer;
		codigoCepa:integer;
		nombreCepa:integer;
		cantidadA:integer;
		cantidadN:integer;
		cantidadR:integer;
		cantidadF:integer;
	end;
	maestro = file of datosMaestro;
	
procedure cargaMaestro(var maestr:maestro);                          //se dispone

procedure cargaDetalles(var dets:detalles);							//se dispone

procedure leer(var ar:arDetalle; var reg:info);
begin
	if(not eof(ar))then
		read(ar,reg)
    else
		reg.codigoLocalidad:=valorAlto;
end;

procedure minimo(var d:detalles; var vec:vector; var minimo:info);
var
	 i:integer;
	 indice:integer;
begin
    minimo.codigoLocalidad:= valorAlto;
	for i:= 1 to 10 do begin
		if(vec[i].codigoLocalidad < minimo.codigoLocalidad)or((vec[i].codigoLocalidad < minimo.codigoLocalidad)and(vec[i].codigoCepa < minimo.codigoCepa))then begin
			minimo:=vec[i];
			indice:=i;
		end;
	end;
	if(minimo.codigo<>valorAlto)then
		leer(d[indice],vec[indice]);
end;

procedure actualizaMaestro(var m:maestro; reg:info);
var
	datosM:datosMaestro;
begin
	while(not eof(m))and(datosM.codigoLocalidad s<> reg.codigoLocalidad)and(datosM.codigoCepa <> reg.codigoCepa)do 
		read(m,datosM);
		
	datosM.cantidadF := datosM.cantidadF + reg.cantF;
	datosM.cantidadR := datosM.cantidadR + reg.cantR;
	datosM.cantidadN := reg.cantN;
	datosM.cantidadA := reg.cantA;
	seek(m,filepos(m)-1);
	write(m,datosM);
end;

procedure actualizaCasos(var ma:maestro; var det:detalles);
var
	vecDetalles:vector;
	i:integer;
	min:info;
	aux:info;
begin
	for i:=1 to 10 do begin
		assign(det[i], det+1);
		reset(det[i]);
		leer(det[i],vecDetalles[i]);
	end;
	minimo(det,vecDetalles,min);
	while(min.codigoLocalidad <> valorAlto)do begin
		aux.codigoLocalidad:=min.codigoLocalidad;
		while(min.codigoLocalidad = aux.codigoLocalidad)do begin
			aux.codigoCepa:= min.codigoCepa;
			while(min.codigoLocalidad = aux.codigoLocalidad)and(min.codigoCepa = aux.codigoCepa)do begin
				aux.cantA:= aux.cantA + min.cantA;
				aux.cantN:= aux.cantN + min.cantN;
				aux.cantR:= aux.cantR + min.cantR;
				aux.cantF:= aux.cantF + min.cantF;
				minimo(det,vecDetalles,min);
			end;
			actualizaMaestro(ma,aux);
		end;
	end;
	close(ma);
    for i:= 1 to 10 do 
		close(det[i]);
end;

procedure cuentaMas50Casos(var ma:maestro; var cant:integer);
var
   dat:datosMaestro;
begin
    reset(ma);
	while(not eof(ma))do begin
		read(ma,dat);
		if(dat.cantidaA > 50)then 	
			cant:= cant+1;
	end;
	close(ma);
end;

var																	//programa principal
	maes:maestro;
	detas:detalles;
	cantidad:integer;
begin
    cantidad:=0;
	assign(maes,'COVID');
	rewrite(maes);
	cargaMaestro(maes);												//se dispone
	cargaDetalles(detas);											//se dispone
	reset(maes);
	actualizaCasos(maes,detas);
	cuentaMas50Casos(maes,cantidad);
	writeln('Cantidad de localidades con mas de 50 casos activos de covid = ', cantidad);
end.
