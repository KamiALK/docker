import pandas as pad

ruta = "./data/carro/"

data = pad.read_csv(f"{ruta}carros_2_csv.csv", sep=";")
data1 = pad.read_csv(f"{ruta}carros_3_csv.csv", sep=";")
data2 = pad.read_csv(f"{ruta}carros_4_csv.csv", sep=";")
# forma de ingresar un excel y tuve que instalar pip install xlrd
data3 = pad.read_excel(f"{ruta}carros_5.xls", sheet_name="hoja", usecols="A:L")

df_unido = pad.concat([data, data1, data2, data3], ignore_index=True)
# print("la cola comineza aqui ")
# print(df_unido.tail(20))
# print("tamaño de data ",data.shape)
# print("tamaño de data1", data1.shape)
# print("tamaño de df_unido:",df_unido.shape)


# se obtiene una serie que nos permite tener en el primer acmpo el valor del ticket y enel segundo campo la cantidad de veces que se repite
conteo_tarjetas = df_unido["Card number"].value_counts()


# aquiobtenemos los grupos de tarjeta
grupo_unicas = conteo_tarjetas[conteo_tarjetas == 1].index
grupo_duplicadas = conteo_tarjetas[conteo_tarjetas > 1].index


# vamos por los duplicados
re_unicos = df_unido[df_unido["Card number"].isin(grupo_unicas)]
re_duplicados = df_unido[df_unido["Card number"].isin(grupo_duplicadas)]


print("_____________________ prueba filtrado de dos columnas _________________________________")
var2 = "SALON INTERNACIONAL DEL AUTOMOVIL 2024"
filtro = (df_unido["Event title"] == var2) & (
    df_unido["Gate"] == "ARCO [1] - Validador 25 [25 ]")
df_filtrado = df_unido[filtro]
# print(df_filtrado)


print("___________________________ filtrado de mas valores en la misma columna _________________________________________")
gates = ["ARCO [1] - Validador 46 [46 ]",
         "PUENTE AGORA [5] - Validador 86 [86 ]", "ARCO [1] - Validador 60 [60 ]"]
filtro_b = (df_unido["Gate"].isin(gates)) & (df_unido["Event title"] == var2)
df_filtro_b = df_unido[filtro_b]
print(df_filtro_b)
var1 = "CREDENCIAL CCB 2024 2025"
var2 = "SALON INTERNACIONAL DEL AUTOMOVIL 2024"


# print(conteo_tarjetas)
# print("conteo de registro unicos", len(re_unicos))
# print("longutud de duplicados: ",len(re_duplicados))
print("---------------------------------------------------------")
# print(re_duplicados.to_string())


if (re_duplicados["Event title"] == var1).equals and (re_duplicados["Gate"] == "Validador 60 [60 ] ").equals:
    # print(re_duplicados.to_string())

    print("hola mundo")
