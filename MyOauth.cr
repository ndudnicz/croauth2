require "http/client"
require "json"

class Myoauth
  struct Token
    include JSON::Serializable
    @access_token : String = String.new
    @expires_in : Int64 = 0
    @created_at : Int64 = 0
  end

  @_token = Token.from_json(%({}))
  @_http_client = HTTP::Client.new("")

  def initialize(
    endpoint : String,
    client_id : String,
    client_secret : String
  )
    match = endpoint.match(/^(?<ht>https?):\/\/(?<uri>[^:]+)(:(?<port>[0-9]+))?$/).not_nil!
    @_client_id = client_id
    @_client_secret = client_secret
    @_http_client = HTTP::Client.new(
      host: match.named_captures["uri"].to_s,
      port: match.named_captures["port"] ? match.named_captures["port"].to_s : nil,
      tls: match.named_captures["ht"].to_s == "https" ? true : false
    ).not_nil!
    @endpoint = endpoint
  end

  def get_token_from_credentials
    params = HTTP::Params.encode({
      "grant_type" => "client_credentials",
      "client_id" => @_client_id,
      "client_secret" => @_client_secret
    })
    res = @_http_client.post("/oauth/token?" + params)
    res.not_nil!
    begin
      body_json = JSON.parse(res.body)
    rescue ex
      puts res.body
      puts "Invalid end point : " + @endpoint + " ?"
      raise "Error: " + ex.message.to_s
    end
    @_token = Token.from_json(res.body)

    @_http_client.before_request do |request|
      request.headers["Authorization"] = "Bearer " + @_token.@access_token
    end
  end

  # TODO: handle params, improve returned value
  def get(
    path : String,
    params  = nil
  )
    @_http_client.get(
      path
    )
  end

  def token
    @_token
  end
end
