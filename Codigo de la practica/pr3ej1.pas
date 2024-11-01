program ejercicio4;
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

function unicidad(var ar:archivo; em:empleado):boolean;                      //Consultar si se puede recorrer el archivo en una funcion ya que se pasa si o si por referencia.
var
	control:boolean;
	empi:empleado;
begin
    control:=true;
    reset(ar);
    while(not eof(ar))do begin
       read(ar,empi);
       if(empi.numero = em.numero)then
          control:=false;
    end;
    close(ar);
    unicidad:=control;
end;

procedure agregaEmpleado(var archi:archivo);
var
  emple:empleado;
begin
  leeEmpleado(emple);
  while(emple.apellido <> 'fin')do begin
    if(unicidad(archi,emple))then begin
       reset(archi);
       seek(archi,filepos(archi)+1);
       write(archi,emple);
       writeln('Empleado agregado exitosamente.');
       close(archi);
    end
    else
       writeln('Empleado ya registrado.');
    writeln('-------------Ingreso de otro empleado--------------');
    leeEmpleado(emple);
  end;
end;

procedure modificaEdad(var unArchivo:archivo; unEmpleado:empleado);
var
	em:empleado;
	corte:boolean;
begin
    corte:=false;
    reset(unArchivo);
    while(not eof(unArchivo))and(corte = true)do begin
        read(unArchivo,em);
        if(em.numero = unEmpleado.numero)then begin
			em.edad:= unEmpleado.edad;
	        seek(unArchivo,filepos(unArchivo)-1);
	        write(unArchivo,em);
	        corte := false;
	    end;
    end;
    close(unArchivo);
    if(corte = false)then
        writeln('Edad del empleado actualizada correctamente.')
    else
        writeln('No se pudo actualizar la edad del empleado.');
end;

procedure exportarTodos(var tar:archivo);
var
    archivo_text : Text;
    remp: empleado;
begin
    assign(archivo_text,'todos_empleados.txt');
    reset(tar);
    rewrite(archivo_text);
    while(not eof(tar))do begin
		read(tar,remp);
        writeln(archivo_text,
           ' ',remp.numero,
           ' ',remp.apellido,
           ' ',remp.nombre,
           ' ',remp.edad,
           ' ',remp.dni);
    end;
    close(tar);
    close(archivo_text);
end;

procedure exportarSinDNI(var unAr:archivo);
var
   texte:Text;
   reg:empleado;
begin
   assign(texte,'faltaDNIempleado.txt');
   reset(unAr);
   rewrite(texte);
   while(not eof(unAr))do begin
       read(unAr,reg);
       if(reg.dni = 00)then 
          writeln(texte,
           ' ',reg.numero,
           ' ',reg.apellido,
           ' ',reg.nombre,
           ' ',reg.edad,
           ' ',reg.dni);
   end;
   close(texte);
   close(unAr);
end;

procedure realizaBaja(var ar:archivo; emple:empleado);
var 
	reg:empleado;
	posicion:integer;
begin
	read(ar,reg);
	while(reg.nombre <> emple.nombre)do begin             //avanzo hasta encontrar el registro a eliminar
		read(ar,reg);
	end;
	posicion:= filepos(ar)-1;                             //guarda la posicion en la que se elimino.
	
	seek(ar,filesize(ar)-1);                              //me posiciono en la ultima posicion del archivo.
	read(ar,emple);                                         //leo el registro de la ultima posicion.
	while(emple.nombre = '@')do begin                       //encuentro el registro que no esta marcado
		seek(ar,filepos(ar)-1);
		read(ar,emple);
	end;
	
	seek(ar,posicion);                                    //me posiciono en donde elimine el registro.
	write(ar,emple);                                        //escribo en de la ultima posicion en el lugar del que elimine.
	
	seek(ar,filesize(ar)-1);                                //me posiciono en la ultima posicion del archivo.
	write(ar,reg);                                          //escribo en la ultima posicion el registro que quiero eliminar.
	Truncate(ar);                                          //truncamiento del archivo.
end;

var 												//programa principal.
  ar_empleados:cadena;
  ar_logico:archivo;
  emp:empleado;
  opcion:integer;
begin
  writeln('Menu');
  writeln('1: crear archivo');
  writeln('2: procesamiento uno');
  writeln('3: procesamietno dos');
  writeln('4: procesamiento tres');
  writeln('5: agregar empleados al archivo');
  writeln('6: modificar edad de un empleado');
  writeln('7: exportar todos los empleados');
  writeln('8: exportar los empleados sin dni');
  Writeln('9: realizar baja');
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
     5: agregaEmpleado(ar_logico);                                    //4 A
     6: begin
        writeln('Ingrese un empleado para modificar su edad.');
        leeEmpleado(emp);
        modificaEdad(ar_logico,emp);                                  //4 B
        end;
     7: exportarTodos(ar_logico);                                     //4 C
     8: exportarSinDNI(ar_logico);                                    //4 D
     9: leeEmpleado(emp);
		realizaBaja(ar_logico,emp);                                   //CORREGIR.
   end;
end.

