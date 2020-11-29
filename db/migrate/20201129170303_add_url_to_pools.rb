class AddUrlToPools < ActiveRecord::Migration[6.0]
  def change
    add_column :pools, :url, :string
  end
end
