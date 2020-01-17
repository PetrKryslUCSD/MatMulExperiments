module mmmultest2
using Test
using BenchmarkTools
using LoopVectorization
using LinearAlgebra


"""
    mulCAB!(C, A, B)

Compute the matrix `C = A * B`
"""
function mulCAB!(C, A, B)
	M, N = size(C); K = size(B,1)
	@assert size(C, 1) == size(A, 1)
    @assert size(C, 2) == size(B, 2)
    @assert size(A, 2) == size(B, 1)
	C .= 0
	@avx  for n ∈ 1:N, k ∈ 1:K # for k ∈ 1:K, n ∈ 1:N #
		Bkn = B[k,n]
		for m ∈ 1:M
			C[m,n] += A[m,k] * Bkn
		end
	end
	return C
end

function gemmavx!(C, A, B)
	M, N = size(C); K = size(B,1)
	C .= 0
    @avx  for n ∈ 1:N, k ∈ 1:K # for k ∈ 1:K, n ∈ 1:N #
    	Bkn = B[k,n]
        for m ∈ 1:M
            C[m,n] += A[m,k] * Bkn
        end
    end
    return C
end

function gemmblas!(C, A, B)
    mul!(C, A, B)
    return C
end



function test(n)
	println("n = ", n)
	C, A, B = rand(n, n), rand(n, n), rand(n, n)
	@test norm(mulCAB!(C, A, B) - A * B) / norm(C) <= 1.0e-9
	@test norm(gemmblas!(C, A, B) - A * B) / norm(C) <= 1.0e-9
	@test norm(gemmavx!(C, A, B) - A * B) / norm(C) <= 1.0e-9

	println("mulCAB!")
	@btime mulCAB!($C, $A, $B)
	println("gemmblas!")
	@btime gemmblas!($C, $A, $B)
	println("gemmavx!")
	@btime gemmavx!($C, $A, $B)
end
end
using .mmmultest2
BLAS.set_num_threads(1)
mmmultest2.test(2^6)
mmmultest2.test(2^5)
mmmultest2.test(2^4)
mmmultest2.test(2^3)

# mlatest1.test(3)
# mlatest1.test(5)
# mlatest1.test(7)