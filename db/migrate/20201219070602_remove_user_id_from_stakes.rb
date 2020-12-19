class RemoveUserIdFromStakes < ActiveRecord::Migration[6.0]
  def change
    remove_column :stakes, :user_id, :integer
  end
end
