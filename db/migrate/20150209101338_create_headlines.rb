class CreateHeadlines < ActiveRecord::Migration
  def change
    create_table :headlines do |t|
      t.string :content
      t.belongs_to :story, index: true

      t.timestamps null: false
    end
  end
end
