require 'rails_helper'

RSpec.describe Relation, type: :model do
    
    context "/ validation /" do
        it "is valid if there is a story_id, tie_id, tie_type" do
            first_story = Story.create!(subject: Faker::Lorem.sentence, section_id: 1)
            second_story = Story.create!(subject: Faker::Lorem.sentence, section_id: 1)
#             tie = Relation.new(story_id:)
        end
    end
  
end
