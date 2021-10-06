module Locateable
  extend ActiveSupport::Concern

  LOCATION_ATTRIBUTES = %w[ip
                          address
                          latitude
                          longitude
                          state
                          province
                          state_code
                          province_code
                          country
                          country_code]
  class Location < Struct.new(*LOCATION_ATTRIBUTES.map(&:to_sym))
    def self.build(args = {})
      args.present? ? new(args.values_at(*LOCATION_ATTRIBUTES)) : new
    end
  end

  class_methods do
    # @param [String] ip
    # @return [Hash{String=>Object}]
    def lookup_location(ip)
      return {} unless ip
      if (res = Geocoder.search(ip, ip_lookup: Geocoder.config.ip_lookup).first)
        data = LOCATION_ATTRIBUTES.each_with_object({}) do |attr, memo|
          memo[attr] = res.send(attr) if res.respond_to? attr
        end
        data["ip"] = ip
        {
          "data" => data,
          "provider" => provider&.to_s
        }
      else
        {}
      end
    end
  end
end
