
import numpy as np


###########################################
#      
#      NumPy Array Iterating
#
###########################################



"""

Iterating Arrays
Iterating means going through elements one by one.

As we deal with multi-dimensional arrays in numpy, we can do this using basic for loop of python.

If we iterate on a 1-D array it will go through each element one by one. 

"""


###########################################
#      
#      iterating in 1-DIMENSION
#
###########################################


arr = np.array([1, 2, 3])

for x in arr:
  print(x)


###########################################
#      
#      ITERATING  IN 2-DIMENTION
#
###########################################

arr = np.array([[1, 2, 3], [4, 5, 6]])

for x in arr:
  print(x)



arr = np.array([[1, 2, 3], [4, 5, 6]])

for x in arr:
  for y in x:
    print(y)


###########################################
#      
#      ITERATING  IN 2-DIMENTION
#
###########################################




arr = np.array([[[1, 2, 3], [4, 5, 6]], [[7, 8, 9], [10, 11, 12]]])

for x in arr:
  print(x)


for x in arr:
  for y in x:
    for z in y:
      print(z)



###########################################
#      
#      Iterating Arrays Using nditer()
#
###########################################


arr = np.array([[[1, 2], [3, 4]], [[5, 6], [7, 8]]])

for x in np.nditer(arr):
  print(x)

"""
esta haciendo esta operacion
1
2
3
4
5
6
7
8
"""

#####################################################
#      
#      Iterating Array With Different Data Types
#
#####################################################


arr = np.array([1, 2, 3])

for x in np.nditer(arr, flags=['buffered'], op_dtypes=['S']):
  print(x)


"""
np.bytes_(b'1')
np.bytes_(b'2')
np.bytes_(b'3')
"""


#####################################################
#      
#      Iterating Array With Different Data Types
#
#####################################################

arr = np.array([[1, 2, 3, 4], [5, 6, 7, 8]])

for x in np.nditer(arr[:, ::2]):
  print(x)



#####################################################
#      
#      Enumerated Iteration Using ndenumerate()
#
#####################################################

# me muestra los index del fulano que se esta iterando 

arr = np.array([1, 2, 3])

for idx, x in np.ndenumerate(arr):
  print(idx, x)



"""
(0,) 1
(1,) 2
(2,) 3
"""

arr = np.array([[1, 2, 3, 4], [5, 6, 7, 8]])

for idx, x in np.ndenumerate(arr):
  print(idx, x)


"""

como un array 2d tiene dos dimensiones entonces necesita dos 

(0, 0) 1
(0, 1) 2
(0, 2) 3
(0, 3) 4
(1, 0) 5
(1, 1) 6
(1, 2) 7
(1, 3) 8

  
"""