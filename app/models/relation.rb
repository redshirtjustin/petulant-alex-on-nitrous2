class Relation < ActiveRecord::Base
    belongs_to :story
    belongs_to :tie, polymorphic: true
    
    validates :story_id, :tie_id, :tie_type, presence: true
end
