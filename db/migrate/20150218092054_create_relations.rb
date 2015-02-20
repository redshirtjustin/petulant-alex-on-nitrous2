class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
        t.belongs_to :story, index: true
        t.references :tie, polymorphic: true, index: true
        t.string :heading, default: "Further reading:"

      t.timestamps
    end
  end
end
