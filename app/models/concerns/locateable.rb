module Locateable
  extend ActiveSupport::Concern

  LOCATION_ATTRIBUTES = %w[address
                          latitude
                          longitude
                          state
                          province
                          state_code
                          province_code
                          country
                          country_code]
  class Location < Struct.new(*LOCATION_ATTRIBUTES.map(&:to_sym)); end

  class_methods do
    # @param [String] ip
    # @return [Hash{String=>Object}]
    def lookup_location(ip)
      return {} unless ip
      provider = Geocoder.config.ip_lookup
      if (res = Geocoder.search(ip, ip_lookup: provider).first)
        data = LOCATION_ATTRIBUTES.each_with_object({}) do |attr, memo|
          memo[attr] = res.send(attr)
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
