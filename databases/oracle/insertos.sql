
SELECT * FROM ADMIN.TB_MEDIDAS;



-- consultar las tablas de la base de datos
SELECT TABLE_NAME FROM user_tables;


describe ADMIN.TB_MEDIDAS;


--codig0_me 
--abreviatura_me
--camilo_coll

SELECT TABLE_NAME FROM USER_DEFINED_TYPE_SCHEMA;


insert into ADMIN.TB_MEDIDAS (CODIG0_ME, ABREVIATURA_ME, KAMILO_COLL) values (555,'cm', 'centimetro');


insert into admin.tb_medidas (CODIG0_ME, ABREVIATURA_ME,KAMILO_COLL)VALUES (2,'CM','CENTIMENTRO');

insert into admin.tb_medidas(codig0_me,abreviatura_me,kamilo_coll)values(3,'cm','cecntimetros');



describe ADMIN.TB_ARTICULOS;

insert into admin.tb_articulos(codigo_ar,descripcion_ar,marca_ar,codig0_me,codigo_ca,fecha_ing,stock_actual)
values (1,'camisa','adidas',1,1,TO_DATE('2023-10-01','YYYY-MM-DD'),100);

COLUMN codigo_ar FORMAT 99
COLUMN codig0_me FORMAT 99
coLUMN codigo_ca FORMAT 99
COLUMN descripcion_ar FORMAT A10
COLUMN marca_ar FORMAT A10
cOLUMN fecha_ing FORMAT A10
coLUMN stock_actual FORMAT 999
SELECT codigo_ar, descripcion_ar, marca_ar, codig0_me, codigo_ca, fecha_ing, stock_actual
  FROM admin.tb_articulos;





CREATE TABLE kamilo_prubea(
  KAMILO  NUMBER (3,0),
  KAMILO_B  NUMBER (3,0), 
  KAMILO_C  NUMBER (3,0),
  kamilo_d  NUMBER (3,0),
  kamilo_e number(3.0),
  KAM_F   NUMBER(3,0),
g NUMBER(3,0)
);





