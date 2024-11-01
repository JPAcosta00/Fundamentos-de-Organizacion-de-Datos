program ejercicio3;
type
	cadena = string[45];
	
    empleado = record
      numero:integer;
      apellido:cadena;
      nombre:cadena;
      edad:integer;
      dni:integer;
    end;
    
    archivo = file of empleado;

procedure leeEmpleado(var e:empleado);
begin
   writeln('Ingrese el apellido del empleado');
   readln(e.apellido);
   if(e.apellido <> 'fin')then begin
      writeln('Ingrese el nombre');
      readln(e.nombre);
      writeln('Ingrese la edad');
      readln(e.edad);
      writeln('Ingrese el dni');
      readln(e.dni);
      writeln('Ingrese el numero');
      readln(e.numero);
      writeln('------------------');
   end;
end;

procedure cargaEmpleados(var arc:archivo);
var 
  emp:empleado;
begin
  reset(arc);
  leeEmpleado(emp);
  while(emp.apellido <> 'fin')do begin
		write(arc,emp);
        leeEmpleado(emp);
  end;
  close(arc);
end;

procedure imprimeInformacion(info:empleado);
begin
  writeln(info.numero);
  writeln(info.nombre);
  writeln(info.apellido);
  writeln(info.edad);
  writeln(info.dni);
  writeln('-------------------');
end;

procedure procesamientoUNO(var a:archivo);
var
  apellido:cadena;
  nombre:cadena;
  emplea:empleado;
begin
  writeln('Ingrese un nombre');
  readln(nombre);
  writeln('Ingrese un apellido');
  readln(apellido);
  reset(a);
  writeln('-------------- B I ------------------');
  while(not eof(a))do begin
	 read(a,emplea);
     if(emplea.nombre = nombre)then 
       imprimeInformacion(emplea);
     if(emplea.apellido = apellido)then
       imprimeInformacion(emplea);
  end;
  close(a);
end;

procedure procesamientoDOS(var al:archivo);
var
  infoE:empleado;
begin
  reset(al);
  writeln('------------- B II ----------------');
  while(not eof(al))do begin
	  read(al,infoE);
      writeln('Numero: ',infoE.numero,'/ Nombre: ',infoE.nombre,'/ Apellido: ',infoE.apellido,'/ Edad: ',infoE.edad,'/ Dni: ',infoE.dni);
  end;
  close(al);
end;

procedure procesamientoTRES(var ah:archivo);
var
  emplead:empleado;
begin
  reset(ah);
  while(not eof(ah))do begin
     read(ah,emplead);
     if(emplead.edad > 70)then
        imprimeInformacion(emplead);
  end;
  close(ah);
end;

var 												//programa principal.
  ar_empleados:string;
  ar_logico:archivo;
  opcion:integer;
begin
  writeln('Menu');
  writeln('1: crear archivo');
  writeln('2: procesamiento uno');
  writeln('3: procesamietno dos');
  writeln('4: procesamiento tres');
  writeln('Ingrese la opcion del menu: ');
  readln(opcion);
  case opcion of
     1: begin
          writeln('Ingrese el nombre del archivo');
          readln(ar_empleados);
          assign(ar_logico,ar_empleados);
          rewrite(ar_logico);
          cargaEmpleados(ar_logico);
        end;
     2: procesamientoUNO(ar_logico);
     3: procesamientoDOS(ar_logico);
     4: procesamientoTRES(ar_logico);        
  end;      
end.
