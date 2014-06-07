class Addition < ActiveRecord::Migration
  def change
   	add_column :changers, :guid, :string
  	add_column :changers, :published_at, :datetime
  	add_column :movers, :guid, :string
  	add_column :movers, :published_at, :datetime
  end
end
