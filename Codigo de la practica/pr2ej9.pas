program ej9;
const
	valoralto = 9999;
type 
	info=record
		codigoProvincia:integer;
		codigoLocalidad:integer;
		numMesa:integer;
		cantVotos:integer;
	end;
	archivo = file of info;

procedure cargaArchivo(var arc:archivo);						//se dispone

procedure leer(var ar:archivo; var regis:info);
begin
	if(not eof(ar))then
		read(ar,regis)
	else
		regis.codigoProvincia:=valoralto;
end;

procedure informaListado(var a:archivo);
var
	reg:info;
	mismaP:integer;
	mismaL:integer;
	totalV:integer;
	totalVotosProvincia:integer;
	totalVotosGenerales:integer;
begin
	totalVotosGenerales:=0;
	leer(a,reg);
	while(reg.codigoProvincia <> valoralto)do begin										//corregir cortes de control
	    totalVotosProvincia:=0;
		mismaP:=reg.codigoProvincia;
		writeln('Codigo provincia ',reg.codigoProvincia);
		writeln('Codigo Localidad         Total Votos');
		while(reg.codigoProvincia = mismaP)do begin
			mismaL:= reg.codigoLocalidad;
			totalVotos:=0;
			while((reg.codigoProvincia = mismaP)and(reg.codigoLocalidad = mismaL))do begin
				totalVotos:= totalVotos + reg.cantVotos;
				leer(a,reg);
			end;
			writeln(reg.codigoLocalidad,'       ',totalVotos);
			totalVotosProvincia:= totalVotosProvincia + totalVotos;
		end;
	    writeln('Total de Votos Provincia ',totalVotosProvincias);
	    totalVotosGenerales:= totalVotosGenerales + totalVotosProvincias;
	end;
	writeln('Total de Votos Generales ', totalVotosGenerales);
	close(a);
end;

var													//programa principal.
	ar:archivo;
begin
	assign(ar,'Elecciones');
	rewrite(ar);
	cargaArchivo(ar);
	informaListado(ar);
end.
