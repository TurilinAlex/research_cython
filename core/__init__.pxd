from core.headers.extremes cimport (
    extract_min_extremes,
    extract_max_extremes,
    diff_between_indexes_min,
    diff_between_indexes_max,
    select_eps,
    localize_extremes,
)
from core.headers.argsort cimport argsort, argsort_reverse
from _cython_typing cimport DFLOATINTTYPE_t, DINTTYPE_t