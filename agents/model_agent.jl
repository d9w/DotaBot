using DotaBot
using HTTP
using ArgParse
using Sockets
using JSON
using Flux
using Flux.Data: DataLoader
using Flux: @epochs
using CUDAapi
using BSON: @save, @load
if has_cuda()
    import CuArrays
    using CUDAdrv
    CuArrays.allowscalar(false)
end

s = ArgParseSettings()
@add_arg_table! s begin
    "--breezyIP"
    help = "breezy server IP adress"
    default = "127.0.0.1"
    "--breezyPort"
    help = "breezy server port number"
    default = "8085"
    "--agentIP"
    help = "agent server IP adress"
    default = "127.0.0.1"
    "--agentPort"
    help = "agent server port number"
    default = "8086"
end

args = parse_args(ARGS, s)

println("loading model")
@load "models/reward_model_2.bson" cm2

println("starting server")
@async HTTP.serve(parse(IPAddr, args["agentIP"]), parse(Int, args["agentPort"])) do request::HTTP.Request
   @show request
   try
       f_act(features) = get_model_action(features, cm2)
       response = server_handler(request, args, f_act)
       @show response
       return response
   catch e
       println(e)
       return HTTP.Response(200, JSON.json(Dict("done"=>false)))
   end
end

println("starting game")
start_game(args)

while true
    sleep(1)
end
