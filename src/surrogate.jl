export get_model_action

function get_model_action(features::Array{Float64}, model)
    inputs = get_inputs(features)
    rewards = zeros(Float32, 30)
    for i in eachindex(rewards)
        actions = 0:29 .== i
        rewards[i] = model([inputs; actions])[1]
    end
    if maximum(rewards) > minimum(rewards)
        return argmax(rewards)-1
    end
    rand(0:29)
end

