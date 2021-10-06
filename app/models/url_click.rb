class UrlClick < ApplicationRecord
  include Locateable

  # @param [Hash] event
  #   @option [Time] event_time
  #   @option [String] url_hash
  #   @option [Integer] short_url_id
  #   @option [Integer] original_url_id
  def self.track(event)
    return unless event
    event_time = event[:event_time] || Time.current
    create(
      **event.slice(:url_hash, :short_url_id, :original_url_id),
      created_at: event_time, updated_at: event_time, location_details: lookup_location(event[:ip])
    )
  end
end
