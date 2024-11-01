program ej6;
type
   cadena = string[50];
   celulares = record
     codigo:integer;
     nombre:cadena;
     descripcion:cadena;
     marca:cadena;
     precio:real;
     stMinimo:integer;
     stDisponible:integer;
   end;
   
   archivo = file of celulares;

procedure cargaBinario(var bin:archivo;var dete:Text);
var 
  celu:celulares;
begin
  assign(dete,'Celulares.txt');
  rewrite(bin);
  reset(dete);
  while(not eof(dete))do begin
      Readln(dete,celu.codigo,celu.precio,celu.marca);
      Readln(dete,celu.stDisponible,celu.stMinimo,celu.descripcion);
      Readln(dete, celu.nombre);
      Write(bin,celu);
  end;
  writeln('Archivo binario cargado exitosamente.');
  close(bin);
  close(dete);
end;

procedure imprimeInfo(c:celulares);
begin
  Writeln('Codigo: ',c.codigo);
  writeln('Nombre: ',c.nombre);
  writeln('Descripcion: ',c.descripcion);
  writeln('Marca: ',c.marca);
  Writeln('Precio: ',c.precio);
  writeln('Stock minimo: ',c.stMinimo);
  writeln('Stock disponible: ',c.stDisponible);
  writeln(' ');
  writeln('------------------------------------------');
end;

procedure muestraMenor(var bin:archivo);
var 
  ce:celulares;
begin
  reset(bin);
  while(not eof(bin))do begin
     read(bin,ce);
     if(ce.stDisponible > ce.stMinimo)then
		 imprimeInfo(ce);
  end;
  close(bin);
end;

procedure muestraDescripcion(var ab:archivo;cade:cadena);
var
   cel:celulares;
begin
   reset(ab);
   while(not eof(ab))do begin
      read(ab,cel);
      if(cel.descripcion = cade)then
         imprimeInfo(cel);
   end;
   close(ab);
end;

procedure cargaTxt(var bina:archivo; var archivot:Text);
var
   celular:celulares;
begin
   rewrite(archivot);
   reset(bina);
   while(not eof(bina))do begin
       read(bina,celular);
       writeln(archivot,
          ' ', celular.codigo,
          ' ', celular.precio,
          ' ', celular.marca);
       writeln(archivot,
          ' ', celular.stDisponible,
          ' ', celular.stMinimo,
          ' ', celular.descripcion);
       writeln(archivot,
          ' ', celular.nombre);
   end;
   writeln('Archivo txt cargado exitosamente.');
   close(bina);
   close(archivot);
end;

procedure leeCelulares(var c:celulares);
begin
  readln(c.codigo);
  if(c.codigo <> 0)then begin
     readln(c.nombre);
     readln(c.descripcion);
     readln(c.marca);
     readln(c.precio);
     readln(c.stMinimo);
     readln(c.stDisponible);
  end;
end;

procedure agregaCelulares(var ab:archivo;nom:cadena);
var
  celu:celulares;
begin
  assign(ab,nom);
  reset(ab);
  leeCelulares(celu);
  while(celu.codigo <> 0)do begin
     seek(ab,filesize(ab)+1);
     write(ab,celu);
     leeCelulares(celu);
  end;
  close(ab);
end;

procedure modificarStock(var ar:archivo; nombre:cadena);
var
  cel:celulares;
begin
  reset(ar);
  while(not eof(ar))do begin
     read(ar,cel);
     if(cel.nombre = nombre)then begin
		cel.stMinimo:= cel.stMinimo-1;
		seek(ar,filepos(ar)-1);
		write(ar,cel);
     end; 
  end;
  close(ar);
end;

procedure exportarSinStock(var bina:archivo;var st:Text);
var 
  cel:celulares;
begin
   reset(bina);
   rewrite(st);
   while(not eof(bina))do begin
      read(bina,cel);
      if(cel.stDisponible = 0)then 
         writeln(st,cel.codigo, ' ',cel.nombre,' ',cel.descripcion,' ',cel.marca,' ',cel.precio,' ',cel.stMinimo,' ',cel.stDisponible);
   end;
   writeln('Archivo txt sin stock cargado exitosamente.');
   close(bina);
   close(st);
end;

var                                                     //programa principal.
   nombreBinario:cadena;
   binario:archivo;
   deTexto:Text;
   stock:Text;
   opcion:integer;
   desc:cadena;
   name:cadena;
begin
   writeln('Menu de tienda de celulares');
   writeln('1: Carga archivo binario con celulares.txt');
   writeln('2: Muesta en pantalla con stock menor al minimo');
   writeln('3: Muestra celulares con cierta descripcion');
   writeln('4: Exportar el archivo binario a txt');
   writeln('5: Añadir uno o mas celulares');
   writeln('6: modificar stock');
   writeln('7: exportar a txt con los celulares sin stock');
   writeln('8: terminar de ver el menu');
   
   writeln('Ingrese la opcion del menu: ');
   readln(opcion);
   case opcion of
     1: begin
        readln(nombreBinario);
        assign(binario,nombreBinario);
        cargaBinario(binario,deTexto);                                //5 A 
        end;
     2: muestraMenor(binario);                                        //5 B
     3: begin
        writeln('Ingrese la descripcion de un celular');              //5 C
        readln(desc);
        muestraDescripcion(binario,desc);
        end;
     4: begin
        assign(deTexto,'Celulares.txt');                              //5 D
        cargaTxt(binario,deTexto);
		end;
     5: agregaCelulares(binario,nombreBinario);                       //6 A
     6: begin
        writeln('Ingrese el nombre del celular a modificar stock');
        readln(name);
        modificarStock(binario,name);                                 //6 B
		end;
     7: begin
        assign(stock,'SinStock.txt'); 
        exportarSinStock(binario,stock);                              //6 C
		end;
     8: writeln('Menu cerrado.');
   end;
end.

