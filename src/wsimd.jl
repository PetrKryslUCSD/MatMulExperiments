
function mulCABijpsimd!(C, A, B)
	M, N = size(C); K = size(B,1)
	@assert M == size(A, 1)
    @assert N == size(B, 2)
    @assert size(A, 2) == K
    C .= 0
	@inbounds for i in 1:M, j in 1:N
		@inbounds @simd for p in 1:K
	        C[i,j] += A[i,p] * B[p,j]
	    end
	end
	return C
end

function mulCABjipsimd!(C, A, B)
	M, N = size(C); K = size(B,1)
	@assert M == size(A, 1)
    @assert N == size(B, 2)
    @assert size(A, 2) == K
    C .= 0
	@inbounds for j in 1:N, i in 1:M
		@inbounds @simd for p in 1:K
	        C[i,j] += A[i,p] * B[p,j]
	    end
	end
	return C
end

function mulCABipjsimd!(C, A, B)
	M, N = size(C); K = size(B,1)
	@assert M == size(A, 1)
    @assert N == size(B, 2)
    @assert size(A, 2) == K
    C .= 0
	@inbounds for i in 1:M, p in 1:K
		@inbounds @simd for j in 1:N
	        C[i,j] += A[i,p] * B[p,j]
	    end
	end
	return C
end

function mulCABjpisimd!(C, A, B)
	M, N = size(C); K = size(B,1)
	@assert M == size(A, 1)
    @assert N == size(B, 2)
    @assert size(A, 2) == K
    C .= 0
	@inbounds for j in 1:N, p in 1:K
		@inbounds @simd for i in 1:M
	        C[i,j] += A[i,p] * B[p,j]
	    end
	end
	return C
end

function mulCABpijsimd!(C, A, B)
	M, N = size(C); K = size(B,1)
	@assert M == size(A, 1)
    @assert N == size(B, 2)
    @assert size(A, 2) == K
    C .= 0
	@inbounds for p in 1:K
		for i in 1:M
			@inbounds @simd for j in 1:N
		        C[i,j] += A[i,p] * B[p,j]
		    end
		end
	end
	return C
end

function mulCABpjisimd!(C, A, B)
	M, N = size(C); K = size(B,1)
	@assert M == size(A, 1)
    @assert N == size(B, 2)
    @assert size(A, 2) == K
    C .= 0
	@inbounds for p in 1:K
		for j in 1:N
			@inbounds @simd for i in 1:M
	        	C[i,j] += A[i,p] * B[p,j]
	        end
	    end
	end
	return C
end
