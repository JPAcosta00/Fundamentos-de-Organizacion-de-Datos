program ej10;
const 
	valoralto = 9999;
type
	subCategoria = 1..15;
	empleado=record
		departamento:integer;
		division:integer;
		numero:integer;
		categoria:subCategoria;
		cantHoras:integer;
	end;
	archivo = file of empleado;
	valores = array[subCategoria]of real;

procedure cargaEmpleados(var archi:archivo);

procedure cargaVectorValores(var ve:valores; var ar:Text);
var
	numCat:subCategoria;
	valor:real;
begin
	reset(ar);
	while(not eof(ar))do begin
		readln(ar,numCat,' ',valor);
		ve[numCat]:= valor;
	end;
	close(ar);
end;

procedure leer(var a:archivo;var re:empleado);
begin
	if(not eof(a))then
		read(a,re)
	else
		re.departamento := valoralto;
end,

procedure informaListado(var a:archivo; v:valores);
var
	em:empleado;
	mismaD:integer;
	mismoEm:integer;
	cantHS:integer;
	cobro:real;
	totalHS:integer;
	totalM:real;
	deptoHS:integer;
	deptoMonto:real;
begin
	reset(a);
	leer(a,em);
	while(em.departamento <> valoralto)do begin												//corrregir cortes de control
		writeln('Departamento: ', em.departamento);
        deptoHS:=0;
        deptoMonto:=0;
		while(mismoDepto = em.departamento)do begin
			writeln('Division: ', em.division);
			writeln('Numero Empleado     Total de HS     Importe a cobrar');
			mismaD:= em.division;
			totalHS:=0;
			totalM:=0;
			while((mismoDepto = em.departamento)and(em.division = mismaD))do begin
				mismoEm:= em.numero;
				cantHS:=0;
				while((mismoDepto = em.departamento)and(em.division = mismaD)and(mismoEm = em.numero))do begin
					cantHS:= cantHS + em.cantHoras;
					leer(a,em);
				end;
				cobro:= v[em.categoria] * cantHS;
				writeln(em.numero,'     ',cantHS,'     ',cobro);
				totalHS:= totalHS + cantHS;
				totalM:= totalM + cobro;
			end;
			writeln('Total de horas division: ',totalHS);
			writeln('Monto total por division: ',totalM);
			deptoHS:= deptoHS + totalHS;
			deptoMonto:= deptoMonto + totalM;
		end;
		writeln('Total horas departamento: ' ,deptoHS);
		writeln('Total monto departamento: ' ,deptoMonto);
	end;
	close(a);
end;

var													//programa principal
	ar_empleados:archivo;
	ar_valores:Text;
	vec:valores;
begin
	assign(ar_empleados,'empleados');
	assign(ar_valores, 'HorasExtras.txt');
	rewrite(ar_empleados);
	rewrite(ar_valores);
	cargaEmpleados(ar_empleados);
	cargaVectorValores(vec,ar_valores);
	informaListado(ar_empleados,vec);
end.
