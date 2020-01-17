using MatMulExperiments: mulCAB!, gemmblas!, gemmavx!
using MatMulExperiments: mulCABijp!, mulCABjip!, mulCABjpi!, mulCABipj!, mulCABpji!, mulCABpij!
using MatMulExperiments: mulCABijpavx!, mulCABjipavx!, mulCABjpiavx!, mulCABipjavx!, mulCABpjiavx!, mulCABpijavx!
using LinearAlgebra
using Test
using BenchmarkTools
using DelimitedFiles

function testf(f, C, A, B)
	@test norm(f(C, A, B) - A * B) / norm(C) <= 1.0e-9
	return @belapsed $f($C, $A, $B)
end


foos = [mulCAB!, gemmblas!, gemmavx!]
foos = [mulCABijp!, mulCABjip!, mulCABjpi!, mulCABipj!, mulCABpji!, mulCABpij!]
foos = [mulCABijpavx!, mulCABjipavx!, mulCABjpiavx!, mulCABipjavx!, mulCABpjiavx!, mulCABpijavx!]

ns = 2:20:400
Cs, As, Bs = Dict(), Dict(), Dict()
for n in ns
	C, A, B = rand(n, n), rand(n, n), rand(n, n)
	Cs[n] = deepcopy(C)
	As[n] = deepcopy(A)
	Bs[n] = deepcopy(B)
end


BLAS.set_num_threads(1)
dts = Dict()
for foo in foos
	ts = Float64[]
	for n in ns
		C, A, B = deepcopy(Cs[n]), deepcopy(As[n]), deepcopy(Bs[n])
		t = testf(foo, C, A, B)
		push!(ts, t)
	end
	dts[nameof(foo)] = ts
	open("$foo.txt", "w") do io
		writedlm(io, [ns ts], ',')
	end;
end
@show dts

