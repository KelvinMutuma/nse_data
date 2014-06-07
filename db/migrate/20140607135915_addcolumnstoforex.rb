class Addcolumnstoforex < ActiveRecord::Migration
  def change
  	add_column :forexes, :guid, :string
  	add_column :forexes, :published_at, :datetime
  end
end
