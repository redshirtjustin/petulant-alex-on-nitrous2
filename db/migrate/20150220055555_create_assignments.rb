class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.belongs_to :story, index: true
      t.belongs_to :author, index: true
      t.integer :flag

      t.timestamps
    end
  end
end
