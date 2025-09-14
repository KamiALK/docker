

create table TB_almacen
(
  codigo_al number(5,0), generated always as identity,
  descripcion_ar varchar(30),
  marca_ar varchar(20),
  codig0_me number(3,0),
  codigo_ca number(3,0),
  fecha_ing date,
  stock_actual decimal(10,2)
);

