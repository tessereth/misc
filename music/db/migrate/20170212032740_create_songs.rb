class CreateSongs < ActiveRecord::Migration[5.0]
  def change
    create_table :songs do |t|
      t.string :title
      t.references :book, foreign_key: true
      t.integer :number

      t.timestamps
    end
  end
end
