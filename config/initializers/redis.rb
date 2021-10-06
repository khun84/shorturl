$redis = if Rails.env.development? || Rails.env.test?
           Redis.new(
             host: Settings.redis.host,
             port: Settings.redis.port,
             password: Settings.redis.passw,
             ssl_params: Settings.redis.ssl
           )
         else
           Redis.new(url: ENV["REDIS_URL"], ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })
         end
