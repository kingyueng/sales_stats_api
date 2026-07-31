source "https://rubygems.org"

ruby "~> 3.2"

gem "rails", "~> 8.1"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "bootsnap", require: false
gem "rack-cors"

# 分页
gem "kaminari"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "rspec-rails", "~> 7.0"
  gem "factory_bot_rails"
  gem "faker"
  gem "shoulda-matchers", "~> 8.0"
end
