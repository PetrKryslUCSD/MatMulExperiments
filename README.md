# MatMulExperiments

The purpose is to understand the effect of using the package `LoopVectorization` produced by Chris Elrod and referenced in [this  post](https://discourse.julialang.org/t/ann-loopvectorization/32843).

The file `test/runtests.jl` produces measurements for square matrices, with 
- the default implementations of the matrix-matrix multiplication (routine with `@avx` as implemented in FinEtools, routine with `@avx` with explicit zeroing out of the matrix, and the built-in BLAS routine);
- the plain  matrix-matrix multiplication routines, pure Julia;
- the matrix-matrix multiplication routines, pure Julia with `@inbounds`;
- the matrix-matrix multiplication routines, pure Julia with `@simd`;
- the matrix-matrix multiplication routines, pure Julia with `@avx`.

Measurements are presented in these graphs:

[Default implementations](gflops-default.png) 

[Naïve Julia](gflops-plain.png)  

[Julia with `@inbounds`](gflops-inbounds.png)  

[Julia with `@simd`](gflops-simd.png) 

[Julia with `@avx`](gflops-avx.png) 