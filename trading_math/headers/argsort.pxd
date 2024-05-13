from trading_math._cython_typing cimport DFLOATINTTYPE_t, DINTTYPE_t

cpdef void argsort(DFLOATINTTYPE_t[:] value, DINTTYPE_t[:] index_view, int size)

cpdef void argsort_reverse(DFLOATINTTYPE_t[:] value, DINTTYPE_t[:] index_view, int size)
