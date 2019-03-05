require 'zci/version.rb'

require 'zendesk_api'
require 'zendesk_api/help_center'

require 'crowdin-api'
require 'nokogiri'
require 'zip'
require 'pry'

# Add requires for other files you add to your project here, so
# you just need to require this one file in your bin file
require_relative 'zci/helpers'
require_relative 'zci/init'
require_relative 'zci/import'
require_relative 'zci/download'
require_relative 'zci/export'
require_relative 'zci/clean'
