program ej6;
const 
	valoralto = 9999;
type 
	registroDetalle=record
		codigo:integer;
		fecha:integer;
		sesion:real;
	end;
	ardetalle = file of registroDetalle;
	detalles = array[1..5] of ardetalle;
	regDet = array[1..5] of registroDetalle;
	
	registroMaestro=record
		codigo:integer;
		fecha:integer;
		tiempo:real;
	end;
	maestro = file of registroMaestro;

procedure cargaDetalles(var deta:detalles);								//se dispone

procedure leer (var ad : detalles; var rd:regDet);
begin
	if(not eof(ad))then 
		read(ad,rd)
	else
		rd.codigo:= valoralto;
end;

procedure minimo(var reDeta:regDet; var minimo:registroDetalle; var arDetas:detalles);
var
	i:integer;
	indice:integer;
begin
    minimo.codigo:=valoralto;
	for i:= 1 to 5 do begin                                             
		if(reDeta[i].codigo < minimo.codigo) or ((reDeta[i].codigo = minimo.codigo)and(reDeta[i].fecha < minimo.fecha))then begin
			minimo:= reDeta[i];
			indice:=i;
		end;
	end;
	if(minimo.codigo <> valoralto)then
	    leer(arDetas[indice],reDeta[indice]);
end;
	

procedure procesaSesiones(var vd:detalles; var maes:maestro);
var
	regD : regDet;
	min : registroDetalle;
	i:integer;
	aux:registroMaestro;
begin
    for i:= 1 to 5 do begin
		assign(vd[i], vd+1);
		reset(vd[i]);
		leer(vd[i],regD[i]);
    end;
	minimo(regD,min,vd);                                                 
	while(min.codigo <> valoralto)do begin 
		aux.codigo:= min.codigo;
		while(min.codigo = aux.codigo)do begin                                
			aux.fecha := min.fecha;
			aux.tiempo:=0;
			while(aux.codigo = min.codigo)and(aux.fecha = min.fecha)do begin
				aux.tiempo:= aux.tiempo + minimo.sesion;
				minimo(regD,min,vd);
			end;
			write(m,aux);
		end;
	end;
	close(m);
	for i:= 1 to 5 do 
		close(vd[i]);
end;
  
var																//programa principal.
	vecD : detalles;
	arMaestro : maestro;
begin
	cargaDetalles(vecD);
	assign(maestro,'/var/log');
	rewrite(maestro);
	procesaSesiones(vecD,maestro);
end.
