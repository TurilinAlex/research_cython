from numpy cimport npy_float32, npy_float64, npy_int8, npy_int16, npy_int32, npy_int64

ctypedef fused DFLOATTYPE_t:
    float
    npy_float32
    npy_float64

ctypedef fused DINTTYPE_t:
    int
    npy_int8
    npy_int16
    npy_int32
    npy_int64

ctypedef fused DFLOATINTTYPE_t:
    float
    npy_float32
    npy_float64
    int
    npy_int8
    npy_int16
    npy_int32
    npy_int64
