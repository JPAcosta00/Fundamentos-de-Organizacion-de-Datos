program ej6;
const
	valoralto = 9999;
type 
	prenda = record
		cod_prenda:integer;
		descripcion:string;
		colores:string;
		tipo_prenda:string;
		stock:integer;
		precio:real;
	end;
	maestro = file of prenda;
	obsoletas = file of integer;     //codigos de prendas

procedure cargaMaestro(var arm:maestro);                  //se dispone
procedure cargaObsoletos(var arO:obsoletos);              //se dispone

procedure leer(var a:obsoletas; var regis:integer);
begin
	if(not eof(a))then
		read(a,regis)
	else
		regis = valoralto;
end;

procedure elimina(var am:maestro; codPrenda:integer);
var 
	pr:prenda;
begin
	reset(am);
	read(am,pr);
	while(not eof(am))and(pr.cod_prenda <> codPrenda)do 
		read(am,pr);
	pr.stock:= pr.stock * -1;
	seek(am,filepos(am)-1);
	write(am,pr);
	close(am);
end;

procedure daBajas(var arM:maestro; var arDelete:obsoletas);
var
	regO:integer;
begin
	reset(arDelete);
	leer(arDelete,regO);
	while(regO <> valoralto)do begin
		elimina(arM,regO);
		leer(arDelete,regO);
	end;
	close(arDelete);
end;

procedure cargaPrendasNoEliminadas(var mViejo:maestro; var mNuevo:maestro);

	procedure leerPrenda(var a:maestro;var regis:prenda);
	begin
		if(not eof(a))then
			read(a,regis)
		else
			regis.cod_prenda = valoralto;
	end;
	
var
	regPrenda:prenda:
begin
	reset(mViejo);
	reset(mNuevo);
	leerPrenda(mViejo,regPrenda);
	while(regPrenda.cod_prenda <> valoralto)do begin
		if(regPrenda.stock > 0)then                                 //si el elemento no esta borrado(stock es un numero positivo)
		    write(mNuevo,regPrenda);                                //escribe los datos no borrados en el archivo nuevo.
		leerPrenda(mViejo,regPrenda);
	end;
	close(mViejo);
	close(mNuevo);
end;

var                                                      //programa principal
	arMaestro:maestro;
	arBorrado:obsoletas;
	arNuevo:maestro;
begin
	assign(arMaestro,'TiendaIndumentaria');
	cargaMaestro(arMaestro);
	assign(arBorrado,'PrendasObsoletas');
	cargaObsoletos(arBorrado);
	daBajas(arMaestro,arBorrado);
	assign(arNuevo,'ArchivoNuevo');
	rewrite(arNuevo);
	cargaPrendasNoEliminadas(arMaestro,arNuevo);
	rename(arNuevo,'TiendaIndumentaria');                         //renombra el archivo nuevo como el maestro original
end.
