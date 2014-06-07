class Addcolumnstomarket < ActiveRecord::Migration
  def change
  	  	add_column :markets, :guid, :string
  	add_column :markets, :published_at, :datetime
  end
end
