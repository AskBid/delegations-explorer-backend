class ChangeHash < ActiveRecord::Migration[6.0]
  def change
    rename_column :pools, :hash, :hashid
  end
end
