class ChangeAddressToBeStringInOwners < ActiveRecord::Migration[6.0]
  def change
  	change_column :owners, :address, :string
  end
end
