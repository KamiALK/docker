import numpy as np


# acceder al elemento de un array
arr=np.array([1,2,3,4,5])
print(arr[0])

#puedo intentar acceder al cuarto elemento de un array
print(arr[3]+arr[4])


###########################################
#        Access 2-D Arrays
###########################################

arr_2d=np.array([[1,10,3,4,5],[1,2,3,4,5]])
print("2nd element on 1st row", arr_2d[0,1])


###########################################
#        Access 3-D Arrays
###########################################
arr_3d=np.array([[[1,2,3],[4,5,6]],[[-1,-2,-3],[-4,-5,-6]],[[-10,-20,-30],[-40,-50,-60]]])
print(arr_3d[2,1,1])
## en este caso el primer numero son las capas superior o inferior 
## el segundo numero son las capas de derecha izquierda 
## el tercer numero se mueve unidireccionalmente 
