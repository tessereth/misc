class CreateCongregations < ActiveRecord::Migration[5.0]
  def change
    create_table :congregations do |t|
      t.string :name

      t.timestamps
    end
  end
end
