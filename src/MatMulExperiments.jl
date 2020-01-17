module MatMulExperiments



using LoopVectorization
using LinearAlgebra

function mulCAB!(C, A, B)
	M, N = size(C); K = size(B,1)
	@assert M == size(A, 1)
    @assert N == size(B, 2)
    @assert size(A, 2) == K
    # Surprisingly the code below (nkm) is slower than the one in the order mnk.
	# C .= 0
	# @avx  for n in 1:N, k in 1:K 
	# 	Bkn = B[k,n]
	# 	for m in 1:M
	# 		C[m,n] += A[m,k] * Bkn
	# 	end
	# end
	z = zero(eltype(C))
	@avx  for m in 1:M, n in 1:N 
		Cmn = z
	    for k in 1:K
	        Cmn += A[m,k] * B[k,n]
	    end
	    C[m,n] = Cmn
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

function mulCABijp!(C, A, B)
	M, N = size(C); K = size(B,1)
	@assert M == size(A, 1)
    @assert N == size(B, 2)
    @assert size(A, 2) == K
    C .= 0
	for i in 1:M, j in 1:N
		for p in 1:K
	        C[i,j] += A[i,p] * B[p,j]
	    end
	end
	return C
end

function mulCABjip!(C, A, B)
	M, N = size(C); K = size(B,1)
	@assert M == size(A, 1)
    @assert N == size(B, 2)
    @assert size(A, 2) == K
    C .= 0
	for j in 1:N, i in 1:M
		for p in 1:K
	        C[i,j] += A[i,p] * B[p,j]
	    end
	end
	return C
end

function mulCABipj!(C, A, B)
	M, N = size(C); K = size(B,1)
	@assert M == size(A, 1)
    @assert N == size(B, 2)
    @assert size(A, 2) == K
    C .= 0
	for i in 1:M, p in 1:K
		for j in 1:N
	        C[i,j] += A[i,p] * B[p,j]
	    end
	end
	return C
end

function mulCABjpi!(C, A, B)
	M, N = size(C); K = size(B,1)
	@assert M == size(A, 1)
    @assert N == size(B, 2)
    @assert size(A, 2) == K
    C .= 0
	for j in 1:N, p in 1:K
		for i in 1:M
	        C[i,j] += A[i,p] * B[p,j]
	    end
	end
	return C
end

function mulCABpij!(C, A, B)
	M, N = size(C); K = size(B,1)
	@assert M == size(A, 1)
    @assert N == size(B, 2)
    @assert size(A, 2) == K
    C .= 0
	for p in 1:K
		for i in 1:M, j in 1:N
	        C[i,j] += A[i,p] * B[p,j]
	    end
	end
	return C
end

function mulCABpji!(C, A, B)
	M, N = size(C); K = size(B,1)
	@assert M == size(A, 1)
    @assert N == size(B, 2)
    @assert size(A, 2) == K
    C .= 0
	for p in 1:K
		for j in 1:N, i in 1:M
	        C[i,j] += A[i,p] * B[p,j]
	    end
	end
	return C
end

function mulCABijpavx!(C, A, B)
	M, N = size(C); K = size(B,1)
	@assert M == size(A, 1)
    @assert N == size(B, 2)
    @assert size(A, 2) == K
    C .= 0
	@avx for i in 1:M, j in 1:N
		for p in 1:K
	        C[i,j] += A[i,p] * B[p,j]
	    end
	end
	return C
end

function mulCABjipavx!(C, A, B)
	M, N = size(C); K = size(B,1)
	@assert M == size(A, 1)
    @assert N == size(B, 2)
    @assert size(A, 2) == K
    C .= 0
	@avx for j in 1:N, i in 1:M
		for p in 1:K
	        C[i,j] += A[i,p] * B[p,j]
	    end
	end
	return C
end

function mulCABipjavx!(C, A, B)
	M, N = size(C); K = size(B,1)
	@assert M == size(A, 1)
    @assert N == size(B, 2)
    @assert size(A, 2) == K
    C .= 0
	@avx for i in 1:M, p in 1:K
		for j in 1:N
	        C[i,j] += A[i,p] * B[p,j]
	    end
	end
	return C
end

function mulCABjpiavx!(C, A, B)
	M, N = size(C); K = size(B,1)
	@assert M == size(A, 1)
    @assert N == size(B, 2)
    @assert size(A, 2) == K
    C .= 0
	@avx for j in 1:N, p in 1:K
		for i in 1:M
	        C[i,j] += A[i,p] * B[p,j]
	    end
	end
	return C
end

function mulCABpijavx!(C, A, B)
	M, N = size(C); K = size(B,1)
	@assert M == size(A, 1)
    @assert N == size(B, 2)
    @assert size(A, 2) == K
    C .= 0
	@avx for p in 1:K
		for i in 1:M, j in 1:N
	        C[i,j] += A[i,p] * B[p,j]
	    end
	end
	return C
end

function mulCABpjiavx!(C, A, B)
	M, N = size(C); K = size(B,1)
	@assert M == size(A, 1)
    @assert N == size(B, 2)
    @assert size(A, 2) == K
    C .= 0
	@avx for p in 1:K
		for j in 1:N, i in 1:M
	        C[i,j] += A[i,p] * B[p,j]
	    end
	end
	return C
end

end # module
