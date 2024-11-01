program ejercicio3p2;
const
	valoralto = 99999;
type
	informacion=record
		codigo:integer;
		mesa:integer;
		cantVotos:integer;
	end;
	archivo = file of informacion;
	auxiliar = file of integer;                                              //guarda los codigos de las localidades que ya procese.

procedure cargaArchivo(var ar:archivo); 											//Se dispone

function YaLoProcese(var ax:auxiliar; cod:integer):boolean;
var
	int:integer;
begin
	read(ax,int);
	while(not eof(ax))and(int <> cod)do	
		read(ax,int);
	if(int = cod)then
		YaLoProcese := true
	else
		YaLoProcese := false;
end;

procedure leer(var ar:archivo;var reg:informacion);
begin
	if(nor eof(ar))then
		read(reg)
	else
		reg.codigo = valoralto;
end;

procedure presentacion(var a:archivo; var auxi:auxiliar);
var
	regM:informacion;
	act:integer;
	cant:integer;
	total:integer;
	control:boolean;
begin
	total:=0;
	reset(a);
	reset(auxi);
	leer(a,regM);
	writeln('Codigo localidad                               Total votos');
	control := true;
	while(control)do begin
		if(YaLoProcese(auxi,regM.codigo) = false)then begin                          //si no procese ese codigo
		    act:= regM.codigo;                                                       //guardo el codigo
			write(auxi,act);                                                         //lo escribo en el archivo que controla
			cant:=0;
			while(regM.codigo <> valoralto)do begin									//lee todo el archivo
				if(regM.codigo = act)then begin                                     //evalua solo si es el codigo act
					cant:= cant + regM.cantVotos;
					leer(a,regM);
				end;
			end;
			seek(a,0);                                                          //posiciona en la pos cero para seguir procesando el resto que no proceso
			total:= total + cant;
			writeln(act,'                           ',cant);
		end;
		leer(a,regM);
		if(regM.codigo = valoralto)then
			control := false;
	end;
	writeln('Total General de votos ',total);
	close(a);
end;

var																					//programa principal.
	archi:archivo;
	aux:auxiliar;
begin
	assign(archi,'Mesas Electorales');
	assign(aux,'Archivo auxiliar');
	rewrite(arhci);
	rewrite(aux);
	cargaArchivo(archi);
	presentacion(archi,aux);
end.
