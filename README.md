An oauth2 module in crystal

### Requirement:
* crystal >= 0.27.2

### Installation :
Add this to your application's `shard.yml`:
```yaml
dependencies:
  croauth2:
    github: ndudnicz/croauth2
```

### Example
```ruby
require "croauth2"

CLIENT_ID = ENV["CLIENT_ID"]
CLIENT_SECRET = ENV["CLIENT_SECRET"]

o = Croauth2.new "https://api.intra.42.fr", CLIENT_ID, CLIENT_SECRET
o.get_token_from_credentials()
res = o.get("/v2/users", params: {"page" => { "number" => "2" } })
puts res.body
```

### API
#### Constructor
```ruby
.new(endpoint: String, client_id: String, client_secret: String)
```
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;create a new Myoauth2 client

#### Instance Methods Summary

```ruby
.get(path: String, params : Hash(String, String) = nil) :
HTTP::Client::Response
```
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Executes a GET request with the params passed as url encoded parameters (WIP). Returns [HTTP::Client::Response](https://crystal-lang.org/api/0.27.2/HTTP/Client/Response.html)

#### Getters
```ruby
.token :
Myoauth2::Token
# struct Token
#   include JSON::Serializable
#   @access_token : String = String.new
#   @expires_in : Int32 = 0
#   @created_at : Int32 = 0
# end
```
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Returns the token object Myoauth2::Token


```ruby
.token_expires_at :
Int64
```
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Returns the timestamp that the token will expire at.
