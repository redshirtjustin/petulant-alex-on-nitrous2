class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :subject
      t.integer :active_headline_id
      t.integer :active_leadline_id
      t.belongs_to :section, index: true

      t.timestamps null: false
    end
  end
end
