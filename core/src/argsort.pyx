# distutils: language=c++
# cython: boundscheck=False, wraparound=False, nonecheck=False, initializedcheck=False, infer_types=True

from math import log2, ceil

from libc.string cimport memcpy
from libc.stdlib cimport malloc, free

from core._cython_typing cimport DFLOATINTTYPE_t, DINTTYPE_t

cpdef void argsort(DFLOATINTTYPE_t[:] value, DINTTYPE_t[:] index_view, int size):

    cdef DINTTYPE_t *index_temp_view = <DINTTYPE_t *> malloc(size * sizeof(DINTTYPE_t))

    cdef int k, ls, le, rs, re, hh, step
    cdef int h = 0
    cdef int status = 0

    cdef int degree = int(ceil(log2(size)))
    cdef int start_degree = 3
    cdef int size_step = int(2 ** start_degree)

    try:
        while h < size:
            if h + size_step > size:
                hh = size
            else:
                hh = h + size_step
            for rs in range(h, hh):
                k = h
                for ls in range(h, rs):
                    if value[rs] >= value[ls]:
                        k += 1
                for ls in range(rs + 1, hh):
                    if value[rs] > value[ls]:
                        k += 1
                index_view[k] = rs
            h += size_step

        for i in range(start_degree, degree):
            h = int(2 ** i)
            step = 2 * h
            for hh in range(0, size - h, step):
                ls = hh
                le = hh + h - 1
                rs = hh + h
                if hh + 2 * h - 1 < size - 1:
                    re = hh + 2 * h - 1
                else:
                    re = size - 1

                memcpy(index_temp_view + ls, &index_view[0] + ls, (re + 1 - ls) * sizeof(DINTTYPE_t))

                for k in range(ls, re + 1):
                    if ls <= le and rs <= re:
                        if value[index_temp_view[rs]] == value[index_temp_view[ls]]:
                            status = 0
                        elif value[index_temp_view[rs]] < value[index_temp_view[ls]]:
                            status = -1
                        else:
                            status = 1
                    if ls > le: status = -1
                    if rs > re: status = 1

                    if status >= 0:
                        index_view[k] = index_temp_view[ls]
                        ls += 1
                    else:
                        index_view[k] = index_temp_view[rs]
                        rs += 1
    finally:
        free(index_temp_view)


cpdef void argsort_reverse(DFLOATINTTYPE_t[:] value, DINTTYPE_t[:] index_view, int size):

    cdef DINTTYPE_t *index_temp_view = <DINTTYPE_t *> malloc(size * sizeof(DINTTYPE_t))

    cdef int k, ls, le, rs, re, hh, step
    cdef int h = 0
    cdef int status = 0

    cdef int degree = int(ceil(log2(size)))
    cdef int start_degree = 3
    cdef int size_step = int(2 ** start_degree)

    try:
        while h < size:
            if h + size_step > size:
                hh = size
            else:
                hh = h + size_step
            for rs in range(h, hh):
                k = hh - 1
                for ls in range(h, rs):
                    if value[rs] >= value[ls]:
                        k -= 1
                for ls in range(rs + 1, hh):
                    if value[rs] > value[ls]:
                        k -= 1
                index_view[k] = rs
            h += size_step

        for i in range(start_degree, degree):
            h = int(2 ** i)
            step = 2 * h
            for hh in range(0, size - h, step):
                ls = hh
                le = hh + h - 1
                rs = hh + h
                if hh + 2 * h - 1 < size - 1:
                    re = hh + 2 * h - 1
                else:
                    re = size - 1

                memcpy(index_temp_view + ls, &index_view[0] + ls, (re + 1 - ls) * sizeof(DINTTYPE_t))

                for k in range(ls, re + 1):
                    if ls <= le and rs <= re:
                        if value[index_temp_view[rs]] == value[index_temp_view[ls]]:
                            status = 0
                        elif value[index_temp_view[rs]] < value[index_temp_view[ls]]:
                            status = 1
                        else:
                            status = -1
                    if ls > le: status = -1
                    if rs > re: status = 1

                    if status >= 1:
                        index_view[k] = index_temp_view[ls]
                        ls += 1
                    else:
                        index_view[k] = index_temp_view[rs]
                        rs += 1
    finally:
        free(index_temp_view)