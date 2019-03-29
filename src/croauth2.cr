require "http/client"
require "json"
require "uri"

require "crtimestamp"

# epoch's timestamp in seconds since `0001-01-01 00:00:00`
EPOCH_SECONDS_TIMESTAMP = 62135596800_i64

class Myoauth2
  struct Token
    include JSON::Serializable
    @access_token : String = String.new
    @expires_in : Int32 = 0
    @created_at : Int32 = 0
  end

  @_token : Token = Token.from_json(%({}))
  @_http_client : HTTP::Client = HTTP::Client.new("")
  @_token_expires_at : Int64 = 0

  def initialize(
    endpoint : String,
    client_id : String,
    client_secret : String
  )
    uri = URI.parse endpoint
    match = endpoint.match(/^(?<ht>https?):\/\/(?<uri>[^:]+)(:(?<port>[0-9]+))?$/).not_nil!
    @_client_id = client_id
    @_client_secret = client_secret
    @_http_client = HTTP::Client.new(
      host: uri.host,
      port: uri.port ? uri.port : nil,
      tls: uri.scheme == "https" ? true : false
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
    @_token_expires_at = Crtimestamp.now_utc_to_unix - EPOCH_SECONDS_TIMESTAMP + @_token.@expires_in

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

  def token : Token
    @_token
  end

  def token_expires_at : Int64
    @_token_expires_at
  end
end
