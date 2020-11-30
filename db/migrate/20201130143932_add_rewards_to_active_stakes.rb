class AddRewardsToActiveStakes < ActiveRecord::Migration[6.0]
  def change
    add_column :active_stakes, :rewards, :string
  end
end
