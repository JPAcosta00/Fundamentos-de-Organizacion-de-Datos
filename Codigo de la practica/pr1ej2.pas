program ejercicio2;
type
   cadena= string[50];
   archivo = file of integer;

procedure cargaEnteros(var arc:archivo);
var
  num:integer;
begin
  reset(arc);
  writeln('Ingrese un numero');
  readln(num);
  while(num <> 30000)do begin
    write(arc,num);
    writeln('Ingrese un numero');
    readln(num);
  end;
  close(arc);
end;
procedure analizaArchivo(var ar:archivo);
var
  cant:integer;
  promedio:real;
  numero:integer;
begin
  cant:=0;
  promedio:=0;
  reset(ar);
  while (not eof(ar))do begin
     read(ar,numero);
     if(numero > 1500)then
         cant:= cant+1;
     writeln(filepos(ar), ' = ',numero);
  end;
  promedio := cant / filesize(ar);
  close(ar);
  writeln('Cantidad de numero mayores a 1500: ',cant);
  writeln('Promedio de esa cantidad con respecto al archivo:',promedio);
end;
var                                                 //programa principal.
  arch_logico:archivo;
  arch_fisico:cadena;
begin
  writeln('Ingresa el nombre del archivo: ');
  readln(arch_fisico);
  assign(arch_logico,arch_fisico);
  rewrite(arch_logico);
  cargaEnteros(arch_logico);
  writeln('--------------------------------------');
  writeln('Ingrese el nombre del archivo a analizar');
  readln(arch_fisico);
  assign(arch_logico,arch_fisico);
  analizaArchivo(arch_logico);
end.
