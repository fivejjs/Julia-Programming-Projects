### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# ╔═╡ 4126f216-1137-11eb-2664-4b5adfacb457
typeof(:x)

# ╔═╡ 7c02abbc-1139-11eb-266c-31b55996d46a
eval(:(x=2))

# ╔═╡ 94130d6c-1139-11eb-0cd8-bb4551bf0768
assign = :(x=2)

# ╔═╡ 9c256f60-1139-11eb-0b18-d9ec46a47a06
fieldnames(typeof(assign))

# ╔═╡ a8abf2cc-1139-11eb-2c82-b169d833a490
dump(assign)

# ╔═╡ d1334dbc-1139-11eb-0bae-edd241b8604d
assign.args[2] = 3

# ╔═╡ daefad96-1139-11eb-2932-053ac99f38d0
eval(assign)

# ╔═╡ 01914cf4-113a-11eb-00b3-53a43d93d8ee
assign4 = Expr(:(=), :xx, 4)

# ╔═╡ 0dde46a2-113a-11eb-014f-931fb94c7f38
eval(assign4)

# ╔═╡ Cell order:
# ╠═4126f216-1137-11eb-2664-4b5adfacb457
# ╠═7c02abbc-1139-11eb-266c-31b55996d46a
# ╠═94130d6c-1139-11eb-0cd8-bb4551bf0768
# ╠═9c256f60-1139-11eb-0b18-d9ec46a47a06
# ╠═a8abf2cc-1139-11eb-2c82-b169d833a490
# ╠═d1334dbc-1139-11eb-0bae-edd241b8604d
# ╠═daefad96-1139-11eb-2932-053ac99f38d0
# ╠═01914cf4-113a-11eb-00b3-53a43d93d8ee
# ╠═0dde46a2-113a-11eb-014f-931fb94c7f38
