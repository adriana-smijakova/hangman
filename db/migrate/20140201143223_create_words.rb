class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :content
      t.belongs_to :category, index: true

      t.timestamps
    end
  end
end
