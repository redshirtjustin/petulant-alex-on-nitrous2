class CreateLeadlines < ActiveRecord::Migration
  def change
    create_table :leadlines do |t|
      t.string :content
      t.belongs_to :story, index: true

      t.timestamps null: false
    end
  end
end
