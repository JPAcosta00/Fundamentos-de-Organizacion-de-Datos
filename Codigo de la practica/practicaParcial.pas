program ejercicio;
const
	valoralto = 9999;
type
	cadena = string[50];
	cadena2 = string[7];
	formato=record
		codigo:integer;
		nombre:cadena;
		fecha:integer;
		cantVendida:integer;
		formaPago:cadena2;
	end;
	ventas = file of formato;
	vecVentas = array[1..30] of ventas;
    vecDato = array[1..30] of formato;
    
procedure cargaVentas(var vec:vecVentas);					//se dispone

procedure leer(var ar:ventas; var reg:formato);
begin
	if(not eof(ar))then
		read(ar,reg)
	else
		reg.codigo:= valoralto;
end;

procedure minimo(var vecD:vecDato; var min:formato; var vecV:vecVentas);
var 
	i:integer;
	pos:integer;
begin
	for i:= 1 to 30 do begin
		if(vecD[i] < min.codigo)and(vecD[i] < min.fecha)then begin
			min:= vecD[i];
			pos:=i;
		end;
	end;	
	if(min.codigo <> valoralto)then
		leer(vecV[pos],vecD[pos]);
end;

procedure calculaMayorFarmaco(cantidad:integer; var maxi:integer; var farma:integer, cod:integer);
begin
	if(cantidad > maxi)then begin
		farma:= cod;
		maxi:=cantidad;
	end;
end;

procedure moduloA(ve:vecVentas; var codMas:integer);
var
	minimo:formato;
	i:integer;
	datos:vecDato;
	mismoCodigo:integer;
	mismaFecha:integer;
	max:integer;
	contador:integer;
begin
	max:=-1;
	for i:= 1 to 30 do begin
		assign(ve[i], 'Venta ' + i);
		reset(ve[i]);
		leer(ve[i],dato[i]);
	end;
	minimo(dato,minimo,ve);
	while(minimo.codigo <> valoralto)do begin
		mismoCodigo:= minimo.codigo;
		contador:=0;
		while(minimo.codigo = mismoCodigo)do begin
			mismaFecha:= minimo.fecha;
			while(minimo.codigo = mismoCodigo)and(minimo.fecha = mismaFecha)do begin
				contador := contador + minimo.cantVendida;
				minimo(dato,minimo,ve);
			end;	
		end;
		calculaMayorFarmaco(contador,max,codMas,minimo.codigo);
	end;
	for i:= 1 to 30 do 
		close(ve[i]);
end;

procedure moduloB(vecto:vecVentas; var ar:Text);
var 

begin
	//recorre los archivos y los escribe por farmaco en el archivo de texto en una sola linea.
end;

var                                             //programa principal
	vector:vecVentas;
	codMayorFarmaco:integer;
	arTexto:Text;
begin
	asssign(arTexto,'Resumen de Ventas.txt');
	rewrite(arTexto);
	cargaVentas(vector);								//Se dispone
	moduloA(vector,codMayorFarmaco);
	writeln('INCISO A: ',codMayorFarmaco);
	moduloB(vector, arTexto);
end.
