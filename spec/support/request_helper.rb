def request_for(path, options={})
  options = {:method => "GET"}.merge(options)
  { "PATH_INFO"      => path,
    "REQUEST_METHOD" => options[:method],
    "rack.errors"    => StringIO.new,
    "rack.input"     => StringIO.new }
end
