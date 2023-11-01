Clearance.configure do |config|
  config.routes = false
  config.mailer_sender = "noreply@remark.social"
  config.cookie_domain = Rails.env.development? ? "localhost" : ".remark.social"
  config.rotate_csrf_on_sign_in = true
  config.secure_cookie = Rails.env.production?
  config.httponly = true
  config.redirect_url = "/feed"
end
