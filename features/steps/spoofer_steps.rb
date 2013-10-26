Given /^I have a spoofer specification with:$/ do |string|
  SpooferRunner.new.evaluate(string)
end

Given /^that Spoofer is running and accepting remote configuration on "([^\"]*)"$/ do |api_endpoint|
  Spoofer.mimic(:port => 11988, :remote_configuration_path => api_endpoint)
end

Given /^that Spoofer is running and accepting remote configuration on "([^\"]*)" with the existing stubs:$/ do |api_endpoint, existing_stubs|
  Spoofer.mimic(:port => 11988, :remote_configuration_path => api_endpoint) do
    eval(existing_stubs)
  end
end

When /^I evaluate the code:$/ do |string|
  eval(string)
end

After do
  Spoofer.cleanup!
end
