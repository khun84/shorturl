class CreateUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :urls do |t|
      t.string :title
      t.bigint :user_id
      t.string :original_url, null: false
      t.timestamps
    end
  end
end
