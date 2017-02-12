class CreateServices < ActiveRecord::Migration[5.0]
  def change
    create_table :services do |t|
      t.date :date

      t.timestamps
    end
  end
end
