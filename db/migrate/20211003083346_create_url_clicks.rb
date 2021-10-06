class CreateUrlClicks < ActiveRecord::Migration[5.2]
  def change
    create_table :url_clicks do |t|
      t.string :url_hash
      t.bigint :short_url_id
      t.bigint :original_url_id
      t.timestamps
    end
  end
end
