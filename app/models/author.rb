class Author < ActiveRecord::Base
    has_many :assignments
    has_many :stories, through: :assignments
    
    has_secure_password
    
    enum role: [ :author, :editor ]
end
