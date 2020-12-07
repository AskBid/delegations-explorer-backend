class CreatePoolOwners < ActiveRecord::Migration[6.0]
  def change
    create_table :pool_owners do |t|
      t.string :hashid
      t.integer :pool_id

      t.timestamps
    end
  end
end
