require_relative './redis'

Geocoder.configure(
  # IP address geocoding service (default :ipinfo_io)
  # ip_lookup: :maxmind,

  # to use an API key:
  api_key: Settings.geocoding.ipinfo.api_key,

  # geocoding service request timeout, in seconds (default 3):
  # timeout: 5,

  # set default units to kilometers:
  units: :km,

  # caching (see Caching section below for details):
  cache: $redis,
  logger: Rails.logger
)
