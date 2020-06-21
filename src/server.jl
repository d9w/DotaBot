export start_game, server_handler

function agent_ip(args::Dict)
    string("http://", args["agentIP"], ":", args["agentPort"])
end

function breezy_ip(args::Dict)
    string("http://", args["breezyIP"], ":", args["breezyPort"])
end

function start_game(args::Dict)
    # build url to dota 2 breezy server
    start_url = string(breezy_ip(args), "/run/")
    start_data = Dict("agent"=>"SuReLI agent", "size"=>1)
    # create a run config for this agent
    HTTP.post(start_url, ["Content-Type" => "application/json"], JSON.json(start_data))
end

function server_handler(request::HTTP.Request, args::Dict, get_action::Function)
    println("handler")
    path = HTTP.URIs.splitpath(request.target)
    println(path[1])
    # path is either an array containing "update" or nothing
    if path[1] == "/update"
        println("Game done.")
        content = JSON.parse(String(request.body))

        # webhook to start new game in existing set of games
        if "webhook" in keys(content)
            # A webhook was sent to the agent to start a new game in the current set of games.
            println(webhookUrl)
            webhook_url = string(breezy_ip(args), content["webhook"])
            # call webhook to trigger new game
            println("Starting a new game among the set")
            HTTP.get(webhookUrl)
        # otherwise start new set of games, or end session
        else
            start_game(args)
        end
        # send response to our server
        return HTTP.Response(200, JSON.json(Dict("done"=>true)))
    else
        println("getting features")
        # relay path gives features from current game to agent
        features = Array{Float64}(JSON.parse(String(request.body)))
        action = get_action(features)
        return HTTP.Response(200, JSON.json(Dict("actionCode"=>action)))
    end
end
