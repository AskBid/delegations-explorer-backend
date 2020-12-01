class CreateStakes < ActiveRecord::Migration[6.0]
  def change
    create_table :stakes do |t|
      t.string :address
      t.integer :user_id

      t.timestamps
    end
  end
end
