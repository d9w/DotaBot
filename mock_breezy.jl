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

@async HTTP.serve(parse(IPAddr, args["breezyIP"]), parse(Int, args["breezyPort"])) do request::HTTP.Request
   @show request
   @show request.method
   @show HTTP.header(request, "Content-Type")
   @show HTTP.payload(request)
   try
       return HTTP.Response(200, "okay")
   catch e
       println(e)
       return HTTP.Response(404, "Error: $e")
   end
end

sleep(1)
global i = 1
while true
    if mod(i, 10) == 0
        HTTP.post(string(DotaBot.agent_ip(args), "/update"), ["Content-Type" => "application/json"],
                  JSON.json(Dict("status"=>"DONE")))
    else
        features = rand(3)
        println(features[1])
        HTTP.post(string(DotaBot.agent_ip(args), "/"),
                  ["Content-Type" => "application/json"], JSON.json(features))
    end
    sleep(0.1)
    global i += 1
end

