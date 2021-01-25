using Documenter
using CyclicArrays


push!(LOAD_PATH,"../src/")

makedocs(
    sitename = "CyclicArrays",
    format = Documenter.HTML(),
    modules=[CyclicArrays],
    authors="udistr <strobach.ehud@gmail.com>",
    pages = [
    "Home" => "index.md",
    "Main" => "main.md",
    "API Guide" => "API.md"
            ]
)

deploydocs( repo = "github.com/udistr/CyclicArrays.jl.git" )

