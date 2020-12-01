class RemoveAddressFromActiveStake < ActiveRecord::Migration[6.0]
  def change
    remove_column :active_stakes, :address, :string
  end
end
