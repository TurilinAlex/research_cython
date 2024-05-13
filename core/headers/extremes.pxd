from .._cython_typing cimport DINTTYPE_t
cimport numpy as np

cpdef np.ndarray[DINTTYPE_t, ndim=1] extract_min_extremes(
        np.ndarray[DINTTYPE_t, ndim=1] input_array,
        int size,
        int eps,
)
cpdef np.ndarray[DINTTYPE_t, ndim=1] extract_max_extremes(
        np.ndarray[DINTTYPE_t, ndim=1] input_array,
        int size,
        int eps,
)

cpdef void diff_between_indexes_min(
        np.ndarray[DINTTYPE_t, ndim=1] input_array,
        np.ndarray[DINTTYPE_t, ndim=1] diff,
        np.ndarray[DINTTYPE_t, ndim=1] marker,
        int size,
        int eps,
)

cpdef void diff_between_indexes_max(
        np.ndarray[DINTTYPE_t, ndim=1] input_array,
        np.ndarray[DINTTYPE_t, ndim=1] diff,
        np.ndarray[DINTTYPE_t, ndim=1] marker,
        int size,
        int eps,
)

cpdef int select_eps(
        np.ndarray[DINTTYPE_t, ndim=1] marker_for_diff,
        int size,
        int coincident,
        int eps,
)

cpdef np.ndarray[DINTTYPE_t, ndim=1] localize_extremes(
        np.ndarray[DINTTYPE_t, ndim=1] diff,
        int size,
        int eps,
)
