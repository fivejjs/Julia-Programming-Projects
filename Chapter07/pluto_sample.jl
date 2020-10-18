### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# ╔═╡ 8f891e2c-1072-11eb-19d0-97bd1b78de3f
using CSV

# ╔═╡ 9ab052dc-1074-11eb-2082-a710d39e9b07
using DataFrames

# ╔═╡ de7f2d62-1074-11eb-27fb-49078f3ff763
using Gadfly

# ╔═╡ 4a299826-1076-11eb-111b-bb93f4d1b75f
using Statistics

# ╔═╡ 5b856314-1131-11eb-31c7-87f2d560ab2f
using MLDataUtils

# ╔═╡ 809e075a-1131-11eb-3c70-954a03dcc993
using Recommendation

# ╔═╡ b2a75f40-1072-11eb-3685-e1db9699cdae
users = CSV.read("data/BX-Users.csv", header=1, delim=';', missingstring="NULL", escapechar='\\')

# ╔═╡ f00c4ac6-1072-11eb-3db1-ad8b2812bbf0
books = CSV.read("data/BX-Books.csv", header = 1, delim = ';', missingstring = "NULL", escapechar = '\\')


# ╔═╡ 8aeb990c-1073-11eb-3789-8318fb637a19
books_ratings = CSV.read("data/BX-Book-Ratings.csv", header = 1, delim = ';', missingstring = "NULL", escapechar = '\\') 

# ╔═╡ b24dcb22-1074-11eb-147f-916dcd879b47
describe(users, stats=[:min, :max, :nmissing, :nunique, :eltype])

# ╔═╡ e9c35874-1074-11eb-3f94-27605e430884
plot(users, x=:Age, Geom.histogram(bincount=15))

# ╔═╡ 12b0cda2-1075-11eb-2c9f-b360b8c2c21f
users[:Age] = coalesce.(users[:Age], mean(skipmissing(users[:Age])))

# ╔═╡ 59078ccc-1076-11eb-2e41-d3f2b566e68a
users1 = users[users[:Age] .< 100, :]

# ╔═╡ 781ef8d4-1076-11eb-1297-95b6c079f48b
head(users1)

# ╔═╡ 87424406-1076-11eb-1daf-e1d622b1ec7b
describe(books, stats=[:nmissing, :nunique, :eltype])

# ╔═╡ b6fd4470-1076-11eb-3eb7-ff85177ac8e3
maximum(skipmissing(books[Symbol("Year-Of-Publication")]))

# ╔═╡ c743c3a6-1076-11eb-2433-ad9e0b69e8e7
minimum(skipmissing(books[Symbol("Year-Of-Publication")]))

# ╔═╡ edddf796-1076-11eb-3622-e702a3518578
plot(books, x = Symbol("Year-Of-Publication"), Geom.histogram)

# ╔═╡ 1434ccda-1077-11eb-1a88-f79b42e1c16a
unique(books[Symbol("Year-Of-Publication")]) |> sort

# ╔═╡ 541172f4-1077-11eb-1495-e5e0e8c879bb
books1 = books[(books[Symbol("Year-Of-Publication")] .> 1970) .& 
	(books[Symbol("Year-Of-Publication")] .<= 2004), :]

# ╔═╡ a1a35816-1077-11eb-1713-73cd86a00ee7
plot(books1, x = Symbol("Year-Of-Publication"), Geom.histogram)

# ╔═╡ b2eef102-1077-11eb-0962-f1b396905180
describe(books_ratings)

# ╔═╡ d278bc32-1111-11eb-21ca-df2281d8d8e2
plot(books_ratings, x=Symbol("Book-Rating"), Geom.histogram)

# ╔═╡ 119663ee-1112-11eb-0407-f1720ff80ef1
books_ratings2 = books_ratings[books_ratings[Symbol("Book-Rating")] .> 0, :]

# ╔═╡ 2d290256-1112-11eb-3605-cd282f54b19c
plot(books_ratings2, x=Symbol("Book-Rating"), Geom.histogram)

# ╔═╡ dfec00f2-111c-11eb-375c-192e5699bbf3
books_raitings_books = join(books_ratings, books, on= :ISBN, kind = :inner)

# ╔═╡ 0bd3812a-111d-11eb-24ba-ed52f7ab4e21
books_ratings_books_users = join(books_raitings_books, users, on=Symbol("User-ID"), 
	kind= :inner)

