program ejercicio1;
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
    writeln('Se guardo: ', num);
    readln(num);
  end;
  writeln('se cerro el archivo.');
  close(arc);
end;
var
  arch_logico:archivo;
  arch_fisico:cadena;
begin
  writeln('Ingresa el nombre del archivo: ');
  readln(arch_fisico);
  assign(arch_logico,arch_fisico);
  rewrite(arch_logico);
  cargaEnteros(arch_logico);
end.
