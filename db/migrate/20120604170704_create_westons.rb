class CreateWestons < ActiveRecord::Migration
  def change
    create_table :westons do |t|

      t.timestamps
    end
  end
end
