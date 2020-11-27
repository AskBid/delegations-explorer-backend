class AddEpochnoToActiveStakes < ActiveRecord::Migration[6.0]
  def change
    add_column :active_stakes, :epochno, :integer
  end
end
