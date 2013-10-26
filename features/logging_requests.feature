Feature: Logging incoming requests
  In order to check that Spoofer is working properly or provide further debug information
  As a developer
  I want to be able to tell Spoofer to log incoming requests
  
  Scenario: Logging to STDOUT
    Given I have a spoofer specification with:
      """
      Spoofer.mimic(:port => 11988, :log => $stdout).get("/some/path")
      """
    When I make an HTTP GET request to "http://localhost:11988/some/path"
    Then I should see "GET /some/path HTTP/1.1" written to STDOUT
    
