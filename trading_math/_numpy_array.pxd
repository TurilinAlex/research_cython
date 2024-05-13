cimport numpy as np

cdef class MemoryNanny:
    cdef void *ptr  # set to NULL by "constructor"
    @staticmethod
    cdef create(void *ptr)

cdef np.ndarray array_from_ptr(void *ptr, np.npy_intp n, int np_type)
