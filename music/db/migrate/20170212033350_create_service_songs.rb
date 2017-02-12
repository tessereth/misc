class CreateServiceSongs < ActiveRecord::Migration[5.0]
  def change
    create_table :service_songs do |t|
      t.integer :position
      t.references :song, foreign_key: true
      t.references :service, foreign_key: true

      t.timestamps
    end
  end
end
