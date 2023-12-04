require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module QuizachuApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    ## SETTING UP LINK TO ENV FILE
    env_file = File.join(Rails.root, 'config', 'local_env.yml')
    if File.exists?(env_file)
        YAML.load(File.open(env_file)).each do |environment, variable_hash|
          if Rails.env == environment
            variable_hash.each do |key,value|
              ENV[key.to_s] = value
            end
          end
        end
    end
  end
end