# ╔═╡ 5db8cc0c-111d-11eb-2fd1-33790ca4e28a
top_ratings = books_ratings_books_users[books_ratings_books_users[Symbol("Book-Rating")] .>= 8, :]

# ╔═╡ 9a93ed8c-111d-11eb-0322-0f632d519cd2
for n in names(top_ratings)
	rename!(top_ratings, n => Symbol(replace(string(n), "-" => "")))
end

# ╔═╡ b029cecc-111e-11eb-0819-65a10c645cc8
names(top_ratings)

# ╔═╡ b5799f6a-111e-11eb-0a17-57a0fbdaf299
ratings_count = by(top_ratings, :UserID, df -> size(df[:UserID])[1])

# ╔═╡ e04f8204-111e-11eb-1788-cd55a4b6eefa
describe(ratings_count)

# ╔═╡ e81c07be-111e-11eb-006e-ff0068cfa4f1
ratings_count1 = ratings_count[ratings_count[:x1] .>= 5, :]

# ╔═╡ 014c47bc-111f-11eb-0156-433ca9534ff0
plot(ratings_count1, x=:x1, Geom.histogram(maxbincount = 6))

# ╔═╡ 1e4fa802-111f-11eb-0d16-3ba21da5c185
ratings_count[ratings_count[:x1] .> 1000, :] 

# ╔═╡ 2db787f8-111f-11eb-26e8-25d916ff0904
ratings_count2 = ratings_count[ratings_count[:x1] .<= 1000, :]

# ╔═╡ 45526edc-111f-11eb-2966-d92942ef25ed
top_ratings1 = join(top_ratings, ratings_count, on = :UserID, kind = :inner)

# ╔═╡ 62137e94-111f-11eb-1286-45e994d7a5ba
CSV.write("data/top_ratings.csv", top_ratings1, delim="|")

# ╔═╡ 8d485cba-111f-11eb-38d7-6b428fae156a
import Pkg

# ╔═╡ ba5e9c78-112e-11eb-221c-d7529139a44e
Pkg.add("MLDataUtils")

# ╔═╡ c31b7ab6-112e-11eb-2ddd-5d894d6eaa8e
train, test = splitobs(top_ratings1, at = 0.9)

# ╔═╡ 68b7f092-1131-11eb-1068-d311515a82d7
size(train), size(test)

# ╔═╡ 9c3d09ac-1131-11eb-17b4-5b5a79cb594a
unique(train[:UserID]) |> size

# ╔═╡ d25483ee-1131-11eb-1e44-ad17a439597a
user_mappings, book_mappings = Dict{Int, Int}(), Dict{String, Int}()

# ╔═╡ 5ae922d2-1132-11eb-2168-ad6b229b5b11
haskey

# ╔═╡ 09456864-1132-11eb-0bbf-314826d3bf2d
begin
	events1 = Recommendation.Event[]
	user_counter, book_counter = 0, 0
	for row in eachrow(train)
		global user_counter, book_counter, events1
		user_id, book_id, rating = row[:UserID], row[:ISBN], row[:BookRating]
		haskey(user_mappings, user_id) || (user_mappings[user_id] = (user_counter += 1))
		haskey(book_mappings, book_id) || (book_mappings[book_id] = (book_counter += 1))
		push!(events1, Event(user_mappings[user_id], book_mappings[book_id], rating))

	end
end

 

# ╔═╡ df5271a4-1132-11eb-23dd-b90676b2c2f5
size(events1)

# ╔═╡ e7064812-1132-11eb-20fc-5fc78b690176
events1

# ╔═╡ 328c7f0e-1133-11eb-074f-0b868c348ecb
user_counter, book_counter

# ╔═╡ 4cd2f622-1133-11eb-3b8b-77d99e78724b
typeof(events1)

# ╔═╡ f7184d36-1132-11eb-1322-bb8d69896080
da = DataAccessor(events1, user_counter, book_counter)

# ╔═╡ 271808b6-1136-11eb-1567-e9ea1279da80
recommender = MF(da)

# ╔═╡ 39804d06-1136-11eb-109f-2382d2c980cc
build!(recommender)

# ╔═╡ 3923f542-1136-11eb-0ed3-ff4f3f517556


