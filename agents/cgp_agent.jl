using DotaBot
using HTTP
using ArgParse
using Sockets
using JSON
using CartesianGeneticProgramming

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
    help = "CGP individual DNA file"
    default = "models/cgp1.dna"
    "--cfg"
    help = "CGP config file"
    default = "config/cgp.yaml"
end

args = parse_args(ARGS, s)
cfg = get_config(args["cfg"])
dna = JSON.parsefile(args["ind"])
individual = CGPInd(cfg, Array{Float64}(dna["chromosome"]))

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
