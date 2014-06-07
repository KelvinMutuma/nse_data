class Addcolumnstobank < ActiveRecord::Migration
  def change
  	add_column :banks, :guid, :string
  	add_column :banks, :published_at, :datetime
  end
end
