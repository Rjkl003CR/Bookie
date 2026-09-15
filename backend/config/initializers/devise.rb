Devise.setup do |config|
  config.jwt do |jwt|
    jwt.secret = Rails.application.credentials.jwt_secret || ENV["JWT_SECRET"]
    jwt.dispatch_requests = [["POST", %r{^/api/v1/login$}]]
    jwt.revocation_requests = [["DELETE", %r{^/api/v1/logout$}]]
    jwt.expiration_time = 1.day.to_i
  end
end
