require "Traitify"
require "webmock/rspec"
require "pry"

Dir[File.expand_path("spec/support/**/*.rb", __FILE__)].each{|f| require f}

RSpec.configure do |config|
  config.color = true
  config.order = "random"
end

def stub_it(http_method = :any, endpoint = "/", options = {}, status = 200, response)
  url = "https://secret:x@example.com/v1#{endpoint}"
  stub = stub_request(http_method, url)
  stub = stub.with(body: options[:body].to_json) if options[:body]
  stub.to_return(
    status: status,
    body: File.read(File.expand_path("../support/mocks/#{response}.json", __FILE__)),
    headers: { 'Content-type' => "application/json" }
  )
end
