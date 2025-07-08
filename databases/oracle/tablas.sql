
/*
CREATE TABLE TB_CATEGORIA(
  CODIGO_CA INT,
  DESCRIPTICION VARCHAR(30)
);
*/

/* 
 ▗▄▄▖▗▄▄▖ ▗▄▄▄▖ ▗▄▖▗▄▄▄▖▗▄▄▄▖    ▗▄▄▄▖▗▄▖ ▗▄▄▖ ▗▖   ▗▄▄▄▖ ▗▄▄▖
▐▌   ▐▌ ▐▌▐▌   ▐▌ ▐▌ █  ▐▌         █ ▐▌ ▐▌▐▌ ▐▌▐▌   ▐▌   ▐▌   
▐▌   ▐▛▀▚▖▐▛▀▀▘▐▛▀▜▌ █  ▐▛▀▀▘      █ ▐▛▀▜▌▐▛▀▚▖▐▌   ▐▛▀▀▘ ▝▀▚▖
▝▚▄▄▖▐▌ ▐▌▐▙▄▄▖▐▌ ▐▌ █  ▐▙▄▄▖      █ ▐▌ ▐▌▐▙▄▞▘▐▙▄▄▖▐▙▄▄▖▗▄▄▞▘
 */

CREATE TABLE TB_MEDIDAS(
  CODIG0_ME NUMBER(3,0),
  ABREVIATURA_ME VARCHAR(3),
  DESCRIPCION_ME VARCHAR(20)
);

CREATE TABLE TB_ARTICULOS_DANIEL(
  CODIGO_AR NUMBER(5,0),
  DESCRIPCION_AR VARCHAR(30),
  MARCA_AR VARCHAR(20),
  CODIG0_ME NUMBER(3,0),
  CODIGO_CA NUMBER(3,0),
  FECHA_ING DATE,
  STOCK_ACTUAL DECIMAL(10,2)
);

/*
 ▗▄▖ ▗▖ ▗▄▄▄▖▗▄▄▄▖▗▄▄▖     ▗▄▄▄▖▗▄▖ ▗▄▄▖ ▗▖   ▗▄▄▄▖ ▗▄▄▖
▐▌ ▐▌▐▌   █  ▐▌   ▐▌ ▐▌      █ ▐▌ ▐▌▐▌ ▐▌▐▌   ▐▌   ▐▌   
▐▛▀▜▌▐▌   █  ▐▛▀▀▘▐▛▀▚▖      █ ▐▛▀▜▌▐▛▀▚▖▐▌   ▐▛▀▀▘ ▝▀▚▖
▐▌ ▐▌▐▙▄▄▖█  ▐▙▄▄▖▐▌ ▐▌      █ ▐▌ ▐▌▐▙▄▞▘▐▙▄▄▖▐▙▄▄▖▗▄▄▞▘

*/

/*
 * vamos a elimitar una columna de la tabla TB_CATEGORIA 
*  si es necesario eliminar una columna poner columna en mayusculas
 */
ALTER TABLE TB_MEDIDAS DROP COLUMN descripcion_me;

/* 
* para crear la columna KAMILO_COLL
* pilas con agregar la palabra COLUMN 
* porque no es necesario
*/


alter TABLE TB_MEDIDAS ADD kamilo_coll varchar(3);


/* vamos a modificar la tabla TB_MEDIDAS
 * para que el campo CODIG0_ME no pueda
 * ser nulo */
ALTER TABLE TB_MEDIDAS MODIFY(CODIG0_ME NOT NULL);
ALTER TABLE TB_MEDIDAS modify (codig0_me NOT NULL);
--  vamos a agregar  valor por defectoa a una columna 

ALTER TABLE TB_ARTICULOS MODIFY (STOCK_ACTUAL DEFAULT 0);
alter table TB_ARTICULOS_DANIEL modify (STOCK_ACTUAL DEFAULT 0);
ALTER TABLE TB_ARTICULOS MODIFY (CODIG0_ME NOT NULL)

-- setear mas parametros al mismo tiempo
ALTER TABLE tB_ARTICULOS_DANIEL MODIFY (CODIG0_ME NOT NULL, STOCK_ACTUAL DEFAULT 0);

DESCRIBE "ADMIN"."TB_ARTICULOS";

