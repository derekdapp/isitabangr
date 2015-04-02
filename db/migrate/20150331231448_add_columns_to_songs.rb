class AddColumnsToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :title, :string
    add_column :songs, :artist, :string
  end
end
