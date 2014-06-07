class Addindices < ActiveRecord::Migration
  def change
  	add_column :share_indices, :guid, :string
  	add_column :share_indices, :published_at, :datetime
  end
end
