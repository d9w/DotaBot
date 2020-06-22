using DotaBot
using HTTP
using ArgParse
using Sockets
using JSON

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

function get_action(features::Array{Float64})
    println(features[1])
    rand(0:29)
end

@async HTTP.serve(parse(IPAddr, args["agentIP"]), parse(Int, args["agentPort"])) do request::HTTP.Request
   @show request
   @show request.method
   @show HTTP.header(request, "Content-Type")
   @show HTTP.payload(request)
   try
       response = server_handler(request, args, get_action)
       println("responding")
       @show response
       return response
   catch e
       println(e)
       return HTTP.Response(200, JSON.json(Dict("done"=>false)))
   end
end

sleep(1)
start_game(args)
while true
    sleep(0.1)
end
