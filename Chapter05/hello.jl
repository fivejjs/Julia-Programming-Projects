using HTTP, Sockets

const HOST = ip"0.0.0.0"
const PORT = 9999

const router = HTTP.Router()

HTTP.@register(router, "GET", "/", req -> HTTP.Response(200, "Hello World"))
HTTP.@register(router, "GET", "/bye", req -> HTTP.Response(200, "Bye"))
HTTP.@register(router, "GET", "*", req -> HTTP.Response(404, "Not found"))

HTTP.serve(router, HOST, PORT)

