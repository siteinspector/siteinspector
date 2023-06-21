Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Convert the comma-separated domains into an array of regular expressions
    allowed_domains = (ENV['ALLOWED_HOSTS'] || '').split(',').map { |domain| /^([a-z0-9\-]*\.)*#{Regexp.quote(domain)}$/ }

    origins allowed_domains
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
end