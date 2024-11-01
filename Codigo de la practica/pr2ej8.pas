program ej8;
const
	valoralto = 9999;
type
	cadena=string[30];
	
	infoCliente=record
		codigo:integer;
		nombre:cadena;
		apellido:cadena;
	end;

    info=record
		cliente:infoCliente;
		año:integer;
		mes:integer;
		dia:integer;
		monto:real;
    end;
    
	maestro = file of info;

procedure leer(var ar:maestro;var r:info);
begin
	if(not eof(ar))then
		read(ar,r)
	else
		r.cliente.codigo:= valoralto;
end;

procedure imprimeDatosClientes(cl:infoCliente);
begin
	writeln('---------------------------------');
	writeln('Codigo del cliente ',cl.codigo);
	writeln('Nombre del cliente ',cl.nombre);
	writeln('Apellido del cliente ',cl.apellido);
end;

procedure reporte (var m:maestro);
var
	reg:info;
	auxAño:integer;
	auxMes:integer;
	totalMes:real;
	totalAño:real;
	mismoCliente:integer;
	montoTotalEmpresa:real;
begin
	montoTotalEmpresa:=0;
	leer(m,reg);
	while(reg.cliente.codigo <> valoralto)do begin 									//corregir corte de control
		imprimeDatosCliente(reg.cliente);
		while(mismoCliente = reg.cliente.codigo)do begin
			auxAño:= reg.año;
		    totalAño:=0;
			while((mismoCliente = reg.cliente.codigo)and(auxAño = reg.año))do begin
				auxMes:= reg.mes;
				totalMes:=0;
				while((mismoCliente == reg.cliente.codigo)and(auxAño = reg.año)and(auxMes = reg.mes))do begin
					totalMes:= totalMes + reg.monto;
					leer(m,reg);
				end;
				if(totalMes <> 0)then
					writeln('Monto del mes ',reg.mes,' = ',totalMes);
				totalAño:= totalAño + totalMes;
		    end;
		    montoTotalEmpresa:= montoTotalEmpresa + totalAño;
		    writeln('Monto del año ',reg.año, ' = ',totalAño);
		end;
	end;
	writeln('Monto total de la empresa = ', montoTotalEmpresa);
end;

var																	//programa principal
	ma:maestro;
begin
    assing(ma, 'Maestro');
    rewrite(ma);
    cargaMaestro(ma);
	reporte(ma);
end.
