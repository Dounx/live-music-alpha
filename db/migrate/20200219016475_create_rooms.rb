class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms do |t|
      t.string :url, null: false
      t.string :token, index: true, null: false, unique: true
      t.text :playlist
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
