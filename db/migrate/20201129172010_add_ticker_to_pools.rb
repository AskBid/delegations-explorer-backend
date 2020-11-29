class AddTickerToPools < ActiveRecord::Migration[6.0]
  def change
    add_column :pools, :ticker, :string
  end
end
