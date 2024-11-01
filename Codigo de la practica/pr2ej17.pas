program ej17;
type 
	cadena=string[50];
	informacion=record
		codLocalidad:integer;
		nomLocalidad:cadena;
		codMunicipio:integer;
		nomMunicipio:cadena;
		codHospital:integer;
		nomHospital:cadena;
		fecha:integer;
		cantCasos:integer;
	end;
	maestro = file of informacion;
	
procedure cargaMaestro (var M:maestro);						//se dispone

procedure cargaText(var a:Text; muni,loca:cadena; canti:integer);
begin
	write(a,' ',
		'Localidad: ', loca,' ',
		'Municipio: ', muni,' ',
		'Cantidad de casos: ',canti,' ');                                     //Menor cantidad de lecturas posibles(Escribe toda la informacion en una linea sola.)
end;

procedure listado(var m:maestro;var ar:Text);
var
	reg:informacion;
	mismaLocalidad:cadena;
	mismoMunicipio:cadena;
	mismoHospital:cadena;
	cantH:integer;
	cantM:integer;
	cantL:integer;
	totalP:integer;
begin
	totalP:=0;
	reset(m);
	read(m,reg);
	while(not eof(m))do begin
		mismaLocalidad := reg.nomLocalidad;
		writeln('Nombre: ', reg.nomLocalidad);
		cantL:=0;
		while(reg.nomLocalidad = mismaLocalidad)do begin
			mismoMunicipio := reg.nomMunicipio;
			writeln('Nombre: ',reg.nomMunicipio);
			cantM:=0;
			while(reg.nomLocalidad = mismaLocalidad)and(reg.nomMunicipio = mismoMunicipio)do begin
				mismoHospital := reg.nomHospital;
				cantH:=0;
				while(reg.nomLocalidad = mismaLocalidad)and(reg.nomMunicipio = mismoMunicipio)and(reg.nomHospital = mismoHospital)do begin
					cantH:= cantH + reg.cantCasos;
					read(m,reg);
				end;
				cantM:= cantM + cantH;
				writeln('Hospital: ',mismoHospital,'------------','Cantidad de casos: ',cantH);
			end;
			cantL:= cantL + cantM;
			if(cantM > 1500)then
				cargaText(ar,mismoMunicipio,mismaLocalidad,cantM);
			writeln('Cantidad de casos Municipio ',mismoMunicipio,' = ',cantM);
		end;
		totalP:= totalP + cantL;
		writeln('Cantidad de casos localidad ',mismaLocalidad,' = ',cantL);
		writeln('------------------------------------------------------------');
	end;
	writeln('Casos totales de la provincia: ',totalP);
	reset(m);
end;

var																								//programa principal.
	maes:maestro;
	archi:Text;
begin
	assign(archi,'TextoCovid-19');
	rewrite(archi);
	assign(maes,'COVID-19');
	rewrite(maes);
	cargaMaestro(maes);
	listado(maes,archi);
end;
