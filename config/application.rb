require_relative "boot"

require "rails/all"
require 'rack/cors'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Backend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

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

    config.action_dispatch.default_headers = {
      "X-Content-Type-Options" => "nosniff",
      "X-Frame-Options" => "DENY",
      "X-XSS-Protection" => "1; mode=block",
    }

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'localhost:3000'
        resource '*',
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options, :head],
          credentials: true
      end
    end

    config.content_security_policy do |policy|
      policy.default_src :self
      policy.script_src :self, :unsafe_inline, "https://cdn.jsdelivr.net/npm/"
      policy.object_src :none
      policy.frame_ancestors :none
      policy.base_uri :none
      policy.form_action :self
      policy.connect_src :self
      policy.font_src :self, "https://fonts.gstatic.com"
      policy.img_src :self
      policy.manifest_src :self
      policy.media_src :self
      policy.prefetch_src :self
      policy.worker_src :self
    end

    config.middleware.use Rack::Protection, use: %i[authenticity_token cookie_tossing form_token_request remote_token_request strict_transport, content_security_policy, xss_header, xframe_options]
  end
end