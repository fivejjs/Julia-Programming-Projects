import HTTP

HTTP.listen("127.0.0.1", 8081) do http
    HTTP.setheader(http, "Content-Type" => "text/html")
    write(http, "target uri: $(http.message.target)<BR>")
    write(http, "request body:<BR><PRE>")
    write(http, read(http))
    write(http, "</PRE>")
    return
end