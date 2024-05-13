from numpy import ndarray

from .._python_typing import DINTTYPE_t


def extract_min_extremes(
        input_array: ndarray[DINTTYPE_t],
        size: int,
        eps: int,
) -> ndarray[DINTTYPE_t]: pass


def extract_max_extremes(
        input_array: ndarray[DINTTYPE_t],
        size: int,
        eps: int,
) -> ndarray[DINTTYPE_t]: pass


def diff_between_indexes_min(
        input_array: ndarray[DINTTYPE_t],
        diff: ndarray[DINTTYPE_t],
        marker: ndarray[DINTTYPE_t],
        size: int,
        eps: int,
) -> None: pass


def diff_between_indexes_max(
        input_array: ndarray[DINTTYPE_t],
        diff: ndarray[DINTTYPE_t],
        marker: ndarray[DINTTYPE_t],
        size: int,
        eps: int,
) -> None: pass


def select_eps(
        marker_for_diff: ndarray[DINTTYPE_t],
        size: int,
        coincident: int,
        eps: int,
) -> int: pass


def localize_extremes(
        diff: ndarray[DINTTYPE_t],
        size: int,
        eps: int,
) -> ndarray[DINTTYPE_t]: pass
