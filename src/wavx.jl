
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
