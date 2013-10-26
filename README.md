# Spoofer, simple web service stubs for testing [![Build Status](https://secure.travis-ci.org/jsmestad/spoofer.png)](https://secure.travis-ci.org/jsmestad/spoofer)


## What is Spoofer?

Spoofer is a fork of the [Mimic Ruby Gem]() project. It was not being actively maintained anymore and decided to create a new fork using Mimic as a basis.

If your unfamiliar with the Mimic gem, then... Spoofer is a testing tool that lets you set create a fake stand-in for an external web service to be used when writing integration/end-to-end tests for applications or libraries that access these services.

## Why not stub?
There are already some good tools, like [FakeWeb](http://fakeweb.rubyforge.org/) which let you stub requests at a low-level which is fine for unit and functional tests but when exercising our code through integration or end-to-end tests we want to exercise as much of the stack as possible.

Spoofer aims to make it possible to test your networking code without actually hitting the real services by starting up a real web server and responding to HTTP requests. This lets you test your application against canned responses in an as-close-to-the-real-thing-as-possible way.

Also, because Spoofer responds to real HTTP requests, it can be used when testing non-Ruby applications too.

## Examples

Registering to a single request stub:

    Spoofer.mimic.get("/some/path").returning("hello world")

And the result, using RestClient:

    $ RestClient.get("http://www.example.com:11988/some/path") # => 200 | hello world

Registering multiple request stubs; note that you can stub the same path with different HTTP methods separately.

    Spoofer.mimic do
      get("/some/path").returning("Hello World", 200)
      get("/some/other/path").returning("Redirecting...", 301, {"Location" => "somewhere else"})
      post("/some/path").returning("Created!", 201)
    end

You can even use Rack middlewares, e.g. to handle common testing scenarios such as authentication:

    Spoofer.mimic do
      use Rack::Auth::Basic do |user, pass|
        user == 'theuser' and pass == 'thepass'
      end

      get("/some/path")
    end

Finally, because Spoofer is built on top of Sinatra for the core request handling, you can create your stubbed requests like you would in any Sinatra app:

    Spoofer.mimic do
      get "/some/path" do
        [200, {}, "hello world"]
      end
    end

## Using Spoofer with non-Ruby processes

Spoofer has a built-in REST API that lets you configure your request stubs over HTTP. This makes it possible to use Spoofer from other processes that can perform HTTP requests.

First of all, you'll need to run Spoofer as a daemon. You can do this with a simple Ruby script and the [daemons](http://daemons.rubyforge.org/) gem:

    #!/usr/bin/env ruby
    require 'spoofer'
    require 'daemons'

    Daemons.run_proc("mimic") do
      Spoofer.mimic(:port => 11988, :fork => false, :remote_configuration_path => '/api') do
        # configure your stubs here
      end
    end

Give the script executable permissions and then start it:

    $ your_spoofer_script.rb start (or run)

The remote configuration path is where the API endpoints will be mounted - this is configurable as you will not be able this path or any paths below it in your stubs, so choose one that doesn't conflict with the paths you need to stub.

The API supports both JSON and Plist payloads, defaulting to JSON. Set the request Content-Type header to application/plist for Plist requests.

For the following Spoofer configuration (using the Ruby DSL):

    Spoofer.mimic.get("/some/path").returning("hello world")

The equivalent stub can be configured using the REST API as follows:

    $ curl -d'{"path":"/some/path", "body":"hello world"}' http://localhost:11988/api/get

Likewise, a POST request to the same path could be stubbed like so:

    $ curl -d'{"path":"/some/path", "body":"hello world"}' http://localhost:11988/api/post

The end-point of the API is the HTTP verb you are stubbing, the path, response body, code and headers are specified in the POST data (a hash in JSON or Plist format). See the HTTP API Cucumber features for more examples.

## License

See LICENSE file distributed with this gem.
