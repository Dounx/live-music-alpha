class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.string :type, null: false
      t.text :data, null: false
      t.integer :from, null: false
      t.integer :to, null: false
      t.timestamps
    end
  end
end
