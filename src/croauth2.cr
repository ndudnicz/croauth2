require "http/client"
require "json"
require "uri"

require "crtimestamp"

class Croauth2
  struct Token
    include JSON::Serializable
    @access_token : String = String.new
    @expires_in : Int32 = 0
    @created_at : Int32 = 0
  end

  @_token : Token
  @_http_client : HTTP::Client
  @_token_expires_at : Int64

  def initialize(
    endpoint : String,
    client_id : String,
    client_secret : String
  )
    uri = URI.parse endpoint
    @_client_id = client_id
    @_client_secret = client_secret
    @_http_client = HTTP::Client.new(
      host: uri.host.as(String),
      port: uri.port ? uri.port.as(Int32) : nil,
      tls: uri.scheme == "https" ? true : false
    ).not_nil!
    @endpoint = endpoint
    @_token = nil
    @_token_expires_at = 0
  end

  def get_token_from_credentials : Token
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
    @_token_expires_at = Crtimestamp.now_utc_to_unix + @_token.@expires_in

    @_http_client.before_request do |request|
      request.headers["Authorization"] = "Bearer " + @_token.@access_token
    end
    token
  end

  # TODO: handle params
  def get(
    path : String,
    params  = nil
  ) : HTTP::Client::Response
    @_http_client.get(
      path
    )
  end

  def token : Token
    @_token
  end

  def token_expires_at : Int64
    @_token_expires_at
  end
end
