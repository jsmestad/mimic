Feature: Configuring Spoofer via an HTTP interface
  In order to use Spoofer stubs from non-Ruby test cases
  As a developer
  I want to be able to configure a background Spoofer process using an HTTP REST API
  
  Scenario: Pinging Spoofer via the API to check it's running
    Given that Spoofer is running and accepting remote configuration on "/api"
    When I make an HTTP GET request to "http://localhost:11988/api/ping"
    Then I should receive an HTTP 200 response with a body matching "OK"
    
  Scenario: Stubbing a request path via GET using the HTTP API
    Given that Spoofer is running and accepting remote configuration on "/api"
    When I make an HTTP POST request to "http://localhost:11988/api/get" with the payload:
      """
        {"path": "/anything"}
      """
    Then I should receive an HTTP 201 response
    And I make an HTTP GET request to "http://localhost:11988/anything"
    Then I should receive an HTTP 200 response with an empty body
    
  Scenario: Stubbing a request path via POST the HTTP API
    Given that Spoofer is running and accepting remote configuration on "/api"
    When I make an HTTP POST request to "http://localhost:11988/api/post" with the payload:
      """
        {"path": "/anything"}
      """
    Then I should receive an HTTP 201 response
    And I make an HTTP POST request to "http://localhost:11988/anything"
    Then I should receive an HTTP 200 response with an empty body
  
  Scenario: Stubbing a request path via PUT using the HTTP API
    Given that Spoofer is running and accepting remote configuration on "/api"
    When I make an HTTP POST request to "http://localhost:11988/api/put" with the payload:
      """
        {"path": "/anything"}
      """
    Then I should receive an HTTP 201 response
    And I make an HTTP PUT request to "http://localhost:11988/anything"
    Then I should receive an HTTP 200 response with an empty body

  Scenario: Stubbing a request path via DELETE the HTTP API for a
    Given that Spoofer is running and accepting remote configuration on "/api"
    When I make an HTTP POST request to "http://localhost:11988/api/delete" with the payload:
      """
        {"path": "/anything"}
      """
    Then I should receive an HTTP 201 response
    And I make an HTTP DELETE request to "http://localhost:11988/anything"
    Then I should receive an HTTP 200 response with an empty body
    
  Scenario: Stubbing a request path via HEAD using the HTTP API
    Given that Spoofer is running and accepting remote configuration on "/api"
    When I make an HTTP POST request to "http://localhost:11988/api/head" with the payload:
      """
        {"path": "/anything"}
      """
    Then I should receive an HTTP 201 response
    And I make an HTTP HEAD request to "http://localhost:11988/anything"
    Then I should receive an HTTP 200 response with an empty body

  Scenario: Stubbing a request path to return a custom response body
    Given that Spoofer is running and accepting remote configuration on "/api"
    When I make an HTTP POST request to "http://localhost:11988/api/get" with the payload:
      """
        {"path": "/anything", "body": "Hello World"}
      """
    Then I should receive an HTTP 201 response
    And I make an HTTP GET request to "http://localhost:11988/anything"
    Then I should receive an HTTP 200 response with a body matching "Hello World"
    
  Scenario: Stubbing a request path to return a custom status code
    Given that Spoofer is running and accepting remote configuration on "/api"
    When I make an HTTP POST request to "http://localhost:11988/api/get" with the payload:
      """
        {"path": "/anything", "code": 301}
      """
    Then I should receive an HTTP 201 response
    And I make an HTTP GET request to "http://localhost:11988/anything"
    Then I should receive an HTTP 301 response with an empty body
    
  Scenario: Stubbing a request path to return custom headers
    Given that Spoofer is running and accepting remote configuration on "/api"
    When I make an HTTP POST request to "http://localhost:11988/api/get" with the payload:
      """
        {"path": "/anything", "headers": {"X-TEST-HEADER": "TESTING"}}
      """
    Then I should receive an HTTP 201 response
    And I make an HTTP GET request to "http://localhost:11988/anything"
    Then I should receive an HTTP 200 response with the value "TESTING" for the header "X-TEST-HEADER"
    
  Scenario: Stubbing a request path that only matches with the right query params
    Given that Spoofer is running and accepting remote configuration on "/api"
    When I make an HTTP POST request to "http://localhost:11988/api/get" with the payload:
      """
        {"path": "/anything", "params": {"foo": "bar"}}
      """
    Then I should receive an HTTP 201 response
    And I make an HTTP GET request to "http://localhost:11988/anything"
    Then I should receive an HTTP 404 response
    And I make an HTTP GET request to "http://localhost:11988/anything?foo=bar"
    Then I should receive an HTTP 200 response
    
  Scenario: Stubbing a request to echo it's request 
    Given that Spoofer is running and accepting remote configuration on "/api"
    When I make an HTTP POST request to "http://localhost:11988/api/get" with the payload:
      """
        {"path": "/anything", "echo": "json"}
      """
    Then I should receive an HTTP 201 response
    And I make an HTTP GET request to "http://localhost:11988/anything?foo=bar"
    Then I should receive an HTTP 200 response with the JSON value "bar" for the key path "echo.params.foo"
    
  Scenario: Stubbing a request using the HTTP API in plist format
    Given that Spoofer is running and accepting remote configuration on "/api"
    When I make an HTTP POST request with a "application/plist" content-type to "http://localhost:11988/api/get" and the payload:
      """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
          <key>path</key>
          <string>/anything</string>
        </dict>
        </plist>
      """
    Then I should receive an HTTP 201 response
    And I make an HTTP GET request to "http://localhost:11988/anything"
    Then I should receive an HTTP 200 response with an empty body
    
  Scenario: Configuring multiple stubs for a single verb in a single request
    Given that Spoofer is running and accepting remote configuration on "/api"
    When I make an HTTP POST request to "http://localhost:11988/api/get" with the payload:
      """
        {"stubs":[{"path": "/anything"}, {"path": "/something"}]}
      """
    Then I should receive an HTTP 201 response
    And I make an HTTP GET request to "http://localhost:11988/anything"
    Then I should receive an HTTP 200 response with an empty body
    And I make an HTTP GET request to "http://localhost:11988/something"
    Then I should receive an HTTP 200 response with an empty body
    
  Scenario: Configuring multiple stubs for different verbs in a single request
    Given that Spoofer is running and accepting remote configuration on "/api"
    When I make an HTTP POST request to "http://localhost:11988/api/multi" with the payload:
      """
        {"stubs":[{"method": "GET", "path": "/anything"}, {"method": "POST", "path": "/something"}]}
      """
    Then I should receive an HTTP 201 response
    And I make an HTTP GET request to "http://localhost:11988/anything"
    Then I should receive an HTTP 200 response with an empty body
    And I make an HTTP POST request to "http://localhost:11988/something"
    Then I should receive an HTTP 200 response with an empty body
    
  Scenario: Clearing all stubs via the HTTP API
    Given that Spoofer is running and accepting remote configuration on "/api" with the existing stubs:
      """
        get("/anything").returning("hello world")
      """
    When I make an HTTP POST request to "http://localhost:11988/api/clear"
    And I make an HTTP GET request to "http://localhost:11988/anything"
    Then I should receive an HTTP 404 response with an empty body

  Scenario: Clearing all stubs then resetting a stub via the API
    Given that Spoofer is running and accepting remote configuration on "/api" with the existing stubs:
      """
        get("/anything").returning("hello world")
      """
    When I make an HTTP POST request to "http://localhost:11988/api/clear"
    When I make an HTTP POST request to "http://localhost:11988/api/get" with the payload:
      """
        {"path": "/anything", "body": "something else"}
      """
    And I make an HTTP GET request to "http://localhost:11988/anything"
    Then I should receive an HTTP 200 response with a body matching "something else"
    
