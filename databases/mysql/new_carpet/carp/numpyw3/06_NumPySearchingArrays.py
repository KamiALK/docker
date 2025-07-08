import numpy as np

#########################################
#        Data Types in Python
#########################################

"""
strings - used to represent text data, the text is given under quote marks. e.g. "ABCD"
integer - used to represent integer numbers. e.g. -1, -2, -3
float - used to represent real numbers. e.g. 1.2, 42.42
boolean - used to represent True or False.
complex - used to represent complex numbers. e.g. 1.0 + 2.0j, 1.5 + 2.5j
"""
#########################################
#        Data Types in Python
#########################################

"""
i - integer
b - boolean
u - unsigned integer
f - float
c - complex float
m - timedelta
M - datetime
O - object
S - string
U - unicode string
V - fixed chunk of memory for other type ( void )
"""

#########################################
#   Checking the Data Type of an Array
#########################################


arr=np.array([1,2,4,5,6])
"""
por algun motivo es un metodo 
"""
print(arr.dtype) # int64

arr_string = np.array(["kamilo","almanza", "casteblanco","duarte"])
print(arr_string.dtype)#<u11


################################################
#   Creating Arrays With a Defined Data Type
################################################


arr=np.array([1,2,3,4,5,6,7],dtype="S")
print(arr.dtype)# |S1


#  For i, u, f, S and U we can define size as well.


arr_2=np.array([1,2,3,4,5,6,7],dtype="U4")
print(arr_2.dtype)# |S1

arr_magico = np.array([1, 2, 3, 4], dtype='i4')

print(arr_magico)
print(arr_magico.dtype)

print("prueba de boleano ")
ar = np.array([1, 0, 3,-1])

newarr = ar.astype(bool)

print(newarr)
print(newarr.dtype)