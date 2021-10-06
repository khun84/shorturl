class AddLocationDetailToUrlClick < ActiveRecord::Migration[5.2]
  def up
    return if column_exists? :url_clicks, :location_details
    add_column :url_clicks, :location_details, :jsonb
    UrlClick.update_all(location_details: {}, updated_at: Time.current)
    change_column_default :url_clicks, :location_details, '{}'
  end

  def down
    remove_column :url_clicks, :location_details if column_exists? :url_clicks, :location_details
  end
end
