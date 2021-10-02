class CreateShortUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :short_urls do |t|
      t.bigint :url_id
      t.string :url_hash
      t.timestamps
    end
  end
end
