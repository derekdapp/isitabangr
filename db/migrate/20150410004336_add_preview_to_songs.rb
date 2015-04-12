class AddPreviewToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :preview, :text
  end
end
