class CreateAuthors < ActiveRecord::Migration
  def change
        create_table :authors do |t|
            t.string :fname
            t.string :lname
            t.integer :role
            t.string :email
            t.string :password_digest

        t.timestamps
    end
  end
end
