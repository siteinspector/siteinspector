class CustomCookieDomain
  def initialize(app, session_key)
    @app = app
    @session_key = session_key
  end

  def call(env)
    host = env["HTTP_HOST"].split(':').first
    custom_domain_name = find_custom_domain(host)

    # Explicitly set the domain attribute in the session cookie
    if custom_domain_name
      env['rack.session.options'] ||= {}
      env['rack.session.options'][:domain] = custom_domain_name
    end

    @app.call(env)
  end

  private

  def find_custom_domain(host)
    allowed_domains = (ENV['ALLOWED_HOSTS'] || '').split(',')
    allowed_domains.find { |domain| host.end_with?(domain) }
  end
end

session_key = '_site_inspector_session'
Rails.application.config.middleware.insert_before(
  ActionDispatch::Cookies,
  CustomCookieDomain,
  session_key
)