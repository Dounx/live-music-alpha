class AddOnlineCounterToRooms < ActiveRecord::Migration[6.0]
  def change
    add_column :rooms, :user_counter, :integer, default: 0
  end
end