# ╔═╡ Cell order:
# ╠═8f891e2c-1072-11eb-19d0-97bd1b78de3f
# ╠═b2a75f40-1072-11eb-3685-e1db9699cdae
# ╠═f00c4ac6-1072-11eb-3db1-ad8b2812bbf0
# ╠═8aeb990c-1073-11eb-3789-8318fb637a19
# ╠═9ab052dc-1074-11eb-2082-a710d39e9b07
# ╠═b24dcb22-1074-11eb-147f-916dcd879b47
# ╠═de7f2d62-1074-11eb-27fb-49078f3ff763
# ╠═e9c35874-1074-11eb-3f94-27605e430884
# ╠═4a299826-1076-11eb-111b-bb93f4d1b75f
# ╠═12b0cda2-1075-11eb-2c9f-b360b8c2c21f
# ╠═59078ccc-1076-11eb-2e41-d3f2b566e68a
# ╠═781ef8d4-1076-11eb-1297-95b6c079f48b
# ╠═87424406-1076-11eb-1daf-e1d622b1ec7b
# ╠═b6fd4470-1076-11eb-3eb7-ff85177ac8e3
# ╠═c743c3a6-1076-11eb-2433-ad9e0b69e8e7
# ╠═edddf796-1076-11eb-3622-e702a3518578
# ╠═1434ccda-1077-11eb-1a88-f79b42e1c16a
# ╠═541172f4-1077-11eb-1495-e5e0e8c879bb
# ╠═a1a35816-1077-11eb-1713-73cd86a00ee7
# ╠═b2eef102-1077-11eb-0962-f1b396905180
# ╠═d278bc32-1111-11eb-21ca-df2281d8d8e2
# ╠═119663ee-1112-11eb-0407-f1720ff80ef1
# ╠═2d290256-1112-11eb-3605-cd282f54b19c
# ╠═dfec00f2-111c-11eb-375c-192e5699bbf3
# ╠═0bd3812a-111d-11eb-24ba-ed52f7ab4e21
# ╠═5db8cc0c-111d-11eb-2fd1-33790ca4e28a
# ╠═9a93ed8c-111d-11eb-0322-0f632d519cd2
# ╠═b029cecc-111e-11eb-0819-65a10c645cc8
# ╠═b5799f6a-111e-11eb-0a17-57a0fbdaf299
# ╠═e04f8204-111e-11eb-1788-cd55a4b6eefa
# ╠═e81c07be-111e-11eb-006e-ff0068cfa4f1
# ╠═014c47bc-111f-11eb-0156-433ca9534ff0
# ╠═1e4fa802-111f-11eb-0d16-3ba21da5c185
# ╠═2db787f8-111f-11eb-26e8-25d916ff0904
# ╠═45526edc-111f-11eb-2966-d92942ef25ed
# ╠═62137e94-111f-11eb-1286-45e994d7a5ba
# ╠═8d485cba-111f-11eb-38d7-6b428fae156a
# ╠═ba5e9c78-112e-11eb-221c-d7529139a44e
# ╠═5b856314-1131-11eb-31c7-87f2d560ab2f
# ╠═c31b7ab6-112e-11eb-2ddd-5d894d6eaa8e
# ╠═68b7f092-1131-11eb-1068-d311515a82d7
# ╠═809e075a-1131-11eb-3c70-954a03dcc993
# ╠═9c3d09ac-1131-11eb-17b4-5b5a79cb594a
# ╠═d25483ee-1131-11eb-1e44-ad17a439597a
# ╠═5ae922d2-1132-11eb-2168-ad6b229b5b11
# ╠═09456864-1132-11eb-0bbf-314826d3bf2d
# ╠═df5271a4-1132-11eb-23dd-b90676b2c2f5
# ╠═e7064812-1132-11eb-20fc-5fc78b690176
# ╠═328c7f0e-1133-11eb-074f-0b868c348ecb
# ╠═4cd2f622-1133-11eb-3b8b-77d99e78724b
# ╠═f7184d36-1132-11eb-1322-bb8d69896080
# ╠═271808b6-1136-11eb-1567-e9ea1279da80
# ╠═39804d06-1136-11eb-109f-2382d2c980cc
# ╠═3923f542-1136-11eb-0ed3-ff4f3f517556
