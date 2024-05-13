from cpython.object cimport PyObject
from cpython.ref cimport Py_INCREF

cimport numpy as np
from libc.stdlib cimport free

#needed to initialize PyArray_API in order to be able to use it
np.import_array()

cdef extern from "numpy/arrayobject.h":
    # a little bit awkward: the reference to obj will be stolen
    # using PyObject*  to signal that Cython cannot handle it automatically
    int PyArray_SetBaseObject(np.ndarray arr, PyObject *obj) except -1  # -1 means there was an error


cdef class MemoryNanny:
    def __dealloc__(self):
        free(self.ptr)

    @staticmethod
    cdef create(void *ptr):
        cdef MemoryNanny result = MemoryNanny()
        result.ptr = ptr
        return result

cdef np.ndarray array_from_ptr(void *ptr, np.npy_intp n, int np_type):
    cdef np.ndarray arr = np.PyArray_SimpleNewFromData(1, &n, np_type, ptr)
    nanny = MemoryNanny.create(ptr)
    Py_INCREF(nanny)  # a reference will get stolen, so prepare nanny
    PyArray_SetBaseObject(arr, <PyObject *> nanny)
    return arr
