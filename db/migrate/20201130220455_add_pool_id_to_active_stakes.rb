class AddPoolIdToActiveStakes < ActiveRecord::Migration[6.0]
  def change
    add_column :active_stakes, :pool_id, :integer
  end
end
