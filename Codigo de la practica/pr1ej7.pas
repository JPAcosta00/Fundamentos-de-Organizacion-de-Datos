program ej7;
type
   cadena = string[55];
   
   novela = record
     codigo:integer;
     nombre:cadena;
     genero:cadena;
     precio:real;
   end;
   
   archivo = file of novela;
   
procedure cargaNovelas(var a:archivo; var tex:Text);
var
  nov:novela;
begin
  reset(tex);
  rewrite(a);
  while(not eof(tex))do begin
     readln(tex,nov.codigo,nov.precio,nov.genero);
     readln(tex,nov.nombre);
     write(a,nov);
  end;
  writeln('Archivo binario cargado correctamente.');
  close(a);
  close(tex);
end;

procedure agregaNovela(var ar:archivo; reg:novela);
begin
   reset(ar);
   seek(ar,filesize(ar)+1);
   write(ar,reg);
   writeln('Novela agregada exitosamente.');
   close(ar);
end;

procedure modificarNovela(var nar:archivo; re:novela);
var
  n:novela;
  control:boolean;
begin
  control:=true;
  reset(nar);
  while((not eof(nar))and(control = true))do begin
	read(nar,n);
	if(n.codigo = re.codigo)then  begin
		seek(nar,filepos(nar)-1);
		write(nar,re);
		control:=false;
    end;
  end;
  writeln('Novela modificada exitosamente.');
  close(nar);
end;

procedure abrirBinario(var arch:archivo);
var
  nove:novela;
  opcion:integer;
begin
  writeln('Actualizacion del archivo binario:');
  writeln('		1: agregar una novela al archivo.');
  writeln('		2: modificar una novela existente.');
  writeln('		3: terminar la actualizacion.');
  
  writeln('Enviar respuesta...');
  readln(opcion);
  case opcion of
     1: begin
        leeNovela(nove);
        agregaNovela(arch,nove);
        end;
     2: begin
        leeNovela(nove);
        modificaNovela(arch,nove);
        end;
     3: writeln('Actualizacion terminada.');
  end;
end;

var                                                       //programa principal.
   archivotext:Text;
   ar:archivo;
   nombreBinario:cadena;
begin
   assign(archivotext,'novelas.txt');
   writeln('Ingrese el nombre del archivo binario:');
   readln(nombreBinario);
   assign(ar,nombreBinario);
   cargaNovelas(ar,archivotext);                                 //7 A
   abrirBinario(ar);                                      //7 B
end.
