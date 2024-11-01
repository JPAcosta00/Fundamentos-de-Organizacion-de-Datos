program ej16;
const
	valoralto=9999;
type
	cadena = string[35];
	moto=record
		codigo:integer;
		nombre:cadena;
		descripcion:cadena;
		modelo:cadena;
		marca:cadena;
		stock:integer;
	end;
	maestro = file of moto;
	infoDetalle=record
		codigo:integer;
		precio:real;
		fecha:integer;
	end;
	detalle= file of infoDetalle;
	detalles = array[1..10] of detalle;
	registros = array[1..10] of infoDetalle;

procedure cargaMaestro(var maest:maestro);												//se dispone

procedure leer(var d:detalle; var r:infoDetalle);
begin
	if(not eof(d))then 
		read(d,r)
	else
		r.codigo:= valoralto;
end;

procedure calculaMinimo(v:registros; var min:infoDetalle; var dets:detalles);
var
	i:integer;
	posicion:integer;
begin
	min.codigo:= 9999;
	for i:= 1 to 10 do begin
		if(v[i].codigo < min.codigo)then begin
			min:= v[i];
			posicion:=i;
		end;
	end;
	if(min.codigo <> valoralto)then
		leer(dets[posicion],v[posicion]);
end;

procedure actualizaMaster(var m:maestro; codigo:integer; cantidad:integer);
var	
	regM:moto;
begin
	read(m,regM);
	while((not eof(m))and(regM.codigo <> codigo))do
		read(m,regM);
	regM.stock := regM.stock - cantidad;
	seek(m,filepos(m)-1);
	write(m,regM);
end;

procedure actualizaStocks(var maes:maestro; var det:detalles);
var
	minimo:infoDetalle;
	i:integer;
	reg:registros;
	mismoCodigo:integer;
	cantVendidas:integer;
begin
	for i:= 1 to 10 do begin
		assign(det[i], detalle + i);
		reset(det[i]);
		leer(det[i],reg[i]);
	end;
	reset(maes);
	calculaMinimo(reg,minimo,det);
	while(minimo.codigo <> valoralto)do begin
		mismoCodigo:= minimo.codigo;
		cantVendidas:=0;
		while(minimo.codigo = mismoCodigo)do begin
			cantVendidas:=+1;
			calculaMinimo(reg,minimo,det);
		end;	
		actualizaMaster(maes,mismoCodigo,cantVendidas);
	end;
	close(maes);
	for i:= 1 to 10 do 
		close(det[i]);
end;

procedure motoMasVendida(var a:maestro;var moto:moto);
var
	min:integer;
	rm:moto;
begin
	reset(a);
	min:=9999;
	read(a,rm);
	while(not eof(a))do begin
		if(rm.stock < min)then begin
			moto := rm;
			min:= rm.stock;
		end;
		read(a,rm);
	end;
	close(a);
end;

procedure informaMoto(m:moto);
begin
	writeln('La moto mas vendida fue: ');
	writeln('Codigo: ',m.codigo);
	writeln('Nombre: ',m.nombre);
	writeln('Descripcion: ',m.descripcion);
	writeln('Modelo: ',m.modelo);
	writeln('Marca: ',m.marca);
	writeln('Stock: ',m.stock);
end;

var																								//programa principal
	arM:maestro;
	detas:detalles;
	masVendida:moto;
begin
	assign(arM,'Consecionaria');
	rewrite(arM);
	cargaMaestro(arM); 																		//se dispone al igual que la carga de los detalles
	actualizaStocks(arM,detas);
	motoMasVendida(arM,masVendida);
	informaMoto(masVendida);
end.
