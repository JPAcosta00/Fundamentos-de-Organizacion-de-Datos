program ej11;
type 
	informacion=record
		año:integer;
		mes:integer;
		dia:integer;
		idUsuario:integer;
		tiempo:integer;
	end;
	archivo = file of informacion;

procedure cargaAccesos(var archi:archivo);						//se dispone

procedure informa(var a:archivo; añoPedido:integer);
var
	info:informacion;
	mismoMes:integer;
	mismoDia:integer;
	tAcceso:integer;
	mismoUsuario:integer;
	totalDia:integer;
	totalMes:integer;
	totalAño:integer;
begin
	writeln('Año ',añoPedido);
	totalAño:=0;
	while(info.año = añoPedido)do begin
		writeln('Mes ',info.mes);
		mismoMes:= info.mes;
		totalMes:=0;
		while((info.año = añoPedido)and(info.mes = mismoMes))do begin
			writeln('Dia ',info.dia);
			mismoDia:= info.dia;
			totalDia:=0;
			while((info.año = añoPedido)and(info.mes = mismoMes)and(info.dia = mismoDia))do begin
				mismoUsuario:= info.idUsuario;
				tAcceso:=0;
				while ((info.año = añoPedido)and(info.mes = mismoMes)and(info.dia = mismoDia)and(info.idUsuario = mismoUsuario))do begin
					tAcceso:=tAcceso + info.tiempo;
					read(a,info);
				end;
				writeln('idUsuario ',info.idUsuario,'Total de acceso',tAcceso,' en el dia ',info.dia,' mes ',info.mes);
				totalDia:= totalDia + tAcceso;
			end;
			writeln('Tiempo total acceso',totalDia,' dia ',info.dia,' mes ',info.mes);
			totalMes:= totalMes + totalDia;
		end;
		writeln('Total tiempo de acceso',totalMes,' del mes ',info.mes);
		totalAño:= totalAño + totalMes;
	end;
	writeln('Total tiempo de acceso año: ',totalAño);
	close(a);
end;

procedure busca(var a:archivo; añoBuscado:integer);
var
	reg:informacion;
begin
	reset(a);
	read(a.reg);
	while(not eof(a))and(reg.año <> añoBuscado)do 
		read(a,reg);
	if(reg.año = añoBuscado)then begin
		informa(a,añoBuscado);
	end;
	else
		writeln('Año no encontrado.');
	close(a);
end;

var																//programa principal
	ar:archivo;
	añoInforme:integer;
begin
	assign(ar,'Accesos');
	rewrite(ar);
	cargaAccesos(ar);
	writeln('Ingrese el año a informar los accesos');
	readln(añoInforme);
	busca(ar,añoInforme)
end.
