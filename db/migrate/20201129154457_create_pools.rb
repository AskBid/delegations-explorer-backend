class CreatePools < ActiveRecord::Migration[6.0]
  def change
    create_table :pools do |t|
      t.string :poolid
      t.string :hash
      t.integer :updatedIn

      t.timestamps
    end
  end
end
