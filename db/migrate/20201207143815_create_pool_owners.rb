class CreatePoolOwners < ActiveRecord::Migration[6.0]
  def change
    create_table :owners do |t|
      t.string :hash
      t.integer :pool_id

      t.timestamps
    end
  end
end
