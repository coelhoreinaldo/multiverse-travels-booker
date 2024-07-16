class Cors
  include HTTP::Handler

  getter origin : String

  def initialize(@origin)
  end

  def call(context)
    context.response.headers["Access-Control-Allow-Methods"] = "GET, PUT, POST, DELETE, LOAD, PATCH"
    context.response.headers["Access-Control-Request-Headers"] = "Content-Type, *"
    context.response.headers["Access-Control-Allow-Headers"] = "authorization"
    context.response.headers["Access-Control-Allow-Origin"] = origin
    context.response.headers["Access-Control-Allow-Credentials"] = "true"
    context.response.headers["Access-Control-Max-Age"] = "1728000"

    if context.request.method.downcase == "options"
      context.response.content_type = "text/html; charset=utf-8"
      context.response.status_code = 200
      context.response.print("")
    else
      call_next context
    end
  end
end

add_handler Cors.new("http://127.0.0.1:3001") # TODO: env
