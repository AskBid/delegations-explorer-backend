class ChangeOwnersToPoolRewardAddresses < ActiveRecord::Migration[6.0]
  def change
  	rename_table :owners, :pool_reward_addresses
  end
end
