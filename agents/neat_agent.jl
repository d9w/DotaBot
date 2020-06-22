using DotaBot
using HTTP
using ArgParse
using Sockets
using JSON
using NEAT

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
    "--ind"
    help = "NEAT individual DNA file"
    default = "models/neat1.dna"
    "--cfg"
    help = "NEAT config file"
    default = "config/neat.yaml"
end

args = parse_args(ARGS, s)
cfg = get_config(args["cfg"])
dna = JSON.parsefile(args["ind"])
individual = NEATInd(cfg, JSON.json(dna))

@async HTTP.serve(parse(IPAddr, args["agentIP"]), parse(Int, args["agentPort"])) do request::HTTP.Request
   @show request
   try
       f_act(features) = get_indiv_action(features, individual)
       response = server_handler(request, args, f_act)
       @show response
       return response
   catch e
       println(e)
       return HTTP.Response(200, JSON.json(Dict("done"=>false)))
   end
end

start_game(args)
while true
    sleep(1)
end
