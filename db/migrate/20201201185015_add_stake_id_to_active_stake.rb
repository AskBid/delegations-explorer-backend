class AddStakeIdToActiveStake < ActiveRecord::Migration[6.0]
  def change
    add_column :active_stakes, :stake_id, :integer
  end
end
