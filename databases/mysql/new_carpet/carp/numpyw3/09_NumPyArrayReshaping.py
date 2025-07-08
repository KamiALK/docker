
###########################################
#           NumPy Array Reshaping
###########################################


import numpy as np

arr = np.array([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])

newarr = arr.reshape(4, 3)

print(newarr)

"""

[[ 1  2  3]
 [ 4  5  6]
 [ 7  8  9]
 [10 11 12]]
"""
###########################################
#           Reshape From 1-D to 3-D
###########################################

# primer numero dimensiones en la dimension 3
# segundo numero cuantos numeros en la dimension 2
# cuantos numeros en la dimension uno 

"""
[[[ 1  2]
  [ 3  4]
  [ 5  6]]

 [[ 7  8]
  [ 9 10]
  [11 12]]]
"""

arr = np.array([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])

newarr = arr.reshape(2, 3, 2)

print(newarr)



###########################################
#      
#      Can We Reshape Into any Shape?
#
###########################################

""""
en este ejemplo use un -1
"""
print("este no lo entendi")
arr = np.array([1, 2, 3, 4, 5, 6, 7, 8])
# leo de atras para adelante  
newarr = arr.reshape(2, 2, -1)

print(newarr)


###########################################
#      
#      Flattening the arrays
#
###########################################

arr = np.array([[1, 2, 3], [4, 5, 6]])

newarr = arr.reshape(-1)

print(newarr)

