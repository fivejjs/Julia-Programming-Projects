using Pkg
Pkg.activate(".")
Pkg.instantiate()
Pkg.resolve()

include("Database.jl")
include("Wikipedia.jl")
include("Gameplay.jl")
include("GameSession.jl")
include("WebApp.jl")

using .Wikipedia, .Gameplay, .GameSession, .WebApp
