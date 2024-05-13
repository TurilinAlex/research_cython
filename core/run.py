from time import monotonic

import numpy as np

from core import argsort as argsort_c
from core import diff_between_indexes_min as diff_between_indexes_min_c
from core import localize_extremes as localize_extremes_c
from core import select_eps as select_eps_c

np.random.seed(123)


def diff_between_indexes(indexes: np.ndarray[np.int32], eps: int):
    n = len(indexes)

    _diff = [0] * n

    # Stores labels about the value of the index difference for local minima
    # That is abs(_index[i] - _index[i - j]) = _diff -> marker_diff_for_minimal[_diff] = 1
    _marker_for_diff = [0] * (n + 1)

    # region Calculating the difference between indexes

    for i in range(n):
        min_diff = n

        # min
        for j in range(1, i + 1):
            diff = abs(indexes[i] - indexes[i - j])
            if diff < min_diff:
                min_diff = diff
            if min_diff <= eps:
                break

        _diff[indexes[i]] = min_diff
        _marker_for_diff[min_diff] = 1

    return _diff, _marker_for_diff


def select_eps(marker_for_diff, coincident: int, eps: int):
    if coincident == 1:
        return eps

    count_zero = 0
    last_non_zero_index = eps
    for i in range(last_non_zero_index + 1, len(marker_for_diff)):
        if count_zero >= coincident - 1:
            return last_non_zero_index + coincident - 1
        if marker_for_diff[i] == 0:
            count_zero += 1
        else:
            count_zero = 0
            last_non_zero_index = i

    return last_non_zero_index + coincident - 1


def localize_extremes(diff, eps: int):
    global_extremes = len(diff)

    extremes_indexes = []
    for i, d in enumerate(diff):
        is_extr = d > eps or d == global_extremes
        if is_extr:
            extremes_indexes.append(i)

    return extremes_indexes


def main():
    values = np.random.uniform(0, 10000, 10_000)
    start_time = monotonic()
    indexes = np.argsort(values, kind="mergesort").astype(np.int32)
    end_time = monotonic()
    r1 = end_time - start_time

    index = np.zeros(len(values), dtype=np.int32)
    start_time = monotonic()
    argsort_c(values, index, len(values))
    end_time = monotonic()
    r2 = end_time - start_time

    print(r1)
    print(r2)
    print(r1 / r2)
    print(indexes)
    print(index)
    print(np.all(indexes == index))

    start_time = monotonic()
    diff = np.zeros((len(indexes),), dtype=np.int32)
    marker = np.zeros((len(indexes) + 1,), dtype=np.int32)
    diff_between_indexes_min_c(indexes, diff, marker, len(indexes), 30)
    eps = select_eps_c(marker, len(marker), 5, 30)
    extremes = localize_extremes_c(diff, len(diff), eps)
    print(monotonic() - start_time)
    print(diff)
    print(marker)
    print(eps, extremes)

    print()
    print()
    start_time = monotonic()
    diff, marker = diff_between_indexes(indexes, 30)
    eps = select_eps(marker, 5, 30)
    extremes = localize_extremes(diff, eps)
    print(monotonic() - start_time)
    print(np.array(diff))
    print(np.array(marker))
    print(eps, np.array(extremes))


if __name__ == '__main__':
    main()
