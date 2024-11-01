program ej15;
const
	valoralto = 9999;
type
	cadena = string[60];
	emision=record
		fecha:integer;
		codSemanario:integer;
		nomSemanario:cadena;
		descripcion:cadena;
		precio:real;
		totalEjem:integer;
		totalEjemVendidos:integer;
	end;
	maestro=file of emision;
	infoDetalle=record
		fecha:integer;
		codigo:integer;
		cantVendidos:integer;
	end;
	detalle = file of infoDetalle;
	detalles = array[1..100] of detalle;
	registros = array[1..100] of infoDetalle;

procedure cargaMaestro(var arm:maestro);							//se dispone

procedure leer(var ar:detalle;var reg:infoDetalle);
begin
	if(not eof(ar))then
		read(ar,reg)
	else
		reg.fecha := valoralto;
end;

procedure minimo(vector:registros;var min:infoDetalle;var vd:detalles);
var
	i:integer;
	posicion:integer;
begin
	min.fecha:= 9999;
	min.codSemanario:=9999;
	for i:= 1 to 100 do begin
		if(vector[i].fecha < min.fecha)or(vector[i].fecha < min.fecha)and(vector[i].codSemanario < min.codigo)then begin
			min:= vector[i];
			posicion:= i;
		end;
	end;
	if(min.fecha <> valoralto)then 
		leer(vd[posicion],vector[posicion]);
end;

procedure actualizaEmisiones(var m:maestro; fecha:integer; cod:integer; cantidad:integer);
var
	regM:emision;
begin
	read(m,regM);
	while(not eof(m))and(regM.fecha < fecha)and(regM.codSemanario < cod)do
		read(m,regM);
	regM.totalEjemVendidos:= regM.totalEjemVendidos + cantidad;
	regM.totalEjem:= regM.totalEjem - cantidad;
	seek(m,filepos(m)-1);
	write(m,regM);
end;

procedure actualizaSemanarios(var ma:maestro; var vec:detalles);
var
	minimo:infoDetalle;
	regis:registros;
	i:integer;
	mismaFecha:integer;
	mismoCodigo:integer;
	contador:integer;
begin
	for i:= 1 to 100 do begin
		assign(vec[i], detalle + i);
		reset(vec[i]);
		leer(vec[i],regis[i]);
	end;
	reset(ma);
	minimo(regis,minimo,vec);
	while(minimo.fecha <> valoralto)do begin
		mismaFecha := minimo.fecha;
		while(minimo.fecha = mismaFecha)do begin
			mismoCodigo := minimo.codigo;
			contador:=0;
			while(minimo.fecha = mismaFecha)and(minimo.codigo = mismoCodigo)do begin
				contador:= contador + minimo.cantVendidos;
				minimo(regis,minimo,vec);
			end;
			if(contador <> 0)then
				actualizaEmisiones(ma,mismaFecha,mismoCodigo,contador);
		end;
	end;
	close(ma);
	for i:= 1 to 100 do 
		close(vec[i]);
end;

procedure calcula(var a:maestro;var masF,cMas,menosF,cMenos:integer);
var
	min:integer;
	max:integer;
	re:emision;
begin	
	reset(a);
	max:=-1;
	min:=9999;
	read(a,re);
	while(not eof(a))do begin
		if(re.totalEjemVendidos  > max)then begin
			masF:= re.fecha;
			cMas:=re.codSemanario;
			max:=re.totalEjemVendidos;
		end;
		if(re.totalEjemVendidos  < min)then begin
			menosF:= re.fecha;
			cMenos:= re.codSemanario;
			min:= re.totalEjemVendidos;
		end;
		read(a,re);
	end;
	close(a);
end;

var																				//programa principal
	maes:maestro;
	vecDe:detalles;
	masFecha,codMas:integer;
	menosFecha,codMenos:integer;
begin
	assign(maes,'Emision');
	rewrite(maes);
	cargaMaestro(maes);
	cargaDetalles(vecDe);
	actualizaSemanarios(maes,vecDe);
	calcula(maes,masFecha,codMas,menosFecha,codMenos);
	writeln('Mas ventas de ejemplares: Semanario: ',codMas,' fecha: ',masFecha);
	writeln('Menos ventas de ejemplares: Semanario: ',codMenos,' fecha: ',menosFecha);
end.
