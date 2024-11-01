program ej2;
const
    valoralto = 9999;
type
    cadena = string[65];
	asistente = record
		numero:integer;
		apeNom:cadena;
		email:cadena;
		telefono:integer;
		dni:integer;
	end;
	maestro = file of asistente;

procedure leer(var ar:archivo; reg:asistente);
begin
	if(not eof(ar))then
		read(ar,reg)
	else
		reg.numero = valoralto;
end;

procedure cargaMaestro(var ma:maestro);

	procedure leeAsistente(var a:asistente);
	begin
		readln(a.dni);
		if(a.dni <> 0)then begin
			readln(a.numero);
			readln(a.apeNom);
			readln(a.email);
			readln(a.telefono);
		end;
	end;

var
	asis:asistente;
begin
	leeAsistente(asis);
	while(asis.dni <> 0)do begin
		write(ma,asis);
		leeAsistente(asis);
	end;
	close(ma);
end;

procedure eliminaAsistentes(var m:maestro);
var
	reg:asistente;
begin
	reset(m);
	leer(m,reg);
	while(reg.numero <> valoralto))do begin
		if(reg.numero < 1000) begin
			reg.apeNom := '@';
			seek(m,filepos(m)-1);
			write(m,reg);
		end;
		leer(m,reg);
	end;
	close(m);
end;

var
	maes:maestro;
begin
	assign(maes,'Asistentes Congreso');
	rewrite(maes);
	cargaMaestro(maes);
	eliminaAsistentes(maes);
end.
