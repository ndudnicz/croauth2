require "http/client"
require "json"

class MyOauth
  struct Token
    include JSON::Serializable
    getter access_token : String = String.new
    getter expires_in : Int64 = 0
    getter created_at : Int64 = 0
  end

  @token = Token.from_json(%({}))
  @auth_header = String.new

  def initialize(
    endpoint : String,
    client_id : String,
    client_secret : String
  )
    match = endpoint.match(/^(?<ht>https?):\/\/(?<uri>[^:]+)(:(?<port>[0-9]+))?$/).not_nil!
    @_client_id = client_id
    @_client_secret = client_secret
    @http_client = HTTP::Client.new(
      host: match.named_captures["uri"].to_s,
      port: match.named_captures["port"] ? match.named_captures["port"].to_s : nil,
      tls: match.named_captures["ht"].to_s == "https" ? true : false
    )
  end

  def get_token_from_credentials
    params = HTTP::Params.encode({
      "grant_type" => "client_credentials",
      "client_id" => @_client_id,
      "client_secret" => @_client_secret
    })
    res = @http_client.post("/oauth/token?" + params)
    body_json = JSON.parse(res.body)
    @token = Token.from_json(res.body)

    @http_client.before_request do |request|
      request.headers["Authorization"] = "Bearer " + @token.@access_token
    end

  end

  # TODO: handle params, improve returned value
  def get(
    path : String,
    params  = nil
  )
    @http_client.get(
      path
    )
  end
end


# CLIENT_ID = ENV["CLIENT_ID"]
# CLIENT_SECRET = ENV["CLIENT_SECRET"]
#
# o = MyOauth.new "https://api.intra.42.fr", CLIENT_ID, CLIENT_SECRET
# o.get_token_from_credentials()
# res = o.get("/v2/users", params: {"page" => { "number" => "2" } })
# puts res.body
