class ChangeAmountDataTypeToActiveStakes < ActiveRecord::Migration[6.0]
  def up
  	change_column :active_stakes, :amount, :string
	end

	def down
	  change_column :active_stakes, :amount, :integer
	end
end
