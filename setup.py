import numpy
from Cython.Build import cythonize
from Cython.Compiler import Options
from setuptools import setup, Extension, find_packages


Options.fast_fail = True

ext = cythonize(
    [
        Extension(
            name="trading_math.*",
            sources=["core/**/*.pyx"],
            language="c++",
            extra_compile_args=[
                "-std=c++17",
                "-O3",
                "-ffast-math",
                "-DCYTHON_FAST_GIL",
                "-Rpass-analysis=loop-vectorize",
            ],
        ),
    ],
    annotate=True,
    compiler_directives={"language_level": "3"},
)

setup(
    name="trading-math",
    version="1.0.0",
    description="Cython math for Trading Service",
    long_description="long_description",
    long_description_content_type="text/markdown",
    packages=find_packages(),
    ext_modules=ext,
    zip_safe=False,
    include_package_data=True,
    include_dirs=[numpy.get_include()],
)
