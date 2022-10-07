require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RubyK04
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Set default locale to something other than :en
    # I18n.default_locale = :ja

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Asia/Ho_Chi_Minh"
    # config.eager_load_paths << Rails.root.join("extras")
    config.autoload_paths << config.root.join('lib')
    config.autoload_paths << config.root.join('lib/concerns')
  end
end
