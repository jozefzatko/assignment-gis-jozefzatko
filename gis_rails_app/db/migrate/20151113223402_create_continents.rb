class CreateContinents < ActiveRecord::Migration
  def change
    create_table :continents do |t|

      t.text "name", limit: 30
      
      t.timestamps null: false
    end
  end
end
