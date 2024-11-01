program ej12;
const
	valoralto = 9999;
type
	cadena = string[25];
	info=record
		nroUsuario:integer;
		nombreUsuario:cadena;
		nombre:cadena;
		apellido:cadena;
		cantMails:integer;
	end;
	maestro = file of info;
	deta=record
		nroUsuario:integer;
		cuentaDestino:integer;
		cuerpoMSJ:string;
	end;
	detalle = file of deta;

procedure cargaServer(var arM:maestro);					//se dispone

procedure cargaCorreos(var arD:detalle);				//se dispone

procedure leer(var a:detalle; var reg:deta);
begin
	if(not eof(a))then
		read(a,reg)
	else
		reg.nroUsuario:=valoralto;
end;

procedure escribirMaestro(var m:maestro;num:integer;cant:integer;var t:Text);
var
	regM:info;
begin
	read(m,regM);                                                   //no hace reset porque el archivo esta ordenado, asi no recorre todo lo que ya escribio.
	while((not eof(m))and(regM.nroUsuario <> num))do begin
		writeln(t,' ',
				'Nro de Usuario ',regM.nroUsuario,' ',
				'Cantidad de mensajes Enviados ',regM.cantMails);
		read(m,regM);
	end;
	if(regM.nroUsuario = num)then begin
		regM.cantMails:= regM.cantMails + cant;
		writeln(t,' ',
			'Nro de Usuario ',regM.nroUsuario,' ',
			'Cantidad de mensajes Enviados ',regM.cantMails);
		seek(m,filepos(m)-1);
		write(m,regM);
	end
	else
		writeln('El usuario no esta en el server.');
end;

procedure actualizaServer(var ma:maestro;var d:detalle,var at:Text);
var
	regD:deta;
	mismo:integer;
	cantidad:integer;
begin
	reset(d);
	reset(ma);
	leer(d,regD);
	while(regD.nroUsuario <> valoralto)do begin
		mismo:=regD.nroUsuario;
		cantidad:=0;
		while(regD.nroUsuario = mismo)do begin
			cantidad:= cantidad+1;
			leer(d,regD);
		end;
		if(cantidad <> 0)then                                      //si el usuario mando 0 mails, entonces ni se gasta en ir al modulo para sumarle cero.
			escribirMaestro(ma,mismo,cantidad,at);
	end;
	close(d);
	close(ma);
end;

var	                          						//programa principal
	aM:maestro;
	aD:detalle;
	arT:Text;
begin
	assign(aM,'/var/log/logmail.dat');
	assign(aD,'CorreosDiarios');
	assign(arT,'listado');
	rewrite(arT);
	rewrite(aM);
	rewrite(aD);
	cargaServer(aM);
	cargaCorreos(aD);
	actualizaServer(aM,aD,arT);
end.
