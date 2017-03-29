class CreateGrams < ActiveRecord::Migration[5.0]
  def change
    create_table :grams do |t|
      t.text :caption
      t.timestamps
    end
  end
end
