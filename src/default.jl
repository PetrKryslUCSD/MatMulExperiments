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
