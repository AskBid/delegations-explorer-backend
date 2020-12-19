class CreateUserStakes < ActiveRecord::Migration[6.0]
  def change
    create_table :user_stakes do |t|
      t.integer :user_id
      t.integer :stake_id

      t.timestamps
    end
  end
end
