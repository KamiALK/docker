/*
CREATE TABLE TB_CATEGORIA(
  CODIGO_CA INT,
  DESCRIPTICION VARCHAR(30)
);
*//* 
 ▗▄▄▖▗▄▄▖ ▗▄▄▄▖ ▗▄▖▗▄▄▄▖▗▄▄▄▖    ▗▄▄▄▖▗▄▖ ▗▄▄▖ ▗▖   ▗▄▄▄▖ ▗▄▄▖
▐▌   ▐▌ ▐▌▐▌   ▐▌ ▐▌ █  ▐▌         █ ▐▌ ▐▌▐▌ ▐▌▐▌   ▐▌   ▐▌   
▐▌   ▐▛▀▚▖▐▛▀▀▘▐▛▀▜▌ █  ▐▛▀▀▘      █ ▐▛▀▜▌▐▛▀▚▖▐▌   ▐▛▀▀▘ ▝▀▚▖
▝▚▄▄▖▐▌ ▐▌▐▙▄▄▖▐▌ ▐▌ █  ▐▙▄▄▖      █ ▐▌ ▐▌▐▙▄▞▘▐▙▄▄▖▐▙▄▄▖▗▄▄▞▘
 */

CREATE TABLE TB_MEDIDOS (
    CODIG0_ME NUMBER(3, 0),
    ABREVIATURA_ME VARCHAR(3),
    DESCRIPCION_ME VARCHAR(20)
);

SELECT * FROM TB_MEDIDOS;


CREATE TABLE TB_ARTICULOS_DANIEL (
    CODIGO_AR NUMBER(5, 0),
    DESCRIPCION_AR VARCHAR(30),
    MARCA_AR VARCHAR(20),
    CODIG0_ME NUMBER(3, 0),
    CODIGO_CA NUMBER(3, 0),
    FECHA_ING DATE,
    STOCK_ACTUAL DECIMAL(10, 2)
);
/*
 ▗▄▖ ▗▖ ▗▄▄▄▖▗▄▄▄▖▗▄▄▖     ▗▄▄▄▖▗▄▖ ▗▄▄▖ ▗▖   ▗▄▄▄▖ ▗▄▄▖
▐▌ ▐▌▐▌   █  ▐▌   ▐▌ ▐▌      █ ▐▌ ▐▌▐▌ ▐▌▐▌   ▐▌   ▐▌   
▐▛▀▜▌▐▌   █  ▐▛▀▀▘▐▛▀▚▖      █ ▐▛▀▜▌▐▛▀▚▖▐▌   ▐▛▀▀▘ ▝▀▚▖
▐▌ ▐▌▐▙▄▄▖█  ▐▙▄▄▖▐▌ ▐▌      █ ▐▌ ▐▌▐▙▄▞▘▐▙▄▄▖▐▙▄▄▖▗▄▄▞▘

*//*
   vamos a elimitar una columna de la tabla TB_CATEGORIA 
   si es necesario eliminar una columna poner columna en mayusculas
 */ 

ALTER TABLE TB_MEDIDAS DROP COLUMN descripcion_me;



/* 
  para crear la columna KAMILO_COLL
  pilas con agregar la palabra COLUMN 
  porque no es necesario
*/

ALTER TABLE TB_MEDIDAS ADD kamilo_coll VARCHAR(3);
/* vamos a modificar la tabla TB_MEDIDAS
   para que el campo CODIG0_ME no pueda
   ser nulo */
ALTER TABLE TB_MEDIDAS MODIFY(CODIG0_ME NOT NULL);
ALTER TABLE TB_MEDIDAS modify(
    codig0_me NOT NULL
);
--  vamos a agregar  valor por defectoa a una columna 
ALTER TABLE TB_ARTICULOS MODIFY(
STOCK_ACTUAL DEFAULT 0
);
ALTER TABLE TB_ARTICULOS_DANIEL modify(
STOCK_ACTUAL DEFAULT 0
);
ALTER TABLE TB_ARTICULOS MODIFY(
CODIG0_ME NOT NULL
)-- setear mas parametros al mismo tiempo
ALTER TABLE tB_ARTICULOS_DANIEL MODIFY(
CODIG0_ME NOT NULL,
STOCK_ACTUAL DEFAULT 0
);
DESCRIBE"ADMIN"."TB_ARTICULOS";
/* 
que vamos a hacer 
en la tabla tb_articulos tengo codigo_me
lo volvere foreign key 
pero en codigo_me de la tabla medidas debe de estar en primery KEY

*/
ALTER TABLE tb_medidas ADD CONSTRAINT pk_codigo_me PRIMARY KEY(codig0_me);
ALTER TABLE tb_articulos_daniel ADD CONSTRAINT fk_codigo_me FOREIGN KEY(codig0_me)REFERENCES tb_medidas(codig0_me);
-- me he dado cuenta que primero tenia que ser una prim
--
/*



/*
*
* nullable
* data_default
* COLUMN_id
* comments
* type
*
*
* /


 ▗▄▖ ▗▖ ▗▖▗▄▄▄▖▗▄▖     ▗▄▄▄▖▗▖  ▗▖ ▗▄▄▖▗▄▄▖ ▗▄▄▄▖▗▖  ▗▖▗▄▄▄▖▗▖  ▗▖▗▄▄▄▖▗▄▖ ▗▖   
▐▌ ▐▌▐▌ ▐▌  █ ▐▌ ▐▌      █  ▐▛▚▖▐▌▐▌   ▐▌ ▐▌▐▌   ▐▛▚▞▜▌▐▌   ▐▛▚▖▐▌  █ ▐▌ ▐▌▐▌   
▐▛▀▜▌▐▌ ▐▌  █ ▐▌ ▐▌      █  ▐▌ ▝▜▌▐▌   ▐▛▀▚▖▐▛▀▀▘▐▌  ▐▌▐▛▀▀▘▐▌ ▝▜▌  █ ▐▛▀▜▌▐▌   
▐▌ ▐▌▝▚▄▞▘  █ ▝▚▄▞▘    ▗▄█▄▖▐▌  ▐▌▝▚▄▄▖▐▌ ▐▌▐▙▄▄▖▐▌  ▐▌▐▙▄▄▖▐▌  ▐▌  █ ▐▌ ▐▌▐▙▄▄▖
                                                                                
                                                                                
                                                                                

*/



CREATE TABLE TB_almacen(
codigo_al number(5,0) generated always AS IDENTITY,
      descripcion_ar VARCHAR(30),
      marca_ar VARCHAR(20),
      codig0_me number(3,0),
      codigo_ca number(3,0),
      fecha_ing DATE,
      stock_actual DECIMAL(10,2)
);





