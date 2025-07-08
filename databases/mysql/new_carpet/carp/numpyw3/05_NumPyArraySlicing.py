## We pass slice instead of index like this: [start:end].
## We can also define the step, like this: [start:end:step].

import numpy as np

arr = np.array([1,2,3,4,5,6,7])
print(arr[1:5])

#comineza   desde el cero
print("segunda tanda de arreglos",arr[2:])


# ahora vamos a hacerlo en reversa 
print("ahora en reversa ")
print(arr[-3:-1])

###########################################
#        STEP INTO THE ARRAY
###########################################


# I am gonna to do steps into the array
print("aqui de abrinquitosa")
print(arr[1:5:2])


# recorre todo el array de dosen dos  
print("recorre todo el array de a dos en dos ")
print(arr[::2])


# recorre 
arr_2d = np.array([[1,2,3,4,5,6],[2,4,6,8,10,12]])
print("el primer valir dice que array hacer y el segundo dice que tomar")
print (arr_2d[1,1:4])



prueba = np.array([[1, 2, 3, 4, 5], [6, 7, 8, 9, 10],[11, 12, 13, 14, 15]])
print("---------------------recorrer en dimencion--------------------------")

# elprimer parametro dice cuantas dimensiones recorrer y el segundo que numero a obtener de esa dimension
print(prueba[0:2, 4]) # [ 5 10]  puedo recorrer dimenciones  tambien
print(prueba[0:3, 4]) # [ 5 10 15]

print("_______________recorrer en dimension y en array________________-__-")

print(prueba[0:2,1:4])



