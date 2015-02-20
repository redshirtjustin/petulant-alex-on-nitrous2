class CreateCitations < ActiveRecord::Migration
  def change
    create_table :citations do |t|
      t.references :cite, polymorphic: true, index: true
      t.string :title
      t.string :url

      t.timestamps null: false
    end
  end
end
