class AddCongregationToServices < ActiveRecord::Migration[5.0]
  def change
    add_reference :services, :congregation, foreign_key: true
  end
end
