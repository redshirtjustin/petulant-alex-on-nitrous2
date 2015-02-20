class Assignment < ActiveRecord::Base
    belongs_to :story
    belongs_to :author
    
    enum flag: [ :pending, :awaiting_review, :completed, :retired ]
    
    scope :live, -> { where(flag: :completed)} 
end