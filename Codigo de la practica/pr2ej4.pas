program ej4;
const 
	valoralto = 'ZZZ';
type 
	cadena = string[35];
	dato=record
		nombre:cadena;
		cantidad:integer;
		total:integer;
	end;
	maestro = file of dato;
	info=record
		nombre:cadena;
		codigo:integer;
		cantAL:integer;
		cantEN:integer;
	end;
	detalle = file of info;

procedure cargaMaestro(var maestr:maestro);                      
procedure cargaDetalles(var detall1,detall2:detalle);

var												//programa principal
	mae1:maestro;
	det1:detalle;
	det2:detalle;

procedure leer(var ar:detalle;var reg:info);
begin
	if(not eof(ar))then 
		read(ar,reg)
    else 
		reg.nombre:= valoralto;
end;

procedure minimo(var d1,d2:detalle;var mini:info);
begin
	if(d1.nombre < d2.nombre)then begin
		mini := d1;
	    leer(det1,d1);
	end;
	else 
	   mini := d2;
	   leer(det2,d2);
end;

procedure escribeMaestro(var m:maestro; cantA,cantE:integer; nom:cadena);
var 
   regM:dato;
begin
   read(m,regM);
   while(regM.nombre <> nom)do 
		read(m,regM);
   regM.cantidad:= regM.cantidad + cantA;
   regM:total:= regM.total + cantE;
   seek(m,filepos(m)-1);
   write(m,regM);
end;

procedure actualizaMaestro(var ma:maestro;var de1,de2:detalle);
var
   regd1:info;
   regd2:info;
   min:info;
   mismo:cadena;
   cantidadAl:integer;
   cantidadEn:integer;
begin
   leer(de1,regd1);
   leer(de2,regd2);
   minimo(regd1,regd2,min);
   while(min.nombre <> valoralto)do begin
		mismo:=min.nombre;
		cantidadAl:=0;
		cantidadEn:=0;
		while(mismo = min.nombre)do begin
			cantidadAl:= cantidadAl + min.cantAL;
			cantidadEn:= cantidadEn + min.cantEN;
			minimo(reg1,reg2,min);
		end;
		escribeMaestro(ma,cantidadAl,cantidadEn,minimo.nombre);   
   end;
end;

begin
	assign(mae1,'Maestro');
	assign(det1,'Detalle 1');
	assign(det2,'Detalle 2');
	cargaMaestro(mae1);							//se dispone
	cargaDetalles(det1,det2);					//se dispone
	actualizaMaestro(mae1,det1,det2);
end.
