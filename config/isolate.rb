# do not depend on system installed gems
options :system => false

gem "sinatra", "~> 1.3.2"

env :development do
  # lock-down eventmachine to avoid errors during compilation of version 0.12.10
  gem "eventmachine", "= 1.0.0.beta.4.1"
  gem "sinatra-contrib", "~> 1.3.1"
end
