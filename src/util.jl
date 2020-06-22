df = CSV.File("min_max_adj.csv") |> DataFrame!
const MINS = Array{Float64}(df[!, :min])
const MAXS = Array{Float64}(df[!, :adj_max])
const DIFF = MAXS .- MINS
const ON_INP = .~(Bool.(df[!, :off]))

function get_inputs(features::Array{Float64})
    inputs = (lastFeatures .- MINS) ./ DIFF
    inputs = min.(max.(inputs, -1.0), 1.0)
    inputs[ON_INP]
end
