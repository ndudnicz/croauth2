require "./Myoauth"

CLIENT_ID = ENV["CLIENT_ID"]
CLIENT_SECRET = ENV["CLIENT_SECRET"]

begin
  o = Myoauth.new "http://api.intra.42.fr", CLIENT_ID, CLIENT_SECRET
  o.get_token_from_credentials()
  res = o.get("/v2/users", params: {"page" => { "number" => "2" } })
  puts res.body
rescue ex
  puts ex.message
end
