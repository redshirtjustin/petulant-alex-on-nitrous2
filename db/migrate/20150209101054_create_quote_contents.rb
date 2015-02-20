class CreateQuoteContents < ActiveRecord::Migration
  def change
    create_table :quote_contents do |t|
      t.string :topic
      t.text :quote
      t.string :quotee_name
      t.string :quotee_title
      t.text :content

      t.timestamps null: false
    end
  end
end
