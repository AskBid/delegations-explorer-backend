class CreateActiveStakes < ActiveRecord::Migration[6.0]
  def change
    create_table :active_stakes do |t|
      t.string :address
      t.integer :amount

      t.timestamps
    end
  end
end
