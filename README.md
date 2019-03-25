
An oauth module in crystal

### Requierment:
* crystal >= 0.27.2

### Example
```ruby
require "./Myoauth"

CLIENT_ID = ENV["CLIENT_ID"]
CLIENT_SECRET = ENV["CLIENT_SECRET"]

o = Myoauth.new "https://api.intra.42.fr", CLIENT_ID, CLIENT_SECRET
o.get_token_from_credentials()
res = o.get("/v2/users", params: {"page" => { "number" => "2" } })
puts res.body
```

### API
#### Constructor
```crystal
.new(endpoint: String, client_id: String, client_secret: String)
```
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;create a new Myoauth client

#### Instance Methods Summary

```crystal
.get(path: String, params : Hash(String, String) = nil) :
HTTP::Client::Response
```
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Executes a GET request with the params passed as url encoded parameters (WIP). Returns [HTTP::Client::Response](https://crystal-lang.org/api/0.27.2/HTTP/Client/Response.html)
