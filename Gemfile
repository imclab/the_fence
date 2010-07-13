source 'http://rubygems.org'

gem 'rails', "3.0.0.beta4"

gem "mongoid", "2.0.0.beta9"
gem "bson_ext"

gem "haml"
gem "rails3-generators"

gem "devise", "1.1.rc2"

gem "rmagick"
gem "carrierwave", :git => 'http://github.com/jnicklas/carrierwave.git'

gem "formtastic", :git => 'http://github.com/justinfrench/formtastic.git',
                  :branch => 'rails3'

gem "cancan"

gem "right-rails"

group :test do
  gem 'rspec', "2.0.0.beta.15"
	gem 'rspec-rails', "2.0.0.beta.15"
	gem 'webrat'

  gem 'capybara'
  gem 'cucumber-rails'
  gem 'cucumber', '0.8.3'
  gem 'spork'
  gem 'launchy'

  gem 'factory_girl_rails', "1.0.0"
                    
	gem 'autotest'
	gem 'autotest-fsevent' if RUBY_PLATFORM =~ /darwin/
	gem 'autotest-growl' if RUBY_PLATFORM =~ /darwin/
end