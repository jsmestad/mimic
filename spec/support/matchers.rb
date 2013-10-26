RSpec::Matchers.define :match_rack_response do |code, headers, body|
  match do |actual|
    (actual[0].should == code) &&
    (actual[1].should RSpec::Matchers::BuiltIn::Include.new(headers)) #&&
    (actual[2].should RSpec::Matchers::BuiltIn::Include.new(body))
  end
end
