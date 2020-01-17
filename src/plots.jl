using PGFPlotsX
using DelimitedFiles

table(foo) = begin
    t = readdlm("$foo.txt", ',')
    n_gflops = @. t[: ,1]^3*2e-9 / t[: ,2]
    [t[: ,1], n_gflops]
end

# foos = [:mulCAB!, :gemmblas!, :gemmavx!]
foos = [:mulCABijp!, :mulCABjip!, :mulCABjpi!, :mulCABipj!, :mulCABpji!, :mulCABpij!]
# foos = [:mulCABijpavx!, :mulCABjipavx!, :mulCABjpiavx!, :mulCABipjavx!, :mulCABpjiavx!, :mulCABpijavx!]
markers = ["o", "+", "triangle", "square", "x", "diamond"]
# \pgfplotscreateplotcyclelist{my black white}{%
# solid, every mark/.append style={solid, fill=gray}, mark=*\\%
# dotted, every mark/.append style={solid, fill=gray}, mark=square*\\%
# densely dotted, every mark/.append style={solid, fill=gray}, mark=otimes*\\%
# loosely dotted, every mark/.append style={solid, fill=gray}, mark=triangle*\\%
# dashed, every mark/.append style={solid, fill=gray},mark=diamond*\\%
# loosely dashed, every mark/.append style={solid, fill=gray},mark=*\\%
# densely dashed, every mark/.append style={solid, fill=gray},mark=square*\\%
# dashdotted, every mark/.append style={solid, fill=gray},mark=otimes*\\%
# dashdotdotted, every mark/.append style={solid},mark=star\\%
# densely dashdotted,every mark/.append style={solid, fill=gray},mark=diamond*\\%
# }

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
	push!(plots, LegendEntry("$foo"[7:9]));
end


@pgf figure = Axis(
    {
        xmajorgrids,
        ymajorgrids,
        xlabel="Size of the matrix [ND]", ylabel="Speed [GFLOPS]"
    },
    plots...
)

pgfsave("gflops-slow.pdf", figure)