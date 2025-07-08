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

'''
se obtiene una serie que nos permite tener
en el primer acmpo el valor del ticket
y enel segundo campo la cantidad de veces que se repite
'''
conteo_tarjetas = df_unido["Card number"].value_counts()

# aquiobtenemos los grupos de tarjeta
grupo_unicas = conteo_tarjetas[conteo_tarjetas == 1].index
grupo_duplicadas = conteo_tarjetas[conteo_tarjetas > 1].index


# vamos por los duplicados
re_unicos = df_unido[df_unido["Card number"].isin(grupo_unicas)]
re_duplicados = df_unido[df_unido["Card number"].isin(grupo_duplicadas)]
sub_df = re_duplicados
# sub_df = re_duplicados.head(10)
# print(re_duplicados.head(10).to_string())


table_name = "historial_transactions"


# Función para formatear los valores correctamente para SQL
def format_value(val):
    if pad.isna(val):
        return 'NULL'
    if isinstance(val, str):
        # Verificar si el valor es 'FALSO' o 'VERDADERO' y convertir a FALSE o TRUE
        if val.upper() == 'FALSO':
            return 'FALSE'
        if val.upper() == 'VERDADERO':
            return 'TRUE'
        # Escapar comillas simples
        return "'" + val.replace("'", "''") + "'"
    if isinstance(val, pad.Timestamp):
        return "'" + val.strftime('%Y-%m-%d %H:%M:%S') + "'"
    if isinstance(val, bool):
        # Si es un valor booleano, devolver 1 para True, 0 para False
        return 'TRUE' if val else 'FALSE'
    return str(val)


insert_statements = []

# Generar las sentencias INSERT
for _, row in df_unido.iterrows():
    # Usar backticks (comillas invertidas) para los nombres de columnas
    columns = ", ".join(f"`{col}`" for col in df_unido.columns)
    values = ", ".join(format_value(row[col]) for col in df_unido.columns)
    sql = f"INSERT INTO {table_name} ({columns}) VALUES ({values});"
    insert_statements.append(sql)

# Mostrar resultados
for stmt in insert_statements:
    print(stmt)

with open("historial_insert.sql", "w", encoding="utf-8") as file:
    for stmt in insert_statements:
        file.write(stmt + "\n")

print("Archivo 'historial_insert.sql' creado con éxito.")
