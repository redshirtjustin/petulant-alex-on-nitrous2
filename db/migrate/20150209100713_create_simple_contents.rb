class CreateSimpleContents < ActiveRecord::Migration
  def change
    create_table :simple_contents do |t|
      t.string :topic
      t.text :content

      t.timestamps null: false
    end
  end
end
