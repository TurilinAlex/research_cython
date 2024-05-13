# distutils: language=c++
# cython: boundscheck=False, wraparound=False, nonecheck=False, initializedcheck=False, infer_types=True


from core._cython_typing cimport DINTTYPE_t
from core._numpy_array cimport array_from_ptr

cimport numpy as np
from libc.stdlib cimport malloc
from libcpp cimport bool

cpdef np.ndarray[DINTTYPE_t, ndim=1] extract_min_extremes(
        np.ndarray[DINTTYPE_t, ndim=1] input_array,
        const int size,
        const int eps,
):
    cdef:
        DINTTYPE_t *extremes = <DINTTYPE_t *> malloc(sizeof(DINTTYPE_t) * size)
        int i, j, f, n = 0

    for i in range(size):
        for j in range(1, i + 1):
            f = input_array[i] - input_array[i - j]
            if abs(f) <= eps:
                break
        else:
            extremes[n] = input_array[i]
            n += 1

    cdef np.ndarray[DINTTYPE_t, ndim=1] arr = array_from_ptr(extremes, n, np.NPY_INT32)
    return arr

cpdef np.ndarray[DINTTYPE_t, ndim=1] extract_max_extremes(
        np.ndarray[DINTTYPE_t, ndim=1] input_array,
        int size,
        int eps,
):
    cdef:
        DINTTYPE_t *extremes = <DINTTYPE_t *> malloc(sizeof(DINTTYPE_t) * size)
        int i, j, f, n = 0

    for i in range(size):
        for j in range(1, size - i):
            f = input_array[i] - input_array[i + j]
            if abs(f) <= eps:
                break
        else:
            extremes[n] = input_array[i]
            n += 1
    cdef np.ndarray[DINTTYPE_t, ndim=1] arr = array_from_ptr(extremes, n, np.NPY_INT32)
    return arr

cpdef void diff_between_indexes_min(
        np.ndarray[DINTTYPE_t, ndim=1] input_array,
        np.ndarray[DINTTYPE_t, ndim=1] diff,
        np.ndarray[DINTTYPE_t, ndim=1] marker,
        int size,
        int eps,
):
    cdef:
        int i, j, f, min_d

    for i in range(size):
        min_d = size

        # min
        for j in range(1, i + 1):
            f = input_array[i] - input_array[i - j]
            f = abs(f)
            if f < min_d:
                min_d = f
            if min_d <= eps:
                break

        diff[input_array[i]] = min_d
        marker[min_d] = 1

cpdef void diff_between_indexes_max(
        np.ndarray[DINTTYPE_t, ndim=1] input_array,
        np.ndarray[DINTTYPE_t, ndim=1] diff,
        np.ndarray[DINTTYPE_t, ndim=1] marker,
        int size,
        int eps,
):
    cdef:
        int i, j, f, min_d

    for i in range(size):
        min_d = size

        # max
        for j in range(1, size - i):
            f = input_array[i] - input_array[i + j]
            f = abs(f)
            if f < min_d:
                min_d = f
            if min_d <= eps:
                break

        diff[input_array[i]] = min_d
        marker[min_d] = 1

cpdef int select_eps(
        np.ndarray[DINTTYPE_t, ndim=1] marker_for_diff,
        int size,
        int coincident,
        int eps,
):
    cdef:
        int i, count_zero, last_non_zero_index

    if coincident == 1:
        return eps

    count_zero = 0
    last_non_zero_index = eps
    for i in range(last_non_zero_index + 1, size):
        if count_zero >= coincident - 1:
            return last_non_zero_index + coincident - 1
        if marker_for_diff[i] == 0:
            count_zero += 1
        else:
            count_zero = 0
            last_non_zero_index = i

    return last_non_zero_index + coincident - 1

cpdef np.ndarray[DINTTYPE_t, ndim=1] localize_extremes(
        np.ndarray[DINTTYPE_t, ndim=1] diff,
        int size,
        int eps,
):
    cdef:
        DINTTYPE_t *extremes = <DINTTYPE_t *> malloc(sizeof(DINTTYPE_t) * size)
        int i, n = 0
        bool is_extr

    for i in range(size):
        is_extr = diff[i] > eps or diff[i] == size
        if is_extr:
            extremes[n] = i
            n += 1

    cdef np.ndarray[DINTTYPE_t, ndim=1] arr = array_from_ptr(extremes, n, np.NPY_INT32)
    return arr
