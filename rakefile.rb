begin
  require "isolate/now"
rescue LoadError
  abort "This project requires Isolate to work. Please `gem install isolate` and try again."
end
