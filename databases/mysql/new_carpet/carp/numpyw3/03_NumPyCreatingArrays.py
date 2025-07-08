import numpy as np

arr = np.array([1,2,3,4,5,6])

print(f"este es el tipo de array {arr}")
print(type(arr))


###########################################
#        ARRAY 1-D
###########################################
arr_1=np.array(42)
print(arr)

###########################################
#        ARRAY 2-D
###########################################
arr_2d=np.array([[1,2,3],[1,2,2]])
print(arr_2d)


###########################################
#        ARRAY 3-D
###########################################
arr_3d = np.array([[[1,2,3],[1,2,3]],[[1,2,3],[1,2,3 ]],[[1,2,3],[1,2,3 ]]])
#arr_3r = np.array([[[1, 2, 3], [4, 5, 6]], [[1, 2, 3], [4, 5, 6]]])
print("aqui tengo el array de tres dimensiones")
print(arr_3d)
# queremos verificar las dimensiones del array con el metodo
print(f"la cantidad de dimensiones es:  {arr_3d.ndim}")


###########################################
#        ARRAY CON N DIMENSIONES
###########################################

arr_ndim=np.array([1,2.3,4,5], ndmin=5)
print("array de dimensiones: ",arr_ndim.ndim)