program ej5;
const 
  valoralto = 9999;
type
  cadena = string[30];
  producto=record
	codigo:integer;
	nombre:cadena;
	descripcion:cadena;
	stDisponible:integer;
	stMinimo:integer;
	precio:real;
  end;
  maestro = file of producto;
  info=record
     codigo:integer;
     cantidad:integer;
  end;
  ar_det = file of info;
  detalles = array[1..30] of ar_det;
  reg_det = array[1..30]of info;

procedure cargaMaestro(var archiM:maestro);             					   //se dispone
procedure cargaDetalles(var archiD:detalles);

procedure leer(var archivo:ar_det; var dato:info);
begin
	if(not eof(archivo))then 
		read(archivo,dato);
    else
        dato.codigo:= valoralto;
end;

procedure minimo(var reg_d:reg_det; var min:info; var deta:detalles);
var
   i:intger;
   indice:integer;
begin
	for i=1 to 30 do begin
		if(reg_d[i].codigo < min.codigo)then begin
			min:= reg_d[i];
			indice := i;
	    end;
	end;
	leer(deta[indice];reg_d[indice]);
end;

procedure actualizaMaestro(var ma:maestro; cod:integer; cant:integer);           //no se hace reset ni close ya que esta ordenado y lo uso en la posicion que quedo.
var
	regM:producto;
begin
    read(ma,regM);
	while(regM.codigo <> cod)do
		read(ma,regM);
	seek(ma,filepos(ma)-1);
	regM.stDisponible:= regM.stDisponible - cant;
	write(ma,regM);
end;

procedure procesaInformacion(var d:detalles; var m:maestro);             
var
	min:info;
	arD:reg_det;
	i:integer;
	mismoCodigo:integer;
	contador:integer;
begin
   for i:= 1 to 30 do begin                     							  //assign de todos los detalles.
		assign(d[i], 'd' +1);
		reset(d[i]);
		leer(d[i],arD[i]);
   end;
   reset(m);                                     
   minimo(arD,min,d);
   while(min.codigo <> valoralto)do begin
		mismoCodigo:= min.codigo;
		contador:=0;
		while(min.codigo = mismoCodigo)do begin
			contador:= contador + min.cantidad;								//acumula la cantidad ya que en cada detalle puede venir 0 o N registros de un determinado producto.
			minimo(arD,min,d);
		end;
		actualizaMaestro(m,min.codigo,contador);
   end;
   close(m);
end;

procedure cargaTexto(var maes:maestro; var ar: Text);
var
    regM: producto;
begin
	reset(maes);
	while(not eof(maes))do begin
		read(maes,regM);
		if(regM.stDisponible < regM.stMinimo)then
			writeln(ar, ' ',
				'NOMBRE: ',regM.nombre, ' ',
				'DESCRIPCION: ',regM.descripcion, ' ',
				'STOCK DISPONIBLE: ',regM.stDisponible, ' ',
				'STOCK MINIMO: ',regM.stMinimo, ' ',
				'PRECIO: ',regM.precio);
	end;
	close(maes);
	close(ar);
end;

var																			//programa principal.
	mae:maestro;
	deta:detalles;
	arT: Text;
begin
    assign(arT,'Informe productos');
    rewrite(arT);
    assign(mae,'Maestro');
	assign(deta,'Detalles productos');
	cargaMaestro(mae);
	cargaDetalles(deta);
    procesaInformacion(deta,mae);
    cargaTexto(mae,arT);
end.


