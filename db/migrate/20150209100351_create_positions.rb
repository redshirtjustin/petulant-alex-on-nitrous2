class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.belongs_to :story, index: true
      t.references :element, polymorphic: true, index: true
      t.integer :position
      t.boolean :active

      t.timestamps null: false
    end
  end
end
