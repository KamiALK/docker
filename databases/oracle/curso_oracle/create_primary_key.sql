/* 
que vamos a hacer 
en la tabla tb_articulos tengo codigo_me
lo volvere foreign key 
pero en codigo_me de la tabla medidas debe de estar en primery KEY

*/

ALTER TABLE tb_medidas
ADD CONSTRAINT pk_codigo_me PRIMARY KEY (codig0_me);

alter table tb_articulos_daniel add constraint fk_codigo_me foreign key (codig0_me) references tb_medidas(codig0_me);

-- me he dado cuenta que primero tenia que ser una primary key antes de hacer la foreign key
--
-
