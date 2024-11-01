program ej14;
const 
	valoralto = 9999;
type
	cadena=string[40];
	infoMaestro=record
		codProvincia:integer;
		nombreProvincia:cadena;
		codLocalidad:integer;
		nombreLocalidad:cadena;
		cantSinLuz:integer;
		cantSinGas:integer;
		cantChapa:integer;
		cantSinAgua:integer;
		sinSanitarios:integer;
	end;
	maestro = file of infoMaestro;
	infoDetalle=record
		codPr:integer;
		codL:integer;
		conLuz:integer;
		conGas:integer;
		construidas:integer;
		conAgua:integer;
		entregaS:integer;
	end;
	detalle=file of infoDetalle;
	vecDetalles = array[1..10] of detalle;
	regDetalles = array[1..10] of infoDetalle;

procedure leer(var ar:detalle;var reg:infoDetalle);
begin
	if(not eof(ar))then
		read,(ar,reg)
	else
		reg.provincia:=valoralto;
end;

procedure minimo (vec:regDetalles;var min:infoDetalle;var vecD:vecDetalles);
var
	i:integer;
	pos:integer;
begin
	min.codPr:=9999;
	min.codL:=999;
	for i:= 1 to 10 do begin
		if(vec[i].codPr < min.codPr)or(vec[i].codPr < min.codPr)and(vec[i].codL < min.codL)then begin
			min:=vec[i];
			pos:= i;
		end;
	end;
	if(min.codPr <> valoralto)then 
		leer(vecD[pos],vec[pos]);
end;

procedure actualizar(var m:maestro;reg:infoDetalle);
var
	regM:infoMaestro;
begin
	read(m,regM);
	while(not eof(m))and(regM.codProvincia <> reg.codPr)and(regM.codLocalidad <> reg.codL)do
				read(m,regM);
				
	regM.cantSinLuz:= regM.cantSinLuz - reg.conLuz;
	regM.cantSinGas:= regM.cantSinGas - reg.conGas;
	regM.cantChapa:= regM.cantChapa - reg.construidas;
	regM.cantSinAgua := regM.cantSinAgua - reg.conAgua;
	regM.sinSanitarios:= regM.sinSanitarios - reg.entregaS;
	seek(m,filepos(m)-1);
	write(m,regM);
end;

procedure actualizaInformacion(var maes:maestro;var vecD:vecDetalles);
var
	i:integer;
	regD:regDetalles;
	mismaPro:integer;
	minimo:infoDetalle;
	mismaLoc:integer;
	aux:infoDetalle;
begin
	reset(maes);
	for i:= 1 to 10 do begin
		assign(vecD[i],'deta' + i);
		reset(vecD[i]);
		leer(vecD[i],regD[i]);
	end;
	minimo(regD,minimo,vecD);
	while(minimo.codPr <> valoralto)do begin
		mismaPro:= mismo.codPr;
		while(minimo.codPr = mismaPro)do begin
			mismaLoc:= minimo.codL;
			aux.codPr:= minimo.codPr;
			aux.codL:= minimo.codL;
			aux.conLuz:=0;
			aux.conGas:=0;
			aux.construidas:=0;
			aux.conAgua:=0;
			aux.entregaS:=0;
			while(minimo.codL = mismaLoc)do begin
				aux.conLuz := aux.conLuz + minimo.conLuz;
				aux.conGas := aux.conGas + minimo.conGas;
				aux.conAgua:= aux.conAgua + minimo.conAgua;
				aux.construidas:= aux.construidas + minimo.construidas;
				aux.entregaS:= entregaS + minimo.entregaS;
				minimo(regD,minimo,vecD);
			end;
			actualizar(maes,aux);
		end;
	end;
	for i:= 1 to 10 do 
		close(vecD[i]);
	close(maes);
end;

procedure cuentaSinChapa(var arM:maestro; var can:integer);
var
	regM:infoMaestro;
begin
	read(arM,regM);
	while(not eof(arM))do begin
		if(regM.cantChapa = 0)then
				can:= can + 1;
		read(arM,regM);
	end;
end;

var													//programa principal.
	arMaestro:maestro;
	detas:vecDetalles;
	cantidad:integer;
begin
	assign(arMaestro,'ONG');
	cargaDetalles(detas);									//se dispone
	rewrite(arMaesto);
	cargaMaestro(arMaestro);								//se dispone
	actualizaInformacion(arMaestro,detas);
	cuentaSinChapa(arMaestro,cantidad);
	writeln('Cantidad de localidades sin viviendas de chapa = ',cantidad);
end.
