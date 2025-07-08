import numpy as np
#####################################################
#      
#      NumPy Joining Array
#
#####################################################



#####################################################
#      
#      NumPy Joining Array 1-D
#
#####################################################

arr1 = np.array([1, 2, 3])

arr2 = np.array([4, 5, 6])

arr = np.concatenate((arr1, arr2))

print(arr)


#####################################################
#      
#      NumPy Joining Array 2-D
#
#####################################################
arr1 = np.array([[1, 2], [3, 4]])

arr2 = np.array([[5, 6], [7, 8]])

arr = np.concatenate((arr1, arr2), axis=1)

print(arr)




#####################################################
#      
#      Joining Arrays Using Stack Functions
#
#####################################################


print("prueba de validacion de xis ")
arr1 = np.array([1, 2, 3])

arr2 = np.array([4, 5, 6])

arr = np.stack((arr1, arr2), axis=1)

print(arr)
"""
estoy cambiando la orientacion del de array
[[1 4]
 [2 5]
 [3 6]]
"""


#####################################################
#      
#      Stacking Along Rows
#
#####################################################

arr1 = np.array([1, 2, 3])

arr2 = np.array([4, 5, 6])

arr = np.hstack((arr1, arr2))

print(arr)

"""
[1 2 3 4 5 6]
"""

#####################################################
#      
#      Stacking Along Rows
#
#####################################################


arr1 = np.array([1, 2, 3])

arr2 = np.array([4, 5, 6])

arr = np.dstack((arr1, arr2))

print(arr)


#####################################################
#      
#      Stacking Along Columns
#
#####################################################

arr1 = np.array([1, 2, 3])

arr2 = np.array([4, 5, 6])

arr = np.vstack((arr1, arr2))

print(arr)



#####################################################
#      
#      Stacking Along Height (depth)
#
#####################################################


arr1 = np.array([1, 2, 3])

arr2 = np.array([4, 5, 6])

arr = np.dstack((arr1, arr2))

print(arr)

