using PGFPlotsX
using DelimitedFiles

table(foo) = begin
    t = readdlm("$foo.txt", ',')
    n_gflops = @. t[: ,1]^3*2e-9 / t[: ,2]
    [t[: ,1], n_gflops]
end

set = "default"; foos = [:mulCAB!, :gemmblas!, :gemmavx!]; legendstring(foo) = "$foo"
set = "plain"; foos = [:mulCABijp!, :mulCABjip!, :mulCABjpi!, :mulCABipj!, :mulCABpji!, :mulCABpij!]; legendstring(foo) = "$foo"[7:9]
# set = "avx"; foos = [:mulCABijpavx!, :mulCABjipavx!, :mulCABjpiavx!, :mulCABipjavx!, :mulCABpjiavx!, :mulCABpijavx!]; legendstring(foo) = "$foo"[7:9]
# set = "inbounds"; foos = [:mulCABijpinbounds!, :mulCABjipinbounds!, :mulCABjpiinbounds!, :mulCABipjinbounds!, :mulCABpjiinbounds!, :mulCABpijinbounds!]; legendstring(foo) = "$foo"[7:9]
set = "simd"; foos = [:mulCABijpsimd!, :mulCABjipsimd!, :mulCABjpisimd!, :mulCABipjsimd!, :mulCABpjisimd!, :mulCABpijsimd!]; legendstring(foo) = "$foo"[7:9]

markers = ["o", "+", "triangle", "square", "x", "diamond"]

plots = [];

for (foo, m) in zip(foos, markers)
	p = @pgf Plot(
	    {
	        mark  = m,
	        color = "black",
	        "only marks",
	        very_thick
	    },
	    Table(table(foo))
	)
	push!(plots, p);
	push!(plots, LegendEntry(legendstring(foo)));
end


@pgf figure = Axis(
    {
        xmajorgrids,
        ymajorgrids,
        xlabel="Size of the matrix [ND]", ylabel="Speed [GFLOPS]",
        "legend pos"="outer north east"
    },
    plots...
)

pgfsave("gflops-$set.png", figure)