class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :spotify

      t.timestamps null: false
    end
  end
end
