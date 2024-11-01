program ej1parte2;
const
	valoralto = 9999;
type
	cadena = string[40];
	producto = record
		codigo:integer;
		nombre:cadena;
		precio:real;
		stActual:integer;
		stMinimo:integer;
	end;
	maestro = file of producto;
	
	ventas = record
		codigo:integer;
		cantidad:integer;
	end;
	detalle = file of ventas;
	vecDetalles = array[1..100]of detalle;
	vecRegis = array[1..100] of ventas;

procedure cargaMaestro(var maes:maestro);                       //Se dispone
procedure cargaDetalles(var vecDetas:vecDetalles);              //Se dispone

procedure actualizaMaestro(var archiM:maestro; ven:venta);
var
	regP:producto;
begin
	reset(archiM);
	read(archiM,regP);
	while(not eof(archiM))and(regP.codigo <> ven.codigo)do          //lee el archivo hasta encontrar el registro del producto vendido
		read(archiM,regP);
	regP.stActual:= regP.stActual - ven.cantidad;                   
	seek(archiM,filepos(archiM)-1);
	write(archiM,regP);                                              //actualiza el producto
	close(archiM);
end;

procedure minimo(var vecR:vecRegis;var min:ventas; var vd:vedDetalles);
var
    i:integer;
    pos:integer;
begin
	for i:= 1 to 100 do begin
		if(vecR[i].codigo < min)then begin
			min:= vecR[i];
			pos:= i;
	    end;
	end;
	if(min.codigo <> valoralto)then
		leer(vd[pos],vecR[pos]);
end;

procedure procesaVentas(var ar:maestro; vec:vecDetalles);
var
	vRegistros:vecRegis;
	minimo:ventas;
	produ:producto;
	i:integer;
begin
	for i:= 1 to 100 do begin
		assign(vec[i],'deta' + i);
		reset(vec[i]);
		leer(vec[i],vRegistros[i]);
	end;
	minimo(vRegistros,minimo,vec);
	while(minimo.codigo <> valoralto)do begin
		actualizaMaestro(ar,minimo);
		minimo(vRegistros,minimo,vec);
	end;
	for i:= 1 to 100 do 
		close(vec[i]);
end;

var                                            //programa principal
	arM:maestro;
	detalles:vecDetalles;
begin
	assign(arM,'ProductosNegocios');
	rewrite(arM);
	cargaMaestro(arM);                        //se dispone
	cargaDetalles(detalles);		          //se dispone
	procesaVentas(arM,detalles);
end.
